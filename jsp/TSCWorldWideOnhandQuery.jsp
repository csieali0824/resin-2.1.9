<%@ page contentType="text/html;charset=utf-8" pageEncoding="big5" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean,ComboBoxAllBean"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<html>
<head>
<title>Slow Moving Stock Query</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<STYLE TYPE='text/css'> 
.style13  {font-family:Tahoma,Georgia; font-size:13px; background-color:#AAAAAA; color:#000000; text-align:left;}
 .style14  {font-family:Tahoma,Georgia; font-size:13px; background-color:#CAE1DC; color:#000000; text-align:center;}
 .style15  {font-family:Tahoma,Georgia; font-size:15px; background-color:#99CC99; color:#000000; text-align:center;}
 .style16  {font-family:Tahoma,Georgia; font-size:11px; background-color:#FFFFFF; color:#000000; text-align:right;}
 td {word-break:break-all}
</STYLE>
<%
String sarea = request.getParameter("SALESAREA");
if (sarea == null ) sarea="";
String sitem = request.getParameter("ITEMNAME");
if (sitem == null) sitem ="";
String qtype = request.getParameter("QTYPE");
if (qtype == null) qtype ="";
String sitemdesc = request.getParameter("ITEMDESC");
if (sitemdesc == null) sitemdesc ="";
String TSCDESC = request.getParameter("TSCDESC");  
if (TSCDESC == null) TSCDESC="";
String CUSTNO = request.getParameter("CUSTNO");
if (CUSTNO == null) CUSTNO ="";
%>
</head>
<body>
<form name="MYFORM"  METHOD="post" ACTION="../jsp/TSCWorldWideOnhandQuery.jsp">
<p>
<font  style="font-weight:bold;font-family:'Tahoma,Georgia';color:#003399;font-size:24px" >TSC ���~�w�s���Ӭd��</font>
<br>
</p>
<table width="100%" bgcolor="#D8E6E7" cellspacing="0" cellpadding="0" bordercolordark="#990000">
 	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#000000" cellpadding="1" width="100%" height="15" align="left">
				<TR>
					<td width="10%" bgcolor="#FFFFFF">
						<%
						if (qtype.equals("sub"))
						{
						%>
							&nbsp;
						<%
						}
						else
						{
						%>
						<table>
							<tr>
    							<TD width="10%"  height="70%" class="style13" title="�^����!">
									<A HREF="../ORAddsMainMenu.jsp" style="text-decoration:none;color:#000000">
									<STRONG>�^����</STRONG>
									</A>
								</TD>
							</tr>
						</table>
						<%
						}
						%>
					</TD>
					<TD width="10%" class="style15">
						<STRONG>�w�s�d��</STRONG>
					</TD>
					<TD width="10%" bgcolor="#FFFFFF">
						<%
						if (qtype.equals("sub"))
						{
						%>
							&nbsp;
						<%
						}
						else
						{
						%>
						<table>
							<tr>
								<TD width="10%" class="style14" title="�Ы��ڶi�J�W�Ǿ��{�d�ߥ\��!">
									<A HREF="TSCWorldWideOnhandHistory.jsp" style="text-decoration:none;color:#000000">
									<STRONG>�W�Ǿ��{</STRONG>
									</A>
								</TD>
							</tr>
						</table>
						<%
						}
						%>						
					</TD>					
					<TD width="10%" bgcolor="#FFFFFF">
						<%
						if (qtype.equals("sub") || (UserRoles.indexOf("SMS_M")<0 && UserRoles.indexOf("admin")<0))
						{
						%>
							&nbsp;
						<%
						}
						else
						{
						%>
						<table>
							<tr>
								<TD width="10%" class="style14" title="�Ы��ڶi�J��ƤW�ǥ\��!">
									<A HREF="TSCWorldWideOnhandUpload.jsp" style="text-decoration:none;color:#000000">
									<STRONG>��ƤW��</STRONG>
									</A>
								</TD>
							</tr>
						</table>
						<%
						}
						%>						
					</TD>	
					<%
					if (qtype.equals("sub"))
					{
					%>
					<TD width="65%" class="style16"></TD>
					<%
					}
					else
					{
					%>
					<!--<TD width="65%" class="style16"><a href="samplefiles/D8-001_User_Guide.doc">Download User Guide</a>&nbsp;</TD>-->
					<TD width="65%" class="style16">&nbsp;</TD>
					<%
					}
					%>						
  				</TR>
			</TABLE>
		</td>
	</tr>
	<tr>
		<td class="style15" height="10"></td>
	</tr>	
	<tr>
		<td>
			<table  border="1" bordercolor="#99FF99" cellspacing="0" bordercolordark="#996699" cellpadding="1" width="100%" height="15" align="left">
				<tr style="background-color:#C7DEC8">
					<td width="15%" style="font-family:Tahoma,Georgia;font-size:13px;color:#000000">�~�Ȱϰ�:</td>
					<td width="20%">
				<%		 
					try
					{   
						Statement statement=con.createStatement();
						String sql = "select distinct area,area from oraddman.tsc_wws_stock_detail ";
						ResultSet rs=statement.executeQuery(sql);		           
						comboBoxAllBean.setRs(rs);
						if (sarea!=null)
						{ 
							comboBoxAllBean.setSelection(sarea); 
						}
						comboBoxAllBean.setFieldName("SALESAREA");	   
						out.println(comboBoxAllBean.getRsString());
						rs.close();   
						statement.close(); 
					} 
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}		   
				%>					
					</td>
					<td width="15%" style="font-family:Tahoma,Georgia;font-size:13px;color:#000000">�x�b�Ƹ��Ϋ~�W:</td>
					<td width="20%"><input type="text" name="ITEMNAME" value="<%=sitem%>" style="font-family:Tahoma,Georgia;font-size:12px"></td>
					<td align="center"><input type="button" name="Query" value="�d��" onClick="setSubmit('../jsp/TSCWorldWideOnhandQuery.jsp')"></td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr>
		<td class="style15" height="10"></td>
	</tr>	
	
<%
String sql = "" ;
Statement st = con.createStatement();
ResultSet rs = null;
try
{
	sql = " SELECT a.version_id, a.area, a.inventory_item_id, a.item_name,a.item_desc, a.date_code, a.qty, a.lot_number,a.sales, a.customer,a.remarks"+
          " FROM oraddman.tsc_wws_stock_detail a"+
		  " where a.version_id = (select max(version_id) FROM oraddman.tsc_wws_stock_header b where b.VERSION_FLAG='A')";
	if (!sarea.equals("") && !sarea.equals("ALL") && !sarea.equals("--")) sql += " and a.area ='"+ sarea +"'";
	if (!sitem.equals("")) sql += " and (a.item_name like '%"+sitem+"%' or item_desc like '%"+sitem+"%')";
	if (!TSCDESC.equals("")) sql += " and CASE WHEN INSTR (item_desc, '-') > 0 THEN SUBSTR (item_desc,0,INSTR (item_desc, '-') - 1) ELSE SUBSTR (item_desc,0, LENGTH (item_desc)- LENGTH (apps.tsc_get_item_packing_code (49,inventory_item_id)) - 1) END ='"+ TSCDESC+"'";
	//out.println(sql);
	rs = st.executeQuery(sql);
	int firCnt = 0;
	while (rs.next()) 
	{	
		if (firCnt==0)
		{
			out.println("<tr><td><table cellspacing='0' bordercolordark='#998811' cellpadding='1' width='100%' align='left' bordercolorlight='#ffffff' border='1'>");
			out.println("<tr style='font-size:11px;font-family:Tahoma,Georgia'>");
			out.println("<td class='style1'>����</td>");
			out.println("<td class='style1'>�~�Ȱϰ�</td>");
			out.println("<td class='style1'>�x�b���X</td>");
			out.println("<td class='style1'>�x�b�~�W</td>");
			out.println("<td class='style1'>�ƶq</td>");
			out.println("<td class='style2'>Date Code</td>");
			out.println("<td class='style2'>Lot Number</td>");
			out.println("<td class='style1'>�~�ȤH��</td>");
			out.println("<td class='style1'>�Ȥ�</td>");
			out.println("<td class='style1'>�Ƶ�</td>");
			//if (!CUSTNO.equals(""))
			//{
			//	out.println("<td style='font-size:13px;background-color:#FFCCCC;font-family:Tahoma,Georgia;'>�Ȥ�D/C����</td>");
			//}
			out.println("</tr>");
		}
		if (!rs.getString("item_desc").equals(sitemdesc))
		{
			out.println("<tr style='background-color:#ffffff;font-size:11px;font-family:Tahoma,Georgia'>");
		}
		else
		{
			out.println("<tr style='background-color:#AAD5BF;font-size:11px;font-family:Tahoma,Georgia'>");
		}
		out.println("<td width='3%'>"+rs.getString("version_id") + "</td>");
		out.println("<td width='7%'>"+rs.getString("area") + "</td>");
		out.println("<td width='16%'>"+rs.getString("item_name") + "</td>");
		out.println("<td width='14%'>"+rs.getString("item_desc") + "</td>");
		out.println("<td width='6%' align='right'>"+rs.getString("qty")+"</td>");
		out.println("<td width='15%'>"+(rs.getString("date_code")==null?"&nbsp;":rs.getString("date_code")) + "</td>");
		out.println("<td width='15%'>"+(rs.getString("lot_number")==null?"&nbsp;":rs.getString("lot_number")) + "</td>");
		out.println("<td width='6%'>"+(rs.getString("sales")==null?"&nbsp;":rs.getString("sales")) + "</td>");
		out.println("<td width='9%'>"+(rs.getString("customer")==null?"&nbsp;":rs.getString("customer")) + "</td>");
		out.println("<td width='12%'>"+(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks")) + "</td>");
		if (!CUSTNO.equals(""))
		{
			out.println("<td width='10%' style='font-size:11px;font-family:Tahoma,Georgia;background-color:#ffffff;'>"+(rs.getString("attribute4").equals("N/A")?"N/A":rs.getString("attribute4")+"��")+"</td>");
		}
		out.println("</tr>");
		firCnt ++;
	}
	if (firCnt >0)
	{
		out.println("</table></td></tr>");
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
finally
{
	rs.close();
	st.close();
}
%>
</table>
<!--=============�H�U�Ϭq������s����==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>
