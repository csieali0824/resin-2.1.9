<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,CheckBoxBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateREGIONAdd.jsp</title>
</head>

<body  background="../image/b01.jpg"> 
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>

<%
  String[] LOCALE=request.getParameterValues("LOCALE");
  String LOCALE_ENG_NAME=request.getParameter("LOCALE_ENG_NAME");
  String REGION=request.getParameter("REGION");

  try
  {
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
		out.println("REGION :"+REGION+"新增完成");
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
<form action="CreateRegion.jsp" method="post" name="signform">
<input type="hidden" name="REGION" value="<%= REGION %>" >
TO CONTINUE:<input type="submit" name="submit" value="ADD" >
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp" %>
<!--=================================-->

<a href="../jsp/CreateRegion.jsp">回新增頁</a><br>
</body>
</html>
