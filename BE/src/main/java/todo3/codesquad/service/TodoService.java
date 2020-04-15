package todo3.codesquad.service;

import org.json.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import todo3.codesquad.domain.Card;
import todo3.codesquad.domain.Col;
import todo3.codesquad.domain.ColRepository;

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
        Col col = colRepository.findByCategoryName(colName).orElse(null);

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
        Col col = colRepository.findByColName(colName).orElse(null);
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
        Card card = colRepository.findByMoveCardId(moveCardId).orElse(null);
        Long originColId = colRepository.findColIdByCardId(moveCardId).orElse(null);
        if(card == null || originColId == null){
            return null;
        }

        String destinationColName = requestBody.get("destinationCol").toString();
        int destinationRow = Integer.parseInt(requestBody.get("destinationRow").toString());
        int originRow = card.getRow();

        Col originCol = colRepository.findById(originColId).orElse(null);
        Col destinationCol = colRepository.findByColName(destinationColName).orElse(null);
        if (originCol == null || destinationCol == null){
            return null;
        }

        List<Card> oriCards = originCol.getCards();
        List<Card> desCards = destinationCol.getCards();

        oriCards.remove(originRow-1);
        desCards.set(destinationRow, card);

        for (int i = 0; i < desCards.size(); i++) {
            Card tempCard = desCards.get(i);
            tempCard.setRow(i+1);
        }

        colRepository.save(originCol);
        colRepository.save(destinationCol);
        return card;
    }
}
