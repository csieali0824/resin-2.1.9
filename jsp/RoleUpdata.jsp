<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>RoleUpdate.jsp</title>
</head>

<body>
<%
  String ROLENAME=request.getParameter("ROLENAME");
  String ROLEDESC=request.getParameter("ROLEDESC");
  
  out.println("<b>修改"+ROLENAME+":</b><br>");
  
try
    {
	Statement statement=con.createStatement();
	String sql="UPDATE WsRole SET ROLEDESC='"+ROLEDESC+"' WHERE ROLENAME='"+ROLENAME+"'";
    statement.executeUpdate(sql);
	statement.close();
    //con.close();
   }//try of end
    catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
%>
<%= ROLENAME %> 修改完成!
<p><a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/RoleShow.jsp">查詢所有角色</A></p>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
