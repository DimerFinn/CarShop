public class CommentController implements Queueable, Database.AllowsCallouts{
	public void execute(QueueableContext context) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:Post/comments');
        HttpResponse response = http.send(request);
        List<CommentWrapper> commentWrapperList = (List<CommentWrapper>)JSON.deserialize(response.getBody(), List<CommentWrapper>.class);
        List<Comment__c> commentList = new List<Comment__c>();
        	for (CommentWrapper commWr : commentWrapperList) {
            commentList.add(new Comment__c(Title__c = commWr.name, Body__c = commWr.body, Post_Id__c = commWr.postId, Email__c = commWr.email, Comment_Id__c = commWr.Id));
        }
        DataBase.upsert(commentList, Comment__c.Fields.Comment_Id__c);
    }
    
	public class CommentWrapper {
        Integer postId;
    	String name;
    	String email;
        String body;
    	Integer id;
        
        public CommentWrapper (String name, String email, String body, Integer postId) {
            this.name = name;
            this.email = email;
            this.body = body;
            this.postId = postId;
        }
    }
}