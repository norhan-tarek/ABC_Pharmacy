public class ABC_ProductRepository {
    private static ABC_ProductRepository instance = null;

    private ABC_ProductRepository() {

    }
    public static ABC_ProductRepository getInstance() {
        if (instance == null) {
          instance = new ABC_ProductRepository();
        }
        return instance;
      }

    public List<PricebookEntry> getAllOnlineProductsPriceBookEntries(){
        return [
            SELECT
            Name,
            Id,
            Product2.Name,
            Product2.Id,
            Product2.QuantityUnitOfMeasure,
            Product2.StockKeepingUnit,
            Product2.Type,
            UnitPrice	
            FROM PricebookEntry
            WHERE Pricebook2.Name ='Online Pharmacy Pricebook'
          ];
    }    
    public List<PricebookEntry> getProductsPriceBookEntriesById(List<String> ids){
        return [
            SELECT
            Name,
            Id,
            Product2.Name,
            Product2.Id,
            Product2.QuantityUnitOfMeasure,
            Product2.StockKeepingUnit,
            Product2.Type,
            UnitPrice	
            FROM PricebookEntry
            WHERE Id in:ids
          ];
    }
   
    public Pricebook2 getOnlinePriceBook(){
        return [
            SELECT
            Name,
            Id
            FROM Pricebook2
            WHERE Pricebook2.Name ='Online Pharmacy Pricebook'
          ];

    }
}