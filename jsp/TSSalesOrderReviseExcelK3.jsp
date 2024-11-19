<!--20170829 Peggy,蘇州/上海/深圳業務單位變更郵件domain由mail.tew.com.cn改為ts-china.com.cn-->
<!--20171226 Peggy,4121訂單link K3客戶固定為(001.0323)上海瀚科國際貿易有限公司-->
<!--20190826 Peggy,統一格式-->
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
<FORM ACTION="../jsp/TSSalesOrderReviseExcelK3.jsp" METHOD="post" name="MYFORM">
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
String v_inside_order="內銷訂單",v_outside_order="外銷訂單",v_sg_order="SG銷售訂單",v_sg_po="SG採購訂單";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TSCC Order Revise List";
	FileName = RPTName+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//WritableSheet ws = wwb.createSheet(RPTName, 0); 
	wwb.createSheet(v_inside_order, 0);
	wwb.createSheet(v_outside_order, 1);
	wwb.createSheet(v_sg_order, 2);
	wwb.createSheet(v_sg_po, 3);
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
	ACenterBL.setWrap(false);	

	//英文內文水平垂直置中-粗體-格線-底色藍  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.PALE_BLUE); 
	ACenterBLB.setWrap(false);
	
	//英文內文水平垂直置中-粗體-格線-底色黃  
	WritableCellFormat ACenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLY.setBackground(jxl.write.Colour.YELLOW); 
	ACenterBLY.setWrap(false);	
	
	//英文內文水平垂直置中-粗體-格線-底色橘
	WritableCellFormat ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
	ACenterBLO.setWrap(false);	
	
	//英文內文水平垂直置中-粗體-格線-底色綠
	WritableCellFormat ACenterBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLG.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLG.setBackground(jxl.write.Colour.BRIGHT_GREEN); 
	ACenterBLG.setWrap(false);	
			
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(font_nobold);   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(false);


	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(font_nobold);   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(false);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(font_nobold);   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(false);
	
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterLB = new WritableCellFormat(font_nobold_b);   
	ACenterLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLB.setWrap(false);


	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightLB = new WritableCellFormat(font_nobold_b);   
	ARightLB.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLB.setWrap(false);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftLB = new WritableCellFormat(font_nobold_b);   
	ALeftLB.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLB.setWrap(false);
		
	//英文內文水平垂直置中-正常-格線-底色粉紅
	WritableCellFormat ACenterLP = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterLP.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLP.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLP.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLP.setBackground(jxl.write.Colour.PINK); 	
	ACenterLP.setWrap(false);
	
	//英文內文水平垂直置中-正常-格線-底色淺綠
	WritableCellFormat ACenterLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterLG.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLG.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
	ACenterLG.setWrap(false);	

	//英文內文水平垂直置中-正常-格線-底色粉紅-藍字
	WritableCellFormat ACenterLPB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLPB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLPB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLPB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLPB.setBackground(jxl.write.Colour.PINK); 	
	ACenterLPB.setWrap(false);
	
	//英文內文水平垂直置中-正常-格線-底色淺綠-藍字
	WritableCellFormat ACenterLGB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLGB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLGB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLGB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLGB.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
	ACenterLGB.setWrap(false);	
		
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(false);

	//日期格式
	WritableCellFormat DATE_FORMAT1 = new WritableCellFormat(font_nobold_b ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT1.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT1.setWrap(false);
	
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
	for (int i =0 ; i < sheetname.length ; i++)
	//for (int i =3 ; i < sheetname.length ; i++)
	{	
		reccnt=0;col=0;row=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings sst = ws.getSettings(); 
		sst.setSelected();
		sst.setVerticalFreeze(1);  //凍結窗格
		for (int g =1 ; g <=8 ;g++ )
		{
			sst.setHorizontalFreeze(g);
		}	
		//單據編號
		ws.addCell(new jxl.write.Label(col, row, "單據編號" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;	
		
		//行號
		ws.addCell(new jxl.write.Label(col, row, "行號" , ACenterBL));
		ws.setColumnView(col,8);	
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
		ws.setColumnView(col,10);	
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
		ws.setColumnView(col,50);	
		col++;
		row++;
			
		if (i<=1) 
		{	
			//out.println(sheetname[i]);
			sql = " SELECT count(1) over(order by ooa.header_id desc,ooa.line_id desc ) cnt ,"+
				  //" upper(Tsc_Intercompany_Pkg.get_sales_group(ooa.header_id)) sales_group,"+  
				  " upper(TSC_OM_Get_Sales_Group(ooa.header_id)) sales_group,"+  
				  " ooa.ORDER_NUMBER,"+
				  " ooa.line_number ||'.'||ooa.shipment_number line_no,"+
				  " msi.description,"+
				  " msi.segment1 item_no,"+
				  " DECODE(ooa.ITEM_IDENTIFIER_TYPE,'CUST',ooa.ORDERED_ITEM,'') CUST_ITEM,"+
				  " nvl(ar.CUSTOMER_NAME_PHONETIC,ar.customer_name) customer,"+
				  " ooa.CUSTOMER_LINE_NUMBER customer_po,"+
				  " ooa.ordered_quantity,"+
				  " to_char(trunc(ooa.schedule_ship_date),'yyyy/mm/dd') schedule_ship_date,"+
				  " to_char(trunc(ooa.REQUEST_DATE),'yyyy/mm/dd') request_date,"+
				  " to_char(trunc(ooa.ORDERED_DATE),'yyyy/mm/dd') ordered_date,"+
				  " ooa.SHIPPING_METHOD_CODE,"+
				  " lc.meaning SHIP_METHOD,"+
				  " replace(ooa.TRANSACTIONAL_CURR_CODE,'CNY','RMB') as TRANSACTIONAL_CURR_CODE,  "+
				  " ooa.PACKING_INSTRUCTIONS,"+
				  " term.NAME,"+
				  " ooa.fob_point,"+
				  " Replace(Replace(TSC_GET_REMARK(ooa.HEADER_ID,'REMARKS'),chr(10), chr(32)),chr(13),chr(32))  REMARKS, "+
				  " Replace(Replace(TSC_GET_REMARK(ooa.HEADER_ID,'SHIPPING MARKS'),chr(10), chr(32)),chr(13),chr(32))  SHIPMARKS,"+
				  " ooa.ATTRIBUTE7   PCMARK,  "+  
				  " ooa.flow_status_code, "+
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
				  " (SELECT CASE WHEN substr(ooa.order_number,2,3) ='121' then SAMPLE_SPQ ELSE SPQ end as SPQ FROM TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',CASE when ooa.PACKING_INSTRUCTIONS = 'Y' or substr(ooa.order_number,1,4)='1156' then '002' when ooa.PACKING_INSTRUCTIONS = 'E' or substr(ooa.order_number,1,4)='1142' THEN '008' when ooa.PACKING_INSTRUCTIONS = 'A'  THEN '010' WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003)='PMD' THEN '006'  WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) IN ('SSP','SSD') THEN '005' ELSE '002' END  ))) AS SPQ,"+
				  " (SELECT MOQ  FROM TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',CASE when ooa.PACKING_INSTRUCTIONS = 'Y' or substr(ooa.order_number,1,4)='1156' then '002' when ooa.PACKING_INSTRUCTIONS = 'E' or substr(ooa.order_number,1,4)='1142' THEN '008' when ooa.PACKING_INSTRUCTIONS = 'A'  THEN '010' WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003)='PMD' THEN '006'  WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) IN ('SSP','SSD') THEN '005' ELSE '002' END  ))) AS MOQ"+
				  ",ooa.ship_to_org_id"+
				  ",ar1.customer_number end_customer_number"+
				  ",to_char(trunc(ooa.schedule_ship_date-tsc_get_china_to_tw_days(ooa.PACKING_INSTRUCTIONS ,ooa.ORDER_NUMBER,ooa.INVENTORY_ITEM_ID,null,ooa.sold_to_org_id,to_char(ooa.mo_creation_date,'yyyymmdd'),ooa.CUSTOMER_LINE_NUMBER)),'yyyy/mm/dd') factory_totw_date "+  //add by Peggy 20160805
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
				  //",ool.UNIT_SELLING_PRICE*ool.ordered_quantity amount"+
				  ",round(ooa.UNIT_SELLING_PRICE*ooa.ordered_quantity,2) amount"+  //四捨五入至小數點二點,add by Peggy 20171226
				  ",round(ooa.UNIT_SELLING_PRICE*ooa.ordered_quantity*tkcr.tax_rate,2) tax_amount"+
				  ",trunc(ooa.creation_date) order_line_creation_date"+
				  ",trunc(ooa.last_update_date) order_line_last_update_date"+
				  ",case when ooa.ordered_quantity <> old_odr.ordered_quantity then 'QTY:'|| old_odr.ordered_quantity/case when ooa.ORDER_QUANTITY_UOM='PCE' THEN 1000 ELSE 1 END ||'K =>'||ooa.ordered_quantity/case when ooa.ORDER_QUANTITY_UOM='PCE' THEN 1000 ELSE 1 END||'K'||CHR(13)||CHR(10) ELSE '' END "+
				  " || case when ooa.schedule_ship_date <> old_odr.schedule_ship_date then 'SSD:'|| TO_CHAR(old_odr.schedule_ship_date,'yyyymmdd') ||' =>'|| to_char(ooa.schedule_ship_date,'yyyymmdd')||CHR(13)||CHR(10) ELSE '' END"+
				  " || case when ooa.customer_line_number <> old_odr.customer_line_number then 'Cust PO:'||old_odr.customer_line_number||' =>'||ooa.customer_line_number||CHR(13)||CHR(10) ELSE '' END "+
				  " || case when ooa.cust_po_number <> old_odr.cust_po_number then 'Cust PO:'||old_odr.cust_po_number||' =>'||ooa.cust_po_number||CHR(13)||CHR(10) ELSE '' END  "+
				  " || case when ooa.creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999 then 'New Line'||CHR(13)||CHR(10) ELSE '' END "+
				  " || case when ooa.unit_selling_price <> old_odr.unit_selling_price then 'Price:'||to_char(old_odr.unit_selling_price,'FM99999990.0999999')||'=>'||to_char(ooa.unit_selling_price,'FM99999990.0999999') ELSE '' END"+
                  " || case when nvl(ooa.end_customer_id,0) <> nvl(old_odr.end_customer_id,0) and old_odr.header_id is not null THEN  'End Cust:'|| nvl(old_odr.end_customer,'N/A') ||'=>'||NVL(NVL (ar1.customer_name_phonetic, ar1.customer_name),'N/A') ELSE '' END"+ //add by Peggy 20220120 end cust
				  " AS REVISE_REMARKS"+  //add by Peggy 20210811
				  //" FROM oe_order_headers_all ooh "+
				  //"     ,oe_order_lines_all ool"+
				  " FROM (SELECT ooh.ORDER_NUMBER"+
				  "       ,ooh.ORDERED_DATE"+
				  "       ,replace(ooh.TRANSACTIONAL_CURR_CODE,'CNY','RMB') as TRANSACTIONAL_CURR_CODE"+
				  "       ,ooh.FOB_POINT_CODE"+
				  "       ,ooh.HEADER_ID"+
				  "       ,ooh.attribute11"+ 
				  "       ,ooh.sold_to_org_id "+
				  "       ,ooh.SALESREP_ID"+
				  "       ,ooh.booked_date"+
				  "       ,nvl(ool.payment_term_id,ooh.payment_term_id) payment_term_id"+
				  "       ,ooh.org_id"+
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
				  "       ,NVL(ool.FOB_POINT_CODE,ooh.FOB_POINT_CODE) fob_point"+
				  "       ,ool.ATTRIBUTE7"+
				  "       ,ool.flow_status_code"+
				  "       ,ool.CUSTOMER_SHIPMENT_NUMBER"+
				  "       ,ool.end_customer_id"+
				  "       ,ool.ship_to_org_id"+
				  "       ,ool.UNIT_SELLING_PRICE"+
				  "       ,ool.last_update_date"+
				  "       ,ool.creation_date"+
				  "       ,ool.cust_po_number"+
				  "       ,ool.INVENTORY_ITEM_ID"+
				  "       ,ool.line_type_id"+
				  "       ,ool.LINE_ID"+
				  "       ,ool.ORDER_QUANTITY_UOM"+
				  "       ,ooh.creation_date mo_creation_date"+
				  "       FROM  oe_order_headers_all ooh,oe_order_lines_all ool "+
				  "       WHERE ooh.HEADER_ID=ool.HEADER_ID "+
				  "       AND ooh.sold_to_org_id in (14980,15540)"+		
				  "       AND NVL(ooh.booked_flag,'N')='Y'"+
				  "       AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017') "+
				  "       AND ool.INVENTORY_ITEM_ID not in  (29570,29562,29560)"+
				  "       AND SUBSTR(ooh.ORDER_NUMBER,2,2) <>'19'"+		
				  "       AND ooh.org_id = case  WHEN SUBSTR( OOH.ORDER_NUMBER,1,1) =1  then 41 else ooh.org_id end"+
				  //"       AND Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id) like 'TSCC%'"+
				  "       AND TSC_OM_Get_Sales_Group(ooh.header_id) like 'TSCC%'"+
				  //"       AND ool.flow_status_code<>'CLOSED'"+ //add by Peggy 20210908
				  "       ) ooa"+
				  "     ,JTF_RS_SALESREPS jrs "+
				  "     ,MTL_SYSTEM_ITEMS_B msi"+
				  "     ,AR_CUSTOMERS ar,"+
				  "     ra_terms_tl term ,"+
				  "     (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') lc,"+
				  "     ar_customers ar1,"+
				  "     (select * from AR.HZ_CUST_SITE_USES_ALL where site_use_code = 'SHIP_TO') hcsu,"+
				  "     (select * from tsc_om_group where org_id=325) tog,"+
				  "     (SELECT * FROM OE_TRANSACTION_TYPES_TL WHERE LANGUAGE ='US') ott,"+
				  "     (select hcsu.site_use_id,hl.address1  from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
				  "      where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
				  "      and hcas.party_site_id = hps.party_site_id  "+
				  "      and hps.location_id =hl.location_id "+
				  "      and hcsu.site_use_code = 'SHIP_TO'"+
				  "      and hcsu.status = 'A') addr"+
				  "     ,(SELECT A.LINE_ID,A.OPERAND  FROM ont.oe_price_adjustments a  where LIST_LINE_TYPE_CODE='FREIGHT_CHARGE') opa"+
				  "     ,oraddman.tscc_k3_cust_link_erp tkce"+  //add by Peggy 20230621
				  //"     ,(select * from oraddman.tscc_k3_cust_link_erp where nvl(active_flag,'I')='A') tkce"+
				  "     ,oraddman.tscc_k3_cust tkc"+
				  "     ,oraddman.tscc_k3_supplier tks"+
				  "     ,oraddman.tscc_k3_curr tkcr"+
				  //"     ,(SELECT reodr.* FROM (SELECT a.* ,row_number() over (partition by a.line_id order by a.version_number) row_seq  FROM ont.oe_order_lines_history a "+
				  //"       WHERE a.hist_creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999) reodr  where reodr.row_seq=1) old_odr"+
				  "     ,(SELECT a.*,(select nvl(x.customer_name_phonetic, x.customer_name) from ar_customers x where x.customer_id=a.end_customer_id) end_customer"+ //add by Peggy 20220120 end cust
				  "       FROM (select x.*,row_number() over (partition by x.header_id,x.line_id,x.version_number order by x.hist_creation_date,decode(x.hist_type_code,'SPLIT',1,2)) same_line_seq from ont.oe_order_lines_history x) a"+
				  "     ,(select header_id ,min(version_number) version_number from ont.oe_order_header_history "+
                  "      WHERE hist_creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999 group by header_id) b"+
                  "      where a.header_id=b.header_id and a.version_number=b.version_number and a.same_line_seq=1) old_odr"+  //modify by Peggy 20201112
				  " WHERE 1=1"+
				  " AND ooa.SALESREP_ID = jrs.SALESREP_ID(+)"+
				  " AND ooa.INVENTORY_ITEM_ID = msi.INVENTORY_ITEM_ID"+
				  " AND msi.ORGANIZATION_ID = 43"+
				  " AND ooa.SOLD_TO_ORG_ID = ar.CUSTOMER_ID"+
				  " AND  term.language='US' "+
				  //" AND nvl(ool.payment_term_id,ooh.payment_term_id) =term.term_id "+
				  " AND ooa.payment_term_id =term.term_id "+
				  " AND ooa.ORG_ID=jrs.ORG_ID(+)"+
				  " AND ooa.SHIPPING_METHOD_CODE = lc.lookup_code (+)"+
				  //" AND ool.end_customer_id = ar1.customer_id(+)"+
				  " AND case when substr(ooa.order_number,1,4) in ('4121') then ooa.sold_to_org_id else  ooa.end_customer_id end = ar1.customer_id(+)"+  //4121 訂單依header customer id link k3客戶,add by Peggy 20171226
				  " AND ooa.ship_to_org_id = hcsu.site_use_id(+)"+
				  " AND hcsu.attribute1=tog.group_id(+)"+
				  " AND ooa.line_type_id= ott.transaction_type_id(+)"+
				  " AND ooa.ship_to_org_id=addr.site_use_id(+)"+
				  " AND ooa.line_id=opa.line_id(+)"+
				  " AND ar1.customer_number=tkce.erp_cust_number(+)"+
				  " AND tkce.cust_code=tkc.cust_code(+)"+
				  " AND substr(ooa.order_number,1,1) =tks.erp_order_code(+)"+
				  " AND substr(ooa.order_number,1,1) =tkcr.erp_order_code(+)"+
				  " AND ooa.LINE_ID=old_odr.LINE_ID(+)"+
				  " AND (((ooa.ordered_quantity <> old_odr.ordered_quantity"+
				  " OR ooa.schedule_ship_date <> old_odr.schedule_ship_date"+
				  " OR ooa.customer_line_number <> old_odr.customer_line_number"+
				  " OR ooa.cust_po_number <> old_odr.cust_po_number"+
                  " OR ooa.unit_selling_price <> old_odr.unit_selling_price"+ //add by Peggy 20210811
				  " OR (NVL(ooa.end_customer_id,0) <> NVL(old_odr.end_customer_id,0) and old_odr.header_id is not null)"+ //add by Peggy 20220120
				  //" OR ool.creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999)";
				  " OR (ooa.shipment_number>1 "+
				  "    AND (ooa.ordered_quantity <> old_odr.ordered_quantity "+
				  "         OR ooa.schedule_ship_date <> old_odr.schedule_ship_date "+
				  "         OR ooa.customer_line_number <> old_odr.customer_line_number"+
                  "         OR ooa.unit_selling_price <> old_odr.unit_selling_price"+ //add by Peggy 20210811
				  "         OR ooa.cust_po_number <> old_odr.cust_po_number"+
				  "         OR (NVL(ooa.end_customer_id,0) <> NVL(old_odr.end_customer_id,0) and old_odr.header_id is not null))))"+  //add by Peggy 20220120
				  " AND ooa.last_update_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999)"+
				  " OR (ooa.shipment_number=1 AND ooa.creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999)"+
				  " OR (EXISTS (SELECT 1 FROM ONT.OE_ORDER_LINES_ALL onx where onx.last_update_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999 and onx.shipment_number>1 and onx.line_number=ooa.line_number and onx.header_id=ooa.header_id))"+ //split line也要顯示,add by Peggy 20180607
				  " )";
			if (UserRoles.indexOf("admin")<0)
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
						 " WHERE togs.user_id = us.user_id"+
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
						 //" AND c.username='"+UserName+"') x where x.group_name=Tsc_Intercompany_Pkg.get_sales_group(ooa.header_id))";	
						 " AND c.username='"+UserName+"') x where x.group_name=TSC_OM_Get_Sales_Group(ooa.header_id))";	
			}
			//if (ORDERTYPE.equals("INSITE") || ERP_USERID.equals("5870"))
			if (i==0)
			{	
				sql += " and substr(ooa.ORDER_NUMBER,1,4) in ('4131','4121')";
			}
			//else if (ORDERTYPE.equals("OUTSITE"))
			else if (i==1)
			{
				sql += " and substr(ooa.ORDER_NUMBER,1,1) in ('1')";
			}
			sql +=" AND ooa.booked_date < TO_DATE('"+EDATE+"','yyyymmdd')"+
				  " order by 1 desc,2,3,4";		
								 
		}
		else if (i==2)
		{
			//sql = " SELECT upper(Tsc_Intercompany_Pkg.get_sales_group(ooa.header_id)) sales_group,"+  
			sql = " SELECT upper(TSC_OM_Get_Sales_Group(ooa.header_id)) sales_group,"+  
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
                  " case when trunc(ooa.ORDERED_DATE)>trunc(ooa.schedule_ship_date) then to_char(trunc(ooa.schedule_ship_date),'yyyy/mm/dd') else to_char(trunc(ooa.ORDERED_DATE),'yyyy/mm/dd') end ordered_date,"+
                  //" case when substr(ooa.ORDER_NUMBER,1,1) ='8' then to_char(trunc(ooa.ORDERED_DATE),'yyyy/mm/dd') else '2020/02/01' end ordered_date,"+
				  " ooa.SHIPPING_METHOD_CODE,"+
				  " lc.meaning SHIP_METHOD,"+
				  "'RMB' TRANSACTIONAL_CURR_CODE,  "+ 
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
				  ",to_char(trunc(ooa.schedule_ship_date-tsc_get_china_to_tw_days(ooa.PACKING_INSTRUCTIONS ,ooa.ORDER_NUMBER,ooa.INVENTORY_ITEM_ID,null,ooa.sold_to_org_id,null,ooa.cust_po_number)),'yyyy/mm/dd') factory_totw_date "+  //add by Peggy 20160805
				  ",(select distinct LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) "+
				  " from ar_contacts_v con WHERE con.contact_id=ooa.attribute11  and con.status='A') ship_to_contact"+
				  ",ooa.UNIT_SELLING_PRICE"+ 
				  ",opa.OPERAND LINE_CHARGE"+ 
				  ",TO_CHAR(tkcr.tax_rate) tax_rate"+
				  //",tkcr.currency_code"+
				  ",'RMB' currency_code"+
				  //",tks.supplier_code"+
				  ",'' supplier_code"+
				  ",tkc.cust_code"+
				  ",tkc.dept_code"+
				  ",tkc.sales_code"+
				  ",round(ooa.UNIT_SELLING_PRICE*ooa.ordered_quantity,2) amount"+ 
				  ",round(ooa.UNIT_SELLING_PRICE*ooa.ordered_quantity*tkcr.tax_rate,2) tax_amount"+
				  ",ooa.K3_ADDR_CODE"+   
				  ",ooa.k3_order_no"+     
				  ",ooa.k3_order_line_no"+  
				  ",msi.segment1 item_no"+ 
				  ",trunc(ooa.creation_date) order_line_creation_date"+
				  ",trunc(ooa.last_update_date) order_line_last_update_date"+
				  ",case when ooa.ordered_quantity <> old_odr.ordered_quantity then 'QTY:'|| old_odr.ordered_quantity/case when ooa.ORDER_QUANTITY_UOM='PCE' THEN 1000 ELSE 1 END ||'K =>'||ooa.ordered_quantity/case when ooa.ORDER_QUANTITY_UOM='PCE' THEN 1000 ELSE 1 END||'K'||CHR(13)||CHR(10) ELSE '' END "+
                  //" || case when nvl(ooa.split_qty,0)>0 then 'QTY:'|| (nvl(ooa.split_qty,0)+ooa.ordered_quantity)/case when ooa.ORDER_QUANTITY_UOM='PCE' THEN 1000 ELSE 1 END ||'K =>'||ooa.ordered_quantity/case when ooa.ORDER_QUANTITY_UOM='PCE' THEN 1000 ELSE 1 END||'K'||CHR(13)||CHR(10) ELSE '' END "+
				  " || case when ooa.schedule_ship_date <> old_odr.schedule_ship_date then 'SSD:'|| TO_CHAR(old_odr.schedule_ship_date,'yyyymmdd') ||' =>'|| to_char(ooa.schedule_ship_date,'yyyymmdd')||CHR(13)||CHR(10) ELSE '' END"+
				  " || case when ooa.customer_line_number <> old_odr.customer_line_number then 'Cust PO:'||old_odr.customer_line_number||' =>'||ooa.customer_line_number||CHR(13)||CHR(10) ELSE '' END "+
				  " || case when ooa.cust_po_number <> old_odr.cust_po_number then 'Cust PO:'||old_odr.cust_po_number||' =>'||ooa.cust_po_number||CHR(13)||CHR(10) ELSE '' END  "+
				  " || case when trunc(ooa.header_creation_date) <> trunc(ooa.creation_date) and ooa.creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999 then 'New Line'||CHR(13)||CHR(10) ELSE '' END"+
                  " || case when nvl(ooa.end_customer_id,0) <> nvl(old_odr.end_customer_id,0) and old_odr.header_id is not null THEN  'End Cust:'|| nvl(old_odr.end_customer,'N/A') ||'=>'||NVL(NVL (ar1.customer_name_phonetic, ar1.customer_name),'N/A') ELSE '' END"+ //add by Peggy 20220120 end cust
                  " AS REVISE_REMARKS"+				  
				  " FROM (SELECT ooh.ORDER_NUMBER"+ 
                  "       ,ooh.header_id"+ 
                  "       ,ooh.ORDERED_DATE"+ 
                  "       ,replace(ooh.TRANSACTIONAL_CURR_CODE,'CNY','RMB') as TRANSACTIONAL_CURR_CODE"+
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
				  //"        else Tsc_Om_Get_Target_Price_0702(ool.ship_from_org_id,ool.inventory_item_id,ool.ORDER_QUANTITY_UOM,2142473,trunc(sysdate),'CNY',ool.packing_instructions,null) end UNIT_SELLING_PRICE"+
				  //"        else Tsc_Om_Get_Target_Price_0702(43,ool.inventory_item_id,ool.ORDER_QUANTITY_UOM,case when trunc(ool.pricing_date)>= to_date('20200301','yyyymmdd') then 30915 else 2142473 end, case when trunc(ool.pricing_date)>= to_date('20200301','yyyymmdd') then trunc(ool.pricing_date) else to_date('20200229','yyyymmdd') end ,'CNY',ool.packing_instructions,null) end UNIT_SELLING_PRICE"+ //TP(USD) 每月依海關上旬匯率變動,modify by Peggy 20200301
				  "        else Tsc_Om_Get_Target_Price_0702(43,ool.inventory_item_id,ool.ORDER_QUANTITY_UOM,case when trunc(ooh.creation_date)>= to_date('20200301','yyyymmdd') then 30915 else 2142473 end, case when trunc(ooh.creation_date)>= to_date('20200301','yyyymmdd') then trunc(ooh.creation_date) else to_date('20200229','yyyymmdd') end ,'CNY',ool.packing_instructions,null) end UNIT_SELLING_PRICE"+ //抓訂單header cration date取價,modify by Peggy 20210204
                  "       ,ool.INVENTORY_ITEM_ID"+ 
                  "       ,ool.line_type_id  "+            
                  "       ,nvl(ool.payment_term_id,ooh.payment_term_id) payment_term_id"+ 
                  "       ,tkale.addr_code k3_addr_code"+ 
                  "       ,case when instr(ool.attribute3,'-')>0 then substr(ool.attribute3,1,instr(ool.attribute3,'-',-1)-1) else null end k3_order_no"+ 
                  "       ,case when instr(ool.attribute3,'-')>0 then substr(ool.attribute3,instr(ool.attribute3,'-',-1)+1) else null end k3_order_line_no"+ 
				  "       ,ool.creation_date"+
				  "       ,ool.last_update_date"+
				  "       ,ool.cust_po_number"+
				  "       ,ool.ORDER_QUANTITY_UOM"+
				  "       ,ooh.attribute1"+
				  "       ,ooh.creation_date header_creation_date"+
				  "       ,ooh.version_number"+
				  "       ,(select sum(x.ORDERED_QUANTITY)  from oe_order_lines_all x where x.header_id=ooh.header_id and x.line_number=ool.line_number and x.shipment_number>ool.shipment_number) split_qty"+
                  "       FROM  oe_order_headers_all ooh"+ 
                  "       ,oe_order_lines_all ool "+ 
                  "       ,hz_cust_site_uses_all hcsua"+ 
                  "       ,(select * from oraddman.tscc_k3_addr_link_erp where active_flag='A') tkale"+ 
                  "       WHERE ooh.HEADER_ID=ool.HEADER_ID "+ 
				  "       AND NVL(ooh.booked_flag,'N')='Y'"+
                  "       AND ool.PACKING_INSTRUCTIONS='T'"+ 
                  "       AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017')"+ 
                  "       AND ool.INVENTORY_ITEM_ID not in  (29570,29562,29560)"+ 
                  "       AND ooh.org_id IN (41,906)"+ 
                  "       AND ool.ship_to_org_id=hcsua.site_use_id  "+           
				  "       AND hcsua.location=tkale.sg_ship_to_location_id(+)"+ 
				  "       AND ool.ship_from_org_id in (907,908)"+ //modify by Peggy 20200331
                  //"       AND not exists (select 1 from ont.oe_order_headers_all sgh where sgh.org_id<>906 and substr(sgh.order_number,1,4) in ('1121','1131','1141') and sgh.order_number=ooh.order_number and sgh.org_id=ooh.org_id )"+
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
				  //"     ,(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkce"+
				  "     ,oraddman.tscc_k3_cust_link_erp tkce"+  //add by Peggy 20230621
				  "     ,oraddman.tscc_k3_cust tkc"+
				  "     ,oraddman.tscc_k3_supplier tks"+
				  "     ,oraddman.tscc_k3_curr tkcr"+
				  //"     ,(SELECT reodr.* FROM (SELECT a.* ,row_number() over (partition by a.line_id order by a.version_number desc) row_seq  FROM ont.oe_order_lines_history a "+
				  //"       WHERE a.hist_creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999) reodr  where reodr.row_seq=1) old_odr"+
				  "     ,(SELECT a.*,(select nvl(x.customer_name_phonetic, x.customer_name) from ar_customers x where x.customer_id=a.end_customer_id) end_customer"+
				  "      FROM (select x.*,row_number() over (partition by x.header_id,x.line_id,x.version_number order by x.hist_creation_date,decode(x.hist_type_code,'SPLIT',1,2)) same_line_seq from ont.oe_order_lines_history x) a"+
				  "     ,(select header_id ,min(version_number) version_number from ont.oe_order_header_history "+
                  "      WHERE hist_creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999 group by header_id) b"+
                  "      where a.header_id=b.header_id and a.version_number=b.version_number and a.same_line_seq=1) old_odr"+  //modify by Peggy 20201112
				  " WHERE ooa.SALESREP_ID = jrs.SALESREP_ID(+)"+
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
				  " AND ooa.LINE_ID=old_odr.LINE_ID(+)"+
				  //" AND ooa.order_number in ( '11420028414','11420028783')"+
				  " AND ("+
				  "  ("+
				  //"   (ooa.ordered_quantity <> NVL(old_odr.ordered_quantity,0) OR ooa.schedule_ship_date <> NVL(old_odr.schedule_ship_date,TO_DATE('20010101','YYYYMMDD')) OR ooa.customer_line_number <> nvl(old_odr.customer_line_number,'') OR ooa.cust_po_number <> nvl(old_odr.cust_po_number,'')"+
				  //"     OR (ooa.shipment_number>1 AND (ooa.creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999 or ooa.ordered_quantity <> nvl(old_odr.ordered_quantity,0) OR ooa.schedule_ship_date <> nvl(old_odr.schedule_ship_date,to_date('20010101','yyyymmdd')) OR ooa.customer_line_number <> nvl(old_odr.customer_line_number,'') OR ooa.cust_po_number <> nvl(old_odr.cust_po_number,'')))"+
				  "   (ooa.ordered_quantity <> NVL(old_odr.ordered_quantity,ooa.ordered_quantity) OR ooa.schedule_ship_date <> NVL(old_odr.schedule_ship_date,ooa.schedule_ship_date) OR ooa.customer_line_number <> nvl(old_odr.customer_line_number,ooa.customer_line_number) OR ooa.cust_po_number <> nvl(old_odr.cust_po_number,ooa.cust_po_number) OR (NVL(ooa.end_customer_id,0) <> NVL(old_odr.end_customer_id,0) and old_odr.header_id is not null)"+ //add end cust by Peggy 20220120,modify by Peggy 20200714
				  "     OR (ooa.shipment_number>1 AND (ooa.creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999 or ooa.ordered_quantity <> nvl(old_odr.ordered_quantity,ooa.ordered_quantity) OR ooa.schedule_ship_date <> nvl(old_odr.schedule_ship_date,ooa.schedule_ship_date) OR ooa.customer_line_number <> nvl(old_odr.customer_line_number,ooa.customer_line_number) OR ooa.cust_po_number <> nvl(old_odr.cust_po_number,ooa.cust_po_number) OR (NVL(ooa.end_customer_id,0) <> NVL(old_odr.end_customer_id,0) and old_odr.header_id is not null)))"+ //add end cust by Peggy 20220120,modify by Peggy 20200714
				  "   )"+
				  "   AND ooa.last_update_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999"+
				  "  )"+
				  " OR (ooa.shipment_number=1 AND ooa.creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999)"+
				  " OR (EXISTS (SELECT 1 FROM ONT.OE_ORDER_LINES_ALL onx where onx.creation_date between TO_DATE('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd')+0.99999 and onx.shipment_number>1 and onx.line_number=ooa.line_number and onx.header_id=ooa.header_id))"+ //split line也要顯示,add by Peggy 20180607
				  " )"+
			      " AND ooa.booked_date < TO_DATE('"+EDATE+"','yyyymmdd')"+
				  //" AND (ooa.booked_date <= TO_DATE('"+EDATE+"','yyyymmdd')+0.99999 and ooa.version_number<>0)"+ //modify by Peggy 20200429,for 11410126050 issue
                  " order by 2,3,4";	
			//out.println(sql);	
		}
		else if (i==3)
		{
			sql =" select '' k3_order_no, "+
                 " '' k3_order_line_no,"+
                 " nvl(ar.CUSTOMER_NAME_PHONETIC,ar.customer_name) customer,"+
                 " tkcr.currency_code as TRANSACTIONAL_CURR_CODE,"+
                 //" upper(Tsc_Intercompany_Pkg.get_sales_group(odr.header_id)) sales_group,"+
				 " upper(TSC_OM_Get_Sales_Group(odr.header_id)) sales_group,"+
                 //" case when odr.ORDER_NUMBER is null then '' else odr.ORDER_NUMBER||'-' end || a.segment1 ORDER_NUMBER,"+
                 //" e.line_num ||'.'||b.SHIPMENT_NUM line_no,"+
				 //" case when substr(odr.order_number,1,1)='8' and odr.attribute1='Opening Order' then odr.line_no else  e.line_num||'.'||b.shipment_num end  as line_no,"+
				 //" case when odr.ORDER_NUMBER is null then '' else odr.ORDER_NUMBER||'-' end || a.segment1 || case when trunc(e.creation_date)>=to_date('20201012','yyyymmdd') then '-'||e.line_num||'.'||b.SHIPMENT_NUM else '' end ORDER_NUMBER,"+ //add by Peggy 20200928
				 " case when odr.ORDER_NUMBER is null  or trunc(e.creation_date)>= to_date('20211001','yyyymmdd') then '' else odr.ORDER_NUMBER||'-' end || a.segment1 || case when trunc(e.creation_date)>=to_date('20201012','yyyymmdd') then '-'||e.line_num||'.'||b.SHIPMENT_NUM else '' end ORDER_NUMBER,"+ //add by Peggy 20210927
                 " case when substr(odr.order_number,1,1)='8' and odr.attribute1='Opening Order' then odr.line_no else case when trunc(e.creation_date)>=to_date('20201012','yyyymmdd') then '1.1' else e.line_num ||'.'||b.SHIPMENT_NUM end end line_no,"+  //add by Peggy 20200928
				 " case when trunc(b.PROMISED_DATE)<trunc(a.creation_date) then to_char(b.PROMISED_DATE,'yyyy/mm/dd') else to_char(a.creation_date,'yyyy/mm/dd') end ordered_date,"+
                 " TSC_GET_REMARK_DESC(odr.HEADER_ID,'SHIPPING MARKS') mark_desc,"+
                 //" case when odr.ORDER_NUMBER is null then 'FORECAST' else odr.CUSTOMER_LINE_NUMBER end customer_po,"+
				 " case when odr.ORDER_NUMBER is null then 'FORECAST' else case when trunc(e.creation_date)>= to_date('20211001','yyyymmdd') then nvl(odr.ORDER_NUMBER,'') else odr.CUSTOMER_LINE_NUMBER end end customer_po,"+  //202110月起,po放銷售訂單號 add by Peggy 20210927
                 " msi.segment1 item_no,"+
                 " msi.description,  "+
                 " odr.CUST_ITEM,"+
				 " case when nvl(a.CANCEL_FLAG,' ')='Y' or nvl(e.CANCEL_FLAG,' ')='Y' then b.QUANTITY-b.QUANTITY_CANCELLED"+
                 " else b.quantity end * case  b.unit_meas_lookup_code when 'KPC' then 1000 else 1 end as ordered_quantity,"+
                 " e.unit_price/case e.unit_meas_lookup_code when 'KPC' then 1000 else 1 end  UNIT_SELLING_PRICE,"+
                 " to_char(b.NEED_BY_DATE,'yyyy/mm/dd') REQUEST_DATE,"+
                 " to_char(b.PROMISED_DATE,'yyyy/mm/dd') SCHEDULE_SHIP_DATE,"+
                 " tkc.cust_code,"+
                 " tkc.dept_code,"+
                 " tkc.sales_code,"+
                 " odr.k3_addr_code,"+
                 " tks.supplier_code,"+
                 " (SELECT meaning  FROM FND_LOOKUP_VALUES_VL x WHERE x.LOOKUP_TYPE='SHIP_METHOD' and x.lookup_code=nvl(odr.SHIPPING_METHOD_CODE,'TRUCK')) SHIP_METHOD,"+
                 " 'T' PACKING_INSTRUCTIONS,"+
                 " TERM.NAME,"+
                 " odr.fob_point,"+
                 " null END_CUSTOMER,"+
                 " a.AUTHORIZATION_STATUS FLOW_STATUS_CODE,"+
                 " Replace(Replace(TSC_GET_REMARK(odr.HEADER_ID,'SHIPPING MARKS'),chr(10), chr(32)),chr(13),chr(32))  SHIPMARKS,"+
                 " nvl(odr.SHIP_TO_ORG_ID,null) SHIP_TO_ORG_ID,"+
                 " '' END_CUSTOMER_NUMBER,"+
                 " CASE WHEN substr(odr.order_number,2,3) ='121' then qq.SAMPLE_SPQ ELSE SPQ end spq,"+
                 " qq.moq,"+
                 " tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) as TSC_PROD_GROUP,"+
                 " tsc_inv_category(msi.inventory_item_id,msi.organization_id,21) as TSC_FAMILY,"+
                 " tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000004) as TSC_PROD_FAMILY,"+
                 " tsc_inv_category(msi.inventory_item_id,msi.organization_id,23) as TSC_Package, "+     
                 " addr.address1,"+
                 " substr(ott.NAME,instr(ott.NAME,'_')+1,length(ott.name)) as line_type,"+
                 " '' yew_group,"+
                 " '' factory_totw_date,"+
				 " TO_CHAR(tkcr.tax_rate) tax_rate,"+
                 " round((case when nvl(a.CANCEL_FLAG,' ')='Y' or nvl(e.CANCEL_FLAG,' ')='Y' then b.QUANTITY-b.QUANTITY_CANCELLED "+
                 " else b.quantity end) * e.unit_price,2) amount,"+
                 " round((case when nvl(a.CANCEL_FLAG,' ')='Y' or nvl(e.CANCEL_FLAG,' ')='Y' then b.QUANTITY-b.QUANTITY_CANCELLED "+
                 " else b.quantity end) * e.unit_price * tkcr.tax_rate,2) tax_amount,"+
				 //" case when nvl(a.CANCEL_FLAG,' ')='Y' or nvl(e.CANCEL_FLAG,' ')='Y' then 'Qty:'||(b.QUANTITY/case when b.UNIT_MEAS_LOOKUP_CODE='PCE' then 1000 else 1 end)||'K=>'|| ((b.QUANTITY-b.QUANTITY_CANCELLED)/case when b.UNIT_MEAS_LOOKUP_CODE='PCE' then 1000 else 1 end)||'K' else '' end  REVISE_REMARKS"+
                 " case when e.quantity <>his.quantity then 'Qty:'||(his.quantity/case when his.UNIT_MEAS_LOOKUP_CODE='PCE' then 1000 else 1 end)||'K=>'|| e.quantity/case when e.UNIT_MEAS_LOOKUP_CODE='PCE' then 1000 else 1 end||'K' else '' end"+
                 " ||case when e.unit_price<>his.unit_price then 'Price:'|| his.unit_price||'=>'||e.unit_price else '' end "+
                 " ||case when trunc(b.need_by_date)<>trunc(his.need_by_date) then 'Need by Date:'||to_char(his.need_by_date,'yyyymmdd')||'=>'||to_char(b.need_by_date,'yyyymmdd') ELSE '' END REVISE_REMARKS"+
                 " from  po_headers_all a"+
                 "       ,po_line_locations_all b "+
                 "       ,ap_suppliers c"+
                 "       ,ap_supplier_sites_all d"+
                 "       ,po_lines_all e"+
                 //"       ,po_distributions_all f"+  //modify by Peggy 20200911
                 "       ,(select * from inv.mtl_system_items_b where organization_id=49) msi "+
                 //"       ,(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkce"+
				 "       ,oraddman.tscc_k3_cust_link_erp tkce"+  //add by Peggy 20230621
                 "       ,oraddman.tscc_k3_cust tkc"+
                 "       ,oraddman.tscc_k3_supplier tks"+
                 "       ,(select * from oraddman.tscc_k3_curr where ERP_ORDER_CODE='8') tkcr"+
                 "       ,AR_CUSTOMERS ar"+
                 "       ,(select * from ra_terms_tl where language='US') term"+
                 "       ,(SELECT * FROM OE_TRANSACTION_TYPES_TL WHERE LANGUAGE ='US') ott"+
                 "       ,(TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',msi.attribute3))) qq"+
                 "       ,(select hcsu.site_use_id,hl.address1  from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
                 "        where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
                 "        and hcas.party_site_id = hps.party_site_id  "+
                 "        and hps.location_id =hl.location_id "+
                 "        and hcsu.site_use_code = 'SHIP_TO'"+
                 "        and hcsu.status = 'A') addr"+
                 "        ,(select to_char(ooh.ORDER_NUMBER) ORDER_NUMBER"+
                 "        ,ooh.header_id"+
                 "        ,DECODE(ool.ITEM_IDENTIFIER_TYPE,'CUST',ool.ORDERED_ITEM,'') CUST_ITEM"+
                 "        ,ool.line_number||'.'|| ool.shipment_number line_no"+
                 "        ,ooh.sold_to_org_id"+
                 "        ,ooh.ORDERED_DATE"+
                 "        ,trunc(ool.REQUEST_DATE) REQUEST_DATE"+
                 "        ,ool.line_type_id "+   
                 "        ,ooh.ORDER_NUMBER || '.'|| ool.line_number order_line_no"+
                 "        ,ool.payment_term_id"+
                 "        ,nvl(ool.FOB_POINT_CODE,ooh.FOB_POINT_CODE) fob_point"+
                 "        ,ool.SHIP_TO_ORG_ID"+
                 "        ,tkale.addr_code k3_addr_code"+
                 "        ,ool.CUSTOMER_LINE_NUMBER"+
                 "        ,ool.SHIPPING_METHOD_CODE"+
				 "        ,ool.attribute3 k3_po"+
				 //"        ,ooh.attribute1"+
				 "        ,case when substr(ooh.order_number,1,1)=8 and trunc(ooh.creation_date)=to_date('20200122','YYYYMMDD') then 'Opening Order' else ooh.attribute1 end attribute1  "+//attribute1值跑掉,modify by Peggy 20200310
                 "        FROM  oe_order_headers_all ooh"+
                 "        ,oe_order_lines_all ool "+
                 "        ,hz_cust_site_uses_all hcsua"+
                 "        ,(select * from oraddman.tscc_k3_addr_link_erp where active_flag='A') tkale"+
                 "        where ooh.org_id IN (41,906) "+
                 "        and ooh.HEADER_ID=ool.HEADER_ID "+
                 "        and ool.SHIPMENT_NUMBER=1"+
                 "        and ool.ship_to_org_id=hcsua.site_use_id  "+
                 "        and hcsua.location=tkale.sg_ship_to_location_id(+)"+
                 "        and ool.PACKING_INSTRUCTIONS='T'"+ 
				 "        and ool.ship_from_org_id in (907,908)"+ //modify by Peggy 20200331
                 //"        and not exists (select 1 from ont.oe_order_headers_all sgh where sgh.org_id<>906 and substr(sgh.order_number,1,4) in ('1121','1131','1141') and sgh.order_number=ooh.order_number and sgh.org_id=ooh.org_id )"+//20200226 修正錯誤 by Peggy
                 "        ) odr"+
				 "        ,(select his.* from ("+
                 //"        SELECT x.segment1,y.line_num,y.unit_price,y.quantity,y.unit_meas_lookup_code,z.need_by_date,y.po_line_id,z.line_location_id,x.revision_num,row_number() over (partition by y.po_line_id order by x.revision_num desc) revision_dense_rank"+
		         "        SELECT x.segment1,y.line_num,y.unit_price,y.quantity,y.unit_meas_lookup_code,z.need_by_date,y.po_line_id,z.line_location_id,x.revision_num,row_number() over (partition by y.po_line_id,nvl(z.line_location_id,0) order by x.revision_num desc) revision_dense_rank"+	//partition by add line_location_id	for 62022120018 line 3 issue by Peggy 20230111		 
                 "        FROM po.po_headers_archive_all x,po.po_lines_archive_all y,po.po_line_locations_archive_all z"+
                 "        where  x.org_id=906"+
                 "        AND x.po_header_id=y.po_header_id"+
                 "        AND x.revision_num=y.revision_num"+
                 "        AND y.po_line_id=z.po_line_id"+
                 "        and y.revision_num=z.revision_num"+
                 "        AND exists (SELECT distinct min_revision_num,po_header_id,po_line_id"+
                 "        from (SELECT min(phaa.revision_num) min_revision_num,phaa.po_header_id,plaa.po_line_id"+
                 "        ,(select count(1) from po.po_headers_archive_all x where x.org_id=phaa.org_id and x.po_header_id=phaa.po_header_id and trunc(x.approved_date) < greatest(phaa.APPROVED_DATE,nvl(phaa.revised_date,to_date('20010101','yyyymmdd')))) version_cnt"+
                 "        FROM po.po_headers_archive_all phaa,po.po_lines_archive_all plaa"+
                 "        WHERE phaa.AUTHORIZATION_STATUS='APPROVED'"+
                 "        AND phaa.po_header_id=plaa.po_header_id"+
                 "        AND phaa.revision_num=plaa.revision_num"+
                 "        AND phaa.org_id=906"+
                 "        AND greatest(phaa.APPROVED_DATE,nvl(phaa.revised_date,to_date('20010101','yyyymmdd'))) BETWEEN TO_DATE('"+SDATE+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?SDATE:EDATE)+"','yyyymmdd')+0.99999"+
                 "        group by  greatest(phaa.APPROVED_DATE,nvl(phaa.revised_date,to_date('20010101','yyyymmdd'))),phaa.po_header_id,plaa.po_line_id"+
                 "        ) tt where version_cnt>0 and tt.po_header_id=y.po_header_id and tt.po_line_id=y.po_line_id and tt.min_revision_num>y.revision_num)) his"+
                 "        where  revision_dense_rank=1) his"+
                 "        where e.po_line_id=b.po_line_id"+
                 "        and a.vendor_site_id=d.vendor_site_id"+
				 //"        and (a.creation_date <> to_date('20200122','yyyymmdd') and nvl(a.CANCEL_FLAG,' ')<>'Y')"+
				 "        and a.creation_date <> to_date('20200122','yyyymmdd')"+  //moidfy by Peggy 20210517
                 "        and d.vendor_id=c.vendor_id"+
                 "        and a.po_header_id=e.po_header_id"+
                 //"        and b.line_location_id=f.line_location_id"+  //modify by Peggy 20200911
                 "        and a.org_id=906"+
                 "        and b.note_to_receiver=odr.order_line_no(+)"+
                 "        and e.item_id=msi.inventory_item_id"+
                 "        and case when  b.note_to_receiver is null or substr(b.note_to_receiver,1,1)<>'8' then case b.ship_to_organization_id when 907 then 14980 when 908 then 20100 else 0 end  else odr.sold_to_org_id end =ar.customer_id"+
                 "        and ar.customer_number=tkce.erp_cust_number(+)"+
                 "        and tkce.cust_code=tkc.cust_code(+)"+
                 "        and c.segment1 =tks.erp_vendor_code(+)"+
                 "        and odr.payment_term_id =term.term_id(+)"+
                 "        and odr.line_type_id= ott.transaction_type_id(+)"+
                 "        and odr.ship_to_org_id=addr.site_use_id(+)"+
				 //"        and (nvl(a.CANCEL_FLAG,' ')='Y' or nvl(e.CANCEL_FLAG,' ')='Y')"+
				 //"        and a.AUTHORIZATION_STATUS in ('APPROVED','CANCELLED')"+
                 //"        and e.last_update_date > (select max(action_date) from po.po_action_history pahx where pahx.object_id=a.po_header_id  and pahx.object_revision_num<a.REVISION_NUM)"+
				 //"        and ((a.REVISION_NUM>0  and a.last_update_date BETWEEN TO_DATE('"+SDATE+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?SDATE:EDATE)+"','yyyymmdd')+0.99999)"+
				 //"            or exists (select 1 from po.po_action_history  pah where pah.object_id=a.po_header_id and pah.object_revision_num>0 and pah.action_code='APPROVE' "+
				 //"                      and pah.action_date  BETWEEN TO_DATE('"+SDATE+"','yyyymmdd')  AND TO_DATE('"+ (EDATE.equals("")?SDATE:EDATE)+"','yyyymmdd')+0.99999) "+
				 //"        )"+
                 "        and b.line_location_id=his.line_location_id"+
                 "        and (e.quantity <>his.quantity or e.unit_price<>his.unit_price or trunc(b.need_by_date)<>trunc(his.need_by_date))"+
                 "        order by  a.segment1,e.line_num,b.note_to_receiver";
			//out.println(sql);
		}
		//Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); 
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);		
		//if (rs.isBeforeFirst() ==false) rs.beforeFirst();
		while (rs.next()) 
		{ 	
			col=0;
			//K3銷售單號
			ws.addCell(new jxl.write.Label(col, row, "",ALeftL));
			col++;					
			//行號
			ws.addCell(new jxl.write.Label(col, row, "",ALeftL));
			col++;					
			//Customer
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER") , ALeftL));
			col++;	
			//幣別
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("TRANSACTIONAL_CURR_CODE")==null?"":rs.getString("TRANSACTIONAL_CURR_CODE")) , ALeftL));
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
			//優先送貨地址代碼
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
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
			//工廠回T出貨日,add by Peggy 20160805
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
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("REVISE_REMARKS")==null?"":rs.getString("REVISE_REMARKS")) , ALeftL));
			col++;	
			row++;				
			reccnt ++;
		}
		rs.close();
		statement.close();			
		//if (reccnt>0) sheetcnt++;
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
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
			}
			else
			{
				remarks="";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sunny@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("casey@ts-china.com.cn"));
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
			
			message.setHeader("Subject", MimeUtility.encodeText("TSCC內外銷訂單異動明細"+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")"+remarks, "UTF-8", null));				
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
