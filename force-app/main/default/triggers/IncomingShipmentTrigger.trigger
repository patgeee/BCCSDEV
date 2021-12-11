trigger IncomingShipmentTrigger on Incoming_Shipment__c ( before insert) {
    if(trigger.IsInsert && trigger.IsBefore){
        IncomingShipmentTriggerHandler.onBeforeInsert(Trigger.new);
    }
    
}