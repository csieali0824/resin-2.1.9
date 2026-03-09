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
<title><jsp:getProperty name="rPH" property="pgDelete"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>
</head>
<body>
<%
try {
	String [] ch = request.getParameterValues("CH");
	//out.println(ch[0]);
	if (ch!=null) {
		String role = ""; 
		String module = "";
		String func = "";
		String add = ""; 
		String sql = "";
		PreparedStatement ps = null;
		for (int i=0;i<ch.length;i++) {
			String s = ch[i];
			role = s.substring(0,s.indexOf("|"));
			s = s.substring(s.indexOf("|")+1,s.length());
			module = s.substring(0,s.indexOf("|"));
			s = s.substring(s.indexOf("|")+1,s.length());
			func = s.substring(0,s.length());
			//out.println(role+","+module+","+func);
			sql = "DELETE FROM ORADDMAN.wsprogrammer WHERE rolename='"+role+"' AND address='"+func+"'";
			ps = con.prepareStatement(sql);
			ps.executeUpdate();
		} // end for
		ps.close();
	} // end if

} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
} // end try-catch

%>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMAuthList.jsp"><jsp:getProperty name="rPH" property="pgAuthoriz"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<font><jsp:getProperty name="rPH" property="pgDelete"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
</body>
</html>

<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
