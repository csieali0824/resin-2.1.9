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
<title>EDI客戶基本資料查詢及維護</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="DateBean" %>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">    
<FORM  METHOD="post" NAME="MYFORM">
<%
	String CUSTOMER = request.getParameter("CUSTOMER");
	if (CUSTOMER==null) CUSTOMER="";
%>
<table cellspacing="0" cellpadding="1" width="90%" align="center">	
	<tr>
		<td><font color="#003366" size="+3" face="Arial Black"><em>EDI</em></font>
			<font style="font-size:28px;color:#000000;font-family:'標楷體'"><strong>客戶資料查詢</strong></font>
		</td>
	</tr>
	<tr>
		<td align="right"><font style="font-size:12px"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></font></td>
	</tr>
	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#A289B1" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bgcolor="#CFD1C0" bordercolor="#cccccc">	
				<tr>
					<td width="20%" nowrap><font style="color:#006666;font-size:12px" ><strong>客戶代號或名稱</strong></font></td> 
					<td width="60%"><INPUT TYPE="textbox" NAME="CUSTOMER" value="<%=CUSTOMER%>" style="font-size:12px;color:#333333;font-family:arial" size="40"></td>
					<td width="20%"><INPUT TYPE="button" value='查詢' onClick='setSubmit("../jsp/TSCEDICustomerQuery.jsp")'>&nbsp;&nbsp;<INPUT TYPE="button" value='新增' onClick='setSubmit1("../jsp/TSCEDICustomerModify.jsp")'></td> 			
				</tr>
			</table>
		</td>
   	</tr>
   	<tr>
   		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>	
			<table cellspacing="0"bordercolordark="#A289B1" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1" bordercolor="#99CCFF">	
				<tr bgcolor="#99CCFF"> 
					<td style="font-size:12px;font-family:arial;color:#663333;">&nbsp;</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">&nbsp;</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">ERP客戶ID</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">客戶名稱</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">客戶簡稱</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">EDI識別碼</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">RFQ業務區</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">業務窗口</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">地區別</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">供應商代碼(台半)</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">停用日期</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">最後異動人員</td>
					<td style="font-size:12px;font-family:arial;color:#663333;">最後異動日期</td>
				</tr>
<%
			try
			{
				String sql = " select a.customer_name, a.cust_shortname, to_char(a.inactive_date,'yyyy-mm-dd') inactive_date,"+
                             " a.edi_cust_acct, a.sales_contact, a.sales_area_no,"+
                             " a.ship_to_site_id, a.region1, a.customer_id, a.cust_tscno,"+
                             " a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date,b.alname "+
							 " from tsc_edi_customer a,oraddman.tssales_area b"+
                             " where a.sales_area_no=b.sales_area_no(+)";
				if (!CUSTOMER.equals("")) sql += " and (a.customer_name like '"+CUSTOMER+"%' or customer_id ='"+CUSTOMER+"')";
   				Statement statement=con.createStatement();
			    ResultSet rs=statement.executeQuery(sql);  
				int i = 1;
			    while (rs.next())
				{
					out.println("<td style='font-size:12px;font-family:arial;'>"+i+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'><input type='button' name='btn"+i+"' value='修改' onclick='setSubmit1("+'"'+"../jsp/TSCEDICustomerModify.jsp?CUSTOMERID="+rs.getString("CUSTOMER_ID")+'"'+")'></td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+rs.getString("CUSTOMER_ID")+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+rs.getString("CUSTOMER_NAME")+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+rs.getString("CUST_SHORTNAME")+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+rs.getString("EDI_CUST_ACCT")+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+rs.getString("ALNAME")+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+rs.getString("SALES_CONTACT")+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+(rs.getString("REGION1")==null?"&nbsp;":rs.getString("REGION1"))+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+rs.getString("CUST_TSCNO")+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+(rs.getString("INACTIVE_DATE")==null?"&nbsp;":rs.getString("INACTIVE_DATE"))+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+(rs.getString("LAST_UPDATED_BY")==null?"&nbsp;":rs.getString("LAST_UPDATED_BY"))+"</td>");
					out.println("<td style='font-size:12px;font-family:arial;'>"+(rs.getString("LAST_UPDATE_DATE")==null?"&nbsp;":rs.getString("LAST_UPDATE_DATE"))+"</td>");
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

