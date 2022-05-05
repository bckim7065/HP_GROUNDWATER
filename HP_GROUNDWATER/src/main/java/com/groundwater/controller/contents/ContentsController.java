package com.groundwater.controller.contents;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.groundwater.common.file.GroundWaterFile;
import com.groundwater.common.util.GroundWaterUtil;
import com.groundwater.service.contents.ContentsService;

@Controller
@RequestMapping("/mobile")
public class ContentsController {
	@Autowired 
	ContentsService contentsService;
	@Autowired 
	GroundWaterFile commonFile;
	@Autowired 
	GroundWaterUtil commonUtil;
	@Value("${file.uploadBase}")
	String uploadBase;
	
	@RequestMapping("/saveData")
	@ResponseBody
	public HashMap<String, Object> saveData(HttpServletRequest request) {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> params = new HashMap<>();
		HttpSession session = request.getSession();
		commonUtil.assignRequest(request, params);
		params.put("SS_M_USER_ID", session.getAttribute("SS_M_USER_ID"));
		params.put("SS_M_USER_NM", session.getAttribute("SS_M_USER_NM"));
		boolean dbResult = contentsService.saveData(params);
		if (dbResult) {
			result.put("rstCd", "200");
			result.put("msg", "success");
		} else {
			result.put("rstCd", "500");
			result.put("msg", "procedure error");
		}
		
		return result;
	}
	
	@RequestMapping("/savePop")
	@ResponseBody
	public HashMap<String, Object> savePop(HttpServletRequest request) {
		HashMap<String, Object> result = new HashMap<>();
		HashMap<String, Object> paraMap = new HashMap<>();
		Enumeration<String> params = request.getParameterNames();
		while (params.hasMoreElements()) {
			String key = params.nextElement();
			String value = request.getParameter(key);
			paraMap.put(key, value);
		}
		
		HttpSession session = request.getSession();
		paraMap.put("SS_M_USER_ID", session.getAttribute("SS_M_USER_ID"));
		paraMap.put("SS_M_USER_NM", session.getAttribute("SS_M_USER_NM"));
		boolean dbResult = contentsService.savePop(paraMap);
		if (dbResult) {
			result.put("rstCd", "200");
			result.put("msg", "success");
		} else {
			result.put("rstCd", "500");
			result.put("msg", "db error");
		}
		
		return result;
	}
	
