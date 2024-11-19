<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String primaryFlag=request.getParameter("PRIMARYFLAG");
String salesAreaNo=request.getParameter("SalesAreaNo");
String MANUFACTORY_NO = request.getParameter("MANUFACTORY");
String lineNo=request.getParameter("LINENO");
String arrayLine=request.getParameter("ArrayLine");
String orderNum = "",lineType="";
if (lineNo == null) lineNo = "";
String PROGID=request.getParameter("PROGID"); 
if (PROGID==null) PROGID="";
String customerid = request.getParameter("CUSTOMERID");
if (customerid==null) customerid="0";
%>
<html>
<head>
<title>Page for choose Order Type List</title>
</head>
<body >  
<FORM NAME="SUBFORM" METHOD="post" ACTION="TSSalesOrderRemarks.jsp">
<%  
try
{ 
	String sql = " select tsc_get_mo_shippingmark(?,?)  from dual";
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,request.getParameter("ID"));
	statement.setString(2,"REMARKS");
	ResultSet rs=statement.executeQuery();
	if (rs.next())
	{
		out.println("<font style='font-family: Tahoma,Georgia; color: #000000; font-size: 11px'>"+rs.getString(1).replace("\n","<br>")+"</font>");
	}	
	else
	{
		out.println("<font style='font-family: Tahoma,Georgia; color: #ff0000; font-size: 11px'>No Data Found!!</font>");
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	out.println("error:"+e.getMessage());
}
%>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
