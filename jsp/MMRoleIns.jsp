<%@ page contentType="text/html" language="java" import="java.sql.*"%> 
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============�H�U�Ϭq�����o���v==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>

<title><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>
</head>

<body> 

<%
	String roleName=request.getParameter("ROLENAME");
	String roleDesc=request.getParameter("ROLEDESC");

  
	try  {
	 String sql="insert into ORADDMAN.wsRole(ROLENAME,ROLEDESC) values('"+roleName+"','"+roleDesc+"')";
	 //out.println(sql);
	 PreparedStatement pstmt=con.prepareStatement(sql);
	 pstmt.executeUpdate(); 
	 pstmt.close();
 	} catch (Exception ee) {out.println("Exception:"+ee.getMessage());
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
	}
%>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMRoleNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRole"/></a>
&nbsp;&nbsp;
<a href="MMRoleList.jsp"><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<font><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>


</body>
</html>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->