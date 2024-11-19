<!-- 20141029 by Peggy,增加幣別欄位-->
<!-- 20141119 by Peggy,PO狀態欄位增加Quantity or Price issue-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCEDIHistoryExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER == null) CUSTOMER ="";
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO == null) CUSTPO ="";
String ORDERS = "ORDERS",ORDCHG="ORDCHG";
String CYearFr = request.getParameter("CYEARFR");
if (CYearFr==null)  CYearFr="";
String CMonthFr = request.getParameter("CMONTHFR");
if (CMonthFr==null) CMonthFr="";
String CDayFr = request.getParameter("CDAYFR");
if (CDayFr==null) CDayFr="";
String CYearTo= request.getParameter("CYEARTO");
if (CYearTo==null) CYearTo="";
String CMonthTo = request.getParameter("CMONTHTO");
if (CMonthTo==null) CMonthTo="";
String CDayTo = request.getParameter("CDAYTO");
if (CDayTo==null) CDayTo="";
String PDNFLAG = request.getParameter("PDNFLAG");
if (PDNFLAG==null) PDNFLAG="";
String POSTATUS = request.getParameter("POSTATUS");
if (POSTATUS==null) POSTATUS="0";
String CURRENCY = request.getParameter("CURRENCY");
if (CURRENCY==null) CURRENCY=""; 
String FileName="",RPTName="",ColumnName="",DEPTNAME="",sql="";
String ERP_CUSTOMER_ID="",CUSTOMER_PO="",CUSTOMER_PO_LINE="",STRBGCOLOR="",ORDER_QTY="",UNIT_PRICE="";//add by Peggy 20141120

