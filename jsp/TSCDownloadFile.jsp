<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.text.DecimalFormat,java.io.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Download File</title>
</head>
<body>
<FORM ACTION="../jsp/TSCDownloadFile.jsp" METHOD="post" NAME="MYFORMD">
<% 
String fname = request.getParameter("fname");
if (fname == null) fname ="";
String ftype=request.getParameter("ftype");
if (ftype == null) ftype = "";
String foldername = request.getParameter("foldername");
if (foldername==null) foldername="";

response.reset();
response.setContentType("application/octet-stream");					
response.sendRedirect("../jsp/CustomerQuestion_Attache/"+foldername+"/"+fname); 
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

