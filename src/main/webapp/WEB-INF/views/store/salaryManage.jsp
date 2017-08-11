<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">


	$(document).ready(function() {
		
		var year="${year}";
		var month="${month}";
 		var storeName="${storeInfo.name}";
		$(".payMantitle").text(storeName+"의 "+year+"년 "+month+"월 급여관리대장");
		
// 		var workTimeList="${allScheduleString}";
// 		var workTimeArray=workTimeList.split(",");
		
// 		var totalWeekTimeList="${totalWeekTime}";
// 		var totalWeekTime=totalWeekTimeList.split(",");
// 		var dayWorkTimeList="${stringworkTime}";
// 		var dayWorkTime=0;
// 		dayWorkTime=dayWorkTimeList.split(",");
// 		var weeklyPay="${totalMoney}";
// 		$("#weeklyPay").text(numberWithCommas(weeklyPay)+"원");
		
// 		var salaryState="";
// 		var totalWorkTime=0;
// 		var totalPlusTime=0;
// 		var totalOverTime=0;
// 		var totalSalary=0;
// 		var totalExcessPay=0;
// 		var totalOverTimePay=0;
		
// 		var check=0;
// 		var sumtime=0;
// 		var hourCheck=0;
// 		for (var i = 0; i < workTimeArray.length; i++) {
// 			var onWork=workTimeArray[i].split(" ")[1].split("_")[0];
// 			var offWork=workTimeArray[i].split("_")[1].split(" ")[1];
// 			var wage=workTimeArray[i].split("_")[2];
// 			var startDay=workTimeArray[i].split("_")[0].split("-")[2].split(" ")[0];

// 			var totalWorkMinute=dayWorkTime[i];
// 			var totalWeekWorkTime=0;
// 			var plusTime=0;
// 			var overTime=0;
// 			var daySalary=0;
// 			salaryState+="<tr class='recruit_tr'><td class='salaryTd'>"+workTimeArray[i].split(" ")[0]+"</td><td class='salaryTd'>"
// 			+onWork+"</td><td class='salaryTd'>"+offWork+"</td>";
			
// 			salaryState+="<td class='salaryTd'>"+Math.floor((totalWorkMinute)/60)+"시간 "+(totalWorkMinute)%60+"분</td>";
			
// 			/*한 주의 총 근무시간 구하기*/
// 			for (var j = 0; j < totalWeekTime.length; j++) {
// 				if(j==0 && (Number(startDay)<=totalWeekTime[j].split("_")[0].split("-")[2])){
// 					totalWeekWorkTime=totalWeekTime[j].split("_")[1];
	
// 				}else if(j>=1 && ((Number(startDay)<=totalWeekTime[j].split("_")[0].split("-")[2]) && (Number(startDay)>totalWeekTime[j-1].split("_")[0].split("-")[2]))){
// 					totalWeekWorkTime=totalWeekTime[j].split("_")[1];
// 				}					
// 			}
			
// 			/* 한 주 총 근무시간이 40시간 이상/이하 비교*/
// 			if(totalWeekWorkTime>=2400){
// 				/*일 근무시간 더하기*/
// 				sumtime+=Number(totalWorkMinute);
// 				if(totalWorkMinute>=480){
// 					hourCheck+=480;
// 				}else{
// 					hourCheck+=Number(totalWorkMinute);	
// 				}
// 				 /*주 40시간 이상 근무시 추가 시간만큼 1.5배 해주기*/
// 				 if(hourCheck>=2400 && check!=1){
// 					check=1;
// 					if(totalWorkMinute>=480){
// 						hourCheck-=480;
// 						hourCheck+=Number(totalWorkMinute);	
// 					}
					
// 					if(hourCheck-2400>=60){
// 						salaryState+="<td class='salaryTd'>"+Math.floor((hourCheck-2400)/60)+"시간 "+(hourCheck-2400)%60+"분</td>";	
// 					}else{
// 						salaryState+="<td class='salaryTd'>"+(hourCheck-2400)%60+"분</td>";	
// 					}
// 					plusTime=hourCheck-2400;
// 					/*주 40시간 초과 근무시 1.5배 해주기*/
// 				 }else if(check==1){
// 					if(totalWorkMinute>=60){
// 						salaryState+="<td class='salaryTd'>"+Math.floor((totalWorkMinute)/60)+"시간 "+(totalWorkMinute)%60+"분</td>";	
// 					}else{
// 						salaryState+="<td class='salaryTd'>"+(totalWorkMinute)%60+"분</td>";	
// 					}
// 					plusTime=totalWorkMinute;
// 					if(totalWeekWorkTime==sumtime){
// 						sumtime=0;
// 						check=0;
// 						hourCheck=0;
// 					 }
// 					/*주의 총 근무시간은 40시간 이상 , 추가 근무시간 합이 40시간 미만일 경우*/
// 				 }else{
// 						if(totalWorkMinute>=480 && (totalWorkMinute-480>=60)){
// 							salaryState+="<td class='salaryTd'>"+Math.floor((totalWorkMinute-480)/60)+"시간 "+(totalWorkMinute-480)%60+"분</td>";	
// 							plusTime=totalWorkMinute-480;
// 						}else if(totalWorkMinute>=480 && (totalWorkMinute-480<60)){
// 							salaryState+="<td class='salaryTd'>"+(totalWorkMinute-480)%60+"분</td>";	
// 							plusTime=totalWorkMinute-480;
// 						}else{
// 							salaryState+="<td class='salaryTd'>-</td>";	
// 							plusTime=0;
// 						}
// 				 }
// 				 /* 주의 총 근무시간이 40시간 미만일경우 */
// 			}else{
// 				if(totalWorkMinute>=480 && (totalWorkMinute-480>=60)){
// 					salaryState+="<td class='salaryTd'>"+Math.floor((totalWorkMinute-480)/60)+"시간 "+(totalWorkMinute-480)%60+"분</td>";	
// 					plusTime=totalWorkMinute-480;
// 				}else if(totalWorkMinute>=480 && (totalWorkMinute-480<60)){
// 					salaryState+="<td class='salaryTd'>"+(totalWorkMinute-480)%60+"분</td>";	
// 					plusTime=totalWorkMinute-480;
// 				}else{
// 					salaryState+="<td class='salaryTd'>-</td>";	
// 					plusTime=0;
// 				}	
// 			}
		

// 			/*야근수당 구하기*/		
// 		 	if(startDay!=workTimeArray[i].split("_")[1].split("-")[2].split(" ")[0]){
// 				if(Number(onWork.split(":")[0])>=22 && Number(offWork.split(":")[0])<=6){
// 					overTime=calcuTime(offWork)+(1440-calcuTime(onWork));
// 				}else if(Number(onWork.split(":")[0])<22 && Number(offWork.split(":")[0])<=6){
// 					overTime=calcuTime(offWork)+120;
// 				}else if(Number(onWork.split(":")[0])>=22 && Number(offWork.split(":")[0])>6){
// 					overTime=calcuTime(onWork)+360;
// 				}else{
// 					overTime=480;
// 				}

// 			}else{
// 				if(Number(onWork.split(":")[0])>=22 || Number(onWork.split(":")[0])<=6 && Number(offWork.split(":")[0])<=6){
// 					overTime=calcuTime(offWork)-calcuTime(onWork);
// 				}else if(Number(offWork.split(":")[0])>=22){
// 					overTime=calcuTime(offWork)-1320;
// 				}else if(Number(onWork.split(":")[0])<=6 && Number(offWork.split(":")[0])>6){
// 					overTime=360-calcuTime(onWork);
// 				}else{
// 					overTime=0;
// 				}
// 			}
// 			if(overTime>=60){
// 				salaryState+="<td class='salaryTd'>"+Math.floor(overTime/60)+"시간 "+(overTime%60)+"분</td>";	
// 			}else if(overTime<60){
// 				salaryState+="<td class='salaryTd'>"+(overTime%60)+"분</td>";	
// 			}else{
// 				salaryState+="<td class='salaryTd'>111</td>";	
// 			}	
		
// 			salaryState+="<td class='salaryTd'>"+numberWithCommas(wage)+"</td>";
// 			if(totalWorkMinute>=480){
// 				daySalary=8*wage+Math.floor(plusTime*((wage*1.5)/60));
// 				daySalary+=Math.floor(overTime*((wage*1.5)/60));
// 			}else{
// 				daySalary=Math.floor(totalWorkMinute*(wage/60));
// 				daySalary+=Math.floor(overTime*((wage*1.5)/60));
// 			}
// 				salaryState+="<td class='salaryTd2'>"+numberWithCommas(daySalary)+" 원</td></tr>";
// 				totalWorkTime+=Number(totalWorkMinute);
// 				totalPlusTime+=Number(plusTime);
// 				totalOverTime+=overTime;
// 				totalSalary+=daySalary;
// 				totalExcessPay+=Math.floor(plusTime*((wage*1.5)/60));
// 				totalOverTimePay+=Math.floor(overTime*((wage*1.5)/60));
// 		}
		
// 		salaryState+="<tr class='recruit_tr'><td class='salaryTd' colspan='3'>합계 <span style='color:#808080'>&nbsp; ※주휴수당 미포함</span></td>"
// 		+"<td class='salaryTd'>"+Math.floor((totalWorkTime)/60)+"시간 "+(totalWorkTime)%60+"분 </td><td class='salaryTd'>"
// 		+Math.floor((totalPlusTime)/60)+"시간 "+(totalPlusTime)%60+"분 </td><td class='salaryTd'>"
// 		+Math.floor((totalOverTime)/60)+"시간 "+(totalOverTime)%60+"분 </td><td class='salaryTd'>총 월급</td>"
// 		+"<td class='salaryTd1'>"+numberWithCommas(totalSalary)+"원</td></tr>";

// 		$("#salaryTbody").html(salaryState);

// 		$("#totalWorkTime").text(Math.floor((totalWorkTime)/60)+"시간 "+(totalWorkTime)%60+"분");
// 		$("#totalExcessPay").text(numberWithCommas(totalExcessPay)+"원");
// 		$("#totalOverTimePay").text(numberWithCommas(totalOverTimePay)+"원");
// 		$("#totalSalary").text(numberWithCommas(totalSalary)+"원");
		
		
// 		/* 엑셀로 다운로드하기 */
// 		$("#toExcelButton").click(function(e) {
// 			window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('#toExcel').html()));
// 			e.preventDefault();
// 		});
	});