int fontsize=8,colcnt=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	if (PDNFLAG.equals("Y"))
	{
		RPTName = "PDNREPORT";
	}
	else if (POSTATUS.equals("6"))
	{
		RPTName = "EDI_ISSUE_REPORT";
	}
	else
	{
		RPTName = "EDI_ORDER_REPORT";
	}
	FileName = RPTName+"("+userID+")"+dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	
	//英文內文水平垂直置中-粗體-格線   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(true);

	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);		
	
	//英文內文水平垂直置中-粗體-格線-底色綠  
	WritableCellFormat ACenterBLC = new WritableCellFormat(font_bold);   
	ACenterBLC.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLC.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLC.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLC.setBackground(jxl.write.Colour.LIME); 
	ACenterBLC.setWrap(true);	
	
	//英文內文水平垂直置右-正常-格線-紅字   
	WritableCellFormat ARightLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 9,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ARightLR.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLR.setWrap(true);		
		
	if (PDNFLAG.equals("Y"))
	{
		sql = " SELECT a.order_number \"M/O\",b.line_number||'.'||b.shipment_number \"Line No.\","+
			  " b.customer_shipment_number \"Customer PO Line No.\",e.description \"Part Number\","+
			  " b.ordered_item \"Cust P/N\",d.customer_name \"Customer\",b.customer_line_number \"P/O No.\","+
			  " to_char(b.creation_date,'yyyy-mm-dd') \"Order Date\",to_char(b.schedule_ship_date,'yyyy-mm-dd') SSD,to_char(b.request_date,'yyyy-mm-dd') CRD,b.shipping_method_code \"Shipping Method\",b.ordered_quantity Qty ,REMARK \"備註\""+
			  " FROM ont.oe_order_headers_all a,ont.oe_order_lines_all b ,(select distinct c.REQUEST_DATE, c.erp_customer_id,c.customer_po,d.cust_po_line_no,d.REMARK from "+
			  " tsc_edi_orders_his_h c,tsc_edi_orders_his_d d where c.request_no =d.request_no and c.erp_customer_id= d.erp_customer_id and d.PDN_FLAG='Y') c,ar_customers d,inv.mtl_system_items_b e,tsc_edi_customer f"+
			  " where a.header_id = b.header_id"+
			  " and a.sold_to_org_id=c.erp_customer_id"+
			  " and b.customer_line_number=c.customer_po"+
			  " and b.customer_shipment_number=c.cust_po_line_no"+
			  " and a.sold_to_org_id=d.customer_id"+
			  " and b.inventory_item_id=e.inventory_item_id"+
			  " and a.SHIP_FROM_ORG_ID=e.organization_id"+
			  " and a.sold_to_org_id =f.customer_id";
		if (!CUSTPO.equals(""))
		{
			sql += " and c.CUSTOMER_PO ='"+CUSTPO+"'";
		}
		if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
		{
			sql += " and c.erp_customer_id ='" + CUSTOMER +"'";
		}
		if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
		{
			sql += " and c.REQUEST_DATE >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
		}
		if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
		{
			sql += " and c.REQUEST_DATE <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
		}
		if (UserRoles!="admin" && !UserRoles.equals("admin")) 
		{ 
			sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=f.SALES_AREA_NO)";
		}						
	}
	else
	{
		if (!POSTATUS.equals("6"))
		{
			sql = " select  ac.CUSTOMER_NUMBER \"客戶代碼\",b.CUSTOMER_NAME \"客戶\",a.CUSTOMER_PO \"客戶訂單\",a.REQUEST_DATE \"申請日期\" ,a.CURRENCY_CODE \"幣別\" from tsc_edi_orders_header a,tsc_edi_customer b,ar_customers ac WHERE a.erp_customer_id=b.CUSTOMER_ID and b.customer_id=ac.customer_id";
			if (!CUSTPO.equals(""))
			{
				sql += " and CUSTOMER_PO = '"+CUSTPO+"'";
			}
			if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
			{
				sql += " and CUSTOMER_ID ='" + CUSTOMER +"'";
			}
			if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
			{
				sql += " and REQUEST_DATE >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
			}
			if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
			{
				sql += " and REQUEST_DATE <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
			}
			if (UserRoles!="admin" && !UserRoles.equals("admin")) 
			{ 
				sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=b.SALES_AREA_NO)";
			}
		}
		else
		{
			sql = " select a.erp_customer_id,b.customer_name,a.currency_code,a.customer_po,a.cust_po_line_no,a.cust_item_name,a.tsc_item_name,a.quantity,a.uom,a.unit_price,a.cust_request_date,d.creation_date,d.last_update_date,"+
				  " e.ORDER_NUMBER,e.lineno,e.ORDERED_ITEM,e.DESCRIPTION,e.ORDERED_QUANTITY,e.UNIT_SELLING_PRICE,e.po_line_cnt ,e.po_line_tot_qty,to_char(e.request_date,'yyyymmdd') request_date "+
				  ",ac.customer_number"+
				  " FROM (select a.ERP_CUSTOMER_ID,a.CURRENCY_CODE,a.CUSTOMER_PO,b.CUST_PO_LINE_NO,b.CUST_ITEM_NAME,b.TSC_ITEM_NAME,sum(b.QUANTITY) QUANTITY,b.UOM,b.UNIT_PRICE,b.CUST_REQUEST_DATE from tsc_edi_orders_header a,tsc_edi_orders_detail b "+
				  " where  a.customer_po = b.customer_po(+)"+
				  " AND a.erp_customer_id = b.erp_customer_id(+)"+
				  " group by a.ERP_CUSTOMER_ID,a.CURRENCY_CODE,a.CUSTOMER_PO,b.CUST_PO_LINE_NO,b.CUST_ITEM_NAME,b.TSC_ITEM_NAME,b.UOM,b.UNIT_PRICE,b.CUST_REQUEST_DATE"+
				  ") a,"+
				  " tsc_edi_customer b,"+
				  " (select  distinct erp_customer_id, customer_po,min(request_date) over(partition by erp_customer_id,customer_po) creation_date,max(request_date) over(partition by erp_customer_id,customer_po) last_update_date "+
				  " from tsc_edi_orders_his_h where 1=1";
			if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
			{
				sql += " and REQUEST_DATE >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
			}
			if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
			{
				sql += " and REQUEST_DATE <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
			}				  
			sql += ") d,"+
				  " (select a.sold_to_org_id,a.order_number,b.line_number||'.'||b.shipment_number lineno,b.customer_line_number,b.customer_shipment_number"+
				  " ,b.ordered_item,c.segment1,c.description,b.unit_selling_price,b.ordered_quantity,b.order_quantity_uom,b.request_date"+
				  " ,sum(b.ordered_quantity) over(partition by a.sold_to_org_id,b.customer_line_number,b.customer_shipment_number,trunc(b.request_date)) po_line_tot_qty"+
				  " ,row_number() over(partition by a.sold_to_org_id,b.customer_line_number,b.customer_shipment_number,trunc(b.request_date) order by a.sold_to_org_id,b.customer_line_number) po_line_cnt"+
				  " from ont.oe_order_headers_all a,ont.oe_order_lines_all b,inv.mtl_system_items_b c"+
				  " where a.header_id=b.header_id"+
				  " and nvl(b.cancelled_flag,'N') = 'N'"+
				  " and nvl(a.cancelled_flag,'N') = 'N'"+
				  " and b.flow_status_code not in ('CANCELLED')"+
				  " and b.inventory_item_id=c.inventory_item_id"+
				  " and b.ship_from_org_id=c.organization_id"+
				  " and exists (select 1 from tsc_edi_customer d where d.customer_id=a.sold_to_org_id)) e,"+
				  " ar_customers ac"+
				  " WHERE     a.erp_customer_id = b.customer_id"+
				  " AND a.customer_po = d.customer_po"+
				  " AND a.erp_customer_id = d.erp_customer_id"+
				  " and a.erp_customer_id=e.sold_to_org_id"+
				  " and a.customer_po=e.customer_line_number"+
				  " and a.cust_po_line_no=e.CUSTOMER_SHIPMENT_NUMBER"+
				  " and a.CUST_REQUEST_DATE=to_char(e.request_date,'yyyymmdd')"+
				  " and (a.quantity<>e.PO_LINE_TOT_QTY"+
				  " or exists (select 1 from ont.oe_order_headers_all m,ont.oe_order_lines_all n "+
				  " where m.header_id=n.header_id "+
				  " and m.sold_to_org_id=a.erp_customer_id"+
				  " and n.customer_line_number=a.customer_po"+
				  " and n.customer_shipment_number=a.cust_po_line_no"+
				  " and to_char(n.request_date,'yyyymmdd') =a.CUST_REQUEST_DATE"+
				  " and b.customer_id=ac.customer_id"+
				  " and n.unit_selling_price <> a.unit_price))";
			if (!CUSTPO.equals(""))
			{
				sql += " and a.CUSTOMER_PO = '"+CUSTPO+"'";
			}
			if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
			{
				sql += " and b.CUSTOMER_ID ='" + CUSTOMER +"'";
			}
			if (!CURRENCY.equals(""))  //add by Peggy 20141029
			{
				sql += " and a.CURRENCY_CODE ='" +CURRENCY.toUpperCase() +"'";
			}			
			
			if (UserRoles!="admin" && !UserRoles.equals("admin")) 
			{ 
				sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=b.SALES_AREA_NO)";
			}
			sql += "order by a.erp_customer_id,b.customer_name,a.customer_po,a.cust_po_line_no,e.po_line_cnt desc";
		}
	}
	//out.println(sql);
	Statement state=con.createStatement();     
    ResultSet rs=state.executeQuery(sql);
	if (!POSTATUS.equals("6"))
	{
		while (rs.next())	
		{ 
			if (reccnt==0)
			{
				ResultSetMetaData md=rs.getMetaData();
				colcnt =md.getColumnCount();
	
				for (int i=1;i<=colcnt;i++) 
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
					if ((PDNFLAG.equals("Y") && i==6)  || (PDNFLAG.equals("N") && i==2))
					{
						ws.setColumnView(col+(i-1),30);	
					}
					else
					{
						ws.setColumnView(col+(i-1),15);	
					}
				}
				row++;
			}
			for (int i =1 ; i <= colcnt ; i++)
			{
				if ((PDNFLAG.equals("Y") && i==6)  || (PDNFLAG.equals("N") && i==2))
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ALeftL));
					ws.setColumnView(col+(i-1),30);
				}
				else
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ACenterL));
					ws.setColumnView(col+(i-1),15);
				}
			}	
			reccnt++;
			row++;
		}
	}
	else
	{
		while (rs.next())	
		{ 
			if (reccnt==0)
			{
				col=0;row=0;
				
				ws.mergeCells(col, row, col+11, row);     
				ws.addCell(new jxl.write.Label(col, row, "EDI", ACenterBLB));
				ws.mergeCells(col+12, row, col+12+6, row);     
				ws.addCell(new jxl.write.Label(col+12, row, "ERP", ACenterBLC));
				row++;

				ws.addCell(new jxl.write.Label(col, row, "客戶代碼" , ACenterBLB));
				ws.setColumnView(col,12);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
				ws.setColumnView(col,30);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "幣別" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "客戶PO" , ACenterBLB));
				ws.setColumnView(col,25);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "PO項次" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBLB));
				ws.setColumnView(col,20);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "台半品號" , ACenterBLB));
				ws.setColumnView(col,20);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "單價" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "Creation Date" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "Last Update Date" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "訂單號碼" , ACenterBLC));
				ws.setColumnView(col,15);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "項次" , ACenterBLC));
				ws.setColumnView(col,10);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBLC));
				ws.setColumnView(col,25);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "台半品號" , ACenterBLC));
				ws.setColumnView(col,25);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBLC));
				ws.setColumnView(col,10);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "訂單數量" , ACenterBLC));
				ws.setColumnView(col,10);	
				col++;					
				ws.addCell(new jxl.write.Label(col, row, "訂單單價" , ACenterBLC));
				ws.setColumnView(col,10);	
				col++;	
				row++;				
			}
			col=0;
			if (!ERP_CUSTOMER_ID.equals(rs.getString("erp_customer_id")) || !CUSTOMER_PO.equals(rs.getString("customer_po")) || !CUSTOMER_PO_LINE.equals(rs.getString("CUST_PO_LINE_NO")))
			{
				ERP_CUSTOMER_ID=rs.getString("erp_customer_id");
				CUSTOMER_PO=rs.getString("customer_po");
				CUSTOMER_PO_LINE=rs.getString("CUST_PO_LINE_NO");
				ORDER_QTY=rs.getString("QUANTITY");
				UNIT_PRICE=rs.getString("UNIT_PRICE");
				
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("customer_number"), ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("customer_name"), ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("currency_code"), ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("customer_po"), ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PO_LINE_NO"), ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_ITEM_NAME"), ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_ITEM_NAME"), ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("QUANTITY")).doubleValue(), ARightL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM"), ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("UNIT_PRICE")).doubleValue(), ARightL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_REQUEST_DATE"), ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATION_DATE"), ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("po_line_cnt")-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("LAST_UPDATE_DATE"), ACenterL));
				col++;	
			}
			else
			{
				col=12;
			}
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_NUMBER"), ACenterL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LINENO"), ACenterL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDERED_ITEM"), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION"), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_DATE"), ACenterL));
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ORDERED_QUANTITY")).doubleValue(), (!ORDER_QTY.equals(rs.getString("po_line_tot_qty"))?ARightLR:ARightL)));
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("UNIT_SELLING_PRICE")).doubleValue(),  (!UNIT_PRICE.equals(rs.getString("UNIT_SELLING_PRICE"))?ARightLR:ARightL)));
			col++;	
			
			reccnt++;
			row++;
		}
	}
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 
	
	rs.close();
	state.close();

	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();			 
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
	response.reset();
	response.setContentType("application/vnd.ms-excel");	
	String strURL = "/oradds/report/"+FileName+".xls"; 
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
