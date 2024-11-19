<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download OPEN Order Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TEWShippingAdviseReport.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE="";
String SALESAREA = request.getParameter("SALESAREA");
if (SALESAREA==null) SALESAREA="";
String TSC_DESC = request.getParameter("TSC_DESC");
if (TSC_DESC==null) TSC_DESC="";
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=9,colcnt=0;
java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	OutputStream os = null;	
	int col=0,row=0,reccnt=0;
	RPTName = "OPEN Order List";
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
	
	//英文內文水平垂直置右-正常-格線-紅字   
	WritableCellFormat ARightLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 11,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ARightLR.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLR.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線-紅字   
	WritableCellFormat ACenterLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 11, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLR.setWrap(true);

	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
	
	sql = " SELECT oola.HEADER_ID,"+
		  " oola.LINE_ID,"+
		  " oola.CUSTOMER_ID,"+
		  " oola.SHIP_FROM_ORG_ID,"+
		  " oola.ORDER_NO ORDER_NUMBER,"+
		  " msi.DESCRIPTION,"+
		  " NVL(oola.ORDERED_QUANTITY,0) ORDERED_QUANTITY,"+
		  " oola.UOM,"+
		  " oola.SALES_GROUP,"+
		  " oola.line_no,"+
		  " oola.CUST_ITEM,"+
		  " oola.CUST_PO_NUMBER CUSTOMER_PO,"+
		  " msi.SEGMENT1,"+
		  " oola.SHIP_METHOD,"+
		  " oola.PLANT_CODE,"+
		  " oola.FOB, "+
		  " TO_CHAR(oola.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') SCHEDULE_SHIP_DATE,"+
		  " oola.PCMARKS,"+
		  " oola.CUSTOMER_NAME,"+
		  " tsc_om_category(oola.inventory_item_id,49,'TSC_PROD_GROUP') AS TSC_PROD_GROUP,"+
		  " oola.ORDER_STATUS STATUS,"+
		  " NVL(sap.SHIP_QTY,0) SHIP_QTY,"+
		  " oola.INVENTORY_ITEM_ID,"+
		  " oola.SHIPPING_REMARK,"+		
		  " oola.TO_TW,"+
          " TSC_GET_REMARK(oola.HEADER_ID,'REMARKS') REMARKS,"+
          " TSC_GET_REMARK(oola.HEADER_ID,'SHIPPING MARKS') SHIPMARKS,"+
          " tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_Package') AS TSC_PACKAGE,"+
		  " ooha.ATTRIBUTE10 RFQ,"+
		  " case WHEN oola.TO_TW='Y' then to_char(oola.SCHEDULE_SHIP_DATE -21,'yyyy/mm/dd') else to_char(oola.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') end AS ACT_SHIP_DATE"+
		  " FROM oraddman.tew_open_orders_all oola,"+
		  " INV.MTL_SYSTEM_ITEMS_B msi,"+
		  " ont.oe_order_headers_all ooha,"+
		  " (SELECT SO_HEADER_ID,SO_LINE_ID,sum(SHIP_QTY) SHIP_QTY  FROM tsc.tsc_shipping_advise_pc_tew a where shipping_from ='TEW' group by SO_HEADER_ID,SO_LINE_ID) sap"+
		  " WHERE ((oola.TO_TW='Y' and oola.SCHEDULE_SHIP_DATE BETWEEN to_date(?,'yyyymmdd')+21 AND to_date(?,'yyyymmdd')+21.99999)"+
		  "  or (oola.TO_TW='N' and oola.SCHEDULE_SHIP_DATE BETWEEN to_date(?,'yyyymmdd') AND to_date(?,'yyyymmdd')+0.99999))"+
		  " AND  oola.INVENTORY_ITEM_ID = msi.INVENTORY_ITEM_ID"+
		  " AND msi.ORGANIZATION_ID = 49"+
		  " AND oola.HEADER_ID = sap.SO_HEADER_ID(+)"+
		  " AND oola.LINE_ID =sap.SO_LINE_ID(+)"+
		  " AND oola.HEADER_ID=ooha.HEADER_ID(+)"+
		  " AND NVL(oola.ORDERED_QUANTITY,0)- NVL(sap.SHIP_QTY,0)>0";
	if (!SALESAREA.equals("--") && !SALESAREA.equals(""))
	{
		sql += " AND oola.SALES_GROUP ='" + SALESAREA+"'";
	}
	if (!TSC_DESC.equals(""))
	{
		sql += " AND msi.description like '"+TSC_DESC+"%'";
	}
	sql += " ORDER BY SALES_GROUP,ACT_SHIP_DATE, oola.SHIP_METHOD,oola.SHIPPING_REMARK,oola.ORDER_NO,oola.LINE_ID,msi.DESCRIPTION";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,SDATE);
	statement.setString(2,EDATE);
	statement.setString(3,SDATE);
	statement.setString(4,EDATE);
	ResultSet rs=statement.executeQuery();
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//order no
			ws.addCell(new jxl.write.Label(col, row, "Order No" , ACenterBLB));
			ws.setColumnView(col,15);
			col++;	

			//sales group
			ws.addCell(new jxl.write.Label(col, row, "Sales Group" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//line
			ws.addCell(new jxl.write.Label(col, row, "Line No" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//description
			ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//Cust PO
			ws.addCell(new jxl.write.Label(col, row, "Cust PO" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			//cust item
			ws.addCell(new jxl.write.Label(col, row, "Cust Item" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//order qty
			ws.addCell(new jxl.write.Label(col, row, "Order Qty" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//ssd
			ws.addCell(new jxl.write.Label(col, row, "Schedule Ship Date" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//pc marks
			ws.addCell(new jxl.write.Label(col, row, "PC Marks" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//UOM
			ws.addCell(new jxl.write.Label(col, row, "UOM" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//shipping method
			ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Customer Name
			ws.addCell(new jxl.write.Label(col, row, "Customer Name" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;

			//ship marks
			ws.addCell(new jxl.write.Label(col, row, "Ship Marks" , ACenterBLB));
			ws.setColumnView(col,50);	
			col++;
				
			//item name
			ws.addCell(new jxl.write.Label(col, row, "Item Name" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;
			
			//tsc package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			
			//Remarks
			ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBLB));
			ws.setColumnView(col,50);	
			col++;
			
			//RFQ 
			ws.addCell(new jxl.write.Label(col, row, "RFQ No" , ACenterBLB));
			ws.setColumnView(col,20);	
						
			col++;
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_NUMBER") , ACenterL));
		ws.setColumnView(col,15);
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_GROUP"), ACenterL));
		ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO"), ALeftL));
		ws.setColumnView(col,10);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION") , ALeftL));
		ws.setColumnView(col,25);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_PO") , ALeftL));
		ws.setColumnView(col,30);	
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_ITEM") , ALeftL));
		ws.setColumnView(col,20);	
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ORDERED_QUANTITY")).doubleValue(), ARightL));
		ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
		ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PCMARKS") , ALeftL));
		ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM") , ACenterL));
		ws.setColumnView(col,10);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIP_METHOD") , ALeftL));
		ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME") , ALeftL));
		ws.setColumnView(col,20);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPMARKS") , ALeftL));
		ws.setColumnView(col,50);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SEGMENT1") , ALeftL));
		ws.setColumnView(col,25);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE") ,ALeftL));
		ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REMARKS"),ALeftL));
		ws.setColumnView(col,50);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("RFQ"),ALeftL));
		ws.setColumnView(col,20);	
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
