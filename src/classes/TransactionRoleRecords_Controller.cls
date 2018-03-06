public class TransactionRoleRecords_Controller {
    
    /***
        * Name         : getContactDetails
        * Params       : recId
        * Description  : Used to retrieve all informations
    ***/
    @AuraEnabled
    public static MainWrapper getContactDetails(String recId , String filter , String FieldSetName ,String sortOrder , String sortingField , String numberOfRecord){ 
        Set<String> setFieldsToQuery = new set<String>();   
        list <FieldInfoWrapper> lstWrapper =new list <FieldInfoWrapper>();
        list <Schema.FieldSetMember> lstFieldSet = new list<Schema.FieldSetMember>(readFieldSet(FieldSetName , 'Transaction_Role__c'));    
        if(sortingField == null) {
            sortingField = lstFieldSet[0].getFieldPath();
        }
        
        for(Schema.FieldSetMember obj : lstFieldSet ) {  
          setFieldsToQuery.add(obj.getFieldPath());  
          lstWrapper.add(new FieldInfoWrapper(obj.getFieldPath(), obj.getLabel(),  string.valueOf(obj.getType()) ));  
        } 

        list<SObject> lstSObject;
        String sobjectType = Id.valueOf(recId).getSObjectType().getDescribe().getName();
        
        //set<Id> setOfTransactions = new set<Id>();
        if(sobjectType == 'Contact'){
        	lstSObject = getContactsOnContactPage(recId, setFieldsToQuery, filter, sortOrder, sortingField, numberOfRecord);
        }else if(sobjectType == 'Opportunity'){
        	lstSObject = getContactsOnTransactionPage(recId, setFieldsToQuery, filter, sortOrder, sortingField, numberOfRecord);   
        }
        
        MainWrapper objWrapper = new MainWrapper(lstWrapper, lstSObject);
        return objWrapper;
    }
    
    private static list<SObject> getContactsOnContactPage(String recId, Set<String> setFieldsToQuery, 
    													String filter, String sortOrder, 
    													String sortingField, String numberOfRecord){
        set<Id> setOfRecords = new set<Id>();
        Transaction_Role__c[] roles = [SELECT Transaction__c FROM Transaction_Role__c WHERE Contact__c = :recId] ;
        
        for(Transaction_Role__c obj : roles ) {
            setOfRecords.add(obj.Transaction__c);
        }
        
        string queryString;
	    queryString = 'Select ';
        queryString += String.join( new List<String>(setFieldsToQuery), ',');
        queryString.removeEnd(',');
        queryString += ' FROM Transaction_Role__c  WHERE Contact__c != :recId' ;
        queryString +=' AND Transaction__c IN :setOfRecords' ;
        if(filter != Null && filter != '')
            queryString += ' AND ' +(filter);
        
        queryString += ' ORDER BY '+sortingField+' ' +sortOrder ;  
        return Database.query(queryString); 
    }
    
    private static list<SObject> getContactsOnTransactionPage(String recId, Set<String> setFieldsToQuery, 
    													String filter, String sortOrder, 
    													String sortingField, String numberOfRecord){
    	string queryString;
        queryString = 'Select ';
        queryString += String.join( new List<String>(setFieldsToQuery), ',');
        queryString.removeEnd(',');
        queryString += ' FROM Transaction_Role__c  WHERE Transaction__c = :recId';
        if(filter != Null && filter != '')
            queryString += ' AND ' +(filter);
        
        queryString += ' ORDER BY '+sortingField+' ' +sortOrder ;  
        return Database.query(queryString); 
    }

    /***
        * Name         : readFieldSet
        * Params       : fieldSetName, strObjectName 
        * Description  : Used to read the field set...
    ***/
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName , String strObjName){
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(strObjName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName); 
        return fieldSetObj.getFields(); 
    }

    public class MainWrapper{
        @AuraEnabled public list<FieldInfoWrapper> lstFieldInfoWrapper { get;set; } 
        @AuraEnabled public List<SObject> lstofSobjectRecords  { get;set; }
        
        public MainWrapper( list<FieldInfoWrapper> lstFieldInfoWrapper , List<SObject> lstofSobjectRecords ) {
            this.lstFieldInfoWrapper = lstFieldInfoWrapper;
            this.lstofSobjectRecords = lstofSobjectRecords;
        }
    }

    public class FieldInfoWrapper{ 
        @AuraEnabled public String fieldPath { get;set; }
        @AuraEnabled public String label { get;set; }
        @AuraEnabled public String type { get; set; }
        
        public FieldInfoWrapper(String fieldPath, String label, String type ) { 
            this.fieldPath = fieldPath;
            this.type = type;
            this.label = label;
        }
    }
}