@isTest
private class ProjectCalloutServiceTest {

    @TestSetup
    private static void setup() {
        Opportunity opp = new Opportunity(
                Name = 'OppName',
                StageName = 'Closed Won'
        );
        insert opp;
    }

    private static testMethod void testFailure() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        ProjectCalloutService.postOpportunityToPMS(new List<Id>());
        Test.stopTest();

        // asserts
    }

    private static testMethod void testSuccess() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        ProjectCalloutService.postOpportunityToPMS(new List<Id>());
        Test.stopTest();

        // asserts
    }
}