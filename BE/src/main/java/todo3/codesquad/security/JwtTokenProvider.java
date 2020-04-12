package todo3.codesquad.security;


import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

import java.security.Key;
import java.time.LocalDateTime;
import java.util.Date;

public class JwtTokenProvider {
    public String JwtTokenMaker(String userName){
        Key key = Keys.secretKeyFor(SignatureAlgorithm.HS256);
        String jws = Jwts.builder()
                .setHeaderParam("typ","JWT")
                .setSubject("userName")
                .claim("userName",userName)
                .setExpiration(new Date(System.currentTimeMillis() + 1 * (1000 * 60 * 60 * 24)))
                .signWith(key,SignatureAlgorithm.HS256)
                .compact();
        return jws;
    }
}
