<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>RpprogrammerInsert.jsp</title>
</head>

<body> 

<%
  int Max=0;
  int Max2=0;
  String ROLENAME=request.getParameter("ROLENAME");
  String address=request.getParameter("address");
  String ADDRESSDESC=request.getParameter("ADDRESSDESC");
  String model=request.getParameter("model");
  String programmername=request.getParameter("programmername");
  //String lineno=request.getParameter("lineno");

  //out.print(MODEL);
  out.print("流水號:"+ADDRESSDESC+"<br>");
  out.print("ROLENAME:"+ROLENAME+"<br>");
  out.print("address:"+address+"<br>");
  out.print("model:"+model+"<br>");
  out.print("programmername:"+programmername+"<br>");


  
  try
  {           //取同一模組,同一角色最大排序在加一
        	  Statement statement=con.createStatement();
	          //ResultSet rs=statement.executeQuery("select max(lineno) Max from wsprogrammer where  ROLENAME='"+ROLENAME+"' and MODEL='"+model+"' ");
	          ResultSet rs=statement.executeQuery("select lineno  as Max from wsprogrammer where  address='"+address+"' ");
              if (rs.next()) {
			       Max=rs.getInt("Max"); 
			       //out.print("Max:"+Max+"<br>");
			  }
			   //Max2=Max+1;
			   //out.print("Max2:"+Max2+"<br>");
               rs.close();    
		       statement.close(); 
  
   String sql="insert into wsProgrammer(ROLENAME,ADDRESS,ADDRESSDESC,MODEL,PROGRAMMERNAME,LINENO) values(?,?,?,?,?,?)";
	 //新增

	 PreparedStatement pstmt=con.prepareStatement(sql);	 	 
	 
	 pstmt.setString(1,ROLENAME);
	 pstmt.setString(2,address);
	 pstmt.setString(3,ADDRESSDESC);
	 pstmt.setString(4,model);
	 pstmt.setString(5,programmername);
	 pstmt.setInt(6,Max);
	 pstmt.executeUpdate(); 
	 pstmt.close();
	 	 
   } 
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
 <br>授權角色對應:<%= ROLENAME %> 加入記錄完成!<br>
 <a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/ShowProgrammer.jsp">查詢所有角色記錄</A>&nbsp;&nbsp;<a href="../jsp/RpprogrammerInputPage.jsp">回上頁</a><br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>