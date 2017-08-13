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
    var endScheduleArray=new Array();
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
	
    $(document).ready(function() {
    	today();
		$("#h2_selectMonth").text(year+"년"+month+"월 근무일정표");
		   	for (var day = lastDay; day >= 1; day--) {
 		    	$(".scheduleTable_time_th").after("<th class='scheduleTable_date_th' data-toggle='modal' data-target='#myModal1' id='th"+day+"' style='cursor:pointer;'>"+day+"</th>");
 		    	if("${checkPosition}"=="1"){
		    		$(".scheduleTable_time_td").after("<td class='scheduleTable_date_td' id="+day+" style='cursor:pointer;' data-toggle='modal' data-target='#myModal'><input type='hidden' name='color' value='0'></td>");
 		    	}else{
 		    		$(".scheduleTable_time_td").after("<td class='scheduleTable_date_td' id="+day+" style='cursor:pointer;' data-toggle='modal' data-target='#myModal'><input type='hidden' name='color' value='0'></td>");
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
		var allEndScheduleString="${allEndScheduleString}";
		if((allScheduleString!="" && allScheduleString!=null)&&(allEndScheduleString!="" && allEndScheduleString!=null)){
			inputSchedule(allScheduleString,allEndScheduleString);
		}
		/*미니달력 설정*/
        jQuery("#miniCalendar").fullCalendar({
              defaultDate : Date()
            , locale : "ko"
//             , height : 490
            , editable : false
            , eventLimit : true
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
        	, events: function(start, end,timezone, callback) {
	    		$.ajax({
	    		    url: 'fullSchedule.do',
	    		    data: {
	                    // our hypothetical feed requires UNIX timestamps
	                    start: start.unix(),
	                    end: end.unix(),
	                    sid: "${storeInfo.sid}"
	                },
	    		    dataType: 'json',
	    		    error:function(request,status,error){
	    		        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	   		        },
	   		        success:function(doc) {
	   	                var events = [];
	   	                $(doc).each(function() {
	   	                    events.push({
	   	                        title: $(this).attr('title'),
	   	                        start: $(this).attr('start') // will be parsed
	   	                    });
	   	                });
	   	                callback(events);
	   	            }
	    		});
      		  }   								     
	        , eventClick:function(event) {
	                alert(event.title);
	                return false;     
	        }
        });
        
// 		$(".fc-content").css("cursor","pointer");

    	
    	 $('.scheduleTable_date_td').click(function(){
    		
    	
    		/*스케줄 날짜, 해당 직원의 총 근무시간, 총 근무일 잡아오기*/
      		var selectDay=$(this).attr("id");
      		var color=$(this).children("input[name=color]").val();
      		var employRid=$(this).siblings(".scheduleTable_td").attr("id");
      		var employName=$(this).siblings(".scheduleTable_td").children("span").text();
      		var editDay=selectDay;
      		if(Number(selectDay)<=9){
      			editDay="0"+selectDay;
      		}
      		//모달에 내용 hidden으로 전달
			$(".modal-title").text(employName+"의 "+year+"년 "+month+"월 "+editDay+"일 근무시간표");
			$("input[name=modal_rid]").val(employRid);
			$("input[name=modal_day]").val(selectDay);
			$("input[name=modal_color]").val(color);

			/*선택한 근무자의 근무시간 select 해주기*/
			var allSchedules=allScheduleString.split(",");
			var allEndSchedules=allEndScheduleString.split(",");
			var checkOption="0";
			for (var i = 0; i < scheduleArray.length; i++) {
				if((employRid==scheduleArray[i].split("_")[0]) &&(selectDay==Number(scheduleArray[i].split("_")[1].split("-")[2].split(" ")[0]))){
					$("#startHour").val(parseInt(scheduleArray[i].split(" ")[1].split(":")[0])).attr("selected", "selected");
					$("#startMinute").val(parseInt(scheduleArray[i].split(" ")[1].split(":")[1])).attr("selected", "selected");
					appendEndHour($("#startHour").val());
					$("#endHour").val(parseInt(endScheduleArray[i].split(" ")[1].split(":")[0])).attr("selected", "selected");
					$("#endMinute").val(parseInt(endScheduleArray[i].split(" ")[1].split(":")[1])).attr("selected", "selected");
					if(scheduleArray[i].split("_")[1].split("-")[2].split(" ")[0]!=endScheduleArray[i].split("_")[1].split("-")[2].split(" ")[0]){
						$("input[name=checkAfterDay]").prop("checked",true);
					}
					checkOption="1";
				}else if(checkOption=="0"){
					$("#startHour").val("0").attr("selected", "selected");
					$("#startMinute").val("0").attr("selected", "selected");
					appendEndHour(0);
					$("input[name=checkAfterDay]").prop("checked",false);
					$("#endHour").val("0").attr("selected", "selected");
					$("#endMinute").val("0").attr("selected", "selected");
					
				}
				
			}
			
     	}); 
    	
    	
    		$(".scheduleTable_date_th").click(function(){
    		var selectDay=$(this).attr("id").split("th")[1];

			$(".modal-title1").text(year+"년"+month+"월"+selectDay+"일 근무시간표");
    		
    		/*시간별 스케줄 일배열에 넣기*/
    		var dayScheduleArray=new Array();
    		for (var i = 0; i < scheduleArray.length; i++) {
				if((Number(scheduleArray[i].split("_")[1].split("-")[2].split(" ")[0])==selectDay) &&(Number(endScheduleArray[i].split("_")[1].split("-")[2].split(" ")[0])==selectDay)){ 
					var schedule=scheduleArray[i].split("_")[0]+"_"+scheduleArray[i].split(" ")[1]+"_"+endScheduleArray[i].split(" ")[1];
					dayScheduleArray.push(schedule);
				}else if((Number(scheduleArray[i].split("_")[1].split("-")[2].split(" ")[0])!=selectDay) &&(Number(endScheduleArray[i].split("_")[1].split("-")[2].split(" ")[0])==selectDay)){
					var schedule=scheduleArray[i].split("_")[0]+"_00:00_"+endScheduleArray[i].split(" ")[1];
					dayScheduleArray.push(schedule);
				}else if((Number(scheduleArray[i].split("_")[1].split("-")[2].split(" ")[0])==selectDay) &&(Number(endScheduleArray[i].split("_")[1].split("-")[2].split(" ")[0])!=selectDay)){
					var schedule=scheduleArray[i].split("_")[0]+"_"+scheduleArray[i].split(" ")[1]+"_24:00";
					dayScheduleArray.push(schedule);
				}
			}

    		
    	    var totalMinute=0;
    		var stringHtml="";
    		var timeTotalWorker=new Array();
    		for (var i = 0; i < 24; i++) {
    			timeTotalWorker[i]=0;
			}
    		
    		for (var i = 0; i < dayScheduleArray.length; i++) {
    			var sumMinute=0;
    			for (var j = 0; j < dayScheduleArray.length; j++) {
    				if(dayScheduleArray[j].split("_")[0]==dayScheduleArray[i].split("_")[0]){
	    				sumMinute+=calcuTime(dayScheduleArray[j].split("_")[2])-calcuTime(dayScheduleArray[j].split("_")[1]);

	    			}
    				if(dayScheduleArray[j].split("_")[0]==dayScheduleArray[i].split("_")[0] && dayScheduleArray[j].split("_")[1]!=dayScheduleArray[i].split("_")[1]){
    					dayScheduleArray[i]=dayScheduleArray[i]+"_"+dayScheduleArray[j].split("_")[1]+"_"+dayScheduleArray[j].split("_")[2];
    					dayScheduleArray.splice($.inArray(dayScheduleArray[j], dayScheduleArray),1);
    				}
					
				}
    			totalMinute+=sumMinute;
        		var memberNames="${memberName}";
        		var memberName=memberNames.split(",");
        		for (var j = 0; j < memberName.length; j++) {
    				if(memberName[j].split("_")[0]==dayScheduleArray[i].split("_")[0]){
    		    		stringHtml+="<tr class='timeTable_tr'><td class='timeTable_td'>"+memberName[j].split("_")[1]+"</td>"
    		    		+"<td class='timeTable_time_td'>"+Math.floor(sumMinute/60)+":"+(sumMinute%60)+"</td>";
    						
    				}
    			}
    			 for (var j = 0; j < 24; j++) {
    				if(dayScheduleArray[i].split("_")[3]==null ||dayScheduleArray[i].split("_")[3]==""){
						if(j>=Number(dayScheduleArray[i].split("_")[1].split(":")[0]) && j<=Number(dayScheduleArray[i].split("_")[2].split(":")[0])){
							timeTotalWorker[j]+=1;
							if(j==Number(dayScheduleArray[i].split("_")[1].split(":")[0]) ){
								stringHtml+="<td class='timeTable_date_td' style='background-color:"+ridColorList[i][1]+";'>"+dayScheduleArray[i].split("_")[1].split(":")[1]+" 분</td>";			
							}else if(dayScheduleArray[i].split("_")[1]==dayScheduleArray[i].split("_")[2] && j==0){
								timeTotalWorker[j]-=1;
								alert("11111");
								stringHtml+="<td class='timeTable_date_td'></td>";	
							}else if(j==Number(dayScheduleArray[i].split("_")[2].split(":")[0])){
								stringHtml+="<td class='timeTable_date_td' style='background-color:"+ridColorList[i][1]+";'>"+dayScheduleArray[i].split("_")[2].split(":")[1]+" 분</td>";	
							}else{
								stringHtml+="<td class='timeTable_date_td' style='background-color:"+ridColorList[i][1]+";'></td>";	
							}
						}else{
							stringHtml+="<td class='timeTable_date_td'></td>";
						}
    				}else{
    					if((j>=Number(dayScheduleArray[i].split("_")[1].split(":")[0]) && j<=Number(dayScheduleArray[i].split("_")[2].split(":")[0])) ||
    					   (j>=Number(dayScheduleArray[i].split("_")[3].split(":")[0]) && j<=Number(dayScheduleArray[i].split("_")[4].split(":")[0]))){
    						timeTotalWorker[j]+=1;
							if(j==Number(dayScheduleArray[i].split("_")[1].split(":")[0])){
								stringHtml+="<td class='timeTable_date_td' style='background-color:"+ridColorList[i][1]+";'>"+dayScheduleArray[i].split("_")[1].split(":")[1]+" 분</td>";			
							}else if(((dayScheduleArray[i].split("_")[1]==dayScheduleArray[i].split("_")[2]) ||
									(dayScheduleArray[i].split("_")[3]==dayScheduleArray[i].split("_")[4])) && j==0){
								timeTotalWorker[j]-=1;
								alert("11111");
								stringHtml+="<td class='timeTable_date_td'></td>";	
							}else if(j==Number(dayScheduleArray[i].split("_")[2].split(":")[0])){
								stringHtml+="<td class='timeTable_date_td' style='background-color:"+ridColorList[i][1]+";'>"+dayScheduleArray[i].split("_")[2].split(":")[1]+" 분</td>";	
							}else if(j==Number(dayScheduleArray[i].split("_")[3].split(":")[0])){
								stringHtml+="<td class='timeTable_date_td' style='background-color:"+ridColorList[i][1]+";'>"+dayScheduleArray[i].split("_")[3].split(":")[1]+" 분</td>";	
							}else if(j==Number(dayScheduleArray[i].split("_")[4].split(":")[0])){
								stringHtml+="<td class='timeTable_date_td' style='background-color:"+ridColorList[i][1]+";'>"+dayScheduleArray[i].split("_")[4].split(":")[1]+" 분</td>";	
							}else{
								stringHtml+="<td class='timeTable_date_td' style='background-color:"+ridColorList[i][1]+";'></td>";	
							}
    					}else{
    						stringHtml+="<td class='timeTable_date_td'></td>";
    					}
    				}
				} 

    			stringHtml+="</tr>";
			}
    		
    		stringHtml+="<tr class='timeTable_tr'><td class='timeTable_td' >합계</td><td class='timeTable_totalTime_td'>"+Math.floor(totalMinute/60)+":"+(totalMinute%60)+"</td>";
    		for (var i = 0; i < timeTotalWorker.length; i++) {
    			stringHtml+="<td class='timeTable_totalDate_td'>"+timeTotalWorker[i]+" 명</td>";
			}
    		stringHtml+="</tr>";
    		$("#modal_html").html(stringHtml);
			
    		
    	}) ;
    	
    	
    	$(".saveTimebtn").click(function(){
    		var checkTime=checkSelectTime();
    		if(checkTime==0){
	    		saveOrDeleteSchedule("0");
	    		$("input[name=checkAfterDay]").prop("checked",false);
	    		$(".close").click();
    		}else{
    			alert("시간을 다시 선택해주세요.");
    		}
    	});
    	$(".deleteTimebtn").click(function(){
    		if($("input[name=modal_color]").val()=="0"){
    			alert("저장된 스케줄이 없습니다.");
    		}else{
    			var checkTime=checkSelectTime();
    			if(checkTime==0){
		    		saveOrDeleteSchedule("1");
		    		$("input[name=checkAfterDay]").prop("checked",false);
		    		$(".close").click();    				
    			}else{
    				alert("시간을 다시 선택해주세요.");
    			}
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
	   	     var stringEndSchedule="";
	   	     for(var i=0;i<endScheduleArray.length;i++){
	    		if(i==endScheduleArray.length-1){
	    			stringEndSchedule+=endScheduleArray[i];
	    		}else{
	    			stringEndSchedule+=endScheduleArray[i]+",";
	    		}
	   	    }
	   	     $.ajax({
	   	    	 url:"saveSchedule.do",
	   	    	 type:"GET",
	   	    	 data:{
	   	    		 "stringSchedule":stringSchedule,
	   	    		 "stringEndSchedule":stringEndSchedule,
	   	    		 "allEmployeeRids":"${allEmployeeRids}",
	   	    		 "deleteDate":year+"-"+month
	   	    	 },
	   	    	 dateType:"text",
	   	    	 success : function(data){
	   	    		 alert("스케줄 저장 완료!");   
	   	    	 }
	   	    	 
	   	     });
	   	     
	   	     
    	});
    	/*근무 시작시간 변겅 시, 퇴근 시간 제어*/
    	$("#startHour").change(function(){
    		var startTime=Number($("#startHour option:selected").val());
     		if(!$("input[name=checkAfterDay]").is(":checked")){
    		$("#endHour option").remove();
    		appendEndHour(startTime);
     		}
    	});
    	

    	/*다음날 체크박스 선택 시, 시간 바꾸기*/
    	$("input[name=checkAfterDay]").click(function(){
    		if($(this).is(":checked")){
    			$("#endHour option").remove();
    			appendEndHour("0");
    		}else{
    			var startTime=Number($("#startHour option:selected").val());
        		$("#endHour option").remove();
        		appendEndHour(startTime);
    		}
    	});
    	
 
    }); 
    

    	function appendEndHour(data){

    		for (var i = data; i <24; i++) {
        		$("#endHour").append("<option value='"+i+"'>"+i+"시</option>");				
    			}
    	}
    	
		function checkSelectTime(){
    		var startHour=$("select[name=startHour]").val();
    		var startMinute=$("select[name=startMinute]").val();
    		var endHour=$("select[name=endHour]").val();
    		var endMinute=$("select[name=endMinute]").val();
    		var checkPoint=0;
    		if(startHour==endHour && startMinute==endMinute){
    			checkPoint=1;
    		}
    		return checkPoint;
		}
    	/*스케줄 저장 혹은 삭제했을 때!*/
    	function saveOrDeleteSchedule(data){

    		var startHour=$("select[name=startHour]").val();
    		var startMinute=$("select[name=startMinute]").val();
    		var endHour=$("select[name=endHour]").val();
    		var endMinute=$("select[name=endMinute]").val();
    		var checkAfterDay=$("input[name=checkAfterDay]").is(":checked");
    		var endDay;
    		
			var employRid=$("input[name=modal_rid]").val();
			var selectDay=$("input[name=modal_day]").val();
			var color=$("input[name=modal_color]").val();
			

			if(checkAfterDay==true){
				endDay=parseInt(selectDay)+1;
			}else{
				endDay=selectDay;
			}
			
			var editDay=selectDay;
	   	     /*데이터 넣기위한 날짜 변환*/
 	   	     if(Number(startHour)<=9){
	   	    	startHour="0"+startHour;
		     }
	   	     if(Number(startMinute)<=9){
	   	    	startMinute="0"+startMinute;
			     }
	   	     if(Number(endHour)<=9){
	   	    	endHour="0"+endHour;
			     }
	   	     if(Number(endMinute)<=9){
	   	    	endMinute="0"+endMinute;
			     } 
	   	     
	   	     
	   	     if(Number(editDay)<=9){
		   	    	editDay="0"+editDay;
			     }
	   	     if(Number(endDay)<=9){
	   	    	endDay="0"+endDay;
			     }
		 	
	    	 var startTime=startHour+":"+startMinute;
	   	     var endTime=endHour+":"+endMinute;
	   	     var startSchedule=employRid+"_"+year+"-"+month+"-"+editDay+" "+startTime;
      		 var endSchedule=employRid+"_"+year+"-"+month+"-"+endDay+" "+endTime;

      		if( (month>(nowDate.getMonth()+1)) ||( month==(nowDate.getMonth()+1) && selectDay>=nowDate.getDate())){
    			/*근무 지정할 때, 데이터 변화시켜주기*/
	          		if(data=="0"){
	          			/*배열에 저장*/
	    	   	    	scheduleArray.push(startSchedule);
	    	   	    	endScheduleArray.push(endSchedule);
	    	 			for (var j = 0; j < ridColorList.length; j++) {
	    					if(employRid==ridColorList[j][0]){
	    						$("#"+employRid).siblings("#"+selectDay).css("background-color",ridColorList[j][1]);
	    					}
	    				}
	    	 			$("#"+employRid).siblings("#"+selectDay).children("input[name=color]").val("1");

	               		totalScheduleCalcu(data,selectDay,endDay,employRid,startTime,endTime);
		          		}else{
		          			
		          			/*배열에 스케줄 저장한 것 삭제*/
		          			scheduleArray.splice($.inArray(startSchedule, scheduleArray),1);
		          			endScheduleArray.splice($.inArray(endSchedule, endScheduleArray),1);
		          	
			          		$("#"+employRid).siblings("#"+selectDay).css("background-color","");    
			          		$("#"+employRid).siblings("#"+selectDay).children("input[name=color]").val("0");
		          			

		               		totalScheduleCalcu(data,selectDay,endDay,employRid,startTime,endTime);
		          		}

          		}else{
          			alert("지난 날짜는 변경이 불가합니다.");
          		}
    	}
    	
    	/*시간 분으로 변환*/
    	function calcuTime(time){
    		var selectHour=Number(time.split(":")[0]);
    		var selectMinute=Number(time.split(":")[1]);
    		var totalMinute=selectHour*60+selectMinute;

    		return totalMinute;
    	}
    	
    	/*근무일, 근무 시간 총 계산*/
    	function totalScheduleCalcu(data,selectDay,endDay,mid,startTime,endTime){
    		
			var sumWork=Number($("#"+mid+"SumWork").text());
			var sumTime=$("#"+mid+"SumTime").text();
			sumTime=calcuTime(sumTime);
      		/* 전체 근무시간, 전체 근무일, 일별 근무하는 인원 잡아오기*/
      		var totalWork=Number($("#totalWork").text());
      		var totalTime=$("#totalTime").text();
      		var totalDate=Number($("span[id="+selectDay+"]").text());

      		totalTime=calcuTime(totalTime);


      		/*근무시간 계산하기*/

      		var startMinute=calcuTime(startTime);
      		var endMinute=calcuTime(endTime);
      		var workTime;
      		if(selectDay==endDay){
      			workTime=endMinute-startMinute;
      		}else{
      			workTime=1440-startMinute+endMinute;
      		}
	      		if(data=="0"){
	       			$("#totalWork").text(totalWork+1); 
	       			$("#totalTime").text(Math.floor((totalTime+workTime)/60)+":"+(totalTime+workTime)%60);
	       			$("span[id="+selectDay+"]").text(totalDate+1);
					$("#"+mid+"SumWork").text(sumWork+1);
					$("#"+mid+"SumTime").text(Math.floor((sumTime+workTime)/60)+":"+(sumTime+workTime)%60);
	      		}else if(data=="1"){
	      			$("#totalWork").text(totalWork-1);
	      			$("#totalTime").text(Math.floor((totalTime-workTime)/60)+":"+(totalTime-workTime)%60);
	      			$("span[id="+selectDay+"]").text(totalDate-1);
					$("#"+mid+"SumWork").text(sumWork-1);
					$("#"+mid+"SumTime").text(Math.floor((sumTime-workTime)/60)+":"+(sumTime-workTime)%60);
	      		}
    	}
		
    	function inputSchedule(allScheduleString,allEndScheduleString){
    		
			var allSchedules=allScheduleString.split(",");
			var allEndSchedules=allEndScheduleString.split(",");
			
			for (var i = 0; i < allSchedules.length; i++) {
				var mid=allSchedules[i].split("_")[0];
	 			var scheduledate=Number(allSchedules[i].split("_")[1].split("-")[2].split(" ")[0]);	
	 			var endDay=Number(allEndSchedules[i].split("_")[1].split("-")[2].split(" ")[0]);	
	 			var startTime=allSchedules[i].split(" ")[1];
	 			var endTime=allEndSchedules[i].split(" ")[1];
	 			scheduleArray.push(allSchedules[i]);
	 			endScheduleArray.push(allEndSchedules[i]);

	 			for (var j = 0; j < ridColorList.length; j++) {
					if(mid==ridColorList[j][0]){
					   	$("#"+mid).siblings("#"+scheduledate).css("background-color",ridColorList[j][1]);
					}
				}
				$("#"+mid).siblings("#"+scheduledate).children("input[name=color]").val("1");

 				totalScheduleCalcu("0",scheduledate,endDay,mid,startTime,endTime);
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
	
		<div id="miniCalendar" style="margin:40px 10px 40px 10px;cursor: pointer;"></div>
		<input type="hidden" name="selectMonth">
		<input type="hidden" name="selectYear">
		<input type="hidden" name="selectDay">


  <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
    
      <!-- Modal content-->
      <div class="modal-content" style="width: 80%;margin:30% 0% 0% 10%;">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title"></h4>
          <input type="hidden" name="modal_rid">
          <input type="hidden" name="modal_day">
          <input type="hidden" name="modal_color">
        </div>
        <div class="modal-body" style="padding-bottom: 10%;">
         	<select name="startHour" id="startHour" class="form-control timeSelect" style="margin-left: 1.5%">
				<c:forEach begin="0" end="23" var="n">
					<option value="${n}">${n}시</option>
				</c:forEach>
			</select>
			<select name="startMinute" id="startMinute" class="form-control timeSelect" >
				<c:forEach begin="0" end="11" var="n">
					<option value="${n*5}">${n*5}분</option>
				</c:forEach>
			</select>
			<span style="float: left;font-size: 20px;">~</span>
			<select name="endHour" id="endHour" class="form-control timeSelect" >
				<c:forEach begin="0" end="23" var="n">
					<option value="${n}">${n}시</option>
				</c:forEach>
			</select>
			<select name="endMinute" id="endMinute" class="form-control timeSelect" >
				<c:forEach begin="0" end="11" var="n">
					<option value="${n*5}">${n*5}분</option>
				</c:forEach>
			</select>

			<div style="vertical-align: middle;margin: 5px 0px 0px 2px;">
				<input type="checkbox" name="checkAfterDay"  style="vertical-align: middle;">다음날
			</div>
        </div>
        
       <div class="modal-footer">
        <c:if test="${checkPosition=='1'}">
          <button type="button" class="btn btn-default deleteTimebtn" >스케줄 삭제</button>
          <button type="button" class="btn btn-info saveTimebtn" >근무시간 저장</button>
        </c:if>
        <c:if test="${checkPosition!='1'}">
		  <button type="button" class="btn btn-default"  data-dismiss="modal">닫기</button>
        </c:if>
       </div>
      </div>
      
    </div>
  </div>
  
  
  <!-- Modal내꺼 -->
  <div class="modal fade" id="myModal1" role="dialog" style="padding-right: 0px;">
    <div class="modal-dialog" style="width: 90%;padding-left:1%;">
    
      <!-- Modal content-->
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h3 class="modal-title1"></h3>
        </div>
        <div class="modal-body">
         	
         	<table id="detailTimeSchedule" style="margin: 20px 38px 20px 36px;width: 1400px;">
		 		<thead>	
					<tr class="timeTable_tr" >
						<th class="timeTable_th">직원명</th>
						<th class="timeTable_time_th" >근무시간</th>
						<c:forEach begin="0" end="23" var="time" >
							<th  class='timeTable_date_th' id="${time}" >${time}</th>
						</c:forEach>
					</tr>
			 	</thead>
			 	<tbody id="modal_html">
			 	</tbody> 
			</table>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default"  data-dismiss="modal">닫기</button>
        </div>
      </div>
    </div>
  </div>
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
				<td class="scheduleTable_day_td "><span id="${n.mid}SumWork">0</span></td>
				<td class="scheduleTable_time_td"><span id="${n.mid}SumTime">00:00</span></td>
			</tr>
			</c:forEach>
			<tr class="scheduleTable_tr">
				<td class="scheduleTable_td">합계</td>
				<td class="scheduleTable_totalDay_td"><span id="totalWork">0</span></td>
				<td class="scheduleTable_totalTime_td"><span id="totalTime">00:00</span></td>
			</tr>
	 	</tbody> 
	</table>
</div>
