public class MyBatchClass implements Schedulable, Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM OrderGood__c]);
       
    }
    public void execute(SchedulableContext sc)
     {
     	MyBatchClass myBatchObject = new MyBatchClass(); 
		Id batchId = Database.executeBatch(myBatchObject);
     }
    public void execute(Database.BatchableContext bc, List<OrderGood__c> records){
        list<Supplier__c> supplierList = [SELECT Name, Good1__r.OrderGood__c FROM Supplier__c WHERE Good1__r.OrderGood__c IN: records AND Active__c = TRUE]; //Квери чайлдов
        Map<Id, list<Supplier__c>> mapSupplier = new Map<Id, list<Supplier__c>>();
        for (Supplier__c sup : supplierList) {
            if (mapSupplier.get(sup.Good1__r.OrderGood__c) != null) {
                list<Supplier__c> supList = mapSupplier.get(sup.Good1__r.OrderGood__c);
                supList.add(sup);
                mapSupplier.put(sup.Good1__r.OrderGood__c,supList);
            } else {
                mapSupplier.put(sup.Good1__r.OrderGood__c, new List<Supplier__c> {sup}); //мапа хранит значения каждого деда
            }
        }
        List<OrderGood__c> orderGoodListToUpdate = new List<OrderGood__c> ();
        for (Id key : mapSupplier.keySet()){
            list<Supplier__c> supList = mapSupplier.get(key);
            String nameString = '';
            for (Supplier__c sup : supList) {
                nameString += ' ' + sup.Name;
            }
            orderGoodListToUpdate.add(new OrderGood__c(Id = key, Name_Supplier__c = nameString));
        }
        update orderGoodListToUpdate;
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
}