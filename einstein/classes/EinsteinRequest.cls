public with sharing class EinsteinRequest {
    public EinsteinRequest() {

    }


    public RecommenderMetadata metaData { get; set; }
    public String webstoreId { get; set; }
    public String recommender { get; set; }
    public String anchorValues  { get; set; }
    public String cookie { get; set; }

}