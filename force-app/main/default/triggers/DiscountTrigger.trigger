trigger DiscountTrigger on OrderGood__c (before insert, before update) {
    if (trigger.isbefore && (trigger.isinsert || trigger.isupdate)){
        for (OrderGood__c newRecord : trigger.new){
            if (newRecord.Discount__c>0.50){
                newRecord.Bypass_validation__c = true;
                
            }
            
        } 
    }
    
        
        
}