<%@ page contentType="text/html" language="java" import="java.sql.*" %>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>

<title><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>
</head>

<body> 
<%
String roleName=request.getParameter("ROLENAME");
String roleDesc=request.getParameter("ROLEDESC");
  
try {
	String sql="UPDATE ORADDMAN.wsRole SET ROLEDESC='"+roleDesc+"' WHERE ROLENAME='"+roleName+"'";
	Statement statement=con.createStatement();
    statement.executeUpdate(sql);
	statement.close();
} catch (Exception ee) { out.println("Exception:"+ee.getMessage());
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
} // end try-catch
%>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMRoleNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRole"/></a>
&nbsp;&nbsp;
<a href="MMRoleList.jsp"><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<font><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>


