@RestResource(urlMapping='/project/*')
global class ProjectRESTService {

    /**
     * The inbound call’s authentication with Salesforce is dependent upon the Org Registration of the Connected App authentication keys.
     * https://YOUR_INSTANCE.salesforce.com/services/apexrest/project
     */
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        // create opportunity for update
        Opportunity opp = new Opportunity();
        opp.Id = OpportunityId;
        opp.DeliveryInstallationStatus__c = 'In Progress';

        // prepare project
        Project__c project = getProjectOrCreateNew(ProjectRef, OpportunityId);

        // set project values
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

    private static Project__c getProjectOrCreateNew(String projectRef, String oppId) {
        List<Project__c> projects = ProjectSelector.getProjects(projectRef, oppId);
        Project__c project;

        if (projects.isEmpty()) {
            project = new Project__c();
            project.Opportunity__c = oppId;
        } else {
            project = projects.get(0);
        }

        return project;
    }
}