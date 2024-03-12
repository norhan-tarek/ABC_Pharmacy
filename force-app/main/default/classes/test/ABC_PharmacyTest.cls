@istest
public class ABC_PharmacyTest {
    public ABC_PharmacyTest() {

    }

    @istest(seeAllData=true)
    static void TestProductListAPI() {
      ABC_DataFactoryTest dataFactory = ABC_DataFactoryTest.getInstance();
      RestRequest req = new RestRequest(); 
      RestResponse res = new RestResponse();
      req.requestURI = '/ABC_ProductListAPI';  
      req.httpMethod = 'GET';
      RestContext.request = req;
      RestContext.response = res;
      Test.startTest();
      List<ABC_ProductMapper> productsSent=ABC_ProductListAPI.getProductList();
      Test.stopTest();
      List<PricebookEntry> productsFromOnlinePriceLits=[SELECT ID FROM PricebookEntry WHERE Pricebook2.Name ='Online Pharmacy Pricebook'];
      System.assertEquals(productsSent.size(), productsFromOnlinePriceLits.size(), 'Sent products not Matching online priceList');
}

@istest(seeAllData=true)
static void TestCreateShoppingCartAPI() {
  ABC_DataFactoryTest dataFactory = ABC_DataFactoryTest.getInstance();
  Account account = dataFactory.CreateAccount('Adam', 'Raheem');
  Contact contact = dataFactory.CreateContact('Ahmed','Gamil','Adam@test.com',account.Id);
  RestRequest req = new RestRequest(); 
  RestResponse res = new RestResponse();
  req.requestURI = '/ABC_ShoppingCartAPI';  
  req.httpMethod = 'Post';
  req.params.put('CustomerId', contact.Id);
  String jsonString = '[' + '{' +' "Product": "Pandol Extra",'+
    '"Quantity": 2'+'}'+']';
  req.requestBody =blob.valueOf(jsonString);

  RestContext.request = req;
  RestContext.response = res;
  Test.startTest();
  ABC_ShoppingCartAPI.CreateOrder();
  Test.stopTest();

}


@istest(seeAllData=true)
static void TestGetShoppingCartAPI() {
  ABC_DataFactoryTest dataFactory = ABC_DataFactoryTest.getInstance();
  Account account = dataFactory.CreateAccount('Adam', 'Raheem');
  Contact contact = dataFactory.CreateContact('Ahmed','Gamil','Adam@test.com',account.Id);
  Pricebook2 pricebook = dataFactory.CreatePricebook('Online Pharmacy Pricebook');
  PricebookEntry pricebookEntry = dataFactory.CreatePricebookEntry('Pandol Extra',pricebook.Id);
  Order order = dataFactory.CreateOrder(contact.Id,account.Id,pricebook.Id,Date.Today(),'ABC_ShoppingCart');
  OrderItem orderItem = dataFactory.CreateOrderItem(order.Id,pricebookEntry);
  RestRequest req = new RestRequest(); 
  RestResponse res = new RestResponse();
  req.requestURI = '/ABC_ShoppingCartAPI';  
  req.httpMethod = 'Get';
  req.params.put('CustomerId', contact.Id);

  RestContext.request = req;
  RestContext.response = res;
  Test.startTest();
  List<ABC_ProductMapper> productsInShoppigCart=ABC_ShoppingCartAPI.getShoppingCart();
  Test.stopTest();
  System.assertEquals(productsInShoppigCart.size(), 1, 'Shopping Cart products does not match');


}

@istest(seeAllData=true)
static void TestVisualForcePageOrderListController() {
    ABC_DataFactoryTest dataFactory = ABC_DataFactoryTest.getInstance();
    Account account = dataFactory.CreateAccount('Adam', 'Raheem');
    Contact contact = dataFactory.CreateContact('Ahmed','Gamil','Adam@test.com',account.Id);
    Pricebook2 pricebook = dataFactory.CreatePricebook('Online Pharmacy Pricebook');
    PricebookEntry pricebookEntry = dataFactory.CreatePricebookEntry('Pandol Extra',pricebook.Id);
    Order order = dataFactory.CreateOrder(contact.Id,account.Id,pricebook.Id,Date.Today(),'ABC_ShoppingCart');
    OrderItem orderItem = dataFactory.CreateOrderItem(order.Id,pricebookEntry);
    Test.startTest();
    ABC_OrderListController controller = new ABC_OrderListController();
    Test.stopTest();

}

@istest(seeAllData=true)
static void TestOrderArchiveBatch() {
    ABC_DataFactoryTest dataFactory = ABC_DataFactoryTest.getInstance();
    Account account = dataFactory.CreateAccount('Adam', 'Raheem');
    Contact contact = dataFactory.CreateContact('Ahmed','Gamil','Adam@test.com',account.Id);
    Pricebook2 pricebook = dataFactory.CreatePricebook('Online Pharmacy Pricebook');
    PricebookEntry pricebookEntry = dataFactory.CreatePricebookEntry('Pandol Extra',pricebook.Id);
    Order order = dataFactory.CreateOrder(contact.Id,account.Id,pricebook.Id,Date.Today().addYears(-2),'ABC_Delivered');
    OrderItem orderItem = dataFactory.CreateOrderItem(order.Id,pricebookEntry);
    Test.startTest();
    ABC_OrderArchiveBatch batchArchive = new ABC_OrderArchiveBatch();
    Database.executeBatch(batchArchive);
    Test.stopTest();
}



}