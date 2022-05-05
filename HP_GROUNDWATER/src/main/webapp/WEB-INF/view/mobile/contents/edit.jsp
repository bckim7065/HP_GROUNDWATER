<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
  	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>지하수 관정 현장조사</title>
  	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css?v=1645950745" />
  	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/layout.css?v=1645950745" />
  	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=1645950745" />
  	
  	<script type="text/javascript"  src="${pageContext.request.contextPath}/js/jquery-1.12.4.min.js"></script>
    <script type="text/javascript"  src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
  	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common_dev.js"></script>
  	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js?contextPath=${pageContext.request.contextPath}"></script>
  	<script>
		let pjtNo = "${pjtNo}";
		let pjtNm = "${pjtNm}";
		let siteNo = "${siteNo}";
		let editStatus = "${listMain[0]['ETC_01']}";
		let viewSiteNo = "${viewSiteNo}";
		let selectedMenu = "${selectedMenu}";
		let KaKaoToken = "${KaKaoToken}";
  	</script>
  	
  	<script>
  		// local_storage
		let addressStorage = {};
		let elementStorage = [];
		let scrollStorage = [];
		// flag
		let throttle = null;
		let disabled = false;
		let isMoveScrollFunc = false;
  	</script>
  	<script>
		$(document).ready(function(){
			// 이벤트추가
			addClickEventToMenu("menu3");
			addClickEventToMenu("menu7");
			addClickEventToPop();

			// 스크롤초기화
			moveScroll(selectedMenu, false);
			addScrollEventToWindow();

			// Html 컨트롤
			controlView("ET");
			controlView("WT");
			controlView("WP");
			controlView("WM");
		});

		// 데이터 저장
		function saveData() {
			let html = "";
			let url = "${pageContext.request.contextPath}/mobile/saveData";
			
			let params = {
				"pjtNo": pjtNo,
				"siteNo": siteNo, 
				"viewSiteNo": viewSiteNo,
				/* [Menu1 Strat] */
			    "WL_ADDR_01_MOD": $("#WL_ADDR_01_MOD").val(),  //수정주소(시군)     
			    "WL_ADDR_02_MOD": $("#WL_ADDR_02_MOD").val(),  //수정주소(읍면동)     
			    "WL_ADDR_03_MOD": $("#WL_ADDR_03_MOD").val(),  //수정주소(리)     
			    "WL_ADDR_04_MOD": $("#WL_ADDR_04_MOD").val(),  //수정주소(지번)     
			    "WL_LOG": $("#WL_LOG").val(),  //위도               
			    "WL_LAG": $("#WL_LAG").val(),  //경도             
			    "WM_PURPOSE_MOD": $("#WM_PURPOSE_MOD option:selected").val(),  //수정용도
			    "WM_PURPOSE_DETAIL_MOD": $("#WM_PURPOSE_DETAIL_MOD option:selected").val(), //수정용도상세  
			    "WM_PURPOSE_USE": $("#WM_PURPOSE_USE").val(),  //사용용도        
			    "WM_STATUS": $("#WM_STATUS option:selected").val(),  //관정현황      
			    "WM_STATUS_DETAIL": $("#WM_STATUS_DETAIL option:selected").val(),  //관정현황상세    
			    "WL_OWNER_NM": $("#WL_OWNER_NM").val(),  //소유자 이름               
			    "WL_OWNER_MOBILE": $("#WL_OWNER_MOBILE").val(),  //소유자 핸드폰           
			    "WL_OWNER_ADDR_01": $("#WL_OWNER_ADDR_01").val(),  //소유자주소(시군)          
			    "WL_OWNER_ADDR_02": $("#WL_OWNER_ADDR_02").val(),  //소유자주소(읍면동)           
			    "WL_OWNER_ADDR_03": $("#WL_OWNER_ADDR_03").val(),  //소유자주소(리)          
			    "WL_OWNER_ADDR_04": $("#WL_OWNER_ADDR_04").val(),  //소유자주소(지번)         
			    "WL_USER_NM": $("#WL_USER_NM").val(),  //사용자 이름               
			    "WL_USER_MOBILE": $("#WL_USER_MOBILE").val(), //사용자 핸드폰            
			    "WL_USER_ADDR_01": $("#WL_USER_ADDR_01").val(),  //사용자(시군)        
			    "WL_USER_ADDR_02": $("#WL_USER_ADDR_02").val(),  //사용자(읍면동)           
			    "WL_USER_ADDR_03": $("#WL_USER_ADDR_03").val(),  //사용자(리)          
			    "WL_USER_ADDR_04": $("#WL_USER_ADDR_04").val(),  //사용자(지번),
			    "WU_SHAPE": $("#WU_SHAPE option:selected").val(),  //관정형태
			    "WU_COMPL_YEAR": $("#WU_COMPL_YEAR").val(),  //개발년도
			    "WU_COMPL_YEAR_MOD": $("#WU_COMPL_YEAR_MOD").val(),  //수정개발년도
			    /* [Menu1 End] */
			    /* [Menu2 Strat] */
			    "WU_DEPTH_MOD": $("#WU_DEPTH_MOD").val(),  //굴착심도
			    "WU_INNER_CASING_MOD": $("#WU_INNER_CASING_MOD").val(),  //내부케이싱
			    "WU_OUT_CASING_MOD": $("#WU_OUT_CASING_MOD").val(),  //외부케이싱
			    "PI_KIND_MOD": $("#PI_KIND_MOD").val(),  //펌프종류
			    "PI_HP_MOD": $("#PI_HP_MOD").val(),  //펌프마력
			    "PI_DCP_MOD": $("#PI_DCP_MOD").val(),  //토출관
			    "PI_FLUX": $("#PI_FLUX option:selected").val(),  //부속자재(유량계)
			    "PI_WLC": $("#PI_WLC option:selected").val(),  //부속자재(수위관)
			    "PI_FE": $("#PI_FE option:selected").val(),  //부속자재(출수장치)
			    "PI_CB": $("#PI_CB option:selected").val(),  //부속자재(제어박스)
			    "PI_CV": $("#PI_CV option:selected").val(),  //부속자재(체크벨브)
			    /* [Menu2 End] */
			    /* [Menu3 Start] */
			    "HG_DR": $("#HG_DR").val(),  //기반암
			    "HG_PC": $("#HG_PC").val(),  //양수량
			    "HG_TC": $("#HG_TC").val(),  //투수량계수
			    "HG_SC": $("#HG_SC").val(),  //비양수량
			    "CL_CS": $("#CL_CS").val(),  //사용중지원인
			    "CL_UD": $("#CL_UD option:selected").val(),  //상부보호공
			    "CL_UDF": $("#CL_UDF option:selected").val(),  //보호공형태
			    "CL_GT": $("#CL_GT option:selected").val(),  //그라우팅
			    "CL_FC_ETC": $("#CL_FC_ETC").val(),  //주변시설물 기타사항
			    "CL_FC": getCodeList("CL_FC"),  //주변시설물
			    /* [Menu3 End] */
			    /* [Menu4 Start] */
			    "CL_CI": $("#CL_CI option:selected").val(),  //케이싱설치
			    "CL_GC": $("#CL_GC option:selected").val(),  //그라우팅균열
			    "CL_GL": $("#CL_GL option:selected").val(),  //그라우팅누수
			    "CL_SWL": $("#CL_SWL option:selected").val(),  //지표수유입
			    "CL_RU": $("#CL_RU option:selected").val(),  //부식
			    "CL_WPC": $("#CL_WPC option:selected").val(),  //수동펌프작동
			    "CL_DCPC": $("#CL_DCPC option:selected").val(),  //토출관
			    "CL_FMC": $("#CL_FMC option:selected").val(),  //유량계작동
			    "CL_EWC": $("#CL_EWC option:selected").val(),  //수중전선
			    "CL_WLCC": $("#CL_WLCC option:selected").val(),  //수위측정관
			    "CL_FEC": $("#CL_FEC option:selected").val(),  //출수장치
			    "CL_CBC": $("#CL_CBC option:selected").val(),  //제어판넬
			    "CL_ECC": $("#CL_ECC option:selected").val(),  //전기인입
			    "CL_PLC": $("#CL_PLC option:selected").val(),  //배관누수
			    /* [Menu4 End] */
			    /* [Menu5 Start] */
			    "CL_RE_PLM": $("#CL_RE_PLM").val(),  //문제점
			    "CL_RE_IMP": $("#CL_RE_IMP").val(),  //개선사항
			    "CL_RE_SF": $("#CL_RE_SF").val(),  //특이사항
			    /* [Menu5 End] */
			    /* [Menu6 Start] */
			    "SS_OS": $("#SS_OS option:selected").val(),  //자동관측장비
			    "SS_OS_DISC": $("#SS_OS_DISC").val(),  //자동관측장비(의견)
			    "SS_SP": $("#SS_SP option:selected").val(),  //단계양수시험
			    "SS_SPD": $("#SS_SPD").val(),  //단계양수시험(의견)
			    "SS_PU": $("#SS_PU option:selected").val(),  //양수시험
			    "SS_PU_DISC": $("#SS_PU_DISC").val(),  //양수시험(의견)
			    "SS_FMO": $("#SS_FMO option:selected").val(),  //유량계작동
			    "SS_FMO_DISC": $("#SS_FMO_DISC").val(),  //유량계작동(의견)
			    "SS_DC": $("#SS_DC option:selected").val(),  //배수
			    "SS_DC_DISC": $("#SS_DC_DISC").val(),  //배수(의견)
			    "SS_SM": $("#SS_SM option:selected").val(),  //시료채취
			    "SS_SM_DISC": $("#SS_SM_DISC").val(),  //시료채취(의견)
			    "SS_ME": $("#SS_ME option:selected").val(),  //장비접근
			    "SS_ME_DISC": $("#SS_ME_DISC").val(),  //장비접근(의견)
			    /* [Menu6 End] */
			    /* [Menu7 Start] */
			    //"WQ_PL": $("#WQ_PL").val(),  //[추가작업]주변오염원
			    "WQ_PL": getCodeList("WQ_PL"),  //[추가작업]주변오염원
			    "WQ_ETC": $("#WQ_ETC").val(),  //주변오염원(직접입력)
			    "ET_D_HIS_EXIST": $("#cb05").is(":checked") ? "T" : "F",  //가뭄이력유무
			    "ET_D_HIS": $("#ET_D_HIS").val(),  //가뭄이력
			    "ET_WSH": $("#ET_WSH").val(),  //급수가구
			    "ET_WSP": $("#ET_WSP").val(),  //급수인원
			    "ET_WSA": $("#ET_WSA").val(),  //급수지역
			    "ET_RO": $("#ET_RO").val(),  //도로상태
			    "ET_WSF": $("#ET_WSF").val(),  //상수도보급
			    /* [Menu7 End] */
			    /* [Menu8 Start] */
			    "WT_EXIST": $("#cb06").is(":checked") ? "T" : "F",  //물탱크유무
			    "WT_ADDR_01": $("#WT_ADDR_01").val(),  //물탱크주소(시)
			    "WT_ADDR_02": $("#WT_ADDR_02").val(),  //물탱크주소(군)
			    "WT_ADDR_03": $("#WT_ADDR_03").val(),  //물탱크주소(리)
			    "WT_ADDR_04": $("#WT_ADDR_04").val(),  //물탱크주소(지번)
			    "WT_LOG": $("#WT_LOG").val(),  //물탱크(위도)
			    "WT_LAG": $("#WT_LAG").val(),  //물탱크(경도)
			    "WT_CP": $("#WT_CP").val(),  //용량
			    "WT_MT": $("#WT_MT").val(),  //재질
			    "WT_MANAGER": $("#WT_MANAGER").val(),  //담당자(이름)
			    "WT_MOBILE": $("#WT_MOBILE").val(),  //담당자(연락처)
			    "WT_DISTANCE": $("#WT_DISTANCE").val(),  //관정과의 거리
			    "WP_INSTALLED": $("#cb07").is(":checked") ? "T" : "F",  //장치유무
			    "WP_MS": $("#WP_MS option:selected").val(),  //관리상태
			    "WP_PFM": $("#WP_PFM").val()  //정수방식
			    /* [Menu8 End] */
			};
			
			$.ajax({
				type: "POST",
				url: url,
				async: true,
				data: params,
				success : function(res){
					if ($.trim(res.rstCd) == "200") {
						//alert("정상적으로 저장되었습니다.");
						//location.reload();
					} else {
						alert("저장도중 문제가발생하였습니다.\r\n관리자에게 문의하세요.");
						console.log(data);
					}
				},
				error : function(xhr, status, error) {
					console.log("xhr", xhr);
					console.log("status", status);
					console.log("error", error);
					alert("에러발생");
				},
	            beforeSend : function(){
	            	showLoadingBar();
	            },
	            complete : function(){
	            	hideLoadingBar();
				}
			});
		}

		// 주변시설물, 주변오염원 코드 생성
		function getCodeList(dvsCd) {
			let list = [];
			
			$.each($("#" + dvsCd + " li"), function(index, elem) {
				if ($(elem).hasClass("on")) {
					list.push($(elem).attr("value"));
				};
			});

			return list.join('^');
		}

		// 옵션 상세 가져오기
	  	function drawOptionDetail(dvsCd, detailId) {
	  		let html = "";
			let url = "${pageContext.request.contextPath}/mobile/getDetailOption";
		  	let upcode = $("#" + dvsCd + " option:selected").attr("upcode");
			let params = {
					DVSCD: dvsCd,
					UPCODE: upcode
				};
			
			if (upcode == "null") {
				html += '<option value="" upcode="Null">선택</option>';
				$("#" + detailId).html(html);
				return;
			}
		  	
			$.ajax({
				type: "POST",
				url: url,
				async: false,
				data: params,
				success : function(response){
					let data = response.data;
					
					html += '<option value="" upcode="null">선택</option>';
					for (let i = 0; i < data.length; i++) {
						html += '<option value="' + data[i].CODE + '">' + data[i].NAME + '</option>';
					}
				},
				error : function(xhr, status, error) {
					console.log("xhr", xhr);
					console.log("status", status);
					console.log("error", error);
					alert("에러발생");
				}
			});

			$("#" + detailId).html(html);
	  	}

	  	function disableAll() {
		  	if (disabled) {
			  	return;
		  	}
		  	
		  	let disableList = ["#menu2", "#menu3", "#menu4", "#menu5", "#menu6", "#menu7", "#menu8"];
		  	$.each($("#menu1").find("table tr:gt(9)"), function(index, element){
		  		$(element).css("display", "none");
		  	});

		  	for (let i = 0; i < disableList.length; i++) {
			  	let div = $(disableList[i]).css("display", "none");
		  	}

		  	$(".header_select option:gt(0)").css("display", "none")
	  	}
		
	  	
	  	function restoreAll() {
	  		let disableList = ["#menu2", "#menu3", "#menu4", "#menu5", "#menu6", "#menu7", "#menu8"];

		  	$.each($("#menu1").find("table tr:gt(9)"), function(index, element){
		  		$(element).css("display", "");
		  	});

		  	for (let i = 0; i < disableList.length; i++) {
			  	let div = $(disableList[i]).css("display", "");
		  	}

		  	$(".header_select option:gt(0)").css("display", "")
	  	}
	  	

	  	function restoreAll2() {
		  	let element, value, tagName, type;
		  	
	  		for (let i = 0; i < elementStorage.length; i++) {
		  		element = elementStorage[i].element;
		  		tagName = $(element).prop('tagName').toLowerCase();
		  		type = $(element).prop("type").toLowerCase();;
		  		value = elementStorage[i].value;

		  		if (tagName == "input" && type == "checkbox") {
		  			$(element).prop("checked", value);
				} else if (tagName == "li") {
					if (value) {
						$(element).addClass("on");
					}
				} else {
					$(element).val(value);
				}
				
		  		$(element).attr("disabled", false);
	  		}

	  		elementStorage = [];
	  	}

	  	function disableAll2() {
		  	if (disabled) {
			  	return;
		  	}
		  	
		  	let disableList = ["#menu2", "#menu3", "#menu4", "#menu5", "#menu6", "#menu7", "#menu8"];
		  	let types = ["input", "select", "li", "textarea"];

		  	$.each($("#menu1").find("table tr:gt(9)"), function(index, element){
		  		$.each($(this).find("input"), function(index2, element2){
		  			let type = $(element2).prop("type");
					let value;
					let obj = {
						element: element2,
						value: ""
					}
					
					if (type == "checkbox") {
			  			value = $(element2).is(":checked");
			  			obj.value = value;
			  			$(element2).prop("checked", false);
			  		} else {
			  			value = $(element2).val();
			  			obj.value = value;
			  			$(element2).val('');
			  		}
					
					elementStorage.push(obj);	
		  			$(element2).attr("disabled", true);
		  		});
		  	});
			
		  	for (let i = 0; i < disableList.length; i++) {
			  	for (let j = 0; j < types.length; j++) {
			  		$.each($(disableList[i]).find(types[j]), function(index, element){
						if ($(element).attr("role") !== "default") {
							let tagName = $(element).prop('tagName').toLowerCase()
							let type = $(element).prop("type").toLowerCase();
							let value;
							let obj = {
								element: element,
								value: ""
							}

							if (tagName == "input" && type == "checkbox") {
								value = $(element).is(":checked");
					  			obj.value = value;
					  			$(element).prop("checked", false);
							} else if (tagName == "li") {
								value = $(element).hasClass("on");
					  			obj.value = value;
					  			$(element).removeClass("on");
							} else {
								value = $(element).val();
					  			obj.value = value;
					  			$(element).val('');
							}
							
							elementStorage.push(obj);	
						}
				  		
			  			$(element).attr("disabled", true);
			  		});
			  	}
		  	}

			// 개별버튼
			let obj = {
				element: $("#menu8 .btn_map").get(0),
				value: ""
			}
		  	elementStorage.push(obj);
		  	$("#menu8 .btn_map").attr("disabled", true);
	  	}

		// 주소복사
		function copyAddr(dvsCd) {
			let address;
			let copyAddr1;
			let copyAddr2;
			let copyAddr3;
			let copyAddr4;
			let copyAddr5;
			let copyAddr6;
			let addr1;
			let addr2;
			let addr3;
			let addr4;
			let addr5;
			let addr6;

			// 1:수정주소, 2:소유자, 3:사용자
			if (dvsCd == 1) {
				//복사주소
				copyAddr1 = $("#WL_ADDR_01").val();
				copyAddr2 = $("#WL_ADDR_02").val();
				copyAddr3 = $("#WL_ADDR_03").val();
				copyAddr4 = $("#WL_ADDR_04").val();
				//본주소
				addr1 = $("#WL_ADDR_01_MOD").val();
				addr2 = $("#WL_ADDR_02_MOD").val();
				addr3 = $("#WL_ADDR_03_MOD").val();
				addr4 = $("#WL_ADDR_04_MOD").val();

				//본주소로 복원
				if ($("#cb").is(":checked")) {
					address = {
						"addr1": addr1,
						"addr2": addr2,
						"addr3": addr3,
						"addr4": addr4 
					}
					saveAddress(dvsCd, address);
					
					$("#WL_ADDR_01_MOD").val(copyAddr1);
					$("#WL_ADDR_02_MOD").val(copyAddr2);
					$("#WL_ADDR_03_MOD").val(copyAddr3);
					$("#WL_ADDR_04_MOD").val(copyAddr4);
				} else {
					$("#WL_ADDR_01_MOD").val(addressStorage[dvsCd].addr1);
					$("#WL_ADDR_02_MOD").val(addressStorage[dvsCd].addr2);
					$("#WL_ADDR_03_MOD").val(addressStorage[dvsCd].addr3);
					$("#WL_ADDR_04_MOD").val(addressStorage[dvsCd].addr4);
				}
			} else if (dvsCd == 2) {
				//복사주소
				copyAddr1 = $("#WL_USER_NM").val();
				copyAddr2 = $("#WL_USER_MOBILE").val();
				copyAddr3 = $("#WL_USER_ADDR_01").val();
				copyAddr4 = $("#WL_USER_ADDR_02").val();
				copyAddr5 = $("#WL_USER_ADDR_03").val();
				copyAddr6 = $("#WL_USER_ADDR_04").val();
				//본주소
				addr1 = $("#WL_OWNER_NM").val();
				addr2 = $("#WL_OWNER_MOBILE").val();
				addr3 = $("#WL_OWNER_ADDR_01").val();
				addr4 = $("#WL_OWNER_ADDR_02").val();
				addr5 = $("#WL_OWNER_ADDR_03").val();
				addr6 = $("#WL_OWNER_ADDR_04").val();

				//본주소로 복원
				if ($("#cb02").is(":checked")) {
					address = {
						"addr1": addr1,
						"addr2": addr2,
						"addr3": addr3,
						"addr4": addr4,
						"addr5": addr5,
						"addr6": addr6
					}
					saveAddress(dvsCd, address);
					
					$("#WL_OWNER_NM").val(copyAddr1);
					$("#WL_OWNER_MOBILE").val(copyAddr2);
					$("#WL_OWNER_ADDR_01").val(copyAddr3);
					$("#WL_OWNER_ADDR_02").val(copyAddr4);
					$("#WL_OWNER_ADDR_03").val(copyAddr5);
					$("#WL_OWNER_ADDR_04").val(copyAddr6);
				} else {
					$("#WL_OWNER_NM").val(addressStorage[dvsCd].addr1);
					$("#WL_OWNER_MOBILE").val(addressStorage[dvsCd].addr2);
					$("#WL_OWNER_ADDR_01").val(addressStorage[dvsCd].addr3);
					$("#WL_OWNER_ADDR_02").val(addressStorage[dvsCd].addr4);
					$("#WL_OWNER_ADDR_03").val(addressStorage[dvsCd].addr5);
					$("#WL_OWNER_ADDR_04").val(addressStorage[dvsCd].addr6);
				}
			} else if (dvsCd == 3) {
				//복사주소
				copyAddr1 = $("#WL_OWNER_NM").val();
				copyAddr2 = $("#WL_OWNER_MOBILE").val();
				copyAddr3 = $("#WL_OWNER_ADDR_01").val();
				copyAddr4 = $("#WL_OWNER_ADDR_02").val();
				copyAddr5 = $("#WL_OWNER_ADDR_03").val();
				copyAddr6 = $("#WL_OWNER_ADDR_04").val();
				//본주소
				addr1 = $("#WL_USER_NM").val();
				addr2 = $("#WL_USER_MOBILE").val();
				addr3 = $("#WL_USER_ADDR_01").val();
				addr4 = $("#WL_USER_ADDR_02").val();
				addr5 = $("#WL_USER_ADDR_03").val();
				addr6 = $("#WL_USER_ADDR_04").val();
				
				if ($("#cb03").is(":checked")) {
					address = {
						"addr1": addr1,
						"addr2": addr2,
						"addr3": addr3,
						"addr4": addr4,
						"addr5": addr5,
						"addr6": addr6
					}
					saveAddress(dvsCd, address);
					
					$("#WL_USER_NM").val(copyAddr1);
					$("#WL_USER_MOBILE").val(copyAddr2);
					$("#WL_USER_ADDR_01").val(copyAddr3);
					$("#WL_USER_ADDR_02").val(copyAddr4);
					$("#WL_USER_ADDR_03").val(copyAddr5);
					$("#WL_USER_ADDR_04").val(copyAddr6);
				} else {
					$("#WL_USER_NM").val(addressStorage[dvsCd].addr1);
					$("#WL_USER_MOBILE").val(addressStorage[dvsCd].addr2);
					$("#WL_USER_ADDR_01").val(addressStorage[dvsCd].addr3);
					$("#WL_USER_ADDR_02").val(addressStorage[dvsCd].addr4);
					$("#WL_USER_ADDR_03").val(addressStorage[dvsCd].addr5);
					$("#WL_USER_ADDR_04").val(addressStorage[dvsCd].addr6);	
				}
			} else if (dvsCd == 4) {
				//복사주소
				copyAddr1 = $("#WL_ADDR_01_MOD").val();
				copyAddr2 = $("#WL_ADDR_02_MOD").val();
				copyAddr3 = $("#WL_ADDR_03_MOD").val();
				copyAddr4 = $("#WL_ADDR_04_MOD").val();
				//본주소
				addr1 = $("#WT_ADDR_01").val();
				addr2 = $("#WT_ADDR_02").val();
				addr3 = $("#WT_ADDR_03").val();
				addr4 = $("#WT_ADDR_04").val();
				
				if ($("#cb08").is(":checked")) {
					address = {
						"addr1": addr1,
						"addr2": addr2,
						"addr3": addr3,
						"addr4": addr4
					}
					saveAddress(dvsCd, address);
					
					$("#WT_ADDR_01").val(copyAddr1);
					$("#WT_ADDR_02").val(copyAddr2);
					$("#WT_ADDR_03").val(copyAddr3);
					$("#WT_ADDR_04").val(copyAddr4);
				} else {
					$("#WT_ADDR_01").val(addressStorage[dvsCd].addr1);
					$("#WT_ADDR_02").val(addressStorage[dvsCd].addr2);
					$("#WT_ADDR_03").val(addressStorage[dvsCd].addr3);
					$("#WT_ADDR_04").val(addressStorage[dvsCd].addr4);
				}

			}

			function saveAddress(dvsCd, address) {
				if (!isSavedAddress(dvsCd)) {
					addressStorage[dvsCd] = address;
					return;
				}

				let obj = addressStorage[dvsCd];
				for (key in obj) {
					addressStorage[dvsCd][key] = address[key];
				}
			}

			function isSavedAddress(key) {
				if (address.hasOwnProperty(key)) {
					return true;
				}

				return false;
			}
		}

		// 구글 맵
		function openMap(dvsCd) {
			let address = "";
			if (dvsCd == "WL") {
				address = $.trim($("#WL_ADDR_01_MOD").val() + " " + $("#WL_ADDR_02_MOD").val() +  " " + $("#WL_ADDR_03_MOD").val() + " " + $("#WL_ADDR_04_MOD").val());
			} else if (dvsCd == "WT") {
				address = $.trim($("#WT_ADDR_01").val() + " " + $("#WT_ADDR_02").val() +  " " + $("#WT_ADDR_03").val() + " " + $("#WT_ADDR_04").val());
			}

			let params = {
				ActionMode: "openMap",
				dvsCd: dvsCd,
				address: address
			}
			let url = Controller + "?" + $.param(params);
			let options = "";
			let popup = window.open(url, "gogleMap");
		}

		// 카카오 맵
		function openKaKaoMap(dvsCd) {
			let address = "";
			if (dvsCd == "WL") {
				address = $.trim($("#WL_ADDR_01_MOD").val() + " " + $("#WL_ADDR_02_MOD").val() +  " " + $("#WL_ADDR_03_MOD").val() + " " + $("#WL_ADDR_04_MOD").val());
			} else if (dvsCd == "WT") {
				address = $.trim($("#WT_ADDR_01").val() + " " + $("#WT_ADDR_02").val() +  " " + $("#WT_ADDR_03").val() + " " + $("#WT_ADDR_04").val());
			}

			let params = {
				dvsCd: dvsCd,
				address: address
			}
			let controller = "${pageContext.request.contextPath}/mobile/openKaKaoMap";
			let url = controller + "?" + $.param(params);
			let options = "";
			let popup = window.open(url, "kakaoMap");
		}

		// 메뉴 스크롤 이동
	    function moveScroll(divName, isSave){
	    	isMoveScrollFunc = true;
			if (divName == "menu9") {
				movePhoto();
				return;
			}

			if (isSave) {
				saveData();
			}
		    
			let base = 100;
			let offset = $("#" + divName).offset();
			let scrollTop = offset.top - base;

	        $('html, body').animate({scrollTop : scrollTop}, 400, 'swing', function(){
		        setTimeout(function(){
		        	isMoveScrollFunc = false;
		        }, 100);
	        });
	    }

		// 관정현황 전체선택
	    function selectAll() {
			let number = 0;
			let base, target, checkBox;

			if ($("input[id='cb04']:checkbox").is(":checked")) {
				$.each($(".input_three"), function(index, elem){
					number = 0;
					base = $(elem).find(" > div input:eq(" + number + ")");
					target = $(elem).find(" > div input:eq(" + ++number + ")");
					checkBox = $(elem).find(" > div input:eq(" + ++number + ")").prop("checked", true);

					target.val(base.val());
				});

				return;
			} 

			$.each($(".input_three"), function(index, elem){
				number = 0;
				target = $(elem).find(" > div input:eq(" + ++number + ")");
				checkBox = $(elem).find(" > div input:eq(" + ++number + ")").prop("checked", false);

				target.val('');
			});
		}

		// 관정현황 단일선택
		function selectOne(element) {
			let base = $(element).parent().prev().prev().find(" input");
			let target = $(element).parent().prev().find(" input");

			if ($(element).is(":checked")) {
				target.val(base.val());
				return 
			}

			target.val('');
		}

		// Menu별 이벤트 할당
	    function addClickEventToMenu(menu) {
			switch(menu) {
				case "menu1" : break;
				case "menu2" : break;
				case "menu3" : 
					$("#menu3 .tb_checkbox_list").on("click", function(event){
						if ($(event.target).attr("disabled") == "disabled") {
							return;	
						}
						
						let element = $(event.target);
						element.toggleClass("on");
	
						if ($("#menu3 .etc").hasClass("on")) {
							$("#menu3 .rmk").attr("disabled", false);
						} else {
							$("#menu3 .rmk").attr("disabled", true);
						}
					});

					$.each($("#CL_FC li"), function(index, elem){
						let text = $(elem).text();

						if (text == "기타") {
							$(elem).addClass("etc");
						}
					});
					
					break;
				case "menu4" : break;
				case "menu5" : break;
				case "menu6" : break;
				case "menu7" : 
					$("#menu7 .tb_checkbox_list").on("click", function(event){
						if ($(event.target).attr("disabled") == "disabled") {
							return;	
						}
						
						let element = $(event.target);
						element.toggleClass("on");
	
						if ($("#menu7 .etc").hasClass("on")) {
							$("#menu7 .rmk").attr("disabled", false);
						} else {
							$("#menu7 .rmk").attr("disabled", true);
						}
					});

					$.each($("#WQ_PL li"), function(index, elem){
						let text = $(elem).text();

						if (text == "기타") {
							$(elem).addClass("etc");
						}
					});
					
					break;
				case "menu8" : break;
				default : break;
			}
		}

		// Html disable 설정
	    function controlView(dvsCd) {
  	  		if (dvsCd == "ET") {
				if ($("#cb05").is(":checked")) {
					$.each($("[name='ET']"), function(index, elem){
						$(elem).attr("disabled", false);
					});	
					
					return;
				}
	
				$.each($("[name='ET']"), function(index, elem){
					$(elem).attr("disabled", true);
				});			
  	  		} else if (dvsCd == "WT") {
	  	  		if ($("#cb06").is(":checked")) {
					$.each($("[name='WT']"), function(index, elem){
						$(elem).attr("disabled", false);
					});	
					
					return;
				}
	
				$.each($("[name='WT']"), function(index, elem){
					$(elem).attr("disabled", true);
				});	
  	  		} else if (dvsCd == "WP") {
				if ($("#cb07").is(":checked")) {
					$("#WP_INSTALLED").attr("disabled", false);
					$("#WP_MS").attr("disabled", false);
					$("#WP_PFM").attr("disabled", false);
					
					return;
				}
	
				$("#WP_INSTALLED").attr("disabled", true);
				$("#WP_MS").attr("disabled", true);
				$("#WP_PFM").attr("disabled", true);
  	  		} else if (dvsCd == "WM") {
  	  	  		let masterValue = $("#WM_STATUS option:selected").val();
  	  			let detailValue = $("#WM_STATUS_DETAIL option:selected").val();

				// 시설있음, 기타작업 외 disable
				if (!(masterValue == "2" || (masterValue == "1" && detailValue == "26"))) {
					disableAll();
					disabled = true;
					return;
				}

				restoreAll();
				disabled = false;
  	  		}
  		}

		// 사진으로 이동
  		function movePhoto() {
  			let params = {
				pjtNo: pjtNo,
				pjtNm: pjtNm,
				siteNo: siteNo,
				viewSiteNo: viewSiteNo,
				preMenu: $(".header_select option:selected").val()
			}
			let url = "${pageContext.request.contextPath}/mobile/photo" + "?" + $.param(params);
			location.href = url;
  		}

	  	function getDistance(lat1, lon1, lat2, lon2, unit) {
	  	   if ((lat1 == lat2) && (lon1 == lon2)) {
	  	      return 0;
	  	   } else {
				let radlat1 = Math.PI * lat1/180;
	  	    	let radlat2 = Math.PI * lat2/180;
				let theta = lon1-lon2;
				let radtheta = Math.PI * theta/180;
				let dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
				
				if (dist > 1) {
					dist = 1;
				}
				
				dist = Math.acos(dist);
				dist = dist * 180/Math.PI;
				dist = dist * 60 * 1.1515;
				
				if (unit == "K") { 
					dist = dist * 1.609344; 
				}
				if (unit == "N") { 
					dist = dist * 0.8684; 
				}
				if (unit == "M"){
		            dist = dist * 1609.344;;
				}
				
				return dist;
	  	   }
	  	}
	  	
  		// 맵 포지션 설정
  		function setMapPosition(position) {
  			if (position.dvsCd == "WL") {
	  	  		$("#WL_LOG").val(position.lat);
	  			$("#WL_LAG").val(position.lng);
  	  		} else if (position.dvsCd == "WT") {
  	  			$("#WT_LOG").val(position.lat);
  	  			$("#WT_LAG").val(position.lng);
  	  		}
  	  		
  			let wl_lat = $("#WL_LOG").val();  //관정 x(위도)
  			let wl_lng = $("#WL_LAG").val();  //관정 y(경도)
  			let wt_lat = $("#WT_LOG").val();  //물탱크 x(위도)
  			let wt_lng = $("#WT_LAG").val();  //물탱크 y(경도)

  	  		if (!isNull(wl_lat) && !isNull(wl_lng) & !isNull(wt_lat) & !isNull(wt_lng)) {
  				let distance = getDistance(wl_lat, wl_lng, wt_lat, wt_lng, "K").toFixed(1); 

  	  	  		$("#WT_DISTANCE").val(distance);
  	  		}
  		}

		// 팝업저장
		function savePop() {
			let html = "";
			let url = Controller;
			
			let params = {
				ActionMode: "saveData",
				SubAction: "pop",
				pjtNo: pjtNo,
				viewSiteNo: viewSiteNo,
				INVEST_DATE: $("#datepicker").val().replaceAll('-', ''),
				ETC_01:	$(".pop_tab li.on").attr("value")
			}

			$.ajax({
				type: "POST",
				url: url,
				async: true,
				data: params,
				success : function(res){
					if ($.trim(res.rstCd) == "200") {
						alert("정상적으로 저장되었습니다.");
					} else {
						alert("저장도중 문제가발생하였습니다.\r\n관리자에게 문의하세요.");
						console.log(data);
					}
				},
				error : function(xhr, status, error) {
					console.log("xhr", xhr);
					console.log("status", status);
					console.log("error", error);
					alert("에러발생");
				},
	            beforeSend : function(){
	            	showLoadingBar();
	            },
	            complete : function(){
	            	hideLoadingBar();
				}
			});
			
		}

		// 팝업 이벤트 등록
  		function addClickEventToPop() {
  	  		$.each($(".pop_tab li"), function(index, elem){
				$(elem).on("click", function(event){
	  	  	  		$(elem).addClass("on").siblings().removeClass("on");
	  	  	  		savePop();
				});
  	  		});
  		}

		// Null 검증
  		function isNull(value) {
  			if (value == null || value == undefined || value.toString().replace(/\s/g,"") == "") {
  				return true;
  			}

  			return false;
  		}

  		function moveSideBar() {
			let params = {
				pjtNo: pjtNo,
				pjtNm: pjtNm,
				siteNo: siteNo,
				viewSiteNo: viewSiteNo,
				preMenu: isNull($(".header_select option:selected").val()) ? "menu1" : $(".header_select option:selected").val() 
			}
			
			let controller = "${pageContext.request.contextPath}/mobile/sideBar"
			location.href = controller + "?" + $.param(params);
  		}

  		function showLoadingBar() {
  			if ($("#loading_mask").length == 0) {
  				drawLoadingBar();	
  			}

  			$('#loading_mask').show();
  			$('#loading_img').show();
  		}
  		
  		function drawLoadingBar() {
  			let maskHeight = $(document).height();
  			let maskWidth = window.document.body.clientWidth;

  			let mask = "<div id='loading_mask' style='position:absolute; z-index:9000; background-color:#000000; display:none; left:0; top:0;'></div>";
  			let loadingImg = '';

  			loadingImg += "<div id='loading_img' class='add' style='position:fixed; left:50%; top:50%; transform:translate(-50%, -50%); display:none; z-index:10000;'>";
  			loadingImg += "    <img src='${pageContext.request.contextPath}/images/loading.gif'/>";
  			loadingImg += "</div>";

  			$('body').append(mask).append(loadingImg);

  			$('#loading_mask').css({
  				'width' : maskWidth,
  				'height': maskHeight,
  				'opacity' : '0.3'
  			});
  		}

  		function hideLoadingBar() {
  			$('#loading_mask, #loading_img').hide();
  		}

  		function convertWSG84ToTM(lng, lat) {
		  	let url = "https://dapi.kakao.com/v2/local/geo/transcoord.json";
		  	let params = {
				x: lng,
				y: lat,
				input_coord: "WGS84",
				output_coord: "TM"
		  	}
		  	url = url + "?" + $.param(params); 
		  	let coords = null;
		  	
	  		$.ajax({
				type:"GET",
				url: url,
				beforeSend: function (xhr) {
		            xhr.setRequestHeader("Authorization", "KakaoAK " + KaKaoToken);
		        },
				async: false,
				success : function(data) {
					coords = data.documents[0];
				},
				error : function(xhr, status, error) {
					alert("주소변환오류");
					return false;
				}
			});

			return coords;
	  	}

	  	function addScrollEventToWindow() {
	  		$.each($("[id^=menu]"), function(index, element){
		  		let divName = $(element).attr("id");
		  		let base = 100;
		  		let offset = $("#" + divName).offset();
		  		let scrollTop = offset.top - base;
			  	let start = scrollTop;
			  	let end = start + $(element).outerHeight(true);
			  	let obj = {
					element: element,
					start: start,
					end: end
			  	}

			  	scrollStorage.push(obj);
		  	});

	  		$(window).scroll(function(){
		  		if (isMoveScrollFunc) {
			  		return;
		  		}
		  		
		  		throttleFunc(300);
	  		});
	  	}

	  	function throttleFunc(time) {
			if (!throttle) {
				setTimeout(function(){
					throttle = null;
					let clientHeight = $(window).height();
				  	let scrollTop = $(window).scrollTop();

				  	//let div = searchDiv("top", scrollTop);
				  	let div = searchDiv("bottom", clientHeight + scrollTop);
				  	if (div != "Null") {
				  		$(".header_select").val(div.element.id);
				  	}
				}, time);
			}

		  	function searchDiv(standard, height) {
			  	if (standard == "top") {
			  		for (let i = 0; i < scrollStorage.length; i++) {
					  	if (height >= scrollStorage[i].start && height <= scrollStorage[i].end) {
						  	return scrollStorage[i];
					  	} 
				  	}
			  	} else if (standard == "bottom") {
			  		for (let i = 0; i < scrollStorage.length; i++) {
					  	let start = scrollStorage[i].start + (scrollStorage[i].end - scrollStorage[i].start) / 3;
					  	if (height >= start && height <= scrollStorage[i].end) {
						  	return scrollStorage[i];
					  	} 
				  	}
			  	}

			  	return "Null"
		  	} 
	  	}
  	</script>
  	<style>
  		.tb_checkbox_list:after {
  			display: block;
  			content: "";
  			clear: both;
		}
		textarea {
			resize: none;
		}
		select[disabled] {
			background: #f1f0ed;
			border-color: #f1f0ed;
			color: #716e64;
			-webkit-appearance: none;
			font-size: 14px;
		}
		.bar {
			display: inline-block;
			width: 2px;
			height: 20px;
			vertical-align: -6px;
			background-color: #c9c5c5;
			margin-right: 6px;
			margin-left: 3px;
		}
		.vtc_top {
			vertical-align: top;
		}
		li[disabled] {
			background: #f1f0ed;
			border-color: #f1f0ed;
		}
		.tb01 td .input_right .btn_map {
			position: relative;
			top: 1px;
		}
		.wrap, .container {
			position: relative;
		}
		
  	</style>
  	
