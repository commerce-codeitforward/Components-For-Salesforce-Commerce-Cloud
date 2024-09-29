import { LightningElement, api, wire } from 'lwc';
import getRecommendations from '@salesforce/apex/RecommendationsController.getRecommendations';
import getActivities from '@salesforce/apex/RecommendationsController.getActivities';
import getCategoryRecommenders from '@salesforce/apex/RecommendationsController.getCategoryRecommenders';
import { trackClickReco, trackViewReco, trackAddProductToCart } from 'commerce/activitiesApi';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import { getAppContext } from 'commerce/contextApi';
import { getSessionContext } from 'commerce/contextApi';
import { addItemToCart } from 'commerce/cartApi';

export default class Recommendations extends NavigationMixin(LightningElement) {
  @api useCase;
  @api headerText;
  @api maximumProductsVisible;
  @api hideForResultsFewerThan;

  categoryId;
  isPreview = false;
  compLoaded = false;
  uuid;
  loading = false;
  showProducts = false;
  productsAll = [];
  products = [];
  hasNextPage = false;
  webStoreId;
  currencyMap = { USD: '$', EUR: '€' };
  currencySymbol;

  categoryUseCases = ['RecentlyViewed', 'MostViewedByCategory', 'TopSellingByCategory'];
  recommenderNames = {
    RecentlyViewed: 'recently-viewed',
    SimilarProducts: 'similar-products',
    MostViewedByCategory: 'most-viewed-by-category',
    TopSelling: 'top-selling',
    Upsell: 'upsell'
  };
  // The recommender names we pass into the Connect API are in a different format
  // than the recommender names we pass into the activities api.


  // Declare the currentPageReference variable in order to track it
  currentPageReference;
  // Injects the page reference that describes the current page
  @wire(CurrentPageReference)
  setCurrentPageReference(currentPageReference) {
    if (this.compLoaded && this.categoryUseCases.indexOf(this.useCase) > -1) {
      this.currentPageReference = currentPageReference;
      const newCategoryId = currentPageReference.attributes.recordId;
      if (currentPageReference.attributes.objectApiName == 'ProductCategory' && newCategoryId != this.categoryId) {
        this.loadProductRecommendations(newCategoryId);
      }
      this.categoryId = newCategoryId;
    }
  }

  connectedCallback() {
    if (this.compLoaded === false) {
      getSessionContext().then((sessionContext) => {
        this.isPreview = sessionContext.isPreview;
        if (sessionContext.isLoggedIn === true) {
          getAppContext().then((appContext) => {
            this.webStoreId = appContext.webstoreId;
            this.onLoadComponent();
            this.compLoaded = true;
          });
        }
      });
    } else {
      this.onLoadComponent();
    }
  }

  onLoadComponent() {
    let productOrCategoryId = this.getProductDetailProductId();
    console.log('======== onLoadComponent');
    getActivities().then((response) => {
      console.log('======== getActivities'+response);
      this.recommenderNames = JSON.parse(response);
     
    }).catch((error) => {
      console.error('Error fetching Activities', error);
      this.loading = false;
    });
    
    getCategoryRecommenders().then((response) => {
      console.log('======== getCategoryRecommenders'+response);
      this.categoryUseCases = JSON.parse(response);
     
    }).catch((error) => {
      console.error('Error fetching Category Use Cases', error);
      this.loading = false;
    });

    this.loadProductRecommendations(productOrCategoryId);

  }

  // send a clickReco activity and navigate to the product detail page
  handleClickProduct(event) {
    let productId = event.currentTarget.dataset.pid;
    //let trackClickaReco = this.activitiesApi.trackClickReco;
    let recName = this.recommenderNames[this.useCase];
    let uuid = this.uuid;
    let products = this.products;
    let product = products.filter((p) => p.id === productId)[0];
    let productToSend = {
      id: product.id,
      price: product.prices ? product.prices.listPrice : undefined
    };
    console.log('======== trackClickReco - before');
    trackClickReco(recName, uuid, productToSend);
    console.log('======== trackClickReco - after');
    // navigate to the product page
    const paths = window.location.pathname.split('/');
    const storeName = paths[1];
    let productName = product.name || 'detail';
    this[NavigationMixin.Navigate]({
      type: 'standard__webPage',
      attributes: {
        url: '/' + storeName + '/product/' + productName + '/' + productId
      }
    });
  }

