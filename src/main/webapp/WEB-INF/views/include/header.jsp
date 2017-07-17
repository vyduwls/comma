<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="header">
	<div class="top-wrapper">
		<h1 id="logo">
		
			<!-- 
				★★ 메인의 타일들로 전부 통일하려고 상대경로를 절대경로로 변경
				그냥 경로만 바꾸면 문제가 생김(프로젝트명이 빠져있어서)
				=> el코드를 사용해서 프로젝트명을 얻어올 수 있음(예전에 프로젝트명 얻어오는 거는 했었음)
			-->
			<a href="${pageContext.request.contextPath}/index.do"><img src="${pageContext.request.contextPath}/images/logo.jpg" alt="SIST" /></a>
		</h1>
		<h2 class="hidden">메인메뉴</h2>
		<ul id="mainmenu" class="block_hlist">
			<li><a href="">정규과정</a></li>
			<li><a href="">취업과정</a></li>
			<li><a href="">서비스</a></li>
		</ul>
		<form id="searchform" action="" method="get">
			<fieldset>
				<legend class="hidden"> 과정검색폼 </legend>
				<label for="query">과정검색</label> <input type="text" name="query" />
				<input type="submit" class="button" value="검색" />
			</fieldset>
		</form>
		<h3 class="hidden">로그인메뉴</h3>
		<ul id="loginmenu" class="block_hlist">
			<li><a href="${pageContext.request.contextPath}/index.do">HOME</a></li>
			<c:if test="${!empty sessionScope.mid}">
				<li><a href="${pageContext.request.contextPath}/joinus/logout.do">로그아웃</a></li>
			</c:if>
			<c:if test="${empty sessionScope.mid}">
				<li><a href="${pageContext.request.contextPath}/joinus/login.do">로그인</a></li>
			</c:if>
				<li><a href="${pageContext.request.contextPath}/joinus/join.do">회원가입</a></li>
		</ul>
		<h3 class="hidden">회원메뉴</h3>
		<ul id="membermenu" class="clear">
			<li><a href="${pageContext.request.contextPath}/joinus/login.do"><img src="${pageContext.request.contextPath}/images/menuMyPage.png" alt="마이페이지" /></a>
			</li>
			<li><a href="${pageContext.request.contextPath}/customer/notice.do"><img
					src="${pageContext.request.contextPath}/images/menuCustomer.png" alt="고객센터" /></a></li>
		</ul>
	</div>
</div>