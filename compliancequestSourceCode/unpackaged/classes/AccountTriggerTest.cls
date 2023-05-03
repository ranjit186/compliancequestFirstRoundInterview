@isTest
public class AccountTriggerTest {
    @isTest static void createPermission() {
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'testName123';
        acc.AccountNumber = '987';
        insert acc;
        Test.stopTest();
    }
    @isTest static void updateAccountTestMethod() {
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Account_Admin'];
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser){
            
            insert new PermissionSetAssignment(AssigneeId = UserInfo.getUserId(), PermissionSetId = ps.Id);
             }
        
        Account acc = new Account();
        acc.Name = 'testName123';
        acc.AccountNumber = '987';
        insert acc;
        
        
        
         List<SQX_Team_Members__c> newListTeamMeber = new List<SQX_Team_Members__c>();
        for(Integer i=1; i<=2; i++){
            SQX_Team_Members__c tempTeamMeber = new SQX_Team_Members__c();
        tempTeamMeber.Name = 'Team Memer test' + i;
        tempTeamMeber.Member_Type__c = 'HR';
        tempTeamMeber.AccountId__c = acc.id;
            newListTeamMeber.add(tempTeamMeber);
            
        }
        
        insert newListTeamMeber;
        Test.startTest();
        acc.Active__c = true;
        update acc;
        Test.stopTest();
    }
}