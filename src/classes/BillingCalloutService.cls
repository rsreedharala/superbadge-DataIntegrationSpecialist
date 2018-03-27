public class BillingCalloutService {

    private static final String STATUS_BILLED = 'Billed';
    private static final ServiceCredentials__c CREDENTIALS = ServiceCredentials__c.getinstance('BillingServiceCredential');

    @future(callout=true)
    public static void callBillingService(String projectRef, Decimal billAmount) {
        // project
        BillingServiceProxy.project soapProject = new BillingServiceProxy.project();
        soapProject.projectRef = projectRef;
        soapProject.billAmount = billAmount;
        soapProject.username = CREDENTIALS.Username__c;
        soapProject.password = CREDENTIALS.Password__c;

        // callout
        BillingServiceProxy.InvoicesPortSoap11 port = new BillingServiceProxy.InvoicesPortSoap11();
        String response = port.billProject(soapProject);

        // update project on success
        if (response == 'OK')
            updateProject(projectRef);
    }

    private static void updateProject(String projectRef) {
        Project__c project = [SELECT Id FROM Project__c WHERE ProjectRef__c =: projectRef];
        project.Status__c = STATUS_BILLED;
        update project;
    }
}