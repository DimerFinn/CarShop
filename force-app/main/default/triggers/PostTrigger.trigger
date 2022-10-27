trigger PostTrigger on Post__c (before insert) {
    if (trigger.isBefore && trigger.isInsert) {
        PostTriggerHandler.createPost(JSON.serialize(trigger.new));
    }
}