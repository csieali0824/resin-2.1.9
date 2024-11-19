<!--20161107,新增PRD外包-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
 <!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<title>外包PO單價申請明細</title>
<STYLE TYPE='text/css'> 
 .style3   {font-family:Arial; font-size:12px; background-color:#FFFFFF; text-align:center;color: #000000;}
 .style4   {font-family:Arial; font-size:12px; background-color:#A0E970; text-align:center;color: #000000;}
 .style1   {font-family:Arial; font-size:12px; background-color:#FFFFFF; text-align:left;color: #000000;}
 .style2   {font-family:Arial; font-size:12px; background-color:#A0E970; text-align:left;color: #000000;}
 .style6   {font-family:Arial; font-size:12px; background-color:#99CC33; text-align:right;color: #000000;}
 .style7   {font-family:Arial; font-size:12px; background-color:#76D06C; text-align:left;color: #000000; }
 .style5   {font-family:Arial; font-size:12px; background-color:#FFFFFF; text-align:right;color: #000000;}
</STYLE>
</head>
<body>
<%
String REQUESTNO = request.getParameter("REQUESTNO");
String ACTIONID = request.getParameter("ACTIONID");
if (ACTIONID==null) ACTIONID="";
String ITEMID="",ITEMNAME="",ITEMDESC="",PRICE="",PREPRICE="",PERCENTAGE="",STARTQTY="",ENDQTY="",REASON="",status="",rowcnt="",UOM="",TSC_PROD_GROUP="";
String strHyperLink = "",strHyperLinkVal="";
strHyperLink = "回首頁";
strHyperLinkVal = "/oradds/ORADDSMainMenu.jsp";

try
{
	String sql = " SELECT a.vendor_code, a.vendor_name, a.vendor_site,a.currency_code, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date, a.created_by_name, to_char(a.approve_date,'yyyy-mm-dd hh24:mi') approve_date, a.approved_by_name"+
				 " ,STATUS,decode(status,'Closed',status||'(結案)',a.status||'('||b.type_desc||')') status_name,a.approve_remark "+
				 " from oraddman.tspmd_quotation_headers_all a"+
				 ", (SELECT  a.type_name, (select TYPE_NAME from oraddman.tspmd_data_type_tbl b WHERE b.TYPE_NO =a.TYPE_NO AND b.DATA_TYPE LIKE 'F2-0%') TYPE_DESC"+
                 " FROM oraddman.tspmd_data_type_tbl a  WHERE DATA_TYPE ='F2_ACTION') b"+
				 " where a.request_no='"+REQUESTNO+"' and a.STATUS=b.type_name(+)";
	//out.println(sql);
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if (rs.next())
	{
		status = rs.getString("STATUS");
%>
<form name="MYFORM"  METHOD="post" >
 <font color="#000000" size="+2" face="標楷體"> <strong>外包PO單價申請明細</strong></font>
<br>
<A HREF="/oradds/ORADDSMainMenu.jsp"><font style="font-size:12px;font-family:'細明體';">回首頁</font></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A href="../jsp/TSCPMDQuotationQuery.jsp"><font style="font-size:12px;font-family:'細明體';">回查詢畫面</font></A>
<table width="90%">
	<tr>
		<td height="153">
			<table width="100%" border="1" align="left" cellpadding="1" cellspacing="0"  bordercolorlight="#336600"  bordercolordark="#FFFFFF">
				<tr>
					<td height="26" colspan="10" class="style7">廠商資訊：</td>
				</tr>
				<tr>
					<td width="5%" height="29" class="style2">申請單號:</td>
					<td width="10%" class="style1"><font style="font-size:16px;color:#0000CC;"><strong><%=REQUESTNO%></strong></font><input type="hidden" name="REQUESTNO" value="<%=REQUESTNO%>"></td> 	
					<td width="5%" class="style2">申請狀態:</td>
					<td width="10%" class="style1"><%if (rs.getString("status").equals("Closed")) out.println("<font color='red'>");%><%=rs.getString("status_name")%><%if (rs.getString("status").equals("Closed")) out.println("</FONT>");%></td> 
					<td width="5%" class="style2">廠商名稱:</td>
					<td width="15%" class="style1"><%="("+rs.getString("vendor_code")+") "+rs.getString("vendor_name")%></td> 	
					<td width="5%" class="style2"><font style="font-family:ARIAL">Site:</font></td>
					<td width="7%" class="style1"><%=rs.getString("vendor_site")%></td>
					<td width="5%" class="style2">幣別:</td>
					<td width="5%" class="style1"><%=rs.getString("currency_code")%></td> 
				</tr>   
				<tr>
					<td height="27" colspan="10" class="style7" >申請明細：</td>
				</tr>
				<TR>
					<td colspan="10">
						<table width="100%" cellspacing="0" bordercolorlight="#FFFFFF" bordercolordark="#006600"  border="1">
							<tr>
								<td class="style4" width="3%" height="29" >項次</td>
								<td class="style4" width="7%">TSC Prod Group</td>
								<td class="style4" width="16%">料號</td>
								<td class="style4" width="12%">品名</td>
								<td class="style4" width="8%">起始訂單量(>)</td>
								<td class="style4" width="8%">結束訂單量(<=)</td>
								<td class="style4" width="5%">數量單位</td>
								<td class="style4" width="5%">單價</td>
								<td class="style4" width="5%">前次單價</td>
								<td class="style4" width="5%">差異比(%)</td>
								<td class="style4" width="15%">異動原因</td>
							</tr>
							<% 
							sql = " SELECT a.inventory_item_id,a.inventory_item_name, a.item_description, "+
							      " (select count(1) from oraddman.tspmd_quotation_lines_all b where b.request_no = a.request_no and b.inventory_item_id = a.inventory_item_id) rowcnt,"+
						          "a.unit_price,a.previous_price, a.start_date, a.end_date,a.request_reason,"+
								  " decode(previous_price,0,0,round((unit_price-previous_price)/previous_price*100,2)) percentage,"+
								  " NVL(a.start_qty,0) start_qty,nvl(a.end_qty,0) end_qty,a.uom"+
								  " ,a.organization_id,a.tsc_prod_group"+ //add by Peggy 20161110
								  " FROM oraddman.tspmd_quotation_lines_all a"+
								  " WHERE  a.request_no='"+ REQUESTNO+"' ORDER BY a.inventory_item_name,a.start_qty";
							//out.println(sql);
							Statement statementd=con.createStatement();
							ResultSet rsd=statementd.executeQuery(sql);
							int i =0;
							String str_color="";
							while (rsd.next())				
							{
								PRICE=rsd.getString("unit_price");
								PREPRICE=rsd.getString("previous_price");
								STARTQTY=rsd.getString("start_QTY");
								ENDQTY=rsd.getString("end_QTY");
								REASON=rsd.getString("request_reason");
								UOM=rsd.getString("UOM");
								PERCENTAGE=rsd.getString("percentage");
								i++;
								out.println("<tr>");
								out.println("<TD class='style3'>"+i+"</td>");
								if (!ITEMID.equals(rsd.getString("inventory_item_id")))
								{
									ITEMID=rsd.getString("inventory_item_id");
									ITEMNAME=rsd.getString("inventory_item_name");
									ITEMDESC=rsd.getString("item_description");
									rowcnt=rsd.getString("rowcnt");
									TSC_PROD_GROUP=rsd.getString("tsc_prod_group"); //add by Peggy 20161110
									
									out.println("<TD class='style1' rowspan='"+rowcnt+"'>&nbsp;"+TSC_PROD_GROUP+"</td>");
									out.println("<TD class='style1' rowspan='"+rowcnt+"'>&nbsp;"+ITEMNAME+"</td>");
									out.println("<TD class='style1' rowspan='"+rowcnt+"'>&nbsp;"+ITEMDESC+"</td>");
								}
								out.println("<TD class='style5'>"+(new DecimalFormat("##,##0.###")).format(Float.parseFloat(STARTQTY))+"&nbsp;</td>");
								out.println("<TD class='style5'>"+(new DecimalFormat("##,##0.###")).format(Float.parseFloat(ENDQTY))+"&nbsp;</td>");
								out.println("<TD class='style3'>"+UOM+"</td>");
								out.println("<TD class='style5'>"+(new DecimalFormat("##,##0.###")).format(Float.parseFloat(PRICE))+"&nbsp;</TD>");
								out.println("<TD class='style5'>"+(new DecimalFormat("##,##0.###")).format(Float.parseFloat(PREPRICE))+"&nbsp;</td>");
								if (Float.parseFloat(PERCENTAGE) <0)
								{
									str_color = "#0000FF";
								}
								else if (Float.parseFloat(PERCENTAGE) >0)
								{
									str_color = "#FF0000";
								}
								else
								{
									str_color = "#000000";
								}
								out.println("<TD class='style5'><strong><font style='color:"+str_color+"'>"+(new DecimalFormat("##,##0.###")).format(Float.parseFloat(PERCENTAGE))+"&nbsp;</font></strong></td>");
								out.println("<TD class='style1'>&nbsp;"+((REASON==null || REASON.equals("null"))?"&nbsp;":REASON)+"</td>");
								out.println("</tr>");
							}
							rsd.close();
							statementd.close();
							%>
						</table>	  
						
				  	</TD>
				</TR>
				<tr>
					<TD height="21" colspan="10" class="style7">&nbsp;</td>
				</tr>
				<TR>
					<td width="10%" class="style2">附件明細</td>
					<td colspan="9">
					<%
					String rootName = "/jsp/PMD_Attache/"+REQUESTNO;
					String rootPath = application.getRealPath(rootName);
					File fp = new File(rootPath);
					if (fp.exists()) 
					{  
						String[] list = fp.list();
						for(int j=0; j<list.length;j++)
						{
							File inFp = new File(rootPath + File.separator + list[j]);
							out.println("&nbsp;<img src='images/pdf.gif'><font style='font-family:arial;font-size:12px'><a href='.."+rootName+"/"+ list[j]+"' target='_blank'>"+list[j]+"</a> ("+new Long(inFp.length()) +" bytes) "+new Timestamp(new Long(inFp.lastModified()).longValue())+"</font><br>");
						}
						if (list.length==0) out.println("&nbsp;<br>&nbsp;");
					}
					else
					{
						out.println("&nbsp;<br>&nbsp;");
					}
					%>
					</td>
				</TR>
			</table>
	  </td>
	</tr>
	<tr>
		<td style="border-right-color:#FFFFFF;border-left-color:#FFFFFF">&nbsp;</td>
	</tr>
	<%
		sql = " SELECT  a.action_name,c.type_name action_desc, to_char(a.action_date,'yyyy-mm-dd hh24:mi:ss')  action_date,a.actor, a.remark "+
		      " FROM oraddman.tspmd_action_history a"+
		      " ,(select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL  where DATA_TYPE ='F2_ACTION') b"+
		      " ,(select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL  where DATA_TYPE like 'F2-%') c"+
		      " where a.request_no ='" + REQUESTNO+"' and a.ACTION_NAME = b.type_name and b.type_no = c.type_no order by a.action_date";
		Statement statementa=con.createStatement();
		ResultSet rsa=statementa.executeQuery(sql);
		int cnt =0;
		while (rsa.next())
		{
			if (cnt ==0)
			{
				out.println("<tr><td colspan='10'>");
				out.println("<table width='100%' border='1' align='left' cellpadding='1' cellspacing='0'  bordercolorlight='#FFFFFF'  bordercolordark='#336600'>");
				out.println("<tr>");
				out.println("<td height='20' colspan='8' class='style7'>申請歷程：</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td class='style4' width='5%'>序號</td>");
				out.println("<td class='style4' width='20%'>交易名稱</td>");
				out.println("<td class='style4' width='20%'>交易日期</td>");
				out.println("<td class='style4' width='20%'>交易人員</td>");
				out.println("<td class='style4' width='35%'>備註說明</td>");
				out.println("</tr>");
			}
			out.println("<tr>");
			out.println("<td class='style3'>"+(cnt+1)+"</td>");
			out.println("<td class='style3'>"+rsa.getString("action_desc")+"</td>");
			out.println("<td class='style3'>"+rsa.getString("action_date")+"</td>");
			out.println("<td class='style3'>"+rsa.getString("actor")+"</td>");
			out.println("<td class='style3'>"+((rsa.getString("remark")==null || rsa.getString("remark").equals(""))?"&nbsp;":rsa.getString("remark"))+"</td>");
			out.println("</tr>");
			cnt ++;
		}
		if (cnt >0)
		{
			out.println("</table></td></tr>");
		}
		rsa.close();
		statementa.close();

	%>
</table>
<%
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());	
}
if (ACTIONID.equals("002"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("PO單價申請成功!!(申請單號:"+ document.MYFORM.REQUESTNO.value+")\n\n若要繼續申請下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDQuotationCreate.jsp";
	}		
	</script>
<%
}
else if (ACTIONID.equals("0021"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("PO單價修改成功!!(申請單號:"+ document.MYFORM.REQUESTNO.value+")\n\n若要繼續修改下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDQuotationQuery.jsp?STATUS=Reject";
	}		
	</script>
<%
}
else if (ACTIONID.equals("001"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("PO單價申請已取消!!(申請單號:"+ document.MYFORM.REQUESTNO.value+")\n\n若要繼續異動下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDQuotationQuery.jsp?STATUS=Reject";
	}		
	</script>
<%
}
else if (ACTIONID.equals("003"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("PO單價核淮成功!!(申請單號:"+ document.MYFORM.REQUESTNO.value+")\n\n若要繼續核淮下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDQuotationConfirmList.jsp";
	}	
	</script>
<%
}
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
</html>
