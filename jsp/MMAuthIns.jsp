<%@ page contentType="text/html" language="java" import="java.sql.*"%>
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
<title><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>
</head>

<body>
<%
try {
	String sRole = request.getParameter("ROLE");
	String sFunction = request.getParameter("FUNCTION");
	String sModule = "";
	PreparedStatement ps = con.prepareStatement("SELECT fmodule FROM ORADDMAN.menufunction WHERE ffunction='"+sFunction+"'");
	ResultSet rs = ps.executeQuery();
	if (rs.next()) {
		sModule = rs.getString("fmodule");
	} // end if
	rs.close();
	ps.close();
	String sql = "INSERT INTO ORADDMAN.wsprogrammer (rolename,address,addressdesc,model) VALUES ('"+sRole+"','"+sFunction+"','"+sFunction+"','"+sModule+"')";
	//out.println(sql);
	ps = con.prepareStatement(sql);
	ps.executeUpdate();
	ps.close();


} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
} // end try-catch

%>
<A HREF="/oradds/ORAddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMAuthNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgAuthoriz"/></a>
&nbsp;&nbsp;
<a href="MMAuthList.jsp"><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgAuthoriz"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<font><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>