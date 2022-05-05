package com.groundwater.service.contents;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;

import com.groundwater.repository.contents.ContentsMp;

@Service
public class ContentsService {
	@Autowired ContentsMp contentsMp;
	
	public List<HashMap<String, Object>> getListMain(String pjtNo, String siteNo) {
		List<HashMap<String, Object>> result = null;
		HashMap<String, Object> paraMap = new HashMap<>();
		paraMap.put("pjtNo", pjtNo);
		paraMap.put("siteNo", siteNo);
		
		try {
			contentsMp.getListMain(paraMap);
			
			result = (List<HashMap<String, Object>>)paraMap.get("list");
			for (int i = 0; i < result.size(); i++) {
				HashMap<String, Object> row = result.get(i);
				String[] WQ_PL = {};
				String[] CL_FC = {};
				
				if (!isNull(row.get("WQ_PL"))) {
					String temp = (String)row.get("WQ_PL");
					WQ_PL = temp.split("\\^");
				}
				
				if (!isNull(row.get("CL_FC"))) {
					String temp = (String)row.get("CL_FC");
					CL_FC = temp.split("\\^");
					
				}
				
				for (int n = 0; n < WQ_PL.length; n++) {
					String colName = "WQ_PL_" + WQ_PL[n];
					result.get(i).put(colName, WQ_PL[n]);
				}
				
				for (int m = 0; m < CL_FC.length; m++) {
					String colName = "CL_FC_" + CL_FC[m];
					result.get(i).put(colName, CL_FC[m]);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	

	public List<HashMap<String, Object>> getListPurPose(String dvsCd, String kind) {
		List<HashMap<String, Object>> result = null;
		HashMap<String, Object> paraMap = new HashMap<>();
		paraMap.put("dvsCd", dvsCd);
		paraMap.put("kind", kind);
		
		try {
			contentsMp.getListPurPose(paraMap);
			result = (List<HashMap<String, Object>>)paraMap.get("list");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	private boolean isNull(Object value) {
		if ("".equals(value) || value == null || "".equals(((String) value).replaceAll("\\s", ""))) {
			return true;
		}
		
		return false;
	}


	public List<HashMap<String, Object>> getListPurPoseDetail(String dvsCd, String kind, String code, String upCode) {
		List<HashMap<String, Object>> result = null;
		HashMap<String, Object> paraMap = new HashMap<>();
		HashMap<String, Object> spccCodeParaMap = new HashMap<>();
		spccCodeParaMap.put("dvsCd", dvsCd);
		spccCodeParaMap.put("kind", kind);
		spccCodeParaMap.put("code", code);
		spccCodeParaMap.put("upCode", upCode);
		
		try {
			contentsMp.getSpccCodeName(spccCodeParaMap);
			List<HashMap<String, Object>> spccCodeList = (List<HashMap<String, Object>>) spccCodeParaMap.get("list");
			String parentCode = String.valueOf(spccCodeList.get(0).get("IDX"));
				
			spccCodeParaMap.put("dvsCd", "UPCODE");
			spccCodeParaMap.put("kind", "세부용도");
			spccCodeParaMap.put("code", "");
			spccCodeParaMap.put("upCode", parentCode);
			
			spccCodeParaMap.put("dvsCd", "UPCODE");
			spccCodeParaMap.put("kind", "세부용도");
			spccCodeParaMap.put("code", "");
			spccCodeParaMap.put("upCode", parentCode);
			contentsMp.getSpccCodeName(spccCodeParaMap);
			result = (List<HashMap<String, Object>>)spccCodeParaMap.get("list");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	public List<HashMap<String, Object>> getSpccCodeName(String dvsCd, String kind, String code, String upCode) {
		List<HashMap<String, Object>> result = null;
		HashMap<String, Object> paraMap = new HashMap<>();
		paraMap.put("dvsCd", dvsCd);
		paraMap.put("kind", kind);
		paraMap.put("code", code);
		paraMap.put("upCode", upCode);
		
		try {
			contentsMp.getSpccCodeName(paraMap);
			result = (List<HashMap<String, Object>>) paraMap.get("list");
		} catch (Exception e) {
			e.printStackTrace();
			result = new ArrayList<HashMap<String, Object>>();
		}
		
		return result;
	}
	
	public HashMap<String, Object> getEditStatus(HashMap<String, Object> params) {
		HashMap<String, Object> result = new HashMap<>();
		List<HashMap<String, Object>> data = null;
		
		try {
			data = contentsMp.getEditStatus(params);
			
			result.put("rstCd", "200");
			result.put("data", data.get(0).get("ETC_01"));
		} catch (Exception e) {
			result.put("rstCd", 500);
			result.put("data", null);
			result.put("error", "getEditStatus");
			
			e.printStackTrace();
		}
		
		return result;
	}


	public boolean saveData(HashMap<String, Object> params) {
		// TODO Auto-generated method stub
		try {
			contentsMp.saveData(params);
		} catch (Exception e) {
			return false;
		}
		
		return true;
	}
	
	public boolean savePop(HashMap<String, Object> params) {
		// TODO Auto-generated method stub
		try {
			contentsMp.savePop(params);
		} catch(Exception e) {
			e.printStackTrace();
			return false;
		}
		
		return true;
	}


	public List<HashMap<String, Object>> getPhotoMain(HashMap<String, Object> params) {
		// TODO Auto-generated method stub
		List<HashMap<String, Object>> result = contentsMp.getPhotoMain(params);
		
		return result;
	}


	public boolean saveFile(HashMap<String, Object> params) {
		try {
			int result = contentsMp.saveFile(params);
			return true;
		} catch (Exception e) {
			return false;
		}
	}


	public boolean deleteFile(HashMap<String, Object> params) {
		int result = contentsMp.deleteFile(params);
		return result == 0 ? false : true;
	}
}
