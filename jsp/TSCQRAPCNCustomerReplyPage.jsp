<%@ page contentType="text/html; charset=utf-8" import="java.sql.*,jxl.*,java.util.*"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
</script>
<title>Customer Web Page Info</title>
<%
String keyid =request.getParameter("keyid");
String PCN = request.getParameter("PCN");
%>
</head>
<body >  
<FORM METHOD="post" NAME="SITEFORM"  ENCTYPE="multipart/form-data">
<%
String cust_url=request.getRequestURL().toString().substring(0,request.getRequestURL().toString().lastIndexOf("/"))+"/TSCQRAProductNoticeCustReply.jsp?formkey="+java.net.URLEncoder.encode(keyid+"#cid"+PCN.toUpperCase().replace("QPCN","")+"+"+"/cview");
%>
<div style="text-decoration:underline;font-size:12px;font-family:arial"><%=cust_url%></div>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
