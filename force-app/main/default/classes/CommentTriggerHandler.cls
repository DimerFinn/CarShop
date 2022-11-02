public class CommentTriggerHandler {
    
    public static void updatePostLookup(List<Comment__c> newList, Map<Id, Comment__c> oldMap){
        Set<Decimal> postIdSet = new Set<Decimal>();
        List<Comment__c> commList = new List<Comment__c>();
        
        for(Comment__c com : newList){
            if(oldMap == null || com.Post_Id__c != oldMap.get(com.Id).Post_Id__c){
                postIdSet.add(com.Post_Id__c);
                commList.add(com);
            }
        }
        
        List<Post__c> postList = [SELECT Id,PostId__c FROM Post__c WHERE PostId__c IN: postIdSet];

        Map<String,Id> postMap = new Map<String,Id>();
        
        for(Post__c post : postList){
            postMap.put(String.valueOf(post.PostId__c), post.Id);
        }

        for(Comment__c comm : commList){
            comm.Post__c = postMap.get(String.valueOf(comm.Post_Id__c));
        }
    }

}