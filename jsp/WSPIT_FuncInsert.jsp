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
<title>Function Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<%
String code=request.getParameter("CODE");
String class1=request.getParameter("CLASS1");
//if (class1.equals("MAIN")){class1="M";} else {class1="S";}
String name=request.getParameter("NAME");
String ref=request.getParameter("REF");
String desc=request.getParameter("DESC");
String locale=request.getParameter("LOCALE");
try
{  
  String sql="insert into pit_function values(?,?,?,?,?,?,?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,code);
  pstmt.setString(2,class1);  
  pstmt.setString(3,name);
  pstmt.setString(4,desc);
  pstmt.setString(5,ref);  
  pstmt.setString(6,locale);
  pstmt.setString(7,dateBean.getYearMonthDay());
  pstmt.setString(8,dateBean.getHourMinute());  
  pstmt.setString(9,userID);
  pstmt.executeUpdate();
  
  out.println("insert into pit_function  Data OK!! (code:"+code+")<BR>");
  out.println("<A HREF=../jsp/WSPIT_FuncQueryAll.jsp>Query All Function</A>");
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
