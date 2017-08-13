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
			<a class="navbar-brand" href="../index.do"><b>ALBAMAN</b></a>
		</div>
		
		<div class="col-lg-1"></div>

		<!-- 상단 메뉴 -->
		<div class="menubar col-lg-9">
			<ul>
				<li class="col-lg-2"><a href="recruit.do">인사 관리</a>
					<ul class="col-lg-12">
						<li><a href="addRecruit.do">직원 정보 등록</a></li>
						<li><a href="recruit.do">직원 정보 조회</a></li>
					</ul>
				</li>
				<li class="col-lg-2"><a href="calendar.do">스케줄 관리</a>
					<ul class="col-lg-12">
						<li><a href="editSchedule.do">스케줄 등록</a></li>
						<li><a href="calendar.do">스케줄 조회</a></li>
					</ul>
				</li>
				<c:if test="${checkPosition==1}">
					<li class="col-lg-2"><a href="salaryManage.do">급여 관리</a>
						<ul class="col-lg-12">
							<li><a href="salaryManage.do">급여 조회</a></li>
						</ul>
					</li>
				</c:if>
				<c:if test="${checkPosition==2}">
					<li class="col-lg-2"><a href="checkSalary.do">급여 관리</a>
						<ul class="col-lg-12">
							<li><a href="checkSalary.do">급여 조회</a></li>
						</ul>
					</li>
				</c:if>
				<li class="col-lg-2"><a href="attendance.do">근태 관리</a></li>
				
				<li class="col-lg-2"><a href="notice.do">공지사항</a></li>
			</ul>
		</div>
		
		<!-- 회원 관련 -->
		<div class="collapse navbar-collapse col-lg-1" id="myNavbar">
			<div class="menubar">
				<ul class="navbar-right">
					<!-- 로그인 후 -->
					<li><a><span class="glyphicon glyphicon-user"></span> ${sessionScope.mid} 님</a>
						<ul class="col-lg-12">
							<c:choose>
								<c:when test="${checkPosition == '0'}">
									<li><a href="admin/adminPage.do">관리페이지</a></li>
								</c:when>
								<c:when test="${checkPosition == '1'}">
									<li><a href="">마이페이지</a></li>
								</c:when>
								<c:when test="${checkPosition == '2' and onWork != 0}">
									<li><a id="onWork" style="cursor: pointer;">출근하기</a></li>
								</c:when>
								<c:when test="${checkPosition == '2' and offWork != 0}">
									<li><a id="offWork" style="cursor: pointer;">퇴근하기</a></li>
								</c:when>
							</c:choose>
							<li><a href="../customer/logout.do">로그아웃</a></li>
						</ul>
					</li>
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