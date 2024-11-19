<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<html>
<%@ page import="java.lang.*" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>DOS Command</title>
</head>
<body>
<%
 Runtime.getRuntime().exec("cmd /c net send 10.0.4.18 How Are U?");
%>
</body>
</html>
