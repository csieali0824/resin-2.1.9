<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="BpcsBean" %>
<jsp:useBean id="bpcsBean" scope="page" class="BpcsBean"/>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>

<%
try {
	String sProd = request.getParameter("PROD");
	String sFac = request.getParameter("FAC");
	String sMethod = request.getParameter("METHOD");
	String sLevel = request.getParameter("LEVEL");
	bpcsBean.setConnection(bpcscon);
	String a[][]=bpcsBean.getWhereUse(sProd,sFac,sMethod,sLevel);
	out.println("<br>"+"Total Record(s)="+a.length);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sample BOM</title>
</head>
<body>
<table border="1">
<tr>
	<td nowrap><font face="sans-serif" size="-1">Level</font></td>
	<td><font face="sans-serif" size="-1">String</font></td>
	<td><font face="sans-serif" size="-1">Seq</font></td>
	<td><font face="sans-serif" size="-1">Parent</font></td>
	<td><font face="sans-serif" size="-1">Child</font></td>
	<td><font face="sans-serif" size="-1">Description</font></td>
	<td><font face="sans-serif" size="-1">U/M</font></td>
	<td><font face="sans-serif" size="-1">Req</font></td>
	<td><font face="sans-serif" size="-1">Type</font></td>
	<td><font face="sans-serif" size="-1">Class</font></td>
	<td><font face="sans-serif" size="-1">BOM Seq</font></td>
</tr>
<%
	for (int j=0;j<a.length;j++) {
		%><tr><%
		for (int k=0;k<a[j].length;k++) {
%>

	<td  nowrap><font face="sans-serif" size="-1"><%if (a[j][k]==null) {out.println("&nbsp;");} else {out.println(a[j][k]);}%></font></td>


<%
		}
		%></tr><%
	} // end for

} // end try
catch (Exception e) { out.println("Exception:"+e.getMessage()); }

%>
</table>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>


