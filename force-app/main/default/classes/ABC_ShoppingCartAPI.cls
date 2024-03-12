@RestResource(urlMapping='/ABC_ShoppingCartAPI/*')
global class ABC_ShoppingCartAPI {
    public static ABC_ProductService aBC_ProductServiceInstance = ABC_ProductService.getInstance();

    public ABC_ShoppingCartAPI() {

    }

    @HttpPost
    global static void CreateOrder(){
        RestRequest postReuest= RestContext.request;
        RestResponse requestResponse= RestContext.response;
        try{
        String customerId = postReuest.params.get('CustomerId');
            List< Object> body = (List< Object>)JSON.deserializeUntyped(RestContext.request.requestbody.tostring());
            aBC_ProductServiceInstance.createShoppingCart(customerId, body);
            requestResponse.statusCode=200;
            requestResponse.responseBody = Blob.valueOf('success');
           
         
       }
       catch(Exception e){
         requestResponse.responseBody = Blob.valueOf(e.getMessage());
         system.debug('shoppoingCartAPI '+e);
      }
    }
        @HttpGet
        global static List<ABC_ProductMapper> getShoppingCart() {
          RestRequest getReuest = RestContext.request;
          RestResponse requestResponse= RestContext.response;
          List<ABC_ProductMapper> productList;
          try{
            String customerId = getReuest.params.get('CustomerId');
            productList =aBC_ProductServiceInstance.getShoppingCartProducts(customerId);
           } catch(Exception e){
              requestResponse.responseBody = Blob.valueOf(e.getMessage());
              system.debug('shoppoingCartAPI '+e);
      
           }
          return productList;
        }
}

