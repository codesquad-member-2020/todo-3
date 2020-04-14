package todo3.codesquad.security;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.expression.ExpressionException;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.xml.bind.DatatypeConverter;

public class JwtTokenDecode {

    private static final Logger log =
            LoggerFactory.getLogger(JwtTokenDecode.class);

    public boolean checkJwt(String jwt) {
        try {
            Claims claims = Jwts.parser().setSigningKey(DatatypeConverter.parseBase64Binary("todo"))
                    .parseClaimsJws(jwt).getBody();
            log.debug("{}", claims);
            System.out.println(claims.get("userName"));
            return true;
        } catch (ExpressionException e) {
            log.debug("Token is timed out");
            return false;
        } catch (JwtException e) {
            log.debug("Token is not verified");
            return false;
        }
    }

    public String getLoginUser(String key) {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        String jwt = request.getHeader("Authorization");
        Claims claims = Jwts.parser().setSigningKey(DatatypeConverter.parseBase64Binary("todo"))
                .parseClaimsJws(jwt).getBody();
        return (String) claims.get("userName");

    }
}
