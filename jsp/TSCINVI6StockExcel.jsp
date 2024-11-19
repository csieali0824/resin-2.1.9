<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.write.*,jxl.format.*,java.text.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean,DateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function popMenuMsg(clkDesc)
{
 alert(clkDesc);
}
</script>
<STYLE TYPE='text/css'>  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
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
<title>Stock Detail Data</title>
</head>
<body>
<FORM ACTION="../jsp/TSCINVI6StockDetail.jsp" METHOD="post" NAME="MYFORM">
<A HREF="/oradds/ORADDSMainMenu.jsp">Home <div align="right"><a href="JavaScript:self.close()">Closed Windows
</div></A>
<% 
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  //  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   //  
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 
  String currentWeek = workingDateBean.getWeekString();

  String itemId=request.getParameter("ITEM_ID");
  String item=request.getParameter("ITEM");
  String subInv=request.getParameter("SUBINV");
  String subItemId=request.getParameter("SUB_ITEM_ID");
  String organizationId=request.getParameter("ORGANIZATION_ID");
  String orgId=request.getParameter("ORG_ID");
  String typeId=request.getParameter("TYPEID");   //typeid 0=item mmt 1=1213未交    2=1211未交  ,3=I1 訂單未交,4= query all
  String conZero=request.getParameter("CONTZERO");
  String Stock=request.getParameter("Stock");
  if (conZero==null) conZero="N";
  String invItem="",itemDesc="",groupArea="",hub="",custName="",orderNo="",orderDate="",schDate="",orderQty="",itemUom="KPC";
  String txnType="",docNo="",sourceCode="",sourceLineId="",invoiceNo="",originalNo="",packingList="";
  float orderQtyf=0,sumQtyf=0;

  String serverHostName=request.getServerName();
  String ymdCurr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
  String hmsCurr = dateBean.getHourMinuteSecond();
  String strHMSec = request.getParameter("HOURTIME");


  String conti="N";
  int k=1;
  
//out.print("<br> itemd="+itemId+"  org="+organizationId+" type="+typeId);

