<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
$(document).ready(function() {
// 	$("#store").change(function() {
// 		var sid = $("#store option:selected").val();
// 		location.href="notice.do?sid=" + sid;
// 	});
});

</script>


<div id="content">
	<div class="container">
		<h2><b>문의사항</b></h2>
		<br><br>
		
		<div id="frm_div">
			<form id="frm" class="form-inline" action="qna.do" method="get">

				
		  		<!-- 검색창 -->
		  		<div class="form-group" style="float: right;">
					<div class="input-group">
	    				<input type="text" class="form-control" name="query" value="${query}">
	   					<div class="input-group-btn">
	   						<button class="btn btn-default" type="submit">검색</button>
	   					</div>
		  			</div>
		  		</div>
				<!-- 문의 내용 선택 -->
				<div class="form-group" style="float: right;">
					<select class="form-control" name="category">
					    <option value="title" ${category=="title" ? "selected" : ""}>제목</option>
					    <option value="content" ${category=="content" ? "selected" : ""}>내용</option>
			  		</select>
		  		</div>
		  		
			</form>
		</div>
		
		<div>
			<table class="table table-bordered" id="notice_table">
				<thead>
					<tr>
						<th class="col-lg-1 active">No.</th>
						<th class="col-lg-9 active">제목</th>
						<th class="col-lg-2 active">등록일</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="qnaList" items="${qnaList}" varStatus="n">
						<tr>
							<td>${n.index+1}</td>
							<td><a href="qnaDetail.do?no=${n.index+1}&qseq=${qnaList.qseq}&category=${category}&query=${query}&pg=${pg}">${qnaList.title}</a></td>
							<td>${qnaList.regDate}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<!-- Pagination -->
		<div style="text-align: center; margin-top: -10px">
		<c:if test="${checkPosition=='1'}">	
			<div style="float: right">
				<a class="btn btn-primary" href="addQna.do">글쓰기</a>
			</div>
		</c:if>
			<div class="row">
				<nav aria-label="Page navigation">
					<ul class="pagination pagination-sm">
						<c:if test="${startPage!=1}">
							<li id="btnPrev">
								<a class="btn btn-default" href="notice.do?pg=
								<%-- <c:if test="${startPage==1}">${startPage}</c:if> --%>
								<c:if test="${startPage!=1}">${startPage-1}</c:if>
								&sid=${sid}&category=${category}&query=${query}" aria-label="Previous"> <span aria-hidden="true">«</span></a></li>
						</c:if>
						
						<c:forEach var="i" begin="0" end="4">
							<c:if test="${startPage+i <= lastPage}">
								<c:if test="${pg == startPage+i}">
									<li><a class="strong">${startPage+i}</a></li>
								</c:if>
								<c:if test="${pg != startPage+i}">
									<li><a class="btn btn-default" href="qna.do?pg=${startPage+i}&category=${category}&query=${query}">${startPage+i}</a></li>
								</c:if>
							</c:if>
						</c:forEach>

						<c:if test="${startPage+4 < lastPage}">
							<li id="btnNext"><a class="btn btn-default" href="qna.do?pg=${startPage+5}&category=${category}&query=${query}" aria-label="Next"> <span aria-hidden="true">»</span></a></li>
						</c:if>

					</ul>
				</nav>
			</div>
		</div>
 		
	</div>
</div>