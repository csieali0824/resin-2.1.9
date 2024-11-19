<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>UpdateRegion.jsp</title>
</head>

<body background="../image/b01.jpg"> 
<%
  String[] LOCALE=request.getParameterValues("LOCALE");
  String[] LOCALE2=request.getParameterValues("LOCALE2");
  String REGION=request.getParameter("REGION");
   //out.println(LOCALE2); 
try
   {
     Statement statement=con.createStatement();


   out.println("<ul>");
	 if(REGION != null)
	 {	  		  
		  String sql="delete from WsREGION where REGION='"+REGION+"'";
		  //刪除
		
		 
		  //out.println(REGION);
		  //out.println("陸地刪除完成<br>");
          statement.executeUpdate(sql);
		  statement.close();
	   }
	 else
	 {
	  out.println("請輸入陸地資料");
	  out.println("</ul><br>");
	 }  
	 
	 ////////////////////////////////////////////////////////////
	 
	 
	 
	 String sql="insert into WSREGION(REGION,LOCALE) values(?,?)";
	 //新增	 	 
	 
	 
  	 out.println("<ul>");
	 if(LOCALE != null)
	 {
	   for(int i=0; i<LOCALE.length ; i++)
	    {
		  PreparedStatement pstmt=con.prepareStatement(sql);
		  //out.println("REGION :"+REGION+"<br>");
		  //out.println("LOCALE :"+LOCALE[i]+"<br>");
		  pstmt.setString(1,REGION);
	      pstmt.setString(2,LOCALE[i]);
		  pstmt.executeUpdate();
		  pstmt.close();
		}
		out.println("REGION :"+REGION+"修改完成");
	 }
	 else
	 {
	   out.println("請輸入資料");
	 out.println("</ul><br>");
	 }
//////////////////////////////////////////////////////////////////////////

	 String sql2="insert into WSREGION(REGION,LOCALE) values(?,?)";
	 //新增	 	 
	 
	 

	 if(LOCALE2 != null)
	 {
	   for(int i=0; i<LOCALE2.length ; i++)
	    {
		  PreparedStatement pstmt=con.prepareStatement(sql);
		  //out.println("REGION :"+REGION+"<br>");
		  //out.println("LOCALE :"+LOCALE2[i]+"<br>");
		  pstmt.setString(1,REGION);
	      pstmt.setString(2,LOCALE2[i]);
		  pstmt.executeUpdate();
		  pstmt.close();
		}
		out.println("REGION :"+REGION+"修改完成");
	 }
	 else
	 {
	   out.println("請輸入資料");
	 out.println("</ul><br>");
	 }
 
	 
	 
	 
     
   }//try of end
    catch (Exception e)
  {
    out.println("Exception:"+e.getMessage());
  }
%>
<form action="EditRegionDb.jsp" method="post" name="signform">
<input type="hidden" name="REGION" value="<%= REGION %>" >
TO CONTINUE:<input type="submit" name="submit" value="ADD" >
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp" %>
<!--=================================-->

<a href="../jsp/EditRegion.jsp">回修改頁</a><br>
</body>
</html>
