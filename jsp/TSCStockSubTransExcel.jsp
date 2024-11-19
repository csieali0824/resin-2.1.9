<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCStockSubTransExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String HID=request.getParameter("HID");
if (HID==null) HID="";
String WKCODE=request.getParameter("WKCODE");
if (WKCODE==null) WKCODE="";
String REQNO=request.getParameter("REQNO");
if (REQNO==null) REQNO="";
int icnt=0,fontsize=10,fontsize1=9;
String sql ="",FileName="";
int row =0,col=0,line=0,tot_row=0,row1 =0; 
String end_str="****** This copyright of document and business secret belong to TSC,and no copies should be made without any permission ******";
String rpt_code="AQ4PC48-A";


try 
{ 	
	OutputStream os = null;	
	FileName=REQNO+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	
	
	//公司名稱中文平行置中     
	WritableCellFormat wCompCName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 20 ,WritableFont.BOLD,false));   
	wCompCName.setAlignment(jxl.format.Alignment.CENTRE);
	
	//報表名稱平行置中    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 16, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName.setAlignment(jxl.format.Alignment.CENTRE);
							
	/*//英文內文水平垂直置中     
	WritableCellFormat ACenter = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenter.setAlignment(jxl.format.Alignment.CENTRE);
	ACenter.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenter.setWrap(true);
	
	//英文內文水平垂直靠左
	WritableCellFormat ALeft = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeft.setAlignment(jxl.format.Alignment.LEFT);
	ALeft.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeft.setWrap(true);

	//英文內文水平垂直靠右
	WritableCellFormat ARight = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARight.setAlignment(jxl.format.Alignment.RIGHT);
	ARight.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARight.setWrap(true);*/

	//英文內文水平垂直置中-粗體-格線   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setWrap(true);
	
	//英文內文水平垂直靠左-粗體-格線   
	WritableCellFormat ALeftBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftBL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftBL.setWrap(true);

	//英文內文水平垂直靠右-粗體-格線   
	WritableCellFormat ARightBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightBL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightBL.setWrap(true);
		
	//英文內文水平垂直置中-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize1, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);

	//英文內文水平垂直靠左-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize1, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
	
	//英文內文水平垂直靠右-格線   
	WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize1, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);
		
	//英文內文水平垂直置中-粗體   
	WritableCellFormat ACenterB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterB.setWrap(true);

	//英文內文水平垂直靠左-粗體  
	WritableCellFormat ALeftB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftB.setAlignment(jxl.format.Alignment.LEFT);
	ALeftB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftB.setWrap(true);

	//英文內文水平垂直靠右-粗體   
	WritableCellFormat ARightB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightB.setAlignment(jxl.format.Alignment.RIGHT);
	ARightB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightB.setWrap(true);
	
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("Sheet1", 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setScaleFactor(70);   // 打印縮放比例
	//sst.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
	sst.setHeaderMargin(0.3);
	sst.setBottomMargin(0.5);
	sst.setLeftMargin(0.2);
	sst.setRightMargin(0.2);
	sst.setTopMargin(0.5);
	sst.setFooterMargin(0.3);		

	sql = " select b.req_line_id"+
		  ",b.req_header_id"+
		  ",b.line_no"+
		  ",b.tsc_prod_group"+
		  ",b.orig_organization_id"+
		  ",b.orig_subinventory_code"+
		  ",b.orig_inventory_item_id"+
		  ",b.orig_item_name"+
		  ",b.orig_item_desc"+
		  ",b.orig_lot_number"+
		  ",b.orig_date_code"+
		  ",b.orig_qty"+
		  ",b.orig_uom"+
		  ",b.req_reason"+
		  ",b.orig_trans_type_id"+
		  ",b.unit_price"+
		  ",b.tot_amt"+
		  ",b.new_organization_id"+
		  ",b.new_subinventory_code"+
		  ",b.new_inventory_item_id"+
		  ",b.new_item_name"+
		  ",b.new_item_desc"+
		  ",b.new_lot_number"+
		  ",b.new_date_code"+
		  ",b.new_qty"+
		  ",b.new_uom"+
		  ",c.organization_code orig_organization_code"+
		  ",d.organization_code new_organization_code"+
		  ",to_number(to_char(a.creation_date,'yyyy'))-1911 iyear"+
		  ",to_char(a.creation_date,'mm') imonth"+
		  ",to_char(a.creation_date,'dd') iday"+
		  ",e.trans_name"+
		  ",e.trans_desc"+
		  ",a.req_no"+
		  ",b.req_reason"+
		  " from oraddman.tsc_stock_trans_headers a"+
		  ",oraddman.tsc_stock_trans_lines b"+
		  ",inv.mtl_parameters c"+
		  ",inv.mtl_parameters d"+
		  ",oraddman.tsc_stock_trans_type e"+
		  ",oraddman.tsc_stock_trans_wkflow f"+
		  //",oraddman.tsc_stock_trans_member g"+	  
		  " where a.req_header_id=b.req_header_id"+
		  " and a.req_header_id=?"+
		  " and b.orig_organization_id=c.organization_id"+
		  " and b.new_organization_id=d.organization_id"+
		  " and a.trans_type=e.trans_type"+
		  " and a.trans_type=f.trans_type"+
		  " and a.wkflow_level=f.wkflow_level"+
		  //" and a.trans_type=g.trans_type"+
		  //" and f.wkflow_next_level=g.wkflow_level"+
		  " order by a.req_no,b.line_no";
	PreparedStatement statementx = con.prepareStatement(sql);
	statementx.setString(1,HID);
	ResultSet rsx=statementx.executeQuery();
	icnt=0;row=0;	
	while (rsx.next())
	{
		col=0;
		if (icnt==0)
		{
				
			//logo
			jxl.write.WritableImage image = new jxl.write.WritableImage(col,row,col+2.8,row+2, new File("..//resin-2.1.9//webapps/oradds/jsp/images/logo.png")); 
			ws.addImage(image); 
	
			ws.mergeCells(col, row, col+11, row);     
			ws.addCell(new jxl.write.Label(col, row,"台灣半導體股份有限公司" , wCompCName));
			ws.setColumnView(col,120);	
			row++;//列+1
						
			ws.mergeCells(col, row, col+11, row);     
			ws.addCell(new jxl.write.Label(col, row,rsx.getString("trans_desc") , wRptName));
			ws.setRowView(row, 500);			
			row++;//列+1
			row++;//列+1

			ws.mergeCells(col+9, row, col+11, row);     
			ws.addCell(new jxl.write.Label(col+9, row,"日期:民國 "+rsx.getInt("iyear")+" 年 "+ rsx.getInt("imonth")+" 月 "+rsx.getInt("iday")+" 日" , ARightB));
			ws.setRowView(row, 450);

			row++;//列+1
			
			col=0;
			ws.addCell(new jxl.write.Label(col, row ,"項次" , ACenterBL));
			ws.setColumnView(col,6);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"產品別" ,ACenterBL));
			ws.setColumnView(col,10);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"品名規格" , ACenterBL));
			ws.setColumnView(col,25);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"Lot Number" , ACenterBL));
			ws.setColumnView(col,20);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"D/C" , ACenterBL));
			ws.setColumnView(col,10);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"移出倉別" , ACenterBL));
			ws.setColumnView(col,7);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"移入倉別" , ACenterBL));
			ws.setColumnView(col,7);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"數量" , ACenterBL));
			ws.setColumnView(col,8);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"單位" , ACenterBL));
			ws.setColumnView(col,6);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"轉倉原因" , ACenterBL));
			ws.setColumnView(col,20);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"單價(KPCS)" , ACenterBL));
			ws.setColumnView(col,10);col++;	
			ws.addCell(new jxl.write.Label(col, row ,"Amount(NTD)" , ACenterBL));
			ws.setColumnView(col,13);col++;	
			ws.setRowView(row, 550);
			row++;//列+1
			
		}

		col=0;
    	ws.addCell(new jxl.write.Label(col, row ,rsx.getString("LINE_NO"), ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , rsx.getString("TSC_PROD_GROUP") , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , rsx.getString("ORIG_ITEM_DESC") , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , rsx.getString("ORIG_LOT_NUMBER") , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , rsx.getString("ORIG_DATE_CODE") , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , rsx.getString("orig_subinventory_code") , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , rsx.getString("new_subinventory_code") , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , (new DecimalFormat("######0.####")).format(Float.parseFloat(rsx.getString("ORIG_QTY"))) , ARightL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , rsx.getString("ORIG_UOM") , ACenterL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , rsx.getString("req_reason") , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , (new DecimalFormat("######0.####")).format(Float.parseFloat(rsx.getString("unit_price"))) , ARightL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , (new DecimalFormat("######0.####")).format(Float.parseFloat(rsx.getString("tot_amt"))), ARightL));
		col++;
		ws.setRowView(row, 700);
		row++;//列+1
		row1++;
		icnt++;
	}
	rsx.close();
	statementx.close();
	
	tot_row=50-(row1*2);
	for ( int i =1 ; i <=tot_row ; i++)
	{
		col=0;
    	ws.addCell(new jxl.write.Label(col, row ,"", ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "" , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "", ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "", ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "" , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "" , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "" , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "", ARightL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "" , ACenterL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "" , ALeftL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "" , ARightL));
		col++;
    	ws.addCell(new jxl.write.Label(col, row , "" , ARightL));
		col++;
		ws.setRowView(row, 350);
		row++;//列+1
	}

	row+=2;//列+1
	col=0;
	
	sql = " select a.action_code,a.created_by,to_char(a.creation_date,'yyyy-mm-dd') creation_date"+
          " from oraddman.tsc_stock_trans_action_log a"+
          " where req_header_id=?"+
          " group by a.action_code,a.created_by,to_char(a.creation_date,'yyyy-mm-dd')";
	statementx = con.prepareStatement(sql);
	statementx.setString(1,HID);
	rsx=statementx.executeQuery();
	while (rsx.next())
	{
		if (rsx.getString("action_code")==null) continue;
		ws.setRowView(row, 500);
		if (rsx.getString("action_code").toUpperCase().equals("APPROVED"))
		{
			ws.mergeCells(col+1, row, col+2, row);
			ws.addCell(new jxl.write.Label(col+1, row,"核淮:"+rsx.getString("created_by")+"\n"+rsx.getString("creation_date"), ALeftB)); 
		}	
		else if (rsx.getString("action_code").toUpperCase().equals("CONFIRMED")) 
		{
			ws.mergeCells(col+3, row, col+4, row);
			ws.addCell(new jxl.write.Label(col+3, row,"單位主管:"+rsx.getString("created_by")+"\n"+rsx.getString("creation_date"),ARightB)); 
		}
		else if (rsx.getString("action_code").toUpperCase().equals("SUBMIT"))
		{		
			ws.mergeCells(col+9, row, col+10, row);  
			ws.addCell(new jxl.write.Label(col+9, row,"申請人:"+rsx.getString("created_by")+"\n"+rsx.getString("creation_date"), ARightB)); 
		}	
	}
	rsx.close();
	statementx.close();	
	
	row+=4;//列+1
	
	col=0;
	ws.mergeCells(col, row, col+11, row);     
	ws.addCell(new jxl.write.Label(col, row,end_str, ACenterB)); 
	row++;//列+1
	col=0;
	ws.mergeCells(col, row, col+11, row);     
	ws.addCell(new jxl.write.Label(col, row,"("+rpt_code+")", ARightB)); 
	row++;//列+1
	
	wwb.write(); 
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
response.reset();
response.setContentType("application/vnd.ms-excel");	
String strURL = "/oradds/report/"+FileName+".xls"; 
response.sendRedirect(strURL);
%>

</html>
