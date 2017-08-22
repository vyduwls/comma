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
		
		/* 셀렉트 박스 변경 시 테이블 변경 */
		$("#store").change(function() {
			$.ajax({
				url : 'changeAttendance.do',
				type : 'post',
				datatype : 'json',
				data : {'sid' : $("#store option:selected").val()},
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
						var today = new Date();
						
						$.each(item, function(key,value) {
							switch(key) {
								case "sseq" :
									tr.attr("id",value);
									break;
								case "date" :
									date = value;
									var input = $("<input type='hidden' name='date'>").val(value);
									var td = $("<td class='divide' style='width: 100px'></td>").text(value);
									tr.append(td.append(input));
									break;
								case "mid" :
									var input = $("<input type='hidden' name='mid'>").val(value);
									var td = $("<td style='width: 60px'></td>").text(value);
									tr.append(td.append(input));
									break;
								case "name" :
									var input = $("<input type='hidden' name='name'>").val(value);
									var td = $("<td style='width: 70px'></td>").text(value);
									tr.append(td.append(input));
									break;
								case "position" :
									var input = $("<input type='hidden' name='position'>").val(value);
									var td = $("<td class='divide' style='width: 80px'></td>").text(value);
									tr.append(td.append(input));
									break;
								case "preOnWork" :
									var temp = date + ' ' + value;
									preOnWork = new Date(temp);
									var input = $("<input style='width: 60px' type='text' name='preOnWork'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
								case "preOffWork" :
									var temp = date + ' ' + value;
									preOffWork = new Date(temp);
									var input = $("<input style='width: 60px' type='text' name='preOffWork'>").val(value);
									var td = $("<td class='data divide'></td>");
									tr.append(td.append(input));
									break;
								case "onWork" :
									var temp = date + ' ' + value;
									onWork = new Date(temp);
									var input = $("<input style='width: 60px' type='text' name='onWork'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									
									if(onWork.getTime() - preOnWork.getTime() > 0) {
										td.append("(지각)");
									}
									break;
								case "offWork" :
									var temp = date + ' ' + value;
									offWork = new Date(temp);
									var input = $("<input style='width: 60px' type='text' name='offWork'>").val(value);
									var td = $("<td class='data divide'></td>");
									tr.append(td.append(input));
									
									if(preOffWork.getTime() - offWork.getTime() > 0) {
										td.append("(조퇴)");
									}
									break;
								case "wage" :
									var todayDate = today.getFullYear() + "-" + today.getMonth() + "-" + today.getDate();
									var toDate = new Date(date);
									var dateDate = toDate.getFullYear() + "-" + toDate.getMonth() + "-" + toDate.getDate();
							
									if(todayDate == dateDate) {
										var input = $("<input style='width: 60px' type='text' name='wage'>").val(value);
										var td = $("<td class='data divide'></td>");
										tr.append(td.append(input));
									} else {
										var td = $("<td class='data divide'></td>").text(value);
										tr.append(td);
									}
									break;
								case "memo" :
									var input = $("<input style='width: 150px' type='text' name='memo'>").val(value);
									var td = $("<td class='data divide'></td>");
									tr.append(td.append(input));
									break;
							}
						});
						
						$("<td><button class='btn btn-xs btn-primary modifyBtn'>저장</button></td>").appendTo(tr);
						tr.appendTo($("#table tbody"));
					});
				}
			});
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
									date = value;
									var input = $("<input type='hidden' name='date'>").val(value);
									var td = $("<td class='divide' style='width: 100px'></td>").text(value);
									tr.append(td.append(input));
									break;
								case "mid" :
									var input = $("<input type='hidden' name='mid'>").val(value);
									var td = $("<td style='width: 60px'></td>").text(value);
									tr.append(td.append(input));
									break;
								case "name" :
									var input = $("<input type='hidden' name='name'>").val(value);
									var td = $("<td style='width: 70px'></td>").text(value);
									tr.append(td.append(input));
									break;
								case "position" :
									var input = $("<input type='hidden' name='position'>").val(value);
									var td = $("<td class='divide' style='width: 80px'></td>").text(value);
									tr.append(td.append(input));
									break;
								case "preOnWork" :
									var temp = date + ' ' + value;
									preOnWork = new Date(temp);
									var input = $("<input style='width: 60px' type='text' name='preOnWork'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
								case "preOffWork" :
									var temp = date + ' ' + value;
									preOffWork = new Date(temp);
									var input = $("<input style='width: 60px' type='text' name='preOffWork'>").val(value);
									var td = $("<td class='data divide'></td>");
									tr.append(td.append(input));
									break;
								case "onWork" :
									var temp = date + ' ' + value;
									onWork = new Date(temp);
									var input = $("<input style='width: 60px' type='text' name='onWork'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									
									if(onWork.getTime() - preOnWork.getTime() > 0) {
										td.append("(지각)");
									}
									break;
								case "offWork" :
									var temp = date + ' ' + value;
									offWork = new Date(temp);
									var input = $("<input style='width: 60px' type='text' name='offWork'>").val(value);
									var td = $("<td class='data divide'></td>");
									tr.append(td.append(input));
									
									if(preOffWork.getTime() - offWork.getTime() > 0) {
										td.append("(조퇴)");
									}
									break;
								case "wage" :
									var todayDate = today.getFullYear() + "-" + today.getMonth() + "-" + today.getDate();
									var toDate = new Date(date);
									var dateDate = toDate.getFullYear() + "-" + toDate.getMonth() + "-" + toDate.getDate();
							
									if(todayDate == dateDate) {
										var input = $("<input style='width: 60px' type='text' name='wage'>").val(value);
										var td = $("<td class='data divide'></td>");
										tr.append(td.append(input));
									} else {
										var td = $("<td class='data divide'></td>").text(value);
										tr.append(td);
									}
									break;
								case "memo" :
									var input = $("<input style='width: 150px' type='text' name='memo'>").val(value);
									var td = $("<td class='data divide'></td>");
									tr.append(td.append(input));
									break;
							}
						}
					});
					
					$("<td><button class='btn btn-xs btn-primary modifyBtn'>저장</button></td>").appendTo(tr);
					tr.appendTo($("#table tbody"));
				});
			},
			error : function() {
				alert("submit 실패");
			}
		});
		
		// 근태 정보 수정
		$(document).on("click", ".modifyBtn", function() {
			var td = $(this).parent().siblings();
			
			$.ajax({
				url : 'modifyAttendance.do',
				type : 'post',
				datatype : 'text',
				data : {'sseq' : td.parent().attr("id"),
						'date' : td.eq(0).children("input").val(),
						'mid' : td.eq(1).children("input").val(),
						'name' : td.eq(2).children("input").val(),
						'position' : td.eq(3).children("input").val(),
						'preOnWork' : td.eq(4).children("input").val(),
						'preOffWork' : td.eq(5).children("input").val(),
						'onWork' : td.eq(6).children("input").val(),
						'offWork' : td.eq(7).children("input").val(),
						'wage' : td.eq(8).children("input").val(),
						'memo' : td.eq(9).children("input").val()
				},
				success : function(data) {
					if($.trim(data) != "0") {
						alert("정보 수정 완료");
					} else {
						alert("정보 수정 실패");
					}
				},
				error:function(request,status,error){
			        alert("code:"+request.status+"\n\n"+"message:"+request.responseText+"\n\n"+"error:"+error);
		       }			
			});
		});
	});

