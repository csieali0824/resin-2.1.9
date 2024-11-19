<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateProgrammerDb.jsp</title>
</head>

<body> 

<%
  String ROLENAME=request.getParameter("ROLENAME");
  //out.println(ROLENAME); 
  String ADDRESS=request.getParameter("ADDRESS");
  String ADDRESSDESC=request.getParameter("ADDRESSDESC");
  String MODEL=request.getParameter("MODEL");
  String PROGRAMMERNAME=request.getParameter("PROGRAMMERNAME");
  String LINENO=request.getParameter("LINENO");
   out.print("流水號:"+ADDRESSDESC);
  try
  {
     Statement stmtexist=con.createStatement();
	 String sSql="select ADDRESS from wsProgrammer where ADDRESS ='"+ADDRESS+"' AND trim(ROLENAME)='"+ROLENAME+"' "; 
	 //out.println(sSql); 
     ResultSet rsexist=stmtexist.executeQuery(sSql);
	 if  (rsexist.next())
	 {out.println("此程式檔已存在，請重新輸入"); }
	 else
	 {
     String sql="insert into WsProgrammer(ROLENAME,ADDRESS,ADDRESSDESC,MODEL,PROGRAMMERNAME,LINENO) values(?,?,?,?,?,?)";
	 //新增

	 PreparedStatement pstmt=con.prepareStatement(sql);	 	 
	 
	 pstmt.setString(1,ROLENAME);
	 pstmt.setString(2,ADDRESS);
	 pstmt.setString(3,ADDRESSDESC);
	 pstmt.setString(4,MODEL);
	 pstmt.setString(5,PROGRAMMERNAME);
	 pstmt.setString(6,LINENO);
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
 <br>授權:<%= ROLENAME %> 加入記錄完成!<br>
 <a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/ShowProgrammerAdmin.jsp">查詢程式檔案資訊</A>&nbsp;&nbsp; <a href="../jsp/CreateProgrammer.jsp">回上頁</a><br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>