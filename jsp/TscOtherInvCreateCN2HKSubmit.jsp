<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="MiscellaneousBean,java.text.DecimalFormat"%>
<!--%@ include file="/jsp/include/ConnTest2PoolPage.jsp"%-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function sendWindowOpen(pp)
{    
 //subWin=window.open("TscOtherInvoiceCreatePreview.jsp?INVOICENO="+pp);  
 document.MYFORM.action=pp;  
 document.MYFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Daphne Invoice CN To HK Create</title>
</head>

<body>
<A HREF="../jsp/TscOtherInvCreateCN2HK.jsp">回上一頁</A> 
<FORM ACTION="../jsp/TscOtherInvCreatePreview.jsp" METHOD="post" NAME="MYFORM">
<%
     String YearFr=request.getParameter("YEARFR");
     String MonthFr=request.getParameter("MONTHFR");
     String DayFr=request.getParameter("DAYFR");
     String invoiceDate=YearFr+MonthFr+DayFr;
	 
	 String invoiceNo=request.getParameter("INVOICENO");
	 String custCharge=request.getParameter("CUSTCHARGE");
	 String freightCharge=request.getParameter("FREIGHTCHARGE");
	 String palletCharge=request.getParameter("PALLETCHARGE");	
	 String insuranceCharge=request.getParameter("INSURANCECHARGE");
	 String serviceItem=request.getParameter("SERVICEITEM"); 
	 
	 String shipMethod=request.getParameter("SHIPMETHOD"); 
	 String shipFrom=request.getParameter("SHIPFROM");
	 String shipMark=request.getParameter("SHIPMARK");
	 
	 boolean bolInvExists = false;
	 
	// String sql="DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')";
	// PreparedStatement pstmt=conTst.prepareStatement(sql);
	// pstmt.executeUpdate();
	// pstmt.close();
	 
	// CallableStatement cs1 = conTst.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 cs1.setString(1,"41");
	 cs1.execute();
     out.println("Procedure : Execute Success !!! ");
     cs1.close();
	 
//Step1 . 判斷若使用者輸入發票號不存在,則可新增 
	 Statement statementTC=con.createStatement();
	 String sql = "select * from DAPHNE_INVOICE_OTHER where name='"+invoiceNo+"' ";
	 ResultSet rs=statementTC.executeQuery(sql);
	 if (!rs.next())
	 {	   
	     bolInvExists = true;
	 
         String sqlInsert = "insert into DAPHNE_INVOICE_OTHER ";
		 String sqlSelect = "select DISTINCT data.NAME,data.ITEM_DESCRIPTION, data.INITIAL_PICKUP_DATE,data.INITIAL_PICKUP_DATE, "+  
                "data.CUST_PO_NUMBER,data.SRC_REQUESTED_QUANTITY,data.UNIT_SELLING_PRICE,data.CURRENCY_CODE, "+  
                "data.AMOUNT,data.NET_INVOICE_VALUE,data.VAT, (data.NET_INVOICE_VALUE + data.VAT ) TOTAL_AMOUNT, "+   
                "data.FOB_POINT_CODE,'"+shipMethod+"',data.TERMS,data.CUSTOMER_JOB,data.PARTY_NAME,data.tax_reference , "+   
                "data.CCCODE,data.TAX_CODE,data.PACKING_INSTRUCTIONS,"+
				//"customer_deliver_to.ADDRESSEE, "+ // 有問題的訂單客戶資訊
				"data.SHIP_TO_ADDRESS1, "+
				"customer_deliver_to.city ,customer_deliver_to.POSTAL_CODE, customer_deliver_to.country, "+
				//"cust_bill_to.ADDRESSEE, "+ // 有問題的訂單客戶資訊
				"data.INVOICE_TO_ADDRESS1, "+
				"cust_bill_to.city,cust_bill_to.POSTAL_CODE ,cust_bill_to.country, "+  
                "data.DELIVER_TO_ADDRESS1,data.person_last_name ,data.person_first_name ,'Y', "+   
                "data.ORDER_NUMBER ,"+
				"'"+shipFrom+"',NULL,data.header_id,data.SALESREP_ID "+  // For Other Invoice Table spec.
		 //    "DATA.INVENTORY_ITEM_ID,null,data.header_id,'SPI' ,null, "+  
         //    "sysdate LAST_UPDATE_DATE,'VENUS' LAST_UPDATED_BY,'VENUS' CREATED_BY,sysdate CREATION_DATE, "+  
         //    " 'Y' Identify_Flag, data.line_id  "+ 
                "from (select oola.line_id ,prl.requisition_line_id, hl.ADDRESS_KEY,   "+
                      "       hl.city , hl.POSTAL_CODE, hps.ADDRESSEE, FTT.TERRITORY_SHORT_NAME country, "+
					  "       hcsua.CUST_ACCT_SITE_ID "+   
                      " from  PO_HEADERS_ALL poh ,PO_LINES_ALL pol ,RCV_SHIPMENT_HEADERS rsh ,RCV_SHIPMENT_LINES rsl , "+  
                      "       PO_DISTRIBUTIONS_ALL PODIS ,PO_REQUISITION_HEADERS_ALL PRH ,PO_REQUISITION_LINES_ALL PRL,  "+  
                      "       PO_REQ_DISTRIBUTIONS_ALL PRDIS ,oe_order_lines_all oola ,oe_order_headers_all ooha, "+
                      "       HZ_CUST_ACCOUNTS hca, HZ_CUST_ACCT_SITES_ALL hcasa ,HZ_CUST_SITE_USES_ALL hcsua , "+   
                      "       HZ_LOCATIONS hl ,HZ_PARTY_SITES hps ,FND_TERRITORIES_TL FTT  "+
                      " where poh.po_header_id =  pol.po_header_id and rsh.SHIPMENT_HEADER_ID = rsl.SHIPMENT_HEADER_ID "+  
                      "   and rsl.po_header_id  = pol.po_header_id and rsl.PO_LINE_ID = pol.PO_LINE_ID "+    
                      "  and prdis.requisition_line_id = prl.requisition_line_id  "+    
                      "  and prh.requisition_header_id = prl.requisition_header_id "+ 
                      "  and podis.req_distribution_id = prdis.distribution_id "+            
                      "  and poh.po_header_id = podis.po_header_id and podis.po_header_id  =  pol.po_header_id "+    
                      "  and podis.po_line_id = pol.po_line_id and oola.line_id = prl.attribute1 "+        
                      "  and oola.HEADER_ID=ooha.header_id and ooha.SOLD_TO_ORG_ID =  hca.cust_account_id "+   
                      "  and hcasa.cust_account_id = hca.cust_account_id and  hcsua.cust_acct_site_id = hcasa.cust_acct_site_id "+   
                      "  and hcsua.SITE_USE_CODE = 'DELIVER_TO' and hcsua.STATUS = 'A' "+  
                      " and  hcsua.PRIMARY_FLAG = 'Y' "+    
                      " and hps.PARTY_SITE_ID =  hcasa.PARTY_SITE_ID "+   
                      " and  hps.LOCATION_ID = hl.LOCATION_ID "+   
                      " and  hl.COUNTRY = FTT.TERRITORY_CODE "+   
                      " and  FTT.LANGUAGE = 'US' "+   
                      "and  rsh.PACKING_SLIP = '"+invoiceNo+"' "+    
                      //and  ooha.order_number = '12130000815'          
                 " ) customer_deliver_to , "+  
	             " ( select oola.line_id ,prl.requisition_line_id, rsh.PACKING_SLIP NAME, pol.ITEM_DESCRIPTION, "+  
                          " pol.item_id INVENTORY_ITEM_ID ,rsh.creation_date INITIAL_PICKUP_DATE, ooha.CUST_PO_NUMBER, "+  
                          " oola.SHIPPED_QUANTITY, decode (rsl.UNIT_OF_MEASURE,'KPC',rsl.QUANTITY_RECEIVED*1000,rsl.QUANTITY_RECEIVED) SRC_REQUESTED_QUANTITY, "+  
                          " oola.UNIT_SELLING_PRICE, ooha.TRANSACTIONAL_CURR_CODE  CURRENCY_CODE, "+  
                          " ( decode (rsl.UNIT_OF_MEASURE,'KPC',rsl.QUANTITY_RECEIVED*1000,rsl.QUANTITY_RECEIVED)) * oola.UNIT_SELLING_PRICE AMOUNT , "+  
                          " ( select sum(( decode (rsl.UNIT_OF_MEASURE,'KPC',rsl.QUANTITY_RECEIVED*1000,rsl.QUANTITY_RECEIVED)) * oola.UNIT_SELLING_PRICE ) "+   
                          " from PO_HEADERS_ALL poh ,PO_LINES_ALL pol ,RCV_SHIPMENT_HEADERS rsh ,RCV_SHIPMENT_LINES rsl ,PO_DISTRIBUTIONS_ALL PODIS , "+   
                                "PO_REQUISITION_HEADERS_ALL PRH , PO_REQUISITION_LINES_ALL PRL ,PO_REQ_DISTRIBUTIONS_ALL PRDIS, "+   
                                "oe_order_lines_all oola ,oe_order_headers_all ooha "+   
                          " where poh.po_header_id =  pol.po_header_id and rsh.SHIPMENT_HEADER_ID = rsl.SHIPMENT_HEADER_ID "+   
                            "and rsl.po_header_id  = pol.po_header_id and rsl.PO_LINE_ID = pol.PO_LINE_ID "+    
                            "and prdis.requisition_line_id = prl.requisition_line_id "+     
                            "and prh.requisition_header_id = prl.requisition_header_id "+   
                            "and podis.req_distribution_id = prdis.distribution_id "+            
                            "and poh.po_header_id = podis.po_header_id and podis.po_header_id=pol.po_header_id "+    
                            "and podis.po_line_id = pol.po_line_id and oola.line_id = prl.attribute1 "+       
                            "and  oola.HEADER_ID=ooha.header_id and rsh.PACKING_SLIP = '"+invoiceNo+"' "+  
                             // and  ooha.order_number = '12130000815'           
                          " ) NET_INVOICE_VALUE, "+  
       "  (select sum(( decode (rsl.UNIT_OF_MEASURE,'  & kp &  ',rsl.QUANTITY_RECEIVED*1000,rsl.QUANTITY_RECEIVED)) * oola.UNIT_SELLING_PRICE ) * 0.16 "+  
            " from  PO_HEADERS_ALL poh ,PO_LINES_ALL pol , "+  
                  " RCV_SHIPMENT_HEADERS rsh ,RCV_SHIPMENT_LINES rsl , "+   
                  " PO_DISTRIBUTIONS_ALL PODIS ,PO_REQUISITION_HEADERS_ALL PRH ,"+
                  " PO_REQUISITION_LINES_ALL PRL, PO_REQ_DISTRIBUTIONS_ALL PRDIS  , "+
                  " oe_order_lines_all oola , "+   
                  " oe_order_headers_all ooha "+   
            "where poh.po_header_id =  pol.po_header_id "+   
              "and rsh.SHIPMENT_HEADER_ID = rsl.SHIPMENT_HEADER_ID "+   
              "and rsl.po_header_id = pol.po_header_id "+   
              "and rsl.PO_LINE_ID = pol.PO_LINE_ID "+   
              "and prdis.requisition_line_id = prl.requisition_line_id "+    
              "and prh.requisition_header_id = prl.requisition_header_id "+    
              "and podis.req_distribution_id = prdis.distribution_id "+            
              "and poh.po_header_id = podis.po_header_id "+    
              "and podis.po_header_id  =  pol.po_header_id "+   
              "and podis.po_line_id    =  pol.po_line_id "+     
              "and oola.line_id = prl.attribute1 and oola.HEADER_ID=ooha.header_id "+
              //and  ooha.order_number = '12130000815'          
              "and rsh.PACKING_SLIP = '"+invoiceNo+"' "+    
              ") VAT, oola.FOB_POINT_CODE, oola.SHIPPING_METHOD_CODE, ooha.TERMs , "+
              "oola.CUSTOMER_JOB, hp.PARTY_NAME, hp.person_first_name ,hp.person_last_name , "+    
              "hp.tax_reference ,tc.CCCODE,oola.TAX_CODE,oola.PACKING_INSTRUCTIONS,ooha.invoice_to_address1, "+   
              "ooha.DELIVER_TO_ADDRESS1,ooha.HEADER_ID,ooha.order_number, ooha.ship_to_address1,"+ 
			  "ooha.SALESREP_ID "+  
        "from PO_HEADERS_ALL poh ,PO_LINES_ALL pol,RCV_SHIPMENT_HEADERS rsh, RCV_SHIPMENT_LINES rsl, "+  
             "PO_DISTRIBUTIONS_ALL PODIS ,PO_REQUISITION_HEADERS_ALL PRH ,PO_REQUISITION_LINES_ALL PRL, "+   
             "PO_REQ_DISTRIBUTIONS_ALL PRDIS , "+    
             "oe_order_lines_all oola, oe_order_headers_v ooha, "+  
             "mtl_system_items_b msi, mtl_item_categories mc, mtl_categories_tl mct , "+   
             "tsc_cccode tc, HZ_CUST_ACCOUNTS  hca ,HZ_PARTIES hp "+
        "where poh.po_header_id =  pol.po_header_id and rsh.SHIPMENT_HEADER_ID = rsl.SHIPMENT_HEADER_ID "+  
          "and rsl.po_header_id  = pol.po_header_id and rsl.PO_LINE_ID = pol.PO_LINE_ID "+    
          "and prdis.requisition_line_id = prl.requisition_line_id "+  
          "and prh.requisition_header_id = prl.requisition_header_id "+   
          "and podis.req_distribution_id = prdis.distribution_id "+           
          "and poh.po_header_id = podis.po_header_id and podis.po_header_id  =  pol.po_header_id "+    
          "and podis.po_line_id    =  pol.po_line_id and oola.line_id = prl.attribute1 "+      
          "and oola.HEADER_ID=ooha.header_id and pol.ITEM_ID=msi.INVENTORY_ITEM_ID "+    
          "and rsl.to_ORGANIZATION_ID=msi.ORGANIZATION_ID "+   
          "and  msi.inventory_item_id = mc.inventory_item_id "+   
          "and  msi.organization_id   = mc.organization_id "+  
          "and  mc.CATEGORY_SET_ID=6 "+   
          "and  mc.category_id = mct.category_id "+   
          "and  mct.language = 'US' "+   
          "and  tc.category_id = mct.category_id "+    
          "and  tc.language = mct.language "+   
          "and  ooha.SOLD_TO_ORG_ID =  hca.cust_account_id "+    
          "and  hp.party_id = hca.party_id "+    
           //and  ooha.order_number = '12130000815'
          "and  rsh.PACKING_SLIP  = '"+invoiceNo+"' "+   
          " ) data, (select oola.line_id , prl.requisition_line_id ,hl.ADDRESS_KEY, "+   
                          " hl.city ,hl.POSTAL_CODE, hps.ADDRESSEE, FTT.TERRITORY_SHORT_NAME country, "+    
                          " hcsua.CUST_ACCT_SITE_ID "+
				    "from PO_HEADERS_ALL poh ,PO_LINES_ALL pol , "+  
                          " RCV_SHIPMENT_HEADERS rsh ,RCV_SHIPMENT_LINES rsl ,"+   
                          " PO_DISTRIBUTIONS_ALL PODIS ,PO_REQUISITION_HEADERS_ALL PRH , PO_REQUISITION_LINES_ALL PRL, "+  
                          " PO_REQ_DISTRIBUTIONS_ALL PRDIS , "+    
                          "oe_order_lines_all oola , oe_order_headers_all ooha , "+  
                          "HZ_CUST_ACCOUNTS  hca ,HZ_CUST_ACCT_SITES_ALL hcasa , "+  
                          "HZ_CUST_SITE_USES_ALL hcsua ,HZ_LOCATIONS hl ,HZ_PARTY_SITES hps , "+  
                          "FND_TERRITORIES_TL FTT "+   
                   " where poh.po_header_id =  pol.po_header_id and rsh.SHIPMENT_HEADER_ID = rsl.SHIPMENT_HEADER_ID "+    
                      "and rsl.po_header_id  = pol.po_header_id and rsl.PO_LINE_ID = pol.PO_LINE_ID "+   
                      "and prdis.requisition_line_id = prl.requisition_line_id "+     
                      "and prh.requisition_header_id = prl.requisition_header_id "+  
                      "and podis.req_distribution_id = prdis.distribution_id and poh.po_header_id = podis.po_header_id "+     
                      "and podis.po_header_id  =  pol.po_header_id and podis.po_line_id=pol.po_line_id "+    
                      "and oola.line_id = prl.attribute1 "+     
                      "and oola.HEADER_ID=ooha.header_id "+   
                      "and ooha.SOLD_TO_ORG_ID =  hca.cust_account_id "+    
                      "and hcasa.cust_account_id = hca.cust_account_id "+   
                      "and hcsua.cust_acct_site_id = hcasa.cust_acct_site_id "+   
                      "and hcsua.SITE_USE_CODE = 'BILL_TO' and  hcsua.STATUS = 'A' "+    
                      "and hcsua.PRIMARY_FLAG = 'Y' "+   
                      "and hps.PARTY_SITE_ID =  hcasa.PARTY_SITE_ID "+    
                     // "and  hps.ADDRESSEE is not null "+ // ...    
                      "and hps.LOCATION_ID = hl.LOCATION_ID  "+   
                      "and hl.COUNTRY = FTT.TERRITORY_CODE "+    
                      "and hcasa.ORG_ID=41 " +  
                      "and  FTT.LANGUAGE = 'US' "+    
					  "and  rsh.PACKING_SLIP = '"+invoiceNo+"'  "+   
                    // "and  ooha.order_number = '12130000815' "+
                  ") cust_bill_to "+
    " where data.line_id= customer_deliver_to.line_id "+   
       "and data.requisition_line_id = customer_deliver_to.requisition_line_id "+   
       "and data.line_id = cust_bill_to.line_id "+    
       "and data.requisition_line_id = cust_bill_to.requisition_line_id "; 
	   //out.println(sqlInsert);
	   sqlInsert = sqlInsert + sqlSelect;
/*	  
	  String sqlInsert="insert into DAPHNE_INVOICE_OTHER ";
      String sqlSelect="select data.NAME,data.ITEM_DESCRIPTION,data.INITIAL_PICKUP_DATE,data.INITIAL_PICKUP_DATE,data.CUST_PO_NUMBER,"+
	                   "data.SRC_REQUESTED_QUANTITY,data.UNIT_SELLING_PRICE,data.CURRENCY_CODE,data. AMOUNT,data.NET_INVOICE_VALUE,data.VAT,"+
				       "data.TOTAL_AMOUNT,data.FOB_POINT_CODE,data.SHIPPING_METHOD_CODE,data.TERMS,data.CUSTOMER_JOB,data.PARTY_NAME,"+
				       "data.tax_reference,data.CCCODE,data.TAX_CODE,data.PACKING_INSTRUCTIONS,data.ship_to_address1,NULL,data.SOLD_TO_CONTACT_ID,NULL,"+
				       "data.invoice_to_address1,NULL,data.ITEM_IDENTIFIER_TYPE,NULL,data.SHIP_TO_ORG_ID,data.person_last_name,data.person_first_name,"+
				       "'Y',data.ORDER_NUMBER,'"+shipFrom+"',NULL,data.header_id,data.SALESREP_ID "+
                "from "+
                "( select wnd.DELIVERY_ID,wdd.DELIVERY_DETAIL_ID,wnd.NAME,wdd.ITEM_DESCRIPTION,wdd.INVENTORY_ITEM_ID,"+
				        " wnd.INITIAL_PICKUP_DATE,oola.CUSTOMER_LINE_NUMBER CUST_PO_NUMBER,oola.SHIPPED_QUANTITY, "+
				        " decode (wdd.REQUESTED_QUANTITY_UOM,'KPC',wdd.REQUESTED_QUANTITY*1000,wdd.REQUESTED_QUANTITY "+
				") SRC_REQUESTED_QUANTITY, oola.UNIT_SELLING_PRICE,wdd.CURRENCY_CODE,round((decode (wdd.REQUESTED_QUANTITY_UOM,'KPC',"+
				"wdd.REQUESTED_QUANTITY*1000, wdd.REQUESTED_QUANTITY) * oola.UNIT_SELLING_PRICE),2) AMOUNT , "+
                "( select round(sum(round(decode (wdd.REQUESTED_QUANTITY_UOM,'KPC',wdd.REQUESTED_QUANTITY*1000,wdd.REQUESTED_QUANTITY) * oola.UNIT_SELLING_PRICE,2)),2) TOTAL "+
                    "from wsh_new_deliveries wnd,wsh_delivery_details wdd,wsh_delivery_assignments wda,oe_order_lines_all oola "+
                   "where wnd.DELIVERY_ID=wda.DELIVERY_ID and  wda.DELIVERY_DETAIL_ID=wdd.DELIVERY_DETAIL_ID and wdd.SOURCE_LINE_ID=oola.LINE_ID "+
				    " and  wnd.NAME= '"+invoiceNo+"' "+
                ") NET_INVOICE_VALUE, "+
                "( select round(sum(round(decode (wdd.REQUESTED_QUANTITY_UOM,'KPC',wdd.REQUESTED_QUANTITY*1000,wdd.REQUESTED_QUANTITY) * oola.UNIT_SELLING_PRICE,2))*0.16,2) TOTAL "+
                  "from wsh_new_deliveries wnd,wsh_delivery_details wdd,wsh_delivery_assignments wda,oe_order_lines_all oola "+
                  "where wnd.DELIVERY_ID=wda.DELIVERY_ID and  wda.DELIVERY_DETAIL_ID=wdd.DELIVERY_DETAIL_ID "+
				  "and wdd.SOURCE_LINE_ID=oola.LINE_ID and  wnd.NAME= '"+invoiceNo+"' "+
                ") VAT, "+
                "( select round(sum(round(decode (wdd.REQUESTED_QUANTITY_UOM,'KPC',wdd.REQUESTED_QUANTITY*1000,wdd.REQUESTED_QUANTITY) * oola."+
				         "UNIT_SELLING_PRICE,2)),2) + round(sum(round(decode (wdd.REQUESTED_QUANTITY_UOM,'KPC',wdd.REQUESTED_QUANTITY*1000,"+
						 "wdd.REQUESTED_QUANTITY) * oola.UNIT_SELLING_PRICE,2))*0.16,2) "+
                    "from wsh_new_deliveries wnd,wsh_delivery_details wdd,wsh_delivery_assignments wda,oe_order_lines_all oola "+
                    "where wnd.DELIVERY_ID=wda.DELIVERY_ID and  wda.DELIVERY_DETAIL_ID=wdd.DELIVERY_DETAIL_ID "+
					"and wdd.SOURCE_LINE_ID=oola.LINE_ID and  wnd.NAME= '"+invoiceNo+"' "+
                ") TOTAL_AMOUNT,oola.FOB_POINT_CODE,ooha.SHIP_TO_ORG_ID,ooha.HEADER_ID,oola.SHIPPING_METHOD_CODE,"+
				"ooha.TERMs,oola.ORDERED_ITEM CUSTOMER_JOB,ooha.ATTRIBUTE11 SOLD_TO_CONTACT_ID,hp.PARTY_NAME,hp.tax_reference,"+
				"hp.person_first_name,hp.person_last_name,tc.CCCODE,oola.TAX_CODE,oola.PACKING_INSTRUCTIONS,ooha.invoice_to_address1,"+
				"oola.ITEM_IDENTIFIER_TYPE,ooha.DELIVER_TO_ADDRESS1,ooha.ship_to_address1,ooha.ORDER_NUMBER,OOHA.SALESREP_ID "+
         "from wsh_new_deliveries wnd,wsh_delivery_details wdd,wsh_delivery_assignments wda,"+
		       "oe_order_lines_all oola,oe_order_headers_v ooha,"+
			   "mtl_system_items_b msi,mtl_item_categories mc,mtl_categories_tl mct,"+
			   "tsc_cccode tc,"+
			   "HZ_CUST_ACCOUNTS hca,HZ_PARTIES hp "+
         "where wnd.DELIVERY_ID=wda.DELIVERY_ID and wda.DELIVERY_DETAIL_ID=wdd.DELIVERY_DETAIL_ID and wdd.SOURCE_LINE_ID=oola.LINE_ID "+
		 "and oola.HEADER_ID=ooha.header_id and wdd.INVENTORY_ITEM_ID=msi.INVENTORY_ITEM_ID and wdd.ORGANIZATION_ID=msi.ORGANIZATION_ID "+
		 "and wdd.inventory_item_id = mc.inventory_item_id and wdd.organization_id = mc.organization_id and mc.CATEGORY_SET_ID=6 "+
		 "and mc.category_id = mct.category_id and mct.language = 'US' and tc.category_id = mct.category_id "+
		 "and tc.language = mct.language and ooha.SOLD_TO_ORG_ID =  hca.cust_account_id and hp.party_id = hca.party_id "+
		 "and wnd.NAME= '" +invoiceNo+"' "+
       ") data ";
	    sqlInsert = sqlInsert + sqlSelect;
         //     PreparedStatement pstmt=con.prepareStatement(sqlInsert);
			  		  
	     //     pstmt.executeUpdate();
	     //      pstmt.close();
	out.println(sqlSelect);
*/
              PreparedStatement pstmt=con.prepareStatement(sqlInsert);
			  		  
	          pstmt.executeUpdate();
	          pstmt.close();
			  out.println("<table>");
			  out.println("<tr bgcolor='#339999'><td><font color='#CCFFCC'><strong>發票號碼</strong></font></td><td><font color='#CCFFCC'><strong>料號</strong></font></td><td><font color='#CCFFCC'><strong>PICKUP DATE</strong></font><td><font color='#CCFFCC'><strong>客戶PO號</strong></font></td><td><font color='#CCFFCC'><strong>訂單號</strong></font></td></tr>");
			  ResultSet rsSel=statementTC.executeQuery(sqlSelect);	
	          while (rsSel.next())
	          {
			    out.println("<tr bgcolor='#339999'>");   
	            out.println("<td><font color='#CCFFCC'><strong>"+rsSel.getString("NAME")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsSel.getString("ITEM_DESCRIPTION")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsSel.getString("INITIAL_PICKUP_DATE")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsSel.getString("CUST_PO_NUMBER")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsSel.getString("ORDER_NUMBER")+"</strong></font></td>");
				out.println("</tr>");
	          }
			  rsSel.close();			  
			  out.println("</table>");
			  
	   //rsTC.close();  // 關閉判斷invoice存在否的結果集     
	 } else {
	           out.println("There is no invoice Exists !!!");             
	        }
			
	 rs.close();	 // end of if (rs.next())  關閉主 SQL 結果集

//	Step 2. 更新原始Pick Date及交貨日的格式為日期型態

	 String sqlUpdate = "update DAPHNE_INVOICE_OTHER set INITIAL_PICKUP_DATE = to_date('"+ invoiceDate + "','yyyy/mm/dd'),DELIVERY_DATE=to_date('"+invoiceDate+"','yyyy/mm/dd') where name='"+invoiceNo+"' ";
	 PreparedStatement pstmtU0=con.prepareStatement(sqlUpdate);
	 pstmtU0.executeUpdate();
	 pstmtU0.close();
	 
//  Step3. 取出 daphne_invoice_other 各欄位內容,準備作Mark內容處理 //
    String longText ="";

    sql = "select * from DAPHNE_INVOICE_OTHER where NAME='"+invoiceNo+"' ";   
    rs=statementTC.executeQuery(sql);
	while (rs.next())
	{	
	    //  Step 4.	取系統出貨備註格式  
		
        String sqlMkFmt="select FDLT.MEDIA_ID MEDIA_ID "+
		                "from FND_ATTACHED_DOCS_FORM_VL FADFV, FND_DOCUMENTS_LONG_TEXT FDLT "+
						"where FADFV.FUNCTION_NAME = 'OEXOEORF' "+
					    "and UPPER(FADFV.CATEGORY_DESCRIPTION) = 'SHIPPING MARKS' "+
					    "and FADFV.PK1_VALUE = '" +rs.getString("HEADER_ID")+"' and FADFV.MEDIA_ID = FDLT.MEDIA_ID "+
					    "and FADFV.USER_ENTITY_NAME = 'OM 訂單表頭' ";  
	    ResultSet rsMkFmt=statementTC.executeQuery(sqlMkFmt);
		if (!rsMkFmt.next())
		{
		  longText = null;
		} else {
		          sqlMkFmt="select FDLT.LONG_TEXT LONG_TEXT "+
				           "from FND_ATTACHED_DOCS_FORM_VL FADFV,FND_DOCUMENTS_LONG_TEXT FDLT "+
				           "where FADFV.FUNCTION_NAME = 'OEXOEORF' and UPPER(FADFV.CATEGORY_DESCRIPTION) = 'SHIPPING MARKS' "+
						   "and FADFV.PK1_VALUE = '69752' and FADFV.MEDIA_ID = FDLT.MEDIA_ID "+
						   "and FADFV.USER_ENTITY_NAME = 'OM 訂單表頭'"; 
			      ResultSet rsMkFmt2=statementTC.executeQuery(sqlMkFmt); 
				  if (rsMkFmt2.next())
				  {
				      longText=rsMkFmt2.getString("LONG_TEXT"); 
					  
				  }
				  rsMkFmt2.close();         
		       }
		rsMkFmt.close();   
	
	}  // End of if (rs.next()) Step3.
	rs.close();  
	
	
	
//  Step4. 取出 daphne_invoice_other 各欄位內容,準備作相關費用處理 //
    sql = "select dit.INITIAL_PICKUP_DATE INITIAL_PICKUP_DATE1,dit.DELIVERY_DATE DELIVERY_DATE1,dit.* from DAPHNE_INVOICE_OTHER dit where NAME='"+invoiceNo+"' ";   
    ResultSet rsFee=statementTC.executeQuery(sql);  
	if (rsFee.next())
	{  

        float totAmountf = 0;
		float custChargef=0,freightChargef=0,palletChargef=0,insuranceChargef=0,serviceItemf=0;
		float netInvoiceValuef = 0,vatf=0; 
		String netInvoiceValue = "",vat="",totAmount="";
		
	    // 判斷若客人費用有輸入,則新增一筆客戶費用並更新總金額
		if (custCharge!=null && !custCharge.equals(""))
		{
		   custChargef = Float.parseFloat(custCharge); 
		   netInvoiceValuef = custChargef + rsFee.getFloat("NET_INVOICE_VALUE");
		   vatf = netInvoiceValuef*0;
		   totAmountf = netInvoiceValuef + vatf;
		   
           miscellaneousBean.setRoundDigit(2);
           custCharge = miscellaneousBean.getFloatRoundStr(custChargef);
		   netInvoiceValue = miscellaneousBean.getFloatRoundStr(netInvoiceValuef);
		   miscellaneousBean.setRoundDigit(3);
		   totAmount = miscellaneousBean.getFloatRoundStr(totAmountf); 
		   
		   custChargef = Float.parseFloat(custCharge);
		   netInvoiceValuef = Float.parseFloat(netInvoiceValue);
		   totAmountf = Float.parseFloat(totAmount);
		   String sqlI1 = "insert into DAPHNE_INVOICE_OTHER "+
		                  "values ('"+invoiceNo+"','CUSTOMS CHARGE',TO_DATE('"+rsFee.getDate("INITIAL_PICKUP_DATE1")+"','yyyy/mm/dd'),"+
						  "TO_DATE('"+rsFee.getDate("DELIVERY_DATE1")+"','yyyy/mm/dd'),null,null,null,'"+rsFee.getString("CURRENCY_CODE")+"',"+
						  "'"+custChargef+"','"+netInvoiceValuef+"','"+vatf+"','"+totAmount+"','"+rsFee.getString("FOB_POINT_CODE")+"',"+
						  "'"+rsFee.getString("SHIPPING_METHOD_CODE")+"','"+rsFee.getString("TERMS")+"',null,'"+rsFee.getString("CUSTOMER_NAME")+"',"+
						  "'"+rsFee.getString("TAX_REFERENCE")+"',null,'"+rsFee.getString("TAX_CODE")+"','"+rsFee.getString("PACKING_INSTRUCTIONS")+"',"+
						  "'"+rsFee.getString("DELIVERTO_ADDRESSEE")+"','"+rsFee.getString("DELIVERTO_CITY")+"','"+rsFee.getString("DELIVERTO_POSTAL_CODE")+"',"+
						  "'"+rsFee.getString("DELIVERTO_COUNTRY")+"','"+rsFee.getString("BILLTO_ADDRESSEE")+"','"+rsFee.getString("BILLTO_CITY")+"',"+
						  "'"+rsFee.getString("BILLTO_POSTALCODE")+"','"+rsFee.getString("BILLTO_COUNTRY")+"',null,null,null,"+
						  "'"+rsFee.getString("FLAG")+"','"+rsFee.getString("ORDER_NUMBER")+"','"+rsFee.getString("FROMM")+"','"+rsFee.getString("DOCU")+"',"+
						  "'"+rsFee.getString("HEADER_ID")+"','"+rsFee.getString("SALES_PERSON")+"')";
		   PreparedStatement pstmtI1=con.prepareStatement(sqlI1);						  		  
	       pstmtI1.executeUpdate();
	       pstmtI1.close();
		   
		   String sqlU1 = "update DAPHNE_INVOICE_OTHER set NET_INVOICE_VALUE = '"+netInvoiceValue+"',VAT = '"+vat+"',TOTAL_AMOUNT='"+totAmount+"' where NAME='"+invoiceNo+"'" ;
		   PreparedStatement pstmtU1=con.prepareStatement(sqlU1);				  		  
	       pstmtU1.executeUpdate();
	       pstmtU1.close();
		   
		   out.println("<BR>");
		   out.println("<table width='70%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#999999' bordercolordark='#FFFFFF'>");
		   out.println("<tr bgcolor='#339999'><td><font color='#CCFFCC'><strong>發票號碼</strong></font></td><td><font color='#CCFFCC'><strong>客戶費用</strong></font></td><td><font color='#CCFFCC'><strong>PICKUP DATE</strong></font><td><font color='#CCFFCC'><strong>客戶PO號</strong></font></td><td><font color='#CCFFCC'><strong>訂單號</strong></font></td></tr>");
		   out.println("<tr bgcolor='#339999'>");   
	       out.println("<td><font color='#CCFFCC'><strong>"+rsFee.getString("NAME")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+"CUSTOMS CHARGE"+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("INITIAL_PICKUP_DATE")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("CUST_PO_NUMBER")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("ORDER_NUMBER")+"</strong></font></td>");
		   out.println("</tr>");
		   out.println("</table>");
						  
		}
		// 判斷若運費有輸入,則新增一筆運費並更新總金額.
		if (freightCharge!=null && !freightCharge.equals(""))
		{
		   freightChargef = Float.parseFloat(freightCharge); 
		   netInvoiceValuef = freightChargef + rsFee.getFloat("NET_INVOICE_VALUE");
		   vatf = netInvoiceValuef*0;
		   totAmountf = netInvoiceValuef + vatf;
		   
           miscellaneousBean.setRoundDigit(2);
           freightCharge = miscellaneousBean.getFloatRoundStr(freightChargef);
		   netInvoiceValue = miscellaneousBean.getFloatRoundStr(netInvoiceValuef);
		   miscellaneousBean.setRoundDigit(3);
		   totAmount = miscellaneousBean.getFloatRoundStr(totAmountf); 
		   
		   freightChargef = Float.parseFloat(freightCharge);
		   netInvoiceValuef = Float.parseFloat(netInvoiceValue);
		   totAmountf = Float.parseFloat(totAmount);
		   String sqlI2 = "insert into DAPHNE_INVOICE_OTHER "+
		                  "values ('"+invoiceNo+"','FREIGHT CHARGE',TO_DATE('"+rsFee.getDate("INITIAL_PICKUP_DATE1")+"','yyyy/mm/dd'),"+
						  "TO_DATE('"+rsFee.getDate("DELIVERY_DATE1")+"','yyyy/mm/dd'),null,null,null,'"+rsFee.getString("CURRENCY_CODE")+"','"+freightChargef+"','"+netInvoiceValuef+"','"+vatf+"','"+totAmount+"','"+rsFee.getString("FOB_POINT_CODE")+"','"+rsFee.getString("SHIPPING_METHOD_CODE")+"','"+rsFee.getString("TERMS")+"',null,'"+rsFee.getString("CUSTOMER_NAME")+"','"+rsFee.getString("TAX_REFERENCE")+"',null,'"+rsFee.getString("TAX_CODE")+"','"+rsFee.getString("PACKING_INSTRUCTIONS")+"','"+rsFee.getString("DELIVERTO_ADDRESSEE")+"','"+rsFee.getString("DELIVERTO_CITY")+"','"+rsFee.getString("DELIVERTO_POSTAL_CODE")+"','"+rsFee.getString("DELIVERTO_COUNTRY")+"','"+rsFee.getString("BILLTO_ADDRESSEE")+"','"+rsFee.getString("BILLTO_CITY")+"','"+rsFee.getString("BILLTO_POSTALCODE")+"','"+rsFee.getString("BILLTO_COUNTRY")+"',null,null,null,"+
						  "'"+rsFee.getString("FLAG")+"','"+rsFee.getString("ORDER_NUMBER")+"','"+rsFee.getString("FROMM")+"','"+rsFee.getString("DOCU")+"',"+
						  "'"+rsFee.getString("HEADER_ID")+"','"+rsFee.getString("SALES_PERSON")+"')";
		   PreparedStatement pstmtI2=con.prepareStatement(sqlI2);						  		  
	       pstmtI2.executeUpdate();
	       pstmtI2.close();
		   
		   String sqlU2 = "update DAPHNE_INVOICE_OTHER set NET_INVOICE_VALUE = '"+netInvoiceValue+"',VAT = '"+vat+"',TOTAL_AMOUNT='"+totAmount+"' where NAME='"+invoiceNo+"'" ;
		   PreparedStatement pstmtU2=con.prepareStatement(sqlU2);				  		  
	       pstmtU2.executeUpdate();
	       pstmtU2.close();
		   
		   out.println("<BR>");
		   out.println("<table width='70%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#999999' bordercolordark='#FFFFFF'>");
		   out.println("<tr bgcolor='#339999'><td><font color='#CCFFCC'><strong>發票號碼</strong></font></td><td><font color='#CCFFCC'><strong>運費</strong></font></td><td><font color='#CCFFCC'><strong>PICKUP DATE</strong></font><td><font color='#CCFFCC'><strong>客戶PO號</strong></font></td><td><font color='#CCFFCC'><strong>訂單號</strong></font></td></tr>");
		   out.println("<tr bgcolor='#339999'>");   
	       out.println("<td><font color='#CCFFCC'><strong>"+rsFee.getString("NAME")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+"FREIGHT CHARGE"+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("INITIAL_PICKUP_DATE")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("CUST_PO_NUMBER")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("ORDER_NUMBER")+"</strong></font></td>");
		   out.println("</tr>");
		   out.println("</table>");
		
		}
		// 判斷若站板費有輸入,則新增一筆站板費並更新總金額.
		if (palletCharge!=null && !palletCharge.equals(""))
		{
		   palletChargef = Float.parseFloat(palletCharge); 
		   netInvoiceValuef = palletChargef + rsFee.getFloat("NET_INVOICE_VALUE");
		   vatf = netInvoiceValuef*0;
		   totAmountf = netInvoiceValuef + vatf;
		   
           miscellaneousBean.setRoundDigit(2);
           palletCharge = miscellaneousBean.getFloatRoundStr(palletChargef);
		   netInvoiceValue = miscellaneousBean.getFloatRoundStr(netInvoiceValuef);
		   miscellaneousBean.setRoundDigit(3);
		   totAmount = miscellaneousBean.getFloatRoundStr(totAmountf); 
		   
		   palletChargef = Float.parseFloat(palletCharge);
		   netInvoiceValuef = Float.parseFloat(netInvoiceValue);
		   totAmountf = Float.parseFloat(totAmount);
		   String sqlI3 = "insert into DAPHNE_INVOICE_OTHER "+
		                  "values ('"+invoiceNo+"','PALLETISED CHARGE',TO_DATE('"+rsFee.getDate("INITIAL_PICKUP_DATE1")+"','yyyy/mm/dd'),"+
						  "TO_DATE('"+rsFee.getDate("DELIVERY_DATE1")+"','yyyy/mm/dd'),null,null,null,'"+rsFee.getString("CURRENCY_CODE")+"','"+palletChargef+"','"+netInvoiceValuef+"','"+vatf+"','"+totAmount+"','"+rsFee.getString("FOB_POINT_CODE")+"','"+rsFee.getString("SHIPPING_METHOD_CODE")+"','"+rsFee.getString("TERMS")+"',null,'"+rsFee.getString("CUSTOMER_NAME")+"','"+rsFee.getString("TAX_REFERENCE")+"',null,'"+rsFee.getString("TAX_CODE")+"','"+rsFee.getString("PACKING_INSTRUCTIONS")+"','"+rsFee.getString("DELIVERTO_ADDRESSEE")+"','"+rsFee.getString("DELIVERTO_CITY")+"','"+rsFee.getString("DELIVERTO_POSTAL_CODE")+"','"+rsFee.getString("DELIVERTO_COUNTRY")+"','"+rsFee.getString("BILLTO_ADDRESSEE")+"','"+rsFee.getString("BILLTO_CITY")+"','"+rsFee.getString("BILLTO_POSTALCODE")+"','"+rsFee.getString("BILLTO_COUNTRY")+"',null,null,null,"+
						  "'"+rsFee.getString("FLAG")+"','"+rsFee.getString("ORDER_NUMBER")+"','"+rsFee.getString("FROMM")+"','"+rsFee.getString("DOCU")+"',"+
						  "'"+rsFee.getString("HEADER_ID")+"','"+rsFee.getString("SALES_PERSON")+"')";
		   PreparedStatement pstmtI3=con.prepareStatement(sqlI3);						  		  
	       pstmtI3.executeUpdate();
	       pstmtI3.close();
		   
		   String sqlU3 = "update DAPHNE_INVOICE_OTHER set NET_INVOICE_VALUE = '"+netInvoiceValue+"',VAT = '"+vat+"',TOTAL_AMOUNT='"+totAmount+"' where NAME='"+invoiceNo+"'" ;
		   PreparedStatement pstmtU3=con.prepareStatement(sqlU3);				  		  
	       pstmtU3.executeUpdate();
	       pstmtU3.close();
		   
		   out.println("<BR>");
		   out.println("<table width='70%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#999999' bordercolordark='#FFFFFF'>");
		   out.println("<tr bgcolor='#339999'><td><font color='#CCFFCC'><strong>發票號碼</strong></font></td><td><font color='#CCFFCC'><strong>站板費用</strong></font></td><td><font color='#CCFFCC'><strong>PICKUP DATE</strong></font><td><font color='#CCFFCC'><strong>客戶PO號</strong></font></td><td><font color='#CCFFCC'><strong>訂單號</strong></font></td></tr>");
		   out.println("<tr bgcolor='#339999'>");   
	       out.println("<td><font color='#CCFFCC'><strong>"+rsFee.getString("NAME")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+"PALLETISED CHARGE"+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("INITIAL_PICKUP_DATE")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("CUST_PO_NUMBER")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("ORDER_NUMBER")+"</strong></font></td>");
		   out.println("</tr>");
		   out.println("</table>");
		}
		// 判斷若保險費有輸入,則新增一筆保險費並更新總金額.
		if (insuranceCharge!=null && !insuranceCharge.equals(""))
		{
		   insuranceChargef = Float.parseFloat(insuranceCharge); 
		   netInvoiceValuef = insuranceChargef + rsFee.getFloat("NET_INVOICE_VALUE");
		   vatf = netInvoiceValuef*0;
		   totAmountf = netInvoiceValuef + vatf;
		   
           miscellaneousBean.setRoundDigit(2);
           insuranceCharge = miscellaneousBean.getFloatRoundStr(insuranceChargef);
		   netInvoiceValue = miscellaneousBean.getFloatRoundStr(netInvoiceValuef);
		   miscellaneousBean.setRoundDigit(3);
		   totAmount = miscellaneousBean.getFloatRoundStr(totAmountf); 
		   
		   insuranceChargef = Float.parseFloat(insuranceCharge);
		   netInvoiceValuef = Float.parseFloat(netInvoiceValue);
		   totAmountf = Float.parseFloat(totAmount);
		   String sqlI4 = "insert into DAPHNE_INVOICE_OTHER "+
		                  "values ('"+invoiceNo+"','INSURANCE CHARGE',TO_DATE('"+rsFee.getDate("INITIAL_PICKUP_DATE1")+"','yyyy/mm/dd'),"+
						  "TO_DATE('"+rsFee.getDate("DELIVERY_DATE1")+"','yyyy/mm/dd'),null,null,null,'"+rsFee.getString("CURRENCY_CODE")+"','"+insuranceChargef+"','"+netInvoiceValuef+"','"+vatf+"','"+totAmount+"','"+rsFee.getString("FOB_POINT_CODE")+"','"+rsFee.getString("SHIPPING_METHOD_CODE")+"','"+rsFee.getString("TERMS")+"',null,'"+rsFee.getString("CUSTOMER_NAME")+"','"+rsFee.getString("TAX_REFERENCE")+"',null,'"+rsFee.getString("TAX_CODE")+"','"+rsFee.getString("PACKING_INSTRUCTIONS")+"','"+rsFee.getString("DELIVERTO_ADDRESSEE")+"','"+rsFee.getString("DELIVERTO_CITY")+"','"+rsFee.getString("DELIVERTO_POSTAL_CODE")+"','"+rsFee.getString("DELIVERTO_COUNTRY")+"','"+rsFee.getString("BILLTO_ADDRESSEE")+"','"+rsFee.getString("BILLTO_CITY")+"','"+rsFee.getString("BILLTO_POSTALCODE")+"','"+rsFee.getString("BILLTO_COUNTRY")+"',null,null,null,"+
						  "'"+rsFee.getString("FLAG")+"','"+rsFee.getString("ORDER_NUMBER")+"','"+rsFee.getString("FROMM")+"','"+rsFee.getString("DOCU")+"',"+
						  "'"+rsFee.getString("HEADER_ID")+"','"+rsFee.getString("SALES_PERSON")+"')";
		   PreparedStatement pstmtI4=con.prepareStatement(sqlI4);						  		  
	       pstmtI4.executeUpdate();
	       pstmtI4.close();
		   
		   String sqlU4 = "update DAPHNE_INVOICE_OTHER set NET_INVOICE_VALUE = '"+netInvoiceValue+"',VAT = '"+vat+"',TOTAL_AMOUNT='"+totAmount+"' where NAME='"+invoiceNo+"'" ;
		   PreparedStatement pstmtU4=con.prepareStatement(sqlU4);				  		  
	       pstmtU4.executeUpdate();
	       pstmtU4.close();
		   
		   out.println("<BR>");
		   out.println("<table width='70%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#999999' bordercolordark='#FFFFFF'>");
		   out.println("<tr bgcolor='#339999'><td><font color='#CCFFCC'><strong>發票號碼</strong></font></td><td><font color='#CCFFCC'><strong>保險費</strong></font></td><td><font color='#CCFFCC'><strong>PICKUP DATE</strong></font><td><font color='#CCFFCC'><strong>客戶PO號</strong></font></td><td><font color='#CCFFCC'><strong>訂單號</strong></font></td></tr>");
		   out.println("<tr bgcolor='#339999'>");   
	       out.println("<td><font color='#CCFFCC'><strong>"+rsFee.getString("NAME")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+"INSURANCE CHARGE"+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("INITIAL_PICKUP_DATE")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("CUST_PO_NUMBER")+"</strong></font></td><td><font color='#CCFFCC'><strong>"+rsFee.getString("ORDER_NUMBER")+"</strong></font></td>");
		   out.println("</tr>");
		   out.println("</table>");
		}
		// 判斷若服務費用有輸入,則新增一筆服務費用並更新總金額.
		
    }  // End of if (rsFee.next()) Step4. End.
	rsFee.close();

// Step 5. 更新DELIVER POSTAL CODE的LAST NAME及FIRST NAME
          String sqlPostal="select NVL(DELIVERTO_POSTAL_CODE,'NULL') DELIVERTO_POSTAL_CODE, DOCU "+
		                   "from DAPHNE_INVOICE_OTHER where name='"+invoiceNo+"'" ;  
		  ResultSet rsPostal=statementTC.executeQuery(sqlPostal); 
		  if (rsPostal.next())    
		  {
		   // 若DELIVERTO_POSTAL_CODE不為空白
		   if (rsPostal.getString("DELIVERTO_POSTAL_CODE")!=null && !rsPostal.getString("DELIVERTO_POSTAL_CODE").equals(""))
		   {
		      sql = "SELECT NVL(AC.LAST_NAME,'NULL') LAST_NAME, AC.FIRST_NAME "+
			        "FROM AR_CONTACTS_V AC "+
					"WHERE AC.ORIG_SYSTEM_REFERENCE='"+rsPostal.getString("DELIVERTO_POSTAL_CODE")+"'";
		      ResultSet rsCont=statementTC.executeQuery(sql); 
			  if (rsCont.next())
			  {			         
			     String sqlU5 = "update DAPHNE_INVOICE_OTHER set LAST_NAME='"+rsCont.getString("LAST_NAME")+"',FIRST_NAME='" +rsCont.getString("FIRST_NAME")+"' "+
				                "where  name='"+invoiceNo+"'";
		         PreparedStatement pstmtU5=con.prepareStatement(sqlU5);				  		  
	             pstmtU5.executeUpdate();
	             pstmtU5.close();
			  }
			  rsCont.close();
		   }
		   
		  } // End of if (rsPostal.next())
		  rsPostal.close();
		  
// Step6. 更新 Shipping Mark
  if (longText != null && !longText.equals(""))  // 若由客戶檔訂單表頭可得ShipMark資料,則以訂單表頭為主.
  {
     shipMark = longText;   
  } 
  
/*
  String sqlU6="update DAPHNE_INVOICE_OTHER set DOCU='"+shipMark+"' where NAME='"+invoiceNo+"'";     
  PreparedStatement pstmtU6=con.prepareStatement(sqlU6);				  		  
  pstmtU6.executeUpdate();
  pstmtU6.close();
*/
  
//
	 
	 statementTC.close();  // 關閉 Statement 敘述
	 
	 
	 
// Step7. 資料產生完成,可選擇直接重新轉向至列印頁面

  //  response.sendRedirect("http://intranet.ts.com.tw/joetest/other/otherindex2.asp?invoice_no="+invoiceNo); 
	 
%>
<%
      if (bolInvExists==true)
	  {
%>
<table>
  <tr bgcolor="#339999">
     <td colspan="2">
	     <div align="center"><font color="#FFFF00"><strong>Please Input Shipping Mark</strong></font><textarea name="SHIPMARK" cols="50" rows="5" ><%=shipMark%></textarea></div>  
	 </td>
  </tr>
</table>

<input name="submit1" type="button"  value="檢視發票" onClick='return sendWindowOpen("../jsp/TscOtherInvoiceCreatePreview.jsp?=<%=invoiceNo%>")'>
<%
      }
%>
<% //-- 表單參數 %>
<input type="hidden" name="INVOICENO" value="<%=invoiceNo%>">
</FORM>
</body>
<!--=============¢FDH?U¢FXI?q?¢FXAAcn3s¢Gg2|A==========-->
<!--%@ include file="/jsp/include/ReleaseConnTest2Page.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
