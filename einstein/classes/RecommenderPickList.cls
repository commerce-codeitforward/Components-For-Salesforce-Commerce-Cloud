global class RecommenderPickList extends VisualEditor.DynamicPickList{
    VisualEditor.DesignTimePageContext context;

    global RecommenderPickList(VisualEditor.DesignTimePageContext context) {
       this.context = context;
    }

    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Recently Viewed', 'RecentlyViewed');
        return defaultValue;
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        String networkId = Network.getNetworkId();
        List<WebStoreNetwork> webStroreNetworkObjList = [
            SELECT WebStoreId, NetworkId
            FROM WebStoreNetwork
            WHERE NetworkId = :networkId
            LIMIT 1
        ];
        String webstoreId;
        if (!webStroreNetworkObjList.isEmpty()) {
            webstoreId = webStroreNetworkObjList.get(0).WebStoreId;
        }
        RecommenderMetadata recommenderMetadata =  Recommender_Configuration.getRecommendersConfig();
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        if(recommenderMetadata.getRecommenders().size() > 0){
            for(RecommenderDetails reco : recommenderMetadata.getRecommenders()){
                if(recommenderMetadata.considerContext){
                    if(context.entityName == 'ProductCategory' && (reco.context.indexOf('Category') > -1 ||reco.context == 'NoContext')){
                        myValues.addRow(new VisualEditor.DataRow(reco.uiLabel,reco.recoEinsteinId));
                    }else if(context.entityName == 'Product2' && (reco.context == 'Product' || reco.context == 'NoContext')){
                        myValues.addRow(new VisualEditor.DataRow(reco.uiLabel,reco.recoEinsteinId));
                    }else if(reco.context.indexOf('NoContext') > -1){
                        myValues.addRow(new VisualEditor.DataRow(reco.uiLabel,reco.recoEinsteinId));
                    }
                }else{
                    myValues.addRow(new VisualEditor.DataRow(reco.uiLabel,reco.recoEinsteinId));
                }
            }
        }
        
        //System.debug('================== context.pageType : '+context.pageType+' : '+context.entityName);
        // if (context.pageType == 'HomePage') {
        //     VisualEditor.DataRow value3 = new VisualEditor.DataRow('purple', 'PURPLE');
        //     myValues.addRow(value3);
        // }

        return myValues;
    }
}