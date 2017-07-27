<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javascript" src="${pageContext.request.contextPath}/js/moment.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/fullcalendar.js" charset="UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/locale-all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gcal.js"></script>

<script type="text/javascript">


	/*현재날짜 구하기*/
 	var nowDate = new Date();
	var year="${year}";
	var month="${month}";
	var day="${day}";
	var lastDay = new Date(year, month, 0).getDate();
    var scheduleArray=new Array();

 	function today(){
	    if (("" + month).length == 1) { month = "0" + month; }
// 	    if (("" + day).length   == 1) { day   = "0" + day;   }
	}
	
	/*마지막 날짜 구하기*/
 	function getLastDay(year, month) {
 	    var date = new Date(year, month, 0);
 	    return date.getDate();
 	 }
	
    jQuery(document).ready(function() {

    	
    	today();
		$("#h2_selectMonth").text(year+"년"+month+"월"+day+"일 근무시간표");
		

		var allScheduleString="${allScheduleString}";
		if(allScheduleString!="" && allScheduleString!=null){
			inputSchedule(allScheduleString);
		}
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
    	     var selectYear=date.split("-")[0];
			 var selectMonth=date.split("-")[1];		
			 var selectDay=date.split("-")[2];
		    $("input[name=selectYear]").val(selectYear);
		    $("input[name=selectMonth]").val(selectMonth);
		    $("input[name=selectDay]").val(selectDay);
		    $("#miniCal").submit();
    	}); 
    	
    	$('.timeTable_date_td').click(function(){
    		/*스케줄 날짜, 해당 직원의 총 근무시간, 총 근무일 잡아오기*/
      		var selectTime=$(this).attr("id");
      		var color=$(this).children("input[name=color]").val();
      		var employName=$(this).siblings(".timeTable_td").attr("id");
      		var hour=selectTime.split(":")[0];
      		var minutes=selectTime.split(":")[1];
      		
       		totalScheduleCalcu(color,selectTime,employName);
	   	     /*데이터 넣기위한 날짜 변환*/
	   	     if(Number(selectTime)<=9){
	   	    	selectTime="0"+selectTime;
		     }
      		var schedule=employName+"-"+year+"-"+month+"-"+day+" "+selectTime;

      		if( (month>(nowDate.getMonth()+1)) ||( month==(nowDate.getMonth()+1) && day>=nowDate.getDate())){
			/*근무 지정할 때, 데이터 변화시켜주기*/
      		if(color=="0"){
      			/*배열에 저장*/
	   	    	scheduleArray.push(schedule);
      			$(this).css("background-color","red");
      			$(this).children("input[name=color]").val("1");
      		}else{
      			/*배열에 스케줄 저장한 것 삭제*/
      			scheduleArray.splice($.inArray(schedule, scheduleArray),1);
      			$(this).css("background-color","");    
      			$(this).children("input[name=color]").val("0");
      		}

      		}else{
      			alert("지난 날짜는 변경이 불가합니다.");
      		}

    	});
    	
    	$(".saveBtn").click(function(){
	   	     /*ajax로 스케줄 저장시 스케줄배열 String 변환*/
	   	     var stringSchedule="";
	   	     for(var i=0;i<scheduleArray.length;i++){
	    		if(i==scheduleArray.length-1){
	    			stringSchedule+=scheduleArray[i];
	    		}else{
	    			stringSchedule+=scheduleArray[i]+",";
	    		}
	   	    }
	   	     $.ajax({
	   	    	 url:"saveSchedule.do",
	   	    	 type:"GET",
	   	    	 data:{
	   	    		 "stringSchedule":stringSchedule,
	   	    		 "memberRidArray":"${memberRidArray}",
	   	    		 "deleteDate":year+"-"+month
	   	    	 },
	   	    	 dateType:"text",
	   	    	 success : function(data){
	   	    		 if($.trim(data)!="0"){
	   	    			 alert("스케줄 저장 완료!");
	   	    		 }else{
	   	    			 alert("스케줄 저장 실패하셨습니다.");
	   	    		 }
	   	    	 }
	   	    	 
	   	     });
	   	     
	   	     
    	});

    });
    	function totalScheduleCalcu(data,scheduleTime,mid){

// 			var sumTime=Number($("#"+mid+"SumTime").text());
//       		/* 전체 근무시간, 전체 근무일, 일별 근무하는 인원 잡아오기*/
//       		var totalTime=Number($("#totalTime").text());
//       		var totalDate=Number($("span[id="+scheduleTime+"]").text());
      		
//       		if(data=="0"){
//        			$("#totalTime").text(totalTime+8);
//        			$("span[id="+scheduleTime+"]").text(totalDate+1);
// 				$("#"+mid+"SumTime").text((sumWork+1)*8);
				
//       		}else if(data=="1"){
//       			$("#totalTime").text(totalTime-8);
//       			$("span[id="+scheduleTime+"]").text(totalDate-1);
// 				$("#"+mid+"SumTime").text((sumWork-1)*8);
//       		}
    	}
		
    	function inputSchedule(allScheduleString){
    		
			var allSchedules=allScheduleString.split(",");
			for (var i = 0; i < allSchedules.length; i++) {
				var mid=allSchedules[i].split("-")[0];
	 			var scheduleTime=allSchedules[i].split("-")[1];
	 			var time=year+"-"+month+"-"+day+" "+scheduleTime;
	 			scheduleArray.push(scheduleTime);
			   	$("#"+mid).siblings("#"+scheduleTime).css("background-color","red");
				$("#"+mid).siblings("#"+scheduleTime).children("input[name=color]").val("1");
				totalScheduleCalcu("0",scheduleTime,mid);
			}
    	}

    	
