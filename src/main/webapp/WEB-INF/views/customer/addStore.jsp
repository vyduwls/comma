<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
	$(document).ready(function(){
		
		$(".addStoreBtn").click(function(){
			$.ajax({
				url : 'insertStore.do',
				type : 'post',
				datatype : 'text',
				data : {'name' : $("input[name=name]").val(),
						'address' : $("input[name=address]").val(),
						'storeNumber' : $("input[name=storeNumber]").val(),
						'ip' : $("input[name=ip]").val()},
				success : function(data) {
					if($.trim(data)==1){
						alert("가게가 등록되었습니다.");
						location.href="myPage.do";
					}
				},
				error:function(request,status,error){
			        alert("code:"+request.status+"\n\n"+"message:"+request.responseText+"\n\n"+"error:"+error);
		       }
			});
		});
		$(".cancelBtn").click(function(){
			location.href="myPage.do";
		});
	});
</script>

<div id="body" class="container">

	<div id="body-title" class="col-lg-12">
		<h3 id="body-title">
			<b>마이 페이지</b>
		</h3>
	</div>


	<!-- 사이드바 -->
	<div id="side" class="col-lg-3" style="height: 800px">
		<div class="profile" style="margin-top:52px;">
			<!-- 프로필 버튼 -->
			<div class="button">
				<a id="myPage" type="button" class="btn btn-default btn-block"
					href="${pageContext.request.contextPath}/customer/modifyMember.do">회원정보수정</a>
				<a id="message" type="button" class="btn btn-default btn-block myPage-active"
					href="${pageContext.request.contextPath}/customer/myPage.do" >가게 정보 등록/변경
				</a> <a id="modify" type="button" class="btn btn-default btn-block"
					href="${pageContext.request.contextPath}/customer/myPageQNA.do">문의사항</a> 
<%-- 					<c:if test="${m.mid=='admin'}"> --%>
<%-- 						<a id="manageMember" type="button" class="btn btn-default btn-block" href="${pageContext.request.contextPath}/customer/manageMember.do">회원관리</a> --%>
<%-- 					</c:if>	 --%>
			</div>
		</div>
	</div>
	
	<div class="tab-content">
			<div class="col-lg-2"></div>
			<div class="col-lg-5">
			<b style="margin-left:41%; font-size: 17px;">가게 등록</b> 
				<div class="form-group" style="margin-top:20px;" >
					<label>가게이름</label> 
					<input type="text" class="form-control" name="name" placeholder="가게 이름" required="required">
				</div>
				<div class="form-group">
					<label>주소</label>
					<input class="form-control" type="text" name="address" placeholder="가게 주소" required="required">
				</div>
				<div class="form-group">
					<label>전화번호</label> 
					<input type="text" class="form-control" name="storeNumber" placeholder="가게 전화번호(-포함해주세요)" >
				</div>
				<div class="form-group">
					<label>ip</label> 
					<input type="text" class="form-control" name="ip" placeholder="ip주소(ex:000.000.000.000)" required="required">
				</div>

				<div class="form-group" style="float:right; margin-top: 14px">
					<input type="submit" class="btn btn-success addStoreBtn" value="가게 등록하기">
					<button type="reset" class="btn btn-default cancelBtn">이전으로</button>
				</div>
			</div>
	</div>
	</div>
