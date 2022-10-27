public class SepplierTriggerHendler {
    public static void updateOlderAccounts(List<Supplier__c> newList, List<Supplier__c> oldList) {
        Set<id> IdSet = new Set<id>();
        if (newList != null) {
          for (Supplier__c newRecord : newList)
            {
                IdSet.add(newRecord.Good1__c);
             }  
        } else {
            for (Supplier__c oldRecord : oldList)
            {
                IdSet.add(oldRecord.Good1__c);
             }  
        }
        List<Good1__c> goodList = [SELECT OrderGood__c FROM Good1__c WHERE Id IN: IdSet];
        Set<Id> orderGoodIdSet = new Set<Id>();
        for (Good1__c good : goodList){
            orderGoodIdSet.add(good.OrderGood__c);
        }
        list<Supplier__c> supplierList = [SELECT Name, Good1__r.OrderGood__c FROM Supplier__c WHERE Good1__r.OrderGood__c IN: orderGoodIdSet AND Active__c = TRUE]; //Квери чайлдов
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
    
    public static void updateActivity(List<Supplier__c> newList, Map<Id, Supplier__c> oldMap) {
        for (Supplier__c newRecord : newList) {
            if (newRecord.Last_Delivery__c != null && newRecord.Last_Delivery__c != oldMap.get(newRecord.Id).Last_Delivery__c) {
                if (newRecord.Last_Delivery__c.addDays(30) < Date.today()){
                    newRecord.Active__c = False;
                } else {
                    newRecord.Active__c = true;
                }
            } else if (newRecord.Last_Delivery__c == null) {
                newRecord.Active__c = False;
            }
        }
    }
}