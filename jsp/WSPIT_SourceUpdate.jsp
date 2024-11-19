<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Update the selected PIT Source</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
String sourceID=request.getParameter("ID");
String desc=request.getParameter("DESC");
String name=request.getParameter("NAME");

try
{  
  if (sourceID!=null)
  {
	  String sql="update PIT_SOURCE set NAME=?,DESCRIPTION=? where SOURCEID='"+sourceID+"'";   
	  PreparedStatement pstmt=con.prepareStatement(sql); 
	  pstmt.setString(1,name); 
	  pstmt.setString(2,desc); 	    
	  
	  pstmt.executeUpdate();                 	
	  pstmt.close();  
	  out.println("來源:("+sourceID+") 已更新!");
  } else {
     out.println("未更新任何來源資訊!");
  }	  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
<BR>
<a href="../WinsMainMenu.jsp">回首頁</a>&nbsp;  &nbsp;<A HREF="WSPIT_SourceQueryAll.jsp">測試來源 清單</A><br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
