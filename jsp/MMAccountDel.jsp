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
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
