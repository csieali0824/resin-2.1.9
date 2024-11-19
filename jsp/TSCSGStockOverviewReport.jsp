<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCSGStockOverviewReport.jsp" METHOD="post" name="MYFORM">
<%

String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",sql_ship="",sql_return="",sql_allocate="",sql_pick="",where="",destination="",remarks;
int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr=dateBean.getYearString();
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr=dateBean.getMonthString();
String DayFr=request.getParameter("DAYFR");
if (DayFr==null || DayFr.equals("--")) DayFr="01";
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo=dateBean.getYearString();
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo=dateBean.getMonthString();
String DayTo=request.getParameter("DAYTO");
if (DayTo==null || DayTo.equals("--"))
{
	if (YearTo.equals(dateBean.getYearString()) && MonthTo.equals(dateBean.getMonthString()))
	{
		DayTo=dateBean.getDayString();
	}
	else
	{
		sql = "select to_char(add_months(to_date('"+YearTo+MonthTo+"','yyyymm'),1)-1,'dd') from dual";
		Statement statement1=con.createStatement(); 
		ResultSet rs1=statement1.executeQuery(sql);
		if (rs1.next()) 
		{ 
			DayTo=rs1.getString(1);
		}
		rs1.close();
		statement1.close();
	}
	
}
//if (RTYPE.equals("AUTO"))
//{
//	dateBean.setAdjDate(-1);
//	YearFr = YearTo= dateBean.getYearString();
//	MonthFr = MonthTo = dateBean.getMonthString();
//	DayFr = "01";
//	DayTo=dateBean.getDayString();
//	//dateBean.setAdjDate(1);
//}
String SDATE =YearFr+""+MonthFr+""+DayFr;
String EDATE =YearTo+""+MonthTo+""+DayTo;

