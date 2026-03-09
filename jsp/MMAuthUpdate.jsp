<%@ page contentType="text/html" language="java" import="java.sql.*"%>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="bean.SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="bean.SalesDRQPageHeaderBean"/>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<html>
<head>
<title><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>
</head>

<body>
<%
try {
	String sRole = request.getParameter("ROLE");
	String sFunc = request.getParameter("FUNC");
	String sFunction = request.getParameter("FUNCTION");
	String sModule = "";
	PreparedStatement ps = con.prepareStatement("SELECT fmodule FROM ORADDMAN.menufunction WHERE ffunction='"+sFunction+"'");
	ResultSet rs = ps.executeQuery();
	if (rs.next()) {
		sModule = rs.getString("fmodule");
	} // end if
	rs.close();
	ps.close();
	String sql = "Update ORADDMAN.WSprogrammer SET address='"+sFunction+"',addressdesc='"+sFunction+"',model='"+sModule+"' WHERE rolename='"+sRole+"' AND address='"+sFunc+"'";
	//out.println(sql);
	ps = con.prepareStatement(sql);
	ps.executeUpdate();
	ps.close();


} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
} // end try-catch

%>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMAuthList.jsp"><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgAuthoriz"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<font><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
</body>
</html>

<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>