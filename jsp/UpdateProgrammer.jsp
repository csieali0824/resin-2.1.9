<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>UpdateProgrammer.jsp</title>
</head>

<body> 
<%
  String ADDRESSDESC=request.getParameter("ADDRESSDESC");
  String ROLENAME=request.getParameter("ROLENAME");
  String ADDRESS=request.getParameter("ADDRESS_");
  String MODEL=request.getParameter("MODEL");
  String PROGRAMMERNAME=request.getParameter("PROGRAMMERNAME");
  String LINENO=request.getParameter("LINENO");
 // out.println(ADDRESSDESC);  
  //out.println(ADDRESS);  
  //out.println(PROGRAMMERNAME);  
try
    {
	 Statement stmtexist=con.createStatement();
	 String sSql="select MODEL, LINENO from wsProgrammer where ADDRESS ='"+ADDRESS+"'"; 
	 //out.println(sSql); 
     ResultSet rsexist=stmtexist.executeQuery(sSql);
     if(rsexist.next())
	 {MODEL=rsexist.getString("MODEL"); 
	 LINENO=rsexist.getString("LINENO"); 	 

	Statement statement=con.createStatement();
	String sql="UPDATE WSProgrammer SET  ROLENAME='"+ROLENAME+"',ADDRESS='"+ADDRESS+"',MODEL='"+MODEL+"',PROGRAMMERNAME='"+PROGRAMMERNAME+"',LINENO='"+LINENO+"' WHERE ADDRESSDESC='"+ADDRESSDESC+"'";
	statement.executeUpdate(sql);
	statement.close();
	}
	 stmtexist.close();
	 rsexist.close();
   }//try of end
    catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<br><%= ROLENAME %> 修改完成!<br>
<a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/ShowProgrammer.jsp">查詢所有角色記錄</A>
</body>
</html>
