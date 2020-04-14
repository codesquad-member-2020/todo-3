package todo3.codesquad;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import springfox.documentation.swagger2.annotations.EnableSwagger2;
import todo3.codesquad.interceptor.LoginInterceptor;

@SpringBootApplication
@EnableSwagger2
@EnableAspectJAutoProxy
public class CodesquadApplication implements WebMvcConfigurer {

    public static void main(String[] args) {
        SpringApplication.run(CodesquadApplication.class, args);
    }

    @Bean
    public LoginInterceptor loginInterceptor() {
        return new LoginInterceptor();
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor())
                .addPathPatterns("/api/**")
                .excludePathPatterns("/api/requestToken");
    }
}

