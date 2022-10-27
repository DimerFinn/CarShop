public class PostTriggerHandler {
    @future (callout=true)
    public static void createPost (String newListStr) {
        List<Post__c> newList = (List<Post__c>) JSON.deserialize(newListStr, List<Post__c>.class);
        List<PostController.PostWrapper> postWrList = new List<PostController.PostWrapper>();
        for (Post__c post : newList) {
            postWrList.add (new PostController.PostWrapper (Integer.valueOf(post.AuthorId__c), post.Title__c, post.Body__c));
        }
        String body = JSON.serialize(postWrList);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json; charset=UTF-8');
        request.setBody (body);
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        HttpResponse response = http.send(request);
        system.debug(response.getBody());
    }
}