<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Ringtone Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>

<body>
<%
String ringtoneCode=request.getParameter("RINGTONECODE");
String ringtoneLocalName=request.getParameter("RINGTONELOCALNAME");
String locale=request.getParameter("LOCALE");

try
{  
  String sql="insert into PIRINGTONE values(?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,ringtoneCode);
  pstmt.setString(2,ringtoneLocalName);  
  pstmt.setString(3,locale);
  
  pstmt.executeUpdate();
  
  out.println("insert into Ringtone Data OK!! (Ringtone:"+ringtoneCode+")<BR>");
  out.println("<A HREF=../jsp/PIRingtoneQueryAll.jsp>Query All Ringtone</A>");
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
