package com.groundwater.common.file;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import com.groundwater.common.util.GroundWaterUtil;

@Controller
public class GroundWaterFile {
	@Value("${file.uploadBase}")
	String uploadBase;
	@Autowired
	GroundWaterUtil util;
	
	@RequestMapping("/common/fileUpload")
	public boolean fileUpload(MultipartFile file, String filePath, String fileName) {
		String origianlFileName = file.getOriginalFilename();
		String ext = getExt(origianlFileName);
		String saveFileName = fileName + "." + ext;
		String uploadPath = uploadBase + filePath;
		
		File dir = new File(uploadPath);
		if (!dir.isDirectory()) {
			dir.mkdirs();
		}
		String savePath = uploadPath + saveFileName;
		
		try {
			file.transferTo(new File(savePath));
		} catch (Exception e) {
			return false;
		} 
		
		return true;
	}
	
	@RequestMapping("/common/fileDelete")
	public boolean fileDelete(String filePath, String fileName, boolean isDeleteAll) {
		String path = uploadBase + filePath;
		File folder = new File(path);
		
		if (folder.exists()) {
			if (isDeleteAll) {
				File[] fileList = folder.listFiles();
				for (File file : fileList) {
					if (file.isFile()) {
						file.delete();
					}
				}
			} else {
				File file = new File(path + fileName);
				if (file.isFile()) {
					file.delete();
				}
			}
		} else {
			return false;
		}
		
		return true;
	}
	
	@RequestMapping("/common/fileDownload")
	public ResponseEntity<Resource> fileDownload(String filePath, String fileName) {
		String path = uploadBase + filePath + fileName;
		Resource resource = new FileSystemResource(path);
		
		if (!resource.exists()) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		HttpHeaders header = new HttpHeaders();
		try {
			header.setContentDisposition(ContentDisposition.builder("attachment").filename(fileName, StandardCharsets.UTF_8).build());
			header.add("Content-Type", Files.probeContentType(Paths.get(path)));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
	}
	
	@RequestMapping("/common/fileView")
	public ResponseEntity<Resource> fileView(String filePath, String fileName) {
		String path = uploadBase + filePath + fileName;
		Resource resource = new FileSystemResource(path);
		
		if (!resource.exists()) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		
		HttpHeaders header = new HttpHeaders();
		try {
			header.add("Content-Type", Files.probeContentType(Paths.get(path)));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
	}
	
	private String getExt(String fileName) {
		int extIndex = fileName.lastIndexOf(".");
		String ext = fileName.substring(extIndex + 1);
		
		return ext;
	}
}
