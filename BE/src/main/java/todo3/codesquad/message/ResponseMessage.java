package todo3.codesquad.message;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class ResponseMessage {
    private String responseMessage;
    private Object responseData;

    public ResponseMessage(String responseMessage,Object responseData) {
        this.responseMessage = responseMessage;
        this.responseData = responseData;
    }
}
