<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<STYLE TYPE='text/css'>  
 .style4   {font-family:細明體; font-size:12px; background-color:#BBDDEE; text-align:center}
 .style1   {font-family:Tahoma,Georgia;font-size:12px; background-color:#FFFFFF; text-align:center}
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
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
String sql ="";
String REQNO=request.getParameter("REQNO");
if (REQNO==null) REQNO="";
String IDX=request.getParameter("IDX");
if (IDX==null) IDX="";

try
{
	sql =" select a.request_no, a.version_id,  a.wip_type_no"+
		 " ,'('|| a.vendor_code||')'|| a.vendor_name vendor"+
		 " ,a.vendor_contact, a.currency_code, a.request_date"+
		 " ,a.subinventory_code, a.inventory_item_name, a.item_description"+
		 " ,a.tsc_package, a.die_name, a.die_desc, a.quantity"+
		 " ,a.unit_price, a.unit_price_uom, a.packing, a.package_spec"+
		 " ,a.test_spec, nvl(a.assembly,'N') assembly, nvl(a.testing,'N') testing"+
		 " ,nvl(a.taping_reel,'N') taping_reel, nvl(a.lapping,'N') lapping"+
		 " ,nvl(a.others,'')  others, a.remarks, a.marking, a.creation_date, a.created_by, nvl(a.wip_issue_hold_flag,'N') wip_issue_hold_flag"+
		 " ,b.line_no, b.inventory_item_name issue_item_name, b.subinventory_code issue_subinv"+
		 " ,c.description issue_item_desc, b.lot_number"+
		 " ,b.wafer_qty, b.date_code, b.completion_date,b.wafer_number"+
		 " ,row_number() over (partition by a.request_no, a.version_id order by b.line_no) row_seq"+
		 " ,count(1) over (partition by a.request_no, a.version_id) row_cnt"+
		 " from oraddman.tsa01_oem_headers_all a"+
		 ",oraddman.tsa01_oem_lines_all b"+
		 ",inv.mtl_system_items_b c"+
		 " where a.request_no=b.request_no"+
		 " and a.version_id=b.version_id"+
		 " and b.inventory_item_id=c.inventory_item_id"+
		 " and a.organization_id=c.organization_id"+
		 " and a.request_no||'-'||a.version_id=?"+
		 " order by a.request_no, a.version_id,b.line_no";
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,REQNO);
	icnt=0;
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{	 
		if (rs.getInt("row_seq")==1)
		{
%>
<table width="100%">
	<tr>	
		<td width="8%">&nbsp;</td>
		<td width="84%" align="center" style="font-weight:bold;font-size:22px;font-family:'細明體'">台灣半導體股份有限公司</td>
		<td width="9%">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%">
				<tr>
					<td align="center" style="font-weight:bold;font-size:20px;font-family:'細明體'">宜蘭封裝廠 委外託工單</td>
				</tr>
			</table>
		<td>&nbsp;</td>
	</tr>	
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0"  bordercolor="#CCCCCC">
				<tr>
					<td width="8%" style="background-color:#BBDDEE;">工單類型</td>
					<td width="20%"><%=rs.getString("WIP_TYPE_NO")%>
					<%
					if (rs.getString("WIP_ISSUE_HOLD_FLAG").equals("Y"))
					{
					%>
					<input type="checkbox" id="HOLD_FLAG" name="HOLD_FLAG" value="Y"  checked disabled><font style="font-weight:bold;color:#0033CC;">預開工單暫不發料</font>
					<%
					}
					%>
					</td>
					<td width="6%" style="background-color:#BBDDEE;">申請單號</td>
					<td width="10%" style="font-weight:bold;color:#0000FF"><%=rs.getString("REQUEST_NO")%></td>
					<td width="6%" style="background-color:#BBDDEE;">版次</td>
					<td width="10%"><%=rs.getString("VERSION_ID")%></td>
					<td width="8%" style="background-color:#BBDDEE;">申請人</td>
					<td width="12%"><%=rs.getString("CREATED_BY")%></td>
					<td width="8%" style="background-color:#BBDDEE;">Issue Date</td>
					<td width="12%"><%=rs.getString("REQUEST_DATE")%></td>
				</tr>
				<tr>
					<td style="background-color:#BBDDEE;">供應商</td>
					<td><%=rs.getString("VENDOR")%></td>
					<td style="background-color:#BBDDEE;">聯絡人</td>
					<td><%=(rs.getString("VENDOR_CONTACT")==null?"&nbsp;":rs.getString("VENDOR_CONTACT"))%></td>
					<td style="background-color:#BBDDEE;">幣別</td>
					<td><%=rs.getString("CURRENCY_CODE")%></td>
					<td style="background-color:#BBDDEE;">預計完工日</td>
					<td><%=rs.getString("COMPLETION_DATE")%></td>
					<td style="background-color:#BBDDEE;">完工入庫倉</td>
					<td><%=rs.getString("SUBINVENTORY_CODE")%></td>
				</tr>				
			</table>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0"  bordercolor="#CCCCCC">
				<tr>
					<td width="15%"><div id="DIV_CHKASSEMBLY" <%=(rs.getString("ASSEMBLY").equals("Y")?" style='font-weight:bold;color:#0033CC;'":" style='font-weight:normal;color:#000000;'")%>><input type="checkbox" name="CHKASSEMBLY" value="Y"  <%=(rs.getString("ASSEMBLY").equals("Y")?" checked":"")%> disabled>封裝<font style="font-family:Tahoma,Georgia">Assembly</font></div></td>
					<td width="15%"><div id="DIV_CHKTESTING" <%=(rs.getString("TESTING").equals("Y")?" style='font-weight:bold;color:#0033CC;'":" style='font-weight:normal;color:#000000;'")%>><input type="checkbox" name="CHKTESTING" value="Y" <%=(rs.getString("TESTING").equals("Y")?" checked":"")%> disabled>測試 <font style="font-family:Tahoma,Georgia">Testing</font></div></td>
					<td width="15%"><div id="DIV_CHKTAPING" <%=(rs.getString("TAPING_REEL").equals("Y")?" style='font-weight:bold;color:#0033CC;'":" style='font-weight:normal;color:#000000;'")%>><input type="checkbox" name="CHKTAPING" value="Y" <%=(rs.getString("TAPING_REEL").equals("Y")?" checked":"")%> disabled>編帶 <font style="font-family:Tahoma,Georgia">T＆R</font></div></td>
					<td width="15%"><div id="DIV_CHKLAPPING" <%=(rs.getString("LAPPING").equals("Y")?" style='font-weight:bold;color:#0033CC;'":" style='font-weight:normal;color:#000000;'")%>><input type="checkbox" name="CHKLAPPING" value="Y" <%=(rs.getString("LAPPING").equals("Y")?" checked":"")%> disabled>減薄 <font style="font-family:Tahoma,Georgia">Lapping</font></div></td>
					<td width="40%"><div id="DIV_CHKOTHERS" <%=(rs.getString("OTHERS")!=null?" style='font-weight:bold;color:#0033CC;'":" style='font-weight:normal;color:#000000;'")%>><input type="checkbox" name="CHKOTHERS" value="Y" <%=(rs.getString("OTHERS")!=null?" checked":"")%> disabled>其他&nbsp;&nbsp;<%=(rs.getString("OTHERS")==null?"":rs.getString("OTHERS"))%></div></td>
				</tr>
			</table>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0"  bordercolor="#CCCCCC">
				<tr>
					<td class="style4">料號<br>
				  <font style="font-family:Tahoma,Georgia">Item No</font></td>
					<td class="style4">品名<br>
				  <font style="font-family:Tahoma,Georgia">Device Name</font></td>
					<td class="style4">封裝型式<br><font style="font-family:Tahoma,Georgia">Package</font></td>
					<td class="style4">芯片名稱<br><font style="font-family:Tahoma,Georgia">Die Name</font></td>
					<td class="style4">數量<br><font style="font-family:Tahoma,Georgia">Q'ty</font>/<%=rs.getString("UNIT_PRICE_UOM")%></td>
					<td class="style4">單價<font style="font-family:Tahoma,Georgia">U/P</font><br>&nbsp;&nbsp;<%=rs.getString("CURRENCY_CODE")%>/片</td>
					<td class="style4">包裝<br><font style="font-family:Tahoma,Georgia">Packing</font></td>
					<td class="style4">封裝規格<br>
				  <font style="font-family:Tahoma,Georgia">D/B No.</font></td>
					<td class="style4">測試規格<br>
				  <font style="font-family:Tahoma,Georgia">Test Spec</font></td>
				</tr>
				<tr>
					<td class="style1"><%=rs.getString("INVENTORY_ITEM_NAME")%></td>
					<td class="style1"><%=rs.getString("ITEM_DESCRIPTION")%></td>
					<td class="style1"><%=rs.getString("TSC_PACKAGE")%></td>
					<td class="style1"><%=rs.getString("DIE_DESC")%></td>
					<td class="style1"><%=rs.getString("QUANTITY")%></td>
					<td class="style1"><%=rs.getString("UNIT_PRICE")%></td>
					<td class="style1"><%=rs.getString("PACKING")%></td>
					<td class="style1"><%=rs.getString("PACKAGE_SPEC")%></td>
					<td class="style1"><%=rs.getString("TEST_SPEC")%></td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0"  bordercolor="#CCCCCC">
				<tr>
					<td width="8%" align="right">Marking</td>
					<td width="18%"><%=rs.getString("MARKING")%></td>
					<td width="8%" align="right">備註</td>
					<td width="66%"><textarea cols="110" rows="5" name="REMARKS" style="font-size:12px;text-align:left;font-family:Tahoma,Georgia" readonly><%=rs.getString("REMARKS")%></textarea></td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>發料明細</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0"  bordercolor="#CCCCCC">
				<tr>
					<TD width="5%" class="style4"><font style="font-family:Tahoma,Georgia">Line#</font></td>
					<TD width="20%" class="style4"><font style="font-family:Tahoma,Georgia">Item No </font></td>
					<TD width="15%" class="style4"><font style="font-family:Tahoma,Georgia">Item Name</font></td>
					<TD width="10%" class="style4"><font style="font-family:Tahoma,Georgia">Wafer Subinventory</font></td>
					<TD width="15%" class="style4"><font style="font-family:Tahoma,Georgia">Wafer Lot#</font></td>
					<TD width="15%" class="style4"><font style="font-family:Tahoma,Georgia">Wafer片號</font></td>
					<TD width="10%" class="style4"><font style="font-family:Tahoma,Georgia">Wafer Qty</font></TD>
					<TD width="10%" class="style4"><font style="font-family:Tahoma,Georgia">Date Code</font></td>
				</tr>
				<%
				}
				%>
				<tr>
					<td align="center"><%=rs.getString("line_no")%></td>
					<td align="center"><%=rs.getString("issue_item_name")%></td>
					<td align="center"><%=rs.getString("issue_item_desc")%></td>
					<td align="center"><%=rs.getString("issue_subinv")%></td>
					<td align="center"><%=rs.getString("lot_number")%></td>
					<td align="center"><%=(rs.getString("wafer_number")==null?"&nbsp;":rs.getString("wafer_number"))%></td>
					<td align="center"><%=rs.getString("wafer_qty")%></td>
					<td align="center"><%=rs.getString("date_code")%></td>
				</tr>
				<%
				if (rs.getInt("row_seq")==rs.getInt("row_cnt"))
				{
				%>
			</table>
		</td>
		<td>&nbsp;</td>
	</tr>
	<%
	if (!IDX.equals(""))
	{
	%>
	<tr><td colspan="3" align="center"><input type="button" name="btngo" value="回上頁" onClick='setSubmit("../jsp/TSA01OEMQuery.jsp")'></td></tr>
	<%
	}
	%>
</table>
<%
		}
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	out.println("<font color='red'>"+e.getMessage()+"</font>");
}
%>
</body>
</FORM>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</head>
</html>


