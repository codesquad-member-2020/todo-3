package todo3.codesquad.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import todo3.codesquad.domain.Card;
import todo3.codesquad.domain.Col;
import todo3.codesquad.domain.ColRepository;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class TodoService {

    private final ColRepository colRepository;

    public TodoService(ColRepository colRepository) {
        this.colRepository = colRepository;
    }

    @Transactional
    public Card createCard(Map<String, Object> cardData) {
        String categoryName = cardData.get("categoryName").toString();
        Col col = colRepository.findByCategoryName(categoryName).orElse(null);
        List<Card> cards = col.getCards();
        Card card = new Card(cardData);
        cards.add(0, card);
        for (int i = 0; i < cards.size(); i++) {
            Card tempCard = cards.get(i);
            tempCard.setRow(i + 1);
        }
        colRepository.save(col);
        return card;
    }

    @Transactional
    public Card updateCard(Long updateCardId, @RequestBody Map<String, Object> map) {
        String colName = map.get("colName").toString();
        Card updateCard = new Card();
        Col col = colRepository.findByColName(colName).orElse(null);
        if (col == null) {
            return null;
        }
        List<Card> cards = col.getCards();
        for (int i = 0; i < cards.size() ; i++) {
            Long cardId = cards.get(i).getId();
            if (cardId.equals(updateCardId)){
                updateCard = cards.get(i);
                updateCard.update(map);
            }
        }
        colRepository.save(col);
        return updateCard;
    }
}
