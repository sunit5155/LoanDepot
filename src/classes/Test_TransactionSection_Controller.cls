@isTest
public class Test_TransactionSection_Controller {
    
    
    @isTest
    public static void myTest(){
        MC_Settings__c objSetting = new MC_Settings__c(Name = 'MC Auth-1',ClientId__c='bemyues1u2mvck440asxfgth', ClientSecret__c='Qh25jPBDeLvUJ6di4VDb8AQH', ApiToken__c='7RK9zSjMIaglz3oyGsztLIeS');
		insert objSetting;
		    
        Date myDate = Date.newInstance(1960, 2, 17);
        Opportunity obj_Opportunity = new Opportunity(Name='abc',StageName ='Closed Won' , CloseDate= myDate);  
        Contact objContact = new Contact (FirstName='abc' , LastName='raara');
        insert objContact;
        insert obj_Opportunity;
        Transaction_Role__c obj = new Transaction_Role__c(Transaction__c = obj_Opportunity.Id , Role__c = 'Co-Borrower' ,	Contact__c = objContact.Id);
        insert obj;
        obj_Opportunity.Name = 'abcde';
        TransactionSection_Controller objTransactionSection_Controller = new TransactionSection_Controller();
        TransactionSection_Controller.getSectionDetails(obj_Opportunity.Id);
        TransactionSection_Controller.Save(obj_Opportunity);
    }
}