public class NewProductController {
    
    @AuraEnabled
    public static void saveProduct(Product_Item__c prodItem, Map<Id, Integer> mapToSend, List<Warehouse__c> wareHouseList){

        insert prodItem;
        
        List<Product_Inventory__c> insProdInvList = new List<Product_Inventory__c>();
        for(Warehouse__c whRec : wareHouseList){
            if(mapToSend.get(whRec.Id) > 0){
                Product_Inventory__c pic = new Product_Inventory__c();
                	pic.Name = prodItem.Name + ' ' + whRec.Name + ' Inventory';
                    pic.Product__c = prodItem.Id;
                    pic.Amount_Available__c = mapToSend.get(whRec.Id);
                	pic.Warehouse__c = whRec.Id;
                	pic.Inventory_Month__c = System.today().month();
                	pic.Inventory_Year__c = System.today().year();
                	insProdInvList.add(pic);
            }
        }
        
        insert insProdInvList;
    }
    
    @AuraEnabled
    public static List<Warehouse__c> queryWarehouse(){
        return [SELECT Id, Name FROM Warehouse__c ORDER BY Name ASC];
    }
}