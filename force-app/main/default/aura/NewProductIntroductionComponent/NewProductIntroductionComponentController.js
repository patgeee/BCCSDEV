({
	onClickSave : function(component, event, helper) {
		console.log('onClickSave clicked');

            var saveProduct = component.get("c.saveProduct")
            var prodItem = component.get("v.prodItem");
        	var wareHouseList = component.get("v.warehouseList");
            
			if(prodItem.Name != null && prodItem.Product_Code__c != null){
                
                var mapToSend = {};
                for(var i =0; i < wareHouseList.length; i++){
                    var wh = wareHouseList[i];
                    mapToSend[wh.Id] = wh.invCount;
                }

            saveProduct.setParams({
                prodItem: prodItem, 
                mapToSend: mapToSend,
                wareHouseList: wareHouseList
            });
            
            saveProduct.setCallback(this,function(ret){
                if(ret.getState() == 'SUCCESS'){
                    console.log('Success');
                   	
                }
                else{
                    console.log('Success not');
                }
            });
            
            $A.enqueueAction(saveProduct);

            }else{
                console.log('error input save');
            }
    },
    
    onClickClear : function(component, event, helper) {
        component.set("v.prodItem", "{}");
	},
    
    onClickCancel: function(component, event, helper) {
        component.set("v.isAddForm", false);
	},
    
    onClickAdd : function(component, event, helper) {
    	component.set("v.isAddForm", true);
        
        var queryWarehouse = component.get("c.queryWarehouse")
        queryWarehouse.setCallback(this, function(ret){
            if(ret.getState() == "SUCCESS"){
                var retVals = ret.getReturnValue();
                
                for(var i = 0; i < retVals.length; i++){
                    var retVal = retVals[i];
                    retVal.invCount = 0;
                }
                
                component.set("v.warehouseList", retVals);
                console.log(retVals);
            }
            else {
                console.log("Error");
            }
        });
        $A.enqueueAction(queryWarehouse);
        
        
	}
    	
})