</script>

    
<div id="body_menu" >
	<form action="editSchedule.do" method="get">
	<select class="select_Store form-control" name="sid">
		<c:if test="${checkPosition==1}">
			<c:forEach items="${storeList}" var="n">
				<c:if test="${n.sid==storeInfo.sid}">
					<option value="${n.sid}" selected="selected">${n.name}</option>
				</c:if>
				<c:if test="${n.sid!=storeInfo.sid}">
					<option value="${n.sid}">${n.name}</option>
				</c:if>
			</c:forEach>
		</c:if>
		<c:if test="${checkPosition==2}">
			<option value="${storeInfo.sid}" selected="selected">${storeInfo.name}</option>
		</c:if>
	</select>
	<button type="submit" class="btn btn-default changeStorebtn">변경</button>
	</form>
	
	<form action="editTimeSchedule.do" method="get" id="miniCal">
		<div id="miniCalendar" style="margin:40px 10px 40px 10px;"></div>
		<input type="hidden" name="selectMonth">
		<input type="hidden" name="selectYear">
		<input type="hidden" name="selectDay">
	</form>
	<c:if test="${checkPosition=='1'}">
		<h2 class="body_menu_ptag" ><a href="editSchedule.do">일별 스케줄 관리</a></h2>
	</c:if>
	<c:if test="${checkPosition!='1'}">
		<h2 class="body_menu_ptag"><a href="editSchedule.do">일별 스케줄 조회</a></h2>
	</c:if>


