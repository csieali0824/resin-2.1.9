<%@ page contentType="text/html" language="java" import="java.sql.*" %>
<%@ page import="CheckBoxBean" %>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<!--=============for multi-language==========-->
<%@ include file="../jsp/include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>

<title><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgID"/></title>
</head>

<body> 
<form action="MMAccountUpdate.jsp" method="post" name="MYFORM">
<br>
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgID"/></font></strong>
<br>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<A HREF="./MMAccountList.jsp"><jsp:getProperty name="rPH" property="pgID"/><jsp:getProperty name="rPH" property="pgList"/></A>
<br>
<%
String USERNAME=request.getParameter("USERNAME");
String WEBID="";
String USERMAIL="";
String USERPROFILE="";
String PASSWORD="";
String ROLENAME="";
try {
	if (USERNAME != null) {
		Statement st=con.createStatement();
		ResultSet rs=st.executeQuery("select WEBID,USERNAME,USERMAIL,USERPROFILE,PASSWORD from ORADDMAN.wsUser WHERE USERNAME='"+USERNAME+"'");
		if(rs.next()) {
		 WEBID=rs.getString("WEBID"); if (WEBID==null) WEBID= "";
		 USERMAIL=rs.getString("USERMAIL"); if (USERMAIL==null) USERMAIL= "";
		 USERPROFILE=rs.getString("USERPROFILE"); if (USERPROFILE==null) USERPROFILE= "";
		 PASSWORD=rs.getString("PASSWORD");   if (PASSWORD==null) PASSWORD= "";
		} // end if
		rs.close();
		rs=st.executeQuery("select ROLENAME from ORADDMAN.wsgroupuserrole where GROUPUSERNAME='"+USERNAME+"'");
		while (rs.next()) { ROLENAME =  ROLENAME+","+rs.getString("ROLENAME"); }
		rs.close();
		rs=st.executeQuery("select ROLENAME,ROLENAME from ORADDMAN.wsrole ORDER BY 1 ");
		checkBoxBean.setRs(rs);
		checkBoxBean.setFieldName("ROLENAME");
		checkBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
		checkBoxBean.setChecked(ROLENAME);
%>
<table border="1">
<tr><td><jsp:getProperty name="rPH" property="pgID"/></td><td><input type="hidden" name="USERNAME"  size="10" maxlength="10" value="<%=USERNAME%>"><%=USERNAME%></td></tr>

<tr><td><jsp:getProperty name="rPH" property="pgAccountWeb"/></td><td><input type="text" name="WEBID" size="20" maxlength="20" value="<%=WEBID%>"></td></tr>

<tr><td><jsp:getProperty name="rPH" property="pgMail"/></td><td><input type="text" name="USERMAIL" size="40" maxlength="40" value="<%=USERMAIL%>"></td></tr>

<tr><td><jsp:getProperty name="rPH" property="pgProfile"/></td><td><input type="text" name="USERPROFILE" size="3" maxlength="3" value="<%=USERPROFILE%>"></td></tr>

<tr><td><jsp:getProperty name="rPH" property="pgPasswd"/></td><td><input type="PASSWORD" name="PASSWORD"  size="8" maxlength="8" value="<%=PASSWORD%>"></td></tr>

<tr><td><jsp:getProperty name="rPH" property="pgRole"/></td><td><%out.println(checkBoxBean.getRsString());%></td></tr>
<tr><td colspan="2" align="center">
<input type="submit" value='<jsp:getProperty name="rPH" property="pgSave"/>'
 onClick='return submitCheck("<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgAccountWeb'/>"
 ,"<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgID'/>")'>
</td></tr>
</table>

<%		 
		rs.close();
		st.close();

	} // end if	 
} catch (Exception e) { out.println("Exception:"+e.getMessage());
} // end try-catch
%>
</form>
<HR>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->


<script language="JavaScript"> 

function submitCheck(ms1,ms2) {
	if (document.MYFORM.WEBID.value == "") {
		alert(ms1);
		return (false);
	}
	if(document.MYFORM.USERNAME.value == ""){
		alert(ms2);
		return (false);
	}
  
	document.MYFORM.submit();
} // end function
   
</script>
