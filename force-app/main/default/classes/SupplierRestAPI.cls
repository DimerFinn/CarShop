@RestResource(urlMapping='/Supplier/*')
global class SupplierRestAPI {
    
    /*
     *endpoint=/services/apexrest/Supplier?active=true&lastDelivery=2022-10-26
	*/
    @HttpGet 
    global static List<Supplier__c> getSuppliers () {
        Boolean active = Boolean.valueOf(RestContext.request.params.get('active'));
        Date lastDelivery = Date.valueOf(RestContext.request.params.get('lastDelivery')); //Запрос даты последней доставки
        return [SELECT Id, Name, Active__c, Good1__c, Last_Delivery__c FROM Supplier__c WHERE Active__c =: active AND Last_Delivery__c =: lastDelivery];
    }
    
    /*
     endpoint=/services/apexrest/Supplier
    body={
	"name":"SuppTest2",
	"lastDelivery":"2022-10-22",
	"goodId":"a077Q000004Pkl4QAC"
	}
	*/
    @HttpPost
    global static String createSupplier (String name, Date lastDelivery, String goodId) {
        Supplier__c supp = new Supplier__c (Name = name, Last_Delivery__c = lastDelivery, Good1__c = goodId);
        Database.insert (supp);
        return supp.Id;
    }
    
    /*
     endpoint=/services/apexrest/Supplier?supplierId=a087Q00000qMmqtQAC
	*/
    @HttpDelete
    global static void deleteSupplier () {
    	String supplierId = RestContext.request.params.get('supplierId');
        Database.delete (new Supplier__c (Id = supplierId));
    }
     /*
      endpoint=/services/apexrest/Supplier
     body={
	"name":"SuppTest2",
	"lastDelivery":"2022-10-22",
	"goodId":"a077Q000004Pkl4QAC",
	"supplierId":"a087Q00000qMmr8QAC"
	}
	*/    
    @HttpPut
    global static String updateSupplier (String name, Date lastDelivery, String goodId, String supplierId) {
        Supplier__c supp = new Supplier__c (Id=supplierId, Name = name, Last_Delivery__c = lastDelivery, Good1__c = goodId);
        Database.update (supp);
        return supp.Id;
    }

}