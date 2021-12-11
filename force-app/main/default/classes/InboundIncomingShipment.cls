@RestResource(urlMapping='/InboundIncomingShipment')
global class InboundIncomingShipment {

    @HttpPost
    global static void doPost(){
        
        String inShipWrapper = RestContext.request.requestBody.toString();

        inShipWrapper isw = (inShipWrapper) Json.deserialize(inShipWrapper, inShipWrapper.class);
        
        try{
            
            Warehouse__c wareHouseRec = [SELECT Id, Name, Warehouse_Code__c FROM Warehouse__c WHERE Warehouse_Code__c = :isw.WarehouseCode LIMIT 1];
            
            Product_Item__c productRec = [SELECT Id, Name, Product_Code__c FROM Product_Item__c WHERE Product_Code__c = :isw.ProductCode LIMIT 1];
            
            
            Incoming_Shipment__c is = new Incoming_Shipment__c();
            is.Product_Code__c = isw.ProductCode;
            is.Warehouse__c = wareHouseRec.Id;
            is.Count__c = isw.Amount;
            
            insert is;
            RestContext.response.responseBody = Blob.valueof('This Incoming Shipment is inserted with Id: '+ is.Id);
        }
        
        catch (Exception e){
            RestContext.response.responseBody = Blob.valueof('Invalid Incoming Shipment parameters.');
        }


        }

    public class InShipWrapper {
        public String ProductCode;
        public String WarehouseCode;
        public Integer Amount;

    }

}