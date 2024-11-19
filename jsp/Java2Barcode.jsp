<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>Java Barcode</title>
</head>
<body>
<%
   String data=request.getParameter("data");    
%>
<img src="/oradds/jsp/JavaGenerateBarcode.jsp?DATA=<%=data%>&height=50"/>
</body>
</html>
