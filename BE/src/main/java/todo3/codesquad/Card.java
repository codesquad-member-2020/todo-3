package todo3.codesquad;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.Id;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;

@Getter @Setter @ToString
public class Card {

    @Id
    private int id;

    private String title;

    private String contents;

    private String writer;

    private boolean deleted;

    private LocalDateTime writtenTime;

    public Card(HashMap<String,Object> map) {
        this.title = map.get("title").toString();
        this.contents = map.get("contents").toString();
        this.writer = map.get("writer").toString();
        this.deleted = false;
        this.writtenTime = LocalDateTime.now();
    }

    public void update(HashMap<String,Object> map) {
        this.title = map.get("title").toString();
        this.contents = map.get("contents").toString();
        this.writer = map.get("writer").toString();
        this.deleted = false;
        this.writtenTime = LocalDateTime.now();
    }
}
