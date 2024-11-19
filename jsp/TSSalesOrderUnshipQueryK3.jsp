<!--20170503 by Peggy,日期條件從ordered_date改為booked_date-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>TSCC Order Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%> 
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	if (document.MYFORM.RPTTYPE.value==null || document.MYFORM.RPTTYPE.value=="--" || document.MYFORM.RPTTYPE.value=="")
	{
		alert("請選擇報表類別!");
		document.MYFORM.RPTTYPE.setFocus();
		return false;
	}
	if (document.MYFORM.SDATE.value==null || document.MYFORM.SDATE.value=="")
	{
		alert("請輸入起始日期!");
		document.MYFORM.SDATE.setFocus();
		return false;
	}
	if (document.MYFORM.EDATE.value!=null &&  document.MYFORM.EDATE.value!="")	
	{
		if (eval(document.MYFORM.EDATE.value)<eval(document.MYFORM.SDATE.value))
		{	
			alert("結束日期異常,請重新確認!");
			document.MYFORM.EDATE.setFocus();
			return false;		
		}
	}
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setExcel(URL)
{
	if (document.MYFORM.RPTTYPE.value==null || document.MYFORM.RPTTYPE.value=="--" || document.MYFORM.RPTTYPE.value=="")
	{
		alert("請選擇報表類別!");
		document.MYFORM.RPTTYPE.setFocus();
		return false;
	}
	if (document.MYFORM.SDATE.value==null || document.MYFORM.SDATE.value=="")
	{
		alert("請輸入起始日期!");
		document.MYFORM.SDATE.setFocus();
		return false;
	}
	if (document.MYFORM.EDATE.value!=null &&  document.MYFORM.EDATE.value!="")	
	{
		if (eval(document.MYFORM.EDATE.value)<eval(document.MYFORM.SDATE.value))
		{	
			alert("結束日期異常,請重新確認!");
			document.MYFORM.EDATE.setFocus();
			return false;		
		}
	}
	if (document.MYFORM.RPTTYPE.value=="ORDER")
	{
		document.MYFORM.action=URL.replace("?01","TSSalesOrderUnshipExcelK3.jsp");
	}
	else if (document.MYFORM.RPTTYPE.value=="SHIP")
	{
		document.MYFORM.action=URL.replace("?01","TSSalesOrdershippedExcelK3.jsp");
	}
	else
	{
		document.MYFORM.action=URL.replace("?01","TSSalesOrderReviseExcelK3.jsp");
	}
 	document.MYFORM.submit();
}
</script>
<%
String sql = "";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String RPTYPE = request.getParameter("RPTYPE");
if (RPTYPE==null) RPTYPE="";
String QPage = request.getParameter("QPage");
if (QPage ==null) QPage="1";
String QTYPE=request.getParameter("QTYPE");
if (QTYPE==null) QTYPE="";
String RPTTYPE="";

float PageSize=100;
float LastPage=0;
float NowPage = Float.parseFloat(QPage);
String strBackColor="";
int rowcnt=0;
String ERP_USERID="";