</script>
<div id="content">
	<div class="container">
		<h2><b>근태 정보 조회</b></h2>
		<br><br>
		<div id="frm_div">
			<form id="frm" class="form-inline" action="searchAttendance.do" method="post">
								
				<!-- 매장 선택 -->
				<div class="form-group">
					<select id="store" class="form-control" name="store">
						<c:forEach items="${storeList}"  var="storeList" varStatus="status">
							<c:if test="${status.index==0}">
								<option selected="selected" value="${storeList.sid}">${storeList.name}</option>
							</c:if>
							<c:if test="${status.index!=0}">
								<option value="${storeList.sid}">${storeList.name}</option>
							</c:if>
						</c:forEach>
			  		</select>
		  		</div>
				&nbsp;
				
				<!-- 날짜 선택 -->
				<div class="form-group">
		  			<input class="form-control" type="text" id="startDatePicker" name="startDate" placeholder="근무기간(시작) 선택" required="required">
				</div>
				~
				<div class="form-group">
		  			<input class="form-control" type="text" id="endDatePicker" name="endDate" placeholder="근무기간(끝) 선택" required="required">
				</div>
				&nbsp;
				
				<!-- 카테고리 선택 -->
				<div class="form-group">
					<select class="form-control" name="category">
					    <option value="mid" selected="selected">아이디</option>
					    <option value="name">이름</option>
			  		</select>
		  		</div>
		  		
		  		<!-- 검색창 -->
		  		<div class="form-group">
					<div class="input-group">
	    				<input type="text" class="form-control" name="query">
	   					<div class="input-group-btn">
	   						<button class="btn btn-default" type="submit">검색</button>
	   					</div>
		  			</div>
		  		</div>
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
						<th>수정</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="attendanceList" items="${attendanceList}">
						<tr class="attendance_tr" id="${attendanceList.sseq}">
							<td class="divide" style="width: 100px">${attendanceList.date}<input type="hidden" name="date" value="${attendanceList.date}"></td>
							<td style="width: 60px">${attendanceList.mid}<input type="hidden" name="mid" value="${attendanceList.mid}"></td>
							<td style="width: 70px">${attendanceList.name}<input type="hidden" name="name" value="${attendanceList.name}"></td>
							<td class="divide" style="width: 80px">${attendanceList.position}<input type="hidden" name="position" value="${attendanceList.position}"></td>
							<td class="data"><input style="width: 60px" type="text" value="${attendanceList.preOnWork}"></td>
							<td class="data divide"><input style="width: 60px" type="text" value="${attendanceList.preOffWork}"></td>
							<td class="data"><input style="width: 60px" type="text" value="${attendanceList.onWork}">
								<c:if test="${attendanceList.onWorkState != '정상'}">
									(${attendanceList.onWorkState})
								</c:if>
							</td>
							<td class="data divide"><input style="width: 60px" type="text" value="${attendanceList.offWork}">
								<c:if test="${!empty attendanceList.offWork}">
									(${attendanceList.offWorkState})
								</c:if>
							</td>
							<td class="data divide">
								<c:if test="${attendanceList.date==today}">
									<input style="width: 60px" type="text" value="${attendanceList.wage}">
								</c:if>
								<c:if test="${attendanceList.date!=today}">
									${attendanceList.wage}
								</c:if>
							</td>
							<td class="data divide"><input style="width: 150px" type="text" value="${attendanceList.memo}"></td>
							<td><button class="btn btn-xs btn-primary modifyBtn">저장</button></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</div>