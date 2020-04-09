package todo3.codesquad;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.List;

@Getter @Setter @ToString
public class Response {
    private String colName;
    private List<Card> cardList;

    public Response() {}

    public Response(String colName , List<Card> cardList) {
        this.colName = colName;
        this.cardList = cardList;
    }

}
