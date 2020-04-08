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
}
