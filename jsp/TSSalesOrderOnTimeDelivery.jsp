<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
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
<FORM ACTION="../jsp/TSSalesOrderOnTimeDelivery.jsp" METHOD="post" name="MYFORM">
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="20150101";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE=dateBean.getYearMonthDay();
String FileName="",RPTName="",PLANTNAME="",sql="",sql1="",sql2="",sql3="",remarks="";
int fontsize=8,colcnt=0,sheetcnt=0;
String TOT_CNT="",TOT_OVER_DUE_CNT="",TOT_OVER_DUE_RATE="",TOT_ON_TIME_CNT="",TOT_ON_TIME_RATE="",str_factory="",months_all="";
int TOT_PO_CNT =0,TOT_ORDER_OVER_LEAD_TIME_PO_CNT=0,OVER_LEAD_TIME_PO_CNT=0,months_cnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
String [] months_list = null;
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "OnTime Delivery Report";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//WritableSheet ws = wwb.createSheet(RPTName, 0); 
	//wwb.createSheet("Row Data", 0);
	//wwb.createSheet("Analysis_On Time %", 1);
	//wwb.createSheet("PO Over Count", 2);
	WritableSheet ws = null;

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

	
	String sqlx="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sqlx);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
	
	sql = " SELECT TO_CHAR(ADD_MONTHS(TRUNC(to_date(?,'yyyymmdd')),ROWNUM-1),'YYYY-MON') YYYYMON"+
	      ",TO_CHAR(ADD_MONTHS(TRUNC(to_date(?,'yyyymmdd')),ROWNUM-1),'MON') MONS"+
		  ",rownum,ceil(months_between(to_date(?,'yyyymmdd'),to_date(?,'yyyymmdd'))) months_cnt FROM DUAL"+
          " CONNECT BY ROWNUM<=(select ceil(months_between(to_date(?,'yyyymmdd'),to_date(?,'yyyymmdd'))) FROM DUAL)";
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,SDATE);
	statement.setString(2,SDATE);
	statement.setString(3,EDATE);
	statement.setString(4,SDATE);
	statement.setString(5,EDATE);
	statement.setString(6,SDATE);
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{	
		if (months_list==null)
		{
			months_list = new String[rs.getInt("months_cnt")+1];
		}	
		months_list[rs.getInt("rownum")-1]=rs.getString("YYYYMON");
		if (rs.getInt("rownum")==1)
		{
			months_all = rs.getString("YYYYMON");
		}
		else if (rs.getInt("rownum")==rs.getInt("months_cnt"))
		{
			months_all += " ~ "+(!SDATE.substring(1,4).equals(EDATE.substring(1,4))?rs.getString("YYYYMON"):rs.getString("MONS"));
		}
	}	
	months_list[months_list.length-1]=months_all;
	rs.close();
	statement.close();	

	sql = " SELECT ROW_NUMBER() OVER (PARTITION BY TOT.SHIPPED_MON ORDER BY TOT.SALES_REGION,TOT.ORDER_NUMBER,TOT.LINE_NO) SHIPPED_MON_SEQ"+
          ",TOT.*"+
          ",COUNT(1) OVER (PARTITION BY TOT.SHIPPED_MON) SHIPPED_MON_CNT"+
          ",SUM(CASE WHEN TOT.SALES_HOLD_FLAG=? THEN ? ELSE ? END) OVER (PARTITION BY TOT.SHIPPED_MON) SALES_HOLD_MON_CNT"+
          ",SUM(CASE WHEN TOT.SALES_HOLD_FLAG=? AND TOT.OVERDUE_FLAG=? THEN ? ELSE ? END) OVER (PARTITION BY TOT.SHIPPED_MON) OVERDUE_MON_CNT"+
          ",COUNT(1) OVER (PARTITION BY TOT.SHIPPED_MON,TOT.FACTORY) SHIPPED_FACTORY_MON_CNT"+
          ",SUM(CASE WHEN TOT.SALES_HOLD_FLAG=? THEN ? ELSE ? END) OVER (PARTITION BY TOT.SHIPPED_MON,TOT.FACTORY) SALES_HOLD_FACTORY_MON_CNT"+
          ",SUM(CASE WHEN TOT.SALES_HOLD_FLAG=? AND TOT.OVERDUE_FLAG=? THEN ? ELSE ? END) OVER (PARTITION BY TOT.SHIPPED_MON,TOT.FACTORY) OVERDUE_FACTORY_MON_CNT"+
          ",COUNT(1) OVER (PARTITION BY TOT.FACTORY) SHIPPED_FACTORY_CNT"+
          ",SUM(CASE WHEN TOT.SALES_HOLD_FLAG=? THEN ? ELSE ? END) OVER (PARTITION BY TOT.FACTORY) SALES_HOLD_FACTORY_CNT"+
          ",SUM(CASE WHEN TOT.SALES_HOLD_FLAG=? AND TOT.OVERDUE_FLAG=? THEN ? ELSE ? END) OVER (PARTITION BY TOT.FACTORY) OVERDUE_FACTORY_CNT"+
          ",ROW_NUMBER() OVER (PARTITION BY TOT.SHIPPED_MON,TOT.FACTORY ORDER BY TOT.SALES_REGION,TOT.ORDER_NUMBER,TOT.LINE_NO) SHIPPED_FACTORY_MON_SEQ"+
          " FROM (SELECT TO_CHAR(OLA.ACTUAL_SHIPMENT_DATE,'YYYY-MM') SHIPPED_MM,TO_CHAR(OLA.ACTUAL_SHIPMENT_DATE,'YYYY-MON') SHIPPED_MON,TSC_INTERCOMPANY_PKG.GET_SALES_GROUP(OHA.HEADER_ID) SALES_REGION,AC.CUSTOMER_NAME,OHA.ORDER_NUMBER,OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER LINE_NO,MSI.SEGMENT1,MSI.DESCRIPTION"+
          " ,TO_CHAR(OLA.SCHEDULE_SHIP_DATE,'YYYY/MM/DD') SCHEDULE_SHIP_DATE"+
		  " ,TO_CHAR(OLA.ACTUAL_SHIPMENT_DATE,'YYYY/MM/DD') ACTUAL_SHIPMENT_DATE"+
		  " ,TO_CHAR(OLA.REQUEST_DATE,'YYYY/MM/DD') REQUEST_DATE"+
          " ,OLA.PACKING_INSTRUCTIONS"+
          " ,TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP"+
          " ,TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,21) TSC_FAMILY"+
          " ,TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,23) TSC_PACKAGE"+
          " ,CASE WHEN OLA.PACKING_INSTRUCTIONS=? THEN ? WHEN OLA.PACKING_INSTRUCTIONS=? THEN ? ELSE CASE WHEN TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003) IN (?,?) THEN TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003) ELSE ? END END FACTORY"+
          " ,CASE WHEN TRUNC(OLA.ACTUAL_SHIPMENT_DATE)-TRUNC(OLA.REQUEST_DATE)>=? THEN ? ELSE ? END  OVERDUE_FLAG"+
          " ,NVL((SELECT DISTINCT ? FROM ONT.OE_ORDER_LINES_HISTORY OOLH WHERE OOLH.LINE_ID=OLA.LINE_ID AND NVL(OOLH.ATTRIBUTE20,?) IN (?,?,?)),?) SALES_HOLD_FLAG"+
          "  FROM ONT.OE_ORDER_HEADERS_ALL OHA,"+
          " ONT.OE_ORDER_LINES_ALL OLA,"+
          " INV.MTL_SYSTEM_ITEMS_B MSI,"+
          " AR_CUSTOMERS AC"+
          " WHERE OLA.ACTUAL_SHIPMENT_DATE BETWEEN TO_DATE(?,'YYYYMMDD') AND TO_DATE(?,'YYYYMMDD')+0.99999"+
          " AND OHA.ORG_ID=?"+
          " AND OHA.HEADER_ID=OLA.HEADER_ID"+
          " AND OLA.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID"+
          " AND OLA.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID"+
          " AND OHA.SOLD_TO_ORG_ID=AC.CUSTOMER_ID"+
          " AND SUBSTR(OHA.ORDER_NUMBER,1,4) IN (?,?,?,?,?)) TOT"+
          " ORDER BY 2,1";
	sql1 = " SELECT 1 RANK_NO"+
	       ",XX.SHIPPED_MM"+
           ",XX.SHIPPED_MON"+
           ",XX.FACTORY"+
           ",ROW_NUMBER() OVER (PARTITION BY XX.FACTORY ORDER BY XX.SHIPPED_MM) FACTORY_SEQ"+
           ",COUNT(1) OVER (PARTITION BY XX.FACTORY) FACTORY_CNT"+
           ",XX.SALES_HOLD_FACTORY_MON_CNT"+
           ",ROUND(XX.SALES_HOLD_FACTORY_MON_CNT/XX.SHIPPED_FACTORY_MON_CNT,3)*100||'%' SALES_HOLD_FACTORY_MON_RATE"+
           ",XX.OVERDUE_FACTORY_MON_CNT"+
		   ",ROUND(XX.OVERDUE_FACTORY_MON_CNT/XX.SHIPPED_FACTORY_MON_CNT,3)*100||'%' OVERDUE_FACTORY_MON_RATE"+
           ",XX.SHIPPED_FACTORY_MON_CNT-XX.OVERDUE_FACTORY_MON_CNT-XX.SALES_HOLD_FACTORY_MON_CNT ONTIME_FACTORY_MON_CNT"+
           ",100-(ROUND(XX.OVERDUE_FACTORY_MON_CNT/XX.SHIPPED_FACTORY_MON_CNT,3)*100)-(ROUND(XX.SALES_HOLD_FACTORY_MON_CNT/XX.SHIPPED_FACTORY_MON_CNT,3)*100)||'%' ONTIME_FACTORY_MON_RATE"+
           ",XX.SHIPPED_FACTORY_MON_CNT"+
           ",XX.SHIPPED_MON_CNT"+
		   //",XX.SALES_HOLD_MON_CNT"+
           //",ROUND(XX.SALES_HOLD_MON_CNT/XX.SHIPPED_MON_CNT,3)*100||'%' SALES_HOLD_MON_RATE"+
           //",XX.OVERDUE_MON_CNT"+
		   //",ROUND(XX.OVERDUE_MON_CNT/XX.SHIPPED_MON_CNT,3)*100||'%' OVERDUE_MON_RATE"+
           //",XX.SHIPPED_MON_CNT-XX.OVERDUE_MON_CNT-XX.SALES_HOLD_MON_CNT ONTIME_MON_CNT"+
           //",100-(ROUND(XX.OVERDUE_MON_CNT/XX.SHIPPED_MON_CNT,3)*100)-(ROUND(XX.SALES_HOLD_MON_CNT/XX.SHIPPED_MON_CNT,3)*100)||'%' ONTIME_MON_RATE"+
           ",XX.SHIPPED_FACTORY_CNT"+
		   ",XX.SALES_HOLD_FACTORY_CNT"+
           ",ROUND(XX.SALES_HOLD_FACTORY_CNT/XX.SHIPPED_FACTORY_CNT,3)*100||'%' SALES_HOLD_FACTORY_RATE"+
           ",XX.OVERDUE_FACTORY_CNT"+
		   ",ROUND(XX.OVERDUE_FACTORY_CNT/XX.SHIPPED_FACTORY_CNT,3)*100||'%' OVERDUE_FACTORY_RATE"+
           ",XX.SHIPPED_FACTORY_CNT-XX.OVERDUE_FACTORY_CNT-XX.SALES_HOLD_FACTORY_CNT ONTIME_FACTORY_CNT"+
           ",100-(ROUND(XX.OVERDUE_FACTORY_CNT/XX.SHIPPED_FACTORY_CNT,3)*100)-(ROUND(XX.SALES_HOLD_FACTORY_CNT/XX.SHIPPED_FACTORY_CNT,3)*100)||'%' ONTIME_FACTORY_RATE"+
           " FROM ("+sql +") XX WHERE XX.SHIPPED_FACTORY_MON_SEQ=1";
	sql3=  " UNION ALL"+
		   " SELECT DISTINCT 2 RANK_NO"+
		   ",XX.SHIPPED_MM"+
           ",XX.SHIPPED_MON"+
           ",'Total' FACTORY"+
           ",ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY XX.SHIPPED_MM) FACTORY_SEQ"+
           ",COUNT(DISTINCT XX.SHIPPED_MM) OVER (PARTITION BY 1) FACTORY_CNT"+
           ",XX.SALES_HOLD_MON_CNT SALES_HOLD_FACTORY_MON_CNT"+
           ",ROUND(XX.SALES_HOLD_MON_CNT/XX.SHIPPED_MON_CNT,3)*100||'%' SALES_HOLD_FACTORY_MON_RATE"+
           ",XX.OVERDUE_MON_CNT OVERDUE_FACTORY_MON_CNT"+
		   ",ROUND(XX.OVERDUE_MON_CNT/XX.SHIPPED_MON_CNT,3)*100||'%' OVERDUE_FACTORY_MON_RATE"+
           ",XX.SHIPPED_MON_CNT-XX.OVERDUE_MON_CNT-XX.SALES_HOLD_MON_CNT ONTIME_FACTORY_MON_CNT"+
           ",100-(ROUND(XX.OVERDUE_MON_CNT/XX.SHIPPED_MON_CNT,3)*100)-(ROUND(XX.SALES_HOLD_MON_CNT/XX.SHIPPED_MON_CNT,3)*100)||'%' ONTIME_FACTORY_MON_RATE"+
           ",XX.SHIPPED_MON_CNT SHIPPED_FACTORY_MON_CNT"+
           ",XX.SHIPPED_MON_CNT"+
           ",SUM(XX.SHIPPED_MON_CNT) OVER (PARTITION BY 1) SHIPPED_FACTORY_CNT"+
		   ",SUM(XX.SALES_HOLD_MON_CNT) OVER (PARTITION BY 1) SALES_HOLD_FACTORY_CNT"+
           ",ROUND(SUM(XX.SALES_HOLD_MON_CNT) OVER (PARTITION BY 1)/SUM(XX.SHIPPED_MON_CNT ) OVER (PARTITION BY 1),3)*100||'%' SALES_HOLD_FACTORY_RATE"+
           ",SUM(XX.OVERDUE_MON_CNT) OVER (PARTITION BY 1) OVERDUE_FACTORY_CNT"+
		   ",ROUND(SUM(XX.OVERDUE_MON_CNT) OVER (PARTITION BY 1)/SUM(XX.SHIPPED_MON_CNT ) OVER (PARTITION BY 1),3)*100||'%' OVERDUE_FACTORY_RATE"+
           ",SUM(XX.SHIPPED_MON_CNT) OVER (PARTITION BY 1)-SUM(XX.OVERDUE_MON_CNT) OVER (PARTITION BY 1)-SUM(XX.SALES_HOLD_MON_CNT) OVER (PARTITION BY 1) ONTIME_FACTORY_CNT"+
           ",100-(ROUND(SUM(XX.OVERDUE_MON_CNT) OVER (PARTITION BY 1)/SUM(XX.SHIPPED_MON_CNT ) OVER (PARTITION BY 1),3)*100)-(ROUND(SUM(XX.SALES_HOLD_MON_CNT) OVER (PARTITION BY 1)/SUM(XX.SHIPPED_MON_CNT ) OVER (PARTITION BY 1),3)*100)||'%' ONTIME_FACTORY_RATE"+
           " FROM ("+sql +") XX WHERE XX.SHIPPED_MON_SEQ=1"+		   
		   " ORDER BY 1,4,2";
	//out.println(sql);
	for (int loop_cnt =1 ; loop_cnt <=2 ; loop_cnt++)
	{
		if (loop_cnt ==1)
		{
			sql2=sql1+sql3;
		}
		else
		{
			sql2=sql;
		}
		//out.println(sql2);
		statement = con.prepareStatement(sql2);
		statement.setString(1,"Y");
		statement.setString(2,"1");
		statement.setString(3,"0");
		statement.setString(4,"N");
		statement.setString(5,"Y");
		statement.setString(6,"1");
		statement.setString(7,"0");
		statement.setString(8,"Y");
		statement.setString(9,"1");
		statement.setString(10,"0");
		statement.setString(11,"N");
		statement.setString(12,"Y");
		statement.setString(13,"1");
		statement.setString(14,"0");
		statement.setString(15,"Y");
		statement.setString(16,"1");
		statement.setString(17,"0");
		statement.setString(18,"N");
		statement.setString(19,"Y");
		statement.setString(20,"1");
		statement.setString(21,"0");
		statement.setString(22,"Y");
		statement.setString(23,"YEW");
		statement.setString(24,"A");
		statement.setString(25,"A01");
		statement.setString(26,"PMD");
		statement.setString(27,"SSD");
		statement.setString(28,"Outsource");
		statement.setString(29,"4");
		statement.setString(30,"Y");
		statement.setString(31,"N");
		statement.setString(32,"Y");
		statement.setString(33,"N");
		statement.setString(34,"YP");
		statement.setString(35,"YC");
		statement.setString(36,"YT");
		statement.setString(37,"N");
		statement.setString(38,SDATE);
		statement.setString(39,EDATE);
		statement.setString(40,"41");
		statement.setString(41,"1131");
		statement.setString(42,"1141");
		statement.setString(43,"1142");
		statement.setString(44,"1156");
		statement.setString(45,"1214");
		if (loop_cnt ==1)
		{		
			statement.setString(46,"Y");
			statement.setString(47,"1");
			statement.setString(48,"0");
			statement.setString(49,"N");
			statement.setString(50,"Y");
			statement.setString(51,"1");
			statement.setString(52,"0");
			statement.setString(53,"Y");
			statement.setString(54,"1");
			statement.setString(55,"0");
			statement.setString(56,"N");
			statement.setString(57,"Y");
			statement.setString(58,"1");
			statement.setString(59,"0");
			statement.setString(60,"Y");
			statement.setString(61,"1");
			statement.setString(62,"0");
			statement.setString(63,"N");
			statement.setString(64,"Y");
			statement.setString(65,"1");
			statement.setString(66,"0");
			statement.setString(67,"Y");
			statement.setString(68,"YEW");
			statement.setString(69,"A");
			statement.setString(70,"A01");
			statement.setString(71,"PMD");
			statement.setString(72,"SSD");
			statement.setString(73,"Outsource");
			statement.setString(74,"4");
			statement.setString(75,"Y");
			statement.setString(76,"N");
			statement.setString(77,"Y");
			statement.setString(78,"N");
			statement.setString(79,"YP");
			statement.setString(80,"YC");
			statement.setString(81,"YT");
			statement.setString(82,"N");
			statement.setString(83,SDATE);
			statement.setString(84,EDATE);
			statement.setString(85,"41");
			statement.setString(86,"1131");
			statement.setString(87,"1141");
			statement.setString(88,"1142");
			statement.setString(89,"1156");
			statement.setString(90,"1214");
		}
		reccnt=0;col=0;row=0;
		rs=statement.executeQuery();
		while (rs.next())
		{	
			if (loop_cnt ==1)
			{
				if (reccnt==0)
				{
					col=0;row=0;
					wwb.createSheet("Overview", sheetcnt);
					ws = wwb.getSheet("Overview");
					SheetSettings sst = ws.getSettings(); 
					sst.setSelected();
					sst.setVerticalFreeze(1);
					sst.setVerticalFreeze(2);
					sst.setHorizontalFreeze(1);	
					sheetcnt++;	

					ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Factory" , ACenterBL));
					ws.setColumnView(col,12);	

					col=1;
					for (int j=0 ; j < months_list.length ; j++)
					{
						ws.mergeCells(col+(j*4), row, col+(j*4)+3, row); 
						ws.addCell(new jxl.write.Label(col+(j*4), row, months_list[j] , ACenterBL));
						//ws.setColumnView(col,12);	
						ws.addCell(new jxl.write.Label(col+(j*4), row+1, "Sales Hold", ACenterBL));
						ws.addCell(new jxl.write.Label(col+(j*4)+1, row+1, "Overdue" , ACenterBL));
						ws.addCell(new jxl.write.Label(col+(j*4)+2, row+1, "On Time" , ACenterBL));
						ws.addCell(new jxl.write.Label(col+(j*4)+3, row+1, "Total" , ACenterBL));
					}			
					row+=2;
				}
					
				if (!str_factory.equals(rs.getString("Factory")))
				{
					col=0;
					if (!str_factory.equals("")) row+=2;
					str_factory=rs.getString("Factory");
					ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, rs.getString("Factory"), ALeftL));
					col++;
				}
				
				for (int j=0 ; j < months_list.length ; j++)
				{
					if (rs.getString("SHIPPED_MON").equals(months_list[j]))
					{	
						ws.addCell(new jxl.write.Number(col+(j*4), row, Double.valueOf(rs.getString("SALES_HOLD_FACTORY_MON_CNT")).doubleValue(), ARightL));
						ws.addCell(new jxl.write.Label(col+(j*4), row+1, rs.getString("SALES_HOLD_FACTORY_MON_RATE"), ARightL));
						ws.addCell(new jxl.write.Number(col+(j*4)+1, row, Double.valueOf(rs.getString("OVERDUE_FACTORY_MON_CNT")).doubleValue(), ARightL));
						ws.addCell(new jxl.write.Label(col+(j*4)+1, row+1, rs.getString("OVERDUE_FACTORY_MON_RATE") , ARightL));
						ws.addCell(new jxl.write.Number(col+(j*4)+2, row, Double.valueOf(rs.getString("ONTIME_FACTORY_MON_CNT")).doubleValue(), ARightL));
						ws.addCell(new jxl.write.Label(col+(j*4)+2, row+1, rs.getString("ONTIME_FACTORY_MON_RATE")  , ARightL));
						ws.addCell(new jxl.write.Number(col+(j*4)+3, row, Double.valueOf(rs.getString("SHIPPED_FACTORY_MON_CNT")).doubleValue(), ARightL));
						ws.addCell(new jxl.write.Label(col+(j*4)+3, row+1, "100%", ARightL));
						break;
					}
				}	
				
				if (rs.getInt("FACTORY_SEQ")==rs.getInt("FACTORY_CNT"))
				{
					ws.addCell(new jxl.write.Number(col+((months_list.length-1)*4), row, Double.valueOf(rs.getString("SALES_HOLD_FACTORY_CNT")).doubleValue(), ARightL));
					ws.addCell(new jxl.write.Label(col+((months_list.length-1)*4), row+1, rs.getString("SALES_HOLD_FACTORY_RATE"), ARightL));
					ws.addCell(new jxl.write.Number(col+((months_list.length-1)*4)+1, row, Double.valueOf(rs.getString("OVERDUE_FACTORY_CNT")).doubleValue(), ARightL));
					ws.addCell(new jxl.write.Label(col+((months_list.length-1)*4)+1, row+1, rs.getString("OVERDUE_FACTORY_RATE") , ARightL));
					ws.addCell(new jxl.write.Number(col+((months_list.length-1)*4)+2, row, Double.valueOf(rs.getString("ONTIME_FACTORY_CNT")).doubleValue(), ARightL));
					ws.addCell(new jxl.write.Label(col+((months_list.length-1)*4)+2, row+1, rs.getString("ONTIME_FACTORY_RATE")  , ARightL));
					ws.addCell(new jxl.write.Number(col+((months_list.length-1)*4)+3, row, Double.valueOf(rs.getString("SHIPPED_FACTORY_CNT")).doubleValue(), ARightL));
					ws.addCell(new jxl.write.Label(col+((months_list.length-1)*4)+3, row+1, "100%", ARightL));
				}											
				reccnt++;					
			}
			else
			{
				if (rs.getInt("SHIPPED_MON_SEQ")==1)
				{
					reccnt=0;col=0;row=0;
					wwb.createSheet(rs.getString("SHIPPED_MM"), sheetcnt);
					ws = wwb.getSheet(rs.getString("SHIPPED_MM"));
					SheetSettings sst = ws.getSettings(); 
					sst.setSelected();	
					sst.setVerticalFreeze(1);
					sheetcnt++;
					
					ws.addCell(new jxl.write.Label(col, row, "Sales Region" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;					
		
					ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
					ws.setColumnView(col,25);	
					col++;					
			
					ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;					
						
					ws.addCell(new jxl.write.Label(col, row, "Line#" , ACenterBL));
					ws.setColumnView(col,8);	
					col++;	
								
					ws.addCell(new jxl.write.Label(col, row, "Item Name(22D/30D)" , ACenterBL));
					ws.setColumnView(col,30);	
					col++;	
			
					ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBL));
					ws.setColumnView(col,20);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "SSD" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "Act Shipment Date" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "Factory" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "Overdue Flag" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "Sales Hold Flag" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
					row++;
				}
				col=0;
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_REGION"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_NUMBER"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SEGMENT1"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("REQUEST_DATE")) ,DATE_FORMAT));
				col++;	
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
				col++;	
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ACTUAL_SHIPMENT_DATE")) ,DATE_FORMAT));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("FACTORY"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_FAMILY"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("OVERDUE_FLAG"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_HOLD_FLAG"),ALeftL));
				col++;	
				row++;				
			}	
		}
		rs.close();
		statement.close();	
	}		
	
	wwb.write(); 
	wwb.close();
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
	if (sheetcnt>0)
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
