<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="DateBean,SendMailBean,WorkingDateBean,CodeUtil,WriteLogToFileBean" %>
<html>
<head>
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
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
</head>

<body>
<%
    String userMail=null;
	String UserID=null;
	String urAddress=null;
	String getWebID = null;
	String serverHostName=request.getServerName();
	String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
	
	int batchCnt = 0; 
	int recordCnt = 1;
	
	 writeLogToFileBean.setTextString("<table cellSpacing='0' bordercolordark='#D8DEA9'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>");
	 System.out.println(writeLogToFileBean.getTextString());  
	
	//  找RCV_INTERFACE內屬 SEA(C) 且未經 BRANCH CONFIRM的資料找出,並等待寫入客制RCV_TRANSACTION_INTERFACE清單
	 String sSqlRCV = "select a.*, b.ORDER_NUMBER, c.LINE_NUMBER from RCV_TRANSACTIONS_INTERFACE a, OE_ORDER_HEADERS_ALL b, OE_ORDER_LINES_ALL c "+
	                  "where a.TRANSACTION_TYPE = 'RECEIVE' and a.OE_ORDER_HEADER_ID = b.HEADER_ID and a.OE_ORDER_LINE_ID = c.LINE_ID and b.HEADER_ID = b.HEADER_ID "+
	                  "  and a.PACKING_SLIP in (select trim(INVOICE_NO) from TSC_INVOICE_HEADERS where SHIPPING_METHOD_CODE = 'SEA(C)' and STATUS ='30') "+
					  "  and a.INTERFACE_TRANSACTION_ID not in ( select INTERFACE_TRANSACTION_ID from TSC_RCV_TRANSACTIONS_INTERFACE ) "; // 已經轉進TSC表內的不重轉 //
     //out.println(sSqlRCV);
	 Statement stmentRCV=con.createStatement();
     ResultSet rsRCV=stmentRCV.executeQuery(sSqlRCV);
	 while (rsRCV.next())
	 {
	    if (batchCnt==0) // 取成功批號,當第一筆成功寫入出現時
        { 
		   writeLogToFileBean.setTextString("<tr bgcolor='#FFFFCC'><td colspan='10' bgcolor='#000099'><font color='#FFFFFF' size=2>("+dateBean.getYearMonthDay()+")成功卡SEA(C)項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366' size=2><strong>INTERFACE_TRANSACTION_ID</strong></font></td><td><font size=2>LAST_UPDATE_DATE</font></td><td><font size=2>LAST_UPDATED_BY</font></td><td><font size=2>TRANSACTION_DATE</font></td><td><font size=2>TRANSACTION_TYPE</font></td><td><font size=2>PRIMARY_QUANTITY</font></td><td><font size=2>PACKING_SLIP</font></td><td><font size=2>ORDER_HEADER</font></td><td><font size=2>ORDER_LINE</font></td></tr>");
		   System.out.println(writeLogToFileBean.getTextString());
		   batchCnt++;   // 取成功入帳BPCS 批號,當第一筆成功寫入出現時 
        } // end of if (batchCnt =0 ) 取成功入帳BPCS 批號,當第一筆成功寫入出現時	
					     
		   
		   writeLogToFileBean.setTextString("<TR bgcolor='#FFFFCC'><TD><font color='#000099' size=2>"+recordCnt+
           "</font></TD><TD><font color='#CC3366' size=2><strong>"+rsRCV.getString("INTERFACE_TRANSACTION_ID")+"</strong></font></TD>"+"<TD><font size=2>"+rsRCV.getString("LAST_UPDATE_DATE")+"</font></TD>"+"<TD><font size=2>"+rsRCV.getString("LAST_UPDATED_BY")+"</font></TD>"+"<TD><font size=2>"+rsRCV.getString("TRANSACTION_DATE")+"</font></TD>"+"<TD><font size=2>"+rsRCV.getString("TRANSACTION_TYPE")+"</font></TD>"+"<TD><font size=2>"+rsRCV.getString("PRIMARY_QUANTITY")+"</font></TD>"+"<TD><font size=2>"+rsRCV.getString("PACKING_SLIP")+"</font></TD>"+"<TD><font size=2>"+rsRCV.getString("ORDER_NUMBER")+"("+rsRCV.getString("OE_ORDER_HEADER_ID")+")"+"</font></TD>"+"<TD><font size=2>"+rsRCV.getString("LINE_NUMBER")+"("+rsRCV.getString("OE_ORDER_LINE_ID")+")"+"</font></TD>"+"</TR>");
		   System.out.println(writeLogToFileBean.getTextString());
		   
	   recordCnt++; // 計算更新筆數	   
	 } // End of While 
	 rsRCV.close();
	 stmentRCV.close();
	 
	 writeLogToFileBean.setTextString("</table>");
	 out.println(writeLogToFileBean.getTextString());
	 
	 // 設定存檔路徑並存檔
    writeLogToFileBean.setFileName("D:/resin-2.1.9/webapps/oradds/LogFile/TSC_RCV_INTERFACE_SEA(C)_"+dateBean.getYearMonthDay()+".html");
    writeLogToFileBean.StrSaveToFile();
	 
	 String sSqlINT = "select a.* from RCV_TRANSACTIONS_INTERFACE a where a.TRANSACTION_TYPE = 'RECEIVE' "+
	                        "  and a.PACKING_SLIP in (select trim(INVOICE_NO) from TSC_INVOICE_HEADERS where SHIPPING_METHOD_CODE ='SEA(C)' and STATUS ='30') "+
							"  and a.INTERFACE_TRANSACTION_ID not in ( select INTERFACE_TRANSACTION_ID from TSC_RCV_TRANSACTIONS_INTERFACE ) "; // 已經轉進TSC表內的不重轉 //
     //out.println(sSqlINT);
	 Statement stmentINT=con.createStatement();
	 ResultSet rsINT=stmentINT.executeQuery(sSqlRCV);
	 if (rsINT.next())
	 {
	         String sqlInsert = "insert into APPS.TSC_RCV_TRANSACTIONS_INTERFACE(INTERFACE_TRANSACTION_ID , GROUP_ID , LAST_UPDATE_DATE , LAST_UPDATED_BY , CREATION_DATE , CREATED_BY , LAST_UPDATE_LOGIN ,"+
			                                                                    " REQUEST_ID , PROGRAM_APPLICATION_ID , PROGRAM_ID , PROGRAM_UPDATE_DATE , TRANSACTION_TYPE , TRANSACTION_DATE , PROCESSING_STATUS_CODE , "+
																				" PROCESSING_MODE_CODE , PROCESSING_REQUEST_ID , TRANSACTION_STATUS_CODE , CATEGORY_ID , QUANTITY , UNIT_OF_MEASURE , INTERFACE_SOURCE_CODE , "+
																				" INTERFACE_SOURCE_LINE_ID , INV_TRANSACTION_ID , ITEM_ID , ITEM_DESCRIPTION , ITEM_REVISION , UOM_CODE , EMPLOYEE_ID , AUTO_TRANSACT_CODE , "+
																				" SHIPMENT_HEADER_ID , SHIPMENT_LINE_ID , SHIP_TO_LOCATION_ID , PRIMARY_QUANTITY , PRIMARY_UNIT_OF_MEASURE , RECEIPT_SOURCE_CODE , VENDOR_ID , "+
																				" VENDOR_SITE_ID , FROM_ORGANIZATION_ID , FROM_SUBINVENTORY , TO_ORGANIZATION_ID , INTRANSIT_OWNING_ORG_ID , ROUTING_HEADER_ID , ROUTING_STEP_ID , "+
																				" SOURCE_DOCUMENT_CODE , PARENT_TRANSACTION_ID , PO_HEADER_ID , PO_REVISION_NUM , PO_RELEASE_ID , PO_LINE_ID , PO_LINE_LOCATION_ID , PO_UNIT_PRICE ,"+
																				" CURRENCY_CODE , CURRENCY_CONVERSION_TYPE , CURRENCY_CONVERSION_RATE , CURRENCY_CONVERSION_DATE , PO_DISTRIBUTION_ID , REQUISITION_LINE_ID , "+
																				" REQ_DISTRIBUTION_ID , CHARGE_ACCOUNT_ID , SUBSTITUTE_UNORDERED_CODE , RECEIPT_EXCEPTION_FLAG , ACCRUAL_STATUS_CODE , INSPECTION_STATUS_CODE , "+
																				" INSPECTION_QUALITY_CODE , DESTINATION_TYPE_CODE , DELIVER_TO_PERSON_ID , LOCATION_ID , DELIVER_TO_LOCATION_ID , SUBINVENTORY , LOCATOR_ID , "+
																				" WIP_ENTITY_ID , WIP_LINE_ID , DEPARTMENT_CODE , WIP_REPETITIVE_SCHEDULE_ID , WIP_OPERATION_SEQ_NUM , WIP_RESOURCE_SEQ_NUM , BOM_RESOURCE_ID , "+
																				" SHIPMENT_NUM , FREIGHT_CARRIER_CODE , BILL_OF_LADING , PACKING_SLIP , SHIPPED_DATE , EXPECTED_RECEIPT_DATE , ACTUAL_COST , TRANSFER_COST , "+
																				" TRANSPORTATION_COST , TRANSPORTATION_ACCOUNT_ID , NUM_OF_CONTAINERS , WAYBILL_AIRBILL_NUM , VENDOR_ITEM_NUM , VENDOR_LOT_NUM , RMA_REFERENCE , "+
																				" COMMENTS , ATTRIBUTE_CATEGORY , ATTRIBUTE1 , ATTRIBUTE2 , ATTRIBUTE3 , ATTRIBUTE4 , ATTRIBUTE5 , ATTRIBUTE6 , ATTRIBUTE7 , ATTRIBUTE8 , ATTRIBUTE9 , "+
																				" ATTRIBUTE10 , ATTRIBUTE11 , ATTRIBUTE12 , ATTRIBUTE13 , ATTRIBUTE14 , ATTRIBUTE15 , SHIP_HEAD_ATTRIBUTE_CATEGORY , SHIP_HEAD_ATTRIBUTE1 , SHIP_HEAD_ATTRIBUTE2 , "+
																				" SHIP_HEAD_ATTRIBUTE3 , SHIP_HEAD_ATTRIBUTE4 , SHIP_HEAD_ATTRIBUTE5 , SHIP_HEAD_ATTRIBUTE6 , SHIP_HEAD_ATTRIBUTE7 , SHIP_HEAD_ATTRIBUTE8 , SHIP_HEAD_ATTRIBUTE9 , "+
																				" SHIP_HEAD_ATTRIBUTE10 , SHIP_HEAD_ATTRIBUTE11 , SHIP_HEAD_ATTRIBUTE12 , SHIP_HEAD_ATTRIBUTE13 , SHIP_HEAD_ATTRIBUTE14 , SHIP_HEAD_ATTRIBUTE15 , "+
																				" SHIP_LINE_ATTRIBUTE_CATEGORY , SHIP_LINE_ATTRIBUTE1 , SHIP_LINE_ATTRIBUTE2 , SHIP_LINE_ATTRIBUTE3 , SHIP_LINE_ATTRIBUTE4 , SHIP_LINE_ATTRIBUTE5 , "+
																				" SHIP_LINE_ATTRIBUTE6 , SHIP_LINE_ATTRIBUTE7 , SHIP_LINE_ATTRIBUTE8 , SHIP_LINE_ATTRIBUTE9 , SHIP_LINE_ATTRIBUTE10 , SHIP_LINE_ATTRIBUTE11 , "+
																				" SHIP_LINE_ATTRIBUTE12 , SHIP_LINE_ATTRIBUTE13 , SHIP_LINE_ATTRIBUTE14 , SHIP_LINE_ATTRIBUTE15 , USSGL_TRANSACTION_CODE , GOVERNMENT_CONTEXT , "+
																				" REASON_ID , DESTINATION_CONTEXT , SOURCE_DOC_QUANTITY , SOURCE_DOC_UNIT_OF_MEASURE , MOVEMENT_ID , HEADER_INTERFACE_ID , VENDOR_CUM_SHIPPED_QTY , "+
																				" ITEM_NUM , DOCUMENT_NUM , DOCUMENT_LINE_NUM , TRUCK_NUM , SHIP_TO_LOCATION_CODE , CONTAINER_NUM , SUBSTITUTE_ITEM_NUM , NOTICE_UNIT_PRICE , "+
																				" ITEM_CATEGORY , LOCATION_CODE , VENDOR_NAME , VENDOR_NUM , VENDOR_SITE_CODE , FROM_ORGANIZATION_CODE , TO_ORGANIZATION_CODE , INTRANSIT_OWNING_ORG_CODE , "+
																				" ROUTING_CODE , ROUTING_STEP , RELEASE_NUM , DOCUMENT_SHIPMENT_LINE_NUM , DOCUMENT_DISTRIBUTION_NUM , DELIVER_TO_PERSON_NAME , DELIVER_TO_LOCATION_CODE , "+
																				" USE_MTL_LOT , USE_MTL_SERIAL , LOCATOR , REASON_NAME , VALIDATION_FLAG , SUBSTITUTE_ITEM_ID , QUANTITY_SHIPPED , QUANTITY_INVOICED , TAX_NAME , "+
																				" TAX_AMOUNT , REQ_NUM , REQ_LINE_NUM , REQ_DISTRIBUTION_NUM , WIP_ENTITY_NAME , WIP_LINE_CODE , RESOURCE_CODE , SHIPMENT_LINE_STATUS_CODE , BARCODE_LABEL , "+
																				" TRANSFER_PERCENTAGE , QA_COLLECTION_ID , COUNTRY_OF_ORIGIN_CODE , OE_ORDER_HEADER_ID , OE_ORDER_LINE_ID , CUSTOMER_ID , CUSTOMER_SITE_ID , CUSTOMER_ITEM_NUM , "+
																				" CREATE_DEBIT_MEMO_FLAG , PUT_AWAY_RULE_ID , PUT_AWAY_STRATEGY_ID , LPN_ID , TRANSFER_LPN_ID , COST_GROUP_ID , MOBILE_TXN , MMTT_TEMP_ID , TRANSFER_COST_GROUP_ID , "+
																				" SECONDARY_QUANTITY , SECONDARY_UNIT_OF_MEASURE , SECONDARY_UOM_CODE , QC_GRADE , FROM_LOCATOR , FROM_LOCATOR_ID , PARENT_SOURCE_TRANSACTION_NUM , INTERFACE_AVAILABLE_QTY , "+
																				" INTERFACE_TRANSACTION_QTY , INTERFACE_AVAILABLE_AMT , INTERFACE_TRANSACTION_AMT , LICENSE_PLATE_NUMBER , SOURCE_TRANSACTION_NUM , TRANSFER_LICENSE_PLATE_NUMBER , "+
																				" LPN_GROUP_ID , ORDER_TRANSACTION_ID , CUSTOMER_ACCOUNT_NUMBER , CUSTOMER_PARTY_NAME , OE_ORDER_LINE_NUM , OE_ORDER_NUM , PARENT_INTERFACE_TXN_ID , CUSTOMER_ITEM_ID , "+
																				"  AMOUNT , JOB_ID , TIMECARD_ID , TIMECARD_OVN , ERECORD_ID , PROJECT_ID , TASK_ID , ASN_ATTACH_ID, "+
																				" J_CREATED_BY, J_CREATION_DATE, J_LAST_UPDATED_BY, J_LAST_UPDATE_DATE, STATUS, STATUSID "+
			                                                                    ") "+
			                     "select a.*, 'kerwin', to_char(SYSDATE,'YYYYMMDDHH24MISS'), 'kerwin',to_char(SYSDATE,'YYYYMMDDHH24MISS'), 'OPEN', '080' from RCV_TRANSACTIONS_INTERFACE a "+
			                     " where a.TRANSACTION_TYPE = 'RECEIVE' and a.PACKING_SLIP in (select trim(INVOICE_NO) from TSC_INVOICE_HEADERS where SHIPPING_METHOD_CODE = 'SEA(C)' and STATUS ='30') "+
								 "   and a.INTERFACE_TRANSACTION_ID not in ( select INTERFACE_TRANSACTION_ID from TSC_RCV_TRANSACTIONS_INTERFACE ) "; // 已經轉進TSC表內的不重轉 //
	         PreparedStatement pstmt=con.prepareStatement(sqlInsert);			
		     pstmt.executeUpdate(); 
             pstmt.close();
			 
			 String strFirstDayWeek = dateBean.getYearMonthDay();	 
     
          // 找到若有卡住的資料,先搬到TSC_RCV_TRANSACTIONS_INTERFACE
             String sSqlMailUser = "select DISTINCT USERMAIL,USERNAME,WEBID from ORADDMAN.WSUSER where LOCKFLAG='N' and USERNAME in ('kerwin','suming','jingker') ";
	         //out.println(sSqlMailUser);
	         Statement stmentMail=con.createStatement();
             ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	         while(rsMail.next())
	         {
	             // 再找 當日有卡住的內容統知我自己名單發E-Mail	  
	             try 
                 {	     
		  
                  sendMailBean.setMailHost(mailHost);					  
	              userMail=rsMail.getString("USERMAIL");
		          UserID = rsMail.getString("USERNAME");		
		          getWebID = rsMail.getString("WEBID");   
		          urAddress = serverHostName+":8080/oradds/LogFile/TSC_RCV_INTERFACE_SEA(C)_"+dateBean.getYearMonthDay()+".html";		
                  sendMailBean.setReception(userMail);
                  sendMailBean.setFrom(UserID);     
                  //   sendMailBean.setSubject(CodeUtil.unicodeToBig5("來自ORACLE系統的郵件:每週料件分類設定異常檢核表-("+strFirstDayWeek+"~"+strLastDayWeek+")")); 
		          sendMailBean.setSubject(CodeUtil.unicodeToBig5("RFQ System E-Mail- 每日寫入1152卡SEA(C)介面表明細("+strFirstDayWeek+")"));         
		          sendMailBean.setUrlName("Dear "+UserID+",\n"+CodeUtil.unicodeToBig5("   請點擊來自發票延遲出貨系統的郵件:每日寫入1152卡SEA(C)介面表明細-("+strFirstDayWeek+")"));     
		          System.out.println("UserID="+UserID);
	              sendMailBean.setUrlAddr(urAddress);
		          System.out.println("userMail="+userMail);
                  sendMailBean.sendMail();
		
		         } //end of try
                 catch (Exception e)
                 {
                   e.printStackTrace();
                   out.println(e.getMessage());
                 }//end of catch			
		  
             } // End of while
	         stmentMail.close();
	         rsMail.close();			 
			 
	 }
	 rsINT.close();
	 stmentINT.close();
	
	//			
	workingDateBean.setAdjWeek(1);  // 把週別調整回來

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>



