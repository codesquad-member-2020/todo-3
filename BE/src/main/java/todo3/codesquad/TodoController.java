package todo3.codesquad;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin
public class TodoController {

    @Autowired
    ColRepository colRepository;

    @Autowired
    CardRepository cardRepository;

    @PostMapping("/api/cards")
    public void createCard(@RequestBody Map<String, Object> map) {
        Col col = colRepository.findByColName(map.get("colName").toString()).orElse(null);
        List<Card> cards = col.getCards();
        Card card = new Card(map);
        cards.add(card);
        colRepository.save(col);
    }

    @PostMapping("/api/cards/update")
    public void updateCard(@RequestBody Map<String, Object> map) {
        Col col = colRepository.findByColName(map.get("colName").toString()).orElse(null);
        List<Card> cards = col.getCards();
        Card card = cards.get((int) map.get("row") - 1);
        card.update(map);
        colRepository.save(col);
    }

    @PostMapping("/api/cards/move")
    public void moveCard(@RequestBody Map<String, Object> map) {
        String originColName = map.get("originColName").toString();
        String destinationColName = map.get("destinationColName").toString();
        int originRow = Integer.parseInt(map.get("originRow").toString());
        int destinationRow = Integer.parseInt(map.get("destinationRow").toString());

        Col originCol = colRepository.findByColName(originColName).orElse(null);
        Col destinationCol = colRepository.findByColName(destinationColName).orElse(null);

        List<Card> originCards = originCol.getCards();
        List<Card> destinationCards = destinationCol.getCards();

        if (originRow > originCards.size()) {
            System.out.println("멀 옴기는거야?");
        }
        if (destinationRow > destinationCards.size()) {
            System.out.println("어디다 옴기는거야?");
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
    }

    @PostMapping("/api/cards/delete")
    public void deleteCard(@RequestBody Map<String, Object> map) {
        Card card = cardRepository.findById(Long.parseLong(map.get("id").toString())).orElse(null);
        card.delete();
        cardRepository.save(card);
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


        return new ResponseEntity<>(new ResponseMessage(resultResponse), HttpStatus.OK);
    }
}
