package todo3.codesquad.domain;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.Id;

@Getter
@Setter
public class User {

    @Id
    private Long id;
    private String userName;
    private String userId;
    private String userPassword;

    public User(String userName, String userId, String userPassword) {
        this.userName = userName;
        this.userId = userId;
        this.userPassword = userPassword;
    }
}
