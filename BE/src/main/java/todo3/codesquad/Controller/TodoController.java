package todo3.codesquad.Controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
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

import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin
public class TodoController {

    private static final Logger log = LoggerFactory.getLogger(TodoController.class);
    private TodoService todoService;
    private UserRepository userRepository;

    public TodoController(TodoService todoService, UserRepository userRepository) {
        this.todoService = todoService;
        this.userRepository = userRepository;
    }

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

    @DeleteMapping("/api/cards/{cardId}")
    public ResponseEntity<ResponseMessage> deleteCard(@PathVariable Long cardId) {
        Card deletedCard = todoService.deleteCard(cardId);
        if (deletedCard == null) {
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE, deletedCard), HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_DELETE, deletedCard), HttpStatus.OK);
    }

    @GetMapping("/api/cards/show")
    public ResponseEntity<ResponseMessage> showCards() {
        List<Col> columns = todoService.showColumns();
        if (columns == null){
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE, columns), HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_SHOW, columns), HttpStatus.OK);
    }

    @GetMapping("/api/columns/{columnName}")
    public ResponseEntity<ResponseMessage> showColumn(@PathVariable String columnName) {
        Col column = todoService.showColumn(columnName);
        if (column == null){
            return new ResponseEntity<>(new ResponseMessage(FailedMessage.NULL_DATA_MESSAGE, column), HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(new ResponseMessage(SuccessMessage.SUCCESS_COL, column), HttpStatus.OK);
    }
}
