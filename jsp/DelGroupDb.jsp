<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="CheckBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>DelGroupDb.jsp</title>
</head>

<body> 
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>

<%
  String[] GROUPNAME=request.getParameterValues("GROUPNAME");
  try
  {
	 
	 if(GROUPNAME != null)
	 {
	    
	   for(int i=0; i<GROUPNAME.length ; i++)
	   {
	      Statement statement=con.createStatement();	  		  
		  String sql="delete from WsGroup where GROUPNAME ='"+GROUPNAME[i]+"'";
		  //刪除群組名稱,說明
		  Statement statement1=con.createStatement();	  		  
		  String sql1="delete from Wsgroupuserrole where GROUPUSERNAME ='"+GROUPNAME[i]+"'";
		  //刪除群組名稱,角色
		  Statement statement2=con.createStatement();	  		  
		  String sql2="delete from Wsusergroup where GROUPNAME ='"+GROUPNAME[i]+"'";
		  //刪除群組成員,群組名稱
		  out.println(GROUPNAME[i]);
		  out.println("群組刪除完成");
          statement.executeUpdate(sql);
	      statement1.executeUpdate(sql1);
		  statement2.executeUpdate(sql2);
		  statement.close();
	      statement1.close();
		  statement2.close();
		  }
	   }
	 else
	 {
	   out.println("<font color=#FF0000><strong>請輸入資料</strong></font>");
	   out.println("</ul><br>");
	 }  
	 
  }//end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
  
 %>
 <br><a href="../jsp/DelGroup.jsp">回上一頁</a>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>