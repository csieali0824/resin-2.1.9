<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat" %>
<%@ page import="DateBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit1(URL)
{   
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12x } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12x }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
</STYLE>
<title>TSC YEW WIP Link SO</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="DateBean" %>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">    
<FORM  METHOD="post" NAME="MYFORM">
<%
	String WIPNO = request.getParameter("WIPNO");
	if (WIPNO==null) WIPNO="";
%>
<table cellspacing="0" cellpadding="1" width="70%" align="center">	
	<tr>
		<td><font color="#003366" size="+2" face="Arial Black">YEW WIP Link SO</font></td>
	</tr>
	<tr>
		<td align="right"><font style="font-size:12px"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></font></td>
	</tr>
	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#A289B1" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bgcolor="#CFD1C0">	
				<tr>
					<td width="20%" nowrap><font style="color:#006666;font-size:12px" ><strong>Customer</strong></font></td> 
					<td width="60%"><INPUT TYPE="textbox" NAME="WIPNO" value="<%=WIPNO%>" style="font-size:12px;color:#333333;font-family:arial" size="40"></td>
					<td width="20%"><INPUT TYPE="button" value="Query" onClick='setSubmit("../jsp/TSCMFGWIPLinkSOHistory.jsp")' style="font-family:Tahoma,Georgia">&nbsp;&nbsp;<INPUT TYPE="button" value='Add New' onClick='setSubmit1("../jsp/TSCMFGWIPLinkSOUpdate.jsp")' style="font-family:Tahoma,Georgia"></td> 			
				</tr>
			</table>
		</td>
   	</tr>
   	<tr>
   		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>	
			<table cellspacing="0"bordercolordark="#A289B1" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">	
				<tr bgcolor="#99CCFF"> 
					<td style="font-size:12px;font-family:arial;color:#663333;" width="10%">&nbsp;</td>
					<td style="font-size:12px;font-family:arial;color:#663333;" width="20%">WIP NO</td>
					<td style="font-size:12px;font-family:arial;color:#663333;" width="30%">SO</td>
					<td style="font-size:12px;font-family:arial;color:#663333;" width="20%">Creation Date</td>
					<td style="font-size:12px;font-family:arial;color:#663333;" width="20%">Created By</td>
				</tr>
<%
			try
			{
				String sql = " select a.wo_no, a.mo_list, to_char(a.creation_date,'yyyy-mm-dd') creation_date, a.created_by from oraddman.tsyew_wip_link_so_history a where 1=1";
				if (!WIPNO.equals("")) sql += " and a.wo_no='"+WIPNO+"'";
				//out.println(sql);
   				Statement statement=con.createStatement();
			    ResultSet rs=statement.executeQuery(sql);  
				int i = 1;
			    while (rs.next())
				{
					out.println("<tr>");
					out.println("<td>"+i+"</td>");
					out.println("<td>"+rs.getString("wo_no")+"</td>");
					out.println("<td>"+rs.getString("mo_list")+"</td>");
					out.println("<td>"+rs.getString("creation_date")+"</td>");
					out.println("<td>"+rs.getString("created_by")+"</td>");
					out.println("</tr>");
					i++;
					
				}
				rs.close();
				statement.close();
			}
			catch (Exception e)
			{
				out.println(e.getMessage());
			}
%>				
			</table>
		</td>
	</tr>
</table>
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

