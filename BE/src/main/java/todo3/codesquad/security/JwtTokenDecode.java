package todo3.codesquad.security;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import org.springframework.expression.ExpressionException;

import javax.xml.bind.DatatypeConverter;

public class JwtTokenDecode {
    public boolean checkJwt(String jwt) {
        try{
            Claims claims = Jwts.parser().setSigningKey(DatatypeConverter.parseBase64Binary("todo"))
                    .parseClaimsJws(jwt).getBody();

            return true;
        } catch (ExpressionException e){
            return false;
        } catch (JwtException e){
            return false;
        }
    }
}
