<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">


	$(document).ready(function() {
		
		var year="${year}";
		var month="${month}";
 		var storeName="${storeInfo.name}";
		$(".payMantitle").text(storeName+"의 "+year+"년 "+month+"월 급여관리대장");
		
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
				<tbody>
					<c:forEach items="${salaryManageList}" var="n">
						<tr class="recruit_tr">		
							<td class="salaryTd name">
								<a href="checkSalary.do?mid=${n.mid}">${n.name}</a>
							</td>
							<td class="salaryTd wage">${n.wage}</td>
							<td class="salaryTd totalWorkTime">${n.totalTime}</td>
							<td class="salaryTd weeklyPay">${n.weeklyPay} 원</td>
							<td class="salaryTd totalExcessPay">${n.excessPay} 원</td>
							<td class="salaryTd totalOverTimePay">${n.overTimePay} 원</td>
							<td class="salaryTd1 totalSalary">${n.totalPay} 원</td>
						</tr>
					</c:forEach>
						<tr>
							<td class="salaryTd" colspan="2" >총합</td>
							<td class="salaryTd totalWorkTime">${sm.totalTime}</td>
							<td class="salaryTd weeklyPay">${sm.weeklyPay} 원</td>
							<td class="salaryTd totalExcessPay">${sm.excessPay} 원</td>
							<td class="salaryTd totalOverTimePay">${sm.overTimePay} 원</td>
							<td class="salaryTd1 totalSalary" style="color: red;">${sm.totalPay} 원</td>
						</tr>
				</tbody>
			</table>	
		</div>		
	</div>
</div>