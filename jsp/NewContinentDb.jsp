<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>NewContinentDb.jsp</title>
</head>

<body> 

<%
  String CONTINENT=request.getParameter("CONTINENT");
  String CONTINENT_NAME=request.getParameter("CONTINENT_NAME");

  try
  {
   String sql="insert into WsContinent(CONTINENT,CONTINENT_NAME) values(?,?)";
	 //新增

	 PreparedStatement pstmt=con.prepareStatement(sql);	 	 
	 
	 pstmt.setString(1,CONTINENT);
	 pstmt.setString(2,CONTINENT_NAME);
	 pstmt.executeUpdate(); 
	 pstmt.close();
   } 
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
 <br>陸地名稱:<%= CONTINENT_NAME %> 加入記錄完成!<br>
 <a href="../jsp/System.jsp">回新增頁</a><br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>