<%@ page contentType="text/html" language="java" import="java.sql.*"%>
<%@ page import="ComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<script language="JavaScript">
function submitCheck(ms1,ms2) {
	if (document.MYFORM.ROLE.value == "--") {
		alert(ms1);
		return (false);
	}
	if (document.MYFORM.FUNCTION.value == "--") {
		alert(ms2);
		return (false);
	}
	document.MYFORM.submit();
} //end function
</script>

<html>
<head>
<title><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgAuthoriz"/></title>

</head>
<body>
<FORM ACTION="./MMAuthIns.jsp" METHOD="post" NAME="MYFORM" >
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgAuthoriz"/></font></strong>
<br><br>
<A HREF="/oradds/OraddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMAuthList.jsp"><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgAuthoriz"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<table border="1">
<tr><td>
<jsp:getProperty name="rPH" property="pgRole"/></td><td>
<%
try {
	Statement st=con.createStatement(); 
	ResultSet rs=st.executeQuery("SELECT ROLENAME,ROLENAME||'--'||ROLEDESC FROM ORADDMAN.WSROLE ORDER BY ROLENAME");
	comboBoxBean.setRs(rs);
	comboBoxBean.setFieldName("ROLE");
	out.println(comboBoxBean.getRsString());
	rs.close();
	st.close();
} // end try

catch (Exception e) { out.println("Exception:"+e.getMessage()); }
%>
</td></tr>
<tr><td>
<jsp:getProperty name="rPH" property="pgFunction"/></td><td>
<%
try {
	Statement st=con.createStatement(); 
	ResultSet rs=st.executeQuery("SELECT FFUNCTION,FFUNCTION||'--'||FDESC FROM ORADDMAN.menumodule,ORADDMAN.MENUFUNCTION WHERE mmodule=fmodule and substr(FADDRESS,1,5) != '/wins' ORDER BY FFUNCTION");
	comboBoxBean.setRs(rs);
	comboBoxBean.setFieldName("FUNCTION");
	out.println(comboBoxBean.getRsString());
	rs.close();
	st.close();

} // end try

catch (Exception e) { out.println("Exception:"+e.getMessage()); }

%>
</td></tr>

<tr><td colspan="2" align="center"><input type="submit" value='<jsp:getProperty name="rPH" property="pgSave"/>'
 onClick='return submitCheck("<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgRole'/>"
  ,"<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgFunction'/>")'>
</td></tr>
</table>
</FORM>

</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
