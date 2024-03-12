public  class ABC_ContactRepository {
    private static ABC_ContactRepository instance = null;

    private ABC_ContactRepository() {

    }
    public static ABC_ContactRepository getInstance() {
        if (instance == null) {
          instance = new ABC_ContactRepository();
        }
        return instance;
      }

      public Contact getContactById(String id){
        return [
            SELECT
            Name,
            Id,
            AccountId
            FROM Contact
            WHERE Id =:id
          ];
    }
}