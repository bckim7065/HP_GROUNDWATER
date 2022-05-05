package com.groundwater.config;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Configuration
public class WebConfig extends WebMvcConfigurerAdapter {
	@Autowired
	CertificationInterceptor certificationInterceptor;
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		String[] excludePath = {"/mobile", "/mobile/login", "/mobile/logout", "/js/**", "/css/**", "/images/**"};
		registry.addInterceptor(certificationInterceptor).excludePathPatterns(Arrays.asList(excludePath)).addPathPatterns("/**/*");
	}
}
