<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div id="footer" class="container-fluid">
	<div class="container">
		<div id="footer-company" class="col-lg-4">
			<h5>COMPANY</h5>
			<p>서비스 소개</p>
			<p>블로그</p>
			<p>언론보도</p>
		</div>

		<div id="footer-policies" class="col-lg-4">
			<h5>POLICIES</h5>
			<p><a href="">이용 약관</a></p>
			<p><a href="">결제 서비스 약관</a></p>
			<p><a href="">개인 정보 취급방침</a></p>
		</div>

		<div id="footer-support" class="col-lg-4">
			<h5>SUPPORT</h5>
			<p><a href="">Q & A</a></p>
		</div>
	</div>

	<div id="footer-certificate" class="col-lg-12">
		<p>© 2017 ALBAMAN. Inc.</p>
		<p>상호:(주)COMMA / 주소:서울특별시 마포구 백범로 18(노고산동) 미화빌딩 3층 쌍용강북교육센터 / 사업자등록번호:767-88-00630 / 대표자명:표여사</p>
	</div>
</div>

<!-- 로그인 모달창 -->
<div class="modal fade" id="modal-login" role="dialog">
	<div class="modal-dialog modal-md">
		<div class="modal-content">
			
			<div class="modal-header">
				<div class="container-fluid" style="padding-right: 5px">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				<div class="container-fluid" style="padding: 10px 0px 20px 0px">
					<h5>ALBAMAN에 오신 것을 환영해요!</h5>
					<p>ALBAMAN는 매장 관리가 가능한 온라인 플랫폼 서비스입니다.</p>
				</div>
			</div>
			
			<div class="modal-body" style="padding: 40px 50px;">
				<div class="form-group">
					<label>아이디</label> 
					<input type="text" class="form-control" id="modal-login-mid" name="mid" placeholder="ID" required="required">
				</div>
				<div class="form-group">
					<label>비밀번호</label> 
					<input type="password" class="form-control" id="modal-login-pwd" name="pwd" placeholder="PASSWORD" required="required">
				</div>
				<br>
				<button type="button" class="btn btn-info btn-block" id="loginButton">로그인</button>
			</div>
			
			<div class="modal-footer">
				<p>ALBAMAN 회원이 아닌가요?<a id="goToJoin" style="cursor: pointer"> 회원가입</a></p>
				<p>비밀번호가 기억나지 않나요?<a id="goToFindPwd" style="cursor: pointer"> 비밀번호 찾기</a></p>
			</div>
		</div>
	</div>
</div>

<!-- 회원가입 모달창 -->
<div class="modal fade" id="modal-join" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
		
			<div class="modal-header">
				<div class="container-fluid" style="padding-right: 5px">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				<div class="container-fluid" style="padding: 10px 0px 20px 0px">
					<h5>ALBAMAN 회원가입</h5>
					<p>회원으로 가입하시면 ALBAMAN의 모든 서비스를 이용하실 수 있습니다.</p>
				</div>
			</div>
			
			<div class="modal-body" style="padding: 40px 50px;">
				<form action="customer/join.do" method="post" onsubmit="return check()">
					<div class="form-group">
						<label>아이디</label> 
						<input type="button" class="btn btn-info btn-xs" style="float: right" id="checkId" value="중복 확인">
						<input type="text" class="form-control" id="modal-join-mid" name="mid" placeholder="ID" required="required">
					</div>

					<div class="form-group">
						<label>비밀번호</label>
						<input type="password" class="form-control" id="modal-join-pwd" name="pwd" placeholder="PASSWORD" required="required">
					</div>

					<div class="form-group">
						<label>비밀번호 확인</label>
						<input type="password" class="form-control" id="modal-join-pwdCheck" name="pwdCheck" placeholder="PASSWORD CHECK" required="required">
					</div>

					<div class="form-group">
						<label>이름</label>
						<input type="text" class="form-control" id="modal-join-name" name="name" placeholder="NAME" required="required">
					</div>

					<div class="form-group">
						<label>전화번호</label>
						<input type="text" class="form-control" id="modal-join-phone" name="phone" placeholder="PHONE NUMBER" required="required">
					</div>

					<div class="form-group">
						<label for="usremail">이메일</label>
						<input type="text" class="form-control" id="modal-join-email" name="email" placeholder="E-MAIL" required="required">
					</div>
					<br>
					<button id="joinButton" type="submit" class="btn btn-info btn-block">회원가입</button>
				</form>
			</div>
			
			<div class="modal-footer">
				<p>이미 ALBAMAN 회원인가요?<a id="goToLogin" style="cursor: pointer"> 로그인</a></p>
			</div>
		</div>
	</div>
</div>


<!-- 비밀번호찾기 모달창 -->
<div class="modal fade" id="modal-findPwd" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content">
		
			<div class="modal-header">
				<div class="container-fluid" style="padding-right: 5px">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				<div class="container-fluid" style="padding: 10px 0px 20px 0px">
					<h5>ALBAMAN 비밀번호 찾기</h5>
					<p>등록된 이메일을 통해 비밀번호를 찾으세요.</p>
				</div>
			</div>
			
			<div class="modal-body" style="padding: 40px 50px;">
				<div class="form-group">
					<label >아이디</label>
					<input type="text" class="form-control" id="modal-findPwd-mid" name="modal-findPwd-mid" placeholder="ID" required="required">
				</div>

				<div class="form-group">
					<label>이메일</label> 
					<input type="button" class="btn btn-info btn-xs" style="float: right" id="sendAuthentication" value="인증번호 받기">
					<input type="text" class="form-control" id="modal-findPwd-email" name="modal-findPwd-email" placeholder="E-MAIL" required="required">
				</div>

				<div class="form-group">
					<label>인증번호</label>
					<input type="text" class="form-control" id="modal-findPwd-authentication" name="modal-findPwd-authentication" placeholder="AUTHENTICATION NUMBER" required="required">
				</div>
				<br>
				<button id="findPwdButton" type="submit" class="btn btn-info btn-block">비밀번호 찾기</button>
			</div>
			
			<div class="modal-footer"></div>
		</div>
	</div>
</div>