	@RequestMapping("/edit")
	public String edit(HttpServletRequest reqeust, String pjtNo, String siteNo, String viewSiteNo, String pjtNm, Model model) {
		// 관정관리 현황
		List<HashMap<String, Object>> listMain = contentsService.getListMain(pjtNo, siteNo);
		// 용도 리스트
		List<HashMap<String, Object>> listPurPose = contentsService.getListPurPose("List", "용도");
		List<HashMap<String, Object>> listPurPoseDetail = null;
		if (listPurPose.size() > 0) {
			String VM_PURPOSE_MOD = (String)listMain.get(0).get("WM_PURPOSE_MOD");
			if (!commonUtil.isNull(listMain.get(0).get("WM_PURPOSE_MOD"))) {
				listPurPoseDetail = contentsService.getListPurPoseDetail("", "용도", VM_PURPOSE_MOD, "");
			}	
		}
		// 관정현황리스트
		List<HashMap<String, Object>> listWmStatus = contentsService.getSpccCodeName("List", "관정현황", null, null);
		List<HashMap<String, Object>> listWmStatusDetail = null;
		// 관정세부현황 리스트
		if (listWmStatus.size() > 0) {
			String wmStatus = String.valueOf(listMain.get(0).get("WM_STATUS"));
			if (!commonUtil.isNull(wmStatus)) {
				List<HashMap<String, Object>> temp = contentsService.getSpccCodeName("", "관정현황", wmStatus, null);
				String upCode = String.valueOf(temp.get(0).get("IDX"));
				
				listWmStatusDetail = contentsService.getSpccCodeName("UPCODE", "관정세부현황", null, upCode);
			}
		}
		// 관정형태 리스트
		List<HashMap<String, Object>> listWuShape = contentsService.getSpccCodeName("List", "관정형태", null, null);
		// 부속자재 상태 리스트
		List<HashMap<String, Object>> listPiState = contentsService.getSpccCodeName("List", "부속자재", null, null);
		// 상부보호공
		List<HashMap<String, Object>> listClUdStatus = contentsService.getSpccCodeName("List", "상부보호공", null, null);
		// 보호공상태 상태 리스트
		List<HashMap<String, Object>> listClUdfStatus = contentsService.getSpccCodeName("List", "상부보호공형태", null, null);
		// 그라우팅 상태 리스트
		List<HashMap<String, Object>> listClGtStatus = contentsService.getSpccCodeName("List", "그라우팅", null, null);
		// 양호 상태 리스트
		List<HashMap<String, Object>> listConditionStatus = contentsService.getSpccCodeName("List", "양호상태", null, null);
		// 유무 상태 리스트
		List<HashMap<String, Object>> listWpInstalledStatus = contentsService.getSpccCodeName("List", "유무", null, null);
		// 장치유무 상태 리스트
		List<HashMap<String, Object>> listWpMsStatus = contentsService.getSpccCodeName("List", "관리상태", null, null);
		// 주변시설물 상태 리스트
		List<HashMap<String, Object>> listClFcStatus = contentsService.getSpccCodeName("List", "주변시설물", null, null);
		for (int a = 0; a < listClFcStatus.size(); a++) {
			String colName =  "CL_FC_" + listClFcStatus.get(a).get("CODE");
			listClFcStatus.get(a).put("COLNAME", colName);
		}
		// 주변오염원 상태 리스트
		List<HashMap<String, Object>> listWqPlStatus = contentsService.getSpccCodeName("List", "주변오염원", null, null);
		for (int b = 0; b < listWqPlStatus.size(); b++) {
			String colName =  "WQ_FC_" + listWqPlStatus.get(b).get("CODE");
			listWqPlStatus.get(b).put("COLNAME", colName);
		}
		// 가능상태 리스트
		List<HashMap<String, Object>> listPosibleStatus = contentsService.getSpccCodeName("List", "가능상태", null, null);
		
		String selectedMenu = reqeust.getParameter("selectedMenu");
		if (commonUtil.isNull(selectedMenu)) {
			selectedMenu = "menu1";
		}
		model.addAttribute("selectedMenu", selectedMenu);
		model.addAttribute("menu", getMenu());
		model.addAttribute("listMain", listMain);
		model.addAttribute("listPurPose", listPurPose);
		model.addAttribute("listPurPoseDetail", listPurPoseDetail);
		model.addAttribute("listWmStatus", listWmStatus);
		model.addAttribute("listWmStatusDetail", listWmStatusDetail);
		model.addAttribute("listWuShape", listWuShape);
		model.addAttribute("listPiState", listPiState);
		model.addAttribute("listClUdStatus", listClUdStatus);
		model.addAttribute("listClGtStatus", listClGtStatus);
		model.addAttribute("listConditionStatus", listConditionStatus);
		model.addAttribute("listWpInstalledStatus", listWpInstalledStatus);
		model.addAttribute("listWpMsStatus", listWpMsStatus);
		model.addAttribute("listClFcStatus", listClFcStatus);
		model.addAttribute("listWqPlStatus", listWqPlStatus);
		model.addAttribute("listPosibleStatus", listPosibleStatus);
		
		model.addAttribute("KaKaoToken", "66ff7a1d2da7f9dd891f0c12c455b1ac");
		model.addAttribute("pjtNm", pjtNm);
		model.addAttribute("pjtNo", pjtNo);
		model.addAttribute("siteNo", siteNo);
		model.addAttribute("viewSiteNo", viewSiteNo);
		
		return "/mobile/contents/edit";
	}
	
