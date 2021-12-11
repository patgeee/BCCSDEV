public with sharing class NewDeliveryController {
    
    @AuraEnabled (cacheable=true)
    public static List<Warehouse__c> getWarehouse(){
        return [SELECT Id, Name FROM Warehouse__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Warehouse__c> getCompareFromWarehouse(Id searchKey){
        return[SELECT Id, Name FROM Warehouse__c WHERE Id != : searchKey];
    }

    @AuraEnabled(cacheable=true)
    public static List<Truck__c> getAvailableTruck(Id searchKey){
        return[SELECT Id, Name, Current_Location__r.Name, Status__c, Driver__r.Name FROM Truck__c WHERE Status__c = 'Parked' AND Current_Location__c = : searchKey];
 
    }

    @AuraEnabled(cacheable=false)
    public static void addDelivery(Id searchKey, Id toWarehouseKey, Id selectTruck, Id selectRoute){
        Truck__c getTrucks = [SELECT Id, Driver__c FROM Truck__c WHERE Id =: selectTruck LIMIT 1];
        
        Delivery__c addDeliveryIns = new Delivery__c();
        addDeliveryIns.Name = 'New Delivery';
        addDeliveryIns.From_Warehouse__c = searchKey;
        addDeliveryIns.To_Warehouse__c = toWarehouseKey;
        addDeliveryIns.Truck__c = getTrucks.Id;
        addDeliveryIns.Route__c = selectRoute;
        addDeliveryIns.Status__c = 'Parked';
        addDeliveryIns.Driver__c = getTrucks.Driver__c;
        system.debug(addDeliveryIns);
        insert addDeliveryIns;
    }

    @AuraEnabled(cacheable=true)
    public static List<Truck__c> getNotAvailaleTruck(Id searchKey){
        return[SELECT Id, Name, Current_Location__r.Name, Status__c, Driver__r.Name FROM Truck__c WHERE Status__c = 'On Delivery' AND Current_Location__c = : searchKey];
    }
    @AuraEnabled(cacheable=false)
    public static List<Product_Inventory__c> getProductInvetory(Id searchKey){
        Integer monthToday  = System.Today().month();
        Integer yearToday = System.Today().year();
        return[SELECT Id, Name, Amount_Available__c, Warehouse__c,Inventory_Month__c, Inventory_Year__c, Product__c FROM Product_Inventory__c WHERE Inventory_Month__c = : monthToday AND Inventory_Year__c = :yearToday AND Warehouse__c = : searchKey];
    }
    @AuraEnabled(cacheable=false)
    public static void addProductInventory(List<Product_Inventory__c> productInv, Id toWarehouseKey){
        Id toWarehouseId = toWarehouseKey;
        system.debug('Id' +toWarehouseId);
        List<Product_Inventory__c> insProdInvList = new List<Product_Inventory__c>();
        for(Product_Inventory__c prod : productInv){
            if(prod.Amount_Available__c > 0 && prod.Amount_Available__c != null){
                    Product_Inventory__c prodInv = new Product_Inventory__c();
                	prodInv.Name = prod.Name + 'Inventory';
                    prodInv.Product__c = prod.Product__c;
                    prodInv.Amount_Available__c = prod.Amount_Available__c;
                	prodInv.Warehouse__c = toWarehouseId;
                	prodInv.Inventory_Month__c = System.today().month();
                	prodInv.Inventory_Year__c = System.today().year();
                	insProdInvList.add(prodInv);
            }
        }
        insert insProdInvList;
        system.debug('insProdInvList' +insProdInvList);
    } 
    @AuraEnabled(cacheable=false)
    public static List<Route__c> getRoute(){
        return[SELECT Id, Name, Travel_Time__c FROM Route__c];
    }
    @AuraEnabled(cacheable=true)
    public static Route__c getTime(String selectRoute){
        return[SELECT Id, Name, Travel_Time__c FROM Route__c WHERE Id =: selectRoute LIMIT 1];
    }
}