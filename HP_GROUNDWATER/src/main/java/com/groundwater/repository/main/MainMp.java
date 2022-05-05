package com.groundwater.repository.main;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MainMp {
	void getUserProjectInfo(HashMap<String, Object> paraMap);
	void getProjectInfo(HashMap<String, Object> paraMap);
}
