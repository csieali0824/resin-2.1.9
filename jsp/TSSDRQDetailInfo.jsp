<!--20140820 by Peggy ,新增shiping method & ERP END CUSTOMER ID欄位-->
<!--20150519 by Peggy,add column "tsch orderl line id" for tsch case-->
<!--20150625 by Peggy,qp_secu_list_headers_v change to qp_list_headers_v -->
<!--20190225 Peggy,add End customer part name-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<html>
<head>
<title>RFQ Detail</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=================================-->
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 11px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   {background-color:#D1EAF1;font-size: 11px}
  .style2   {font-family:Tahoma,Georgia;border:none;font-size: 11px}
  .style3   {font-family:Tahoma,Georgia;color:#0000CC;font-size:12px;border:none;font-weight:bold}
  .style4   {font-family:Tahoma,Georgia;border-left:none;border-right:none;border-top:none;color:#000000;border-color:#CCCCCC;font-size: 11px}
  .style5   {font-family:Tahoma,Georgia;font-size: 11px}
</STYLE>
<%
	String DNDOCNO = request.getParameter("DNDOCNO");
	if (DNDOCNO==null) DNDOCNO="";
	String STATUSID = request.getParameter("STATUSID");
	if (STATUSID==null) STATUSID="";
	String STATUS = request.getParameter("STATUS");
	if (STATUS==null) STATUS="";
	String SALESAREANO= request.getParameter("SALESAREANO");
	if (SALESAREANO==null) SALESAREANO="";
	String SALESAREA= request.getParameter("SALESAREA");
	if (SALESAREA==null) SALESAREA="";
	String CUSTPO = request.getParameter("CUSTPO");
	if (CUSTPO==null) CUSTPO="";
	String CURRENCY = request.getParameter("CURRENCY");
	if (CURRENCY==null) CURRENCY="";
	String TAXCODE = request.getParameter("TAXCODE");
	if (TAXCODE==null) TAXCODE="";
	String CUSTNAME= request.getParameter("CUSTNAME");
	if (CUSTNAME==null) CUSTNAME="";
	String SALES = request.getParameter("SALES");
	if (SALES==null) SALES="";
	String PAYTERMID = request.getParameter("PAYTERMID");
	if (PAYTERMID==null) PAYTERMID="";
	String PAYMENTTERM = request.getParameter("PAYMENTTERM");
	if (PAYMENTTERM==null) PAYMENTTERM="";
	String SHIPTOID = request.getParameter("SHIPTOID");
	if (SHIPTOID==null) SHIPTOID="";
	String SHIPTO = request.getParameter("SHIPTO");
	if (SHIPTO==null) SHIPTO="";
	String FOB = request.getParameter("FOB");
	if (FOB==null) FOB="";
	String SHIPTOCONTACTID = request.getParameter("SHIPTOCONTACTID");
	if (SHIPTOCONTACTID==null) SHIPTOCONTACTID="";
	String SHIPTOCONTACT = request.getParameter("SHIPTOCONTACT");
	if (SHIPTOCONTACT==null) SHIPTOCONTACT="";
	String BILLTOID=request.getParameter("BILLTOID");
	if (BILLTOID==null) BILLTOID="";
	String BILLTO=request.getParameter("BILLTO");
	if (BILLTO==null) BILLTO="";
	String RFQTYPE = request.getParameter("RFQTYPE");
	if (RFQTYPE==null) RFQTYPE="";
	String PRICELIST = request.getParameter("PRICELIST");
	if (PRICELIST==null) PRICELIST="";
	String DELIVERYTOID = request.getParameter("DELIVERYTOID");
	if (DELIVERYTOID==null) DELIVERYTOID="";
	String DELIVERYTO = request.getParameter("DELIVERYTO");
	if (DELIVERYTO==null) DELIVERYTO="";
	String REMARK = request.getParameter("REMARK");
	if (REMARK==null) REMARK="";
	String ERPCUSTOMERID = request.getParameter("ERPCUSTOMERID");
	if (ERPCUSTOMERID ==null) ERPCUSTOMERID="";
	String CUSTMARKETGROUP=request.getParameter("CUSTMARKETGROUP");
	if (CUSTMARKETGROUP ==null) CUSTMARKETGROUP = ""; 
	String BY_CODE=request.getParameter("BY_CODE");
	if (BY_CODE==null) BY_CODE="";
	String DP_CODE=request.getParameter("DP_CODE");
	if (DP_CODE==null) DP_CODE="";
	String SUPPPLIER_NUMBER=request.getParameter("SUPPPLIER_NUMBER");  //add by Peggy 20220429
	if (SUPPPLIER_NUMBER==null) SUPPPLIER_NUMBER="";
	String SYSTEMDATE = dateBeans.getYearMonthDay();
	dateBeans.setAdjDate(7);
    String maxDate = dateBeans.getYearMonthDay();
	dateBeans.setAdjDate(-7);
	String sql = "",CREATION_DATE="",CREATED_BY="",RFQTYPE_NAME="";
	int iMaxLine = 0;
	try
	{
		iMaxLine = Integer.parseInt(request.getParameter("MAXLINE"));
	}
	catch(Exception e)
	{
		iMaxLine = 0;
	}
	
	
	boolean bNotFound = false;
	
	try
	{
		sql = " select a.STATUS,a.STATUSID,TSAREANO,a.TSCUSTOMERID,a.CUST_PO,a.CURR,a.TAX_CODE,a.SALESPERSON,a.PAYTERM_ID,a.BILL_TO_ORG"+
			  ",a.SHIP_TO_ORG,a.FOB_POINT,a.SHIP_TO_CONTACT_ID,a.SOLD_TO_ORG,a.RFQ_TYPE,a.PRICE_LIST,a.DELIVERY_TO_ORG,a.REMARK"+
			  ",to_char(to_date(a.CREATION_DATE,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd hh24:mi') CREATION_DATE"+
			  ",(select USERNAME from oraddman.WSUSER k where k.LOCKFLAG='N' and k.WEBID = a.CREATED_BY and rownum=1) CREATED_BY"+
			  ",'('||b.SALES_AREA_NO||')'||b.SALES_AREA_NAME as SALESAREA,'('||c.customer_number||')'||a.CUSTOMER as CUSTNAME"+
			  ",d.LIST_CODE,e.NAME PAYMENTTERM,f.LAST_NAME || DECODE(f.FIRST_NAME, NULL,NULL, ', '||f.FIRST_NAME)|| DECODE(f.TITLE,NULL, NULL, ' '||f.TITLE) ship_to_contact_name"+
			  ",c.ATTRIBUTE2 market_group,g.BY_CODE,g.DP_CODE"+
			  ",(select x.A_VALUE from oraddman.tsc_rfq_setup x where x.A_CODE='RFQ_TYPE' and x.A_SEQ=a.RFQ_TYPE) RFQ_TYPE_NAME"+ //add by Peggy 20220411
			  ",(select supplier_number from oraddman.tsdelivery_notice_detail x where x.dndocno=a.dndocno and rownum=1) SUPPPLIER_NUMBER"+ //add by Peggy 20220429
			  " from oraddman.tsdelivery_notice a"+
			  ",oraddman.tssales_area b"+
			  ",ar_customers c"+
			  ",(select LIST_HEADER_ID, LIST_HEADER_ID||'('||NAME||')' as LIST_CODE "+
			  //" from qp_secu_list_headers_v "+
	          " from qp_list_headers_v "+ //因價格表改為 User 權限 , 取消所有 OU 權限,故改用qp_list_headers_v by Peggy 20150625
			  " where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0'  AND (ORIG_ORG_ID =41 or ORIG_ORG_ID IS NULL )) d"+
			  ",(select a.TERM_ID, a.NAME, a.DESCRIPTION  from RA_TERMS_VL a where a.IN_USE ='Y' ) e"+
			  ", ar_contacts_v f"+
			  ",(select distinct ERP_CUSTOMER_ID,CUSTOMER_PO,BY_CODE,DP_CODE from tsc_edi_orders_header g where DATA_FLAG='Y') g"+
			  " where a.DNDOCNO =? "+
			  " and a.TSAREANO=b.SALES_AREA_NO "+
			  " and a.TSCUSTOMERID=c.customer_id"+
			  " and a.PRICE_LIST = d.LIST_HEADER_ID(+)"+
			  " and a.PAYTERM_ID = e.TERM_ID(+)"+
			  " and a.SHIP_TO_CONTACT_ID = f.contact_id(+)"+
			  " and a.TSCUSTOMERID = g.ERP_CUSTOMER_ID(+)"+
			  " and a.CUST_PO = g.CUSTOMER_PO(+)";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,DNDOCNO);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			ERPCUSTOMERID = rs.getString("TSCUSTOMERID");
			STATUS = rs.getString("STATUS");
			STATUSID = rs.getString("STATUSID");
			SALESAREANO = rs.getString("TSAREANO");
			SALESAREA = rs.getString("SALESAREA");
			CUSTPO = rs.getString("CUST_PO");
			CURRENCY = rs.getString("CURR");
			TAXCODE = rs.getString("TAX_CODE");
			if (TAXCODE==null || TAXCODE.equals("null")) TAXCODE="";
			CUSTNAME = rs.getString("CUSTNAME");
			SALES = rs.getString("SALESPERSON");
			PAYTERMID = rs.getString("PAYTERM_ID");
			PAYMENTTERM = rs.getString("PAYMENTTERM");
			SHIPTOID = rs.getString("SHIP_TO_ORG");
			FOB = rs.getString("FOB_POINT");
			SHIPTOCONTACTID = rs.getString("SHIP_TO_CONTACT_ID");
			if (SHIPTOCONTACTID==null || SHIPTOCONTACTID.equals("null")) SHIPTOCONTACTID="0";
			SHIPTOCONTACT = rs.getString("SHIP_TO_CONTACT_NAME");
			if (SHIPTOCONTACT==null || SHIPTOCONTACT.equals("null")) SHIPTOCONTACT="";
			BILLTOID = rs.getString("BILL_TO_ORG");
			if (BILLTOID==null || BILLTOID.equals("null")) BILLTOID="";
			RFQTYPE = rs.getString("RFQ_TYPE");
			RFQTYPE_NAME =rs.getString("RFQ_TYPE_NAME"); //add by Peggy 20220411
			PRICELIST = rs.getString("PRICE_LIST");
			DELIVERYTOID = rs.getString("DELIVERY_TO_ORG");
			if (DELIVERYTOID==null || DELIVERYTOID.equals("null")) DELIVERYTOID="";
			DELIVERYTO="";
			REMARK = rs.getString("REMARK");
			if (REMARK==null) REMARK ="";
			CREATION_DATE = rs.getString("CREATION_DATE");
			CREATED_BY = rs.getString("CREATED_BY");
			CUSTMARKETGROUP =rs.getString("MARKET_GROUP");
			BY_CODE=rs.getString("BY_CODE");
			DP_CODE=rs.getString("DP_CODE");
			SUPPPLIER_NUMBER=rs.getString("SUPPPLIER_NUMBER");
			if (SUPPPLIER_NUMBER==null) SUPPPLIER_NUMBER="";
			
			CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
			cs1.setString(1,"41"); 
			cs1.execute();
			cs1.close();	
			
			String sqla =" select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+       
						 " a.PAYMENT_TERM_ID, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID"+ 
						 " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc"+
						 " where  a.ADDRESS_ID = b.cust_acct_site_id"+
						 " AND b.party_site_id = party_site.party_site_id"+
						 " AND loc.location_id = party_site.location_id "+
						 " and a.STATUS='A' "+
						 " and b.CUST_ACCOUNT_ID =?";
			//out.println(sqla);
			PreparedStatement statementa = con.prepareStatement(sqla);
			statementa.setString(1,ERPCUSTOMERID);
			ResultSet rsa=statementa.executeQuery();
			while (rsa.next())
			{
				if (rsa.getString("SITE_USE_CODE").equals("SHIP_TO") && rsa.getString("SITE_USE_ID").equals(SHIPTOID))
				{
					SHIPTO = "(" + rsa.getString("SITE_USE_ID")+")"+rsa.getString("ADDRESS1");
				}
				else if (rsa.getString("SITE_USE_CODE").equals("BILL_TO") && rsa.getString("SITE_USE_ID").equals(BILLTOID))
				{
					BILLTO =  "(" + rsa.getString("SITE_USE_ID")+")"+rsa.getString("ADDRESS1");
				}
				else if (rsa.getString("SITE_USE_CODE").equals("DELIVER_TO") && rsa.getString("SITE_USE_ID").equals(DELIVERYTOID))
				{
					DELIVERYTO =  "(" + rsa.getString("SITE_USE_ID")+")"+rsa.getString("ADDRESS1");
				}
			}
			rsa.close();
			statementa.close();
		}
		else
		{
			bNotFound = true;
		}
		rs.close();
		statement.close();	
	
	}
	catch(Exception e)
	{
		out.println(e.getMessage());
		//bNotFound = true;
	}	
	
	if (bNotFound)
	{
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無資料!!申請單狀態可能不符合條件,請重新確認,謝謝!");
			closeWindow();
		</script>
		<%
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="TSSDRQDetailInfo.jsp" METHOD="post" NAME="MYFORM">
<BR>
<table width="100%">
	<tr>
		<td align="left"><font style="font-weight:bold;font-size:20px;color:#003366;font-family:Tahoma,Georgia">RFQ</font>
			<font style="font-size:20px;color:#000000;font-family:細明體"><strong>資料明細</strong></font>
		</td>
	</tr>
	<tr>
		<td align="right"><a href="TSSDRQInformationQuery.jsp" id="myLINK"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></a></td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" bordercolordark="#ABC2AF" bordercolorlight="#FFFFFF" cellPadding="1"  cellspacing="0" bordercolor="#ABC2AF">
				<tr>
					<td width="8%" class="style1"><jsp:getProperty name="rPH" property="pgQDocNo"/></td>
					<td width="20%"><input type="text" name="DNDOCNO" value="<%=DNDOCNO%>"  class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td width="8%" class="style1"><jsp:getProperty name="rPH" property="pgRepStatus"/></td>
					<td width="10%"><input type="text" name="STATUS"  value="<%=STATUS%>" class="style2" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="STATUSID"  value="<%=STATUSID%>"></td>
					<td width="8%" class="style1"><jsp:getProperty name="rPH" property="pgCreateFormDate"/></td>
					<td width="10%"><%=CREATION_DATE%></td>
					<td width="8%" class="style1"><jsp:getProperty name="rPH" property="pgCreateFormUser"/></td>
					<td width="15%"><%=CREATED_BY%></td>
				</tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgSalesArea"/></td>
					<td><input type="text" name="SALESAREA" value="<%=SALESAREA%>" size="40" class="style2" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="SALESAREANO" value="<%=SALESAREANO%>"></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgCustPONo"/></td>
					<td><input type="text" name="CUSTPO" value="<%=CUSTPO%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgRFQType"/></td>
					<td><input type="text" name="RFQTYPE" value="<%=RFQTYPE_NAME%>" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgSalesMan"/></td>
					<td><input type="text" name="SALES" value="<%=SALES%>" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgCustomerName"/></td>
					<td colspan="3"><input type="text" name="CUSTNAME" value="<%=CUSTNAME%>"  size="50" class="style3" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="ERPCUSTOMERID" value="<%=ERPCUSTOMERID%>"></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgCurr"/></td>
					<td><input type="text" name="CURRENCY" value="<%=CURRENCY%>" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgPaymentTerm"/></td>
					<td><input type="text" name="PAYMENTTERM" value="<%=PAYMENTTERM%>" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (PAYMENTTERM==null||PAYMENTTERM==""){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="hidden" name="PAYTERMID" value="<%=PAYTERMID%>"></td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></td>
					<td colspan="3"><input type="text" name="SHIPTO" value="<%=SHIPTO%>"  size="100" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgFOB"/></td>
					<td><input type="text" name="FOB" value="<%=FOB%>" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (FOB==null||FOB==""){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly></td>
					<td class="style1">Tax Code</td>
					<td><input type="text" name="TAXCODE" value="<%=TAXCODE%>" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgBillTo"/></td>
					<td colspan="3"><input type="text" name="BILLTO" value="<%=BILLTO%>" size="100" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td class="style1">Ship To Contact</td>
					<td colspan="3"><input type="text" name="SHIPTOCONTACT" value="<%=SHIPTOCONTACT%>" class="style4" size="50" onKeyDown="return (event.keyCode!=8);" readonly></td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgDeliverTo"/></td>
					<td colspan="3"><input type="text" name="DELIVERYTO" value="<%=DELIVERYTO%>" size="100" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgPriceList"/></td>
					<td colspan="3">
					<%
					try
					{   
						Statement statementx=con.createStatement();
						sql = " select LIST_HEADER_ID, LIST_HEADER_ID||'('||NAME||')' as LIST_CODE, CURRENCY_CODE "+
					 	     //" from qp_secu_list_headers_v "+
						      " from qp_list_headers_v "+ //因價格表改為 User 權限 , 取消所有 OU 權限,故改用qp_list_headers_v by Peggy 20150625
							  " where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0' "+
							  "  AND (ORIG_ORG_ID =41 or ORIG_ORG_ID IS NULL ) "; 
						//out.println(sql);
						ResultSet rsx=statementx.executeQuery(sql);
						out.println("<select NAME='PRICELIST' tabindex='16' class='style5'" + ((PRICELIST==null||PRICELIST=="")?"style='background-color:#FFFF66'":"style='background-color:#FFFFFF' disabled>"));
						out.println("<OPTION VALUE=-->--");     
						while (rsx.next())
						{            
							String s1=(String)rsx.getString(1); 
							String s2=(String)rsx.getString(2); 
							String s3=(String)rsx.getString(3);
							if (s1==PRICELIST || s1.equals(PRICELIST)) 
							{
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
							} 
							else 
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}        
						} 
						out.println("</select>"); 
						statementx.close();		  		  
						rsx.close();        	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception3:"+e.getMessage()); 
					} 		
					%>
					</td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgRemark"/></td>
					<td><input type="text" name="REMARK" value="<%=REMARK%>" size="60" class="style4" readonly></td>
					<td class="style1">Supplier<br>Number</td>
					<td colspan="5"><input type="text" name="SUPPLIER_NUMBER" value="<%=SUPPPLIER_NUMBER%>" class="style3" readonly></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="1500" border="1" bordercolordark="#ABC2AF" bordercolorlight="#FFFFFF" cellPadding="1"  cellspacing="0" bordercolor="#ABC2AF">
				<tr>
					<td colspan="22" class="style1"><jsp:getProperty name="rPH" property="pgDetail"/></td>
				</tr>
				<tr>
					<td width="2%" class="style1">Line No</td>
					<td width="11%" class="style1"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgPart"/></td>
					<td width="8%" class="style1"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgItemDesc"/></td>
					<td width="8%" class="style1"><jsp:getProperty name="rPH" property="pgCustItemNo"/></td>
					<td width="5%" class="style1"><jsp:getProperty name="rPH" property="pgProdFactory"/></td>
					<td width="9%" class="style1"><jsp:getProperty name="rPH" property="pgQty"/>/<jsp:getProperty name="rPH" property="pgUOM"/>:</font><font color="#FF0000"><jsp:getProperty name="rPH" property="pgKPC"/></font></td>
					<td width="5%" class="style1">Selling Price</td>
					<td width="5%" class="style1">CRD</td>
					<td width="5%" class="style1"><jsp:getProperty name="rPH" property="pgShippingMethod"/></td>
					<td width="5%" class="style1">SSD</td>
					<td width="5%" class="style1"><jsp:getProperty name="rPH" property="pgFirmOrderType"/></td>
					<td width="5%" class="style1">Line Type</td>
					<td width="6%" class="style1"><jsp:getProperty name="rPH" property="pgFOB"/></td>
					<td width="7%" class="style1"><jsp:getProperty name="rPH" property="pgCustPONo"/></td>
					<td width="2%" class="style1"><jsp:getProperty name="rPH" property="pgCustPOLineNo"/></td>
					<td width="5%" class="style1"><jsp:getProperty name="rPH" property="pgRemark"/></td>
					<td width="5%" class="style1">Quote Number</td>
					<td width="5%" class="style1">End Cust ID</td>
					<td width="5%" class="style1">End Customer</td>
					<td width="5%" class="style1">ERP MO</td>
					<td width="5%" class="style1">SOURCE MO</td>
					<td width="5%" class="style1">End Cust PartNo</td>
				</tr>
				<%
					String orderNum = "EDI".equals(RFQTYPE_NAME)? "tsc_rfq_create_erp_odr_pkg.TSC_GET_ORDER_TYPE(a.inventory_item_id) ORDER_NUM" : "b.ORDER_NUM ";

					sql = " SELECT a.dndocno, a.line_no, a.inventory_item_id, a.item_segment1,a.ASSIGN_MANUFACT,"+
                          " a.quantity, a.uom, substr(a.request_date,1,8) request_date ,a.line_type,  nvl(a.selling_price,0) selling_price, "+
                          " a.item_description,a.ordered_item, a.ordered_item_id, a.item_id_type,"+
                          " a.tsc_prod_group,  a.spq, a.moq,substr(a.cust_request_date,1,8) cust_request_date, nvl(d.shipping_method,a.shipping_method) shipping_method,"+
                          " a.order_type_id,a.cust_po_line_no,"+orderNum+" " +
						  " ,a.fob, "+
						  " NVL(TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,49,'TSC_Package'),TSC_OM_CATEGORY(INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE"+
						  ",mod(a.quantity ,a.spq) spq_value,case when a.quantity <a.moq then 1 else 0 end as moq_value"+
						  ",a.CUST_PO_NUMBER"+
						  ",a.orderno"+
						  ",a.quote_number"+//add by Peggy 20140423
						  ",a.REMARK"+  //add by Peggy 20140604
						  ",c.customer_number END_CUSTOMER_ID,a.END_CUSTOMER"+ //add by Peggy 20140820
						  ",case when orig_so_line_id is null then null else (select order_number ||'-'|| y.line_number||'.'||y.shipment_number from ont.oe_order_headers_all x,ont.oe_order_lines_all y where x.header_id=y.header_id and y.line_id=a.orig_so_line_id) end as SOURCE_SO"+
						  ",a.end_customer_partno"+ //add by Peggy 20190225
						  //" FROM oraddman.tsdelivery_notice_detail a,(select distinct SAREA_NO,OTYPE_ID,ORDER_NUM FROM oraddman.tsarea_ordercls) b"+
						  " FROM (select a.*,c.order_type_id order_type_id1 from oraddman.tsdelivery_notice_detail a"+
						  ",oraddman.tsdelivery_notice c "+
						  " where a.dndocno = c.dndocno";
						 if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0)
	                     {
		                  	sql +=" and exists (select 1 from oraddman.tsprod_person x where x.USERNAME='"+UserName+"' and x.PROD_FACNO=a.ASSIGN_MANUFACT)";
						 }						  
					sql += " ) a,(select distinct SAREA_NO,OTYPE_ID,ORDER_NUM FROM oraddman.tsarea_ordercls) b"+
						  ",ar_customers c"+
						  ",ASO_I_SHIPPING_METHODS_V d"+
						  " where a.dndocno =? "+
						  " and b.SAREA_NO=?"+
						  //" and a.order_type_id= b.OTYPE_ID(+)"+
						  " and nvl(a.order_type_id,a.order_type_id1)= b.OTYPE_ID(+)"+
						  " and a.END_CUSTOMER_ID=c.customer_id(+)"+
						  " and nvl( a.shipping_method,'') = d.shipping_method_code(+)"+
						  " order by to_number(a.line_no)";
					//out.println(sql);
					PreparedStatement statementb = con.prepareStatement(sql);
					statementb.setString(1,DNDOCNO);
					statementb.setString(2,SALESAREANO);
					String LineNo = "";
					ResultSet rsb=statementb.executeQuery();
					iMaxLine =0;
					float qty =0,moq =0,spq=0;
					while(rsb.next())
					{
						LineNo = rsb.getString("line_no");
						iMaxLine ++;
				%>
					<tr>
						<td><input type="text" name="LINE_NO_<%=iMaxLine%>" value="<%=rsb.getString("line_no")%>"  size="2" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="TSC_ITEM_<%=iMaxLine%>" value="<%=rsb.getString("item_segment1")%>" size="23" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="TSC_ITEM_DESC_<%=iMaxLine%>" value="<%=rsb.getString("item_description")%>"  size="18" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="CUST_ITEM_<%=iMaxLine%>" value="<%=rsb.getString("ordered_item")%>" size="10" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="PLANTCODE_<%=iMaxLine%>" value="<%=rsb.getString("ASSIGN_MANUFACT")%>" class="style4" size="2" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="QUANTITY_<%=iMaxLine%>" value="<%=rsb.getString("quantity")%>" size="3" class="style4" onKeyDown="return (event.keyCode!=8);" readonly>
						<font color='#FF0000' face = 'Arial'><strong>MOQ:<input type="text" name="MOQ_<%=iMaxLine%>" size="2" align="right" style="border:0;color:#FF0000; text-decoration: underline ;font:'Comic Sans MS'; font-style:italic;"  value="<%=rsb.getString("moq")%>" onKeyDown="return (event.keyCode!=8);" readonly>K</strong></font></td>
						<td><input type="text" name="SELLINGPRICE_<%=iMaxLine%>" value="<%=(new DecimalFormat("####0.#####")).format(Float.parseFloat(rsb.getString("selling_price")))%>" size="4" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="CRD_<%=iMaxLine%>" value="<%=(rsb.getString("cust_request_date")==null?"&nbsp;":rsb.getString("cust_request_date"))%>" size="6" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="SHIPPINGMETHOD_<%=iMaxLine%>" value="<%=rsb.getString("shipping_method")%>" size="10" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="SSD_<%=iMaxLine%>" value="<%=rsb.getString("request_date")%>" size="6" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="ORDER_TYPE_<%=iMaxLine%>" value="<%=rsb.getString("ORDER_NUM")%>" class="style4" size="3" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="LINE_TYPE_<%=iMaxLine%>" value="<%=rsb.getString("line_type")%>" class="style4" size="3" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="LINE_FOB_<%=iMaxLine%>" value="<%=rsb.getString("fob")%>"  class="style4" size="15" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="CUST_PO_NO_<%=iMaxLine%>" value="<%=(rsb.getString("CUST_PO_NUMBER")==null?"&nbsp;":rsb.getString("CUST_PO_NUMBER"))%>" size="30" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="CUST_PO_LINE_NO_<%=iMaxLine%>" value="<%=(rsb.getString("cust_po_line_no")==null?"&nbsp;":rsb.getString("cust_po_line_no"))%>" size="4" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="REMARK_<%=iMaxLine%>" value="<%=(rsb.getString("remark")==null?"&nbsp;":rsb.getString("remark"))%>" size="8" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="QUOTE<%=iMaxLine%>" value="<%=(rsb.getString("QUOTE_NUMBER")==null?"&nbsp;":rsb.getString("QUOTE_NUMBER"))%>" size="8" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="ENDCUSTID<%=iMaxLine%>" value="<%=(rsb.getString("END_CUSTOMER_ID")==null?"&nbsp;":rsb.getString("END_CUSTOMER_ID"))%>" size="8" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="ENDCUSTOMER<%=iMaxLine%>" value="<%=(rsb.getString("END_CUSTOMER")==null?"&nbsp;":rsb.getString("END_CUSTOMER"))%>" size="8" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="ORDERNO_<%=iMaxLine%>" value="<%=(rsb.getString("ORDERNO")==null?"&nbsp;":rsb.getString("ORDERNO"))%>" size="10" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="SOURCE_MO_<%=iMaxLine%>" value="<%=(rsb.getString("SOURCE_SO")==null?"&nbsp;":rsb.getString("SOURCE_SO"))%>" size="15" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="ENDCUSTPARTNO_<%=iMaxLine%>" value="<%=(rsb.getString("end_customer_partno")==null?"&nbsp;":rsb.getString("end_customer_partno"))%>" size="15" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
					</tr>

				<%
					}
					rsb.close();
					statementb.close();
				%>
			</table>
		</td>
	</tr>
	<tr><td><HR></td></tr>
</table>
<input type="hidden" name="MAXLINE" value="<%=iMaxLine%>">
<input type="hidden" name="SYSTEMDATE" value="<%=SYSTEMDATE%>">
<input name="CUSTMARKETGROUP" type="hidden" value="<%=CUSTMARKETGROUP%>">
<input name="BY_CODE" type="hidden" value="<%=BY_CODE%>">
<input name="DP_CODE" type="hidden" value="<%=DP_CODE%>">
<input name="PROGRAMNAME" type="hidden" value="RFQCONFIRM">
</FORM>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
