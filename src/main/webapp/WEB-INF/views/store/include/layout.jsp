<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<title>index</title>
		
		<!-- jQuery -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"/>
		<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
		<script type='text/javascript' src='http://malsup.github.com/jquery.form.js'></script>
		
		<!-- Bootstrap -->
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css"/>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css"/>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
		
		<!-- CSS -->
		<link href="<tiles:getAsString name="css"/>" type="text/css" rel="stylesheet"/>
		<link href="${pageContext.request.contextPath}/css/fullcalendar.css" rel="stylesheet"/>
		<link href="${pageContext.request.contextPath}/css/fullcalendar.print.css" rel="stylesheet" media="print"/>
	</head>
	<body>
	
		<tiles:insertAttribute name="header"/>
		
		<tiles:insertAttribute name="content"/>
		
		<tiles:insertAttribute name="footer"/>
		
	</body>
</html>
