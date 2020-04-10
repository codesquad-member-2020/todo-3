package todo3.codesquad.message;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class ResponseMessage {
    private Object responseMessage;

    public ResponseMessage(Object result) {
        this.responseMessage = result;
    }
}
