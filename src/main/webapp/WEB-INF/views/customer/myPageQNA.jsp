<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
	$(document).ready(function(){
		$("#memberModify").click(function(){
			
		})
	});
</script>

<div id="body" class="container">

	<div id="body-title" class="col-lg-12">
		<h3 id="body-title"
			><b>마이 페이지</b>
		</h3>
	</div>


	<!-- 사이드바 -->
	<div id="side" class="col-lg-3" style="height: 800px">
		<div class="profile" style="margin-top:52px;">
			<!-- 프로필 버튼 -->
			<div class="button">
				<a id="myPage" type="button" class="btn btn-default btn-block"
					href="${pageContext.request.contextPath}/customer/modifyMember.do">회원정보수정</a>
				<a id="message" type="button" class="btn btn-default btn-block"
					href="${pageContext.request.contextPath}/customer/myPage.do" >가게 정보 등록/변경
				</a> <a id="modify" type="button" class="btn btn-default btn-block myPage-active"
					href="${pageContext.request.contextPath}/customer/myPageQNA.do">문의사항</a> 
			</div>
		</div>
	</div>
	
	
<div class="tab-content">
	<a href="qna.do"  style="font-size: 13px;margin:0px 0px 20px 66%;">QNA 바로가기>></a>
	<b style="margin-left:33%; font-size: 17px;">답글이 완료된 문의사항</b>
		<!-- 게시글 리스트 -->
	<div id="sell" >
			<div class="col-lg-9" style="height: 600px; overflow: auto">
				<table class="table table-hover">
					<thead>
						<tr>
						<th class="col-lg-2" style="text-align: center;">NO.</th>
						<th class="col-lg-6" style="text-align: center;">제목</th>
						<th class="col-lg-2" style="text-align: center;">작성자</th>
						<th class="col-lg-2" style="text-align: center;">등록일</th>
						</tr>
					</thead>
					<tbody>
					<c:if test="${!empty qnaList}">
						<c:forEach items="${qnaList}" var="qna" varStatus="n">
							<tr class="store_tr" style="cursor: pointer;">
								<td class="storeTd">${n.index+1}</td>
								<td class="storeTd"><a href="qnaDetail.do?no=${n.index+1}&qseq=${qna.qseq}&pg=${pg}">${qna.title}</a></td>
								<td class="storeTd">${qna.mid}</td>
								<td class="storeTd">${qna.regDate}</td>
							</tr>
							<tr class="store_tr" style="cursor: pointer;">
								<td class="storeTd"> </td>
								<td class="storeTd"><a href="reQNADetail.do?no=${n.index+1}&cseq=${qna.cseq}&pg=${pg}">L답글입니다.</a></td>
								<td class="storeTd">admin</td>
								<td class="storeTd">${qna.reDate}</td>
							</tr>
						</c:forEach>
					</c:if>
					</tbody>
				</table>
				<div class="row">
				<nav aria-label="Page navigation">
					<ul class="pagination pagination-sm">
						<c:if test="${startPage!=1}">
							<li id="btnPrev">
								<a class="btn btn-default" href="myPageQNA.do?pg=
								<c:if test="${startPage!=1}">${startPage-1}</c:if>
								" aria-label="Previous"> <span aria-hidden="true">«</span></a></li>
						</c:if>
						<c:forEach var="i" begin="0" end="4">
							<c:if test="${startPage+i <= lastPage}">
								<c:if test="${pg == startPage+i}">
									<li><a class="strong">${startPage+i}</a></li>
								</c:if>
								<c:if test="${pg != startPage+i}">
									<li><a class="btn btn-default" href="myPageQNA.do?pg=${startPage+i}">${startPage+i}</a></li>
								</c:if>
							</c:if>
						</c:forEach>
						<c:if test="${startPage+4 < lastPage}">
							<li id="btnNext"><a class="btn btn-default" href="myPageQNA.do?pg=${startPage+5}" aria-label="Next"> <span aria-hidden="true">»</span></a></li>
						</c:if>
					</ul>
				</nav>
				</div>
			</div>
		</div>
	</div>
</div>
