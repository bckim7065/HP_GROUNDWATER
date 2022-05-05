<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
  	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>지하수 관정 현장조사</title>
    
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css?v=1" />
  	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/layout.css?v=1" />
  	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=1" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/font-awesome.min.css" />
  	 
  	<script src="${pageContext.request.contextPath}/js/jquery-1.12.4.min.js"></script>
  	<script>
		let pjtNo = "${pjtNo}";
		let pjtNm = "${pjtNm}";
		let memberMobile = "${memberMobile}";
  	</script>
  	
  	
  	<script>
		$(document).ready(function(){
			$(".drop-down").on("click", function(event){
				$(".options > ul").toggleClass("on");
			});
		});

		function searchProject() {
			let params = {
				pjtNo: pjtNo,
				searchText: $("#search_text").val()
			}

			location.href = "${pageContext.request.contextPath}/mobile/main" + "?" + $.param(params);
		}
	  	
		function checkKey() {
			if (event.keyCode == "13") {
				searchProject();
			}
		}
  	
		function moveEdit(siteNo, viewSiteNo) {
			let params = {
				pjtNo: pjtNo,
				siteNo: siteNo,
				viewSiteNo: viewSiteNo,
				pjtNm: pjtNm
			}
			
			location.href = "${pageContext.request.contextPath}/mobile/edit" + "?" + $.param(params);
		}

		function getProjectList(pjtNo) {
			let params = {
				pjtNo: pjtNo
			}
			
			location.href = "${pageContext.request.contextPath}/mobile/main" + "?" + $.param(params);
		}

		function logout() {
			if (confirm("로그아웃 하시겠습니까?")) {
				let params = {
					memberMobile: memberMobile
				}
				
				let controller = "${pageContext.request.contextPath}/mobile/logout";
				location.href = controller + "?" + $.param(params);
			}
		}
  	</script>
  	<style>
  		.tb_list td.align_center {
  			text-align: center;
  		}
  		.header > .drop-down > .options ul.on {
  			display: block;
  		}
  		.logout {
  			position: absolute;
  			top: 13px;
  			left: 14px;
  			z-index: 10;
  			cursor: pointer;
  		}
  		.logout i {
  			font-size: 22px;
  			color: #8ab389;
  		}
  		.logout:hover i {
			color: #50e44a;
		} 
  	</style>
  	
</head>
<body>
<!-- wrap -->
<div class="wrap">
	<!-- header -->
	<div class="header">
    <!-- ios 가운데 정렬 안되는 문제로 ul li 사용 -->
	<div class="logout" onclick="logout()"><i class="fa fa-power-off" aria-hidden="true"></i></div>
	<div class="drop-down">
		<div class="selected">
        	<a href="#">${pjtNm}</a>
		</div>
		<div class="options">
			<ul>
				<c:forEach items="${userProjectInfo}" var="row">
					<li onclick="getProjectList('${row.PJT_NO}')"><a>${row.PJT_NM}</a></li>
				</c:forEach>
			</ul>
      </div>
    </div>
    <div class="header_srch">
      <input id="search_text" type="text" onkeydown="checkKey()">
      <button type="button" onclick="searchProject()"></button>
    </div>
	</div>
	<!-- //header -->
	<!-- container -->
	<div class="m_container">
		<!-- content -->
		<div class="content">
			<table class="tb_list">
		        <colgroup>
		          <col style="*">
		          <col style="width:90px;">
		        </colgroup>
		        <tbody>
		        	<c:forEach items="${projectInfo}" var="row" varStatus="status">
						<tr onclick="moveEdit('${row.SITE_NO}', '${row.VIEW_PJT_NO}')">
							<th>
								<p class="pj_name ellipsis">${row.VIEW_PJT_NO}</p> 
								<p class="pj_member">
									${row.INVEST_MEMBER_MOBILE}
									<c:if test = "${not empty row.INVEST_MEMBER_NM}">
										(${row.INVEST_MEMBER_NM})
									</c:if>
								</p>
							</th>
							<td>
								<p class="pj_date">${row.INVEST_DATE}</p>
								<p class="pj_progress finish">${row.WRITE_TF}</p>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		<!-- //content -->
	</div>
	<!-- //container -->
</div>
<!-- //wrap -->
</body>
</html>