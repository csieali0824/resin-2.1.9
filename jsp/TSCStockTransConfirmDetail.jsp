<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
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
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 11px}
#Layer1 {
	position:absolute;
	width:200px;
	height:115px;
	z-index:1;
}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();
}
</script>
<FORM METHOD="post" NAME="SUBFORM">
<body>
<%
int iseq=0,icnt=0;
String sql ="",opt_subinv="SUBTRANS",opt_misc="MISC";
String HID=request.getParameter("HID");
if (HID==null) HID="";
String WKCODE=request.getParameter("WKCODE");
if (WKCODE==null) WKCODE="";
String DTYPE=request.getParameter("DTYPE");
if (DTYPE==null) DTYPE ="";
String REQUEST_NO="";
String strSubinv="",strTotAmt="";

sql = " select b.req_line_id"+
	  ",b.req_header_id"+
	  ",b.line_no"+
	  ",b.tsc_prod_group"+
	  ",b.orig_organization_id"+
	  ",b.orig_subinventory_code"+
	  ",b.orig_inventory_item_id"+
	  ",b.orig_item_name"+
	  ",b.orig_item_desc"+
	  ",b.orig_lot_number"+
	  ",b.orig_date_code"+
	  ",b.orig_qty"+
	  ",b.orig_uom"+
	  ",b.req_reason"+
	  ",b.orig_trans_type_id"+
	  ",b.unit_price"+
	  ",b.tot_amt"+
	  ",b.new_organization_id"+
	  ",b.new_subinventory_code"+
	  ",b.new_inventory_item_id"+
	  ",b.new_item_name"+
	  ",b.new_item_desc"+
	  ",b.new_lot_number"+
	  ",b.new_date_code"+
	  ",b.new_qty"+
	  ",b.new_uom"+
	  ",c.organization_code orig_organization_code"+
	  ",d.organization_code new_organization_code"+
	  ",to_number(to_char(a.creation_date,'yyyy'))-1911 iyear"+
	  ",to_char(a.creation_date,'mm') imonth"+
	  ",to_char(a.creation_date,'dd') iday"+
	  ",e.trans_name"+
	  ",e.trans_desc"+
	  ",a.req_no"+
	  ",h.description orig_subinv_name"+
	  ",k.description new_subinv_name"+
	  ",sum(nvl(b.tot_amt,0)) over (partition by 1) gtot_amt"+
	  " from oraddman.tsc_stock_trans_headers a"+
	  ",oraddman.tsc_stock_trans_lines b"+
	  ",inv.mtl_parameters c"+
	  ",inv.mtl_parameters d"+
	  ",oraddman.tsc_stock_trans_type e"+
	  ",oraddman.tsc_stock_trans_wkflow f"+
	  ",inv.mtl_secondary_inventories h"+
	  ",inv.mtl_secondary_inventories k";
if (!DTYPE.equals("Q"))
{	  
	sql +=",oraddman.tsc_stock_trans_member g";
}
	sql +=" where a.req_header_id=b.req_header_id"+
	  " and a.req_header_id=?"+
	  " and b.orig_organization_id=c.organization_id"+
	  " and b.new_organization_id=d.organization_id"+
	  " and a.trans_type=e.trans_type"+
	  " and a.trans_type=f.trans_type"+
	  " and a.wkflow_level=f.wkflow_level"+
	  " and b.orig_organization_id=h.organization_id"+
	  " and b.orig_subinventory_code=h.secondary_inventory_name"+
	  " and b.new_organization_id=k.organization_id(+)"+
	  " and b.new_subinventory_code=k.secondary_inventory_name(+)";
