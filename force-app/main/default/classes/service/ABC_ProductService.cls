public class ABC_ProductService {
    private static ABC_ProductService instance = null;
    public ABC_ProductRepository aBC_ProductRepositoryInstance;
    public ABC_OrderRepository aBC_OrderRepositoryInstance;
    public ABC_ContactRepository aBC_ContactRepositoryInstance; 

    public ABC_ProductMapper productMapper = new ABC_ProductMapper();

    private ABC_ProductService() {
        aBC_ProductRepositoryInstance = ABC_ProductRepository.getInstance();
        aBC_OrderRepositoryInstance = ABC_OrderRepository.getInstance();
        aBC_ContactRepositoryInstance = ABC_ContactRepository.getInstance();
    }

    public static ABC_ProductService getInstance() {
        if (instance == null) {
            instance = new ABC_ProductService();
          }
          return instance;
    }

    public List<ABC_ProductMapper> GetOnlineProductList(){
       
        return productMapper.productObjectListToMapperList(aBC_ProductRepositoryInstance.getAllOnlineProductsPriceBookEntries());
    }

    public void createShoppingCart(String contactId, List< Object> products){
        Pricebook2 onlinePriceBook = aBC_ProductRepositoryInstance.getOnlinePriceBook();
        Contact contactDetails =  aBC_ContactRepositoryInstance.getContactById(contactId);
        Order shoppingCartOrder;
        List<OrderItem> orderItems = new List<OrderItem>();
        if(getShoppingCart(contactId)!= null){
            shoppingCartOrder =getShoppingCart(contactId);
            orderItems =aBC_OrderRepositoryInstance.getOrderItemByOrder(shoppingCartOrder.Id);
        }else{
        shoppingCartOrder = new Order(
            Contact_abc__c = contactId,
            AccountId = contactDetails.AccountId,
            Pricebook2Id = onlinePriceBook.Id,
            EffectiveDate = Date.today(),
            Status='ABC_ShoppingCart'
        );
         insert shoppingCartOrder;
       }

       if(orderItems.size()>0){
        delete orderItems;
        orderItems.clear();
       }
        Integer counter = 0;
        system.debug('products size '+products.size());
         Map<String,PricebookEntry> productMap= mapProduct();
        while(counter < products.size()){
            Map<String,Object> productDetails = (Map<String,Object>) products.get(counter);
            OrderItem orderItem = new OrderItem(
                OrderId = shoppingCartOrder.Id,
                Product2Id = productMap.get((String)productDetails.get('Product')).Product2.Id,
                PricebookEntryId =productMap.get((String)productDetails.get('Product')).Id,
                UnitPrice =productMap.get((String)productDetails.get('Product')).UnitPrice,
                Quantity = (Decimal)productDetails.get('Quantity')
            );

            orderItems.add(orderItem);
            counter++;
        }
        insert orderItems;
    }

    public Order getShoppingCart(String contactId){
        List <Order> contactOrderList =aBC_OrderRepositoryInstance.getOrderByContactAndStatus(contactId,'ABC_ShoppingCart');
        if(contactOrderList.size()>0){
        return contactOrderList.get(0);
        }else{
            return null;
        }
    }
    
    public  List<ABC_ProductMapper> getShoppingCartProducts(String contactId){
        List<OrderItem> orderItems = aBC_OrderRepositoryInstance.getOrderItemByOrder(getShoppingCart(contactId).Id);
        List<String> pricebookEntryIds = new List<String>();
        for(OrderItem orderItem : orderItems){
            pricebookEntryIds.add(orderItem.PricebookEntryId);
        }
         return productMapper.productObjectListToMapperList(aBC_ProductRepositoryInstance.getProductsPriceBookEntriesById(pricebookEntryIds));
    }

        public Map<String,PricebookEntry> mapProduct(){
           Map<String,PricebookEntry> productMap= new Map<String,PricebookEntry>();
            List<PricebookEntry> products = aBC_ProductRepositoryInstance.getAllOnlineProductsPriceBookEntries();
            for(PricebookEntry product : products){
                productMap.put(product.Product2.Name,product);
            }
            return productMap;
        }
    

}