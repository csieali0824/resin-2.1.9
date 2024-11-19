<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>DelProgrammerDb.jsp</title>
</head>

<body> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<%
  String ROLENAME=request.getParameter("ROLENAME");
  String MODEL=request.getParameter("MODEL");
  String PROGRAMMERNAME=request.getParameter("PROGRAMMERNAME");

  try
  {
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select * from WsProgrammer WHERE ROLENAME='"+ROLENAME+"' and PROGRAMMERNAME='"+PROGRAMMERNAME+"'");
   rsBean.setRs(rs);
	 if(rs.next())
	 {	  		  
		  String sql="delete from WsProgrammer where ROLENAME='"+ROLENAME+"' and PROGRAMMERNAME='"+PROGRAMMERNAME+"'and MODEL='"+MODEL+"'";
		  //刪除
		 
		  out.println(ROLENAME);
		  out.println("刪除完成<br>");
          statement.executeUpdate(sql);
		  rs.close();
		  statement.close();
	   }
	 else
	 {
	  response.sendRedirect("/wins/jsp/DelProgrammer.jsp");
	 }  
  }//end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
  
 %>
 <br><a href="/wins/jsp/DelProgrammer.jsp">回上一頁</a>
 <br><a href="/wins/WinsMainMenu.jsp">回首頁</a>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>