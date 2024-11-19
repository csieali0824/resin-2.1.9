<%@ page contentType="text/html" language="java" %>
<%@ page import="java.sql.*" %>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<title><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>
</head>

<body>
<br><br>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMModuleNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgModule"/></a>
&nbsp;&nbsp;
<a href="MMModuleList.jsp"><jsp:getProperty name="rPH" property="pgModule"/><jsp:getProperty name="rPH" property="pgList"/></a>
<%
try {

	String sModule = request.getParameter("MODULE");
	String sDesc = request.getParameter("MDESC");
	String sSeq = request.getParameter("MSEQ");
	String sRoot = request.getParameter("MROOT");
	String sql = "INSERT INTO ORADDMAN.MENUMODULE (MMODULE,MDESC,MSEQ,MROOT) VALUES ('"+sModule+"','"+sDesc+"',"+sSeq+",'"+sRoot+"')";
	//out.println(sql);
	PreparedStatement ps = con.prepareStatement(sql);
	ps.executeUpdate();
	ps.close();

} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%
}
%>
<br><br>
<font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
