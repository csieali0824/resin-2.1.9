<%@ page contentType="text/html;charset=big5" %>
<html>
<head><title>Sample272</title><meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%
session.setAttribute("username","伊藤");
%>
<jsp:forward page="error.jsp" />
</body>
</html>