if (!DTYPE.equals("Q"))
{	  
	sql += " and a.trans_type=g.trans_type"+
	  	   " and f.wkflow_next_level=g.wkflow_level"+
	       " and a.status_code in (?,?)"+
	       " and substr(g.WKFLOW_LEVEL,1,length(?))=?"+
	       " and g.user_name=?";	  
}
PreparedStatement statementx = con.prepareStatement(sql);
statementx.setString(1,HID);
if (!DTYPE.equals("Q"))
{	
	statementx.setString(2,"AWAITING_APPROVE");
	statementx.setString(3,"CONFIRMED");
	statementx.setString(4,WKCODE);
	statementx.setString(5,WKCODE);
	statementx.setString(6,UserName);
}
ResultSet rsx=statementx.executeQuery();
iseq=0;	
while (rsx.next())
{
	iseq++;
	if (iseq==1)
	{
		REQUEST_NO=rsx.getString("req_no");
	%>	
		<table width="100%">
			<tr><td width="25%"><img src="images/logo.PNG"></td><td colspan="2" width="50%" align="center" style="font-weight:bold;font-family:'細明體';font-size:28px">台灣半導體股份有限公司</td><td width="25%">&nbsp;</td></tr>
			<tr><td>&nbsp; </td><td colspan="2" align="center" style="font-family:'細明體';font-size:24px"><%=rsx.getString("trans_desc")%></td><td>&nbsp;</td></tr>
<%

			sql = " SELECT a.organization_code,listagg( a.subinventory_code||' '||a.subinventory_name,' , ') within group(order by a.subinventory_code) subinv_list"+
				  " FROM oraddman.tsc_stock_trans_subinv a"+
				  " where NVL(a.active_flag,'N')=?"+
				  //" and (exists (select 1 from oraddman.tsc_stock_trans_lines b,mtl_parameters c where b.req_header_id=? and b.orig_organization_id=c.organization_id and b.orig_subinventory_code=a.subinventory_code and c.organization_code=a.organization_code)"+
				  //" or exists (select 1 from oraddman.tsc_stock_trans_lines b,mtl_parameters c where b.req_header_id=? and b.new_organization_id=c.organization_id and b.new_subinventory_code=a.subinventory_code and c.organization_code=a.organization_code))"+
                  " and (exists (select 1 from oraddman.tsc_stock_trans_lines b,mtl_parameters c,oraddman.tsc_stock_trans_headers d where d.req_header_id=? and d.trans_type=a.trans_type and d.req_header_id=b.req_header_id and b.orig_organization_id=c.organization_id and b.orig_subinventory_code=a.subinventory_code and c.organization_code=a.organization_code)"+ //add by Peggy 20201019
                  " or exists (select 1 from oraddman.tsc_stock_trans_lines b,mtl_parameters c,oraddman.tsc_stock_trans_headers d where d.req_header_id=? and d.trans_type=a.trans_type and d.req_header_id=b.req_header_id and b.new_organization_id=c.organization_id and b.new_subinventory_code=a.subinventory_code and c.organization_code=a.organization_code))"+ //add by Peggy 20201019
				  " group by  a.organization_code";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,"A");
			statement1.setString(2,HID);
			statement1.setString(3,HID);
			ResultSet rs1=statement1.executeQuery();
			if (rs1.next())
			{	
				if (strSubinv.length()>0) strSubinv += "<br>";
				strSubinv+= rs1.getString(1)+":"+rs1.getString(2);
			}
			rs1.close();
			statement1.close();							 
		%>
			<tr><td colspan="4" style="color:#0000FF;font-family:Tahoma,Georgia;font-size:11px"><%="倉別說明:<br>"+strSubinv%></td></tr>	
			<tr><td><font style="font-family:'細明體';font-size:12px">申請單:</font><fon style="font-family:'Tahoma,Georgia';font-size:12px"><%=REQUEST_NO%></font></td><td colspan="2">&nbsp;</td>
			<td align="right" style="font-family:'Tahoma,Georgia';font-size:12px">申請日期:民國&nbsp;&nbsp;<%=rsx.getInt("iyear")%>&nbsp;&nbsp;年&nbsp;&nbsp;<%=rsx.getInt("imonth")%>&nbsp;&nbsp;月&nbsp;&nbsp;<%=rsx.getInt("iday")%>&nbsp;&nbsp;日</td></tr>
			<tr><td colspan="4">
			<table width="100%" border="1" cellspacing="0" cellpadding="1">
			<%
			if (rsx.getString("trans_name").equals(opt_subinv))
			{
			%>
				<tr bgcolor="#D5ECB0" style="font-family:Tahoma,Georgia">
					<td width="3%" align="center">項次</td>
					<td width="4%" align="center">產品別</td>
					<td width="18%" align="center">料號(22D/30D)</td>
					<td width="13%" align="center">品名規格</td>
					<td width="10%" align="center">Lot Number</td>
					<td width="5%" align="center">Date Code</td>
					<td width="3%" align="center">移出Org</td>
					<td width="3%" align="center">移出倉別</td>
					<td width="3%" align="center">移入Org</td>
					<td width="3%" align="center">移入倉別</td>
					<td width="5%" align="center">數量</td>
					<td width="3%" align="center">單位</td>
					<td width="14%" align="center">移轉原因</td>
					<td width="5%" align="center">單價</td>
					<td width="7%" align="center">Amt(NTD)</td>
				</tr>
	
<%
			}
			else if (rsx.getString("trans_name").equals(opt_misc))
			{
%>
				<tr bgcolor="#E2D9CD" style="font-family:Tahoma,Georgia">
					<td width="2%" style="font-size:11px">項次</td>
					<td width="4%" style="font-size:11px">產品別</td>
					<td width="14%" style="font-size:11px">轉出料號(22D/30D)</td>
					<td width="9%" style="font-size:11px">轉出品名規格</td>
					<td width="7%" style="font-size:11px">Lot Number</td>
					<td width="3%" style="font-size:11px">Date Code</td>
					<td width="4%" style="font-size:11px">數量</td>
					<td width="3%" align="center" style="font-size:11px">單位</td>
					<td width="3%" align="center" style="font-size:11px">Org</td>
					<td width="3%" style="font-size:11px">倉別</td>
					<td width="14%" style="font-size:11px">轉入<br>料號(22D/30D)</td>
					<td width="9%" style="font-size:11px">轉入<br>品名規格</td>
					<td width="7%" style="font-size:11px">轉入<br>Lot Number</td>
					<td width="3%" style="font-size:11px">轉入<br>D/C</td>
					<td width="4%" style="font-size:11px">轉入<br>數量</td>
					<td width="3%" align="center" style="font-size:11px">轉入<br>單位</td>
					<td width="8%" style="font-size:11px">移轉原因</td>
				</tr>
<%			
			}
	}

	if (rsx.getString("trans_name").equals(opt_subinv))
	{
		strTotAmt = rsx.getString("gtot_amt");
%>	
				<tr>
				<td><%=iseq%></td>
				<td><%=rsx.getString("TSC_PROD_GROUP")%></td>
				<td><%=rsx.getString("ORIG_ITEM_NAME")%></td>
				<td><%=rsx.getString("ORIG_ITEM_DESC")%></td>
				<td><%=rsx.getString("ORIG_LOT_NUMBER")%></td>
				<td><%=(rsx.getString("ORIG_DATE_CODE")==null?"&nbsp;":rsx.getString("ORIG_DATE_CODE"))%></td>
				<td><%=rsx.getString("ORIG_ORGANIZATION_CODE")%></td>
				<td><%=rsx.getString("ORIG_SUBINVENTORY_CODE")%></td>
				<td><%=rsx.getString("NEW_ORGANIZATION_CODE")%></td>
				<td><%=rsx.getString("NEW_SUBINVENTORY_CODE")%></td>
				<td align="right"><%=rsx.getString("ORIG_QTY")%></td>
				<td><%=rsx.getString("ORIG_UOM")%></td>
				<td><%=(rsx.getString("REQ_REASON")==null?"&nbsp;":rsx.getString("REQ_REASON"))%></td>
				<td align="right"><%=(rsx.getString("UNIT_PRICE")==null?"&nbsp;":rsx.getString("UNIT_PRICE"))%></td>
				<td align="right"><%=(rsx.getString("TOT_AMT")==null?"&nbsp;":rsx.getString("TOT_AMT"))%></td>
				</tr>
<%		
	}
	else if (rsx.getString("trans_name").equals(opt_misc))
	{
%>
				<tr>
				<td style="font-size:11px"><%=iseq%></td>
				<td style="font-size:11px"><%=rsx.getString("TSC_PROD_GROUP")%></td>
				<td style="font-size:11px"><%=rsx.getString("ORIG_ITEM_NAME")%></td>
				<td style="font-size:11px"><%=rsx.getString("ORIG_ITEM_DESC")%></td>
				<td style="font-size:11px"><%=rsx.getString("ORIG_LOT_NUMBER")%></td>
				<td style="font-size:11px"><%=(rsx.getString("ORIG_DATE_CODE")==null?"&nbsp;":rsx.getString("ORIG_DATE_CODE"))%></td>
				<td align="right" style="font-size:11px"><%=rsx.getString("ORIG_QTY")%></td>
				<td align="center" style="font-size:11px"><%=rsx.getString("ORIG_UOM")%></td>
				<td align="center" style="font-size:11px"><%=rsx.getString("ORIG_ORGANIZATION_CODE")%></td>
				<td align="center" style="font-size:11px"><%=rsx.getString("ORIG_SUBINVENTORY_CODE")%></td>
				<td style="color:<%=(!rsx.getString("NEW_ITEM_NAME").equals(rsx.getString("ORIG_ITEM_NAME"))?"#ff0000":"#000000")%>;font-size:11px"><%=rsx.getString("NEW_ITEM_NAME")%></td>
				<td style="font-size:11px"><%=rsx.getString("NEW_ITEM_DESC")%></td>
				<td style="color:<%=(!rsx.getString("NEW_LOT_NUMBER").equals(rsx.getString("ORIG_LOT_NUMBER"))?"#ff0000":"#000000")%>;font-size:11px"><%=rsx.getString("NEW_LOT_NUMBER")%></td>
				<td style="font-size:11px"><%=(rsx.getString("NEW_DATE_CODE")==null?"&nbsp;":rsx.getString("NEW_DATE_CODE"))%></td>
				<td align="right" style="color:<%=(!rsx.getString("NEW_QTY").equals(rsx.getString("ORIG_QTY"))?"#ff0000":"#000000")%>;font-size:11px"><%=rsx.getString("NEW_QTY")%></td>
				<td align="center" style="color:<%=(!rsx.getString("NEW_UOM").equals(rsx.getString("ORIG_UOM"))?"#ff0000":"#000000")%>;font-size:11px"><%=rsx.getString("NEW_UOM")%></td>
				<td style="font-size:11px"><%=rsx.getString("REQ_REASON")%></td>
				</tr>
<%
	}
}
rsx.close();
statementx.close();

