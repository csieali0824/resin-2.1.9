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
<FORM ACTION="../jsp/TSCSGPOReceiveExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr=dateBean.getYearString();
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr=dateBean.getMonthString();
String DayFr=request.getParameter("DAYFR");
if (DayFr==null) DayFr=dateBean.getDayString();;
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo="--"; 
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="--";
String DayTo=request.getParameter("DAYTO");
if (DayTo==null) DayTo="--";
String ORGCODE= request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String VENDOR_NAME = request.getParameter("VENDOR_NAME");
if (VENDOR_NAME==null) VENDOR_NAME="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String LOT_NUMBER = request.getParameter("LOT_NUMBER");
if (LOT_NUMBER==null) LOT_NUMBER="";
String DATE_CODE = request.getParameter("DATE_CODE");
if (DATE_CODE==null) DATE_CODE="";
String ITEM=request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String RECEIPT_NUM=request.getParameter("RECEIPT_NUM");
if (RECEIPT_NUM==null) RECEIPT_NUM="";
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=9,colcnt=0;
try 
{ 	

	int row =0,col=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,line=0,mergeCol=0;
	String column1="",column2="",column3="",column4="",column5="",mo_CRD="",mo_QTY="",mo_PRICE="",mo_SSD="";
	OutputStream os = null;	
	RPTName = "SG_RECEIVE_LIST";
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
		
	//存儲格樣式,保留三位小數   
	//NumberFormat scale2format = new NumberFormat("##0.0##");   
	//WritableCellFormat numbercellformat_scale2 = new WritableCellFormat(new WritableFont(WritableFont.createFont("ARIAL"),fontsize,WritableFont.NO_BOLD,false),scale2format);               
	//numbercellformat_scale2.setAlignment(jxl.format.Alignment.RIGHT); 
	//numbercellformat_scale2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);

		
	sql = " select a.lot_number"+
	      ", a.date_code"+
		  ", a.rcv_qty"+
          ", a.po_no"+
		  ", nvl(d.vendor_site_code,a.vendor_name) vendor_name"+
		  ", a.item_name"+
		  ", a.item_desc"+
		  ", to_char(a.receive_date,'yyyymmdd') receive_date"+
		  ", case a.inspect_result when 'A' then 'ACCEPT'  when 'W' then 'WAVE' when 'R' then 'REJECT' else '' end inspect_result "+
		  ", a.inspect_reason"+
		  ", a.inspect_remark"+
		  ", to_char(a.creation_date,'yyyymmdd') creation_date"+
		  ", a.created_by"+
		  ", to_char(a.last_update_date,'yyyymmdd') last_updated_date"+
		  ", a.last_updated_by"+
		  ", a.receipt_num"+
		  ", a.organization_id"+
		  ", a.vendor_site_id"+
		  ", a.remarks"+
		  ", a.no_match_fifo_reason"+
		  ", a.status"+
		  ", a.subinventory_code"+
          ", to_char(a.lot_expiration_date,'yyyymmdd') lot_expiration_date"+
		  ", to_char(a.inspection_date,'yyyymmdd') inspection_date"+
		  ", a.inspected_by"+
		  ", b.organization_code"+
		  ", replace(c.note_to_receiver,'.','/') note_to_receiver"+
		  ",a.return_qty"+
		  ",a.return_reason"+
		  ",case  b.organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else b.organization_code end as organization_name"+
		  ",nvl(a.delivery_type,'') delivery_type"+ //add by Peggy 20200424
		  ",a.dc_yyww"+ //add by Peggy 20220728
		  " from oraddman.tssg_po_receive_detail a"+
  	      ",mtl_parameters b"+
		  ",po.po_line_locations_all c"+
		  ",ap.ap_supplier_sites_all d"+
          " where a.organization_id=b.organization_id"+
		  " and a.po_line_location_id=c.line_location_id(+)"+
		  " and a.vendor_site_id=d.vendor_site_id";
	if (!ORGCODE.equals("") && !ORGCODE.equals("--"))
	{
		sql += " AND a.organization_id = '"+ ORGCODE+"'";
	}
	if (!PONO.equals(""))
	{
		sql += " AND a.PO_NO LIKE '"+ PONO+"%'";
	}	
	if (!ITEM.equals(""))
	{
		sql += " AND (UPPER(a.item_name) LIKE '"+ ITEM.toUpperCase()+"%' OR UPPER(a.item_desc) LIKE '"+ITEM.toUpperCase()+"%')";
	}
	if (!VENDOR_NAME.equals("") && !VENDOR_NAME.equals("--"))
	{
		sql += " and a.vendor_name ='"+VENDOR_NAME+"'";
	}
	if (!LOT_NUMBER.equals(""))
	{
		sql += " AND a.LOT_NUMBER = '"+ LOT_NUMBER+"'";
	}	
	if (!DATE_CODE.equals(""))
	{
		sql += " AND a.date_code = '"+ DATE_CODE+"'";
	}	
	if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
	{
		sql += " AND to_char(a.RECEIVE_DATE,'yyyymmdd') >= '" + (YearFr.equals("--") || YearFr.equals("")?"2019":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"00":DayFr)+"'";
	}
	if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") || !DayTo.equals("")))
	{
		sql += " AND to_char(a.RECEIVE_DATE,'yyyymmdd') <= '" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"'";
	}
	if (!RECEIPT_NUM.equals("") && !RECEIPT_NUM.equals("--"))
	{
		sql += " and a.receipt_num ='"+RECEIPT_NUM+"'";
	}	
	sql += " ORDER BY receive_date DESC, item_name, lot_number DESC";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			

			//內外銷
			ws.addCell(new jxl.write.Label(col, row, "內外銷" , ACenterBLB));
			ws.setColumnView(col,6);	
			col++;

			//廠商直出
			ws.addCell(new jxl.write.Label(col, row, "廠商直出" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;					
			
			//Vendor
			ws.addCell(new jxl.write.Label(col, row, "Vendor" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Rcv Date
			ws.addCell(new jxl.write.Label(col, row, "Rcv Date" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Receipt Num
			ws.addCell(new jxl.write.Label(col, row, "Receipt Num" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//PO NO
			ws.addCell(new jxl.write.Label(col, row, "PO NO" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//MO#
			ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Item Name
			ws.addCell(new jxl.write.Label(col, row, "Item Name" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//Item Desc
			ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//LOT
			ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Date Code
			ws.addCell(new jxl.write.Label(col, row, "Date Code" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//Qty(K)
			ws.addCell(new jxl.write.Label(col, row, "Qty(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//Lot Expiration Date
			ws.addCell(new jxl.write.Label(col, row, "Lot Expiration Date" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;

			//QC Result
			ws.addCell(new jxl.write.Label(col, row, "QC Result" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
			
			//QC Rej Reason
			ws.addCell(new jxl.write.Label(col, row, "QC Rej Reason" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;			
			
			//QC Remarks
			ws.addCell(new jxl.write.Label(col, row, "QC Remarks" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
				
			//Subinv Code
			ws.addCell(new jxl.write.Label(col, row, "Subinv Code" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
			
			//No FIFO Reason
			ws.addCell(new jxl.write.Label(col, row, "No FIFO Reason" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//Return Qty
			ws.addCell(new jxl.write.Label(col, row, "Return Qty" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;

			//Return Reason
			ws.addCell(new jxl.write.Label(col, row, "Return Reason" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			
			//Status
			ws.addCell(new jxl.write.Label(col, row, "Status" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//DC YYWW
			ws.addCell(new jxl.write.Label(col, row, "DC YYWW" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
			
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORGANIZATION_NAME"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("delivery_type")==null?"":rs.getString("delivery_type")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_NAME"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIVE_DATE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIPT_NUM") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PO_NO") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("note_to_receiver")==null?"":rs.getString("note_to_receiver")) , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("RCV_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("lot_expiration_date") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INSPECT_RESULT")==null?"":rs.getString("INSPECT_RESULT")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INSPECT_REASON")==null?"":rs.getString("INSPECT_REASON")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INSPECT_REMARK")==null?"":rs.getString("INSPECT_REMARK")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SUBINVENTORY_CODE")==null?"":rs.getString("SUBINVENTORY_CODE")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("NO_MATCH_FIFO_REASON")==null?"":rs.getString("NO_MATCH_FIFO_REASON")) , ACenterL));
		col++;	
		if (rs.getString("RETURN_QTY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row,"" ,ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("RETURN_QTY")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("RETURN_REASON")==null?"":rs.getString("RETURN_REASON")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("STATUS") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("DC_YYWW")==null?"":rs.getString("DC_YYWW")) , ALeftL));
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
