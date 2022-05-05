package com.groundwater.config;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.springframework.beans.factory.annotation.Value;

public class SessionListener implements HttpSessionListener{
	@Value("${server.servlet.session.timeout}")
	private int sessionTimeOut;
	
	public void sessionCreated(HttpSessionEvent sessionEvent) {
		sessionEvent.getSession().setMaxInactiveInterval(sessionTimeOut);
	}
	
	public void sessionDestroyed(HttpSessionEvent sessionEvent) {
		
	}
}
