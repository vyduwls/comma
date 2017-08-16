<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="content">
	<div class="container">
		<h2><b>직원 정보 조회</b></h2>
		<p style="color: blue; margin-left: 10px">(직원 정보 수정은 점주만 가능합니다.)</p>
		<br><br>
		<form action="addRecruit.do" method="post">
			<div class="col-lg-6">
				<div class="form-group">
					<label>매장명</label> 
					<input readonly="readonly" type="text" class="form-control" name="pwd" value="${store.name}">
				</div>
				<div class="form-group">
					<label>아이디(사원번호)</label> 
					<input readonly="readonly" type="text" class="form-control" name="mid" value="${employee.mid}">
				</div>
				<div class="form-group">
					<label>이름</label> 
					<input readonly="readonly" type="text" class="form-control" name="name" value="${employee.name}">
				</div>
				<div class="form-group">
					<label>전화번호</label> 
					<input readonly="readonly" type="text" class="form-control" name="phone" value="${employee.phone}">
				</div>
				<div class="form-group">
					<label>이메일</label> 
					<input readonly="readonly" type="text" class="form-control" name="email" value="${employee.email}">
				</div>
			</div>
			
			<div class="col-lg-6">
				<div class="form-group">
					<label>직급</label> 
					<input readonly="readonly" type="text" class="form-control" name="position" placeholder="POSITION" value="${employee.position}">
				</div>
				<div class="form-group">
					<label>생년월일</label>
					<input readonly="readonly" class="form-control" type="text" id="birthdayPicker" name="birth" value="${employee.birth}">
				</div>
				<div class="form-group">
					<label>주소</label> 
					<input readonly="readonly" type="text" class="form-control" name="address" value="${employee.address}">
				</div>
				<div class="form-group">
					<label>시급</label> 
					<input readonly="readonly" type="text" class="form-control" name="wage" value="${employee.wage}">
				</div>
				<div class="form-group">
					<label>입사일</label>
					<input readonly="readonly" class="form-control" type="text" name="joinDate" value="${employee.joinDate}">
				</div>
			</div>
			
		</form>
	</div>
</div>