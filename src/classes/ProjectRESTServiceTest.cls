@isTest
private class ProjectRESTServiceTest {

    private static final String PROJECT_REF = '12345';
    private static final String NONEXISTING_PROJECT_REF = '00000';
    private static final String CLOSED_WON = 'Closed/Won';

    private static final String PROJECT_NAME = 'Project Name';
    private static final String PROJECT_STATUS = 'Running';

    @testSetup
    static void setup() {
        Opportunity opp = new Opportunity(
                Name = 'OpportunityName',
                StageName = 'Prospecting',
                CloseDate = Date.today().addYears(1)
        );
        insert opp;

        Project__c project = new Project__c();
        project.ProjectRef__c = PROJECT_REF;
        project.Opportunity__c = opp.Id;
        insert project;
    }

    @isTest
    static void testPostCreate() {
        Id oppId = OpportunitySelector.getAllOpportunities(1).get(0).Id;

        Test.startTest();

        String result = ProjectRESTService.postProjectData(
                NONEXISTING_PROJECT_REF, PROJECT_NAME, oppId, Date.today(), Date.today().addYears(1), 100, PROJECT_STATUS);

        Test.stopTest();

        Opportunity opp = OpportunitySelector.getAllOpportunities(1).get(0);
        List<Project__c> projects = ProjectSelector.getAllProjects(10);

        System.assertEquals('OK', result);
        System.assertEquals(2, projects.size());

        Project__c project = projects[0].ProjectRef__c == NONEXISTING_PROJECT_REF ? projects[0] : projects[1];

        System.assertEquals('In progress', opp.DeliveryInstallationStatus__c);
        System.assertEquals(PROJECT_NAME, project.Name);
        System.assertEquals(PROJECT_STATUS, project.Status__c);
    }

    @isTest
    static void testPostUpdate() {
        Id oppId = OpportunitySelector.getAllOpportunities(1).get(0).Id;

        Test.startTest();

        String result = ProjectRESTService.postProjectData(
                PROJECT_REF, PROJECT_NAME, oppId, Date.today(), Date.today().addYears(1), 100, PROJECT_STATUS);

        Test.stopTest();

        Opportunity opp = OpportunitySelector.getAllOpportunities(1).get(0);
        List<Project__c> projects = ProjectSelector.getAllProjects(1);

        System.assertEquals('OK', result);
        System.assertEquals(1, projects.size());

        System.assertEquals('In progress', opp.DeliveryInstallationStatus__c);
        System.assertEquals(PROJECT_NAME, projects[0].Name);
        System.assertEquals(PROJECT_STATUS, projects[0].Status__c);
    }

    @isTest
    static void testPostInvalidOpportunityId() {
        String invalidOppId = '0061r00000uf2gc';

        Test.startTest();

        String result = ProjectRESTService.postProjectData(
                PROJECT_REF, PROJECT_NAME, invalidOppId, Date.today(), Date.today().addYears(1), 100, PROJECT_STATUS);

        Test.stopTest();

        System.assertNotEquals('OK', result);

        Opportunity opp = OpportunitySelector.getAllOpportunities(1).get(0);
        System.assertNotEquals('In progress', opp.DeliveryInstallationStatus__c);
    }

}