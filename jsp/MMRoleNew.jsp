<%@ page contentType="text/html" language="java" import="java.sql.*" %>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>

<title><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRole"/></title>


<form action="./MMRoleIns.jsp" method="post" name="MYFORM">
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRole"/></font></strong>
<br><br>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMRoleList.jsp"><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<table border="1">
<tr>
<td><jsp:getProperty name="rPH" property="pgRole"/></td>
<td><input type="text" name="ROLENAME" size="20" maxlength="20"></td>
</tr>
<tr>
<td><jsp:getProperty name="rPH" property="pgDesc"/></td>
<td><input type="text" name="ROLEDESC" size="30" maxlength="40"></td>
</tr>
<tr>
<td colspan="2" align="center"><input type="submit" name="submit" value='<jsp:getProperty name="rPH" property="pgSave"/>'
 onClick='return submitCheck("<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgRole'/>"
 ,"<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgAccount'/><jsp:getProperty name='rPH' property='pgDesc'/>")'>
</td>
</tr>
</table>
</form>

</body>
</html>

<script language="JavaScript"> 

function submitCheck(ms1,ms2) {
	if (document.MYFORM.ROLENAME.value == "") {
		alert(ms1);
		return (false);
	}
	if(document.MYFORM.ROLEDESC.value == ""){
		alert(ms2);
		return (false);
	}
  
	document.MYFORM.submit();
} // end function
    

</script>  
