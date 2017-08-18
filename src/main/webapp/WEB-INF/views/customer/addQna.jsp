<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.6/summernote.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.6/summernote.js"></script>
<script src="lang/summernote-ko-KR.js"></script>

<script>
	$(document).ready(function() {
		if("${add}" == "fail") {
			alert("문의사항 등록 실패");
		}
	});
</script>

<div id="content">
	<div class="container">
		<h2><b>문의사항 등록</b></h2>
		<br><br>
		
		<form action="addQna.do" method="post" enctype="multipart/form-data">
			<div>			
				<!-- 제목 -->
				<div>
					<label>제목</label>
					<input type="text" class="form-control" name="title">
				</div>
				
				<!-- 내용 -->
				<div style="margin-top: 17px">
					<label>내용</label>
				</div>
				<textarea id="summernote" name="content"></textarea>
				<script type="text/javascript">
				    $(document).ready(function() {
				        $('#summernote').summernote({
				        	height: 300,
				        	lang : 'ko-KR',
				        	callbacks : {
					        	onImageUpload : function(files, editor, welEditable) {
					        		sendFile(files[0], editor, welEditable);
					        	}				        		
				        	}
				        });
				        $('textarea[name="content"]').html($('#summernote').code());
				    });
				    
				    function sendFile(file, editor, welEditable) {
				        data = new FormData();
				        data.append("uploadFile", file);
				        $.ajax({
				            data : data,
				            type : "POST",
				            url : "qnaImageUpload.do",
				            cache : false,
				            contentType : false,
				            processData : false,
				            success : function(data) {
				            	var image = $("<img>").attr('src', '${pageContext.request.contextPath}' + data);
				            	$('#summernote').summernote('insertNode', image[0]);
				            }
				        });
				    }
				</script>
				
				<!-- 파일 첨부 -->
				<div>
					<label>파일 첨부</label>
					<input id="file" class="form-control" type="file" name="file">
				</div>
				
				<!-- 버튼 -->
				<div id="btn-group" style="margin-top: 20px">
					<button class="btn btn-primary" type="submit">등록</button>
					<!-- 뒤로가기를 해서 sid,category,query 등 데이터 안 넘겨줘도 가능 -->
					<a class="btn btn-default" href="javascript:history.go(-1)">취소</a>
				</div>
			</div>
		</form>
	</div>
</div>