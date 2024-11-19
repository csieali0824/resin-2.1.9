<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
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
<FORM ACTION="../jsp/TSCSGOrderShipExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr="--";
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="--";
String DayFr=request.getParameter("DAYFR");
if (DayFr==null) DayFr="--";
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo="--"; 
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="--";
String DayTo=request.getParameter("DAYTO");
if (DayTo==null) DayTo="--";
String SUPPLIER = request.getParameter("SUPPLIER");
if (SUPPLIER==null) SUPPLIER="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String MONO = request.getParameter("MONO");
if (MONO==null) MONO="";
String LOT = request.getParameter("LOT");
if (LOT==null) LOT="";
String ITEM=request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String ADVISENO = request.getParameter("ADVISENO");
if (ADVISENO==null) ADVISENO="";
String SG_INVOICE = request.getParameter("SG_INVOICE");
if (SG_INVOICE==null) SG_INVOICE="";
String TSC_INVOICE = request.getParameter("TSC_INVOICE");
if (TSC_INVOICE==null) TSC_INVOICE="";
String YearFr1=request.getParameter("EYEARFR");
if (YearFr1==null) YearFr1="--";
String MonthFr1=request.getParameter("EMONTHFR");
if (MonthFr1==null) MonthFr1="--";
String DayFr1=request.getParameter("EDAYFR");
if (DayFr1==null) DayFr1="--";
String YearTo1=request.getParameter("EYEARTO");
if (YearTo1==null) YearTo1="--"; 
String MonthTo1=request.getParameter("EMONTHTO");
if (MonthTo1==null) MonthTo1="--";
String DayTo1=request.getParameter("EDAYTO");
if (DayTo1==null) DayTo1="--";
String RECEIPTNUM = request.getParameter("RECEIPTNUM");  //add by Peggy 20140814
if (RECEIPTNUM==null) RECEIPTNUM="";
String DATECODE = request.getParameter("DATECODE");  //add by Peggy 20140814
if (DATECODE==null) DATECODE="";
String CUSTOMER = request.getParameter("CUSTOMER");  //add by Peggy 20140814
if (CUSTOMER==null) CUSTOMER="";
String TOTW = request.getParameter("TOTW");  //add by Peggy 20160616
if (TOTW==null) TOTW="";
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=9,colcnt=0;
String SYearFr=request.getParameter("SYEARFR");
if (SYearFr==null) SYearFr="--";
String SMonthFr=request.getParameter("SMONTHFR");
if (SMonthFr==null) SMonthFr="--";
String SDayFr=request.getParameter("SDAYFR");
if (SDayFr==null) SDayFr="--";
String SYearTo=request.getParameter("SYEARTO");
if (SYearTo==null) SYearTo="--"; 
String SMonthTo=request.getParameter("SMONTHTO");
if (SMonthTo==null) SMonthTo="--";
String SDayTo=request.getParameter("SDAYTO");
if (SDayTo==null) SDayTo="--";
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "SG_Shipped_Report";
	FileName = RPTName+"("+userID+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
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
	
	sql = " select x.advise_no,x.so_no,x.item_no,x.item_desc,x.PC_SCHEDULE_SHIP_DATE,x.shipping_method,x.CARTON_NO,x.SUBINVENTORY,x.lot,x.date_code,sum(x.QTY) QTY,x.CUST_ITEM,x.PICK_CONFIRM_DATE,x.INVOICE_NO,x.TSC_INVOICE_NO,x.SHIPPING_REMARK,x.so_header_id,x.to_tw,x.customer,x.CARTON_NUM"+
	      ",tew_rcv_pkg.GET_SO_DESTINATION(x.advise_no,x.so_no) destination"+ //add by Peggy 20150703
		  ",x.TOTAL_AMOUNT"+ //add by Peggy 20151228
		  ",x.shipping_from_name"+
		  ",x.status_code"+
		  ",x.delivery_type"+
		  ",x.tsc_package"+
		  ",x.vendor_site_code"+
		  ",x.INITIAL_PICKUP_DATE"+
		  ",x.dc_yyww"+
		  " from (select b.tew_advise_no advise_no"+
	      ",b.so_no"+
		  ",b.item_no"+
		  ",b.item_desc"+
		  ",to_char(b.PC_SCHEDULE_SHIP_DATE,'yyyy-mm-dd') PC_SCHEDULE_SHIP_DATE"+
		  ",a.shipping_method"+
		  //",c.CARTON_NO||a.POST_FIX_CODE CARTON_NO"+
		  ",case when length(b.SHIPPING_REMARK) >=12 and substr(b.SHIPPING_REMARK,0,12) ='CHANNEL WELL' or instr(b.SHIPPING_REMARK,'駱騰')>0 then b.POST_CODE||c.CARTON_NO else c.CARTON_NO||b.POST_CODE end as CARTON_NO"+ //modify by Peggy 20140902
		  ",c.SUBINVENTORY"+
		  ",c.lot"+
		  ",c.date_code"+
		  ",c.QTY/1000 QTY"+
		  //",e.segment1 pono"+
		  //",f.vendor_site_code"+
		  //",c.receipt_num"+
		  ",j.INVOICE_NO"+
		  ",i.TOTAL_AMOUNT"+
		  ",j.TSC_INVOICE_NO TSC_INVOICE_NO"+
		  //",DECODE(g.ITEM_IDENTIFIER_TYPE,'CUST',g.ORDERED_ITEM,'') CUST_ITEM"+
          ",case when substr(b.so_no,1,1)='8' then DECODE(g.ITEM_IDENTIFIER_TYPE,'CUST',g.ORDERED_ITEM,'') "+
		  " else decode(tsc_odr.item_identifier_type,'CUST',tsc_odr.ordered_item,'') end CUST_ITEM"+
		  ",TO_CHAR(h.PICK_CONFIRM_DATE,'yyyy-mm-dd') PICK_CONFIRM_DATE"+
		  ",b.SHIPPING_REMARK"+
		  ",b.so_header_id"+
		  ",a.to_tw"+
		  ",case when a.to_tw='Y' and substr(b.so_no,1,4)='1121' then 'CKS AIRPORT' "+
		  "      when a.to_tw='Y' and substr(b.so_no,1,4)<>'1121' then 'KEELUNG' "+
		  " else '' end as DESTINATION"+
		  ",'('||m.customer_number||')'||m.CUSTOMER_NAME_PHONETIC customer"+
		  ",c.CARTON_NO CARTON_NUM"+
		  ",case a.shipping_from when 'SG1' then '內銷' when 'SG2' THEN '外銷' ELSE a.shipping_from END shipping_from_name"+
          ",wnd.STATUS_CODE"+
		  ",decode(a.delivery_type ,'VENDOR','廠商直出','') delivery_type "+//add by Peggy 20200505
		  ",tsc_inv_category(b.inventory_item_id,43,23) tsc_package"+ //add b Peggy 20201127
		  ",f.vendor_site_code"+ //add by Peggy 20201127
		  ",to_char(wnd.INITIAL_PICKUP_DATE,'yyyy-mm-dd') INITIAL_PICKUP_DATE "+ //add by Peggy 20210816
		  ",c.dc_yyww"+ //add by Peggy 20220728
          " from tsc.tsc_shipping_advise_headers a"+
		  ",tsc.tsc_shipping_advise_lines b"+
		  ",tsc.tsc_pick_confirm_lines c"+
		  //",po.po_line_locations_all d"+
		  //",po_headers_all e"+
		  ",ap_supplier_sites_all f"+
		  ",ont.oe_order_lines_all g"+
		  ",tsc.tsc_pick_confirm_headers h"+
		  //",(SELECT TEW_ADVISE_NO,INVOICE_NO from apps.TSC_VENDOR_INVOICE_LINES GROUP BY TEW_ADVISE_NO,INVOICE_NO) i"+
		  ",(SELECT x.TEW_ADVISE_NO,x.INVOICE_NO,y.TOTAL_AMOUNT from apps.TSC_VENDOR_INVOICE_LINES x,tsc_vendor_invoice_headers y where x.INVOICE_NO=y.INVOICE_NO GROUP BY x.TEW_ADVISE_NO,x.INVOICE_NO,y.TOTAL_AMOUNT) i"+
		  //",(select ADVISE_HEADER_ID,INVOICE_NO from tsc.tsc_advise_dn_header_int where STATUS='S') j"+
		  //",(select distinct x.ADVISE_HEADER_ID,y.advise_line_id,y.delivery_id,y.DELIVERY_NAME INVOICE_NO from tsc.tsc_advise_dn_header_int x, tsc.tsc_advise_dn_line_int y where x.STATUS='S' and x.INTERFACE_HEADER_ID=y.INTERFACE_HEADER_ID and x.ADVISE_HEADER_ID=y.ADVISE_HEADER_ID) j"+
		  ",(SELECT x.*,z.invoice_no tsc_invoice_no FROM (select distinct x.ADVISE_HEADER_ID,y.advise_line_id,y.so_line_id,y.DELIVERY_ID,y.DELIVERY_NAME INVOICE_NO ,x.invoice_no SG_INVOICE_NO"+
          " from tsc.tsc_advise_dn_header_int x, tsc.tsc_advise_dn_line_int y"+
          " where x.STATUS='S' "+
          " and x.INTERFACE_HEADER_ID=y.INTERFACE_HEADER_ID "+
          " and x.ADVISE_HEADER_ID=y.ADVISE_HEADER_ID) x,tsc_invoice_lines z "+
          " where x.sg_invoice_no=z.bvi_invoice_no(+)"+
          " and x.so_line_id=z.order_line_id(+)) j"+ //modify by Peggy 20201125,add tsc invoice
		  ",ar_customers m"+
		  ",wsh.wsh_new_deliveries wnd"+
		  ",(select x.order_number,y.line_number||'.'||y.shipment_number line_no,y.item_identifier_type,y.ordered_item from ont.oe_order_headers_all x,ont.oe_order_lines_all y where x.org_id=41 and x.header_id=y.header_id and y.packing_instructions='T') tsc_odr"+
		  " where a.shipping_from LIKE 'SG%'"+
		  " and b.tew_advise_no is not null"+
		  " AND a.advise_header_id = b.advise_header_id "+
          " and b.advise_header_id=c.advise_header_id"+
		  " and b.advise_line_id = c.advise_line_id"+
		  //" and c.po_line_location_id = d.line_location_id"+
		  //" and d.po_header_id=e.po_header_id "+
          " and b.vendor_site_id =f.vendor_site_id"+
		  " and b.so_header_id = g.header_id "+
		  " and b.so_line_id = g.line_id"+
		  " and a.CUSTOMER_ID=m.customer_id"+
		  " and b.advise_header_id = j.advise_header_id(+)"+
		  " and b.advise_line_id = j.advise_line_id(+)"+
		  " and c.advise_header_id = h.advise_header_id"+
		  " and j.delivery_id=wnd.delivery_id(+)"+ //add by Peggy 20200109
          " and b.tew_advise_no = i.tew_advise_no(+)"+
		  " and b.so_no=tsc_odr.order_number(+)"+
		  " and b.so_line_number=tsc_odr.line_no(+)";
	if (!ADVISENO.equals(""))
	{
		sql += " AND b.tew_advise_no like '"+ ADVISENO+"%'";
	}
	//if (!PONO.equals(""))
	//{
	//	sql += " AND e.SEGMENT1 = '"+ PONO+"'";
	//}	
	if (!MONO.equals(""))
	{
		sql += " AND b.so_no = '"+ MONO+"'";
	}	
	if (!LOT.equals(""))
	{
		sql += " AND c.lot ='" + LOT+"'";
	}
	if (!ITEM.equals(""))
	{
		sql += " AND (UPPER(b.item_no) LIKE '"+ ITEM.toUpperCase()+"%' OR UPPER(b.item_desc) LIKE '"+ITEM.toUpperCase()+"%')";
	}
	//if (!SUPPLIER.equals("") && !SUPPLIER.equals("--"))
	//{
	//	sql += " AND f.vendor_site_id = '"+SUPPLIER+"'";
	//}
	if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
	{
		sql += " AND trunc(b.PC_SCHEDULE_SHIP_DATE) >= to_date('" + (YearFr.equals("--") || YearFr.equals("")?"2014":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"01":DayFr)+"','yyyymmdd')";
	}
	if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") && !DayTo.equals("")))
	{
		sql += " AND trunc(b.PC_SCHEDULE_SHIP_DATE) <= to_date('" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"','yyyymmdd')";
	}
	if (!SG_INVOICE.equals(""))
	{
		sql += " AND j.INVOICE_NO LIKE '"+SG_INVOICE+"%'";
	}
	if (!TSC_INVOICE.equals(""))
	{
		sql += " AND j.TSC_INVOICE_NO LIKE '"+TSC_INVOICE+"%'";
	}	
	if ((!YearFr1.equals("--") && !YearFr1.equals("")) || (!MonthFr1.equals("--") && !MonthFr1.equals("")) || (!DayFr1.equals("--") && !DayFr1.equals("")))
	{
		sql += " AND trunc(h.PICK_CONFIRM_DATE)  >= to_date('" + (YearFr1.equals("--") || YearFr1.equals("")?"2014":YearFr1)+(MonthFr1.equals("--") || MonthFr1.equals("")?"01":MonthFr1)+(DayFr1.equals("--") || DayFr1.equals("")?"01":DayFr1)+"','yyyymmdd')";
	}
	if ((!YearTo1.equals("--") && !YearTo1.equals("")) || (!MonthTo1.equals("--") && !MonthTo1.equals("")) || (!DayTo1.equals("--") && !DayTo1.equals("")))
	{
		sql += " AND trunc(h.PICK_CONFIRM_DATE)  <= to_date('" + (YearTo1.equals("--") || YearTo1.equals("")?dateBean.getYearString():YearTo1)+(MonthTo1.equals("--") || MonthTo1.equals("")?dateBean.getMonthString():MonthTo1)+(DayTo1.equals("--") || DayTo1.equals("")?dateBean.getDayString():DayTo1)+"','yyyymmdd')";
	}	
	if ((!SYearFr.equals("--") && !SYearFr.equals("")) || (!SMonthFr.equals("--") && !SMonthFr.equals("")) || (!SDayFr.equals("--") && !SDayFr.equals("")))
	{
		sql += " AND wnd.STATUS_CODE is not NULL AND wnd.STATUS_CODE='CL' AND TRUNC(wnd.INITIAL_PICKUP_DATE) >= TO_DATE('" + (SYearFr.equals("--") || SYearFr.equals("")?"2020":SYearFr)+(SMonthFr.equals("--") || SMonthFr.equals("")?"01":SMonthFr)+(SDayFr.equals("--") || SDayFr.equals("")?"01":SDayFr)+"','yyyymmdd')";
	}
	if ((!SYearTo.equals("--") && !SYearTo.equals("")) || (!SMonthTo.equals("--") && !SMonthTo.equals("")) || (!SDayTo.equals("--") && !SDayTo.equals("")))
	{
		sql += " AND wnd.STATUS_CODE is not NULL AND wnd.STATUS_CODE='CL' AND TRUNC(wnd.INITIAL_PICKUP_DATE) <= TO_DATE('" + (SYearTo.equals("--") || SYearTo.equals("")?dateBean.getYearString():SYearTo)+(SMonthTo.equals("--") || SMonthTo.equals("")?dateBean.getMonthString():SMonthTo)+(SDayTo.equals("--") || SDayTo.equals("")?dateBean.getDayString():SDayTo)+"','yyyymmdd')";
	}		
	//if (!RECEIPTNUM.equals("")) 
	//{
	//	sql += " AND c.receipt_num LIKE '"+ RECEIPTNUM +"%'";
	//}
	if (!DATECODE.equals(""))  
	{
		sql += " AND c.date_code LIKE '"+ DATECODE +"%'";
	}	
	if (!CUSTOMER.equals(""))
	{
		sql += " AND (m.CUSTOMER_NUMBER like '"+CUSTOMER+"%' or upper(m.CUSTOMER_NAME_PHONETIC) like '%"+CUSTOMER.toUpperCase()+"%' or upper(b.SHIPPING_REMARK) like '%"+CUSTOMER.toUpperCase()+"%')";
	}	
	if (!TOTW.equals("--") && !TOTW.equals(""))
	{
		sql += " and a.TO_TW='"+TOTW+"'";
	}	
	sql += ") x "+
	       " group by x.shipping_from_name,x.advise_no,x.so_no,x.item_no,x.item_desc,x.PC_SCHEDULE_SHIP_DATE,x.shipping_method,x.CARTON_NO,x.SUBINVENTORY,x.lot,x.date_code,x.CUST_ITEM,x.PICK_CONFIRM_DATE,x.INVOICE_NO,x.TSC_INVOICE_NO,x.SHIPPING_REMARK,x.so_header_id,x.to_tw,x.customer,x.CARTON_NUM,x.TOTAL_AMOUNT,x.status_code,x.delivery_type,x.tsc_package,x.vendor_site_code,x.INITIAL_PICKUP_DATE,x.dc_yyww"+
		   " ORDER BY x.PC_SCHEDULE_SHIP_DATE , x.advise_no,to_number(x.CARTON_NUM),x.lot";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	String destination="";
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			SheetSettings sst = ws.getSettings(); 
			sst.setSelected();
			sst.setVerticalFreeze(1);  //凍結窗格		
			col=0;row=0;

			//內外銷
			ws.addCell(new jxl.write.Label(col, row, "內外銷" , ACenterBLB));
			ws.setColumnView(col,10);
			col++;	
			
			//Advise No
			ws.addCell(new jxl.write.Label(col, row, "Advise No" , ACenterBLB));
			ws.setColumnView(col,15);
			col++;	

			//MO單號
			ws.addCell(new jxl.write.Label(col, row, "MO單號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//客戶
			ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
			ws.setColumnView(col,35);	
			col++;	
						
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,35);	
			col++;	

			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//客戶品號
			ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//嘜頭
			ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			//出貨日期
			ws.addCell(new jxl.write.Label(col, row, "出貨日期" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//出貨方式
			ws.addCell(new jxl.write.Label(col, row, "出貨方式" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//目的地
			ws.addCell(new jxl.write.Label(col, row, "目的地" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//箱號
			ws.addCell(new jxl.write.Label(col, row, "箱號" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
					
			//lot
			ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBLB));
			ws.setColumnView(col,23);	
			col++;	
				
			//D/C
			ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//數量(K)
			ws.addCell(new jxl.write.Label(col, row, "數量(K)" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			////供應商
			//ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			//ws.setColumnView(col,20);	
			//col++;

			////採購單號
			//ws.addCell(new jxl.write.Label(col, row, "採購單號" , ACenterBLB));
			//ws.setColumnView(col,15);	
			//col++;

			//ERP交易日
			ws.addCell(new jxl.write.Label(col, row, "ERP交易日" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;			

			////驗收單號
			//ws.addCell(new jxl.write.Label(col, row, "驗收單號" , ACenterBLB));
			//ws.setColumnView(col,15);	
			//col++;			

			////供應商發票號
			//ws.addCell(new jxl.write.Label(col, row, "供應商發票號" , ACenterBLB));
			//ws.setColumnView(col,20);	
			//col++;			

			////供應商發票金額,add by Peggy 20151228
			//ws.addCell(new jxl.write.Label(col, row, "供應商發票金額(USD)" , ACenterBLB));
			//ws.setColumnView(col,20);	
			//col++;			

			//SG發票號
			ws.addCell(new jxl.write.Label(col, row, "SG發票號" , ACenterBLB));
			ws.setColumnView(col,16);	
			col++;			

			//台半發票號
			ws.addCell(new jxl.write.Label(col, row, "台半發票號" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;			

			//Ship confirm
			ws.addCell(new jxl.write.Label(col, row, "Ship Confirm" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;			

			//Ship confirm date
			ws.addCell(new jxl.write.Label(col, row, "Ship Confirm Date" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;			

			//回T訂單
			ws.addCell(new jxl.write.Label(col, row, "回T訂單" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;			

			//Delivery Instructions
			ws.addCell(new jxl.write.Label(col, row, "Delivery Instructions" , ACenterBLB));
			ws.setColumnView(col,11);	
			col++;	
			
			//tsc package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		
			
			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
					
			//DC YYWW
			ws.addCell(new jxl.write.Label(col, row, "DC YYWW" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	
			row++;
		}
		destination=rs.getString("destination"); 
		
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("shipping_from_name") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("advise_no") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("so_no"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("customer"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NO"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_ITEM")==null?"":rs.getString("CUST_ITEM")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_REMARK") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PC_SCHEDULE_SHIP_DATE") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("shipping_method") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, destination , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CARTON_NO") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
		col++;											
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("QTY")).doubleValue() , ARightL));
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_SITE_CODE") , ACenterL));
		//col++;	
		//ws.addCell(new jxl.write.Label(col, row, rs.getString("PONO") , ACenterL));
		//col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PICK_CONFIRM_DATE")==null?"":rs.getString("PICK_CONFIRM_DATE")) , ACenterL));
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, (rs.getString("RECEIPT_NUM")==null?"":rs.getString("RECEIPT_NUM")) , ACenterL));
		//col++;	
		//ws.addCell(new jxl.write.Label(col, row, (rs.getString("INVOICE_NO")==null?"":rs.getString("INVOICE_NO")) , ACenterL));
		//col++;
		//if (rs.getString("TOTAL_AMOUNT")==null)
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
		//}
		//else
		//{
		//	ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOTAL_AMOUNT")).doubleValue() , ARightL));
		//}
		//col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INVOICE_NO")==null?"":rs.getString("INVOICE_NO")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_INVOICE_NO")==null?"":rs.getString("TSC_INVOICE_NO")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("STATUS_CODE")==null||!rs.getString("STATUS_CODE").equals("CL")?"":"Y") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("STATUS_CODE")==null||!rs.getString("STATUS_CODE").equals("CL")?"":rs.getString("INITIAL_PICKUP_DATE")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TO_TW")==null?"":rs.getString("TO_TW")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("delivery_type")==null?"":rs.getString("delivery_type")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("tsc_package")==null?"":rs.getString("tsc_package")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("vendor_site_code")==null?"":rs.getString("vendor_site_code")) ,  ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("DC_YYWW")==null?"":rs.getString("DC_YYWW")) , ALeftL));
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
