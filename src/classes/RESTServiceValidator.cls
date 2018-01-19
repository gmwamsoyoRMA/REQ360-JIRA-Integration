/***
*Class            RESTServiceValidator
*Author           Godfrey Mwamsoyo
*Story            S-40895
*Date             12/23/2017
*Description      Base/super class for REST service classes
-----------------------------Modifications Updates ------------------------------
*Date             
*Description      

***/
public class RESTServiceValidator {
    private RESTServiceErrors errors = new RESTServiceErrors();
    
    public Boolean isNotBlank(String param, String field) {
        if (String.isBlank(param))
        {
            errors.add(getFriendlyName(field) + ' is required', field);
            return false;
        }
        return true;
    }
    
    public Boolean isTrue(Boolean condition, String field) {
        if (!condition)
        {
            //errors.add(getFriendlyName(field) + ' is not valid', field);
            errors.add('Invalid ' + getFriendlyName(field), field);
            return false;
        }
        return true;
    }
    
    public Boolean isFalse(Boolean condition, String field) {
        if (condition)
        {
            //errors.add(getFriendlyName(field) + ' is not valid', field);
            errors.add('Invalid ' + getFriendlyName(field), field);
            return false;
        }
        return true;
    }
    
     public Boolean isActive(Boolean condition, String field) {
        if (!condition)
        {
            errors.add(getFriendlyName(field)+ ' not active', field);
            return false;
        }
        return true;
    }
    public Boolean isEmpty() {
        return errors.isEmpty();
    }
    
    public RESTServiceErrors getErrors() {
        return errors;
    }
    
    private String getFriendlyName(String field) {
        String s = field.replace('_', ' ');
        s = s.subString(0, 1).ToUpperCase() + s.subString(1);
        if (s.endsWith(' id')) {
            s = s.substring(0, s.length() - 3);
        }
        return s;
    }
}