trigger SuplierTrigger on Supplier__c (after insert, after update, after delete, before insert, before update) {
    if (trigger.isafter && (trigger.isinsert || trigger.isupdate))
    {
        if (trigger.isdelete) {
            SepplierTriggerHendler.updateOlderAccounts(JSON.serialize(trigger.new), JSON.serialize(trigger.oldMap));
        }
            SepplierTriggerHendler.upsertPost(trigger.new, trigger.oldMap);
    }
    if (trigger.isbefore && (trigger.isinsert || trigger.isupdate)) {
        SepplierTriggerHendler.updateActivity(JSON.serialize(trigger.new), JSON.serialize(trigger.oldMap));
    }
}