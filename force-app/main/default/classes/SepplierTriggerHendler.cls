public class SepplierTriggerHendler {
    @future
    public static void updateOlderAccounts(String newListStr, String oldMapStr) {
        List<Supplier__c> newList =(List<Supplier__c>) JSON.deserialize(newListStr, List<Supplier__c>.class);
        Map<Id,Supplier__c> oldMap =(Map<Id,Supplier__c>) JSON.deserialize(oldMapStr, Map<Id,Supplier__c>.class);
        Set<id> IdSet = new Set<id>();
        if (newList != null) {
          for (Supplier__c newRecord : newList)
            {
                if (oldMap == null || newRecord.Active__c != oldMap.get(newRecord.Id).Active__c) {  //Отсеял поля Актив которые не поменялись
                    IdSet.add(newRecord.Good1__c);}
             }  
        } else {
            for (Supplier__c oldRecord : oldMap.values())
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
        Map<Id, String> orderGoodNameMap = new Map<Id, String>();
        	for (Supplier__c sup : supplierList) {
            	orderGoodNameMap.put(sup.Good1__r.OrderGood__c, orderGoodNameMap.get(sup.Good1__r.OrderGood__c) + ' ' + sup.Name);
        }
        List<OrderGood__c> orderGoodListToUpdate = new List<OrderGood__c> ();
        for (Id key : orderGoodNameMap.keySet()){
            
            orderGoodListToUpdate.add(new OrderGood__c(Id = key, Name_Supplier__c = orderGoodNameMap.get(key).remove('null')));
        }
        update orderGoodListToUpdate;
    }
    @future
    public static void updateActivity(String newListStr,String oldMapStr) {
        List<Supplier__c> newList =(List<Supplier__c>) JSON.deserialize(newListStr, List<Supplier__c>.class);
        Map<id, Supplier__c> oldMap =(Map<id, Supplier__c>) JSON.deserialize(oldMapStr, Map<id, Supplier__c>.class);
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
    public static void upsertPost (List<Supplier__c> newList, Map<id, Supplier__c> oldMap) {
        Boolean createPost = false;
        for (Supplier__c newRecord : newList) {
            if (newRecord.Last_Delivery__c !=null && (oldMap == null || newRecord.Last_Delivery__c != oldMap.get(newRecord.Id).Last_Delivery__c)) {
                createPost = true;
            }
        }
        if (createPost) {
            ID jobID = System.enqueueJob(new PostController());
        }
    }
        
}