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
<title><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>
</head>

<body>
<br><br>
<A HREF="/oradds/OraddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMFunctionNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgFunction"/></a>
&nbsp;&nbsp;
<a href="MMFunctionList.jsp"><jsp:getProperty name="rPH" property="pgFunction"/><jsp:getProperty name="rPH" property="pgList"/></a>
<%
try {

	String sFunction = request.getParameter("FUNCTION");
	String sDesc = request.getParameter("DESC");
	String sModule = request.getParameter("MODULE");
	String sAddr = request.getParameter("ADDR");
	String sShow = request.getParameter("SHOW");
	String sSeq = request.getParameter("SEQ");
	String sql = "UPDATE ORADDMAN.MENUFUNCTION SET FDESC='"+sDesc+"',FMODULE='"+sModule+"',FADDRESS='"+sAddr+"',FSEQ="+sSeq+",FSHOW="+sShow
	+" WHERE FFUNCTION='"+sFunction+"' ";
	//out.println(sql);
	PreparedStatement ps = con.prepareStatement(sql);
	ps.executeUpdate();
	ps.close();
	sql = "UPDATE ORADDMAN.wsprogrammer SET model='"+sModule+"' WHERE address='"+sFunction+"'";
	ps = con.prepareStatement(sql);
	ps.executeUpdate();
	ps.close();

} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%
}
%>

<br><br>
<font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
