<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*,java.lang.Object.*" %>
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
<FORM ACTION="../jsp/TSCSGTOTWPOReceiveExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String V_INVOICE=request.getParameter("INVOICE");
if (V_INVOICE==null) V_INVOICE="";
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=9,colcnt=0;
try 
{ 	

	int row =0,col=0,reccnt=0;
	String column1="",column2="",column3="",column4="",column5="";
	OutputStream os = null;	
	RPTName = "TW_ADVISE_LIST";
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
	WritableSheet ws = wwb.createSheet("Sheet1", 0); 
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置中-格線-底色黃
	WritableCellFormat CenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	CenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
	CenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	CenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	CenterBLY.setBackground(jxl.write.Colour.YELLOW); 
	CenterBLY.setWrap(true);	

	//英文內文水平垂直置中-格線-底色紅
	WritableCellFormat CenterBLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	CenterBLR.setAlignment(jxl.format.Alignment.CENTRE);
	CenterBLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	CenterBLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	CenterBLR.setBackground(jxl.write.Colour.RED); 
	CenterBLR.setWrap(true);	
	
	//英文內文水平垂直置中-粗體-格線-底色綠
	WritableCellFormat CenterBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	CenterBLG.setAlignment(jxl.format.Alignment.CENTRE);
	CenterBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	CenterBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	CenterBLG.setBackground(jxl.write.Colour.BRIGHT_GREEN); 
	CenterBLG.setWrap(true);
		
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


		
	sql = " select '' po_no"+
          ", '' WIP_no "+
          ", b.SO_NO mono"+
          ", c.item_no"+
          ", decode(b.UOM,'PCE','KPC',b.UOM) UOM"+
          ", decode(b.UOM,'PCE',sum(c.QTY)/1000,'KPC',sum(c.QTY)) qty"+
          ", c.LOT "+
          ", c.date_code"+
          ", case  when substr(b.so_no,1,4)='1121' then '40' when tsc_inv_category(msi.inventory_item_id,43,1100000003)='SSD' THEN '11' ELSE '13' END SUBINVENTORY"+
          ",'' locator"+
          ",'' packing_slip"+
          ",tn.invoice_no Waybill_Num"+
          //",b.CARTON_NUM_FR"+
          //",b.CARTON_NUM_TO"+
          ",c.carton_no CARTON_NUM_FR"+
          ",c.carton_no CARTON_NUM_TO"+
          ",a.POST_FIX_CODE"+
          ",b.GROSS_WEIGHT"+
          ",b.NET_WEIGHT"+
          ",'' cube "+
		  ",c.DC_YYWW"+  //add by Peggy 20220726
		  ",to_char(tsh.PICKUP_DATE,'yyyymmdd') invoice_date"+
		  ",case when substr(b.SO_NO,1,1)='8' then NVL(decode(d.item_identifier_type,'CUST',d.ordered_item,''),'') else decode(tsc_odr.item_identifier_type,'CUST',tsc_odr.ordered_item,'') end CUST_PARTNO"+
          " from TSC_SHIPPING_ADVISE_HEADERS a "+
		  ",TSC_SHIPPING_ADVISE_LINES b"+
		  ",TSC_PICK_CONFIRM_LINES c"+
		  ",mtl_system_items msi"+
          ",tsc_sg_invoice_lines tn"+
		  ",TSC_SG_INVOICE_HEADERS tsh"+ //add by Peggy 20230118
		  ",ONT.OE_ORDER_LINES_ALL d"+
		  ",(select distinct x.order_number,y.line_number line_no,y.item_identifier_type,y.ordered_item from ont.oe_order_headers_all x,ont.oe_order_lines_all y where x.org_id=41 and x.header_id=y.header_id and y.packing_instructions='T') tsc_odr"+
          " where a.ADVISE_HEADER_ID = B.ADVISE_HEADER_ID"+
          " and b.ADVISE_LINE_ID = c.ADVISE_LINE_ID"+
          " and c.INVENTORY_ITEM_ID = msi.INVENTORY_ITEM_ID"+
          " and c.ORGANIZATION_ID = msi.ORGANIZATION_ID"+
          " and c.so_line_id=tn.order_line_id(+)"+
          " and tn.invoice_no = '"+V_INVOICE+"'"+
		  " and tn.invoice_no = tsh.invoice_no"+ //add by Peggy 20230118
          " and b.so_line_id = d.line_id(+)"+
          " and b.so_no=tsc_odr.order_number(+)"+
          " and substr(b.so_line_number,1,instr(b.so_line_number,'.')-1)=tsc_odr.line_no(+) "+
          " group by b.SO_NO "+
          " , c.item_no"+
          " ,b.UOM"+
          " ,c.LOT "+
          " ,c.date_code"+
          " ,tn.invoice_no"+
          //" ,b.CARTON_NUM_FR"+
          //" ,b.CARTON_NUM_TO"+
		  " ,c.carton_no"+//modify by Peggy 20201211
          " ,a.POST_FIX_CODE"+
          " ,b.GROSS_WEIGHT"+
          " ,b.NET_WEIGHT"+
          " ,msi.inventory_item_id"+
		  " ,c.DC_YYWW"+ //add by Peggy 20220726
		  " ,to_char(tsh.PICKUP_DATE,'yyyymmdd')"+ //add by Peggy 20230118
		  " ,d.item_identifier_type"+
		  " ,d.ordered_item"+
		  " ,tsc_odr.item_identifier_type"+
		  " ,tsc_odr.ordered_item"+
          //" order by 13";
		  " order by to_number(c.carton_no),b.GROSS_WEIGHT"; //modify by Peggy 20201211
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			

			//PO No
			ws.addCell(new jxl.write.Label(col, row, "PO No" , ACenterBLB));
			ws.setColumnView(col,6);	
			col++;	
			
			//WIP No
			ws.addCell(new jxl.write.Label(col, row, "WIP No" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Mo No
			ws.addCell(new jxl.write.Label(col, row, "Mo No" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Item
			ws.addCell(new jxl.write.Label(col, row, "Item" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			//Cust PN,add by Peggy 20230118
			ws.addCell(new jxl.write.Label(col, row, "Cust PN" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			
			//Uom
			ws.addCell(new jxl.write.Label(col, row, "Uom" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//LOT Qty
			ws.addCell(new jxl.write.Label(col, row, "LOT Qty" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Lot No
			ws.addCell(new jxl.write.Label(col, row, "Lot No" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//DC YYWW
			ws.addCell(new jxl.write.Label(col, row, "DC YYWW" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
			
			//Date Code
			ws.addCell(new jxl.write.Label(col, row, "Date Code" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//Subinventory
			ws.addCell(new jxl.write.Label(col, row, "Subinventory" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Locator
			ws.addCell(new jxl.write.Label(col, row, "Locator" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//Invoice date,modify by Peggy 20230118
			ws.addCell(new jxl.write.Label(col, row, "Invoice date" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//Waybill Airbill Num
			ws.addCell(new jxl.write.Label(col, row, "Waybill Airbill Num" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;

			//C/No From
			ws.addCell(new jxl.write.Label(col, row, "C/No From" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
			
			//C/No To
			ws.addCell(new jxl.write.Label(col, row, "C/No To" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;			
			
			//Carton Codes
			ws.addCell(new jxl.write.Label(col, row, "Carton Code" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
				
			//N.W.
			ws.addCell(new jxl.write.Label(col, row, "N.W." , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
			
			//G.W.
			ws.addCell(new jxl.write.Label(col, row, "G.W." , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
			
			//CUBE
			ws.addCell(new jxl.write.Label(col, row, "CUBE" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;

			//WareHouse
			ws.addCell(new jxl.write.Label(col, row, "WareHouse" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//ALLOW WAVE
			ws.addCell(new jxl.write.Label(col, row, "ALLOW WAVE" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;

			//Reason
			ws.addCell(new jxl.write.Label(col, row, "Reason" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;

			//QC Person
			ws.addCell(new jxl.write.Label(col, row, "QC Person" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PO_NO"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("WIP_NO"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("MONO") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NO") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_PARTNO")==null?"":rs.getString("CUST_PARTNO")) , ALeftL)); //add by Peggy 20230118
		col++;		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("QTY") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DC_YYWW") , ALeftL));  //add by Peggy 20220726
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SUBINVENTORY") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOCATOR") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("INVOICE_DATE") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("WAYBILL_NUM") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CARTON_NUM_FR") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CARTON_NUM_TO") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("POST_FIX_CODE") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("NET_WEIGHT") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("GROSS_WEIGHT") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUBE") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("mono").substring(1,4).equals("1121")?"台北":"宜蘭") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, "N" , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, UserName , ALeftL));
		col++;			
		row++;
		
		reccnt ++;
	}	
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 
	
	rs.close();
	statement.close();
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
