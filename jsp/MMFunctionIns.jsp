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
	// check if function code exist
	String sql = "SELECT * FROM ORADDMAN.MENUFUNCTION WHERE FFUNCTION='"+sFunction+"'";
	PreparedStatement ps = con.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	boolean hasData = rs.next();
	rs.close();
	ps.close();
	if (hasData) {
%>
<br><br>
<font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgFail"/></font>
<%
	
	} else {
		sql = "INSERT INTO ORADDMAN.MENUFUNCTION (FFUNCTION,FDESC,FMODULE,FADDRESS,FSEQ,FSHOW) "
		+" VALUES ('"+sFunction+"','"+sDesc+"','"+sModule+"','"+sAddr+"',"+sSeq+","+sShow+")";
		//out.println(sql);
		ps = con.prepareStatement(sql);
		ps.executeUpdate();
		ps.close();
		//新增功能時, 要同時授權給給Admin
		sql = "INSERT INTO ORADDMAN.WSprogrammer (rolename,address,addressdesc,model) "
		+" VALUES ('admin','"+sFunction+"','"+sFunction+"','"+sModule+"')";
		//out.println(sql);
		ps = con.prepareStatement(sql);
		ps.executeUpdate();
		ps.close();
%>
<br><br>
<font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
<%

	}


} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%
}
%>

</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
