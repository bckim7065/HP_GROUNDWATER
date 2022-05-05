package com.groundwater.repository.contents;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ContentsMp {
	void getListMain(HashMap<String, Object> paraMap);
	void getListPurPose(HashMap<String, Object> paraMap);
	void getListPurPoseDetail(HashMap<String, Object> paraMap);
	void getSpccCodeName(HashMap<String, Object> paraMap);
	void saveData(HashMap<String, Object> paraMap);
	void savePop(HashMap<String, Object> params);
	List<HashMap<String, Object>> getEditStatus(HashMap<String, Object> params);
	List<HashMap<String, Object>> getPhotoMain(HashMap<String, Object> params);
	int saveFile(HashMap<String, Object> params);
	int deleteFile(HashMap<String, Object> params);
}
