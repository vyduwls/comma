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
	var lastDay = new Date(year, month, 0).getDate();
    var scheduleArray=new Array();
	var ridColorList=new Array();

	
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
		$("#h2_selectMonth").text(year+"년"+month+"월 근무일정표");
		   	for (var day = lastDay; day >= 1; day--) {
 		    	$(".scheduleTable_time_th").after("<th class='scheduleTable_date_th' >"+day+"</th>");
 		    	if("${checkPosition}"=="1"){
		    		$(".scheduleTable_time_td").after("<td class='scheduleTable_date_td' id="+day+" style='cursor:pointer;'><input type='hidden' name='color' value='0'></td>");
 		    	}else{
 		    		$(".scheduleTable_time_td").after("<td class='scheduleTable_date_td' id="+day+"><input type='hidden' name='color' value='0'></td>");
 		    	}
		    	$(".scheduleTable_totalTime_td").after("<td class='scheduleTable_totalDate_td' ><span id="+day+">0</span></td>"); 

		   	}			
		var ridList="${allEmployeeRids}".split(",");
		var color=new Array();
		color[0]="rgb(23, 144, 214)";
		color[1]="rgb(255, 177, 0)";
		color[2]="rgba(127, 255, 85, 0.83)";
		color[3]="rgba(255, 99, 8, 0.67)";

 		for (var i = 0; i < ridList.length; i++) {
			ridColorList[i]=new Array();
			if(i<4){
				ridColorList[i][0]=ridList[i]
				ridColorList[i][1]=color[i];
			}else{
				ridColorList[i][0]=ridList[i]
				ridColorList[i][1]=color[i%4];
			}
		} 
		
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
    	
    	$('.scheduleTable_date_td').click(function(){
    		/*스케줄 날짜, 해당 직원의 총 근무시간, 총 근무일 잡아오기*/
      		var selectDay=$(this).attr("id");
      		var color=$(this).children("input[name=color]").val();
      		var employName=$(this).siblings(".scheduleTable_td").attr("id");
      		

			var editDay=selectDay;
	   	     /*데이터 넣기위한 날짜 변환*/
	   	     if(Number(editDay)<=9){
	   	    	editDay="0"+editDay;
		     }
      		var schedule=employName+"_"+year+"-"+month+"-"+editDay;
      		
      		if( (month>(nowDate.getMonth()+1)) ||( month==(nowDate.getMonth()+1) && selectDay>=nowDate.getDate())){
			/*근무 지정할 때, 데이터 변화시켜주기*/
      		if(color=="0"){
      			/*배열에 저장*/
	   	    	scheduleArray.push(schedule);
	 			for (var j = 0; j < ridColorList.length; j++) {
					if(employName==ridColorList[j][0]){
		      			$(this).css("background-color",ridColorList[j][1]);
					}
				}
      			$(this).children("input[name=color]").val("1");
           		totalScheduleCalcu(color,selectDay,employName);
      		}else{
      			/*배열에 스케줄 저장한 것 삭제*/
      			scheduleArray.splice($.inArray(schedule, scheduleArray),1);
      			$(this).css("background-color","");    
      			$(this).children("input[name=color]").val("0");
           		totalScheduleCalcu(color,selectDay,employName);
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
	   	    		 "allEmployeeRids":"${allEmployeeRids}",
	   	    		 "deleteDate":year+"-"+month
	   	    	 },
	   	    	 dateType:"text",
	   	    	 success : function(data){
	   	    		 alert("스케줄 저장 완료!");   
	   	    	 }
	   	    	 
	   	     });
	   	     
	   	     
    	});

    });
    	function totalScheduleCalcu(data,selectDay,mid){
    		
			var sumWork=Number($("#"+mid+"SumWork").text());
			var sumTime=Number($("#"+mid+"SumTime").text());
      		/* 전체 근무시간, 전체 근무일, 일별 근무하는 인원 잡아오기*/
      		var totalWork=Number($("#totalWork").text());
      		var totalTime=Number($("#totalTime").text());
      		var totalDate=Number($("span[id="+selectDay+"]").text());
      		
      		if(data=="0"){
       			$("#totalWork").text(totalWork+1);
       			$("#totalTime").text(totalTime+8);
       			$("span[id="+selectDay+"]").text(totalDate+1);
				$("#"+mid+"SumWork").text(sumWork+1);
				$("#"+mid+"SumTime").text((sumWork+1)*8);
				
      		}else if(data=="1"){
      			$("#totalWork").text(totalWork-1);
      			$("#totalTime").text(totalTime-8);
      			$("span[id="+selectDay+"]").text(totalDate-1);
				$("#"+mid+"SumWork").text(sumWork-1);
				$("#"+mid+"SumTime").text((sumWork-1)*8);
      		}
    	}
		
    	function inputSchedule(allScheduleString){
    		
			var allSchedules=allScheduleString.split(",");
			for (var i = 0; i < allSchedules.length; i++) {
				var mid=allSchedules[i].split("_")[0];
	 			var scheduledate=Number(allSchedules[i].split("_")[1].split("-")[2]);	
	 			scheduleArray.push(allSchedules[i]);
	 			for (var j = 0; j < ridColorList.length; j++) {
					if(mid==ridColorList[j][0]){
					   	$("#"+mid).siblings("#"+scheduledate).css("background-color",ridColorList[j][1]);						
					}
				}
				$("#"+mid).siblings("#"+scheduledate).children("input[name=color]").val("1");
				totalScheduleCalcu("0",scheduledate,mid);
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
		<h2 class="body_menu_ptag" ><a href="editTimeSchedule.do">시간별 스케줄 관리</a></h2>
	</c:if>
	<c:if test="${checkPosition!='1'}">
		<h2 class="body_menu_ptag"><a href="editTimeSchedule.do">시간별 스케줄 조회</a></h2>
	</c:if>


</div>
<div id="body_content" style="overflow-x:auto;">
	<div class="row">
		<div class="col-lg-4">
			<h2 id="h2_selectMonth" ></h2>
		</div>
		<div class="col-lg-6" style="margin-top: 40px;">
		<form action="editSchedule.do">
			<select name="selectYear" class="form-control selectYear" style="width:20%;float:left;">
				<c:forEach begin="${storeRegYear}" end="2017" var="n">
				<c:if test="${n==year}">
					<option value="${n}" selected="selected">${n}년</option>	
				</c:if>
				<c:if test="${n!=year}">
					<option value="${n}">${n}년</option>	
				</c:if>
				</c:forEach>	
			</select>
			<select name="selectMonth" class="form-control selectMonth" style="width:20%;float:left;" >				
				<c:forEach begin="1" end="12" var="n">
				<c:if test="${n==month}">
						<option value="${n}" selected="selected">${n}월</option>	
				</c:if>
				<c:if test="${n!=month}">
					<option value="${n}">${n}월</option>	
				</c:if>
				</c:forEach>	
			</select>
			<input type="text" class="form-control emName" name="emName" placeholder="직원 이름" style="width:20%;float:left;">
			<input type="hidden" name="sid" value="${storeInfo.sid}" >
			<button class="btn btn-default searchBtn" style="width:10%;float:left;">검색</button>
		</form>	
			<c:if test="${checkPosition=='1'}">
				<button class="btn btn-default saveBtn" style="float:left;margin-left:20px;">스케줄 저장</button>
			</c:if>
		</div>
			<div class="col-lg-2" style="margin-top:40px;">
			</div>
	</div>		

	<table id="detailSchedule">
 		<thead>	
			<tr class="scheduleTable_tr" >
				<th class="scheduleTable_th">직원명</th>
				<th class="scheduleTable_day_th" >근무일수</th>
				<th class="scheduleTable_time_th" >근무시간</th>
			</tr>
	 	</thead>
	 	<tbody>
			<c:forEach items="${memberList}" var="n" varStatus="m">
			<tr class="scheduleTable_tr" >
				<c:if test="${n.name==emName}">
				<td class="scheduleTable_td" id="${n.mid}" style="color:red"><input type="hidden" name="rid" value="${n.mid}"><span class="employName">${n.name}</span></td>
				</c:if>
				<c:if test="${n.name!=emName}">
				<td class="scheduleTable_td" id="${n.mid}" ><span class="employName">${n.name}</span></td>
				</c:if>
				<td class="scheduleTable_day_td"><span id="${n.mid}SumWork">0</span></td>
				<td class="scheduleTable_time_td"><span id="${n.mid}SumTime">0</span></td>
			</tr>
			</c:forEach>
			<tr class="scheduleTable_tr">
				<td class="scheduleTable_td">합계</td>
				<td class="scheduleTable_totalDay_td"><span id="totalWork">0</span></td>
				<td class="scheduleTable_totalTime_td"><span id="totalTime">0</span></td>
			</tr>
	 	</tbody> 
	</table>
</div>
