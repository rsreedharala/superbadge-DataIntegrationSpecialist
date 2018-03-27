@RestResource(urlMapping='/project/*')
global class ProjectRESTService {

    /**
     * The inbound call’s authentication with Salesforce is dependent upon the Org Registration of the Connected App authentication keys.
     * https://YOUR_INSTANCE.salesforce.com/services/apexrest/project
     */
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        // update opportunity
        Opportunity opp = new Opportunity(Id = OpportunityId);
        opp.DeliveryInstallationStatus__c = 'In Progress';

        // upsert project
        Project__c project;

        List<Project__c> projects = queryProject(ProjectRef, OpportunityId);

        project = projects.isEmpty() ? new Project__c() : projects.get(0);

        // update project fields
        if (projects.isEmpty()) {
            project.Opportunity__c = opp.Id;
        }
        project.ProjectRef__c = ProjectRef;
        project.Name = ProjectName;
        project.Start_Date__c = StartDate;
        project.End_Date__c = EndDate;
        project.Billable_Amount__c = Amount;
        project.Status__c = Status;

        // dml
        Savepoint sp = Database.setSavepoint(); // create database savepoint

        try {
            update opp;
            upsert project;
        } catch (Exception e) {
            Database.rollback(sp); // rollback on error
            return e.getMessage();
        }

        return 'OK';
    }

    private static List<Project__c> queryProject(String ProjectRef, String OpportunityId) {
        return [
                SELECT Id
                FROM Project__c
                WHERE ProjectRef__c =: ProjectRef AND Opportunity__c =: OpportunityId
                LIMIT 1
        ];
    }
}