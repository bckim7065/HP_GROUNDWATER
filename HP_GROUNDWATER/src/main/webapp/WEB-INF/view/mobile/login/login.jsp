<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page session="false" %>

<!DOCTYPE html>
<html lang="ko">
    <meta charset="utf-8" />
  	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>지하수 관정 현장조사</title>
  	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css?v=1" />
  	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/layout.css?v=1" />
  	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=1" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/font-awesome.min.css" />
  	
  	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.12.4.min.js"></script>
  	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
  	<script type="text/javascript" src="${pageContext.request.contextPath}/js/cleave.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/cleave_kr.js"></script>
  	
	<script type="text/javascript">
		$(document).ready(function(){
			alert("데모계정 : 01030167065로 접속가능합니다.");
			
			var cleave = new Cleave(".id", {
				phone: true,
			    phoneRegionCode: 'KR',
			    delimiter: ''
			});
			
			let ck_id = getCookie('ck_id');

			if (isNull(ck_id)) {
				return;
			}
			
			if (ck_id != null) {
				$("#saveId").prop("checked", true);
				$("#id").val(ck_id);
			}
		});
	
		function login() {
			let id = $("#id").val();


			if (isNull(id)) {
				alert("휴대폰번호를 입력하여 주세요.");
				return;
			}
			
			let url = "${pageContext.request.contextPath}/mobile/login";
			let params = {
				mobileNumber: $("#id").val()
			}
			$.ajax({
				type : "POST",
				url  : url,
				data: params,
				cache : false,
				success: function(res) {
					if (res.rstCd == "200") {
						saveId();
						location.href = "${pageContext.request.contextPath}/mobile/main";
						return;
					} 

					alert("휴대번호를 확인하여 주세요.\r\n권한이 없는경우 관리자에게 문의하세요.");
					$("#id").focus();
				},
				error:function() {
					alert("로그인 에러");
				}
			});
		}

		function isNull(value) {
			if (value == null || value == undefined || value.toString().replace(/\s/g,"") == "") {
				return true;
			}

			return false;
		}
		
		function checkAction() {
			// 로그인
			if (event.keyCode == 13) {
				$("#btn_id").trigger("click");
				return true;
			}
		}
		
		function setCookie(name, value, exp) {
			let date = new Date();
			date.setTime(date.getTime() + exp * 24 * 60 * 60 * 1000);
			document.cookie = name + '=' + value + ';expires=' + date.toUTCString() + ';path=/';
		}

		function getCookie(name) {
			let value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
			return value ? value[2] : null;
		}

		function eraseCookie(name) {   
			setCookie(name, '', -1);
		}

		function saveId() {
			if ($("#saveId").is(":checked")) {
				setCookie("ck_id", $("#id").val(), 7);
			} else {
				eraseCookie("ck_id");
			}
		}
		
		function isNull(value) {
			if (value == null || value == undefined || value.toString().replace(/\s/g,"") == "") {
				return true;
			}

			return false;
		}
	</script>
	<style>
		#id {
			ime-mode: disabled;
			-webkit-ime-mode: disabled;
		}
		input[type="checkbox"] {
			position: absolute;
			width: 1px;
			height: 1px;
			padding: 0;
			margin: -1px;
			overflow: hidden;
			clip: rect(0, 0, 0, 0);
			border: 0;
		}
		input[type="checkbox"] + label:before {
			display: inline-block;
			content: "";
			position: relative;
			top: 2px;
			width: 12px;
			height: 12px;
			border: 2px solid #666;
		
		}
		input[type="checkbox"]:checked + label:before {
			border: 2px solid #1271b1;
			background-color: #1271b1;
		}
		input[type="checkbox"]:checked + label:after {
			display: inline-block;
			position: absolute;
			content: "\f00c";
			top: 4px;
			left: 2px;
			font-family: fontAwesome;
			font-weight: bold;
			font-size: 12px;
			color: #fff;
		}
		.login_addOn {
			text-align: right;
			margin: 13% 0 5px 0;
		}
		.lb_id {
			position: relative;
			display: inline-block;
			cursor: pointer;
			width: auto;
			height: auto;
		}
		.lb_id span {
			font-size: 17px;
		}
	</style>
	
<body>
<!-- wrap -->
<div class="wrap">
	<!-- 로그인 -->
    <div class="login_wrap">
    	<!--  
		<p class="login_logo"><img src="${pageContext.request.contextPath}/images/logo_saman.png"></p>
		-->
		<div class="login_wrap_in">
			<img src="${pageContext.request.contextPath}/images/login_img.png">
			<div class="login_tit">지하수 관정<p>현장조사</p></div>
			<p class="login_tit_en">Groundwater well Field survey </p>
			<div class="login_addOn">
				<input id="saveId" type="checkbox"/>
				<label class="lb_id" for="saveId">
					<span>번호저장</span>
				</label>
			</div>
			<!-- 입력 -->
			<div class="login_input_wrap">
				<input id="id" class="id" type="text" placeholder="휴대폰번호 (숫자만 입력)" value="01030167065" onkeydown="checkAction()">
				<button id="btn_id" onclick="login();" type="button">로그인</button>
			</div>
			<!-- //입력 -->
			<!--  
			<p class="login_footer">Copyright ⓒsaman eng. All Right Reserved.</p>
			-->
		</div>
	</div>
	<!-- //로그인 -->
</div>
<!-- //wrap -->
</body>
</html>