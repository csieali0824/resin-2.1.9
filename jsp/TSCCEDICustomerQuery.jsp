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
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11x } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11x }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 11px}
</STYLE>
<title>TSCC EDI客戶基本資料查詢及維護</title>
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
	String CUSTOMER = request.getParameter("CUSTOMER");
	if (CUSTOMER==null) CUSTOMER="";
%>
<table cellspacing="0" cellpadding="1" width="100%" align="center">	
	<tr>
		<td><font color="#003366" size="+2" face="Arial Black">TSCC EDI Customer Info</font>
		</td>
	</tr>
	<tr>
		<td align="right"><font style="font-size:12px"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></font></td>
	</tr>
	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#A289B1" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bgcolor="#CFD1C0">	
				<tr>
					<td width="20%" nowrap><font style="color:#006666;font-size:12px" ><strong>Customer</strong></font></td> 
					<td width="60%"><INPUT TYPE="textbox" NAME="CUSTOMER" value="<%=CUSTOMER%>" style="font-size:12px;color:#333333;font-family:arial" size="40"></td>
					<td width="20%"><INPUT TYPE="button" value="Query" onClick='setSubmit("../jsp/TSCCEDICustomerQuery.jsp")' style="font-family:Tahoma,Georgia">&nbsp;&nbsp;<INPUT TYPE="button" value='Add New' onClick='setSubmit1("../jsp/TSCCEDICustomerModify.jsp?ACTIONTYPE=NEW")' style="font-family:Tahoma,Georgia"></td> 			
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
					<td style="font-size:12px;font-family:arial;color:#663333;">&nbsp;</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">&nbsp;</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">Sales Region</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">Customer Name</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">EDI Address Code</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">EDI Address Desc</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">EDI Customer Code</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">ERP Customer Number</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">ERP Customer Name</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">DELFOR Folder</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">DESADV Folder</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">Inactive Date</td>
					<!--<td style="font-size:12px;font-family:arial;color:#663333;">Creation Date</td>-->
					<!--<td style="font-size:12px;font-family:arial;color:#663333;">Created By</td>-->
					<td style="font-size:12px;font-family:arial;color:#663333;">Last Update Date</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">Last Updated By</td>
				</tr>
<%
			try
			{
				String sql = " select a.edi_cust_seq,a.sales_region, a.cust_name, a.edi_address_code,"+
                             " a.edi_address_desc, a.edi_cust_code, a.erp_cust_number,b.customer_name,"+
                             " a.ftp_server_route||'\\'||a.delfor_folder_name delfor,"+
                             " a.ftp_server_route||'\\'||a.desadv_folder_name desadv,"+
							 " a.created_by, to_char(a.creation_date,'yyyy-mm-dd') creation_date,"+
                             " a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date,to_char(a.inactive_date,'yyyy-mm-dd') inactive_date"+
                             " from tscc_edi_customers a,ar_customers b"+
                             " where a.erp_cust_number=b.customer_number(+)";
				if (!CUSTOMER.equals("")) sql += " and (b.customer_name like '"+CUSTOMER+"%' or a.erp_cust_number ='"+CUSTOMER+"')";
				//out.println(sql);
   				Statement statement=con.createStatement();
			    ResultSet rs=statement.executeQuery(sql);  
				int i = 1;
			    while (rs.next())
				{
					out.println("<tr>");
					out.println("<td>"+i+"</td>");
					out.println("<td><input type='button' name='btn"+i+"' value='Edit' onclick='setSubmit1("+'"'+"../jsp/TSCCEDICustomerModify.jsp?ACTIONTYPE=MODIFY&edi_cust_seq="+rs.getString("edi_cust_seq")+'"'+")' style='font-family:Tahoma,Georgia'></td>");
					out.println("<td>"+rs.getString("sales_region")+"</td>");
					out.println("<td>"+rs.getString("cust_name")+"</td>");
					out.println("<td>"+rs.getString("edi_address_code")+"</td>");
					out.println("<td>"+rs.getString("edi_address_desc")+"</td>");
					out.println("<td>"+rs.getString("edi_cust_code")+"</td>");
					out.println("<td>"+(rs.getString("erp_cust_number")==null?"&nbsp;":rs.getString("erp_cust_number"))+"</td>");
					out.println("<td>"+(rs.getString("customer_name")==null?"&nbsp;":rs.getString("customer_name"))+"</td>");
					out.println("<td>"+rs.getString("delfor")+"</td>");
					out.println("<td>"+rs.getString("desadv")+"</td>");
					out.println("<td>"+(rs.getString("inactive_date")==null?"&nbsp;":rs.getString("inactive_date"))+"</td>");
					//out.println("<td>"+rs.getString("creation_date")+"</td>");
					//out.println("<td>"+rs.getString("created_by")+"</td>");
					out.println("<td>"+rs.getString("last_update_date")+"</td>");
					out.println("<td>"+rs.getString("last_updated_by")+"</td>");
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