</head>
<body>
<!-- wrap -->
<div class="wrap">
	<!-- header -->
	<div class="header">
		<a href="#" class="header_home" onclick="moveHome()"></a>
		<h1 class="header_tit">TA000001</h1>
	    <div class="header_right">
			<button class="header_menu" onclick="moveSideBar()">
		        <span></span>
		        <span></span>
		        <span></span>
			</button>
	    </div>
		<select class="header_select" onchange="moveScroll(this.value, true)">
			<c:forEach items="${menu}" var="row">
				<option value="${row['CODE']}" <c:if test="${selectedMenu eq row['CODE']}">selected</c:if>>${row['NAME']}</option>
			</c:forEach>
	    </select>
	</div>
	<!-- //header -->
	<!-- container -->
	<div class="container">
		<!-- content -->
		<div class="content">
	      	<!-- 입력내용 1 -->
	      	<div id="menu1">
		      	<table class="tb01">
					<colgroup>
						<col style="width:120px">
						<col style="*">
					</colgroup>
					<tbody>
						<tr class="tb_tit_wrap">
							<th>관정관리현황</th>
							<td>
								<div class="input_right">
									<div class="checkbox_container"></div>
								</div>
							</td>
						</tr>
						<tr>
							<th>허가(신고)번호</th>
							<td><input id="WM_PERMIT_NO" type="text" value="${listMain[0]['WM_PERMIT_NO']}" role="default" disabled ></td>
						</tr>
						<tr>
							<th>관리기관 및 부서</th>
							<td><input id="WM_AGENCY_NM" type="text" value="${listMain[0]['WM_AGENCY_NM']}" role="default" disabled></td>
						</tr>
						<tr>
							<th>원주소</th>
							<td>
								<div class="input_two_02">
	          						<input id="WL_ADDR_01"  type="text" value="${listMain[0]['WL_ADDR_01']}" readonly="readonly"><input id="WL_ADDR_02" type="text" value="${listMain[0]['WL_ADDR_02']}" readonly="readonly">
									<input id="WL_ADDR_03" type="text" value="${listMain[0]['WL_ADDR_03']}" readonly="readonly"><input id="WL_ADDR_04" type="text" value="${listMain[0]['WL_ADDR_04']}" readonly="readonly">
								</div>
							</td>
						</tr>
						<tr>
							<th class="i">수정주소</th>
							<td>
								<div class="input_right">
									<div class="checkbox_container"><input type="checkbox" id="cb" onchange="copyAddr(1)"><label for="cb"><em>원주소</em>와 같음</label></div>
								</div>
								<div class="input_two_02">
									<input id="WL_ADDR_01_MOD" type="text" placeholder="시군" value="${listMain[0]['WL_ADDR_01_MOD']}"><input id="WL_ADDR_02_MOD" type="text" placeholder="읍면동" value="${listMain[0]['WL_ADDR_02_MOD']}">
	          						<input id="WL_ADDR_03_MOD" type="text" placeholder="리" value="${listMain[0]['WL_ADDR_03_MOD']}"><input id="WL_ADDR_04_MOD" type="text" placeholder="지번" value="${listMain[0]['WL_ADDR_04_MOD']}">
								</div>
							</td>
						</tr>
						<tr>
							<th class="i">위경도</th>
							<td>
								<p class="input_right"><button class="btn_map" onclick="openKaKaoMap('WL')">위치 찾기</button></p>
								<div class="input_two_02">
									<input id="WL_LOG" type="text" placeholder="위도" value="${listMain[0]['WL_LOG']}"><input id="WL_LAG" type="text" placeholder="경도" value="${listMain[0]['WL_LAG']}">
								</div>
							</td>
						</tr>
						<tr>
							<th>용도</th>
							<td><div class="input_two"><input id="WM_PURPOSE_NAME" type="text" value="생활용" readonly="readonly"><input id="WM_PURPOSE_DETAIL_NAME" type="text" value="${listMain[0]['WM_PURPOSE_DETAIL_NAME']}" readonly="readonly"></div></td>
						</tr>
						<tr>
							<th class="i">수정용도</th> <!--필수 입력 사항 class="i"추가-->
							<td>
								<div class="select_two">
									<select id="WM_PURPOSE_MOD" onchange="drawOptionDetail('WM_PURPOSE_MOD', 'WM_PURPOSE_DETAIL_MOD')">
										<option value="" upcode="null">선택</option>
										<c:forEach items="${listPurPose}" var="row">
											<option value="${row.CODE}" upcode="${row.IDX}" <c:if test="${listMain[0]['WM_PURPOSE_MOD'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
										</c:forEach>
									</select>
									<select id="WM_PURPOSE_DETAIL_MOD">
										<option value="" upcode="null">선택</option>
										<c:forEach items="${listPurPoseDetail}" var="row">
											<option value="${row.CODE}" upcode="${row.UPCODE}" <c:if test="${listMain[0]['WM_PURPOSE_DETAIL_MOD'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
										</c:forEach>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<th class="i">사용용도</th>
							<td><textarea id="WM_PURPOSE_USE"></textarea></td>
						</tr>
						<tr>
							<th class="i">관정현황</th>
							<td>
								<div class="select_two">
					                <select id="WM_STATUS" onchange="drawOptionDetail('WM_STATUS', 'WM_STATUS_DETAIL'); controlView('WM');">
					                	<option value="" upcode="null">선택</option>
										<c:forEach items="${listWmStatus}" var="row">
											<option value="${row.CODE}" upcode="${row.IDX}" <c:if test="${listMain[0]['WM_STATUS'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
										</c:forEach>
					                </select>
					                <select id="WM_STATUS_DETAIL" onchange="controlView('WM')">
					                	<option value="" upcode="null">선택</option>
				                		<c:forEach items="${listWmStatusDetail}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['WM_STATUS_DETAIL'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
										</c:forEach>
					                </select>
								</div>
							</td>
						</tr>
						<tr>
							<th class="i">소유자</th>
							<td>
								<div class="input_right">
									<div class="checkbox_container"><input type="checkbox" id="cb02" onchange="copyAddr(2)"><label for="cb02"><em>사용자주소</em>와 같음</label></div>
								</div>
								<div class="input_two"><input id="WL_OWNER_NM" type="text" placeholder="이름" value=김병철><input id="WL_OWNER_MOBILE" type="text" placeholder="연락처" value=010-3016-7065></div>
								<div class="input_two_02 mt05">
	          						<input id="WL_OWNER_ADDR_01" type="text" placeholder="시군" value="${listMain[0]['WL_OWNER_ADDR_01']}"><input id="WL_OWNER_ADDR_02" type="text" placeholder="읍면동" value="${listMain[0]['WL_OWNER_ADDR_02']}">
	          						<input id="WL_OWNER_ADDR_03" type="text" placeholder="리" value="${listMain[0]['WL_OWNER_ADDR_03']}"><input id="WL_OWNER_ADDR_04" type="text" placeholder="지번" value="${listMain[0]['WL_OWNER_ADDR_04']}">
								</div>
							</td>
						</tr>
						<tr>
							<th class="i">사용자</th>
							<td>
								<div class="input_right">
									<div class="checkbox_container"><input type="checkbox" id="cb03" onchange="copyAddr(3)"><label for="cb03"><em>소유자 주소</em>와 같음</label></div>
								</div>
								<div class="input_two"><input id="WL_USER_NM" type="text" placeholder="이름" value="${listMain[0]['WL_USER_NM']}"><input id="WL_USER_MOBILE" type="text" placeholder="연락처" value="${listMain[0]['WL_USER_MOBILE']}"></div>
								<div class="input_two_02 mt05">
			          				<input id="WL_USER_ADDR_01" type="text" placeholder="시군" value="${listMain[0]['WL_USER_ADDR_01']}"><input id="WL_USER_ADDR_02" type="text" placeholder="읍면동" value="${listMain[0]['WL_USER_ADDR_02']}">
			          				<input id="WL_USER_ADDR_03" type="text" placeholder="리" value="${listMain[0]['WL_USER_ADDR_02']}"><input id="WL_USER_ADDR_04" type="text" placeholder="지번" value="${listMain[0]['WL_USER_ADDR_04']}">
								</div>
							</td>
						</tr>
					</tbody>
				</table>
		      	<!-- //입력내용 1 -->
	      	</div>
	      	<div id="menu2">
	      		<!-- 입력내용 2 -->
				<table class="tb01">
					<colgroup>
						<col style="width:120px">
						<col style="*">
					</colgroup>
					<tbody>
						<tr>
							<th class="i">관정형태</th>
							<td>
								<select id="WU_SHAPE">
								<c:forEach items="${listWuShape}" var="row">
								<option value="${row.CODE}" upcode="${row.UPCODE}" <c:if test="${listMain[0]['WU_SHAPE'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
								</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th>허가형태</th>
							<td>
								<input id="WU_PERMIT" type="text" role="default" disabled value="${listMain[0]['WU_PERMIT_NAME']}">
							</td>
						</tr>
						<tr>
							<th>개발년도</th>
							<td>
								<div class="input_two_02"><input id="WU_COMPL_YEAR" type="text" role="default" disabled value="${listMain[0]['WU_COMPL_YEAR']}"><input id="WU_COMPL_YEAR_MOD" type="text" value="${listMain[0]['WU_COMPL_YEAR_MOD']}"></div>
							</td>
						</tr>
						<tr class="tb_tit_wrap">
							<th>관정현황</th>
							<td>
								<div class="input_right">
									<div class="checkbox_container"><input type="checkbox" id="cb04" onclick="selectAll()"><label for="cb04"><em>기초자료</em>와 같음</label></div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">굴착심도</th>
							<td>
								<div class="input_three">
									<div class="input_m"><input id="WU_DEPTH" type="text" role="default" disabled value="${listMain[0]['WU_DEPTH']}"></div>
					                <div class="input_m"><input id="WU_DEPTH_MOD" type="text" value="${listMain[0]['WU_DEPTH_MOD']}"></div>
									<div class="checkbox_container"><input type="checkbox" id="cb04_1" onchange="selectOne(this)"><label for="cb04_1"></label></div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">내부케이싱</th>
							<td>
								<div class="input_three">
									<div class="input_mm"><input id="WU_INNER_CASING" type="text" role="default" disabled value="${listMain[0]['WU_INNER_CASING']}"></div>
				                	<div class="input_mm"><input id="WU_INNER_CASING_MOD" type="text" value="${listMain[0]['WU_INNER_CASING_MOD']}"></div>
									<div class="checkbox_container"><input type="checkbox" id="cb04_2" onchange="selectOne(this)"><label for="cb04_2"></label></div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">외부케이싱</th>
							<td>
								<div class="input_three">
									<div class="input_mm"><input id="WU_OUT_CASING" type="text" role="default" disabled value="${listMain[0]['WU_OUT_CASING']}"></div>
									<div class="input_mm"><input id="WU_OUT_CASING_MOD" type="text" value="${listMain[0]['WU_OUT_CASING_MOD']}"></div>
									<div class="checkbox_container"><input type="checkbox" id="cb04_3" onchange="selectOne(this)"><label for="cb04_3"></label></div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">펌프종류</th>
							<td>
								<div class="input_three">
									<div class="input_pi_kind"><input id="PI_KIND" type="text" role="default" disabled value="${listMain[0]['PI_KIND']}"></div>
									<div class="input_pi_kind"><input id="PI_KIND_MOD" type="text" value="${listMain[0]['PI_KIND_MOD']}"></div>
									<div class="checkbox_container"><input type="checkbox" id="cb04_4" onchange="selectOne(this)"><label for="cb04_4"></label></div>
								</div>
							</td>
						</tr>
						<tr>
			            	<th class="depth02 i">펌프마력</th>
							<td>
								<div class="input_three">
									<div class="input_hp"><input id="PI_HP" type="text" role="default" disabled value="${listMain[0]['PI_HP']}"></div>
									<div class="input_hp"><input id="PI_HP_MOD" type="text" value="${listMain[0]['PI_HP_MOD']}"></div>
									<div class="checkbox_container"><input type="checkbox" id="cb04_5" onchange="selectOne(this)"><label for="cb04_5"></label></div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">토출관</th>
							<td>
								<div class="input_three">
									<div class="input_mm"><input id="PI_DCP" type="text" role="default" disabled value="${listMain[0]['PI_DCP']}"></div>
									<div class="input_mm"><input id="PI_DCP_MOD" type="text" value="${listMain[0]['PI_DCP_MOD']}"></div>
									<div class="checkbox_container"><input type="checkbox" id="cb04_6" onchange="selectOne(this)"><label for="cb04_6"></label></div>
								</div>
							</td>
						</tr>
						<tr class="tb_tit_wrap">
							<th>부속자재</th>
							<td></td>
						</tr>
						<tr>
							<th class="depth02 i">유량계</th>
							<td>
								<select id="PI_FLUX">
									<option value="">선택</option>
									<c:forEach items="${listPiState}" var="row">
										<option value="${row.CODE}" upcode="${row.UPCODE}" <c:if test="${listMain[0]['PI_FLUX'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
									</c:forEach>								
								</select>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">수위관</th>
							<td>
								<select id="PI_WLC">
									<option value="">선택</option>
									<c:forEach items="${listPiState}" var="row">
										<option value="${row.CODE}" upcode="${row.UPCODE}" <c:if test="${listMain[0]['PI_WLC'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
									</c:forEach>		
								</select>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">출수장치</th>
							<td>
								<select id="PI_FE">
									<option value="">선택</option>
									<c:forEach items="${listPiState}" var="row">
									<option value="${row.CODE}" upcode="${row.UPCODE}" <c:if test="${listMain[0]['PI_FE'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
									</c:forEach>	
								</select>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">제어박스</th>
							<td>
								<select id="PI_CB">
									<option value="">선택</option>
									<c:forEach items="${listPiState}" var="row">
									<option value="${row.CODE}" upcode="${row.UPCODE}" <c:if test="${listMain[0]['PI_CB'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
									</c:forEach>	
								</select>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">체크밸브</th>
							<td>
								<select id="PI_CV">
									<option value="">선택</option>
									<c:forEach items="${listPiState}" var="row">
									<option value="${row.CODE}" upcode="${row.UPCODE}" <c:if test="${listMain[0]['PI_CV'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
									</c:forEach>	
								</select>
							</td>
						</tr>
					</tbody>
      			</table>
				<!-- //입력내용 2 -->
	      	</div>
	      	<div id="menu3">
	      		<!-- 입력내용 3 > 현황판 기입 & 점검현황 -->
				<table class="tb01">
					<colgroup>
						<col style="width:120px">
						<col style="*">
					</colgroup>
					<tbody>
						<tr class="tb_tit_wrap">
							<th>현황판 기입</th>
							<td></td>
						</tr>
						<tr>
							<th class="depth02 i">기반암</th>
							<td><input id="HG_DR" type="text" placeholder="직접입력" value="${listMain[0]['HG_DR']}"></td>
						</tr>
						<tr>
							<th class="depth02 i">양수량</th>
							<td><input id="HG_PC" type="text" placeholder="직접입력" value="${listMain[0]['HG_PC']}"></td>
						</tr>
						<tr>
							<th class="depth02 i">투수량계수</th>
							<td><input id="HG_TC" type="text" placeholder="직접입력" value="${listMain[0]['HG_TC']}"></td>
						</tr>
						<tr>
							<th class="depth02 i">비양수량</th>
							<td><input id="HG_SC" type="text" placeholder="직접입력" value="${listMain[0]['HG_SC']}"></td>
						</tr>
						<tr class="tb_tit_wrap">
							<th>점검현황</th>
							<td></td>
						</tr>
						<tr>
							<th class="depth02 i">사용중지원인</th>
							<td><textarea id="CL_CS" placeholder="직접입력">"${listMain[0]['CL_CS']}"</textarea></td>
						</tr>
						<tr>
							<th class="depth02 i">상부보호공</th>
							<td>
								<select id="CL_UD">
									<option value="">선택</option>
									<c:forEach items="${listClUdStatus}" var="row">
									<option value="${row.CODE}" upcode="${row.UPCODE}" <c:if test="${listMain[0]['CL_UD'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">보호공형태</th>
							<td>
								<select id="CL_UDF">
									<option value="">선택</option>
									<c:forEach items="${listClUdfStatus}" var="row">
									<option value="${row.CODE}" upcode="${row.UPCODE}" <c:if test="${listMain[0]['CL_UDF'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">그라우팅</th>
				            <td>
								<select id="CL_GT">
									<option value="">선택</option>
									<c:forEach items="${listClGtStatus}" var="row">
									<option value="${row.CODE}" upcode="${row.UPCODE}" <c:if test="${listMain[0]['CL_GT'] eq row.CODE}">selected</c:if>>${row.NAME}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">주변시설물</th>
							<td>
								<ul id="CL_FC" class="tb_checkbox_list">
									<li  value="1" <c:if test="${listMain[0]['CL_FC_1'] eq '1'}">class="on"</c:if>>물탱크</li>
									<li  value="2" <c:if test="${listMain[0]['CL_FC_2'] eq '2'}">class="on"</c:if>>가옥형(장옥)</li>
									<li  value="3" <c:if test="${listMain[0]['CL_FC_3'] eq '3'}">class="on"</c:if>>소독시설</li>
									<li  value="4" <c:if test="${listMain[0]['CL_FC_4'] eq '4'}">class="on"</c:if>>기타</li>
								</ul>
								<textarea id="CL_FC_ETC" class="rmk" placeholder="직접입력" class="mt05" >기타입력완료</textarea>
							</td>
						</tr>
					</tbody>
				</table>
	      		<!-- //입력내용 3 > 현황판 기입 & 점검현황 -->
	      	</div>
	      	<div id="menu4">
	      		<!-- 입력내용 4 > 관정 및 자재 상태 -->
	      		<table class="tb01">
					<colgroup>
						<col style="width:120px">
						<col style="*">
					</colgroup>
					<tbody>
						<tr>
							<th class="i">케이싱설치</th>
							<td>
								<select id="CL_CI">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_CI'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="i">그라우팅균열</th>
							<td>
								<select id="CL_GC">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_GC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
			            </tr>
						<tr>
							<th class="i">그라우팅누수</th>
							<td>
								<select id="CL_GL">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_GL'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="i">지표수유입</th>
							<td>
								<select id="CL_SWL">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_SWL'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="i">부식</th>
							<td>
								<select id="CL_RU">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_RU'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="i">수동펌프작동</th>
							<td>
								<select id="CL_WPC">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_WPC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="i">토출관</th>
							<td>
			                	<select id="CL_DCPC">
			                		<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_DCPC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
			            <tr>
							<th class="i">유량계작동</th>
							<td>
								<select id="CL_FMC">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_FMC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="i">수중전선</th>
							<td>
			                	<select id="CL_EWC">
			                		<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_EWC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="i">수위측정관</th>
							<td>
								<select id="CL_WLCC">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_WLCC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="i">출수장치</th>
							<td>
								<select id="CL_FEC">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_FEC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="i">제어판넬</th>
							<td>
								<select id="CL_CBC">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_CBC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
			            </tr>
						<tr>
							<th class="i">전기인입</th>
							<td>
								<select id="CL_ECC">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_ECC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="i">배관누수</th>
							<td>
								<select id="CL_PLC">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['CL_PLC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
        		<!-- //입력내용 4 > 관정 및 자재 상태 -->
	      	</div>
	      	
	      	
			<!-- 입력내용 5 > 문제점 및 개선사항, 특이사항 -->
	      	<div id="menu5">
				<table class="tb01">
					<colgroup>
						<col style="width:120px">
						<col style="*">
					</colgroup>
					<tbody>
						<tr>
							<th class="i">문제점</th>
							<td><textarea id="CL_RE_PLM" placeholder="직접입력" class="h150">${listMain[0]['CL_RE_PLM']}</textarea></td>
						</tr>
						<tr>
							<th class="i">개선사항</th>
							<td><textarea id="CL_RE_IMP" placeholder="직접입력" class="h150">${listMain[0]['CL_RE_IMP']}</textarea></td>
						</tr>
						<tr>
							<th class="i">특이사항</th>
							<td><textarea id="CL_RE_SF" placeholder="직접입력" class="h150">${listMain[0]['CL_RE_SF']}</textarea></td>
						</tr>
					</tbody>
				</table>
	      	</div>
	      	<!-- //입력내용 5 > 문제점 및 개선사항, 특이사항 -->
	      	
			<!-- 입력내용 6 > 현장시험 가능여부  -->
			<div id="menu6">
				<table class="tb01">
					<colgroup>
						<col style="width:120px">
						<col style="*">
					</colgroup>
					<tbody>
						<tr class="tb_tit_wrap">
							<th>현장시험 가능여부</th>
							<td></td>
						</tr>
						<tr>
							<th class="i">자동관측장비</th>
							<td>
								<select id="SS_OS">
									<option value="">선택</option>
									<c:forEach items="${listPosibleStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['SS_OS'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
									</select>
								<textarea id="SS_OS_DISC" placeholder="조사자 의견 : 직접입력" class="mt05">${listMain[0]['SS_OS_DISC']}</textarea>
							</td>
						</tr>
						<tr>
							<th class="i">단계양수시험</th>
							<td>
								<select id="SS_SP">
									<option value="">선택</option>
									<c:forEach items="${listPosibleStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['SS_SP'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
									</select>
								<textarea id="SS_SPD" placeholder="조사자 의견 : 직접입력" class="mt05">${listMain[0]['SS_SPD']}</textarea>
							</td>
						</tr>
						<tr>
							<th class="i">양수시험</th>
							<td>
								<select id="SS_PU">
									<option value="">선택</option>
									<c:forEach items="${listPosibleStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['SS_PU'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
									</select>
								<textarea id="SS_PU_DISC" placeholder="조사자 의견 : 직접입력" class="mt05">${listMain[0]['SS_PU_DISC']}</textarea>
							</td>
						</tr>
						<tr>
							<th class="i">유량계 작동</th>
							<td>
								<select id="SS_FMO">
									<option value="">선택</option>
									<c:forEach items="${listPosibleStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['SS_FMO'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
									</select>
								<textarea id="SS_FMO_DISC" placeholder="조사자 의견 : 직접입력" class="mt05">${listMain[0]['SS_FMO_DISC']}</textarea>
							</td>
						</tr>
						<tr>
							<th class="i">배수</th>
							<td>
								<select id="SS_DC">
									<option value="">선택</option>
									<c:forEach items="${listPosibleStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['SS_DC'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
									</select>
								<textarea id="SS_DC_DISC" placeholder="조사자 의견 : 직접입력" class="mt05">${listMain[0]['SS_DC_DISC']}</textarea>
							</td>
						</tr>
						<tr>
							<th class="i">시료채취</th>
							<td>
								<select id="SS_SM">
									<option value="">선택</option>
									<c:forEach items="${listPosibleStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['SS_SM'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
									</select>
								<textarea id="SS_SM_DISC" placeholder="조사자 의견 : 직접입력" class="mt05">${listMain[0]['SS_SM_DISC']}</textarea>
							</td>
						</tr>
						<tr>
							<th class="i">장비접근</th>
							<td>
								<select id="SS_ME">
									<option value="">선택</option>
									<c:forEach items="${listPosibleStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['SS_ME'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
									</select>
								<textarea id="SS_ME_DISC" placeholder="조사자 의견 : 직접입력" class="mt05">${listMain[0]['SS_ME_DISC']}</textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //입력내용 6 > 현장시험 가능여부  -->
			
			<!-- 입력내용 7 > 수질, 가뭄현황  -->
			<div id="menu7">
				<table class="tb01">
					<colgroup>
						<col style="width:120px">
						<col style="*">
					</colgroup>
					<tbody>
						<tr class="tb_tit_wrap">
							<th>수질관련현황</th>
							<td></td>
						</tr>
						<tr>
							<th>수질검사결과</th>
							<td>
								<input id="WQ_INSPT" type="text" role="default" disabled value="${listMain[0]['WQ_INSPT']}">
							</td>
						</tr>
						<tr>
							<th>부적합항목</th>
							<td><input id="WQ_UF" type="text" role="default" disabled value="${listMain[0]['WQ_UF']}"></td>
						</tr>
						<tr>
							<th class="i">주변오염원</th>
							<td>
								<div>
									<ul class="tb_checkbox_list" id="WQ_PL">
										<li  value="1" name="" <c:if test="${listMain[0]['WQ_PL_1'] eq '1'}">class="on"</c:if>>매립지</li>
										<li  value="2" name="" <c:if test="${listMain[0]['WQ_PL_2'] eq '2'}">class="on"</c:if>>지상탱크</li>
										<li  value="3" name="" <c:if test="${listMain[0]['WQ_PL_3'] eq '3'}">class="on"</c:if>>지하탱크</li>
										<li  value="4" name="" <c:if test="${listMain[0]['WQ_PL_4'] eq '4'}">class="on"</c:if>>축사</li>
										<li  value="5" name="" <c:if test="${listMain[0]['WQ_PL_5'] eq '5'}">class="on"</c:if>>농경지</li>
										<li  value="6" name="" <c:if test="${listMain[0]['WQ_PL_6'] eq '6'}">class="on"</c:if>>주유소</li>
										<li  value="7" name="" <c:if test="${listMain[0]['WQ_PL_7'] eq '7'}">class="on"</c:if>>기타</li>
									</ul>
								</div>
								<textarea id="WQ_ETC" class="rmk" placeholder="직접입력" class="mt05" disabled="disabled">${listMain[0]['WQ_ETC']}</textarea>
							</td>
						</tr>
						<tr class="tb_tit_wrap">
							<th>가뭄현황</th>
							<td>
								<div class="input_right">
									<div class="checkbox_container"><input id="cb05" type="checkbox" id="cb05" onchange="controlView('ET')" ><label for="cb05"><em>가뭄이력</em>유무</label></div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">가뭄이력</th>
							<td><input id="ET_D_HIS" name="ET"  type="text" placeholder="직접입력" disabled="disabled" value="${listMain[0]['ET_D_HIS']}"></td>
						</tr>
						<tr>
							<th class="depth02 i">급수가구</th>
							<td><input id="ET_WSH" type="text" name="ET" placeholder="직접입력" disabled="disabled" value="${listMain[0]['ET_WSH']}"></td>
						</tr>
						<tr>
							<th class="depth02 i">급수인원</th>
							<td><input id="ET_WSP" type="text" name="ET" placeholder="직접입력" disabled="disabled" value="${listMain[0]['ET_WSP']}"></td>
						</tr>
						<tr>
							<th class="depth02 i">급수지역</th>
							<td><input id="ET_WSA" type="text" name="ET" placeholder="직접입력" disabled="disabled" value="${listMain[0]['ET_WSA']}"></td>
						</tr>
						<tr>
							<th class="depth02 i">도로상태</th>
							<td><input id="ET_RO" type="text" name="ET" placeholder="직접입력" disabled="disabled" value="${listMain[0]['ET_RO']}"></td>
						</tr>
						<tr>
							<th class="depth02 i">상수도보급</th>
							<td>
								<input id="ET_WSF" type="text" name="ET" placeholder="직접입력" disabled="disabled" value="${listMain[0]['ET_WSF']}">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //입력내용 7 > 수질, 가뭄현황  -->
	      	
	      	<!-- 입력내용 8 > 마을상수도 물탱크 점검  -->
	      	<div id="menu8">
				<table class="tb01">
					<colgroup>
						<col style="width:120px">
						<col style="*">
					</colgroup>
					<tbody>
						<tr class="tb_tit_wrap">
							<th>물탱크현황</th>
							<td>
								<div class="input_right">
									<div class="checkbox_container"><input id="cb06" type="checkbox" id="cb06" onchange="controlView('WT')" ><label for="cb06"><em>물탱크</em>유무</label></div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">물탱크 주소</th>
							<td>
								<div class="input_two_02">
									<input id="WT_ADDR_01" name="WT" type="text" placeholder="시" disabled="disabled" value="${listMain[0]['WT_ADDR_01']}"><input id="WT_ADDR_02" name="WT" type="text" placeholder="군" disabled="disabled" value="${listMain[0]['WT_ADDR_02']}">
									<input id="WT_ADDR_03" name="WT" type="text" placeholder="리" disabled="disabled" value="${listMain[0]['WT_ADDR_03']}"><input id="WT_ADDR_04" name="WT" type="text" placeholder="지번" disabled="disabled" value="${listMain[0]['WT_ADDR_04']}">
								</div>
							</td>
						</tr>
			            <tr>
							<th class="depth02 i">위경도</th>
							<td>
								<div class="input_right">
									<button class="btn_map vtc_top" onclick="openKaKaoMap('WT')">위치 찾기</button>
									<span class="bar"></span>
									<div class="checkbox_container"><input type="checkbox" id="cb08" onchange="copyAddr(4)"><label for="cb08" class="vtc_top"><em>관정주소</em>와 같음</label></div>
								</div>
								<div class="input_two_02">
									<input id="WT_LOG" name="WT" type="text" placeholder="위도" disabled="disabled" value="${listMain[0]['WT_LOG']}"><input id="WT_LAG" name="WT" type="text" placeholder="경도" disabled="disabled" value="${listMain[0]['WT_LAG']}">
								</div>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">용량</th>
							<td><input id="WT_CP" name="WT" type="text" placeholder="직접입력" disabled="disabled" value="${listMain[0]['WT_CP']}"></td>
						</tr>
						<tr>
							<th class="depth02 i">재질</th>
							<td><input id="WT_MT" name="WT" type="text" placeholder="직접입력" disabled="disabled" value="${listMain[0]['WT_MT']}"></td>
						</tr>
						<tr>
							<th class="depth02 i">담당자</th>
							<td>
								<div class="input_two">
									<input id="WT_MANAGER" name="WT" type="text" placeholder="이름" disabled="disabled" value="${listMain[0]['WT_MANAGER']}"><input id="WT_MOBILE" name="WT" type="text" placeholder="연락처" disabled="disabled" value="${listMain[0]['WT_MOBILE']}">
								</div>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">관정과의 거리</th>
							<td><input id="WT_DISTANCE" name="WT" type="text" placeholder="좌표로 거리계산" disabled="disabled" value="${listMain[0]['WT_DISTANCE']}"></td>
						</tr>
						<tr>
							<tr class="tb_tit_wrap">
							<th>정수장치현황</th>
							<td>
								<div class="input_right">
									<div class="checkbox_container"><input id="cb07" type="checkbox" id="cb07" onchange="controlView('WP')" ><label for="cb07"><em>정수장치</em>유무</label></div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">관리상태</th>
							<td>
								<select id="WP_MS" disabled="disabled">
									<option value="">선택</option>
									<c:forEach items="${listConditionStatus}" var="row">
										<option value="${row.CODE}" <c:if test="${listMain[0]['WP_MS'] eq row.CODE}">selected</c:if>>${row.NAME}</option> 
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="depth02 i">정수방식</th>
							<td>
								<input id="WP_PFM" type="text" placeholder="직접 입력" disabled="disabled" value="${listMain[0]['WP_PFM']}">
							</td>
						</tr>
					</tbody>
				</table>	
	      	</div>
	      	<!-- //입력내용 8 > 마을상수도 물탱크 점검  -->
		</div>
		<!-- //content -->
		
	    <!-- 하단고정 버튼 영역 -->
	    <div class="bottom_btn_wrap">
			<button class="btn_photo" onclick="movePhoto()">PHOTO</button>
			<button class="btn_save" onclick="saveData()">저장</button>
	    </div>
	    <!-- //하단고정 버튼 영역 -->
	</div>
	<!-- //container -->
</div>
<!-- //wrap -->
</body>
</html>