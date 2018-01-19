/***
*Class            RESTServiceException
*Author           Godfrey Mwamsoyo
*Story            S-40895
*Date             12/23/2017
*Description      Base/super class for REST service classes
-----------------------------Modifications Updates ------------------------------
*Date             
*Description      

***/
public class RESTServiceException extends Exception {
    private RESTServiceErrors errors;
    
    public RESTServiceException(String message, RESTServiceErrors errors) {
        this(message);
        this.errors = errors;
    }
    
    public RESTServiceException(String message, Integer statusCode, String errorCode, String userMessage) {
        this(message);
        this.errors = new RESTServiceErrors();
        errors.statusCode = statusCode;
        errors.errorCode = errorCode;
        if (!String.isBlank(userMessage)) {
            errors.add(userMessage);
        }
    }
    
    public RESTServiceErrors getErrors() {
        return errors;
    }

    public static RESTServiceException getBadRequestException(String errorCode, RESTServiceErrors errors) {
        errors.statusCode = 400;
        errors.errorCode = errorCode;
        return new RESTServiceException('Bad request', errors);
    }

    public static RESTServiceException getBadRequestException(String errorCode, String userMessage) {
        return new RESTServiceException('Bad request', 400, errorCode, userMessage);
    }

    public static RESTServiceException getNotFoundException(String errorCode) {
        return new RESTServiceException('Not found', 404, errorCode, 'Not found');
    }

    public static RESTServiceException getNotFoundException(String errorCode, String userMessage) {
        return new RESTServiceException('Not found', 404, errorCode, userMessage);
    }
    
    public static RESTServiceException getMethodNotAllowedException() {
        return new RESTServiceException('Method not allowed', 405, '', '');
    }

}