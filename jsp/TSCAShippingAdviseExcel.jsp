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
<FORM ACTION="../jsp/TSCAShippingAdviseExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String ADVISE_NO = request.getParameter("ADVISE_NO");
if (ADVISE_NO==null) ADVISE_NO="";
String FileName="",RPTName="",sql="";
int fontsize=9,colcnt=0;
try 
{ 	
	int row =0,col=0,reccnt=0,mergeCol=0;
	String advise_no="";
	OutputStream os = null;	
	FileName = "ShippingAdvise-"+ADVISE_NO+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
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

	//報表名稱平行置中    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 16, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
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
	
	
	sql = " select x.organization_id"+
	      ",x.advise_line_id"+
		  ",x.advise_no"+
		  ",x.advise_header_id"+
		  ",x.customer_id"+
		  ",x.customer_number"+
		  ",x.customer_name"+
		  ",x.cs_schedule_ship_date"+
		  ",x.shipping_method"+
		  ",x.cust_po"+
		  ",x.cust_item"+
		  ",x.item_desc"+
		  ",x.part_spec"+
		  ",x.ship_qty"+
		  ",x.subinventory_code"+
		  ",x.bin_code"+
		  ",x.SO_NO"+
		  ",x.so_line_number"+
		  ",sum(x.allot_qty) allot_qty"+
          ",row_number() over (partition by x.advise_line_id order by x.bin_code) row_seq"+
          ",count(1) over (partition by x.advise_line_id) row_cnt"+
          " from (select b.organization_id,a.advise_no,a.advise_header_id,b.SO_NO,b.so_line_number,a.customer_id,tca.account_number customer_number,nvl(tca.customer_sname,tca.customer_name) customer_name"+
          "      ,to_char(b.cs_schedule_ship_date,'mm-dd-yyyy') cs_schedule_ship_date,a.shipping_method,b.cust_po,decode(b.cust_item,'N/A',b.item_desc,b.cust_item) cust_item,b.item_desc"+
          "      ,nvl(aecq.part_spec,adv.part_spec) part_spec,b.ship_qty,adv.subinventory_code,adv.bin_code,adv.pallet_line_id,adv.lot_number,adv.allot_qty,b.advise_line_id"+
          "      from tsca.ta_shipping_advise_headers a"+
		  "      ,tsca.ta_shipping_advise_lines b"+
		  "      ,tsc_customer_all_v tca"+
          "      ,table(tsc_get_aecq_info(b.inventory_item_id)) aecq"+
          "      ,table(tsca_ship_pkg.GET_ALLOT_ONAHND(b.advise_line_id)) adv"+
          "      where a.advise_header_id=b.advise_header_id"+
          "      and a.advise_no='"+ADVISE_NO+"'"+
          "      and a.customer_id=tca.customer_id) x "+
          " group by x.organization_id,x.advise_no,x.advise_header_id,x.customer_id,x.customer_number,x.customer_name"+
          " ,x.cs_schedule_ship_date,x.shipping_method,x.cust_po,x.cust_item,x.item_desc,"+
          " x.part_spec,x.ship_qty,x.bin_code,x.advise_line_id,x.SO_NO,x.so_line_number,x.subinventory_code"+
          " order by x.advise_line_id,x.bin_code";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	String ssd ="",so_header_id="";
	while (rs.next())
	{
		if (reccnt==0)
		{
			String strRPTtitle = "Shipping Advise"; 
			ws.mergeCells(col, row, col+10, row);     
			ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wRptName1));
			row+=2;
		
			ws.mergeCells(col, row, col+2, row);     
			ws.addCell(new jxl.write.Label(col, row,"Advise No："+rs.getString("ADVISE_NO"),ALEFT));	
			ws.mergeCells(col+2+4, row, col+2+4+2, row);  
			ws.addCell(new jxl.write.Label(col+2+4, row,"Shipment Date："+rs.getString("CS_SCHEDULE_SHIP_DATE"),ALEFT));
			row++;//列+1
			ws.mergeCells(col, row, col+2, row);  
			ws.addCell(new jxl.write.Label(col, row,"Customer："+rs.getString("CUSTOMER_NAME"),ALEFT));
			ws.mergeCells(col+2+4, row, col+2+4+2, row);  
			ws.addCell(new jxl.write.Label(col+2+4, row,"Shipping Method："+rs.getString("SHIPPING_METHOD"),ALEFT));
			row++;//列+1	
			
			col=0;
			ws.addCell(new jxl.write.Label(col, row, "Seq#"  , ACenterBL));
			ws.setColumnView(col,6);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "Line#" , ACenterBL));
			ws.setColumnView(col,6);	
			col++;				
	
			ws.addCell(new jxl.write.Label(col, row, "Cust Item" , ACenterBL));
			ws.setColumnView(col,22);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "Description" , ACenterBL));
			ws.setColumnView(col,55);	
			col++;	
				
			ws.addCell(new jxl.write.Label(col, row, "Cust PO" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "Ship Qty(PCS)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;
				
			ws.addCell(new jxl.write.Label(col, row, "Bin Code" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "Subinventory" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;				
			
			ws.addCell(new jxl.write.Label(col, row, "Onhand(PCS)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;			
			row++;
		}

		col=0;
		if (rs.getInt("row_seq")==1)
		{ 	
			ws.setRowView(row,500);	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   	
			ws.addCell(new jxl.write.Label(col, row, ""+(reccnt+1), ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO") ,ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_LINE_NUMBER"),ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_ITEM") , ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PART_SPEC") , ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PO") , ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("row_cnt")-1);   	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SHIP_QTY")).doubleValue(), ARightL));
			col++;	
		}
		else
		{
			ws.setRowView(row,500);	
			col=7;
		}	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("BIN_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("subinventory_code") , ALeftL));
		col++;			
		if (rs.getString("ALLOT_QTY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ALLOT_QTY")).doubleValue() , ARightL));
		}
		col++;					
		row++;
		reccnt++;
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
