<!-- 20141008 by Peggy,���RFQ�Ȥ�i������D/C�~��-->
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
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit1()
{    
	this.window.close();
}
function setCheck(chkline,itemid,slowseqid,idleqty)
{
	var chkflag ="";
	var lineid="";
	var ship_qty="";

	if (window.opener.document.DISPLAYREPAIR.chk.length != undefined)
	{
		chkflag = window.opener.document.DISPLAYREPAIR.chk[chkline-1].checked; 
		lineid = window.opener.document.DISPLAYREPAIR.chk[chkline-1].value;	
		if (chkflag != true)
		{	
			window.opener.document.DISPLAYREPAIR.chk[chkline-1].checked=true;
			window.opener.document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].disabled = false;
			window.opener.document.DISPLAYREPAIR.elements["IDLE_REMARK"+lineid].disabled = false;
			window.opener.document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].disabled = false;
			window.opener.document.DISPLAYREPAIR.elements["SHIPDATE"+lineid].disabled = false;
			window.opener.document.DISPLAYREPAIR.elements["IDLE_REMARK"+lineid].value = "";
			window.opener.document.getElementById("tr"+lineid).style.backgroundColor ="#daf1a9";
			window.opener.document.getElementById("popcal"+lineid).style.width=20;
		}
	}
	else
	{
		chkflag = window.opener.document.DISPLAYREPAIR.chk.checked; 
		lineid = window.opener.document.DISPLAYREPAIR.chk.value;		
		if (chkflag != true)
		{
			window.opener.document.DISPLAYREPAIR.chk.checked=true;
			window.opener.document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].disabled = false;
			window.opener.document.DISPLAYREPAIR.elements["IDLE_REMARK"+lineid].disabled = false;
			window.opener.document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].disabled = false;
			window.opener.document.DISPLAYREPAIR.elements["SHIPDATE"+lineid].disabled = false;
			window.opener.document.DISPLAYREPAIR.elements["IDLE_REMARK"+lineid].value = "";
			window.opener.document.getElementById("tr"+lineid).style.backgroundColor ="#daf1a9";
			window.opener.document.getElementById("popcal"+lineid).style.width=20;
		}			
	}
	window.opener.document.DISPLAYREPAIR.elements["IDLE_REMARK"+lineid].value = document.MYFORM.elements["info_"+slowseqid].value;	
	ship_qty = eval(window.opener.document.DISPLAYREPAIR.elements["QTY_"+lineid].value)*1000;
	if (eval(ship_qty)>eval(idleqty))
	{
		window.opener.document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value = eval(idleqty)/1000;
		window.opener.document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value = (eval(ship_qty)-eval(idleqty))/1000;
	}
	else
	{
		window.opener.document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value = eval(ship_qty)/1000;
		window.opener.document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value = "0";
	}		
	window.opener.document.DISPLAYREPAIR.elements["SLOWSEQID"+lineid].value = slowseqid;	
	setSubmit1();
}
</script>
<STYLE TYPE='text/css'> 
 .style1   {font-family:�з���; font-size:13px; background-color:#CCFF66; color:#000000; text-align:left;}
 .style2   {font-family:arial; font-size:13px; background-color:#CCFF66; color:#000000; text-align:left;}
 .style3   {font-family:�з���; font-size:14px; background-color:#FFFFFF; color:#000000; text-align:left;}
 .style4   {font-family:Arial; font-size:12px; color: #000000; text-align:center}
 .style7   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#CC0000; text-align:right;}
 .style9   {font-family:Arial; font-size:12px; background-color:#CCFFFF; color:#000000; text-align:left;}
 .style13  {font-family:�з���; font-size:14px; background-color:#AAAAAA; color:#FFFFFF; text-align:left;}
 .style14  {font-family:�з���; font-size:14px; background-color:#AAAAAA; color:#FFFFFF; text-align:center;}
 .style15  {font-family:�з���; font-size:16px; background-color:#6699CC; color:#FFFFFF; text-align:center;}
 .style16  {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:right;}
 .style17  {font-family:Arial; font-size:14px; background-color:#FFFFFF; color:#000000; text-align:LEFT;}
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
String TSCDESC = request.getParameter("TSCDESC");  //add by Peggy 20140123
if (TSCDESC == null) TSCDESC="";
String CUSTNO = request.getParameter("CUSTNO");  //add by Peggy 20141008
if (CUSTNO == null) CUSTNO ="";
String sregion = request.getParameter("SREGION");  //add by Peggy 20221230
if (sregion == null ) sregion="";
String CHKLINE=request.getParameter("CHKLINE"); //add by Peggy 20230203
if (CHKLINE==null) CHKLINE="";
%>
</head>
<body>
<form name="MYFORM"  METHOD="post" ACTION="../jsp/TscSlowMovingQueryAll.jsp">
<p>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Slow Moving Stock Query</strong></font>
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
							<div style="text-decoration:underline;font-size:12px;font-family:Tahoma,Georgia;" onClick="setSubmit1()" align="center">Close Window</div>
						<%
						}
						else
						{
						%>
						<table>
							<tr>
    							<TD width="10%"  height="70%" class="style13" title="�^����!">
									<A HREF="../ORAddsMainMenu.jsp" style="text-decoration:none;color:#FFFFFF">
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
									<A HREF="TscSlowMovingQueryHistory.jsp" style="text-decoration:none;color:#FFFFFF">
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
						if (qtype.equals("sub") || UserRoles.indexOf("SMS_M")<0)
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
									<A HREF="TscSlowMovingQtyUpload.jsp" style="text-decoration:none;color:#FFFFFF">
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
				<tr>
					<td width="15%" style="font-family:�з���;font-size:14px;color:#000000">�~�Ȱϰ�:</td>
					<td width="20%">
				<%		 
					try
					{   
						Statement statement=con.createStatement();
						String sql = "select distinct area,area from oraddman.tsc_idle_stock_detail ";
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
					<td width="15%" style="font-family:�з���;font-size:14px;color:#000000">�x�b�Ƹ��Ϋ~�W:</td>
					<td width="20%"><input type="text" name="ITEMNAME" value="<%=sitem%>"></td>
					<td align="center"><input type="button" name="Query" value="�d��" onClick="setSubmit('../jsp/TscSlowMovingQueryAll.jsp')"></td>
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
	sql = " SELECT a.version_id, a.area, a.inventory_item_id, a.item_name,a.item_desc, a.date_code, a.idle_qty, a.sales, a.customer,a.remarks"+
		  ", nvl((select attribute4 from ar_customers  where customer_id='"+CUSTNO+"'),'N/A') attribute4,region,a.seq_no"+	  
		  ",'�P�N���ƫȤ�:'||a.customer||' ����:'||a.item_desc||' �b'||a.area||'���w�s' as stock_info"+ //add by Peggy 20230208    
          " FROM oraddman.tsc_idle_stock_detail a"+
		  " where a.version_id in (select max(version_id) FROM oraddman.tsc_idle_stock_header b where b.version_id = a.version_id and b.VERSION_FLAG='A')";
	if (!sarea.equals("") && !sarea.equals("ALL") && !sarea.equals("--")) sql += " and a.area ='"+ sarea +"'";
	if (!sitem.equals("")) sql += " and (a.item_name like '%"+sitem+"%' or item_desc like '%"+sitem+"%')";
	//add by Peggy 20140123
	//if (!TSCDESC.equals("")) sql += " and CASE WHEN INSTR (item_desc, '-') > 0 THEN SUBSTR (item_desc,0,INSTR (item_desc, '-') - 1) ELSE SUBSTR (item_desc,0, LENGTH (item_desc)- LENGTH (apps.tsc_get_item_packing_code (49,inventory_item_id)) - 1) END ='"+ TSCDESC+"'";
	if (!TSCDESC.equals("")) sql += " and CASE WHEN INSTR (item_desc, '-') > 0 THEN SUBSTR (item_desc,0,INSTR (item_desc, '-') - 1) ELSE case when apps.tsc_get_item_packing_code (49,inventory_item_id) in ('QQ','QQG') THEN a.item_desc ELSE SUBSTR (item_desc,0, LENGTH (item_desc)- LENGTH (apps.tsc_get_item_packing_code (49,inventory_item_id)) - 1) END END ='"+ TSCDESC+"'"; //add by Peggy 20220722
	sql += " order by case when '"+sregion+"' is null then 1 else case when instr('"+sregion+"',a.region)>0 then 0 else 1 end end, case when upper(a.area) in ('YEW','TEW','ILAN','A01') then 0 else 1 end,a.area,a.region";
	//out.println(sql);
	rs = st.executeQuery(sql);
	int firCnt = 0;
	while (rs.next()) 
	{	
		if (firCnt==0)
		{
			out.println("<tr><td><table cellspacing='0' bordercolordark='#998811' cellpadding='1' width='100%' align='left' bordercolorlight='#ffffff' border='1'>");
			out.println("<tr>");
			if (!CHKLINE.equals("")) //add by Peggy 20230203
			{
				out.println("<td class='style1'>&nbsp;</td>");
			}
			out.println("<td class='style1'>����</td>");
			out.println("<td class='style1'>�~�Ȱϰ�</td>");
			out.println("<td class='style1'>�f���a</td>");
			out.println("<td class='style1'>�x�b���X</td>");
			out.println("<td class='style1'>�x�b�~�W</td>");
			out.println("<td class='style2'>Date Code</td>");
			out.println("<td class='style1'>�ƶq</td>");
			out.println("<td class='style1'>�~�ȤH��</td>");
			out.println("<td class='style1'>�Ȥ�</td>");
			out.println("<td class='style1'>�Ƶ�</td>");
			if (!CUSTNO.equals(""))
			{
				out.println("<td style='font-size:13px;background-color:#FFCCCC;font-family:�з���;'>�Ȥ�D/C����</td>");
			}
			out.println("</tr>");
		}
		//add by Peggy 201401120
		if (!rs.getString("item_desc").equals(sitemdesc))
		{
			out.println("<tr style='background-color:#ffffff'>");
		}
		else
		{
			out.println("<tr bgcolor='#AAD5BF'>");
		}
		if (!CHKLINE.equals("")) //add by Peggy 20230203
		{
			out.println("<td width='3%' style='font-size:11px;font-family:arial'><input type='button' name='btn"+rs.getString("seq_no")+"' value='set'  onClick='setCheck("+'"'+CHKLINE+'"'+","+'"'+rs.getString("INVENTORY_ITEM_ID")+'"'+","+'"'+rs.getString("seq_no")+'"'+","+'"'+rs.getString("idle_qty")+'"'+")'></td>");
		}		
		out.println("<td width='3%' style='font-size:11px;font-family:arial'>"+rs.getString("version_id") + "</td>");
		out.println("<td width='7%' style='font-size:11px;font-family:arial'>"+rs.getString("region") + "</td>");
		out.println("<td width='7%' style='font-size:11px;font-family:arial'>"+rs.getString("area") + "</td>");
		out.println("<td width='16%' style='font-size:11px;font-family:arial'>"+rs.getString("item_name") + "</td>");
		out.println("<td width='14%' style='font-size:11px;font-family:arial'>"+rs.getString("item_desc") + "</td>");
		out.println("<td width='15%' style='font-size:11px;font-family:arial'>"+(rs.getString("date_code")==null?"&nbsp;":rs.getString("date_code")) + "</td>");
		out.println("<td width='6%' style='font-size:11px;font-family:arial' align='right'>"+rs.getString("idle_qty")+"</td>");
		out.println("<td width='6%' style='font-size:11px;font-family:arial'>"+rs.getString("sales") + "</td>");
		out.println("<td width='9%' style='font-size:11px;font-family:arial'>"+(rs.getString("customer")==null?"&nbsp;":rs.getString("customer")) + "</td>");
		out.println("<td width='12%' style='font-size:11px;font-family:arial'>"+(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks")));
		out.println("<input type='hidden' name='info_"+rs.getString("seq_no")+"' value='"+rs.getString("stock_info")+"'>");
		out.println("</td>");
		
		if (!CUSTNO.equals(""))
		{
			out.println("<td width='10%' style='font-size:11px;font-family:arial;background-color:#ffffff;'>"+(rs.getString("attribute4").equals("N/A")?"N/A":rs.getString("attribute4")+"��")+"</td>");
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
<input type="hidden" name="QTYPE" value="<%=qtype%>">
<input type="hidden" name="CHKLINE" value="<%=CHKLINE%>">
</form>
<!--=============�H�U�Ϭq������s����==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
