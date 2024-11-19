<!--20160527 by Peggy,增加台半發票號查詢條件-->
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
<FORM ACTION="../jsp/TEWStockOverviewReport.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",sqlx="",sqly="",where="",destination="";
String TSCPRODGROUP = request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP="SSD";
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
String TSC_INVOICE_NO = request.getParameter("TSC_INVOICE_NO");  //add by Peggy 20160527
if (TSC_INVOICE_NO==null) TSC_INVOICE_NO=""; 

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
	RPTName = "TewOrderPurchasingDetail";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setVerticalFreeze(2);  //凍結窗格
	for (int g =1 ; g <=6 ;g++ )
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
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();

	sql = " SELECT H.ORDER_NUMBER ORDER_NUMBER"+
          ",L.LINE_NUMBER||'.'||L.SHIPMENT_NUMBER LINE_NO"+
          ",L.LINE_ID"+
          ",M.SEGMENT1 ITEM_NAME"+
          ",M.DESCRIPTION ITEM_DESC"+
          ",RA.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME_PHONETIC"+
          ",to_char(L.ACTUAL_SHIPMENT_DATE,'yyyy/mm/dd') AS ACTUAL_SHIPMENT_DATE"+
          //",SUM(NVL(L.SHIPPED_QUANTITY,0)) SHIPPED_QUANTITY"+
		  ",SUM(NVL(L.SHIPPED_QUANTITY,0)*case when L.ORDER_QUANTITY_UOM='KPC' then 1000 else 1 end) SHIPPED_QUANTITY"+
          //",tsc_om_category(l.inventory_item_id,49,'TSC_Package') AS TSC_PACKAGE"+
		  ",tsc_inv_category(l.inventory_item_id,49,23) AS TSC_PACKAGE"+
          //",tsc_om_category(l.inventory_item_id,49,'TSC_Family') AS TSC_FAMILY"+
		  ",tsc_inv_category(l.inventory_item_id,49,21) AS TSC_FAMILY"+
          //",tsc_om_category(l.inventory_item_id,49,'TSC_PROD_GROUP') AS TSC_PROD_GROUP"+
		  ",tsc_inv_category(l.inventory_item_id,49,1100000003) AS TSC_PROD_GROUP"+
          ",L.FLOW_STATUS_CODE"+
          ",xx.SHIPPED_QUANTITY lot_shipped_qty"+
          ",xx.PO_NO PO_NO"+
          ",xx.CONVERSION_RATE CURRENCY_CONVERSION_RATE "+
          ",xx.UNIT_PRICE po_unit_price"+
          ",xx.VENDOR_SITE_CODE vendor_site_code"+
          ",xx.CURRENCY_CODE CURRENCY_CODE"+
		  ",round(xx.SHIPPED_QUANTITY*xx.UNIT_PRICE/decode(xx.CURRENCY_CODE,'USD',1,xx.CONVERSION_RATE),2) amount"+
		  ",(select attribute3 from inv.mtl_system_items_b k where k.organization_id=49 and k.inventory_item_id=l.inventory_item_id) plant_code"+ //add by Peggy 20200827
          " FROM OE_ORDER_HEADERS_ALL H "+
          ",OE_ORDER_LINES_ALL L"+
          ",INV.MTL_SYSTEM_ITEMS_B M"+
          ",AR_CUSTOMERS RA"+
          " ,(select x.SOURCE_LINE_ID,x.ORGANIZATION_ID,x.VENDOR_SITE_CODE,x.PO_NO,x.UNIT_PRICE,x.CURRENCY_CODE,x.CONVERSION_RATE,sum(qty) SHIPPED_QUANTITY"+
          "  from (select g.so_line_id SOURCE_LINE_ID,a.organization_id,g.qty,d.segment1 po_no,f.vendor_site_code,decode(e.UNIT_MEAS_LOOKUP_CODE,'KPC',e.unit_price/1000,e.unit_price) unit_price,d.currency_code ,h.CONVERSION_RATE ,ROW_NUMBER() OVER (PARTITION BY g.so_line_id,a.ORGANIZATION_ID,a.LOT_NUMBER ORDER BY A.CREATION_DATE) ROW_SEQ"+
          "        from inv.mtl_transaction_lot_numbers a"+
          "       ,inv.mtl_material_transactions b"+
          "       ,po.rcv_transactions c"+
          "       ,po.po_headers_all d"+
          "       ,po.po_lines_all e"+
          "       ,ap.ap_supplier_sites_all f"+
          "       ,(select x.inventory_item_id,x.so_line_id,lot,sum(x.qty*case when y.uom='KPC' then 1000 else 1 end) qty from tsc.tsc_pick_confirm_lines x,tsc.tsc_shipping_advise_lines y where x.advise_header_id=y.advise_header_id and x.advise_line_id=y.advise_line_id group by x.inventory_item_id,x.so_line_id,x.lot) g"+
		  "       ,(SELECT CONVERSION_DATE, CONVERSION_RATE FROM gl_daily_rates  WHERE from_currency = 'USD'  AND to_currency = 'TWD' AND conversion_type = '1001') h"+
          "       where a.TRANSACTION_ID=b.TRANSACTION_ID"+
		  "       and b.transaction_type_id=18"+
		  "       and b.organization_id=49"+
          "       and b.RCV_TRANSACTION_ID=c.TRANSACTION_ID(+)"+ 
          "       and c.PO_HEADER_ID=d.PO_HEADER_ID(+) "+
          "       and c.PO_LINE_ID=e.PO_LINE_ID(+) "+
          "       and d.vendor_site_id=f.vendor_site_id(+) "+
          "       and a.lot_number=g.lot"+
		  "       and TSC_PO_GET_SOURCE_ITEMID(g.inventory_item_id,g.lot)=a.inventory_item_id "+
		  //"       and b.TRANSACTION_DATE = h.CONVERSION_DATE"+
		  "       and trunc(b.TRANSACTION_DATE) = h.CONVERSION_DATE"+
		  //"       AND tsc_om_category(g.inventory_item_id,49,'TSC_PROD_GROUP')='"+TSCPRODGROUP+"'"+
		  "       AND tsc_inv_category(g.inventory_item_id,49,1100000003)='"+TSCPRODGROUP+"'"+
          "  ) x "+
          "  where ROW_SEQ=1 "+
          "  group by x.SOURCE_LINE_ID,x.ORGANIZATION_ID,x.VENDOR_SITE_CODE,x.PO_NO,x.UNIT_PRICE,x.CURRENCY_CODE,x.CONVERSION_RATE) xx"+
          " WHERE H.HEADER_ID = L.HEADER_ID"+
          " AND L.INVENTORY_ITEM_ID = M.INVENTORY_ITEM_ID"+
          " AND M.ORGANIZATION_ID = 43"+
          " AND H.SOLD_TO_ORG_ID = RA.CUSTOMER_ID"+
          " AND L.CANCELLED_FLAG != 'Y'"+
		  " AND L.PACKING_INSTRUCTIONS NOT IN ('T','A')"+ //排除SG/A01訂單,add by Peggy 20200324
		  //" AND instr(nvl(L.ATTRIBUTE7,' '),'Slow Moving Stock Check')=0"+  //排除消庫存訂單,add by Peggy 20200424   //for 11410155866 issue拿掉此條件 by Peggy 20230928
          " AND H.FLOW_STATUS_CODE in ('BOOKED','CLOSED','ENTERED')"+
          " AND tsc_inv_category(l.inventory_item_id,49,1100000003)='"+TSCPRODGROUP+"'"+
		  " AND SUBSTR(H.ORDER_NUMBER,1,3) NOT IN ('115','119')"+  //ADD BY PEGGY 20160701
		  " AND SUBSTR(H.ORDER_NUMBER,1,4) NOT IN ('1211')"+        //ADD BY PEGGY 20160701
		  " AND SUBSTR(H.ORDER_NUMBER,1,1) NOT IN ('7')"+        //ADD BY PEGGY 20160711
		  " AND NOT EXISTS (SELECT 1 FROM inv.mtl_system_items_b k where k.organization_id=49 and k.inventory_item_id=l.inventory_item_id and k.attribute3 IN ('006','010'))"+ //add by Peggy 20200827
          " AND l.line_id=xx.source_line_id(+)";
	if (!VENDOR.equals(""))
	{
		sql += " AND xx.VENDOR_SITE_CODE LIKE '%"+VENDOR+"%'";
	}		  
	if (!TSC_ITEM_DESC.equals(""))
	{
		sql += " AND M.DESCRIPTION LIKE '"+TSC_ITEM_DESC+"%'";
	}
	if (!TSC_INVOICE_NO.equals(""))
	{
		sql += " AND EXISTS (SELECT 1"+
               " FROM wsh.wsh_new_deliveries k,wsh.wsh_delivery_assignments p,wsh.wsh_delivery_details u"+
               " WHERE k.delivery_id=p.delivery_id"+
               " AND p.delivery_detail_id=u.DELIVERY_DETAIL_ID"+
               " AND u.source_line_id=l.line_id"+
               " AND K.NAME='"+TSC_INVOICE_NO+"')";
	}	 
	else
	{
    	sql +=" AND L.ACTUAL_SHIPMENT_DATE BETWEEN  to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 ";
	}
    sql += " GROUP BY H.ORDER_NUMBER"+
          " ,L.LINE_ID"+
          " ,M.SEGMENT1"+
          " ,M.DESCRIPTION"+
          " ,RA.CUSTOMER_NAME_PHONETIC"+
          " ,H.HEADER_ID"+
          " ,L.INVENTORY_ITEM_ID"+
          " ,decode(L.ITEM_IDENTIFIER_TYPE,'CUST',L.ORDERED_ITEM,'null')"+
          " ,L.ORDER_QUANTITY_UOM"+
          " ,L.ACTUAL_SHIPMENT_DATE"+
          " ,L.FLOW_STATUS_CODE"+
          " ,xx.UNIT_PRICE"+
          " ,xx.VENDOR_SITE_CODE"+
          " ,xx.CURRENCY_CODE"+
          " ,xx.SHIPPED_QUANTITY"+
          " ,xx.CONVERSION_RATE"+
          " ,xx.PO_NO"+
          " ,L.LINE_NUMBER"+
          " ,L.shipment_number"+
          "  order by 11,1,2";
	//out.println(sql);
	//out.println(sqlx);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			if (!TSC_INVOICE_NO.equals(""))
			{			
				//台半發票號
				ws.mergeCells(col, row, col+2, row);     
				ws.addCell(new jxl.write.Label(col, row, "台半發票號:" +TSC_INVOICE_NO, LeftBLY));
			}
			else
			{
				//訂單出貨日期
				ws.mergeCells(col, row, col+2, row);     
				ws.addCell(new jxl.write.Label(col, row, "訂單出貨日期:" +YearFr+"/"+MonthFr+"/"+DayFr+"~"+YearTo+"/"+MonthTo+"/"+DayTo, LeftBLY));
			}
				row++;
						
			//訂單號碼
			ws.addCell(new jxl.write.Label(col, row, "訂單號碼" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//訂單項次
			ws.addCell(new jxl.write.Label(col, row, "訂單項次" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//客戶
			ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
			ws.setColumnView(col,24);	
			col++;	

			//台半22D
			ws.addCell(new jxl.write.Label(col, row, "台半料號(22D)" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//台半品名
			ws.addCell(new jxl.write.Label(col, row, "品名" , ACenterBLB));
			ws.setColumnView(col,22);	
			col++;	

			//出貨日期
			ws.addCell(new jxl.write.Label(col, row, "出貨日期" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//出貨數量
			ws.addCell(new jxl.write.Label(col, row, "出貨數量" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//採購單
			ws.addCell(new jxl.write.Label(col, row, "採購單" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//採購單價
			ws.addCell(new jxl.write.Label(col, row, "採購單價" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//採購幣別
			ws.addCell(new jxl.write.Label(col, row, "採購幣別" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//匯率
			ws.addCell(new jxl.write.Label(col, row, "匯率" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//金額
			ws.addCell(new jxl.write.Label(col, row, "金額(USD)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//TSC PROD GROUP
			ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//TSC Package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;			
			row++;
		}
		col=0;

		//訂單號碼
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_NUMBER"), ACenterL));
		col++;	
		//訂單項次
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO") , ALeftL));
		col++;	
		//客戶
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME_PHONETIC") , ALeftL));
		col++;	
		//台半22D
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME"), ALeftL));
		col++;	
		//台半品名
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;	
		//出貨日期
		if (rs.getString("ACTUAL_SHIPMENT_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ACTUAL_SHIPMENT_DATE")) ,DATE_FORMAT));
		}	
		col++;		
		//出貨數量
		if (rs.getString("LOT_SHIPPED_QTY")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("LOT_SHIPPED_QTY")).doubleValue(), ARightL));
		}
		col++;			
		//採購單
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PO_NO")==null?"":rs.getString("PO_NO")) , ALeftL));
		col++;			
		//採購單價
		if (rs.getString("PO_UNIT_PRICE")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PO_UNIT_PRICE")).doubleValue(), ARightL));
		}
		col++;	
		//採購幣別			
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CURRENCY_CODE")==null?"":rs.getString("CURRENCY_CODE")), ACenterL));
		col++;			
		//匯率
		if (rs.getString("CURRENCY_CONVERSION_RATE")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("CURRENCY_CONVERSION_RATE")).doubleValue(), ARightL));
		}
		col++;		
		//金額
		if (rs.getString("amount")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("amount")).doubleValue(), ARightL));
		}
		col++;			
		//供應商
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("VENDOR_SITE_CODE")==null?"":rs.getString("VENDOR_SITE_CODE")), ALeftL));
		col++;	
		//tsc prod group
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PROD_GROUP")==null?"":rs.getString("TSC_PROD_GROUP")), ALeftL));
		col++;	
		//tsc package
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PACKAGE")==null?"":rs.getString("TSC_PACKAGE")), ALeftL));
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
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jojo@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ivy@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zhangdi@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wendy@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Cecilia@mail.tew.com.cn"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("TEW Order Purchasing Detail Report"+(RTYPE.equals("AUTO")?"("+TSCPRODGROUP+")":"")+" - "+dateBean.getYearMonthDay()+remarks);
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
