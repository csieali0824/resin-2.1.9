<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>DelResginAllDb.jsp</title>
</head>

<body background="../image/b01.jpg"> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<%
  String REGION=request.getParameter("REGION");


  try
  {
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select REGION from WsREGION WHERE REGION='"+REGION+"'");
   rsBean.setRs(rs);
	 if(rs.next())
	 {	  		  
		  String sql="delete from WsREGION where REGION='"+REGION+"'";
		  //刪除
		 
		  out.println(REGION);
		  out.println("區域刪除完成<br>");
          statement.executeUpdate(sql);
		  statement.close();
	   }
	 else
	 {
	  response.sendRedirect("/wins/jsp/DelResginAll.jsp");
	 }  
  }//end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
  
 %>
 <br><a href="/wins/jsp/DelRegionAll.jsp">回上一頁</a>
 <br><a href="/wins/WinsMainMenu.jsp">回首頁</a>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>