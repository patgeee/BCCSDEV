public class ProductSearchComponentController {
	
    @AuraEnabled
    public static List<Product_Item__c> getProductList(){
        return[SELECT Id, Name, Product_Code__c FROM Product_Item__c ORDER BY Product_Code__c ASC]; 
    }
    
    @AuraEnabled
    public static List<Product_Inventory__c> getSearch(String searchKey){

        String wildcard = '%'+ searchKey + '%';
        List<Product_Inventory__c> productInventory = [Select Id, Name, Product__r.Name, Product__r.Product_Code__c, Amount_available__c, Warehouse__r.Name from Product_Inventory__c 
                                                       where (Product__r.Name LIKE :wildcard OR Product__r.Product_Code__c LIKE :wildcard) 
                                                       AND Inventory_Month__c =:System.today().month() 
                                                       AND Inventory_Year__c =:System.today().year()];
        
        
        return productInventory; 
    }

    @AuraEnabled
    public static List <Warehouse__c> getWarehouseList(){
        return [SELECT Id, Name FROM Warehouse__c];
    }

    @AuraEnabled
    public static List <Product_Inventory__c> filterProdist(String searchKey, String selectedItem){

        string selectItem = selectedItem;
        String wildcard = '%'+ searchKey + '%';
        List<Product_Inventory__c> productInventory = [Select Id, Name, Product__r.Name, Product__r.Product_Code__c, Amount_available__c, Warehouse__r.Name from Product_Inventory__c 
                                                       where (Product__r.Name LIKE :wildcard OR Product__r.Product_Code__c LIKE :wildcard)
                                                       AND Warehouse__c = : selectItem
                                                       AND Inventory_Month__c =:System.today().month() 
                                                       AND Inventory_Year__c =:System.today().year()];

        return productInventory;
    }
}