<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
  	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>위치 찾기</title>
     
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/font-awesome.min.css" /> 
     
	<script type="text/javascript"  src="${pageContext.request.contextPath}/js/jquery-1.12.4.min.js"></script>
  	<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
  	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${KAKAO_TOKEN}&libraries=services"></script>
	<script>
		let pjtNo = "${pjtNo}";
		let siteNo = "${siteNo}";
		let address = "${address}";
  	</script>
  	
  	
  	<script>
	  	let geocoder = null;
	  	let map = null;
	  	let mapContainer = null;
	  	let places = null;
	  	let markers = [];
	  	let traceMarker = null;
	  	let isThrottle = true;
	  	let throttleTime = 1;
	  	let infowindow = null;
	  	let isInit = true;
  		
		$(document).ready(function(){
			init();
		});

		function init() {
			mapContainer = document.getElementById('map'); // 지도를 표시할 div 
		    let mapOption = {
		        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
		        level: 3, // 지도의 확대 레벨,
	            mapTypeId: kakao.maps.MapTypeId.HYBRID
		    };  

			// 지도 생성  
			map = new kakao.maps.Map(mapContainer, mapOption); 
			// 주소-좌표 변환 객체
			geocoder = new kakao.maps.services.Geocoder();
			places = new kakao.maps.services.Places();

			findAddress();
			
			// 지도, 스카이뷰
			let mapTypeControl = new kakao.maps.MapTypeControl();
			map.addControl(mapTypeControl, kakao.maps.ControlPosition.BOTTOMRIGHT);

			// 드래그 start
			kakao.maps.event.addListener(map, 'dragstart', function() {
				$(".map_desc").css("display", "none");
			});
			
			// 드래그 ing
			kakao.maps.event.addListener(map, 'drag', function() {
				$("#disp_address").blur();
				let coords = {
					lat : map.getCenter().getLat(),
					lng : map.getCenter().getLng()
				}

				throttleCoord2Address(coords);
			});

			// 드래그 End
			kakao.maps.event.addListener(map, 'dragend', function(event) {
				let coords = {
					lat : map.getCenter().getLat(),
					lng : map.getCenter().getLng()
				}

				throttleCoord2Address(coords, true);
			});

			kakao.maps.event.addListener(map, 'zoom_start', function() {
				$("#disp_address").blur();
				$(".map_desc").css("display", "none");
			});

			// 지도가 확대 또는 축소되면 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
			kakao.maps.event.addListener(map, 'zoom_changed', function() {  
				let coords = {
					lat : map.getCenter().getLat(),
					lng : map.getCenter().getLng()
				}

				throttleCoord2Address(coords, true);
			});

			$("[title='지도']").parent().parent().css("top", 20);

			$(window).resize(function(){
				/*
				let coords = {
					lat : map.getCenter().getLat(),
					lng : map.getCenter().getLng()
				}
				throttleCoord2Address(coords);
				*/
			});
		}

		function removeMarker() {
			for (let i = 0; i < markers.length; i++) {
				markers[i].setMap(null);
			}
		}

		function throttleCoord2Address(coords, isDisplay) {
			if (isDisplay) {
				isThrottle = false;
				
				geocoder.coord2Address(coords.lng, coords.lat, function(result1, status1){
					geocoder.coord2RegionCode(coords.lng, coords.lat, function(result2, status2) {
						// 마커설정
						traceMarker.setPosition(new kakao.maps.LatLng(coords.lat, coords.lng));
						// 마커인포 
						if (status1 == kakao.maps.services.Status.OK) {
							setInfoWindow(traceMarker, result2[1].region_3depth_name);
							$(".map_desc").css("display", "block");
						} else {
							infowindow.close();
							$(".map_desc").css("display", "none");
						}
						// 맵_상세 설정   
						setMapDescHtml(result1, coords);
						isThrottle = true;
					});
				});

				return;
			}
			
			if (isThrottle) {
				isThrottle = false;

				setTimeout(function(){
					// coord2Address(경도(longtiude), 위도(latitude), callback)
					geocoder.coord2Address(coords.lng, coords.lat, function(result1, status1){
						geocoder.coord2RegionCode(coords.lng, coords.lat, function(result2, status2) {
							// 마커설정
							traceMarker.setPosition(new kakao.maps.LatLng(coords.lat, coords.lng));
							// 마커인포 
							if (status1 == kakao.maps.services.Status.OK) {
								setInfoWindow(traceMarker, result2[1].region_3depth_name);
							} else {
								infowindow.close();
								$(".map_desc").css("display", "none");
							}
							// 맵_상세 설정   
							setMapDescHtml(result1, coords);
							isThrottle = true;
						});
					});
				}, throttleTime);
			}
		}

		function setMapDescHtml(result, coords) {
			if (isNull(result) || isNull(coords) == null) {
				return;
			}

			coords.lat = coords.lat.toFixed(7);
			coords.lng = coords.lng.toFixed(7);
			
			let html = "";
			let address = result[0].address.address_name;

			if (result[0].road_address != null) {
				address = result[0].road_address.address_name +  " " + result[0].road_address.building_name;
			}

			html += "<span class='icon_copy' onclick='copyAddress()'>" + "<i class='fa fa-clone' aria-hidden='true'></i>" + "</span>";
			html += "<span class='address' title='" + address + "'>" + address + "</span>" + "<br>";
			html += "<span class='location'>" + "위도 : " + coords.lat + ", " + "경도 : " + coords.lng + "</span>";
			
			$(".map_desc").html(html);
		}

		function setInfoWindow(marker, content) {
			let iwContent = content; // 인포윈도우에 표시할 내용
			let iwRemoveable = true;
			iwContent = "<div class='map_info'>" + content + "</div>"; // 인포윈도우에 표시할 내용

	        if (infowindow != null) {
				infowindow.close();
	        }
			    
		    // 인포윈도우 객체 생성
		    infowindow = new kakao.maps.InfoWindow({
		        content : iwContent,
		        removable : false
		    }); 

		    // 마커에 윈포윈도우 설정 
		    infowindow.open(map, marker);
		}

		function findAddress() {
			map.relayout();
			let address = $("#address").val();

			// 주소로 좌표를 검색합니다
			if (address == "") {
				address = "서울 중구 태평로2가 17-3 ";
			}
			
			geocoder.addressSearch(address, function(result, status) {
				// 정상적으로 검색이 완료됐으면 
				if (status === kakao.maps.services.Status.OK) {
					if (markers.length != 0) {
						removeMarker();
					}
					
			        let coords = new kakao.maps.LatLng(result[0].y, result[0].x);
			        // 결과값으로 받은 위치를 마커로 표시합니다
			        let marker = new kakao.maps.Marker({
			            map: map,
			            position: coords,
			            draggable: false,
			        });
			        markers.push(marker);

			     	let imageSrc = '${pageContext.request.contextPath}/images/cur-location.svg';    
				    let imageSize = new kakao.maps.Size(40, 30);
				      
					// 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
					let markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);
					traceMarker = new kakao.maps.Marker({
			            map: map,
			            position: coords,
			            draggable: false,
			            image: markerImage
			        });
					markers.push(traceMarker);

					let coord = {
						lat : coords.getLat(),  // 위도
						lng : coords.getLng()  // 경도
					}
					throttleCoord2Address(coord);
	
			        map.setCenter(coords);
			    } else {
			    	places.keywordSearch(address, function(result, status) { 
						if (status === kakao.maps.services.Status.OK && result.length == 1) {
							$("#address").val(result[0].address_name);
							findAddress();
						} else {
							if (status !== kakao.maps.services.Status.OK) {
								if (isInit) {
									//$("#address").val('');
									//$("#disp_address").val('');

									if (markers.length != 0) {
										removeMarker();
									}

									// 시청 default;
							        let coords = new kakao.maps.LatLng(37.5654004, 126.9776792);
							        // 결과값으로 받은 위치를 마커로 표시합니다
							        let marker = new kakao.maps.Marker({
							            map: map,
							            position: coords,
							            draggable: false,
							        });
							        markers.push(marker);

							     	let imageSrc = '${pageContext.request.contextPath}/images/cur-location.svg';    
								    let imageSize = new kakao.maps.Size(40, 30);
								    
									// 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
									let markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);
									traceMarker = new kakao.maps.Marker({
							            map: map,
							            position: coords,
							            draggable: false,
							            image: markerImage
							        });
									markers.push(traceMarker);

									let coord = {
										lat : coords.getLat(),  // 위도
										lng : coords.getLng()  // 경도
									}
									throttleCoord2Address(coord);
									
									map.setCenter(coords);
									isInit = false;
								}
								
								alert("주소를 찾을 수 없습니다.\r\n1.주소를 상세하게 입력해주세요.\r\n2.시군,읍면동,지번을 띄어쓰기로 구분하세요.");
							} else {
								let title = $("#disp_address").val();
								let html = "";


								html += "<div class='header'>";
									html += "<span class='search_close'><i class='fa fa-times' aria-hidden='true'></i></span>"  + title + " 찾기 결과";
								html += "</div>";
								let categorys = [];
								let cnt = 0;
								for (let i = 0; i < result.length; i++) {
									if (isNull(result[i].road_address_name)) {
										continue;
									}
								
									html += "<div class='item' onclick=\"setAddress('" + result[i].road_address_name + "'" + ",'" + result[i].place_name + "')\">";
										html += "<span class='search_name'>";
											html += result[i].place_name;
											categorys = result[i].category_name.split(">");
											html += "<span class='search_category'>" + categorys[categorys.length - 1] + "</span>";
										html += "</span>";
										html += "<span class='search_address'>" + result[i].road_address_name + "</span>";
										html += isNull(result[i].phone) ? "" : "<span class='search_tel'>" + result[i].phone + "</span>";
									html += "</div>";
									
									cnt++;
								}

								if (cnt == 0) {
									html += "<div class='item align_center'>";
										html +=	"검색 결과가 없습니다.";
									html += "</div>";
								}

								$("#search_pop").html(html);
								
								$(".content").css("display", "none");
								$("#search_pop").fadeIn(600);

								$(".search_close").on("click", function(){
									$("#search_pop").css("display", "none");
									$(".content").fadeIn(600);
									map.relayout();
								});

								$(".content").css("display", "none");
								$("#search_pop").fadeIn(600);
							}
						}
			    	});
			    } 
			}); 

		}

		function copyAddress() {
			let tempTxtArea = document.createElement("textarea");
			document.body.appendChild(tempTxtArea);
			tempTxtArea.value = $(".map_desc .address").text() + " " + $(".map_desc .location").text();
			tempTxtArea.select();
			tempTxtArea.setSelectionRange(0, 9999);  // IOS 호환
			
			document.execCommand("copy");
			document.body.removeChild(tempTxtArea);

			$("#msg_pop").css("display", "block");
			$("#msg_pop").fadeOut(3000);
		}

		function saveData() {
			if (markers.length == 0) {
				alert("위치를 검색하세요.");
				return;
			}

            let position = {
               dvsCd: $("#dvsCd").val(),
               lat: traceMarker.getPosition().getLat().toFixed(7),  // 위도
               lng: traceMarker.getPosition().getLng().toFixed(7)  // 경도
            }
            
            opener.setMapPosition(position);
            closeWindow();
		}

		function checkAction() {
			$("#address").val($("#disp_address").val()); 

			
			if (event.keyCode == 13) {
				if (isNull($("#address").val())) {
					alert("주소를 입력해주세요.");
					$("#disp_address").focus();
					return;
				}
				
				findAddress();
			} 
		}

		function isNull(value) {
  			if (value == null || value == undefined || value.toString().replace(/\s/g,"") == "") {
  				return true;
  			}

  			return false;
  		}

	  	function closeWindow() {
        	window.close(); 
        }

	  	function setAddress(address, place) {
	  		$("#disp_address").val(place);
			$("#address").val(address);

			$("#search_pop").css("display", "none");
			$(".content").css("display", "block");
			
			findAddress();
	  	}
  	</script>
  	<style>
  		html, body {
  			height: 100%;
  			margin: 0;
  			padding: 0;
  		}
  		.wrap {
  			position: relative;
  			width: 100%;
  			height: 100%;
  		}
  		/* [카카오 맵 Start] */
  		.map_wrap {
  			position: relative;
  			height: 90%;
  		}
  		.map_wrap .map {
			height: 100%;
		}
		.map_wrap .map_desc {
			position: absolute;
			bottom: 45px;
			left: 0;
			width: 100%;
			height: auto;
			padding: 5px;
			z-index: 1000;
			background: #fff;
			text-align: center;
			box-sizing: border-box;
		}
		.map_wrap .map_desc .address {
			display: inline-block;
			width: 100%;
			font-size: 15px;
			font-weight: bold;
			color: #0558ef;
			text-overflow: ellipsis;
			overflow: hidden;
			white-space: nowrap;
		}
		.map_wrap .map_desc .location {
			display: inline-block;
			width: 100%;
			font-size: 14px;
			font-weight: bold;
			color: #8f8d8d;
			text-overflow: ellipsis;
			overflow: hidden;
			white-space: nowrap;
		}
		.map_wrap .map_info {
			width: 150px;
			text-align: center;
			font-size: 15px;
			font-weight: bold;
		}
        .map_desc .icon_copy {
        	position: absolute;
        	display: inline-block;
        	width: auto;
        	height: 35px;
        	top: 50%;
        	right: 10px;
        	transform: translate(0, -50%);
        }
        .map_desc .icon_copy i {
        	font-size: 21px;
        	position: relative;
        	top: 50%;
        	left: 50%;
        	transform: translate(-50%, -50%);
        }
        .msg_pop {
        	display: none;
        	width: 100%;
        	height: auto;
        	position: absolute;
        	left: 0;
        	bottom : 182px;
        	z-index: 9999;
        	text-align: center;
        }
        .msg_pop .msg {
        	display: inline-block;
        	background: #8f8d8d;
        	padding: 10px 5px;
        	border-radius: 15px;
        	font-size: 15px;
        	font-weight: bold;
        	color: #fff;
        }
		/* [카카오 맵 Start] */
		/* [본문 Start] */
  		.content {
  			width: 100%;
  			height: 100%;
  		}
		.content .search_wrap {
			position: absolute;
			width: 100%;
			padding: 10px 8px;
			z-index: 10;
			box-sizing: border-box;
		}
        .content .search {
            position: relative;
            width: 100%;
            padding: 5px 10px;
            box-shadow: 0 10px 6px -6px #bbb;
            box-sizing: border-box;
            border: 2px solid #eee;
            border-radius: 5px;
            background-color: #fff;
        }
        .content #address {
        	width: calc(100% - 56px);
        	height: 25px;
        	font-size: 15px;
        	border: 0;
        	outline: none;
        	box-sizing: border-box;
        }
        .content #disp_address {
        	width: calc(100% - 56px);
        	height: 25px;
        	font-size: 15px;
        	border: 0;
        	outline: none;
        	box-sizing: border-box;
        }
        .content #search {
        	width: 50px;
        }
        /* [본문 End] */
        /* [Footer(저장, 닫기) Start] */
        .map_footer {
        	position: relative;
        	height: 10%;
        	background: #fff;
        }
        .map_footer .btn_wrap {
        	width: 100%;
        	position: relative;
        	top: 50%;
        	left: 50%;
        	transform: translate(-50%, -50%);
        	text-align: center;
        }
        .map_footer #confirm {
			display: inline-block;
        	position: relative;
        	width: 51px;
        	padding: 8px 27px;
        	border-radius: 3px;
        	background: #0b96ab;
        	color: #fff;
        	font-weight: bold;
        	text-align: center;
        	cursor: pointer;
        }
        .map_footer #close {
        	display: inline-block;
        	position: relative;
        	width: 51px;
        	padding: 8px 27px;
        	border-radius: 3px;
        	background: #a7a7a7;
        	color: #fff;
        	font-weight: bold;
        	text-align: center;
        	cursor: pointer;
        }
        /* [Footer(저장, 닫기) End] */
		/* [주소검색 팝업 Start] */
		.search_pop {
			display: none;
			width: 100%;
			height: auto;
			background: #fff;
		}
		.search_pop .header {
			background: #e4e3e4;
			font-size: 16px;
			font-weight: bold;
			text-align: center;
			color: #076978;
			border-top: #33818e 2px solid;
			border-bottom: 1px #a1bec3 solid;
			padding: 10px 10px;
		}
		.search_pop .item {
			display: block;
			padding: 5px 10px;
			border: 1px solid #dddfe2;
			cursor: pointer;
		}
		.search_pop .search_name {
			display: inline-block;
			width: 100%;
			height: 20px;
			padding: 3px 0;
			font-size: 15px;
			font-weight: bold;
			box-sizing: border-box;
		}
		.search_pop .search_category {
			font-size: 12px;
			color: #8f8d8d;
			box-sizing: border-box;
		}
		.search_pop .search_address {
			display: inline-block;
			width: 100%;
			height: 20px;
			padding: 3px 0;
			font-size: 12px;
			box-sizing: border-box;
		}
		.search_pop .search_tel {
			display: inline-block;
			width: 100%;
			height: 20px;
			padding: 3px 0;
			color: #0558ef;
			font-size: 12px;
			font-weight: bold;
			box-sizing: border-box;
		}
		.search_pop .search_close {
			position: absolute;
			top: 8px;
			right: 15px;
			font-size: 21px;
		}
		.search_pop .search_close i {
			color: #076978;
		}
        /* [주소검색 팝업 End] */
        /* [카카오맵 트래커 마커 관련 Start] */
        .gmnoprint .gm-style-mtc {
        	display: none;
        }
        .node {
		    position: absolute;
		    background-image: url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/sign-info-64.png);
		    cursor: pointer;
		    width: 64px;
		    height: 64px;
		}
		.tooltip {
		    background-color: #fff;
		    position: absolute;
		    border: 2px solid #333;
		    font-size: 25px;
		    font-weight: bold;
		    padding: 3px 5px 0;
		    left: 65px;
		    top: 14px;
		    border-radius: 5px;
		    white-space: nowrap;
		    display: none;
		}
		.tracker {
		    position: absolute;
		    margin: -35px 0 0 -30px;
		    display: none;
		    cursor: pointer;
		    z-index: 3;
		}
		.icon {
		    position: absolute;
		    left: 6px;
		    top: 9px;
		    width: 48px;
		    height: 48px;
		    background-image: url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/sign-info-48.png);
		}
		.balloon {
		    position: absolute;
		    width: 60px;
		    height: 60px;
		    background-image: url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/balloon.png);
		    -ms-transform-origin: 50% 34px;
		    -webkit-transform-origin: 50% 34px;
		    transform-origin: 50% 34px;
		}
		/* [카카오맵 트래커 마커 관련 End] */
		div.hidden {
        	display: absolute;
        	top: -99999999px;
        	left: -9999999px;
        }
        .align_center {
        	text-align: center;
        }
        
        @media all and (max-width: 1024px) {
        	.msg_pop {
        		bottom: 210px;	
        	}
        	.map_wrap .map_desc .address {
        		font-size: 32px;
        	}
        	.map_wrap .map_desc .location {
        		font-size: 25px;
        	}
        	.map_desc .icon_copy {
        		height: 50px;
        	}
        	.map_desc .icon_copy i {
        		font-size: 48px;
        	}
        	.content #disp_address {
        		height: 50px;
        	}
        	.content #search {
        		height: 35px;
        	}
        }
        @media all and (max-width: 768px) {
        	.msg_pop {
        		bottom: 210px;	
        	}
        	.map_wrap .map_desc .address {
        		font-size: 20px;
        	}
        	.map_wrap .map_desc .location {
        		font-size: 18px;
        	}
        	.map_desc .icon_copy i {
        		font-size: 30px;
        	}
        }
        @media all and (max-width: 425px) {
        	.map_wrap .map_desc .address {
        		font-size: 13px;
        	}
        	.map_wrap .map_desc .location {
        		font-size: 12px;
        	}
        	.map_desc .icon_copy i {
        		font-size: 25px;
        	}
        	.content #disp_address {
        		height: 25px;
        	}
        	.content #search {
        		height: auto;
        	}
        }
		@media all and (max-width: 280px) {
        	.map_wrap .map_desc .address {
        		font-size: 13px;
        	}
        	.map_wrap .map_desc .location {
        		font-size: 12px;
        	}
        }
  	</style>
  	
