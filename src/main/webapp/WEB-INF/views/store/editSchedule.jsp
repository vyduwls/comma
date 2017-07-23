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
    	$(".scheduleTable_time_th").after("<th class='scheduleTable_date_th' >"+day+"<th>");
    	$(".scheduleTable_time_td").after("<td class='scheduleTable_date_td' ><input type='hidden' name='day' value="+day+"><input type='hidden' name='color' value='0'><td>");
    	$(".scheduleTable_totalTime_td").after("<td class='scheduleTable_totalDate_td' ><span id="+day+">0</span><td>");
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
    	
    	$('.scheduleTable_date_td').click(function(){
    		
    		/*스케줄 날짜, 해당 직원의 총 근무시간, 총 근무일 잡아오기*/
      		var selectDay=$(this).children("input[name=day]").val();
      		var color=$(this).children("input[name=color]").val();
      		var sumWork=Number($(this).siblings(".scheduleTable_day_td").children(".sumWork").text());
      		var sumTime=Number($(this).siblings(".scheduleTable_time_td").children(".sumTime").text());
      	
      		/* 전체 근무시간, 전체 근무일, 일별 근무하는 인원 잡아오기*/
      		var totalWork=Number($("#totalWork").text());
      		var totalTime=Number($("#totalTime").text());
      		var totalDate=Number($("span[id="+selectDay+"]").text());
			
      		
      		if( (month>(nowDate.getMonth()+1)) ||( month==(nowDate.getMonth()+1) && selectDay>=nowDate.getDate())){
			/*근무 지정할 때, 데이터 변화시켜주기*/
      		if(color=="0"){
      			$(this).css("background-color","red");
      			$(this).children("input[name=color]").val("1");
       			$(this).siblings(".scheduleTable_day_td").children(".sumWork").text(sumWork+1);
       			$("#totalWork").text(totalWork+1);
       			$("#totalTime").text(totalTime+8);
       			$("span[id="+selectDay+"]").text(totalDate+1);

      		}else{
      			$(this).css("background-color","");    
      			$(this).children("input[name=color]").val("0");
      			$(this).siblings(".scheduleTable_day_td").children(".sumWork").text(sumWork-1);
      			$("#totalWork").text(totalWork-1);
      			$("#totalTime").text(totalTime-8);
      			$("span[id="+selectDay+"]").text(totalDate-1);
      		}
	   	     $(this).siblings(".scheduleTable_time_td").children(".sumTime").text((sumWork+1)*8);
      		}else{
      			alert("지난 날짜는 변경이 불가합니다.");
      		}
      		
	   	     /*데이터 넣기위한 날짜 변환*/
	   	     if(Number(selectDay)<=9){
	   	    	selectDay="0"+selectDay;
		     }
	   	     var selectDate=year+"-"+month+"-"+date;
    	});
			$("#h2_selectMonth").text(year+"년"+month+"월 근무일정표");
    });

</script>

    
<div id="body_menu" >
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
<div id="body_content" style="overflow-x:auto;">
	<h2 id="h2_selectMonth"></h2>
	<table id="detailSchedule">
 		<thead>	
			<tr class="scheduleTable_tr" >
				<th class="scheduleTable_th">직원명</th>
				<th class="scheduleTable_day_th" >근무일수</th>
				<th class="scheduleTable_time_th" >근무시간</th>
			</tr>
	 	</thead>
	 	<tbody>
			<tr class="scheduleTable_tr" >
				<td class="scheduleTable_td">11</td>
				<td class="scheduleTable_day_td"><span class="sumWork">0</span></td>
				<td class="scheduleTable_time_td"><span class="sumTime">0</span></td>
			</tr>
			<tr class="scheduleTable_tr">
				<td class="scheduleTable_td">11</td>
				<td class="scheduleTable_day_td"><span class="sumWork">0</span></td>
				<td class="scheduleTable_time_td"><span class="sumTime">0</span></td>
			</tr>
			<tr class="scheduleTable_tr">
				<td class="scheduleTable_td">합계</td>
				<td class="scheduleTable_totalDay_td"><span id="totalWork">0</span></td>
				<td class="scheduleTable_totalTime_td"><span id="totalTime">0</span></td>
			</tr>
	 	</tbody> 
	</table>
</div>
