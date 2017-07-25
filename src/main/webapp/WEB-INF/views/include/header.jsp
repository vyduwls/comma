<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
						<li><a href="">스케줄 등록</a></li>
						<li><a href="">스케줄 조회</a></li>
					</ul>
				</li>
				<li class="col-lg-2"><a href="">급여 관리</a>
					<ul class="col-lg-12">
						<li><a href="">급여 조회</a></li>
					</ul>
				</li>
				<li class="col-lg-2"><a href="">공지사항 관리</a>
					<ul class="col-lg-12">
						<li><a href="">공지사항 등록</a></li>
						<li><a href="">공지사항 조회</a></li>
					</ul>
				</li>
				<li class="col-lg-2"><a href="">문의 게시판</a></li>
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
									<c:otherwise>
										<li><a href="">출근하기</a></li>
										<li><a href="">퇴근하기</a></li>
									</c:otherwise>
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