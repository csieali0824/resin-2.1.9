<!-- modify by Peggy 20140808,新增對應erp customer-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean,MiscellaneousBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setAddNew(URL)
{   
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setModify(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setInactive(URL,STATUS)
{
	var str ="Inactive";
	if (STATUS=="A") str ="Active";
	if (confirm("您確定要將資料狀態改為"+str+"?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setSubmit1(URL)
{    
	var CUSTOMER = document.MYFORM.CUSTOMER.value;
	var CURRENCYCODE = document.MYFORM.CURRENCYCODE.value;
	document.MYFORM.action=URL+"?CUSTOMER="+CUSTOMER+"&CURRENCYCODE="+CURRENCYCODE;
 	document.MYFORM.submit();
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
</STYLE>
<title>TSCE Customer資料查詢</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<% /* 建立本頁面資料庫連線  */ %>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">    
<FORM  METHOD="post" NAME="MYFORM">
<%
	String CUSTOMERID = request.getParameter("CUSTOMERID");
	if (CUSTOMERID==null) CUSTOMERID="";
	String CUSTOMER = request.getParameter("CUSTOMER");
	if (CUSTOMER==null) CUSTOMER="";
	String ACTIONCODE = request.getParameter("ACTIONCODE");
	if (ACTIONCODE==null) ACTIONCODE = "";
	String CURRENCYCODE = request.getParameter("CURRENCYCODE");
	if (CURRENCYCODE==null) CURRENCYCODE="";
	String CURR = request.getParameter("CURR");
	if (CURR==null) CURR="";	
	String STATUS = request.getParameter("STATUS");
	if (STATUS==null) STATUS="N";
	
	if (ACTIONCODE.equals("CANCEL"))
	{
		String sql = " update oraddman.TSCE_END_CUSTOMER_LIST  set ACTIVE_FLAG='"+STATUS+"' , LAST_UPDATED_BY='"+UserName+"',LAST_UPDATE_DATE=sysdate"+
			  " where CUSTOMER_ID ='"+CUSTOMERID+"'"+
			  " and currency_code='"+CURR+"'"; //add by Peggy 20210526
		PreparedStatement st1 = con.prepareStatement(sql);
		st1.executeUpdate();
		st1.close();
		out.println("<script language = 'JavaScript'>");
		out.println("alert('資料狀態更新完成!')");
		out.println("</script>");
	}
%>
<table cellspacing="0" cellpadding="1" width="100%" align="center">	
	<tr>
		<td><font color="#003366" size="+2" face="Arial Black"><em>TSCE Customer List View</em></font>
		</td>
	</tr>
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"  style="font-size:16px;font-family:標楷體;text-decoration:none;color:#0000FF">回首頁</A></td>
	</tr>
	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#999966" cellpadding="0" width="100%" align="center" bordercolorlight="#ffffff" border="1">	
				<tr BGCOLOR='#A0BEB6'>
					<td width="15%" nowrap><strong>Customer ID or Name</strong></td> 
					<td width="20%"><input type="text" name="CUSTOMER" value="<%=CUSTOMER%>" style="font-size:11px;color:#333333;font-family: Tahoma,Georgia" size="30"></td>
					<td width="15%" nowrap><strong>Currency Code</strong></td> 
					<td width="20%"><INPUT TYPE="text" NAME="CURRENCYCODE" value="<%=CURRENCYCODE%>" style="font-size:11px;color:#333333;font-family: Tahoma,Georgia" size="20"></td>
					<td width="30%"><INPUT TYPE="button" id='Query' value='Query' onClick='setSubmit("../jsp/TSCE1214CustomerListView.jsp")' style="font-family:'Times New Roman';font-size:14px">&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='button' id='AddNew' value='AddNew' onClick='setAddNew("../jsp/TSCE1214CustomerUpdate.jsp")' style="font-family:'Times New Roman';font-size:14px">&nbsp;&nbsp;&nbsp;
					<input type="button" name="submit1" value="Export to Excel" onClick="setSubmit1('../jsp/TSCE1214CustomerExcel.jsp')" style="font-family:'Times New Roman';font-size:14px">					</td> 			
				</tr>
			</table>
		</td>
   	</tr>
   	<tr>
   		<td>&nbsp;</td>
	</tr>
<%
			String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
			PreparedStatement pstmt1=con.prepareStatement(sql1);
			pstmt1.executeUpdate(); 
			pstmt1.close();
	
			int i =0,rowcnt=0;
			try
			{
				String sourceLot = "";
				String sql = " SELECT  a.customer_id, a.customer_name, a.currency_code, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date,"+
                             " a.created_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date, a.last_updated_by, a.active_flag "+
							 ",(select '('||customer_number||')' || customer_name ||case when STATUS='I' then '(Inactive)' else '' end from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_1) erp_customer_1"+
							 ",(select '('||customer_number||')' || customer_name ||case when STATUS='I' then '(Inactive)' else '' end from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_2) erp_customer_2"+
							 ",(select '('||customer_number||')' || customer_name ||case when STATUS='I' then '(Inactive)' else '' end from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_3) erp_customer_3"+
							 ",(select '('||customer_number||')' || customer_name ||case when STATUS='I' then '(Inactive)' else '' end from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_4) erp_customer_4"+
							 ",(select '('||customer_number||')' || customer_name ||case when STATUS='I' then '(Inactive)' else '' end from ar_customers b where b.customer_id =a.ERP_CUSTOMER_ID_5) erp_customer_5"+
                             " FROM oraddman.TSCE_END_CUSTOMER_LIST a where 1=1";
				if (!CUSTOMER.equals(""))
				{
					sql += " and (CUSTOMER_ID like '"+CUSTOMER+"%' or upper(CUSTOMER_NAME) like '%"+CUSTOMER.toUpperCase()+"%')";
				}
				if (!CURRENCYCODE.equals(""))
				{
					sql += " and CURRENCY_CODE ='" + CURRENCYCODE+"'";
				}
				sql += " order by customer_id";
				Statement statement1=con.createStatement();
			    ResultSet rs1=statement1.executeQuery("select count(1) from ("+sql+")");  
				if (rs1.next())
				{
					rowcnt = rs1.getInt(1);
				}
				rs1.close();
				statement1.close();
				
				Statement statement=con.createStatement();
			    ResultSet rs=statement.executeQuery(sql);  
				//out.println(sql);
			    while (rs.next())
				{
					i++;
					if (i==1)
					{
						out.println("<tr><td style='font-family: Tahoma,Georgia;font-size:13px'>Total Count:"+rowcnt+"</td></tr>");
						out.println("<tr>");
						out.println("<td>");
						out.println("<table cellspacing='0' bordercolordark='#FFFFFF' cellpadding='1' width='100%' align='center' bordercolorlight='#CCCC99' border='1'>");	
						out.println("<tr bgcolor='#A0BEB6'>");
						out.println("<td width='2%' align='center'>&nbsp;</td>");
						out.println("<td width='7%' align='center'>&nbsp;</td>");
						out.println("<td align='center' width='5%' valign='middle'>Customer ID</td>");
						out.println("<td align='center' width='15%'>Customer Name</td>");
						out.println("<td align='center' width='5%'>Currency Code</td>");
						out.println("<td align='center' width='15%'>ERP Customer 1</td>");
						out.println("<td align='center' width='15%'>ERP Customer 2</td>");
						out.println("<td align='center' width='15%'>ERP Customer 3</td>");
						//out.println("<td align='center' width='10%'>ERP Customer 4</td>");
						//out.println("<td align='center' width='10%'>ERP Customer 5</td>");
						out.println("<td align='center' width='5%'>Status</td>");
						//out.println("<td align='center' width='8%' align='center'>Creation Date</td>");
						//out.println("<td align='center' width='8%' align='center'>Created By</td>");
						out.println("<td align='center' width='8%' align='center'>Last Update Date</td>");
						out.println("<td align='center' width='8%' align='center'>Last Updated By</td>");
						out.println("</tr>");
					}
					out.println("<tr>");
					out.println("<td align='center'>"+i+"</td>");
					out.println("<td align='center'>");
					out.println("<input type='button' id='UPD"+i+"' value='Update' style='width:50;font-size:11px;font-family: Tahoma,Georgia;' onclick='setModify("+'"'+"../jsp/TSCE1214CustomerUpdate.jsp?ACTIONMODE=MODIFY&CUSTOMERID="+rs.getString("CUSTOMER_ID")+"&CURR="+rs.getString("currency_code")+'"'+")'>");
					if (rs.getString("ACTIVE_FLAG").equals("A"))
					{
						out.println("<input type='button' id='CANCEL"+i+"' value='Inactive' style='width:50;font-size:11px;font-family: Tahoma,Georgia;' onclick='setInactive("+'"'+"../jsp/TSCE1214CustomerListView.jsp?ACTIONCODE=CANCEL&CUSTOMERID="+rs.getString("CUSTOMER_ID")+"&CURR="+rs.getString("currency_code")+"&STATUS=I"+'"'+","+'"'+"I"+'"'+")'>");
					}
					else
					{
						out.println("<input type='button' id='CANCEL"+i+"' value='Active' style='width:50;font-size:11px;font-family: Tahoma,Georgia;' onclick='setInactive("+'"'+"../jsp/TSCE1214CustomerListView.jsp?ACTIONCODE=CANCEL&&CUSTOMERID="+rs.getString("CUSTOMER_ID")+"&CURR="+rs.getString("currency_code")+"&STATUS=A"+'"'+","+'"'+"A"+'"'+")'>");
					}
					out.println("</td>");
					out.println("<td>"+rs.getString("CUSTOMER_ID")+"</td>");
					out.println("<td>"+rs.getString("CUSTOMER_NAME")+"</td>");
					out.println("<td align='center'>"+rs.getString("currency_code")+"</td>");
					out.println("<td "+(rs.getString("erp_customer_1")!=null && rs.getString("erp_customer_1").indexOf("Inactive")>0?"style='color:#ff0000'":"")+">"+(rs.getString("erp_customer_1")==null?"&nbsp;":rs.getString("erp_customer_1"))+"</td>");
					out.println("<td "+(rs.getString("erp_customer_2")!=null && rs.getString("erp_customer_2").indexOf("Inactive")>0?"style='color:#ff0000'":"")+">"+(rs.getString("erp_customer_2")==null?"&nbsp;":rs.getString("erp_customer_2"))+"</td>");
					out.println("<td "+(rs.getString("erp_customer_3")!=null && rs.getString("erp_customer_3").indexOf("Inactive")>0?"style='color:#ff0000'":"")+">"+(rs.getString("erp_customer_3")==null?"&nbsp;":rs.getString("erp_customer_3"))+"</td>");
					//out.println("<td>"+(rs.getString("erp_customer_4")==null?"&nbsp;":rs.getString("erp_customer_4"))+"</td>");
					//out.println("<td>"+(rs.getString("erp_customer_5")==null?"&nbsp;":rs.getString("erp_customer_5"))+"</td>");
					out.println("<td align='center'>"+(rs.getString("ACTIVE_FLAG").equals("A")?"<font color='blue'>Active</font>":"<font color='red'>Inactive</font>")+"</td>");
					//out.println("<td align='center'>"+(rs.getString("CREATION_DATE")==null?"&nbsp;":rs.getString("CREATION_DATE"))+"</td>");
					//out.println("<td align='center'>"+(rs.getString("CREATED_BY")==null?"&nbsp;":rs.getString("CREATED_BY"))+"</td>");
					out.println("<td align='center'>"+(rs.getString("LAST_UPDATE_DATE")==null?"&nbsp;":rs.getString("last_update_date"))+"</td>");
					out.println("<td align='center'>"+rs.getString("LAST_UPDATED_BY")+"</td>");
					out.println("</tr>");
				}
				rs.close();
				statement.close();
			}
			catch (Exception e)
			{
				out.println(e.getMessage());
			}
			if (i>0)
			{
				out.println("</table>");
				out.println("</td>");
				out.println("</tr>");
			}
			else
			{
				out.println("<tr><td align='center'><font style='font-size:14px;font-family:Times New Roman;color:#ff0000'>No Data Found!!</font></td></tr>");
			}
%>				
</table>
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

