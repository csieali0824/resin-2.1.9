<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Object Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<%
String objectid=request.getParameter("OBJECTID");
String name=request.getParameter("NAME");
String desc=request.getParameter("DESC");
try
{  
  String sql="insert into pit_object values(?,?,?,?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,objectid);
  pstmt.setString(2,name);  
  pstmt.setString(3,desc);
  pstmt.setString(4,dateBean.getYearMonthDay());
  pstmt.setString(5,dateBean.getHourMinute());  
  pstmt.setString(6,userID);
  pstmt.executeUpdate();
  
  out.println("insert into pit_object Data OK!! (objectid:"+objectid+")<BR>");
  out.println("<A HREF=../jsp/WSPIT_ObjectQueryAll.jsp>Query All Object</A>");
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
