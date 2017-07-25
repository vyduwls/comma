<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
						<option value="" selected="selected">매장 1</option>
					    <option value="">매장 2</option>
					    <option value="">매장 3</option>
					    <option value="">매장 4</option>
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
				<tr>
					<td>심규진</td>
					<td>jin</td>
					<td>123</td>
					<td>직원</td>
					<td>010-3945-6685</td>
					<td>1991-12-04</td>
					<td>인천광역시 계양구 용종동 동아아파트 321동 703호</td>
					<td>6200원</td>
					<td>2017-07-11</td>
					<td>2017-08-11</td>
				</tr>
				
				<tr>
					<td>표여진</td>
					<td>pyo</td>
					<td>123</td>
					<td>직원</td>
					<td>010-5008-0449</td>
					<td>1993-10-17</td>
					<td>서울특별시 연신내 로데오거리 그 근처 어딘가 주택</td>
					<td>5400원</td>
					<td>2017-07-11</td>
					<td>2017-08-11</td>
				</tr>
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