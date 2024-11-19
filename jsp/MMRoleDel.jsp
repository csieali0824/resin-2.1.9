<%@ page contentType="text/html" language="java" import="java.sql.*" %>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<html>
<head>
<title><jsp:getProperty name="rPH" property="pgDelete"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>

</head>

<body>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMRoleNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgRole"/></a>
&nbsp;&nbsp;
<a href="MMRoleList.jsp"><jsp:getProperty name="rPH" property="pgRole"/><jsp:getProperty name="rPH" property="pgList"/></a>

<%
try {  
	String [] ch = request.getParameterValues("CH");
	String s = "";
	
	if (ch!=null) {
		for (int i=0;i<ch.length;i++) {
			if (s=="") {
				s = "'"+ch[i]+"'";
			} else {
				s = s + ",'"+ch[i]+"'";
			} // end if-else
			PreparedStatement pstmt=con.prepareStatement("select * from ORADDMAN.wsgroupuserrole where rolename='"+ch[i]+"'");
			ResultSet rs=pstmt.executeQuery();
			boolean isEmpty = !rs.next();
			rs.close();
			pstmt.close();
			if (isEmpty) {
				String sql="delete from ORADDMAN.WSROLE where ROLENAME='"+ch[i]+"'";   
				//out.println(sql);
				pstmt=con.prepareStatement(sql);    
				pstmt.executeUpdate();           
				pstmt.close();
			} else { out.println("<br><br><fontsize='+1' color='#FF0000'>"+"Role "+ch[i]+" is not empty!"+"</font>"); }
		} // end for
		/*
		String sql="delete from RPROLE where ROLENAME in ("+s+")";   
		//out.println(sql);
		PreparedStatement pstmt=con.prepareStatement(sql);    
		pstmt.executeUpdate();           
		pstmt.close();
		*/
	} // end if 
	
} catch (Exception ee) { out.println(ee.getMessage()); 
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
}//end try-catch

%>
<br><br>
<font><jsp:getProperty name="rPH" property="pgDelete"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
