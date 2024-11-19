<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="RsBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EmployeeDb.jsp</title>
</head>

<body> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>


<%
  String USERNAME=request.getParameter("USERNAME");
 
  
  try
  {
   Statement statement=con.createStatement();
   
   ResultSet rscheck=statement.executeQuery("select COUNT (*) from WsUser where USERNAME='"+USERNAME+"'");
	rscheck.next();
	if(rscheck.getInt(1)==0)
	{
	  response.sendRedirect("../jsp/Employee2.jsp");
	} 
	rscheck.close();
	
   ResultSet rs=statement.executeQuery("select USERNAME,WEBID,USERMAIL,USERPROFILE from WsUser WHERE USERNAME='"+USERNAME+"'");
   rsBean.setRs(rs);
   out.println(rsBean.getRsString());   
   statement.close();
   rs.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
 

 
 
 <a href="/wins/jsp/Employee1.jsp">回查詢頁</a><br>
 <a href="/wins/WinsMainMenu.jsp">回首頁</a>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>



