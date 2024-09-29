public without sharing class ProductHelper {
    public ProductHelper() {

    }
    private static final Integer NUM_OF_MEDIA_IDS_PER_REQUEST = 150;
    public static Map<String, String> getProdImages(Set<Id> productIds){
        Map<String, String> productImageUrlsByProductIds = new Map<String, String>();
        try{
        List<ProductMedia> prodMedia =[SELECT ElectronicMediaId,ProductId FROM ProductMedia WHERE ProductId IN :productIds ORDER BY SortOrder];
            
            Map<String, String> electronicMediaIds = new Map<String, String>();
            if (prodMedia != null && prodMedia.size() > 0) {
                for (ProductMedia p : prodMedia) {
                    electronicMediaIds.put(p.ElectronicMediaId, p.ProductId);
                }
            } 
            Map<String, String> electronicMediaIdsCopy = electronicMediaIds.clone();
            while (true) {
                List<String> loopElMediaIds = getSubSetAndRemoveFromOriginal(electronicMediaIdsCopy.keySet(), NUM_OF_MEDIA_IDS_PER_REQUEST);
                if (loopElMediaIds.isEmpty()) {
                    break;
                }
                if (! loopElMediaIds.isEmpty()) {
                    ConnectApi.ManagedContentVersionCollection contentVersionCollection = ConnectApi.ManagedContent.getManagedContentByIds(
                        Network.getNetworkId(),
                        loopElMediaIds,
                        null,
                        NUM_OF_MEDIA_IDS_PER_REQUEST,
                        null,
                        null
                    );
                    
                    List<ConnectApi.ManagedContentVersion> contentVersions = (List<ConnectApi.ManagedContentVersion>) contentVersionCollection.items;
                    if (contentVersions != null && contentVersions.size() > 0) {
                        for (ConnectApi.ManagedContentVersion managedContentVersion : contentVersions) {
                            if (managedContentVersion.title != null && managedContentVersion.contentNodes != null) {
                                Map<String, ConnectApi.ManagedContentNodeValue> contentNodes = (Map<String, ConnectApi.ManagedContentNodeValue>) managedContentVersion.contentNodes;
                                ConnectApi.ManagedContentMediaSourceNodeValue mediaSourceNodeValue = (ConnectApi.ManagedContentMediaSourceNodeValue) contentNodes.get('source');
                                if(mediaSourceNodeValue.url != null){
                                    String electronicMediaId = String.valueOf(managedContentVersion.managedContentId);
                                    productImageUrlsByProductIds.put(electronicMediaIds.get(electronicMediaId),mediaSourceNodeValue.url);
                                }
                            }
                        }
                    }
                }
            }
        }catch(Exception e){
            system.debug('Exception while getting product images'+e.getMessage());
        }
        return productImageUrlsByProductIds;
    }

    private static List<String> getSubSetAndRemoveFromOriginal(Set<String> original, Integer size){
        List<String> subSet = new List<String>();
        
        for (String str : original) {
            subSet.add(str);
            if (subSet.size() >= size) {
                break;
            }
            
        }
        original.removeAll(subSet);
        return subSet;
    }
}