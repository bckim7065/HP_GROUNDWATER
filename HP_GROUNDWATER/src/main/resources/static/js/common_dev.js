// select ul li
$( document ).ready(function() {
	addClickEventToRadioList();
	addClickEventToCheckBoxList();
	
	// 사진미리보기
	$.fn.setPreview = function(opt) {
		"use strict";
		var defaultOpt = {
			inputFile: $(this),
			img: null,
			w: 'auto',
			h: 'auto'
		};
		$.extend(defaultOpt, opt);

		var previewImage = function () {
			if (!defaultOpt.inputFile || !defaultOpt.img) {
		          return;
			}

        	var inputFile = defaultOpt.inputFile.get(0);
        	var img = defaultOpt.img.get(0);

			// FileReader
	        if (window.FileReader) {
				if (inputFile.files.length == 0) {
					return;
				}
		        
				if (!inputFile.files[0].type.match(/image\//)) {
					return;
				}

				// preview
				try {
					var reader = new FileReader();
					reader.onload = function (e) {
						img.src = e.target.result;
						img.style.width = defaultOpt.w + 'px';
						if (defaultOpt.h != 'auto') {
							img.style.height = defaultOpt.h + 'px';
						} else {
			                img.style.height = 'auto';
						}
						img.style.display = '';
					}
					reader.readAsDataURL(inputFile.files[0]);
				} catch (e) {
					console.log(e);
				}
	        } else if (img.filters) { // img.filters (MSIE)
				inputFile.select();
				inputFile.blur();
				var imgSrc = document.selection.createRange().text;
	
				img.style.width = defaultOpt.w + 'px';
				if (defaultOpt.h != 'auto') {
		            img.style.height = defaultOpt.h + 'px';
				} else {
		            img.style.height = 'auto';
				}
				img.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enable='true',sizingMethod='scale',src=\"" + imgSrc + "\")";
				img.style.display = '';
	        } else {
	          // Safari5, ...
	        }
		};

		// onchange
		$(this).change(function () {
			previewImage();
		});
	}
});

function addClickEventToRadioList() {
	$(".wall_radio_list").on("click", function(event){
		var element = $(event.target); 
		if (element.hasClass("on")) {
			element.removeClass("on").siblings().removeClass("on");
			return;
		}
		
		element.addClass("on").siblings().removeClass("on");
	});
}

function addClickEventToCheckBoxList() {
	$(".wall_checkbox_list").on("click", function(event){
		var element = $(event.target); 
		element.toggleClass("on");
	});
}

function changeMenu(controller) {
	let parmas = {
		"pjt_no": PJT_NO, 
		"site_no": SITE_NO
	}
	
	let url  = getContextPath() + "/" + controller + "?" + $.param(parmas);
	location.href = url;
}

function moveHome() {
	let controller = getContextPath() + "/mobile/main";
	
	let url  = controller;
	location.href = url;
}

function moveLogin() {
	let controller = getContextPath() + "/mobile/";
	
	let url  = controller;
	location.href = url;
}

function getContextPath() {
	let contextPath = "";
	let scripts = document.getElementsByTagName("script");
	
	for (var i = 0; i < scripts.length; i++) {
		let src = scripts[i].getAttribute("src");
		if (src != null && src.indexOf("/js/common.js") >= 0 && src.indexOf("?") >= 0) {
			if (src.split("?")[1] != null && src.split("?")[1] != "") {
				let params = src.split("?")[1].split("&");
				
				for (var j = 0; j < params.length; j++) {
					if (params[j].indexOf("=") >= 0) {
						if (params[j].split("=")[0] == "contextPath") {
							contextPath = params[j].split("=")[1];
						}
					}	
				}
			}			
		}	
	} 	
	
	return contextPath;
}
