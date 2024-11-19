<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="PoolBean" %>
<html>
<head>
<title>TSDRQ Product Factory Person Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String recCenterNo=request.getParameter("MANUFACTORY_NO");
String recPersonNo=request.getParameter("RECPERSONNO");
String v_userID=request.getParameter("USERID");
String v_userName=request.getParameter("USERNAME");
String v_locale=request.getParameter("LOCALE");
String v_SalesResID=request.getParameter("SALESRESID");

try
{  
  String sql="insert into ORADDMAN.TSPROD_PERSON(PROD_FACNO,PROD_PERSONNO,USERID,USERNAME,PLOCALE) values(?,?,?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);   
  pstmt.setString(1,recCenterNo);
  pstmt.setString(2,recPersonNo);
  pstmt.setString(3,v_userID); 
  pstmt.setString(4,v_userName); 
  pstmt.setString(5,v_locale); 
  //pstmt.setString(6,v_SalesResID);
  
  pstmt.executeUpdate();
  
  out.println("insert into PRODUCT FACTORY PC PERSON value(USERID:"+v_userID+") OK!<BR>");
  out.println("<A HREF=../jsp/TSSDRQProdPersonQueryAll.jsp>");
  %>
  <jsp:getProperty name="rPH" property="pgQuery"/><jsp:getProperty name="rPH" property="pgProdPC"/><jsp:getProperty name="rPH" property="pgAllRecords"/>
  <%//查詢所有維修收件人員
  out.println("</A>");
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
