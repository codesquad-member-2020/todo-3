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
import todo3.codesquad.service.TodoService;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin
public class TodoController {

    private static final Logger log = LoggerFactory.getLogger(TodoController.class);
    private TodoService todoService;

    public TodoController(TodoService todoService) {
        this.todoService = todoService;
    }

    @Autowired
    UserRepository userRepository;

    @Autowired
    ColRepository colRepository;
    
    @PostMapping("/api/requestToken")
    public ResponseEntity<ResponseMessage> userLogin(@RequestBody Map<String, Object> requestBody) {
        JwtTokenProvider jwtTokenProvider = new JwtTokenProvider();
        String userId = requestBody.get("userId").toString();
        User defaultUser = userRepository.findDefaultUser();
        User user = userRepository.findByUserId(userId).orElse(defaultUser);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_LOGIN, jwtTokenProvider.JwtTokenMaker(user)), HttpStatus.OK);
    }

    @PostMapping("/api/cards")
    public ResponseEntity<ResponseMessage> createCard2(@RequestBody Map<String, Object> requestBody) {
        Card newCard = todoService.createCard(requestBody);
        if(newCard == null){
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.SIZE_ERROR_MESSAGE, newCard), HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_CREATE, newCard), HttpStatus.OK);
    }

    @PutMapping("/api/cards/{cardId}")
    public ResponseEntity<ResponseMessage> updateCard(@PathVariable Long cardId, @RequestBody Map<String, Object> requestBody) {
        Card updateCard = todoService.updateCard(cardId,requestBody);
        if(updateCard == null){
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.SIZE_ERROR_MESSAGE, updateCard), HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_UPDATE, updateCard), HttpStatus.OK);
    }

    @PatchMapping("/api/cards/{cardId}")
    public ResponseEntity<ResponseMessage> moveCard(@PathVariable Long cardId, @RequestBody Map<String, Object> requestBody) {
        Card movedCard = todoService.moveCard(cardId,requestBody);
        if (movedCard == null){
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.SIZE_ERROR_MESSAGE, movedCard), HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_MOVE, movedCard), HttpStatus.OK);
    }
//
//    @DeleteMapping("/api/cards/{cardId}")
//    public ResponseEntity<ResponseMessage> deleteCard(@PathVariable Long cardId, @RequestBody Map<String, Object> map) {
//        Card card = cardRepository.findById(Long.parseLong(map.get("id").toString())).orElse(null);
//        Long colId = cardRepository.findColByCardId(cardId);
//        Col col = colRepository.findById(colId).orElse(null);
//        if (card.getRow() != col.getCards().size()) {
//            for (int i = card.getRow(); i < col.getCards().size(); i++) {
//                Card otherCard = col.getCards().get(i);
//                otherCard.setRow(otherCard.getRow() - 1);
//            }
//            colRepository.save(col);
//        }
//        if (card == null) {
//            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE, null), HttpStatus.NOT_FOUND);
//        }
//        card.delete();
//        cardRepository.save(card);
//        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_DELETE, card), HttpStatus.OK);
//    }

//    @GetMapping("/api/cards/show")
//    public ResponseEntity<ResponseMessage> showCards() {
//        List<Response> resultResponse = new ArrayList<>();
//        List<Integer> colNames = colRepository.findColIdByNotDeleted();
//        for (int i = 0; i < colNames.size(); i++) {
//            Integer idx = colNames.get(i);
//            String columnName = colRepository.findColNameByNotDeleted(idx);
//            List<Card> tempCards = cardRepository.findAllByColumnCard(idx);
//            Response response = new Response(columnName, tempCards);
//            resultResponse.add(response);
//        }
//        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_SHOW, resultResponse), HttpStatus.OK);
//    }

    @GetMapping("/api/columns/{columnName}")
    public ResponseEntity<ResponseMessage> showColumn(@PathVariable String columnName) {
        columnName = columnName.replace("_", " ");
        Col col = colRepository.findByColName(columnName).orElse(null);
        List<Card> cards = col.getCards();
        List<Card> newCards = new ArrayList<>();

        for (int i = 0; i < cards.size(); i++) {
            Card tempCard = cards.get(i);
            if (!tempCard.getDeleted()) {
                newCards.add(tempCard);
            }
        }

        for (int i = 0; i < newCards.size(); i++) {
            Card tempCard = cards.get(i);
            tempCard.setRow(i + 1);
        }

        col.setCards(newCards);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_COL, col), HttpStatus.OK);
    }

    @PatchMapping ("/test/{id}")
    public ResponseEntity<ResponseMessage> test(@PathVariable Long id, @RequestBody Map<String,Object> map) {
        Card movedCard = todoService.moveCard(id,map);
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_COL, movedCard), HttpStatus.OK);
    }
}
