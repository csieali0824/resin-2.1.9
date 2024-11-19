<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="CheckBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateEmployeeDb.jsp</title>
</head>

<body> 
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>

<%
  String USERNAME=request.getParameter("USERNAME");
  String WEBID=request.getParameter("WEBID");
  String USERMAIL=request.getParameter("USERMAIL");
  String USERPROFILE=request.getParameter("USERPROFILE");
  String PASSWORD=request.getParameter("PASSWORD");
  String USERLOCK=request.getParameter("USERLOCK");
  String[] ROLENAME=request.getParameterValues("ROLENAME");
  String[] GROUPNAME=request.getParameterValues("GROUPNAME");
  try
  {
    if(USERPROFILE==null && USERPROFILE.equals(null))
	{USERPROFILE="0"; }	 
	 Statement stmtexist=con.createStatement();
	 String sSql="select WEBID from WsUser where WEBID ='"+WEBID+"'"; 
	 //out.println(sSql); 
     ResultSet rsexist=stmtexist.executeQuery(sSql);
	 if  (rsexist.next())
	 {out.println("此人員已存在，請重新輸入"); }
	 else
	 {
	 String sql="insert into WsUser(USERNAME,WEBID,USERMAIL,USERPROFILE,PASSWORD,LOCKFLAG) values(?,?,?,?,?,?)";
	 //新增人員名稱,工號,密碼
	 String sql1="insert into Wsgroupuserrole(GROUPUSERNAME,ROLENAME) values(?,?)";
	 //新增人員名稱,角色
	 String sql2="insert into Wsusergroup(USERNAME,GROUPNAME) values(?,?)";
	 //新增人員名稱,群組名稱
	 PreparedStatement pstmt=con.prepareStatement(sql);
	 PreparedStatement pstmt1=con.prepareStatement(sql1);
	 PreparedStatement pstmt2=con.prepareStatement(sql2);
	 pstmt.setString(1,USERNAME);
	 pstmt.setString(2,WEBID);
	 pstmt.setString(3,USERMAIL);
	 pstmt.setString(4,USERPROFILE);
	 pstmt.setString(5,PASSWORD);
	 pstmt.setString(6,USERLOCK);
 	 out.println("<ul>");
	 if(ROLENAME != null)
	 {
	   for(int i=0; i<ROLENAME.length ; i++)
	    {
		  
		  pstmt1.setString(1,USERNAME);
	      pstmt1.setString(2,ROLENAME[i]);
		  pstmt1.executeUpdate();
		  out.println("角色:<li>");
		  out.println(ROLENAME[i]);
		}
	  }
	  else
	  {
	   out.println("請輸入資料");
	   out.println("</ul><br>");
	   }
	   out.println("<ul>");
	  if(GROUPNAME != null)
	  {
	    for(int i=0; i<GROUPNAME.length ; i++)
	     {
		  
		  pstmt2.setString(1,USERNAME);
	      pstmt2.setString(2,GROUPNAME[i]);
		  pstmt2.executeUpdate();
		  out.println("群組名稱:<li>");
		  out.println(GROUPNAME[i]);
		 }
	  }
	  else
	  {
	   out.println("請輸入資料");
	   out.println("</ul><br>");
	   }
	  pstmt.executeUpdate(); 
	  pstmt.close();
	  pstmt1.close();
	  pstmt2.close();
    } 
     stmtexist.close();
	 rsexist.close();
	} 
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
 <br>人名:<%= USERNAME %> 加入記錄完成!<br>
<a href="../WinsMainMenu.jsp">回首頁</a>&nbsp; <A HREF="../jsp/CreateEmployee.jsp">新增人員</A> &nbsp;<A HREF="../jsp/EmployeeShow.jsp">查詢人員記錄</A>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>