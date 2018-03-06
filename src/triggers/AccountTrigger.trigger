// Trigger on Account object

/*  * \arg CreatedOn        : 03/Oct/2017
    * \arg LastModifiedOn   : 03/Oct/2017
    * \arg CreatededBy      : Nrusingh
    * \arg ModifiedBy       : Nrsingh
    * \arg Description      : Trigger for Account object.
*/
trigger AccountTrigger on Account (after insert, after update) {
    Trigger_Settings__c objTriggerSettings = TeamSharingManager.returnCustomSettingVal();
    
    // Checking the custom setting is enabled or not...
    if(!objTriggerSettings.Disable_All__c && !objTriggerSettings.Disable_Account__c){
        AccountTriggerHandler objHandler = new AccountTriggerHandler ();
    
        if(Trigger.isAfter){
            if(Trigger.isInsert)
                objHandler.onAfterInsert(Trigger.newMap);
            else if(Trigger.isUpdate)
                objHandler.onAfterUpdate(Trigger.oldMap, Trigger.newMap);
        } 
    }
}