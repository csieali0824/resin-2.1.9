<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,java.lang.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCSGSupplierAccountsPayableExcel.jsp" METHOD="post" name="MYFORM">
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String FileName="",RPTName="",PLANTNAME="",sql="",remarks="",v_vendor_site="";
int fontsize=8,colcnt=0,sheetcnt=0,icnt=0,i_loop=0,i_data=2;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0,idx=0;
	OutputStream os = null;	
	RPTName = "SG Supplier Account Payable Detail";
	FileName = RPTName+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);

	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold_b = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBL = new WritableCellFormat(font_bold);   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(true);	

	//英文內文水平垂直置中-粗體-格線-底色藍  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.PALE_BLUE); 
	ACenterBLB.setWrap(true);
	
	//英文內文水平垂直置中-粗體-格線-底色黃  
	WritableCellFormat ACenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLY.setBackground(jxl.write.Colour.YELLOW); 
	ACenterBLY.setWrap(true);	
	
	//英文內文水平垂直置中-粗體-格線-底色橘
	WritableCellFormat ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
	ACenterBLO.setWrap(true);	
	
	//英文內文水平垂直置中-粗體-格線-底色綠
	WritableCellFormat ACenterBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLG.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLG.setBackground(jxl.write.Colour.BRIGHT_GREEN); 
	ACenterBLG.setWrap(true);	
			
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(font_nobold);   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);


	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(font_nobold);   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(font_nobold);   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
	
	//英文內文水平垂直置左-正常-格線-底色黃  
	WritableCellFormat ALeftLY = new WritableCellFormat(font_nobold);   
	ALeftLY.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLY.setBackground(jxl.write.Colour.YELLOW);
	ALeftLY.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterLB = new WritableCellFormat(font_nobold_b);   
	ACenterLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLB.setWrap(true);


	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightLB = new WritableCellFormat(font_nobold_b);   
	ARightLB.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLB.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftLB = new WritableCellFormat(font_nobold_b);   
	ALeftLB.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLB.setWrap(true);
		
	//英文內文水平垂直置中-正常-格線-底色粉紅
	WritableCellFormat ACenterLP = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterLP.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLP.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLP.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLP.setBackground(jxl.write.Colour.PINK); 	
	ACenterLP.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線-底色淺綠
	WritableCellFormat ACenterLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterLG.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLG.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
	ACenterLG.setWrap(true);	

	//英文內文水平垂直置中-正常-格線-底色粉紅-藍字
	WritableCellFormat ACenterLPB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLPB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLPB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLPB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLPB.setBackground(jxl.write.Colour.PINK); 	
	ACenterLPB.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線-底色淺綠-藍字
	WritableCellFormat ACenterLGB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLGB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLGB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLGB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLGB.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
	ACenterLGB.setWrap(true);	
		
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);

	//日期格式
	WritableCellFormat DATE_FORMAT1 = new WritableCellFormat(font_nobold_b ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT1.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT1.setWrap(true);
	
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = null;
	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
	/*sql = " SELECT A.* ,a.UNIT_PRICE * a.SHIPPED_QTY amt"+
	      ",SUM(A.SHIPPED_QTY) OVER (PARTITION BY A.VENDOR_SITE_ID) TOT_QTY "+
          ",SUM(A.SHIPPED_QTY*UNIT_PRICE) OVER (PARTITION BY A.VENDOR_SITE_ID) TOT_AMT"+
          ",row_number() over (PARTITION BY A.VENDOR_SITE_ID order by 6,1,4,9,10,12 desc) seq_num"+
          ",count(1) over (PARTITION BY A.VENDOR_SITE_ID) seq_cnt"+
		  ",to_char(a.TRANSACTION_DATE,'yyyy/mm/dd') receive_date,to_char(a.SHIP_DATE,'yyyy/mm/dd') mo_ship_date "+
          " FROM TABLE(TSSG_SHIP_PKG.SG_RCV_SHIP_VIEW(NULL,'"+SDATE+"','"+EDATE+"')) A"+
          //" order by 6,1,27,4,9,10,12 DESC";
		  " order by 6,1,4,9,10,12,27 DESC";*/
	sql = "SELECT X.*,SUM(X.SHIP_QTY) OVER (PARTITION BY X.SG_STOCK_ID) TOT_SHIP_QTY"+
          ",CASE WHEN X.S_TYPE='1' AND X.SG_STOCK_ID_SEQ=X.SG_STOCK_ID_CNT THEN X.RCV_QTY - NVL(SUM(X.SHIP_QTY) OVER (PARTITION BY X.SG_STOCK_ID),0) ELSE 0 END ONHAND"+
          ",NVL(X.SHIP_QTY,0)*X.UNIT_PRICE TOT_SHIP_AMT"+
          ",NVL(X.SHIP_QTY,0)*X.INVOICE_PRICE TOT_TSC_AMT"+
          ",CASE WHEN X.S_TYPE='1' AND X.SG_STOCK_ID_SEQ=X.SG_STOCK_ID_CNT THEN X.RCV_QTY - NVL(SUM(X.SHIP_QTY) OVER (PARTITION BY X.SG_STOCK_ID),0) ELSE 0 END * X.UNIT_PRICE TOT_ONHAND_AMT"+
		  ",ROW_NUMBER() OVER (PARTITION BY VENDOR_SITE_ID ORDER BY X.VENDOR_ID,X.ORGANIZATION_ID,X.RECEIVE_DATE,X.SG_STOCK_ID,X.INVOICE_NO,X.SO_NO) SEQ_NUM"+
          ",COUNT(1) OVER (PARTITION BY VENDOR_SITE_ID ) SEQ_CNT"+
          " FROM (SELECT '1' S_TYPE"+
		  "       ,AP.VENDOR_ID"+
		  "       ,TSO.SG_STOCK_ID"+
		  "       ,TSO.ORGANIZATION_ID"+
		  "       ,TSO.SUBINVENTORY_CODE"+
		  "       ,TSO.INVENTORY_ITEM_ID"+
		  "       ,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM') YYMM"+
		  "       ,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM/DD') RECEIVE_DATE"+
          "       ,TSO.VENDOR_SITE_ID"+
		  "       ,TSO.VENDOR_SITE_CODE"+
		  "       ,NVL(TSO1.RECEIPT_NUM,TSO.RECEIPT_NUM) RECEIPT_NUM"+
		  "       ,TSO.ITEM_NAME"+
		  "       ,TSO.ITEM_DESC"+
		  "       ,TSO.LOT_NUMBER"+
		  "       ,TSO.DATE_CODE"+
          "       ,(NVL(TSO.RECEIVED_QTY,0)+NVL(TSO.ALLOCATE_IN_QTY,0) -NVL(TSO.RETURN_QTY,0)-NVL(TSO.ALLOCATE_OUT_QTY,0))/1000 RCV_QTY"+
          "       ,NVL(CASE WHEN PLA1.UNIT_MEAS_LOOKUP_CODE='PCE' THEN PLA1.UNIT_PRICE*1000 ELSE PLA1.UNIT_PRICE END,CASE WHEN PLA.UNIT_MEAS_LOOKUP_CODE='PCE' THEN PLA.UNIT_PRICE*1000 ELSE PLA.UNIT_PRICE END) UNIT_PRICE"+
          "       ,NVL(PLA1.UNIT_MEAS_LOOKUP_CODE,PLA.UNIT_MEAS_LOOKUP_CODE) UOM"+
          "       ,CASE WHEN INSTR(PLLA.NOTE_TO_RECEIVER,'.')>0 THEN SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1) ELSE '' END SO_NO"+
          "       ,SHP.SO_NO SHIP_SO_NO"+
		  "       ,SHP.INVOICE_NO"+
		  "       ,SHP.SHIP_QTY"+
		  "       ,TO_CHAR(SHP.CONFIRM_DATE,'YYYY/MM/DD') CONFIRM_DATE"+
          "       ,ROW_NUMBER() OVER ( PARTITION BY TSO.SG_STOCK_ID ORDER BY AP.VENDOR_ID,TSO.ORGANIZATION_ID,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM'),SHP.INVOICE_NO ,SHP.SO_NO) SG_STOCK_ID_SEQ"+
          "       ,COUNT(1) OVER ( PARTITION BY TSO.SG_STOCK_ID) SG_STOCK_ID_CNT"+
          //"       ,CASE WHEN NVL(TSO.ALLOCATE_IN_QTY,0) >0 THEN CASE  TSO.ORGANIZATION_ID  WHEN 907 THEN '外銷'  WHEN 908 THEN '內銷' ELSE '' END ||'(原驗收日:'||(SELECT TO_CHAR(RECEIVED_DATE,'YYYY/MM/DD') FROM ORADDMAN.TSSG_STOCK_OVERVIEW X WHERE X.SG_STOCK_ID=TSO.FROM_SG_STOCK_ID) ||')轉入' ELSE '' END|| nvl(TSO.REMARKS,'') REMARKS"+
		  "       ,CASE WHEN NVL(TSO.ALLOCATE_IN_QTY,0) >0 THEN CASE WHEN X.SUBINVENTORY_CODE IN ('03') THEN '隔離倉轉入' WHEN TSO.SUBINVENTORY_CODE IN ('03') THEN '過期品轉隔離倉' ELSE CASE  TSO.ORGANIZATION_ID  WHEN 907 THEN '外銷'  WHEN 908 THEN '內銷' ELSE '' END ||'(原驗收日:'||TO_CHAR(X.RECEIVED_DATE,'YYYY/MM/DD')||')轉入' END ELSE ''  END || nvl(TSO.REMARKS,'') REMARKS"+
          "       ,SHP.INVOICE_PRICE"+
		  "       ,SHP.REGION_CODE"+
          "       FROM ORADDMAN.TSSG_STOCK_OVERVIEW  TSO"+
		  "       ,ORADDMAN.TSSG_STOCK_OVERVIEW X"+ //add by Peggy 202401120
          "       ,PO.PO_LINE_LOCATIONS_ALL PLLA"+
          "       ,PO.PO_LINES_ALL PLA"+
          "       ,AP.AP_SUPPLIER_SITES_ALL AP"+
          "       ,ORADDMAN.TSSG_STOCK_OVERVIEW  TSO1"+
          "       ,PO.PO_LINE_LOCATIONS_ALL PLLA1"+
          "       ,PO.PO_LINES_ALL PLA1"+
          "       ,(SELECT TPCL.SG_STOCK_ID,TPCL.SO_NO,TADH.INVOICE_NO,SUM(TPCL.QTY/1000) SHIP_QTY,TRUNC(TPCH.PICK_CONFIRM_DATE) CONFIRM_DATE"+
          "        ,TSIL.UNIT_SELLING_PRICE INVOICE_PRICE"+
		  "        ,TSAL.REGION_CODE"+
          //"         FROM TSC_PICK_CONFIRM_LINES TPCL"+
          "        FROM (SELECT A.*,(SELECT VENDOR_SITE_ID FROM oraddman.tssg_stock_overview tt WHERE TT.sg_stock_id=A.SG_STOCK_ID) VENDOR_SITE_ID FROM TSC_PICK_CONFIRM_LINES A) TPCL"+ //MODIFY BY PEGGY 20210917
		  "         ,TSC_PICK_CONFIRM_HEADERS TPCH"+
		  "         ,TSC_SHIPPING_ADVISE_LINES TSAL"+
		  "         ,(SELECT ADVISE_HEADER_ID,INVOICE_NO FROM TSC_ADVISE_DN_HEADER_INT X WHERE X.STATUS='S') TADH"+
          "         ,APPS.TSC_SG_INVOICE_LINES TSIL"+
          "         WHERE TPCL.ADVISE_HEADER_ID=TPCH.ADVISE_HEADER_ID"+
          "         AND TPCL.TEW_ADVISE_NO IS NOT NULL"+
		  "         AND TPCL.ADVISE_LINE_ID=TSAL.ADVISE_LINE_ID"+
          "         AND TPCH.PICK_CONFIRM_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+
          "         AND TPCH.ADVISE_HEADER_ID=TADH.ADVISE_HEADER_ID"+
          "        AND TPCL.TEW_ADVISE_NO=TSIL.ADVISE_NO(+)"+
          "        AND TPCL.SO_LINE_ID=TSIL.ORDER_LINE_ID(+)"+
          "        AND TPCL.INVENTORY_ITEM_ID=TSIL.INVENTORY_ITEM_ID(+)"+
          "        AND TPCL.VENDOR_SITE_ID=TSIL.ATTRIBUTE3(+)"+  //加上VENDOR_SITE_ID BY PEGGY 20210917
          "         GROUP BY TPCL.SG_STOCK_ID,TPCL.SO_NO,TADH.INVOICE_NO,TRUNC(TPCH.PICK_CONFIRM_DATE),TSIL.UNIT_SELLING_PRICE,TSAL.REGION_CODE) SHP"+
          "       WHERE TSO.RECEIVED_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+
          "       AND TSO.PO_LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID(+)"+
          "       AND PLLA.PO_LINE_ID=PLA.PO_LINE_ID(+)"+
          "       AND TSO.SG_STOCK_ID=SHP.SG_STOCK_ID(+)"+
          "       AND TSO.VENDOR_SITE_ID=AP.VENDOR_SITE_ID"+
          "       AND TSO.FROM_SG_STOCK_ID=TSO1.SG_STOCK_ID(+)"+
          "       AND TSO1.PO_LINE_LOCATION_ID=PLLA1.LINE_LOCATION_ID(+)"+
          "       AND PLLA1.PO_LINE_ID=PLA1.PO_LINE_ID(+)"+
		  "       AND TSO.FROM_SG_STOCK_ID=X.SG_STOCK_ID(+)"+ //add by Peggy 20240120
          "       AND NVL(TSO.RECEIVED_QTY,0)+NVL(TSO.ALLOCATE_IN_QTY,0) -NVL(TSO.RETURN_QTY,0)-NVL(TSO.ALLOCATE_OUT_QTY,0)>0"+
		  "       UNION ALL"+
          "       SELECT '2' S_TYPE"+
		  "       ,AP.VENDOR_ID"+
		  "       ,TSO.SG_STOCK_ID"+
		  "       ,TSO.ORGANIZATION_ID"+
		  "       ,TSO.SUBINVENTORY_CODE"+
		  "       ,TSO.INVENTORY_ITEM_ID"+
		  "       ,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM') YYMM"+
		  "       ,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM/DD') RECEIVE_DATE"+
          "       ,TSO.VENDOR_SITE_ID"+
		  "       ,TSO.VENDOR_SITE_CODE"+
		  "       ,TSO.RECEIPT_NUM"+
		  "       ,TSO.ITEM_NAME"+
		  "       ,TSO.ITEM_DESC"+
		  "       ,TSO.LOT_NUMBER"+
		  "       ,TSO.DATE_CODE"+
          "       ,(NVL(TSO.RECEIVED_QTY,0)+NVL(TSO.ALLOCATE_IN_QTY,0) -NVL(TSO.RETURN_QTY,0)-NVL(TSO.ALLOCATE_OUT_QTY,0))/1000 RCV_QTY"+
          "       ,NVL(CASE WHEN PLA1.UNIT_MEAS_LOOKUP_CODE='PCE' THEN PLA1.UNIT_PRICE*1000 ELSE PLA1.UNIT_PRICE END,CASE WHEN PLA.UNIT_MEAS_LOOKUP_CODE='PCE' THEN PLA.UNIT_PRICE*1000 ELSE PLA.UNIT_PRICE END) UNIT_PRICE"+
          "       ,NVL(PLA1.UNIT_MEAS_LOOKUP_CODE,PLA.UNIT_MEAS_LOOKUP_CODE) UOM"+
          "       ,CASE WHEN INSTR(PLLA.NOTE_TO_RECEIVER,'.')>0 THEN SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1) ELSE '' END SO_NO"+
          "       ,SHP.SO_NO SHIP_SO_NO,SHP.INVOICE_NO,SHP.SHIP_QTY,TO_CHAR(SHP.CONFIRM_DATE,'YYYY/MM/DD') CONFIRM_DATE"+
          "       ,ROW_NUMBER() OVER ( PARTITION BY TSO.SG_STOCK_ID ORDER BY  AP.VENDOR_ID,TSO.ORGANIZATION_ID,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM'),SHP.INVOICE_NO ,SHP.SO_NO) SG_STOCK_ID_SEQ"+
          "       ,COUNT(1) OVER ( PARTITION BY TSO.SG_STOCK_ID) SG_STOCK_ID_CNT"+
          "       ,CASE WHEN NVL(TSO.ALLOCATE_IN_QTY,0) >0 THEN CASE  TSO.ORGANIZATION_ID  WHEN 907 THEN '外銷'  WHEN 908 THEN '內銷' ELSE '' END ||'轉入' ELSE '' END || nvl(TSO.REMARKS,'') REMARKS"+
          "       ,SHP.INVOICE_PRICE"+
		  "       ,SHP.REGION_CODE"+		  
          "       FROM ORADDMAN.TSSG_STOCK_OVERVIEW  TSO"+
          "       ,PO.PO_LINE_LOCATIONS_ALL PLLA"+
          "       ,PO.PO_LINES_ALL PLA"+
          "       ,AP.AP_SUPPLIER_SITES_ALL AP"+
          "       ,ORADDMAN.TSSG_STOCK_OVERVIEW  TSO1"+
          "       ,PO.PO_LINE_LOCATIONS_ALL PLLA1"+
          "       ,PO.PO_LINES_ALL PLA1"+
          "       ,(SELECT TPCL.SG_STOCK_ID,TPCL.SO_NO,TADH.INVOICE_NO,SUM(TPCL.QTY/1000) SHIP_QTY,TRUNC(TPCH.PICK_CONFIRM_DATE) CONFIRM_DATE"+
          "        ,TSIL.UNIT_SELLING_PRICE INVOICE_PRICE"+
		  "        ,TSAL.REGION_CODE"+
          //"        FROM TSC_PICK_CONFIRM_LINES TPCL"+
          "        FROM (SELECT A.*,(SELECT VENDOR_SITE_ID FROM oraddman.tssg_stock_overview tt WHERE TT.sg_stock_id=A.SG_STOCK_ID) VENDOR_SITE_ID FROM TSC_PICK_CONFIRM_LINES A) TPCL"+ //MODIFY BY PEGGY 20210917
		  "        ,TSC_PICK_CONFIRM_HEADERS TPCH"+
		  "        ,(SELECT A.*,(SELECT VENDOR_SITE_ID FROM TSC.TSC_SHIPPING_ADVISE_PC_SG X WHERE X.PC_ADVISE_ID=A.PC_ADVISE_ID) PC_VENDOR_SITE_ID FROM TSC_SHIPPING_ADVISE_LINES A) TSAL"+
		  "        ,(SELECT ADVISE_HEADER_ID,INVOICE_NO FROM TSC_ADVISE_DN_HEADER_INT X WHERE X.STATUS='S') TADH"+
          "        ,APPS.TSC_SG_INVOICE_LINES TSIL"+
          "        WHERE TPCL.ADVISE_HEADER_ID=TPCH.ADVISE_HEADER_ID"+
          "        AND TPCL.TEW_ADVISE_NO IS NOT NULL"+
		  "        AND TPCL.ADVISE_LINE_ID=TSAL.ADVISE_LINE_ID"+
          "        AND TPCH.PICK_CONFIRM_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+
          "        AND TPCH.ADVISE_HEADER_ID=TADH.ADVISE_HEADER_ID"+
          //"        AND TPCL.TEW_ADVISE_NO=TSIL.ADVISE_NO(+)"+
          //"        AND TPCL.SO_LINE_ID=TSIL.ORDER_LINE_ID(+)"+
          //"        AND TPCL.INVENTORY_ITEM_ID=TSIL.INVENTORY_ITEM_ID(+)"+
          //"        AND TPCL.VENDOR_SITE_ID=TSIL.ATTRIBUTE3(+)"+  //加上VENDOR_SITE_ID BY PEGGY 20210917
          "        AND TSAL.TEW_ADVISE_NO=TSIL.ADVISE_NO(+)"+
          "        AND TSAL.SO_LINE_ID=TSIL.ORDER_LINE_ID(+)"+
          "        AND TSAL.INVENTORY_ITEM_ID=TSIL.INVENTORY_ITEM_ID(+)"+
          "        AND TSAL.PC_VENDOR_SITE_ID=TSIL.ATTRIBUTE3(+)"+  //加上VENDOR_SITE_ID BY PEGGY 20210917
          "        GROUP BY TPCL.SG_STOCK_ID,TPCL.SO_NO,TADH.INVOICE_NO,TRUNC(TPCH.PICK_CONFIRM_DATE),TSIL.UNIT_SELLING_PRICE,TSAL.REGION_CODE) SHP"+
          "        WHERE TSO.RECEIVED_DATE < TO_DATE('"+SDATE+"','YYYYMMDD')"+
          "        AND TSO.PO_LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID(+)"+
          "        AND PLLA.PO_LINE_ID=PLA.PO_LINE_ID(+)"+
          "        AND TSO.SG_STOCK_ID=SHP.SG_STOCK_ID"+
          "        AND TSO.VENDOR_SITE_ID=AP.VENDOR_SITE_ID(+)"+
          "        AND TSO.FROM_SG_STOCK_ID=TSO1.SG_STOCK_ID(+)"+
          "        AND TSO1.PO_LINE_LOCATION_ID=PLLA1.LINE_LOCATION_ID(+)"+
          "        AND PLLA1.PO_LINE_ID=PLA1.PO_LINE_ID(+)"+
          "        AND NVL(TSO.RECEIVED_QTY,0)+NVL(TSO.ALLOCATE_IN_QTY,0) -NVL(TSO.RETURN_QTY,0)-NVL(TSO.ALLOCATE_OUT_QTY,0)>0"+
          //"        ORDER BY AP.VENDOR_ID,TSO.ORGANIZATION_ID,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM'),TSO.SG_STOCK_ID,SHP.INVOICE_NO,SHP.SO_NO"+
		  "        ) X"+
          "        ORDER BY X.VENDOR_ID,X.ORGANIZATION_ID,X.RECEIVE_DATE,X.SG_STOCK_ID,X.SG_STOCK_ID_SEQ,X.INVOICE_NO,X.SO_NO";
	//out.println(sql);
	Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
	ResultSet rs=statement.executeQuery(sql);
	int sheet_cnt =0;
	for (int z =1 ; z<=i_data ; z++)
	{
		if (rs.isBeforeFirst() ==false) rs.beforeFirst();
		icnt =0;
		
		while (rs.next())
		{
			if ((z==1 && !rs.getString("VENDOR_SITE_CODE").equals(v_vendor_site)) || (z==2 && icnt==0))
			{
				icnt=1;
				if (z==1)
				{
					v_vendor_site = rs.getString("VENDOR_SITE_CODE");
				}
				else
				{
					v_vendor_site = "SGT-E合併";
				}
				wwb.createSheet(v_vendor_site, sheet_cnt);
				sheet_cnt++;
				ws = wwb.getSheet(v_vendor_site);
				col=0;row=0;
							
				ws.mergeCells(col, row, col+1, row);     
				ws.addCell(new jxl.write.Label(col, row,v_vendor_site+"出貨明細", ACenterBLY));
				row++;//列+1	
				
				//項次
				ws.addCell(new jxl.write.Label(col, row, "項次" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;					
		
				//廠商
				ws.addCell(new jxl.write.Label(col, row, "廠商" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;					
		
				//入帳月
				ws.addCell(new jxl.write.Label(col, row, "入帳月" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
	
				//驗收日
				ws.addCell(new jxl.write.Label(col, row, "驗收日" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
				
				//驗收單號
				ws.addCell(new jxl.write.Label(col, row, "驗收單號" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;				
	
				//TSC料號
				ws.addCell(new jxl.write.Label(col, row, "TSC料號" , ACenterBL));
				ws.setColumnView(col,25);	
				col++;				
	
				//數量(K)
				ws.addCell(new jxl.write.Label(col, row, "數量(K)" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;				
	
				//單價(未稅)
				ws.addCell(new jxl.write.Label(col, row, "單價(未稅)" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;				
	
				//總價(未稅)
				ws.addCell(new jxl.write.Label(col, row, "總價(未稅)" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;				
	
				//批號
				ws.addCell(new jxl.write.Label(col, row, "批號" , ACenterBL));
				ws.setColumnView(col,20);	
				col++;				
	
				//Date code
				ws.addCell(new jxl.write.Label(col, row, "Date Code" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;				
	
				//發票號
				ws.addCell(new jxl.write.Label(col, row, "發票號" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;				
	
				//訂單號碼
				ws.addCell(new jxl.write.Label(col, row, "訂單號碼" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;				
	
				//出貨日
				ws.addCell(new jxl.write.Label(col, row, "出貨日" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;				

				//業務區
				ws.addCell(new jxl.write.Label(col, row, "業務區" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;				
	
				//備註
				ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBL));
				ws.setColumnView(col,25);	
				col++;	
				
				if (UserName.toUpperCase().equals("CASEY") ||  UserName.toUpperCase().equals("PEGGY_CHEN"))
				{
					//TP單價
					ws.addCell(new jxl.write.Label(col, row, "TP單價" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
	
					//TP總價
					ws.addCell(new jxl.write.Label(col, row, "TP總價" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
				}
				row++;			
			}
			
			if (z==2 && !rs.getString("ORGANIZATION_ID").equals("908")) continue;
			
			if (rs.getString("SHIP_QTY")==null)
			{
				i_loop=1;
			}
			else
			{
				if (!rs.getString("ONHAND").equals("0"))
				{
					i_loop=2;
				}
				else
				{
					i_loop=1;
				}
			}
			
			for ( int k =1 ; k<=i_loop ; k++)
			{
				col=0;
				//項次
				ws.addCell(new jxl.write.Label(col, row, ""+icnt, ALeftL));
				col++;
				//廠商
				ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_SITE_CODE"), ALeftL));
				col++;
				//入帳月
				ws.addCell(new jxl.write.Label(col, row, rs.getString("YYMM"), ALeftL));
				col++;
				//驗收日
				if (rs.getString("RECEIVE_DATE")==null)
				{		
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("RECEIVE_DATE")) ,DATE_FORMAT));
				}			
				col++;
				//驗收單號
				ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIPT_NUM"), ALeftL));
				col++;
				//TSC料號
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"), ALeftL));
				col++;
				//數量(K)
				if (k==2)
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ONHAND")).doubleValue(), ARightL));
				}
				else
				{
					if (rs.getString("SHIP_QTY")==null)
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ONHAND")).doubleValue(), ARightL));
					}
					else
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SHIP_QTY")).doubleValue(), ARightL));
					}
				}
				
				col++;			
				//單價(未稅)
				if (rs.getString("UNIT_PRICE")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("UNIT_PRICE")).doubleValue(), ARightL));
				}	
				col++;				
				//總價(未稅)	
				if (k==2)
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOT_ONHAND_AMT")).doubleValue(), ARightL));
				}
				else
				{
					if (rs.getString("SHIP_QTY")==null)
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOT_ONHAND_AMT")).doubleValue(), ARightL));
					}
					else
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOT_SHIP_AMT")).doubleValue(), ARightL));
					}
				}
				col++;	
				//批號
				ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER"),ALeftL));
				col++;					
				//Date Code
				ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE"),ALeftL));
				col++;					
				//發票號
				if (k==2)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("INVOICE_NO")==null?"":rs.getString("INVOICE_NO")),ALeftL));
				}
				col++;					
				//訂單號碼
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIP_SO_NO")==null?(rs.getString("SO_NO")==null?"":rs.getString("SO_NO")):rs.getString("SHIP_SO_NO")),ALeftL));
				col++;					
				//出貨日
				if (k==2)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{			
					if (rs.getString("CONFIRM_DATE")==null)
					{		
						ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
					}
					else
					{
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("CONFIRM_DATE")) ,DATE_FORMAT));
					}	
				}	
				col++;				
				//業務區
				if (k==2)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{	
					if (rs.getString("REGION_CODE")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
					}
					else
					{	
						ws.addCell(new jxl.write.Label(col, row, rs.getString("REGION_CODE"),ALeftL));
					}
				}
				col++;	
				//備註
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("REMARKS")==null?"":rs.getString("REMARKS")), (rs.getString("REMARKS")==null?ALeftL:ALeftLY) ));
				col++;	
				if (UserName.toUpperCase().equals("CASEY") ||  UserName.toUpperCase().equals("PEGGY_CHEN"))
				{
					if (k==2)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
					}
					else
					{
						if (!rs.getString("ORGANIZATION_ID").equals("908") || rs.getString("INVOICE_PRICE")==null)
						{
							ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
						}
						else
						{
							ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("INVOICE_PRICE")).doubleValue(), ARightL));
						}	
					}
					col++;
					if (k==2)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
					}
					else
					{
						if (!rs.getString("ORGANIZATION_ID").equals("908") || rs.getString("INVOICE_PRICE")==null)
						{
							ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
						}
						else
						{
							ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOT_TSC_AMT")).doubleValue(), ARightL));
						}
					}									
					col++;					
				}				
				row++;
				icnt++;
			}
		}
		/*if (rs.getString("seq_num").equals(rs.getString("seq_cnt")))
		{
			ws.addCell(new jxl.write.Label(5, row, "TOTAL:",ALeftL));
			//總數
			if (rs.getString("TOT_QTY")==null)
			{
				ws.addCell(new jxl.write.Label(6, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(6, row, Double.valueOf(rs.getString("TOT_QTY")).doubleValue(), ARightL));
			}
			ws.addCell(new jxl.write.Label(7, row, "",ALeftL));
			//總金額
			if (rs.getString("TOT_AMT")==null)
			{
				ws.addCell(new jxl.write.Label(8, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(8, row, Double.valueOf(rs.getString("TOT_AMT")).doubleValue(), ARightL));
			}
		}
		*/			
	}
	rs.close();
	statement.close();	
	
	wwb.write(); 
	wwb.close();

	os.close();  
	out.close(); 
	
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 	
try
{
	response.reset();
	response.setContentType("application/vnd.ms-excel");	
	String strURL = "/oradds/report/"+FileName; 
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
