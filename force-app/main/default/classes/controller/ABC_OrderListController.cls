public class ABC_OrderListController {
    public List<Order> orders {get; set;}
    public Map<String, List<OrderItem>> orderItemsMap{get; set;}
    public Map<String, String> orderIconMap{get; set;}
    public Date dateCheck { get { return Date.today(); }}
 

    public ABC_OrderListController() {
      orders = [SELECT Id,OrderNumber, Name, toLabel(Status), EffectiveDate FROM Order];
      List<String> ordersId = new List<String>();
      for(Order order : orders){
        ordersId.add(order.Id);
        
      }

      List<OrderItem> orderItems = [SELECT Id, Quantity, UnitPrice,Product2.Name,OrderId FROM OrderItem WHERE OrderId=:ordersId];
      orderItemsMap = new Map<String, List<OrderItem>>();
      orderIconMap = new Map<String, String>();
      for(Order order : orders){

    
       if(order.Status == 'In delivery'){
            orderIconMap.put(order.Id, '/resource/ABC_InDelivery');

    
        }else if(order.Status == 'Delivered'){
            orderIconMap.put(order.Id, '/resource/ABC_Delivered');

    
        }else if( order.EffectiveDate==Date.today()){
            orderIconMap.put(order.Id, '/resource/ABC_CreatedToday');

        }else{
            orderIconMap.put(order.Id, '/resource/ABC_CreatedMoreThanDayAgo');
        }

        

        List<OrderItem> releatedOrderItems =new List<OrderItem>();
        orderItemsMap.put(order.Id, releatedOrderItems);
        for(OrderItem item : orderItems){
            if(item.OrderId == order.Id){
                releatedOrderItems=orderItemsMap.get(order.Id);
                releatedOrderItems.add(item);
                orderItemsMap.put(order.Id,releatedOrderItems);
            }
        }
      }

    }
}