	@RequestMapping("/sideBar")
	public String sideBar(String pjtNo, String siteNo, String viewSiteNo, String pjtNm, Model model, HttpServletRequest request) {
		HttpSession session = request.getSession();
		HashMap<String, Object> params = new HashMap<>();
		Enumeration<String> sessionEnum = session.getAttributeNames();
		while (sessionEnum.hasMoreElements()) {
			String key = sessionEnum.nextElement();
			String value = String.valueOf(session.getAttribute(key));
			params.put(key, value);
		}
		params.put("pjtNo", pjtNo);
		params.put("siteNo", siteNo);
		HashMap<String, Object> result = contentsService.getEditStatus(params);
		
		if ("200".equals(result.get("rstCd"))) {
			model.addAttribute("editStatus", result.get("data"));
		}
		
		model.addAttribute("preMenu", request.getParameter("preMenu"));
		model.addAttribute("pjtNm", pjtNm);
		model.addAttribute("pjtNo", pjtNo);
		model.addAttribute("siteNo", siteNo);
		model.addAttribute("viewSiteNo", viewSiteNo);
		model.addAttribute("SS_M_USER_ID", session.getAttribute("SS_M_USER_ID"));
		model.addAttribute("SS_M_USER_NM", session.getAttribute("SS_M_USER_NM"));
		
		return "/mobile/contents/sideBar";
	}
	
	@RequestMapping("/getDetailOption")
	@ResponseBody
	public HashMap<String, Object> getDetailOption(HttpServletRequest request, String DVSCD, String UPCODE) {
		System.out.println("getDetailOption");
		List<HashMap<String, Object>> result = null;
		HashMap<String, Object> response = new HashMap<>();
		
		if ("WM_PURPOSE_MOD".equals(DVSCD)) {
			result = contentsService.getSpccCodeName("UPCODE", "세부용도", null, UPCODE);
		} else if ("WM_STATUS".equals(DVSCD)) {
			result = contentsService.getSpccCodeName("UPCODE", "관정세부현황", null, UPCODE);
		}
		response.put("rstCd", "200");
		response.put("data", result);
		
		return response;
	}
	
	@RequestMapping("/photo")
	public String photo(HttpServletRequest request, Model model) {
		HashMap<String, Object> params = new HashMap<>();
		HashMap<String, Object> viewMain = new HashMap<String, Object>();
		commonUtil.assignRequest(request, params);
		
		List<HashMap<String, Object>> viewData = contentsService.getPhotoMain(params);
		for (int i = 0; i < viewData.size(); i++) {
			HashMap<String, Object> row = viewData.get(i);
			viewMain.put(String.valueOf(row.get("PT_KIND")), row);	
		}
		model.addAttribute("selectedMenu", "menu9");
		model.addAttribute("menu", getMenu());
		model.addAttribute("preMenu", request.getParameter("preMenu"));
		model.addAttribute("pjtNm", request.getParameter("pjtNm"));
		model.addAttribute("preMenu", request.getParameter("preMenu"));
		model.addAttribute("pjtNo", request.getParameter("pjtNo"));
		model.addAttribute("siteNo", request.getParameter("siteNo"));
		model.addAttribute("viewSiteNo", request.getParameter("viewSiteNo"));
		model.addAttribute("viewMain", viewMain);
		
		return "/mobile/contents/photo";
	}
	
