package com.groundwater.config;

import org.springframework.boot.web.server.ErrorPage;
import org.springframework.boot.web.server.ErrorPageRegistrar;
import org.springframework.boot.web.server.ErrorPageRegistry;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;

/**
 * <pre>
 * [에러페이지 설정]
 * 
 * 관리책임 : 김병철
 * 변경이력 (작성일자 / 작성자 / 요청자 / 내용) : 
 *     1. 2022-03-12 / 김병철 / - / 최초작성
 * </pre> 	
 */
@Configuration
public class ErrorConfig {		
	@Bean
	public ErrorPageRegistrar errorPageRegistrar() {
		return new MyErrorPageRegistrar();
	}

	private static class MyErrorPageRegistrar implements ErrorPageRegistrar {
		@Override
		public void registerErrorPages(ErrorPageRegistry registry) {		
			registry.addErrorPages(new ErrorPage(HttpStatus.UNAUTHORIZED, "/mobile/error/401"));
			registry.addErrorPages(new ErrorPage(HttpStatus.FORBIDDEN, "/mobile/error/403"));
			registry.addErrorPages(new ErrorPage(HttpStatus.NOT_FOUND, "/mobile/error/404"));			
			registry.addErrorPages(new ErrorPage(HttpStatus.INTERNAL_SERVER_ERROR, "/mobile/error/500"));			
			registry.addErrorPages(new ErrorPage("/mobile/error/500"));
		}
	}	
}
