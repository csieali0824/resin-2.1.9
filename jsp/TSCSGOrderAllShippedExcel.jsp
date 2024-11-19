<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCSGOrderShipExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=9,colcnt=0;
String SYearFr=request.getParameter("SYEARFR");
if (SYearFr==null) SYearFr="--";
String SMonthFr=request.getParameter("SMONTHFR");
if (SMonthFr==null) SMonthFr="--";
String SDayFr=request.getParameter("SDAYFR");
if (SDayFr==null) SDayFr="--";
String SYearTo=request.getParameter("SYEARTO");
if (SYearTo==null) SYearTo="--"; 
String SMonthTo=request.getParameter("SMONTHTO");
if (SMonthTo==null) SMonthTo="--";
String SDayTo=request.getParameter("SDAYTO");
if (SDayTo==null) SDayTo="--";
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "SG_AllShipped_Report";
	FileName = RPTName+"("+userID+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
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
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	
		
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
	
	sql = " select case a.shipping_from when 'SG1' then '內銷' when 'SG2' THEN '外銷' ELSE '外銷' END shipping_from_name"+
          ",tsc_inv_category(b.inventory_item_id,43,1100000003) tsc_prod_group"+
          ",b.region_code"+
          ",nvl(b.tew_advise_no,a.advise_no) advise_no"+
          ",b.so_no"+
          ",g.line_number||'.'||g.shipment_number line_no"+
          ",decode(g.ship_from_org_id, 907,m.customer_sname,nvl(TSC_GET_HQORDER_INFO(g.org_id, g.ship_from_org_id, g.line_id, 'CUSTOMER_NAME'), m.customer_sname)) as customer"+
          ",b.item_no"+
          ",b.item_desc"+
          ",b.SHIPPING_REMARK"+
          ",to_char(h.ordered_date,'yyyy-mm-dd') ordered_date"+
          ",to_char(g.schedule_ship_date,'yyyy-mm-dd') SSD"+
          ",to_char(g.request_date,'yyyy-mm-dd') CRD"+
          ",to_char(b.PC_SCHEDULE_SHIP_DATE,'yyyy-mm-dd') PC_SCHEDULE_SHIP_DATE"+
          ",a.shipping_method"+
          ",b.ship_qty"+
          ",wnd.name  delivery_name"+
          ",wnd.STATUS_CODE"+
          ",to_char(wnd.INITIAL_PICKUP_DATE,'yyyy-mm-dd') INITIAL_PICKUP_DATE"+         
          ",decode(a.delivery_type ,'VENDOR','廠商直出','') delivery_type"+ 
          ",tsc_inv_category(b.inventory_item_id,43,23) tsc_package"+
          ",f.vendor_site_code"+
          ",b.so_header_id"+
          ",b.so_line_id"+
          ",a.to_tw "+         
          " from tsc.tsc_shipping_advise_headers a"+
          ",(select advise_header_id,so_no,so_header_id,so_line_id,vendor_site_id,tew_advise_no,inventory_item_id,shipping_remark,item_no,item_desc,region_code,trunc(PC_SCHEDULE_SHIP_DATE) PC_SCHEDULE_SHIP_DATE,sum(ship_qty/1000) ship_qty from tsc.tsc_shipping_advise_lines where ((packing_instructions='T' and tew_advise_no is not null) or (packing_instructions='I' and product_group='SSD'))  group by advise_header_id,so_no,so_header_id,so_line_id,vendor_site_id,tew_advise_no,inventory_item_id,shipping_remark,item_no,item_desc,region_code,trunc(PC_SCHEDULE_SHIP_DATE)) b"+
          ",ap_supplier_sites_all f"+
          ",ont.oe_order_lines_all g"+
          ",ont.oe_order_headers_all h"+
          ",tsc_customer_all_v m"+
          ",(select distinct wnd.name,wnd.delivery_id,wnd.status_code,wnd.initial_pickup_date,wdd.source_header_id,wdd.source_line_id from wsh.wsh_new_deliveries wnd,wsh.wsh_delivery_assignments wda,wsh.wsh_delivery_details wdd where wnd.status_code is not null and wnd.status_code='CL' and wnd.delivery_id=wda.delivery_id and wda.delivery_detail_id=wdd.delivery_detail_id and wnd.status_code='CL') wnd"+
          " where a.advise_header_id = b.advise_header_id "+
          " and b.vendor_site_id =f.vendor_site_id(+)"+
          " and b.so_header_id = g.header_id "+
          " and b.so_line_id = g.line_id"+
          " and b.so_header_id=h.header_id"+
          " and g.header_id=h.header_id"+
          " and h.sold_to_org_id=m.customer_id"+
          " and b.so_header_id=wnd.source_header_id"+
          " and b.so_line_id=wnd.source_line_id";
	if ((!SYearFr.equals("--") && !SYearFr.equals("")) || (!SMonthFr.equals("--") && !SMonthFr.equals("")) || (!SDayFr.equals("--") && !SDayFr.equals("")))
	{
		sql += " AND TRUNC(wnd.INITIAL_PICKUP_DATE) >= TO_DATE('" + (SYearFr.equals("--") || SYearFr.equals("")?"2020":SYearFr)+(SMonthFr.equals("--") || SMonthFr.equals("")?"01":SMonthFr)+(SDayFr.equals("--") || SDayFr.equals("")?"01":SDayFr)+"','yyyymmdd')";
	}
	if ((!SYearTo.equals("--") && !SYearTo.equals("")) || (!SMonthTo.equals("--") && !SMonthTo.equals("")) || (!SDayTo.equals("--") && !SDayTo.equals("")))
	{
		sql += " AND TRUNC(wnd.INITIAL_PICKUP_DATE) <= TO_DATE('" + (SYearTo.equals("--") || SYearTo.equals("")?dateBean.getYearString():SYearTo)+(SMonthTo.equals("--") || SMonthTo.equals("")?dateBean.getMonthString():SMonthTo)+(SDayTo.equals("--") || SDayTo.equals("")?dateBean.getDayString():SDayTo)+"','yyyymmdd')";
	}		
	sql += " order by b.so_no,g.line_number||'.'||g.shipment_number";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	String destination="";
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			SheetSettings sst = ws.getSettings(); 
			sst.setSelected();
			sst.setVerticalFreeze(1);  //凍結窗格		
			col=0;row=0;

			//內外銷
			ws.addCell(new jxl.write.Label(col, row, "內外銷" , ACenterBLB));
			ws.setColumnView(col,10);
			col++;	
			
			//Tsc Prod Group
			ws.addCell(new jxl.write.Label(col, row, "Tsc Prod Group" , ACenterBLB));
			ws.setColumnView(col,12);
			col++;	
			
			//Sales Group
			ws.addCell(new jxl.write.Label(col, row, "Sales Group" , ACenterBLB));
			ws.setColumnView(col,12);
			col++;		
			
			//Advise No
			ws.addCell(new jxl.write.Label(col, row, "Advise No" , ACenterBLB));
			ws.setColumnView(col,12);
			col++;						

			//MO單號
			ws.addCell(new jxl.write.Label(col, row, "MO單號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//Line Number
			ws.addCell(new jxl.write.Label(col, row, "Line Number" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;			
			
			//客戶
			ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
			ws.setColumnView(col,35);	
			col++;	
						
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,35);	
			col++;	

			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//嘜頭
			ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			//Ordered Date
			ws.addCell(new jxl.write.Label(col, row, "Ordered Date" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//SSD
			ws.addCell(new jxl.write.Label(col, row, "SSD" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//CRD
			ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//出貨日期
			ws.addCell(new jxl.write.Label(col, row, "出貨日期" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;							

			//出貨方式
			ws.addCell(new jxl.write.Label(col, row, "出貨方式" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//數量(K)
			ws.addCell(new jxl.write.Label(col, row, "數量(K)" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//SG發票號
			ws.addCell(new jxl.write.Label(col, row, "SG發票號" , ACenterBLB));
			ws.setColumnView(col,16);	
			col++;			

			//Ship confirm
			ws.addCell(new jxl.write.Label(col, row, "Ship Confirm" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;			

			//Ship confirm date
			ws.addCell(new jxl.write.Label(col, row, "Ship Confirm Date" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;			

			//Delivery Instructions
			ws.addCell(new jxl.write.Label(col, row, "Delivery Instructions" , ACenterBLB));
			ws.setColumnView(col,11);	
			col++;	
			
			//tsc package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		
			
			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			row++;
		}
		
		col=0;
		//內外銷
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_FROM_NAME"), ALeftL));
		col++;
		//Tsc Prod Group
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP") , ALeftL));
		col++;
		//Sales Group
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REGION_CODE") , ACenterL));
		col++;	
		//Advise No		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ADVISE_NO") , ACenterL));
		col++;	
		//MO單號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO"), ACenterL));
		col++;
		//Line Number
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO"), ACenterL));
		col++;	
		//客戶		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER"), ALeftL));
		col++;	
		//料號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NO"), ALeftL));
		col++;
		//型號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;	
		//嘜頭	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_REMARK") , ALeftL));
		col++;
		//Ordered Date	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDERED_DATE") , ACenterL));
		col++;	
		//SSD
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SSD") , ACenterL));
		col++;
		//CRD	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CRD") , ACenterL));
		col++;	
		//出貨日期						
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PC_SCHEDULE_SHIP_DATE") , ACenterL));
		col++;	
		//出貨方式
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_METHOD") , ACenterL));
		col++;	
		//數量(K)										
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SHIP_QTY")).doubleValue() , ARightL));
		col++;	
		//SG發票號
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("DELIVERY_NAME")==null?"":rs.getString("DELIVERY_NAME")) , ACenterL));
		col++;	
		//Ship Confirm
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("STATUS_CODE")==null||!rs.getString("STATUS_CODE").equals("CL")?"":"Y") , ACenterL));
		col++;	
		//Ship Confirm Date
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INITIAL_PICKUP_DATE")==null?"":rs.getString("INITIAL_PICKUP_DATE")) , ACenterL));
		col++;	
		//Delivery Instructions
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("delivery_type")==null?"":rs.getString("delivery_type")) , ACenterL));
		col++;	
		//TSC Package
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("tsc_package")==null?"":rs.getString("tsc_package")) , ALeftL));
		col++;	
		//供應商
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("vendor_site_code")==null?"":rs.getString("vendor_site_code")) ,  ALeftL));
		col++;	
		row++;
		reccnt ++;
	}	
	wwb.write(); 
	
	rs.close();
	statement.close();
	
	wwb.close();
	os.close();  
	out.close(); 

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
