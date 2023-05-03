public class AccountHandlerTrigger {

    Public static void updateAccountAndCreateMembers(List<Account> newRecords){
        try{
            List<SQX_Team_Members__c> newListTeamMeber = new List<SQX_Team_Members__c>();
            for(Account each: newRecords){
                for(Integer i=1; i<=2; i++){
                    SQX_Team_Members__c tempTeamMeber = new SQX_Team_Members__c();
                    tempTeamMeber.Name = 'Team Memer '+ i;
                    tempTeamMeber.Contact_Info__c = '';
                     tempTeamMeber.Member_Type__c = '';
                    tempTeamMeber.AccountId__c = each.Id;
                    newListTeamMeber.add(tempTeamMeber);
                }
            }
            if(!newListTeamMeber.isEmpty()){
                Database.insert(newListTeamMeber);
            }
        }catch(Exception ex){
            
        }
    }
    Public static void beforeUpdateTrigger(List<Account> newRecords){
        try{
            boolean updateAccount = false;
    		boolean onceUpdate = true;
           set<Id> AccountIds = new set<Id>();
            for(Account each: newRecords){
                if(each.Active__c == true){
                    AccountIds.add(each.id);
                }
                
            }
            if(!AccountIds.isEmpty()){
                List<PermissionSetAssignment> perAssignments = [SELECT AssigneeId, PermissionSet.Name 
                                                                FROM PermissionSetAssignment 
                                                                WHERE PermissionSet.Name = 'Account_Admin' 
                                                                AND AssigneeId=:UserInfo.getUserId()];
                
                List<SQX_Team_Members__c> getAllTeamMembers = [SELECT Id, Member_Type__c ,AccountId__c
                                                               From SQX_Team_Members__c 
                                                               where AccountId__c IN :AccountIds];
                
                Map<Id, Integer> AccountIdVsTeamMembers = new Map<Id, Integer>();
                for(SQX_Team_Members__c eachData : getAllTeamMembers){
                      if((eachData.Member_Type__c == 'HR' || eachData.Member_Type__c == 'Admin') && !perAssignments.isEmpty()){
                          updateAccount = true;
                          if(AccountIdVsTeamMembers.containsKey(eachData.AccountId__c)){
                              Integer existHrOrAdminMember = AccountIdVsTeamMembers.get(eachData.AccountId__c);
                              existHrOrAdminMember += 1;
                              AccountIdVsTeamMembers.put(eachData.AccountId__c, existHrOrAdminMember);
                          }else if(!AccountIdVsTeamMembers.containsKey(eachData.AccountId__c)){
                              Integer HrOrAdminMember = 1;
                              AccountIdVsTeamMembers.put(eachData.AccountId__c, HrOrAdminMember);
                          }
                        
                      }
                }
                List<Account> newListUpdate = new List<Account>();
                for(Id eachId : AccountIdVsTeamMembers.keyset()){
                    if(AccountIdVsTeamMembers.containsKey(eachId) && AccountIdVsTeamMembers.get(eachId) > 0){
                        Account accObj = new Account();
                        accObj.Id = eachid;
                        accobj.Active__c = true;
                        newListUpdate.add(accObj);
                    }
                }
                if(!newListUpdate.isEmpty() && manageAccountUpdate.isFirstTime){
                    manageAccountUpdate.isFirstTime = false;
                   update newListUpdate;
                }
            }
            
            
        }catch(Exception ex){
            
        }
    }
}