if (typeId=="0" || typeId.equals("0"))  //typeid=0  //MMT EXPORT
{ 
  try
  {  

    if( organizationId == "326" || organizationId.equals("326"))
     {    
       //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('325')}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '325')}");
	   cs1.execute();
       cs1.close();
      }
    else
     {    
       //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	   cs1.execute();
       cs1.close();
      }

    String sqla = " SELECT   mmt.transaction_id, mmt.item_ord, mmt.description,to_char(trunc(mmt.transaction_date),'yyyy/mm/dd') transaction_date,  "+
        		  //"          mmt.subinventory, mmt.transaction_type_name,mmt.primary_quantity, mmt.primary_uom_code, "+
				  "          mmt.subinventory, mmt.transaction_type_name,mmt.primary_quantity/case when primary_uom_code='PCE' THEN 1000 ELSE 1 END AS primary_quantity, 'KPC' primary_uom_code, "+
				  "          mmt.TRANSACTION_SOURCE_TYPE_NAME SOURCE_CODE, mmt.TRANSACTION_REFERENCE DOC_NO,mmt.source_line_id "+
   				  "   FROM mtl_txns_all_v mmt "+
             //     "  WHERE mmt.organization_id = "+organizationId+"  AND mmt.transaction_type_id != 52 and mmt.TRANSACTION_ACTION_ID!=24 "+
                 "  WHERE mmt.organization_id = "+organizationId+"  AND mmt.transaction_type_id != 52 and mmt.TRANSACTION_ACTION_ID not in (7,9,10,24)  "+		//20140318 liling modify		  
  				  "   AND mmt.inventory_item_id =  '"+itemId+"' AND mmt.subinventory = '"+subInv+"' "+
	 			  " ORDER BY mmt.transaction_date ";				 			   				   
	 
    //  sqla = sqla + where + orderBy;	

	OutputStream os = null;	
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
      os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/TSC_MMT_"+userID+"_"+hmsCurr+".xls");
	}  else { // For Windows Platform
	          os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\TSC_MMT_"+userID+"_"+hmsCurr+".xls");
	        }
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("DATA", 0); //-- TEST
	
	//jxl.Sheet ws = wwb.createSheet("Sales Delivery Request", 0);
	
	jxl.SheetSettings sst = ws.getSettings(); 
	
	//out.println("2<BR>");
   /*               */
    // 第二個Sheet ws2
    //jxl.write.WritableSheet ws2 = wwb.createSheet("Sales Delivery Record", 0);
    // 抬頭列字型15
	jxl.write.WritableFont wf2Title = new jxl.write.WritableFont(WritableFont.TIMES, 15,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Title = new jxl.write.WritableCellFormat(wf2Title); 
	wcf2Title.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    // 條件列字型12
    jxl.write.WritableFont wf2Cond = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Cond = new jxl.write.WritableCellFormat(wf2Cond); 
	wcf2Cond.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    // Header 列背景灰色
    jxl.write.WritableFont wf2Header = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(wf2Header); 
	wcf2Header.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    wcf2Header.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色
    // 內容 列 定義
    jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
	wcf2Content.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    //wcf2Content.setBackground(jxl.format.Colour.GRAY_25); // 	  
	
	jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
	wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    wcfT.setAlignment(jxl.format.Alignment.LEFT);
   /*                  */
	
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	//sst.setProtected(true);
	sst.setFitToPages(true);	
	sst.setFitWidth(1);  // 設定一頁寬
	//sst.setFitHeight(1);  // 設定一頁高
	//sst.setPassword("kerwin");

	//抬頭:(第6列第0行)		// 明細抬頭說明
	jxl.write.Label labelCF5 = new jxl.write.Label(0, 0, "LineNo", wcfT); // (行,列)
    ws.addCell(labelCF5);
	ws.setColumnView(0,5);
	
    jxl.write.Label labelC19 = new jxl.write.Label(1, 0, "ItemNo", wcfT); // (行,列)
    ws.addCell(labelC19);
	ws.setColumnView(1,25);		
	
	jxl.write.Label labelCFC4 = new jxl.write.Label(2, 0, "Description", wcfT); // (行,列)
    ws.addCell(labelCFC4);
	ws.setColumnView(2,20);	
	
	jxl.write.Label labelCFC6 = new jxl.write.Label(3, 0, "Transaction Date", wcfT); // (行,列)
    ws.addCell(labelCFC6);
	ws.setColumnView(3,11);
	
	//抬頭:(第6列第1行)
	jxl.write.Label labelCF7 = new jxl.write.Label(4, 0, "Subinventory", wcfT); // (行,列)
    ws.addCell(labelCF7);
	ws.setColumnView(4,5);
	//抬頭:(第6列第2行)
	jxl.write.Label labelCF8 = new jxl.write.Label(5, 0, "TransactionType", wcfT); // (行,列)
    ws.addCell(labelCF8);
	ws.setColumnView(5,18);
	//抬頭:(第6列第3行)
	jxl.write.Label labelCF9 = new jxl.write.Label(6, 0, "Doc No", wcfT); // (行,列)
    ws.addCell(labelCF9);
	ws.setColumnView(6,15);
	jxl.write.Label labelCF91 = new jxl.write.Label(7, 0, "Invoice No", wcfT); // (行,列)
    ws.addCell(labelCF91);
	ws.setColumnView(7,11);	
	jxl.write.Label labelCF911 = new jxl.write.Label(8, 0, "Customer Name", wcfT); // (行,列)
    ws.addCell(labelCF911);
	ws.setColumnView(8,11);	
	jxl.write.Label labelCF92 = new jxl.write.Label(9, 0, "Original INV#", wcfT); // (行,列)
    ws.addCell(labelCF92);
	ws.setColumnView(9,11);	
	jxl.write.Label labelCF93 = new jxl.write.Label(10, 0, "Packing List#", wcfT); // (行,列)
    ws.addCell(labelCF93);
	ws.setColumnView(10,11);			
	//抬頭:(第6列第4行)
	jxl.write.Label labelCFC10 = new jxl.write.Label(11, 0, "TransactionQty", wcfT); // (行,列)
    ws.addCell(labelCFC10);
	ws.setColumnView(11,8);
	//抬頭:(第6列第5行)
	jxl.write.Label labelCFC11 = new jxl.write.Label(12, 0, "UOM", wcfT); // (行,列)
    ws.addCell(labelCFC11);
	ws.setColumnView(12,6);
	//抬頭:(第6列第6行)
	jxl.write.Label labelCF12 = new jxl.write.Label(13, 0, "StockQty", wcfT); // (行,列)
    ws.addCell(labelCF12);
	ws.setColumnView(13,8);

	//out.println(sqla);
	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 1;
		int rowNo = 1;  //第二列開始
		
        //sql = sqlGlobal;
        //out.println(sql+"<BR>"); 
	    //out.println("S1");
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sqla); 		
		//out.println("S2");
		while (rs.next())
		{	//out.println("S2");  		 
		  noSeq = noSeq + 1;
		  noSeqStr = Integer.toString(noSeq);
		  String rowNoStr = Integer.toString(rowNo);		  

		  jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		  //wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  
		  
		  //out.println("S4"); 

		  jxl.write.Label lable9 = new jxl.write.Label(0, rowNo, noSeqStr , wcfFL); // (行,列);由第2列開始顯示動態資料
          ws.addCell(lable9);	
	  
		  invItem=rs.getString("ITEM_ORD");			  
		  jxl.write.Label lable121 = new jxl.write.Label(1, rowNo, invItem , wcfFL); 
          ws.addCell(lable121);			  
		  
		  itemDesc = rs.getString("DESCRIPTION");  //DESCRIPTION
		  jxl.write.Label lable8 = new jxl.write.Label(2, rowNo, itemDesc , wcfFL); // (行,列);
          ws.addCell(lable8);	
		  	  	  
		  orderDate = rs.getString("TRANSACTION_DATE");  //txnDate
		  jxl.write.Label lable10 = new jxl.write.Label(3, rowNo, orderDate , wcfFL); // (行,列); 
          ws.addCell(lable10);
		  
		  subInv = rs.getString("SUBINVENTORY");  //SUBINVENTORY
	      jxl.write.Label lable11 = new jxl.write.Label(4, rowNo, subInv , wcfFL); // (行,列); 
          ws.addCell(lable11);
		  
		  txnType = rs.getString("TRANSACTION_TYPE_NAME");  //txnType
	      jxl.write.Label lable21 = new jxl.write.Label(5, rowNo, txnType , wcfFL); // (行,列); 
          ws.addCell(lable21);

//查單號起
	   sourceCode=rs.getString("SOURCE_CODE");
	   sourceLineId=rs.getString("SOURCE_LINE_ID");
	   invoiceNo ="";          //add by Peggy 20150706    
	   originalNo =""; 	       //add by Peggy 20150706
	   packingList ="";	       //add by Peggy 20150706
	   custName="";	          //add by Peggy 20150706 
	   
       if (sourceCode=="Inventory" || sourceCode.equals("Inventory")) 
	     {
		   docNo=rs.getString("DOC_NO");   // Inventory大多為inter-org 移來有 reference 有打1213訂單號
		   invoiceNo=rs.getString("DOC_NO");
		   if (invoiceNo==null || invoiceNo.equals(null)) invoiceNo ="";			
		 }
       if (sourceCode=="Sales order" || sourceCode.equals("Sales order")) 
        {
 			String sqlfnd = "  select ooh.order_number,ool.SHIPPING_INSTRUCTIONS,ool.ATTRIBUTE1   from oe_order_headers_all ooh,oe_order_lines_all ool "+
 						    "   where ooh.header_id = ool.header_id  and ool.line_id= '"+sourceLineId+ "'";
			Statement stateFndId=con.createStatement();
            ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
			if (rsFndId.next())
			{
				 docNo = rsFndId.getString("ORDER_NUMBER"); 
				 originalNo = rsFndId.getString("SHIPPING_INSTRUCTIONS"); 	
				 packingList = rsFndId.getString("ATTRIBUTE1"); 	
		         if (originalNo==null || originalNo.equals(null)) originalNo ="";		
				 if (packingList==null || packingList.equals(null)) packingList ="";		 			 
			 }
			 rsFndId.close();
			 stateFndId.close(); 
			    
 			String sqlinv = " SELECT MAX(INVOICE_NO) INVOICE_NO FROM TSC_INVOICE_LINES TIL WHERE  TIL.ORDER_NUMBER = '"+docNo+ "'";
			Statement stateFndInv=con.createStatement();
            ResultSet rsFndInv=stateFndInv.executeQuery(sqlinv);
			if (rsFndInv.next())
			{
				 invoiceNo = rsFndInv.getString("INVOICE_NO"); 
			 }
			 rsFndInv.close();
			 stateFndInv.close(); 
			 if (invoiceNo==null || sourceCode.equals("null")) invoiceNo ="";
			// if (packingNo==null || packingNo.equals(null)) packingNo =""; 			     
        }
       else if (sourceCode=="RMA" || sourceCode.equals("RMA"))
        {
 			String sqlrma = "   select ooh.order_number,ooh.SOLD_TO from rcv_transactions rt,oe_order_headers_v ooh "+
 						    "    where rt.OE_ORDER_HEADER_ID = ooh.header_id and  rt.transaction_id= '"+sourceLineId+ "'";
			Statement staterma=con.createStatement();
            ResultSet rsrma=staterma.executeQuery(sqlrma);
			if (rsrma.next())
			{
				 docNo = rsrma.getString("ORDER_NUMBER"); 
				 custName = rsrma.getString("SOLD_TO"); 				 
			 }
			 rsrma.close();
			 staterma.close(); 
         }
       else if (sourceCode=="Purchase order" || sourceCode.equals("Purchase order"))
        { 
 			String sqlPo = "   SELECT poh.segment1 || ' / ' || pol.note_to_receiver segment1 FROM rcv_transactions rt, po_headers_all poh, po_line_locations_all pol "+
 						   "    WHERE rt.po_header_id = poh.po_header_id  AND rt.po_line_location_id = pol.line_location_id  AND pol.po_header_id = poh.po_header_id "+
                           "      and rt.transaction_id='"+sourceLineId+ "'";
			Statement statePo=con.createStatement();
            ResultSet rsPo=statePo.executeQuery(sqlPo);
			if (rsPo.next())
			{
				 docNo = rsPo.getString("SEGMENT1"); 
			 }
			 rsPo.close();
			 statePo.close(); 
         } 

      if (docNo==null || docNo.equals("null")) docNo="";
      if (invoiceNo==null || invoiceNo.equals("null")) invoiceNo="";
	  if (originalNo==null || originalNo.equals(null)) originalNo =""; 	  
	  if (packingList==null || packingList.equals(null)) packingList =""; 
	  
	//customer name  
	  if (invoiceNo==null || invoiceNo.equals("null")) 
	    {  if (custName==null || custName.equals("null"))
		     { custName=""; }
	    }
	  else 
	    {
 			String sqlCust = "  select CUSTOMER_NAME from tsc_invoice_headers  where invoice_no='"+invoiceNo+ "'";
			Statement stateCust=con.createStatement();
            ResultSet rsCust=stateCust.executeQuery(sqlCust);
			if (rsCust.next())
			{
				 custName = rsCust.getString("CUSTOMER_NAME"); 
			 }
			 rsCust.close();    //add by Peggy 20150706
			 stateCust.close(); //add by Peggy 20150706			 
		 } //end invoice is null

	  
 //查單號

		  jxl.write.Label lable31 = new jxl.write.Label(6, rowNo, docNo , wcfFL); // (行,列); 
          ws.addCell(lable31);
		  
		  jxl.write.Label lable32 = new jxl.write.Label(7, rowNo, invoiceNo , wcfFL); // (行,列); 
          ws.addCell(lable32);	
		  
		  jxl.write.Label lable321 = new jxl.write.Label(8, rowNo, custName , wcfFL); // (行,列); 
          ws.addCell(lable321);			  
		  	  
		  jxl.write.Label lable33 = new jxl.write.Label(9, rowNo, originalNo , wcfFL); // (行,列); 
          ws.addCell(lable33);		

		  jxl.write.Label lable34 = new jxl.write.Label(10, rowNo, packingList , wcfFL); // (行,列); 
          ws.addCell(lable34);			  
		  	  
		  orderQty=rs.getString("PRIMARY_QUANTITY");					  
		  jxl.write.Label lable41 = new jxl.write.Label(11, rowNo, orderQty , wcfFL); 
          ws.addCell(lable41);		
          		  
		  itemUom=rs.getString("PRIMARY_UOM_CODE");
		  jxl.write.Label lable51 = new jxl.write.Label(12, rowNo, itemUom , wcfFL); 
          ws.addCell(lable51);	

          orderQtyf=rs.getFloat("PRIMARY_QUANTITY");
          sumQtyf=sumQtyf+orderQtyf;	  
		  jxl.write.Label lable61 = new jxl.write.Label(13, rowNo, (new DecimalFormat("######0.###")).format(sumQtyf), wcfFL); 
          ws.addCell(lable61);

		  rowNo = rowNo + 1;		   
		
	  }   // End of While rs.next()
		
	 rs.close();
	 statement.close();

	//寫入Excel 
	wwb.write(); 
    //關閉Excel工作薄 
    //wwb.close();
	
	//rs.close();
	
	 
    //response.setContentType("application/vnd.ms-excel");  
   // response.getOutputStream().write(wwb) ;
   //response.getOutputStream().flush();  
   //ws.close();   // close workbook's sheet //
   wwb.close(); // close workbook //
   os.close();   // close file outputstream //
   out.close(); 

  } //end of try
  catch (Exception e)
  {
   out.println("Exception e:"+e.getMessage());
  }
}  //end typeid=0  //MMT EXPORT

