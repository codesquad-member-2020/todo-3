package todo3.codesquad.Controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import todo3.codesquad.domain.*;
import todo3.codesquad.message.FailedMessage;
import todo3.codesquad.message.ResponseMessage;
import todo3.codesquad.message.SuccessMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import todo3.codesquad.security.JwtTokenProvider;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin
public class TodoController {

    private static final Logger log = LoggerFactory.getLogger(TodoController.class);

    @Autowired
    UserRepository userRepository;

    @Autowired
    ColRepository colRepository;

    @Autowired
    CardRepository cardRepository;

    @PostMapping("/api/requestToken")
    public ResponseEntity<ResponseMessage> userLogin(@RequestBody Map<String,Object> map) {
        JwtTokenProvider jwtTokenProvider = new JwtTokenProvider();
        String userId = map.get("userId").toString();
        User defaultUser = userRepository.findDefaultUser();
        User user = userRepository.findByUserId(userId).orElse(defaultUser);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_LOGIN, jwtTokenProvider.JwtTokenMaker(user)), HttpStatus.OK);
    }

    @PostMapping("/api/cards")
    public ResponseEntity<ResponseMessage> createCard(@RequestBody Map<String, Object> map) {
        Col col = colRepository.findByColName(map.get("colName").toString()).orElse(null);
        if (col == null) {
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE, null), HttpStatus.NOT_FOUND);
        }
        List<Card> cards = col.getCards();
        Card card = new Card(map);
        cards.add(card);
        colRepository.save(col);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_CREATE, card), HttpStatus.OK);
    }

    @PutMapping("/api/cards")
    public ResponseEntity<ResponseMessage> updateCard(@RequestBody Map<String, Object> map) {
        Col col = colRepository.findByColName(map.get("colName").toString()).orElse(null);
        if (col == null) {
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE, null), HttpStatus.NOT_FOUND);
        }
        List<Card> cards = col.getCards();
        Card card = cards.get((int) map.get("row") - 1);
        card.update(map);
        colRepository.save(col);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_UPDATE, card), HttpStatus.OK);
    }

    @PostMapping("/api/cards/move")
    public ResponseEntity<ResponseMessage> moveCard(@RequestBody Map<String, Object> map) {
        String originColName = map.get("originColName").toString();
        String destinationColName = map.get("destinationColName").toString();
        int originRow = Integer.parseInt(map.get("originRow").toString());
        int destinationRow = Integer.parseInt(map.get("destinationRow").toString());

        Col originCol = colRepository.findByColName(originColName).orElse(null);
        Col destinationCol = colRepository.findByColName(destinationColName).orElse(null);
        if (originCol == null || destinationCol == null) {
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE, null), HttpStatus.NOT_FOUND);
        }
        List<Card> originCards = originCol.getCards();
        List<Card> destinationCards = destinationCol.getCards();

        if (originRow > originCards.size()) {
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.SIZE_ERROR_MESSAGE, null), HttpStatus.BAD_REQUEST);
        }
        if (destinationRow > destinationCards.size()) {
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.SIZE_ERROR_MESSAGE, null), HttpStatus.BAD_REQUEST);
        }
        Card movedCard = originCards.get(originRow - 1);
        originCards.remove(originRow - 1);
        for (int i = 0; i < originCards.size(); i++) {
            Card card = originCards.get(i);
            card.setRow(i + 1);
        }

        destinationCards.add(destinationRow - 1, movedCard);
        for (int i = 0; i < destinationCards.size(); i++) {
            Card card = destinationCards.get(i);
            card.setRow(i + 1);
        }

        colRepository.save(originCol);
        colRepository.save(destinationCol);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_MOVE, movedCard), HttpStatus.OK);
    }

    @DeleteMapping("/api/cards")
    public ResponseEntity<ResponseMessage> deleteCard(@RequestBody Map<String, Object> map) {
        Card card = cardRepository.findById(Long.parseLong(map.get("id").toString())).orElse(null);
        Long cardId = Long.parseLong(map.get("id").toString());
        Long colId = cardRepository.findColByCardId(cardId);
        Col col = colRepository.findById(colId).orElse(null);
        if (card.getRow() != col.getCards().size()) {
            for (int i = card.getRow(); i < col.getCards().size(); i++) {
                Card otherCard = col.getCards().get(i);
                otherCard.setRow(otherCard.getRow() - 1);
            }
            colRepository.save(col);
        }
        if (card == null) {
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE, null), HttpStatus.NOT_FOUND);
        }
        card.delete();
        cardRepository.save(card);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_DELETE, card), HttpStatus.OK);
    }

    @GetMapping("/api/cards/show")
    public ResponseEntity<ResponseMessage> showCards() {
        List<Response> resultResponse = new ArrayList<>();
        List<Integer> colNames = colRepository.findColIdByNotDeleted();
        for (int i = 0; i < colNames.size(); i++) {
            Integer idx = colNames.get(i);
            String columnName = colRepository.findColNameByNotDeleted(idx);
            List<Card> tempCards = cardRepository.findAllByColumnCard(idx);
            Response response = new Response(columnName, tempCards);
            resultResponse.add(response);
        }
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_SHOW, resultResponse), HttpStatus.OK);
    }
}
