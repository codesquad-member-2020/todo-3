package todo3.codesquad.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.Id;

import java.time.LocalDateTime;
import java.util.Map;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class Card {

    @Id
    private Long id;

    private int row;

    private String title;

    private String contents;

    private String writer;

    private boolean deleted;

    private LocalDateTime writtenTime;

    public Card(Map<String, Object> map) {
        if (map.get("title") == null) {
            this.title = "New Card";
        } else {
            this.title = map.get("title").toString();
        }
        this.contents = map.get("contents").toString();
        this.writer = map.get("writer").toString();
        this.deleted = false;
        this.writtenTime = LocalDateTime.now();
    }

    public void update(Map<String, Object> map) {
        if (map.get("title") != null) {
            this.title = map.get("title").toString();
        }
        if (map.get("contents") != null) {
            this.contents = map.get("contents").toString();
        }
        if (map.get("writer") != null) {
            this.writer = map.get("writer").toString();
        }
        this.writtenTime = LocalDateTime.now();
    }

    public void delete() {
        this.deleted = true;
    }

    public boolean getDeleted() {
        return this.deleted;
    }
}
