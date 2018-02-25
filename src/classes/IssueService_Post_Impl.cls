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
global with sharing class IssueService_Post_Impl extends RESTServiceBase{
       
    public override Object getResponse() {
        List<PostIssueRequest> issueList = (List<PostIssueRequest>)JSON.deserialize(RestContext.request.requestBody.toString(), List<PostIssueRequest>.class);
        RestResponse response = RestContext.response;
        
         //Validate request parameters
        RESTServiceValidator val = new RESTServiceValidator();
        Map<String, String> componentMap = new Map<String, Id>();
        for(PostIssueRequest issue : issueList){
            componentMap.put(issue.component,null);
            if(issue.external_source != 'Erickson_JIRA')
              val.getErrors().add('Invalid external_source - ' + issue.external_source);
            if(issue.backlog_status != null && !validatePicklist('Backlog_Status__c', issue.backlog_status))
              val.getErrors().add('Invalid backlog_status - ' + issue.Backlog_Status);
            if(issue.defect_type != null && !validatePicklist('Defect_Type__c', issue.defect_type))
              val.getErrors().add('Invalid defect_type - ' + issue.defect_type);
            if(issue.priority != null && !validatePicklist('Priority__c', issue.priority))
              val.getErrors().add('Invalid priority - ' + issue.priority);
            if(issue.status != null && !validatePicklist('Status__c', issue.status))
              val.getErrors().add('Invalid status - ' + issue.status);
          }
        if (!val.isEmpty()) {    //Validation failed
            throw RESTServiceException.getBadRequestException('POST_ISSUE_FAILED', val.getErrors());
        }
            
        if(componentMap.size() > 0) {
            for(Component__c componentRecord : [Select Id, Name from Component__c where Name IN :componentMap.keySet()]) {
                componentMap.put(componentRecord.Name, componentRecord.Id);
            }
        }
        
        List<Issue__c> newIssuesList = new List<Issue__c>();
        for(PostIssueRequest issue : issueList){
        	if(componentMap.get(issue.component) != null){
        		Issue__c newIssue = new Issue__c();
            	newIssue.actual_result__c = issue.actual_result;
				newIssue.backlog_status__c = issue.backlog_status;
				newIssue.browser__c = issue.browser;
				newIssue.close_date_time__c = issue.close_date_time;
				newIssue.component__c = componentMap.get(issue.component);
				newIssue.defect_type__c = issue.defect_type;
				newIssue.detected_by__c = issue.detected_by;
				newIssue.dev_owner__c = issue.dev_owner;
				newIssue.due_date__c = issue.due_date;
				newIssue.environment__c = issue.environment;
				newIssue.epic__c = issue.epic;
				newIssue.estimated_loe_rollup__c = issue.estimated_loe_rollup;
				newIssue.expected_result__c = issue.expected_result;
				newIssue.external_id__c = issue.external_id;
				newIssue.external_number__c = issue.external_number;
				newIssue.external_source__c = issue.external_source;
				newIssue.external_timestamp__c = issue.external_timestamp;
				newIssue.issue_name__c = issue.issue_name;
				newIssue.order__c = issue.order;
				newIssue.previous_blocked_duration__c = issue.previous_blocked_duration;
				newIssue.previous_status__c = issue.previous_status;
				newIssue.previous_status_notes__c = issue.previous_status_notes;
				newIssue.priority__c = issue.priority;
				newIssue.process_diagram_url__c = issue.process_diagram_url;
				newIssue.product__c = issue.product;
				newIssue.qa_owner__c = issue.qa_owner;
				newIssue.release__c = issue.release;
				newIssue.resolution__c = issue.resolution;
				newIssue.resolution_owner__c = issue.resolution_owner;
				newIssue.screenshots_video__c = issue.screenshots_video;
				newIssue.source_story__c = issue.source_story;
				newIssue.source_story_test_case__c = issue.source_story_test_case;
				newIssue.source_story_test_result__c = issue.source_story_test_result;
				newIssue.sprint__c = issue.sprint;
				newIssue.status__c = issue.status;
				newIssue.status_notes__c = issue.status_notes;
				newIssue.steps_to_reproduce__c = issue.steps_to_reproduce;
				newIssue.story_name__c = issue.story_name;
				newIssue.storyid__c = issue.storyid;
				newIssue.sub_component__c = issue.sub_component;
				newIssue.wireframe_url__c = issue.wireframe_url;
            	           	
                newIssuesList.add(newIssue);
            }
        }
        
        if(newIssuesList.size() > 0) {
            insert newIssuesList;    
            
            List<PostIssueResponse> responseList = new List<PostIssueResponse>();
            for(Issue__c issue : newIssuesList){
            	PostIssueResponse postedIssue = new PostIssueResponse(issue.Id);
            	postedIssue.external_id = issue.external_id__c;
            	responseList.add(postedIssue);
            }
            response.statusCode = 201;
            return responseList;
            
        }
        return null;
	}   
	
	public Boolean validatePicklist(String Field_name, String option){
		Schema.sObjectType objType = Issue__c.getSObjectType();
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe(); 
		Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
		list<Schema.PicklistEntry> fieldResult = fieldMap.get(Field_name).getDescribe().getPickListValues();
	    for( Schema.PicklistEntry f : fieldResult)
	    {
	      if (f.getValue() == option)
	      	return true;
	    }    
		return false;
	}
       
    global class PostIssueRequest {
        public String actual_result  { get; set; }
		public String backlog_status  { get; set; }
		public String browser  { get; set; }
		public DateTime close_date_time  { get; set; }
		public String component  { get; set; }
		public String defect_type  { get; set; }
		public String detected_by  { get; set; }
		public String dev_owner  { get; set; }
		public Date due_date  { get; set; }
		public String environment  { get; set; }
		public String epic  { get; set; }
		public Decimal estimated_loe_rollup  { get; set; }
		public String expected_result  { get; set; }
		public String external_id  { get; set; }
		public String external_number  { get; set; }
		public String external_source  { get; set; }
		public DateTime external_timestamp  { get; set; }
		public String issue_name  { get; set; }
		public Decimal order  { get; set; }
		public Decimal previous_blocked_duration  { get; set; }
		public String previous_status  { get; set; }
		public String previous_status_notes  { get; set; }
		public String priority  { get; set; }
		public String process_diagram_url  { get; set; }
		public String product  { get; set; }
		public String qa_owner  { get; set; }
		public String release  { get; set; }
		public String resolution  { get; set; }
		public String resolution_owner  { get; set; }
		public String screenshots_video  { get; set; }
		public String source_story  { get; set; }
		public String source_story_test_case  { get; set; }
		public String source_story_test_result  { get; set; }
		public String sprint  { get; set; }
		public String status  { get; set; }
		public String status_notes  { get; set; }
		public String steps_to_reproduce  { get; set; }
		public String story_name  { get; set; }
		public String storyid  { get; set; }
		public String sub_component  { get; set; }
		public String wireframe_url  { get; set; }       
    }
    
    global class PostIssueResponse {
        public string issue_id { get; set; }
        public string external_id { get; set; }
        public HALLinks hal_links { get; set; }   

        public PostIssueResponse(String issueId) {
            issue_id = issueId;
            hal_links = new HALLinks();
            hal_links.self = new HALLink('/services/apexrest/REQ360/v1/issues/' + issueId);            
        }
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