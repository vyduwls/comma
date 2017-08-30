<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">
$(document).ready(function() {
	if("${delete}" == "fail") {
		alert("삭제 실패");
	}
	
	// 댓글 삭제
	$("#commentDelete").click(function() {
		
		var tr = $(this).parents(".commentList_tr"); 
		
		$.ajax({
			url : 'deleteComment.do',
			type : 'post',
			datatype : 'text',
			data : {'cseq' : $(this).prev().prev().val()
			},
			success : function(data) {
				if($.trim(data) != "0") {
					alert("댓글 삭제 완료");
					tr.remove();
					$("#space").remove();
				} else {
					alert("댓글 삭제 실패");
				}
			},
			error:function(request,status,error){
		        alert("code:"+request.status+"\n\n"+"message:"+request.responseText+"\n\n"+"error:"+error);
	       }			
		});
	});
	
	// 댓글 수정
	$("#commentModify").click(function() {
		$.ajax({
			url : 'modifyComment.do',
			type : 'post',
			datatype : 'text',
			data : {'cseq' : $(this).prev().prev().prev().val(),
					'content' : $(this).prev().prev().val()
			},
			success : function(data) {
				if($.trim(data) != "0") {
					alert("댓글 수정 완료");
				} else {
					alert("댓글 수정 실패");
				}
			},
			error:function(request,status,error){
		        alert("code:"+request.status+"\n\n"+"message:"+request.responseText+"\n\n"+"error:"+error);
	       }			
		});
	});
	
	// 댓글 추가
	$("#commentAdd").click(function() {
		$.ajax({
			url : 'addComment.do',
			type : 'post',
			datatype : 'text',
			data : {'content' : $("#comment_content").val(),
					'qseq' : "${qna.qseq}"},
			success : function(data) {
				if($.trim(data) != "0") {
					location.reload();
				} else {
					alert("댓글 수정 실패");
				}
			},
			error:function(request,status,error){
		        alert("code:"+request.status+"\n\n"+"message:"+request.responseText+"\n\n"+"error:"+error);
	       }			
		});
	});
});
</script>

<div id="content">
	<div class="container">
		<h2><b>문의게시판</b></h2>
		<br><br>
		
		<div>
			<table class="table table-bordered" id="qna_detail_table">
					<tr>
						<th style="width: 20px" class="active">No.</th>
						<td style="width: 20px">${qna.qseq}</td>
						<th style="width: 20px" class="active">제목</th>
						<td style="width: 50px">${qna.title}</td>
						<th style="width: 20px" class="active">등록일</th>
						<td style="width: 50px">${qna.regDate}</td>
					</tr>		
					<tr>
						<th style="width: 20px" class="active">내용</th>
						<td colspan="5">
							<div id="qna_detail_content">${qna.content}</div>
						</td>
					</tr>
					<tr>
						<th style="width: 20px" class="active">첨부</th>
						<td colspan="5"><a href="download.do?path=/WEB-INF/views/customer/upload&fileName=${fileName}">${qna.file}</a></td>
					</tr>	
			</table>
			
			<!-- 댓글 리스트 -->
			<p style="margin-left: 10px"><b>댓글</b></p>
			<table class="table table-bordered">
				<c:forEach var="commentList" items="${commentList}">
					<tr class="commentList_tr">
						<td class="active" style="width: 40px; vertical-align: middle">${commentList.mid}</td>
						<c:if test="${sessionScope.mid == commentList.mid}">
							<td id="comment_content">
								<input type="hidden" value="${commentList.cseq}" name="cseq">
								<input type="text" style="border: none; width: 95%; text-align: center" value="${commentList.content}">
								<a id="commentDelete" style="font-size: 11px; float: right; text-decoration: none; cursor: pointer;">삭제</a>
								<a id="commentModify" style="font-size: 11px; float: right; text-decoration: none; margin-right: 5px; cursor: pointer;">수정</a>
							</td>
							<td class="active" style="width: 100px; vertical-align: middle">${commentList.regDate}</td>
						</c:if>
						<c:if test="${sessionScope.mid != commentList.mid}">
							<td id="comment_content">
								${commentList.content}
							</td>
							<td class="active" style="width: 100px; vertical-align: middle">${commentList.regDate}</td>
						</c:if>
					</tr>
				</c:forEach>
				
				<c:if test="${commentList.size()!=0}">
					<tr id="space" style="border-left: none; border-right: none; height: 20px"></tr>
				</c:if>
				
				<tr id="add">
					<td class="active" style="width: 40px; vertical-align: middle">${sessionScope.mid}</td>
					<td><input id="comment_content" class="form-control" style="width: -webkit-fill-available" name="content"></td>
					<td style="vertical-align: middle; width: 100px"><button id="commentAdd" class="btn btn-primary">등록</button></td>
				</tr>
			</table>
			
			<div id="btn-group">
				<c:if test="${sessionScope.mid==qna.mid}">
					<a class="btn btn-default" href="modifyQNA.do?qseq=${qna.qseq}&category=${category}&query=${query}&pg=${pg}">수정</a>
					<a class="btn btn-default" href="deleteQNA.do?qseq=${qna.qseq}&category=${category}&query=${query}&pg=${pg}">삭제</a>
				</c:if>
				<a class="btn btn-default" href="${returnURL}?category=${category}&query=${query}&pg=${pg}">목록</a>
			</div>
		</div>
	</div>
</div>