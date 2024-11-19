<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<html>
<head>
<title>新增成功</title>
</head>

<body>
<%
try {
	String sRole = request.getParameter("ROLE");
	String sComp = request.getParameter("COMP");
	String sql = "INSERT INTO ORADDMAN.wsrole_comp (rolename,comp) VALUES ('"+sRole+"','"+sComp+"')";
	//out.println(sql);
	PreparedStatement ps = con.prepareStatement(sql);
	ps.executeUpdate();
	ps.close();


} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
} // end try-catch

%>
<A HREF="/oradds/ORADDSMainMenu.jsp">回頁頁</A>
&nbsp;&nbsp;
<a href="MMCompNew.jsp">新增公司授權</a>
&nbsp;&nbsp;
<a href="MMCompList.jsp">公司授權清單</a>
<br><br>
<font>新增成功</font>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>