	@RequestMapping("/saveFile")
	@ResponseBody
	public HashMap<String, Object> saveFile(HttpServletRequest request, MultipartHttpServletRequest multipartHttpServletRequest) {
		HashMap<String, Object> response = new HashMap<>();
		
		String[] PT_KIND_ARR = multipartHttpServletRequest.getParameterValues("PT_KIND[]");
		List<MultipartFile> mf = multipartHttpServletRequest.getFiles("userfile[]");
		
		int PT_KIND_INDEX = 0;
		for (int i = 0; i < mf.size(); i++) {
			if (mf.get(i).isEmpty()) {
				continue;
			}
			
			String filePath = PT_KIND_ARR[PT_KIND_INDEX] + "\\";
			String fileName = UUID.randomUUID().toString();
			String ext = getExt(mf.get(i).getOriginalFilename());
			String newFileName = fileName + "." + ext; 
			
			HashMap<String, Object> params = new HashMap<>();
			commonUtil.assignRequest(request, params);
			params.put("PT_KIND", PT_KIND_ARR[PT_KIND_INDEX]);
			params.put("PT_LOCAT", filePath);
			params.put("PT_STORED_NM", newFileName);
			boolean dbResult = contentsService.saveFile(params);
			
			if (dbResult) {
				boolean fileResult = commonFile.fileUpload(mf.get(i), filePath, fileName);
				if (!fileResult) {
					response.put("rstCd", "500");
					response.put("msg", "file Upload Error");
				}
				
				PT_KIND_INDEX++;
			} else {
				response.put("rstCd", "500");
				response.put("msg", "db Insert Error");
			}
		}
		
		response.put("rstCd", "200");
		response.put("msg", "success");
		return response;
	}
	
	@RequestMapping("/deleteFile")
	@ResponseBody
	public HashMap<String, Object> deleteFile(HttpServletRequest request) {
		HashMap<String, Object> response = new HashMap<>();
		HashMap<String, Object> params = new HashMap<>();
		commonUtil.assignRequest(request, params);
		String[] deleteFiles = request.getParameterValues("del_files[]");
		
		for (int i = 0; i < deleteFiles.length; i++) {
			String filePath = deleteFiles[i] + "\\";
			params.put("PT_KIND", deleteFiles[i]);
			
			try {
				boolean dbResult = contentsService.deleteFile(params);
				
				if (dbResult) {
					boolean fileResult = commonFile.fileDelete(filePath, "", true);
					
					if (!fileResult) {
						response.put("rstCd", "500");
						response.put("msg", "file delete fail");
					}
				} else {
					response.put("rstCd", "500");
					response.put("msg", "db delete fail");
					
					return response;
				}
			} catch (Exception e) {
				response.put("rstCd", "500");
				response.put("msg", "Exception error");
				e.printStackTrace();
				return response;
			}
		}
		
		response.put("rstCd", "200");
		response.put("msg", "success");
		return response;
	}
	
	@RequestMapping("/fileView")
	public ResponseEntity<Resource> fileView(HttpServletRequest request, String PT_KIND, String fileName) {
		String filePath = PT_KIND + "\\";
		ResponseEntity<Resource> resource = commonFile.fileView(filePath, fileName);
		
		return resource;
	}
	
	private String getExt(String fileName) {
		int extIndex = fileName.lastIndexOf(".");
		String ext = fileName.substring(extIndex + 1);
		
		return ext;
	}
	
	private List<HashMap<String, String>> getMenu() {
		List<HashMap<String, String>> menuList = new ArrayList<>();
		menuList.add(new HashMap<String, String>() {{put("CODE", "menu1");put("NAME", "1.관정관리 및 위치");}});
		menuList.add(new HashMap<String, String>() {{put("CODE", "menu2");put("NAME", "2.관정현황 및 부속자재");}});
		menuList.add(new HashMap<String, String>() {{put("CODE", "menu3");put("NAME", "3.현황판 기입 및 점검현황");}});
		menuList.add(new HashMap<String, String>() {{put("CODE", "menu4");put("NAME", "4.관정 및 자재 상태");}});
		menuList.add(new HashMap<String, String>() {{put("CODE", "menu5");put("NAME", "5.문제점 및 개선사항,특이사항");}});
		menuList.add(new HashMap<String, String>() {{put("CODE", "menu6");put("NAME", "6.현장시험 가능여부");}});
		menuList.add(new HashMap<String, String>() {{put("CODE", "menu7");put("NAME", "7.수질현황 및 가뭄현황");}});
		menuList.add(new HashMap<String, String>() {{put("CODE", "menu8");put("NAME", "8.물탱크 점검 및 정수장치현황");}});
		menuList.add(new HashMap<String, String>() {{put("CODE", "menu9");put("NAME", "9.현장사진");}});
		
		return menuList;
	}
}
