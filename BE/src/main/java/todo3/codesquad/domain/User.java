package todo3.codesquad.domain;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class User {
    private String userId;
    private String userPassword;

    public User(String userId , String userPassword) {
        this.userId = userId;
        this.userPassword = userPassword;
    }
}
