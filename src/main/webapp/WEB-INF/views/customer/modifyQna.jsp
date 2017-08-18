<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.6/summernote.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.6/summernote.js"></script>
<script src="lang/summernote-ko-KR.js"></script>

<script>
	$(document).ready(function() {
		if("${modify}" == "fail") {
			alert("공지사항 수정 실패");
		}
	});
</script>

<div id="content">
	<div class="container">
		<h2><b>공지사항 수정</b></h2>
		<br><br>
		
		<form action="modifyNotice.do" method="post" enctype="multipart/form-data">
			<div>			
				<!-- 제목 -->
				<div>
					<label>제목 (${store.name})</label>
					<input type="hidden" name="sid" value="${store.sid}">
					<input type="text" class="form-control" name="title" value="${notice.title}">
				</div>
				
				<!-- 내용 -->
				<div style="margin-top: 17px">
					<label>내용</label>
				</div>
				<textarea id="summernote" name="content">${notice.content}</textarea>
				<script type="text/javascript">
				    $(document).ready(function() {
				        $('#summernote').summernote({
				        	height: 300,
				        	lang : 'ko-KR'
				        });
				        $('textarea[name="content"]').html($('#summernote').code());
				    });
				</script>
				
				<!-- 파일 첨부 -->
				<div>
					<label>파일 첨부</label>
					<!-- 보안상의 이유로 file은 read-only다. 따라서 value값을 불러올 수 없음 -->
					<input id="file" class="form-control" type="file" name="file">
				</div>
				
				<!-- 넘겨줘야 할 데이터 -->
				<input type="hidden" name="category" value="${category}">
				<input type="hidden" name="query" value="${query}">
				<input type="hidden" name="pg" value="${pg}">
				
				<!-- 버튼 -->
				<div id="btn-group" style="margin-top: 20px">
					<button class="btn btn-primary" type="submit">수정</button>
					<!-- 뒤로가기를 해서 sid,category,query 등 데이터 안 넘겨줘도 가능 -->
					<a class="btn btn-default" href="javascript:history.go(-1)">취소</a>
				</div>
			</div>
		</form>
	</div>
</div>