/***
*Class            RESTServiceException
*Author           Godfrey Mwamsoyo
*Story            S-40895
*Date             12/23/2017
*Description      REST API for Finding Issue by External Number
-----------------------------Modifications Updates ------------------------------
*Date             
*Description      

***/
global with sharing class IssueService_FindByExternalNumber_Impl extends RESTServiceBase {

    public override Object getResponse() {
        RestRequest req = RestContext.request; 
        String externalNumber = RestContext.request.Params.get('external_number'); 
        String sourceName = RestContext.request.Params.get('source_name');
        
        //Validate request parameters
        RESTServiceValidator val = new RESTServiceValidator();
        val.isNotBlank(externalNumber, 'externalnumber');
        if(sourceName != 'Erickson JIRA')
        	val.getErrors().add('Invalid source_name');
        if (!val.isEmpty()) {    //Validation failed
            throw RESTServiceException.getBadRequestException('GET_ISSUE_FAILED', val.getErrors());
        }
        
        List<Issue__c> issueLst = [select Id, Issue_Name__c, Name, external_source__c, external_id__c, external_number__c
                                   from Issue__c 
                                   where external_number__c = :externalNumber
                                   and external_source__c = :sourceName Limit 1];
        if(issueLst.Size() == 0) { //Issue was not found
            throw RESTServiceException.getNotFoundException('ISSUE_NOT_FOUND', 'Issue Not Found');       
        }
        
        IssueGetResponse resp = new IssueGetResponse();
        resp.issue_id = issueLst[0].Id;
        resp.issue_number = issueLst[0].Name;
        resp.issue_name = issueLst[0].Issue_Name__c; //Name;
        resp.external_id = issueLst[0].external_id__c;
        resp.external_number = issueLst[0].external_number__c;
        resp.external_source = issueLst[0].external_source__c;
        resp.hal_links = new HALLinks();
        resp.hal_links.self = new HALLink('/services/apexrest/REQ360/v1/issues/' + issueLst[0].Id);

        return resp;
    }
       
    public class IssueGetResponse {
        public String issue_id { get; set; } 
        public String issue_number { get; set; }
        public String issue_name { get; set; }
        public String external_id { get; set; }
        public String external_number { get; set; }
        public String external_source { get; set; }
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