<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
  	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>지하수 관정 현장조사(PHOTO)</title>
    
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
		let viewSiteNo = "${viewSiteNo}";
		let siteNo = "${siteNo}";
		let preMenu = "${preMenu}";
		let del_files = [];
  	</script>
  	
  	<script>
		$(document).ready(function(){
			$.each($("[id^=m_photo]"), function(index, elem){
				let opt = {
					img: $(elem).find(" +")
				}
				
				$(elem).setPreview(opt);
			});
	
			$(".photo_wrap").on("click", viewPhoto);
			addClickEventToPhtoList();
		});
	  	
	  	function saveData() {
	  		saveFile();
		}
	
		function saveFile() {
			let form = $("#uploadForm")[0];
			let formData = new FormData(form);
			let params = {
				siteNo: siteNo,
				pjtNo: pjtNo
			}
			let controller = "${pageContext.request.contextPath}/mobile/saveFile"
			let url = controller + "?" + $.param(params);
			let PT_KIND = [];
	
			/* [파일 업로드 Start] */
			$.each($("[name^=userfile]"), function(index, elem){
				if (elem.files.length != 0) {
					formData.append("PT_KIND[]", $(elem).attr("PT_KIND"));
				}
			});
			
	        $.ajax({
	        	async: true,
	            cache : false,
	            url : url, // 요기에
	            processData: false,
	            contentType: false,
	            type : 'POST',
	            data : formData,
	            success : function(res) {
					if (res.rstCd != "200") {
						alert("저장중(업로드) 문제가 발생하였습니다.\r\n관리자에게 문의하세요.");
						console.log(res);
						return;
					}
	
					if (del_files.length == 0) {
						//alert("정상적으로 저장되었습니다.");
						location.reload();
						return;
					}
	
					deleteFile();
	            }, // success
	            error : function(xhr, status) {
	                alert(xhr + " : " + status);
	            },
	            beforeSend : function(){
	            	showLoadingBar();
	            },
	            complete : function(){
	            	hideLoadingBar();
				}
	        });
		}
	
		function deleteFile() {
			let params = {
				pjtNo: pjtNo,
				siteNo: siteNo
			}
			let data = {
				del_files: del_files
			}
			let controller = "${pageContext.request.contextPath}/mobile/deleteFile"
			let url = controller + "?" + $.param(params);
			
			/* [파일 삭제 Start] */
	        $.ajax({
	            async: true,
	            cache : false,
	            url : url, // 요기에
	            type : 'POST',
	            data : data,
	            success : function(res) {
	                if ($.trim(res.msg) == "success") {
	                	//alert("정상적으로 저장되었습니다.");
	      	            location.reload();
	                	return;
	                }
	
	                alert("저장중(파일삭제) 문제가 발생하였습니다.\r\n관리자에게 문의하세요.");
	                console.log(data);
	            }, // success
	            error : function(xhr, status) {
	                alert(xhr + " : " + status);
	            }
	        });
	        /* [파일 삭제 End] */
		}
	
		function addClickEventToPhtoList() {
			$.each($("[name=btn_upload]"), function(index, elem){
				$(elem).on("click", function(event){
					let bind = $(event.target).attr("bind");
					let input_file = $("#" + bind);
					let img_preview = $(input_file).find(" + img");
					
					input_file.trigger("click");
					img_preview.attr("src", "");
				});
			});
		}
	
	    function delPhoto(action, seq) {
			let img = $(event.target).parent().prev().find(" img");
			let li = $(event.target).parent().parent();
			let src = img.attr("src");

			//#f0f0f0

			//img.attr("src", "");
			if (li.hasClass("deleted")) {
				for (let i = 0; i < del_files.length; i++) {
					if (del_files[i] == seq)  {
						del_files.splice(i, 1);
						li.toggleClass("deleted");
						return;
					}
				}
			}
			
			li.toggleClass("deleted");
        	del_files.push(seq);
	    }
	
	    function changeMenu(menu) {
			let params = {
				selectedMenu: menu,
				pjtNo: pjtNo,
				viewSiteNo: viewSiteNo,
				siteNo: siteNo,
				selectedMenu: menu
			}
			let url = "${pageContext.request.contextPath}/mobile/edit"
			location.href = url + "?" + $.param(params);
	    }
	
	    function isNull(value) {
			if (value == null || value == undefined || value.toString().replace(/\s/g,"") == "") {
				return true;
			}
	
			return false;
		}
	
		function showLoadingBar() {
			if ($("loading_mask").length > 1) {
				return;
			}
	
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
	
			$('#loading_mask').show();
			$('#loading_img').show();
		}
	
		function hideLoadingBar() {
			$('#loading_mask, #loading_img').hide();
		}
	
		function moveSideBar() {
			let params = {
				pjtNo: pjtNo,
				pjtNm: pjtNm,
				siteNo: siteNo,
				viewSiteNo: viewSiteNo,
				preMenu: "menu9" 
			}
			
			let controller = "${pageContext.request.contextPath}/mobile/sideBar"
			location.href = controller + "?" + $.param(params);
  		}
	
		function viewPhoto() {
			let element = $(event.target);
			let src = element.attr("src");
	
			if (isNull(src)) {
				return;
			}
	
			$("#frame_preview").attr("src", src);
			$("#frame_img").toggleClass("on");
		}
  	</script>
  	<style>
  		[name^=userfile] {
  			overflow: hidden;
  			position: absolute;
  			clip: rect(0 0 0 0);
  			width: 1px;
  			height: 1px;
  			margin: -1px;
  		}
  		.div_hidden  {
  			display: none;
  		}
  		#frame_img {
  			display : none; 
  			width: 80%;
  			height: 55%;
  			position: fixed; 
  			border:2px solid #f0f0f0;
  			top: 50%;
  			left: 50%;
  			transform: translate(-50%, -50%);
  			background-color: #fff;
  		}
		#frame_img.on {
			display: block;
		}
  		#frame_img img {
  			width: 100%;
  			height: 100%
  		}
  		.bottom_btn_wrap .btn_photo::before {
			display: none;
		}
		.photo_list li .photo_wrap img {
			width: 100%;
			height: 100%;
			padding: 5px 5px;
		}
		Img[src=''], Img:not([src]) {
			opacity:0;
		}
		.photo_list li.deleted {
			border-color: #e17343;
		}
  	</style>
  	
