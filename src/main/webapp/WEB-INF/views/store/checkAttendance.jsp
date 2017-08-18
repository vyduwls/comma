<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
$(document).ready(function() {
	/* 근무 기간 선택 */
	$("#startDatePicker").datepicker({
		dateFormat: "yy-mm-dd",
		changeMonth : true,
		changeYear : true,
		maxDate : 0,
		onClose: function( selectedDate ) {    
	        $("#endDatePicker").datepicker("option", "minDate", selectedDate);
	    } 
	});
	$("#endDatePicker").datepicker({
		dateFormat: "yy-mm-dd",
		changeMonth : true,
		changeYear : true,
		maxDate : 0,
		onClose: function( selectedDate ) { 
	        $("#startDatePicker").datepicker("option", "maxDate", selectedDate);
	    } 
	});
	
	/* 검색 기능 */
	$("#frm").ajaxForm({
		beforeSubmit : function(data, form, option) {
			return true;
		},
		success : function(data) {
			var result = $.trim(data);
			var test = JSON.parse(result);
			
			
			
			/* 테이블 초기화 */
			$("#table tbody .attendance_tr").remove();
			
			/* 테이블 갱신 */
			$.each(test, function(index,item) {
				var tr = $("<tr class='attendance_tr'></tr>");
				
				// state를 완성하기 위한 플래그
				var date;
				var preOnWork;
				var preOffWork;
				var onWork;
				var offWork;
				
				$.each(item, function(key,value) {
					if(key!="rid" && key!="sid") {
						switch(key) {
							case "sseq" :
								tr.attr("id",value);
								break;
							case "date" :
								var td = $("<td class='divide' style='width: 100px'></td>").text(value);
								tr.append(td);
								break;
							case "mid" :
								var td = $("<td style='width: 60px'></td>").text(value);
								tr.append(td);
								break;
							case "name" :
								var td = $("<td style='width: 70px'></td>").text(value);
								tr.append(td);
								break;
							case "position" :
								var td = $("<td class='divide' style='width: 80px'></td>").text(value);
								tr.append(td);
								break;
							case "preOnWork" :
								var temp = date + ' ' + value;
								preOnWork = new Date(temp);
								var td = $("<td class='data'></td>").text(value);
								tr.append(td);
								break;
							case "preOffWork" :
								var temp = date + ' ' + value;
								preOffWork = new Date(temp);
								var td = $("<td class='data divide'></td>").text(value);
								tr.append(td);
								break;
							case "onWork" :
								var temp = date + ' ' + value;
								onWork = new Date(temp);
								var td = $("<td class='data'></td>").text(value);
								tr.append(td);
								
								if(onWork.getTime() - preOnWork.getTime() > 0) {
									td.append("(지각)");
								}
								break;
							case "offWork" :
								var temp = date + ' ' + value;
								offWork = new Date(temp);
								var td = $("<td class='data divide'></td>").text(value);
								tr.append(td);
								
								if(preOffWork.getTime() - offWork.getTime() > 0) {
									td.append("(조퇴)");
								}
								break;
							case "wage" :
								var td = $("<td class='data divide'></td>").text(value);
								tr.append(td);
								break;
							case "memo" :
								var td = $("<td class='data divide' style='width: 200px'></td>");
								tr.append(td);
								break;
						}
					}
				});
				
				tr.appendTo($("#table tbody"));
			});
		},
		error : function() {
			alert("submit 실패");
		}
	});
});

</script>

<div id="content">
	<div class="container">
		<h2><b>근태 정보 조회</b></h2>
		<br><br>
		<div id="frm_div">
			<form id="frm" class="form-inline" action="searchAttendanceForEmployee.do" method="post">
			
				<!-- 날짜 선택 -->
				<div class="form-group">
		  			<input class="form-control" type="text" id="startDatePicker" name="startDate" placeholder="근무기간(시작) 선택" required="required">
				</div>
				~
				<div class="form-group">
		  			<input class="form-control" type="text" id="endDatePicker" name="endDate" placeholder="근무기간(끝) 선택" required="required">
				</div>
				&nbsp;
				
				<button class="btn btn-default" type="submit">검색</button>
			</form>
		</div>

		<div class="col-lg-12 sticky-table sticky-headers sticky-ltr-cells">
			<table id="table" class="table">
				<thead>
					<tr class="sticky-row">
						<th class="divide">날짜</th>
						<th>아이디</th>
						<th>이름</th>					
						<th class="divide">직급</th>
						<th>출근 시간</th>
						<th class="divide">퇴근 시간</th>
						<th>출근 시간(실제)</th>
						<th class="divide">퇴근 시간(실제)</th>
						<th class="divide">시급</th>
						<th class="divide">비고</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="attendanceList" items="${attendanceList}">
						<tr class="attendance_tr" id="${attendanceList.sseq}">
							<td class="divide" style="width: 100px">${attendanceList.date}</td>
							<td style="width: 60px">${attendanceList.mid}</td>
							<td style="width: 70px">${attendanceList.name}</td>
							<td class="divide" style="width: 80px">${attendanceList.position}</td>
							<td class="data">${attendanceList.preOnWork}</td>
							<td class="data divide">${attendanceList.preOffWork}</td>
							<td class="data">${attendanceList.onWork}
								<c:if test="${attendanceList.onWorkState != '정상'}">
									(${attendanceList.onWorkState})
								</c:if>
							</td>
							<td class="data divide">${attendanceList.offWork}
								<c:if test="${!empty attendanceList.offWork}">
									(${attendanceList.offWorkState})
								</c:if>
							</td>
							<td class="data divide">${attendanceList.wage}</td>
							<td class="data divide" style="width: 200px">${attendanceList.memo}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</div>