if (typeId=="1" || typeId.equals("1"))  //typeid=1  //1213 EXPORT
{ 
  try
  {  

    String sqla = " select a.GROUP_NAME,a.HUB,a.CUSTOMER_NAME,a.ORDER_NUMBER,to_char(a.ORDERED_DATE,'yyyy/mm/dd') ORDERED_DATE,  "+
       			  " 	   to_char(a.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') SCHEDULE_SHIP_DATE,a.ITEM,a.ITEM_DESC,(a.ORDER_QTY)/1000 AS ORDER_1213,a.ITEM_ID "+
  				  "   from tsc_om_1213 a "+
                  " where a.L_STATUS not in ('CLOSED','CANCELLED') "+
  				  "   and A.ITEM_ID = '"+itemId+"' and a.hub = '"+subInv+"' "+
                  " order by a.SCHEDULE_SHIP_DATE ";				 			   				   
	 
     // sqla = sqla + where + orderBy;	

	OutputStream os = null;	
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
      os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/TSC_MMT_"+userID+"_"+hmsCurr+".xls");
	}  else { // For Windows Platform
	          os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\TSC_MMT_"+userID+"_"+hmsCurr+".xls");
	        }
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("1213", 0); //-- TEST
	
	//jxl.Sheet ws = wwb.createSheet("Sales Delivery Request", 0);
	
	jxl.SheetSettings sst = ws.getSettings(); 
	
	//out.println("2<BR>");
   /*               */
    // 第二個Sheet ws2
    //jxl.write.WritableSheet ws2 = wwb.createSheet("Sales Delivery Record", 0);
    // 抬頭列字型15
	jxl.write.WritableFont wf2Title = new jxl.write.WritableFont(WritableFont.TIMES, 15,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Title = new jxl.write.WritableCellFormat(wf2Title); 
	wcf2Title.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    // 條件列字型12
    jxl.write.WritableFont wf2Cond = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Cond = new jxl.write.WritableCellFormat(wf2Cond); 
	wcf2Cond.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    // Header 列背景灰色
    jxl.write.WritableFont wf2Header = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(wf2Header); 
	wcf2Header.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    wcf2Header.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色
    // 內容 列 定義
    jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
	wcf2Content.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    //wcf2Content.setBackground(jxl.format.Colour.GRAY_25); // 	  
	
	jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
	wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    wcfT.setAlignment(jxl.format.Alignment.LEFT);
   /*                  */
	
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	//sst.setProtected(true);
	sst.setFitToPages(true);	
	sst.setFitWidth(1);  // 設定一頁寬
	//sst.setFitHeight(1);  // 設定一頁高
	//sst.setPassword("kerwin");

	//抬頭:(第6列第0行)		// 明細抬頭說明
	jxl.write.Label labelCF5 = new jxl.write.Label(0, 0, "LineNo", wcfT); // (行,列)
    ws.addCell(labelCF5);
	ws.setColumnView(0,5);
	
    jxl.write.Label labelC19 = new jxl.write.Label(1, 0, "GROUP", wcfT); // (行,列)
    ws.addCell(labelC19);
	ws.setColumnView(1,8);		
	
	jxl.write.Label labelCFC4 = new jxl.write.Label(2, 0, "HUB", wcfT); // (行,列)
    ws.addCell(labelCFC4);
	ws.setColumnView(2,8);	
	
	jxl.write.Label labelCFC6 = new jxl.write.Label(3, 0, "CustomerName", wcfT); // (行,列)
    ws.addCell(labelCFC6);
	ws.setColumnView(3,20);
	
	//抬頭:(第6列第1行)
	jxl.write.Label labelCF7 = new jxl.write.Label(4, 0, "OrderNo", wcfT); // (行,列)
    ws.addCell(labelCF7);
	ws.setColumnView(4,13);
	//抬頭:(第6列第2行)
	jxl.write.Label labelCF8 = new jxl.write.Label(5, 0, "ItemNo", wcfT); // (行,列)
    ws.addCell(labelCF8);
	ws.setColumnView(5,25);
	//抬頭:(第6列第3行)
	jxl.write.Label labelCF9 = new jxl.write.Label(6, 0, "Description", wcfT); // (行,列)
    ws.addCell(labelCF9);
	ws.setColumnView(6,18);
	//抬頭:(第6列第4行)
	jxl.write.Label labelCFC10 = new jxl.write.Label(7, 0, "OrderDate", wcfT); // (行,列)
    ws.addCell(labelCFC10);
	ws.setColumnView(7,12);
	//抬頭:(第6列第5行)
	jxl.write.Label labelCFC11 = new jxl.write.Label(8, 0, "ScheduleShipDate", wcfT); // (行,列)
    ws.addCell(labelCFC11);
	ws.setColumnView(8,12);
	//抬頭:(第6列第6行)
	jxl.write.Label labelCF12 = new jxl.write.Label(9, 0, "1213/1214 UnshipQty", wcfT); // (行,列)
    ws.addCell(labelCF12);
	ws.setColumnView(9,8);

	jxl.write.Label labelCF13 = new jxl.write.Label(10, 0, "UOM", wcfT); // (行,列)
    ws.addCell(labelCF13);
	ws.setColumnView(10,6);

	out.println(sqla);
	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 1;
		int rowNo = 1;  //第二列開始
		
        //sql = sqlGlobal;
        //out.println(sql+"<BR>"); 
	    //out.println("S1");
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sqla); 		
		//out.println("S2");
		while (rs.next())
		{	//out.println("S2");  		 
		  noSeq = noSeq + 1;
		  noSeqStr = Integer.toString(noSeq);
		  String rowNoStr = Integer.toString(rowNo);		  

		  jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		  //wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  
		  
		  //out.println("S4"); 

		  jxl.write.Label lable1 = new jxl.write.Label(0, rowNo, noSeqStr , wcfFL); // (行,列);由第2列開始顯示動態資料
          ws.addCell(lable1);	
	  
		  hub=rs.getString("HUB");			  
		  jxl.write.Label lable2 = new jxl.write.Label(1, rowNo, hub , wcfFL); 
          ws.addCell(lable2);			  

		  groupArea = rs.getString("GROUP_NAME");  //groupArea
		  jxl.write.Label lable3 = new jxl.write.Label(2, rowNo, groupArea , wcfFL); // (行,列);
          ws.addCell(lable3);

		  
		  custName = rs.getString("CUSTOMER_NAME");  //custName
		  jxl.write.Label lable4 = new jxl.write.Label(3, rowNo, custName , wcfFL); // (行,列);
          ws.addCell(lable4);	
		  	  	  
		  orderNo = rs.getString("ORDER_NUMBER");  //orderNo
		  jxl.write.Label lable5 = new jxl.write.Label(4, rowNo, orderNo , wcfFL); // (行,列); 
          ws.addCell(lable5);
		  
		  invItem = rs.getString("ITEM");  //invItem
	      jxl.write.Label lable6 = new jxl.write.Label(5, rowNo, invItem , wcfFL); // (行,列); 
          ws.addCell(lable6);
		  
		  itemDesc = rs.getString("ITEM_DESC");  //itemDesc
	      jxl.write.Label lable7 = new jxl.write.Label(6, rowNo, itemDesc , wcfFL); // (行,列); 
          ws.addCell(lable7);

		  orderDate = rs.getString("ORDERED_DATE");  //orderDate
		  jxl.write.Label lable8 = new jxl.write.Label(7, rowNo, orderDate , wcfFL); // (行,列); 
          ws.addCell(lable8);
		  
		  schDate=rs.getString("SCHEDULE_SHIP_DATE");					  
		  jxl.write.Label lable9 = new jxl.write.Label(8, rowNo, schDate , wcfFL); 
          ws.addCell(lable9);		
          		  
		  orderQty=rs.getString("ORDER_1213");
		  jxl.write.Label lable10 = new jxl.write.Label(9, rowNo, orderQty , wcfFL); 
          ws.addCell(lable10);	
 
		  jxl.write.Label lable11 = new jxl.write.Label(10, rowNo,"KPC", wcfFL); 
          ws.addCell(lable11);

		  rowNo = rowNo + 1;		   
		
	  }   // End of While rs.next()
		
	 rs.close();
	 statement.close();

	//寫入Excel 
	wwb.write(); 
    //關閉Excel工作薄 
    //wwb.close();
	
	//rs.close();
	
	 
    //response.setContentType("application/vnd.ms-excel");  
   // response.getOutputStream().write(wwb) ;
   //response.getOutputStream().flush();  
   //ws.close();   // close workbook's sheet //
   wwb.close(); // close workbook //
   os.close();   // close file outputstream //
   out.close(); 

  } //end of try
  catch (Exception e)
  {
   out.println("Exception 1213:"+e.getMessage());
  }
}  //end typeid=1  //1213 EXPORT

