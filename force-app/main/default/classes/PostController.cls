public class PostController implements Queueable, Database.AllowsCallouts{
	public void execute(QueueableContext context) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        HttpResponse response = http.send(request);
        List<PostWrapper> postWrapperList = (List<PostWrapper>)JSON.deserialize(response.getBody(), List<PostWrapper>.class);
        List<Post__c> postList = new List<Post__c>();
        	for (PostWrapper postWr : postWrapperList) {
            postList.add(new Post__c(Title__c = postWr.title, Body__c = postWr.body, AuthorId__c = postWr.userId, PostId__c = postWr.id));
                
        }
        DataBase.upsert(postList, Post__c.Fields.PostId__c);
    }
public class PostWrapper {
        Integer userId;
    	String title;
    	String body;
    	Integer id;
    public PostWrapper (integer userId, string title, string body) {
        this.userId = userId;
        this.title = title;
        this.body = body;
        
    }
    }
}