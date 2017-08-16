<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
	$(document).ready(function() {
		$("#birthdayPicker").datepicker({
			dateFormat: "yy-mm-dd",
			changeMonth : true,
			changeYear : true,
			maxDate : 0
		});
		
		$("#joindatePicker").datepicker({
			dateFormat: "yy-mm-dd",
			changeMonth : true,
			changeYear : true,
			minDate : 0
		});
		
		$("#createId").click(function() {
			$.ajax({
				url : 'createId.do',
				type : 'post',
				datatype : 'text',
				data : {'sid' : $("#store option:selected").val()},
				success : function(data) {
					if ($.trim(data) != "" || $.trim(data) != null) {
						$('input[name=mid]').val($.trim(data));
					} else {
						alert("사원번호 발급 실패");
					}
				}
			});
		});
	});

</script>
<div id="content">
	<div class="container">
		<h2><b>직원 정보 등록</b></h2>
		<br><br>
		<form action="addRecruit.do" method="post">
			<div class="col-lg-6">
				<div class="form-group" style="margin-bottom: 14px">
					<label>매장 선택</label> 
					<select class="form-control" name="store" id="store">
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
				<div class="form-group">
					<label>아이디(사원번호)</label> 
					<input type="button" class="btn btn-success btn-xs" style="float: right" id="createId" value="사원번호 발급">
					<input readonly="readonly" type="text" class="form-control" name="mid" placeholder="사원번호 발급 버튼을 누르세요." required="required">
				</div>
				<div class="form-group">
					<label>비밀번호</label> 
					<input type="password" class="form-control" name="pwd" placeholder="PWD" required="required">
				</div>
				<div class="form-group">
					<label>이름</label> 
					<input type="text" class="form-control" name="name" placeholder="NAME" required="required">
				</div>
				<div class="form-group">
					<label>전화번호</label> 
					<input type="text" class="form-control" name="phone" placeholder="- 를 포함하세요." required="required">
				</div>
				<div class="form-group">
					<label>이메일</label> 
					<input type="text" class="form-control" name="email" placeholder="EMAIl" required="required">
				</div>
			</div>
			
			<div class="col-lg-6">
				<div class="form-group">
					<label>직급</label> 
					<input type="text" class="form-control" name="position" placeholder="POSITION" required="required">
				</div>
				<div class="form-group">
					<label>생년월일</label>
					<input class="form-control" type="text" id="birthdayPicker" name="birth" placeholder="BIRTHDAY">
				</div>
				<div class="form-group">
					<label>주소</label> 
					<input type="text" class="form-control" name="address" placeholder="ADDRESS" required="required">
				</div>
				<div class="form-group">
					<label>시급</label> 
					<input type="text" class="form-control" name="wage" placeholder="WAGE" required="required">
				</div>
				<div class="form-group">
					<label>입사 예정일</label>
					<input class="form-control" type="text" id="joindatePicker" name="joinDate" placeholder="JOIN DATE">
				</div>

				<div class="form-group" style="float:right; margin-top: 14px">
					<input type="submit" class="btn btn-success" value="직원 등록하기">
					<button type="reset" class="btn btn-default">초기화하기</button>
				</div>
			</div>
			
		</form>
	</div>
</div>