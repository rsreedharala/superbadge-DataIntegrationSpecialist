public class OpportunityFactory {

    private static Integer counter = 0;

    public static Opportunity createOpportunity(String stageName) {
        return createOpportunities(1, stageName).get(0);
    }

    public static List<Opportunity> createOpportunities(Integer count, String stageName) {
        List<Opportunity> opps = new List<Opportunity>();
        Date closeDate = Date.today().addYears(1);

        for (Integer i = 0; i < count; ++i) {
            opps.add(new Opportunity(
                    Name = 'TestOpportunity ' + counter,
                    StageName = stageName,
                    CloseDate = closeDate
            ));
            ++counter;
        }

        return opps;
    }
}