// 	function calcuTime(time){
// 		var selectHour=Number(time.split(":")[0]);
// 		var selectMinute=Number(time.split(":")[1]);
// 		var totalMinute=selectHour*60+selectMinute;
	
// 		return totalMinute;
// 	}
// 	function numberWithCommas(x) {
// 	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
// 	}



</script>
<div id="content">
	<div class="container">
		<h2 class="payMantitle"><b></b></h2>
		<br><br>
		<div >
			<form id="frm" class="form-inline" action="checkSalary.do" method="get">				
				<!-- 매장 선택 -->
				<div class="col-lg-9">
					<select class="form-control selectStore" style="margin-top: 20px;">
						<c:forEach items="${storeList}" var="n">
							<c:if test="${n.sid==storeInfo.sid}">
								<option value="${n.sid}" selected="selected">${n.name}</option>
							</c:if>
							<c:if test="${n.sid!=storeInfo.sid}">
								<option value="${n.sid}">${n.name}</option>
							</c:if>
						</c:forEach>
					</select>
					<select name="selectYear" class="form-control selectYear" style="margin-top: 20px;">
						<c:forEach begin="${startYear}" end="2017" var="n">
						<c:if test="${n==year}">
							<option value="${n}" selected="selected">${n}년</option>	
						</c:if>
						<c:if test="${n!=year}">
							<option value="${n}">${n}년</option>	
						</c:if>
						</c:forEach>	
					</select>
					<select name="selectMonth" class="form-control selectMonth" style="margin-top: 20px;">				
						<c:forEach begin="1" end="12" var="n">
						<c:if test="${n==month}">
								<option value="${n}" selected="selected">${n}월</option>	
						</c:if>
						<c:if test="${n!=month}">
							<option value="${n}">${n}월</option>	
						</c:if>
						</c:forEach>	
					</select>
					<button class="btn btn-default searchBtn" style="margin-top: 20px;">검색</button>
				</div>
			</form>	
		  		&nbsp;
		 		&nbsp;  		
		  		<!-- 직원 등록 버튼 / 엑셀 다운로드 버튼 -->
		  		<div class="col-lg-3">
				<button id="toExcelButton" class="btn btn-warning" style="float: right;margin-bottom: 20px;">엑셀 다운로드</button>	
				</div>
		</div>
		
		<div id="toExcel">
			<table id="salaryTable" class="table table-bordered">
				<thead>
					<tr>
						<th class="salaryTh1">성명</th>
						<th class="salaryTh">시급</th>
						<th class="salaryTh">총 근무시간</th>
						<th class="salaryTh">주휴 수당</th>
						<th class="salaryTh">추가 수당</th>					
						<th class="salaryTh">야간 수당</th>
						<th class="salaryTh1">총 월급</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${salaryManageList}" var="n">
						<tr class="recruit_tr">
							<td class="salaryTd name">${n.name}</td>
							<td class="salaryTd wage">${n.wage}</td>
							<td class="salaryTd totalWorkTime">${n.totalTime}</td>
							<td class="salaryTd weeklyPay">${n.weeklyPay}</td>
<%-- 							<td class="salaryTd totalExcessPay">${n.excessPay}</td> --%>
<%-- 							<td class="salaryTd totalOverTimePay">${n.overTimePay}</td> --%>
<%-- 							<td class="salaryTd1 totalSalary">${n.totalPay}</td> --%>
							<td class="salaryTd totalExcessPay">0</td>
							<td class="salaryTd totalOverTimePay">0</td>
							<td class="salaryTd1 totalSalary">0</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>	
		</div>		
	</div>
</div>