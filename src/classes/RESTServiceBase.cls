/***
*Class            RESTServiceBase
*Author           Godfrey Mwamsoyo
*Story            S-40895
*Date             12/23/2017
*Description      Base/super class for REST service classes
-----------------------------Modifications Updates ------------------------------
*Date             
*Description      

***/
public abstract class RESTServiceBase {
    public void execute() {
        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }
        res.addHeader('Content-Type', 'application/hal+json');
        try {
            res.statusCode = 200;  //can be overriden in the subclass
            String body = JSON.serialize(getResponse());
            body = body.replace(getHALLinksFieldName(), '_links'); //can't have _links as a field name in APEX, so have to do this hack
            res.responseBody = Blob.valueOf(body);
        } catch (RESTServiceException e) {
            RESTServiceErrors errors = e.getErrors();
            errors.DeveloperMessage = e.getMessage();
            res.statusCode = errors.statusCode;
            res.responseBody = Blob.valueOf(errors.getErrorJSON());
        } catch (Exception e) {
            RESTServiceErrors errors = new RESTServiceErrors();
            errors.StatusCode = 500;
            errors.ErrorCode = getErrorCode();
            errors.DeveloperMessage = e.getMessage();  //consider adding stack trace to developer message
            errors.add(getErrorMessage());
            res.statusCode = errors.StatusCode;
            res.responseBody = Blob.valueOf(errors.getErrorJSON());
        }        
    }

    public string getId() {
        RestRequest req = RestContext.request;
        return req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    }
    
    public virtual String getErrorCode() {
        return 'GENERAL_ERROR';
    }
    
    public virtual String getErrorMessage() {
        return 'An unknown error has occurred';
    }
    
    public virtual String getHALLinksFieldName() {
        return 'hal_links';
    }
    
    public abstract Object getResponse();
}