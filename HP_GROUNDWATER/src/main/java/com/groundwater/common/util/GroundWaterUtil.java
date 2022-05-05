package com.groundwater.common.util;

import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Component;

@Component
public class GroundWaterUtil {
	public HashMap<String, Object> assignRequest(HttpServletRequest request, HashMap<String, Object> params) {
		Enumeration<String> paramsEnum = request.getParameterNames();
		while (paramsEnum.hasMoreElements()) {
			String key = paramsEnum.nextElement();
			String value = request.getParameter(key);
			
			params.put(key, value);
		}
		
		return params;
	}
	
	public boolean isNull(Object value) {
		if ("".equals(value) || value == null || "null".equals(value) || "".equals(((String) value).replaceAll("\\s", ""))) {
			return true;
		}
		
		return false;
	}
}
