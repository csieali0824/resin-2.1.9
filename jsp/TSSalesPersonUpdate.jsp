<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<title>Updating Data of Repair Person</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String v_userID=request.getParameter("USERID");
String v_salesArea=request.getParameter("SALESAREA");
String repCenterNo=request.getParameter("SALES_AREA_NO");
String repPersonNo=request.getParameter("REPPERSONNO");
String v_userName=request.getParameter("USERNAME");
String v_SalesResID=request.getParameter("SALESRESID");

try
{  
	String sql="update ORADDMAN.TSRECPERSON set TSSALEAREANO=?,RECPERSONNO=?,USERNAME=?,SALESPERSONID=? where USERID='"+v_userID+"' AND TSSALEAREANO='"+ v_salesArea +"'";
  	PreparedStatement pstmt=con.prepareStatement(sql);  
  	pstmt.setString(1,repCenterNo); 
  	pstmt.setString(2,repPersonNo); 
  	pstmt.setString(3,v_userName); 
  	pstmt.setString(4,v_SalesResID);
  	pstmt.executeUpdate(); 
  
 	out.println("Processing Data of Sales Person(ID:"+v_userID+") OK!<BR>");
  	out.println("<A HREF='../jsp/TSSalesPersonQueryAll.jsp'>");
%>
  <jsp:getProperty name="rPH" property="pgQuery"/><jsp:getProperty name="rPH" property="pgSalesMan"/><jsp:getProperty name="rPH" property="pgAllRecords"/>
<%
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
