public class ProjectTriggerHelper {

    public static List<Project__c> filterStatusChanged(Map<Id, Project__c> oldMap, List<Project__c> newList, String newStatus) {
        List<Project__c> result = new List<Project__c>();

        for (Project__c newProject : newList) {
            if (newProject.Status__c == newStatus && oldMap.get(newProject.Id).Status__c != newStatus)
                result.add(newProject);
        }
        return result;
    }
}