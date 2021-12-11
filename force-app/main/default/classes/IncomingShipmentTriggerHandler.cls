public class IncomingShipmentTriggerHandler {
    public static void onBeforeInsert(List<Incoming_Shipment__c> inShipList){
        Set<String> warehouseSet = new Set<String>(); //storage for incoming shipment record warehouse. Used for filter
        set<String> prodItemSet = new Set<String>(); //storage for incoming shipment record product. Used for filter
        Map<id, Incoming_Shipment__c> inShipMap = new Map<id, Incoming_Shipment__c>();
        for(Incoming_Shipment__c inShip : inShipList){
            warehouseSet.add(inShip.Warehouse__c); //adds warehouse to set
            prodItemSet.add(inShip.Product_Code__c); //adds product to set
        }
        
        List<Product_Item__c> prodItemList = [SELECT Id, Name, Product_Code__c FROM Product_Item__c WHERE Product_Code__c IN :prodItemSet];
        if(prodItemList.size() > 0){
            for(Incoming_Shipment__c inShip : inShipList){
                Boolean error = true;
                for(Product_Item__c prodItem : prodItemList){
                    if(prodItem.Product_Code__c == inShip.Product_Code__c){ //checks if the product code in the incoming shipment exists in the db
                        inShipMap.put(prodItem.Id, inShip); //puts the incoming record in a map with the product Id as the key
                        error = false;
                    }
                }
                if(error){
                    inShip.addError('Not a Valid Product Code.');
                }
            }
            
            List<Product_Inventory__c> prodInvList = [SELECT Id, Name, Warehouse__c, Inventory_Month__c, Inventory_Year__c, Product__c, Amount_Available__c 
                                                      FROM Product_Inventory__c 
                                                      WHERE Warehouse__c IN :warehouseSet 
                                                      AND Product__c IN :inShipMap.keySet()
                                                      AND Inventory_Month__c = :System.Today().month()
                                                      AND Inventory_Year__c = :System.Today().year()];
            
            if(prodInvList.size() > 0){ //checks if there is any product inventory record present
                for(Incoming_Shipment__c inShip : inShipList){
                    Boolean error = true;
                    for(Product_Inventory__c prodInv : prodInvList){
                        if(prodInv.Warehouse__c == inShip.Warehouse__c && inShip.Product_Code__c == inShipMap.get(prodInv.Product__c).Product_Code__c){
                            prodInv.Amount_Available__c = prodInv.Amount_Available__c + inShip.Count__c;
                            error =  false;
                        }
                    }
                    if(error){
                        inShip.addError('No Product Inventory Record Found.');
                    }
                }
                
                update prodInvList;
                
            }else{
                for(Incoming_Shipment__c inShip : inShipList){
                    inShip.addError('No Product Inventory Record Found.');
                }
            }
        }else{
            for(Incoming_Shipment__c inShip : inShipList){
                inShip.addError('Not a Valid Product Code.');
            }
        }
    }//end of method
}//end of handler