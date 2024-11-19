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
<FORM ACTION="../jsp/TSCSGDomesticOrdershippedExcel.jsp" METHOD="post" name="MYFORM">
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
String UserName = request.getParameter("UserName");
if (UserName==null) UserName="";
String UserRoles =request.getParameter("UserRoles");
if (UserRoles==null) UserRoles="";
String FileName="",RPTName="",PLANTNAME="",sql="",ERP_USERID="",remarks="",price_show="N";
int fontsize=8,colcnt=0,sheetcnt=0;
String v_sg_shipped="SG內銷出貨";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "SG Domestic Shipped List";
	FileName = RPTName+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	wwb.createSheet(v_sg_shipped, 0);   
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
	for (int i =0 ; i < sheetname.length ; i++)
	{	
		reccnt=0;col=0;row=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings sst = ws.getSettings(); 
		sst.setSelected();
		sst.setVerticalFreeze(1);  //凍結窗格
		//出貨日期
		ws.addCell(new jxl.write.Label(col, row, "出貨日期" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;					
			
		//PO#
		ws.addCell(new jxl.write.Label(col, row, "PO#" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	

		//MO#
		ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;	
		
		//訂單line#
		ws.addCell(new jxl.write.Label(col, row, "line#" , ACenterBL));
		ws.setColumnView(col,8);	
		col++;

		//客戶名稱
		ws.addCell(new jxl.write.Label(col, row, "客戶名稱" , ACenterBL));
		ws.setColumnView(col,30);	
		col++;
					
		//物料代碼
		ws.addCell(new jxl.write.Label(col, row, "物料代碼" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;	

		//數量
		ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;	

		//運單號
		ws.addCell(new jxl.write.Label(col, row, "運單號" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	
		
		//送貨單號(delivery note)
		ws.addCell(new jxl.write.Label(col, row, "送貨單號(delivery note)" , ACenterBL));
		ws.setColumnView(col,18);	
		col++;
		
		//批號
		ws.addCell(new jxl.write.Label(col, row, "批號" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	

		//D/C
		ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;	
					

		//客戶品號
		ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;

		//出貨地址
		ws.addCell(new jxl.write.Label(col, row, "出貨地址" , ACenterBL));
		ws.setColumnView(col,80);	
		col++;
		row++;
			
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
			  "       ,(select * from oraddman.tscc_k3_addr_link_erp where active_flag='A') tkale"+ 
			  "       WHERE ooh.HEADER_ID=ool.HEADER_ID "+ 
			  "       AND ool.CANCELLED_FLAG != 'Y'"+ 
			  "       AND ool.PACKING_INSTRUCTIONS='T'"+ 
			  //"       AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017')"+ 
			  //"       AND ool.INVENTORY_ITEM_ID not in  (29570,29562,29560)"+ 
			  //"       AND SUBSTR(ooh.ORDER_NUMBER,1,3) <>'819'  "+ 
			  "       AND ooh.org_id IN (906)"+ 
			  "       AND ool.ship_from_org_id="+ORGCODE+""+
			  "       AND ool.ship_to_org_id=hcsua.site_use_id  "+  
			  "       AND hcsua.location=tkale.sg_ship_to_location_id(+)"+ 
			  //"       AND not exists (select 1 from ont.oe_order_headers_all sgh where sgh.org_id=906 and ooh.org_id<>906 and sgh.order_number=ooh.order_number)"+
			  //"       AND not exists (select 1 from ont.oe_order_headers_all sgh where sgh.org_id<>906 and substr(sgh.order_number,1,4) in ('1121','1131','1141') and sgh.order_number=ooh.order_number and sgh.org_id=ooh.org_id )"+ //20200226 修正錯誤 by Peggy
			  "       ) ooa"+
			  ",ar_customers ac"+
			  ",inv.mtl_system_items_b msi"+
			  ",oraddman.tscc_k3_supplier k3s"+
			  ",oe_ship_methods_v osmv"+
			  ",(select * from oraddman.tscc_k3_cust_link_erp where active_flag='A') tkcl"+
			  ",oraddman.tscc_k3_cust tkc"+
			  ",(select pac.*,mt.vendor_code "+
			  "   from "+
			  "         (select wdd.source_header_id,wdd.source_line_id,wnd.initial_pickup_date,wnd.name dn_name,wdd.lot_number,wdd.attribute1 date_code,wdd.inventory_item_id,tad.sg_delivery_no,sum(case when wdd.REQUESTED_QUANTITY_UOM='KPC' then 1000 else 1 end*SHIPPED_QUANTITY) shipped_qty"+
			  "         from  wsh.wsh_new_deliveries wnd,"+
			  "         wsh.wsh_delivery_assignments wda,"+
			  "         wsh.wsh_delivery_details wdd"+
			  "         ,(select delivery_id,sg_delivery_no from tsc.tsc_advise_dn_header_int x,tsc.tsc_advise_dn_line_int y"+
			  "           where x.advise_header_id=y.advise_header_id and x.status='S' and y.sg_delivery_no is not null group by  delivery_id,sg_delivery_no) tad"+
			  "         where wnd.status_code='CL' "+
			  "         and wnd.itinerary_complete='Y'"+
			  "         and wnd.delivery_id=wda.delivery_id"+
			  "         and wnd.delivery_id=tad.delivery_id(+)"+
			  "         and wda.delivery_detail_id=wdd.delivery_detail_id"+
			  "         and wnd.CONFIRM_DATE between to_date('"+SDATE+"','yyyymmdd') AND to_date('"+(!EDATE.equals("") && !EDATE.equals(SDATE)?EDATE:SDATE)+"','yyyymmdd')+0.99999"+
			  "         group by wdd.source_header_id,wdd.source_line_id,wnd.initial_pickup_date,wnd.name ,wdd.lot_number,wdd.attribute1,wdd.inventory_item_id,tad.sg_delivery_no) pac"+
			  //"         ,(SELECT distinct SHA.RECEIPT_NUM,MTLN.INVENTORY_ITEM_ID,MTLN.LOT_NUMBER,AP.SEGMENT1 VENDOR_CODE,PHA.SEGMENT1 PO_NO"+
			  "         ,(SELECT distinct MTLN.INVENTORY_ITEM_ID,MTLN.LOT_NUMBER,AP.SEGMENT1 VENDOR_CODE"+
			  "          FROM MTL_TRANSACTION_LOT_NUMBERS MTLN "+
			  "          ,MTL_MATERIAL_TRANSACTIONS MMT"+
			  "          ,PO.RCV_SHIPMENT_HEADERS SHA "+
			  "          ,(SELECT RTX.* FROM PO.RCV_TRANSACTIONS RTX WHERE NOT EXISTS (SELECT 1 FROM PO.RCV_TRANSACTIONS RTR WHERE RTR.TRANSACTION_TYPE LIKE 'RETURN%' AND RTR.PARENT_TRANSACTION_ID=RTX.TRANSACTION_ID)) RT"+
			  "           ,INV.MTL_PARAMETERS MP"+
			  "          ,PO.PO_HEADERS_ALL PHA,AP_SUPPLIERS AP"+
			  "          WHERE  MTLN.TRANSACTION_ID=MMT.TRANSACTION_ID"+
			  "          AND MMT.TRANSACTION_TYPE_ID IN (18,44)"+
			  "          AND MMT.ORGANIZATION_ID=MP.ORGANIZATION_Id"+
			  "          AND MP.ORGANIZATION_CODE LIKE 'SG%'"+
			  "          AND RT.SHIPMENT_HEADER_ID=SHA.SHIPMENT_HEADER_ID(+)"+
			  "          AND MMT.RCV_TRANSACTION_ID=RT.TRANSACTION_ID(+)"+
			  "          AND RT.PO_HEADER_ID=PHA.PO_HEADER_ID"+
			  "          AND PHA.VENDOR_ID=AP.VENDOR_ID) mt"+
			  "          WHERE pac.inventory_item_id=mt.inventory_item_id"+
			  "          AND pac.lot_number=mt.lot_number) pkg"+
			  " WHERE  case when substr(ooa.order_number,1,1)<>'8' then 20100 else  ooa.sold_to_org_id end=ac.customer_id(+)"+
			  " AND ac.customer_number= tkcl.erp_cust_number(+)"+
			  " AND tkcl.cust_code=tkc.cust_code(+)"+
			  " AND ooa.ship_from_org_id=msi.organization_id(+)"+
			  " AND ooa.inventory_item_id=msi.inventory_item_id(+)"+
			  " AND pkg.vendor_code = k3s.erp_vendor_code(+)"+
			  " AND osmv.lookup_type = 'SHIP_METHOD'"+
			  " and ooa.header_id=pkg.source_header_id"+
			  " and ooa.line_id=pkg.source_line_id "+                  
			  " AND osmv.lookup_code = ooa.shipping_method_code";
	 		//out.println(sql);
		//Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); 
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);		
		//if (rs.isBeforeFirst() ==false) rs.beforeFirst();
		while (rs.next()) 
		{ 	
			col=0;
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
			//PO#
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PO#") , ALeftL));
			col++;	
			//MO#
			ws.addCell(new jxl.write.Label(col, row, rs.getString("MO#") , ALeftL));
			col++;	
			//原始訂單line#
			ws.addCell(new jxl.write.Label(col, row, rs.getString("原始訂單line#")  , ALeftL));
			col++;
			//客戶名稱
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("客戶名稱")==null?"":rs.getString("客戶名稱"))  , ALeftL));
			col++;
			//物料代碼
			ws.addCell(new jxl.write.Label(col, row, rs.getString("物料代碼"), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("數量")).doubleValue(), ARightL)); 
			col++;	
			//運單號
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("運單號")==null?"":rs.getString("運單號")) , ALeftL));
			col++;				
			//送貨單號(delivery note)
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("送貨單號(delivery note)")==null?"":rs.getString("送貨單號(delivery note)")) , ALeftL));
			col++;	
			//批號
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("批號")==null?"":rs.getString("批號"))  ,ALeftL));  
			col++;
			//D/C
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("D/C")==null?"":rs.getString("D/C"))  , ALeftL));
			col++;
			//客戶品號
			ws.addCell(new jxl.write.Label(col, row, rs.getString("cust_item") , ALeftL));
			col++;					
			//出貨地址,只顯示SG出庫,Add by Peggy 20200302
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIP_TO_ADDR")==null?"":rs.getString("SHIP_TO_ADDR")) , ALeftL));
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
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{
				remarks="";
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kevin@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jason@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("flora_niu@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("joyce@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anna_qiu@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("winnie@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tina@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("chris_wen@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("william_wu@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sandy@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("demi_duan@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lisahou@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("john_wei@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jack_tang@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nina_zan@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("hongmei_li@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wendy_cai@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jodie@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Fiona_chen@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Regina_pu@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Sophia_li@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Sandy_sun@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-Sample@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS002@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS006@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS003@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS001@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS004@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS007@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs008@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs006@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs005@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("kelly@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("coco_liu@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("mery_heng@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("lily_yin@ts-china.com.cn"));				
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
			message.setHeader("Subject", MimeUtility.encodeText("SG內銷出貨明細"+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")"+remarks, "UTF-8", null));				
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
