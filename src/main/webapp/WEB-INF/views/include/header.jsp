<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<script type="text/javascript">
	$(document).ready(function() {
		
		// 출근하기
		$("#onWork").click(function() {
			$.ajax({
				url : 'customer/onWork.do',
				type : 'post',
				datatype : 'text',
				data : {'rid' : '${sessionScope.mid}'},
				success : function(data) {
					if($.trim(data)=="1") {
						alert("출근 완료");
					} else {
						alert("출근 실패");
					}
				}
			});
		});
		
		// 퇴근하기
		$("#offWork").click(function() {
			$.ajax({
				url : 'customer/offWork.do',
				type : 'post',
				datatype : 'text',
				data : {'rid' : '${sessionScope.mid}'},
				success : function(data) {
					if($.trim(data)=="1") {
						alert("퇴근 완료");
					} else {
						alert("퇴근 실패");
					}
				}
			});
		});
	});
</script>


<!-- 네비바 -->
<nav class="navbar navbar-collapse navbar-inverse navbar-fixed-top">
	<div class="container-fluid">
		<div class="navbar-header col-lg-1">
			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target="#myNavbar">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.do"><b>ALBAMAN</b></a>
		</div>
		
		<div class="col-lg-1"></div>

		<!-- 상단 메뉴 -->
		<div class="menubar col-lg-9">
			<ul>
				<li class="col-lg-2"><a href="store/recruit.do">인사 관리</a>
					<ul class="col-lg-12">
						<li><a href="store/addRecruit.do">직원 정보 등록</a></li>
						<li><a href="store/recruit.do">직원 정보 조회</a></li>
					</ul>
				</li>
				<li class="col-lg-2"><a href="store/calendar.do">스케줄 관리</a>
					<ul class="col-lg-12">
						<li><a href="store/editSchedule.do">스케줄 등록</a></li>
						<li><a href="store/calendar.do">스케줄 조회</a></li>
					</ul>
				</li>
				<c:if test="${checkPosition==1}">
					<li class="col-lg-2"><a href="store/salaryManage.do">급여 관리</a>
						<ul class="col-lg-12">
							<li><a href="store/salaryManage.do">급여 조회</a></li>
						</ul>
					</li>
				</c:if>
				<c:if test="${checkPosition==2}">
					<li class="col-lg-2"><a href="store/checkSalary.do">급여 관리</a>
						<ul class="col-lg-12">
							<li><a href="store/checkSalary.do">급여 조회</a></li>
						</ul>
					</li>
				</c:if>
				<li class="col-lg-2"><a href="store/attendance.do">근태 관리</a></li>
				
				<li class="col-lg-2"><a href="">공지사항 관리</a>
					<ul class="col-lg-12">
						<li><a href="">공지사항 등록</a></li>
						<li><a href="">공지사항 조회</a></li>
					</ul>
				</li>
			</ul>
		</div>
		
		<!-- 회원 관련 -->
		<div class="collapse navbar-collapse col-lg-1" id="myNavbar">
			<div class="menubar">
				<ul class="navbar-right">
					<c:if test="${empty member.mid}">
						<li><a><span class="glyphicon glyphicon-user"></span> GUEST</a>
							<ul class="col-lg-12">
								<li><a id="login" style="cursor: pointer;">로그인</a></li>
								<li><a id="join" style="cursor: pointer;">회원가입</a></li>
							</ul></li>
					</c:if>

					<!-- 로그인 후 -->
					<c:if test="${!empty member.mid}">
						<li><a><span class="glyphicon glyphicon-user"></span> ${sessionScope.mid} 님</a>
							<ul class="col-lg-12">
								<c:choose>
									<c:when test="${member.position == '관리자'}">
										<li><a href="admin/adminPage.do">관리페이지</a></li>
									</c:when>
									<c:when test="${member.position == '점주'}">
										<li><a href="">마이페이지</a></li>
									</c:when>
									<c:when test="${onWork != 0}">
										<li><a id="onWork" style="cursor: pointer;">출근하기</a></li>
									</c:when>
									<c:when test="${offWork != 0}">
										<li><a id="offWork" style="cursor: pointer;">퇴근하기</a></li>
									</c:when>
								</c:choose>
								<li><a href="customer/logout.do">로그아웃</a></li>
							</ul>
						</li>
					</c:if>
				</ul>
			</div>
		</div>
	</div>
</nav>

<div id="banner" class="container-fluid">
	<div id="banner-content" class="container-fluid">
		<div id="banner-info" class="col-lg-offset-6 col-lg-6">
			<h1>ALBAMAN과 함께 스케줄 관리부터 급여 정산까지!</h1>
			<h3>( 인사 관리 / 스케줄 관리 / 급여 정산 / 커뮤니케이션 )</h3>
		</div>
	</div>
</div>