<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Display Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String displayName=request.getParameter("DISPLAYNAME");
String displayLocalName=request.getParameter("DISPLAYLOCALNAME");
String locale=request.getParameter("LOCALE");

try
{  
  String sql="insert into PIDISPLAY values(?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,displayName); 
  pstmt.setString(2,displayLocalName );
  pstmt.setString(3,locale);
  
  pstmt.executeUpdate();
  
  out.println("insert into Display Data OK!! (DisplayName:"+displayName+")<BR>");
  out.println("<A HREF=../jsp/PIDisplayQueryAll.jsp>Query All Display</A>");
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
