public with sharing class RecommenderMetadata {
    public RecommenderMetadata() {

    }
    
    public boolean considerContext { get; set; }
    public Map<String,String> locales { get; set; }
    public String endPoint { get; set; }
    public String httpMethod { get; set; }
    public String mockedResponse { get; set; }
    public String serviceMode { get; set; }
    public String serviceTimeout { get; set; }
    public String serviceImplClass { get; set; }
    public String namedCredentials { get; set; }
    private List<RecommenderDetails> recommenders  = new List<RecommenderDetails>();
    private List<ActivityDetails> activities  = new List<ActivityDetails>();
    
    public void addRecoDetails(RecommenderDetails recoDetails) {
        recommenders.add(recoDetails);
    }

    public List<RecommenderDetails> getRecommenders(){
        return recommenders;
    }

    public void addActivities(ActivityDetails activityDetails) {
        activities.add(activityDetails);
    }

    public List<ActivityDetails> getActivities(){
        return activities;
    }

    public RecommenderDetails getRecommender(String recommenderName){
        RecommenderDetails rd;
        for(Integer index = 0, size = recommenders.size(); index < size; index++) {
            if(recommenders.get(index).recoEinsteinId == recommenderName){
                rd = recommenders.get(index);
                break;
            }
        }
        return rd;
    }
}