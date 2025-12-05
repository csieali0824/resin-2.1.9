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
<FORM ACTION="../jsp/TSCSGPOReceiveDetailExcel.jsp" METHOD="post" name="MYFORM">
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
String STOCK = request.getParameter("STOCK");  
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
	RPTName = "SG_RECEIVE_LIST";
	//FileName = RPTName+"("+userID+")"+dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
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
	
	//英文內文水平垂直置右-正常-格線-藍字   
	WritableCellFormat ARightLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 11,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ARightLB.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLB.setWrap(true);		
		
	//存儲格樣式,保留三位小數   
	//NumberFormat scale2format = new NumberFormat("##0.0##");   
	//WritableCellFormat numbercellformat_scale2 = new WritableCellFormat(new WritableFont(WritableFont.createFont("ARIAL"),fontsize,WritableFont.NO_BOLD,false),scale2format);               
	//numbercellformat_scale2.setAlignment(jxl.format.Alignment.RIGHT); 
	//numbercellformat_scale2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);

	sql = " SELECT X.*,X.RECEIVED_QTY+X.ALLOCATE_IN_QTY-(X.ALLOCATE_OUT_QTY+X.RETURN_QTY+X.SHIPPED_QTY+X.PICK_QTY) ONHAND "+
	      " FROM (SELECT A.SG_STOCK_ID"+
		  "       ,A.ORGANIZATION_ID"+
          "       ,CASE A.ORGANIZATION_ID WHEN 907 THEN '內銷' WHEN 908 THEN '外銷' ELSE '??' END AS organization_name"+
          "       ,TRUNC(SYSDATE)-TRUNC(A.RECEIVED_DATE) STOCK_AGE"+
          "       ,A.INVENTORY_ITEM_ID ITEM_ID"+
          "       ,A.ITEM_NAME"+
          "       ,A.ITEM_DESC"+
		  "       ,APPS.TSCC_GET_FLOW_CODE(A.INVENTORY_ITEM_ID) as FLOW_CODE \n" +
          "       ,A.SUBINVENTORY_CODE"+
          "       ,A.LOT_NUMBER"+
          "       ,A.DATE_CODE"+
		  "       ,A.DC_YYWW"+ //add by Peggy 20220721
          "       ,NVL(A.RECEIVED_QTY,0)/1000 RECEIVED_QTY"+
          "       ,NVL(A.ALLOCATE_IN_QTY,0)/1000 ALLOCATE_IN_QTY"+
          "       ,NVL(A.RETURN_QTY,0)/1000 RETURN_QTY"+
          "       ,NVL(A.ALLOCATE_OUT_QTY,0)/1000 ALLOCATE_OUT_QTY"+
          "       ,NVL(A.SHIPPED_QTY,0)/1000 SHIPPED_QTY"+
          "       ,NVL((SELECT SUM(TPCL.QTY) QTY FROM TSC_PICK_CONFIRM_LINES TPCL,TSC_PICK_CONFIRM_HEADERS TPCH WHERE TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.PICK_CONFIRM_DATE IS NULL AND  TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID AND TPCL.SG_STOCK_ID=A.SG_STOCK_ID),0)/1000 PICK_QTY"+
          "       ,TO_CHAR(A.RECEIVED_DATE,'YYYY/MM/DD') RECEIVED_DATE"+
          "       ,B.NOTE_TO_RECEIVER"+
          "       ,A.VENDOR_CARTON_NO"+
          "       ,D.SEGMENT1 PO_NO"+
          "       ,D.CURRENCY_CODE"+
          "       ,C.LINE_NUM"+
		  "       ,TO_CHAR(B.NEED_BY_DATE,'YYYY/MM/DD') NEED_BY_DATE"+
          "       ,A.VENDOR_SITE_ID"+
          "       ,A.VENDOR_SITE_CODE"+
          //"       ,NVL(A.CUST_PARTNO,NVL(TRIM(REPLACE(REPLACE(CASE INSTR(C.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN C.NOTE_TO_VENDOR ELSE SUBSTR(C.NOTE_TO_VENDOR,1,INSTR(C.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
		  "       ,NVL(A.CUST_PARTNO,NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(C.NOTE_TO_VENDOR)"+ //modify by Peggy 20230607
          "       ,CASE WHEN B.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
          "       FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
          "       WHERE x.org_id= CASE WHEN SUBSTR(B.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
          "       AND x.header_id=y.header_id"+
          "       AND y.packing_instructions='T'"+
          "       AND x.order_number= SUBSTR(B.NOTE_TO_RECEIVER,1,INSTR(B.NOTE_TO_RECEIVER,'.')-1)"+
          "       AND y.shipment_number=1 and y.line_number=SUBSTR(B.NOTE_TO_RECEIVER,INSTR(B.NOTE_TO_RECEIVER,'.')+1))"+
          "       ELSE '' END)) PO_CUST_PARTNO"+
		  "       ,A.CREATED_BY"+
          "       ,TSC_INV_CATEGORY(A.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP"+
          "       ,TSC_INV_CATEGORY(A.INVENTORY_ITEM_ID,43,21) TSC_FAMILY"+
          "       ,TSC_INV_CATEGORY(A.INVENTORY_ITEM_ID,43,23) TSC_PACKAGE "+   
          "       FROM ORADDMAN.TSSG_STOCK_OVERVIEW A"+
          "       ,PO.PO_LINE_LOCATIONS_ALL B"+
          "       ,PO.PO_LINES_ALL C"+
          "       ,PO.PO_HEADERS_ALL D"+
          "       WHERE A.RECEIVED_DATE between to_date('" + (YearFr.equals("--") || YearFr.equals("")?"2020":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"02":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"01":DayFr)+"','yyyymmdd')"+
 		  "       AND to_date('" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"','yyyymmdd')+0.99999"+
          "       AND A.PO_LINE_LOCATION_ID=B.LINE_LOCATION_ID(+)"+
          "       AND B.PO_LINE_ID=C.PO_LINE_ID(+)"+
          "       AND A.PO_HEADER_ID=D.PO_HEADER_ID(+)) X "+
		  "       WHERE 1=1";
	/*sql = " select a.* from TSSG_ONHAND_V a"+
          " where a.TRANSACTION_DATE between to_date('" + (YearFr.equals("--") || YearFr.equals("")?"2020":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"02":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"01":DayFr)+"','yyyymmdd')"+
 		  " AND to_date('" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"','yyyymmdd')+0.99999";*/
	if (!ORGCODE.equals("") && !ORGCODE.equals("--"))
	{
		sql += " AND X.ORGANIZATION_ID = '"+ ORGCODE+"'";
	}
	if (!PONO.equals(""))
	{
		sql += " AND X.PO_NO LIKE '"+ PONO+"%'";
	}	
	
	if (!ITEM.equals(""))
	{
		sql += " AND (UPPER(X.ITEM_NAME) LIKE '"+ ITEM.toUpperCase()+"%' OR UPPER(X.ITEM_DESC) LIKE '"+ITEM.toUpperCase()+"%')";
	}	

	if (!SUPPLIER.equals("") && !SUPPLIER.equals("--"))
	{
		sql += " AND X.VENDOR_SITE_ID = '"+ SUPPLIER+"'";
	}	

	if (!LOT_NUMBER.equals(""))
	{
		sql += " AND X.LOT_NUMBER = '"+ LOT_NUMBER+"'";
	}	
	if (!DATE_CODE.equals(""))
	{
		sql += " AND X.DATE_CODE = '"+ DATE_CODE+"'";
	}		
	if (STOCK.equals("1"))
	{
		sql += " AND X.RECEIVED_QTY+X.ALLOCATE_IN_QTY-(X.ALLOCATE_OUT_QTY+X.RETURN_QTY+X.SHIPPED_QTY+X.PICK_QTY)<>0";
	}
	else if (STOCK.equals("2")) 
	{
		sql += " AND X.RECEIVED_QTY+X.ALLOCATE_IN_QTY-(X.ALLOCATE_OUT_QTY+X.RETURN_QTY+X.SHIPPED_QTY+X.PICK_QTY)=0";
	}
	else if (STOCK.equals("3"))
	{
		sql += " AND NVL(x.RETURN_QTY,0)>0";
	}
	else if (STOCK.equals("4"))
	{
		sql += " AND NVL(x.PICK_QTY,0)>0";
	}
	else if (STOCK.equals("5"))
	{
		sql += " AND NVL(x.SHIPPED_QTY,0)>0";
	}
	else if (STOCK.equals("6"))
	{
		sql += " AND NVL(x.ALLOCATE_IN_QTY,0)+NVL(x.ALLOCATE_OUT_QTY,0)>0";
	}
    sql +=" ORDER BY X.STOCK_AGE,X.ORGANIZATION_ID,X.ITEM_DESC,X.RECEIVED_DATE,X.LOT_NUMBER,X.DATE_CODE,NVL(X.VENDOR_CARTON_NO,'0')";
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
			ws.setColumnView(col,6);
			col++;	

			//內外銷
			ws.addCell(new jxl.write.Label(col, row, "內外銷" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//收料日期
			ws.addCell(new jxl.write.Label(col, row, "收料日期" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,35);	
			col++;	

			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;

			//Flow Code
			ws.addCell(new jxl.write.Label(col, row, "Flow Code" , ACenterBLB));
			ws.setColumnView(col,10);
			col++;

			//倉別
			ws.addCell(new jxl.write.Label(col, row, "倉別" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//LOT
			ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBLB));
			ws.setColumnView(col,22);	
			col++;	

			//D/C
			ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//數量(K)
			ws.addCell(new jxl.write.Label(col, row, "收貨量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//退貨數量(K)
			ws.addCell(new jxl.write.Label(col, row, "退貨量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//調撥入(K)
			ws.addCell(new jxl.write.Label(col, row, "調撥入(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//調撥(K)
			ws.addCell(new jxl.write.Label(col, row, "調撥出(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//出貨數量(K)
			ws.addCell(new jxl.write.Label(col, row, "出貨量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//撿貨數量
			ws.addCell(new jxl.write.Label(col, row, "撿貨量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//庫存
			ws.addCell(new jxl.write.Label(col, row, "庫存量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
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
		
			//幣別
			ws.addCell(new jxl.write.Label(col, row, "幣別" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
				
			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//供應商箱號
			ws.addCell(new jxl.write.Label(col, row, "供應商箱號" , ACenterBLB));
			ws.setColumnView(col,18);	
			col++;

			//TSC PROD GROUP
			ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;			

			//TSC Family
			ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;

			//TSC Package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;

			//DC YYWW
			ws.addCell(new jxl.write.Label(col, row, "DC_YYWW" , ACenterBLB));
			ws.setColumnView(col,10);	
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
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORGANIZATION_NAME"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIVED_DATE"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;
		// flow code
		ws.addCell(new jxl.write.Label(col, row, rs.getString("FLOW_CODE") , ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SUBINVENTORY_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("RECEIVED_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("RETURN_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ALLOCATE_IN_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ALLOCATE_OUT_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SHIPPED_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PICK_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ONHAND")).doubleValue(), (rs.getFloat("ONHAND")>0?ARightLB:(rs.getFloat("ONHAND")<0?ARightLR:ARightL))));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PO_CUST_PARTNO")==null?"":rs.getString("PO_CUST_PARTNO")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PO_NO")==null?"":rs.getString("PO_NO")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("line_num")==null?"":rs.getString("line_num")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CURRENCY_CODE")==null?"":rs.getString("CURRENCY_CODE")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("VENDOR_SITE_CODE")==null?"":rs.getString("VENDOR_SITE_CODE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("VENDOR_CARTON_NO")==null?"":rs.getString("VENDOR_CARTON_NO")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_prod_group") , ALeftL));
		col++;		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_family") , ALeftL));
		col++;		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_package") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("DC_YYWW")==null?"":rs.getString("DC_YYWW")) , ALeftL));  //add by Peggy 20220721
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
