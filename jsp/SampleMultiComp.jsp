<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<%@ page import="ArrayComboBoxBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>

<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sample for Company Code</title>
</head>

<body>
<form name="MYFORM" method="post" action="SampleCompanyDB.jsp">
<font face="細明體" size="+2" color="#33CCFF"><strong>範列:如何取得及顯示公司別</strong></font>
<br>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>
<br>
<font face="細明體" size="+2" color="#33CCFF"><strong>公司別</strong></font>
<%

if (userCompCodeArray[0].length == 0) {
%>
<font face="細明體" size="+2" color="#33CCFF"><strong>你沒有被授權任一公司</strong></font>
<%
}
else {
	arrayComboBoxBean.setNoNull("Y");
	arrayComboBoxBean.setArrayString2D(userCompCodeArray);
	arrayComboBoxBean.setFieldName("COMP");
	out.println(arrayComboBoxBean.getArrayString2D());
}
%>
<input type="submit" name="OK" value="Ok">
</form>
</body>
</html>
