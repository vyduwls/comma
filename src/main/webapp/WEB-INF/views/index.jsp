<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">

	/* 아이디 중복 검사 여부 확인 */
	var idCheck = 0;

	$(document).ready(function() {
		
		alert("<%=request.getRemoteAddr()%>");
		
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
		$("#modal-login-mid").keypress(function(key) {
			if(key.which == 13) {
				$("#loginButton").click();
			}
		});
		$("#modal-login-pwd").keypress(function(key) {
			if(key.which == 13) {
				$("#loginButton").click();
			}
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
					if ($.trim(data) == "1") {
						alert("아이디나 비밀번호를 다시 확인해주세요.");
					} else {
						location.reload();
					}
				} ,
				error:function(request,status,error){
			        alert("code:"+request.status+"\n\nmessage:"+request.responseText+"\n\nerror:"+error);
		       }
			});
		});
		
		/* 아이디 중복 확인 */
		$("#checkId").click(function() {
			$.ajax({
				url : 'customer/checkId.do',
				type : 'post',
				datatype : 'text',
				data : {
					'mid' : $("#modal-join-mid").val()
				},
				success : function(data) {
					if ($.trim(data) == "0") {
						idCheck = 1;
						alert("사용가능한 아이디입니다.");
					} else {
						alert("이미 존재하는 아이디입니다.");
					}
				}
			});
		});
		$("#modal-join-mid").change(function() {
			idCheck = 0;
		});
		
		// 인증번호 보내기
		$("#sendAuthentication").click(function() {
			$.ajax({
				url : 'customer/sendAuthentication.do',
				type : 'post',
				datatype : 'text',
				data : {'mid' : $("#modal-findPwd-mid").val(),
					'email' : $("#modal-findPwd-email").val()},
				success : function(data) {
					if ($.trim(data) == "1") {
						alert("인증번호가 발송되었습니다.");
					} else {
						alert("아이디 혹은 이메일이 일치하지 않습니다.");
					}
				}
			});
		});
		
		// 비밀번호 찾기
		$("#findPwdButton").click(function() {
			$.ajax({
				url : 'customer/findPwd.do',
				type : 'post',
				datatype : 'text',
				data : {'mid' : $("#modal-findPwd-mid").val(),
					'checkAuthNum' : $("#modal-findPwd-authentication").val()},
				success : function(data) {
					if ($.trim(data) == "1") {
						alert("인증번호가 일치하지 않습니다.");
					} else {
						alert("비밀번호는 " + $.trim(data) + " 입니다.");
						$("#modal-findPwd").modal('toggle');
					}
				}
			});
		});
	});
	
	/* 회원가입 검사 */
	function check() {
		if (idCheck != 1) {
			alert("아이디 중복 확인을 해주세요.");
			return false;
		}

		if ($("#modal-join-pwd").val() != $("#modal-join-pwdCheck").val()) {
			alert("비밀번호를 다시 확인해주세요.");
			return false;
		} else {
			alert("회원가입을 축하합니다!");
			return true;
		}
	}
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