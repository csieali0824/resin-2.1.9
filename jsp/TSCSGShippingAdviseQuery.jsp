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
	if (document.MYFORM.SDATE.value=="" && document.MYFORM.EDATE.value && document.MYFORM.CUSTOMER.value=="" && document.MYFORM.MO.value=="" && document.MYFORM.ADVISE_NO.value=="" && document.MYFORM.ITEMNAME.value=="" && document.MYFORM.SALESAREA.value=="")
	{
		alert("Please input to query condition !");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit1(URL)
{
	if (confirm("Are you sure to delete the datas?"))
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
<title>SG Shipping Advise Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="com.mysql.jdbc.StringUtils"%>
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
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String ITEMNAME = request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String SALESAREA = request.getParameter("SALESAREA");
if (SALESAREA==null) SALESAREA="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String TSCPRODGROUP=request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP="";
String CHK_PRT=request.getParameter("CHK_PRT");
if (CHK_PRT==null) CHK_PRT="";
String VENDOR_SITE_CODE=request.getParameter("VENDOR_SITE_CODE");
if (VENDOR_SITE_CODE==null) VENDOR_SITE_CODE="";
String sql ="",status_color="",swhere="";
int exist_cnt=0;
String CHK_RPT_NAME=""; //add by Peggy 20210331

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
			sql = " delete tsc.tsc_shipping_advise_pc_sg a"+
				  " where pc_advise_id=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,ID);
			pstmtDt.executeUpdate();
			pstmtDt.close();
		
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("The data has deleted!");
			</script>	
	<%	
		}
		else
		{
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("Action fail!The transaction has reached the next stage!!");
			</script>	
	<%			
		}
	}
	catch(Exception e)
	{
%>
		<script language="JavaScript" type="text/JavaScript">
			alert("Action Fail!Please contact the system administrator!");
		</script>
<%
	}
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCSGShippingAdviseQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG Shipping Advise</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1' bordercolor="#D3E6F3">
	<tr>
		<td width="8%" bgcolor="#D3E6F3"  style="color:#006666">PC SSD :</td>   
		<td width="18%">
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			&nbsp;~&nbsp;
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td> 
	    <td width="8%" bgcolor="#D3E6F3" style="font-family: Tahoma,Georgia;color:#006666">內外銷:</td> 
		<td width="12%">	
		<%		
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select organization_id,case  organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else organization_code end as organization_code from inv.mtl_parameters a where organization_code IN ('SG1','SG2')";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='ORGCODE' style='font-family:Tahoma,Georgia;font-size:11px'>");
			out.println("<OPTION VALUE=--"+ (ORGCODE.equals("") || ORGCODE.equals("--") ?" selected ":"")+">--");     
			while (rs1.next())
			{            
           		out.println("<OPTION VALUE='"+rs1.getString(1)+"'"+ (ORGCODE.equals(rs1.getString(1))?" selected ":"") +">"+rs1.getString(2));
			} 
			out.println("</select>"); 
			statement1.close();		  		  
			rs1.close();        	 
		} 
    	catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		} 	
		%>		
		<td width="8%" bgcolor="#D3E6F3"  style="color:#006666">TSC Prod Group :</td>   
		<td width="10%">
		<select NAME="TSCPRODGROUP" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE=-- <%if (TSCPRODGROUP.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="PRD-Subcon" <%if (TSCPRODGROUP.equals("PRD-Subcon")) out.println("selected");%>>PRD-Subcon</OPTION>
		<OPTION VALUE="SSD" <%if (TSCPRODGROUP.equals("SSD")) out.println("selected");%>>SSD</OPTION>
		</select>		
		</td>
		<td width="8%" bgcolor="#D3E6F3"  style="font-family: Tahoma,Georgia;color:#006666">Advise No:</td>   
		<td width="10%"><input type="text" name="ADVISE_NO" value="<%=ADVISE_NO%>" style="font-family:Tahoma,Georgia" size="12" onKeyPress="chgObj();"></td>
		<td width="8%" bgcolor="#D3E6F3"  style="font-family: Tahoma,Georgia;color:#006666">Sales Region :</td>   
		<td width="10%">
		<%
			sql = " SELECT distinct REGION_CODE,REGION_CODE REGION_CODE1 FROM tsc.tsc_shipping_advise_pc_sg a  group by REGION_CODE ORDER BY 1";
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
	<tr>
	    <td bgcolor="#D3E6F3" style="font-family: Tahoma,Georgia;color:#006666">Customer Name:</td> 
		<td><input type="text" name="CUSTOMER" value="<%=CUSTOMER%>" style="font-family: Tahoma,Georgia" size="30"></td>
		<td bgcolor="#D3E6F3"  style="color:#006666">Item Desc:</td>   
		<td><input type="text" name="ITEMNAME" value="<%=ITEMNAME%>" style="font-family: Tahoma,Georgia" size="20"></td>
			
		<!--<select NAME="ORGCODE" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="887" <%if (ORGCODE.equals("907")) out.println("selected");%>>SG1</OPTION>
		<!--<OPTION VALUE="49" <%if (ORGCODE.equals("49")) out.println("selected");%>>I1</OPTION>
		</select>-->
		</td>
	    <td bgcolor="#D3E6F3" style="font-family: Tahoma,Georgia;color:#006666">Order Number :</td> 
		<td><input type="text" name="MO" value="<%=MO%>" style="font-family: Tahoma,Georgia" size="12" onKeyPress="chgObj();"></td>
		<td bgcolor="#D3E6F3"  style="font-family: Tahoma,Georgia;color:#006666">檢驗報告名:</td>   
		<td><input type="text" name="CHK_PRT" value="<%=CHK_PRT%>" style="font-family:Tahoma,Georgia" size="12" onKeyPress="chgObj();"></td>
		<td bgcolor="#D3E6F3"  style="font-family: Tahoma,Georgia;color:#006666">Vendor Name :</td>  
		<td>
		<%
			sql = " SELECT distinct B.VENDOR_SITE_ID,B.VENDOR_SITE_CODE FROM tsc.tsc_shipping_advise_pc_sg a,ap_supplier_sites_all b where a.VENDOR_SITE_ID=b.VENDOR_SITE_ID ORDER BY 2";
			statement=con.createStatement();
			rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(VENDOR_SITE_CODE);
			comboBoxBean.setFieldName("VENDOR_SITE_CODE");	
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
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' style="font-size:11px;font-family:Tahoma,Georgia;"  onClick='setSubmit("../jsp/TSCSGShippingAdviseQuery.jsp")' > 
			<% if (UserRoles.indexOf("TEW_QC")<0)
			{
			%>
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value="Shipping Advise"  style="font-size:11px;font-family:Tahoma,Georgia;" onClick='setExportXLS("../jsp/TSCSGShippingAdviseExcel.jsp")' > 
			<%
			}
			%>
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='EXCEL'  style="font-size:11px;font-family:Tahoma,Georgia;" onClick='setExportXLS("../jsp/TSCSGShippingAdviseDetailExcel.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select tsa.PC_ADVISE_ID,"+
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
		  " tsa.ADVISE_NO,"+
          " decode(oolla.item_identifier_type,'CUST',oolla.ordered_item,'') CUST_ITEM,"+
		  " RA.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME,"+
		  " tsa.REGION_CODE,"+
		  " nvl((select count(1) from tsc.tsc_shipping_advise_lines tsal where tsal.pc_advise_id = tsa.pc_advise_id and not exists (select 1 from tsc.tsc_pick_confirm_lines x where x.advise_line_id=tsal.advise_line_id) ),0) box_cnt,"+
		  //" nvl((select count(1) from oraddman.tssg_lot_distribution_detail tpcl,tsc.tsc_shipping_advise_lines tsal where tpcl.advise_line_id = tsal.advise_line_id and tsal.pc_advise_id = tsa.pc_advise_id and NVL(tpcl.confirm_flag,'N') <>'Y'),0) pick_cnt,"+
		  " nvl((select count(1) from tsc.tsc_pick_confirm_headers tpc,tsc.tsc_pick_confirm_lines tpcl,tsc.tsc_shipping_advise_lines tsal where tpc.advise_header_id=tpcl.advise_header_id and tpcl.advise_line_id = tsal.advise_line_id and tsal.pc_advise_id = tsa.pc_advise_id and tpc.pick_confirm_date is  null),0)  pick_cnt,"+
		  " nvl((select count(1) from tsc.tsc_pick_confirm_headers tpc,tsc.tsc_pick_confirm_lines tpcl,tsc.tsc_shipping_advise_lines tsal where tpc.advise_header_id=tpcl.advise_header_id and tpcl.advise_line_id = tsal.advise_line_id and tsal.pc_advise_id = tsa.pc_advise_id and tpc.pick_confirm_date is not null),0) shipped_cnt,"+
		  " mp.organization_code,"+
		  " tsa.PRODUCT_GROUP,"+
		  " tsa.vendor_site_id,"+
		  " ap.vendor_site_code"+
          ",case  mp.organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else mp.organization_code end as organization_name"+
          ",pha.segment1 PONO"+
          ",tspp.PO_UNIT_PRICE"+
		  ",(tspp.order_qty/1000) order_qty"+
		  ",tspp.cust_partno pc_cust_partno"+
		  ",tspp.PC_ADVISE_PRICE_ID"+
		  ",decode(tsa.delivery_type ,'VENDOR','廠商直出','') delivery_type "+//add by Peggy 20200505
		  ",nvl(tspp.pc_advise_price_id,0) pc_advise_price_id"+
		  ",tsa.CHK_RPT_NAME"+ //add by Peggy 20201223
		  ",TSC_GET_OQC_RPT(tsa.SO_LINE_ID,'TEW',null) as QC_RPT_FLAG "+  //add by Peggy 20201223 
		  ",tsa.orig_advise_no"+ //add by Peggy 20210331
		  ",tsa.CHK_PAPER_RPT_NAME"+ //add by Peggy 20210331
		  ",APPS.TSCC_GET_FLOW_CODE(tsa.inventory_item_id) as flow_code \n"+
          " FROM tsc.tsc_shipping_advise_pc_sg tsa,"+
          " ONT.OE_ORDER_LINES_ALL oolla,"+
		  " AR_CUSTOMERS ra,"+
		  " INV.MTL_PARAMETERS mp,"+
		  " ap_supplier_sites_all ap,"+
		  " tsc.tsc_shipping_po_price_sg tspp,"+
          " po.po_headers_all pha"+
          " where tsa.so_line_id = oolla.line_id"+
		  " and tsa.CUSTOMER_ID = ra.CUSTOMER_ID"+
		  " and tsa.organization_id=mp.organization_id"+
		  " and tsa.pc_advise_id = tspp.pc_advise_id(+)"+
          " and tspp.po_header_id = pha.po_header_id(+)"+
		  " and tsa.vendor_site_id=ap.vendor_site_id";
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
	if (!SALESAREA.equals("") && !SALESAREA.equals("--"))
	{
		swhere += " and tsa.REGION_CODE='"+ SALESAREA+"'";
	}
	if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
	{
		sql += " AND tsa.ORGANIZATION_ID='"+ORGCODE+"'";
	}	
	if (!TSCPRODGROUP.equals("--") && !TSCPRODGROUP.equals(""))
	{
		sql += " AND tsa.PRODUCT_GROUP='"+TSCPRODGROUP+"'";
	}	
	if (!CHK_PRT.equals(""))
	{
		sql += " AND exists (select 1 from tsc.tsc_shipping_advise_pc_sg x where NVL(x.orig_chk_rpt_name,x.CHK_RPT_NAME) like '%"+CHK_PRT+"%' and x.advise_no=tsa.advise_no)";
	}
	if (!VENDOR_SITE_CODE.equals("--") && !VENDOR_SITE_CODE.equals(""))
	{
		sql += " AND tsa.vendor_site_id='"+VENDOR_SITE_CODE+"'";
	}
	if (swhere.equals(""))
	{
		String sql2 = " SELECT TO_CHAR(EDATE-6,'yyyymmdd') AS SDATE,to_char(EDATE,'yyyymmdd') EDATE"+
			  " FROM ( select case when to_char(max(tsa.PC_SCHEDULE_SHIP_DATE),'D')=6 THEN max(tsa.PC_SCHEDULE_SHIP_DATE) "+
			  " when to_char(max(tsa.PC_SCHEDULE_SHIP_DATE),'D')=7 THEN max(tsa.PC_SCHEDULE_SHIP_DATE)"+
			  " ELSE next_day(max(tsa.PC_SCHEDULE_SHIP_DATE),7) END AS EDATE"+
			  " FROM tsc.tsc_shipping_advise_pc_sg tsa)";
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
	String color_status1 ="#E25871", color_status2 ="#FFCC33", color_status3 ="#9933FF",color_status4 ="#99CC33",pc_advise_id="",pc_advise_price_id="";
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
		<table width="1400" border="1" cellpadding="1" cellspacing="0" borderColorLight="#FFFFFF"  bordercolordark="#5C7671" bordercolor="#cccccc">
			<tr bgcolor="#84BDC1" style="color:#ffffff"> 
				<td width="20" align="center" nowrap>&nbsp;</td> 
				<td width="40" align="center" nowrap>Delivery Instructions</td> 
				<td width="30" align="center">內外銷</td>
				<td width="70" align="center">Advise NO</td>
				<td width="60" align="center">Sales Region</td>
				<td width="100" align="center">Customer</td>
				<td width="120" align="center">Shipping Marks</td>
				<td width="90" align="center">Order Number</td>
				<td width="30" align="center">Line No</td>
				<td width="60" align="center">Vendor</td>            
				<td width="130" align="center">Item Desc</td>
				<td width="30" align="center">Flow Code</td>
				<td width="20" align="center">Report</td>            
				<td width="60" align="center">TSC Prod Group</td>            
				<td width="50" align="center">PC confirm Qty(K)</td>            
				<td width="60" align="center">PC SSD</td>            
				<td width="20" align="center">To TW</td>            
				<td width="140" align="center">Customer PO</td>            
				<td width="70" align="center">Shipping Method</td>  
				<td width="90" align="center">PO NO</td>
				<td width="90" align="center">PO Cust Partno</td>
				<td width="30" align="center">QTY(K)</td>
				          
			</tr>
		<% 
		}
    	%>
		<tr  id="tr_<%=iCnt%>">
			<%
			if (!rs.getString("pc_advise_id").equals(pc_advise_id) || !rs.getString("pc_advise_price_id").equals(pc_advise_price_id))
			{
				if (rs.getString("ADVISE_NO")==null)
				{
					status_color="background-color:"+color_status1+"";
				}
				else if (rs.getInt("BOX_CNT")>0)
				{
					status_color="background-color:"+color_status2+"";
				}
				else if (rs.getInt("PICK_CNT")>0)
				{
					status_color="background-color:"+color_status3+"";
				}
				else if (rs.getInt("shipped_CNT")>0)
				{
					status_color="background-color:"+color_status4+"";
				}
				else
				{
					status_color="";
				}
				pc_advise_id=rs.getString("pc_advise_id");
				pc_advise_price_id=rs.getString("pc_advise_price_id");
			%>
			<td align="center" style="background-color:#84BDC1">
			<% if (UserRoles.indexOf("TEW_QC")<0)
			{
			%>			
			<%=(status_color.equals("")?"<input type='button' name='DEL_"+rs.getString("pc_advise_id")+"' value='Cancel' style='font-family:Tahoma,Georgia;font-size:11px;' onClick='setSubmit1("+'"'+"../jsp/TSCSGShippingAdviseQuery.jsp?TRANSTYPE=CANCEL&ID="+rs.getString("pc_advise_id")+'"'+")'>":"&nbsp;")%>
			<%
			}
			%>
			</td>
			<td align="center"><%=(rs.getString("delivery_type")==null?"&nbsp;":rs.getString("delivery_type"))%></td>
			<td align="left" style="font-size:10px;"><%=rs.getString("ORGANIZATION_NAME")%></td>
			<td align="center" style="font-size:10px;<%=status_color%>"><%=(rs.getString("ADVISE_NO")==null?"&nbsp;":rs.getString("ADVISE_NO"))%></td>
			<td align="left"><%=rs.getString("REGION_CODE")%></td>
			<td align="left"><%=rs.getString("CUSTOMER_NAME")%></td>
			<td align="left"><%=(rs.getString("shipping_remark")==null?"&nbsp;":rs.getString("shipping_remark"))%></td>
			<td><%=rs.getString("SO_NO")%></td>
			<td><%=rs.getString("SO_LINE_NUMBER")%></td>
			<td><%=rs.getString("VENDOR_SITE_CODE")%></td>
			<td><%=rs.getString("ITEM_DESC")%></td>
			<td><%=StringUtils.isNullOrEmpty(rs.getString("FLOW_CODE")) ? "" : rs.getString("FLOW_CODE")%></td>
			<%
			CHK_RPT_NAME="";
			if (rs.getString("shipping_remark")!=null)
			{
				if ((rs.getString("shipping_remark").indexOf("元超")>=0 && !rs.getString("SO_NO").startsWith("1121")) || (!rs.getString("to_tw").equals("Y") && (rs.getString("QC_RPT_FLAG").equals("Y") || rs.getString("QC_RPT_FLAG").indexOf("PDF")>=0 || rs.getString("shipping_remark").toUpperCase().indexOf("CHANNEL WELL") >=0 || rs.getString("ITEM_DESC").indexOf("FR107G-K-02")>=0)))  //add FR107G-K-02 by Peggy 20220318
				{
					if (rs.getString("QC_RPT_FLAG").indexOf("PDF")>=0)
					{
						CHK_RPT_NAME=rs.getString("CHK_RPT_NAME");
					}
					else
					{
						//CHK_RPT_NAME=rs.getString("CHK_PAPER_RPT_NAME"); //紙製檢驗報告,add by Peggy 20210331
						CHK_RPT_NAME=rs.getString("PC_ADVISE_ID"); //紙製檢驗報告,add by Peggy 20210331
					}
				%>
					<td <%=(rs.getString("QC_RPT_FLAG").indexOf("PDF")<0?" style='background-color:#66FF66'":"")%>><a href="../jsp/TSCSGShippingInspectionReport.jsp?CHK_RPT_NAME=<%=CHK_RPT_NAME%>"><img name="popcal" border="0" src="../image/excel_16.gif"></a></td>
				<%
				}
				else
				{
					out.println("<td>&nbsp;</td>");
				}
			}
			else
			{
				out.println("<td>&nbsp;</td>");
			}
			%>
			<td style="font-size:10px"><%=rs.getString("PRODUCT_GROUP")%></td>
			<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("SHIP_QTY")))%></td>
			<td align="center"><%=rs.getString("PC_SCHEDULE_SHIP_DATE")%></td>
			<td align="center"><%=rs.getString("to_tw")%></td>
			<td align="left" style="font-size:10px"><%=rs.getString("CUST_PO_NUMBER")%></td>
			<td align="left"><%=rs.getString("SHIPPING_METHOD")%></td>
			<%
			}
			%>
			<td align="center"><font style="font-size:11px"><%=(rs.getString("PONO")==null?"&nbsp;":rs.getString("PONO"))%></font></td>
			<td align="left"><font style="font-size:11px"><%=(rs.getString("pc_cust_partno")==null?"&nbsp;":rs.getString("pc_cust_partno"))%></font>
			<% if (UserRoles.indexOf("TEW_QC")<0 && UserRoles.indexOf("SG_Financial_M")<0)
			{
			%>			
			<img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setUpdate('../jsp/TSCSGShippingAdviseRevise.jsp?AID=<%=rs.getString("PC_ADVISE_PRICE_ID")%>')"></td>
			<%
			}
			%>
			<td align="right"><font style="font-size:11px"><%=(rs.getString("order_qty")==null?"&nbsp;":rs.getString("order_qty"))%></font></td>
		</tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='Tahoma,Georgia'><strong>No data found!</strong></font></div>");
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

