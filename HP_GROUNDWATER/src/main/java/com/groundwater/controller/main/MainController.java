package com.groundwater.controller.main;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.groundwater.common.util.GroundWaterUtil;
import com.groundwater.service.main.MainService;

@Controller
@RequestMapping("/mobile")
public class MainController {
	@Autowired MainService mainService;
	@Autowired GroundWaterUtil commonUtil;
	
	@RequestMapping("/main")
	public String main(HttpServletRequest request, @RequestParam(required = false)String pjtNo, @RequestParam(required = false, defaultValue = "")String searchText, Model model) {
		HttpSession session = request.getSession();
		
		String memberMobile = String.valueOf(session.getAttribute("SS_M_USER_ID"));
		pjtNo = commonUtil.isNull(pjtNo) ? String.valueOf(session.getAttribute("SS_M_PJT_NO")) : pjtNo;
		
		List<HashMap<String, Object>> userProjectInfo = mainService.getUserProjectInfo(pjtNo, memberMobile);
		List<HashMap<String, Object>> projectInfo = mainService.getProjectInfo(pjtNo, searchText);
		
		String pjtNm = "";
		for (int i = 0; i < userProjectInfo.size(); i++) {
			HashMap<String, Object> row = userProjectInfo.get(i);
			
			if (pjtNo.equals(row.get("PJT_NO"))) {
				pjtNm = String.valueOf(row.get("PJT_NM"));
				break;
			}
		}
		
		model.addAttribute("userProjectInfo", userProjectInfo);
		model.addAttribute("projectInfo", projectInfo);
		model.addAttribute("pjtNo", pjtNo);
		model.addAttribute("pjtNm", pjtNm);
		
		return "mobile/main/main";
	}
	
	@RequestMapping("/logout")
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.removeAttribute("SS_M_USER_ID");
		session.removeAttribute("SS_M_PJT_NO");
		session.setMaxInactiveInterval(0);
		return "/mobile/login/logout";
	}
}
