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
		<h2><b>공지사항</b></h2>
		<br><br>
		
		<div>
			<table class="table table-bordered" id="notice_detail_table">
					<tr>
						<th style="width: 20px" class="active">No.</th>
						<td style="width: 20px">${notice.nseq}</td>
						<th style="width: 20px" class="active">제목</th>
						<td style="width: 200px">${notice.title}</td>
						<th style="width: 20px" class="active">등록일</th>
						<td style="width: 50px">${notice.regDate}</td>
					</tr>		
					<tr>
						<th style="width: 20px" class="active">내용</th>
						<td colspan="5">
							<div id="notice_detail_content">${notice.content}</div>
						</td>
					</tr>
					<tr>
						<th style="width: 20px" class="active">첨부</th>
						<td colspan="5"><a href="download.do?path=/WEB-INF/views/store/upload&fileName=${fileName}">${notice.file}</a></td>
					</tr>		
			</table>
			<div id="btn-group">
				<a class="btn btn-default btn-xs" href="notice.do?sid=${sid}&category=${category}&query=${query}&pg=${pg}">목록</a>
				<c:if test="${checkPosition=='1'}">
					<a class="btn btn-primary btn-xs" href="modifyNotice.do?nseq=${notice.nseq}&sid=${sid}&category=${category}&query=${query}&pg=${pg}">수정</a>
					<a class="btn btn-danger btn-xs" href="deleteNotice.do?nseq=${notice.nseq}&sid=${sid}&category=${category}&query=${query}&pg=${pg}">삭제</a>
				</c:if>
			</div>
		</div>
	</div>
</div>