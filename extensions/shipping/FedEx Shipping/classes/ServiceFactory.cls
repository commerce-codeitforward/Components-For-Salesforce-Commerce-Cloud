public with sharing class ServiceFactory {
    private static HTTPService service;
    private ServiceFactory() {
    }
    public static HTTPService getService(String className) {
      if (service == null) {
        if (String.isNotEmpty(className)) {
          Type t = Type.forName(className);
          service = (HTTPService) t.newInstance();
        } else {
          service = new HTTPService();
        }
      }
      return service;
    }
  }