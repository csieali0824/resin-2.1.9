<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%><html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>COLOR MASTER</title>
</head>

<body>
<font color="#0080FF" size="4"><strong>顏色代碼查詢</strong></font>

<table border="1">
<tr>
<td><font face="Arial" size="1">COLOR CODE</font></td>
<td><font face="Arial" size="1">COLOR DESC</font></td>
</tr>
<tr>
<%
try {
	Statement st=con.createStatement();
	ResultSet rs = st.executeQuery("SELECT COLORCODE,COLORDESC FROM PICOLOR_MASTER ORDER BY COLORCODE");
	while (rs.next()) {
%>
<tr>
<td><font face="Arial" size="1"><%=rs.getString("COLORCODE")%></font></td>
<td><font face="Arial" size="1"><%=rs.getString("COLORDESC")%></font></td>
</tr>
<%
	} // end while
	rs.close();
	st.close();
}
catch (Exception e) { out.println("Exception:"+e.getMessage()); }
%>
</tr>
</table>

</body>
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
