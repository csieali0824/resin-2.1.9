<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Features Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String featureCode=request.getParameter("FEATURECODE");
String featureName=request.getParameter("FEATURENAME");
String featureLocalName=request.getParameter("FEATURELOCALNAME");
String locale=request.getParameter("LOCALE");

try
{  
  String sql="insert into PIFEATURES values(?,?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,featureCode);
  pstmt.setString(2,featureName); 
  pstmt.setString(3,featureLocalName); 
  pstmt.setString(4,locale);
  
  pstmt.executeUpdate();
  
  out.println("insert into Features Data OK!! (Feature:"+featureName+")<BR>");
  out.println("<A HREF=../jsp/PIFeaturesQueryAll.jsp>Query All Features</A>");
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
