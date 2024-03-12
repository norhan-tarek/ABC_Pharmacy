public class ABC_OrderRepository {
    private static ABC_OrderRepository instance = null;

    private ABC_OrderRepository() {

    }
    public static ABC_OrderRepository getInstance() {
        if (instance == null) {
          instance = new ABC_OrderRepository();
        }
        return instance;
      }

      public List<Order> getOrderByContactAndStatus(String contact, String status){
        return [
            SELECT
            Name,
            AccountId,
            Contact_abc__c,
            Pricebook2Id	
            FROM Order
            WHERE Contact_abc__c =:contact
            AND Status =:status
          ];
    }
    public List<OrderItem> getOrderItemByOrder(String order){
        return [
            SELECT
            Product2.Name,
            Quantity,
            TotalPrice,
            PricebookEntryId,
            UnitPrice	
            FROM  OrderItem
            WHERE OrderId =:order
          ];
    }
    public List<OrderItem> getOrdersItemByOrder(List<String> order){
        return [
            SELECT
            Product2.Name,
            Quantity,
            TotalPrice,
            OrderId,
            ListPrice,
            PricebookEntryId,
            UnitPrice	
            FROM  OrderItem
            WHERE OrderId in:order
          ];
    }

}