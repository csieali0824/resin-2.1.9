<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Update the selected PIT OBJECT</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
String objectid=request.getParameter("OBJECTID");
String name=request.getParameter("NAME");
String desc=request.getParameter("DESC");
try
{  
  if (objectid!=null)
  {
	  String sql="update PIT_OBJECT set NAME=?,DESCRIPTION=? where OBJECTID='"+objectid+"'";   
	  PreparedStatement pstmt=con.prepareStatement(sql); 
	  pstmt.setString(1,name); 
	  pstmt.setString(2,desc); 
	  pstmt.executeUpdate();                 	
	  pstmt.close();  
	  out.println("("+objectid+") 已更新!");
  } else {
     out.println("未更新任何功能清單資訊!");
  }	  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
<BR>
<a href="../WinsMainMenu.jsp">回首頁</a>&nbsp;  &nbsp;<A HREF="WSPIT_ObjectQueryAll.jsp">物件定義 清單</A><br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

