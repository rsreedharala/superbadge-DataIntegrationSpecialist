@RestResource(urlMapping='/project/*')
global class ProjectRESTService {

    /**
     * The inbound call’s authentication with Salesforce is dependent upon the Org Registration of the Connected App authentication keys.
     * https://YOUR_INSTANCE.salesforce.com/services/apexrest/project
     */
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        System.debug(ProjectRef + ' ' + ProjectName);
        return 'OK';
    }
}