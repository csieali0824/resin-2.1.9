<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,java.lang.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSSalesOrderUnshipOpeningExcelK3.jsp" METHOD="post" name="MYFORM">
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
String UserName = request.getParameter("UserName");
if (UserName==null) UserName="";
String UserRoles =request.getParameter("UserRoles");
if (UserRoles==null) UserRoles="";
String FileName="",RPTName="",PLANTNAME="",sql="",ERP_USERID="",remarks="",price_show="N";
int fontsize=8,colcnt=0,sheetcnt=0;
String v_sg_order="SG銷售訂單",v_sg_po="SG採購訂單";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "SG Opening Order List";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	wwb.createSheet(v_sg_order, 1);
	wwb.createSheet(v_sg_po, 2);
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
	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
	
	
	String sheetname [] = wwb.getSheetNames();
	for (int i =1 ; i < sheetname.length ; i++)
	{	
		reccnt=0;col=0;row=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings sst = ws.getSettings(); 
		sst.setSelected();
		sst.setVerticalFreeze(1);  //凍結窗格
		for (int g =1 ; g <=10 ;g++ )
		{
			sst.setHorizontalFreeze(g);
		}	
		//單據編號
		ws.addCell(new jxl.write.Label(col, row, "單據編號" , ACenterBL));
		ws.setColumnView(col,15);	
		col++;					

		//Sales Group
		ws.addCell(new jxl.write.Label(col, row, "行號" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;					

		//Customer
		ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	

		//幣別K3代碼
		ws.addCell(new jxl.write.Label(col, row, "幣別K3代碼" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	
		
		//Sales Group
		ws.addCell(new jxl.write.Label(col, row, "Sales Group" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;					

		//MO#
		ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
		ws.setColumnView(col,14);	
		col++;					
			
		//Line#
		ws.addCell(new jxl.write.Label(col, row, "Line#" , ACenterBL));
		ws.setColumnView(col,8);	
		col++;	
			
		//Ordered Date
		ws.addCell(new jxl.write.Label(col, row, "Order Date" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;
					
		//嘜頭
		ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	

		//Customer PO
		ws.addCell(new jxl.write.Label(col, row, "Customer PO" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	
		
		//TSC Item(22D)
		ws.addCell(new jxl.write.Label(col, row, "TSC Item(22D)" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	

		//ItemK3Code
		ws.addCell(new jxl.write.Label(col, row, "ItemK3Code" , ACenterBL));
		ws.setColumnView(col,15);	
		col++;

		//Item Desc
		ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	

		//Customer ITEM
		ws.addCell(new jxl.write.Label(col, row, "Customer P/N" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;				
		
		//Order Qty
		ws.addCell(new jxl.write.Label(col, row, "Order Qty" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	

		//未稅單價
		ws.addCell(new jxl.write.Label(col, row, "未稅單價" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	

		//CRD
		ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;

		//要求工廠出貨日
		ws.addCell(new jxl.write.Label(col, row, "要求工廠出貨日期" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;
						
		//Schedule Ship Date
		ws.addCell(new jxl.write.Label(col, row, "Schedule Ship Date" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	

		//客戶K3代碼
		ws.addCell(new jxl.write.Label(col, row, "客戶K3代碼" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	
				
		//部門K3代碼
		ws.addCell(new jxl.write.Label(col, row, "部門K3代碼" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;					
		
		//業務員K3代碼
		ws.addCell(new jxl.write.Label(col, row, "業務員K3代碼" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;		
	
		//優先送貨地址代碼
		ws.addCell(new jxl.write.Label(col, row, "優先送貨地址代碼" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;
		
		//供應商K3代碼
		ws.addCell(new jxl.write.Label(col, row, "供應商K3代碼" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	
				
		//Shipping Method
		ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;	

		//Packing Instrucations
		ws.addCell(new jxl.write.Label(col, row, "Packing Instrucations" , ACenterBL));
		ws.setColumnView(col,8);	
		col++;	

		//Payment Term
		ws.addCell(new jxl.write.Label(col, row, "Payment Term" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;
		
		//Fob Term
		ws.addCell(new jxl.write.Label(col, row, "Fob Term" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;

		//End Customer
		ws.addCell(new jxl.write.Label(col, row, "End Customer" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;
				
		//Order Status
		ws.addCell(new jxl.write.Label(col, row, "Order Status" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;
		
		//Shipping Marks
		ws.addCell(new jxl.write.Label(col, row, "Shipping Marks" , ACenterBL));
		ws.setColumnView(col,50);	
		col++;

		//Ship to org id
		ws.addCell(new jxl.write.Label(col, row, "Ship To Org ID" , ACenterBL));
		ws.setColumnView(col,15);	
		col++;

		//End Customer Number
		ws.addCell(new jxl.write.Label(col, row, "End Customer Number" , ACenterBL));
		ws.setColumnView(col,30);	
		col++;							
			
		//spq
		ws.addCell(new jxl.write.Label(col, row, "SPQ" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;	

		//moq
		ws.addCell(new jxl.write.Label(col, row, "MOQ" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;	
			
		//TSC_PROD_GROUP
		ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;		
		
		//TSC_Family
		ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;	
			
		//TSC_prod_Family
		ws.addCell(new jxl.write.Label(col, row, "TSC Prod Family" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;		
		
		//TSC_Package
		ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;		
		
		//ship to
		ws.addCell(new jxl.write.Label(col, row, "Ship to Address" , ACenterBL));
		ws.setColumnView(col,50);	
		col++;		
		
		//line type
		ws.addCell(new jxl.write.Label(col, row, "Line Type" , ACenterBL));
		ws.setColumnView(col,30);	
		col++;
		
		//yew group
		ws.addCell(new jxl.write.Label(col, row, "Yew Group" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;	

		//工廠回T出貨日
		ws.addCell(new jxl.write.Label(col, row, "工廠回T出貨日" , ACenterBL));
		ws.setColumnView(col,15);	
		col++;	

		//未稅金額
		ws.addCell(new jxl.write.Label(col, row, "未稅金額" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;
				
		//稅率
		ws.addCell(new jxl.write.Label(col, row, "稅率" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;
				
		//稅額
		ws.addCell(new jxl.write.Label(col, row, "稅額" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;
			
		//Remarks
		ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBL));
		ws.setColumnView(col,30);	
		col++;
		
		row++;
		
		if (i==0)
		{
			sql = " SELECT upper(Tsc_Intercompany_Pkg.get_sales_group(ooa.header_id)) sales_group,"+  
				  " ooa.ORDER_NUMBER,"+
				  " ooa.line_number ||'.'||ooa.shipment_number line_no,"+
				  " msi.description,"+
				  " DECODE(ooa.ITEM_IDENTIFIER_TYPE,'CUST',ooa.ORDERED_ITEM,'') CUST_ITEM,"+
				  " nvl(ar.CUSTOMER_NAME_PHONETIC,ar.customer_name) customer,"+
				  " ooa.CUSTOMER_LINE_NUMBER customer_po,"+
				  " ooa.ordered_quantity,"+
				  " to_char(trunc(ooa.schedule_ship_date),'yyyy/mm/dd') schedule_ship_date,"+
				  " to_char(trunc(ooa.REQUEST_DATE),'yyyy/mm/dd') request_date,"+
				  //" to_char(trunc(ooa.ORDERED_DATE),'yyyy/mm/dd') ordered_date,"+
                  " case when substr(ooa.ORDER_NUMBER,1,1) ='8' then to_char(trunc(ooa.ORDERED_DATE),'yyyy/mm/dd') else '2020/02/01' end ordered_date,"+
				  " ooa.SHIPPING_METHOD_CODE,"+
				  " lc.meaning SHIP_METHOD,"+
				  "'RMB' currency_code,  "+ 
				  " ooa.PACKING_INSTRUCTIONS,"+
				  " TERM.NAME,"+
				  " ooa.fob_point,"+
				  " Replace(Replace(TSC_GET_REMARK(ooa.HEADER_ID,'REMARKS'),chr(10), chr(32)),chr(13),chr(32))  REMARKS, "+
				  " Replace(Replace(TSC_GET_REMARK(ooa.HEADER_ID,'SHIPPING MARKS'),chr(10), chr(32)),chr(13),chr(32))  SHIPMARKS,"+
				  " ooa.ATTRIBUTE7 PCMARK,"+  
				  " ooa.flow_status_code,"+
				  " ooa.CUSTOMER_SHIPMENT_NUMBER CUSTOMER_PO_LINE_NUM,"+
				  " TSC_GET_REMARK_DESC(ooa.HEADER_ID,'SHIPPING MARKS') mark_desc,"+
				  " ooa.end_customer_id,"+
				  " NVL (ar1.customer_name_phonetic, ar1.customer_name) end_customer,"+
				  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) as TSC_PROD_GROUP,"+
				  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,21) as TSC_FAMILY,"+
				  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000004) as TSC_PROD_FAMILY,"+
				  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,23) as TSC_Package,"+
				  " tog.description yew_group,"+
				  " substr(ott.NAME,instr(ott.NAME,'_')+1,length(ott.name)) as line_type,"+
				  " addr.address1, "+
				  " (SELECT CASE WHEN substr(ooa.order_number,2,3) ='121' then SAMPLE_SPQ ELSE SPQ end as SPQ FROM TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',CASE WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) IN ('SSD') THEN '005' ELSE '008' END ))) AS SPQ,"+
				  " (SELECT MOQ  FROM TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',CASE WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) IN ('SSD') THEN '005' ELSE '008' END ))) AS MOQ"+
				  ",ooa.ship_to_org_id"+
				  ",ar1.customer_number end_customer_number"+
				  ",to_char(trunc(ooa.schedule_ship_date-tsc_get_china_to_tw_days(ooa.PACKING_INSTRUCTIONS ,ooa.ORDER_NUMBER,ooa.INVENTORY_ITEM_ID,null,null,null)),'yyyy/mm/dd') factory_totw_date "+  //add by Peggy 20160805
				  ",(select distinct LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) "+
				  " from ar_contacts_v con WHERE con.contact_id=ooa.attribute11  and con.status='A') ship_to_contact"+
				  ",ooa.UNIT_SELLING_PRICE"+ 
				  ",opa.OPERAND LINE_CHARGE"+ 
				  ",TO_CHAR(tkcr.tax_rate) tax_rate"+
				  ",tkcr.currency_code"+
				  ",tks.supplier_code"+
				  ",tkc.cust_code"+
				  ",tkc.dept_code"+
				  ",tkc.sales_code"+
				  //",round(ooa.UNIT_SELLING_PRICE*ooa.ordered_quantity,2) amount"+ 
				  //",round(ooa.UNIT_SELLING_PRICE*ooa.ordered_quantity*tkcr.tax_rate,2) tax_amount"+
				  ",round(ooa.UNIT_SELLING_PRICE*ooa.ordered_quantity,2) amount"+  //四捨五入至小數點二點,add by Peggy 20171226
				  ",round(ooa.UNIT_SELLING_PRICE*ooa.ordered_quantity*tkcr.tax_rate,2) tax_amount"+
				  ",ooa.K3_ADDR_CODE"+   
				  ",ooa.k3_order_no"+     
				  ",ooa.k3_order_line_no"+  
				  ",msi.segment1 item_no"+ 
				  " FROM (SELECT ooh.ORDER_NUMBER"+ 
                  "       ,ooh.header_id"+ 
                  "       ,ooh.ORDERED_DATE"+ 
                  "       ,ooh.TRANSACTIONAL_CURR_CODE"+ 
                  "       ,ooh.FOB_POINT_CODE"+ 
                  "       ,ooh.attribute11"+ 
                  "       ,ooh.SALESREP_ID"+ 
                  "       ,ooh.SOLD_TO_ORG_ID"+ 
                  "       ,ooh.ORG_ID"+ 
                  "       ,ooh.BOOKED_DATE"+ 
                  "       ,ool.line_id"+ 
                  "       ,ool.line_number "+  
                  "       ,ool.shipment_number"+ 
                  "       ,ool.ITEM_IDENTIFIER_TYPE"+ 
                  "       ,ool.ORDERED_ITEM"+ 
                  "       ,ool.CUSTOMER_LINE_NUMBER"+ 
                  "       ,ool.ordered_quantity"+ 
                  "       ,ool.schedule_ship_date"+ 
                  "       ,ool.REQUEST_DATE"+ 
                  "       ,ool.SHIPPING_METHOD_CODE"+ 
                  "       ,ool.PACKING_INSTRUCTIONS"+ 
                  "       ,nvl(ool.FOB_POINT_CODE,ooh.FOB_POINT_CODE) fob_point"+ 
                  "       ,ool.ATTRIBUTE7 "+ 
                  "       ,ool.flow_status_code"+ 
                  "       ,ool.CUSTOMER_SHIPMENT_NUMBER"+ 
                  "       ,ool.end_customer_id"+ 
                  "       ,ool.ship_to_org_id"+ 
				  "       ,case when substr(ooh.order_number,1,1)=8 then  ool.UNIT_SELLING_PRICE"+
				  "        else Tsc_Om_Get_Target_Price_0702(ool.ship_from_org_id,ool.inventory_item_id,ool.ORDER_QUANTITY_UOM,2142473,trunc(sysdate),'CNY',ool.packing_instructions,null) end UNIT_SELLING_PRICE"+
                  "       ,ool.INVENTORY_ITEM_ID"+ 
                  "       ,ool.line_type_id  "+            
                  "       ,nvl(ool.payment_term_id,ooh.payment_term_id) payment_term_id"+ 
                  "       ,tkale.addr_code k3_addr_code"+ 
                  "      ,case when instr(ool.attribute3,'-')>0 then substr(ool.attribute3,1,instr(ool.attribute3,'-',-1)-1) else null end k3_order_no"+ 
                  "       ,case when instr(ool.attribute3,'-')>0 then substr(ool.attribute3,instr(ool.attribute3,'-',-1)+1) else null end k3_order_line_no"+ 
                  "       FROM  oe_order_headers_all ooh"+ 
                  "       ,oe_order_lines_all ool "+ 
                  "       ,hz_cust_site_uses_all hcsua"+ 
                  "       ,(select * from oraddman.tscc_k3_addr_link_erp where active_flag='A') tkale"+ 
                  "       WHERE nvl(ooh.ATTRIBUTE1,'xx')='Opening Order'"+ 
                  //"       OR exists (select 1 from oraddman.tssg_abroad_open_order taox where NVL(taox.UPDATED_FLAG,'N')='Y' AND taox.so_no=ooh.order_number and taox.line_no=ool.line_number||'.'||ool.shipment_number)"+
				  //"       OR ooh.order_number in ('11310043440','11310043441','11310043442')"+
				  //"        )"+ 
                  "       AND ooh.HEADER_ID=ool.HEADER_ID "+ 
                  "       AND ool.CANCELLED_FLAG != 'Y'"+ 
                  "       AND ool.PACKING_INSTRUCTIONS='T'"+ 
                  //"       AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017')"+ 
				  "       AND ooh.ORDER_TYPE_ID in ('1707')"+  //8131
                  "       AND ool.INVENTORY_ITEM_ID not in  (29570,29562,29560)"+ 
                  //"       AND SUBSTR(ooh.ORDER_NUMBER,1,4) <>'1121'  "+ 
                  "       AND ooh.org_id IN (906)"+ 
                  "       AND ool.ship_to_org_id=hcsua.site_use_id  "+           
                  //"       AND hcsua.location=tkale.erp_ship_to_location_id(+)"+ 
				  "       AND hcsua.location=tkale.sg_ship_to_location_id(+)"+ 
                  //"       AND not exists (select 1 from ont.oe_order_headers_all sgh where sgh.org_id=906 and ooh.org_id<>906 and sgh.order_number=ooh.order_number)";
				  "       and (ool.attribute3 is not null and instr(ool.attribute3,'-')>0)"+
			      "      ) ooa"+
				  "     ,JTF_RS_SALESREPS jrs "+
				  "     ,MTL_SYSTEM_ITEMS_B msi"+
				  "     ,AR_CUSTOMERS ar,"+
                  "     (select * from ra_terms_tl where language='US') term ,"+
				  "     (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') lc,"+
				  "     ar_customers ar1,"+
				  "     (select * from AR.HZ_CUST_SITE_USES_ALL where site_use_code = 'SHIP_TO') hcsu,"+
				  "     (select * from tsc_om_group) tog,"+
				  "     (SELECT * FROM OE_TRANSACTION_TYPES_TL WHERE LANGUAGE ='US') ott,"+
				  "     (select hcsu.site_use_id,hl.address1  from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
				  "      where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
				  "      and hcas.party_site_id = hps.party_site_id  "+
				  "      and hps.location_id =hl.location_id "+
				  "      and hcsu.site_use_code = 'SHIP_TO'"+
				  "      and hcsu.status = 'A') addr"+
				  "     ,(SELECT A.LINE_ID,A.OPERAND  FROM ont.oe_price_adjustments a  where LIST_LINE_TYPE_CODE='FREIGHT_CHARGE') opa"+
				  "     ,(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkce"+
				  "     ,oraddman.tscc_k3_cust tkc"+
				  "     ,oraddman.tscc_k3_supplier tks"+
				  "     ,oraddman.tscc_k3_curr tkcr"+
				  " WHERE 1=1"+
				  " AND ooa.SALESREP_ID = jrs.SALESREP_ID(+)"+
				  " AND ooA.INVENTORY_ITEM_ID = msi.INVENTORY_ITEM_ID"+
				  " AND msi.ORGANIZATION_ID = 43"+
				  " AND ooa.SOLD_TO_ORG_ID = ar.CUSTOMER_ID"+
				  " AND ooa.payment_term_id =term.term_id "+
				  " AND ooa.ORG_ID=jrs.ORG_ID(+)"+
				  " AND ooa.SHIPPING_METHOD_CODE = lc.lookup_code (+)"+
				  " AND case when substr(ooa.order_number,1,1)<>'8' then 20100 else  ooa.sold_to_org_id end=ar1.customer_id(+)"+
				  " AND ooa.ship_to_org_id = hcsu.site_use_id(+)"+
				  " AND hcsu.attribute1=tog.group_id(+)"+
				  " AND ooa.line_type_id= ott.transaction_type_id(+)"+
				  " AND ooa.ship_to_org_id=addr.site_use_id(+)"+
				  " AND ooa.LINE_ID=opa.LINE_ID(+)"+
				  " AND ar1.customer_number=tkce.erp_cust_number(+)"+
				  " AND tkce.cust_code=tkc.cust_code(+)"+
				  " AND substr(ooa.order_number,1,1) =tks.erp_order_code(+)"+
				  " AND substr(ooa.order_number,1,1) =tkcr.erp_order_code(+)"+
                  " order by 2,3,4";		
			//out.println(sql);
		}
		else if (i==1)
		{
			sql = " SELECT upper(Tsc_Intercompany_Pkg.get_sales_group(ooa.header_id)) sales_group,"+
                  " to_char(ooa.ORDER_NUMBER) ||'-'|| ooa.po_no ORDER_NUMBER,"+
                  " ooa.line_number ||'.'||ooa.shipment_number line_no,"+
                  " msi.description,"+
                  " DECODE(ooa.ITEM_IDENTIFIER_TYPE,'CUST',ooa.ORDERED_ITEM,'') CUST_ITEM,"+
                  " nvl(ar.CUSTOMER_NAME_PHONETIC,ar.customer_name) customer,"+
                  " ooa.CUSTOMER_LINE_NUMBER customer_po,"+
                  //" ooa.ordered_quantity,"+
                  " ooa.po_qty ordered_quantity,"+
                  " to_char(trunc(ooa.schedule_ship_date),'yyyy/mm/dd') schedule_ship_date,"+
                  " to_char(trunc(ooa.REQUEST_DATE),'yyyy/mm/dd') request_date,"+
                  " case when substr(ooa.ORDER_NUMBER,1,1) ='8' then to_char(trunc(ooa.ORDERED_DATE),'yyyy/mm/dd') else '2020/01/22' end ordered_date,"+
                  " ooa.SHIPPING_METHOD_CODE,"+
                  " lc.meaning SHIP_METHOD,"+
                  " ooa.TRANSACTIONAL_CURR_CODE, "+
                  " ooa.PACKING_INSTRUCTIONS,"+
                  " TERM.NAME,"+
                  " ooa.fob_point,"+
                  " Replace(Replace(TSC_GET_REMARK(ooa.HEADER_ID,'REMARKS'),chr(10), chr(32)),chr(13),chr(32))  REMARKS, "+
                  " Replace(Replace(TSC_GET_REMARK(ooa.HEADER_ID,'SHIPPING MARKS'),chr(10), chr(32)),chr(13),chr(32))  SHIPMARKS,"+
                  " ooa.ATTRIBUTE7 PCMARK,"+
                  " ooa.flow_status_code,"+
                  " ooa.CUSTOMER_SHIPMENT_NUMBER CUSTOMER_PO_LINE_NUM,"+
                  " TSC_GET_REMARK_DESC(ooa.HEADER_ID,'SHIPPING MARKS') mark_desc,"+
                  " ooa.end_customer_id,"+
                  " NVL (ar1.customer_name_phonetic, ar1.customer_name) end_customer,"+
                  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) as TSC_PROD_GROUP,"+
                  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,21) as TSC_FAMILY,"+
                  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000004) as TSC_PROD_FAMILY,"+
                  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,23) as TSC_Package,"+
                  " tog.description yew_group,"+
                  " substr(ott.NAME,instr(ott.NAME,'_')+1,length(ott.name)) as line_type,"+
                  " addr.address1, "+
                  " (SELECT CASE WHEN substr(ooa.order_number,2,3) ='121' then SAMPLE_SPQ ELSE SPQ end as SPQ FROM TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',CASE WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) IN ('SSD') THEN '005' ELSE '008' END ))) AS SPQ,"+
                  " (SELECT MOQ  FROM TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',CASE WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) IN ('SSD') THEN '005' ELSE '008' END ))) AS MOQ"+
                  ",ooa.ship_to_org_id"+
                  ",ar1.customer_number end_customer_number"+
                  ",to_char(trunc(ooa.schedule_ship_date-tsc_get_china_to_tw_days(ooa.PACKING_INSTRUCTIONS ,ooa.ORDER_NUMBER,ooa.INVENTORY_ITEM_ID,null,null,null)),'yyyy/mm/dd') factory_totw_date "+
                  ",(select distinct LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) "+
                  " from ar_contacts_v con WHERE con.contact_id=ooa.attribute11  and con.status='A') ship_to_contact"+
                  //,ooa.UNIT_SELLING_PRICE"+
                  ",ooa.po_unit_price UNIT_SELLING_PRICE"+
                  ",to_char(opa.OPERAND) LINE_CHARGE "+
                  ",TO_CHAR(tkcr.tax_rate) tax_rate"+
                  ",tkcr.currency_code"+
                  ",tks.supplier_code"+
                  ",tkc.cust_code"+
                  ",tkc.dept_code"+
                  ",tkc.sales_code"+
                  //",round(ooa.UNIT_SELLING_PRICE*ooa.ordered_quantity,2) amount"+
				  ",round(ooa.po_unit_price*ooa.po_qty,2) amount"+
                  //",round(ooa.UNIT_SELLING_PRICE*ooa.ordered_quantity*tkcr.tax_rate,2) tax_amount"+
				  ",round(ooa.po_unit_price*ooa.po_qty*tkcr.tax_rate,2) tax_amount"+
                  ",ooa.K3_ADDR_CODE"+
                  ",ooa.k3_order_no"+  
                  ",ooa.k3_order_line_no "+
                  ",msi.segment1 item_no"+
                  ",ooa.vendor_code"+
                  ",ooa.vendor_name"+
				  " FROM (SELECT ooax.*"+
				  "      ,po.po_no,po.unit_price po_unit_price"+
				  "      ,po.quantity po_qty"+
				  "      ,po.vendor_code"+
				  "      ,po.vendor_name"+
				  "      ,decode(po.currency_code,'CNY','RMB',po.currency_code) TRANSACTIONAL_CURR_CODE "+
				  "       FROM (SELECT to_char(ooh.ORDER_NUMBER) ORDER_NUMBER"+ 
                  "       ,ooh.header_id"+ 
                  "       ,ooh.ORDERED_DATE"+ 
                  "       ,ooh.FOB_POINT_CODE"+ 
                  "       ,ooh.attribute11"+ 
                  "       ,ooh.SALESREP_ID"+ 
                  "       ,ooh.SOLD_TO_ORG_ID"+ 
                  "       ,ooh.ORG_ID"+ 
                  "       ,ooh.BOOKED_DATE"+ 
                  "       ,ool.line_id"+ 
                  "       ,ool.line_number "+  
                  "       ,ool.shipment_number"+ 
                  "       ,ool.ITEM_IDENTIFIER_TYPE"+ 
                  "       ,ool.ORDERED_ITEM"+ 
                  "       ,ool.CUSTOMER_LINE_NUMBER"+ 
                  "       ,ool.ordered_quantity"+ 
                  "       ,trunc(ool.schedule_ship_date) schedule_ship_date"+ 
                  "       ,trunc(ool.REQUEST_DATE) REQUEST_DATE"+ 
                  "       ,ool.SHIPPING_METHOD_CODE"+ 
                  "       ,ool.PACKING_INSTRUCTIONS"+ 
                  "       ,nvl(ool.FOB_POINT_CODE,ooh.FOB_POINT_CODE) fob_point"+ 
                  "       ,ool.ATTRIBUTE7 "+ 
                  "       ,ool.flow_status_code"+ 
                  "       ,ool.CUSTOMER_SHIPMENT_NUMBER"+ 
                  "       ,ool.end_customer_id"+ 
                  "       ,ool.ship_to_org_id"+ 
                  "       ,ool.UNIT_SELLING_PRICE"+ 
                  "       ,ool.INVENTORY_ITEM_ID"+ 
                  "       ,ool.line_type_id  "+            
                  "       ,nvl(ool.payment_term_id,ooh.payment_term_id) payment_term_id"+ 
                  "       ,tkale.addr_code k3_addr_code"+ 
                  "       ,case when ool.attribute3 is not null and instr(ool.attribute3,'-')>0 then substr(ool.attribute3,1,instr(ool.attribute3,'-',-1)-1) else '' end k3_order_no"+ 
                  "       ,case when ool.attribute3 is not null and instr(ool.attribute3,'-')>0 then substr(ool.attribute3,instr(ool.attribute3,'-',-1)+1) else '' end k3_order_line_no"+ 
                  "       FROM  oe_order_headers_all ooh"+ 
                  "       ,oe_order_lines_all ool "+ 
                  "       ,hz_cust_site_uses_all hcsua"+ 
                  "       ,(select * from oraddman.tscc_k3_addr_link_erp where active_flag='A') tkale"+ 
                  "       WHERE nvl(ooh.ATTRIBUTE1,'xx')='Opening Order'"+ 
                  //"       OR exists (select 1 from oraddman.tssg_abroad_open_order taox where NVL(taox.UPDATED_FLAG,'N')='Y' AND taox.so_no=ooh.order_number and taox.line_no=ool.line_number||'.'||ool.shipment_number)"+
				  //"       OR exists (select 1 from  po_headers_all ak,po_line_locations_all bk where  ak.po_header_id=bk.po_header_id and bk.note_to_receiver is not null and ak.org_id=906 and ak.comments LIKE 'Opening PO%' and substr(bk.note_to_receiver,1,instr(bk.note_to_receiver,'.')-1)=ooh.order_number) "+
				  //"       OR ooh.order_number in ('11310043440','11310043441','11310043442')"+
				  //"       )"+ 
                  "       AND ooh.HEADER_ID=ool.HEADER_ID "+ 
                  "       AND ool.CANCELLED_FLAG != 'Y'"+ 
                  //"       AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017')"+ 
				  "       AND ooh.ORDER_TYPE_ID in ('1707')"+ 
                  "       AND ool.INVENTORY_ITEM_ID not in  (29570,29562,29560)"+
                  //"       AND ool.PACKING_INSTRUCTIONS='T'"+ 
                  //"       AND ooh.org_id IN (41,906)"+ 
            	  "       AND ool.PACKING_INSTRUCTIONS='T'"+ 
                  "       AND ooh.org_id IN (906)"+
                  "       AND ool.ship_to_org_id=hcsua.site_use_id"+
                  //"       AND hcsua.location=tkale.erp_ship_to_location_id(+)"+ 
				  "       AND hcsua.location=tkale.sg_ship_to_location_id(+)"+
                  //"       AND not exists (select 1 from ont.oe_order_headers_all sgh where sgh.org_id=906 and ooh.org_id<>906 and sgh.order_number=ooh.order_number)";
				  "       and (ool.attribute3 is not null and instr(ool.attribute3,'-')>0)"+
			      "       ) ooax"+ 
				  "      ,(select substr(b.note_to_receiver,1,instr(b.note_to_receiver,'.')-1) so_no,substr(b.note_to_receiver,instr(b.note_to_receiver,'.')+1) so_line_no ,a.segment1 po_no,c.vendor_id,c.segment1 vendor_code,c.vendor_name,e.line_num,a.currency_code ,f.attribute1 so_line_id,e.unit_price/case e.unit_meas_lookup_code when 'KPC' then 1000 else 1 end unit_price,sum(b.quantity * case  b.unit_meas_lookup_code when 'KPC' then 1000 else 1 end) quantity,a.comments,b.note_to_receiver"+
                  "        from  po_headers_all a, po_line_locations_all b, ap_suppliers c,ap_supplier_sites_all d,po_lines_all e, po_distributions_all f"+
                  "        where e.po_line_id=b.po_line_id"+
                  "        and a.vendor_site_id=d.vendor_site_id"+
                  "        and d.vendor_id=c.vendor_id"+
                  "        and a.po_header_id=e.po_header_id"+
				  "        and a.cancel_flag<>'Y'"+
				  "        and b.line_location_id=f.line_location_id"+
                  "        and substr(b.note_to_receiver,instr(b.note_to_receiver,'.')+1) is not null"+
                  "        and a.org_id=906"+
                  //"        and a.revision_num=0"+
                  "        group by b.note_to_receiver ,a.segment1,c.segment1,c.vendor_id ,c.vendor_name,e.line_num,e.unit_price,e.unit_meas_lookup_code,a.currency_code,f.attribute1,a.comments ) po"+
                  //"        where to_char(ooax.order_number)=po.so_no"+
                  //"        and ooax.line_number=po.so_line_no"+
				  //"        where  ooax.line_id=po.so_line_id"+
				  //"        and ((substr(ooax.order_number,1,1)<>'8' and po.comments LIKE 'Opening PO%')"+
				   "        where  ooax.line_id=po.so_line_id"+
			       "        and substr(ooax.order_number,1,1)='8'"+
				   "         and po.vendor_id<>'976232'"+
                  "       ) ooa"+
                  "     ,JTF_RS_SALESREPS jrs "+
                  "     ,MTL_SYSTEM_ITEMS_B msi"+
                  "     ,AR_CUSTOMERS ar,"+
                  "     ra_terms_tl term ,"+
                  "     (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') lc,"+
                  "     ar_customers ar1,"+
                  "     (select * from AR.HZ_CUST_SITE_USES_ALL where site_use_code = 'SHIP_TO') hcsu,"+
                  "     (select * from tsc_om_group) tog,"+
                  "     (SELECT * FROM OE_TRANSACTION_TYPES_TL WHERE LANGUAGE ='US') ott,"+
                  "     (select hcsu.site_use_id,hl.address1  from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
                  "      where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
                  "      and hcas.party_site_id = hps.party_site_id  "+
                  "      and hps.location_id =hl.location_id "+
                  "      and hcsu.site_use_code = 'SHIP_TO'"+
                  "      and hcsu.status = 'A') addr"+
                  "     ,(SELECT A.LINE_ID,A.OPERAND  FROM ont.oe_price_adjustments a  where LIST_LINE_TYPE_CODE='FREIGHT_CHARGE') opa"+
                  "     ,(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkce"+
                  "     ,oraddman.tscc_k3_cust tkc"+
                  "     ,oraddman.tscc_k3_supplier tks"+
				  "     ,(select * from oraddman.tscc_k3_curr where ERP_ORDER_CODE='8') tkcr"+
                  " WHERE ooa.SALESREP_ID = jrs.SALESREP_ID(+)"+
                  " AND ooA.INVENTORY_ITEM_ID = msi.INVENTORY_ITEM_ID"+
                  " AND msi.ORGANIZATION_ID = 43"+
                  " AND ooa.SOLD_TO_ORG_ID = ar.CUSTOMER_ID"+
                  " AND term.language='US' "+
                  " AND ooa.payment_term_id =term.term_id(+)"+
                  " AND ooa.ORG_ID=jrs.ORG_ID(+)"+
                  " AND ooa.SHIPPING_METHOD_CODE = lc.lookup_code (+)"+
				  " AND case when substr(ooa.order_number,1,1)<>'8' then 20100 else  ooa.sold_to_org_id end=ar1.customer_id(+)"+
                  " AND ooa.ship_to_org_id = hcsu.site_use_id(+)"+
                  " AND hcsu.attribute1=tog.group_id(+)"+
                  " AND ooa.line_type_id= ott.transaction_type_id(+)"+
                  " AND ooa.ship_to_org_id=addr.site_use_id(+)"+
                  " AND ooa.LINE_ID=opa.LINE_ID(+)"+
				  " AND ar1.customer_number=tkce.erp_cust_number(+)"+
                  " AND tkce.cust_code=tkc.cust_code(+)"+
                  " AND ooa.vendor_code =tks.erp_vendor_code(+)"+
			      " order by 2,3";	
			//out.println(sql);
		}
		//out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);		
		while (rs.next()) 
		{ 	
			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("k3_order_no"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("k3_order_line_no"),ALeftL)); 
			col++;					
			//Customer
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("currency_code")==null?"":rs.getString("currency_code")) , ALeftL));
			col++;	
			//Sales Group
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_GROUP"),ALeftL));
			col++;					
			//MO#
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_NUMBER"), ACenterL));
			col++;					
			//Line#
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO") , ACenterL));
			col++;	
			//Ordered Date
			if (rs.getString("ORDERED_DATE")==null)
			{		
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ORDERED_DATE")) ,DATE_FORMAT));
			}
			col++;		
			//嘜頭
			ws.addCell(new jxl.write.Label(col, row, rs.getString("MARK_DESC")  , ALeftL));
			col++;				
			//Customer PO
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_PO"), ALeftL));
			col++;	
			//料號22D
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NO"), ALeftL));
			col++;	
			//Item Desc
			ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION") , ALeftL));
			col++;	
			//Item Desc
			ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION") , ALeftL));
			col++;	
			//Customer ITEM
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_ITEM") , ALeftL));
			col++;				
			//Order Qty
			if (rs.getString("ORDERED_QUANTITY")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ORDERED_QUANTITY")).doubleValue(), ARightL));
			}
			col++;	
			if (rs.getString("UNIT_SELLING_PRICE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("UNIT_SELLING_PRICE")).doubleValue(), ARightL));
			}
			col++;	
			//CRD
			if (rs.getString("REQUEST_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("REQUEST_DATE")) ,DATE_FORMAT));
			}
			col++;
			//要求工廠出貨日
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			col++;
			//Schedule Ship Date
			if (rs.getString("SCHEDULE_SHIP_DATE")==null)
			{		
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
			}
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("cust_code")==null?"":rs.getString("cust_code")) , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("dept_code")==null?"":rs.getString("dept_code") ) , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("sales_code")==null?"":rs.getString("sales_code")) , ALeftL));
			col++;	
			//優先送貨地址代碼,add by Peggy 20190625
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("k3_addr_code")==null?"":rs.getString("k3_addr_code")) , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("supplier_code")==null?"":rs.getString("supplier_code")) , ALeftL));
			col++;	
			//Shipping Method
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIP_METHOD") , ALeftL));
			col++;	
			//Packing Instrucations
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKING_INSTRUCTIONS")  ,ACenterL));
			col++;	
			//Payment Term
			ws.addCell(new jxl.write.Label(col, row, rs.getString("NAME")  , ALeftL));
			col++;
			//Fob Term
			ws.addCell(new jxl.write.Label(col, row, rs.getString("FOB_POINT")  ,ALeftL));
			col++;
			//End Customer
			ws.addCell(new jxl.write.Label(col, row, rs.getString("END_CUSTOMER")  , ALeftL));
			col++;
			//Order Status
			ws.addCell(new jxl.write.Label(col, row, rs.getString("FLOW_STATUS_CODE")  , ALeftL));
			col++;
			//Shipping Marks
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPMARKS")  , ALeftL));
			col++;
			//ship to org id
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIP_TO_ORG_ID")  , ALeftL));
			col++;
			//end customer number
			ws.addCell(new jxl.write.Label(col, row, rs.getString("END_CUSTOMER_NUMBER")  , ALeftL));
			col++;
			//spq
			ws.addCell(new jxl.write.Label(col, row, rs.getString("spq")  , ARightL));
			col++;	
			//moq
			ws.addCell(new jxl.write.Label(col, row, rs.getString("MOQ") , ARightL));
			col++;	
			//TSC_PROD_GROUP
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP") , ALeftL));
			col++;		
			//TSC_Family
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_FAMILY") , ALeftL));
			col++;	
			//TSC_prod_Family
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_FAMILY") , ALeftL));
			col++;		
			//TSC_Package
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE") , ALeftL));
			col++;	
			//ship to
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ADDRESS1") , ALeftL));
			col++;		
			//line type
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_TYPE") , ALeftL));
			col++;
			//yew group
			ws.addCell(new jxl.write.Label(col, row, rs.getString("YEW_GROUP") , ALeftL));
			col++;	
			if (rs.getString("SCHEDULE_SHIP_DATE")==null || rs.getString("factory_totw_date")==null || rs.getString("SCHEDULE_SHIP_DATE").equals(rs.getString("factory_totw_date")) )  
			{		
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("factory_totw_date")) ,DATE_FORMAT));
			}	
			col++;
			if (rs.getString("amount")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("amount")).doubleValue(), ARightL));
			}
			col++;				
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("tax_rate")==null?"":(new DecimalFormat("######0.####")).format(rs.getFloat("tax_rate"))) , ALeftL));
			col++;	
			if (rs.getString("tax_amount")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("tax_amount")).doubleValue(), ARightL));
			}
			col++;	
			ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			col++;		
			row++;				
			reccnt ++;
		}
		rs.close();
		statement.close();			
		sheetcnt++;
	}	
	wwb.write(); 
	wwb.close();

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
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				remarks="(這是來自RFQ測試區的信件)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{
				remarks="";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sunny@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("casey@ts-china.com.cn"));
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@.ts.com.tw"));
			
			message.setHeader("Subject", MimeUtility.encodeText("SG開帳訂單明細"+(ACTTYPE.equals("AUTO3")?"(金碟已下單)":"")+remarks, "UTF-8", null));				
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
	if (ACTTYPE.equals(""))
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
