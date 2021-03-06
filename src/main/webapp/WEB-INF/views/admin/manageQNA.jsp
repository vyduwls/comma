<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
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
		
		<div id="admin-content" class="col-lg-9">
		
			<!-- 검색창 -->
			<div id="frm_div">
				<form id="frm" class="form-inline" action="manageQNA.do" method="get">
					
					<!-- 카테고리 선택 -->
					<div class="form-group">
						<select class="form-control" name="category">
						    <option value="title" ${category=="title" ? "selected" : ""}>제목</option>
						    <option value="content" ${category=="content" ? "selected" : ""}>내용</option>
						    <option value="mid" ${category=="mid" ? "selected" : ""}>작성자</option>
				  		</select>
			  		</div>
			  		
			  		<!-- 검색창 -->
			  		<div class="form-group">
						<div class="input-group">
		    				<input type="text" class="form-control" name="query" value="${query}">
		   					<div class="input-group-btn">
		   						<button class="btn btn-default" type="submit">검색</button>
		   					</div>
			  			</div>
			  		</div>
				</form>
			</div>
			
			<!-- 문의 게시판 -->
			<div>
				<table class="table table-bordered" id="qna_table">
					<thead>
						<tr>
							<th class="col-lg-1 active">No.</th>
							<th class="col-lg-7 active">제목</th>
							<th class="col-lg-2 active">작성자</th>
							<th class="col-lg-2 active">등록일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="qnaList" items="${qnaList}">
							<tr>
								<td>${qnaList.qseq}</td>
								<td>
									<a href="../customer/qnaDetail.do?qseq=${qnaList.qseq}&category=${category}&query=${query}&pg=${pg}&returnURL=../admin/manageQNA.do">${qnaList.title}</a>
									<c:if test="${qnaList.comment!=0}">
										<span style="font-size: 9px; font-weight: lighter; color: red; vertical-align: middle;">완료</span>
									</c:if>
								</td>
								<td>${qnaList.mid}</td>
								<td>${qnaList.regDate}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<!-- Pagination -->
			<div style="text-align: center; margin-top: -10px">
				<div class="row">
					<nav aria-label="Page navigation">
						<ul class="pagination pagination-sm">
							<c:if test="${startPage!=1}">
								<li id="btnPrev">
									<a class="btn btn-default" href="manageQNA.do?pg=
									<c:if test="${startPage!=1}">${startPage-1}</c:if>
									&category=${category}&query=${query}" aria-label="Previous"> <span aria-hidden="true">«</span></a></li>
							</c:if>
							
							<c:forEach var="i" begin="0" end="4">
								<c:if test="${startPage+i <= lastPage}">
									<c:if test="${pg == startPage+i}">
										<li><a class="strong">${startPage+i}</a></li>
									</c:if>
									<c:if test="${pg != startPage+i}">
										<li><a class="btn btn-default" href="manageQNA.do?pg=${startPage+i}&category=${category}&query=${query}">${startPage+i}</a></li>
									</c:if>
								</c:if>
							</c:forEach>
	
							<c:if test="${startPage+4 < lastPage}">
								<li id="btnNext"><a class="btn btn-default" href="manageQNA.do?pg=${startPage+5}&category=${category}&query=${query}" aria-label="Next"> <span aria-hidden="true">»</span></a></li>
							</c:if>
						</ul>
					</nav>
				</div>
			</div>
		</div>
	</div>
</div>
