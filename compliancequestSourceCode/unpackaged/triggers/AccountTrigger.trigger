trigger AccountTrigger on Account (after insert, before update) {
    
    Switch On Trigger.OperationType{
        When AFTER_INSERT{
            AccountHandlerTrigger.updateAccountAndCreateMembers(trigger.new);
        }
        WHEN BEFORE_UPDATE{
            AccountHandlerTrigger.beforeUpdateTrigger(trigger.new);
        }
    }

}