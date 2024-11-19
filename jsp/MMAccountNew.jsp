<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="CheckBoxBean"%>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<!--=============for multi-language==========-->
<%@ include file="../jsp/include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function submitCheck(ms1,ms2) 
{
	if (document.MYFORM.WEBID.value == "") 
	{
		alert(ms1);
		return (false);
	}
	if(document.MYFORM.USERNAME.value == "")
	{
		alert(ms2);
		return (false);
	}
	document.MYFORM.submit();
} // end function

function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<html>
<head>
<title><jsp:getProperty name="rPH" property="pgAdd"/><jsp:getProperty name="rPH" property="pgID"/></title>
</head>

<body> 
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgAdd"/><jsp:getProperty name="rPH" property="pgID"/></font></strong>
<br> <!--換行 -->
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
<A HREF="./MMAccountList.jsp"><jsp:getProperty name="rPH" property="pgID"/><jsp:getProperty name="rPH" property="pgList"/></A>
<%
String UName=request.getParameter("USERNAME");
String webID=request.getParameter("WEBID");
String emailAddress=request.getParameter("USERMAIL");
String ERPUSERID=request.getParameter("ERPUSERID");
if (UName==null) UName="";
if (webID==null) webID="";
if (emailAddress==null) emailAddress="";
if (ERPUSERID==null) ERPUSERID="";
  
Statement stateUser=con.createStatement(); 
ResultSet rsUser=stateUser.executeQuery("select a.EMPLOYEE_NO, b.EMAIL_ADDRESS,b.USER_ID from AHR_EMPLOYEES_ALL a, FND_USER b where a.PERSON_ID(+)=b.EMPLOYEE_ID and (LOWER(b.USER_NAME)=LOWER('"+UName+"') or b.USER_NAME='"+UName+"') ");
if (rsUser.next()) 
{
	webID = rsUser.getString("EMPLOYEE_NO");
	emailAddress = rsUser.getString("EMAIL_ADDRESS");
	ERPUSERID=rsUser.getString("USER_ID");
}
rsUser.close();
stateUser.close();
  
%>
<form action="./MMAccountIns.jsp" method="post" name="MYFORM">
<table border="1">
<tr><td><jsp:getProperty name="rPH" property="pgID"/></td><td><input type="text" name="USERNAME" size="20" maxlength="20" value="<%=UName%>" >
<INPUT TYPE="button" NAME="submit2" value='Get UserInfo.' onClick='setSubmit("../jsp/MMAccountNew.jsp")'>
</td></tr>

<tr><td><jsp:getProperty name="rPH" property="pgAccountWeb"/></td><td><input type="text" name="WEBID" size="20" value="<%=webID%>"><input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>"</td></tr>

<tr><td><jsp:getProperty name="rPH" property="pgMail"/></td><td><input type="text" name="USERMAIL" size="40" maxlength="40" value="<%=emailAddress%>"></td></tr>

<tr><td><jsp:getProperty name="rPH" property="pgProfile"/></td><td><input type="text" name="USERPROFILE" size="3" maxlength="3"></td></tr>

<tr><td><jsp:getProperty name="rPH" property="pgPasswd"/></td><td><input type="PASSWORD" name="PASSWORD"  size="8" maxlength="8"></td></tr>

<tr><td><jsp:getProperty name="rPH" property="pgRole"/></td><td>
<%
Statement statement=con.createStatement();
ResultSet rs=statement.executeQuery("select ROLENAME,ROLENAME from ORADDMAN.wsrole ORDER BY 1 ");
checkBoxBean.setRs(rs);
checkBoxBean.setFieldName("ROLENAME");
checkBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
out.println(checkBoxBean.getRsString()); 
rs.close();
statement.close();
%>
</td></tr>
<tr><td colspan="2" align="center">
<input type="submit" value='<jsp:getProperty name="rPH" property="pgSave"/>'
 onClick='return submitCheck("<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgAccountWeb'/>"
 ,"<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgID'/>")'>
</td></tr>
</table>
</form>

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
