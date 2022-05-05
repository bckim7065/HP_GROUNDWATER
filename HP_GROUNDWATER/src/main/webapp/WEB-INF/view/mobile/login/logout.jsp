<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page session="false" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>logout</title>
</head>
<body>
	<script>
		alert("정상적으로 로그아웃되셨습니다.");
		location.href = "${pageContext.request.contextPath}/mobile";
	</script>
</body>
</html>