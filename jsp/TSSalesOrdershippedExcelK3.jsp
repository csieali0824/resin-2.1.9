<!--20170829 Peggy,蘇州/上海/深圳業務單位變更郵件domain由mail.tew.com.cn改為ts-china.com.cn-->
<!--20171226 Peggy,4121訂單link K3客戶固定為(001.0323)上海瀚科國際貿易有限公司-->
<!--20180718 Peggy,數量加總,lot只顯示其中一筆 for ccyang issue-->
<!--20190531 Peggy,新增客戶品號 for ccyang issue-->
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
<FORM ACTION="../jsp/TSSalesOrdershippedExcelK3.jsp" METHOD="post" name="MYFORM">
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE=SDATE;
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
String UserName = request.getParameter("UserName");
if (UserName==null) UserName="";
String UserRoles =request.getParameter("UserRoles");
if (UserRoles==null) UserRoles="";
String FileName="",RPTName="",PLANTNAME="",sql="",ERP_USERID="",remarks="",price_show="N";
int fontsize=8,colcnt=0,sheetcnt=0;
String v_yew_order="YEW出入庫",v_tsc_order="TSC出入庫";
String v_yew_order_s="YEW出入庫-合併版",v_tsc_order_s="TSC出入庫-合併版";
String v_sg_received="SG入庫",v_sg_shipped="SG出庫";
String v_sg_allocated="SG內外銷調撥"; //add by Peggy 20200604
String v_sg_resell="1151轉賣"; //add by Peggy 20221209
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TSCC Shipped List";
	FileName = RPTName+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//WritableSheet ws = wwb.createSheet(RPTName, 0); 
	wwb.createSheet(v_yew_order, 0);
	wwb.createSheet(v_tsc_order, 1);
	wwb.createSheet(v_yew_order_s, 2);    //add by Pggy 20180718
	wwb.createSheet(v_tsc_order_s, 3);    //add by Pggy 20180718
	wwb.createSheet(v_sg_received, 4);    //add by Pggy 20191219
	wwb.createSheet(v_sg_shipped, 5);     //add by Pggy 20191219
	wwb.createSheet(v_sg_allocated, 6);   //add by Pggy 20200604
	wwb.createSheet(v_sg_resell, 7);      //add by Pggy 20221209
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
	//for (int i =4 ; i < 5 ; i++)
	//for (int i =0 ; i < 2; i++)
	{	
		reccnt=0;col=0;row=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings sst = ws.getSettings(); 
		sst.setSelected();
		sst.setVerticalFreeze(1);  //凍結窗格
		//for (int g =1 ; g <=8 ;g++ )
		//{
		//	sst.setHorizontalFreeze(g);
		//}	
		if (i ==6)
		{
			//物料代碼
			ws.addCell(new jxl.write.Label(col, row, "物料代碼" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
			
			//批號
			ws.addCell(new jxl.write.Label(col, row, "批號" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;	
	
			//D/C
			ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//轉出倉庫
			ws.addCell(new jxl.write.Label(col, row, "轉出倉庫" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;
			
			//轉出K3倉位
			ws.addCell(new jxl.write.Label(col, row, "轉出K3倉位" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;

			//轉入倉庫
			ws.addCell(new jxl.write.Label(col, row, "轉入倉庫" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;
			
			//轉入K3倉位
			ws.addCell(new jxl.write.Label(col, row, "轉入K3倉位" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;
	
			//數量
			ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//備註
			ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;				
		
		}
		else
		{
			//序號
			ws.addCell(new jxl.write.Label(col, row, "序號" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;					
	
			//出貨日期
			ws.addCell(new jxl.write.Label(col, row, "出貨日期" , ACenterBL));
			ws.setColumnView(col,14);	
			col++;					
				
			//客戶
			ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
						
			//PO#
			ws.addCell(new jxl.write.Label(col, row, "PO#" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;	
	
			//MO#
			ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//物料代碼
			ws.addCell(new jxl.write.Label(col, row, "物料代碼" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
	
			//數量
			ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//運輸方式
			ws.addCell(new jxl.write.Label(col, row, "運輸方式" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
	
			//運單號
			ws.addCell(new jxl.write.Label(col, row, "運單號" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
			
			//送貨單號(delivery note)
			ws.addCell(new jxl.write.Label(col, row, "送貨單號(delivery note)" , ACenterBL));
			ws.setColumnView(col,18);	
			col++;
			
			//備註
			ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBL));
			ws.setColumnView(col,15);
			col++;
						
			//供應商K3代碼
			ws.addCell(new jxl.write.Label(col, row, "供應商K3代碼" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;				
			
			//批號
			ws.addCell(new jxl.write.Label(col, row, "批號" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;	
	
			//D/C
			ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
						
			//收貨倉庫K3Code
			ws.addCell(new jxl.write.Label(col, row, "收貨倉庫K3Code" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;
			
			//發貨倉庫K3Code
			ws.addCell(new jxl.write.Label(col, row, "發貨倉庫K3Code" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;
	
			//原始訂單line#
			ws.addCell(new jxl.write.Label(col, row, "原始訂單line#" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;
					
			//客戶名稱
			ws.addCell(new jxl.write.Label(col, row, "客戶名稱" , ACenterBL));
			ws.setColumnView(col,30);	
			col++;
	
			//K3倉位代碼
			ws.addCell(new jxl.write.Label(col, row, "K3倉位代碼" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;
	
			//if (sheetname[i].indexOf("合併")<0)
			//{
				//客戶品號
				ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBL));
				ws.setColumnView(col,20);	
				col++;
			//}
			//優先送貨地址代碼
			ws.addCell(new jxl.write.Label(col, row, "優先送貨地址代碼" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;
			
			if (i<=3 || i==5)
			{
				//出貨地址,只顯示在SG出庫,add by Peggy 20200302
				ws.addCell(new jxl.write.Label(col, row, "出貨地址" , ACenterBL));
				ws.setColumnView(col,50);	
				col++;
				
				if (i==5)
				{
					//原始入庫K3倉位代碼
					ws.addCell(new jxl.write.Label(col, row, "原始入庫K3倉位代碼" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
				}			
			}
		}
		row++;
			
		if (i<=3) 
		{			
			//out.println(sheetname[i]);
			sql = " SELECT '' as \"序號\","+
				  " to_char(ooa.actual_shipment_date,'yyyy/mm/dd') as \"出貨日期\","+
				  " ooa.end_customer_id,"+
				  " nvl(tkcl.cust_code,'') as \"客戶\","+
				  " nvl(ooa.customer_line_number,ooa.cust_po_number) as \"PO#\","+
				  " ooa.packing_instructions,"+
				  " ooa.order_number as \"MO#\","+
				  " ooa.header_id,"+
				  " ooa.line_id,"+
				  " msi.description as \"物料代碼\","+
				  " ooa.shipping_quantity,"+
				  " sum( pkg.quantity) over (partition by ooa.header_id,ooa.line_id) tot_lot_qty,"+
				  " pkg.quantity as  \"數量\","+
				  " osmv.meaning as \"運輸方式\","+
				  " '' as \"運單號\","+
				  " pkg.packing_no as \"送貨單號(delivery note)\","+
				  " '' as \"備註\","+
				  " k3s.supplier_code as \"供應商K3代碼\","+
				  " pkg.lot_number as \"批號\","+
				  " pkg.datecode ||'-'||to_char(ooa.actual_shipment_date+1,'yyyymmdd') as \"D/C\","+
				  " '' as \"收貨倉庫K3Code\","+
				  " '' as \"發貨倉庫K3Code\","+
				  " ooa.line_number||'.'||ooa.shipment_number  as \"原始訂單line#\","+
				  " tkc.cust_name as \"客戶名稱\","+
				  " row_number() over (partition by ooa.header_id,ooa.line_id order by pkg.lot_number ) line_seq"+ //add by Peggy 20180718
				  " ,ooa.cust_item"+ //add by Peggy 20190531
				  " ,ooa.K3_ADDR_CODE"+ //add by Peggy 20190625
				  //" FROM ont.oe_order_headers_all ooh"+
				  //",ont.oe_order_lines_all ool"+
				  ",pkg.datecode"+  //add by Peggy 20200707
				  ",ooa.ship_to_addr"+
				  " FROM (SELECT ooh.order_number"+
				  "       ,ooh.header_id"+
				  "       ,ooh.sold_to_org_id"+
				  "       ,ool.line_id"+
				  "       ,ool.actual_shipment_date"+
				  "       ,ool.end_customer_id"+
				  "       ,ool.customer_line_number"+
				  "       ,ool.cust_po_number"+
				  "       ,ool.packing_instructions"+
				  "       ,ool.shipping_quantity"+
				  "       ,ool.line_number"+
				  "       ,ool.shipment_number"+
				  "       ,ool.ship_from_org_id"+
				  "       ,ool.inventory_item_id"+
				  "       ,ool.shipping_method_code"+
				  "       ,decode(ool.item_identifier_type,'CUST',ool.ordered_item,'') cust_item"+
				  "       ,tkale.addr_code K3_ADDR_CODE"+
				  "       ,(select  loc.ADDRESS1 from hz_cust_site_uses_all a,HZ_CUST_ACCT_SITES_ALL b, hz_party_sites party_site, hz_locations loc"+
                  "         where  a.cust_acct_site_id = b.cust_acct_site_id"+
                  "         and b.party_site_id = party_site.party_site_id"+
                  "         and loc.location_id = party_site.location_id "+
                  "         and a.site_use_id=ool.ship_to_org_id) ship_to_addr"+				  
				  "       FROM  oe_order_headers_all ooh"+
				  "       ,oe_order_lines_all ool "+
				  "       ,hz_cust_site_uses_all hcsua"+
				  "       ,(select * from oraddman.tscc_k3_addr_link_erp where active_flag='Y') tkale"+
				  "       WHERE ooh.HEADER_ID=ool.HEADER_ID "+
				  "       AND ooh.sold_to_org_id in (14980,15540)"+
				  "       AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017') "+
				  "       AND substr(ooh.order_number,2,2) <>'19'"+
				  "       AND ool.ship_to_org_id=hcsua.site_use_id"+              //add by Peggy 20190625
				  "       AND hcsua.location=to_char(tkale.erp_ship_to_location_id(+))"+   //add by Peggy 20190625
				  "       ) ooa"+			  
				  ",ar_customers ac"+
				  ",inv.mtl_system_items_b msi"+
				  ",(select a.packing_no,a.order_number,a.order_header_id,a.order_line_id,a.cust_po_number,a.quantity,a.lot_data lot_number,a.rc_datecode datecode,a.SHIP_TRANSACTION_NAME dn_name from tsc_packing_lines a,tsc_packing_headers b where b.SHIPPING_DATE between to_date('"+SDATE+"','yyyymmdd')-90 and to_date('"+(!EDATE.equals("") && !EDATE.equals(SDATE)?EDATE:SDATE)+"','yyyymmdd')+30+0.99999 and a.packing_no=b.packing_no and nvl(b.status,0)>=40"+ //增加status>=40判斷,add by Peggy 20201116
				  " union all"+
				  " select packing_no,order_number,order_header_id,order_line_id,'' cust_po_number,quantity,lot_data lot_number,rc_datecode datecode,SHIP_TRANSACTION_NAME dn_name from "+
				  " (SELECT a.carton_no,a.packing_no,a.item_description,a.item_description_cust,a.order_number, a.order_line_id, a.inventory_item_id,a.lot_data,a.attribute6,a.attribute1, a.attribute2, a.attribute3, a.attribute4,"+
				  " a.attribute9, a.attribute10, a.standard_carton, a.standard_nw_kg, a.standard_gw_kg,a.cust_lot_no,a.rc_datecode,a.standard_outline,a.tsc_cube, a.ship_transaction_name, a.quantity, a.order_header_id FROM tsc_t_packing_l_fairchild a,tsc_triangle_packing_headers b where b.SHIPPING_DATE between to_date('"+SDATE+"','yyyymmdd')-90 and to_date('"+(!EDATE.equals("") && !EDATE.equals(SDATE)?EDATE:SDATE)+"','yyyymmdd')+30+0.99999 and a.packing_no=b.packing_no and nvl(b.status,0)>=40"+ //增加status>=40判斷,add by Peggy 20201116
				  ")) pkg"+  //packing程式有bug,資料會重複寫入,用group by去除重複資料,add by Peggy 20180502
				  ",oraddman.tscc_k3_supplier k3s"+
				  ",oe_ship_methods_v osmv"+
				  //",oraddman.tscc_k3_cust_link_erp tkcl"+
				  ",(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkcl"+
				  ",oraddman.tscc_k3_cust tkc"+
				  //--" WHERE ooh.header_id=ool.header_id"+
				  //--" AND ooh.sold_to_org_id in (14980,15540)"+
				  //--" AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017') "+
				  //--" AND substr(ooh.order_number,2,2) <>'19'"+
				  " WHERE 1=1"+
				  //" and ool.end_customer_id=ac.customer_id(+)"+
				  " AND case when substr(ooa.order_number,1,4) in ('4121') then ooa.sold_to_org_id else ooa.end_customer_id end=ac.customer_id(+)"+  //4121 訂單依header customer id link k3客戶,add by Peggy 20171226
				  " AND ac.customer_number= tkcl.erp_cust_number(+)"+
				  " AND tkcl.cust_code=tkc.cust_code(+)"+
				  " AND ooa.ship_from_org_id=msi.organization_id(+)"+
				  " AND ooa.inventory_item_id=msi.inventory_item_id(+)"+
				  " AND ooa.header_id=pkg.order_header_id(+)"+
				  " AND ooa.line_id=pkg.order_line_id(+)"+
				  " AND substr(ooa.order_number,1,1)=k3s.erp_order_code(+)"+
				  " AND exists (select wnd.initial_pickup_date,wnd.name dn_name,wdd.source_header_id,wdd.source_line_id,wdd.lot_number"+
				  "            from  wsh.wsh_new_deliveries wnd,"+
				  "            wsh.wsh_delivery_assignments wda,"+
				  "            wsh.wsh_delivery_details wdd"+
				  "            where wnd.status_code='CL' "+
				  "            and wnd.itinerary_complete='Y'"+
				  "            and wnd.delivery_id=wda.delivery_id"+
				  "            and wda.delivery_detail_id=wdd.delivery_detail_id"+
				  "            and wnd.CONFIRM_DATE between to_date('"+SDATE+"','yyyymmdd') AND to_date('"+(!EDATE.equals("") && !EDATE.equals(SDATE)?EDATE:SDATE)+"','yyyymmdd')+0.99999"+
				  "            and ooa.header_id=wdd.source_header_id"+
				  "            and ooa.line_id=wdd.source_line_id)"+
				  " AND osmv.lookup_type = 'SHIP_METHOD'";
			if (UserRoles.indexOf("admin")<0)
			{
				sql += " AND exists (select 1 from (SELECT tog.group_name "+
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
						 //" AND c.username='"+UserName+"') x where x.group_name=Tsc_Intercompany_Pkg.get_sales_group(ooa.header_id))";	
						 " AND c.username='"+UserName+"') x where x.group_name=TSC_OM_Get_Sales_Group(ooa.header_id))";	
			}
				  
			if (sheetname[i].toUpperCase().indexOf("YEW")>=0)
			{			  
				//sql += " AND ooa.packing_instructions ='Y'";
				sql += " AND (ooa.packing_instructions ='Y' and pkg.packing_no not like 'T-%')"; //for slow moving issue by Peggy 20231107
				
			}
			else
			{
				//sql += " AND ooa.packing_instructions <>'Y'";
				sql += " AND (ooa.packing_instructions <>'Y' or pkg.packing_no like 'T-%')";   //for slow moving issue by Peggy 20231107
			}
			sql+= " AND osmv.lookup_code = ooa.shipping_method_code"+
			      " order by pkg.packing_no,ooa.order_number"; 
			
			if (sheetname[i].indexOf("合併")>=0)
			{
				sql = "select * from ("+sql+") x WHERE LINE_SEQ=1";
			}
			//out.println(sql);
		}
		else if (i==4)
		{
			sql = " SELECT '' as \"序號\","+
                  " to_char(MIN(rv.transaction_date),'yyyy/mm/dd') as \"出貨日期\","+
                  " '' end_customer_id,"+
                  " tkcl.cust_code as \"客戶\","+
                  //"  nvl(odr.CUSTOMER_PO,'Forecast') as \"PO#\","+
				  " case when trunc(e.creation_date)>= to_date('20211001','yyyymmdd') then nvl(odr.ORDER_NUMBER,'') else nvl(odr.CUSTOMER_PO,'Forecast') end as \"PO#\","+ //add by Peggy 20210927
                  " 'T' packing_instructions,"+
				  //" case when odr.order_number is null then '' else odr.order_number ||'-' end ||a.segment1 as \"MO#\","+
			 	  //" case when odr.ORDER_NUMBER is null then '' else odr.ORDER_NUMBER||'-' end || a.segment1 || case when trunc(e.creation_date)>=to_date('20201012','yyyymmdd') then '-'||e.line_num||'.'||b.SHIPMENT_NUM else '' end as \"MO#\","+ //add by Peggy 20200928
				  " case when odr.ORDER_NUMBER is null or trunc(e.creation_date)>= to_date('20211001','yyyymmdd') then '' else odr.ORDER_NUMBER||'-' end || a.segment1 || case when trunc(e.creation_date)>=to_date('20201012','yyyymmdd') then '-'||e.line_num||'.'||b.SHIPMENT_NUM else '' end as \"MO#\","+ //add by Peggy 20210927
                  " msi.description as \"物料代碼\","+
                  " SUM(CASE WHEN mmt.transaction_uom = 'KPC' THEN 1000 ELSE 1 END * mtln.transaction_quantity) shipping_quantity,"+
                  " SUM(CASE WHEN mmt.transaction_uom = 'KPC' THEN 1000 ELSE 1 END * mtln.transaction_quantity) tot_lot_qty,"+
                  " SUM(CASE WHEN mmt.transaction_uom = 'KPC' THEN 1000 ELSE 1 END * mtln.transaction_quantity) as  \"數量\","+
                  " nvl(odr.shipping_method_name,'TRUCK') as \"運輸方式\","+
                  " '' as \"運單號\","+
                  " rsh.receipt_num as \"送貨單號(delivery note)\","+
                  " '' as \"備註\","+
                  " k3s.supplier_code as \"供應商K3代碼\","+
                  " mtln.lot_number as \"批號\","+
                  " mtln.date_code as \"D/C\","+
                  //" case when substr(odr.order_number,1,1)='8' then '001.016' else '001.017' end as \"收貨倉庫K3Code\","+
				  " case  b.SHIP_TO_ORGANIZATION_ID when 907 then '001.016' when 908 then '001.017' else '' end as \"收貨倉庫K3Code\","+ //add by Peggy 20200313 
                  " '' as \"發貨倉庫K3Code\","+
				  //" case when odr.order_number is not null and substr(odr.order_number,1,1)='8' and odr.attribute1='Opening Order' then odr.line_no else  e.line_num||'.'||b.shipment_num end  as \"原始訂單line#\","+
				  " case when odr.order_number is not null and substr(odr.order_number,1,1)='8' and odr.attribute1='Opening Order' then odr.line_no else "+
				  " case when trunc(e.creation_date)>=to_date('20201012','yyyymmdd') then '1.1' else  e.line_num||'.'||b.shipment_num end end  as \"原始訂單line#\","+  //add by Peggy 20200928
                  " tkc.cust_name as \"客戶名稱\","+
                  " 0 line_seq,"+
                  " odr.cust_item,"+
                  " odr.K3_ADDR_CODE,"+
                  " a.comments,"+
                  " SUBSTR (b.note_to_receiver, 1, INSTR (b.note_to_receiver, '.') - 1) so_no,"+
                  " SUBSTR (b.note_to_receiver, INSTR (b.note_to_receiver, '.') + 1) so_line_no,"+
                  " a.segment1 po_no,"+
                  " e.note_to_vendor,"+
                  " b.note_to_receiver,"+
                  " e.attribute5 line_attribute5"+
                  " FROM po_headers_all a,"+
                  " po_line_locations_all b,"+
                  " ap_suppliers c,"+
                  " ap_supplier_sites_all d,"+
                  " po_lines_all e,"+
                  " rcv_shipment_headers rsh,"+
                  " rcv_shipment_lines rsl,"+
                  " rcv_transactions rv,"+
                  " mtl_material_transactions mmt,"+
                  " mtl_transaction_lot_numbers mtln,"+
                  " inv.mtl_system_items_b msi,"+
                  " ar_customers ac,"+
                  " oraddman.tscc_k3_supplier k3s,"+
                  " (select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkcl,"+
                  " oraddman.tscc_k3_cust tkc,"+
                  " (select to_char(ooh.ORDER_NUMBER) ORDER_NUMBER"+
                  ",DECODE(ool.ITEM_IDENTIFIER_TYPE,'CUST',ool.ORDERED_ITEM,'') CUST_ITEM"+
                  ",ooh.sold_to_org_id"+
                  ",ooh.ORDER_NUMBER || '.'|| ool.line_number order_line_no"+
				  ",ool.line_number||'.'||ool.shipment_number line_no"+
                  ",tkale.addr_code k3_addr_code"+
                  ",nvl(ool.customer_line_number,ool.cust_po_number) CUSTOMER_PO"+
                  ",ool.end_customer_id"+
                  ",osmv.meaning shipping_method_name"+
				  ",case when substr(ooh.order_number,1,1)=8 and trunc(ooh.creation_date)=to_date('20200122','YYYYMMDD') then 'Opening Order' else ooh.attribute1 end attribute1  "+//attribute1值跑掉,modify by Peggy 20200310
                  " FROM  oe_order_headers_all ooh"+
                  ",oe_order_lines_all ool "+
                  ",hz_cust_site_uses_all hcsua"+
                  ",(select * from oraddman.tscc_k3_addr_link_erp where active_flag='A') tkale"+
                  ",(select * from oe_ship_methods_v where lookup_type = 'SHIP_METHOD') osmv"+
                  " where ooh.org_id IN (41,906) "+
                  " and ooh.HEADER_ID=ool.HEADER_ID"+ 
                  " and ool.SHIPMENT_NUMBER=1"+
                  " and ool.ship_to_org_id=hcsua.site_use_id "+
                  " and hcsua.location=to_char(tkale.sg_ship_to_location_id(+))"+
                  " and ool.shipping_method_code=osmv.lookup_code(+)"+
				  " and ool.ship_from_org_id in (907,908)"+ //modify by Peggy 20200331
                  //" and not exists (select 1 from ont.oe_order_headers_all sgh where sgh.org_id=906 and ooh.org_id<>906 and sgh.order_number=ooh.order_number)"+
                  //" and not exists (select 1 from ont.oe_order_headers_all sgh where sgh.org_id<>906 and substr(sgh.order_number,1,4) in ('1121','1131','1141') and sgh.order_number=ooh.order_number and sgh.org_id=ooh.org_id )"+ //20200226 修正錯誤 by Peggy
                  " ) odr"+
                  " WHERE rv.transaction_date >= TO_DATE ('20200101', 'YYYYMMDD')"+
                  " AND e.po_line_id = b.po_line_id"+
                  " AND a.vendor_site_id = d.vendor_site_id"+
                  " AND d.vendor_id = c.vendor_id"+
                  " AND a.po_header_id = e.po_header_id"+
                  " AND b.line_location_id = rsl.po_line_location_id"+
                  " AND rsl.shipment_header_id = rsh.shipment_header_id"+
                  " AND rsl.shipment_line_id = rv.shipment_line_id"+
                  " AND a.org_id = 906"+
                  " AND rv.transaction_type IN ('DELIVER', 'RETURN TO RECEIVING')"+
                  " AND rv.transaction_id = mmt.rcv_transaction_id(+)"+
                  " AND mmt.transaction_id = mtln.transaction_id(+)"+
                  " AND rv.transaction_date between to_date('"+(SDATE.equals("20200220")?"20200215":SDATE)+"','yyyymmdd') AND to_date('"+(!EDATE.equals("") && !EDATE.equals((SDATE.equals("20200220")?"20200215":SDATE))?EDATE:(SDATE.equals("20200220")?"20200215":SDATE))+"','yyyymmdd')+0.99999"+
                  " AND b.note_to_receiver=odr.order_line_no(+)"+
                  " and e.item_id=msi.inventory_item_id"+
                  " and msi.organization_id=43"+
                  " and case when b.note_to_receiver is null or substr(b.note_to_receiver,1,1)<>'8' then case b.ship_to_organization_id when 907 then 14980 when 908 then 20100 else 0 end  else odr.sold_to_org_id end =ac.customer_id"+
                  " and ac.customer_number= tkcl.erp_cust_number(+)"+
                  " and tkcl.cust_code=tkc.cust_code(+)"+
                  " and c.segment1 = k3s.erp_vendor_code(+) "+
                  " GROUP BY a.comments,"+
                  " a.vendor_site_id,"+
                  " a.vendor_id,"+
                  " e.note_to_vendor,"+
                  " b.note_to_receiver,"+
                  " a.segment1,"+
                  " b.line_location_id,"+
                  " c.segment1,"+
                  " c.vendor_name,"+
                  " e.line_num,"+
                  " b.shipment_num,"+
                  " a.currency_code,"+
                  " e.unit_price,"+
                  " b.quantity,"+
                  " b.unit_meas_lookup_code,"+
                  " rsh.receipt_num,"+
                  " mtln.lot_number,"+
                  " mtln.date_code,"+
                  " e.attribute5,"+
                  " tkcl.cust_code,"+
                  " odr.CUSTOMER_PO,"+
                  " odr.order_number,"+
                  " msi.description,"+
                  " odr.shipping_method_name,"+
                  " k3s.supplier_code ,"+
                  " odr.cust_item,"+
                  " odr.K3_ADDR_CODE,"+
                  " tkc.cust_name,"+
                  " b.ship_to_organization_id,"+
				  " odr.line_no,"+
				  " odr.attribute1,"+
				  " trunc(e.creation_date)"+ //add by Peggy 20200928
                  " HAVING SUM (CASE WHEN mmt.transaction_uom = 'KPC' THEN 1000 ELSE 1 END * mtln.transaction_quantity) <> 0";				  
	 		//out.println(sql);
		}
		else if (i==5)
		{
			sql = " SELECT '' as \"序號\","+
				  " to_char(ooa.actual_shipment_date,'yyyy/mm/dd') as \"出貨日期\","+
				  " '' end_customer_id,"+
				  " tkcl.cust_code as \"客戶\","+
				  " nvl(ooa.customer_line_number,ooa.cust_po_number) as \"PO#\","+
				  " ooa.packing_instructions,"+
				  " ooa.order_number as \"MO#\","+
				  " ooa.header_id,"+
				  " ooa.line_id,"+
				  " msi.description as \"物料代碼\","+
				  " sum( pkg.SHIPPED_QTY) over (partition by ooa.header_id,ooa.line_id) shipping_quantity,"+
				  " sum( pkg.SHIPPED_QTY) over (partition by ooa.header_id,ooa.line_id) tot_lot_qty,"+
				  " pkg.SHIPPED_QTY as  \"數量\","+
				  " osmv.meaning as \"運輸方式\","+
				  " pkg.sg_delivery_no as \"運單號\","+
				  " pkg.DN_NAME as \"送貨單號(delivery note)\","+
				  " '' as \"備註\","+
				  " k3s.supplier_code as \"供應商K3代碼\","+
				  " pkg.lot_number as \"批號\","+
				  " pkg.date_code as \"D/C\","+
				  " '' as \"收貨倉庫K3Code\","+
				  " case when substr(ooa.order_number,1,1)='8' then '001.016' else '001.017' end as \"發貨倉庫K3Code\","+
				  " ooa.line_number||'.'||ooa.shipment_number as \"原始訂單line#\","+
				  " tkc.cust_name as \"客戶名稱\","+
				  " row_number() over (partition by ooa.header_id,ooa.line_id order by pkg.lot_number ) line_seq"+
				  " ,ooa.cust_item"+
				  " ,ooa.K3_ADDR_CODE"+ 
				  " ,ooa.ship_to_addr"+
				  " ,pkg.cust_code orig_demand_cust"+ //add by Peggy 20220818
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
				  "       ,ool.CUST_PO_NUMBER"+
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
				  "       ,decode(ool.item_identifier_type,'CUST',ool.ordered_item,'') cust_item"+
				  "       ,case when substr(ooh.order_number,1,1)=8 then  ool.UNIT_SELLING_PRICE"+
				  //"        else Tsc_Om_Get_Target_Price_0702(ool.ship_from_org_id,ool.inventory_item_id,ool.ORDER_QUANTITY_UOM,2142473,trunc(sysdate),'USD',ool.packing_instructions,null) end UNIT_SELLING_PRICE"+
				  "        else Tsc_Om_Get_Target_Price_0702(ool.ship_from_org_id,ool.inventory_item_id,ool.ORDER_QUANTITY_UOM,case when trunc(ool.pricing_date)>= to_date('20200301','yyyymmdd') then 30915 else 2142473 end,trunc(ool.pricing_date),'CNY',ool.packing_instructions,null) end UNIT_SELLING_PRICE"+ //TP(USD) 每月依海關上旬匯率變動,modify by Peggy 20200301
                  "       ,ool.INVENTORY_ITEM_ID"+ 
                  "       ,ool.line_type_id  "+            
                  "       ,nvl(ool.payment_term_id,ooh.payment_term_id) payment_term_id"+ 
                  "       ,tkale.addr_code k3_addr_code"+ 
				  "       ,ool.ship_from_org_id"+
				  "       ,ooh.attribute1"+
				  "       ,ool.actual_shipment_date"+
                  "       ,case when instr(ool.attribute3,'-')>0 then substr(ool.attribute3,1,instr(ool.attribute3,'-',-1)-1) else null end k3_order_no"+ 
                  "       ,case when instr(ool.attribute3,'-')>0 then substr(ool.attribute3,instr(ool.attribute3,'-',-1)+1) else null end k3_order_line_no"+ 
				  "       ,(select  loc.ADDRESS1 from hz_cust_site_uses_all a,HZ_CUST_ACCT_SITES_ALL b, hz_party_sites party_site, hz_locations loc"+
                  "         where  a.cust_acct_site_id = b.cust_acct_site_id"+
                  "         and b.party_site_id = party_site.party_site_id"+
                  "         and loc.location_id = party_site.location_id "+
                  "         and a.site_use_id=ool.ship_to_org_id) ship_to_addr"+
                  "       FROM  oe_order_headers_all ooh"+ 
                  "       ,oe_order_lines_all ool "+ 
                  "       ,hz_cust_site_uses_all hcsua"+ 
                  //"       ,(select * from oraddman.tscc_k3_addr_link_erp where active_flag='A') tkale"+ 
				  "       ,(SELECT * FROM (select A.*,ROW_NUMBER() OVER (PARTITION BY ERP_CUSTOMER_ID,SG_SHIP_TO_LOCATION_ID ORDER BY ADDR_CODE DESC) ROW_SEQ from oraddman.tscc_k3_addr_link_erp A where active_flag='A') WHERE ROW_SEQ=1) tkale"+ //FOR 上海禾馥多個終端客戶地址對應同一個ERP地址 MODIFY BY PEGGY 20230706
                  "       WHERE ooh.HEADER_ID=ool.HEADER_ID "+ 
                  "       AND ool.CANCELLED_FLAG != 'Y'"+ 
                  "       AND ool.PACKING_INSTRUCTIONS='T'"+ 
                  "       AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017')"+ 
                  "       AND ool.INVENTORY_ITEM_ID not in  (29570,29562,29560)"+ 
                  "       AND SUBSTR(ooh.ORDER_NUMBER,1,3) <>'819'  "+ 
                  "       AND ooh.org_id IN (41,906)"+ 
                  "       AND ool.ship_to_org_id=hcsua.site_use_id  "+  
				  "       AND hcsua.location=to_char(tkale.sg_ship_to_location_id(+))"+ 
				  "       AND ool.ship_from_org_id in (907,908)"+ //modify by Peggy 20200331
				  "       ) ooa"+
				  ",ar_customers ac"+
				  ",inv.mtl_system_items_b msi"+
				  ",oraddman.tscc_k3_supplier k3s"+
				  ",oe_ship_methods_v osmv"+
				  ",(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkcl"+
				  ",oraddman.tscc_k3_cust tkc"+
				  /*",(select wdd.source_header_id,wdd.source_line_id,wnd.initial_pickup_date,wnd.name dn_name,wdd.lot_number,wdd.attribute1 date_code,wdd.inventory_item_id,tad.sg_delivery_no,sum(case when wdd.REQUESTED_QUANTITY_UOM='KPC' then 1000 else 1 end*SHIPPED_QUANTITY) shipped_qty"+
				  "  ,(select distinct asp.segment1 "+
                  "    from tsc.tsc_advise_dn_line_int x,tsc.tsc_pick_confirm_lines y,oraddman.tssg_stock_overview z,ap_supplier_sites_all asa,ap_suppliers asp"+
                  "     where x.advise_line_id=y.advise_line_id"+
                  "     and x.delivery_name=wnd.name"+
                  "     and y.lot= wdd.lot_number"+
                  "     and y.sg_stock_id=z.sg_stock_id"+
                  //"     and z.vendor_site_id=asa.vendor_site_id"+
				  "     and DECODE(z.VENDOR_SITE_ID,1117980,1287968,1117981,1287969,z.VENDOR_SITE_ID) = asa.vendor_site_id"+ //中之轉先之科,modify by Peggy 20210823
                  "     and asa.vendor_id=asp.vendor_id) vendor_code "+				  
                  " from  wsh.wsh_new_deliveries wnd,"+
                  "       wsh.wsh_delivery_assignments wda,"+
                  "       wsh.wsh_delivery_details wdd"+
				  "       ,(select delivery_id,sg_delivery_no from tsc.tsc_advise_dn_header_int x,tsc.tsc_advise_dn_line_int y"+
                  "         where x.advise_header_id=y.advise_header_id and x.status='S' and y.sg_delivery_no is not null group by  delivery_id,sg_delivery_no) tad"+
                  "  where wnd.status_code='CL' "+
                  "  and wnd.itinerary_complete='Y'"+
                  "  and wnd.delivery_id=wda.delivery_id"+
				  "  and wnd.delivery_id=tad.delivery_id(+)"+
                  "  and wda.delivery_detail_id=wdd.delivery_detail_id"+
                  "  and wnd.CONFIRM_DATE between to_date('"+(SDATE.equals("20200220")?"20200215":SDATE)+"','yyyymmdd') AND to_date('"+(!EDATE.equals("") && !EDATE.equals((SDATE.equals("20200220")?"20200215":SDATE))?EDATE:(SDATE.equals("20200220")?"20200215":SDATE))+"','yyyymmdd')+0.99999"+
                  "  group by wdd.source_header_id,wdd.source_line_id,wnd.initial_pickup_date,wnd.name ,wdd.lot_number,wdd.attribute1,wdd.inventory_item_id,tad.sg_delivery_no) pkg"+*/
				  /*",(SELECT wnd.name DN_NAME,tadl.delivery_id,wdd.source_header_id,wdd.source_line_id,tadl.sg_delivery_no"+
                  " ,tpcl.lot lot_number,tpcl.date_code,sum(tpcl.qty) SHIPPED_QTY,asp.segment1 vendor_code,TKCL.cust_code"+
                  " FROM wsh.wsh_new_deliveries wnd"+
                  "     ,wsh.wsh_delivery_assignments wda"+
                  "     ,wsh.wsh_delivery_details wdd"+
                  "     ,tsc.tsc_advise_dn_header_int tadh"+
                  "     ,tsc.tsc_advise_dn_line_int tadl"+
                  "     ,tsc.tsc_pick_confirm_lines tpcl"+
                  "     ,oraddman.tssg_stock_overview tso"+
                  "     ,ap_supplier_sites_all asa"+
                  "     ,ap_suppliers asp"+
                  "     ,po.po_line_locations_all plla"+
                  "     ,(SELECT DISTINCT OOH.sold_to_org_id,OOH.ORDER_NUMBER||'.'||OOL.LINE_NUMBER NOTE_TO_RECEIVER"+
                  "       FROM ONT.OE_ORDER_HEADERS_ALL OOH"+
                  "           ,ONT.OE_ORDER_LINES_ALL OOL"+
                  "       WHERE OOH.ORG_ID IN (41,906) "+
                  "       AND OOL.SHIPMENT_NUMBER=1"+
                  "       AND OOL.SHIP_FROM_ORG_ID IN (907,908)"+
                  "       AND OOH.HEADER_ID=OOL.HEADER_ID) odr"+
                  "     ,AR_CUSTOMERS AC"+
                  "     ,(SELECT * FROM ORADDMAN.TSCC_K3_CUST_LINK_ERP WHERE ACTIVE_FLAG='A') TKCL"+
                  "  WHERE  wnd.status_code='CL' "+
                  "  AND wnd.itinerary_complete='Y'"+
                  "  AND wnd.delivery_id=wda.delivery_id"+
                  "  AND wda.delivery_detail_id=wdd.delivery_detail_id"+
                  "  and wnd.CONFIRM_DATE between to_date('"+(SDATE.equals("20200220")?"20200215":SDATE)+"','yyyymmdd') AND to_date('"+(!EDATE.equals("") && !EDATE.equals((SDATE.equals("20200220")?"20200215":SDATE))?EDATE:(SDATE.equals("20200220")?"20200215":SDATE))+"','yyyymmdd')+0.99999"+
                  "  AND tadh.advise_header_id=tadl.advise_header_id "+
                  "  AND tadh.status='S' "+
                  "  AND wnd.delivery_id=tadl.delivery_id"+
                  "  AND wdd.source_header_id=tadl.so_header_id"+
                  "  AND wdd.source_line_id=tadl.so_line_id"+
                  "  AND wdd.lot_number=tpcl.lot"+
                  "  AND tadl.advise_line_id=tpcl.advise_line_id"+
                  "  AND tpcl.sg_stock_id=tso.sg_stock_id"+
                  "  AND DECODE(tso.VENDOR_SITE_ID,1117980,1287968,1117981,1287969,tso.VENDOR_SITE_ID) = asa.vendor_site_id"+
                  "  AND asa.vendor_id=asp.vendor_id"+
                  "  AND tso.po_line_location_id=plla.line_location_id "+
                  "  AND case when plla.note_to_receiver is null or substr(plla.note_to_receiver,1,1)<>'8' then case plla.ship_to_organization_id when 907 then 14980 when 908 then 20100 else 0 end  else odr.sold_to_org_id end =ac.customer_id"+
                  "  and plla.note_to_receiver=odr.note_to_receiver(+)"+
                  "  AND AC.CUSTOMER_NUMBER=TKCL.ERP_CUST_NUMBER(+)"+
                  "  group by wnd.name,tadl.delivery_id,wdd.source_header_id,wdd.source_line_id,tadl.sg_delivery_no,tpcl.lot,tpcl.date_code,asp.segment1,TKCL.cust_code) pkg"+*/
                  ",(select pkg1.DN_NAME,pkg1.delivery_id,pkg1.source_header_id,pkg1.source_line_id,pkg1.sg_delivery_no"+
                  " ,pkg1.lot_number,pkg1.date_code,sum(pkg1.qty) shipped_qty ,pkg1.vendor_code,pkg1.cust_code from (SELECT wnd.name DN_NAME,tadl.delivery_id,wdd.source_header_id,wdd.source_line_id,tadl.sg_delivery_no"+
                  " ,tpcl.lot lot_number,tpcl.date_code,tpcl.qty ,asp.segment1 vendor_code"+
                  " ,case when tso.po_line_location_id is null and tso.allocate_in_qty>0 then '外銷轉內銷' else (select TKCL.cust_code from AR_CUSTOMERS AC ,(SELECT * FROM ORADDMAN.TSCC_K3_CUST_LINK_ERP WHERE ACTIVE_FLAG='A') TKCL"+
                  "  where  AC.CUSTOMER_NUMBER=TKCL.ERP_CUST_NUMBER(+) "+
                  "  and case when plla.note_to_receiver is null or substr(plla.note_to_receiver,1,1)<>'8' then case plla.ship_to_organization_id when 907 then 14980 when 908 then 20100 else 0 end  else odr.sold_to_org_id end =ac.customer_id) end cust_code"+
                  " FROM wsh.wsh_new_deliveries wnd"+
                  //"     ,wsh.wsh_delivery_assignments wda"+
                  //"     ,wsh.wsh_delivery_details wdd"+
				  "       ,(select x.delivery_id,y.source_header_id,y.source_line_id,y.lot_number from wsh.wsh_delivery_assignments x, wsh.wsh_delivery_details y where x.delivery_detail_id=y.delivery_detail_id group by x.delivery_id,y.source_header_id,y.source_line_id,y.lot_number) wdd"+ //for 20230214 lot:TSC61SL0C2V1222018 6k issue by Peggy 20230216
                  "     ,tsc.tsc_advise_dn_header_int tadh"+
                  "     ,tsc.tsc_advise_dn_line_int tadl"+
                  "     ,tsc.tsc_pick_confirm_lines tpcl"+
                  "     ,oraddman.tssg_stock_overview tso"+
                  "     ,ap_supplier_sites_all asa"+
                  "     ,ap_suppliers asp"+
                  "     ,po.po_line_locations_all plla"+
                  "     ,(SELECT DISTINCT OOH.sold_to_org_id,OOH.ORDER_NUMBER||'.'||OOL.LINE_NUMBER NOTE_TO_RECEIVER"+
                  "       FROM ONT.OE_ORDER_HEADERS_ALL OOH"+
                  "           ,ONT.OE_ORDER_LINES_ALL OOL"+
                  "       WHERE OOH.ORG_ID IN (41,906) "+
                  "       AND OOL.SHIPMENT_NUMBER=1"+
                  "       AND OOL.SHIP_FROM_ORG_ID IN (907,908)"+
                  "       AND OOH.HEADER_ID=OOL.HEADER_ID) odr"+
                  "  WHERE  wnd.status_code='CL' "+
                  "  AND wnd.itinerary_complete='Y'"+
                  //"  AND wnd.delivery_id=wda.delivery_id"+
                  //"  AND wda.delivery_detail_id=wdd.delivery_detail_id"+
				  "  AND wnd.delivery_id=wdd.delivery_id"+ //add by Peggy 20230215
                  "  and wnd.CONFIRM_DATE between to_date('"+(SDATE.equals("20200220")?"20200215":SDATE)+"','yyyymmdd') AND to_date('"+(!EDATE.equals("") && !EDATE.equals((SDATE.equals("20200220")?"20200215":SDATE))?EDATE:(SDATE.equals("20200220")?"20200215":SDATE))+"','yyyymmdd')+0.99999"+
                  "  AND tadh.advise_header_id=tadl.advise_header_id "+
                  "  AND tadh.status='S'"+ 
                  "  AND wnd.delivery_id=tadl.delivery_id"+
                  "  AND wdd.source_header_id=tadl.so_header_id"+
                  "  AND wdd.source_line_id=tadl.so_line_id"+
                  "  AND wdd.lot_number=tpcl.lot"+
                  "  AND tadl.advise_line_id=tpcl.advise_line_id"+
                  "  AND tpcl.sg_stock_id=tso.sg_stock_id"+
				  //"  AND tpcl.lot='TSC61SL0C2V1222018'"+
                  "  AND DECODE(tso.VENDOR_SITE_ID,1117980,1287968,1117981,1287969,tso.VENDOR_SITE_ID) = asa.vendor_site_id"+
                  "  AND asa.vendor_id=asp.vendor_id"+
                  "  AND tso.po_line_location_id=plla.line_location_id(+) "+
                  "  and plla.note_to_receiver=odr.note_to_receiver(+)) pkg1"+
                  " group by pkg1.DN_NAME,pkg1.delivery_id,pkg1.source_header_id,pkg1.source_line_id,pkg1.sg_delivery_no,pkg1.lot_number,pkg1.date_code ,pkg1.vendor_code,pkg1.cust_code) pkg"+
				  " WHERE  case when substr(ooa.order_number,1,1)<>'8' then 20100 else  ooa.sold_to_org_id end=ac.customer_id(+)"+
				  " AND ac.customer_number= tkcl.erp_cust_number(+)"+
				  " AND tkcl.cust_code=tkc.cust_code(+)"+
				  " AND ooa.ship_from_org_id=msi.organization_id(+)"+
				  " AND ooa.inventory_item_id=msi.inventory_item_id(+)"+
				  " AND pkg.vendor_code = k3s.erp_vendor_code(+)"+
				  " AND osmv.lookup_type = 'SHIP_METHOD'"+
                  " and ooa.header_id=pkg.source_header_id"+
                  " and ooa.line_id=pkg.source_line_id "+   
				  //" and pkg.DN_NAME='YS-20220570'"+               
			      " AND osmv.lookup_code = ooa.shipping_method_code";
	 		//out.println(sql);
		}
		else if (i==6)
		{
			sql =" select tso1.organization_id from_org_id"+
			     ",tso.organization_id to_org_id"+
				 ",tso.item_desc"+
				 ",tso.lot_number"+
				 ",tso.date_code"+
				 ",sum(nvl(tso.allocate_in_qty,0)) allocate_in_qty"+
                 ",case tso1.organization_id when 907 then '001.016' when 908 then '001.017' else '' end stock_out"+
                 ",tkcl1.cust_code stock_locator_out"+
                 ",case tso.organization_id when 907 then '001.016' when 908 then '001.017' else '' end stock_in"+
                 ",tkcl.cust_code stock_locator_in"+
                 ",case tso1.organization_id when 907 then '內銷' when 908 then '外銷' else '' end ||'庫存轉入'|| case tso.organization_id when 907 then '內銷' when 908 then '外銷' else '' end remarks"+
                 " from oraddman.tssg_stock_overview tso"+
				 ",ar_customers ac"+
				 ",(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkcl"+
                 ",oraddman.tssg_stock_overview tso1"+
				 ",ar_customers ac1"+
				 ",(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkcl1"+
                 " where tso.received_date between to_date('"+SDATE+"','yyyymmdd') AND to_date('"+(!EDATE.equals("") && !EDATE.equals(SDATE)?EDATE:SDATE)+"','yyyymmdd')+0.99999"+
                 " and case tso.organization_id when 907 then 14980 when 908 then 20100 else 0 end = ac.customer_id(+)"+
                 " and ac.customer_number= tkcl.erp_cust_number(+) "+
                 " and tso.from_sg_stock_id=tso1.sg_stock_id"+
				 " and tso.organization_id<>tso1.organization_id"+ //add by Peggy 20231226
                 " and nvl(tso.allocate_in_qty,0)>0"+
                 " and case tso1.organization_id when 907 then 14980 when 908 then 20100 else 0 end = ac1.customer_id(+)"+
                 " and ac1.customer_number= tkcl1.erp_cust_number(+) "+
                 " group by tso1.organization_id,tso.organization_id,tso.item_desc,tso.lot_number,tso.date_code,tkcl1.cust_code,tkcl.cust_code";
			//out.println(sql);
		}
		else if (i==7)
		{
			sql = " SELECT ac.customer_number,'' as \"序號\","+
                  " to_char(pkg.SHIPPING_DATE,'yyyy/mm/dd') as \"出貨日期\","+
                  " ooa.end_customer_id,"+
                  " nvl(tkcl.cust_code,'') as \"客戶\","+
                  " nvl(ooa.customer_line_number,ooa.cust_po_number) as \"PO#\","+
                  " ooa.packing_instructions,"+
                  " ooa.order_number as \"MO#\","+
                  " ooa.header_id,"+
                  " ooa.line_id,"+
                  " msi.description as \"物料代碼\","+
                  " ooa.shipping_quantity,"+
                  " sum( pkg.quantity) over (partition by ooa.header_id,ooa.line_id) tot_lot_qty,"+
                  " pkg.quantity as  \"數量\","+
                  " osmv.meaning as \"運輸方式\","+
                  " '' as \"運單號\","+
                  " pkg.packing_no as \"送貨單號(delivery note)\","+
                  " '' as \"備註\","+
                  " k3s.supplier_code as \"供應商K3代碼\","+
                  " pkg.lot_number as \"批號\","+
                  " pkg.datecode as \"D/C\","+
                  " '' as \"收貨倉庫K3Code\","+
                  " '' as \"發貨倉庫K3Code\","+
                  " ooa.line_number||'.'||ooa.shipment_number  as \"原始訂單line#\","+
                  " tkc.cust_name as \"客戶名稱\","+
                  " row_number() over (partition by ooa.header_id,ooa.line_id order by pkg.lot_number ) line_seq"+
                  " ,ooa.cust_item"+
                  " ,ooa.K3_ADDR_CODE"+
                  ",pkg.datecode"+
                  ",ooa.ship_to_addr"+
                  " FROM (SELECT ooh.order_number"+
                  "       ,ooh.header_id"+
                  "       ,ooh.sold_to_org_id"+
                  "       ,ool.line_id"+
                  "       ,ool.actual_shipment_date"+
                  "       ,ool.end_customer_id"+
                  "       ,ool.customer_line_number"+
                  "       ,ool.cust_po_number"+
                  "       ,ool.packing_instructions"+
                  "       ,ool.shipping_quantity"+
                  "       ,ool.line_number"+
                  "       ,ool.shipment_number"+
                  "       ,ool.ship_from_org_id"+
                  "       ,ool.inventory_item_id"+
                  "       ,ool.shipping_method_code"+
                  "       ,decode(ool.item_identifier_type,'CUST',ool.ordered_item,'') cust_item"+
                  "       ,tkale.addr_code K3_ADDR_CODE"+
                  "       ,(select  loc.ADDRESS1 from hz_cust_site_uses_all a,HZ_CUST_ACCT_SITES_ALL b, hz_party_sites party_site, hz_locations loc"+
                  "         where  a.cust_acct_site_id = b.cust_acct_site_id"+
                  "         and b.party_site_id = party_site.party_site_id"+
                  "         and loc.location_id = party_site.location_id "+
                  "         and a.site_use_id=ool.ship_to_org_id) ship_to_addr"+          
                  "       FROM  oe_order_headers_all ooh"+
                  "       ,oe_order_lines_all ool"+
                  "       ,hz_cust_site_uses_all hcsua"+
                  "       ,(select * from oraddman.tscc_k3_addr_link_erp where active_flag='Y') tkale"+
                  "       WHERE ooh.HEADER_ID=ool.HEADER_ID "+
                  "       AND ooh.sold_to_org_id in (14980,15540)"+
                  "       AND substr(ooh.order_number,1,4) ='1151'"+
                  "       AND ool.ship_to_org_id=hcsua.site_use_id"+
                  "       AND hcsua.location=to_char(tkale.erp_ship_to_location_id(+))"+
                  "       ) ooa "+       
                  ",ar_customers ac"+
                  ",inv.mtl_system_items_b msi"+
                  ",(select a.packing_no,a.order_number,a.order_header_id,a.order_line_id,a.cust_po_number,a.quantity,a.lot_data lot_number,a.rc_datecode datecode,a.SHIP_TRANSACTION_NAME dn_name,b.SHIPPING_DATE from tsc_packing_lines a,tsc_packing_headers b where b.SHIPPING_DATE between to_date('"+SDATE+"','yyyymmdd') and to_date('"+EDATE+"','yyyymmdd')+0.99999 and a.packing_no=b.packing_no and nvl(b.status,0)>=40) pkg"+
                  ",oraddman.tscc_k3_supplier k3s"+
                  ",oe_ship_methods_v osmv"+
                  ",(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkcl"+
                  ",oraddman.tscc_k3_cust tkc"+
                  " WHERE nvl(ooa.end_customer_id,ooa.sold_to_org_id)=ac.customer_id(+)"+
                  " AND ac.customer_number= tkcl.erp_cust_number(+)"+
                  " AND tkcl.cust_code=tkc.cust_code(+)"+
                  " AND ooa.ship_from_org_id=msi.organization_id(+)"+
                  " AND ooa.inventory_item_id=msi.inventory_item_id(+)"+
                  " AND ooa.header_id=pkg.order_header_id"+
                  " AND ooa.line_id=pkg.order_line_id"+
                  " AND substr(ooa.order_number,1,1)=k3s.erp_order_code(+)"+
                  " AND osmv.lookup_type = 'SHIP_METHOD'"+
                  " AND osmv.lookup_code = ooa.shipping_method_code"+
                  "  order by pkg.packing_no,ooa.order_number,to_number(ooa.line_number||'.'||ooa.shipment_number)";
			//out.println(sql);
		}
		
		//Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); 
		//out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);		
		//if (rs.isBeforeFirst() ==false) rs.beforeFirst();
		while (rs.next()) 
		{ 	
			col=0;
			if (i==6)
			{
				//物料代碼
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"), ALeftL));
				col++;	

				//批號
				ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER") ,ALeftL));  
				col++;
			
				//D/C
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("DATE_CODE")==null?"":rs.getString("DATE_CODE"))  , ALeftL));
				col++;

				//轉出倉庫
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("STOCK_OUT")==null?"":rs.getString("STOCK_OUT"))  , ALeftL));
				col++;

				//轉出倉位
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("STOCK_LOCATOR_OUT")==null?"":rs.getString("STOCK_LOCATOR_OUT"))  , ALeftL));
				col++;

				//轉入倉庫
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("STOCK_IN")==null?"":rs.getString("STOCK_IN"))  , ALeftL));
				col++;

				//轉入倉位
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("STOCK_LOCATOR_IN")==null?"":rs.getString("STOCK_LOCATOR_IN"))  , ALeftL));
				col++;
			
				//數量
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ALLOCATE_IN_QTY")).doubleValue(), ARightL));
				col++;	
				
				//備註
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("REMARKS")==null?"":rs.getString("REMARKS"))  , ALeftL));
				col++;

			
			}
			else
			{
				//序號
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("序號")==null?"":rs.getString("序號")),ALeftL));
				col++;					
				//出貨日期
				if (rs.getString("出貨日期")==null)
				{		
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("出貨日期")) ,DATE_FORMAT));
				}			
				col++;					
				//客戶
				ws.addCell(new jxl.write.Label(col, row, rs.getString("客戶") , ALeftL));
				col++;	
				//PO#
				ws.addCell(new jxl.write.Label(col, row, rs.getString("PO#") , ALeftL));
				col++;	
				//MO#
				ws.addCell(new jxl.write.Label(col, row, rs.getString("MO#") , ALeftL));
				col++;	
				//物料代碼
				ws.addCell(new jxl.write.Label(col, row, rs.getString("物料代碼"), ALeftL));
				col++;	
				//數量
				//if (rs.getString("數量")==null)
				if ((sheetname[i].indexOf("合併")>=0?rs.getString("TOT_LOT_QTY"):rs.getString("數量"))==null) //modify by Peggy 20180718
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					//ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("數量")).doubleValue(), ARightL));
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf((sheetname[i].indexOf("合併")>=0?rs.getString("TOT_LOT_QTY"):rs.getString("數量"))).doubleValue(), ARightL)); //modify by Peggy 20180718
				}
				col++;	
				//運輸方式
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("運輸方式")==null?"":rs.getString("運輸方式")) , ALeftL));
				col++;				
				//運單號
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("運單號")==null?"":rs.getString("運單號")) , ALeftL));
				col++;				
				//送貨單號(delivery note)
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("送貨單號(delivery note)")==null?"":rs.getString("送貨單號(delivery note)")) , ALeftL));
				col++;	
				//備註
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("備註")==null?"":rs.getString("備註")) ,ALeftL));
				col++;	
				//供應商K3代碼
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("供應商K3代碼")==null?"":rs.getString("供應商K3代碼"))  , ALeftL));
				col++;
				//批號
				//ws.addCell(new jxl.write.Label(col, row, (rs.getString("批號")==null?"":rs.getString("批號"))  ,ALeftL)); 
				//ws.addCell(new jxl.write.Label(col, row, (rs.getString("批號")==null?"":rs.getString("批號"))+(sheetname[i].indexOf("合併")>=0?"-"+rs.getString("客戶"):"")  ,ALeftL));  //modify by Peggy 20180718
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("批號")==null?"":rs.getString("批號"))+(sheetname[i].indexOf("合併")>=0?"-"+rs.getString("datecode"):"")  ,ALeftL));  //modify by Peggy 20200707
				col++;
				//D/C
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("D/C")==null?"":rs.getString("D/C"))  , ALeftL));
				col++;
				//收貨倉庫K3Code
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("收貨倉庫K3Code")==null?"":rs.getString("收貨倉庫K3Code"))  , ALeftL));
				col++;
				//發貨倉庫K3Code
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("發貨倉庫K3Code")==null?"":rs.getString("發貨倉庫K3Code"))  , ALeftL));
				col++;
				//原始訂單line#
				ws.addCell(new jxl.write.Label(col, row, rs.getString("原始訂單line#")  , ALeftL));
				col++;
				//客戶名稱
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("客戶名稱")==null?"":rs.getString("客戶名稱"))  , ALeftL));
				col++;
				//K3倉位代碼=客戶代碼,add by Peggy 20190403
				ws.addCell(new jxl.write.Label(col, row, rs.getString("客戶") , ALeftL));
				col++;
				//if (sheetname[i].indexOf("合併")<0)
				//{
					//客戶品號
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("cust_item")==null?"":rs.getString("cust_item")) , ALeftL));
					col++;					
				//}	
				//優先送貨地址代碼,add by Peggy 20190625
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("K3_ADDR_CODE")==null?"":rs.getString("K3_ADDR_CODE")) , ALeftL));
				col++;	
				
				if (i<=3 || i==5)
				{			
					//出貨地址,只顯示SG出庫,Add by Peggy 20200302
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIP_TO_ADDR")==null?"":rs.getString("SHIP_TO_ADDR")) , ALeftL));
					col++;	
					
					if (i==5)
					{
						//原始入庫K3倉位代碼=客戶代碼,add by Peggy 20220818
						ws.addCell(new jxl.write.Label(col, row, rs.getString("ORIG_DEMAND_CUST") , ALeftL));
						col++;
					}
				}
			}
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
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{
				remarks="";
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ccyang@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("mery_heng@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("casey@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn"));   //add by Peggy 20221019
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("coco_liu@ts-china.com.cn")); //add by Peggy 20221019
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
			message.setHeader("Subject", MimeUtility.encodeText("TSCC出入庫明細"+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")"+remarks, "UTF-8", null));				
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
try
{
	if (ACTTYPE.equals(""))
	{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/report/"+FileName; 
		response.sendRedirect(strURL);
	}
	else
	{
	%>
		<script>
			alert("The report has been successfully sent to your mailbox!!");
			window.location.replace("../jsp/TSSalesOrdershippedQueryK3.jsp");
		</script>
	<%
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
