package com.nickthecloudguy.redis.passwordless;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

@SpringBootApplication
@EnableCaching
public class RedisPasswordlessApplication {

	public static void main(String[] args) {
		SpringApplication.run(RedisPasswordlessApplication.class, args);
	}

	@ControllerAdvice
    public class ExceptionHandlerControllerAdvice extends ResponseEntityExceptionHandler {
        private static final Logger log = LoggerFactory.getLogger(ExceptionHandlerControllerAdvice.class);

        @ExceptionHandler(Exception.class)
        public ProblemDetail exceptionHandler(Exception ex) {
            log.error("Error", ex);
            ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, ex.getMessage());
            return pd;
        }
    }
}
