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
<FORM ACTION="../jsp/TSCSGDeliveryOverviewExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",sqlx="",sqly="",where="",destination="";
String TSCPRODGROUP = request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP="";
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr="--";
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="--";
String DayFr=request.getParameter("DAYFR");
if (DayFr==null || DayFr.equals("--")) DayFr="01";
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo="--"; 
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="--";
String DayTo=request.getParameter("DAYTO");
if (DayTo==null || DayTo.equals("--")) DayTo=dateBean.getDayString();
String VENDOR = request.getParameter("VENDOR");
if (VENDOR ==null) VENDOR="";
String TSC_ITEM_DESC = request.getParameter("TSC_ITEM_DESC");
if (TSC_ITEM_DESC==null) TSC_ITEM_DESC="";

if (RTYPE.equals("AUTO"))
{
	sql = "select to_char(trunc(sysdate, 'D')-2,'yyyymmdd'),to_char(trunc(sysdate, 'D')+4,'yyyymmdd') from dual";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if (rs.next())
	{
		YearFr = rs.getString(1).substring(0,4);
		MonthFr = rs.getString(1).substring(4,6);
		DayFr =  rs.getString(1).substring(6,8);
		YearTo =  rs.getString(2).substring(0,4);
		MonthTo = rs.getString(2).substring(4,6);
		DayTo=rs.getString(2).substring(6,8);
	}
	rs.close();
	statement.close();
}

