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
<title>PIT Version Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<%
String version=request.getParameter("VERSION");
String verDesc=request.getParameter("DESC");
String country=request.getParameter("COUNTRY");
String object=request.getParameter("OBJECT");
String model=request.getParameter("MODEL");
String product=request.getParameter("PRODUCT");

String sql=null;
PreparedStatement pstmt=null;
try
{  
  //先將之前同樣條件的舊版本資訊ACTIVE改成N
  sql="update PIT_VERSION set ACTIVE='N' where PRODUCT='"+product+"' and MODEL='"+model+"'"+
      " and T_OBJECT='"+object+"' and COUNTRY='"+country+"' and ACTIVE='Y'";
  pstmt=con.prepareStatement(sql);
  pstmt.executeUpdate();	
  pstmt.close();  
  
  //再插入新的版本資訊
  sql="insert into PIT_VERSION values(?,?,?,?,?,?,?,?,?,?)";
  pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,product);
  pstmt.setString(2,model);  
  pstmt.setString(3,object);
  
  pstmt.setString(4,country);
  pstmt.setString(5,version);
  pstmt.setString(6,verDesc);
  pstmt.setString(7,dateBean.getYearMonthDay());
  pstmt.setString(8,dateBean.getHourMinute());
  pstmt.setString(9,userID);
  pstmt.setString(10,"Y");
  
  pstmt.executeUpdate();
  
  out.println("新的測試發行 版本輸入成功!! (VERSION:"+version+")<BR>");
  out.println("<A HREF=../jsp/WSPIT_VersionQueryAll.jsp>測試發行版本 清單</A>");
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
