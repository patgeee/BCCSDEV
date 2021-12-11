public class ProductInventorySchedulable implements Schedulable {
    public void execute(SchedulableContext SC){
        ProductInventoryBatch pib = new ProductInventoryBatch();
            Database.executeBatch(pib);
    }
}