<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Camera Specifics Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>

<body>
<%
String cameraName=request.getParameter("CAMERANAME");
String cameraFeature=request.getParameter("CAMERAFEATURE");

try
{  
  String sql="insert into PICAMERA values(?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,cameraName);
  pstmt.setString(2,cameraFeature);  
  
  pstmt.executeUpdate();
  
  out.println("insert into Camera Specifics Data OK!! (Camera Name:"+cameraName+")<BR>");
  out.println("<A HREF=../jsp/PICameraSpecQueryAll.jsp>Query All Camera Specifics</A>");
  pstmt.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
