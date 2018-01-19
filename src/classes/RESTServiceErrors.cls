/***
*Class            RESTServiceErrors
*Author           Godfrey Mwamsoyo
*Story            S-40895
*Date             12/23/2017
*Description      Base/super class for REST service classes
-----------------------------Modifications Updates ------------------------------
*Date             
*Description      

***/
public class RESTServiceErrors {
    public Integer StatusCode { get; set; }
    public String ErrorCode { get; set; }
    public String DeveloperMessage { get; set; }    
    public List<ErrorMessage> UserMessages { get; private set; }

    public RESTServiceErrors() {
        StatusCode = 500;
        UserMessages = new List<ErrorMessage>();
    }

    
    public void add(String message) {
        UserMessages.add(new ErrorMessage(message, null));
    }
    
    public void add(String message, String field) {
        UserMessages.add(new ErrorMessage(message, field));
    }
    
    public Boolean isEmpty() {
        return UserMessages.isEmpty();
    }
    
    public String getErrorJSON() {
        JSONGenerator generator = JSON.createGenerator(false);   
        generator.writeStartObject();               
        generator.writeNumberField('status_code', StatusCode);
        if (!String.isBlank(ErrorCode)) {
            generator.writeStringField('error_code', ErrorCode);
        }
        if (!String.isBlank(DeveloperMessage)) {
            generator.writeStringField('developer_message', DeveloperMessage);
        }
        generator.writeFieldName('user_messages');
        generator.writeStartArray();
        for (ErrorMessage message: UserMessages) {
            generator.writeStartObject();
            generator.writeStringField('message', message.Message);       
            if (!String.isBlank(message.Field)) {
                generator.writeStringField('field', message.Field);
            }
            generator.writeEndObject();
        }
        generator.writeEndArray();
        generator.writeEndObject();                 
        return generator.getAsString();
    }
        
    public class ErrorMessage {
        public String Message { get; set; }
        public String Field { get; set; }
        
        public ErrorMessage(String message, String field) {
            this.Message = message;
            this.Field = field;
        }
    }   
}