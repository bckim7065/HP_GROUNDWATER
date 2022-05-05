package com.groundwater.config;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.groundwater.common.util.GroundWaterUtil;

@Component
public class CertificationInterceptor implements HandlerInterceptor {
	@Autowired
	GroundWaterUtil commonUtil;
	@Value("${server.servlet.session.timeout}")
	int sessionTimeOut;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession();
		String userId = String.valueOf(session.getAttribute("SS_M_USER_ID"));
		
		if (commonUtil.isNull(userId)) {
			String redirectUrl = request.getContextPath() + "/mobile";
			response.sendRedirect(redirectUrl);
			return false;
		} else {
			session.setMaxInactiveInterval(sessionTimeOut);
			return true;
		}
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		
	}
}