  loadProductRecommendations(recordId) {
    try {
      console.log('======== loadProductRecommendations');
      // if(recordId){
      //   const isCategoryId = recordId.slice(0, 3) == '0ZG';
      //   const isCategoryUseCase = this.categoryUseCases.indexOf(this.useCase) > -1;
      //   if ((isCategoryId && !isCategoryUseCase) || (!isCategoryId && isCategoryUseCase)) {
      //     return;
      //   }
      // }
      
      this.loading = true;
      let input = {};
      input.webStoreId = this.webStoreId;
      //input.recommender = this.useCaseMap[this.useCase];
      input.recommender = this.useCase;
      input.anchorValues = recordId;
      input.cookie = document.cookie;
      getRecommendations({ input: input })
        .then((response) => {
          console.log('======== '+response);
          let data = JSON.parse(response);
          this.productsAll = [...data.productPage.products];
          this.productsAll.forEach((p) => {
            p.shortName = p.name.slice(0, 16) + '...';
          });

          this.currencySymbol = this.currencyMap[data.productPage.currencyIsoCode];
          this.products = this.productsAll.slice(0, this.maximumProductsVisible);
          this.hasNextPage = this.productsAll.length > this.maximumProductsVisible;

          this.uuid = data.uuid;
          this.loading = false;
          this.showProducts = this.productsAll.length >= this.hideForResultsFewerThan;
          // Only send the viewReco activity when we display the product recommendations
          if (this.showProducts) {
            this.sendViewRecoActivity();
          }
        })
        .catch((error) => {
          console.error('Error fetching recommendations', error);
          this.loading = false;
        });
    } catch (error) {
      console.error('Failed to load recommendations: ', error);
      this.loading = false;
    }
  }
  
  getProductDetailProductId() {
    let productOrCategoryId;
    let pageProductIdMatch = window.location.href.match(new RegExp('01t[a-zA-Z0-9]{15}'));
    productOrCategoryId = pageProductIdMatch ? pageProductIdMatch[0] : null;

    if (productOrCategoryId == null) {
      let pageCategoryIdMatch = window.location.href.match(new RegExp('0ZG[a-zA-Z0-9]{15}'));
      productOrCategoryId = pageCategoryIdMatch ? pageCategoryIdMatch[0] : null;
    }
    return productOrCategoryId;
  }

  sendViewRecoActivity() {
    let products = this.products.map((p) => ({ id: p.id }));
    console.log('============== sendViewRecoActivity - before');
    trackViewReco(this.recommenderNames[this.useCase], this.uuid, products);
    console.log('============== sendViewRecoActivity - after');
  }

  handlePrevious() {
    const lastProduct = this.products[this.maximumProductsVisible - 1];
    const lastIndex = this.productsAll.findIndex((p) => {
      return p.id === lastProduct.id;
    });

    let arr = [...this.productsAll.slice(lastIndex + 1), ...this.productsAll.slice(0, lastIndex + 1)];
    this.products = [...arr.slice(0, this.maximumProductsVisible)];
  }

  handleNext() {
    const lastProduct = this.products[this.maximumProductsVisible - 1];
    const lastIndex = this.productsAll.findIndex((p) => {
      return p.id === lastProduct.id;
    });

    let arr = [...this.productsAll.slice(lastIndex + 1), ...this.productsAll.slice(0, lastIndex + 1)];
    this.products = [...arr.slice(0, this.maximumProductsVisible)];
  }

  handleAddItemToCart(event) {
    if (event.currentTarget.dataset.loading == 'true') {
      event.stopPropagation();
    }
    event.currentTarget.dataset.loading = 'true';
    let productId = event.currentTarget.dataset.pid;
    event.currentTarget.style.pointerEvents = 'none';
    event.currentTarget.classList.add('button--loading');
    addItemToCart(productId, 1).then((result) => {
      let buttons = this.template.querySelectorAll(`button[data-pid="${result.productId}"]`);
      let btn = buttons[0];
      btn.classList.remove('button--loading');
      btn.classList.remove('slds-button_neutral');
      btn.classList.add('slds-button_success');
      btn.childNodes[0].innerText = 'Added';
      setTimeout(
        (id) => {
          let buttons = this.template.querySelectorAll(`button[data-pid="${id}"]`);
          let btn = buttons[0];
          btn.classList.remove('slds-button_success');
          btn.classList.add('slds-button_neutral');
          btn.childNodes[0].innerText = 'Add to Cart';
          btn.style.pointerEvents = 'auto';
          btn.dataset.loading = 'false';
        },
        '1500',
        result.productId
      );
      let addedProduct;
      this.productsAll.forEach((p) => {
       if(p.id === productId){
        addedProduct = p;
       }
      });
      if(addedProduct){
        console.log("product added activity : "+productId);
        trackAddProductToCart({ id: productId, sku: addedProduct.fields.StockKeepingUnit, quantity: 1, price: addedProduct.prices.unitPrice, originalPrice: addedProduct.prices.listPrice });
      }
    });
  }
}
