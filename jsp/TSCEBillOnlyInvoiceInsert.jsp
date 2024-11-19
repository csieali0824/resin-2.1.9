<!-- 20090522 liling upate 新增變數i ,判斷多筆mo line 可寫入,原程式只能寫入一筆line -->
<!--20140808 modify by Peggy,insert前檢查invoice是否已存在,已存在,不可重複insert-->
<!--20150303 modify by Peggy,update TSC_INVOICE_HEADERS.vat-->
<!-- 20150625 by Peggy,qp_secu_list_headers_v change to qp_list_headers_v -->
<!--20160408 by Peggy,檢查item是否有assign到I8-->
<!--20160411 by Peggy,shippin method改丟name到invoice-->
<!--20180315 by Peggy,解決地址有單引號會報錯之問題-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>1151 Bill Only Invoice Create Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
</head>
<STYLE TYPE='text/css'>
  .style1 {color: #003399}
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}
             
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function alertTaxCode(URL)
{   
     alert("您選擇的TaxCode與MO單上不一致\n                    請再確認!!!");		     
	 document.MYFORM.action=URL;
     document.MYFORM.submit();
	 return (false);
		   
}

function alertCurrCode(URL)
{   
     alert("您選擇的幣別與MO單上PriceList幣別不一致\n                    請再確認!!!");		     
	 document.MYFORM.action=URL;
     document.MYFORM.submit();
	 return (false);
		   
}
</script>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>  
<form name="MYFORM" method="post" action="../jsp/TSCEBillOnlyInvoiceInsert.jsp">
<font color="#003399" size="3">1151 Bill Only Invoice Create</font> 