</head>
<body>
	<div class="hidden">
		<input type="hidden" id="dvsCd" name="dvsCd" value="${dvsCd}">
	</div>
	<div class="wrap">
		<div id="search_pop" class="search_pop">
			<div class="header">
				찾기 결과
			</div>
			<div class="item">
				<span class="search_name">마천역 5호선  <span class="search_category">수도권 5호선</span></span>
				<span class="search_address">서울 송파구 마천로57길 지하 7</span>
				<span class="search_tel">02-6311-5601</span>
			</div>
			<div class="contents"></div>
		</div>
		<div id="msg_pop" class="msg_pop">
			<span class="msg">주소와 위치가 복사되었습니다.</span>
		</div>
		<div class="content">
			<div class="search_wrap">
			    <div class="search">
					<input id="disp_address" type="text" placeholder="주소를 입력하세요" onkeyup="checkAction()" value="${address}" />
			        <input id="address" type="hidden" value="${address}" />
			        <button id="search" type="button" value="Geocode" onclick="findAddress()">검색</button>
			    </div>
			</div>
			<div class="map_wrap">
				<div id="map" class="map"></div>
				<div class="map_desc"></div>
			</div>
			<div class="map_footer">
				<div class="btn_wrap">
					<span id="confirm" onclick="saveData()">저장</span>
					<span id="close" onclick="closeWindow()">닫기</span>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
