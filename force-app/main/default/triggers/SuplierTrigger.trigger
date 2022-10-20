trigger SuplierTrigger on Supplier__c (before insert, before update) {
    if (trigger.isbefore && (trigger.isinsert || trigger.isupdate))
    {
        Set<id> IdSet = new Set<id>();
        for (Supplier__c newRecord : trigger.new){
            IdSet.add(newRecord.Good1__c);
         }
        List<Good1__c> goodList = [SELECT OrderGood__c FROM Good1__c WHERE Id IN: IdSet];
        Map<Id, Good1__c> goodMap = new Map <Id, Good1__c> (goodList);
        List<OrderGood__c> orderGoodListToUpdate = new List<OrderGood__c> ();
        for (Supplier__c newRecord : trigger.new){
            Good1__c good = goodMap.get(newRecord.Good1__c);
            orderGoodListToUpdate.add(new OrderGood__c(Id = good.OrderGood__c, Name_Supplier__c = newRecord.Name));
        }
        update orderGoodListToUpdate;
    }

}