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
				url : 'changeRecruit.do',
				type : 'post',
				datatype : 'json',
				data : {'sid' : $("#store option:selected").val()},
				success : function(data) {
					var result = $.trim(data);
					var test = JSON.parse(result);
					
					/* 테이블 초기화 */
					$("#recruitList tbody .recruit_tr").remove();
					
					/* 테이블 갱신 */
					$.each(test, function(index,item) {
						var tr = $("<tr class='recruit_tr'></tr>");
						
						$.each(item, function(key,value) {
							if(key!="rid" && key!="sid") {
								$("<td></td>").text(value).appendTo(tr);								
							}
						});
						
						tr.appendTo($("#recruitList tbody"));
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
				$("#recruitList tbody .recruit_tr").remove();
				
				/* 테이블 갱신 */
				$.each(test, function(index,item) {
					var tr = $("<tr class='recruit_tr'></tr>");
					
					$.each(item, function(key,value) {
						if(key!="rid" && key!="sid") {
							$("<td></td>").text(value).appendTo(tr);								
						}
					});
					
					tr.appendTo($("#recruitList tbody"));
				});
			},
			error : function() {
				alert("submit 실패");
			}
		});
		
		/* 엑셀로 다운로드하기 */
		$("#toExcelButton").click(function(e) {
			window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('#toExcel').html()));
			e.preventDefault();
		});
	});

</script>
<div id="content">
	<div class="container">
		<h2><b>직원 정보 조회</b></h2>
		<br><br>
		<div style="float: right">
			<form id="frm" class="form-inline" action="searchRecruit.do" method="post">
								
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
		  		&nbsp;
		  		&nbsp;
		  		
		  		<!-- 직원 등록 버튼 / 엑셀 다운로드 버튼 -->
				<button type="button" class="btn btn-success" onClick="javascript:self.location='addRecruit.do'">직원 등록</button>
				<button id="toExcelButton" class="btn btn-warning">엑셀 다운로드</button>	
			</form>
		</div>
		
		<div id="toExcel">
			<table id="recruitList" class="table table-bordered">
				<thead>
					<tr>
						<th>아이디</th>
						<th>비밀번호</th>
						<th>이름</th>
						<th>전화번호</th>
						<th>이메일</th>					
						<th>직급</th>
						<th>생년월일</th>
						<th>주소</th>
						<th>시급</th>
						<th>입사일</th>
						<th>퇴사일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${employeeList}" var="employeeList">
						<tr class="recruit_tr">
							<td>${employeeList.mid}</td>
							<td>${employeeList.pwd}</td>
							<td>${employeeList.name}</td>
							<td>${employeeList.phone}</td>
							<td>${employeeList.email}</td>
							<td>${employeeList.position}</td>
							<td>${employeeList.birth}</td>
							<td>${employeeList.address}</td>
							<td>${employeeList.wage}</td>
							<td>${employeeList.joinDate}</td>
							<td>${employeeList.resignDate}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>		
		</div>		
	</div>
</div>