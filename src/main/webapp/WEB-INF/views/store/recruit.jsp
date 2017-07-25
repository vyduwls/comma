<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
	$(document).ready(function() {
		$("#joindatePicker").datepicker({
			dateFormat: "yy-mm-dd",
			changeMonth : true,
			changeYear : true,
			maxDate : 0,
			onClose: function( selectedDate ) {    
                $("#resigndatePicker").datepicker("option", "minDate", selectedDate);
            } 
		});
		
		$("#resigndatePicker").datepicker({
			dateFormat: "yy-mm-dd",
			changeMonth : true,
			changeYear : true,
			maxDate : 0,
			onClose: function( selectedDate ) { 
                $("#joindatePicker").datepicker("option", "maxDate", selectedDate);
            } 
		});
	});

</script>
<div id="content">
	<div class="container">
		<h2><b>직원 정보 조회</b></h2>
		<br><br>
		<div style="float: right">
			<form class="form-inline" action="" method="post">
								
				<!-- 매장 선택 -->
				<div class="form-group">
					<select class="form-control" name="store">
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
				
				<!-- 날짜 선택 -->
				<div class="form-group">
		  			<input class="form-control" type="text" id="joindatePicker" name="joindate" placeholder="입사일 선택">
				</div>
				<div class="form-group">
		  			<input class="form-control" type="text" id="resigndatePicker" name="resigndate" placeholder="퇴사일 선택">
				</div>
				
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
				<button type="button" class="btn btn-success" onClick="javascript:self.location='addRecruit.do'">직원 등록</button>
			</form>
		</div>
		
		<table id="recruitList" class="table">
			<thead>
				<tr>
					<th>이름</th>
					<th>아이디</th>
					<th>비밀번호</th>
					<th>직급</th>
					<th>전화번호</th>
					<th>생년월일</th>
					<th>주소</th>
					<th>시급</th>
					<th>입사일</th>
					<th>퇴사일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${employeeList}" var="employeeList">
					<tr>
						<td>${employeeList.name}</td>
						<td>${employeeList.mid}</td>
						<td>${employeeList.pwd}</td>
						<td>${employeeList.position}</td>
						<td>${employeeList.phone}</td>
						<td>${employeeList.birth}</td>
						<td>${employeeList.address}</td>
						<td>${employeeList.wage}</td>
						<td>${employeeList.joinDate}</td>
						<td>${employeeList.resignDate}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<div style="text-align: center">
			<ul class="pagination">
				<li><a href="#" aria-label="Previous"> <span aria-hidden="true">«</span></a></li>
				<li><a href="#">1</a></li>
				<li><a href="#">2</a></li>
				<li><a href="#">3</a></li>
				<li><a href="#">4</a></li>
				<li><a href="#">5</a></li>
				<li><a href="#" aria-label="Next"> <span aria-hidden="true">»</span></a></li>
			</ul>
		</div>
	</div>
</div>