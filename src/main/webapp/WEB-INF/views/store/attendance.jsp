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
		
		/* 정보 수정 부분 */
		$(".data").click(function() {
			// input 태그가 없는 경우
			if($(this).children().length == 0) {
				var value = $(this).text();				
				$(this).html("<input class='form-control input-sm' type='text' value='" + value + "' />");
			}
		});
	});

</script>
<div id="content">
	<div class="container">
		<h2><b>근태 정보 조회</b></h2>
		<br><br>
		<div id="frm_div" style="float: right">
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
		  		
		  		<!-- 엑셀 다운로드 버튼 -->
				<button id="toExcelButton" class="btn btn-warning">엑셀 다운로드</button>	
			</form>
		</div>

		<div class="col-lg-12 sticky-table sticky-headers sticky-ltr-cells">
			<table id="table" class="table table-striped">
				<thead>
					<tr class="sticky-row">
						<th class="col-lg-2">날짜</th>
						<th class="col-lg-1">아이디</th>
						<th class="col-lg-1">이름</th>					
						<th class="col-lg-1">직급</th>
						<th class="col-lg-1">출근 시간</th>
						<th class="col-lg-1">퇴근 시간</th>
						<th class="col-lg-1">근태 상태</th>
						<th class="col-lg-3">비고</th>
						<th class="col-lg-1">수정</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="col-lg-2">2017-07-11</td>
						<td class="col-lg-1">4-2</td>
						<td class="col-lg-1">심규진</td>
						<td class="col-lg-1">직원</td>
						<td class="col-lg-1 data">17:07:15</td>
						<td class="col-lg-1 data">17:17:00</td>
						<td class="col-lg-1 data">출근</td>
						<td class="col-lg-3 data"></td>
						<td class="col-lg-1"><button class="btn btn-xs btn-primary modifyBtn">저장</button></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>