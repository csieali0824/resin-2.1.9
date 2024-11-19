<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>DelContinentDb.jsp</title>
</head>

<body> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<%
  String CONTINENT=request.getParameter("CONTINENT");

  try
  {
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select * from WsContinent WHERE CONTINENT='"+CONTINENT+"'");
   rsBean.setRs(rs);
	 if(rs.next())
	 {	  		  
		  String sql="delete from WsContinent where CONTINENT='"+CONTINENT+"'";
		  //刪除
		 
		  out.println(CONTINENT);
		  out.println("陸地刪除完成<br>");
          statement.executeUpdate(sql);
		  statement.close();
	   }
	 else
	 {
	  response.sendRedirect("/wins/jsp/DelContinent.jsp");
	 }  
  }//end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
  
 %>
 <br><a href="/wins/jsp/DelContinent.jsp">回上一頁</a>
 <br><a href="/wins/WinsMainMenu.jsp">回首頁</a>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>