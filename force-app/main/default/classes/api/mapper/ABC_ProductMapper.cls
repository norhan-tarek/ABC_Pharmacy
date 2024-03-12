global class ABC_ProductMapper {

    String productName;
    Decimal unitPrice;
    String id;
    public ABC_ProductMapper() {

    }
    public ABC_ProductMapper productObjectToMapper(PricebookEntry product ){
        ABC_ProductMapper productMapper = new ABC_ProductMapper();
        productMapper.productName = product.Product2.Name;
        productMapper.unitPrice = product.UnitPrice;
        productMapper.id = product.Product2.Id;

        return productMapper; 
    }

        global  List<ABC_ProductMapper> productObjectListToMapperList(List<PricebookEntry> productObjectList){

        List<ABC_ProductMapper> mapperList = new List<ABC_ProductMapper>();

        for( PricebookEntry priceListEntery: productObjectList ){

            mapperList.add(productObjectToMapper(priceListEntery));
        }

        return mapperList;
      }
}