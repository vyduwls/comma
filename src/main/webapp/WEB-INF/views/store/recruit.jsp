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
		
		/* 회원 정보 수정 (날짜) */
		/* $(".joinDatePicker").datepicker({ */
		$(document).on("focus", ".joinDatePicker", function() {
			$(this).datepicker({
				dateFormat: "yy-mm-dd",
				changeMonth : true,
				changeYear : true,
				maxDate : 0,
				onClose: function( selectedDate ) {    
	                $(".resignDatePicker").datepicker("option", "minDate", selectedDate);
	            } 
			});
		});
		$(document).on("focus", ".resignDatePicker", function() {
			$(this).datepicker({
				dateFormat: "yy-mm-dd",
				changeMonth : true,
				changeYear : true,
				onClose: function( selectedDate ) { 
	                $(".joinDatePicker").datepicker("option", "maxDate", selectedDate);
	            } 
			});
		});
		$(document).on("focus", ".birthDatePicker", function() {
			$(this).datepicker({
				dateFormat: "yy-mm-dd",
				changeMonth : true,
				changeYear : true,
				maxDate : 0
			});
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
					$("#table tbody .recruit_tr").remove();
					
					/* 테이블 갱신 */
					$.each(test, function(index,item) {
						var tr = $("<tr class='recruit_tr'></tr>");
						
						$.each(item, function(key,value) {
							if(key!="rid" && key!="sid") {
								switch(key) {
									case "mid" :
										var input = $("<input type='hidden' name='mid'>").val(value);
										var td = $("<td class='data'></td>").text(value);
										tr.append(td.append(input));
										break;
									case "pwd" :
										var input = $("<input style='width: 50px' type='text' name='pwd'>").val(value);
										var td = $("<td class='data'></td>");
										tr.append(td.append(input));
										break;
									case "name" :
										var input = $("<input style='width: 50px' type='text' name='name'>").val(value);
										var td = $("<td class='data'></td>");
										tr.append(td.append(input));
										break;
									case "position" :
										var input = $("<input style='width: 50px' type='text' name='position'>").val(value);
										var td = $("<td class='data'></td>");
										tr.append(td.append(input));
										break;
									case "phone" :
										var input = $("<input style='width: 110px' type='text' name='phone'>").val(value);
										var td = $("<td class='data'></td>");
										tr.append(td.append(input));
										break;
									case "birth" :
										var input = $("<input class='birthDatePicker' style='width: 80px' type='text' name='birth'>").val(value);
										var td = $("<td class='data'></td>");
										tr.append(td.append(input));
										break;
									case "address" :
										var input = $("<input style='width: 300px' type='text' name='address'>").val(value);
										var td = $("<td class='data'></td>");
										tr.append(td.append(input));
										break;
									case "wage" :
										var input = $("<input style='width: 45px' type='text' name='wage'>").val(value);
										var td = $("<td class='data'></td>");
										tr.append(td.append(input));
										break;
									case "joinDate" :
										var input = $("<input class='joinDatePicker' style='width: 80px' type='text' name='joinDate'>").val(value);
										var td = $("<td class='data'></td>");
										tr.append(td.append(input));
										break;
									case "resignDate" :
										var input = $("<input class='resignDatePicker' style='width: 80px' type='text' name='resignDate'>").val(value);
										var td = $("<td class='data'></td>");
										tr.append(td.append(input));
										break;
								}						
							}
						});
						
						$("<td><button class='btn btn-xs btn-primary modifyBtn'>수정</button></td>").appendTo(tr);
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
				$("#table tbody .recruit_tr").remove();
				
				/* 테이블 갱신 */
				$.each(test, function(index,item) {
					var tr = $("<tr class='recruit_tr'></tr>");
					
					$.each(item, function(key,value) {
						if(key!="rid" && key!="sid") {
							switch(key) {
								case "mid" :
									var input = $("<input type='hidden' name='mid'>").val(value);
									var td = $("<td class='data'></td>").text(value);
									tr.append(td.append(input));
									break;
								case "pwd" :
									var input = $("<input style='width: 50px' type='text' name='pwd'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
								case "name" :
									var input = $("<input style='width: 50px' type='text' name='name'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
								case "position" :
									var input = $("<input style='width: 50px' type='text' name='position'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
								case "phone" :
									var input = $("<input style='width: 110px' type='text' name='phone'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
								case "birth" :
									var input = $("<input class='birthDatePicker' style='width: 80px' type='text' name='birth'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
								case "address" :
									var input = $("<input style='width: 300px' type='text' name='address'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
								case "wage" :
									var input = $("<input style='width: 45px' type='text' name='wage'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
								case "joinDate" :
									var input = $("<input class='joinDatePicker' style='width: 80px' type='text' name='joinDate'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
								case "resignDate" :
									var input = $("<input class='resignDatePicker' style='width: 80px' type='text' name='resignDate'>").val(value);
									var td = $("<td class='data'></td>");
									tr.append(td.append(input));
									break;
							}						
						}
					});
					
					$("<td><button class='btn btn-xs btn-primary modifyBtn'>수정</button></td>").appendTo(tr);
					tr.appendTo($("#table tbody"));
				});
			},
			error : function() {
				alert("submit 실패");
			}
		});
		
		/* 엑셀로 다운로드하기 */
		$("#toExcelButton").click(function(e) {
			window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('.sticky-table').html()));
			e.preventDefault();
		});
		
		
		$(document).on("click", ".modifyBtn", function() {
			var td = $(this).parent().siblings();
			
			$.ajax({
				url : 'modifyRecruit.do',
				type : 'post',
				datatype : 'text',
				data : {'mid' : td.eq(0).children("input").val(),
						'pwd' : td.eq(1).children("input").val(),
						'name' : td.eq(2).children("input").val(),
						'position' : td.eq(3).children("input").val(),
						'phone' : td.eq(4).children("input").val(),
						'birth' : td.eq(5).children("input").val(),
						'address' : td.eq(6).children("input").val(),
						'wage' : td.eq(7).children("input").val(),
						'joinDate' : td.eq(8).children("input").val(),
						'resignDate' : td.eq(9).children("input").val()
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
	<div id="inner_content" class="container">
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
		
		<div class="col-lg-12 sticky-table sticky-headers sticky-ltr-cells">
			<table id="table" class="table">
				<thead>
					<tr class="sticky-row">
						<th>아이디</th>
						<th>비밀번호</th>
						<th>이름</th>
						<th>직급</th>
						<th>전화번호</th>
						<th>생년월일</th>
						<th>주소</th>
						<th>시급</th>
						<th>입사일</th>
						<th>퇴사일</th>
						<th>수정</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${employeeList}" var="employeeList">
						<tr class="recruit_tr">
							<td class="data">${employeeList.mid}<input type="hidden" name="mid" value="${employeeList.mid}"></td>
							<td class="data"><input style="width: 50px" type="text" name="pwd" value="${employeeList.pwd}"></td>
							<td class="data"><input style="width: 50px" type="text" name="name" value="${employeeList.name}"></td>
							<td class="data"><input style="width: 50px" type="text" name="position" value="${employeeList.position}"></td>
							<td class="data"><input style="width: 110px" type="text" name="phone" value="${employeeList.phone}"></td>
							<td class="data"><input class="birthDatePicker" style="width: 80px" type="text" name="birth" value="${employeeList.birth}"></td>
							<td class="data"><input style="width: 300px" type="text" name="address" value="${employeeList.address}"></td>
							<td class="data"><input style="width: 45px" type="text" name="wage" value="${employeeList.wage}"></td>
							<td class="data"><input class="joinDatePicker" style="width: 80px" type="text" name="joinDate" value="${employeeList.joinDate}"></td>
							<td class="data"><input class="resignDatePicker" style="width: 80px" type="text" name="resignDate" value="${employeeList.resignDate}"></td>
							<td><button class="btn btn-xs btn-primary modifyBtn">저장</button></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>		
		</div>	
	</div>
</div>