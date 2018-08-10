public class ProjectCalloutService {

    public static final String PROJECT_SERVICE_TOKEN_NAME = 'ProjectServiceToken';

    /**
     * Synchronize Outbound Project Data
     *
     * Note that this process is not designed to operate in bulk.
     * It’s designed to only process the first ID passed even if activated on a bulk load of opportunities.
     */
    @InvocableMethod(label='Callout POST opps to PMS')
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
            // query opportunity
            List<Opportunity> opportunities = OpportunitySelector.getOpportunities(new Set<Id>{oppId});

            if (opportunities.isEmpty()) {
                // handle error
                return;
            }

            // create http request with all headers
            HttpRequest request = createRequest(opportunities.get(0));

            // send
            HttpResponse response = new Http().send(request);

            // update Opportunity.StageName
            Opportunity opp = new Opportunity(Id = oppId);
            if (response.getStatusCode() != 201) {
                opp.StageName = OpportunitySelector.STAGE_RESUBMIT_PROJECT;
            } else {
                opp.StageName = OpportunitySelector.STAGE_SUBMITTED_PROJECT;
            }
            update opp;
        }


        private HttpRequest createRequest(Opportunity opp) {
            String token = ServiceTokens__c.getInstance(PROJECT_SERVICE_TOKEN_NAME).Token__c;

            HttpRequest request = new HttpRequest();

            request.setEndpoint('callout:ProjectService');
            request.setMethod('POST');
            request.setHeader('token', token);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody(serializeOpp(opp));

            return request;
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