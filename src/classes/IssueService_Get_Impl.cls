/***
*Class            IssueService_Get_Impl
*Author           Godfrey Mwamsoyo
*Story            S-40895
*Date             12/24/2017
*Description      REST API for Finding Issue by Id
-----------------------------Modifications Updates ------------------------------
*Date             
*Description      

***/
global with sharing class IssueService_Get_Impl extends RESTServiceBase {
    public override Object getResponse() {
        String issueId = super.getId();
        Issue__c issue = [select Id, Name, external_number__c
                                   from Issue__c 
                                   where Id = :issueId];
        if (issueId  == null) {
          throw RESTServiceException.getNotFoundException('ISSUE_NOT_FOUND', 'Issue Not Found');
        }
        
        IssueGetResponse resp = new IssueGetResponse();
        resp.issue_id = issue.Id;
        resp.external_number = issue.external_number__c;
        resp.issue_name = issue.Name;
        resp.hal_links = new HALLinks();
        resp.hal_links.self = new HALLink('/services/apexrest/REQ360/v1/issues/' + issue.Id);
        return resp;
    }

    public class IssueGetResponse {
        public String issue_id { get; set; }
        public String external_number{ get; set; }
        public String issue_name{ get; set; }
        public HALLinks hal_links { get; set; }
    } 

    public class HALLinks
    {
        public HALLink self { get; set; }
    }

    public class HALLink
    {
        public String href { get; set; }

        public HALLink(String href) {
            this.href = href;
        }
    }
}