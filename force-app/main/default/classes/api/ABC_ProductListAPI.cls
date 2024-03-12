
@RestResource(urlMapping='/ABC_ProductListAPI/*')
global class ABC_ProductListAPI {
    public static ABC_ProductService aBC_ProductServiceInstance = ABC_ProductService.getInstance();

    public ABC_ProductListAPI() {

    }

    @HttpGet
  global static List<ABC_ProductMapper> getProductList() {
    RestRequest getReuest = RestContext.request;
    RestResponse requestResponse= RestContext.response;
    List<ABC_ProductMapper> productList;
    try{
      productList =aBC_ProductServiceInstance.GetOnlineProductList();
     } catch(Exception e){
        system.debug('ProductListAPI '+e);

     }
    return productList;
  }
}