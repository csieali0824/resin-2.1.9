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
<title><jsp:getProperty name="rPH" property="pgDelete"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>
</head>

<body>
<br><br>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMRootNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRoot"/></a>
&nbsp;&nbsp;
<a href="MMRootList.jsp"><jsp:getProperty name="rPH" property="pgRoot"/><jsp:getProperty name="rPH" property="pgList"/></a>
<%
try {

	String [] ch = request.getParameterValues("CH");
	if (ch!=null) {
		for (int i=0;i<ch.length;i++) {
			String s1 = ch[i];
			String s2 = s1.substring(0,s1.indexOf("|"));
			
			PreparedStatement ps=con.prepareStatement("SELECT * FROM ORADDMAN.MENUMODULE WHERE MROOT='"+s2+"'");
			ResultSet rs=ps.executeQuery();
			boolean isEmpty = !rs.next();
			rs.close();
			ps.close();
			
			if (isEmpty) {
				ps=con.prepareStatement("DELETE FROM ORADDMAN.MENUROOT WHERE RROOT='"+s2+"'" );
				ps.executeUpdate();
				ps.close();
			} else { out.println("<br><br>"+"ROOT "+s2+" is not empty"); }
		} // end for
	}  // end if

} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%
} // end try-catch
%>
<br><br>
<font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgDelete"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
