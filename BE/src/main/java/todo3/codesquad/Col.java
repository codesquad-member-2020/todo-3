package todo3.codesquad;

import org.springframework.data.annotation.Id;

import java.util.List;

public class Col {

    @Id
    private Long id;

    private String colName;

    private boolean deleted;

    private List<Card> cards;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getColName() {
        return colName;
    }

    public void setColName(String colName) {
        this.colName = colName;
    }

    public boolean isDeleted() {
        return deleted;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }

    public List<Card> getCards() {
        return cards;
    }

    public void addCards(Card card) {
        this.cards.add(card);
    }

    @Override
    public String toString() {
        return "Col{" +
                "id=" + id +
                ", colName='" + colName + '\'' +
                ", deleted=" + deleted +
                ", cards=" + cards +
                '}';
    }
}
