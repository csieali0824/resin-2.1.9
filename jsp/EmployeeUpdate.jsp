<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EmployeeUpdate.jsp</title>
</head>

<body>
<%
  String USERNAME=request.getParameter("USERNAME");
  String WEBID=request.getParameter("WEBID");
  String USERMAIL=request.getParameter("USERMAIL");
  String USERPROFILE=request.getParameter("USERPROFILE");
  String PASSWORD=request.getParameter("PASSWORD");
  String USERLOCK=request.getParameter("USERLOCK");
  String[] GROUPNAME=request.getParameterValues("GROUPNAME");
  String[] ROLENAME=request.getParameterValues("ROLENAME");
  
  out.println("<b>修改"+USERNAME+":</b><br>");
try
    {
	Statement statement=con.createStatement();
	Statement statement1=con.createStatement();
	Statement statement2=con.createStatement();
	
	String sql="UPDATE WSUser SET WEBID='"+WEBID+"',USERMAIL='"+USERMAIL+"',USERPROFILE='"+USERPROFILE+"',PASSWORD='"+PASSWORD+"',LOCKFLAG='"+USERLOCK+"'   WHERE USERNAME='"+USERNAME+"'";
	//out.println(sql); 
	statement.executeUpdate(sql);
	statement.close();
	//修改人名
	 out.println("<ul>");
	 //out.println(GROUPNAME); 
	 if(GROUPNAME != null)
	 {
	     String sql1="delete from WSusergroup where USERNAME ='"+USERNAME+"'";
		  //刪除群組成員,群組名稱
          statement1.executeUpdate(sql1);
	   for(int i=0; i<GROUPNAME.length ; i++)
	    {
		  String sql2="insert into WSusergroup(USERNAME,GROUPNAME) values(?,?)";
		   //新增群組成員,群組名稱
		  PreparedStatement pstmt1=con.prepareStatement(sql2);
		  pstmt1.setString(1,USERNAME);
	      pstmt1.setString(2,GROUPNAME[i]);
		  pstmt1.executeUpdate();
		  out.println("<li>群組名稱:"+GROUPNAME[i]); 
		}
	 }
	 else
	 {
	   out.println("請輸入群組資料");
	 out.println("</ul><br>");
	 }
	 
	 
	 
	 out.println("<ul>");
	 if(ROLENAME != null)
	 {
	      String sql3="delete from WSgroupuserrole where GROUPUSERNAME ='"+USERNAME+"'";
		  //刪除人員名稱,角色
		  statement2.executeUpdate(sql3);
	   for(int i=0; i<ROLENAME.length ; i++)
	    {
		  String sql4="insert into WSgroupuserrole(GROUPUSERNAME,ROLENAME) values(?,?)";
		   //新增人員名稱,角色
		  PreparedStatement pstmt2=con.prepareStatement(sql4);
		  pstmt2.setString(1,USERNAME);
	      pstmt2.setString(2,ROLENAME[i]);
		  pstmt2.executeUpdate();
		  out.println("<li>角色:"+ROLENAME[i]);
		}
	 }
	 else
	 {
	   out.println("請輸入角色資料");
	 out.println("</ul><br>");
	 }
    statement1.close();
	statement2.close();
   }//try of end
    catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<br><%=USERNAME%> 修改完成!<br>
<a href="../WinsMainMenu.jsp">回首頁</a>&nbsp;  &nbsp;<A HREF="../jsp/EmployeeShow.jsp">查詢人員記錄</A><br>
</body>
</html>
