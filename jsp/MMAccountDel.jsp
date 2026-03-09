<%@ page contentType="text/html" language="java" import="java.sql.*" %>
<!--=============for multi-language==========-->
<%@ include file="../jsp/include/PageHeaderSwitch.jsp" %>
<%@ page import="bean.SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="bean.SalesDRQPageHeaderBean"/>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<html>
<head>
<title><jsp:getProperty name="rPH" property="pgDelete"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>
</head>
<body>
<%
String [] ch = request.getParameterValues("CH");
if (ch != null)
{
	try 
	{  
		String s = "";
	
		for (int i=0;i<ch.length;i++) 
		{
			if (s=="") 
			{
				s = "'"+ch[i]+"'";
			} 
			else 
			{
				s = s + ",'"+ch[i]+"'";
			} // end if-else
		} // end for
		//out.println(s);
		PreparedStatement pstmt=con.prepareStatement("delete from ORADDMAN.WSUSER where USERNAME in ("+s+")"); 
		pstmt.executeUpdate();
		pstmt.close();  
		pstmt=con.prepareStatement("delete from ORADDMAN.WSgroupuserrole where GROUPUSERNAME in ("+s+")"); 
		pstmt.executeUpdate();
		pstmt.close();
	} //end of try
	catch (Exception ee) 
	{ 
		out.println(ee.getMessage()); 
	%>
	<%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
	}
%>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<A HREF="./MMAccountList.jsp"><jsp:getProperty name="rPH" property="pgID"/><jsp:getProperty name="rPH" property="pgList"/></A>
<br><br>
<font><jsp:getProperty name="rPH" property="pgDelete"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
<%
}else{
	response.sendRedirect("MMAccountList.jsp");
}
%>
</body>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
