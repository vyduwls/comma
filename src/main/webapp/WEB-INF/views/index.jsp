<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">
	$(document).ready(function() {
		
		/* 모달 */
		$("#login").click(function() {
			$("#modal-login").modal();
		});
		$("#join").click(function() {
			$("#modal-join").modal();
		});
		$("#goToFindPwd").click(function() {
			$("#modal-login").modal('toggle');
			$("#modal-findPwd").modal();
		});
		$("#goToJoin").click(function() {
			$("#modal-login").modal('toggle');
			$("#modal-join").modal();
		});
		$("#goToLogin").click(function() {
			$("#modal-join").modal('toggle');
			$("#modal-login").modal();
		});
		
		/* 로그인 */
		$("#loginButton").click(function() {
			$.ajax({
				url : 'customer/login.do',
				type : 'post',
				datatype : 'text',
				data : {
					'mid' : $("#modal-login-mid").val(),
					'pwd' : $("#modal-login-pwd").val()
				},
				success : function(data) {
					alert(data);
					if ($.trim(data) == "1") {
						alert("아이디나 비밀번호를 다시 확인해주세요.");
					} else {
						location.reload();
					}
				}/* ,
				error:function(request,status,error){
			        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		       } */
			});
		});
	});
</script>
		
<div id="content" class="container-fluid">
	<div id="introduce" class="container">
		
		<div id="introduce-header">
			<h1>ALBAMAN 제공 기능</h1>
			<h4>내가 없어도 우리 매장은 잘 돌아갈까?</h4>
			<h4>온라인으로 출퇴근 확인부터, 급여정산까지!</h4>
		</div>
		
		<div id="function-left" class="col-lg-2">
			<div>
				<h4>매장에서만 출근 가능</h4>
				<h5>직원들은 오직 매장에서만</h5> 
				<h5>출퇴근이 가능합니다.</h5>
			</div>
			<div>
				<h4>간편한 스케줄 관리</h4>
				<h5>간편하게 직원 스케줄을 </h5>
				<h5>관리하세요.</h5>
			</div>
			<div>
				<h4>급여 자동계산</h4>
				<h5>주휴수당, 야근수당이 포함된</h5>
				<h5>실급여 계산이 가능합니다.</h5>
			</div>
		</div>
		
		<div id="introduce-image" class="col-lg-8">
		</div>
		
		<div id="function-right" class="col-lg-2">
			<div>
				<h4>공지사항</h4>
				<h5>매장 내 중요한 사항을</h5>
				<h5>공지사항을 통해 전하세요.</h5>
			</div>
			<div>
				<h4>채팅</h4>
				<h5>이제 단톡방이 아닌</h5> 
				<h5>ALBAMAN에서 직원들과</h5>
				<h5>의사소통이 가능합니다.</h5>
			</div>
			<div>
				<h4>여러 매장 관리도 OK!</h4>
				<h5>여러 매장의 관리를</h5>
				<h5>알바맨에서 가능합니다.</h5>
			</div>
		</div>
	</div>
</div>