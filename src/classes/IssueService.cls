/***
*Class            IssueService
*Author           Godfrey Mwamsoyo
*Story            S-40895
*Date             12/24/2017
*Description      REST API for searching, updating and creating new Issue
-----------------------------Modifications Updates ------------------------------
*Date             
*Description      

***/
@RestResource(UrlMapping='/REQ360/v1/issues/*')
global with sharing class IssueService{

    @HttpGet
    global static void doGet()
    {
        IssueService_Get_Impl service = new IssueService_Get_Impl();
        service.execute();
    }

    @HttpPost
    global static void doPost()
    {
        IssueService_Post_Impl service = new IssueService_Post_Impl();
        service.execute();
    }
}