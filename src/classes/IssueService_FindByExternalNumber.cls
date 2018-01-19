/***
*Class            RESTServiceValidator
*Author           Godfrey Mwamsoyo
*Story            S-40895
*Date             12/23/2017
*Description      REST API for searching issues by external number
-----------------------------Modifications Updates ------------------------------
*Date             
*Description      

***/
@RestResource(UrlMapping='/REQ360/v1/issues')
global with sharing class IssueService_FindByExternalNumber {

    @HttpGet
    global static void doGet()
    {
          IssueService_FindByExternalNumber_Impl service = new IssueService_FindByExternalNumber_Impl();
          service.execute();
    } 
}