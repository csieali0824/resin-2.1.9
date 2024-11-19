<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>UpdateEditEmployeeUser.jsp</title>
</head>

<body> 
<%
  //String USERID=request.getParameter("USERID");
  String PASSWORD=request.getParameter("PASSWORD");

  
  out.println("<b>修改"+UserName+":</b><br>");
try
    {
	Statement statement=con.createStatement();
	String sql="UPDATE ORADDMAN.wsUser SET PASSWORD='"+PASSWORD+"' WHERE USERNAME='"+UserName+"'";
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
<br><%=UserName%> 修改完成!<br>
<a href="/Oradds/ORAddsMainMenu.jsp">回首頁</a><br>
</body>
</html>
