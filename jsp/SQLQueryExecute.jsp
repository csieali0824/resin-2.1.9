<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QueryAllBean" %>
<html>
<head>
<title>RsTest</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>

<body>
<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<%  
  String sqlStat=request.getParameter("SQL");
  try
  {   
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery(sqlStat);
   queryAllBean.setRs(rs);
   out.println(queryAllBean.getRsString());
   
   statement.close();
   rs.close();  
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</body>
 <!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
