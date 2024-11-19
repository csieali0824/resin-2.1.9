<%@ page isErrorPage="true" import="java.io.*" %>
<html>
<head>
	<title>Exceptional Even Occurred!</title>
</head>
<body>
<%-- Exception Handler --%>
<font size="-1" face="Verdana, Arial, Helvetica, sans-serif" color="red">
<b><%= exception.toString() %></b><br>
</font>
<%
out.println("<!--");
StringWriter sw = new StringWriter();
PrintWriter pw = new PrintWriter(sw);
exception.printStackTrace(pw);
out.print(sw);
sw.close();
pw.close();
out.println("-->");
%>
</body>
</html>
