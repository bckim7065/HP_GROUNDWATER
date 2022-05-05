package com.groundwater.controller.login;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.groundwater.service.login.LoginService;

@Controller
public class LoginController {
	@Autowired LoginService loginService;
	
	@RequestMapping(value= {"/mobile", "/"})
	public String main() {
		return "mobile/login/login";
	}
	
	
	@RequestMapping("/mobile/login")
	@ResponseBody
	public HashMap<String, Object> login(HttpServletRequest request, String mobileNumber) {
		HashMap<String, Object> res = loginService.checkLogin(request, mobileNumber);
		return res;
	}
}
