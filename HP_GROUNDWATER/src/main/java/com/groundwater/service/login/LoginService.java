package com.groundwater.service.login;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groundwater.repository.login.LoginServiceMp;

@Service
public class LoginService {
	@Autowired LoginServiceMp loginServiceMp;
	public HashMap<String, Object> checkLogin(HttpServletRequest request, String mobileNumber) {
		List<HashMap<String, Object>> result = loginServiceMp.checkLogin(mobileNumber);
		HashMap<String, Object> rtn = new HashMap<>();
		
		try {
			if (result.size() > 0) {
				boolean sessionResult = setSession(request, result);
				
				if (!sessionResult) {
					rtn.put("rstCd", "500");
					rtn.put("res", null);
					rtn.put("erorr", getError("500", "세션처리에 실패하였습니다."));
				} else {
					rtn.put("rstCd", "200");
					rtn.put("res", result);
				}
			} else {
				rtn.put("rstCd", "401");
				rtn.put("res", null);
			}
		} catch(Exception e) {
			
		}
		
		return rtn;
	}
	
	public boolean setSession(HttpServletRequest request, List<HashMap<String, Object>> result) {
		HttpSession session = request.getSession();
		String sessionId = (String)session.getAttribute("SS_M_USER_ID");
		
		if (sessionId != null) {
			return true;
		} 
		
		try {
			if (result.size() != 0) {
				session.setAttribute("SS_M_USER_ID", result.get(0).get("MEMBER_MOBILE"));
				session.setAttribute("SS_M_USER_NM", result.get(0).get("MEMBER_NM"));
				session.setAttribute("SS_M_PJT_NO", result.get(0).get("PJT_NO"));
			}
			
		} catch (Exception e) {
			return false;
		}
		
		return true;
	}
	
	public HashMap<String, String> getError(String code, String msg) {
		HashMap<String, String> error = new HashMap<>();
		error.put("code", code);
		error.put("msg", msg);
		
		return error;
	}
}
