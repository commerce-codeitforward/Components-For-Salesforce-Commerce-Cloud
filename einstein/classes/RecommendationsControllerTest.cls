@IsTest
public class RecommendationsControllerTest {
  static String recommender = 'recommenders';
  static String anchorValues = 'test';
  static String cookie = 'cookie';

  /**
   * @description Test positive scenario for getRecommendations method
   */
  @IsTest
  static void shouldGetRecommendations() {
    WebStore webstore = new WebStore(Name = 'Test', DefaultLanguage = 'en_US');
    insert webstore;

    Test.setMock(HttpCalloutMock.class, new RestSuccessMock());

    Test.startTest();
    RecommendationsController.GetRecommendationsInput input = new RecommendationsController.GetRecommendationsInput();
    input.recommender = recommender;
    input.cookie = cookie;
    input.anchorValues = anchorValues;
    input.webstoreId = webstore.ID;
    String result = RecommendationsController.getRecommendations(input);
    Test.stopTest();

    // Perform assertions to verify the expected behavior
    System.assert(result != null, 'Result should not be null');
  }

  /**
   * @description Mock success response class
   */
  private class RestSuccessMock implements HttpCalloutMock {
    /**
     * @description Http respond method
     * @param request HttpRequest object
     * @return HttpResponse object
     */
    public HttpResponse respond(HttpRequest request) {
      HttpResponse mockResponse = new HttpResponse();
      String jsonResponse = '{"uuid":"aaaa-bbbb-cccc-dddd","productPage":{"products":[{"id":"001","name":"Product 1","image":"https://example.com/image1.jpg","price":99.99},{"id":"002","name":"Product 2","image":"https://example.com/image2.jpg","price":49.99},{"id":"003","name":"Product 3","image":"https://example.com/image3.jpg","price":19.99},{"id":"004","name":"Product 4","image":"https://example.com/image4.jpg","price":39.99}]}}';
      mockResponse.setBody(jsonResponse);
      mockResponse.setStatusCode(200);
      return mockResponse;
    }
  }
}
