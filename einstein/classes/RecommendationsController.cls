/**
 * @description recommendations products
 */
public with sharing class RecommendationsController {
  @AuraEnabled
  /**
   * @description retrieve recommendation products
   * @param input GetRecommendationsInput model
   * @return return string to json
   */
  public static String getRecommendations(GetRecommendationsInput input) {
    EinsteinRequest request = new EinsteinRequest();
    request.webstoreId = input.webstoreId;
    request.recommender = input.recommender;
    request.anchorValues = input.anchorValues;
    request.cookie = input.cookie;
    RecommenderMetadata recommenderMetadata =  Recommender_Configuration.getRecommendersConfig();
    request.metaData = recommenderMetadata;
    String recResponse = EinsteinRecommenderService.getRecommendations (request);
    EinsteinRecommenderResponse responseDs = (EinsteinRecommenderResponse) JSON.deserialize(recResponse, EinsteinRecommenderResponse.class);
    Set<Id> pIds = new Set<Id>();
    for(EinsteinRecommenderResponse.cls_products ep : responseDs.productPage.products){
      pIds.add(ep.id);
    }
    Map<String, String> imagesByProdIds = ProductHelper.getProdImages(pIds);
    for (String key : imagesByProdIds.keySet()) {
      for(EinsteinRecommenderResponse.cls_products ep : responseDs.productPage.products){
       if(key == ep.id){
          ep.defaultImage.url = imagesByProdIds.get(key);
       }
      }
    }
    return JSON.serialize(responseDs, true);
  }

  @AuraEnabled
  public static String getActivities() {
    RecommenderMetadata recommenderMetadata =  Recommender_Configuration.getRecommendersConfig();
    Map<String, String> activities = new Map<String, String>();
    if(recommenderMetadata.getActivities().size() > 0){
      for(ActivityDetails activity : recommenderMetadata.getActivities()){
          activities.put(activity.nameInRecommender , activity.nameInActivity);
      }
    }
    return JSON.serialize(activities);
  }

  @AuraEnabled
  public static String getCategoryRecommenders() {
    RecommenderMetadata recommenderMetadata =  Recommender_Configuration.getRecommendersConfig();
    List<String> catRecommenders = new List<String>();
    if(recommenderMetadata.getRecommenders().size() > 0){
      for(RecommenderDetails reco : recommenderMetadata.getRecommenders()){
          if(reco.context == 'Category'){
            catRecommenders.add(reco.recoEinsteinId);
        }
      }
  }
    return JSON.serialize(catRecommenders);
  }

  /**
   * @description getRecommendations model class
   */
  public class GetRecommendationsInput {
    /**
     * @description WebStore Id
     */
    @AuraEnabled
    public String webstoreId { get; set; }

    /**
     * @description Recommender name
     */
    @AuraEnabled
    public String recommender { get; set; }

    /**
     * @description Anchor values
     */
    @AuraEnabled
    public String anchorValues { get; set; }

    /**
     * @description Cookie
     */
    @AuraEnabled
    public String cookie { get; set; }
  }
}
