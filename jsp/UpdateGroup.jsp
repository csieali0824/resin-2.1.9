<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>UpdataGroup.jsp</title>
</head>

<body> 
<%
   String[] USERNAME=request.getParameterValues("USERNAME");
   String GROUPDESC=request.getParameter("GROUPDESC");
   String GROUPPROFILE=request.getParameter("GROUPPROFILE");
   String[] ROLENAME=request.getParameterValues("ROLENAME");
   String GROUPNAME =(String) session.getAttribute("GROUPNAME");
  
   
  
   
  out.println("<b>修改"+GROUPNAME+":</b><br>");
try
    {
	Statement statement=con.createStatement();
	Statement statement1=con.createStatement();
	Statement statement2=con.createStatement();
	String sql="UPDATE WsGroup SET GROUPDESC='"+GROUPDESC+"',GROUPPROFILE='"+GROUPPROFILE+"' WHERE GROUPNAME='"+GROUPNAME+"'";
	statement.executeUpdate(sql);
	statement.close();
	//修改人名
	out.println("修改群組說明:"+GROUPDESC);
	out.println("<br>群組系統基本設定:"+GROUPPROFILE);
	 out.println("<ul>");
	 if(USERNAME != null)
	 {
	 	  String sql1="delete from Wsusergroup where GROUPNAME ='"+GROUPNAME+"'";
		  //刪除群組成員,群組名稱
          statement1.executeUpdate(sql1);
	   for(int i=0; i<USERNAME.length ; i++)
	    {
		  String sql3="insert into Wsusergroup(USERNAME,GROUPNAME) values(?,?)";
		   //新增群組成員,群組名稱
		  PreparedStatement pstmt1=con.prepareStatement(sql3);
		  pstmt1.setString(1,USERNAME[i]);
	      pstmt1.setString(2,GROUPNAME);
		  pstmt1.executeUpdate();
		  out.println("<li>人員名稱:"+USERNAME[i]);
		}
	 }
	 else
	 {
	   out.println("請輸入人員資料");
	 out.println("</ul><br>");
	 }
	 
	 
	 
	 out.println("<ul>");
	 if(ROLENAME== null)
	 { out.println("請輸入角色資料");}
	 else
	 {
	      String sql2="delete from WSROLEGROUP where GROUPNAME ='"+GROUPNAME+"'";
		  //刪除群組名稱,角色
		  statement2.executeUpdate(sql2);
	
	   for(int i=0; i<ROLENAME.length ; i++)
	    {
		  String sql4="insert into WSROLEGROUP(GROUPNAME,ROLENAME) values(?,?)";
		   //新增群組名稱,角色
		  PreparedStatement pstmt2=con.prepareStatement(sql4);
		  pstmt2.setString(1,GROUPNAME);
	      pstmt2.setString(2,ROLENAME[i]);
		  pstmt2.executeUpdate();
		  out.println("<li>角色:"+ROLENAME[i]);	  
	  }
	 }
    statement1.close();
	statement2.close();
	 for(int h=0; h<USERNAME.length ; h++)
	    { 
		 for(int i=0; i<ROLENAME.length ; i++)
	    {
        Statement stmtexist=con.createStatement();
	    String sSql="select GROUPUSERNAME from WSGROUPUSERROLE where ROLENAME ='"+ROLENAME[i]+"' and GROUPUSERNAME='"+USERNAME[h]+"'"; 
	    //out.println(sSql); 
       ResultSet rsexist=stmtexist.executeQuery(sSql);
	   if  (!rsexist.next())
	   {	 		
	       String sql5="insert into WSGROUPUSERROLE(GROUPUSERNAME,ROLENAME) values(?,?)";
		   //新增群組名稱,角色
		  PreparedStatement pstmt5=con.prepareStatement(sql5);
		  pstmt5.setString(1,USERNAME[h]);
	      pstmt5.setString(2,ROLENAME[i]);
		  pstmt5.executeUpdate();  
	    }		 
     stmtexist.close();
	 rsexist.close();
	 
		}
	}
	
	
   }//try of end
    catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<br><%=GROUPNAME%> 修改完成!<br>
<a href="../WinsMainMenu.jsp">回首頁</a>&nbsp;  &nbsp;<A HREF="../jsp/GroupShow.jsp">查詢群組記錄</A><br>
</body>
</html>
