<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="CheckBoxBean,ArrayLstChkBoxInputBean,CheckBoxBeanNew" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateGroupDb.jsp</title>
</head>

<body> 
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>

<jsp:useBean id="arrayLstChkBoxInputBean" scope="session" class="ArrayLstChkBoxInputBean"/>
成員:<BR>
<%
  String GROUPNAME=request.getParameter("GROUPNAME");
  String GROUPDESC=request.getParameter("GROUPDESC");
  String GROUPPROFILE=request.getParameter("GROUPPROFILE");
  String[] USERNAME=request.getParameterValues("USERNAME");
  String[] ROLENAME=request.getParameterValues("ROLENAME");
   //String a[][]=arrayLstChkBoxInputBean.getArray2DContent()  ; 
   try
  {
     Statement stmtexist=con.createStatement();
	 String sSql="select GROUPNAME from Wsgroup where GROUPNAME ='"+GROUPNAME+"'"; 
	 //out.println(sSql); 
     ResultSet rsexist=stmtexist.executeQuery(sSql);
	 if  (rsexist.next())
	 {out.println("此群組已存在，請重新輸入"); }
	 else
	 {
	 String sql="insert into Wsgroup(GROUPNAME,GROUPDESC,GROUPPROFILE) values(?,?,?)";	 
	 //新增群組名稱,說明
	 PreparedStatement pstmt=con.prepareStatement(sql);	 	 
	  pstmt.setString(1,GROUPNAME);
	 pstmt.setString(2,GROUPDESC);
	 pstmt.setString(3,GROUPPROFILE);
	 pstmt.executeUpdate(); 
	 pstmt.close();	  
	  } 
     stmtexist.close();
	 rsexist.close();
	 
	
	 
   	 if(USERNAME != null)
	 {
	   for(int i=0; i<USERNAME.length ; i++)
     {
	 String sql1="insert into Wsusergroup(USERNAME,GROUPNAME) values(?,?)";
	 //新增群組成員,群組名稱
	      PreparedStatement pstmt1=con.prepareStatement(sql1);
		  pstmt1.setString(1,USERNAME[i]);
	      pstmt1.setString(2,GROUPNAME);
		  pstmt1.executeUpdate();		  		  
		  pstmt1.close();		  
		  out.println("*"+USERNAME[i]+"<BR>");
		}
	 }
	 else
	 {
	   out.println("請輸入資料");
	   out.println("</ul><br>");
	 }
	 out.println("<ul>");
	 if(ROLENAME != null)
	 {
	   for(int i=0; i<ROLENAME.length ; i++)
	    {
	     String sql2="insert into WSROLEGROUP(GROUPNAME,ROLENAME) values(?,?)";
	       //新增群組名稱,角色
		  PreparedStatement pstmt2=con.prepareStatement(sql2);
		  pstmt2.setString(1,GROUPNAME);
	      pstmt2.setString(2,ROLENAME[i]);
		  pstmt2.executeUpdate();
		  pstmt2.close();
		  out.println("角色:<li>");
		  out.println(ROLENAME[i]);
		}
	 }
	 else
	 {
	   out.println("請輸入資料");
	   out.println("</ul><br>");
	  }
  	 for(int h=0; h<USERNAME.length ; h++)
	    { 
		 for(int i=0; i<ROLENAME.length ; i++)
	    {
        Statement existstmt=con.createStatement();
	    String sSql2="select GROUPUSERNAME from WSGROUPUSERROLE where ROLENAME ='"+ROLENAME[i]+"' and GROUPUSERNAME='"+USERNAME[h]+"'"; 
	    //out.println(sSql2); 
       ResultSet rsexist2=existstmt.executeQuery(sSql2);
	   if  (!rsexist2.next())
	   {	 		
	       String sql5="insert into WSGROUPUSERROLE(GROUPUSERNAME,ROLENAME) values(?,?)";
		   //新增群組名稱,角色
		  PreparedStatement pstmt5=con.prepareStatement(sql5);
		  pstmt5.setString(1,USERNAME[h]);
	      pstmt5.setString(2,ROLENAME[i]);
		  pstmt5.executeUpdate();  
	    }		 
     existstmt.close();
	 rsexist2.close();
	 
		}
	}
   
   }//end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
 <br>群組名稱:<%= GROUPNAME %> 、群組說明:<%= GROUPDESC %> 加入記錄完成!<br>
<A HREF="/wins/WinsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;<A HREF="../jsp/CreateGroup.jsp">回上一頁</A>&nbsp;&nbsp;<A HREF="../jsp/GroupShow.jsp">查詢群組記錄</A></body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
