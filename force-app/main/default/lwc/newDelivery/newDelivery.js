import { LightningElement, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

import getWarehouse from '@salesforce/apex/NewDeliveryController.getWarehouse';
import getCompareFromWarehouse from '@salesforce/apex/NewDeliveryController.getCompareFromWarehouse';
import getAvailableTrucks from '@salesforce/apex/NewDeliveryController.getAvailableTruck';
import getNotAvailaleTruck from '@salesforce/apex/NewDeliveryController.getNotAvailaleTruck';
import getProductInvetory from '@salesforce/apex/NewDeliveryController.getProductInvetory';
import addProductInventory from '@salesforce/apex/NewDeliveryController.addProductInventory';
import getRoute from '@salesforce/apex/NewDeliveryController.getRoute';
import getTime from '@salesforce/apex/NewDeliveryController.getTime';
import addDelivery from '@salesforce/apex/NewDeliveryController.addDelivery';

export default class NewDeliveryCmp extends LightningElement {
        
        selectOptions = [];
        toSelectOptions = [];
        routeSelectOptions = [];
        searchKey = '';
        availTrucks;
        notAvailTrucks;
        productInv;
        productInvPass;
        amountAvail = 0;
        key;
        displayAvailTrucks = false;
        displayProdInv = false;
        displayTime = false;
        mapToSend = {};
        isTest; 
        toWarehouseKey;
        selectRoute;
        getTimeResult;
        selectTruck;
        eta = 0;

    @wire(getWarehouse)
    lists({ error, data }) {
        if (data) {
            for(const list of data){
                const option = {
                    label: list.Name,
                    value: list.Id
                };
                this.selectOptions = [ ...this.selectOptions, option ];
            }
        } else if (error) {
            console.error(error);
        }

        console.log(data);
    }


    onSelectFromWarehouse(event){
        this.searchKey = event.target.value;

        getCompareFromWarehouse({searchKey : this.searchKey})
        .then (result => {
            for(const list of result){
                const toOption = {
                    label: list.Name,
                    value: list.Id
                };
                this.toSelectOptions = [ ...this.toSelectOptions, toOption ];

                console.log("From Warehouse Success");
                
            }
        })
        .catch(error => {
            this.error = error;

            console.log("Error");
        })

        getRoute({})
        .then (result => {
            for(const list of result){
                const routeOption = {
                    label: list.Name,
                    value: list.Id
                };
                this.routeSelectOptions = [ ...this.routeSelectOptions, routeOption ];

                console.log("Route Success" + this.routeSelectOptions);
                
            }
        })
        .catch(error => {
            this.error = error;

            console.log(this.error);
        })

        getAvailableTrucks({searchKey : this.searchKey})
        .then (result => {
            this.availTrucks = result;
            console.log(this.availTrucks);
        })
        .catch(error => {
            this.error = error;
            console.log('Show Truck Error' + error);
        })

        getNotAvailaleTruck({searchKey : this.searchKey})
        .then (result => {
            this.notAvailTrucks = result;
        })
        .catch(error => {
            this.error = error;
        })

    }

    onSelectRoute(event){
        this.selectRoute = event.target.value;

        getTime({selectRoute : this.selectRoute})
        .then (result => {
            this.getTimeResult = result;

            this.eta = this.getTimeResult.Travel_Time__c;
            console.log('getTimeResult' +this.getTimeResult.Travel_Time__c);
            this.displayTime = true;
        })
        .catch(error => {
            this.error = error;
            console.log(error);
        })
    }

    onSelectToWarehouse(event){
        this.toWarehouseKey = event.target.value;
    }

    showTrucks(event){
        console.log('showTruck Button Pressed');

        this.displayAvailTrucks = !this.displayAvailTrucks;
    }
    
    selectTruckEvent(event){

        console.log('selectTruck');

        var selectTruck = event.currentTarget.dataset.id;
        this.selectTruck = selectTruck;
        this.displayProdInv = true;

        console.log('selectTruck' +selectTruck);

        getProductInvetory({searchKey : this.searchKey})
        .then (result => {
            for(var i =0; i < result.length; i++){
                var prodInvPass = result[i];
                prodInvPass.Amount_Available__c = ''; 
            }
            this.productInv = result; 
        })
        .catch(error => {
            this.error = error;
        })
    }

    saveRecord(){

        console.log(this.productInv);

        addProductInventory({
            productInv : this.productInv,
            toWarehouseKey : this.toWarehouseKey  
        })
        .then (result => {
            console.log('Saving Data');

            const event = new ShowToastEvent({
                title: 'Delivery Record Saved!',
                message: 'Please see Delivery Tabs',
            });
            this.dispatchEvent(event);
        })
        .catch(error => {
            this.error = error;

            const event = new ShowToastEvent({
                title: 'Delivery Record didnt Save!',
                message: {error},
            });
            this.dispatchEvent(event);
        }) 
        
        console.log('searchKey - deliver' + this.searchKey);
        console.log('toWarehouseKey - deliver' +this.toWarehouseKey);
        console.log('selectTruck - deliver' +this.selectTruck);
        console.log('selectRoute - deliver' +this.selectRoute);
        
        addDelivery({
            searchKey : this.searchKey,
            toWarehouseKey : this.toWarehouseKey,
            selectTruck : this.selectTruck,
            selectRoute : this.selectRoute
        })
        .then(result => {
            console.log('Add Delivery');
        })
        .catch(error => {
            console.log(error);
        })


    }

    amountSaveRec(event){
       for (var i in this.productInv) {
        var prod = this.productInv[i];
        if (prod.Id == event.target.dataset.inputid) {
            prod.Amount_Available__c = event.target.value;
           break;
        }
      }

       console.log(this.productInv);
        
        

    }
} // end of js;