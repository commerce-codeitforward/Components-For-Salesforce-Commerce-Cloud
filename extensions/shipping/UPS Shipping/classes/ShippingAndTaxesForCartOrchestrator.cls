/**
* @description This is a sample orchestrator that calls the inventory, pricing, promotions, shipping and tax calculators.
* This class must extend CartExtension.CartCalculate and must be linked to the orchestrator extension point (Commerce_Domain_Cart_Calculate).
* Calculates pricing, promotions, shipping and taxes for operations: Add to cart, remove from cart, edit cart item.
* Calculates promotions and taxes for operations: add coupon, remove coupon.
* Calculates pricing, promotions, inventory for start checkout operation (without shipping address available).
* Calculates pricing, promotions, inventory, shipping, post shipping and taxes for start checkout operation (with shipping address available).
* Calculates shipping, post shipping and taxes for update shipping address operation.
* Calculates taxes for select delivery method operation.
*/
global class ShippingAndTaxesForCartOrchestrator extends CartExtension.CartCalculate {

    /**
     * @description All classes extending CartExtension.CartCalculate must have a default constructor defined
     */
    global ShippingAndTaxesForCartOrchestrator() {}

    /**
     * @description Constructor used by unit tests only. See <<CartCalculateSampleUnitTest>>.
     * @param apexExecutor Executor which executes various calculators. Can be used to stub calculation results or delegate calculations to actual Calculator. See <<CartCalculateExecutorMock>>.
     */
    global ShippingAndTaxesForCartOrchestrator(final CartExtension.CartCalculateExecutorMock apexExecutor) {
        // Must call super constructor in order for provided Executor to be used for calculations
        super(apexExecutor);
    }

    // Each orchestrator must override this calculate method.
    global virtual override void calculate(CartExtension.CartCalculateOrchestratorRequest request) {
        CartExtension.Cart cart = request.getCart();

        // Use BuyerActions to decide which calculators to invoke
        CartExtension.BuyerActions buyerActions = request.getBuyerActions();
        boolean runPricing = buyerActions.isCartItemChanged() || buyerActions.isCheckoutStarted();
        boolean runPromotions = buyerActions.isCheckoutStarted() || buyerActions.isCouponChanged() || buyerActions.isCartItemChanged();
        boolean runInventory = buyerActions.isCheckoutStarted();
        boolean runShipping = buyerActions.isCartItemChanged() || buyerActions.isDeliveryGroupChanged();
        boolean runPostShipping = buyerActions.isCartItemChanged() || buyerActions.isDeliveryGroupChanged() || buyerActions.isDeliveryMethodSelected();
        boolean runTaxes = buyerActions.isCartItemChanged() || buyerActions.isCouponChanged() || buyerActions.isDeliveryGroupChanged() || buyerActions.isDeliveryMethodSelected();

        // OptionalBuyerActionDetails can be used to optimize the various calculators that are invoked
        CartExtension.CartCalculateCalculatorRequest calculatorRequest = new CartExtension.CartCalculateCalculatorRequest(cart, request.getOptionalBuyerActionDetails());

        if (runPricing) {
            prices(calculatorRequest);

            if (hasErrorLevelCartValidationOutput(cart.getCartValidationOutputs(), CartExtension.CartValidationOutputTypeEnum.PRICING)) {
                return;
            }
        }

        if (runPromotions) {
            promotions(calculatorRequest);

            if (hasErrorLevelCartValidationOutput(cart.getCartValidationOutputs(), CartExtension.CartValidationOutputTypeEnum.PROMOTIONS)) {
                return;
            }
        }

        if (runInventory) {
            inventory(calculatorRequest);

            if (hasErrorLevelCartValidationOutput(cart.getCartValidationOutputs(), CartExtension.CartValidationOutputTypeEnum.INVENTORY)) {
                return;
            }
        }

        if (runShipping) {
            shipping(calculatorRequest);

            if (hasErrorLevelCartValidationOutput(cart.getCartValidationOutputs(), CartExtension.CartValidationOutputTypeEnum.SHIPPING)) {
                return;
            }
        }

        if (runPostShipping) {
            selectCheapestDeliveryMethodAndCreateShippingCharge(calculatorRequest);
        }

        if (runTaxes) {
            taxes(calculatorRequest);
        }
    }

    // This function evaluates whether there are errors in the CVO of a specific calculator type.
    private Boolean hasErrorLevelCartValidationOutput(CartExtension.CartValidationOutputList cartValidationOutputs,
                                                      CartExtension.CartValidationOutputTypeEnum cartValidationOutputType) {
        Iterator<CartExtension.CartValidationOutput> iterator = cartValidationOutputs.iterator();

        while (iterator.hasNext()) {
            CartExtension.CartValidationOutput cvo = iterator.next();

            Boolean cvoContainsCalculatorError = cvo.getType() == cartValidationOutputType
                    && cvo.getLevel() == CartExtension.CartValidationOutputLevelEnum.ERROR;

            if (cvoContainsCalculatorError) {
                return true;
            }
        }

        return false;
    }

    /*
    * @description Alternative to the default post shipping but can operate on Delivery Groups without shipping Address.
    * Clears existing selected delivery method and shipping charges and reapplies them using new recalculated shipping options provided by shipping calculator.
    */
    private void selectCheapestDeliveryMethodAndCreateShippingCharge(CartExtension.CartCalculateCalculatorRequest request) {
        CartExtension.Cart cart = request.getCart();
        Iterator<CartExtension.CartDeliveryGroup> cdgIterator = cart.getCartDeliveryGroups().iterator();

        while (cdgIterator.hasNext()) {
            // clear existing selected delivery method
        	CartExtension.CartDeliveryGroup cartDeliveryGroup = cdgIterator.next();
        	cartDeliveryGroup.setSelectedCartDeliveryGroupMethod(Null);

            // clear existing charges
            CartExtension.CartItemList cartItems = cart.getCartItems();
            for (Integer i = (cartItems.size() - 1); i >= 0; i--) {
                CartExtension.CartItem cartItem = cartItems.get(i);
                cart.setName(cart.getName() + cartItem.getType());
                if (cartDeliveryGroup.getId() == cartItem.getCartDeliveryGroup().getId() &&
                            cartItem.getType().name() == CartExtension.SalesItemTypeEnum.CHARGE.name()) {
                    cartItems.remove(cartItem);
                }
            }

        	Iterator<CartExtension.CartDeliveryGroupMethod> cdgmIterator = cartDeliveryGroup.getCartDeliveryGroupMethods().iterator();
        	Decimal minShippingFee = Null;
        	CartExtension.CartDeliveryGroupMethod cheapestDeliveryMethod = Null;
        	while (cdgmIterator.hasNext()) {
        	    CartExtension.CartDeliveryGroupMethod cartDeliveryGroupMethod = cdgmIterator.next();
        	    if (minShippingFee == Null) {
        	        minShippingFee = cartDeliveryGroupMethod.getShippingFee();
        	        cheapestDeliveryMethod = cartDeliveryGroupMethod;
        	        continue;
        	    }
        	    if (cartDeliveryGroupMethod.getShippingFee() < minShippingFee) {
        	        minShippingFee = cartDeliveryGroupMethod.getShippingFee();
                    cheapestDeliveryMethod = cartDeliveryGroupMethod;
        	    }
        	}
        	if (cheapestDeliveryMethod != Null) {
        	    // Update selected delivery method
        	    cartDeliveryGroup.setSelectedCartDeliveryGroupMethod(cheapestDeliveryMethod);
        	    String shippingProduct = cheapestDeliveryMethod.getProductId();
        	    Decimal shippingFee = cheapestDeliveryMethod.getShippingFee();

                // Create shipping charge
        	    CartExtension.CartItem shippingCharge = new CartExtension.CartItem(CartExtension.SalesItemTypeEnum.CHARGE, cartDeliveryGroup, 'Shipping Fee');
        	    shippingCharge.setProduct2Id(shippingProduct);
        	    shippingCharge.setQuantity(1);
        	    shippingCharge.setTotalPrice(shippingFee);
                shippingCharge.setListPrice(shippingFee);
                shippingCharge.setSalesPrice(shippingFee);
                shippingCharge.setTotalListPrice(shippingFee);
                cart.getCartItems().add(shippingCharge);
        	}
        }
    }
}