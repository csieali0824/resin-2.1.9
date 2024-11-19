<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Update the selected PIT version</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
String version=request.getParameter("VERSION");
String verDesc=request.getParameter("DESC");
String country=request.getParameter("COUNTRY");
String object=request.getParameter("OBJECT");
String model=request.getParameter("MODEL");
String product=request.getParameter("PRODUCT");

try
{  
  if (version!=null)
  {
	  String sql="update PIT_VERSION set PRODUCT=?,MODEL=?,COUNTRY=?,T_OBJECT=?,DESCRIPTION=? where T_VERSION='"+version+"'";   
	  PreparedStatement pstmt=con.prepareStatement(sql); 
	  pstmt.setString(1,product); 
	  pstmt.setString(2,model); 
	  pstmt.setString(3,country); 
	  pstmt.setString(4,object); 
	  pstmt.setString(5,verDesc);    
	  
	  pstmt.executeUpdate();                 	
	  pstmt.close();  
	  out.println("版本:("+version+") 已更新!");
  } else {
     out.println("未更新任何版本資訊!");
  }	  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
<BR>
<a href="../WinsMainMenu.jsp">回首頁</a>&nbsp;  &nbsp;<A HREF="WSPIT_VersionQueryAll.jsp">測試發行版本 清單</A><br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
