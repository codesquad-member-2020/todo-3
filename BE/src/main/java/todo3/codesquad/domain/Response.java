package todo3.codesquad.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import todo3.codesquad.domain.Card;

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
