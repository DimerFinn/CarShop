trigger CommentTrigger on Comment__c (before insert, before update) {
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        CommentTriggerHandler.updatePostLookup(trigger.new, trigger.oldMap);
    }
}