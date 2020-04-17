package todo3.codesquad.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import todo3.codesquad.Controller.TodoController;
import todo3.codesquad.domain.*;
import todo3.codesquad.security.JwtTokenDecode;
import todo3.codesquad.security.JwtTokenProvider;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class TodoService {

    private final ColRepository colRepository;
    private final UserRepository userRepository;
    private static final Logger log = LoggerFactory.getLogger(TodoController.class);

    public TodoService(ColRepository colRepository, UserRepository userRepository) {
        this.colRepository = colRepository;
        this.userRepository = userRepository;
    }

    public String issueJwtToken(Map<String, Object> requestBody) {
        if (requestBody.get("userId") == null) {
            return null;
        }
        String userId = requestBody.get("userId").toString();
        User defaultUser = userRepository.findDefaultUser();
        User user = userRepository.findByUserId(userId).orElse(defaultUser);

        String token = getJwtToken(user);

        return token;
    }

    public Card createCard(Long columnId, Map<String, Object> requestBody) {
        Col col = colRepository.findById(columnId).orElse(null);
        if (col == null) {
            return null;
        }
        if (col.getCards() == null) {
            return null;
        }

        String writer = getWriterInJwtToken();
        Card card = new Card(requestBody, writer);

        List<Card> cards = col.getCards();
        cards.add(card);
        if (!newCardsSetColumn(cards, col.getColName())) {
            return null;
        }

        return card;
    }

    public Card updateCard(Long updateCardId, Map<String, Object> requestBody) {
        String title = requestBody.get("title").toString();
        String contents = requestBody.get("contents").toString();
        String writer = getWriterInJwtToken();

        if (!title.isEmpty()) {
            colRepository.updateCardTitleByCardId(updateCardId, title);
        }
        if (!contents.isEmpty()) {
            colRepository.updateCardContentsByCardId(updateCardId, contents);
        }
        if (!writer.isEmpty()) {
            colRepository.updateCardWriterByCardId(updateCardId, writer);
        }

        return colRepository.findCardByCardId(updateCardId).orElse(null);
    }

    public Card moveCard(Long originColumnId, Long moveCardId, Map<String, Object> requestBody) {
        log.info("Card ID --------------{}", originColumnId);
        log.info("Destination Row ------------{}", requestBody.get("destinationRow").toString());
        log.info("Destination Col ------------{}", requestBody.get("destinationId").toString());
        Long destinationColumnId = Long.parseLong(requestBody.get("destinationId").toString());
        Col originCol = colRepository.findById(originColumnId).orElse(null);
        Col destinationCol = colRepository.findById(destinationColumnId).orElse(null);
        String originColName = originCol.getColName();
        String destinationColName = destinationCol.getColName();
        int destinationRow = Integer.parseInt(requestBody.get("destinationRow").toString());
        if (originColumnId.equals(destinationColumnId)) {
            Card card = colRepository.findCardByCardId(moveCardId).orElse(null);
            int cardRow = card.getRow();
            List<Card> cards = colRepository.findCardsByColName(originColName).orElse(null);
            cards.remove(cardRow - 1);
            if (destinationRow == 99) {
                cards.add(card);
            } else {
                cards.add(destinationRow - 1, card);
            }
            if (!newCardsSetColumn(cards, destinationColName)) {
                return null;
            }
            return card;
        }

        List<Card> oriCards = colRepository.findCardsByColName(originColName).orElse(null);
        List<Card> desCards = colRepository.findCardsByColName(destinationColName).orElse(null);
        Card movedCard = colRepository.findCardByCardId(moveCardId).orElse(null);
        for (int i = 0; i < oriCards.size(); i++) {
            Long cardId = oriCards.get(i).getId();
            if (cardId.equals(moveCardId)) {
                oriCards.remove(i);
            }
        }
        if (destinationRow == 99) {
            desCards.add(movedCard);
        } else {
            desCards.add(destinationRow - 1, movedCard);
        }
        if (!newCardsSetColumn(oriCards, originCol.getColName()) || !newCardsSetColumn(desCards, destinationColName)) {
            return null;
        }
        return movedCard;
    }

    private boolean newCardsSetColumn(List<Card> cards, String columnName) {
        List<Card> newCards = cardsRowReset(cards);
        Col column = colRepository.findColByColName(columnName).orElse(null);
        if (column == null) {
            return false;
        }
        column.setCards(newCards);
        colRepository.save(column);
        return true;
    }

    public List<Card> cardsRowReset(List<Card> cards) {
        int rowIdx = 1;
        for (int i = 0; i < cards.size(); i++) {
            Card tempCard = cards.get(i);
            if (tempCard.getDeleted() || tempCard.getRow() == 0) {
                continue;
            }
            tempCard.setRow(rowIdx);
            rowIdx++;
        }
        return cards;
    }

    public Card deleteCard(Long deleteCardId) {
        log.info("Deleted Card ID----------------{}",deleteCardId );
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
        return jwtTokenDecode.getLoginUser("userName");
    }

    private String getJwtToken(User user) {
        JwtTokenProvider jwtTokenProvider = new JwtTokenProvider();
        return jwtTokenProvider.JwtTokenMaker(user);
    }
}
