package com.groundwater.excpetion;

import javax.servlet.http.HttpServletRequest;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * <pre>
 * [에러페이지 Controller]
 * 
 * 관리책임 : 김병철
 * 변경이력 (작성일자 / 작성자 / 요청자 / 내용) : 
 *     1. 2022-03-13 / 김병철 / - / 최초작성
 * </pre> 	
 */
@Controller
public class ErrorExceptionController implements ErrorController {		
    private static final String PATH = "/mobile/error";

    @RequestMapping(value = PATH + "/401")
    public String error_401(HttpServletRequest request, Model model) {
        return "/mobile/error/401";
    }
    
    @RequestMapping(value = PATH + "/403")
    public String error_403(HttpServletRequest request, Model model) {
        return "/mobile/error/403";
    }
    
    @RequestMapping(value = PATH + "/404")
    public String error_404(HttpServletRequest request, Model model) {
        return "/mobile/error/404";
    }
    
    @RequestMapping(value = PATH + "/500")
    public String error_500(HttpServletRequest request) {
		return "/mobile/error/500";  	        
    }
}