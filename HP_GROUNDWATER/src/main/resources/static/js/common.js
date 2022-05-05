// select ul li
$(function() {
	//토글 ul
	$(".drop-down > .selected a").click(function() {
	    //$(".drop-down .options ul").toggle();
	    var $options = $(this).parent().siblings('.options');
	    $options.find('> ul').toggle();
	});

	//옵션 선택 및 선택 후 옵션 숨기기
	$(".drop-down .options ul li a").click(function() {
	    var text = $(this).html();
	    var $selected = $(this).closest('.options').siblings('.selected');
	    $selected.find('> a').html(text);
	    $(this).closest('ul').hide();
	});

	//페이지의 다른 위치를 클릭하면 옵션 숨기기
	$(document).bind('click', function(e) {
	    var $clicked = $(e.target);
	    if (!$clicked.parents().hasClass("drop-down")){
	            $(".drop-down .options ul").hide();
	        }
	});
});


/* 햄버거메뉴 */
$(function(){
	const menuTrigger = document.querySelector('.header_menu');
    if (menuTrigger) {
        menuTrigger.addEventListener('click', (event) => {
            event.currentTarget.classList.toggle('active-1');
          });
    }
});

/*  sidemenu */
/*
$(function(){
	 // $(".popup_wrap").hide();
			$('.header_menu').click(function(){
				$(".popup_wrap").toggle();
			});
});
*/

/* textarea auto height */
$(document).ready(function() {
	$("table").on("keyup", "textarea", function(e) {
		$(this).css("height", "auto");
		$(this).height(this.scrollHeight);
	});
	$("table").find("textarea").keyup();
});

//$('#divDate').datetimepicker({
//format: "YYYY-MM-DD", ignoreReadonly: true });

$(function() {
        var datePicker = $("#datepicker");
		var now = new Date();	// 현재 날짜 및 시간
		var year = now.getFullYear();	// 연도
		var startYear = "2017";
		var endYear = year;
		var yearRange = startYear + ":" + year;

        if (datePicker.length > 0) {
            //input을 datepicker로 선언
            $("#datepicker").datepicker({
                dateFormat: 'yy-mm-dd' //Input Display Format 변경
                ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
                ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
                ,changeYear: true //콤보박스에서 년 선택 가능
                ,changeMonth: true //콤보박스에서 월 선택 가능
                ,buttonText: "선택" //버튼에 마우스 갖다 댔을 때 표시되는 텍스트
                ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
                ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
                ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
                ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
                ,yearRange: yearRange
                ,weekHeader: 'Wk'
                ,dateFormat: 'yy-mm-dd'
                ,firstDay: 0
                ,isRTL: false
                ,showMonthAfterYear: true
                ,showOtherMonths: true
                ,selectOtherMonths:true
                ,yearSuffix: ''
                ,changeMonth: true
                ,changeYear: true
                ,showButtonPanel: true
            });
        }

		//초기값을 오늘 날짜로 설정
		//$('#datepicker').datepicker('setDate', new Date()); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)
});