</head>
<body>
<!-- wrap -->
<form id="uploadForm" name="uploadForm"  method="post" enctype="multipart/form-data">
	<div class="div_hidden">
		<input type="hidden" id="siteNo" 		name="siteNo"		title="siteNo"  	value="${siteNo}" 		style="width:50px;"/>
		<input type="hidden" id="pjtNo" 		name="pjtNo"		title="pjtNo"    	value="${pjtNo}" 		style="width:50px;"/>
	</div>
	<div class="wrap">
		<!-- header -->
		<div class="header">
			<a href="#" class="header_home" onclick="moveHome()"></a>
			<h1 class="header_tit">${viewSiteNo}</h1>
			<div class="header_right">
				<button type="button" class="header_menu" onclick="moveSideBar()">
					<span></span>
					<span></span>
					<span></span>
				</button>
			</div>
			<select class="header_select" onchange="changeMenu(this.value)">
					<c:forEach items="${menu}" var="row">
						<option value="${row['CODE']}" <c:if test="${selectedMenu eq row['CODE']}">selected</c:if>>${row['NAME']}</option>
					</c:forEach>
			</select>
		</div>
		<!-- //header -->
		<!-- container -->
		<div class="container">
	    	<!-- content -->
			<ul class="photo_list">
					<li>
						<p>원경</p>
						<div class="photo_wrap">
							<c:choose>
								<c:when test="${empty viewMain['4']}">
									<input id="m_photo4" type="file" name="userfile[]" accept="image/*" capture="camera" PT_KIND="4"></input>
									<img id="m_preview4">
								</c:when>
								<c:otherwise>
									<img id="m_preview4" src="<c:url value="/mobile/fileView?fileName=${viewMain['4']['PT_STORED_NM']}&PT_KIND=4"></c:url>">
								</c:otherwise>
							</c:choose>
			        	</div>
				        <div class="button_wrap">
				        	<c:choose>
				        		<c:when test="${not empty viewMain['4']}">
				        			<button name="btn_delete" class="btn_delete" type="button" onclick="delPhoto('del','4','')">삭제</button>
				        		</c:when>
				        		<c:otherwise>
				        			<button name="btn_upload" class="btn_upload" type="button" bind="m_photo4" >업로드</button>
				        		</c:otherwise>
				        	</c:choose>
			        	</div>
					</li>
							
					<li>
						<p>근경</p>
						<div class="photo_wrap">
							<c:choose>
								<c:when test="${empty viewMain['1']}">
									<input id="m_photo1" type="file" name="userfile[]" accept="image/*" capture="camera" PT_KIND="1"></input>
									<img id="m_preview1">
								</c:when>
								<c:otherwise>
									<img id="m_preview1" src="<c:url value="/mobile/fileView?fileName=${viewMain['1']['PT_STORED_NM']}&PT_KIND=1"></c:url>">
								</c:otherwise>
							</c:choose>
						</div>
						<div class="button_wrap">
							<c:choose>
				        		<c:when test="${not empty viewMain['1']}">
				        			<button name="btn_delete" class="btn_delete" type="button" onclick="delPhoto('del','1','')">삭제</button>
				        		</c:when>
				        		<c:otherwise>
				        			<button name="btn_upload" class="btn_upload" type="button" bind="m_photo1" >업로드</button>
				        		</c:otherwise>
				        	</c:choose>
						</div>
					</li>
					<li>
						<p>내부</p>
				        <div class="photo_wrap">
				        	<c:choose>
					        	<c:when test="${empty viewMain['2']}">
									<input id="m_photo2" type="file" name="userfile[]" accept="image/*" capture="camera" PT_KIND="2"></input>
									<img id="m_preview2">
								</c:when>
								<c:otherwise>
									<img id="m_preview2" src="<c:url value="/mobile/fileView?fileName=${viewMain['2']['PT_STORED_NM']}&PT_KIND=2"></c:url>">
								</c:otherwise>
							</c:choose>
			        	</div>
				        <div class="button_wrap">
				        	<c:choose>
				        		<c:when test="${not empty viewMain['2']}">
				        			<button name="btn_delete" class="btn_delete" type="button" onclick="delPhoto('del','2','')">삭제</button>
				        		</c:when>
				        		<c:otherwise>
				        			<button name="btn_upload" class="btn_upload" type="button" bind="m_photo2" >업로드</button>
				        		</c:otherwise>
				        	</c:choose>
			        	</div>
					</li>
				
					<li>
						<p>현황판</p>
						<div class="photo_wrap">
							<c:choose>
								<c:when test="${empty viewMain['5']}">
									<input id="m_photo5" type="file" name="userfile[]" accept="image/*" capture="camera" PT_KIND="5"></input>
									<img id="m_preview5">
								</c:when>
								<c:otherwise>
									<img id="m_preview5" src="<c:url value="/mobile/fileView?fileName=${viewMain['5']['PT_STORED_NM']}&PT_KIND=5"></c:url>">
								</c:otherwise>
							</c:choose>
						</div>
						<div class="button_wrap">
							<c:choose>
				        		<c:when test="${not empty viewMain['5']}">
				        			<button name="btn_delete" class="btn_delete" type="button" onclick="delPhoto('del','5','')">삭제</button>
				        		</c:when>
				        		<c:otherwise>
				        			<button name="btn_upload" class="btn_upload" type="button" bind="m_photo5" >업로드</button>
				        		</c:otherwise>
				        	</c:choose>
						</div>
					</li>
					<li>
						<p>물탱크원경</p>
						<div class="photo_wrap">
							<c:choose>
								<c:when test="${empty viewMain['6']}">
									<input id="m_photo6" type="file" name="userfile[]" accept="image/*" capture="camera" PT_KIND="6"></input>
									<img id="m_preview6">
								</c:when>
								<c:otherwise>
									<img id="m_preview6" src="<c:url value="/mobile/fileView?fileName=${viewMain['6']['PT_STORED_NM']}&PT_KIND=6"></c:url>">
								</c:otherwise>
							</c:choose>
						</div>
						<div class="button_wrap">
							<c:choose>
				        		<c:when test="${not empty viewMain['6']}">
				        			<button name="btn_delete" class="btn_delete" type="button" onclick="delPhoto('del','6','')">삭제</button>
				        		</c:when>
				        		<c:otherwise>
				        			<button name="btn_upload" class="btn_upload" type="button" bind="m_photo6" >업로드</button>
				        		</c:otherwise>
				        	</c:choose>
						</div>
					</li>   
					<li>
						<p>물탱크 근경</p>
				        <div class="photo_wrap">
				        	<c:choose>
					        	<c:when test="${empty viewMain['3']}">
									<input id="m_photo3" type="file" name="userfile[]" accept="image/*" capture="camera" PT_KIND="3"></input>
									<img id="m_preview3">
								</c:when>
								<c:otherwise>
									<img id="m_preview3" src="<c:url value="/mobile/fileView?fileName=${viewMain['3']['PT_STORED_NM']}&PT_KIND=3"></c:url>">
								</c:otherwise>
							</c:choose>
			        	</div>
				        <div class="button_wrap">
				        	<c:choose>
				        		<c:when test="${not empty viewMain['3']}">
				        			<button name="btn_delete" class="btn_delete" type="button" onclick="delPhoto('del','3','')">삭제</button>
				        		</c:when>
				        		<c:otherwise>
				        			<button name="btn_upload" class="btn_upload" type="button" bind="m_photo3" >업로드</button>
				        		</c:otherwise>
				        	</c:choose>
			        	</div>
					</li>
					<li>
						<p>기타1</p>
						<div class="photo_wrap">
							<c:choose>
								<c:when test="${empty viewMain['7']}">
									<input id="m_photo7" type="file" name="userfile[]" accept="image/*" capture="camera" PT_KIND="7"></input>
									<img id="m_preview7">
								</c:when>
								<c:otherwise>
									<img id="m_preview7" src="<c:url value="/mobile/fileView?fileName=${viewMain['7']['PT_STORED_NM']}&PT_KIND=7"></c:url>">
								</c:otherwise>
							</c:choose>
						</div>
						<div class="button_wrap">
							<c:choose>
				        		<c:when test="${not empty viewMain['7']}">
				        			<button name="btn_delete" class="btn_delete" type="button" onclick="delPhoto('del','7','')">삭제</button>
				        		</c:when>
				        		<c:otherwise>
				        			<button name="btn_upload" class="btn_upload" type="button" bind="m_photo7" >업로드</button>
				        		</c:otherwise>
				        	</c:choose>
						</div>
					</li>      
					<li>
						<p>기타2</p>
						<div class="photo_wrap">
							<c:choose>	
								<c:when test="${empty viewMain['8']}">
									<input id="m_photo8" type="file" name="userfile[]" accept="image/*" capture="camera" PT_KIND="8"></input>
									<img id="m_preview8">
								</c:when>
								<c:otherwise>
									<img id="m_preview8" src="<c:url value="/mobile/fileView?fileName=${viewMain['8']['PT_STORED_NM']}&PT_KIND=8"></c:url>">
								</c:otherwise>
							</c:choose>
						</div>
						<div class="button_wrap">
							<c:choose>
				        		<c:when test="${not empty viewMain['8']}">
				        			<button name="btn_delete" class="btn_delete" type="button" onclick="delPhoto('del','8','')">삭제</button>
				        		</c:when>
				        		<c:otherwise>
				        			<button name="btn_upload" class="btn_upload" type="button" bind="m_photo8" >업로드</button>
				        		</c:otherwise>
				        	</c:choose>
						</div>
					</li>      
					<li>
						<p>기타3</p>
						<div class="photo_wrap">
							<c:choose>
								<c:when test="${empty viewMain['9']}">
									<input id="m_photo9" type="file" name="userfile[]" accept="image/*" capture="camera" PT_KIND="9"></input>
									<img id="m_preview9">
								</c:when>
								<c:otherwise>
									<img id="m_preview9" src="<c:url value="/mobile/fileView?fileName=${viewMain['9']['PT_STORED_NM']}&PT_KIND=9"></c:url>">
								</c:otherwise>
							</c:choose>
						</div>
						<div class="button_wrap">
							<c:choose>
				        		<c:when test="${not empty viewMain['9']}">
				        			<button name="btn_delete" class="btn_delete" type="button" onclick="delPhoto('del','9','')">삭제</button>
				        		</c:when>
				        		<c:otherwise>
				        			<button name="btn_upload" class="btn_upload" type="button" bind="m_photo9" >업로드</button>
				        		</c:otherwise>
				        	</c:choose>
						</div>
					</li>
					<li>
						<p>기타4</p>
						<div class="photo_wrap">
							<c:choose>
								<c:when test="${empty viewMain['10']}">
									<input id="m_photo10" type="file" name="userfile[]" accept="image/*" capture="camera" PT_KIND="10"></input>
									<img id="m_preview10">
								</c:when>
								<c:otherwise>
									<img id="m_preview10" src="<c:url value="/mobile/fileView?fileName=${viewMain['10']['PT_STORED_NM']}&PT_KIND=10"></c:url>">
								</c:otherwise>
							</c:choose>
						</div>
						<div class="button_wrap">
							<c:choose>
				        		<c:when test="${not empty viewMain['10']}">
				        			<button name="btn_delete" class="btn_delete" type="button" onclick="delPhoto('del','10','')">삭제</button>
				        		</c:when>
				        		<c:otherwise>
				        			<button name="btn_upload" class="btn_upload" type="button" bind="m_photo10" >업로드</button>
				        		</c:otherwise>
				        	</c:choose>
						</div>
					</li>
			</ul>
	    	<!-- //content -->
			<!-- 하단고정 버튼 영역 -->
			<div class="bottom_btn_wrap">
				<button type="button" class="btn_photo" onclick="changeMenu('${preMenu}')">이전</button>
				<button type="button" class="btn_save" onclick="saveData()">저장</button>
			</div>
			<!-- //하단고정 버튼 영역 -->
		</div>
		<div id="frame_img" name="frame_img" onclick="viewPhoto('display','');" >
			<img id="frame_preview" class="hand" src="" title="이미지 미리보기"/>
		</div>
		<!-- //container -->
	</div>
	<!-- //wrap -->
</form>
</body>
</html>