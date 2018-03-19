public class ProjectCalloutService {

    public static final String PROJECT_SERVICE_TOKEN_NAME = 'ProjectServiceToken';

    /**
     * Note that this process is not designed to operate in bulk.
     * It’s designed to only process the first ID passed even if activated on a bulk load of opportunities.
     */
    @InvocableMethod(label='Callout post opps to PMS')
    public static void postOpportunityToPMS(List<Id> oppIds) {
        if (!oppIds.isEmpty())
            System.enqueueJob(new QueueablePMSCall(oppIds.get(0)));
    }

    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts {

        private Id oppId;

        public QueueablePMSCall(Id oppId) {
            this.oppId = oppId;
        }

        public void execute(System.QueueableContext ctx) {
            Opportunity opp = [SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id =: oppId];

            String token = ServiceTokens__c.getInstance(PROJECT_SERVICE_TOKEN_NAME).Token__c;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:ProjectService');
            request.setMethod('POST');
            request.setHeader('token', token);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(serializeOpp(opp));

            HttpResponse response = http.send(request);

            opp.StageName = (response.getStatusCode() != 201 ? 'Resubmit Project' : 'Submitted Project');
            update opp;
        }

        private String serializeOpp(Opportunity opp) {
            return '{ ' +
                    '"opportunityId": "' + opp.Id + '", ' +
                    '"opportunityName": "' + opp.Name + '", ' +
                    '"accountName": "' + opp.Account.Name + '", ' +
                    '"closeDate": "' + opp.CloseDate + '", ' +
                    '"amount":' + opp.Amount +
                    '}';
        }
    }
}