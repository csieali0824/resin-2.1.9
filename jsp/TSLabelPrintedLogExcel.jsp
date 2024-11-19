<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,java.awt.Image.*,java.lang.Object.*,jxl.format.*,java.text.*" %>
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
<FORM ACTION="../jsp/TSLabelPrintedLogExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String WIPNO = request.getParameter("WIPNO");
if (WIPNO==null) WIPNO="";
String LOTNO = request.getParameter("LOTNO");
if (LOTNO==null) LOTNO="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String TSCPARTNO=request.getParameter("TSCPARTNO");
if (TSCPARTNO==null) TSCPARTNO="";
String A01_FLAG = request.getParameter("check1");
if (A01_FLAG==null) A01_FLAG="A01";
String ILANHUB_FLAG = request.getParameter("check2");
if (ILANHUB_FLAG==null) ILANHUB_FLAG="";
String TEW_FLAG = request.getParameter("check3");
if (TEW_FLAG==null) TEW_FLAG="";
String REEL_CHK = request.getParameter("REEL_CHK");
if (REEL_CHK==null) REEL_CHK="";
String BOX_CHK = request.getParameter("BOX_CHK");
if (BOX_CHK==null) BOX_CHK="";
String CARTON_CHK = request.getParameter("CARTON_CHK");
if (CARTON_CHK==null) CARTON_CHK="";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
String sql ="";
String FileName="",RPTName="";
int fontsize=8,reccnt=0;
try 
{ 	
	int row =0,col=0;
	OutputStream os = null;	
	RPTName = "TS_LABEL_LOG";
	FileName = RPTName+"("+UserName+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
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
	
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
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
	
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd H:mm:ss")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);	

	sql = " select a.cust_number, a.cust_name, a.so_no"+
          ",a.so_line_number, a.shipping_remark, a.item_no, a.item_desc, a.tsc_prod_group,"+
          " a.tsc_family, a.tsc_package, a.cust_partno, a.cust_po,"+
          " a.lot_number, a.lot_qty, a.date_code, a.label_code,  c.label_type_name,"+
          " to_char(a.print_date,'yyyy/mm/dd hh24:mi:ss') print_date, a.printed_by,"+
		  " a.attribute1, a.attribute1_value,"+
          " a.attribute2, a.attribute2_value,"+
		  " a.attribute3, a.attribute3_value,"+
		  " a.attribute4, a.attribute4_value,"+
          " a.attribute5, a.attribute5_value,"+
		  " a.attribute6, a.attribute6_value,"+
		  " a.attribute7, a.attribute7_value,"+
          " a.attribute8, a.attribute8_value,"+
		  " a.attribute9, a.attribute9_value,"+
		  " a.attribute10, a.attribute10_value,"+
          " a.attribute11, a.attribute11_value,"+
		  " a.attribute12, a.attribute12_value,"+
		  " a.attribute13, a.attribute13_value,"+
          " a.attribute14, a.attribute14_value,"+
		  " a.attribute15, a.attribute15_value,"+
		  " a.attribute16, a.attribute16_value,"+
          " a.attribute17, a.attribute17_value,"+
		  " a.attribute18, a.attribute18_value,"+
		  " a.attribute19, a.attribute19_value,"+
          " a.attribute20, a.attribute20_value,"+
		  " a.attribute21, a.attribute21_value,"+
		  " a.attribute22, a.attribute22_value,"+
		  " a.attribute23, a.attribute23_value,"+
          " a.attribute24, a.attribute24_value,"+
		  " a.attribute25, a.attribute25_value,"+
		  " a.attribute26, a.attribute26_value,"+
          " a.attribute27, a.attribute27_value,"+
		  " a.attribute28, a.attribute28_value,"+
		  " a.attribute29, a.attribute29_value,"+
          " a.attribute30, a.attribute30_value, "+
		  " a.location,a.wip_no,"+
	      " a.unlock_reason, a.unlock_reason_remarks, a.unlocked_by,"+
          " to_char(a.unlock_date,'yyyy/mm/dd hh24:mi:ss') unlock_date, a.unlock_group_id"+
          " from oraddman.ts_label_print_log a"+
	      " ,oraddman.ts_label_all b"+
		  " ,oraddman.ts_label_types c"+
		  " ,oraddman.ts_label_groups d"+
          " where a.label_code=b.label_code"+
          " and b.label_type_code=c.label_type_code"+
          " and b.label_group_code=d.label_group_code";
	if (!A01_FLAG.equals("") || !ILANHUB_FLAG.equals("") || !TEW_FLAG.equals(""))
	{
		sql += " and a.location in ('"+A01_FLAG+"','"+ILANHUB_FLAG+"','"+TEW_FLAG+"')";
	}
	if (!TSCPARTNO.equals(""))
	{
		String [] sArray = TSCPARTNO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and (";
			}
			else
			{
				sql += " or ";
			}
			sql += " upper(a.ITEM_DESC) like '"+sArray[x].trim().toUpperCase()+"%'";
			if (x==sArray.length -1) sql += ")";
		}
	}			  
	if (!WIPNO.equals(""))
	{
		String [] sArray = WIPNO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and a.WIP_NO in ('"+sArray[x].trim()+"'";
			}
			else
			{
				sql += (",'"+sArray[x].trim()+"'");
			}
			if (x==sArray.length -1) sql += ")";
		}
	}	
	if (!LOTNO.equals(""))
	{
		String [] sArray = LOTNO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and a.LOT_NUMBER in ('"+sArray[x].trim()+"'";
			}
			else
			{
				sql += (",'"+sArray[x].trim()+"'");
			}
			if (x==sArray.length -1) sql += ")";
		}
	}		
	if (!SDATE.equals("") || !EDATE.equals(""))
	{
		sql += " and a.PRINT_DATE between to_date(nvl('"+SDATE+"',to_char(add_months(sysdate,-24),'yyyymmdd')),'yyyymmdd') and to_date(NVL('"+EDATE+"',to_char(sysdate,'yyyymmdd')),'yyyymmdd')";
	}	
	if (!REEL_CHK.equals("") || !BOX_CHK.equals("") || !CARTON_CHK.equals(""))
	{
		sql += " and c.label_type_size in ('"+REEL_CHK+"','"+BOX_CHK+"','"+CARTON_CHK+"')";
	}
	sql += " order by a.lot_number,a.label_code,c.label_type_size,a.print_date";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			ws.addCell(new jxl.write.Label(col, row, "Customer Name" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Line#" , ACenterBLB));
			ws.setColumnView(col,6);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "料號(22D/30D)" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "客戶PO" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "WIP#" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "LOT#" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Date Code" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "Label Code" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;			

			ws.addCell(new jxl.write.Label(col, row, "Package Type" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;			

			ws.addCell(new jxl.write.Label(col, row, "列印日期" , ACenterBLB));
			ws.setColumnView(col,18);	
			col++;			

			ws.addCell(new jxl.write.Label(col, row, "列印人員" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute1" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute1_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute2" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute2_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;		

			ws.addCell(new jxl.write.Label(col, row, "attribute3" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute3_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute4" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute4_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "attribute5" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute5_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute6" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute6_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute7" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute7_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "attribute8" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute8_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute9" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute9_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute10" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute10_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute11" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute11_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "attribute12" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute12_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "attribute13" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute13_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute14" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute14_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;			
				
			ws.addCell(new jxl.write.Label(col, row, "attribute15" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute15_value" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;
			
			ws.addCell(new jxl.write.Label(col, row, "attribute16" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute16_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute17" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute17_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "attribute18" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute18_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "attribute19" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute19_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "attribute20" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute20_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute21" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute21_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute22" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute22_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "attribute23" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute23_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute24" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute24_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute25" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute25_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute26" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute26_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "attribute27" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute27_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute28" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute28_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute29" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute29_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "attribute30" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "attribute30_value" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "Unlock Reason" , ACenterBLB));
			ws.setColumnView(col,18);	
			col++;						

			ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "Unlocked by" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;																																																					

			ws.addCell(new jxl.write.Label(col, row, "Unlock Date" , ACenterBLB));
			ws.setColumnView(col,18);	
			col++;																																																					
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_NAME"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_LINE_NUMBER") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIPPING_REMARK")==null?"":rs.getString("SHIPPING_REMARK")) , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row,(rs.getString("ITEM_NO")==null?"":rs.getString("ITEM_NO")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row,(rs.getString("ITEM_DESC")==null?"":rs.getString("ITEM_DESC")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row,(rs.getString("CUST_PARTNO")==null?"":rs.getString("CUST_PARTNO")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row,(rs.getString("CUST_PO")==null?"":rs.getString("CUST_PO")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row,(rs.getString("WIP_NO")==null?"":rs.getString("WIP_NO")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row,(rs.getString("LOT_NUMBER")==null?"":rs.getString("LOT_NUMBER")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row,(rs.getString("DATE_CODE")==null?"":rs.getString("DATE_CODE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row,(rs.getString("LABEL_CODE")==null?"":rs.getString("LABEL_CODE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row,(rs.getString("LABEL_TYPE_NAME")==null?"":rs.getString("LABEL_TYPE_NAME")) , ALeftL));
		col++;	
		if (rs.getString("PRINT_DATE")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("PRINT_DATE")) ,DATE_FORMAT));
		}				
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PRINTED_BY") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE1")==null?"":rs.getString("ATTRIBUTE1")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE1_VALUE")==null?"":rs.getString("ATTRIBUTE1_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE2")==null?"":rs.getString("ATTRIBUTE2")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE2_VALUE")==null?"":rs.getString("ATTRIBUTE2_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE3")==null?"":rs.getString("ATTRIBUTE3")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE3_VALUE")==null?"":rs.getString("ATTRIBUTE3_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE4")==null?"":rs.getString("ATTRIBUTE4")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE4_VALUE")==null?"":rs.getString("ATTRIBUTE4_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE5")==null?"":rs.getString("ATTRIBUTE5")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE5_VALUE")==null?"":rs.getString("ATTRIBUTE5_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE6")==null?"":rs.getString("ATTRIBUTE6")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE6_VALUE")==null?"":rs.getString("ATTRIBUTE6_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE7")==null?"":rs.getString("ATTRIBUTE7")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE7_VALUE")==null?"":rs.getString("ATTRIBUTE7_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE8")==null?"":rs.getString("ATTRIBUTE8")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE8_VALUE")==null?"":rs.getString("ATTRIBUTE8_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE9")==null?"":rs.getString("ATTRIBUTE9")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE9_VALUE")==null?"":rs.getString("ATTRIBUTE9_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE10")==null?"":rs.getString("ATTRIBUTE10")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE10_VALUE")==null?"":rs.getString("ATTRIBUTE10_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE11")==null?"":rs.getString("ATTRIBUTE11")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE11_VALUE")==null?"":rs.getString("ATTRIBUTE11_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE12")==null?"":rs.getString("ATTRIBUTE12")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE12_VALUE")==null?"":rs.getString("ATTRIBUTE12_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE13")==null?"":rs.getString("ATTRIBUTE13")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE13_VALUE")==null?"":rs.getString("ATTRIBUTE13_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE14")==null?"":rs.getString("ATTRIBUTE14")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE14_VALUE")==null?"":rs.getString("ATTRIBUTE14_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE15")==null?"":rs.getString("ATTRIBUTE15")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE15_VALUE")==null?"":rs.getString("ATTRIBUTE15_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE16")==null?"":rs.getString("ATTRIBUTE16")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE16_VALUE")==null?"":rs.getString("ATTRIBUTE16_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE17")==null?"":rs.getString("ATTRIBUTE17")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE17_VALUE")==null?"":rs.getString("ATTRIBUTE17_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE18")==null?"":rs.getString("ATTRIBUTE18")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE18_VALUE")==null?"":rs.getString("ATTRIBUTE18_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE19")==null?"":rs.getString("ATTRIBUTE19")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE19_VALUE")==null?"":rs.getString("ATTRIBUTE19_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE20")==null?"":rs.getString("ATTRIBUTE20")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE20_VALUE")==null?"":rs.getString("ATTRIBUTE20_VALUE") ) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE21")==null?"":rs.getString("ATTRIBUTE21")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE21_VALUE")==null?"":rs.getString("ATTRIBUTE21_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE22")==null?"":rs.getString("ATTRIBUTE22")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE22_VALUE")==null?"":rs.getString("ATTRIBUTE22_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE23")==null?"":rs.getString("ATTRIBUTE23")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE23_VALUE")==null?"":rs.getString("ATTRIBUTE23_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE24")==null?"":rs.getString("ATTRIBUTE24")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE24_VALUE")==null?"":rs.getString("ATTRIBUTE24_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE25")==null?"":rs.getString("ATTRIBUTE25")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE25_VALUE")==null?"":rs.getString("ATTRIBUTE25_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE26")==null?"":rs.getString("ATTRIBUTE26")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE26_VALUE")==null?"":rs.getString("ATTRIBUTE26_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE27")==null?"":rs.getString("ATTRIBUTE27")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE27_VALUE")==null?"":rs.getString("ATTRIBUTE27_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE28")==null?"":rs.getString("ATTRIBUTE28")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE28_VALUE")==null?"":rs.getString("ATTRIBUTE28_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE29")==null?"":rs.getString("ATTRIBUTE29")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE29_VALUE")==null?"":rs.getString("ATTRIBUTE29_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE30")==null?"":rs.getString("ATTRIBUTE30")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ATTRIBUTE30_VALUE")==null?"":rs.getString("ATTRIBUTE30_VALUE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("unlock_reason")==null?"":rs.getString("unlock_reason")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("UNLOCK_REASON_REMARKS")==null?"":rs.getString("UNLOCK_REASON_REMARKS")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("UNLOCKED_BY")==null?"":rs.getString("UNLOCKED_BY")) , ALeftL));
		col++;	
		if (rs.getString("UNLOCK_DATE")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("UNLOCK_DATE")) ,DATE_FORMAT));
		}				
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
	reccnt =0;
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
	if (reccnt>0)
	{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/report/"+FileName+".xls"; 
		response.sendRedirect(strURL);	
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