if (typeId=="3" || typeId.equals("3"))  //typeid=3  //I1 ORDER EXPORT
{ 
  try
  {  

    if( organizationId == "326" || organizationId.equals("326"))
     {    
       orgId="325";
       //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('325')}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '325')}");
	   cs1.execute();
       cs1.close();
      }
    else
     {    
       orgId="41";
       //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
	 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	   cs1.execute();
       cs1.close();
      }

//out.print("call DBMS_APPLICATION_<br>");

    String sqla =" SELECT tsc_intercompany_pkg.get_sales_group (ooh.header_id) group_name,AC.CUSTOMER_NAME, ooh.order_number, "+
       			  "		   TO_CHAR (TRUNC (ooh.ordered_date), 'yyyy/mm/dd') ordered_date, "+
	   			  "        TO_CHAR (TRUNC (ool.schedule_ship_date),'yyyy/mm/dd') schedule_ship_date, "+
       			  "        msi.segment1 item_no, msi.description,  msi.primary_unit_of_measure UOM, ool.inventory_item_id , "+
	  			  "        DECODE (order_quantity_uom,'PCE', ordered_quantity / 1000,ool.ordered_quantity) order_qty "+
 				  "   FROM oe_order_lines_all ool, oe_order_headers_all ooh, mtl_system_items msi, AR_CUSTOMERS AC "+
				  "  WHERE ool.ship_from_org_id = "+organizationId+"  AND ool.header_id = ooh.header_id "+
   				//   "	AND ooh.org_id = "+orgId+"   AND ool.line_category_code = 'ORDER' "+ 
   				   "	AND ool.line_category_code = 'ORDER' AND OOH.SOLD_TO_ORG_ID = AC.CUSTOMER_ID "+ 
   				   "	AND ool.cancelled_flag = 'N'   AND ool.ship_from_org_id = msi.organization_id "+ 
   				   "    AND ool.inventory_item_id = msi.inventory_item_id "+ 
   				   "    AND ool.inventory_item_id NOT IN (29570, 29560, 29562, 66996) "+
  				   "    AND ool.flow_status_code IN ('ENTERED', 'BOOKED', 'AWAITING_SHIPPING') "+   
 				   "    AND ool.inventory_item_id = '"+itemId+"' "+
				   " order by  ool.schedule_ship_date  ";	

	 
     // sqla = sqla + where + orderBy;	

	OutputStream os = null;	
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
      os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/TSC_MMT_"+userID+"_"+hmsCurr+".xls");
	}  else { // For Windows Platform
	          os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\TSC_MMT_"+userID+"_"+hmsCurr+".xls");
	        }
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("I1", 0); //-- TEST
	
	//jxl.Sheet ws = wwb.createSheet("Sales Delivery Request", 0);
	
	jxl.SheetSettings sst = ws.getSettings(); 
	
	//out.println("2<BR>");
   /*               */
    // 第二個Sheet ws2
    //jxl.write.WritableSheet ws2 = wwb.createSheet("Sales Delivery Record", 0);
    // 抬頭列字型15
	jxl.write.WritableFont wf2Title = new jxl.write.WritableFont(WritableFont.TIMES, 15,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Title = new jxl.write.WritableCellFormat(wf2Title); 
	wcf2Title.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    // 條件列字型12
    jxl.write.WritableFont wf2Cond = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Cond = new jxl.write.WritableCellFormat(wf2Cond); 
	wcf2Cond.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    // Header 列背景灰色
    jxl.write.WritableFont wf2Header = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(wf2Header); 
	wcf2Header.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    wcf2Header.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色
    // 內容 列 定義
    jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
	wcf2Content.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    //wcf2Content.setBackground(jxl.format.Colour.GRAY_25); // 	  
	
	jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
	wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    wcfT.setAlignment(jxl.format.Alignment.LEFT);
   /*                  */
	
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	//sst.setProtected(true);
	sst.setFitToPages(true);	
	sst.setFitWidth(1);  // 設定一頁寬
	//sst.setFitHeight(1);  // 設定一頁高
	//sst.setPassword("kerwin");

	//抬頭:(第6列第0行)		// 明細抬頭說明
	jxl.write.Label labelCF5 = new jxl.write.Label(0, 0, "LineNo", wcfT); // (行,列)
    ws.addCell(labelCF5);
	ws.setColumnView(0,5);
	
    jxl.write.Label labelC19 = new jxl.write.Label(1, 0, "GROUP", wcfT); // (行,列)
    ws.addCell(labelC19);
	ws.setColumnView(1,8);		
	
	//jxl.write.Label labelCFC4 = new jxl.write.Label(2, 0, "HUB", wcfT); // (行,列)
   // ws.addCell(labelCFC4);
	//ws.setColumnView(2,8);	
	
	jxl.write.Label labelCFC6 = new jxl.write.Label(2, 0, "CustomerName", wcfT); // (行,列)
    ws.addCell(labelCFC6);
	ws.setColumnView(2,30);
	
	//抬頭:(第6列第1行)
	jxl.write.Label labelCF7 = new jxl.write.Label(3, 0, "OrderNo", wcfT); // (行,列)
    ws.addCell(labelCF7);
	ws.setColumnView(3,13);
	//抬頭:(第6列第2行)
	jxl.write.Label labelCF8 = new jxl.write.Label(4, 0, "ItemNo", wcfT); // (行,列)
    ws.addCell(labelCF8);
	ws.setColumnView(4,25);
	//抬頭:(第6列第3行)
	jxl.write.Label labelCF9 = new jxl.write.Label(5, 0, "Description", wcfT); // (行,列)
    ws.addCell(labelCF9);
	ws.setColumnView(5,18);
	//抬頭:(第6列第4行)
	jxl.write.Label labelCFC10 = new jxl.write.Label(6, 0, "OrderDate", wcfT); // (行,列)
    ws.addCell(labelCFC10);
	ws.setColumnView(6,12);
	//抬頭:(第6列第5行)
	jxl.write.Label labelCFC11 = new jxl.write.Label(7, 0, "ScheduleShipDate", wcfT); // (行,列)
    ws.addCell(labelCFC11);
	ws.setColumnView(7,12);
	//抬頭:(第6列第6行)
	jxl.write.Label labelCF12 = new jxl.write.Label(8, 0, "UnshipQty", wcfT); // (行,列)
    ws.addCell(labelCF12);
	ws.setColumnView(8,8);

	jxl.write.Label labelCF13 = new jxl.write.Label(9, 0, "UOM", wcfT); // (行,列)
    ws.addCell(labelCF13);
	ws.setColumnView(9,6);

	out.println(sqla);
	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 1;
		int rowNo = 1;  //第二列開始
		
        //sql = sqlGlobal;
        //out.println(sql+"<BR>"); 
	   // out.println("S1");
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sqla); 		
		//out.println("S2");
		while (rs.next())
		{	//out.println("S2");  		 
		  noSeq = noSeq + 1;
		  noSeqStr = Integer.toString(noSeq);
		  String rowNoStr = Integer.toString(rowNo);		  

		  jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		  //wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  
		  
		  //out.println("S4"); 

		  jxl.write.Label lable1 = new jxl.write.Label(0, rowNo, noSeqStr , wcfFL); // (行,列);由第2列開始顯示動態資料
          ws.addCell(lable1);	
	  
		//  hub=rs.getString("HUB");			  
		//  jxl.write.Label lable2 = new jxl.write.Label(1, rowNo, hub , wcfFL); 
        //  ws.addCell(lable2);			  

		  groupArea = rs.getString("GROUP_NAME");  //groupArea
		  jxl.write.Label lable3 = new jxl.write.Label(1, rowNo, groupArea , wcfFL); // (行,列);
          ws.addCell(lable3);

		  
		  custName = rs.getString("CUSTOMER_NAME");  //custName
		  jxl.write.Label lable4 = new jxl.write.Label(2, rowNo, custName , wcfFL); // (行,列);
          ws.addCell(lable4);	
		  	  	  
		  orderNo = rs.getString("ORDER_NUMBER");  //orderNo
		  jxl.write.Label lable5 = new jxl.write.Label(3, rowNo, orderNo , wcfFL); // (行,列); 
          ws.addCell(lable5);
		  
		  invItem = rs.getString("ITEM_NO");  //invItem
	      jxl.write.Label lable6 = new jxl.write.Label(4, rowNo, invItem , wcfFL); // (行,列); 
          ws.addCell(lable6);
		  
		  itemDesc = rs.getString("DESCRIPTION");  //itemDesc
	      jxl.write.Label lable7 = new jxl.write.Label(5, rowNo, itemDesc , wcfFL); // (行,列); 
          ws.addCell(lable7);

		  orderDate = rs.getString("ORDERED_DATE");  //orderDate
		  jxl.write.Label lable8 = new jxl.write.Label(6, rowNo, orderDate , wcfFL); // (行,列); 
          ws.addCell(lable8);
		  
		  schDate=rs.getString("SCHEDULE_SHIP_DATE");					  
		  jxl.write.Label lable9 = new jxl.write.Label(7, rowNo, schDate , wcfFL); 
          ws.addCell(lable9);		
          		  
		  orderQty=rs.getString("ORDER_QTY");
		  jxl.write.Label lable10 = new jxl.write.Label(8, rowNo, orderQty , wcfFL); 
          ws.addCell(lable10);	
 
		  jxl.write.Label lable11 = new jxl.write.Label(9, rowNo,"KPC", wcfFL); 
          ws.addCell(lable11);

		  rowNo = rowNo + 1;		   
		
	  }   // End of While rs.next()
		
	 rs.close();
	 statement.close();

	//寫入Excel 
	wwb.write(); 
    //關閉Excel工作薄 
    //wwb.close();
	
	//rs.close();
	
	 
    //response.setContentType("application/vnd.ms-excel");  
   // response.getOutputStream().write(wwb) ;
   //response.getOutputStream().flush();  
   //ws.close();   // close workbook's sheet //
   wwb.close(); // close workbook //
   os.close();   // close file outputstream //
   out.close(); 

  } //end of try
  catch (Exception e)
  {
   out.println("Exception I1:"+e.getMessage());
  }
}  //end typeid=3  //I1 ORDER EXPORT


