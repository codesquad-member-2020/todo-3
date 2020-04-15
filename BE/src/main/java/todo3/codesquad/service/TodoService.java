package todo3.codesquad.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import todo3.codesquad.domain.Card;
import todo3.codesquad.domain.Col;
import todo3.codesquad.domain.ColRepository;
import todo3.codesquad.security.JwtTokenDecode;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class TodoService {

    private final ColRepository colRepository;

    public TodoService(ColRepository colRepository) {
        this.colRepository = colRepository;
    }

    public Card createCard(Map<String, Object> requestBody) {
        if (requestBody.get("colName") == null) {
            return null;
        }

        String colName = requestBody.get("colName").toString();
        Col col = colRepository.findColByColName(colName).orElse(null);

        if (col.getCards() == null) {
            return null;
        }
        String writer = getWriterInJwtToken();
        List<Card> cards = col.getCards();
        Card card = new Card(requestBody, writer);
        cards.add(card);
        for (int i = 0; i < cards.size(); i++) {
            Card tempCard = cards.get(i);
            tempCard.setRow(i + 1);
        }
        colRepository.save(col);
        return card;
    }

    public Card updateCard(Long updateCardId, Map<String, Object> requestBody) {
        String colName = requestBody.get("colName").toString();
        Card updateCard = new Card();
        boolean checkCardId = true;
        Col col = colRepository.findColByColName(colName).orElse(null);
        if (col == null) {
            return null;
        }
        List<Card> cards = col.getCards();
        for (int i = 0; i < cards.size(); i++) {
            Long cardId = cards.get(i).getId();
            if (cardId.equals(updateCardId)) {
                updateCard = cards.get(i);
                updateCard.update(requestBody);
                checkCardId = false;
            }
        }
        if (checkCardId) {
            return null;
        }
        colRepository.save(col);
        return updateCard;
    }

    public Card moveCard(Long moveCardId, Map<String, Object> requestBody) {
        Card card = colRepository.findCardByCardId(moveCardId).orElse(null);
        if (card == null) {
            return null;
        }

        String destinationColName = requestBody.get("destinationCol").toString();
        int destinationRow = Integer.parseInt(requestBody.get("destinationRow").toString());
        int originRow = card.getRow();

        Col originCol = colRepository.findColByCardId(moveCardId).orElse(null);
        Col destinationCol = colRepository.findColByColName(destinationColName).orElse(null);
        if (originCol == null || destinationCol == null) {
            return null;
        }

        List<Card> oriCards = originCol.getCards();
        List<Card> desCards = destinationCol.getCards();

        oriCards.remove(originRow - 1);
        desCards.set(destinationRow, card);

        for (int i = 0; i < desCards.size(); i++) {
            Card tempCard = desCards.get(i);
            tempCard.setRow(i + 1);
        }

        colRepository.save(originCol);
        colRepository.save(destinationCol);
        return card;
    }

    public Card deleteCard(Long deleteCardId) {
        if (colRepository.deleteCardByCardId(deleteCardId)) {
            Col col = colRepository.findColByCardId(deleteCardId).orElse(null);
            List<Card> cards = col.getCards();
            int rowIdx = 1;
            for (int i = 0; i < cards.size(); i++) {
                if (cards.get(i).getDeleted()) {
                    continue;
                }
                cards.get(i).setRow(rowIdx);
                rowIdx++;
            }
            colRepository.save(col);
            return colRepository.findCardByCardId(deleteCardId).orElse(null);
        }
        return null;
    }

    public List<Col> showColumns() {
        List<Col> columns = colRepository.findColByNotDeleted().orElse(null);
        List<Col> newColumns = new ArrayList<>();
        for (int i = 0; i < columns.size(); i++) {
            Col tempCol = columns.get(i);
            Long colId = tempCol.getId();
            List<Card> tempCards = colRepository.findNotDeletedCardsByColId(colId).orElse(null);
            if (tempCol.isDeleted()) {
                continue;
            }
            tempCol.setCards(tempCards);
            newColumns.add(tempCol);
        }
        return newColumns;
    }

    public Col showColumn(String columnName) {
        columnName = columnName.replace("_", " ");
        List<Col> columns = showColumns();
        for (int i = 0; i < columns.size(); i++) {
            if (columns.get(i).getColName().equals(columnName)) {
                return columns.get(i);
            }
        }
        return null;
    }

    private String getWriterInJwtToken() {
        JwtTokenDecode jwtTokenDecode = new JwtTokenDecode();
        return jwtTokenDecode.getLoginUser("userId");
    }
}
