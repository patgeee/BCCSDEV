trigger DeliveryTrigger on Delivery__c (after update) {
    if(trigger.isUpdate && trigger.isAfter){
        DeliveryTriggerHandler.onDeliveryChange(trigger.new);
    }
}