if (iseq>0)
{
%>
			</table>
		</td>
	</tr>	
<%
	if (!strTotAmt.equals(""))
	{
%>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan="2" align="right" style="font-weight:bold;color:#0000CC;font-size:13px">合計:&nbsp;&nbsp;<%=strTotAmt%></td>				
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
<%
	}

		//取得附件
		String rootName = "/jsp/ILAN_Attache/"+REQUEST_NO;
		String rootPath = application.getRealPath(rootName);
		File fp = new File(rootPath);
		if (fp.exists()) 
		{
%>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4">附件:
<%
			String[] list = fp.list();
			if (list.length > 0)
			{
				for(int i=0; i<list.length;i++)
				{
					if (list[i].endsWith(".files") || list[i].endsWith(".msg")) continue;
					File inFp = new File(rootPath + File.separator + list[i]);
					out.println("&nbsp;<img src='images/pdf.gif'><font style='font-family:arial;font-size:12px'><a href='.."+rootName+"/"+list[i]+"' target='_blank'>"+list[i]+"</a> ("+new Long(inFp.length()) +" bytes) "+new Timestamp(new Long(inFp.lastModified()).longValue())+"</font><br>");
				}
			}
			else
			{
				out.println("&nbsp;<br>&nbsp;");
			}
%>
		</td>
	</tr>
<%		
		}
		
		String approve_str="<br>&nbsp;",manager_str="<br>&nbsp;",requestor_str="<br>&nbsp;";
		sql = " select a.action_code,a.created_by,to_char(a.creation_date,'yyyy-mm-dd') creation_date"+
          " from oraddman.tsc_stock_trans_action_log a"+
          " where req_header_id=?"+
          " group by a.action_code,a.created_by,to_char(a.creation_date,'yyyy-mm-dd')";
		statementx = con.prepareStatement(sql);
		statementx.setString(1,HID);
		rsx=statementx.executeQuery();
		while (rsx.next())
		{
			if (rsx.getString("action_code")==null) continue;
			if (rsx.getString("action_code").toUpperCase().equals("APPROVED"))
			{
				approve_str=rsx.getString("created_by")+"<br>"+rsx.getString("creation_date"); 
			}	
			else if (rsx.getString("action_code").toUpperCase().equals("CONFIRMED")) 
			{
				manager_str=rsx.getString("created_by")+"<br>"+rsx.getString("creation_date");
			}
			else if (rsx.getString("action_code").toUpperCase().equals("SUBMIT"))
			{		
				requestor_str=rsx.getString("created_by")+"<br>"+rsx.getString("creation_date");
			}	
		}
		rsx.close();
		statementx.close();			
%>
	<tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan="2">
			<table width="100%">
				<tr>
				<td width="33%" style="color:#000000;font-family:Tahoma,Georgia;font-size:12px" align="right">核淮:<%=approve_str%></td>
				<td width="33%" style="color:#000000;font-family:Tahoma,Georgia;font-size:12px" align="right">單位主管:<%=manager_str%></td>
				<td width="33%" style="color:#000000;font-family:Tahoma,Georgia;font-size:12px" align="right">申請人:<%=requestor_str%></td>
				</tr>
			</table>
		</td>				
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>	
</table>
	<%
	if (DTYPE.equals("Q"))
	{
	%>
        <table width="100%">
          <tr><td colspan="3">&nbsp;</td></tr>
          <tr><td colspan="3" align="center"><input type="button" name="PREPAGE" value="回上頁" onClick="setSubmit('../jsp/TSCStockTransQuery.jsp?WKCODE=<%=WKCODE%>')"></td></tr>	
          <tr><td colspan="3">&nbsp;</td></tr>
          <tr><td colspan="3">&nbsp;</td></tr>
          <tr><td width="25%">&nbsp;</td>
		 	  <td width="50%">
		    <%
		sql = " SELECT a.req_header_id, a.seq_id, a.action_code, a.created_by,"+
              " to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date, a.remarks"+
              " FROM oraddman.tsc_stock_trans_action_log a"+
			  " WHERE a.req_header_id=?";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,HID);
		ResultSet rs=statement.executeQuery();
		int cnt =0;
		while (rs.next())
		{
			if (cnt ==0)
			{
				out.println("<table width='100%' border='1' align='left' cellpadding='1' cellspacing='0'  bordercolorlight='#FFFFFF'  bordercolordark='#336600'>");
				out.println("<tr>");
				out.println("<td height='20' colspan='8' >申請歷程：</td>");
				out.println("</tr>");
				out.println("<tr style='background-color:#DADAD6'>");
				out.println("<td width='5%'>序號</td>");
				out.println("<td width='15%'>執行作業</td>");
				out.println("<td width='15%'>操作人員</td>");
				out.println("<td width='15%'>操作日期</td>");
				out.println("<td width='35%'>備註</td>");
				out.println("</tr>");
			}
			out.println("<tr>");
			out.println("<td>"+rs.getString("SEQ_ID")+"</td>");
			out.println("<td>"+rs.getString("action_code")+"</td>");
			out.println("<td>"+rs.getString("created_by")+"</td>");
			out.println("<td>"+rs.getString("creation_date")+"</td>");
			out.println("<td>"+((rs.getString("remarks")==null || rs.getString("remarks").equals(""))?"&nbsp;":rs.getString("remarks"))+"</td>");
			out.println("</tr>");
			cnt ++;
		}
		if (cnt >0)
		{
			out.println("</table>");
		}
		else
		{
			out.println("&nbsp;");
		}
		rs.close();
		statement.close();
		%>		    
			</td>
		  	<td width="25%">&nbsp;</td>
	  	</tr>
	</table>
      <%
	}
%>
        <%
}
else
{
	if (DTYPE.equals("Q"))
	{
	%>
	<script language="JavaScript" type="text/JavaScript">
		alert("查無資料,請重新確認,謝謝!");
		location.href="../jsp/TSCStockTransQuery.jsp?WKCODE=<%=WKCODE%>";
	</script>
	<%
	}
	else
	{
		out.println("<font color='red'>No data found!</font>");
	}
}
%>
</body>
</FORM>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</head>
</html>


