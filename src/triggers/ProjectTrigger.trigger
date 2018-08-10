trigger ProjectTrigger on Project__c (before update, after update, before insert, after insert, before delete, after delete) {

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            List<Project__c> filtered = ProjectTriggerHelper.filterStatusChanged(Trigger.oldMap, Trigger.new, ProjectSelector.STATUS_BILLABLE);
            if (!filtered.isEmpty())
                BillingCalloutService.callBillingService(filtered[0].Id);
        }
    }
}