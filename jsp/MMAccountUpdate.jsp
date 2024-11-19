<%@ page contentType="text/html" language="java" import="java.sql.*" %>
<!--=============for multi-language==========-->
<%@ include file="../jsp/include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為安全認證機制==========-->
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
String USERNAME=request.getParameter("USERNAME");
String WEBID=request.getParameter("WEBID");
String USERMAIL=request.getParameter("USERMAIL");
String USERPROFILE=request.getParameter("USERPROFILE");
String PASSWORD=request.getParameter("PASSWORD");
String [] ROLENAME=request.getParameterValues("ROLENAME");
try {
	String sql="UPDATE ORADDMAN.wsUser SET WEBID='"+WEBID+"',USERMAIL='"+USERMAIL+"',USERPROFILE='"+USERPROFILE+"' ,PASSWORD='"+PASSWORD+"' WHERE USERNAME='"+USERNAME+"'";
	PreparedStatement ps=con.prepareStatement(sql);
	ps.executeUpdate();
	ps.close();
	ps=con.prepareStatement("delete from ORADDMAN.wsgroupuserrole where GROUPUSERNAME ='"+USERNAME+"'");
	ps.executeUpdate();
	ps.close();
	if(ROLENAME != null) {
		ps=con.prepareStatement("insert into ORADDMAN.wsgroupuserrole(GROUPUSERNAME,ROLENAME) values(?,?)");
		for(int i=0; i<ROLENAME.length ; i++) {
		  ps.setString(1,USERNAME);
	      ps.setString(2,ROLENAME[i]);
		  ps.executeUpdate();
		} // end for
	 } // end if
    ps.close();
} catch (Exception ee) { out.println("Exception:"+ee.getMessage());
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
}
%>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<A HREF="./MMAccountList.jsp"><jsp:getProperty name="rPH" property="pgAccount"/><jsp:getProperty name="rPH" property="pgList"/></A>
<br><br>
<font><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
