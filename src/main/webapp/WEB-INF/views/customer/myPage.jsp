<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
	$(document).ready(function(){
		$("#memberModify").click(function(){
			
		})
	});
</script>


<div id="body_menu" >
		<p class="pTagMember" style="">회원 정보</p>
		<p class="pTag">아이디    :<input type="text" name="mid" value="${member.mid}" class="form-control mypageInput" readonly="readonly"></p>
		<p class="pTag">비밀번호 :<input type="text" name="pwd" value="${member.pwd}" class="form-control mypageInput"></p>
		<p class="pTag">이름      :<input type="text" name="name" value="${member.name}" class="form-control mypageInput"></p>
		<p class="pTag">전화번호 :<input type="text" name="phoneNumber" value="${member.phone}" class="form-control mypageInput"></p>
		<p class="pTag">이메일    :<input type="text" name="email" value="${member.email}" class="form-control mypageInput"></p>
		<button class="btn btn-primary" style="width: 80%;height: 40px;font-size: 20px;margin-top:20px;">정보 저장</button>
		<button class="btn btn-default" style="width: 80%;height: 40px;font-size: 20px;margin-top:60px;">문의사항</button>
</div>
<div id="body_content" style="overflow-x:auto;">
		<h2>가게 List</h2>
		<button class="btn btn-default" style="width: 10%;height: 35px;font-size: 18px;margin:0px 0px 10px 80%;">가게 등록</button>
			<table id="storeTable" class="table table-bordered">
				<thead>
					<tr>
						<th class="storeTh">가게명</th>
						<th class="storeTh">이미지</th>
						<th class="storeTh1">주소</th>
						<th class="storeTh">전화번호</th>
						<th class="storeTh">ip</th>
						<th class="storeTh">등록일</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${!empty storeList}">
						<c:forEach items="${storeList}" var="n">
							<tr class="store_tr">
								<td class="storeTd storeName"><input type="hidden" name="sid" value="${n.sid}">${n.name}</td>
								<td class="storeTd">${n.image}</td>
								<td class="storeTd">${n.address}</td>
								<td class="storeTd">${n.storeNumber}</td>
								<td class="storeTd">${n.ip}</td>
								<td class="storeTd">${n.regDate}</td>
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
