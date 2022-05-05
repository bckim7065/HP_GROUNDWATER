package com.groundwater.service.main;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.groundwater.repository.main.MainMp;

@Service
public class MainService {
	@Autowired MainMp mainMp;
	public List<HashMap<String, Object>> getUserProjectInfo(String pjtNo, String memberMobile) {
		List<HashMap<String, Object>> result = null;
		try {
			HashMap<String, Object> paraMap = new HashMap<>();
			paraMap.put("pjtNo", pjtNo);
			paraMap.put("memberMobile", memberMobile);

			mainMp.getUserProjectInfo(paraMap);
			result = (List<HashMap<String, Object>>) paraMap.get("list");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public List<HashMap<String, Object>> getProjectInfo(String pjtNo, String searchText) {
		List<HashMap<String, Object>> result = null;
		try {
			HashMap<String, Object> paraMap = new HashMap<>();
			paraMap.put("pjtNo", pjtNo);
			paraMap.put("searchText", searchText);
			
			mainMp.getProjectInfo(paraMap);
			result = (List<HashMap<String, Object>>) paraMap.get("list");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
}