if (typeId=="4" || typeId.equals("4"))  //typeid=4  //I1 QUERY EXPORT
{ 

    if( organizationId == "326" || organizationId.equals("326"))
     {    
       //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('325')}");
	 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '325')}");
	   cs1.execute();
       cs1.close();
      }
    else
     {    
       //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	   cs1.execute();
       cs1.close();
      }

 float fgOhQtyf=0,unShipQtyf=0,avaiQtyf=0;
 String fgOhQty="",unShipQty ="",avaiQty="",uom="";

  try
  {  

     //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	 cs1.execute();
     cs1.close();
    String sqla =" SELECT ROWNUM,A.INVENTORY_ITEM_ID,MSI.SEGMENT1 ITEM_NO,MSI.DESCRIPTION,MSI.PRIMARY_UNIT_OF_MEASURE UOM "+
				 " FROM ( "+
   				 "          SELECT moq.inventory_item_id,SUM (transaction_quantity) onhand_qty, 0 AS unship_qty "+
     			 "		   FROM mtl_onhand_quantities_detail moq "+
				 "          WHERE moq.organization_id = "+organizationId+"  "+
				 "                AND moq.SUBINVENTORY_CODE NOT IN ('00','01','02','05','06') "+
				 "                GROUP BY moq.inventory_item_id"+
  				 "          UNION  "+
   				 "          SELECT ool.inventory_item_id , 0 AS onhand_qty"+
				 "          , SUM (DECODE (order_quantity_uom,'PCE', ordered_quantity / 1000,ordered_quantity)) unship_qty"+
    			 "          FROM oe_order_lines_all ool "+
    			 "          WHERE ool.ship_from_org_id = "+organizationId+" "+
				 "          AND ool.line_category_code = 'ORDER'  "+
     			 "          AND ool.cancelled_flag = 'N'"+
				 "          AND ool.flow_status_code IN ('ENTERED', 'BOOKED', 'AWAITING_SHIPPING')  "+
     			 "          AND ool.inventory_item_id NOT IN (29570, 29560, 29562, 66996) "+
				 "          GROUP BY ool.inventory_item_id) a ,mtl_system_items msi ";

	String sqlW = " WHERE msi.organization_id ='"+organizationId+"'    AND a.inventory_item_id   = msi.inventory_item_id  ";

    String sOrderBy = " order by ROWNUM ";

   if (item==null || item.equals(""))  {sqlW=sqlW+" ";}
   else { sqlW = sqlW + " AND ( MSI.SEGMENT1 LIKE upper('"+item+"%') or upper(MSI.DESCRIPTION) like upper('"+item+"%'))   "; }

	 
    sqla = sqla + sqlW + sOrderBy;	

	OutputStream os = null;	
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
      os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/TSC_MMT_"+userID+"_"+hmsCurr+".xls");
	}  else { // For Windows Platform
	          os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\TSC_MMT_"+userID+"_"+hmsCurr+".xls");
	        }
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("I1", 0); //-- TEST
	
	//jxl.Sheet ws = wwb.createSheet("Sales Delivery Request", 0);
	
	jxl.SheetSettings sst = ws.getSettings(); 
	
	//out.println("2<BR>");
   /*               */
    // 第二個Sheet ws2
    //jxl.write.WritableSheet ws2 = wwb.createSheet("Sales Delivery Record", 0);
    // 抬頭列字型15
	jxl.write.WritableFont wf2Title = new jxl.write.WritableFont(WritableFont.TIMES, 15,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Title = new jxl.write.WritableCellFormat(wf2Title); 
	wcf2Title.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    // 條件列字型12
    jxl.write.WritableFont wf2Cond = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Cond = new jxl.write.WritableCellFormat(wf2Cond); 
	wcf2Cond.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    // Header 列背景灰色
    jxl.write.WritableFont wf2Header = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(wf2Header); 
	wcf2Header.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    wcf2Header.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色
    // 內容 列 定義
    jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
	wcf2Content.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    //wcf2Content.setBackground(jxl.format.Colour.GRAY_25); // 	  
	
	jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
	wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    wcfT.setAlignment(jxl.format.Alignment.LEFT);
   /*                  */
	
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	//sst.setProtected(true);
	sst.setFitToPages(true);	
	sst.setFitWidth(1);  // 設定一頁寬
	//sst.setFitHeight(1);  // 設定一頁高
	//sst.setPassword("kerwin");

	//抬頭:(第6列第0行)		// 明細抬頭說明
	jxl.write.Label labelCF5 = new jxl.write.Label(0, 0, "No", wcfT); // (行,列)
    ws.addCell(labelCF5);
	ws.setColumnView(0,5);
	
    jxl.write.Label labelC19 = new jxl.write.Label(1, 0, "ITEM NO", wcfT); // (行,列)
    ws.addCell(labelC19);
	ws.setColumnView(1,28);		
	
	
	jxl.write.Label labelCFC6 = new jxl.write.Label(2, 0, "Description", wcfT); // (行,列)
    ws.addCell(labelCFC6);
	ws.setColumnView(2,25);
	
	//抬頭:(第6列第1行)
	jxl.write.Label labelCF7 = new jxl.write.Label(3, 0, "UOM", wcfT); // (行,列)
    ws.addCell(labelCF7);
	ws.setColumnView(3,6);
	//抬頭:(第6列第2行)
	jxl.write.Label labelCF8 = new jxl.write.Label(4, 0, "On Hand Qty", wcfT); // (行,列)
    ws.addCell(labelCF8);
	ws.setColumnView(4,13);
	//抬頭:(第6列第3行)
	jxl.write.Label labelCF9 = new jxl.write.Label(5, 0, "Unship Order Qty", wcfT); // (行,列)
    ws.addCell(labelCF9);
	ws.setColumnView(5,13);
	//抬頭:(第6列第4行)
	jxl.write.Label labelCFC10 = new jxl.write.Label(6, 0, "Available Qty", wcfT); // (行,列)
    ws.addCell(labelCFC10);
	ws.setColumnView(6,13);
	//抬頭:(第6列第5行)
/*
	jxl.write.Label labelCFC11 = new jxl.write.Label(7, 0, "ScheduleShipDate", wcfT); // (行,列)
    ws.addCell(labelCFC11);
	ws.setColumnView(7,12);
	//抬頭:(第6列第6行)
	jxl.write.Label labelCF12 = new jxl.write.Label(8, 0, "UnshipQty", wcfT); // (行,列)
    ws.addCell(labelCF12);
	ws.setColumnView(8,8);

	jxl.write.Label labelCF13 = new jxl.write.Label(9, 0, "UOM", wcfT); // (行,列)
    ws.addCell(labelCF13);
	ws.setColumnView(9,6);
*/
	out.println(sqla);
	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 1;
		int rowNo = 1;  //第二列開始
		
        //sql = sqlGlobal;
        //out.println(sql+"<BR>"); 
	   // out.println("S1");
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sqla); 		
		//out.println("S2");
		while (rs.next())
		{	//out.println("S2");  		 
		  noSeq = noSeq + 1;
		  noSeqStr = Integer.toString(noSeq);
		  String rowNoStr = Integer.toString(rowNo);		  

		  jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		  //wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  
		  
		  //out.println("S4"); 

		  jxl.write.Label lable1 = new jxl.write.Label(0, rowNo, noSeqStr , wcfFL); // (行,列);由第2列開始顯示動態資料
          ws.addCell(lable1);	
	  
		//  hub=rs.getString("HUB");			  
		//  jxl.write.Label lable2 = new jxl.write.Label(1, rowNo, hub , wcfFL); 
        //  ws.addCell(lable2);			  

		  invItem = rs.getString("ITEM_NO");  //ITEM_NO
		  jxl.write.Label lable3 = new jxl.write.Label(1, rowNo, invItem , wcfFL); // (行,列);
          ws.addCell(lable3);

		  
		  itemDesc = rs.getString("DESCRIPTION");  //DESCRIPTION
		  jxl.write.Label lable4 = new jxl.write.Label(2, rowNo, itemDesc , wcfFL); // (行,列);
          ws.addCell(lable4);	
		  	  	  
		  uom = rs.getString("UOM");  //orderNo
		  jxl.write.Label lable5 = new jxl.write.Label(3, rowNo, uom , wcfFL); // (行,列); 
          ws.addCell(lable5);

          
          itemId = rs.getString("INVENTORY_ITEM_ID");  //INVENTORY_ITEM_ID

//_________________計算庫存及未出訂單_____起
      try
       {
	    //計算ON_HAND QTY		       
         String sqlOhQty = "  SELECT SUM(TRANSACTION_QUANTITY) ONHAND_QTY  FROM mtl_onhand_quantities_detail moq WHERE moq.organization_id = "+organizationId+"  "+
  	  				       "     AND moq.SUBINVENTORY_CODE NOT IN ('00','01','02','05','06') AND moq.inventory_item_id  = ' "+itemId+ "'";
	     Statement stateOhQty=con.createStatement();
         ResultSet rsOhQty=stateOhQty.executeQuery(sqlOhQty);
	     if (rsOhQty.next())
	  	 {
	 	   fgOhQtyf = rsOhQty.getFloat("ONHAND_QTY"); 
	 	//   fgOhQty = rsOhQty.getString("ONHAND_QTY"); 
		  }
	     rsOhQty.close();
	     stateOhQty.close();	

      // out.print("   **" +noSeqStr+" fgOhQtyf= "+fgOhQtyf);
	    //計算未出訂單數量		       
         String sqlUnShipQty = "  SELECT SUM (DECODE (order_quantity_uom,'PCE', ordered_quantity / 1000, ordered_quantity )) unship_qty "+
 				   		       "    FROM oe_order_lines_all ool WHERE ool.ship_from_org_id = "+organizationId+" "+
   							   "     AND ool.line_category_code = 'ORDER' AND ool.cancelled_flag = 'N' "+
  							   "     AND ool.flow_status_code IN ('ENTERED', 'BOOKED', 'AWAITING_SHIPPING')  "+
  							   "     AND ool.inventory_item_id  = ' "+itemId+ "'";
	     Statement stateUnShipQty=con.createStatement();
         ResultSet rsUnShipQty=stateUnShipQty.executeQuery(sqlUnShipQty);
	     if (rsUnShipQty.next())
		  {
	 	    unShipQtyf = rsUnShipQty.getFloat("UNSHIP_QTY"); 
	 	//    unShipQty = rsUnShipQty.getString("UNSHIP_QTY"); 
		   }
	      rsUnShipQty.close();
	      stateUnShipQty.close();	
      // out.print("   **" +noSeqStr+" unShipQtyf= "+unShipQtyf);

         //計算可用庫存
          avaiQtyf =  fgOhQtyf - unShipQtyf ;
          avaiQty = Float.toString(avaiQtyf);
         } //end of try
        catch (Exception e)
       {
          out.println("Exception count:"+e.getMessage());
         }

//_________________計算庫存及未出訂單_____迄

//小數轉換___起

try
{

    java.text.DecimalFormat nf = new java.text.DecimalFormat("#.###"); // 取小數後三位
    
	  fgOhQty = nf.format(fgOhQtyf);
	//  java.math.BigDecimal bd = new java.math.BigDecimal(fgOhQty);
  	//  java.math.BigDecimal fgOhQtyN = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
    //	fgOhQtyf =fgOhQtyN.floatValue();
     //  out.print("<br>"+noSeqStr+"item "+invItem+"  fgOhQtyf="+fgOhQtyf);
 
	  unShipQty = nf.format(unShipQtyf);

    //   bd = new java.math.BigDecimal(unShipQty);
	//   java.math.BigDecimal unShipQtyN = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
	//   unShipQtyf =unShipQtyN.floatValue();

	  avaiQty = nf.format(avaiQtyf);

   //   bd = new java.math.BigDecimal(avaiQty);
	//  java.math.BigDecimal avaiQtyN = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
	//  avaiQtyf =avaiQtyN.floatValue();

    } //end of try
    catch (Exception e)
    {
      out.println("Exception f:"+e.getMessage());
    }

//小數轉換___迄
		  
         
          //on hand qty
	      jxl.write.Label lable6 = new jxl.write.Label(4, rowNo, fgOhQty , wcfFL); // (行,列); 
	    //  jxl.write.Number lable6 = new jxl.write.Number(4, rowNo,fgOhQtyf, wcfFL); // (行,列); 
          ws.addCell(lable6);
		  
          //unship order qty
	      jxl.write.Label lable7 = new jxl.write.Label(5, rowNo, unShipQty , wcfFL); // (行,列); 
	    //  jxl.write.Number lable7 = new jxl.write.Number(5, rowNo, unShipQtyf , wcfFL); // (行,列); 
          ws.addCell(lable7);

          //avaiable qty  = on hand qty - unship order qty
		  jxl.write.Label lable8 = new jxl.write.Label(6, rowNo, avaiQty , wcfFL); // (行,列); 
		//  jxl.write.Number lable8 = new jxl.write.Number(6, rowNo, avaiQtyf , wcfFL); // (行,列); 
          ws.addCell(lable8);
/*		  
		  schDate=rs.getString("SCHEDULE_SHIP_DATE");					  
		  jxl.write.Label lable9 = new jxl.write.Label(7, rowNo, schDate , wcfFL); 
          ws.addCell(lable9);		
          		  
		  orderQty=rs.getString("ORDER_QTY");
		  jxl.write.Label lable10 = new jxl.write.Label(8, rowNo, orderQty , wcfFL); 
          ws.addCell(lable10);	
 
		  jxl.write.Label lable11 = new jxl.write.Label(9, rowNo,"KPC", wcfFL); 
          ws.addCell(lable11);
*/

		  rowNo = rowNo + 1;		   
		
	  }   // End of While rs.next()
		
	 rs.close();
	 statement.close();

	//寫入Excel 
	wwb.write(); 
    //關閉Excel工作薄 
    //wwb.close();
	
	//rs.close();
	
	 
    //response.setContentType("application/vnd.ms-excel");  
   // response.getOutputStream().write(wwb) ;
   //response.getOutputStream().flush();  
   //ws.close();   // close workbook's sheet //
   wwb.close(); // close workbook //
   os.close();   // close file outputstream //
   out.close(); 

  } //end of try
  catch (Exception e)
  {
   out.println("Exception I1:"+e.getMessage());
  }
}  //end typeid=4  //I1 excel EXPORT


