<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Band Mode Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>

<body>
<%
String bandMode=request.getParameter("BANDMODE");
String bandModeLocalName=request.getParameter("BANDMODELOCALNAME");
String locale=request.getParameter("LOCALE");

try
{  
  String sql="insert into PIBANDMODE values(?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,bandMode);
  pstmt.setString(2,bandModeLocalName);  
  pstmt.setString(3,locale);
  
  pstmt.executeUpdate();
  
  out.println("insert into Band Mode Data OK!! (BandMode:"+bandModeLocalName+")<BR>");
  out.println("<A HREF=../jsp/PIBandModeQueryAll.jsp>Query All Band Mode</A>");
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
