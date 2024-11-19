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
<FORM ACTION="../jsp/TSCMfgLabelPrintedExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String LOTNO = request.getParameter("LOTNO");
if (LOTNO==null) LOTNO="";
String LABEL_NAME = request.getParameter("LABEL_NAME");
if (LABEL_NAME==null) LABEL_NAME="";
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String FileName="",RPTName="",sql="",where="";
int fontsize=9,colcnt=0;
try 
{ 	

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "YEW_LABEL_PRINTED_LIST";
	FileName = RPTName+"("+UserName+")"+dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
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

	//sql = " select z.statname,replace(y.runcard_no,'*','') runcard_no,y.runcard_no orig_lotno,y.*,(SELECT listagg(a.lot_no,'<br>') within group(order by a.lot_no) FROM oraddman.tscust_label_px a  WHERE a.px_lot_no=y.runcard_no) source_lot_list"+
	sql = " select 'OLD' sys_kind, z.statname,replace(y.runcard_no,'*','') runcard_no,y.runcard_no orig_lotno,y.LABEL_TEMPFILE,y.CREATED_BY,y.PRINTED_DATE,(SELECT listagg(a.lot_no,'<br>') within group(order by a.lot_no) FROM oraddman.tscust_label_px a  WHERE a.px_lot_no=y.runcard_no) source_lot_list"+
		  ",y.unlock_reason,y.unlock_reason_remarks,NULL unlocked_by,NULL unlock_date"+
				 " from (select * from oraddman.tscust_lblprt_txns x "+
				 "       where 1=1";
	if (!LOTNO.equals("")) sql += " and runcard_no in ('"+LOTNO+"' ,'"+LOTNO+"*')";						 
		  sql += "       union all"+
				 "       select * from oraddman.tscust_lblprt_txns x "+
				 "       where 1=1 ";
	if (!LOTNO.equals("")) sql += " and exists (select 1 from oraddman.tscust_label_px c where  c.PX_LOT_NO=x.RUNCARD_NO and c.LOT_NO='"+LOTNO+"')";
		  sql += "      ) y,oraddman.tscust_label_station z "+
				 " where  y.statno=z.statno";
	if (!LABEL_NAME.equals("")) sql += " and upper(y.LABEL_TEMPFILE) like '"+LABEL_NAME.toUpperCase()+"%'";
	if (!SDATE.equals("")) sql += " and PRINTED_DATE >= '"+SDATE+"000000'";
	if (!EDATE.equals("")) sql += " and PRINTED_DATE <= '"+EDATE+"235959'";
	sql +=" union all"+
		  " select x.* from (SELECT 'NEW' sys_kind,"+
		  " CASE  c.label_kind WHEN 'TSC' THEN '台半' WHEN 'CUST' THEN '客戶' ELSE '其他' END || d.label_type_name statname,"+
		  " a.lot_number RUNCARD_NO,"+
		  " a.lot_number orig_lotno,"+
		  " a.label_code || '.lbl' LABEL_TEMPFILE,"+
		  " a.printed_by CREATED_BY,"+
		  " TO_CHAR (MAX (a.print_date), 'YYYYMMDDHH24MISS') print_date,"+
		  " NULL source_lot_list,"+
		  " a.unlock_reason,"+
		  " a.unlock_reason_remarks,"+
		  " a.unlocked_by,"+
		  " TO_CHAR (a.unlock_date, 'YYYYMMDD') unlock_date "+
		  " FROM oraddman.tsyew_label_print_log a,"+
		  " oraddman.tsyew_label_all b,"+
		  " oraddman.tsyew_label_groups c,"+
		  " oraddman.tsyew_label_types d"+
		  " WHERE a.label_code = b.label_code"+
		  " AND b.label_group_code = c.label_group_code"+
		  " AND b.label_type_code=d.label_type_code"+
		  " GROUP BY a.lot_number,a.item_no,a.item_desc, a.label_code, a.label_type, a.printed_by, a.unlock_reason,a.unlock_reason_remarks,a.unlocked_by,TO_CHAR (a.unlock_date, 'YYYYMMDD'),c.label_kind, d.label_type_name) x "+
		  " where 1=1";
	if (!LOTNO.equals("")) sql += " and x.RUNCARD_NO='"+ LOTNO+"'";
	if (!LABEL_NAME.equals("")) sql += " and upper(x.LABEL_TEMPFILE) like '"+LABEL_NAME.toUpperCase()+"%'";
	if (!SDATE.equals("")) sql += " and x.print_date >= '"+SDATE+"000000'";
	if (!EDATE.equals("")) sql += " and x.print_date <= '"+EDATE+"235959'";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;

			//system
			ws.addCell(new jxl.write.Label(col, row, "System" , ACenterBLB));
			ws.setColumnView(col,20);
			col++;	
			
			//Lot Number
			ws.addCell(new jxl.write.Label(col, row, "Lot Number" , ACenterBLB));
			ws.setColumnView(col,20);
			col++;	

			//Label Name
			ws.addCell(new jxl.write.Label(col, row, "Label Name" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			//Station
			ws.addCell(new jxl.write.Label(col, row, "Station" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Printed Date
			ws.addCell(new jxl.write.Label(col, row, "Printed Date" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Printed By
			ws.addCell(new jxl.write.Label(col, row, "Printed By" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Orig Lot Number
			ws.addCell(new jxl.write.Label(col, row, "Orig Lot Number" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Unlock Reason
			ws.addCell(new jxl.write.Label(col, row, "Unlock Reason" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Unlock Reason Descripton
			ws.addCell(new jxl.write.Label(col, row, "Unlock Reason Descripton" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("sys_kind"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("runcard_no"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("label_tempfile"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("statname") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("printed_date") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATED_BY") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SOURCE_LOT_LIST")==null?"":rs.getString("SOURCE_LOT_LIST")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("unlock_reason")==null?"":rs.getString("unlock_reason")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("unlock_reason_remarks")==null?"":rs.getString("unlock_reason_remarks")) , ALeftL));
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
