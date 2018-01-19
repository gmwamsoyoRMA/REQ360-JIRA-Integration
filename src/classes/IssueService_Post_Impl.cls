/***
*Class            IssueService_Post_Impl 
*Author           Godfrey Mwamsoyo
*Story            S-40895
*Date             12/24/2017
*Description      REST API for Creating a new Issue
-----------------------------Modifications Updates ------------------------------
*Date             
*Description      

***/
global with sharing class IssueService_Post_Impl extends RESTServiceBase {
    public override Object getResponse() {
        
        IssuePostRequest req = (IssuePostRequest)JSON.deserialize(RestContext.request.requestBody.toString(), IssuePostRequest.class);
        
        //To-Do: Perform validation on post request
        
        //To-Do: Create a new issue
        
        //Create post response object
        IssuePostResponse resp = new IssuePostResponse();
        resp.issue_id = '';
        resp.external_number = '';
        resp.issue_name = '';
        resp.hal_links = new HALLinks();
        resp.hal_links.self = new HALLink('/services/apexrest/REQ360/v1/issues/' + 'issue.Id');
        return resp;
    }

    public class IssuePostResponse {
        public String issue_id { get; set; }
        public String external_number{ get; set; }
        public String issue_name{ get; set; }
        public HALLinks hal_links { get; set; }
    } 
    
    public class IssuePostRequest {
        public String external_number{ get; set; }
        public String comment{ get; set; }
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