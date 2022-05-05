package com.groundwater;

import javax.servlet.http.HttpSessionListener;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import com.groundwater.config.SessionListener;

@SpringBootApplication
public class HpGroundwaterApplication {

	public static void main(String[] args) {
		SpringApplication.run(HpGroundwaterApplication.class, args);
	}
	
	@Bean
	public HttpSessionListener httpSessionListener() {
		return new SessionListener();
	}

}
