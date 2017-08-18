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
				<a id="myPage" type="button" class="btn btn-default btn-block "
					href="${pageContext.request.contextPath}/customer/modifyMember.do">회원정보수정</a>
				<a id="message" type="button" class="btn btn-default btn-block myPage-active"
					href="${pageContext.request.contextPath}/customer/myPage.do" >가게 정보 등록/변경
				</a> <a id="modify" type="button" class="btn btn-default btn-block"
					href="${pageContext.request.contextPath}/customer/myPageQNA.do">문의사항</a> 
			</div>
		</div>
	</div>
	
	
<div class="tab-content">
	<b style="margin-left:34%; font-size: 17px;">가게 List</b>
	<a href="addStore.do" class="btn btn-default" style="font-size: 13px;margin:0px 0px 10px 66%;">가게 등록</a>
		<!-- 게시글 리스트 -->
	<div id="sell" >
			<div class="col-lg-9" style="height: 600px; overflow: auto">
				<table class="table table-hover">
					<thead>
						<tr>
						<th class="col-lg-2" style="text-align: center;">가게명</th>
						<th class="col-lg-3" style="text-align: center;">주소</th>
						<th class="col-lg-2" style="text-align: center;">전화번호</th>
						<th class="col-lg-2" style="text-align: center;">ip</th>
						<th class="col-lg-2" style="text-align: center;">등록일</th>
						<th class="col-lg-1" style="text-align: center;">수정</th>
						</tr>
					</thead>
					<tbody>
					<c:if test="${!empty storeList}">
						<c:forEach items="${storeList}" var="n">
							<tr class="store_tr" style="cursor: pointer;">
								<td class="storeTd">${n.name}</td>
								<td class="storeTd">${n.address}</td>
								<td class="storeTd">${n.storeNumber}</td>
								<td class="storeTd">${n.ip}</td>
								<td class="storeTd">${n.regDate}</td>
								<td class="storeTd">
								<a href="modifyStore.do?sid=${n.sid}" class="btn btn-primary" style="font-size: 13px;">수정</a>
								</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${empty storeList}">
							<tr class="store_tr">
								<td class="storeTd">-</td>
								<td class="storeTd">-</td>
								<td class="storeTd">-</td>
								<td class="storeTd">-</td>
								<td class="storeTd">-</td>
								<td class="storeTd">-</td>
							</tr>
					</c:if>
					</tbody>
				</table>
			</div>
		</div>
		</div>
	</div>
