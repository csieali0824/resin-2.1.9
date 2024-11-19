<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<title>Sales Person Data Delete</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String [] choice=request.getParameterValues("CH");
//String choiceString=null;
String sql="",userID="",salesAreaNo="",userName="",result="";  //add by Peggy 20121218
try
{  
	for (int k=0;k<choice.length ;k++)
  	{
		if (k==0)
		{
			out.println("<table width='50%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#B9BB99'>");
			out.println("<tr bgcolor='#9810A1' style='color:#ffffff;family:arial'><td>SalesAreaNo</td><td>User ID</td><td>User Name</td><td>Result</td></tr>");
			
		}
		userID = request.getParameter(choice[k]+"_2");
		salesAreaNo = request.getParameter(choice[k]+"_3");
		userName = request.getParameter(choice[k]+"_5");
		sql="delete from ORADDMAN.TSRECPERSON where USERID ='"+ userID +"' and TSSALEAREANO='"+ salesAreaNo +"'";   
		PreparedStatement pstmt=con.prepareStatement(sql);    
		if (pstmt.executeUpdate()>0)
		{
			result="OK";
		}
		else
		{
			result="Fail";
		} 
		pstmt.close();          
		out.println("<tr><td>"+salesAreaNo+"</td><td>"+userID +"</td><td>"+userName+"</td><td>"+result+"</td></tr>");
  	}
	if (choice.length>0) out.println("</table>");
  	out.println("<p><p><A HREF=/oradds/jsp/TSSalesPersonQueryAll.jsp>");
%> 
  <jsp:getProperty name="rPH" property="pgQuery"/><jsp:getProperty name="rPH" property="pgSalesMan"/><jsp:getProperty name="rPH" property="pgAllRecords"/>
<%
	out.println("</A>");
} 
catch (Exception e)
{
	out.println(e.getMessage());
}
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
