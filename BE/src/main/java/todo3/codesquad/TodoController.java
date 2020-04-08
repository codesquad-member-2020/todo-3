package todo3.codesquad;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.List;

@RestController
public class TodoController {

    @Autowired
    ColRepository colRepository;

    @PostMapping("/api/cards")
    public Col createCard(String colName) {
        Col col = colRepository.findByColName(colName);
        List<Card> cards = col.getCards();
        for (int i = 0; i < 10; i++) {
            Card card = new Card();
            card.setTitle("mocha Title" + i);
            card.setContents("mocha Contents" + i);
            card.setWriter("mocha");
            card.setDeleted(false);
            card.setWrittenTime(LocalDateTime.now());
            cards.add(card);
        }

        colRepository.save(col);
        return col;
    }
}
