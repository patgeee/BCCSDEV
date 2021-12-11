({
	queryProducts : function(component, event, helper) {
		console.log('Helper Query Products'); 
        
        var getProducts = component.get("c.getProductList"); 
        getProducts.setCallback(this, function(ret){
            if(ret.getState() == "SUCCESS"){
                var retVal = ret.getReturnValue();
                
                component.set("v.productList", retVal);
                console.log(retVal);
            }
            else {
                console.log("Error");
            }
        });
        $A.enqueueAction(getProducts);
        
	},
    
    querySearch : function(component, event, helper) {
        console.log('querySearch');
        
        var wildcard = component.get("c.getSearch"); 
        wildcard.setParams({
            searchKey : component.get("v.searchKey") 
        });
        wildcard.setCallback(this,function(ret) {
            if(ret.getState() == "SUCCESS"){
                var retValue = ret.getReturnValue();
                component.set("v.proList",retValue);
                component.set("v.isSearchKey",false);
            } else{
                //error
            }
        });
        $A.enqueueAction(wildcard);     
        
    },
    queryWarehouse : function(component, event, helper) {

        var getWarehouse = component.get("c.getWarehouseList"); 
        getWarehouse.setCallback(this, function(ret){
            if(ret.getState() == "SUCCESS"){
                var retVal = ret.getReturnValue();
                
                component.set("v.warehouseList", retVal);
                console.log(retVal);
            }
            else {
                console.log("Error");
            }
        });
        $A.enqueueAction(getWarehouse);
    },

    filterSearch : function(component, event, helper, selectedItem) {
        console.log("filterSearch");
        var wildcard = component.get("c.filterProdist"); 
        wildcard.setParams({
            searchKey : component.get("v.searchKey"),
            selectedItem : selectedItem
        });
        wildcard.setCallback(this,function(ret) {
            if(ret.getState() == "SUCCESS"){
                console.log("filterSearch success");
                var retValue = ret.getReturnValue();
                component.set("v.proList",retValue);
                component.set("v.isSearchKey",false);
            } else{
                //error
            }
        });
        $A.enqueueAction(wildcard);           

    }
})