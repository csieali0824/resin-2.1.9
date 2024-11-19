<%@ page contentType="text/html" language="java" import="java.sql.* " %>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgList"/></title>
</head>

<body> 

<%
	String roleName=request.getParameter("ROLENAME");
	String roleDesc="";
	try {
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery("select rolename,roledesc from ORADDMAN.wsrole where ROLENAME='"+roleName+"'");
		if (!rs.next()) {
		} else {
			roleDesc=rs.getString("roledesc");
			//out.println(roleDesc);
%>
<form action="./MMRoleUpdata.jsp" method="post" name="MYFORM" onsubmit="return validate()">
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgRole"/></font></strong>
<br><br>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMRoleNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRole"/></a>
&nbsp;&nbsp;
<a href="MMRoleList.jsp"><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<table border="1">
<tr>
<td><jsp:getProperty name="rPH" property="pgRole"/></td>
<td><input type="hidden" name="ROLENAME" value="<%=roleName%>" size="20" maxlength="20"><%=roleName%></td>
</tr>
<tr>
<td><jsp:getProperty name="rPH" property="pgDesc"/></td>
<td><input type="text" name="ROLEDESC" value="<%if (roleDesc==null) {} else { out.println(roleDesc); }%>"></td>
</tr>
<tr>
<td colspan="2" align="center"><input type="submit" name="submit" value='<jsp:getProperty name="rPH" property="pgSave"/>'
 onClick='return submitCheck("<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgRole'/>"
 ,"<jsp:getProperty name='rPH' property='pgAccount'/><jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgDesc'/>")'>
</td>
</tr>
</table>
</form>

<%
		} // end if-else
		statement.close(); 
		rs.close();		
	} catch (Exception ee) { out.println("Exception:"+ee.getMessage());
%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%
	}
%>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
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
