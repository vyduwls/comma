<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
$(document).ready(function() {
	if("${delete}" == "fail") {
		alert("삭제 실패");
	}
});
</script>

<div id="content">
	<div class="container">
		<h2><b>문의사항</b></h2>
		<br><br>
		
		<div>
			<table class="table table-bordered" id="notice_detail_table">
					<tr>
						<th style="width: 20px" class="active">No.</th>
						<td style="width: 20px">${no}</td>
						<th style="width: 20px" class="active">제목</th>
						<c:if test="${comment=='no'}">
							<td style="width: 200px">${qna.title}</td>
						</c:if>
						<c:if test="${comment=='yes'}">
							<td style="width: 200px">L답글입니다.</td>
						</c:if>
						<th style="width: 20px" class="active">등록일</th>
						<td style="width: 50px">${qna.regDate}</td>
					</tr>		
					<tr>
						<th style="width: 20px" class="active">내용</th>
						<td colspan="5">
							<div id="notice_detail_content">${qna.content}</div>
						</td>
					</tr>
					<c:if test="${comment=='no'}">
						<tr>
							<th style="width: 20px" class="active">첨부</th>
							<td colspan="5"><a href="download.do?path=/WEB-INF/views/customer/upload&fileName=${fileName}">${qna.file}</a></td>
						</tr>		
					</c:if>
			</table>
			<div id="btn-group">
				<a class="btn btn-default btn-xs" href="qna.do?category=${category}&query=${query}&pg=${pg}">목록</a>
				<c:if test="${comment=='yes'}">
					<c:if test="${checkPosition=='0'}">
						<a class="btn btn-primary btn-xs" href="modifyQna.do?qseq=${qna.cseq}&category=${category}&query=${query}&pg=${pg}">수정</a>
						<a class="btn btn-danger btn-xs" href="deleteQna.do?qseq=${qna.cseq}&category=${category}&query=${query}&pg=${pg}">삭제</a>
					</c:if>
				</c:if>
				<c:if test="${comment=='no'}">
					<c:if test="${checkPosition=='1'}">
						<a class="btn btn-primary btn-xs" href="modifyQna.do?qseq=${qna.qseq}&category=${category}&query=${query}&pg=${pg}">수정</a>
						<a class="btn btn-danger btn-xs" href="deleteQna.do?qseq=${qna.qseq}&category=${category}&query=${query}&pg=${pg}">삭제</a>
					</c:if>
					<c:if test="${checkPosition=='0'}">
						<a class="btn btn-primary btn-xs" href="modifyQna.do?qseq=${qna.qseq}&category=${category}&query=${query}&pg=${pg}">답글</a>
						<a class="btn btn-danger btn-xs" href="deleteQna.do?qseq=${qna.qseq}&category=${category}&query=${query}&pg=${pg}">삭제</a>
					</c:if>
				</c:if>
			</div>
		</div>
	</div>
</div>