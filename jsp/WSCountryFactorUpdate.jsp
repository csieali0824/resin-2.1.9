<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Updating Country Factor</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String country=request.getParameter("COUNTRY");
String baseCountry=request.getParameter("BASECOUNTRY");
String region=request.getParameter("REGION");
String brand=request.getParameter("BRAND");
String exw_adj=request.getParameter("EXW_ADJ");
String vat=request.getParameter("VAT");
String ll_basecoun=request.getParameter("LL_BASECOUN");
String ll_coun_adj=request.getParameter("LL_COUN_ADJ");
String ex_rate=request.getParameter("EX_RATE");
String curr=request.getParameter("CURR");

try
{        
  String sql="update PSALES_COUNTRY_FACTOR set BASECOUNTRY=?,REGION=?,BRAND=?,EXW_ADJ=?,VAT=?,LL_BASECOUN=?,LL_COUN_ADJ=?,EX_RATE=?,CURR=? where COUNTRY='"+country+"'";
  PreparedStatement pstmt=con.prepareStatement(sql);  
 
  pstmt.setString(1,baseCountry); 
  pstmt.setString(2,region);
  pstmt.setString(3,brand);
  pstmt.setString(4,exw_adj);  
  pstmt.setFloat(5,Float.parseFloat(vat)/100);
  pstmt.setString(6,ll_basecoun);
  pstmt.setString(7,ll_coun_adj);
  pstmt.setString(8,ex_rate);
  pstmt.setString(9,curr); 
  
  pstmt.executeUpdate(); 
  
  out.println("Processing Country Factor value(COUNTRY:"+country+") OK!<BR>");
  out.println("<A HREF='../jsp/WSCountryFactorQueryAll.jsp'>All Country Factors</A>");
  
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
