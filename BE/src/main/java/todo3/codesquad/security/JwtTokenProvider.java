package todo3.codesquad.security;

import javax.annotation.PostConstruct;
import java.util.Base64;
import java.util.List;

public class JwtTokenProvider {
    private String secretKey = "todo3";

    private long tokenValidTime = 30 * 24 * 60 * 1000L;

    @PostConstruct
    protected void init() {
        secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
    }

    public String createToken(String userPk, List<String> roles) {
        return "";
    }

}
