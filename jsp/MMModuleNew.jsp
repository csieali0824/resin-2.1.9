<%@ page contentType="text/html" language="java" %>
<%@ page import="java.sql.*,bean.ComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="bean.ComboBoxBean"/>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="bean.SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="bean.SalesDRQPageHeaderBean"/>
<!--=============�H�U�Ϭq�����o���v==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============�H�U�Ϭq���B�z�}�l==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgModule"/></title>
</head>

<body>
<form name="MYFORM" method="post" action="MMModuleIns.jsp">
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgModule"/></font></strong>
<br>
<br>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMModuleList.jsp"><jsp:getProperty name="rPH" property="pgModule"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<table border="1">
	<tr>
		<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgModule"/></font></td>
		<td><input name="MODULE" type="text"></td>
	</tr>
	<tr>
		<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgDesc"/></font></td>
		<td><input name="MDESC" type="text"></td>
	</tr>
	<tr>
		<td width="21%"><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgModule"/></font></td>
		<td width="79%">
<%
	Statement st=con.createStatement(); 
	ResultSet rs=st.executeQuery("SELECT RROOT,RROOT||'--'||RDESC AS RDESC FROM ORADDMAN.MENUROOT ORDER BY RROOT");
	comboBoxBean.setRs(rs);
	comboBoxBean.setFieldName("MROOT");
	out.println(comboBoxBean.getRsString());
	rs.close();
	st.close();

%>
		</td>
	</tr>
	<tr>
		<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgSeq"/></font></td>
		<td><input name="MSEQ" type="text" align="right" value="0"></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><input type="submit" value='<jsp:getProperty name="rPH" property="pgSave"/>'
		 onClick='return submitCheck("<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgModule'/>"
		 ,"<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgDesc'/>")'>
	  </td>
	</tr>
</table>
</form>

</body>
</html>
<!--=============�H�U�Ϭq���B�z����==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<script>
function submitCheck(ms1,ms2) {
	if (document.MYFORM.MODULE.value == "") {
		alert(ms1);
		return (false);
	}
	if(document.MYFORM.MDESC.value == ""){
		alert(ms2);
		return (false);
	}
	document.MYFORM.submit();
} // end function

</script>