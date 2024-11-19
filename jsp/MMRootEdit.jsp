<%@ page contentType="text/html" language="java" %>
<%@ page import="java.sql.*,ComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<title><jsp:getProperty name="rPH" property="pgRoot"/><jsp:getProperty name="rPH" property="pgRevise"/></title>
</head>

<body>
<%
try {

	String sRoot = request.getParameter("RROOT");
	String sDesc = request.getParameter("RDESC");
	String sSeq = request.getParameter("RSEQ");
%>
<form name="MYFORM" method="post" action="MMRootUpdate.jsp">
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgRoot"/><jsp:getProperty name="rPH" property="pgRevise"/></font></strong>
<br><br>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMRootNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRoot"/></a>
&nbsp;&nbsp;
<a href="MMRootList.jsp"><jsp:getProperty name="rPH" property="pgRoot"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<table border="1">
	<tr>
		<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgRoot"/></font></td>
		<td><input name="ROOT" type="hidden" value="<%=sRoot%>" readonly><%=sRoot%></td>
	</tr>
	<tr>
		<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgDesc"/></font></td>
		<td><input name="RDESC" type="text" value="<%=sDesc%>"></td>
	</tr>

	<tr>
		<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgSeq"/></font></td>
		<td><input name="RSEQ" type="text" value="<%=sSeq%>" align="right"></td>
	</tr>

	<tr>
	<td colspan="2" align="center"><input type="submit" value='<jsp:getProperty name="rPH" property="pgSave"/>'
	 onClick='return submitCheck("<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name="rPH" property="pgRoot"/>"
	 ,"<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name="rPH" property="pgDesc"/>")'>
	</td>
	</tr>
</table>
</form>
<%
} // end try

catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
}
%>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<script>
function submitCheck(ms1,ms2) {
	if (document.MYFORM.ROOT.value == "") {
		alert(ms1);
		return (false);
	}
	if(document.MYFORM.RDESC.value == ""){
		alert(ms2);
		return (false);
	}
	document.MYFORM.submit();
} // end function

</script>