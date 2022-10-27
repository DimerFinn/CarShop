global class OrderGoodScheduler implements Schedulable {
	global void execute(SchedulableContext sc)
     {
     	MyBatchClass myBatchObject = new MyBatchClass(); 
		Id batchId = Database.executeBatch(myBatchObject);
     }
}