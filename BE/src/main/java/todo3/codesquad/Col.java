package todo3.codesquad;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.springframework.data.annotation.Id;

import java.util.List;

@Getter @Setter @ToString @NoArgsConstructor
public class Col {

    @Id
    private Long id;

    private String colName;

    private boolean deleted;

    private List<Card> cards;

}