sql = "SELECT erp_user_id from oraddman.wsuser a where USERNAME ='"+UserName+"'";
Statement st3=con.createStatement();
ResultSet rs3=st3.executeQuery(sql);
if (rs3.next())
{
	ERP_USERID=rs3.getString(1);
}
rs3.close();
st3.close();

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
%>
<body> 
<FORM ACTION="../jsp/TSSalesOrderUnshipQueryK3.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">TSCC Order Detail Query</div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE width="100%" border='1' bordercolorlight='#426193' bordercolordark='#ffffff' cellPadding='1' cellspacing='0' bgcolor="#E2EBBE">
	<tr>
		<td width="10%"align="right">Report Type ：</td>
		<td width="10%">
		<select NAME="RPTTYPE" style="font-family: Tahoma,Georgia; font-size:11px">
		<OPTION VALUE="ORDER" <%if (RPTTYPE.equals("ORDER")) out.println("selected");%>>訂單未交明細</OPTION>
		<OPTION VALUE="SHIP" <%if (RPTTYPE.equals("SHIP")) out.println("selected");%>>出入庫明細</OPTION>
		<OPTION VALUE="REVISE" <%if (RPTTYPE.equals("REVISE")) out.println("selected");%>>訂單異動明細</OPTION>
		</select>
		</td>	
		<td width="10%"align="right">Date：</td>
		<td width="16%"><input type="TEXT" NAME="SDATE" value="<%=SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">
          <A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
          <input type="TEXT" NAME="EDATE" value="<%=EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">
          <A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A></td>
		<td  align="center"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSSalesOrderUnshipQueryK3.jsp?QTYPE=1')">&nbsp;&nbsp;
		<input type="button" name="btnExport" value="Export to Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/?01?UserName=<%=UserName%>&UserRoles=<%=UserRoles%>')"></td>
	</tr>
