<!-- modify by Peggy 20140902,客戶=CHANNEL WELL, 箱碼固定為D,且放置在箱數前面,例D1,D2..-->
<!-- modify by Peggy 20150703,新增TEW_RCV_PKG.GET_SO_DESTINATION取代JSP 取訂單目的地的code-->
<!-- modify by Peggy 20151228,新增供應商發票金額-->
<!-- modify by Peggy 20160322,訂單嘜頭列入customer欄位search條件-->
<!-- modify by Peggy 20160616,新增"回T訂單"查詢條件-->
<!-- 20181211 by Peggy,客戶=駱騰, 箱碼固定為I,且放置在箱數前面,例I1,I2..-->
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
<FORM ACTION="../jsp/TEWShippedExcel.jsp" METHOD="post" name="MYFORM">
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
String VENDOR_INVOICE = request.getParameter("VENDOR_INVOICE");
if (VENDOR_INVOICE==null) VENDOR_INVOICE="";
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
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TEW_Shipped_Report";
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
	
		
	//CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	//cs1.setString(1,"41"); 
	//cs1.execute();
	//cs1.close();
		
	sql = " select x.advise_no,x.so_no,x.item_no,x.item_desc,x.PC_SCHEDULE_SHIP_DATE,x.shipping_method,x.CARTON_NO,x.SUBINVENTORY,x.lot,x.date_code,sum(x.QTY) QTY,x.pono,x.vendor_site_code,x.CUST_ITEM,x.PICK_CONFIRM_DATE,x.receipt_num,x.INVOICE_NO,x.TSC_INVOICE_NO,x.SHIPPING_REMARK,x.so_header_id,x.to_tw,x.customer,x.CARTON_NUM"+
	      ",tew_rcv_pkg.GET_SO_DESTINATION(x.advise_no,x.so_no) destination"+ //add by Peggy 20150703
		  ",x.TOTAL_AMOUNT"+ //add by Peggy 20151228
		  " from (select b.tew_advise_no advise_no"+
	      ",b.so_no"+
		  ",b.item_no"+
		  ",b.item_desc"+
		  ",to_char(b.PC_SCHEDULE_SHIP_DATE,'yyyy-mm-dd') PC_SCHEDULE_SHIP_DATE"+
		  ",a.shipping_method"+
		  //",c.CARTON_NO||a.POST_FIX_CODE CARTON_NO"+
		  ",case when length(b.SHIPPING_REMARK) >=12 and substr(b.SHIPPING_REMARK,0,12) ='CHANNEL WELL' or instr(b.SHIPPING_REMARK,'駱騰')>0 then a.POST_FIX_CODE||c.CARTON_NO else c.CARTON_NO||a.POST_FIX_CODE end as CARTON_NO"+ //modify by Peggy 20140902
		  ",c.SUBINVENTORY"+
		  ",c.lot"+
		  ",c.date_code"+
		  ",c.QTY/1000 QTY"+
		  ",e.segment1 pono"+
		  ",f.vendor_site_code"+
		  ",c.receipt_num"+
		  ",i.INVOICE_NO"+
		  ",i.TOTAL_AMOUNT"+
		  ",j.INVOICE_NO TSC_INVOICE_NO"+
		  ",DECODE(g.ITEM_IDENTIFIER_TYPE,'CUST',g.ORDERED_ITEM,'') CUST_ITEM"+
		  ",TO_CHAR(h.PICK_CONFIRM_DATE,'yyyy-mm-dd') PICK_CONFIRM_DATE"+
		  ",b.SHIPPING_REMARK"+
		  ",b.so_header_id"+
		  ",a.to_tw"+
		  ",case when a.to_tw='Y' and substr(b.so_no,1,4)='1121' then 'CKS AIRPORT' "+
		  "      when a.to_tw='Y' and substr(b.so_no,1,4)<>'1121' then 'KEELUNG' "+
		  " else '' end as DESTINATION"+
		  ",'('||m.customer_number||')'||m.CUSTOMER_NAME_PHONETIC customer"+
		  ",c.CARTON_NO CARTON_NUM"+
          " from tsc.tsc_shipping_advise_headers a"+
		  ",tsc.tsc_shipping_advise_lines b"+
		  ",tsc.tsc_pick_confirm_lines c"+
		  ",po.po_line_locations_all d"+
		  ",po_headers_all e"+
		  ",ap_supplier_sites_all f"+
		  ",ont.oe_order_lines_all g"+
		  ",tsc.tsc_pick_confirm_headers h"+
		  //",(SELECT TEW_ADVISE_NO,INVOICE_NO from apps.TSC_VENDOR_INVOICE_LINES GROUP BY TEW_ADVISE_NO,INVOICE_NO) i"+
		  ",(SELECT x.TEW_ADVISE_NO,x.INVOICE_NO,y.TOTAL_AMOUNT from apps.TSC_VENDOR_INVOICE_LINES x,tsc_vendor_invoice_headers y where x.INVOICE_NO=y.INVOICE_NO GROUP BY x.TEW_ADVISE_NO,x.INVOICE_NO,y.TOTAL_AMOUNT) i"+
		  //",(select ADVISE_HEADER_ID,INVOICE_NO from tsc.tsc_advise_dn_header_int where STATUS='S') j"+
		  ",(select distinct x.ADVISE_HEADER_ID,y.DELIVERY_NAME INVOICE_NO from tsc.tsc_advise_dn_header_int x, tsc.tsc_advise_dn_line_int y where x.STATUS='S' and x.INTERFACE_HEADER_ID=y.INTERFACE_HEADER_ID and x.ADVISE_HEADER_ID=y.ADVISE_HEADER_ID) j"+
		  ",ar_customers m"+
		  " where a.shipping_from='TEW'"+
		  " and b.tew_advise_no is not null"+
		  " AND a.advise_header_id = b.advise_header_id "+
          " and b.advise_header_id=c.advise_header_id"+
		  " and b.advise_line_id = c.advise_line_id"+
		  " and c.po_line_location_id = d.line_location_id"+
		  " and d.po_header_id=e.po_header_id "+
          " and e.vendor_site_id =f.vendor_site_id"+
		  " and b.so_header_id = g.header_id "+
		  " and b.so_line_id = g.line_id"+
		  " and a.CUSTOMER_ID=m.customer_id"+
		  " and a.advise_header_id = j.advise_header_id(+)"+
		  " and c.advise_header_id = h.advise_header_id"+
          " and b.tew_advise_no = i.tew_advise_no(+)";
	if (!ADVISENO.equals(""))
	{
		sql += " AND b.tew_advise_no like '"+ ADVISENO+"%'";
	}
	if (!PONO.equals(""))
	{
		sql += " AND e.SEGMENT1 = '"+ PONO+"'";
	}	
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
	if (!SUPPLIER.equals("") && !SUPPLIER.equals("--"))
	{
		sql += " AND f.vendor_site_id = '"+SUPPLIER+"'";
	}
	if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
	{
		sql += " AND to_char(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd')  >= '" + (YearFr.equals("--") || YearFr.equals("")?"2014":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"01":DayFr)+"'";
	}
	if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") && !DayTo.equals("")))
	{
		sql += " AND to_char(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd')  <= '" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"'";
	}
	if (!VENDOR_INVOICE.equals(""))
	{
		sql += " AND i.INVOICE_NO LIKE '"+VENDOR_INVOICE+"%'";
	}
	if (!TSC_INVOICE.equals(""))
	{
		sql += " AND j.INVOICE_NO LIKE '"+TSC_INVOICE+"%'";
	}	
	if ((!YearFr1.equals("--") && !YearFr1.equals("")) || (!MonthFr1.equals("--") && !MonthFr1.equals("")) || (!DayFr1.equals("--") && !DayFr1.equals("")))
	{
		sql += " AND TO_CHAR(h.PICK_CONFIRM_DATE,'yyyymmdd')  >= '" + (YearFr1.equals("--") || YearFr1.equals("")?"2014":YearFr1)+(MonthFr1.equals("--") || MonthFr1.equals("")?"01":MonthFr1)+(DayFr1.equals("--") || DayFr1.equals("")?"01":DayFr1)+"'";
	}
	if ((!YearTo1.equals("--") && !YearTo1.equals("")) || (!MonthTo1.equals("--") && !MonthTo1.equals("")) || (!DayTo1.equals("--") && !DayTo1.equals("")))
	{
		sql += " AND TO_CHAR(h.PICK_CONFIRM_DATE,'yyyymmdd')  <= '" + (YearTo1.equals("--") || YearTo1.equals("")?dateBean.getYearString():YearTo1)+(MonthTo1.equals("--") || MonthTo1.equals("")?dateBean.getMonthString():MonthTo1)+(DayTo1.equals("--") || DayTo1.equals("")?dateBean.getDayString():DayTo1)+"'";
	}	
	if (!RECEIPTNUM.equals(""))  //add by Peggy 20140814
	{
		sql += " AND c.receipt_num LIKE '"+ RECEIPTNUM +"%'";
	}
	if (!DATECODE.equals(""))  //add by Peggy 20140814
	{
		sql += " AND c.date_code LIKE '"+ DATECODE +"%'";
	}	
	if (!CUSTOMER.equals("")) //add by Peggy 20140814
	{
		sql += " AND (m.CUSTOMER_NUMBER like '"+CUSTOMER+"%' or upper(m.CUSTOMER_NAME_PHONETIC) like '%"+CUSTOMER.toUpperCase()+"%' or upper(b.SHIPPING_REMARK) like '%"+CUSTOMER.toUpperCase()+"%')";
	}	
	if (!TOTW.equals("--") && !TOTW.equals(""))
	{
		sql += " and a.TO_TW='"+TOTW+"'";
	}	
	sql += ") x "+
	       " group by x.advise_no,x.so_no,x.item_no,x.item_desc,x.PC_SCHEDULE_SHIP_DATE,x.shipping_method,x.CARTON_NO,x.SUBINVENTORY,x.lot,x.date_code,x.pono,x.vendor_site_code,x.CUST_ITEM,x.PICK_CONFIRM_DATE,x.receipt_num,x.INVOICE_NO,x.TSC_INVOICE_NO,x.SHIPPING_REMARK,x.so_header_id,x.to_tw,x.customer,x.CARTON_NUM,x.TOTAL_AMOUNT"+
		   " ORDER BY x.PC_SCHEDULE_SHIP_DATE , x.advise_no,to_number(x.CARTON_NUM),x.lot";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	String destination="";
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
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
			ws.setColumnView(col,40);	
			col++;	
						
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,25);	
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
			ws.setColumnView(col,40);	
			col++;	

			//出貨日期
			ws.addCell(new jxl.write.Label(col, row, "出貨日期" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//出貨方式
			ws.addCell(new jxl.write.Label(col, row, "出貨方式" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//目的地
			ws.addCell(new jxl.write.Label(col, row, "目的地" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	
			
			//箱號
			ws.addCell(new jxl.write.Label(col, row, "箱號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
					
			//lot
			ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
				
			//D/C
			ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
												
			//數量(K)
			ws.addCell(new jxl.write.Label(col, row, "數量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;

			//採購單號
			ws.addCell(new jxl.write.Label(col, row, "採購單號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//ERP交易日
			ws.addCell(new jxl.write.Label(col, row, "ERP交易日" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;			

			//驗收單號
			ws.addCell(new jxl.write.Label(col, row, "驗收單號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;			

			//供應商發票號
			ws.addCell(new jxl.write.Label(col, row, "供應商發票號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;			

			//供應商發票金額,add by Peggy 20151228
			ws.addCell(new jxl.write.Label(col, row, "供應商發票金額(USD)" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;			

			//台半發票號
			ws.addCell(new jxl.write.Label(col, row, "台半發票號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;			

			//回T訂單
			ws.addCell(new jxl.write.Label(col, row, "回T訂單" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;			
			row++;
		}
		destination=rs.getString("destination"); 
		//modify by Peggy 20150703,call TEW_RCV_PKG.GET_SO_DESTINATION取目的地
		//if (rs.getString("to_tw").equals("N"))
		//{
		//	sql = " SELECT  FDLT.LONG_TEXT  FROM FND_ATTACHED_DOCS_FORM_VL FADFV, FND_DOCUMENTS_LONG_TEXT FDLT"+
		//		  " WHERE FADFV.FUNCTION_NAME = 'OEXOEORD' AND FADFV.CATEGORY_DESCRIPTION = 'SHIPPING MARKS' AND FADFV.PK1_VALUE = to_char(?) AND FADFV.MEDIA_ID = FDLT.MEDIA_ID  AND fadfv.USER_ENTITY_NAME = 'OM Order Header'";  
		//	//out.println(sql);
		//	//out.println(rs.getString("so_header_id"));
		//	PreparedStatement statementp = con.prepareStatement(sql);
		//	statementp.setString(1,rs.getString("so_header_id"));
		//	ResultSet rsp=statementp.executeQuery();
		//	if  (rsp.next())
		//	{
		//		String splitStr[] = rsp.getString("LONG_TEXT").split("\n");	
		//		for (int k=0;k <splitStr.length;k++)
		//		{
		//			if (splitStr[k].indexOf("C/N")>=0 || splitStr[k].indexOf("C/O NO")>=0)
		//			{
		//				for (int m=k-1 ; m>=0 ; m--)
		//				{
		//					if (splitStr[m].equals("") || splitStr[m].indexOf("P/NO") >= 0 || splitStr[m].indexOf("P/N NO")>=0 || splitStr[m].indexOf("P/O NO")>=0) continue;
		//					destination = splitStr[m].replace("CHINA","");
		//					break;
		//				}
		//			}
		//		}			
		//	}
		//	rsp.close();
		//	statementp.close();
		//}
		//else
		//{
		//	destination = rs.getString("destination");
		//}
		
		col=0;
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
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_ITEM") , ALeftL));
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
		ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_SITE_CODE") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PONO") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PICK_CONFIRM_DATE")==null?"":rs.getString("PICK_CONFIRM_DATE")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("RECEIPT_NUM")==null?"":rs.getString("RECEIPT_NUM")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INVOICE_NO")==null?"":rs.getString("INVOICE_NO")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOTAL_AMOUNT")).doubleValue() , ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_INVOICE_NO")==null?"":rs.getString("TSC_INVOICE_NO")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TO_TW")==null?"":rs.getString("TO_TW")) , ACenterL));
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
