<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Shipping Advise Doc</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCAReceiptListExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String INVOICE_NO = request.getParameter("INVOICE_NO");
if (INVOICE_NO==null) INVOICE_NO="";
String FileName="",RPTName="",sql="",sqla="",swhere="",tot_qty="";
int fontsize=10,colcnt=0;
try 
{ 	
	int row =0,col=0,totcnt=0,reccnt=0,mergeCol=0;
	OutputStream os = null;	
	FileName = "TSCAReceiptList-"+INVOICE_NO+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ 
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("Sheet1", 0);  
	SheetSettings settings = ws.getSettings();//取得分頁環境設定(如:標頭/標尾,分頁,欄長,欄高等設定
	settings.setZoomFactor(90);    //顯示縮放比例
	settings.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
	settings.setScaleFactor(70);   // 打印縮放比例
	settings.setHeaderMargin(0.3);
	settings.setBottomMargin(0.5);
	settings.setLeftMargin(0.2);
	settings.setRightMargin(0.2);
	settings.setTopMargin(0.5);
	settings.setFooterMargin(0.3);	
	
	sql = " SELECT a.invoice_no"+
	      ",a.receipt_num"+
		  ",a.po_no"+
		  ",b.pallet_code"+
		  ",b.bin_code"+
		  ",b.subinventory_code"+
		  ",b.cust_item"+
		  ",b.item_description"+
		  ",b.tsc_item_spec"+
		  ",c.lot_number"+
		  ",c.date_code"+
		  ",c.dc_yyww"+
		  ",c.quantity"+
 		  ",b.tot_qty sub_tot_qty"+
		  ",sum(c.quantity) over (partition by a.invoice_no) tot_qty"+
          ",row_number() over (partition by a.invoice_no,b.pallet_code order by c.lot_number,c.date_code,c.rcv_line_id) row_seq"+
		  ",count(1) over (partition by a.invoice_no,b.pallet_code) row_cnt"+
          " FROM tsca.ta_po_receive_headers a,"+
          " tsca.ta_po_receive_lines b,"+
          " tsca.ta_po_receive_line_lots c"+
          " where a.invoice_no='"+INVOICE_NO+"'"+
          " and a.rcv_header_id=b.rcv_header_id"+
          " and b.rcv_line_id=c.rcv_line_id"+
          " order by a.invoice_no,a.receipt_num,a.po_no,b.pallet_code,b.bin_code,c.lot_number,c.date_code,c.rcv_line_id";
	//out.println(sql);
	//報表名稱平行置中    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 16, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName.setAlignment(jxl.format.Alignment.CENTRE);

	//報表名稱平行置中    
	WritableCellFormat wRptName1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 12, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName1.setAlignment(jxl.format.Alignment.CENTRE);
	
	//表尾行置中     
	WritableCellFormat wRptEnd = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptEnd.setAlignment(jxl.format.Alignment.CENTRE);
		
	//英文內文水平垂直置左  
	WritableCellFormat ALEFT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),fontsize ,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFT.setAlignment(jxl.format.Alignment.LEFT);
	//ALEFT.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);
	ALEFT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALEFT.setWrap(true);
	
	//英文內文水平垂直置右 
	WritableCellFormat ARIGHT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),fontsize ,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARIGHT.setAlignment(jxl.format.Alignment.RIGHT);
	ARIGHT.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);	
		
	//英文內文水平垂直置中-粗體-格線-底色灰-字體黑   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.WHITE));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.SEA_GREEN); 
	ACenterBL.setWrap(true);
	
	//報表名稱平行置中    
	WritableCellFormat wRptName2 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 12, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName2.setAlignment(jxl.format.Alignment.CENTRE);	
	wRptName2.setBackground(jxl.write.Colour.YELLOW); 
	wRptName2.setWrap(true);	

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

	WritableCellFormat ALeftL1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 8,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL1.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL1.setWrap(true);
		
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next())
	{
		if (reccnt==0)
		{
			tot_qty =rs.getString("tot_qty");
			//String strRPTtitle = "Receipt List";
			//ws.mergeCells(col, row, col+10, row);     
			//ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wRptName));
			//row++;
			ws.mergeCells(col, row, col+2, row);  
			ws.addCell(new jxl.write.Label(col, row,"TSC Invoice#："+rs.getString("INVOICE_NO"),ALEFT));
			row++;//列+1
			ws.mergeCells(col, row, col+2, row);  
			ws.addCell(new jxl.write.Label(col, row,"PO#："+(rs.getString("PO_NO")==null?"":rs.getString("PO_NO")),ALEFT));
			row++;//列+1
			ws.mergeCells(col, row, col+2, row);  
			ws.addCell(new jxl.write.Label(col, row,"Receipt#："+(rs.getString("RECEIPT_NUM")==null?"":rs.getString("RECEIPT_NUM")),ALEFT));
			row++;//列+1
					
			ws.addCell(new jxl.write.Label(col, row, "Customer Item" , ACenterBL));
			ws.setColumnView(col,18);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "TSC Item" , ACenterBL));
			ws.setColumnView(col,30);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Subinventory Code" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;
			
			ws.addCell(new jxl.write.Label(col, row, "Pallet Code" , ACenterBL));
			ws.setColumnView(col,14);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Bin Code" , ACenterBL));
			ws.setColumnView(col,14);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Tot Receive Qty" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Lot Number" , ACenterBL));
			ws.setColumnView(col,22);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "Date Code" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "DC YYWW" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Receive Qty" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;	
			
			row++;
		}

		col=0;
		if (rs.getInt("row_seq")==1)
		{  
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_ITEM") ,ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESCRIPTION"),ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SUBINVENTORY_CODE") , ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PALLET_CODE") , ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   
			ws.addCell(new jxl.write.Label(col, row, rs.getString("BIN_CODE") , ALeftL));
			col++;
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SUB_TOT_QTY")).doubleValue() , ARightL));
			col++;								
		}
		else
		{
			col=6;
		}
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DC_YYWW") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("QUANTITY")).doubleValue() , ARightL));
		col++;	
		row++;
		reccnt++;
	}
	if (reccnt>0)
	{
		col=4;
		ws.addCell(new jxl.write.Label(col, row, "Total:",  ALEFT));
		col++;
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(tot_qty).doubleValue() , ARIGHT));
		col++;
		row++;	
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
