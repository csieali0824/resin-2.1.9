<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>UpdateProgrammer.jsp</title>
</head>

<body> 
<%
  String ADDRESSDESC=request.getParameter("ADDRESSDESC");
  String ROLENAME=request.getParameter("ROLENAME");
  String ADDRESS=request.getParameter("ADDRESS");
  String MODEL=request.getParameter("MODEL");
  String PROGRAMMERNAME=request.getParameter("PROGRAMMERNAME");
  String LINENO=request.getParameter("LINENO");
   
try
    {
	Statement statement=con.createStatement();
	String sql="UPDATE WSProgrammer SET  ROLENAME='admin',MODEL='"+MODEL+"',PROGRAMMERNAME='"+PROGRAMMERNAME+"',LINENO='"+LINENO+"' WHERE trim(ADDRESS)='"+ADDRESS+"'";
	//out.println(sql); 
	statement.executeUpdate(sql);
	statement.close();
	
   }//try of end
    catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<br><%--= ROLENAME --%> 修改完成!<br>
<a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/ShowProgrammerAdmin.jsp">查詢所有檔案資訊</A>
</body>
</html>
