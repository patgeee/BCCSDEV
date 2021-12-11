public class ProductInventoryBatch implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext pib){
        Integer yearToday = System.today().year(); //used to check the record's latest inventory year
        Integer monthToday = System.today().month() -1; //used to check the record's latest inventory month
        if(monthToday == 0){ 
            monthToday = 12; //sets the inventory month to 12 if the current month is 1 (January)
            yearToday = yearToday-1; //sets the inventroy year to 1 year earlier
        }
        String query = 'SELECT Id, Name, Product__c, Inventory_Month__c, Inventory_Year__c, Amount_Available__c, Warehouse__c FROM Product_Inventory__c WHERE Inventory_Month__c = '+monthToday+' AND Inventory_Year__c = '+yearToday;
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext pib, List<Product_Inventory__c> scope){
        List<Product_Inventory__c> insCloneList = new  List<Product_Inventory__c>();
        for(Product_Inventory__c prodInv : scope){
            Product_Inventory__c insClone = new Product_Inventory__c();
            insClone.Name = prodInv.Name;
            insClone.Inventory_Month__c = System.today().month();
            insClone.Inventory_Year__c = System.today().year();
            insClone.Warehouse__c = prodInv.Warehouse__c;
            insClone.Product__c = prodInv.Product__c;
            insClone.Amount_Available__c = prodInv.Amount_Available__c;
            insCloneList.add(insClone);  
        }
        insert insCloneList;
    }

    public void finish(Database.BatchableContext pib){
        
    }

}