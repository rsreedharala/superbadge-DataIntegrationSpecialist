@isTest
private class ProjectCalloutServiceTest {

  private static testMethod void testFailure() {
      Test.startTest();
      Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
      ProjectCalloutService.postOpportunityToPMS(new List<Id>());
      Test.stopTest();

      // todo asserts
  }
}