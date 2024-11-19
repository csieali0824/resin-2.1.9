<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>System Mode Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>

<body>
<%
String systemMode=request.getParameter("SYSTEMMODE");
String modeDesc=request.getParameter("MODEDESC");

try
{  
  String sql="insert into PISYSTEMMODE values(?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,systemMode);
  pstmt.setString(2,modeDesc);  
  
  pstmt.executeUpdate();
  
  out.println("insert into System Mode Data OK!! (Mode Name:"+systemMode+")<BR>");
  out.println("<A HREF=../jsp/PISystemModeQueryAll.jsp>Query All System Mode</A>");
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
