trigger SuplierTrigger on Supplier__c (after insert, after update, after delete) {
    if (trigger.isafter && (trigger.isinsert || trigger.isupdate || trigger.isdelete))
    {
       SepplierTriggerHendler.updateOlderAccounts(trigger.new, trigger.old);
    }
}