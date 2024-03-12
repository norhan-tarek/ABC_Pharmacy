public class ABC_OrderArchiveBatch implements Database.Batchable<SObject>, Database.Stateful{
   
  ABC_OrderRepository aBC_OrderRepositoryInstance=ABC_OrderRepository.getInstance();
    public ABC_OrderArchiveBatch() {
    }


  public Database.QueryLocator start(Database.BatchableContext bc) {
    // collect the batches of records or objects to be passed to execute
    return Database.getQueryLocator(
      [
        SELECT
         Id,
         Name,
         Contact_abc__c,
         OrderNumber,
         EffectiveDate
         FROM Order
         WHERE Status=:'ABC_Delivered'
         AND EffectiveDate <=: (Date.Today().addYears(-1))
      ]
    );
  }
  public void execute(Database.BatchableContext bc, List<Order> orders) {

    List<Order_History_abc__b> ordersHistory = new List<Order_History_abc__b>();
    List<String> ordersId = new List<String>();
    for(Order order: orders){
      ordersId.add(order.Id);
      Order_History_abc__b orderHistory = new Order_History_abc__b();
      orderHistory.Contact_abc__c = order.Contact_abc__c;
      orderHistory.Order_Number_abc__c = order.OrderNumber;
      orderHistory.Order_Start_Date_abc__c = order.EffectiveDate;
      orderHistory.Id_abc__c = order.Id;
      ordersHistory.add(orderHistory);
    }
    List<OrderItem> orderItems=aBC_OrderRepositoryInstance.getOrdersItemByOrder(ordersId);
    List<OrderItem_History_abc__b> orderItemsHistory = new List<OrderItem_History_abc__b>();
    for(OrderItem orderItem:orderItems){
      OrderItem_History_abc__b orderItemHistory= new OrderItem_History_abc__b();
      orderItemHistory.Order_abc__c = orderItem.OrderId;
      orderItemHistory.Product_abc__c = orderItem.Product2Id;
      orderItemHistory.Id_abc__c = orderItem.Id;
      orderItemHistory.ListPrice_abc__c = orderItem.ListPrice;
      orderItemHistory.TotalPrice_abc__c = orderItem.TotalPrice;
      orderItemHistory.UnitPrice_abc__c = orderItem.UnitPrice;
      orderItemHistory.Quantity_abc__c = orderItem.Quantity;
      orderItemsHistory.add(orderItemHistory);
    }
    if(!Test.isRunningTest()){
   try{ 
    Database.InsertAsync(ordersHistory);
   }catch (DmlException e) {
      System.debug('Error inserting order: ' + e.getMessage());
    }
    try{
    Database.InsertAsync(orderItemsHistory);
    }catch (DmlException e) {
      System.debug('Error inserting order items: ' + e.getMessage());
    }
  }
    delete orderItems;
    delete orders;
  }
  public void finish(Database.BatchableContext bc) {
    // execute any post-processing operations

    // call some utility to send email
  }
}