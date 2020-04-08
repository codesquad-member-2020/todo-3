package todo3.codesquad;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class TodoController {

    @Autowired
    ColRepository colRepository;

    @PostMapping("/api/cards")
    public void createCard(@RequestBody Map<String,Object> map) {
        System.out.println(colRepository.findByColName(map.get("colName").toString()).orElse(null));
        Col col = colRepository.findByColName(map.get("colName").toString()).orElse(null);
        List<Card> cards = col.getCards();
        Card card = new Card(map);
        cards.add(card);
        colRepository.save(col);
    }

    @PostMapping("/api/cards/update")
    public void updateCard(@RequestBody Map<String,Object> map) {
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

        Card originCard = originCards.get(originRow - 1);
        originCards.remove(originRow - 1);
        if(destinationCards.size() > destinationRow -1){
            destinationCards.add(destinationRow - 1,originCard);
        }
        destinationCards.add(originCard);

        colRepository.save(originCol);
        colRepository.save(destinationCol);
    }
}
