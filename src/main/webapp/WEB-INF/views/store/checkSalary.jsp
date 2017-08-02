<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">


	$(document).ready(function() {
		
		var year="${year}";
		var month="${month}";
		$(".payMantitle").text(year+"년 "+month+"월 급여명세서");
		
		var workTimeList="${allScheduleString}";
		var workTimeArray=workTimeList.split(",");
		var salaryState="";

		var totalWorkTime=0;
		var totalPlusTime=0;
		var totalOverTime=0;
		var totalSalary=0;
		for (var i = 0; i < workTimeArray.length; i++) {
			var onWork=workTimeArray[i].split(" ")[1].split("_")[0];
			var offWork=workTimeArray[i].split("_")[1].split(" ")[1];
			var wage=workTimeArray[i].split("_")[2];
			
			var totalWorkMinute=0;
			var plusTime=0;
			var overTime=0;
			var daySalary=0;
			salaryState+="<tr class='recruit_tr'><td class='salaryTd'>"+workTimeArray[i].split(" ")[0]+"</td><td class='salaryTd'>"
			+onWork+"</td><td class='salaryTd'>"+offWork+"</td>";
	
			 if(Number(onWork.split(":")[0])>Number(offWork.split(":")[0])){
				totalWorkMinute=1440-calcuTime(onWork)+calcuTime(offWork);
			}else{
				totalWorkMinute=calcuTime(offWork)-calcuTime(onWork);
			}
			
			salaryState+="<td class='salaryTd'>"+Math.floor((totalWorkMinute)/60)+"시간 "+(totalWorkMinute)%60+"분</td>";
			
			if(totalWorkMinute>=480 && (totalWorkMinute-480>=60)){
				salaryState+="<td class='salaryTd'>"+Math.floor((totalWorkMinute-480)/60)+"시간 "+(totalWorkMinute-480)%60+"분</td>";	
				plusTime=totalWorkMinute-480;
			}else if(totalWorkMinute>=480 && (totalWorkMinute-480<60)){
				salaryState+="<td class='salaryTd'>"+(totalWorkMinute-480)%60+"분</td>";	
				plusTime=totalWorkMinute-480;
			}else{
				salaryState+="<td class='salaryTd'>-</td>";	
				plusTime=0;
			}
			/*야근수당은 보류.....*/			
		/* 	if(Number(onWork.split(":")[0])>Number(offWork.split(":")[0])){
				if()
			} */
			salaryState+="<td class='salaryTd'>-</td><td class='salaryTd'>"+numberWithCommas(wage)+"</td>";
			if(totalWorkMinute>=480){
				daySalary=8*wage+Math.floor((totalWorkMinute-480)*((wage*1.5)/60));
			}else{
				daySalary=Math.floor(totalWorkMinute*(wage/60));
			}
				salaryState+="<td class='salaryTd2'>"+numberWithCommas(daySalary)+" 원</td></tr>";
				
				totalWorkTime+=totalWorkMinute;
				totalPlusTime+=plusTime;
				totalOverTime+=overTime;
				totalSalary+=daySalary;
		}
		
		salaryState+="<tr class='recruit_tr'><td class='salaryTd' colspan='3'>합계 <span style='color:#808080'>&nbsp; ※주휴수당 미포함</span></td>"
		+"<td class='salaryTd'>"+Math.floor((totalWorkTime)/60)+"시간 "+(totalWorkTime)%60+"분 </td><td class='salaryTd'>"
		+Math.floor((totalPlusTime)/60)+"시간 "+(totalPlusTime)%60+"분 </td><td class='salaryTd'>"
		+Math.floor((totalOverTime)/60)+"시간 "+(totalOverTime)%60+"분 </td><td class='salaryTd'>총 수당</td>"
		+"<td class='salaryTd1'>"+numberWithCommas(totalSalary)+"원</td></tr>";

		$("#salaryTbody").html(salaryState);


		/* 엑셀로 다운로드하기 */
		$("#toExcelButton").click(function(e) {
			window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('#toExcel').html()));
			e.preventDefault();
		});
	});
	function calcuTime(time){
		var selectHour=Number(time.split(":")[0]);
		var selectMinute=Number(time.split(":")[1]);
		var totalMinute=selectHour*60+selectMinute;
	
		return totalMinute;
	}
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}



</script>
<div id="content">
	<div class="container">
		<h2 class="payMantitle"><b></b></h2>
		<br><br>
		<div >
			<form id="frm" class="form-inline" action="checkSalary.do" method="get">				
				<!-- 매장 선택 -->
				<div class="col-lg-9">
<%-- 					<select id="store" class="form-control" name="store" style="margin-top: 20px;">
						<c:forEach items="${storeList}"  var="storeList" varStatus="status">
							<c:if test="${status.index==0}">
								<option selected="selected" value="${storeList.sid}">${storeList.name}</option>
							</c:if>
							<c:if test="${status.index!=0}">
								<option value="${storeList.sid}">${storeList.name}</option>
							</c:if>
						</c:forEach>
			  		</select> --%>
					<select name="selectYear" class="form-control selectYear" style="margin-top: 20px;">
						<c:forEach begin="${joinYear}" end="2017" var="n">
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
						<th class="salaryTh1">지급일자</th>
						<th class="salaryTh">성명</th>
						<th class="salaryTh">총 근무시간</th>
						<th class="salaryTh">주휴 수당</th>
						<th class="salaryTh">추가 수당</th>					
						<th class="salaryTh">총 수당</th>
						<th class="salaryTh">갑근세</th>
						<th class="salaryTh">주민세</th>
						<th class="salaryTh">고용보험</th>
						<th class="salaryTh">건강보험</th>
						<th class="salaryTh">국민연금</th>
						<th class="salaryTh">실지급액</th>
					</tr>
				</thead>
				<tbody>
						<tr class="recruit_tr">
							<td class="salaryTd">2017-08-11</td>
							<td class="salaryTd">표여진</td>
							<td class="salaryTd">109</td>
							<td class="salaryTd">56,000</td>
							<td class="salaryTd">76,200</td>
							<td class="salaryTd">924,000</td>
							<td class="salaryTd">60,000</td>
							<td class="salaryTd">6,000</td>
							<td class="salaryTd">43,032</td>
							<td class="salaryTd">11,210</td>
							<td class="salaryTd">11,253</td>
							<td class="salaryTd1">881,200원</td>
						</tr>
				</tbody>
			</table>

			<table id="salaryDetailTable" class="table table-bordered">
				<thead>
					<tr>
						<th class="salaryTh1">근무일자</th>
						<th class="salaryTh">출근시간</th>
						<th class="salaryTh">퇴근시간</th>
						<th class="salaryTh">총 근무시간</th>
						<th class="salaryTh">초과근무시간</th>					
						<th class="salaryTh">야간수당</th>
						<th class="salaryTh">시급</th>
						<th class="salaryTh">총 지급액</th>

					</tr>
				</thead>
				<tbody id="salaryTbody">
					

				</tbody>
			</table>		
		</div>		
	</div>
</div>