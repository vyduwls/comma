<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script type="text/javascript" src="${pageContext.request.contextPath}/js/moment.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/fullcalendar.js" charset="UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/locale-all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gcal.js"></script>
<script type="text/javascript">

    jQuery(document).ready(function() {
        jQuery("#miniCalendar").fullCalendar({
              defaultDate : Date()
            , locale : "ko"
            , editable : false
            , eventLimit : false
            , googleCalendarApiKey : "AIzaSyDcnW6WejpTOCffshGDDb4neIrXVUA1EAE"      // Google API KEY
            , eventSources : [
                    // 대한민국의 공휴일
                    {
                          googleCalendarId : "ko.south_korea#holiday@group.v.calendar.google.com"
                        , className : "koHolidays"
                        , color : "red"
                        , textColor : "#FFFFFF" 
                    }
              ]
        });
        

    	$('#miniCalendar').on('click','.fc-day-top',function(){
    	     var date=$(this).attr('data-date');
			 alert(date);
    	}); 
        
    });
</script>

    
<div id="body_menu">
	<select class="select_Store" name="storeName">
		<option value="스타벅스" selected="selected">스타벅스</option>
		<option value="롯데리아">롯데리아</option>
		<option value="맥도날드">맥도날드</option>	
	</select>
	<button class="btn btn-default changeStorebtn">변경</button>
	<div id="miniCalendar" style="margin:40px 10px 40px 10px;"></div>
	<h2 class="body_menu_ptag">공지사항</h2>
	<h2 class="body_menu_ptag">출퇴근 확인</h2>
	<h2 class="body_menu_ptag">담당업무 설정</h2>
	<h2 class="body_menu_ptag">근무지 정보</h2>
</div>
<div id="body_content">
	<table  id="detailSchedule"></table>
</div>
