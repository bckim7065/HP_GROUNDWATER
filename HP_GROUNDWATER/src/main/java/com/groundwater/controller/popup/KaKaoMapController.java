package com.groundwater.controller.popup;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.groundwater.common.util.*;

@Controller
@RequestMapping("/mobile")
public class KaKaoMapController {
	private final String KAKAO_TOKEN = "08d3afeb28134eaa050a184a0443d346";
	
	@RequestMapping("/openKaKaoMap")
	public String openKaKaoMap(HttpServletRequest request, Model model) {
		GroundWaterUtil groundWaterUtil = new GroundWaterUtil();
		HashMap<String, Object> params = new HashMap<>();
		groundWaterUtil.assignRequest(request, params);
		
		model.addAttribute("KAKAO_TOKEN", KAKAO_TOKEN);
		model.addAttribute("dvsCd", params.get("dvsCd"));
		model.addAttribute("address", params.get("address"));
		return "/mobile/popup/kakaoMap";
	}
}
