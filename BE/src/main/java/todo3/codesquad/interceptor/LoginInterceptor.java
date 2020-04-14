package todo3.codesquad.interceptor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import todo3.codesquad.security.JwtTokenDecode;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor extends HandlerInterceptorAdapter {

    private String TOKEN_KEY_IN_HEADER = "token";

    private static final Logger log =
            LoggerFactory.getLogger(LoginInterceptor.class);
    private static final String TIME = "TIME";
    private static final String URL = "URL";
    private static final String METHOD = "METHOD";



    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        request.setAttribute(TIME, System.currentTimeMillis());
        request.setAttribute(URL, request.getRequestURL());
        request.setAttribute(METHOD, request.getMethod());
        String givenToken = request.getHeader(TOKEN_KEY_IN_HEADER);

        if(givenToken == null){
            log.debug("There is no token");
            return false;
        }

        JwtTokenDecode jwtTokenDecode = new JwtTokenDecode();

        return jwtTokenDecode.checkJwt(givenToken);
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) {
        long startTime = (long)request.getAttribute(TIME);
        log.debug("{} {} {}", request.getAttribute(METHOD), request.getAttribute(URL), System.currentTimeMillis() - startTime);
    }
}
