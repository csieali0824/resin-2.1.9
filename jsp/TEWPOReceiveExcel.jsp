<!-- modify by Peggy 20140903,增加庫存數量查詢條件-->
<!-- modify by Peggy 20151118,增加調撥數量,調撥日期欄位-->
<!-- modify by Peggy 20170920,新增remarks欄位-->
<!-- modify by Peggy 20171205,新增不符FIFO原因-->
<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*,java.lang.Object.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TEWPOReceiveExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");
String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
String STOCK_AGE = request.getParameter("STOCK_AGE");
if (STOCK_AGE==null) STOCK_AGE="";
String ORGCODE= request.getParameter("ORGCODE");
if (ORGCODE==null) ORGCODE="";
String SUPPLIER = request.getParameter("SUPPLIER");
if (SUPPLIER==null) SUPPLIER="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String ITEM=request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String DATE_CODE = request.getParameter("DATE_CODE");
if (DATE_CODE==null) DATE_CODE="";
String LOT_NUMBER = request.getParameter("LOT_NUMBER");
if (LOT_NUMBER==null) LOT_NUMBER="";
String STOCK = request.getParameter("STOCK");  //add by Peggy 20140903
if (STOCK==null) STOCK="";
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=9,colcnt=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,line=0,mergeCol=0;
	String column1="",column2="",column3="",column4="",column5="",mo_CRD="",mo_QTY="",mo_PRICE="",mo_SSD="";
	OutputStream os = null;	
	RPTName = "TEW_RECEIVE_LIST";
	FileName = RPTName+"("+userID+")"+dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置中-格線-底色黃
	WritableCellFormat CenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	CenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
	CenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	CenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	CenterBLY.setBackground(jxl.write.Colour.YELLOW); 
	CenterBLY.setWrap(true);	

	//英文內文水平垂直置中-格線-底色紅
	WritableCellFormat CenterBLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	CenterBLR.setAlignment(jxl.format.Alignment.CENTRE);
	CenterBLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	CenterBLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	CenterBLR.setBackground(jxl.write.Colour.RED); 
	CenterBLR.setWrap(true);	
	
	//英文內文水平垂直置中-粗體-格線-底色綠
	WritableCellFormat CenterBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	CenterBLG.setAlignment(jxl.format.Alignment.CENTRE);
	CenterBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	CenterBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	CenterBLG.setBackground(jxl.write.Colour.BRIGHT_GREEN); 
	CenterBLG.setWrap(true);
		
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
	
	//英文內文水平垂直置右-正常-格線-紅字   
	WritableCellFormat ARightLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 11,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ARightLR.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLR.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線-紅字   
	WritableCellFormat ACenterLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 11, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLR.setWrap(true);
		
	//存儲格樣式,保留三位小數   
	//NumberFormat scale2format = new NumberFormat("##0.0##");   
	//WritableCellFormat numbercellformat_scale2 = new WritableCellFormat(new WritableFont(WritableFont.createFont("ARIAL"),fontsize,WritableFont.NO_BOLD,false),scale2format);               
	//numbercellformat_scale2.setAlignment(jxl.format.Alignment.RIGHT); 
	//numbercellformat_scale2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();
		
	sql = " SELECT  trunc(sysdate)-orh.received_date stock_age"+
	      ",to_char(orh.received_date,'yyyy-mm-dd') receive_date"+
          ",orh.*"+
		  ",odr.order_number"+
		  ",odr.line_number"+
		  ",nvl(odr.cust_partno,pla.note_to_vendor) cust_partno"+
		  ",pph.CURRENCY_CODE"+
		  ",axs.VENDOR_SITE_CODE VENDOR_NAME"+
		  ",pla.line_num"+		  
		  ",nvl(orh.received_quantity,0)-nvl(orh.shipped_quantity,0)-nvl(orh.return_quantity,0)-nvl(orh.allocation_quantity,0)-nvl(orh.allot_quantity,0) onhand"+
		  ",pll.price_override"+ //add by Peggy 20140807
		  ",TSC_OM_CATEGORY(orh.inventory_item_id,orh.organization_id,'TSC_PROD_GROUP') TSC_PROD_GROUP"+
		  ",TSC_OM_CATEGORY(orh.inventory_item_id,orh.organization_id,'TSC_Family') TSC_Family"+
		  ",TSC_OM_CATEGORY(orh.inventory_item_id,orh.organization_id,'TSC_Package') TSC_Package"+
          " FROM (SELECT trh.organization_id,"+
		  "              trh.po_no,"+
          "              trh.po_header_id,"+
          "              trh.po_line_location_id,"+
          "              trh.inventory_item_id,"+
          "              trh.item_name,"+
          "              trh.item_desc,"+
          "              trd.received_date,"+
          "              trd.lot_number,"+
          "              trd.date_code,"+
		  "              trd.seq_id,"+
		  "              trr.CREATION_DATE return_date,"+
		  "              '' allocation_date,"+
		  "              trh.vendor_site_id,"+
          "              SUM (NVL (trr.return_quantity,0)) received_quantity,"+
          "              0 shipped_quantity,"+
		  "              SUM (NVL (trr.return_quantity,0)) return_quantity,"+
		  "              0 allocation_quantity,"+
		  "              0 allot_quantity,"+
		  "              nvl(trd.remarks,'') remarks,"+ //add by Peggy 20170920
		  "              nvl(trd.no_match_fifo_reason,'') no_match_fifo_reason"+  //add by Peggy 20171205
          "        FROM oraddman.tewpo_receive_header trh,"+
          "        oraddman.tewpo_receive_detail trd,"+
		  "        (select PO_LINE_LOCATION_ID,SEQ_ID,to_char(CREATION_DATE,'yyyy-mm-dd') CREATION_DATE,SUM((OLD_RECEIVED_QUANTITY-NEW_RECEIVED_QUANTITY)) RETURN_QUANTITY"+
          "        from  oraddman.tewpo_receive_revise where nvl(APPROVE_FLAG,'N')='Y' AND CHANGE_TYPE='1' GROUP BY PO_LINE_LOCATION_ID,SEQ_ID,CREATION_DATE) trr "+
          "        WHERE trh.po_line_location_id = trd.po_line_location_id"+
		  "        and trd.po_line_location_id=trr.po_line_location_id"+
		  "        and trd.seq_id=trr.seq_id"+
		  "        and nvl(trd.received_quantity,0)+nvl(trr.return_quantity,0) >0"+
          "        GROUP BY trh.organization_id,"+
          "              trh.po_no,"+
          "              trh.po_header_id,"+
          "              trh.po_line_location_id,"+
          "              trh.inventory_item_id,"+
          "              trh.item_name,"+
          "              trh.item_desc,"+
          "              trd.received_date,"+
          "              trd.lot_number,"+
		  "              trd.seq_id,"+
		  "              trh.vendor_site_id,"+
		  "              trr.CREATION_DATE,"+
          "              trd.date_code,"+
		  "              nvl(trd.remarks,''),"+ //add by Peggy 20170920
		  "              nvl(trd.no_match_fifo_reason,'')"+  //add by Peggy 20171205
		  "        union all"+
		  "        SELECT trh.organization_id,"+
		  "              trh.po_no,"+
          "              trh.po_header_id,"+
          "              trh.po_line_location_id,"+
          "              trh.inventory_item_id,"+
          "              trh.item_name,"+
          "              trh.item_desc,"+
          "              trd.received_date,"+
          "              trd.lot_number,"+
          "              trd.date_code,"+
		  "              trd.seq_id,"+
		  "              '' return_date,"+
		  "              tra.creation_date allocation_date,"+
		  "              trh.vendor_site_id,"+
          "              SUM (NVL (tra.allocation_quantity, 0)) received_quantity,"+
          "              0 shipped_quantity,"+
		  "              0 return_quantity,"+
		  "              SUM (NVL (tra.allocation_quantity,0)) allocation_quantity,"+
		  "              0 allot_quantity,"+
		  "              nvl(trd.remarks,'') remarks,"+ //add by Peggy 20170920
		  "              nvl(trd.no_match_fifo_reason,'') no_match_fifo_reason"+  //add by Peggy 20171205
          "        FROM oraddman.tewpo_receive_header trh,"+
          "        oraddman.tewpo_receive_detail trd,"+
		  "        (select PO_LINE_LOCATION_ID,SEQ_ID,to_char(CREATION_DATE,'yyyy-mm-dd') CREATION_DATE,SUM((OLD_RECEIVED_QUANTITY-NEW_RECEIVED_QUANTITY)) ALLOCATION_QUANTITY"+
          "        from  oraddman.tewpo_receive_revise where nvl(APPROVE_FLAG,'N')='Y' AND CHANGE_TYPE='3' GROUP BY PO_LINE_LOCATION_ID,SEQ_ID,CREATION_DATE) tra"+
          "        WHERE trh.po_line_location_id = trd.po_line_location_id"+
		  "        and trd.po_line_location_id=tra.po_line_location_id"+
		  "        and trd.seq_id=tra.seq_id"+
		  "        and nvl(trd.received_quantity,0)+nvl(tra.allocation_quantity,0) >0"+
          "        GROUP BY trh.organization_id,"+
          "              trh.po_no,"+
          "              trh.po_header_id,"+
          "              trh.po_line_location_id,"+
          "              trh.inventory_item_id,"+
          "              trh.item_name,"+
          "              trh.item_desc,"+
          "              trd.received_date,"+		  
          "              trd.lot_number,"+
		  "              trd.seq_id,"+
		  "              trh.vendor_site_id,"+
		  "              tra.CREATION_DATE,"+
          "              trd.date_code,"+
		  "              nvl(trd.remarks,''),"+ //add by Peggy 20170920
		  "              nvl(trd.no_match_fifo_reason,'')"+ //add by Peggy 20171205
		  "        union all"+		  
		  "        SELECT trh.organization_id,"+
		  "              trh.po_no,"+
          "              trh.po_header_id,"+
          "              trh.po_line_location_id,"+
          "              trh.inventory_item_id,"+
          "              trh.item_name,"+
          "              trh.item_desc,"+
          "              trd.received_date,"+
          "              trd.lot_number,"+
          "              trd.date_code,"+
		  "              trd.seq_id,"+
		  "              '' return_date,"+
		  "              '' allocation_date,"+
		  "              trh.vendor_site_id,"+
          "              SUM (NVL (trd.received_quantity,0)) received_quantity,"+
          "              SUM (NVL (trd.shipped_quantity, 0)) shipped_quantity,"+
		  "              0 return_quantity,"+
		  "              0 allocation_quantity,"+
		  "              (select nvl(sum(ALLOT_QTY),0)/1000 from oraddman.tew_lot_allot_detail tlad where nvl(CONFIRM_FLAG,'N')<>'Y' and tlad.po_line_location_id=trh.po_line_location_id and tlad.lot_number=trd.lot_number and tlad.seq_id=trd.seq_id) allot_quantity,"+
		  "              nvl(trd.remarks,'') remarks,"+ //add by Peggy 20170920
		  "              nvl(trd.no_match_fifo_reason,'') no_match_fifo_reason"+ //add by Peggy 20171205
          "        FROM oraddman.tewpo_receive_header trh,"+
          "        oraddman.tewpo_receive_detail trd "+
          "        WHERE trh.po_line_location_id = trd.po_line_location_id"+
		  "        and nvl(trd.received_quantity,0) >0"+
          "        GROUP BY trh.organization_id,"+
          "              trh.po_no,"+
          "              trh.po_header_id,"+
          "              trh.po_line_location_id,"+
          "              trh.inventory_item_id,"+
          "              trh.item_name,"+
          "              trh.item_desc,"+
          "              trd.received_date,"+
          "              trd.lot_number,"+
		  "              trd.seq_id,"+
		  "              trh.vendor_site_id,"+
          "              trd.date_code,"+		  
		  "              nvl(trd.remarks,''),"+ //add by Peggy 20170920
		  "              nvl(trd.no_match_fifo_reason,'')"+ //add by Peggy 20171205
          "       ) orh,"+
          " po.po_line_locations_all pll,"+
		  " po.po_lines_all pla,"+
		  " (SELECT *  FROM (SELECT a.order_number, b.line_number,DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number  ORDER BY shipment_number) seqno"+
          "                  FROM ont.oe_order_headers_all a, ont.oe_order_lines_all b"+
          "                  WHERE a.header_id = b.header_id) WHERE seqno = 1) odr,"+
          " PO.PO_HEADERS_ALL  pph,"+
		  " AP.AP_SUPPLIER_SITES_ALL axs,"+
          " AP.AP_SUPPLIERS aas"+
          " WHERE orh.po_line_location_id = pll.line_location_id"+
          " AND orh.po_header_id = pph.PO_HEADER_ID"+
		  " and orh.vendor_site_id = axs.vendor_site_id"+
          " AND axs.VENDOR_ID=aas.VENDOR_ID"+
		  " AND pll.po_line_id=pla.po_line_id"+
		  " AND pll.po_header_id=pla.po_header_id"+		  
          " AND SUBSTR (pll.note_to_receiver,1, INSTR (pll.note_to_receiver, '.') - 1) = odr.order_number(+)"+
          " AND SUBSTR (pll.note_to_receiver,INSTR (pll.note_to_receiver, '.') + 1,LENGTH (pll.note_to_receiver)) = odr.line_number(+)";
	if (ORGCODE.equals("") && ORGCODE.equals("--"))
	{
		sql += " AND orh.organization_id = '"+ ORGCODE+"'";
	}
	if (!PONO.equals(""))
	{
		sql += " AND orh.PO_NO LIKE '"+ PONO+"%'";
	}	
	if (!ITEM.equals(""))
	{
		sql += " AND (UPPER(orh.item_name) LIKE '"+ ITEM.toUpperCase()+"%' OR UPPER(orh.item_desc) LIKE '"+ITEM.toUpperCase()+"%')";
	}
	if (!SUPPLIER.equals("") && !SUPPLIER.equals("--"))
	{
		//sql += " AND aas.VENDOR_NAME LIKE '"+SUPPLIER+"%'";
		sql += " AND orh.VENDOR_SITE_ID = '"+ SUPPLIER+"'";
	}
	if (!LOT_NUMBER.equals(""))
	{
		sql += " AND orh.LOT_NUMBER = '"+ LOT_NUMBER+"'";
	}
	if (!DATE_CODE.equals(""))
	{
		sql += " AND orh.date_code = '"+ DATE_CODE+"'";
	}			
	if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
	{
		sql += " AND to_char(orh.RECEIVED_DATE,'yyyymmdd') >= '" + (YearFr.equals("--") || YearFr.equals("")?"2010":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"00":DayFr)+"'";
	}
	if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") || !DayTo.equals("")))
	{
		sql += " AND to_char(orh.RECEIVED_DATE,'yyyymmdd') <= '" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"'";
	}
	if (STOCK.equals("1")) //add by Peggy 20140903,庫存數量>0
	{
		sql += " AND nvl(orh.received_quantity,0)-nvl(orh.shipped_quantity,0)-nvl(orh.return_quantity,0)-nvl(orh.allocation_quantity,0) >0";
	}
	else if (STOCK.equals("2")) //add by Peggy 20140903,庫存數量=0
	{
		sql += " AND nvl(orh.received_quantity,0)-nvl(orh.shipped_quantity,0)-nvl(orh.return_quantity,0)-nvl(orh.allocation_quantity,0) =0";
	}	
	sql += " ORDER BY receive_date DESC, item_name, lot_number DESC,seq_id";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//庫齡天數
			ws.addCell(new jxl.write.Label(col, row, "庫齡天數" , ACenterBLB));
			ws.setColumnView(col,10);
			col++;	

			//收料日期
			ws.addCell(new jxl.write.Label(col, row, "收料日期" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//LOT
			ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//數量(K)
			ws.addCell(new jxl.write.Label(col, row, "數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//撿貨數量
			ws.addCell(new jxl.write.Label(col, row, "撿貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//已轉ERP數量(K)
			ws.addCell(new jxl.write.Label(col, row, "出貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//庫存
			ws.addCell(new jxl.write.Label(col, row, "庫存數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//D/C
			ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//M/O單號
			ws.addCell(new jxl.write.Label(col, row, "M/O單號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//客戶品號
			ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//採購單號
			ws.addCell(new jxl.write.Label(col, row, "採購單號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//採購單項次
			ws.addCell(new jxl.write.Label(col, row, "採購單項次" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;

			//採購角色及系統管理員可看單價,add by Peggy 20140807
			if (UserRoles.indexOf("TEW_BUYER") >=0 || UserRoles.indexOf("admin") >=0)
			{
				//單價
				ws.addCell(new jxl.write.Label(col, row, "單價" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;			
			}
			
			//幣別
			ws.addCell(new jxl.write.Label(col, row, "幣別" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
				
			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			
			//退貨日期
			ws.addCell(new jxl.write.Label(col, row, "退貨日期" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			
			//退貨數量
			ws.addCell(new jxl.write.Label(col, row, "退貨數量" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//調撥日期
			ws.addCell(new jxl.write.Label(col, row, "調撥日期" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			
			//調撥數量
			ws.addCell(new jxl.write.Label(col, row, "調撥數量" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;


			//TSC PROD GROUP
			ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;			

			//TSC Family
			ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//TSC Package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			//remarks
			ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			//不符FIFO原因
			ws.addCell(new jxl.write.Label(col, row, "不符FIFO原因" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;						
			row++;
		}
		col=0;
		if (Integer.parseInt(rs.getString("STOCK_AGE")) <=90)
		{
			ws.addCell(new jxl.write.Label(col, row, rs.getString("STOCK_AGE") , CenterBLG));
		}
		else if (Integer.parseInt(rs.getString("STOCK_AGE")) >90 && Integer.parseInt(rs.getString("STOCK_AGE")) < 180)
		{			
			ws.addCell(new jxl.write.Label(col, row, rs.getString("STOCK_AGE") , CenterBLY));
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row, rs.getString("STOCK_AGE") , CenterBLR));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIVE_DATE"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("RECEIVED_QUANTITY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ALLOT_QUANTITY")).doubleValue(), ARightL));
		col++;	
		//ws.addCell(new jxl.write.Number(col, row, (new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("SHIPPED_QUANTITY"))) , ARightL));
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SHIPPED_QUANTITY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ONHAND")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_NUMBER") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_PARTNO")==null?"":rs.getString("CUST_PARTNO")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PO_NO") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("line_num") , ACenterL));
		col++;	
		//採購角色及系統管理員可看單價,add by Peggy 20140807
		if (UserRoles.indexOf("TEW_BUYER") >=0 || UserRoles.indexOf("admin") >=0)
		{
			//單價
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("price_override")).doubleValue(), ARightL));
			col++;			
		}
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CURRENCY_CODE") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_NAME") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("return_date")==null?"":rs.getString("return_date")) ,ACenterL));
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("return_quantity"))),ARightL));
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("return_quantity")).doubleValue(),ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("allocation_date")==null?"":rs.getString("allocation_date")) ,ACenterL));
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("return_quantity"))),ARightL));
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("allocation_quantity")).doubleValue(),ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_prod_group") , ALeftL));
		col++;		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_family") , ALeftL));
		col++;		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_package") , ALeftL));
		col++;		
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("remarks")==null?"":rs.getString("remarks")) , ALeftL));
		col++;		
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("no_match_fifo_reason")==null?"":rs.getString("no_match_fifo_reason")) , ALeftL));
		col++;		
		row++;
		
		reccnt ++;
	}	
	wwb.write(); 
	
	rs.close();
	statement.close();
	
	wwb.close();
	os.close();  
	out.close(); 

	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();			 
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 	
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
try
{
	response.reset();
	response.setContentType("application/vnd.ms-excel");	
	String strURL = "/oradds/report/"+FileName+".xls"; 
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
