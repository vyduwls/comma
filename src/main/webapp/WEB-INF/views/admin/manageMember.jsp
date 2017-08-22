<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 위지윅(서머노트) -->
<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.6/summernote.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.6/summernote.js"></script>
<script src="lang/summernote-ko-KR.js"></script>
	
<script type="text/javascript">
	$(document).ready(function() {
		/* 체크박스 */
		$("#checkAll").click(function() {
			if($("#checkAll").prop("checked")) {
				$("input[type=checkbox]").prop("checked", true);
			} else {
				$("input[type=checkbox]").prop("checked", false);
			}
		});
		
		/* 회원 정보 수정 */
		$(document).on("click", ".modifyBtn", function() {
			var td = $(this).parent().siblings();
			
			$.ajax({
				url : 'modifyMember.do',
				type : 'post',
				datatype : 'text',
				data : {'mid' : td.eq(1).children("input").val(),
						'pwd' : td.eq(2).children("input").val(),
						'name' : td.eq(3).children("input").val(),
						'phone' : td.eq(4).children("input").val(),
						'email' : td.eq(5).children("input").val()
				},
				success : function(data) {
					if($.trim(data) != "0") {
						alert("정보 수정 완료");
					} else {
						alert("정보 수정 실패");
					}
				},
				error:function(request,status,error){
			        alert("code:"+request.status+"\n\n"+"message:"+request.responseText+"\n\n"+"error:"+error);
		       }			
			});
		});
		
		/* 회원 탈퇴 */
		/* $(document).on("click", ".resignBtn", function() {
			var td = $(this).parent().siblings();
			var tr = $(this).parent().parent();
			tr.remove();
			
			$.ajax({
				url : 'resignMember.do',
				type : 'post',
				datatype : 'text',
				data : {'mid' : td.eq(1).children("input").val()
				},
				success : function(data) {
					if($.trim(data) != "0") {
						// 해당 행 삭제
						tr.remove(); 
						alert("탈퇴 완료");
					} else {
						alert("탈퇴 실패");
					}
				},
				error:function(request,status,error){
			        alert("code:"+request.status+"\n\n"+"message:"+request.responseText+"\n\n"+"error:"+error);
		       }			
			});
		}); */
		
		/* 이메일 전송 모달 */
		$("#sendEmailModal").click(function() {
			if($("input[name='check']:checked").length==0) {
				alert("항목을 선택하세요.");
				return false;
			}
			
			$("#modal-sendEmail").modal();
			
			/* modal에서 보여줄 mid */
			var midArray = "";
			$("input[name='check']:checked").each(function() {
				midArray = midArray + $(this).val() + ", ";
			});
			midArray = midArray.substring(0,midArray.lastIndexOf(","));
			
			$("#modal-sendEmail-receiver").val(midArray);
		});
		
		/* 이메일 전송 */
		$("#sendEmail").click(function() {
			
			/* 실제 전달될 email */
			var emailArray = "";
			$("input[name='check']:checked").each(function() {
				var td = $(this).parent().siblings();
				emailArray = emailArray + td.eq(4).children("input").val() + ", ";
			});
			emailArray = emailArray.substring(0,emailArray.lastIndexOf(","));
			
			$.ajax({
				url : 'sendEmailToMember.do',
				type : 'post',
				datatype : 'text',
				data : {'title' : $("#modal-sendEmail-title").val(),
						'receiverMid' : $("#modal-sendEmail-receiver").val(),
						'receiverEmail' : emailArray,
						'content' : $("#summernote").val()
				},
				success : function(data) {
					if($.trim(data) != 0) {
						alert("이메일 전송 완료");
						location.reload();
					} else {
						alert("이메일 전송 실패");
					}
				},
				error:function(request,status,error){
			        alert("code:"+request.status+"\n\n"+"message:"+request.responseText+"\n\n"+"error:"+error);
		       }			
			});
		});
		
		/* 선택된 회원 탈퇴 */
		$("#resignSelected").click(function() {
			if($("input[name='check']:checked").length==0) {
				alert("항목을 선택하세요.");
				return false;
			}
			
			var midArray = [];
			$("input[name='check']:checked").each(function() {
				midArray.push($(this).val());
			});
			var tr = $("input[name='check']:checked").parent().parent();
			
			// java에 배열 넘기기 위해 필요
			jQuery.ajaxSettings.traditional = true;
			
			$.ajax({
				url : 'resignSelectedMember.do',
				type : 'post',
				datatype : 'text',
				data : {'midArray' : midArray
				},
				success : function(data) {
					if($.trim(data) == midArray.length) {
						// 해당 행 삭제
						tr.remove(); 
						alert("탈퇴 완료");
					} else {
						alert("탈퇴 실패");
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
	<div id="inner_content" class="container">
		<h2><b>회원 관리</b></h2>
		<br><br>
		
		<!-- 사이드바 -->
		<div id="side" class="col-lg-3" style="height: 800px">
			<div class="profile">
				<!-- 프로필 버튼 -->
				<div class="button">
					<a id="manageMember" type="button" class="btn btn-block" style="border-left: 3px solid rgb(66,133,244)"
						href="${pageContext.request.contextPath}/admin/manageMember.do">회원 관리</a>
					<a id="manageStore" type="button" class="btn btn-block"
						href="${pageContext.request.contextPath}/admin/manageStore.do">점포 관리</a> 
					<a id="manageQNA" type="button" class="btn btn-block"
						href="${pageContext.request.contextPath}/admin/manageQNA.do">문의 게시판</a> 
				</div>
			</div>
		</div>
		
		<!-- 컨텐츠 -->
		<div id="admin-content" class="col-lg-9">
			<!-- 검색 기능 -->
			<div style="float: right">
				<form id="frm" class="form-inline" action="manageMember.do" method="get">
										
					<!-- 카테고리 선택 -->
					<div class="form-group">
						<select class="form-control" name="category">
						    <option value="mid" ${category=="mid" ? "selected" : ""}>아이디</option>
						    <option value="name" ${category=="name" ? "selected" : ""}>이름</option>
						    <option value="phone" ${category=="phone" ? "selected" : ""}>전화번호</option>
						    <option value="email" ${category=="email" ? "selected" : ""}>이메일</option>
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
			
			<!-- 점주 정보 테이블 -->
			<div class="col-lg-12 sticky-table sticky-headers sticky-ltr-cells">
				<table id="table" class="table">
					<thead>
						<tr class="sticky-row">
							<th class="divide">
								<input id="checkAll" type="checkbox">
							</th>
							<th class="divide">아이디</th>
							<th class="divide">비밀번호</th>					
							<th class="divide">이름</th>
							<th class="divide">전화번호</th>
							<th class="divide">이메일</th>
							<th class="divide">직급</th>
							<th class="divide">가게 수</th>
							<th>수정</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="storeMemberList" items="${storeMemberList}">
							<tr class="storeMember_tr">
								<td class="divide">
									<input type="checkbox" name="check" value="${storeMemberList.mid}">
								</td>
								<td class="divide"><b>${storeMemberList.mid}</b><input type="hidden" name="mid" value="${storeMemberList.mid}"></td>
								<td class="data divide"><input style="width: 50px" type="text" name="pwd" value="${storeMemberList.pwd}"></td>
								<td class="data divide"><input style="width: 50px" type="text" name="name" value="${storeMemberList.name}"></td>
								<td class="data divide"><input style="width: 110px" type="text" name="phone" value="${storeMemberList.phone}"></td>
								<td class="data divide"><input style="width: 150px" type="text" name="email" value="${storeMemberList.email}"></td>
								<td class="divide"><b>${storeMemberList.position}</b><input type="hidden" name="position" value="${storeMemberList.position}"></td>
								<td class="divide"><a href="manageStore.do?category=mid&query=${storeMemberList.mid}">${storeMemberList.storeCount}</a><input type="hidden" name="storeCount" value="${storeMemberList.storeCount}"></td>
								<td class="divide"><button class="btn btn-xs btn-primary modifyBtn">수정</button></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<!-- 하단 버튼 -->
			<div class="form-group col-lg-12" style="margin-left: -16px; margin-top: 10px">			
				<button id="sendEmailModal" class="btn btn-default">메일 전송</button>
				<button id="resignSelected" class="btn btn-danger">탈퇴</button>			
			</div>
		</div>
	</div>
</div>

<!-- 이메일 전송 모달창 -->
<div class="modal fade" id="modal-sendEmail" role="dialog">
	<div class="modal-dialog">
		<div class="modal-content modal-lg">
			
			<div class="modal-header">
				<div class="container-fluid" style="padding-right: 5px">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				<div class="container-fluid" style="padding: 10px 0px 20px 0px">
					<h5>ALBAMAN 이메일 전송</h5>
				</div>
			</div>
			
			<div class="modal-body" style="padding: 40px 50px;">
				<div class="form-group">
					<label>제목</label> 
					<input type="text" class="form-control" id="modal-sendEmail-title" name="title" placeholder="TITLE" required="required">
				</div>
				
				<div class="form-group">
					<label>받는 사람</label> 
					<input type="text" class="form-control" id="modal-sendEmail-receiver" name="receiver" readonly="readonly" required="required">
				</div>
				
				<textarea id="summernote" name="content"></textarea>
				<script type="text/javascript">
				    $(document).ready(function() {
				        $('#summernote').summernote({
				        	height: 300,
				        	lang : 'ko-KR'
				        });
				        $('textarea[name="content"]').html($('#summernote').code());
				    });
				</script>
				
				<br>
				<button type="button" class="btn btn-info btn-block" id="sendEmail">이메일 전송</button>
			</div>
			
			<div class="modal-footer">
			</div>
		</div>
	</div>
</div>