</TABLE>
<hr>
<%
try
{
	if (QTYPE.equals(""))
	{
		%><DIV align="center" style="color:#0000ff;font-size:12px">Please input query condition,and press Query button to search data</DIV><%
	}
	else
	{
		sql = " select  count(1) over(order by ooh.header_id desc,ool.line_id desc ) cnt ,"+
			  //" upper(Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id)) sales_group,"+  
			  " upper(TSC_OM_Get_Sales_Group(ooh.header_id)) sales_group,"+   //modify by Peggy 20220531 
			  " ooh.ORDER_NUMBER,"+
			  " ool.line_number ||'.'||ool.shipment_number line_no,"+
			  " msi.description,"+
			  " DECODE(ool.ITEM_IDENTIFIER_TYPE,'CUST',ool.ORDERED_ITEM,'') CUST_ITEM,"+
			  " nvl(ar.CUSTOMER_NAME_PHONETIC,ar.customer_name) customer,"+
			  " ool.CUSTOMER_LINE_NUMBER customer_po,"+
			  " ool.ordered_quantity,"+
			  " to_char(trunc(ool.schedule_ship_date),'yyyy/mm/dd') schedule_ship_date,"+
			  " to_char(trunc(ool.REQUEST_DATE),'yyyy/mm/dd') request_date,"+
			  " to_char(trunc(ooh.ORDERED_DATE),'yyyy/mm/dd') ordered_date,"+
			  " ool.SHIPPING_METHOD_CODE,"+
			  " lc.meaning SHIP_METHOD,"+
			  " ooh.TRANSACTIONAL_CURR_CODE,  "+ 
			  " ool.PACKING_INSTRUCTIONS,"+
			  " TERM.NAME,"+
			  " NVL(ool.FOB_POINT_CODE,ooh.FOB_POINT_CODE) fob_point,"+
			  " Replace(Replace(TSC_GET_REMARK(ooh.HEADER_ID,'REMARKS'),chr(10), chr(32)),chr(13),chr(32))  REMARKS, "+
			  " Replace(Replace(TSC_GET_REMARK(ooh.HEADER_ID,'SHIPPING MARKS'),chr(10), chr(32)),chr(13),chr(32))  SHIPMARKS,"+
			  " ool.ATTRIBUTE7   PCMARK,  "+  
			  " ool.flow_status_code, "+
			  " ool.CUSTOMER_SHIPMENT_NUMBER CUSTOMER_PO_LINE_NUM,"+
			  " TSC_GET_REMARK_DESC(ooh.HEADER_ID,'SHIPPING MARKS') mark_desc,"+
			  " ool.end_customer_id,"+
			  " NVL (ar1.customer_name_phonetic, ar1.customer_name) end_customer,"+
			  " tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_PROD_GROUP') as TSC_PROD_GROUP,"+
			  " tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_Family') as TSC_FAMILY,"+
			  " tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_PROD_FAMILY') as TSC_PROD_FAMILY,"+
			  " tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_Package') as TSC_Package,"+
			  " tog.description yew_group,"+
			  " substr(ott.NAME,instr(ott.NAME,'_')+1,length(ott.name)) as line_type,"+
			  " addr.address1, "+
			  " (SELECT CASE WHEN substr(ooh.order_number,2,3) ='121' then SAMPLE_SPQ ELSE SPQ end as SPQ FROM TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',CASE when ool.PACKING_INSTRUCTIONS = 'Y' or substr(ooh.order_number,1,4)='1156' then '002' when ool.PACKING_INSTRUCTIONS = 'E' or substr(ooh.order_number,1,4)='1142' THEN '008' when ool.PACKING_INSTRUCTIONS = 'A'  THEN '010' WHEN tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_PROD_GROUP')='PMD' THEN '006'  WHEN tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_PROD_GROUP') IN ('SSP','SSD') THEN '005' ELSE '002' END  ))) AS SPQ,"+
			  " (SELECT MOQ  FROM TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',CASE when ool.PACKING_INSTRUCTIONS = 'Y' or substr(ooh.order_number,1,4)='1156' then '002' when ool.PACKING_INSTRUCTIONS = 'E' or substr(ooh.order_number,1,4)='1142' THEN '008' when ool.PACKING_INSTRUCTIONS = 'A'  THEN '010' WHEN tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_PROD_GROUP')='PMD' THEN '006'  WHEN tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_PROD_GROUP') IN ('SSP','SSD') THEN '005' ELSE '002' END  ))) AS MOQ"+
			  ",ool.ship_to_org_id"+
			  ",end_ar.customer_number end_customer_number"+
			  ",to_char(trunc(ool.schedule_ship_date-tsc_get_china_to_tw_days(ool.PACKING_INSTRUCTIONS ,ooh.oRDER_NUMBER,ool.inventory_item_id,null,ooh.sold_to_org_id,to_char(ooh.creation_date,'yyyymmdd'),NVL(ool.CUSTOMER_LINE_NUMBER,ool.CUST_PO_NUMBER))),'yyyy/mm/dd') factory_totw_date "+  //add by Peggy 20160805
			  ",(select distinct LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) "+
			  " from ar_contacts_v con WHERE con.contact_id=ooh.attribute11  and con.status='A') ship_to_contact"+
			  ",ool.UNIT_SELLING_PRICE"+ 
			  ",opa.OPERAND LINE_CHARGE"+ 
			  ",tkcr.tax_rate*100||'%' tax_rate"+
			  ",tkcr.currency_code"+
			  ",tks.supplier_code"+
			  ",tkc.cust_code"+
			  ",tkc.dept_code"+
			  ",tkc.sales_code"+
			  ",ool.UNIT_SELLING_PRICE*ool.ordered_quantity amount"+
			  ",ool.UNIT_SELLING_PRICE*ool.ordered_quantity*tkcr.tax_rate tax_amount"+
			  " from oe_order_headers_all ooh "+
			  "     ,oe_order_lines_all ool"+
			  "     ,JTF_RS_SALESREPS jrs "+
			  "     ,MTL_SYSTEM_ITEMS_B msi"+
			  "     ,AR_CUSTOMERS ar,"+
			  "     ra_terms_tl term ,"+
			  "     (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') lc,"+
			  "     ar_customers ar1,"+
			  "     (select * from AR.HZ_CUST_SITE_USES_ALL where site_use_code = 'SHIP_TO') hcsu,"+
			  "     (select * from tsc_om_group where org_id=325) tog,"+
			  "     (SELECT * FROM OE_TRANSACTION_TYPES_TL WHERE LANGUAGE ='US') ott,"+
			  "     (select hcsu.site_use_id,hl.address1  from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
			  "      where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
			  "      and hcas.party_site_id = hps.party_site_id  "+
			  "      and hps.location_id =hl.location_id "+
			  "      and hcsu.site_use_code = 'SHIP_TO'"+
			  "       and hcsu.status = 'A') addr"+
			  "     ,(SELECT A.LINE_ID,A.OPERAND  FROM ont.oe_price_adjustments a  where LIST_LINE_TYPE_CODE='FREIGHT_CHARGE') opa"+
			  "     ,oraddman.tscc_k3_cust_link_erp tkce"+
			  "     ,oraddman.tscc_k3_cust tkc"+
			  "     ,oraddman.tscc_k3_supplier tks"+
			  "     ,oraddman.tscc_k3_curr tkcr"+
			  "     ,ar_customers end_ar"+
			  " WHERE ooh.HEADER_ID = ool.HEADER_ID(+)"+
			  " AND ooh.sold_to_org_id in (14980,15540)"+ //只抓SHANGHAI GREAT & 上海瀚科
			  " AND ooh.SALESREP_ID = jrs.SALESREP_ID(+)"+
			  " AND ool.INVENTORY_ITEM_ID = msi.INVENTORY_ITEM_ID"+
			  " AND msi.ORGANIZATION_ID = 43"+
			  " AND ooh.SOLD_TO_ORG_ID = ar.CUSTOMER_ID"+
			  " AND ool.CANCELLED_FLAG != 'Y'"+
			  " AND nvl(ool.ORDERED_QUANTITY,0) - nvl(ool.SHIPPED_QUANTITY,0)>0"+
			  " AND ool.FLOW_STATUS_CODE IN ('BOOKED','AWAITING_SHIPPING','AWAITING_APPROVE')"+
			  " AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017') "+
			  " and ool.INVENTORY_ITEM_ID not in  (29570,29562,29560)"+
			  " and  term.language='US' "+
			  " AND nvl(ool.payment_term_id,ooh.payment_term_id) =term.term_id "+
			  " and ooh.ORG_ID=jrs.ORG_ID(+)"+
			  " AND ool.SHIPPING_METHOD_CODE = lc.lookup_code (+)"+
			  " AND ool.end_customer_id = ar1.customer_id(+)"+
			  " AND ool.ship_to_org_id = hcsu.site_use_id(+)"+
			  " AND hcsu.attribute1=tog.group_id(+)"+
			  " AND ool.line_type_id= ott.transaction_type_id(+)"+
			  " AND ool.ship_to_org_id=addr.site_use_id(+)"+
			  " AND SUBSTR(ooh.ORDER_NUMBER,2,2) <>'19'"+			  
			  " AND ool.end_customer_id=end_ar.customer_id(+)"+
			  " AND ool.LINE_ID=opa.LINE_ID(+)"+
			  " AND ooh.org_id = case  WHEN SUBSTR( OOH.ORDER_NUMBER,1,1) =1  then 41 else ooh.org_id end"+
			  //" AND Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id) like 'TSCC%'"+
			  " AND TSC_OM_Get_Sales_Group(ooh.header_id) like 'TSCC%'"+  //modify by Peggy 20220531
			  " AND ool.end_customer_id=end_ar.customer_id(+)"+
			  " AND end_ar.customer_number=tkce.erp_cust_number(+)"+
			  " AND tkce.cust_code=tkc.cust_code(+)"+
			  " AND substr(ooh.order_number,1,1) =tks.erp_order_code(+)"+
			  " AND substr(ooh.order_number,1,1) =tkcr.erp_order_code(+)";
		if (UserRoles.indexOf("admin")<0)
		{
			sql += " and exists (select 1 from (SELECT tog.group_name "+
					 " FROM tsc_om_group_salesrep togs,"+
					 " ahr_employees_all aea,"+
					 " jtf_rs_salesreps jrs,"+
					 " fnd_user us,"+
					 " tsc_om_group tog,"+
					 " oraddman.wsuser ow"+
					 " WHERE  (aea.employee_no = jrs.salesrep_number or us.user_name =jrs.salesrep_number)"+ //for forecase demain issue by Peggy 20230407"
					 " AND us.employee_id = aea.person_id"+
					 " AND togs.salesrep_id = jrs.salesrep_id"+
					 " AND togs.GROUP_ID = tog.GROUP_ID"+
					 " AND (tog.end_date IS NULL OR tog.end_date > TRUNC (SYSDATE))"+
					 " AND us.user_id=ow.ERP_USER_ID"+
					 " AND ow.username='"+UserName+"'"+
					 " UNION ALL"+
					 " SELECT tog.group_name"+
					 " FROM tsc_om_group_salesrep togs,"+
					 " fnd_user us, "+
					 " tsc_om_group tog,"+
					 " oraddman.wsuser ow"+
					 " WHERE  togs.user_id = us.user_id"+
					 " AND togs.GROUP_ID = tog.GROUP_ID"+
					 " AND (tog.end_date IS NULL OR tog.end_date > TRUNC (SYSDATE))"+
					 " AND us.user_id=ow.ERP_USER_ID"+
					 " AND ow.username='"+UserName+"'"+
					 " UNION ALL"+
					 " SELECT 'SAMPLE' group_name "+
					 " FROM oraddman.tssales_area A,oraddman.tsrecperson B,oraddman.wsuser C"+
					 " WHERE A.sales_area_no='020'"+
					 " AND A.sales_area_no=B.tssaleareano "+
					 " AND B.username=C.username "+
					 " AND NVL(C.lockflag,'Y')='N'"+
					 //" AND c.username='"+UserName+"') x where x.group_name=Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id))";	
					 " AND c.username='"+UserName+"') x where x.group_name=TSC_OM_Get_Sales_Group(ooh.header_id))";	  //modify by Peggy 20220531
		}
		//sql += " and ooh.ORDERED_DATE  BETWEEN TO_DATE('"+(SDATE.equals("")?"trunc(add_months(sysdate,-48))":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?"trunc(add_months(sysdate,24))":EDATE)+"','yyyymmdd')+0.99999"+
		sql += " and ooh.BOOKED_DATE  BETWEEN TO_DATE('"+(SDATE.equals("")?"trunc(add_months(sysdate,-48))":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?"trunc(add_months(sysdate,24))":EDATE)+"','yyyymmdd')+0.99999"+
		       " order by 1 desc,2,3,4";
		//out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);
		while (rs.next()) 
		{ 	
			rowcnt++;
			if (rowcnt==1)
			{
				//最後頁數
				LastPage = (int)(Math.ceil(rs.getLong(1) / PageSize));		
			%>
	<table width="100%" border="0">
		<tr>
			<td style="font-family:Tahoma,Georgia;font-size:12px">Data total count:<%=rs.getString(1)%>，Count Range：<%=(int)((NowPage-1)*PageSize+1)%> ~ <%=((int)(NowPage*PageSize)>rs.getInt(1)?rs.getLong(1):(int)(NowPage*PageSize))%></font>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type=button name="FPage" id="FPage" value="<<" onClick="setQuery('../jsp/TSSalesOrderUnshipQueryK3.jsp?QPage=1')" <%if((int)NowPage==1){ out.println("disabled");}%> title="First Page">
				&nbsp;
				<input type=button name="PPage" id="PPage" value="<" onClick="setQuery('../jsp/TSSalesOrderUnshipQueryK3.jsp?QPage=<%=((int)NowPage-1)%>')"  <%if(NowPage==1){ out.println("disabled");}%> title="Previous Page">
				&nbsp;&nbsp;Page：<%=(int)NowPage%>&nbsp;&nbsp;
				<input type=button name="NPage" id="NPage" value=">" onClick="setQuery('../jsp/TSSalesOrderUnshipQueryK3.jsp?QPage=<%=((int)NowPage+1)%>')"  <%if(NowPage==LastPage){ out.println("disabled");}%> title="Next Page">
				&nbsp;
				<input type=button name="LPage" id="LPage" value=">>" onClick="setQuery('../jsp/TSSalesOrderUnshipQueryK3.jsp?QPage=<%=(int)LastPage%>')" <%if(NowPage==LastPage){ out.println("disabled");}%> title="Last Page">
			</td>
		</tr>
	</table>		
	<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
		<tr style="background-color:#E9F8F2;color:#000000">
			<td width="3%" align="center">Seq No</td>
			<td width="6%" align="center">Sales Area</td>
			<td width="9%" align="center">Customer </td>	
			<td width="7%" align="center">MO#</td>
			<td width="3%'" align="center">Line#</td>	
			<td width="9%'" align="center">Customer PO</td>	
			<td width="9%" align="center">Item Desc</td>	
			<td width="9%" align="center">Cust Item</td>	
			<td width="5%" align="center">Order Qty</td>	
			<td width="6%" align="center">Schedule Ship Date</td>	
			<td width="6%" align="center">CRD</td>	
			<td width="6%" align="center">Shipping Method</td>	
			<td width="5%" align="center">Packing Instrucations</td>	
			<td width="6%" align="center">Payment Term</td>	
			<td width="6%" align="center">Fob Term</td>	
			<td width="6%" align="center">Order Status</td>	
		</tr>
			<%
			}
			if (rowcnt < (int)((NowPage-1)*PageSize+1)) continue;
			if (rowcnt > (int)(NowPage*PageSize)) break;
			
			%>
		<tr id="tr<%=rowcnt%>">
			<td><%=rowcnt%></td>
			<td><%=(rs.getString("SALES_GROUP")==null?"&nbsp;":rs.getString("SALES_GROUP"))%></td>
			<td><%=(rs.getString("CUSTOMER")==null?"&nbsp;":rs.getString("CUSTOMER"))%></td>
			<td><%=(rs.getString("ORDER_NUMBER")==null?"&nbsp;":rs.getString("ORDER_NUMBER"))%></td>
			<td><%=(rs.getString("LINE_NO")==null?"&nbsp;":rs.getString("LINE_NO"))%></td>
			<td><%=(rs.getString("CUSTOMER_PO")==null?"&nbsp;":rs.getString("CUSTOMER_PO"))%></td>
			<td><%=(rs.getString("DESCRIPTION")==null?"&nbsp;":rs.getString("DESCRIPTION"))%></td>
			<td><%=(rs.getString("CUST_ITEM")==null?"&nbsp;":rs.getString("CUST_ITEM"))%></td>
			<td align="right"><%=(rs.getString("ordered_quantity")==null?"&nbsp;":rs.getString("ordered_quantity"))%></td>
			<td align="center"><%=(rs.getString("schedule_ship_date")==null?"&nbsp;":rs.getString("schedule_ship_date"))%></td>
			<td align="center"><%=(rs.getString("request_date")==null?"&nbsp;":rs.getString("request_date"))%></td>
			<td><%=(rs.getString("SHIP_METHOD")==null?"&nbsp;":rs.getString("SHIP_METHOD"))%></td>
			<td><%=(rs.getString("PACKING_INSTRUCTIONS")==null?"&nbsp;":rs.getString("PACKING_INSTRUCTIONS"))%></td>
			<td><%=(rs.getString("NAME")==null?"&nbsp;":rs.getString("NAME"))%></td>
			<td><%=(rs.getString("fob_point")==null?"&nbsp;":rs.getString("fob_point"))%></td>
			<td><%=(rs.getString("flow_status_code")==null?"&nbsp;":rs.getString("flow_status_code"))%></td>
		</tr>
			<%
		}
		rs.close();
		statement.close();
	
		if (rowcnt <=0) 
		{
			out.println("<div style='color:#ff0000;font-size:13px' align='center'>No Data Found!!</div>");
		}
		else
		{
		%>
	  </table>
		<%
		}
	}
}
catch(Exception e)
{
	out.println("<div align='center'><font color='red'>Exception:"+e.getMessage()+"</font></div>");
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

