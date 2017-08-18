<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<div id="content">
	<div id="inner_content" class="container">
		<h2><b>문의 게시판</b></h2>
		<br><br>
		
		<!-- 사이드바 -->
		<div id="side" class="col-lg-3" style="height: 800px">
			<div class="profile">
				<!-- 프로필 버튼 -->
				<div class="button">
					<a id="manageMember" type="button" class="btn btn-block" 
						href="${pageContext.request.contextPath}/admin/manageMember.do">회원 관리</a>
					<a id="manageStore" type="button" class="btn btn-block" 
						href="${pageContext.request.contextPath}/admin/manageStore.do">점포 관리</a> 
					<a id="manageQNA" type="button" class="btn btn-block" style="border-left: 3px solid rgb(66,133,244)"
						href="${pageContext.request.contextPath}/admin/manageQNA.do">문의 게시판</a> 
				</div>
			</div>
		</div>
		
		<div id="admin-content" class="col-lg-9" style="height: 800px; border: 1px solid lightGrey">
			<h1>CONTENT 들어갈 자리</h1>
		</div>
	</div>
</div>