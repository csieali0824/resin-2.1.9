<!--20180213 Peggy,新增客戶品號修改功能-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setExportXLS(URL)
{    
	if (document.MYFORM.SDATE.value=="" && document.MYFORM.EDATE.value && document.MYFORM.CUSTOMER.value=="" && document.MYFORM.MO.value=="" && document.MYFORM.ADVISE_NO.value=="" && document.MYFORM.PONO.value=="" && document.MYFORM.VENDOR.value=="" && document.MYFORM.ITEMNAME.value=="" && document.MYFORM.SALESAREA.value=="")
	{
		alert("請先輸入查詢條件!");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit1(URL)
{
	if (confirm("您確定要刪除此筆出貨通知資料嗎?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function chgObj()
{
	document.MYFORM.SDATE.value = "";
	document.MYFORM.EDATE.value = "";
}
function setUpdate(URL)
{
	var w_width=300;
	var w_height=200;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x;
	subWin=window.open(URL,"subwin",ww);
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
<title>TEW 出貨通知查詢</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String MO = request.getParameter("MO");
if (MO==null) MO="";
String ADVISE_NO = request.getParameter("ADVISE_NO");
if (ADVISE_NO==null) ADVISE_NO="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String VENDOR = request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String ITEMNAME = request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String SALESAREA = request.getParameter("SALESAREA");
if (SALESAREA==null) SALESAREA="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String sql ="",status_color="",swhere="";
int exist_cnt=0;

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

if (TRANSTYPE.equals("CANCEL") && !ID.equals(""))
{
	try
	{
		sql = " select sum(exist_cnt) tot_cnt"+
              " from (SELECT COUNT(1) exist_cnt FROM tsc.tsc_shipping_advise_lines a where pc_advise_id="+ID+""+
              " UNION ALL "+
              " SELECT COUNT(1) exist_cnt FROM tsc.tsc_pick_confirm_lines a,tsc.tsc_shipping_advise_lines b where a.advise_line_id = b.advise_line_id and b.pc_advise_id="+ID+""+
              " UNION ALL "+
              " SELECT COUNT(1) exist_cnt FROM tsc.tsc_advise_dn_header_int a,tsc.tsc_advise_dn_line_int b where a.INTERFACE_HEADER_ID=b.INTERFACE_HEADER_ID and a.advise_header_id = b.advise_header_id"+
              " and exists (select 1 from tsc.tsc_shipping_advise_lines c where c.pc_advise_id ="+ID+" and c.advise_header_id= a.advise_header_id))";
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(sql);
		if (rs1.next())
		{
			exist_cnt=rs1.getInt(1);
		}
		rs1.close();
		statement1.close();			  
		
		if (exist_cnt ==0)
		{	  
			sql = " delete tsc.tsc_shipping_advise_pc_tew a"+
				  " where pc_advise_id=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,ID);
			pstmtDt.executeUpdate();
			pstmtDt.close();
			
			sql = " delete tsc.tsc_shipping_po_price a"+
				  " where PC_ADVISE_ID=?";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,ID);
			pstmtDt.executeQuery();
			pstmtDt.close();				
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("資料刪除成功!");
			</script>	
	<%	
		}
		else
		{
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("資料刪除失敗!進出口或倉庫人員已進行作業,不允許刪除!");
			</script>	
	<%			
		}
	}
	catch(Exception e)
	{
%>
		<script language="JavaScript" type="text/JavaScript">
			alert("資料刪除失敗,請洽系統管理人員!");
		</script>
<%
	}
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWShippingAdviseQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TEW 出貨通知查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
	<tr>
		<td width="10%" bgcolor="#D3E6F3"  style="color:#006666">排定出貨日:</td>   
		<td width="20%">
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			&nbsp;~&nbsp;
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td> 
	    <td width="10%" bgcolor="#D3E6F3" style="font-family: Tahoma,Georgia;color:#006666">客戶號碼或名稱:</td> 
		<td><input type="text" name="CUSTOMER" value="<%=CUSTOMER%>" style="font-family: Tahoma,Georgia" size="30"></td>
		<td width="10%" bgcolor="#D3E6F3"  style="color:#006666">採購單號:</td>   
		<td width="10%"><input type="text" name="PONO" value="<%=PONO%>" style="font-family: Tahoma,Georgia" size="20" onKeyPress="chgObj();"></td>
		<td width="10%" bgcolor="#D3E6F3"  style="font-family: Tahoma,Georgia;color:#006666">Advise No:</td>   
		<td width="10%"><input type="text" name="ADVISE_NO" value="<%=ADVISE_NO%>" style="font-family:Tahoma,Georgia" size="20" onKeyPress="chgObj();"></td>
	</tr>
	<tr>
		<td bgcolor="#D3E6F3"  style="color:#006666">台半料號或型號:</td>   
		<td><input type="text" name="ITEMNAME" value="<%=ITEMNAME%>" style="font-family: Tahoma,Georgia" size="20"></td>
	    <td bgcolor="#D3E6F3" style="font-family: Tahoma,Georgia;color:#006666">供應商:</td> 
		<td>		
		<%
		try
		{
			sql = " select vendor_site_id,vendor_site_code from ap.ap_supplier_sites_all a where exists (select 1 from oraddman.tewpo_receive_header b where b.vendor_site_id=a.vendor_site_id) order by vendor_site_code";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(VENDOR);
			comboBoxBean.setFieldName("VENDOR");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%></td>
	    <td width="10%" bgcolor="#D3E6F3" style="font-family: Tahoma,Georgia;color:#006666">訂單號碼:</td> 
		<td width="20%"><input type="text" name="MO" value="<%=MO%>" style="font-family: Tahoma,Georgia" size="20" onKeyPress="chgObj();"></td>
		<td bgcolor="#D3E6F3"  style="font-family: Tahoma,Georgia;color:#006666">業務區:</td>   
		<td>
		<%
			sql = " SELECT REGION_CODE,REGION_CODE REGION_CODE1 FROM tsc.tsc_shipping_advise_pc_tew a  where shipping_from ='TEW' group by REGION_CODE ORDER BY 1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(SALESAREA);
			comboBoxBean.setFieldName("SALESAREA");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		%>
		</td>
	</tr>	
</table>
<table border="0" width="100%">
	<tr>
		<td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' style="font-family:Tahoma,Georgia;"  onClick='setSubmit("../jsp/TEWShippingAdviseQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='出貨通知單'  style="font-family:Tahoma,Georgia;" onClick='setExportXLS("../jsp/TEWShippingAdviseExcel.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='EXCEL'  style="font-family:Tahoma,Georgia;" onClick='setExportXLS("../jsp/TEWShippingAdviseDetailExcel.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select tsa.PC_ADVISE_ID,"+
          " ass.vendor_site_code,"+
          " tsa.SO_NO,"+
          " tsa.SO_LINE_NUMBER,"+
          " tsa.ITEM_NO,"+
          " tsa.item_desc,"+
          " (tsa.ship_qty/1000) ship_qty,"+
          " to_char(tsa.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,"+
          " decode(tsa.TO_TW,'N','否','Y','是',to_tw) TO_TW,"+
          " tsa.SHIPPING_REMARK,"+
          " tsa.CUST_PO_NUMBER,"+
          " tsa.SHIPPING_METHOD,"+
          " pha.segment1 PONO,"+
          " tspp.PO_UNIT_PRICE,"+
		  " (tspp.order_qty/1000) order_qty,"+
		  " tsa.ADVISE_NO,"+
          " decode(oolla.item_identifier_type,'CUST',oolla.ordered_item,'') CUST_ITEM,"+
		  " RA.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME,"+
		  " tsa.REGION_CODE,"+
		  " tspp.cust_partno pc_cust_partno,"+
		  " nvl((select count(1) from tsc.tsc_shipping_advise_lines tsal where tsal.pc_advise_id = tsa.pc_advise_id and not exists (select 1 from oraddman.tew_lot_allot_detail k where k.advise_line_id= tsal.advise_line_id)),0) box_cnt,"+
		  " nvl((select count(1) from oraddman.TEW_LOT_ALLOT_DETAIL tpcl,tsc.tsc_shipping_advise_lines tsal where tpcl.advise_line_id = tsal.advise_line_id and tsal.pc_advise_id = tsa.pc_advise_id and NVL(tpcl.confirm_flag,'N') <>'Y'),0) pick_cnt,"+
		  " nvl((select count(1) from tsc.tsc_pick_confirm_headers tpc,tsc.tsc_pick_confirm_lines tpcl,tsc.tsc_shipping_advise_lines tsal where tpc.advise_header_id=tpcl.advise_header_id and tpcl.advise_line_id = tsal.advise_line_id and tsal.pc_advise_id = tsa.pc_advise_id and tpc.pick_confirm_date is not null),0) shipped_cnt,"+
		  " (select count(1) from tsc.tsc_shipping_po_price tt where tt.pc_advise_id=tsa.pc_advise_id";
	if (!PONO.equals(""))
	{ 
		sql += " and exists (select 1 from po_headers_all kk where kk.po_header_id=tt.PO_HEADER_ID and kk.segment1 LIKE '"+PONO+"%')";
	}		  
	sql +=") po_cnt"+
	      ",tspp.pc_advise_price_id"+  //add by Peggy 20180213
          " FROM tsc.tsc_shipping_advise_pc_tew tsa,"+
          " ap.ap_supplier_sites_all  ass ,"+
          " po.po_headers_all pha,"+
          " ONT.OE_ORDER_LINES_ALL oolla,"+
		  " AR_CUSTOMERS ra,"+
		  " tsc.tsc_shipping_po_price tspp"+
          " where shipping_from ='TEW'"+
          " and tsa.vendor_site_id = ass.vendor_site_id"+
		  " and tsa.pc_advise_id = tspp.pc_advise_id(+)"+
          " and tspp.po_header_id = pha.po_header_id(+)"+
          " and tsa.so_line_id = oolla.line_id"+
		  " and tsa.CUSTOMER_ID = ra.CUSTOMER_ID";
	if (!SDATE.equals(""))
	{
		swhere += " and tsa.PC_SCHEDULE_SHIP_DATE >= TO_DATE('"+SDATE+"','yyyymmdd')";
	}
	if (!EDATE.equals(""))
	{
		swhere += " and tsa.PC_SCHEDULE_SHIP_DATE <= TO_DATE('"+EDATE+"','yyyymmdd')";
	}
	if (!MO.equals(""))
	{
		swhere += " and tsa.SO_NO like '"+MO+"%'";
	}
	if (!PONO.equals(""))
	{
		swhere += " and pha.SEGMENT1 like '"+PONO+"%'";
	}
	if (!ADVISE_NO.equals(""))
	{
		swhere += " and tsa.ADVISE_NO like '"+ADVISE_NO+"%'";
	}
	if (!ITEMNAME.equals(""))
	{
		swhere += " and (tsa.ITEM_NO like '"+ITEMNAME +"%' OR tsa.ITEM_DESC like '"+ ITEMNAME+"%')";
	}
	if (!CUSTOMER.equals(""))
	{
		swhere += " AND RA.CUSTOMER_NAME_PHONETIC like '"+CUSTOMER+"%' ";
	}
	if (!VENDOR.equals("") && !VENDOR.equals("--"))
	{
		swhere += " and ass.vendor_site_id = '"+VENDOR+"'";
	}
	if (!SALESAREA.equals("") && !SALESAREA.equals("--"))
	{
		swhere += " and tsa.REGION_CODE='"+ SALESAREA+"'";
	}
	if (swhere.equals(""))
	{
		String sql2 = " SELECT TO_CHAR(EDATE-6,'yyyymmdd') AS SDATE,to_char(EDATE,'yyyymmdd') EDATE"+
			  " FROM ( select case when to_char(max(tsa.PC_SCHEDULE_SHIP_DATE),'D')=6 THEN max(tsa.PC_SCHEDULE_SHIP_DATE) "+
			  " when to_char(max(tsa.PC_SCHEDULE_SHIP_DATE),'D')=7 THEN max(tsa.PC_SCHEDULE_SHIP_DATE)"+
			  " ELSE next_day(max(tsa.PC_SCHEDULE_SHIP_DATE),7) END AS EDATE"+
			  " FROM tsc.tsc_shipping_advise_pc_tew tsa"+
			  " where tsa.shipping_from ='TEW')";
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(sql2);
		if (rs1.next())
		{
			if (!rs1.getString(1).equals(""))
			{
				swhere += " and tsa.PC_SCHEDULE_SHIP_DATE >= TO_DATE('"+rs1.getString(1)+"','yyyymmdd')";
				out.println("<script language='javascript'>");
				out.println("document.MYFORM.SDATE.value ="+rs1.getString(1)+";");
				out.println("</script>");					
			}
			if (!rs1.getString(2).equals(""))
			{
				swhere += " and tsa.PC_SCHEDULE_SHIP_DATE <= TO_DATE('"+rs1.getString(2)+"','yyyymmdd')";
				out.println("<script language='javascript'>");
				out.println("document.MYFORM.EDATE.value ="+rs1.getString(2)+";");
				out.println("</script>");					
			}
		}
		rs1.close();
		statement1.close();
	}
	sql +=  swhere;
	sql += " order by tsa.PC_SCHEDULE_SHIP_DATE,tsa.ADVISE_NO,tsa.REGION_CODE,tsa.SO_NO,tsa.PC_ADVISE_ID"; 
	//out.println(sql);
	statement=con.createStatement(); 
	rs=statement.executeQuery(sql);
	String color_status1 ="#E25871", color_status2 ="#FFCC33", color_status3 ="#9933FF",color_status4 ="#99CC33",pc_advise_id="";
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table border="0" width="100%">
			<tr>
				<td bgcolor="<%=color_status1%>" width="1%">&nbsp;</td><td width="5%">生管未確認</td>
				<td bgcolor="<%=color_status2%>" width="1%">&nbsp;</td><td width="5%">進出口已編箱</td>
				<td bgcolor="<%=color_status3%>" width="1%">&nbsp;</td><td width="5%">倉庫已撿貨</td>
				<td bgcolor="<%=color_status4%>" width="1%">&nbsp;</td><td width="5%">倉庫已出貨</td>
				<td width="56%">&nbsp;</td>
			</tr>
		</table>			
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#FFFFFF"  bordercolordark="#5C7671">
			<tr bgcolor="#84BDC1" style="color:#ffffff"> 
				<td width="3%" align="center" nowrap>&nbsp;</td> 
				<td width="6%" align="center">Advise NO</td>
				<td width="5%" align="center">業務區</td>
				<td width="10%" align="center">客戶</td>
				<td width="8%" align="center">嘜頭</td>
				<td width="6%" align="center">訂單號碼</td>
				<td width="2%" align="center">項次</td>
				<td width="7%" align="center">型號</td>            
				<td width="3%" align="center">出貨量(K)</td>            
				<td width="5%" align="center">出貨日</td>            
				<td width="2%" align="center">回T</td>            
				<td width="7%" align="center">客戶品號</td>
				<td width="9%" align="center">客戶PO</td>            
				<td width="4%" align="center">出貨方式</td>            
				<td width="4%" align="center">供應商</td>
				<td width="5%" align="center">採購單號</font></div></td>
				<td width="7%" align="center">採購客戶品號</td>
				<td width="3%" align="center">單價</td>
				<td width="3%" align="center">數量(K)</td>
			</tr>
		<% 
		}
    	%>
		<!--<tr  id="tr_<%=iCnt%>" bgcolor="#ffffff" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#578FB9';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#ffffff';style.color='#000000';this.style.fontWeight='normal'">-->
		<tr  id="tr_<%=iCnt%>">
			<%
			if (!rs.getString("pc_advise_id").equals(pc_advise_id))
			{
				if (rs.getString("ADVISE_NO")==null)
				{
					status_color="style='background-color:"+color_status1+"'";
				}
				else if (rs.getInt("BOX_CNT")>0)
				{
					status_color="style='background-color:"+color_status2+"'";
				}
				else if (rs.getInt("PICK_CNT")>0)
				{
					status_color="style='background-color:"+color_status3+"'";
				}
				else if (rs.getInt("shipped_CNT")>0)
				{
					status_color="style='background-color:"+color_status4+"'";
				}
				else
				{
					status_color="";
				}
				pc_advise_id=rs.getString("pc_advise_id");
			%>
			<td rowspan="<%=rs.getString("po_cnt")%>" align="center" style="background-color:#84BDC1"><%=(status_color.equals("")?"<input type='button' name='DEL_"+rs.getString("pc_advise_id")+"' value='取消' style='font-family:Tahoma,Georgia;font-size:12px;' onClick='setSubmit1("+'"'+"../jsp/TEWShippingAdviseQuery.jsp?TRANSTYPE=CANCEL&ID="+rs.getString("pc_advise_id")+'"'+")'>":"&nbsp;")%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" align="center" <%=status_color%>><%=(rs.getString("ADVISE_NO")==null?"&nbsp;":rs.getString("ADVISE_NO"))%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" align="left"><%=rs.getString("REGION_CODE")%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" align="left"><%=rs.getString("CUSTOMER_NAME")%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" align="left"><%=(rs.getString("shipping_remark")==null?"&nbsp;":rs.getString("shipping_remark"))%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>"><%=rs.getString("SO_NO")%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>"><%=rs.getString("SO_LINE_NUMBER")%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>"><%=rs.getString("ITEM_DESC")%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("SHIP_QTY")))%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" align="center"><%=rs.getString("PC_SCHEDULE_SHIP_DATE")%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" align="center"><%=rs.getString("to_tw")%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" ><%=(rs.getString("CUST_ITEM")==null?"&nbsp;":rs.getString("CUST_ITEM"))%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" align="left"><%=rs.getString("CUST_PO_NUMBER")%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" align="left"><%=rs.getString("SHIPPING_METHOD")%></td>
			<td rowspan="<%=rs.getString("po_cnt")%>" ><%=rs.getString("vendor_site_code")%></td>
			<%
			}
			%>
			<td align="center"><font style="font-size:11px"><%=rs.getString("PONO")%></font></td>
			<td align="left"><font style="font-size:11px"><%=rs.getString("pc_cust_partno")%></font><img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setUpdate('../jsp/TEWShippingAdviseRevise.jsp?AID=<%=rs.getString("PC_ADVISE_PRICE_ID")%>')"></td>
			<td align="right"><font style="font-size:11px"><%=rs.getString("po_unit_price")%></font></td>
			<td align="right"><font style="font-size:11px"><%=rs.getString("order_qty")%></font></td>
		</tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
	}
	else
	{
%>
	</table>
<%
	}
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

