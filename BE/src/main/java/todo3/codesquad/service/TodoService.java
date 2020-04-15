package todo3.codesquad.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import todo3.codesquad.domain.Card;
import todo3.codesquad.domain.Col;
import todo3.codesquad.domain.ColRepository;

import java.sql.SQLException;
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
        List<Card> cards = col.getCards();
        Card card = new Card(requestBody);
        cards.add(0, card);
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

}
