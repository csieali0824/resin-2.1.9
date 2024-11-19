<%@ page language="java" import="java.sql.*,java.io.*" %>
<%@ page import="PageHeaderBean" %>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>
<% 
 String pageHeaderURL=null;
 String clientLocale=request.getLocale().toString();
 if (clientLocale.equals("zh_TW"))
 {
  pageHeaderURL="/jsp/include/PIMasterPageHeader_TW.jsp";
  response.setContentType("text/html; charset=Big5");
 } else {
  pageHeaderURL="/jsp/include/PIMasterPageHeader_EN.jsp";
  response.setContentType("text/html; charset=ISO8859_1");
 } 
%>
<jsp:include page="<%= pageHeaderURL %>"/>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<jsp:getProperty name="pageHeader" property="titleName"/><BR>
<jsp:getProperty name="pageHeader" property="marketName"/><BR>
</body>
</html>
