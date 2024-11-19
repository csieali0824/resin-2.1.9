<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="RsBean" %> 
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>SelectEmployeeDb.jsp</title>
</head>

<body> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>

<%
  
  String USERNAME=request.getParameter("USERNAME");
  String ROLENAME="";
  String GROUPNAME="";
  
  try
  {
   
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select USERNAME from WsUser WHERE USERNAME='"+USERNAME+"'");
   rsBean.setRs(rs);
   
   if(rs.next())
   {      
         //session.setAttribute("Login","ok");
		 //session.setAttribute("USERID",USERID);  	  
         //session.setAttribute("USERNAME",USERNAME);
		 out.println("<H4>人名"+USERNAME+"</H4>");
		 
		 rs=statement.executeQuery("select ROLENAME from WsGroupUserRole WHERE GROUPUSERNAME='"+USERNAME+"'");  
		 while(rs.next()){
		 	ROLENAME = rs.getString("ROLENAME");
			out.print("角色:"+rs.getString("ROLENAME")+"<br>"); 
		 	//session.setAttribute("ROLENAME",ROLENAME);
		 }
		 
		 rs=statement.executeQuery("select GROUPNAME from WsUserGroup WHERE USERNAME='"+USERNAME+"'");
		 while(rs.next()){
		 	GROUPNAME = rs.getString("GROUPNAME");
			out.print("群組:"+rs.getString("GROUPNAME")+"<br>");
		 	//session.setAttribute("GROUPNAME",GROUPNAME);
		 }
	   
   }	   
    else
	     response.sendRedirect("../jsp/SelectEmployee2.jsp");
   statement.close();  
   rs.close();
  } //end of try
  catch (Exception e)
  {

   e.printStackTrace();
   out.println("Exception:"+e.getMessage());
  }
 %>
 <a href="../jsp/SelectEmployee.jsp">回查詢頁</a><br>
 <a href="/wins/WinsMainMenu.jsp">回首頁</a>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>