</div>
<div id="body_content" style="overflow-x:auto;">
	<div class="row">
		<div class="col-lg-4">
			<h2 id="h2_selectMonth" ></h2>
		</div>
		<div class="col-lg-6" style="margin-top: 40px;">
		<form action="editTimeSchedule.do">
			<select name="selectYear" class="form-control selectYear" style="width:15%;float:left;">
				<c:forEach begin="${storeRegYear}" end="2017" var="n">
				<c:if test="${n==year}">
					<option value="${n}" selected="selected">${n}년</option>	
				</c:if>
				<c:if test="${n!=year}">
					<option value="${n}">${n}년</option>	
				</c:if>
				</c:forEach>	
			</select>
			<select name="selectMonth" class="form-control selectMonth" style="width:15%;float:left;" >				
				<c:forEach begin="1" end="12" var="n">
				<c:if test="${n==month}">
					<option value="${n}" selected="selected">${n}월</option>	
				</c:if>
				<c:if test="${n!=month}">
					<option value="${n}">${n}월</option>	
				</c:if>
				</c:forEach>	
			</select>
			<select name="selectDay" class="form-control selectMonth" style="width:15%;float:left;" >				
				<c:forEach begin="1" end="31" var="n">
				<c:if test="${n==day}">
					<option value="${n}" selected="selected">${n}일</option>	
				</c:if>
				<c:if test="${n!=day}">
					<option value="${n}">${n}일</option>	
				</c:if>
				</c:forEach>	
			</select>
			<input type="text" class="form-control emName" name="emName" placeholder="직원 이름" style="width:15%;float:left;">
			<input type="hidden" name="sid" value="${storeInfo.sid}" >
			<button class="btn btn-default searchBtn" style="width:10%;float:left;">검색</button>
		</form>	
		</div>
			<div class="col-lg-2" style="margin-top:40px;">
				<c:if test="${checkPosition=='1'}">
					<button class="btn btn-default saveBtn" style="float:left;margin-left:20px;">스케줄 저장</button>
				</c:if>
			</div>
	</div>		

	<table id="detailTimeSchedule">
 		<thead>	
			<tr class="timeTable_tr" >
				<th class="timeTable_th">직원명</th>
				<th class="timeTable_time_th1" >근무시간</th>
				<th class="timeTable_time_th" >총시간</th>
				<c:forEach begin="0" end="23" var="time" >
					<th  class='timeTable_date_th' id="${time}" >${time}</th>
				</c:forEach>
			</tr>
	 	</thead>
	 	<tbody>
			<c:forEach items="${memberList}" var="n" varStatus="m">
			<tr class="timeTable_tr" >
				<c:if test="${n.name==emName}">
				<td class="timeTable_td" id="${n.mid}" style="color:red"><input type="hidden" name="rid" value="${n.mid}"><span class="employName">${n.name}</span></td>
				</c:if>
				<c:if test="${n.name!=emName}">
				<td class="timeTable_td" id="${n.mid}" ><span class="employName">${n.name}</span></td>
				</c:if>
				<td class="timeTable_time_td1">
					<select name="startHour" class="form-control timeSelect" >
						<c:forEach begin="0" end="23" var="n">
						<option value="${n}">${n}시</option>
						</c:forEach>
					</select>
					<select name="startMinute" class="form-control timeSelect" >
						<c:forEach begin="1" end="4" var="n">
						<option value="${n*15}">${n*15}분</option>
						</c:forEach>
					</select>
					<span style="float: left;">~</span>
					<select name="endHour" class="form-control timeSelect" >
						<c:forEach begin="0" end="23" var="n">
						<option value="${n}">${n}시</option>
						</c:forEach>
					</select>
					<select name="endMinute" class="form-control timeSelect" >
						<c:forEach begin="1" end="4" var="n">
						<option value="${n*15}">${n*15}분</option>
						</c:forEach>
					</select>
				</td>
				<td class="timeTable_time_td"><span id="${n.mid}SumTime">0</span></td>
				<c:forEach begin="0" end="23" var="time" >
					<td  class='timeTable_date_td' id="${time}" style="cursor: pointer;"><input type='hidden' name='color' value='0'></td>
				</c:forEach>
			</tr>
			</c:forEach>
			<tr class="timeTable_tr">
				<td class="timeTable_td" colspan="2">합계</td>
				<td class="timeTable_totalTime_td"><span id="totalTime">0</span></td>
				<c:forEach begin="0" end="23" var="time" >
					<td  class='timeTable_totalDate_td' ><span id="total${time}">0</span></td>
				</c:forEach>
			</tr>
	 	</tbody> 
	</table>
</div>
