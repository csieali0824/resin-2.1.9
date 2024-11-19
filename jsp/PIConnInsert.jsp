<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Connectivity Specifics Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>

<body>
<%
String connName=request.getParameter("CONNNAME");
String connFeature=request.getParameter("CONNFEATURE");

try
{  
  String sql="insert into PICONN values(?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,connName);
  pstmt.setString(2,connFeature);  
  
  pstmt.executeUpdate();
  
  out.println("insert into Connectivity Specifics Data OK!! (Connectivity Name:"+connName+")<BR>");
  out.println("<A HREF=../jsp/PIConnQueryAll.jsp>Query All Connectivity Specifics</A>");
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
