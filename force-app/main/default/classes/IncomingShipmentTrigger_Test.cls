@isTest
public class IncomingShipmentTrigger_Test {

    @isTest 
    private static void onBeforeInsert(){
        
        Test.startTest();
        Incoming_Shipment__c isc = new Incoming_Shipment__c();

        isc.Count__c = 2;
        isc.Warehouse__c = 'WH00000001';
        isc.Product_Code__c = 'PROD000001';
        
        insert isc;
        Test.stopTest();
        	
        Product_Inventory__c picRec = [SELECT Id, Name, Warehouse__c, Amount_Available__c, Inventory_Month__c, Inventory_Year__c, Product__c FROM Product_Inventory__c LIMIT 1];
        System.assertEquals(picRec.Warehouse__c, isc.Warehouse__c, 'No Product Inventory Record Found.');
    
    }//end of test method oonBeforeInsert()
    
}//end of test class