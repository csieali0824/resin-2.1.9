<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>RoleAdd.jsp</title>
</head>

<body> 

<%
  String ROLENAME=request.getParameter("ROLENAME");
  String ROLEDESC=request.getParameter("ROLEDESC");

  
  try
  {
	  Statement stmtexist=con.createStatement();
	 String sSql="select ROLENAME from WsRole where trim(ROLENAME)='"+ROLENAME+"'"; 
	 //out.println(sSql); 
     ResultSet rsexist=stmtexist.executeQuery(sSql);
	 if  (rsexist.next())
	 {out.println("此角色已存在，請重新輸入"); }
	 else
	 {
	 String sql="insert into WsRole(ROLENAME,ROLEDESC) values(?,?)";
	 PreparedStatement pstmt=con.prepareStatement(sql);
	 
	 pstmt.setString(1,ROLENAME);
	 pstmt.setString(2,ROLEDESC);	 
	 pstmt.executeUpdate(); 
	 pstmt.close();
	   }
	 stmtexist.close();
	 rsexist.close();
   } 
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
 <%= ROLENAME %> 加入記錄完成! <br>
 <a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<a href="/wins/jsp/RoleAdd1.jsp">回上一頁</a>&nbsp;&nbsp;<A HREF="../jsp/RoleShow.jsp">查詢所有角色</A><br>
 
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
