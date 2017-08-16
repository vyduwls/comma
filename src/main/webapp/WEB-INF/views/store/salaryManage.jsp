<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">


	$(document).ready(function() {
		
		var year="${year}";
		var month="${month}";
 		var storeName="${storeInfo.name}";
		$(".payMantitle").text(storeName+"의 "+year+"년 "+month+"월 급여관리대장");
		
		var stringSalary="${stringSalary}";
		var salaryList=stringSalary.split(",");
		
		var tableInput="";
		for (var i = 0; i < salaryList.length; i++) {
			alert(salaryList[i].split("_")[0]);
			tableInput+="<tr class='recruit_tr'><td class='salaryTd name'><a href='checkSalary.do?mid="+salaryList[i].split("_")[0]+"'>"
			+salaryList[i].split("_")[1]+"</a></td><td class='salaryTd wage'>"+numberWithCommas(salaryList[i].split("_")[2])+" 원</td>"
			+"<td class='salaryTd workTime'>"+Math.floor(salaryList[i].split("_")[3]/60)+"시간 "+salaryList[i].split("_")[3]%60+"분</td>"
			+"<td class='salaryTd weeklyPay'>"+numberWithCommas(salaryList[i].split("_")[4])+" 원</td>"
			+"<td class='salaryTd excessPay'>"+numberWithCommas(salaryList[i].split("_")[5])+" 원</td>"
			+"<td class='salaryTd overTimePay'>"+numberWithCommas(salaryList[i].split("_")[6])+" 원</td>"
			+"<td class='salaryTd salary'>"+numberWithCommas(salaryList[i].split("_")[7])+" 원</td></tr>"
		}
			$(".tbodyInTr").after(tableInput);
		

			$(".totalWorkTime").text(Math.floor($(".totalWorkTime").text()/60)+"시간 "+$(".totalWorkTime").text()%60+"분");
			$(".totalweeklyPay").text(numberWithCommas($(".totalweeklyPay").text())+" 원");
			$(".totalExcessPay").text(numberWithCommas($(".totalExcessPay").text())+" 원");
			$(".totalOverTimePay").text(numberWithCommas($(".totalOverTimePay").text())+" 원");
			$(".totalSalary").text(numberWithCommas($(".totalSalary").text())+" 원");
		
	});
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}



</script>
<div id="content">
	<div class="container">
		<h2 class="payMantitle"><b></b></h2>
		<br><br>
		<div >
			<form id="frm" class="form-inline" action="salaryManage.do" method="get">				
				<!-- 매장 선택 -->
				<div class="col-lg-9">
					<select name="sid" class="form-control selectStore" style="margin-top: 20px;">
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
				<tbody id="salaryTbody">
						<tr class="tbodyInTr"></tr>
						<tr>
							<td class="salaryTd" colspan="2" >총합</td>
							<td class="salaryTd totalWorkTime">${sm.totalTime}</td>
							<td class="salaryTd totalweeklyPay">${sm.weeklyPay}</td>
							<td class="salaryTd totalExcessPay">${sm.excessPay}</td>
							<td class="salaryTd totalOverTimePay">${sm.overTimePay}</td>
							<td class="salaryTd1 totalSalary" style="color: red;">${sm.totalPay}</td>
						</tr>
				</tbody>
			</table>	
		</div>		
	</div>
</div>