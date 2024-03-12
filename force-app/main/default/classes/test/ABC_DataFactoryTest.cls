public class ABC_DataFactoryTest {
 private static ABC_DataFactoryTest instance;
    private ABC_DataFactoryTest() {

    }


    public static ABC_DataFactoryTest getInstance(){
        if(instance == null){
            instance = new ABC_DataFactoryTest();
        }
        return instance;
    }

    public Account CreateAccount(String firstName, String lastName){
        Account account = new Account(
            Name = firstName + '  ' + lastName,
            Type= 'Prospect');
        insert account;
        return account;
    } 
    public Contact CreateContact(String firstName, String lastName, String email, String accountId){
        Contact contact = new Contact( 
            FirstName=firstName,
            LastName=lastName,
            AccountId=accountId,
            Email=email
            );
        insert contact;
        return contact;
    } 
    public Pricebook2 CreatePricebook(String name){
        Pricebook2 pricebook = new Pricebook2(
            Name=name,
            IsActive = true
        );
        insert pricebook;
        return pricebook;
    }
    public Order CreateOrder(String contactId, String accountId , String pricebookId , Date effectiveDate, String status){

        Order order = new Order(
            Contact_abc__c = contactId,
            AccountId = accountId,
            Pricebook2Id = pricebookId,
            EffectiveDate = effectiveDate,
            Status=status
        );
        insert order;
        return order;
    }
    public PricebookEntry CreatePricebookEntry(String name, String pricebookId){
        Product2 product = [select Id from Product2 where Name =:name];
        PricebookEntry pricebookEntry = new PricebookEntry(
            Product2Id = product.Id,
            UnitPrice = 10,
            Pricebook2Id = pricebookId
        );
        insert pricebookEntry;
        return PricebookEntry;
    }

    public OrderItem CreateOrderItem( String orderId , PricebookEntry pricebookEntry){

           OrderItem orderItem = new OrderItem(
            OrderId = orderId,
            Product2Id = pricebookEntry.Product2.Id,
            PricebookEntryId =pricebookEntry.Id,
            UnitPrice =pricebookEntry.UnitPrice,
            Quantity =2
        );
        insert orderItem;
        return orderItem;
    }



}