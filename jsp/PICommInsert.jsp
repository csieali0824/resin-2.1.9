<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>COMM Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String commName=request.getParameter("COMMNAME");
String commLocalName=request.getParameter("COMMLOCALNAME");
String locale=request.getParameter("LOCALE");

try
{  
  String sql="insert into PICOMM values(?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,commName);
  pstmt.setString(2,commLocalName);  
  pstmt.setString(3,locale);
  
  pstmt.executeUpdate();
  
  out.println("insert into COMM Data OK!! (COMM Name:"+commName+")<BR>");
  out.println("<A HREF=../jsp/PICommQueryAll.jsp>Query All COMM</A>");
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
