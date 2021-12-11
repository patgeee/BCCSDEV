({
	onInit : function(component, event, helper) {
		helper.queryProducts(component, event, helper); 
		helper.queryWarehouse(component, event, helper);
		component.set("v.isSearchKey",true);
		component.set("v.searchKey",null);

	},
    onclickSearch : function(component, event, helper){
    	helper.querySearch(component, event, helper);
	},
	onchangeFilter : function(component, event, helper){

		var selectedItem = event.getSource().get("v.value");
	    console.log(selectedItem);

		helper.filterSearch(component, event, helper, selectedItem);
	}
    
})