public class DeliveryTriggerhandler {
    public static void onDeliveryChange(List<Delivery__c> deliList) {
        Set<Id> truckSet = new Set<Id>();//storage list for record trucks. Used for filtering
        List<Delivery__c> newDeliList = new List<Delivery__c>();
        for(Delivery__c deliItem : deliList){
            truckSet.add(deliItem.Truck__c);
            newDeliList.add(deliItem);
        }

        List<Truck__c> truckList = [SELECT Id, Name, Current_Location__c, Status__c FROM Truck__c WHERE Id IN :truckSet];
        //query for trucks with the same id as the current delivery record

        if(truckList.size() > 0){
            List<Truck__c> updTruckList = new List<Truck__c>(); //storage for truck update
            for(Delivery__c newDeliItem : newDeliList){ 
                for(Truck__c truckItem : truckList){
                    if(newDeliItem.Truck__c == truckItem.Id){
                        if(newDeliItem.Status__c == 'Parked' || newDeliItem.Status__c == 'En-route'){
                            truckItem.Status__c = 'On Delivery';
                            updTruckList.add(truckItem);
                        }
                        else{
                            system.debug('else');
                            truckItem.Status__c = 'Parked';
                            truckItem.Current_Location__c = newDeliItem.To_Warehouse__c;
                            updTruckList.add(truckItem);
                        }
                    }

                }
                update updTruckList;
            }
        }
        
    }//end of onDeliveryChange
}//end of handler