if (typeId=="5" || typeId.equals("5"))  //typeid=5  //I6 QUERY EXPORT
{ 
	float fgOhQtyf=0,unShipQtyf=0,avaiQtyf=0,Qty1213f=0,Qty1211f=0;
	String fgOhQty="",unShipQty ="",avaiQty="",uom="",locator="";
 	String onWayQty="",Qty1213="",Qty1211="",onWayInv="";
  	try
  	{  
 		//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
	 	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	 	cs1.execute();
     	cs1.close();

    	//String sqla ="  SELECT A.*   ";
    	//String sFrom = " FROM ( SELECT DISTINCT MOQ.SUBINVENTORY_CODE,MOQ.INVENTORY_ITEM_ID,MSI.SEGMENT1,MSI.DESCRIPTION "+
 		//	   "          FROM MTL_ONHAND_QUANTITIES_DETAIL MOQ,MTL_SECONDARY_INVENTORIES INV,MTL_SYSTEM_ITEMS MSI "+
		//	   "		 WHERE MOQ.ORGANIZATION_ID=163 "+
 		//	   "		   AND MOQ.ORGANIZATION_ID = INV.ORGANIZATION_ID "+
  		//	   "		   AND MOQ.SUBINVENTORY_CODE=INV.SECONDARY_INVENTORY_NAME  "+
  		//	   " 		   AND INV.ATTRIBUTE2 = 'S'  "+
  		//	   "		   AND MOQ.ORGANIZATION_ID = MSI.ORGANIZATION_ID    "+
  		//	   "           AND MOQ.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID "+
		//	   "		 UNION "+
		//	   "        SELECT DISTINCT HUB,ITEM_ID,ITEM,ITEM_DESC FROM TSC_OM_1211 "+
		//	   "	     WHERE L_STATUS IN ('AWAITING_SHIPPING','ENTERED','BOOKED')  AND item_id != 29570 "+
		//	   "         UNION  "+
		//	   "        SELECT DISTINCT HUB,ITEM_ID,ITEM,ITEM_DESC FROM TSC_OM_1213  "+
		//	   "         WHERE  L_STATUS IN ('AWAITING_SHIPPING','ENTERED','BOOKED') ) A ";
    	//String sOrderBy = " order by 3,1  ";
   		//if (item==null || item.equals("")) 
    	// {sFrom=sFrom+" ";}
     	//{     sqla = sqla + sFrom + sOrderBy;	 }
   		//else 
      	//{sFrom=sFrom+" WHERE ( a.SEGMENT1 like upper('"+item+"%') or upper(a.DESCRIPTION) like upper('"+item+"%'))  ";
       	//sqla = sqla + sFrom + sOrderBy;	
      	//}

		String sqla = " SELECT   stk.organization_id, stk.inventory_item_id,"+
        	   " stk.secondary_inventory_name, stk.item_name,stk.item_desc,stk.description, stk.intransit_stock,"+
           	   " NVL (onh.onhand_qty, 0) onhand_qty, NVL (ins.onway_qty, 0) onway_qty,"+
           	   " NVL (qty_1211, 0) qty_1211,nvl(qty_1213,0) qty_1213,"+
               " NVL (onh.onhand_qty, 0) + NVL (ins.onway_qty, 0) - NVL (qty_1211, 0)+ nvl(qty_1213,0) available_qty"+
               " FROM (SELECT msi.organization_id, msi.inventory_item_id,msi.segment1 item_name,msi.description item_desc,"+
               " inv.secondary_inventory_name, inv.description,"+
               " CASE inv.secondary_inventory_name"+
               " WHEN '10' THEN '12' WHEN '20' THEN '22' WHEN '30' THEN '32' WHEN '40' THEN '42' "+
			   " WHEN '50' THEN '52' ELSE inv.secondary_inventory_name"+
               " END AS intransit_stock"+
               " FROM mtl_secondary_inventories inv,"+
               " mtl_system_items msi,"+
               " inv.mtl_parameters mps"+
               //" WHERE inv.attribute2 = 'S'"+
		       " WHERE (inv.attribute2 = 'S' or SECONDARY_INVENTORY_NAME='14')"+  //ADD TSCE 14倉 BY PEGGY 20210625
               " AND inv.organization_id = msi.organization_id"+
               " AND msi.organization_id = mps.organization_id"+
		 	   //" AND msi.inventory_item_status_code <> 'Inactive'"+
           	   //" AND msi.description not like '%Disable%'"+
			   " $$$ "+
		       " ??? "+
               " AND mps.organization_id = "+organizationId+") stk,"+
               " (SELECT   moq.organization_id, moq.subinventory_code, moq.inventory_item_id,SUM (moq.primary_transaction_quantity) onhand_qty"+
               " FROM mtl_onhand_quantities_detail moq GROUP BY moq.organization_id,moq.subinventory_code, moq.inventory_item_id) onh,"+
               " (SELECT   moq.organization_id, moq.subinventory_code,moq.inventory_item_id,SUM (moq.primary_transaction_quantity) onway_qty"+
               " FROM mtl_onhand_quantities_detail moq,mtl_secondary_inventories msi "+
			   //" WHERE moq.subinventory_code IN ('12', '22', '32', '42','52') "+  //用倉庫名判別,add by Peggy 20210413
			   " WHERE moq.organization_id=msi.organization_id"+
			   " and moq.subinventory_code=msi.secondary_inventory_name"+
			   " and msi.description LIKE '%In Transit%'"+
               " GROUP BY moq.organization_id,moq.subinventory_code, moq.inventory_item_id) ins,"+
               " (SELECT   hub subinventory_code, item_id inventory_item_id,(SUM (order_qty) / 1000) qty_1211 FROM tsc_om_1211"+
               " WHERE l_status IN ('AWAITING_SHIPPING', 'ENTERED', 'BOOKED')  AND item_id != 29570 GROUP BY hub, item_id) om1211,"+
               " (SELECT   hub subinventory_code, item_id inventory_item_id,(SUM (order_qty) / 1000) qty_1213 FROM tsc_om_1213"+
               " WHERE l_status IN ('AWAITING_SHIPPING', 'ENTERED', 'BOOKED') GROUP BY hub, item_id) om1213 "+
   		       " WHERE stk.organization_id = onh.organization_id(+)"+
     	       " AND stk.inventory_item_id = onh.inventory_item_id(+)"+
     	       " AND stk.secondary_inventory_name = onh.subinventory_code(+)"+
     	       " AND stk.organization_id = ins.organization_id(+)"+
     	       " AND stk.inventory_item_id = ins.inventory_item_id(+)"+
               " AND stk.intransit_stock = ins.subinventory_code(+)"+
               " AND stk.inventory_item_id = om1211.inventory_item_id(+)"+
     	       //" AND stk.intransit_stock = om1211.subinventory_code(+)"+
			   " AND stk.secondary_inventory_name = om1211.subinventory_code(+)"+  //modify by Peggy 20191202
               " AND stk.inventory_item_id = om1213.inventory_item_id(+)"+
               //" AND stk.intransit_stock = om1213.subinventory_code(+)"+
			   " AND stk.secondary_inventory_name = om1213.subinventory_code(+)"+  //modify by Peggy 20191202
               " ***"+
               " ORDER BY 1, 2, 3";
		if (!item.equals("") && item != null)
		{
			sqla = sqla.replace("???","AND (msi.SEGMENT1 like upper('"+item+"%') or upper(msi.DESCRIPTION) like upper('"+item+"%'))");
		}
		else
		{
			sqla = sqla.replace("???","");
		}
		if (conZero.equals("Y"))
		{
			sqla = sqla.replace("***","");
		}
		else
		{
			sqla = sqla.replace("***","AND (NVL (onh.onhand_qty, 0)>0  OR NVL (ins.onway_qty, 0) >0  OR   NVL (qty_1211, 0) >0 OR Nvl(qty_1213,0) >0)");
		}
		if (! Stock.equals("") &&  Stock != null && !Stock.equals("--"))
		{
			sqla = sqla.replace("$$$","AND inv.secondary_inventory_name = '" +Stock+"'");
		}
		else
		{
			sqla = sqla.replace("$$$","");
		}	
		//out.println(sqla);	
		OutputStream os = null;	
		if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
		{ // For Unix Platform
      		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/TSC_MMT_"+userID+"_"+hmsCurr+".xls");
		}  
		else 
		{ // For Windows Platform
	    	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\TSC_MMT_"+userID+"_"+hmsCurr+".xls");
	    }
    	jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
		//file://建立Excel工作表的 sheet名稱
    	jxl.write.WritableSheet ws = wwb.createSheet("I6", 0); //-- TEST
	
		//jxl.Sheet ws = wwb.createSheet("Sales Delivery Request", 0);
		jxl.SheetSettings sst = ws.getSettings(); 
	
    	// 抬頭列字型15
		jxl.write.WritableFont wf2Title = new jxl.write.WritableFont(WritableFont.TIMES, 15,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    	jxl.write.WritableCellFormat wcf2Title = new jxl.write.WritableCellFormat(wf2Title); 
		wcf2Title.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    	// 條件列字型12
    	jxl.write.WritableFont wf2Cond = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    	jxl.write.WritableCellFormat wcf2Cond = new jxl.write.WritableCellFormat(wf2Cond); 
		wcf2Cond.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    	// Header 列背景灰色
    	jxl.write.WritableFont wf2Header = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    	jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(wf2Header); 
		wcf2Header.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    	wcf2Header.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色
    	// 內容 列 定義
    	jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    	jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
		wcf2Content.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	
		jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    	jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
		wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    	wcfT.setAlignment(jxl.format.Alignment.LEFT);
	
		sst.setSelected();
		sst.setVerticalFreeze(1);  //凍結窗格
		sst.setFitToPages(true);	
		sst.setFitWidth(1);  // 設定一頁寬

		//抬頭:(第6列第0行)		// 明細抬頭說明
		jxl.write.Label labelCF0 = new jxl.write.Label(0, 0, "No", wcfT); // (行,列)
    	ws.addCell(labelCF0);
		ws.setColumnView(0,5);
	
    	jxl.write.Label labelC1 = new jxl.write.Label(1, 0, "ITEM NO", wcfT); // (行,列)
    	ws.addCell(labelC1);
		ws.setColumnView(1,28);		
	
		jxl.write.Label labelCFC2 = new jxl.write.Label(2, 0, "Description", wcfT); // (行,列)
    	ws.addCell(labelCFC2);
		ws.setColumnView(2,25);
	
		//抬頭:(第6列第1行)
		jxl.write.Label labelCF3 = new jxl.write.Label(3, 0, "UOM", wcfT); // (行,列)
    	ws.addCell(labelCF3);
		ws.setColumnView(3,6);

		//抬頭:(第6列第1行)
		jxl.write.Label labelCF4 = new jxl.write.Label(4, 0, "InvNo", wcfT); // (行,列)
    	ws.addCell(labelCF4 );
		ws.setColumnView(4,5);

		//抬頭:(第6列第2行)
		jxl.write.Label labelCF6 = new jxl.write.Label(5, 0, "On Hand Qty", wcfT); // (行,列)
    	ws.addCell(labelCF6);
		ws.setColumnView(6,15);
	
		//抬頭:(第6列第3行)
		jxl.write.Label labelCF7 = new jxl.write.Label(6, 0, "On The Way", wcfT); // (行,列)
    	ws.addCell(labelCF7);
		ws.setColumnView(7,15);
	
		//抬頭:(第6列第4行)
		jxl.write.Label labelCFC8 = new jxl.write.Label(7, 0, "1213/1214Unship Qty", wcfT); // (行,列)
    	ws.addCell(labelCFC8);
		ws.setColumnView(8,15);
	
		//抬頭:(第6列第5行)
		jxl.write.Label labelCFC9 = new jxl.write.Label(8, 0, "1211/1215Unship Qty", wcfT); // (行,列)
    	ws.addCell(labelCFC9);
		ws.setColumnView(9,12);
	
		//抬頭:(第6列第6行)
		jxl.write.Label labelCF10 = new jxl.write.Label(9, 0, "Available Qty", wcfT); // (行,列)
    	ws.addCell(labelCF10);
		ws.setColumnView(10,8);

	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 1;
		int rowNo = 1;  //第二列開始
		
		//out.println("sqla="+sqla);
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sqla); 		
		while (rs.next())
		{	
			noSeq = noSeq + 1;
		  	noSeqStr = Integer.toString(noSeq);
		  	String rowNoStr = Integer.toString(rowNo);		  

		  	jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          	jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		  	//wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  	wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  
		  
		  	jxl.write.Label lable0 = new jxl.write.Label(0, rowNo, noSeqStr , wcfFL); // (行,列);由第2列開始顯示動態資料
          	ws.addCell(lable0);	
	  		  
		  	invItem = rs.getString("ITEM_NAME");  //ITEM_NO
		  	jxl.write.Label lable1 = new jxl.write.Label(1, rowNo, invItem , wcfFL); // (行,列);
          	ws.addCell(lable1);

		  	itemDesc = rs.getString("ITEM_DESC");  //DESCRIPTION
		  	jxl.write.Label lable2 = new jxl.write.Label(2, rowNo, itemDesc , wcfFL); // (行,列);
          	ws.addCell(lable2);	
		  	  	  
		  	uom = "KPC";  //rs.getString("UOM");  //UOM
		  	jxl.write.Label lable3 = new jxl.write.Label(3, rowNo, uom , wcfFL); // (行,列); 
          	ws.addCell(lable3);

		  	subInv = rs.getString("secondary_inventory_name");  //SUBINV
		  	jxl.write.Label lable4 = new jxl.write.Label(4, rowNo, subInv , wcfFL); // (行,列); 
          	ws.addCell(lable4);

          	itemId=rs.getString("INVENTORY_ITEM_ID");  //INVENTORY_ITEM_ID
			fgOhQty=new java.text.DecimalFormat("0.###").format(rs.getFloat("ONHAND_QTY")); 
			onWayQty=new java.text.DecimalFormat("0.###").format(rs.getFloat("ONWAY_QTY"));
			Qty1211=new java.text.DecimalFormat("0.###").format(rs.getFloat("QTY_1211"));
	    	Qty1213=new java.text.DecimalFormat("0.###").format(rs.getFloat("QTY_1213"));
			avaiQty =new java.text.DecimalFormat("#.###").format(rs.getFloat("available_qty"));			
			//顯示on_hand
      		//String sqlOh = "   SELECT SUM(MOQ.PRIMARY_TRANSACTION_QUANTITY) ONHAND_QTY "+
 			//		 "     FROM MTL_ONHAND_QUANTITIES_DETAIL MOQ "+
			//	     "    WHERE MOQ.ORGANIZATION_ID=163   "+
  			//		 "      AND MOQ.SUBINVENTORY_CODE='"+subInv+"'  AND MOQ.INVENTORY_ITEM_ID='"+itemId+"'  ";
	  		//Statement stateOh=con.createStatement();
      		//ResultSet rsOh=stateOh.executeQuery(sqlOh);
	  		//if (rsOh.next())
			//{
	 	  	//	fgOhQtyf = rsOh.getFloat("ONHAND_QTY"); 
		 	//}
	  		//rsOh.close();
	  		//stateOh.close();

			//顯示在途倉數量
        	//if (subInv=="10" || subInv.equals("10")) onWayInv="12";
        	//if (subInv=="20" || subInv.equals("20")) onWayInv="22";
        	//if (subInv=="30" || subInv.equals("30")) onWayInv="32";
        	//if (subInv=="40" || subInv.equals("40")) onWayInv="42";

      		//String sqlway = "   SELECT SUM (moq.primary_transaction_quantity) ONWAY_QTY   FROM mtl_onhand_quantities_detail moq"+  
  			//		  "    WHERE moq.organization_id = 163  AND moq.inventory_item_id = '"+itemId+"' "+
            //        "      AND moq.subinventory_code = '"+onWayInv+"'  ";
	  		//Statement stateWay=con.createStatement();
      		//ResultSet rsWay=stateWay.executeQuery(sqlway);
	  		//if (rsWay.next())
			//{
	 	  	//	onWayQty = rsWay.getString("ONWAY_QTY"); 
		 	//}
	  		//rsWay.close();
	  		//stateWay.close();
      		//if (onWayQty==null || onWayQty.equals("")) onWayQty="0"; 

			//顯示1211/1213未交數量
      		//String sqlUnShip = " SELECT A.QTY_1211,B.QTY_1213 FROM  "+
            //          "    (SELECT (SUM(ORDER_QTY)/1000) QTY_1211 FROM TSC_OM_1211 "+
			//	      "      WHERE L_STATUS IN ('AWAITING_SHIPPING','ENTERED','BOOKED')  AND HUB='"+subInv+"' AND ITEM_ID='"+itemId+"' ) A, "+
			//		  "    (SELECT DISTINCT (SUM(ORDER_QTY)/1000) QTY_1213 FROM TSC_OM_1213 "+
			//	      "      WHERE  L_STATUS IN ('AWAITING_SHIPPING','ENTERED','BOOKED')  AND HUB='"+subInv+"' AND ITEM_ID='"+itemId+"' ) B  ";
	  		//Statement stateUnShip=con.createStatement();
      		//ResultSet rsUnShip=stateUnShip.executeQuery(sqlUnShip);
	  		//if (rsUnShip.next())
			//{
		    //	Qty1211f=rsUnShip.getFloat("QTY_1211");
	    	//	Qty1213f=rsUnShip.getFloat("QTY_1213");
		 	//}
	  		//rsUnShip.close();
	  		//stateUnShip.close();

			//小數轉換___起
			//try
			//{
    		//	java.text.DecimalFormat nf = new java.text.DecimalFormat("#.###"); // 取小數後三位
	  		//	avaiQtyf = fgOhQtyf + Qty1213f - Qty1211f;
	  		//	fgOhQty = nf.format(fgOhQtyf);
	  		//	Qty1213 = nf.format(Qty1213f);
	  		//	Qty1211 = nf.format(Qty1211f);
	  		//	avaiQty = nf.format(avaiQtyf);
    		//} //end of try
    		//catch (Exception e)
    		//{
      		//	out.println("Exception f:"+e.getMessage());
    		//}

			//小數轉換___迄
          	//on hand qty
	      	jxl.write.Label lable6 = new jxl.write.Label(5, rowNo, fgOhQty , wcfFL); // (行,列); 
          	ws.addCell(lable6);

          	//onWayQty
          	if(subInv=="13" || subInv.equals("13")) onWayQty="";  //13倉無在途數量
	      	jxl.write.Label lable7 = new jxl.write.Label(6, rowNo, onWayQty , wcfFL); // (行,列); 
          	ws.addCell(lable7);
		  
          	//Qty1213
          	if(subInv=="13" || subInv.equals("13")) Qty1213="";  //13倉無Qty1213
	      	jxl.write.Label lable8 = new jxl.write.Label(7, rowNo, Qty1213 , wcfFL); // (行,列); 
          	ws.addCell(lable8);

          	//Qty1211
          	if(subInv=="13" || subInv.equals("13")) Qty1211="";  //13倉無Qty1211
		  	jxl.write.Label lable9 = new jxl.write.Label(8, rowNo, Qty1211 , wcfFL); // (行,列); 
          	ws.addCell(lable9);

          	//avaiQty
		  	jxl.write.Label lable10 = new jxl.write.Label(9, rowNo, avaiQty , wcfFL); // (行,列); 
          	ws.addCell(lable10);

		  	rowNo = rowNo + 1;		   
	  	}   // End of While rs.next()
		
	 	rs.close();
	 	statement.close();

		//寫入Excel 
		wwb.write(); 
    	//關閉Excel工作薄 

   		wwb.close(); // close workbook //
   		os.close();   // close file outputstream //
   		out.close(); 
  	} //end of try
  	catch (Exception e)
  	{
   		out.println("Exception I6:"+e.getMessage());
  	}
}  //end typeid=5  //I6 excel EXPORT

 %>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
    response.reset();
    response.setContentType("application/vnd.ms-excel");					
    response.sendRedirect("/oradds/report/TSC_MMT_"+userID+"_"+hmsCurr+".xls"); 
%>
</html>

