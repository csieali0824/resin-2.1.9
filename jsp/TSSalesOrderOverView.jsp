<!-- 20160725 Peggy,function:tsce_get_eta_date replace TSC_OM_COUNT_DDATE-->
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
<FORM ACTION="../jsp/TSSalesOrderOverView.jsp" METHOD="post" name="MYFORM">
<%
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String CUSTOMER_ID = request.getParameter("CUSTOMER_ID");
if (CUSTOMER_ID==null) CUSTOMER_ID="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="20150101";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE=dateBean.getYearMonthDay();
String FileName="",RPTName="",PLANTNAME="",sql="",sql1="",sql2="",ERP_USERID="",remarks="";
int fontsize=8,colcnt=0,sheetcnt=0;
String TOT_CNT="",TOT_OVER_DUE_CNT="",TOT_OVER_DUE_RATE="",TOT_ON_TIME_CNT="",TOT_ON_TIME_RATE="";
int TOT_PO_CNT =0,TOT_ORDER_OVER_LEAD_TIME_PO_CNT=0,OVER_LEAD_TIME_PO_CNT=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "Logistic Performance Report";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//WritableSheet ws = wwb.createSheet(RPTName, 0); 
	wwb.createSheet("Row Data", 0);
	wwb.createSheet("Analysis_On Time %", 1);
	wwb.createSheet("PO Over Count", 2);
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
	
	sql = "SELECT erp_user_id from oraddman.wsuser a where USERNAME ='"+UserName+"'";
	Statement st3=con.createStatement();
	ResultSet rs3=st3.executeQuery(sql);
	if (rs3.next())
	{
		ERP_USERID=rs3.getString(1);
	}
	rs3.close();
	st3.close();
	
	String sqlx="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sqlx);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
	
	//out.println(sheetname[i]);
	sql = " SELECT A.HEADER_ID"+
	      ",A.LINE_ID"+
		  ",A.ORDER_NUMBER"+
		  ",A.LINE_NUMBER||'.'||A.SHIPMENT_NUMBER LINE_NO"+
		  ",A.ORDERED_ITEM"+
		  ",C.DESCRIPTION"+
		  ",D.CUSTOMER_NUMBER"+
		  ",NVL(D.CUSTOMER_NAME_PHONETIC,D.CUSTOMER_NAME) CUSTOMER"+
		  ",A.CUSTOMER_LINE_NUMBER CUSTOM_PO_NUMBER"+
          ",A.CUSTOMER_SHIPMENT_NUMBER CUSTOMER_PO_LINE_NUMBER"+
		  ",to_char(A.ORDERED_DATE,'yyyy/mm/dd') ORDERED_DATE"+
          ",MIN(A.ORDERED_DATE) OVER (PARTITION BY A.SOLD_TO_ORG_ID,NVL(A.CUSTOMER_LINE_NUMBER,A.CUST_PO_NUMBER)) MIN_ORDERED_DATE"+
		  ",to_char(A.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') SCHEDULE_SHIP_DATE"+
		  ",to_char(A.REQUEST_DATE,'yyyy/mm/dd') REQUEST_DATE"+
          ",N.meaning SHIPPING_METHOD_CODE"+
          ",A.TRANSACTIONAL_CURR_CODE"+
          ",A.ORDERED_QUANTITY"+
          ",DECODE(A.ORDER_QUANTITY_UOM,'KPC',A.UNIT_SELLING_PRICE / 1000,A.UNIT_SELLING_PRICE) UNIT_SELLING_PRICE"+
          ",DECODE(A.ORDER_QUANTITY_UOM,'KPC','PCE',A.ORDER_QUANTITY_UOM) ORDER_QUANTITY_UOM "+
          ",DECODE(A.ORDER_QUANTITY_UOM,'KPC',(A.ORDERED_QUANTITY * A.UNIT_SELLING_PRICE) / 1000,A.ORDERED_QUANTITY * A.UNIT_SELLING_PRICE) AMOUNT"+
          ",E.DELIVERY_NAME"+
          ",to_char(A.ACTUAL_SHIPMENT_DATE,'yyyy/mm/dd') ACTUAL_SHIPMENT_DATE"+
          ",TSC_OM_CATEGORY(C.INVENTORY_ITEM_ID,C.ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP"+
          ",TSC_OM_CATEGORY(C.INVENTORY_ITEM_ID,C.ORGANIZATION_ID,'TSC_Family') TSC_Family"+
          ",TSC_OM_CATEGORY(C.INVENTORY_ITEM_ID,C.ORGANIZATION_ID,'TSC_Package') TSC_Package "+
          ",A.VERSION_NUMBER"+
          ",A.PACKING_INSTRUCTIONS "+
          ",F.ORGANIZATION_CODE"+
          ",A.ATTRIBUTE20 HOLD"+
          ",A.ATTRIBUTE5 HOLD_REASON"+
          ",A.ATTRIBUTE18 QUOTE_NUMBER"+
          ",I.LEAD_TIME AS \"Standard Lead Time (week)\""+
          ",CASE WHEN TRUNC(A.ACTUAL_SHIPMENT_DATE)- TRUNC(A.SCHEDULE_SHIP_DATE)>=4 THEN 'Y' ELSE 'N' END AS \"Over due(Y/N)\""+
          ",G.DNDOCNO"+
          ",CASE WHEN G.PC_OVER_LEADTIME_REASON IS NULL THEN 'N' ELSE 'Y' END AS \"Over Lead Time(Y/N)\""+
          ",NVL(H.DATA_VALUE_ENG,G.PC_OVER_LEADTIME_REASON) OVER_LEADTIME_REASON "+
          ",A.INVENTORY_ITEM_ID"+
          ",to_char(J.DELIVERY_DATE,'yyyy/mm/dd') DELIVERY_DATE"+
          ",to_char(J.INVOICE_DATE,'yyyy/mm/dd') INVOICE_DATE"+
          ",K.TERRITORY_SHORT_NAME COUNTRY"+
          ",A.FLOW_STATUS_CODE"+
          ",M.pi_seqno OCNO"+
          ",tsc_get_airsurcharge (A.line_id,A.ordered_quantity) FREIGHT_CHARGE"+
          //",to_char(TSC_OM_COUNT_DDATE (A.FOB_POINT_CODE,A.SHIPPING_METHOD_CODE,A.PACKING_INSTRUCTIONS,A.ORDER_NUMBER,A.SCHEDULE_SHIP_DATE),'yyyy/mm/dd') ETA"+
		  ",to_char(tsce_get_eta_date (A.SHIPPING_METHOD_CODE,A.FOB_POINT_CODE,A.ORDER_NUMBER,A.PACKING_INSTRUCTIONS,A.SCHEDULE_SHIP_DATE,A.SOLD_TO_ORG_ID),'yyyy/mm/dd') ETA"+  //modify by Peggy 20160725
		  ",J.DELIVERY_DATE-A.REQUEST_DATE DIFF_DAYS"+
		  ",CASE WHEN (TRUNC(J.DELIVERY_DATE)-TRUNC(A.REQUEST_DATE))/7 > I.LEAD_TIME THEN 'Y' ELSE 'N' END AS DIFF_DAYS_OVER_LEAD_TIME"+ 
		  ",CASE WHEN (TRUNC(A.REQUEST_DATE)-TRUNC(A.ORDERED_DATE))/7 < I.LEAD_TIME THEN 'Y' ELSE 'N' END AS ORDER_OVER_LEAD_TIME"+ 
    	  ",CASE a.packing_instructions WHEN 'I' THEN  CASE tsc_om_category (a.inventory_item_id, a.ship_from_org_id, 'TSC_PROD_GROUP') WHEN 'PMD' THEN '006' WHEN 'SSD' THEN '005' END WHEN 'Y' THEN '002' WHEN 'A' THEN '010' WHEN 'E' THEN '008' END AS PLANT_CODE"+
          ",ROW_NUMBER() OVER (PARTITION BY A.HEADER_ID,A.LINE_ID ORDER BY A.LINE_ID) ORDER_SEQ"+
          " FROM (SELECT A.VERSION_NUMBER,A.ORDER_NUMBER,A.TRANSACTIONAL_CURR_CODE,A.ATTRIBUTE10 HEADER_ATTRIBUTE10,A.ORDERED_DATE,A.ORDER_TYPE_ID,B.*  FROM ONT.OE_ORDER_HEADERS_ALL A,ONT.OE_ORDER_LINES_ALL B WHERE A.HEADER_ID=B.HEADER_ID AND B.FLOW_STATUS_CODE NOT IN ('CANCELLED')) A"+
          " ,INV.MTL_SYSTEM_ITEMS_B C"+
          " ,AR_CUSTOMERS D"+
          " ,(SELECT DISTINCT X.DELIVERY_ID,X.NAME DELIVERY_NAME,Z.SOURCE_HEADER_ID,Z.SOURCE_LINE_ID FROM WSH.WSH_NEW_DELIVERIES X,WSH.WSH_DELIVERY_ASSIGNMENTS Y,WSH.WSH_DELIVERY_DETAILS Z WHERE X.DELIVERY_ID=Y.delivery_id AND Y.DELIVERY_DETAIL_ID=Z.DELIVERY_DETAIL_ID ) E"+
          " ,MTL_PARAMETERS F"+
          " ,ORADDMAN.TSDELIVERY_NOTICE_DETAIL G"+
          " ,(SELECT * FROM ORADDMAN.TSPROD_MANUFACTORY_SETUP WHERE DATA_TYPE='OVER_LEAD_TIME_REASON') H"+
          " ,(SELECT X.* FROM (SELECT X.*,ROW_NUMBER() OVER (PARTITION BY  X.MANUFACTORY_NO,X.TSC_PROD_GROUP, X.INVENTORY_ITEM_ID ORDER BY X.PRIORITY_SEQ,X.LAST_UPDATE_DATE DESC) ROW_RANK"+
          "  FROM (select '2' AS PRIORITY_SEQ ,A.MANUFACTORY_NO,A.TSC_PROD_GROUP, B.INVENTORY_ITEM_ID,A.LEAD_TIME ,A.LAST_UPDATE_DATE"+
          "  from oraddman.tsprod_manufactory_leadtime a,(SELECT * FROM inv.mtl_system_items_b WHERE ORGANIZATION_ID=49) b "+
          "  where a.TSC_DESC is null "+
          "  and a.TSC_PROD_GROUP=TSC_OM_CATEGORY(b.INVENTORY_ITEM_ID,b.ORGANIZATION_ID,'TSC_PROD_GROUP') "+
          " and a.TSC_FAMILY=TSC_OM_CATEGORY(b.INVENTORY_ITEM_ID,b.ORGANIZATION_ID,'TSC_Family') "+
          " and NVL(a.TSC_PROD_FAMILY,'XX')=case when  tsc_om_category (b.inventory_item_id,b.organization_id,'TSC_PROD_GROUP') NOT IN ('SSD','PMD') THEN NVL (a.tsc_prod_family, 'XX') ELSE NVL ( tsc_om_category (b.inventory_item_id,b.organization_id,'TSC_PROD_FAMILY'),'XX') END "+
          " AND a.TSC_PACKAGE=TSC_OM_CATEGORY(b.INVENTORY_ITEM_ID,b.ORGANIZATION_ID,'TSC_Package') "+
          " UNION ALL"+
          " select '1' AS PRIORITY_SEQ , A.MANUFACTORY_NO,A.TSC_PROD_GROUP, B.INVENTORY_ITEM_ID,A.LEAD_TIME ,A.LAST_UPDATE_DATE"+
          " from oraddman.tsprod_manufactory_leadtime a,(SELECT * FROM inv.mtl_system_items_b WHERE ORGANIZATION_ID=49) b "+
          " where a.TSC_DESC is not null "+
          " AND a.TSC_DESC=b.DESCRIPTION) X) X WHERE ROW_RANK=1 ) I"+
          " ,(SELECT x.ORDER_LINE_ID,MAX(Y.DELIVERY_DATE) DELIVERY_DATE,MAX(Y.PICKUP_DATE) INVOICE_DATE FROM TSC_INVOICE_LINES X,TSC_INVOICE_HEADERS Y WHERE X.INVOICE_NO(+)=Y.INVOICE_NO GROUP BY x.ORDER_LINE_ID) J"+
          " ,(SELECT X.* FROM (SELECT X.*,ROW_NUMBER() OVER (PARTITION BY SITE_USE_ID ORDER BY PRIORITY) ROW_SEQ FROM (SELECT '1' PRIORITY, hcsu.site_use_id, tv.territory_short_name"+
          " FROM hz_cust_site_uses_all hcsu, ra_territories ra, fnd_territories_tl tv"+
          " WHERE hcsu.territory_id = ra.territory_id (+) "+
          " AND ra.segment2 = tv.territory_code(+)"+
          " AND hcsu.site_use_code = 'BILL_TO'"+
          " AND tv.language = 'US'"+
          " UNION ALL"+
          " SELECT '2' PRIORITY, hcsu.site_use_id, tv.territory_short_name"+
          " FROM hz_cust_site_uses_all hcsu,"+
          " hz_cust_acct_sites_all hcas,"+
          " hz_party_sites hps,"+
          " hz_locations hl,"+
          " fnd_territories_tl tv"+
          " WHERE  hcsu.cust_acct_site_id = hcas.cust_acct_site_id"+
          " AND hcas.party_site_id = hps.party_site_id"+
          " AND hps.location_id = hl.location_id"+
          " AND hcsu.site_use_code = 'BILL_TO'"+
          " AND hl.country = tv.territory_code(+)"+
          " AND tv.language = 'US') X) X WHERE X.ROW_SEQ=1 ) K"+
          " ,(SELECT DISTINCT CUSTOMER_ID,cust_po_number,pi_seqno FROM daphne_pi_temp) M"+
          " ,(SELECT * FROM FND_LOOKUP_VALUES_VL WHERE lookup_type (+)='SHIP_METHOD' ) N"+
          " WHERE A.SOLD_TO_ORG_ID="+ CUSTOMER_ID+" "+
          " AND A.ORDER_TYPE_ID IN (1015,1021,1022,1020,1091,1154,1175,1063,1322,1114,1342)"+
          " AND A.ORDERED_DATE BETWEEN TO_DATE('"+SDATE+"','yyyymmdd')  AND TO_DATE('"+EDATE+"','yyyymmdd') "+
          " AND A.INVENTORY_ITEM_ID=C.INVENTORY_ITEM_ID "+
          " AND A.SHIP_FROM_ORG_ID=C.ORGANIZATION_ID"+
          " AND A.SOLD_TO_ORG_ID=D.CUSTOMER_ID "+
          " AND C.ORGANIZATION_ID=F.ORGANIZATION_ID"+
          " AND A.LINE_ID=E.SOURCE_LINE_ID(+)"+
          " AND A.HEADER_ATTRIBUTE10=G.DNDOCNO(+)"+
          " AND A.INVENTORY_ITEM_ID=G.INVENTORY_ITEM_ID(+) "+
          " AND TO_CHAR(A.ORDER_NUMBER)=G.ORDERNO(+)"+
          " AND G.PC_OVER_LEADTIME_REASON=DATE_VALUE(+)"+
          " AND A.INVENTORY_ITEM_ID=I.INVENTORY_ITEM_ID(+)"+
          " AND A.LINE_ID=J.ORDER_LINE_ID(+)"+
          " AND A.INVOICE_TO_ORG_ID=K.SITE_USE_ID(+)"+
          " AND A.SHIPPING_METHOD_CODE=N.LOOKUP_CODE(+)"+
          " AND A.SOLD_TO_ORG_ID=M.CUSTOMER_ID(+)"+
          " AND NVL(A.CUSTOMER_LINE_NUMBER,A.CUST_PO_NUMBER)=M.cust_po_number(+)"+
		  " AND A.ATTRIBUTE20 IS NULL"+ //先排除,待有介面給使用者操作時,再加入條件控制HOLD資料是否要顯示
          " AND CASE  A.PACKING_INSTRUCTIONS WHEN 'I' THEN  CASE TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.SHIP_FROM_ORG_ID,'TSC_PROD_GROUP') WHEN 'PMD' THEN '006' WHEN 'SSD' THEN '005' END WHEN 'Y' THEN '002' WHEN 'A' THEN '010' WHEN 'E' THEN '008' END =I.MANUFACTORY_NO(+)";
	if (!salesGroup.equals("--") && !salesGroup.equals(""))
	{
		//sql += " and  Tsc_Intercompany_Pkg.get_sales_group(A.header_id)='"+salesGroup+"'";
		sql += " and  TSC_OM_Get_Sales_Group(A.header_id)='"+salesGroup+"'";
	}
	else if (UserRoles.indexOf("admin")<0)
	{
		sql += " and exists (select 1 from (SELECT tog.group_name "+
				 " FROM tsc_om_group_salesrep togs,"+
				 " ahr_employees_all aea,"+
				 " jtf_rs_salesreps jrs,"+
				 " fnd_user us,"+
				 " tsc_om_group tog,"+
				 " oraddman.wsuser ow"+
				 " WHERE  (aea.employee_no = jrs.salesrep_number or us.user_name =jrs.salesrep_number)"+ //for forecase demain issue by Peggy 20230407
				 " AND us.employee_id = aea.person_id"+
				 " AND togs.salesrep_id = jrs.salesrep_id"+
				 " AND togs.GROUP_ID = tog.GROUP_ID"+
				 " AND (tog.end_date IS NULL OR tog.end_date > TRUNC (SYSDATE))"+
				 " AND us.user_id=ow.ERP_USER_ID"+
				 " AND ow.username='"+UserName+"'"+
				 " UNION ALL"+
				 " SELECT tog.group_name"+
				 " FROM tsc_om_group_salesrep togs,"+
				 " fnd_user us, "+
				 " tsc_om_group tog,"+
				 " oraddman.wsuser ow"+
				 " WHERE  togs.user_id = us.user_id"+
				 " AND togs.GROUP_ID = tog.GROUP_ID"+
				 " AND (tog.end_date IS NULL OR tog.end_date > TRUNC (SYSDATE))"+
				 " AND us.user_id=ow.ERP_USER_ID"+
				 " AND ow.username='"+UserName+"'"+
				 " UNION ALL"+
				 " SELECT 'SAMPLE' group_name "+
				 " FROM oraddman.tssales_area A,oraddman.tsrecperson B,oraddman.wsuser C"+
				 " WHERE A.sales_area_no='020'"+
				 " AND A.sales_area_no=B.tssaleareano "+
				 " AND B.username=C.username "+
				 " AND NVL(C.lockflag,'Y')='N'"+
				 //" AND c.username='"+UserName+"') x where x.group_name=Tsc_Intercompany_Pkg.get_sales_group(A.header_id))"+
				 " AND c.username='"+UserName+"') x where x.group_name=TSC_OM_Get_Sales_Group(A.header_id))"+
				 " ORDER BY A.ORDER_NUMBER,TO_NUMBER(A.LINE_NUMBER||'.'||A.SHIPMENT_NUMBER)";
	}
	//out.println(sql);
	String sheetname [] = wwb.getSheetNames();
	for (int i =0 ; i < sheetname.length ; i++)
	{	
		reccnt=0;col=0;row=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings sst = ws.getSettings(); 
		sst.setSelected();
		if (i==0)
		{
			Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); 
			ResultSet rs=statement.executeQuery(sql);
		
			sst.setVerticalFreeze(1);  //凍結窗格
			//for (int g =1 ; g <=8 ;g++ )
			//{
			//	sst.setHorizontalFreeze(g);
			//}	
			//M/O
			ws.addCell(new jxl.write.Label(col, row, " M/O" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;					
	
			//Part Number
			ws.addCell(new jxl.write.Label(col, row, "Part Number" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;					
				
			//Cust Part No
			ws.addCell(new jxl.write.Label(col, row, "Cust Part No" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
						
			// Customer
			ws.addCell(new jxl.write.Label(col, row, " Customer" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
	
			//P/O No.
			ws.addCell(new jxl.write.Label(col, row, "P/O No." , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
	
			//ORDATE
			ws.addCell(new jxl.write.Label(col, row, "ORDATE" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//SSD
			ws.addCell(new jxl.write.Label(col, row, "SSD" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//CRD
			ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//Shipping Method
			ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
			
			//Currency
			ws.addCell(new jxl.write.Label(col, row, "Currency" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;
			
			//Order Qty
			ws.addCell(new jxl.write.Label(col, row, "Order Qty" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;
						
			//Selling Price
			ws.addCell(new jxl.write.Label(col, row, "Selling Price" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;				
			
			//Amt
			ws.addCell(new jxl.write.Label(col, row, "Amt" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//Delivery Name
			ws.addCell(new jxl.write.Label(col, row, "Delivery Name" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
						
			//Act Ship Date
			ws.addCell(new jxl.write.Label(col, row, "Act Ship Date" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;
			
			//Invoice Date 
			ws.addCell(new jxl.write.Label(col, row, "Invoice Date" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;
	
			//TSC_Family
			ws.addCell(new jxl.write.Label(col, row, "TSC_Family" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;
					
			//TSC_Package
			ws.addCell(new jxl.write.Label(col, row, "TSC_Package" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;
			
			//Version
			ws.addCell(new jxl.write.Label(col, row, "Version" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;
	
			//Factory
			ws.addCell(new jxl.write.Label(col, row, "Factory" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;
	
			//Warehouse
			ws.addCell(new jxl.write.Label(col, row, "Warehouse" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;							
				
			//Freight Charge
			ws.addCell(new jxl.write.Label(col, row, "Freight Charge" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;
				
			//OC No
			ws.addCell(new jxl.write.Label(col, row, "OC No" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			// LINE#
			ws.addCell(new jxl.write.Label(col, row, "LINE#" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;	
				
			//CUSTOMER NUMBER 
			ws.addCell(new jxl.write.Label(col, row, "CUSTOMER NUMBER " , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
			
			//Hold
			ws.addCell(new jxl.write.Label(col, row, "Hold" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
				
			//Hold Reason  
			ws.addCell(new jxl.write.Label(col, row, "Hold Reason" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
			
			//ETA     
			ws.addCell(new jxl.write.Label(col, row, "ETA" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
			
			//Delivery Date
			ws.addCell(new jxl.write.Label(col, row, "Delivery Date" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
			
			//TSC PROD GROUP  
			ws.addCell(new jxl.write.Label(col, row, "TSC PROD GROUP" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;
			
			//COUNTRY
			ws.addCell(new jxl.write.Label(col, row, "COUNTRY" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
			
			//Customer PO Line Number 
			ws.addCell(new jxl.write.Label(col, row, "Customer PO Line Number" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//Quote Number 
			ws.addCell(new jxl.write.Label(col, row, "Quote Number" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//Standard Lead Time (week)
			ws.addCell(new jxl.write.Label(col, row, "Standard Lead Time (week)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
				
			//Over due(Y/N)
			ws.addCell(new jxl.write.Label(col, row, "Over due(Y/N)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//Additional Days: Delivery Date - CRD
			ws.addCell(new jxl.write.Label(col, row, "Additional Days: Delivery Date - CRD" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//Additional Days (Delivery Date - CRD): OVER LEAD TIME: (Y/N)
			ws.addCell(new jxl.write.Label(col, row, "Additional Days (Delivery Date - CRD): OVER LEAD TIME: (Y/N)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			
			//OVER LEAD TIME(Y/N)
			ws.addCell(new jxl.write.Label(col, row, "OVER LEAD TIME(Y/N)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
				
			//Reason for over Lead Time
			ws.addCell(new jxl.write.Label(col, row, "Reason for over Lead Time" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;															

			//(CRD-Order Date) < Standard L/T: (Y/N)
			ws.addCell(new jxl.write.Label(col, row, "(CRD-Order Date) < Standard L/T: (Y/N)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;															
			row++;
			
			if (rs.isBeforeFirst() ==false) rs.beforeFirst();
			while (rs.next()) 
			{ 	
				col=0;
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_NUMBER"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION"),  ALeftL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDERED_ITEM") , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER") , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOM_PO_NUMBER") , ALeftL));
				col++;	
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ORDERED_DATE")) ,DATE_FORMAT));
				col++;	
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
				col++;	
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("REQUEST_DATE")) ,DATE_FORMAT));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_METHOD_CODE") , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TRANSACTIONAL_CURR_CODE") , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ORDERED_QUANTITY")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("UNIT_SELLING_PRICE")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("AMOUNT")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("DELIVERY_NAME")==null?"": rs.getString("DELIVERY_NAME")), ALeftL));
				col++;	
				if (rs.getString("ACTUAL_SHIPMENT_DATE")==null)
				{		
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ACTUAL_SHIPMENT_DATE")) ,DATE_FORMAT));
				}
				col++;	
				if (rs.getString("INVOICE_DATE")==null)
				{		
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("INVOICE_DATE")) ,DATE_FORMAT));
				}
				col++;			
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_FAMILY")  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE")  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, rs.getString("VERSION_NUMBER")  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKING_INSTRUCTIONS")  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ORGANIZATION_CODE")  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("FREIGHT_CHARGE")==null?"":rs.getString("FREIGHT_CHARGE"))  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("OCNO")==null?"":rs.getString("OCNO"))  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO")  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NUMBER")  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("HOLD")==null?"":rs.getString("HOLD"))  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("HOLD_REASON")==null?"":rs.getString("HOLD_REASON")) , ALeftL));
				col++;	
				if (rs.getString("ETA")==null)
				{		
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ETA")) ,DATE_FORMAT));
				}
				col++;						
				if (rs.getString("DELIVERY_DATE")==null)
				{		
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("DELIVERY_DATE")) ,DATE_FORMAT));
				}
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP")  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, rs.getString("COUNTRY")  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUSTOMER_PO_LINE_NUMBER")==null?"":rs.getString("CUSTOMER_PO_LINE_NUMBER"))  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("QUOTE_NUMBER")==null?"":rs.getString("QUOTE_NUMBER"))  , ALeftL));
				col++;		
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("Standard Lead Time (week)")==null?"":rs.getString("Standard Lead Time (week)"))  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("Over due(Y/N)")==null?"":rs.getString("Over due(Y/N)"))  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("DIFF_DAYS")==null?"":rs.getString("DIFF_DAYS"))  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("DIFF_DAYS_OVER_LEAD_TIME")==null?"":rs.getString("DIFF_DAYS_OVER_LEAD_TIME"))  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("Over Lead Time(Y/N)")==null?"":rs.getString("Over Lead Time(Y/N)"))  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("OVER_LEADTIME_REASON")==null?"":rs.getString("OVER_LEADTIME_REASON"))  , ALeftL));
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("ORDER_OVER_LEAD_TIME")==null?"":rs.getString("ORDER_OVER_LEAD_TIME"))  , ALeftL));
				col++;				
				row++;				
				reccnt ++;
			}
			rs.close();
			statement.close();				
		}
		else if (i==1)
		{
			ws.mergeCells(col, row, col+5, row);     
			ws.addCell(new jxl.write.Label(col, row, SDATE.substring(0,4)+"/"+SDATE.substring(4,6)+"~"+EDATE.substring(0,4)+"/"+EDATE.substring(4,6), ACenterL));
			row++;
			col=0;
		
			ws.addCell(new jxl.write.Label(col, row, "Factory" , ACenterBL));
			ws.setColumnView(col,16);	
			col++;					
	
			ws.addCell(new jxl.write.Label(col, row, "Line Count" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;					
				
			ws.addCell(new jxl.write.Label(col, row, "Overdue" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
						
			ws.addCell(new jxl.write.Label(col, row, "Overdue %" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "On Time" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "On Time %" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			row++;
								
		
			sql1 = " SELECT X.PLANT_CODE,Y.ALENGNAME"+
			      ",COUNT(1) TOTAL_ORDER_CNT"+
				  ",SUM(CASE WHEN \"Over due(Y/N)\" ='Y' THEN 1 ELSE 0 END) AS OVER_DUE_CNT"+
				  ",ROUND(SUM(CASE WHEN \"Over due(Y/N)\" ='Y' THEN 1 ELSE 0 END)/COUNT(1),4)*100 AS OVER_DUE_RATE"+
				  ",SUM(CASE WHEN \"Over due(Y/N)\" ='Y' THEN 0 ELSE 1 END) AS ON_TIME_CNT"+
				  ",(1-(ROUND(SUM(CASE WHEN \"Over due(Y/N)\" ='Y' THEN 1 ELSE 0 END)/COUNT(1),4)))*100 AS ON_TIME_RATE"+
                  ",SUM(COUNT(1)) OVER (ORDER BY X.PLANT_CODE) AS TOTAL_CNT"+
                  ",SUM(SUM(CASE WHEN \"Over due(Y/N)\" ='Y' THEN 1 ELSE 0 END)) OVER (ORDER BY X.PLANT_CODE) AS TOTAL_OVER_DUE_CNT"+
                  ",SUM(SUM(CASE WHEN \"Over due(Y/N)\" ='Y' THEN 0 ELSE 1 END)) OVER (ORDER BY X.PLANT_CODE) AS TOTAL_ON_TIME_CNT"+
                  ",ROUND(SUM(SUM(CASE WHEN \"Over due(Y/N)\" ='Y' THEN 1 ELSE 0 END)) OVER (ORDER BY X.PLANT_CODE)/SUM(COUNT(1)) OVER (ORDER BY X.PLANT_CODE),4)*100 AS TOTAL_OVER_DUE_RATE"+
                  ",(1-(ROUND(SUM(SUM(CASE WHEN \"Over due(Y/N)\" ='Y' THEN 1 ELSE 0 END)) OVER (ORDER BY X.PLANT_CODE) /SUM(COUNT(1)) OVER (ORDER BY X.PLANT_CODE),4)))*100 AS TOTAL_ON_TIME_RATE"+
                  " FROM ("+sql+") X ,oraddman.tsprod_manufactory Y "+
				  " WHERE X.PLANT_CODE=Y.MANUFACTORY_NO"+
                  " GROUP BY X.PLANT_CODE,Y.ALENGNAME"+
				  " ORDER BY X.PLANT_CODE";  
			//out.println(sql);
			Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); 
			ResultSet rs=statement.executeQuery(sql1);	 
			if (rs.isBeforeFirst() ==false) rs.beforeFirst();
			while (rs.next()) 
			{ 	
				col=0;
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ALENGNAME").replace("外購"," Outsourcing"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOTAL_ORDER_CNT")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("OVER_DUE_CNT")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row,rs.getString("OVER_DUE_RATE")+"%", ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ON_TIME_CNT")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ON_TIME_RATE")+"%", ARightL));
				col++;	
				row++;
				TOT_CNT=rs.getString("TOTAL_CNT");
				TOT_OVER_DUE_CNT=rs.getString("TOTAL_OVER_DUE_CNT");
				TOT_OVER_DUE_RATE=rs.getString("TOTAL_OVER_DUE_RATE");
				TOT_ON_TIME_CNT=rs.getString("TOTAL_ON_TIME_CNT");
				TOT_ON_TIME_RATE=rs.getString("TOTAL_ON_TIME_RATE");			
				reccnt ++;
			}
			rs.close();
			statement.close();	
		}
		else
		{
			ws.mergeCells(col, row, col+3, row);     
			ws.addCell(new jxl.write.Label(col, row, "Date:"+SDATE.substring(0,4)+"/"+SDATE.substring(4,6)+"~"+EDATE.substring(0,4)+"/"+EDATE.substring(4,6), ALeftL));
			row++;
			col=0;

			ws.addCell(new jxl.write.Label(col, row, "" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;					
		
			ws.addCell(new jxl.write.Label(col, row, "Number of PO's" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;					
	
			ws.addCell(new jxl.write.Label(col, row, "Number of PO's where (CRD-ORDATE) < Standard LT" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;					
				
			ws.addCell(new jxl.write.Label(col, row, "Number of PO's where OVER LEAD " , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
			row++;
								
		
			sql2 = " SELECT TO_CHAR(Y.ORDERED_DATE,'YYYY-MM') ORDERED_DATE"+
			      ",TO_CHAR(Y.ORDERED_DATE,'YYYY-MON') ORDERED_DATE_ENG"+
                  ",COUNT(DISTINCT Y.CUSTOM_PO_NUMBER) PO_CNT"+
                  ",SUM(ORDER_OVER_LEAD_TIME_PO) ORDER_OVER_LEAD_TIME_PO_CNT"+
                  ",SUM(OVER_LEAD_TIME_PO) OVER_LEAD_TIME_PO_CNT"+
                  " FROM (SELECT DISTINCT  TRUNC(X.MIN_ORDERED_DATE) ORDERED_DATE "+
                  "      ,X.CUSTOM_PO_NUMBER"+
                  "      ,CASE WHEN X.ORDER_OVER_LEAD_TIME='Y' THEN 1 ELSE 0 END ORDER_OVER_LEAD_TIME_PO"+
                  "      ,CASE WHEN X.\"Over Lead Time(Y/N)\"='Y' THEN 1 ELSE 0 END OVER_LEAD_TIME_PO"+
                  "      FROM ("+sql+") X) Y"+
                  " GROUP BY  TO_CHAR(Y.ORDERED_DATE,'YYYY-MM'),TO_CHAR(Y.ORDERED_DATE,'YYYY-MON')"+
                  " ORDER BY TO_CHAR(Y.ORDERED_DATE,'YYYY-MM')";
			//out.println(sql);
			Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); 
			ResultSet rs=statement.executeQuery(sql2);	 
			if (rs.isBeforeFirst() ==false) rs.beforeFirst();
			while (rs.next()) 
			{ 	
				col=0;
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDERED_DATE_ENG"),ALeftL));
				col++;					
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PO_CNT")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ORDER_OVER_LEAD_TIME_PO_CNT")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("OVER_LEAD_TIME_PO_CNT")).doubleValue(), ARightL));
				col++;	
				row++;
				TOT_PO_CNT += rs.getInt("PO_CNT");
				TOT_ORDER_OVER_LEAD_TIME_PO_CNT+=rs.getInt("ORDER_OVER_LEAD_TIME_PO_CNT");
				OVER_LEAD_TIME_PO_CNT+=rs.getInt("OVER_LEAD_TIME_PO_CNT");
				reccnt ++;
			}
			rs.close();
			statement.close();				
								
		}
		if (reccnt>0)
		{
			if (i==1)
			{
				col=0;
				ws.addCell(new jxl.write.Label(col, row, "TOTAL",ALeftL));
				col++;					
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(TOT_CNT).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(TOT_OVER_DUE_CNT).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, TOT_OVER_DUE_RATE+"%", ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(TOT_ON_TIME_CNT).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, TOT_ON_TIME_RATE+"%", ARightL));
				col++;	
				row++;
			}
			else if (i==2)
			{
				col=0;
				ws.addCell(new jxl.write.Label(col, row, "TOTAL",ALeftL));
				col++;					
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(""+TOT_PO_CNT).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(""+TOT_ORDER_OVER_LEAD_TIME_PO_CNT).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(""+OVER_LEAD_TIME_PO_CNT).doubleValue(), ARightL));
				col++;	
				row++;
			}
			sheetcnt++;
		}
	}	
	
	wwb.write(); 
	wwb.close();

	/*
	if (sheetcnt >0)
	{
		if (!ACTTYPE.equals(""))
		{
			Properties props = System.getProperties();
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", "mail.ts.com.tw");
			props.put("mail.smtp.port", "25");
			
			Session s = Session.getInstance(props, null);
			javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
			message.setSentDate(new java.util.Date());
			message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0) //測試環境
			{
				remarks="(這是來自RFQ測試區的信件)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			}
			else if (ACTTYPE.equals("TSCC") && RPTTYPE.equals("INSIDE"))
			{
				remarks="";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("june@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("joyce@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("xiongyu@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("laura@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nancy@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCCSH-CS@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Jason@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Anna_Qiu@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("william_wu@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("shelly@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tingting@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("chris_wen@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sky_shi@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("gordon@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("alex@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Charlotte@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lisahou@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ccyang@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ccyang@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bin@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kevin@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("merry@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("charlotte@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("RITA_zhou@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sansan@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wendy_cai@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jodie@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Sophia_li@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Seven@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Sandra@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sky@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Fiona_chen@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-Sample@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS002@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS003@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS006@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS005@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS001@mail.tew.com.cn"));
			}
			else if (ACTTYPE.equals("TSCC") && RPTTYPE.equals("OUTSIDE"))
			{				
				remarks="";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("june@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("joyce@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("xiongyu@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("laura@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nancy@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCCSH-CS@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Jason@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Anna_Qiu@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("william_wu@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("shelly@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tingting@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("chris_wen@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sky_shi@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("gordon@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("alex@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Charlotte@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lisahou@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ccyang@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ccyang@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bin@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kevin@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("merry@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("charlotte@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("RITA_zhou@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sansan@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wendy_cai@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jodie@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Sophia_li@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Seven@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Sandra@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sky@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Fiona_chen@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-Sample@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS002@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS003@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS006@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS005@mail.tew.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS001@mail.tew.com.cn"));
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			
			if (ACTTYPE.equals("TSCC"))
			{
				message.setHeader("Subject", MimeUtility.encodeText((RPTTYPE.equals("INSIDE")?"TSCC內銷未交訂單明細":"TSCC外銷未交訂單明細")+remarks, "UTF-8", null));				
			}
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
			mbp.setDataHandler(new javax.activation.DataHandler(fds));
			mbp.setFileName(fds.getName());
		
			// create the Multipart and add its parts to it
			mp.addBodyPart(mbp);
			message.setContent(mp);
			Transport.send(message);	
		}
	}
	*/
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
	//if (ACTTYPE.equals(""))
	//{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/report/"+FileName; 
		response.sendRedirect(strURL);
	//}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
