<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>無標題文件</title>

</head>
<%
   String height=request.getParameter("HEIGHT");
   String textArea = request.getParameter("TEXTAREA");
   String aaa = request.getParameter("AAA");
   
   if (aaa==null || aaa.equals("")) { aaa="NULL OPTION"; textArea=aaa; }
%>
<form action="HelloWorld.jsp" method="post">
<body>
<table >
<tr><td>aaa</td><td>bbb</td></tr>
</table>
<%   
   out.println("Hello World");
   out.println("My height is "+height+"!!!");
%>

<textarea name="TEXTAREA" cols="12" rows="12"><% if (textArea==null || textArea.equals("")) out.println(aaa); else out.println(textArea); %></textarea>
</body>
<script language="javascript">
  alert("Hello world !!!, My height is 148 !!!");
</script>
<input type="hidden" name="AAA" value="<%=textArea%>">
</form>
</html>