try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,line=0,mergeCol=0;
	String column1="",column2="",column3="",column4="",column5="",mo_CRD="",mo_QTY="",mo_PRICE="",mo_SSD="";
	OutputStream os = null;	
	RPTName = "SGStockOverView";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setVerticalFreeze(2);  //凍結窗格
	for (int g =1 ; g <=10 ;g++ )
	{
		sst.setHorizontalFreeze(g);
	}
	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置左-格線-底色黃
	WritableCellFormat LeftBLY = new WritableCellFormat(font_bold);   
	LeftBLY.setAlignment(jxl.format.Alignment.LEFT);
	LeftBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	LeftBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	LeftBLY.setBackground(jxl.write.Colour.YELLOW); 
	LeftBLY.setWrap(true);	

	
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
	
	//英文內文水平垂直置右-正常-格線-紅字   
	WritableCellFormat ARightLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 11,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ARightLR.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLR.setWrap(true);	
	
	//英文內文水平垂直置右-正常-格線-藍字   
	WritableCellFormat ARightLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 11,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ARightLB.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLB.setWrap(true);				
		
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
					
	//CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	//cs1.setString(1,"41"); 
	//cs1.execute();
	//cs1.close();
	sql = " SELECT TSO.SG_STOCK_ID,TRUNC(SYSDATE)-TRUNC(TSO.RECEIVED_DATE) STOCK_AGE,TSC_INV_CATEGORY(TSO.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP,TSC_INV_CATEGORY(TSO.INVENTORY_ITEM_ID,43,23) TSC_Package"+
	      ",TSO.ORGANIZATION_ID,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM/DD') RECIVED_DATE,TSO.VENDOR_SITE_CODE,TSO.INVENTORY_ITEM_ID,TSO.ITEM_NAME,TSO.ITEM_DESC"+
          ",TSO.SUBINVENTORY_CODE,TSO.LOT_NUMBER,TSO.DATE_CODE,TSO.DC_YYWW"+
          ",STK.OPEN_QTY/1000 OPEN_QTY,STK.RECEIVED_QTY/1000 RECEIVED_QTY,STK.ALLOCATE_IN_QTY/1000 ALLOCATE_IN_QTY"+
		  ",STK.RETURN_QTY/1000 RETURN_QTY,STK.ALLOCATE_OUT_QTY/1000 ALLOCATE_OUT_QTY,STK.PICK_QTY/1000 PICK_QTY,STK.SHIPPED_QTY/1000 SHIPPED_QTY"+
          ",(NVL(STK.OPEN_QTY,0)+NVL(STK.RECEIVED_QTY,0)+NVL(STK.ALLOCATE_IN_QTY,0)-NVL(STK.RETURN_QTY,0)-NVL(STK.ALLOCATE_OUT_QTY,0)-NVL(STK.PICK_QTY,0)-NVL(STK.SHIPPED_QTY,0))/1000 ONHAND_QTY"+
          ",TSO.RECEIPT_NUM,PHA.SEGMENT1 PO_NO,SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1) SO_NO"+
          //",NVL(TSO.CUST_PARTNO,NVL(TRIM(REPLACE(REPLACE(CASE INSTR(PLA.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN PLA.NOTE_TO_VENDOR ELSE SUBSTR(PLA.NOTE_TO_VENDOR,1,INSTR(PLA.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
          ",NVL(TSO.CUST_PARTNO,NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(PLA.NOTE_TO_VENDOR)"+ //modify by Peggy 20230607
		  "      ,CASE WHEN PLLA.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
          "      FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
          "       WHERE x.org_id= CASE WHEN SUBSTR(PLLA.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
          "       AND x.header_id=y.header_id"+
          "       AND y.packing_instructions='T'"+
          "       AND x.order_number= SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1)"+
          "       AND y.shipment_number=1 and y.line_number=SUBSTR(PLLA.NOTE_TO_RECEIVER,INSTR(PLLA.NOTE_TO_RECEIVER,'.')+1))"+
          "       ELSE '' END)) PO_CUST_PARTNO"+
          ", NULL SHIP_SO_NO,NULL SHIPPING_REMARK,NULL ADVISE_NO,NULL PC_SCHEDULE_SHIP_DATE,NULL PICK_CONFIRM_DATE,NULL DELIVERY_NAME,NULL ERP_SHIP_CONFIRM_DATE  "+
          " , NULL RETURN_DATE,NULL RETURN_REASON,NULL ALLOCATED_OUT_DATE,NULL REMARKS ,NULL CARTON_LIST "+
          " FROM (SELECT ONHAND.SG_STOCK_ID"+
          "       ,CASE D_TYPE WHEN 1 THEN NVL(ONHAND.RECEIVED_QTY,0)+ NVL(ONHAND.ALLOCATE_IN_QTY,0) - NVL(ONHAND.RETURN_QTY,0) - NVL(ONHAND.ALLOCATED_OUT_QTY,0) - NVL(ONHAND.PICK_QTY,0) - NVL(ONHAND.SHIPPED_QTY,0) ELSE 0 END  OPEN_QTY"+
          "       ,CASE D_TYPE WHEN 2 THEN NVL(ONHAND.RECEIVED_QTY,0)+ NVL(ONHAND.ALLOCATE_IN_QTY,0) - NVL(ONHAND.RETURN_QTY,0) - NVL(ONHAND.ALLOCATED_OUT_QTY,0) - NVL(ONHAND.PICK_QTY,0) - NVL(ONHAND.SHIPPED_QTY,0) ELSE 0 END  RECEIVED_QTY"+
          "       ,0 ALLOCATE_IN_QTY,0 RETURN_QTY,0 ALLOCATE_OUT_QTY,0 PICK_QTY,0 SHIPPED_QTY"+
          "      FROM (SELECT 1 D_TYPE,A.SG_STOCK_ID,A.RECEIVED_QTY,A.ALLOCATE_IN_QTY"+
          "           ,(SELECT SUM(NVL(TPRD.RETURN_QTY,0)) "+
          "            FROM ORADDMAN.TSSG_PO_RECEIVE_DETAIL TPRD "+
          //"            WHERE TPRD.RETURNED_DATE <= TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+
		  "            WHERE TPRD.RETURN_APPROVE_DATE <= TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+  //改成RETURN_APPROVE_DATE by Peggy 20211229
          "            AND NVL(TPRD.RETURN_QTY,0)>0 "+
          "            AND TPRD.ORGANIZATION_ID=A.ORGANIZATION_ID"+
          //"            AND TPRD.SUBINVENTORY_CODE=A.SUBINVENTORY_CODE"+
		  "              AND NVL(TPRD.SUBINVENTORY_CODE,DECODE(TPRD.DELIVERY_TYPE,'Y','02','01'))=A.SUBINVENTORY_CODE"+ //modify by Peggy 20210412
          "            AND TPRD.INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID"+
          "            AND TPRD.LOT_NUMBER=A.LOT_NUMBER"+
          "            AND TPRD.DATE_CODE=A.DATE_CODE"+
          "            AND TPRD.PO_LINE_LOCATION_ID=A.PO_LINE_LOCATION_ID"+
          "            AND NVL(TPRD.VENDOR_CARTON_NO,'--')=NVL(A.VENDOR_CARTON_NO,'--')"+ //add by Peggy 20240305	
          "            AND NVL(TPRD.NW,'--')=NVL(A.NW,'--')"+//add by Peggy 20240305
          "            AND NVL(TPRD.GW,'--')=NVL(A.GW,'--')"+ //add by Peggy 20240305			  
          "            AND TPRD.RECEIPT_NUM=A.RECEIPT_NUM) RETURN_QTY"+
          "            ,(SELECT SUM(ALLOCATED_QTY) FROM ORADDMAN.TSSG_STOCK_ALLOCATE_DETAIL TSAD  WHERE TSAD.ALLOCATED_DATE <= TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999 AND TSAD.SG_STOCK_ID=A.SG_STOCK_ID) ALLOCATED_OUT_QTY"+
          "            ,NVL(PK.PICK_QTY,0) PICK_QTY"+
          "            ,NVL(SHIP.SHIPPED_QTY,0) SHIPPED_QTY"+
          "            FROM ORADDMAN.TSSG_STOCK_OVERVIEW A"+
          //"            ,(SELECT SG_STOCK_ID,SUM(QTY) PICK_QTY FROM TSC.TSC_PICK_CONFIRM_HEADERS TPCH,TSC.TSC_PICK_CONFIRM_LINES TPCL WHERE TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID AND TPCH.PICK_CONFIRM_DATE IS NULL AND TPCL.LAST_UPDATE_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999 GROUP BY SG_STOCK_ID) PK   "+
		  "            ,(SELECT SG_STOCK_ID,SUM(QTY) PICK_QTY FROM TSC.TSC_PICK_CONFIRM_HEADERS TPCH,TSC.TSC_PICK_CONFIRM_LINES TPCL WHERE TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID AND TPCH.PICK_CONFIRM_DATE IS NULL AND TPCL.LAST_UPDATE_DATE <= TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999 GROUP BY SG_STOCK_ID) PK "+    //跨月撿貨issue,modify by Peggy 20200707
          "            ,(SELECT SG_STOCK_ID,SUM(QTY) SHIPPED_QTY FROM TSC.TSC_PICK_CONFIRM_HEADERS TPCH,TSC.TSC_PICK_CONFIRM_LINES TPCL WHERE TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.PICK_CONFIRM_DATE <= TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999  AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID GROUP BY SG_STOCK_ID) SHIP"+
          "            WHERE A.RECEIVED_DATE <= (TO_DATE('"+SDATE+"','YYYYMMDD')-1)+0.99999"+
          "            AND A.SG_STOCK_ID=SHIP.SG_STOCK_ID(+)"+
          "            AND A.SG_STOCK_ID=PK.SG_STOCK_ID(+)"+
          "            UNION ALL"+
          "            SELECT 2 D_TYPE,A.SG_STOCK_ID,A.RECEIVED_QTY,A.ALLOCATE_IN_QTY"+
          "            ,(SELECT SUM(NVL(TPRD.RETURN_QTY,0))"+
          "              FROM ORADDMAN.TSSG_PO_RECEIVE_DETAIL TPRD "+
          //"              WHERE TPRD.RETURNED_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+
		  "              WHERE TPRD.RETURN_APPROVE_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+ //改成RETURN_APPROVE_DATE by Peggy 20211229
          "              AND NVL(TPRD.RETURN_QTY,0)>0"+
          "              AND TPRD.ORGANIZATION_ID=A.ORGANIZATION_ID"+
          //"              AND TPRD.SUBINVENTORY_CODE=A.SUBINVENTORY_CODE"+
		  "              AND NVL(TPRD.SUBINVENTORY_CODE,DECODE(TPRD.DELIVERY_TYPE,'Y','02','01'))=A.SUBINVENTORY_CODE"+ //modify by Peggy 20210323
          "              AND TPRD.INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID"+
          "              AND TPRD.LOT_NUMBER=A.LOT_NUMBER"+
          "              AND TPRD.DATE_CODE=A.DATE_CODE"+
          "              AND TPRD.PO_LINE_LOCATION_ID=A.PO_LINE_LOCATION_ID"+
          "              AND NVL(TPRD.VENDOR_CARTON_NO,'--')=NVL(A.VENDOR_CARTON_NO,'--')"+ //add by Peggy 20240227	
          "              AND NVL(TPRD.NW,'--')=NVL(A.NW,'--')"+//add by Peggy 20240227	
          "              AND NVL(TPRD.GW,'--')=NVL(A.GW,'--')"+ //add by Peggy 20240227		  
          "              AND TPRD.RECEIPT_NUM=A.RECEIPT_NUM) RETURN_QTY"+
          "           ,(SELECT SUM(ALLOCATED_QTY) FROM ORADDMAN.TSSG_STOCK_ALLOCATE_DETAIL TSAD WHERE TSAD.ALLOCATED_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999 AND TSAD.SG_STOCK_ID=A.SG_STOCK_ID) ALLOCATED_OUT_QTY"+
          "           ,PK.PICK_QTY"+
          "           ,SH.SHIPPED_QTY"+
          "           FROM ORADDMAN.TSSG_STOCK_OVERVIEW A"+
          "           ,(SELECT SG_STOCK_ID,SUM(QTY) PICK_QTY FROM TSC.TSC_PICK_CONFIRM_HEADERS TPCH,TSC.TSC_PICK_CONFIRM_LINES TPCL WHERE TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID AND TPCH.PICK_CONFIRM_DATE IS NULL AND TPCL.LAST_UPDATE_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999 GROUP BY SG_STOCK_ID) PK   "+
          "           ,(SELECT SG_STOCK_ID,SUM(QTY) SHIPPED_QTY FROM TSC.TSC_PICK_CONFIRM_HEADERS TPCH,TSC.TSC_PICK_CONFIRM_LINES TPCL WHERE TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID AND TPCH.PICK_CONFIRM_DATE IS NOT NULL AND TPCH.PICK_CONFIRM_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999 GROUP BY SG_STOCK_ID) SH "+
          "           WHERE A.RECEIVED_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+
          "           AND A.SG_STOCK_ID=SH.SG_STOCK_ID(+)"+
          "           AND A.SG_STOCK_ID=PK.SG_STOCK_ID(+)"+
          "           ) ONHAND"+
          "           WHERE NVL(ONHAND.RECEIVED_QTY,0)+ NVL(ONHAND.ALLOCATE_IN_QTY,0) - NVL(ONHAND.RETURN_QTY,0) - NVL(ONHAND.ALLOCATED_OUT_QTY,0)  - NVL(ONHAND.PICK_QTY,0) - NVL(ONHAND.SHIPPED_QTY,0)>0"+
		  "           ) STK"+
          "           ,ORADDMAN.TSSG_STOCK_OVERVIEW TSO"+
          "           ,PO.PO_HEADERS_ALL PHA"+
          "           ,PO.PO_LINE_LOCATIONS_ALL PLLA"+
          "           ,PO.PO_LINES_ALL PLA"+
          "           WHERE STK.SG_STOCK_ID=TSO.SG_STOCK_ID"+
          "           AND TSO.PO_HEADER_ID=PHA.PO_HEADER_ID(+)"+
          "           AND TSO.PO_LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID(+)"+
          "           AND PLLA.PO_LINE_ID=PLA.PO_LINE_ID(+)";
	sql_ship= " UNION ALL"+ // ----------出貨
          " SELECT TSO.SG_STOCK_ID,TRUNC(SYSDATE)-TRUNC(TSO.RECEIVED_DATE) STOCK_AGE,TSC_INV_CATEGORY(TSO.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP,TSC_INV_CATEGORY(TSO.INVENTORY_ITEM_ID,43,23) TSC_Package"+
		  " ,TSO.ORGANIZATION_ID,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM/DD') RECIVED_DATE,TSO.VENDOR_SITE_CODE,TSO.INVENTORY_ITEM_ID,TSO.ITEM_NAME,TSO.ITEM_DESC"+
          " ,TSO.SUBINVENTORY_CODE,TSO.LOT_NUMBER,TSO.DATE_CODE,TSO.DC_YYWW"+
          " ,STK.OPEN_QTY/1000 OPEN_QTY,STK.RECEIVED_QTY/1000 RECEIVED_QTY,STK.ALLOCATE_IN_QTY/1000 ALLOCATE_IN_QTY,STK.RETURN_QTY/1000 RETURN_QTY"+
		  " ,STK.ALLOCATE_OUT_QTY/1000 ALLOCATE_OUT_QTY,STK.PICK_QTY/1000 PICK_QTY,STK.SHIPPED_QTY/1000 SHIPPED_QTY"+
          " ,(NVL(STK.OPEN_QTY,0)+NVL(STK.RECEIVED_QTY,0)+NVL(STK.ALLOCATE_IN_QTY,0)-NVL(STK.RETURN_QTY,0)-NVL(STK.ALLOCATE_OUT_QTY,0)-NVL(STK.PICK_QTY,0)-NVL(STK.SHIPPED_QTY,0))/1000 ONHAND_QTY"+
          " ,TSO.RECEIPT_NUM,PHA.SEGMENT1 PO_NO,SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1) SO_NO"+
          //" ,NVL(TSO.CUST_PARTNO,NVL(TRIM(REPLACE(REPLACE(CASE INSTR(PLA.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN PLA.NOTE_TO_VENDOR ELSE SUBSTR(PLA.NOTE_TO_VENDOR,1,INSTR(PLA.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
          " ,NVL(TSO.CUST_PARTNO,NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(PLA.NOTE_TO_VENDOR)"+ //modify by Peggy 20230607
          "                 ,CASE WHEN PLLA.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
          "                  FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
          "                  WHERE x.org_id= CASE WHEN SUBSTR(PLLA.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
          "                  AND x.header_id=y.header_id"+
          "                  AND y.packing_instructions='T'"+
          "                  AND x.order_number= SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1)"+
          "                  AND y.shipment_number=1 and y.line_number=SUBSTR(PLLA.NOTE_TO_RECEIVER,INSTR(PLLA.NOTE_TO_RECEIVER,'.')+1))"+
          "                  ELSE '' END)) PO_CUST_PARTNO,"+
          "                  STK.SHIP_SO_NO,STK.SHIPPING_REMARK,STK.ADVISE_NO,STK.PC_SCHEDULE_SHIP_DATE,STK.PICK_CONFIRM_DATE,STK.DELIVERY_NAME,STK.ERP_SHIP_CONFIRM_DATE"+
          "                  , NULL RETURN_DATE,NULL RETURN_REASON,NULL ALLOCATED_OUT_DATE,NULL REMARKS ,STK.CARTON_LIST"+
          " FROM (SELECT A.SG_STOCK_ID,TSAL.SO_NO SHIP_SO_NO,TSAL.SHIPPING_REMARK,TSAH.ADVISE_NO,TO_CHAR(TSAL.PC_SCHEDULE_SHIP_DATE,'YYYY/MM/DD') PC_SCHEDULE_SHIP_DATE,TO_CHAR(TPCH.PICK_CONFIRM_DATE,'YYYY/MM/DD') PICK_CONFIRM_DATE"+
          " ,TADL.DELIVERY_NAME,TO_CHAR(WND.CONFIRM_DATE,'YYYY/MM/DD') ERP_SHIP_CONFIRM_DATE"+
          " ,SUM(CASE WHEN TRUNC(A.RECEIVED_DATE)<TO_DATE('"+SDATE+"','YYYYMMDD') AND A.FROM_SG_STOCK_ID IS NULL THEN TPCL.QTY ELSE 0 END) OPEN_QTY"+
          " ,SUM(CASE WHEN TRUNC(A.RECEIVED_DATE)>=TO_DATE('"+SDATE+"','YYYYMMDD') AND A.FROM_SG_STOCK_ID IS NULL THEN TPCL.QTY ELSE 0 END) RECEIVED_QTY"+
          //" ,SUM(CASE WHEN TRUNC(A.RECEIVED_DATE)>=TO_DATE('"+SDATE+"','YYYYMMDD') AND A.FROM_SG_STOCK_ID IS NOT NULL THEN TPCL.QTY ELSE 0 END) ALLOCATE_IN_QTY"+
		  " ,SUM(CASE WHEN TRUNC(A.RECEIVED_DATE)<=TO_DATE('"+EDATE+"','YYYYMMDD') AND A.FROM_SG_STOCK_ID IS NOT NULL THEN TPCL.QTY ELSE 0 END) ALLOCATE_IN_QTY"+
          " ,0 RETURN_QTY,0 ALLOCATE_OUT_QTY,0 PICK_QTY,SUM(TPCL.QTY) SHIPPED_QTY"+
          " ,LISTAGG(TPCL.CARTON_NO||TSAH.POST_FIX_CODE,',') WITHIN GROUP (ORDER BY TPCL.CARTON_NO) CARTON_LIST"+ 
          " FROM TSC.TSC_PICK_CONFIRM_HEADERS TPCH"+
          " ,TSC.TSC_PICK_CONFIRM_LINES TPCL "+
          " ,ORADDMAN.TSSG_STOCK_OVERVIEW A"+
          " ,TSC.TSC_SHIPPING_ADVISE_LINES TSAL"+
          " ,TSC.TSC_SHIPPING_ADVISE_HEADERS TSAH"+
          " ,TSC_ADVISE_DN_LINE_INT TADL"+
          " ,TSC_ADVISE_DN_HEADER_INT TADH"+
          " ,WSH.WSH_NEW_DELIVERIES WND"+
          " WHERE TPCL.ORGANIZATION_ID IN (907,908)"+
          " AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID"+
          " AND TPCH.PICK_CONFIRM_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+
          " AND TPCL.SG_STOCK_ID=A.SG_STOCK_ID"+
          " AND TPCL.ADVISE_LINE_ID=TSAL.ADVISE_LINE_ID"+
          " AND TSAL.ADVISE_HEADER_ID=TSAH.ADVISE_HEADER_ID"+
          " AND TSAL.ADVISE_LINE_ID=TADL.ADVISE_LINE_ID(+)"+
          " AND TADL.INTERFACE_HEADER_ID=TADH.INTERFACE_HEADER_ID(+)"+
          " AND TADL.ADVISE_HEADER_ID=TADH.ADVISE_HEADER_ID(+)"+
          " AND TADL.BATCH_ID=TADH.BATCH_ID(+)"+
          " AND TADH.STATUS='S'"+
          " AND TADL.DELIVERY_ID=WND.DELIVERY_ID(+)"+
          " GROUP BY A.SG_STOCK_ID,TSAL.SO_NO ,TSAL.SHIPPING_REMARK,TSAH.ADVISE_NO,TO_CHAR(TSAL.PC_SCHEDULE_SHIP_DATE,'YYYY/MM/DD') ,TO_CHAR(TPCH.PICK_CONFIRM_DATE,'YYYY/MM/DD'),TPCL.ADVISE_LINE_ID "+
          " ,TADL.DELIVERY_NAME,TO_CHAR(WND.CONFIRM_DATE,'YYYY/MM/DD'))STK"+
          " ,ORADDMAN.TSSG_STOCK_OVERVIEW TSO"+
          " ,PO.PO_HEADERS_ALL PHA"+
          " ,PO.PO_LINE_LOCATIONS_ALL PLLA"+
          " ,PO.PO_LINES_ALL PLA"+
          " WHERE STK.SG_STOCK_ID=TSO.SG_STOCK_ID"+
          " AND TSO.PO_HEADER_ID=PHA.PO_HEADER_ID(+)"+
          " AND TSO.PO_LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID(+)"+
          " AND PLLA.PO_LINE_ID=PLA.PO_LINE_ID(+)";
	sql_return= " UNION ALL"+ // --------退貨
          " SELECT TSO.SG_STOCK_ID,TRUNC(SYSDATE)-TRUNC(TSO.RECEIVED_DATE) STOCK_AGE,TSC_INV_CATEGORY(TSO.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP,TSC_INV_CATEGORY(TSO.INVENTORY_ITEM_ID,43,23) TSC_Package"+
		  " ,TSO.ORGANIZATION_ID,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM/DD') RECIVED_DATE,TSO.VENDOR_SITE_CODE,TSO.INVENTORY_ITEM_ID,TSO.ITEM_NAME,TSO.ITEM_DESC"+
          " ,TSO.SUBINVENTORY_CODE,TSO.LOT_NUMBER,TSO.DATE_CODE,TSO.DC_YYWW"+
          " ,(CASE WHEN TRUNC(TSO.RECEIVED_DATE)<TO_DATE('"+SDATE+"','YYYYMMDD') THEN NVL(TPRD.RETURN_QTY,0) ELSE 0 END)/1000 OPEN_QTY"+
          " ,(CASE WHEN TRUNC(TSO.RECEIVED_DATE)>=TO_DATE('"+SDATE+"','YYYYMMDD') THEN NVL(TPRD.RETURN_QTY,0) ELSE 0 END)/1000 RECEIVED_QTY"+
          " ,0 ALLOCATE_IN_QTY,NVL(TPRD.RETURN_QTY,0)/1000 RETURN_QTY,0 ALLOCATE_OUT_QTY,0 PICK_QTY,0 SHIPPED_QTY"+
          " ,0 ONHAND_QTY"+
          " ,TSO.RECEIPT_NUM,PHA.SEGMENT1 PO_NO,SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1) SO_NO"+
          //" ,NVL(TSO.CUST_PARTNO,NVL(TRIM(REPLACE(REPLACE(CASE INSTR(PLA.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN PLA.NOTE_TO_VENDOR ELSE SUBSTR(PLA.NOTE_TO_VENDOR,1,INSTR(PLA.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
          " ,NVL(TSO.CUST_PARTNO,NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(PLA.NOTE_TO_VENDOR)"+ //modify by Peggy 20230607
          "                 ,CASE WHEN PLLA.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
          "                  FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
          "                  WHERE x.org_id= CASE WHEN SUBSTR(PLLA.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
          "                  AND x.header_id=y.header_id"+
          "                  AND y.packing_instructions='T'"+
          "                  AND x.order_number= SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1)"+
          "                  AND y.shipment_number=1 and y.line_number=SUBSTR(PLLA.NOTE_TO_RECEIVER,INSTR(PLLA.NOTE_TO_RECEIVER,'.')+1))"+
          "                  ELSE '' END)) PO_CUST_PARTNO,"+
          "                  NULL SHIP_SO_NO,NULL SHIPPING_REMARK,NULL ADVISE_NO,NULL PC_SCHEDULE_SHIP_DATE,NULL PICK_CONFIRM_DATE,NULL DELIVERY_NAME,NULL ERP_SHIP_CONFIRM_DATE"+
          //"                  , TO_CHAR(TPRD.RETURNED_DATE,'YYYY/MM/DD') RETURN_DATE,TPRD.RETURN_REASON ,NULL ALLOCATED_OUT_DATE,NULL REMARKS ,NULL CARTON_LIST"+
		  "                  , TO_CHAR(TPRD.RETURN_APPROVE_DATE,'YYYY/MM/DD') RETURN_DATE,TPRD.RETURN_REASON ,NULL ALLOCATED_OUT_DATE,NULL REMARKS ,NULL CARTON_LIST"+ //改成RETURN_APPROVE_DATE by Peggy 20211229
          " FROM ORADDMAN.TSSG_PO_RECEIVE_DETAIL TPRD "+
          " ,ORADDMAN.TSSG_STOCK_OVERVIEW TSO"+
          " ,PO.PO_HEADERS_ALL PHA"+
          " ,PO.PO_LINE_LOCATIONS_ALL PLLA"+
          " ,PO.PO_LINES_ALL PLA"+
          //" WHERE TPRD.RETURNED_DATE BETWEEN  TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+
		  " WHERE TPRD.RETURN_APPROVE_DATE BETWEEN  TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+  //改成RETURN_APPROVE_DATE by Peggy 20211229
          " AND NVL(TPRD.RETURN_QTY,0)>0"+
          " AND TPRD.ORGANIZATION_ID=TSO.ORGANIZATION_ID"+
          //" AND TPRD.SUBINVENTORY_CODE=TSO.SUBINVENTORY_CODE"+
		  " AND NVL(TPRD.SUBINVENTORY_CODE,DECODE(TPRD.DELIVERY_TYPE,'Y','02','01'))=TSO.SUBINVENTORY_CODE"+ //modify by Peggy 20210323
          " AND TPRD.INVENTORY_ITEM_ID=TSO.INVENTORY_ITEM_ID"+
          " AND TPRD.LOT_NUMBER=TSO.LOT_NUMBER"+
          " AND TPRD.DATE_CODE=TSO.DATE_CODE"+
          " AND TPRD.PO_LINE_LOCATION_ID=TSO.PO_LINE_LOCATION_ID"+
          " AND TPRD.RECEIPT_NUM=TSO.RECEIPT_NUM"+
          " AND TSO.PO_HEADER_ID=PHA.PO_HEADER_ID(+)"+
          " AND TSO.PO_LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID(+)"+
          " AND PLLA.PO_LINE_ID=PLA.PO_LINE_ID(+)";
	sql_allocate= " UNION ALL"+  //---------調撥出
          " SELECT TSO.SG_STOCK_ID,TRUNC(SYSDATE)-TRUNC(TSO.RECEIVED_DATE) STOCK_AGE,TSC_INV_CATEGORY(TSO.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP,TSC_INV_CATEGORY(TSO.INVENTORY_ITEM_ID,43,23) TSC_Package"+
		  " ,TSO.ORGANIZATION_ID,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM/DD') RECIVED_DATE,TSO.VENDOR_SITE_CODE,TSO.INVENTORY_ITEM_ID,TSO.ITEM_NAME,TSO.ITEM_DESC"+
          " ,TSO.SUBINVENTORY_CODE,TSO.LOT_NUMBER,TSO.DATE_CODE,TSO.DC_YYWW"+
          " ,(CASE WHEN TRUNC(TSO.RECEIVED_DATE)<TO_DATE('"+SDATE+"','YYYYMMDD') THEN NVL(TSAD.ALLOCATED_QTY,0) ELSE 0 END)/1000 OPEN_QTY"+
          " ,(CASE WHEN TRUNC(TSO.RECEIVED_DATE)>=TO_DATE('"+SDATE+"','YYYYMMDD') THEN NVL(TSAD.ALLOCATED_QTY,0) ELSE 0 END)/1000 RECEIVED_QTY"+
          " ,0 ALLOCATE_IN_QTY,0 RETURN_QTY,NVL(TSAD.ALLOCATED_QTY,0)/1000 ALLOCATE_OUT_QTY,0 PICK_QTY,0 SHIPPED_QTY"+
          " ,0 ONHAND_QTY"+
          " ,TSO.RECEIPT_NUM,PHA.SEGMENT1 PO_NO,SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1) SO_NO"+
          //" ,NVL(TSO.CUST_PARTNO,NVL(TRIM(REPLACE(REPLACE(CASE INSTR(PLA.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN PLA.NOTE_TO_VENDOR ELSE SUBSTR(PLA.NOTE_TO_VENDOR,1,INSTR(PLA.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
          " ,NVL(TSO.CUST_PARTNO,NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(PLA.NOTE_TO_VENDOR)"+ //modify by Peggy 20230607
          "                 ,CASE WHEN PLLA.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
          "                  FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
          "                  WHERE x.org_id= CASE WHEN SUBSTR(PLLA.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
          "                  AND x.header_id=y.header_id"+
          "                  AND y.packing_instructions='T'"+
          "                  AND x.order_number= SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1)"+
          "                  AND y.shipment_number=1 and y.line_number=SUBSTR(PLLA.NOTE_TO_RECEIVER,INSTR(PLLA.NOTE_TO_RECEIVER,'.')+1))"+
          "                  ELSE '' END)) PO_CUST_PARTNO,"+
          "                  NULL SHIP_SO_NO,NULL SHIPPING_REMARK,NULL ADVISE_NO,NULL PC_SCHEDULE_SHIP_DATE,NULL PICK_CONFIRM_DATE,NULL DELIVERY_NAME,NULL ERP_SHIP_CONFIRM_DATE"+
          "                  ,NULL RETURN_DATE,NULL RETURN_REASON ,TO_CHAR(TSAD.ALLOCATED_DATE,'YYYY/MM/DD') ALLOCATED_OUT_DATE,NULL REMARKS ,NULL CARTON_LIST"+
          " FROM ORADDMAN.TSSG_STOCK_ALLOCATE_DETAIL TSAD"+
          " ,ORADDMAN.TSSG_STOCK_OVERVIEW TSO"+
          " ,PO.PO_HEADERS_ALL PHA"+
          " ,PO.PO_LINE_LOCATIONS_ALL PLLA"+
          " ,PO.PO_LINES_ALL PLA"+
          " WHERE TSAD.ALLOCATED_DATE BETWEEN  TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+
          " AND TSAD.SG_STOCK_ID=TSO.SG_STOCK_ID"+
          " AND TSO.PO_HEADER_ID=PHA.PO_HEADER_ID(+)"+
          " AND TSO.PO_LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID(+)"+
          " AND PLLA.PO_LINE_ID=PLA.PO_LINE_ID(+)";
	sql_pick= " UNION ALL"+   //-----撿貨
          " SELECT TSO.SG_STOCK_ID,TRUNC(SYSDATE)-TRUNC(TSO.RECEIVED_DATE) STOCK_AGE,TSC_INV_CATEGORY(TSO.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP,TSC_INV_CATEGORY(TSO.INVENTORY_ITEM_ID,43,23) TSC_Package"+
		  " ,TSO.ORGANIZATION_ID,TO_CHAR(TSO.RECEIVED_DATE,'YYYY/MM/DD') RECIVED_DATE,TSO.VENDOR_SITE_CODE,TSO.INVENTORY_ITEM_ID,TSO.ITEM_NAME,TSO.ITEM_DESC"+
          " ,TSO.SUBINVENTORY_CODE,TSO.LOT_NUMBER,TSO.DATE_CODE,TSO.DC_YYWW"+
		  " ,STK.OPEN_QTY/1000 OPEN_QTY,STK.RECEIVED_QTY/1000 RECEIVED_QTY,STK.ALLOCATE_IN_QTY/1000 ALLOCATE_IN_QTY,STK.RETURN_QTY/1000 RETURN_QTY"+
		  " ,STK.ALLOCATE_OUT_QTY/1000 ALLOCATE_OUT_QTY,STK.PICK_QTY/1000 PICK_QTY,STK.SHIPPED_QTY/1000 SHIPPED_QTY"+
          " ,(NVL(STK.OPEN_QTY,0)+NVL(STK.RECEIVED_QTY,0)+NVL(STK.ALLOCATE_IN_QTY,0)-NVL(STK.RETURN_QTY,0)-NVL(STK.ALLOCATE_OUT_QTY,0)-NVL(STK.PICK_QTY,0)-NVL(STK.SHIPPED_QTY,0))/1000 ONHAND_QTY"+
          " ,TSO.RECEIPT_NUM,PHA.SEGMENT1 PO_NO,SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1) SO_NO"+
          //" ,NVL(TSO.CUST_PARTNO,NVL(TRIM(REPLACE(REPLACE(CASE INSTR(PLA.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN PLA.NOTE_TO_VENDOR ELSE SUBSTR(PLA.NOTE_TO_VENDOR,1,INSTR(PLA.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
          " ,NVL(TSO.CUST_PARTNO,NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(PLA.NOTE_TO_VENDOR)"+ //modify by Peggy 20230607
          "                 ,CASE WHEN PLLA.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
          "                  FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
          "                  WHERE x.org_id= CASE WHEN SUBSTR(PLLA.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
          "                  AND x.header_id=y.header_id"+
          "                  AND y.packing_instructions='T'"+
          "                  AND x.order_number= SUBSTR(PLLA.NOTE_TO_RECEIVER,1,INSTR(PLLA.NOTE_TO_RECEIVER,'.')-1)"+
          "                  AND y.shipment_number=1 and y.line_number=SUBSTR(PLLA.NOTE_TO_RECEIVER,INSTR(PLLA.NOTE_TO_RECEIVER,'.')+1))"+
          "                  ELSE '' END)) PO_CUST_PARTNO,"+
          "                  STK.SHIP_SO_NO,STK.SHIPPING_REMARK,STK.ADVISE_NO,STK.PC_SCHEDULE_SHIP_DATE,STK.PICK_CONFIRM_DATE,STK.DELIVERY_NAME,STK.ERP_SHIP_CONFIRM_DATE"+
          "                  , NULL RETURN_DATE,NULL RETURN_REASON,NULL ALLOCATED_OUT_DATE,NULL REMARKS,STK.CARTON_LIST "+
          " FROM (SELECT A.SG_STOCK_ID,TSAL.SO_NO SHIP_SO_NO,TSAL.SHIPPING_REMARK,TSAH.ADVISE_NO,TO_CHAR(TSAL.PC_SCHEDULE_SHIP_DATE,'YYYY/MM/DD') PC_SCHEDULE_SHIP_DATE,TO_CHAR(TPCH.PICK_CONFIRM_DATE,'YYYY/MM/DD') PICK_CONFIRM_DATE"+
          " ,NULL DELIVERY_NAME,NULL ERP_SHIP_CONFIRM_DATE"+
          " ,SUM(CASE WHEN TRUNC(A.RECEIVED_DATE)<TO_DATE('"+SDATE+"','YYYYMMDD')  AND A.FROM_SG_STOCK_ID IS NULL THEN TPCL.QTY ELSE 0 END) OPEN_QTY"+
          " ,SUM(CASE WHEN TRUNC(A.RECEIVED_DATE)>=TO_DATE('"+SDATE+"','YYYYMMDD') AND A.FROM_SG_STOCK_ID IS NULL THEN TPCL.QTY ELSE 0 END) RECEIVED_QTY"+
          " ,SUM(CASE WHEN TRUNC(A.RECEIVED_DATE)<=TO_DATE('"+EDATE+"','YYYYMMDD') AND A.FROM_SG_STOCK_ID IS NOT NULL THEN TPCL.QTY ELSE 0 END) ALLOCATE_IN_QTY"+
          " ,0 RETURN_QTY,0 ALLOCATE_OUT_QTY,NVL(SUM(TPCL.QTY),0) PICK_QTY,0 SHIPPED_QTY"+
          " ,LISTAGG(TPCL.CARTON_NO||TSAH.POST_FIX_CODE,',') WITHIN GROUP (ORDER BY TPCL.CARTON_NO) CARTON_LIST "+
          " FROM TSC.TSC_PICK_CONFIRM_HEADERS TPCH"+
          " ,TSC.TSC_PICK_CONFIRM_LINES TPCL "+
          " ,ORADDMAN.TSSG_STOCK_OVERVIEW A"+
          " ,TSC.TSC_SHIPPING_ADVISE_LINES TSAL"+
          " ,TSC.TSC_SHIPPING_ADVISE_HEADERS TSAH"+
          " WHERE TPCL.ORGANIZATION_ID IN (907,908)"+
          //" AND TPCL.LAST_UPDATE_DATE BETWEEN TO_DATE('"+SDATE+"','YYYYMMDD') AND TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+
		  " AND TPCL.LAST_UPDATE_DATE <= TO_DATE('"+EDATE+"','YYYYMMDD')+0.99999"+  //跨月撿貨issue,modify by Peggy 20200707
          " AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID"+
          " AND TPCH.PICK_CONFIRM_DATE IS NULL "+
          " AND TPCL.SG_STOCK_ID=A.SG_STOCK_ID"+
          " AND TPCL.ADVISE_LINE_ID=TSAL.ADVISE_LINE_ID"+
          " AND TSAL.ORGANIZATION_ID IN (907,908)"+
          " AND TSAL.ADVISE_HEADER_ID=TSAH.ADVISE_HEADER_ID"+
          " GROUP BY A.SG_STOCK_ID,TSAL.SO_NO ,TSAL.SHIPPING_REMARK,TSAH.ADVISE_NO,TO_CHAR(TSAL.PC_SCHEDULE_SHIP_DATE,'YYYY/MM/DD') ,TO_CHAR(TPCH.PICK_CONFIRM_DATE,'YYYY/MM/DD'))STK"+
          " ,ORADDMAN.TSSG_STOCK_OVERVIEW TSO"+
          " ,PO.PO_HEADERS_ALL PHA"+
          " ,PO.PO_LINE_LOCATIONS_ALL PLLA"+
          " ,PO.PO_LINES_ALL PLA"+
          " WHERE STK.SG_STOCK_ID=TSO.SG_STOCK_ID"+
          " AND TSO.PO_HEADER_ID=PHA.PO_HEADER_ID(+)"+
          " AND TSO.PO_LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID(+)"+
          " AND PLLA.PO_LINE_ID=PLA.PO_LINE_ID(+)"+
          " ORDER BY 2,4,3,7";
	//out.println(sql+sql_ship+sql_return+sql_allocate+sql_pick);
	//out.println(sqlx);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql+sql_ship+sql_return+sql_allocate+sql_pick);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//資料日期
			ws.mergeCells(col, row, col+3, row);     
			ws.addCell(new jxl.write.Label(col, row, "資料日期:" +YearFr+"/"+MonthFr+"/"+DayFr+"~"+YearTo+"/"+MonthTo+"/"+DayTo, LeftBLY));
			row++;
						
			//內外銷
			ws.addCell(new jxl.write.Label(col, row, "內外銷" , ACenterBLB));
			ws.setColumnView(col,5);	
			col++;	

			//tsc_prod_group
			ws.addCell(new jxl.write.Label(col, row, "TSC_PROD_GROUP" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
			
			//庫齡
			ws.addCell(new jxl.write.Label(col, row, "庫齡/天" , ACenterBLB));
			ws.setColumnView(col,7);	
			col++;				
			
			//收料日期
			ws.addCell(new jxl.write.Label(col, row, "收料日期" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
			
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,28);	
			col++;	

			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//倉別
			ws.addCell(new jxl.write.Label(col, row, "Subinventory Code" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//LOT
			ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//D/C
			ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//期初數量(K)
			ws.addCell(new jxl.write.Label(col, row, "期初數量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//收貨數量(K)
			ws.addCell(new jxl.write.Label(col, row, "收貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//退貨數量
			ws.addCell(new jxl.write.Label(col, row, "退貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;

			//調撥(入)數量
			ws.addCell(new jxl.write.Label(col, row, "調撥入(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;

			//退貨數量
			ws.addCell(new jxl.write.Label(col, row, "調撥出(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;

			//撿貨數量
			ws.addCell(new jxl.write.Label(col, row, "撿貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//出貨數量(K)
			ws.addCell(new jxl.write.Label(col, row, "出貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;		

			//庫存
			ws.addCell(new jxl.write.Label(col, row, "庫存數量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//M/O單號
			ws.addCell(new jxl.write.Label(col, row, "收貨MO#" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//客戶品號
			ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//採購單號
			ws.addCell(new jxl.write.Label(col, row, "採購單號" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//驗收單號
			ws.addCell(new jxl.write.Label(col, row, "驗收單號" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;					
						
			//Advise No
			ws.addCell(new jxl.write.Label(col, row, "Advise No" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//出貨MO
			ws.addCell(new jxl.write.Label(col, row, "出貨MO#" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
									
			//嘜頭
			ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	
				
			//目的地
			//ws.addCell(new jxl.write.Label(col, row, "目的地" , ACenterBLB));
			//ws.setColumnView(col,20);	
			//col++;					
					
			//出貨日期
			ws.addCell(new jxl.write.Label(col, row, "出貨日期" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
						
			//RFQ出貨日
			ws.addCell(new jxl.write.Label(col, row, "RFQ Ship Conifrm Date" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;		
			
			//ERP SHIP CONFIRM日
			ws.addCell(new jxl.write.Label(col, row, "ERP Ship Confirm Date" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
						
			//SG發票號
			ws.addCell(new jxl.write.Label(col, row, "SG發票號" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//箱號
			ws.addCell(new jxl.write.Label(col, row, "箱號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	
			
			//退貨日期
			ws.addCell(new jxl.write.Label(col, row, "退貨日期" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
			
			//退貨原因
			ws.addCell(new jxl.write.Label(col, row, "退貨原因" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			//調撥日期
			ws.addCell(new jxl.write.Label(col, row, "調撥日期" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//備註
			ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;									

			//TSC_Package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//DC YYWW
			ws.addCell(new jxl.write.Label(col, row, "DC YYWW" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	
			row++;
		}
		col=0;
		if (rs.getString("ORGANIZATION_ID").equals("907"))
		{
			ws.addCell(new jxl.write.Label(col, row, "內銷", ACenterL));
		}
		else if (rs.getString("ORGANIZATION_ID").equals("908"))
		{
			ws.addCell(new jxl.write.Label(col, row, "外銷", ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ORGANIZATION_ID"), ACenterL));
		}
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP"), ACenterL));
		col++;	
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
		if (rs.getString("RECIVED_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("RECIVED_DATE")) ,DATE_FORMAT));
		}
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_SITE_CODE"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SUBINVENTORY_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("OPEN_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("RECEIVED_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("RETURN_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ALLOCATE_IN_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ALLOCATE_OUT_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PICK_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SHIPPED_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ONHAND_QTY")).doubleValue(), (rs.getFloat("ONHAND_QTY")>0?ARightLB:(rs.getFloat("ONHAND_QTY")<0?ARightLR:ARightL))));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SO_NO")==null?"": rs.getString("SO_NO")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PO_CUST_PARTNO")==null?"":rs.getString("PO_CUST_PARTNO")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PO_NO") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIPT_NUM") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ADVISE_NO")==null?"":rs.getString("ADVISE_NO")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIP_SO_NO")==null?"":rs.getString("SHIP_SO_NO")) ,ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIPPING_REMARK")==null?"":rs.getString("SHIPPING_REMARK")) , ALeftL));
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, rs.getString("DESTINATION_LIST") ,ALeftL));
		//col++;	
		if (rs.getString("PC_SCHEDULE_SHIP_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("PC_SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
		}
		col++;	
		if (rs.getString("PICK_CONFIRM_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("PICK_CONFIRM_DATE")) ,DATE_FORMAT));
		}
		col++;	
		if (rs.getString("ERP_SHIP_CONFIRM_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ERP_SHIP_CONFIRM_DATE")) ,DATE_FORMAT));
		}		
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("DELIVERY_NAME")==null?"":rs.getString("DELIVERY_NAME")) ,  ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CARTON_LIST")==null?"":rs.getString("CARTON_LIST")) , ALeftL));
		col++;	
		if (rs.getString("RETURN_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("RETURN_DATE")) ,DATE_FORMAT));
		}		
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("RETURN_REASON")==null?"":rs.getString("RETURN_REASON")) , ALeftL));
		col++;	
		if (rs.getString("ALLOCATED_OUT_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ALLOCATED_OUT_DATE")) ,DATE_FORMAT));
		}		
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("REMARKS")==null?"":rs.getString("REMARKS")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_Package")==null?"":rs.getString("TSC_Package")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("DC_YYWW")==null?"": rs.getString("DC_YYWW")), ALeftL));
		col++;	
		row++;
		
		reccnt ++;
	}	
	wwb.write(); 
	wwb.close();

	rs.close();
	statement.close();

	if (RTYPE.equals("AUTO") && reccnt>0)
	{
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		remarks="";
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jojo@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ivy@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zhangdi@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sunjun@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("coco@mail.tew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("eva@mail.tew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("aggie@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wws@mail.tew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ian@mail.tew.com.cn"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("TEW In & Out Stock Report - "+dateBean.getYearMonthDay()+remarks);
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		mbp = new javax.mail.internet.MimeBodyPart();
		javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		mbp.setDataHandler(new javax.activation.DataHandler(fds));
		mbp.setFileName(fds.getName());
	
		// create the Multipart and add its parts to it
		mp.addBodyPart(mbp);
		message.setContent(mp);
		Transport.send(message);	
	}	 
	os.close();  
	out.close(); 
	
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
	if (!RTYPE.equals("AUTO"))
	{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/report/"+FileName; 
		response.sendRedirect(strURL);
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
