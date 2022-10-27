trigger SuplierTrigger on Supplier__c (after insert, after update, after delete, before insert, before update) {
    if (trigger.isafter && (trigger.isinsert || trigger.isupdate || trigger.isdelete))
    {
       SepplierTriggerHendler.updateOlderAccounts(trigger.new, trigger.old);
    }
    if (trigger.isbefore && (trigger.isinsert || trigger.isupdate)) {
        SepplierTriggerHendler.updateActivity(trigger.new, trigger.oldMap);
    }
}