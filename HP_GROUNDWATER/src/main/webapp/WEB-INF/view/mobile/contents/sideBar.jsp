<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
  	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>삼안 가뭄대비나눔지하수사업</title>
  	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css?v=1646575664" />
  	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css?v=1646575664" />
  	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=1646575664" />
  	<script src="${pageContext.request.contextPath}/js/jquery-1.12.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
    
  	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common_dev.js"></script>
  	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
  	<script>
		let pjtNo = "${pjtNo}";
		let pjtNm = "${pjtNm}";
		let viewSiteNo = "${viewSiteNo}";
		let siteNo = "${siteNo}";
		let preMenu = "${preMenu}";
  	</script>
  	
  	<script>
  	</script>
  	<script>
		$(document).ready(function(){
			addClickEventPop();
		});
		
		// 팝업저장
		function savePop() {
			let url = "${pageContext.request.contextPath}/mobile/savePop";
			
			let params = {
				pjtNo: pjtNo,
				siteNo: siteNo,
				INVEST_DATE: $("#datepicker").val().replaceAll('-', ''),
				selectedMenu: preMenu,
				ETC_01:	$(".pop_tab li.on").attr("value")
			}

			$.ajax({
				type: "POST",
				url: url,
				async: false,
				data: params,
				success : function(res){
					if ($.trim(res.rstCd) == "200") {
						alert("정상적으로 저장되었습니다.");
						moveBack();
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
				}
			});
			
		}

		// 팝업 이벤트 등록
  		function addClickEventPop() {
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

  		function moveBack() {
  			let params = {
				pjtNo: pjtNo,
				viewSiteNo: viewSiteNo,
				siteNo: siteNo,
				pjtNm: pjtNm,
				selectedMenu: preMenu
  			}
  				
  			location.href = "${pageContext.request.contextPath}/mobile/edit" + "?" + $.param(params);
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
		.popup_wrap {
			display: display;
			z-index: 20;
		}
  	</style>
  	
</head>
<body>
<!-- popup -->
<div class="popup_wrap">
	<div class="pop_header">
	   <div class="header_right">
			<button class="header_menu active-1" onclick="moveBack()">
		        <span></span>
		        <span></span>
		        <span></span>
			</button>
	    </div>
	</div>
	<div class="pop_content">
		<div class="pop_content_in">
			<ul class="pop_info">
				<li>${pjtNm}</li>
				<li>${viewSiteNo}</li>
				<li>${SS_M_USER_ID} (${SS_M_USER_NM})</li>
			</ul>
			<!-- 팝업 입력 부분 -->
			<div class="pop_write">
				<p class="pop_tit">조사일자</p>
				<div class="pop_write_input_wrap">
					<input type="text" id="datepicker" class="datepicker" required readonly="readonly" value="2022-03-06">
				</div>
				<p class="pop_tit">작성상태</p>
				<ul class="pop_tab">
					<li <c:if test = "${editStatus == '1'}">class="on"</c:if> value="1">미작성</li>
					<li <c:if test = "${editStatus == '2'}">class="on"</c:if> value="2">작성중</li>
					<li <c:if test = "${editStatus == '3'}">class="on"</c:if> value="3">작성완료</li>
				</ul>
			</div>
			<!-- //팝업 입력 부분 -->
		</div>
	</div>
</div>
<!-- //popup -->
</body>
</html>
