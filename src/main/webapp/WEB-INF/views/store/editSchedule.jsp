<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script type="text/javascript" src="${pageContext.request.contextPath}/js/moment.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/fullcalendar.js" charset="UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/locale-all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gcal.js"></script>

<script type="text/javascript">


	/*현재날짜 구하기*/
	var nowDate = new Date();
	var year  = nowDate.getFullYear();
	var month = nowDate.getMonth() + 1; // 0부터 시작하므로 1더함 더함
	var day   = nowDate.getDate();
	var lastDay = new Date(year, month, 0).getDate();
	
 	function today(){
	    if (("" + month).length == 1) { month = "0" + month; }
	    if (("" + day).length   == 1) { day   = "0" + day;   }
	}
	
	/*마지막 날짜 구하기*/
 	function getLastDay(year, month) {
 	    var date = new Date(year, month, 0);
 	    return date.getDate();
 	 }
	
    jQuery(document).ready(function() {
	
	    today();
	   	for (var day = lastDay; day >= 1; day--) {	
    	$(".ScheduleTableTime_th").after("<th class='.ScheduleTable_date_th' style='text-align: center; width:auto;border:1px solid #a8b0ad;'>"+day+"<th>");
    	$(".ScheduleTableTime_td").after("<td class='ScheduleTable_date_td' style='text-align: center;border:1px solid #a8b0ad;'><td>");
	   	}
	   	
   		/*달의 마지막날 구하기*/
//     	var lastDay = (new Date(년도입력,월입력,0)).getDate();
    	
		/*미니달력 설정*/
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
	<table id="detailSchedule" style="border: 1px solid #a8b0ad;">
<!-- 		<thead>	
			<tr class="ScheduleTable_tr">
				<th class="ScheduleTable_th" style="text-align: center;width:5%;border: 1px solid #a8b0ad;">직원명</th>
				<th class="ScheduleTable_th" style="text-align: center;width:5%;border: 1px solid #a8b0ad;">근무일수</th>
				<th class="ScheduleTableTime_th" style="text-align: center;width:5%;border: 1px solid #a8b0ad;">근무시간</th>
			</tr>
	 	</thead>
	 	<tbody>
			<tr class="ScheduleTable_tr" >
				<td class="ScheduleTable_td" style="border: 1px solid #a8b0ad;">11</td>
				<td class="ScheduleTable_td" style="border: 1px solid #a8b0ad;"> 11</td>
				<td class="ScheduleTableTime_td" style="border: 1px solid #a8b0ad;">11</td>
			</tr>
			<tr class="ScheduleTable_tr">
				<td class="ScheduleTable_td" style="border: 1px solid #a8b0ad;">11</td>
				<td class="ScheduleTable_td" style="border: 1px solid #a8b0ad;">11</td>
				<td class="ScheduleTableTime_td" style="border: 1px solid #a8b0ad;">11</td>
			</tr>
	 	</tbody> -->
	 	<thead>	
			<tr class="ScheduleTable_tr">
				<th>직원명</th>
				<th>근무일수</th>
				<th class="ScheduleTableTime_th">근무시간</th>
			</tr>
	 	</thead>
	 	<tbody>
			<tr class="ScheduleTable_tr" >
				<td>11</td>
				<td> 11</td>
				<td class="ScheduleTableTime_td" >11</td>
			</tr>
			<tr class="ScheduleTable_tr">
				<td>11</td>
				<td>11</td>
				<td class="ScheduleTableTime_td" >11</td>
			</tr>
	 	</tbody>
	</table>
</div>
