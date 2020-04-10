package todo3.codesquad.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import todo3.codesquad.domain.Response;
import todo3.codesquad.message.FailedMessage;
import todo3.codesquad.message.ResponseMessage;
import todo3.codesquad.domain.Card;
import todo3.codesquad.domain.CardRepository;
import todo3.codesquad.domain.Col;
import todo3.codesquad.domain.ColRepository;
import todo3.codesquad.message.SuccessMessage;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
public class TodoController {

    @Autowired
    ColRepository colRepository;

    @Autowired
    CardRepository cardRepository;

    @PostMapping("/api/cards")
    public ResponseEntity<ResponseMessage> createCard(@RequestBody Map<String, Object> map) {
        Col col = colRepository.findByColName(map.get("colName").toString()).orElse(null);
        if(col == null){
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE,null), HttpStatus.NOT_FOUND);
        }
        List<Card> cards = col.getCards();
        Card card = new Card(map);
        cards.add(card);
        colRepository.save(col);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_CREATE,card), HttpStatus.OK);
    }

    @PostMapping("/api/cards/update")
    public ResponseEntity<ResponseMessage> updateCard(@RequestBody Map<String, Object> map) {
        Col col = colRepository.findByColName(map.get("colName").toString()).orElse(null);
        if(col == null){
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE,null), HttpStatus.NOT_FOUND);
        }
        List<Card> cards = col.getCards();
        Card card = cards.get((int) map.get("row") - 1);
        card.update(map);
        colRepository.save(col);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_UPDATE,card), HttpStatus.OK);
    }

    @PostMapping("/api/cards/move")
    public ResponseEntity<ResponseMessage> moveCard(@RequestBody Map<String, Object> map) {
        String originColName = map.get("originColName").toString();
        String destinationColName = map.get("destinationColName").toString();
        int originRow = Integer.parseInt(map.get("originRow").toString());
        int destinationRow = Integer.parseInt(map.get("destinationRow").toString());

        Col originCol = colRepository.findByColName(originColName).orElse(null);
        Col destinationCol = colRepository.findByColName(destinationColName).orElse(null);
        if(originCol == null || destinationCol == null){
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE,null), HttpStatus.NOT_FOUND);
        }
        List<Card> originCards = originCol.getCards();
        List<Card> destinationCards = destinationCol.getCards();

        if (originRow > originCards.size()) {
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.SIZE_ERROR_MESSAGE,null), HttpStatus.BAD_REQUEST);
        }
        if (destinationRow > destinationCards.size()) {
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.SIZE_ERROR_MESSAGE,null), HttpStatus.BAD_REQUEST);
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
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_MOVE,movedCard), HttpStatus.OK);
    }

    @PostMapping("/api/cards/delete")
    public ResponseEntity<ResponseMessage> deleteCard(@RequestBody Map<String, Object> map) {
        Card card = cardRepository.findById(Long.parseLong(map.get("id").toString())).orElse(null);
        if(card == null){
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE,null), HttpStatus.NOT_FOUND);
        }
        card.delete();
        cardRepository.save(card);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_DELETE,card), HttpStatus.OK);
    }

    @GetMapping("/api/cards/show")
    public ResponseEntity<ResponseMessage> showCards() {
        List<Response> resultResponse = new ArrayList<>();
        List<Integer> colNames = colRepository.findColIdByNotDeleted();
        for (int i = 0 ; i < colNames.size() ; i++){
            Integer idx = colNames.get(i);
            String columnName = colRepository.findColNameByNotDeleted(idx);
            List<Card> tempCards = cardRepository.findAllByColumCard(idx);
            Response response = new Response(columnName,tempCards);
            resultResponse.add(response);
        }
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_SHOW,resultResponse), HttpStatus.OK);
    }
}
