@isTest
global class CartCalculationOrchestratorExtensionTest{
  private static final String CART_REPRICED = 'CartRepriced';
  private static final String PROMOTIONS_RECALCULATED = 'PromotionsRecalculated';
  private static final String INVENTORY_CHECKED = 'InventoryChecked';
  private static final String SHIPPING_RECALCULATED = 'ShippingRecalculated';
  private static final String TAXES_RECALCULATED = 'TaxesRecalculated';
  private static final String POST_SHIPPING_COMPLETED = 'PostShippingCompleted';

  static CartCalculateExecutorForUnitTest executor = new CartCalculateExecutorForUnitTest();
  static CartCalculationOrchestratorExtension cartCalculateSample = new CartCalculationOrchestratorExtension(
    executor
  );
    @isTest
    private static void calculateTest(){
      CartExtension.Cart cart = arrangeCart();
      CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForAddToCart(cart);
      CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForAddToCart(cart.getCartItems().get(0));
      CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(buyerActionDetails); 
      CartExtension.CartCalculateCalculatorRequest calculatorRequest = new CartExtension.CartCalculateCalculatorRequest(cart, CartExtension.OptionalBuyerActionDetails.empty());
      CartExtension.CartCalculateOrchestratorRequest request =  new CartExtension.CartCalculateOrchestratorRequest(cart, buyerActions, optionalBuyerActionDetails); 
      CartExtension.BuyerActions byrAction= request.getBuyerActions();
      boolean runPricing =byrAction.isCheckoutStarted() || byrAction.isCartItemChanged();
      boolean runPromotions = byrAction.isCheckoutStarted() ||byrAction.isCouponChanged() ||byrAction.isCartItemChanged();
      boolean runInventory = byrAction.isCheckoutStarted();
      boolean runShipping = byrAction.isDeliveryGroupChanged();
      boolean runPostShipping =byrAction.isDeliveryGroupChanged() ||byrAction.isDeliveryMethodSelected();
      boolean runTaxes = byrAction.isDeliveryGroupChanged() ||byrAction.isDeliveryMethodSelected();  
      Test.startTest();
      CartCalculationOrchestratorExtension extension  = new CartCalculationOrchestratorExtension();
      extension.calculate(request);
      Test.stopTest();
    }
  @IsTest
  public static void shouldRunPricingAndPromotionsWhenBuyerAddsToCart() {
    // Arrange Cart
    CartExtension.Cart cart = arrangeCart();

    // Arrange BuyerActions and BuyerActionDetails as if the Buyer has added an item to cart
    CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForAddToCart(
      cart
    );
    CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForAddToCart(
      cart.getCartItems().get(0)
    );
    CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(
      buyerActionDetails
    );

    // Act
    act(
      new CartExtension.CartCalculateOrchestratorRequest(
        cart,
        buyerActions,
        optionalBuyerActionDetails
      )
    );

    // Assert
    assertNoCartValidationOutputs(cart);
    assertExpectedCalculations(
      cart,
      new List<String>{ CART_REPRICED, PROMOTIONS_RECALCULATED }
    );
    assertUnexpectedCalculations(
      cart,
      new List<String>{
        INVENTORY_CHECKED,
        SHIPPING_RECALCULATED,
        TAXES_RECALCULATED,
        POST_SHIPPING_COMPLETED
      }
    );
  }

  @IsTest
  public static void shouldRunPricingAndPromotionsWhenBuyerRemovesItemToCart() {
    // Arrange Cart
    CartExtension.Cart cart = arrangeCart();

    // Arrange BuyerActions and BuyerActionDetails as if the Buyer has added an item to cart
    CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForDeleteFromCart(
      cart
    );
    CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForDeleteFromCart();
    CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(
      buyerActionDetails
    );

    // Act
    act(
      new CartExtension.CartCalculateOrchestratorRequest(
        cart,
        buyerActions,
        optionalBuyerActionDetails
      )
    );

    // Assert
    assertNoCartValidationOutputs(cart);
    assertExpectedCalculations(
      cart,
      new List<String>{ CART_REPRICED, PROMOTIONS_RECALCULATED }
    );
    assertUnexpectedCalculations(
      cart,
      new List<String>{
        INVENTORY_CHECKED,
        SHIPPING_RECALCULATED,
        TAXES_RECALCULATED,
        POST_SHIPPING_COMPLETED
      }
    );
  }

  @IsTest
  public static void shouldRunPricingAndPromotionsWhenBuyerIncreasesQuantityOfItem() {
    // Arrange Cart
    CartExtension.Cart cart = arrangeCart();

    // Arrange BuyerActions and BuyerActionDetails as if the Buyer has added an item to cart
    CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForQuantityIncrease(
      cart
    );
    CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForQuantityIncrease(
      cart.getCartItems().get(0)
    );
    CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(
      buyerActionDetails
    );

    // Act
    act(
      new CartExtension.CartCalculateOrchestratorRequest(
        cart,
        buyerActions,
        optionalBuyerActionDetails
      )
    );

    // Assert
    assertNoCartValidationOutputs(cart);
    assertExpectedCalculations(
      cart,
      new List<String>{ CART_REPRICED, PROMOTIONS_RECALCULATED }
    );
    assertUnexpectedCalculations(
      cart,
      new List<String>{
        INVENTORY_CHECKED,
        SHIPPING_RECALCULATED,
        TAXES_RECALCULATED,
        POST_SHIPPING_COMPLETED
      }
    );
  }

  @IsTest
  public static void shouldRunPricingAndPromotionsWhenBuyerDecreasesQuantityOfItem() {
    // Arrange Cart
    CartExtension.Cart cart = arrangeCart();

    // Arrange BuyerActions and BuyerActionDetails as if the Buyer has added an item to cart
    CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForQuantityDecrease(
      cart
    );
    CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForQuantityDecrease(
      cart.getCartItems().get(0)
    );
    CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(
      buyerActionDetails
    );

    // Act
    act(
      new CartExtension.CartCalculateOrchestratorRequest(
        cart,
        buyerActions,
        optionalBuyerActionDetails
      )
    );

    // Assert
    assertNoCartValidationOutputs(cart);
    assertExpectedCalculations(
      cart,
      new List<String>{ CART_REPRICED, PROMOTIONS_RECALCULATED }
    );
    assertUnexpectedCalculations(
      cart,
      new List<String>{
        INVENTORY_CHECKED,
        SHIPPING_RECALCULATED,
        TAXES_RECALCULATED,
        POST_SHIPPING_COMPLETED
      }
    );
  }

  @IsTest
  public static void shouldRunPromotionsWhenBuyerAddsCoupon() {
    // Arrange Cart
    CartExtension.Cart cart = arrangeCart();

    // Arrange BuyerActions and BuyerActionDetails as if the Buyer added a coupon
    CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForApplyCoupon(
      cart
    );
    CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForApplyCoupon(
      cart.getCartAdjustmentBases().get(0)
    );
    CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(
      buyerActionDetails
    );

    // Act
    act(
      new CartExtension.CartCalculateOrchestratorRequest(
        cart,
        buyerActions,
        optionalBuyerActionDetails
      )
    );

    // Assert
    assertNoCartValidationOutputs(cart);
    assertExpectedCalculations(
      cart,
      new List<String>{ PROMOTIONS_RECALCULATED }
    );
    assertUnexpectedCalculations(
      cart,
      new List<String>{
        CART_REPRICED,
        INVENTORY_CHECKED,
        SHIPPING_RECALCULATED,
        POST_SHIPPING_COMPLETED,
        TAXES_RECALCULATED
      }
    );
  }

  @IsTest
  public static void shouldRunPromotionsWhenBuyerRemovesCoupon() {
    // Arrange Cart
    CartExtension.Cart cart = arrangeCart();

    // Arrange BuyerActions and BuyerActionDetails as if the Buyer added a coupon
    CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForDeleteCoupon(
      cart
    );
    CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForDeleteCoupon();
    CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(
      buyerActionDetails
    );

    // Act
    act(
      new CartExtension.CartCalculateOrchestratorRequest(
        cart,
        buyerActions,
        optionalBuyerActionDetails
      )
    );

    // Assert
    assertNoCartValidationOutputs(cart);
    assertExpectedCalculations(
      cart,
      new List<String>{ PROMOTIONS_RECALCULATED }
    );
    assertUnexpectedCalculations(
      cart,
      new List<String>{
        CART_REPRICED,
        INVENTORY_CHECKED,
        SHIPPING_RECALCULATED,
        POST_SHIPPING_COMPLETED,
        TAXES_RECALCULATED
      }
    );
  }

  @IsTest
  public static void shouldRunPricingPromotionsAndInventoryWhenBuyerStartsCheckout() {
    // Arrange Cart
    CartExtension.Cart cart = arrangeCart();

    // Arrange BuyerActions and BuyerActionDetails as if the Buyer has started Checkout
    CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForStartCheckout(
      cart
    );
    CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForStartCheckout();
    CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(
      buyerActionDetails
    );

    // Act
    act(
      new CartExtension.CartCalculateOrchestratorRequest(
        cart,
        buyerActions,
        optionalBuyerActionDetails
      )
    );

    // Assert
    assertNoCartValidationOutputs(cart);
    assertExpectedCalculations(
      cart,
      new List<String>{
        CART_REPRICED,
        PROMOTIONS_RECALCULATED,
        INVENTORY_CHECKED
      }
    );
    assertUnexpectedCalculations(
      cart,
      new List<String>{
        SHIPPING_RECALCULATED,
        TAXES_RECALCULATED,
        POST_SHIPPING_COMPLETED
      }
    );
  }

  @IsTest
  public static void shouldRunPricingPromotionsInventoryShippingTaxesWhenRegisteredBuyerStartsCheckoutGivenShippingAddressAvailable() {
    // Arrange Cart
    CartExtension.Cart cart = arrangeCart();

    // Arrange BuyerActions and BuyerActionDetails as if the Buyer has started Checkout
    CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForStartCheckoutForBuyerWithShippingAddress(
      cart
    );
    CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForStartCheckoutForBuyerWithShippingAddress(
      cart.getCartDeliveryGroups().get(0)
    );
    CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(
      buyerActionDetails
    );

    // Act
    act(
      new CartExtension.CartCalculateOrchestratorRequest(
        cart,
        buyerActions,
        optionalBuyerActionDetails
      )
    );

    // Assert
    assertNoCartValidationOutputs(cart);
    assertExpectedCalculations(
      cart,
      new List<String>{
        CART_REPRICED,
        PROMOTIONS_RECALCULATED,
        INVENTORY_CHECKED,
        SHIPPING_RECALCULATED,
        TAXES_RECALCULATED,
        POST_SHIPPING_COMPLETED
      }
    );
  }

  @IsTest
  public static void shouldRunShippingTaxesAndPostShippingWhenBuyerUpdatesShippingAddress() {
    // Arrange Cart
    CartExtension.Cart cart = arrangeCart();

    // Arrange BuyerActions and BuyerActionDetails as if the Buyer has updated their shipping address
    CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForUpdateCheckoutWithShippingAddress(
      cart
    );
    CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForUpdateCheckoutWithShippingAddress(
      cart.getCartDeliveryGroups().get(0)
    );
    CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(
      buyerActionDetails
    );

    // Act
    act(
      new CartExtension.CartCalculateOrchestratorRequest(
        cart,
        buyerActions,
        optionalBuyerActionDetails
      )
    );

    // Assert
    assertNoCartValidationOutputs(cart);
    assertExpectedCalculations(
      cart,
      new List<String>{
        SHIPPING_RECALCULATED,
        TAXES_RECALCULATED,
        POST_SHIPPING_COMPLETED
      }
    );
    assertUnexpectedCalculations(
      cart,
      new List<String>{
        CART_REPRICED,
        PROMOTIONS_RECALCULATED,
        INVENTORY_CHECKED
      }
    );
  }

  @IsTest
  public static void shouldRunPostShippingAndTaxesWhenBuyerSelectsDeliveryMethod() {
    // Arrange Cart
    CartExtension.Cart cart = arrangeCart();

    // Arrange BuyerActions and BuyerActionDetails as if the Buyer selected a delivery method
    CartExtension.BuyerActionsMock buyerActions = getBuyerActionsForUpdateCheckoutWithSelectedDeliveryMethod(
      cart
    );
    CartExtension.BuyerActionDetails buyerActionDetails = getBuyerActionDetailsForUpdateCheckoutWithSelectedDeliveryMethod(
      cart.getCartDeliveryGroups().get(0)
    );
    CartExtension.OptionalBuyerActionDetails optionalBuyerActionDetails = CartExtension.OptionalBuyerActionDetails.of(
      buyerActionDetails
    );

    // Act
    act(
      new CartExtension.CartCalculateOrchestratorRequest(
        cart,
        buyerActions,
        optionalBuyerActionDetails
      )
    );

    // Assert
    assertNoCartValidationOutputs(cart);
    assertExpectedCalculations(
      cart,
      new List<String>{ TAXES_RECALCULATED, POST_SHIPPING_COMPLETED }
    );
    assertUnexpectedCalculations(
      cart,
      new List<String>{
        CART_REPRICED,
        PROMOTIONS_RECALCULATED,
        INVENTORY_CHECKED,
        SHIPPING_RECALCULATED
      }
    );
  }

  private static CartExtension.Cart arrangeCart() {
    Account testAccount = new Account(Name = 'My Account');
    insert testAccount;

    WebStore testWebStore = new WebStore(Name = 'My WebStore');
    insert testWebStore;

    WebCart testCart = new WebCart(
      Name = 'My Cart',
      WebStoreId = testWebStore.Id,
      AccountId = testAccount.Id
    );
    insert testCart;

    CartDeliveryGroup testDeliveryGroup = new CartDeliveryGroup(
      Name = 'My Delivery Group',
      CartId = testCart.Id
    );
    insert testDeliveryGroup;

    CartItem testCartItem = new CartItem(
      Name = 'My Cart Item',
      CartId = testCart.Id,
      CartDeliveryGroupId = testDeliveryGroup.Id
    );
    insert testCartItem;

    WebCartAdjustmentBasis testCartAdjustmentBasis = new WebCartAdjustmentBasis(
      Name = 'My Coupon',
      WebCartId = testCart.Id
    );
    insert testCartAdjustmentBasis;

    return CartExtension.CartTestUtil.getCart(testCart.Id);
  }

  private static void act(
    CartExtension.CartCalculateOrchestratorRequest request
  ) {
    Test.startTest();
    cartCalculateSample.calculate(request);
    Test.stopTest();
  }

  private static void assertNoCartValidationOutputs(CartExtension.Cart cart) {
    CartExtension.CartValidationOutputList cartValidationOutputs = cart.getCartValidationOutputs();
    Assert.areEqual(0, cartValidationOutputs.size());
  }

  private static void assertExpectedCalculations(
    CartExtension.Cart cart,
    List<String> expectedCalculations
  ) {
    for (String calculationTag : expectedCalculations) {
      Assert.isTrue(cart.getName().contains(calculationTag));
    }
  }

  private static void assertUnexpectedCalculations(
    CartExtension.Cart cart,
    List<String> unexpectedCalculations
  ) {
    for (String calculationTag : unexpectedCalculations) {
      Assert.isFalse(cart.getName().contains(calculationTag));
    }
  }

  /**
   * @description Mocks invocations of prices(), promotions(), inventory(), shipping(), taxes(), postShipping() from CartCalculate
   */
  global class CartCalculateExecutorForUnitTest extends CartExtension.CartCalculateExecutorMock {
    /**
     * @description All classes extending CartExtension.CartCalculateExecutorMock must have a default constructor defined
     */
    global CartCalculateExecutorForUnitTest() {
    }

    global override void prices(
      CartExtension.CartCalculateCalculatorRequest request
    ) {
      CartExtension.Cart cart = request.getCart();
      cart.setName(cart.getName() + ', ' + CART_REPRICED);
    }

    global override void promotions(
      CartExtension.CartCalculateCalculatorRequest request
    ) {
      CartExtension.Cart cart = request.getCart();
      cart.setName(cart.getName() + ', ' + PROMOTIONS_RECALCULATED);
    }

    global override void inventory(
      CartExtension.CartCalculateCalculatorRequest request
    ) {
      CartExtension.Cart cart = request.getCart();
      cart.setName(cart.getName() + ', ' + INVENTORY_CHECKED);
    }

    global override void shipping(
      CartExtension.CartCalculateCalculatorRequest request
    ) {
      CartExtension.Cart cart = request.getCart();
      cart.setName(cart.getName() + ', ' + SHIPPING_RECALCULATED);
    }

    global override void tax(
      CartExtension.CartCalculateCalculatorRequest request
    ) {
      CartExtension.Cart cart = request.getCart();
      cart.setName(cart.getName() + ', ' + TAXES_RECALCULATED);
    }

    global override void postShipping(
      CartExtension.CartCalculateCalculatorRequest request
    ) {
      CartExtension.Cart cart = request.getCart();
      cart.setName(cart.getName() + ', ' + POST_SHIPPING_COMPLETED);
    }
  }

  private static CartExtension.BuyerActionsMock getBuyerActionsForAddToCart(
    CartExtension.Cart cart
  ) {
    return getCartItemChangedBuyerActions(cart);
  }

  private static CartExtension.BuyerActionDetails getBuyerActionDetailsForAddToCart(
    CartExtension.CartItem addedCartItem
  ) {
    CartExtension.CartItemChange cartItemChange = new CartExtension.CartItemChange.Builder()
      .withChangedItem(CartExtension.OptionalCartItem.of(addedCartItem))
      .withAdded(true)
      .build();
    List<CartExtension.CartItemChange> changedCartItems = new List<CartExtension.CartItemChange>{
      cartItemChange
    };
    CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
      .withCartItemChanges(changedCartItems)
      .build();
    return buyerActionDetails;
  }

  private static CartExtension.BuyerActionsMock getBuyerActionsForQuantityIncrease(
    CartExtension.Cart cart
  ) {
    return getCartItemChangedBuyerActions(cart);
  }

  private static CartExtension.BuyerActionDetails getBuyerActionDetailsForQuantityIncrease(
    CartExtension.CartItem cartItemWithIncreasedQuantity
  ) {
    CartExtension.CartItemChange cartItemChange = new CartExtension.CartItemChange.Builder()
      .withChangedItem(
        CartExtension.OptionalCartItem.of(cartItemWithIncreasedQuantity)
      )
      .withQuantityIncreased(true)
      .build();
    List<CartExtension.CartItemChange> changedCartItems = new List<CartExtension.CartItemChange>{
      cartItemChange
    };
    CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
      .withCartItemChanges(changedCartItems)
      .build();
    return buyerActionDetails;
  }

  private static CartExtension.BuyerActionsMock getBuyerActionsForQuantityDecrease(
    CartExtension.Cart cart
  ) {
    return getCartItemChangedBuyerActions(cart);
  }

  private static CartExtension.BuyerActionDetails getBuyerActionDetailsForQuantityDecrease(
    CartExtension.CartItem cartItemWithDecreasedQuantity
  ) {
    CartExtension.CartItemChange cartItemChange = new CartExtension.CartItemChange.Builder()
      .withChangedItem(
        CartExtension.OptionalCartItem.of(cartItemWithDecreasedQuantity)
      )
      .withQuantityDecreased(true)
      .build();
    List<CartExtension.CartItemChange> changedCartItems = new List<CartExtension.CartItemChange>{
      cartItemChange
    };
    CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
      .withCartItemChanges(changedCartItems)
      .build();
    return buyerActionDetails;
  }

  private static CartExtension.BuyerActionsMock getBuyerActionsForDeleteFromCart(
    CartExtension.Cart cart
  ) {
    return getCartItemChangedBuyerActions(cart);
  }

  private static CartExtension.BuyerActionDetails getBuyerActionDetailsForDeleteFromCart() {
    CartExtension.CartItemChange cartItemChange = new CartExtension.CartItemChange.Builder()
      .withChangedItem(CartExtension.OptionalCartItem.empty())
      .withRemoved(true)
      .build();
    List<CartExtension.CartItemChange> changedCartItems = new List<CartExtension.CartItemChange>{
      cartItemChange
    };
    CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
      .withCartItemChanges(changedCartItems)
      .build();
    return buyerActionDetails;
  }

  private static CartExtension.BuyerActionsMock getBuyerActionsForApplyCoupon(
    CartExtension.Cart cart
  ) {
    return getCouponChangedBuyerActions(cart);
  }

  private static CartExtension.BuyerActionDetails getBuyerActionDetailsForApplyCoupon(
    CartExtension.CartAdjustmentBasis cartAdjustmentBasis
  ) {
    CartExtension.CouponChange couponChange = new CartExtension.CouponChange.Builder()
      .withChangedAdjustmentBasis(
        CartExtension.OptionalCartAdjustmentBasis.of(cartAdjustmentBasis)
      )
      .withAdded(true)
      .build();
    List<CartExtension.CouponChange> changedCoupons = new List<CartExtension.CouponChange>{
      couponChange
    };
    CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
      .withCouponChanges(changedCoupons)
      .build();
    return buyerActionDetails;
  }

  private static CartExtension.BuyerActionsMock getBuyerActionsForDeleteCoupon(
    CartExtension.Cart cart
  ) {
    return getCouponChangedBuyerActions(cart);
  }

  private static CartExtension.BuyerActionDetails getBuyerActionDetailsForDeleteCoupon() {
    CartExtension.CouponChange couponChange = new CartExtension.CouponChange.Builder()
      .withChangedAdjustmentBasis(
        CartExtension.OptionalCartAdjustmentBasis.empty()
      )
      .withRemoved(true)
      .build();
    List<CartExtension.CouponChange> changedCoupons = new List<CartExtension.CouponChange>{
      couponChange
    };
    CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
      .withCouponChanges(changedCoupons)
      .build();
    return buyerActionDetails;
  }

  private static CartExtension.BuyerActionsMock getBuyerActionsForStartCheckout(
    CartExtension.Cart cart
  ) {
    CartExtension.BuyerActionsMock buyerActions = new CartExtension.BuyerActionsMock(
      cart
    );
    buyerActions.setCheckoutStarted(true);
    return buyerActions;
  }

  private static CartExtension.BuyerActionDetails getBuyerActionDetailsForStartCheckout() {
    CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
      .withCheckoutStarted(true)
      .build();
    return buyerActionDetails;
  }

  private static CartExtension.BuyerActionsMock getBuyerActionsForStartCheckoutForBuyerWithShippingAddress(
    CartExtension.Cart cart
  ) {
    CartExtension.BuyerActionsMock buyerActions = new CartExtension.BuyerActionsMock(
      cart
    );
    buyerActions.setCheckoutStarted(true);
    buyerActions.setDeliveryGroupChanged(true);
    return buyerActions;
  }

  private static CartExtension.BuyerActionDetails getBuyerActionDetailsForStartCheckoutForBuyerWithShippingAddress(
    CartExtension.CartDeliveryGroup deliveryGroup
  ) {
    CartExtension.CartDeliveryGroupChange deliveryGroupChange = new CartExtension.CartDeliveryGroupChange.Builder()
      .withChangedDeliveryGroup(
        CartExtension.OptionalCartDeliveryGroup.of(deliveryGroup)
      )
      .build();
    List<CartExtension.CartDeliveryGroupChange> deliveryGroupChanges = new List<CartExtension.CartDeliveryGroupChange>{
      deliveryGroupChange
    };
    CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
      .withCheckoutStarted(true)
      .withDeliveryGroupChanges(deliveryGroupChanges)
      .build();
    return buyerActionDetails;
  }

  private static CartExtension.BuyerActionsMock getBuyerActionsForUpdateCheckoutWithShippingAddress(
    CartExtension.Cart cart
  ) {
    CartExtension.BuyerActionsMock buyerActions = new CartExtension.BuyerActionsMock(
      cart
    );
    buyerActions.setDeliveryGroupChanged(true);
    return buyerActions;
  }

  private static CartExtension.BuyerActionDetails getBuyerActionDetailsForUpdateCheckoutWithShippingAddress(
    CartExtension.CartDeliveryGroup deliveryGroup
  ) {
    CartExtension.CartDeliveryGroupChange deliveryGroupChange = new CartExtension.CartDeliveryGroupChange.Builder()
      .withChangedDeliveryGroup(
        CartExtension.OptionalCartDeliveryGroup.of(deliveryGroup)
      )
      .build();
    List<CartExtension.CartDeliveryGroupChange> deliveryGroupChanges = new List<CartExtension.CartDeliveryGroupChange>{
      deliveryGroupChange
    };
    CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
      .withDeliveryGroupChanges(deliveryGroupChanges)
      .build();
    return buyerActionDetails;
  }

  private static CartExtension.BuyerActionsMock getBuyerActionsForUpdateCheckoutWithSelectedDeliveryMethod(
    CartExtension.Cart cart
  ) {
    CartExtension.BuyerActionsMock buyerActions = new CartExtension.BuyerActionsMock(
      cart
    );
    buyerActions.setDeliveryMethodSelected(true);
    return buyerActions;
  }

  private static CartExtension.BuyerActionDetails getBuyerActionDetailsForUpdateCheckoutWithSelectedDeliveryMethod(
    CartExtension.CartDeliveryGroup deliveryGroup
  ) {
    CartExtension.CartDeliveryGroupChange deliveryGroupChange = new CartExtension.CartDeliveryGroupChange.Builder()
      .withChangedDeliveryGroup(
        CartExtension.OptionalCartDeliveryGroup.of(deliveryGroup)
      )
      .build();
    List<CartExtension.CartDeliveryGroupChange> deliveryGroupChanges = new List<CartExtension.CartDeliveryGroupChange>{
      deliveryGroupChange
    };
    CartExtension.BuyerActionDetails buyerActionDetails = new CartExtension.BuyerActionDetails.Builder()
      .withDeliveryGroupChanges(deliveryGroupChanges)
      .build();
    return buyerActionDetails;
  }

  private static CartExtension.BuyerActionsMock getCartItemChangedBuyerActions(
    CartExtension.Cart cart
  ) {
    CartExtension.BuyerActionsMock buyerActions = new CartExtension.BuyerActionsMock(
      cart
    );
    buyerActions.setCartItemChanged(true);
    return buyerActions;
  }

  private static CartExtension.BuyerActionsMock getCouponChangedBuyerActions(
    CartExtension.Cart cart
  ) {
    CartExtension.BuyerActionsMock buyerActions = new CartExtension.BuyerActionsMock(
      cart
    );
    buyerActions.setCouponChanged(true);
    return buyerActions;
  }
}