<%
  	String invoiceNo=request.getParameter("INVNO");
	invoiceNo = invoiceNo.trim();  //add by Peggy 20140808
  	String salesMONo=request.getParameter("MONO");
  	String taxCode=request.getParameter("TAX_CODE");
  	String currCode=request.getParameter("CURR_CODE");
	boolean isExist = false;      //add by Peggy 20140808
	int unassign_cnt =0;          //add by Peggy 20160408
  
  	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
  	cs1.setString(1,"41");  // 取業務員隸屬ParOrgID 半導體
  	cs1.execute();
  	cs1.close();
	
	try
	{
		//檢查invoice是否存在,add by Peggy 20140808
		String sql = " select 1 from TSC_INVOICE_HEADERS a where a.INVOICE_NO ='"+ invoiceNo +"'";
	 	Statement state1=con.createStatement();
     	ResultSet rs1=state1.executeQuery(sql);
		if (rs1.next())
		{
			isExist =true;
		}
		rs1.close();
		state1.close();
		
		if (isExist)
		{
			out.println("<p>");
			out.println("<div style='color:#ff0000;font-size:12px'>新增失敗!! Invoice No:"+invoiceNo+" 已存在,不可重複新增!</div>");
			out.println("<p>");
			out.println("<div style='color:#ff0000;font-size:12px'><a href='../jsp/TSCEBillOnlyInvoiceCreate.jsp'>回新增畫面</a></div>");
			
		}
		else
		{
			//檢查item是否有assign到I8
			String sqlx = " select distinct msi.segment1,msi.description from OE_ORDER_HEADERS_ALL a, OE_ORDER_LINES_ALL b ,MTL_SYSTEM_ITEMS_B msi"+
                          " where a.HEADER_ID = b.HEADER_ID and a.ORDER_NUMBER = '"+salesMONo+"' and b.FLOW_STATUS_CODE !='CANCELLED' "+
                          " and b.ship_from_org_id=msi.organization_id"+
                          " and b.inventory_item_id=msi.inventory_item_id "+
                          " and not exists (select 1 from mtl_system_items_b x where x.organization_id=44 and x.inventory_item_id=b.inventory_item_id)";
			Statement statex=con.createStatement();
			ResultSet rsx=statex.executeQuery(sqlx);
			while (rsx.next())
			{ 							  
				out.println("<div style='color:#ff0000;font-size:12px'>22D:"+rsx.getString("segment1")+" 沒有assign到ORG:I8</div>");
				unassign_cnt++;
			}
			rsx.close();
			statex.close();
			if (unassign_cnt>0)
			{
				throw new Exception("");
			}
			
			int i=1;  //判斷line 有多少筆,第一筆寫入header即可
			String sqlOM = " select a.HEADER_ID, b.LINE_ID, b.INVENTORY_ITEM_ID from OE_ORDER_HEADERS_ALL a, OE_ORDER_LINES_ALL b "+
						"  where a.HEADER_ID = b.HEADER_ID and a.ORDER_NUMBER = '"+salesMONo+"'  and b.FLOW_STATUS_CODE !='CANCELLED' "; 				
			// out.print("<BR>sqltsc="+sqltsc+"<br>");
			Statement stateOM=con.createStatement();
			ResultSet rsOM=stateOM.executeQuery(sqlOM);
			while (rsOM.next())   //20090522 liling upate if->while for muliti mo line
			{ 	
				String custTaxCode = "", custCity = "", custPostalCode="", custAddress="", custCountry="", custCurrency="";
				String deliverCity ="", deliverPostalCode="", deliverAddress="", deliverCountry="";
		 
				// 取得 Invoice Header的Ship To 資訊
				//   String sqlShipTo = " select hcsua.TAX_CODE as Cust_tax_code, hl.address1, hl.city as Cust_city, hl.POSTAL_CODE as Cust_postal_code, "+  //20090521 liling update taxcode
				String sqlShipTo = " select oola.TAX_CODE as Cust_tax_code, hl.address1, hl.city as Cust_city, hl.POSTAL_CODE as Cust_postal_code, "+
									  "        hps.ADDRESSEE as Cust_addressee, FTT.TERRITORY_SHORT_NAME as Cust_country , QSH.CURRENCY_CODE "+ 		
									  "   from oe_order_lines_all oola,oe_order_headers_all ooha,  "+
									  "        HZ_CUST_ACCOUNTS  hca,HZ_CUST_ACCT_SITES_ALL hcasa,HZ_CUST_SITE_USES_ALL hcsua,HZ_LOCATIONS hl, "+	
									  "        HZ_PARTY_SITES hps,FND_TERRITORIES_TL FTT,"+
									  //"        QP_SECU_LIST_HEADERS_V QSH "+	
									  "        QP_LIST_HEADERS_V QSH "+	 //因價格表改為 User 權限 , 取消所有 OU 權限,故改用qp_list_headers_v by Peggy 20150625
									  "  where oola.LINE_ID = "+rsOM.getString("LINE_ID")+" "+
									  "    and oola.HEADER_ID=ooha.header_id "+
									  "    and ooha.SOLD_TO_ORG_ID =  hca.cust_account_id  "+
									  "    and hcasa.cust_account_id = hca.cust_account_id "+
									  "    and hcsua.cust_acct_site_id = hcasa.cust_acct_site_id "+
									  "    and  hcsua.SITE_USE_CODE = 'BILL_TO' "+
									  "    and  hcsua.STATUS = 'A' and  hcsua.PRIMARY_FLAG = 'Y' "+
									  "    and  hps.PARTY_SITE_ID =  hcasa.PARTY_SITE_ID "+
									  "    and  hps.LOCATION_ID = hl.LOCATION_ID  "+
									  "    and  hl.COUNTRY = FTT.TERRITORY_CODE "+
									  "    and  oola.PRICE_LIST_ID = QSH.LIST_HEADER_ID "+
									  "    and  FTT.LANGUAGE = 'US' ";
				   //out.print("<BR>sqlShipTo="+sqlShipTo+"<br>");
				Statement stateShipTo=con.createStatement();
				ResultSet rsShipTo=stateShipTo.executeQuery(sqlShipTo);
				if (rsShipTo.next())
				{
					custTaxCode = rsShipTo.getString("CUST_TAX_CODE"); 
					custCity = rsShipTo.getString("CUST_CITY");
					custPostalCode=rsShipTo.getString("CUST_POSTAL_CODE");
					custAddress=rsShipTo.getString("CUST_ADDRESSEE"); 
					custAddress=custAddress.replace("'","''");  //add by Peggy 20180315
					custCountry=rsShipTo.getString("CUST_COUNTRY"); 
					custCurrency=rsShipTo.getString("CURRENCY_CODE");
				}
				rsShipTo.close();
				stateShipTo.close();
				   
				// 取得 Invoice Header的 Deliver 資訊
				String sqlDeliver = " select hcsua.CUST_ACCT_SITE_ID, hl.ADDRESS_KEY, hl.city as Deliver_city, hl.POSTAL_CODE as Deliver_postal_code, "+
									  "           hps.ADDRESSEE as Deliver_addressee, FTT.TERRITORY_SHORT_NAME as Deliver_country   "+ 		
									  "   from oe_order_lines_all oola,oe_order_headers_all ooha,HZ_CUST_ACCOUNTS  hca,   "+
									  "        HZ_CUST_ACCT_SITES_ALL hcasa,HZ_CUST_SITE_USES_ALL hcsua, "+	
									  "        HZ_LOCATIONS hl,HZ_PARTY_SITES hps, FND_TERRITORIES_TL FTT "+	
									  "  where oola.LINE_ID = '"+rsOM.getString("LINE_ID")+"' "+
									  "    and oola.HEADER_ID=ooha.header_id "+
									  "    and ooha.SOLD_TO_ORG_ID =  hca.cust_account_id  "+
									  "    and hcasa.cust_account_id = hca.cust_account_id "+
									  "    and hcsua.cust_acct_site_id = hcasa.cust_acct_site_id "+
									  "    and HCSUA.SITE_USE_ID=OOHA.DELIVER_TO_ORG_ID "+
									  "    and hps.PARTY_SITE_ID =  hcasa.PARTY_SITE_ID "+
									  "    and hps.LOCATION_ID = hl.LOCATION_ID  "+	                             
									  "    and  hl.COUNTRY = FTT.TERRITORY_CODE "+
									  "    and  FTT.LANGUAGE = 'US' ";
				   // out.print("<BR>sqltsc="+sqltsc+"<br>");
				Statement stateDeliver=con.createStatement();
				ResultSet rsDeliver=stateDeliver.executeQuery(sqlDeliver);
				if (rsDeliver.next())
				{
					deliverCity =rsDeliver.getString("DELIVER_CITY"); 
					deliverPostalCode=rsDeliver.getString("DELIVER_POSTAL_CODE"); 
					deliverAddress=rsDeliver.getString("DELIVER_ADDRESSEE"); 
					deliverAddress=deliverAddress.replace("'","''"); //add by Peggy 20180315
					deliverCountry=rsDeliver.getString("DELIVER_COUNTRY"); 
				}
				rsDeliver.close();
				stateDeliver.close();
				   
				// 判斷選擇的TAXCODE 或 CURRENCT CODE 與訂單不一致	   
				if (!taxCode.equals(custTaxCode))
				{
				//out.println("taxCode="+taxCode);
				//out.println("custTaxCode="+custTaxCode);
				%>
					<script language="javascript">
						alertTaxCode("../jsp/TSCEBillOnlyInvoiceCreate.jsp");
					</script>
				<%		
				//break;
				} 
				else if (!currCode.equals(custCurrency))
				{
					//out.println("currCode="+currCode);
					//out.println("custCurrency="+custCurrency);
				%>
					<script language="javascript">
						alertCurrCode("../jsp/TSCEBillOnlyInvoiceCreate.jsp");
					</script>
				<%
				} 
				else 
				{   // 表示TaxCode與 Curr Code 都選擇正確
					// 寫入Invoice Header的主檔
					if (i==1)
					{
						String sqlInvHdr = " insert into TSC_INVOICE_HEADERS "+
											   // 20100409 Marvie Add : fix bug
											   "(invoice_no, pickup_date, delivery_date, customer_name, fob_point_code, "+
											   " shipping_method_code, deliverto_addressee, deliverto_city, deliverto_postal_code, "+
											   " deliverto_country, billto_addressee, billto_city, billto_postalcode, billto_country, "+
											   " tax_reference, terms, tax_code, region1, status, vat, net_invoice_value, total_amount, "+
											   " ship_from, docu, shipto_customer_name, shipto_reference, shipto_mark, created_by, "+
											   " creation_date, currency_code, org_id, delivery_note, last_update_date, last_update_by, "+
											   " arrive_flag,acc_status"+ //add acc_status field by Peggy 20120524
											   ", INV_CUST_ID)"+ //add by Peggy 20210616
											" SELECT '"+invoiceNo+"', TRUNC(sysdate), TRUNC(sysdate), hp.PARTY_NAME,  "+
											//"        oola.FOB_POINT_CODE, oola.SHIPPING_METHOD_CODE,  "+ 
											"        oola.FOB_POINT_CODE, flv.meaning,  "+ //modify by Peggy 20160411,改抓shipping method name
											"        '"+deliverAddress+"' as Deliver_addressee   ,'"+deliverCity+"' as Deliver_city   ,'"+deliverPostalCode+"' as Deliver_postal_code ,'"+deliverCountry+"' as Deliver_country, "+	
											//"        '"+custAddress+"' as Cust_addressee  ,'"+custAddress+"' as Cust_city ,'"+custPostalCode+"' as Cust_postal_code ,'"+custCountry+"' as Cust_country,  "+
											"        '"+custAddress+"' as Cust_addressee  ,'"+custCity+"' as Cust_city ,'"+custPostalCode+"' as Cust_postal_code ,'"+custCountry+"' as Cust_country,  "+ //修正city誤植成address bug,by Peggy 20170817
											"        hp.tax_reference,ooha.TERMs,'"+taxCode+"' as Cust_tax_code ,'TSCE','10',0,0,0,  "+	
											"        '','',  decode(ooha.attribute11,'',hp.party_name, av.LAST_NAME) , hp.person_first_name,'','"+UserName+"(RFQ)',TRUNC (SYSDATE) as creation_date,  "+
											"        '"+currCode+"' ,'41', '',TRUNC(sysdate), '"+UserName+"(RFQ)' "+
													// 20100409 Marvie Add : fix bug
													",'N','N'"+ //add acc_status='N' field by Peggy 20120524
											"       ,ooha.sold_to_org_id"+ //add by Peggy 20210616
											"    from oe_order_lines_V oola, "+
											"         oe_order_headers_v ooha,"+
											"         mtl_system_items_b msi,"+
											"         mtl_item_categories mc,   "+	
											"         AR_CONTACTS_V  av ,"+
											"         mtl_categories_tl mct,"+
											"         tsc_cccode tc,"+
											"         HZ_CUST_ACCOUNTS  hca, "+
											"         HZ_PARTIES hp,  "+	
											"         (select meaning,lookup_code from FND_LOOKUP_VALUES_VL where lookup_type='SHIP_METHOD') flv "+
											"  where oola.LINE_ID = '"+rsOM.getString("LINE_ID")+"' "+
											"    and oola.HEADER_ID=ooha.header_id   "+
											"    and ooha.attribute11 = av.ORIG_SYSTEM_REFERENCE(+)   "+
											"    and msi.INVENTORY_ITEM_ID = '"+rsOM.getString("INVENTORY_ITEM_ID")+"' "+
											"    and msi.ORGANIZATION_ID = 44  "+
											"    and mc.inventory_item_id = '"+rsOM.getString("INVENTORY_ITEM_ID")+"' "+
											"    and mc.organization_id = 44 "+
											"    and mc.CATEGORY_SET_ID=6 "+	                             
											"    and mc.category_id = mct.category_id "+
											"    and mct.language = 'US' "+
											"    and tc.category_id(+) = mct.category_id "+
											"    and tc.language(+) = mct.language "+
											"    and ooha.SOLD_TO_ORG_ID =  hca.cust_account_id "+
											"    and oola.SHIPPING_METHOD_CODE=flv.lookup_code(+)"+
											"    and hp.party_id  =   hca.party_id"+
											"    and ROWNUM=1 ";
						 // out.print("<BR>sqltsc="+sqltsc+"<br>");
						//out.println(sqlInvHdr);
						PreparedStatement stmtInvHdr=con.prepareStatement(sqlInvHdr);                 	
						//stmtInvHdr.executeUpdate();  
						stmtInvHdr.executeQuery();  //等全部都insert成功,再commit,add by Peggy 20120524 
						stmtInvHdr.close(); 
					}// end i=1
		
					// 寫入 Invoice Line 的主檔
					String sqlInvDtl = " insert into TSC_INVOICE_LINES( "+
										  " invoice_no, "+               //1
										  " item_description,"+          //2
										  " cust_po_no,"+                //3
										  " quantity,"+                  //4
										  " unit_selling_price,"+        //5
										  " line_amount,"+               //6
										  " cccode,"+                    //7
										  " packing_instructions,"+      //8
										  " inventory_item_id,"+         //9
										  " partno_category_id, "+       //10
										  " item_identifier_type,"+      //11
										  " created_by,"+                //12
										  " creation_date,"+             //13
										  " order_number,"+              //14
										  " order_header_id,"+           //15
										  " order_line_id,"+             //16
										  " customer_partno,"+           //17
										  " packing_list_no,"+           //18
										  " internal_item, "+            //19
										  " release, "+                  //20
										  " customer_dn,"+               //21
										  " bvi_invoice_no,"+            //22
										  " airsurcharge,"+              //23
										  " ship_transaction_name,"+     //24
										  " acc_status"+                //25
										  ")"+
										  " select '"+invoiceNo+"'"+      //1
										  ", msi.DESCRIPTION"+            //2
										  ", oola.CUSTOMER_LINE_NUMBER"+  //3
										  ",decode (oola.PRICING_QUANTITY_UOM,'KPC',oola.PRICING_QUANTITY*1000,oola.ORDERED_QUANTITY) SRC_REQUESTED_QUANTITY"+   //4
										  ",oola.UNIT_SELLING_PRICE "+    //5
										  ",round((decode (oola.PRICING_QUANTITY_UOM,'KPC',oola.PRICING_QUANTITY*1000,oola.ORDERED_QUANTITY) * oola.UNIT_SELLING_PRICE),2) AMOUNT "+  //6
										  ",tc.CCCODE"+                   //7
										  ",oola.PACKING_INSTRUCTIONS"+   //8
										  ",msi.INVENTORY_ITEM_ID"+       //9
										  ",''"+                          //10
										  ",oola.ITEM_IDENTIFIER_TYPE"+   //11
										  ",'"+UserName+"'"+              //12
										  ",TRUNC (SYSDATE) creation_date"+  //13
										  ",ooha.ORDER_NUMBER"+           //14
										  ",ooha.HEADER_ID"+              //15
										  ",oola.LINE_ID"+                //16
										  ",decode(oola.item_identifier_type,'Customer',oola.ordered_item,'CUST',oola.ordered_item,'') CUSTOMER_JOB "+  //17
										  ",oola.ATTRIBUTE1 "+            //18
										  ",''"+                          //19
										  ",''"+                          //20
										  ",''"+                          //21
										  ",''"+                          //22
										  ",'0'"+                         //23,selina要求寫入0,add by Peggy 20201224
										  ",'"+invoiceNo+"'"+             //24 填入invoice,add by peggy 20120525
										  ",'10'"+                        //25 add acc_status=10 by Peggy 20120524          
										  "  from oe_order_lines_all oola, "+
										  "       oe_order_headers_v ooha,mtl_system_items_b msi,mtl_item_categories mc,  "+
										  "       mtl_categories_tl mct,tsc_cccode tc,HZ_CUST_ACCOUNTS  hca ,HZ_PARTIES hp "+
										  " where oola.LINE_ID = '"+rsOM.getString("LINE_ID")+"' "+
										  "   and oola.HEADER_ID=ooha.header_id and msi.INVENTORY_ITEM_ID = '"+rsOM.getString("INVENTORY_ITEM_ID")+"' "+
										  "   and msi.ORGANIZATION_ID = 44 "+
										  "   and mc.inventory_item_id = '"+rsOM.getString("INVENTORY_ITEM_ID")+"' "+
										  "   and mc.organization_id = 44 "+
										  "   and mc.CATEGORY_SET_ID=6 "+
										  "   and mc.category_id = mct.category_id "+
										  "   and mct.language = 'US' "+
										  "   and tc.category_id(+) = mct.category_id  "+
										  "   and tc.language(+) = mct.language  "+
										  "   and ooha.SOLD_TO_ORG_ID =  hca.cust_account_id "+
										  "   and hp.party_id  =   hca.party_id ";
					//out.println(sqlInvDtl);
					PreparedStatement stmtInvDtl=con.prepareStatement(sqlInvDtl);                 	
					//stmtInvDtl.executeUpdate();   
					stmtInvDtl.executeQuery(); //等全部都insert成功,再commit,add by Peggy 20120524
					stmtInvDtl.close();
				} // End of else // 表示TaxCode與 Curr Code 都選擇正確
				i++;  //20090522 liling for multi  mo line	   
			}
			rsOM.close();
			stateOM.close(); 
	  
			float netInvAmt = 0,totInvAmt=0,taxInvAmt=0;  //taxInvAmt,add by Peggy 20150304
			Statement stateInvAmt=con.createStatement();
			ResultSet rsInvAmt=stateInvAmt.executeQuery("select sum(QUANTITY*UNIT_SELLING_PRICE) from TSC_INVOICE_LINES where INVOICE_NO= '"+invoiceNo+"' ");
			if (rsInvAmt.next())
			{
				netInvAmt = rsInvAmt.getFloat(1); 
					 
				if (taxCode.equals("Nontax") || taxCode.equals("Nontax(For EU denote)") || taxCode.equals("Zerotax")) 
				{
					taxInvAmt=0;
					//totInvAmt=netInvAmt;
				} 
				else if (taxCode.equals("Vat 16%(For EU denote)")) 
				{ 
					taxInvAmt=(float)netInvAmt*0.16f;
					//totInvAmt=(float)netInvAmt*0.16f + netInvAmt;
				} 
				else if (taxCode.equals("Vat 19%(For EU denote)"))
				{ 
					taxInvAmt=(float)netInvAmt*0.19f;
					//totInvAmt=(float)netInvAmt*0.19f + netInvAmt;
				} 
				else if (taxCode.equals("Vat 5%"))
				{ 
					taxInvAmt=(float)netInvAmt*0.05f;
					//totInvAmt=(float)netInvAmt*0.05f + netInvAmt;
				} 
				else 
				{
					taxInvAmt=0;
					//totInvAmt=netInvAmt;
				}						
				totInvAmt=taxInvAmt + netInvAmt;
			}
			rsInvAmt.close();
			stateInvAmt.close();
				   
			// 更新發票頭檔發票金額
			String sqlUptInv = "update TSC_INVOICE_HEADERS set NET_INVOICE_VALUE =?,TOTAL_AMOUNT = ?,VAT=?"+ //vat,add by Peggy 20150303
							   " where INVOICE_NO = '"+invoiceNo+"' ";
			PreparedStatement stmtUptInv=con.prepareStatement(sqlUptInv);    
			stmtUptInv.setFloat(1,netInvAmt);  
			stmtUptInv.setFloat(2,totInvAmt);              	
			stmtUptInv.setFloat(3,taxInvAmt);              	
			//stmtUptInv.executeUpdate();   
			stmtUptInv.executeQuery();   //等全部都insert成功,再commit,add by Peggy 20120524 
			stmtUptInv.close();
	
			con.commit();	
			
			out.println("<font color='blue'>資料新增成功!!</font>");
		}
   	}
   	catch(Exception e)
   	{
		con.rollback();
		out.println("<font color='red'>資料新增失敗!請速洽系統管理人員,謝謝!("+e.getMessage().toString()+")</font>");
   	}
%>
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