int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,line=0,mergeCol=0;
	String column1="",column2="",column3="",column4="",column5="",mo_CRD="",mo_QTY="",mo_PRICE="",mo_SSD="";
	OutputStream os = null;	
	RPTName = "SGOrderDeliveryDetail";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setVerticalFreeze(2);  //凍結窗格
	for (int g =1 ; g <=8 ;g++ )
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
	
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"906"); 
	cs1.execute();
	cs1.close();

	/*sql = " SELECT xx.advise_no"+
          ",tsc_inv_category(l.inventory_item_id,49,1100000003) AS TSC_PROD_GROUP"+
          ",CASE WHEN SUBSTR(H.ORDER_NUMBER,1,4) IN ('1121','1131','1141') AND L.PACKING_INSTRUCTIONS='T' THEN Tsc_Intercompany_Pkg.get_sales_group(H.HEADER_ID) WHEN SUBSTR(H.ORDER_NUMBER,1,1) IN ('8') THEN 'TSCC' ELSE Tsc_Intercompany_Pkg.get_sales_group(H.header_id) END SALES_GROUP"+
          ",RA.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME_PHONETIC"+
          //",lh.description SHIPPING_REMARK"+
		  ",TSC_GET_REMARK_DESC(H.HEADER_ID,'SHIPPING MARKS') SHIPPING_REMARK"+
          ",H.ORDER_NUMBER ORDER_NUMBER"+
          ",L.LINE_NUMBER||'.'||L.SHIPMENT_NUMBER LINE_NO"+
          ",M.DESCRIPTION ITEM_DESC"+
          ",DECODE(L.ITEM_IDENTIFIER_TYPE,'CUST',L.ORDERED_ITEM,'') CUST_ITEM"+
          ",nvl(l.customer_line_number,l.cust_po_number) cust_po_number"+
          ",xx.SHIPPED_QUANTITY/1000 lot_shipped_qty"+
          ",xx.UNIT_PRICE"+
          ",to_char(L.ACTUAL_SHIPMENT_DATE,'yyyy/mm/dd') AS ACTUAL_SHIPMENT_DATE"+
          ",TO_NUMBER(to_char(L.ACTUAL_SHIPMENT_DATE,'mm')) AS ACTUAL_SHIPMENT_MONTH"+
          ",xx.TO_TW"+
          ",lc.meaning shipping_method"+
          ",xx.VENDOR_SITE_CODE vendor_site_code"+
          ",xx.receipt_num"+
          ",xx.carton_list"+
          ",xx.lot"+
          ",xx.date_code"+
          ",xx.PO_NO PO_NO"+
          ",tsc_inv_category(l.inventory_item_id,49,23) AS TSC_PACKAGE"+
          ",tsc_inv_category(l.inventory_item_id,49,1100000004) AS TSC_PROD_FAMILY"+
          ",tsc_inv_category(l.inventory_item_id,49,21) AS TSC_FAMILY"+
          ",RA.ATTRIBUTE2 MARKET_GROUP"+
          ",mkg.LOV_MEANING MAKET_GROUP_NAME"+
          ",M.SEGMENT1 ITEM_NAME"+
          ",L.FLOW_STATUS_CODE"+
          ",xx.CURRENCY_CODE CURRENCY_CODE"+
          " FROM OE_ORDER_HEADERS_ALL H "+
          "     ,OE_ORDER_LINES_ALL L"+
          "     ,INV.MTL_SYSTEM_ITEMS_B M"+
          "     ,AR_CUSTOMERS RA"+
          "     ,(SELECT * FROM tsc_crm_lov_v tcl WHERE tcl.lov_type = 'MARKET_GROUPS' AND LOV_ENABLED_FLAG='Y') mkg"+
          "     ,(SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') lc"+
          //"     ,(SELECT llh.* from (SELECT y.description ,z.pk1_value,x.MEDIA_ID,row_number() over (partition by z.pk1_value order by x.MEDIA_ID) rec_seq from fnd_documents_tl y,fnd_attached_documents z ,fnd_documents x where x.DOCUMENT_ID=y.DOCUMENT_ID and y.language = 'US' AND x.DOCUMENT_ID=z.DOCUMENT_ID  and exists (select 1  from fnd_document_categories_tl r WHERE r.USER_NAME='SHIPPING MARKS' AND r.LANGUAGE='US' and r.category_id = x.category_id)) llh where llh.rec_seq=1) lh"+
          "     ,(select x.advise_no,x.receipt_num,x.SOURCE_LINE_ID,x.ORGANIZATION_ID,x.VENDOR_SITE_CODE,x.PO_NO,x.lot,x.date_code,x.carton_list,x.UNIT_PRICE,x.CURRENCY_CODE,x.TO_TW,sum(qty) SHIPPED_QUANTITY"+
          "       from (select g.advise_no,rsh.receipt_num,g.so_line_id SOURCE_LINE_ID,a.organization_id,g.qty,d.segment1 po_no,f.vendor_site_code,g.lot,g.date_code,g.TO_TW,g.carton_list"+
		  //"           ,decode(e.UNIT_MEAS_LOOKUP_CODE,'KPC',e.unit_price/1000,e.unit_price) unit_price"+
		  "           ,e.unit_price"+ 
		  "           ,d.currency_code ,ROW_NUMBER() OVER (PARTITION BY g.so_line_id,a.ORGANIZATION_ID,a.LOT_NUMBER,g.carton_list ORDER BY A.CREATION_DATE) ROW_SEQ"+
          "             from inv.mtl_transaction_lot_numbers a"+
          "                 ,inv.mtl_material_transactions b"+
          "                 ,po.rcv_transactions c"+
          "                 ,po.po_headers_all d"+
          "                 ,po.po_lines_all e"+
          "                 ,ap.ap_supplier_sites_all f"+
          "                 ,po.rcv_shipment_headers rsh"+
          "                 ,(SELECT x.tew_advise_no advise_no,x.organization_id,inventory_item_id,so_line_id,lot,date_code,TO_TW"+
		  //"                  ,tssg_ship_pkg.get_order_carton_list ('ORDER_LINE',x.tew_advise_no,so_line_id,'0','0') carton_list"+
		  "                   ,tssg_ship_pkg.get_order_carton_list ('LOT',x.advise_line_id,x.so_header_id,x.tew_advise_no,x.lot) carton_list"+
		  "                  ,SUM (qty) qty  "+
		  "                    FROM tsc.tsc_pick_confirm_lines x, tsc.tsc_shipping_advise_headers y "+
		  "                    WHERE y.shipping_from like 'SG%' "+
		  "                    AND y.advise_header_id = x.advise_header_id "+
		  "                    GROUP BY x.advise_line_id,x.organization_id,x.so_header_id,x.inventory_item_id, x.so_line_id,x.lot,x.tew_advise_no,date_code,TO_TW) g"+
          "                    where a.TRANSACTION_ID=b.TRANSACTION_ID"+
          "                    and b.transaction_type_id=18"+
		  "                    and b.organization_id in (907,908)"+
          "                    and b.RCV_TRANSACTION_ID=c.TRANSACTION_ID(+)"+
          "                    and c.PO_HEADER_ID=d.PO_HEADER_ID(+) "+
          "                    and c.PO_LINE_ID=e.PO_LINE_ID(+) "+
          "                    and d.vendor_site_id=f.vendor_site_id(+) "+
          "                    and a.lot_number=g.lot"+
		  "                    and a.organization_id=g.organization_id"+ //add by Peggy 20200414
          "                    and g.inventory_item_id=a.inventory_item_id "+
          "                    and c.shipment_header_id=rsh.shipment_header_id"+
          "                   ) x "+
          "             where ROW_SEQ=1 "+
          "           group by x.advise_no,x.receipt_num,x.SOURCE_LINE_ID,x.ORGANIZATION_ID,x.VENDOR_SITE_CODE,x.PO_NO,x.UNIT_PRICE,x.CURRENCY_CODE,x.lot,x.date_code,x.carton_list,x.TO_TW) xx"+
          " WHERE H.HEADER_ID = L.HEADER_ID"+
          " AND L.INVENTORY_ITEM_ID = M.INVENTORY_ITEM_ID"+
          " AND H.ORG_ID IN (41,906)"+
          //" AND NOT EXISTS (SELECT 1 FROM ont.oe_order_headers_all sgh where sgh.org_id=906 and H.org_id<>906 and sgh.order_number=H.order_number)"+
		  //" AND NOT EXISTS (SELECT 1 FROM ont.oe_order_headers_all sgh WHERE sgh.org_id<>906 AND substr(sgh.order_number,1,4) IN ('1121','1131','1141') AND sgh.order_number=H.order_number AND sgh.org_id=H.org_id )"+
		  //" AND SUBSTR(H.ORDER_NUMBER,1,4) NOT IN ('1211','1215')"+
		  " AND L.ship_from_org_id in (907,908)"+
          " AND M.ORGANIZATION_ID = 43"+
          " AND H.SOLD_TO_ORG_ID = RA.CUSTOMER_ID"+
          " AND L.CANCELLED_FLAG != 'Y'"+
          " AND L.PACKING_INSTRUCTIONS='T'"+
          " AND l.line_id=xx.source_line_id(+)"+
          //" AND H.header_id = lh.pk1_value(+)"+
          " AND l.SHIPPING_METHOD_CODE = lc.lookup_code (+)"+
          " AND ra.attribute2=mkg.LOV_CODE(+)"+
          " AND L.ACTUAL_SHIPMENT_DATE BETWEEN  to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 ";*/
	sql = " SELECT xx.advise_no"+
          ",tsc_inv_category(l.inventory_item_id,49,1100000003) AS TSC_PROD_GROUP"+
          ",CASE WHEN SUBSTR(H.ORDER_NUMBER,1,4) IN ('1121','1131','1141') AND L.PACKING_INSTRUCTIONS='T' THEN Tsc_Intercompany_Pkg.get_sales_group(H.HEADER_ID) WHEN SUBSTR(H.ORDER_NUMBER,1,1) IN ('8') THEN 'TSCC' ELSE Tsc_Intercompany_Pkg.get_sales_group(H.header_id) END SALES_GROUP"+
          ",RA.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME_PHONETIC"+
          ",TSC_GET_REMARK_DESC(H.HEADER_ID,'SHIPPING MARKS') SHIPPING_REMARK"+
          ",H.ORDER_NUMBER ORDER_NUMBER"+
          ",L.LINE_NUMBER||'.'||L.SHIPMENT_NUMBER LINE_NO"+
          ",M.DESCRIPTION ITEM_DESC"+
          ",DECODE(L.ITEM_IDENTIFIER_TYPE,'CUST',L.ORDERED_ITEM,'') CUST_ITEM"+
          ",nvl(l.customer_line_number,l.cust_po_number) cust_po_number"+
          ",xx.SHIPPED_QUANTITY lot_shipped_qty"+
          ",xx.UNIT_PRICE"+
          ",to_char(L.ACTUAL_SHIPMENT_DATE,'yyyy/mm/dd') AS ACTUAL_SHIPMENT_DATE"+
          ",TO_NUMBER(to_char(L.ACTUAL_SHIPMENT_DATE,'mm')) AS ACTUAL_SHIPMENT_MONTH"+
          ",xx.TO_TW"+
          ",lc.meaning shipping_method"+
          ",xx.VENDOR_SITE_CODE vendor_site_code"+
          ",xx.receipt_num"+
          ",xx.carton_list"+
          ",xx.lot"+
          ",xx.date_code"+
          ",xx.PO_NO PO_NO"+
          ",tsc_inv_category(l.inventory_item_id,49,23) AS TSC_PACKAGE"+
          ",tsc_inv_category(l.inventory_item_id,49,1100000004) AS TSC_PROD_FAMILY"+
          ",tsc_inv_category(l.inventory_item_id,49,21) AS TSC_FAMILY"+
          ",RA.ATTRIBUTE2 MARKET_GROUP"+
          ",mkg.LOV_MEANING MAKET_GROUP_NAME"+
          ",M.SEGMENT1 ITEM_NAME"+
          ",L.FLOW_STATUS_CODE"+
          ",xx.CURRENCY_CODE CURRENCY_CODE"+
          " FROM OE_ORDER_HEADERS_ALL H "+
          "     ,OE_ORDER_LINES_ALL L"+
          "     ,INV.MTL_SYSTEM_ITEMS_B M"+
          "     ,AR_CUSTOMERS RA"+
          "     ,(SELECT * FROM tsc_crm_lov_v tcl WHERE tcl.lov_type = 'MARKET_GROUPS' AND LOV_ENABLED_FLAG='Y') mkg"+
          "     ,(SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') lc"+
          "     ,(SELECT tsah.advise_no,tpcl.so_line_id,tpcl.organization_id,tso.vendor_site_code,tpcl.lot,tpcl.date_code,tsah.to_tw"+
          "      ,nvl(tso1.receipt_num,tso.receipt_num) receipt_num"+
          "      ,nvl(pha1.segment1,pha.segment1) po_no"+
          "      ,nvl(pla1.unit_price,pla.unit_price)* case when nvl(pla1.UNIT_MEAS_LOOKUP_CODE,pla.UNIT_MEAS_LOOKUP_CODE)='PCE' THEN 1000 ELSE 1 END unit_price"+
          "      ,nvl(pha1.currency_code,pha.currency_code)  currency_code"+
          "      ,tssg_ship_pkg.get_order_carton_list ('LOT',tpcl.advise_line_id,tpcl.so_header_id,tsah.advise_no,tpcl.lot) carton_list"+
          "      ,SUM (qty)/1000 SHIPPED_QUANTITY"+
          "      FROM tsc.tsc_pick_confirm_lines tpcl"+
          "      ,tsc.tsc_shipping_advise_headers tsah"+
          "      ,oraddman.tssg_stock_overview tso"+
          "      ,po.po_headers_all pha"+
          "      ,po.po_lines_all pla"+
          "      ,po.po_line_locations_all plla"+
          "      ,oraddman.tssg_stock_overview tso1"+
          "      ,po.po_headers_all pha1"+
          "      ,po.po_lines_all pla1"+
          "      ,po.po_line_locations_all plla1"+
          "      where tpcl.advise_header_id=tsah.advise_header_id"+
          "      and tpcl.sg_stock_id=tso.sg_stock_id"+
          "      and tso.po_header_id=pha.po_header_id(+)"+
          "      and tso.po_line_location_id=plla.line_location_id(+)"+
          "      and plla.po_line_id=pla.po_line_id(+)"+
          "      and tso.from_sg_stock_id=tso1.sg_stock_id(+)"+
          "      and tso1.po_header_id=pha1.po_header_id(+)"+
          "      and tso1.po_line_location_id=plla1.line_location_id(+)"+
          "      and plla1.po_line_id=pla1.po_line_id(+)"+
          "      group by tsah.advise_no,tpcl.advise_line_id,tpcl.so_header_id,tpcl.so_line_id,tpcl.organization_id,tso.vendor_site_code,tpcl.lot,tpcl.date_code,tsah.to_tw"+
          "      ,nvl(tso1.receipt_num,tso.receipt_num)"+
          "      ,nvl(pha1.segment1,pha.segment1) "+
          "      ,nvl(pla1.unit_price,pla.unit_price)"+
          "      ,nvl(pha1.currency_code,pha.currency_code)"+
          "      ,nvl(pla1.UNIT_MEAS_LOOKUP_CODE,pla.UNIT_MEAS_LOOKUP_CODE)) xx  "+                   
          " WHERE H.HEADER_ID = L.HEADER_ID"+
          " AND L.INVENTORY_ITEM_ID = M.INVENTORY_ITEM_ID"+
          " AND H.ORG_ID IN (41,906)"+
          " AND L.ship_from_org_id in (907,908)"+
          " AND M.ORGANIZATION_ID = 43"+
          " AND H.SOLD_TO_ORG_ID = RA.CUSTOMER_ID"+
          " AND L.CANCELLED_FLAG != 'Y'"+
          " AND L.PACKING_INSTRUCTIONS='T'"+
          " AND l.line_id=xx.so_line_id(+)"+
          " AND l.SHIPPING_METHOD_CODE = lc.lookup_code (+)"+
          " AND ra.attribute2=mkg.LOV_CODE(+)"+
          " AND L.ACTUAL_SHIPMENT_DATE BETWEEN  to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 ";
	if (!VENDOR.equals(""))
	{
		sql += " AND xx.VENDOR_SITE_CODE LIKE '%"+VENDOR+"%'";
	}		  
	if (!TSC_ITEM_DESC.equals(""))
	{
		sql += " AND M.DESCRIPTION LIKE '"+TSC_ITEM_DESC+"%'";
	}
	if (!TSCPRODGROUP.equals("") && !TSCPRODGROUP.equals("--"))
	{
		sql += " AND tsc_inv_category(l.inventory_item_id,49,1100000003)='"+TSCPRODGROUP+"'";
	}
    sql += " ORDER BY 1,6,7,19";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//訂單出貨日期
			ws.mergeCells(col, row, col+2, row);     
			ws.addCell(new jxl.write.Label(col, row, "訂單出貨日期:" +YearFr+"/"+MonthFr+"/"+DayFr+"~"+YearTo+"/"+MonthTo+"/"+DayTo, LeftBLY));
			row++;

			//Advise NO
			ws.addCell(new jxl.write.Label(col, row, "Advise NO" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
						
			//TSC PROD GROUP
			ws.addCell(new jxl.write.Label(col, row, "TSC PROD GROUP" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//業務區
			ws.addCell(new jxl.write.Label(col, row, "業務區" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//客戶
			ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//嘜頭
			ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//訂單號碼
			ws.addCell(new jxl.write.Label(col, row, "訂單號碼" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//訂單項次
			ws.addCell(new jxl.write.Label(col, row, "訂單項次" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;

			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//客戶品號
			ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//客戶PO
			ws.addCell(new jxl.write.Label(col, row, "客戶PO" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//出貨量(K)
			ws.addCell(new jxl.write.Label(col, row, "出貨量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
		
			//採購單價
			ws.addCell(new jxl.write.Label(col, row, "採購單價" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//出貨日
			ws.addCell(new jxl.write.Label(col, row, "出貨日" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//出貨月份
			ws.addCell(new jxl.write.Label(col, row, "出貨月份" , ACenterBLB));
			ws.setColumnView(col,5);	
			col++;	

			//回T
			ws.addCell(new jxl.write.Label(col, row, "回T" , ACenterBLB));
			ws.setColumnView(col,5);	
			col++;	

			//出貨方式
			ws.addCell(new jxl.write.Label(col, row, "出貨方式" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//驗收單號
			ws.addCell(new jxl.write.Label(col, row, "驗收單號" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;

			//箱號
			ws.addCell(new jxl.write.Label(col, row, "箱號" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;

			//LOT
			ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//D/C
			ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;

			//採購單號
			ws.addCell(new jxl.write.Label(col, row, "採購單號" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//採購幣別
			ws.addCell(new jxl.write.Label(col, row, "採購幣別" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//TSC Package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Family
			ws.addCell(new jxl.write.Label(col, row, "Family" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//TSC Family
			ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Market Group
			ws.addCell(new jxl.write.Label(col, row, "Market Group" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//Market Group Desc
			ws.addCell(new jxl.write.Label(col, row, "Market Group Desc" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//台半料號
			ws.addCell(new jxl.write.Label(col, row, "台半料號" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			row++;
		}
		col=0;

		//Advise NO
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ADVISE_NO"), ALeftL));
		col++;	
						
		//TSC PROD GROUP
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP"), ACenterL));
		col++;	

		//業務區
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_GROUP"),ALeftL));
		col++;	

		//客戶
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME_PHONETIC"), ALeftL));
		col++;	

		//嘜頭
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_REMARK"),ALeftL));
		col++;	

		//訂單號碼
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_NUMBER"), ACenterL));
		col++;	
		
		//訂單項次
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO"), ACenterL));
		col++;

		//型號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"),ALeftL));
		col++;	

		//客戶品號
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_ITEM")==null?"":rs.getString("CUST_ITEM")), ALeftL));
		col++;	

		//客戶PO
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PO_NUMBER"), ALeftL));
		col++;	


		//出貨量(K)
		if (rs.getString("LOT_SHIPPED_QTY")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("LOT_SHIPPED_QTY")).doubleValue(), ARightL));
		}		
		col++;	
	
		//採購單價
		if (rs.getString("UNIT_PRICE")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("UNIT_PRICE")).doubleValue(), ARightL));
		}		
		col++;	

		//出貨日
		if (rs.getString("ACTUAL_SHIPMENT_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ACTUAL_SHIPMENT_DATE")) ,DATE_FORMAT));
		}	
		col++;		
		
		//出貨月份
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ACTUAL_SHIPMENT_MONTH"), ACenterL));
		col++;	

		//回T
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TO_TW"), ACenterL));
		col++;	

		//出貨方式
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_METHOD"),ALeftL));
		col++;	

		//供應商
		ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_SITE_CODE"), ALeftL));
		col++;

		//驗收單號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIPT_NUM"), ALeftL));
		col++;

		//箱號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CARTON_LIST"),ALeftL));
		col++;

		//LOT
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT"), ALeftL));
		col++;

		//D/C
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE"), ALeftL));
		col++;

		//採購單號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PO_NO"),ALeftL));
		col++;	
		
		//採購幣別
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CURRENCY_CODE"),ALeftL));
		col++;	

		//TSC Package
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE"),ALeftL));
		col++;	

		//Family
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_FAMILY"), ALeftL));
		col++;	

		//TSC Family
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_FAMILY"),ALeftL));
		col++;	

		//Market Group
		ws.addCell(new jxl.write.Label(col, row, rs.getString("MARKET_GROUP"), ALeftL));
		col++;	

		//Market Group Desc
		ws.addCell(new jxl.write.Label(col, row, rs.getString("MAKET_GROUP_NAME"), ALeftL));
		col++;	

		//台半料號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME"),ALeftL));
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
		String remarks="";
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@mail.ts.com.tw"));
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.1353") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@mail.ts.com.tw"));
		}
		else
		{
			remarks="";
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@mail.ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jojo@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ivy@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zhangdi@mail.tew.com.cn"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy_chen@mail.ts.com.tw"));
			
		message.setSubject("TEW Order Purchasing Detail Report - "+dateBean.getYearMonthDay()+remarks);
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
