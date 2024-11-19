<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="CheckBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>SelectGroupDb.jsp</title>
</head>

<body> 
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>

<%
  String USERNAME=request.getParameter("USERNAME");
  String[] ROLENAME=request.getParameterValues("ROLENAME");
  String[] GROUPNAME=request.getParameterValues("GROUPNAME");
  try
  {
	 if(GROUPNAME != null)
	 {
	    
	   for(int i=0; i<GROUPNAME.length ; i++)
	   {
	      Statement statement1=con.createStatement();
		  Statement statement2=con.createStatement();
		  ResultSet rs1=statement1.executeQuery("select USERNAME from Wsusergroup where GROUPNAME ='"+GROUPNAME[i]+"'");
		  //查詢人員
		  out.print(GROUPNAME[i]+"群組:<br>");
		  while(rs1.next())
		  {
		   USERNAME = rs1.getString("USERNAME");
		   out.print("人員:"+USERNAME+"<br>");
		  }
		  ResultSet rs2=statement2.executeQuery("Select ROLENAME from  Wsgroupuserrole where GROUPUSERNAME ='"+GROUPNAME[i]+"'");
		  while(rs2.next())
		  {
		  out.print("角色:"+rs2.getString("ROLENAME")+"<br>");
		  //查詢角色
		  }//end of while 
	      statement1.close();
		  statement2.close();
		}//end of for
	 }//end of if
   else
   {
     response.sendRedirect("../jsp/SelectGroup2.jsp");
   }
 
 }//end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
  
 %>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
 <a href="../jsp/SelectGroup.jsp">回查詢頁</a><br>
 <a href="/wins/WinsMainMenu.jsp">回手頁</a>
</body>
</html>
