<!--20161106 Peggy,新增PRD外包-->
<!--20190124 Peggy,新增異動原因-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCPMDQuotationExcel.jsp" METHOD="post" name="MYFORM">
<%
String VENDOR=request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String ITEMNAME=request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String YearFr=request.getParameter("YEARFR");
if (YearFr ==null || YearFr.equals("--")) YearFr ="";
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr ==null || MonthFr.equals("--")) MonthFr="";
String DayFr=request.getParameter("DAYFR");
if (DayFr == null || DayFr.equals("--")) DayFr = "";
String YearTo=request.getParameter("YEARTO");
if (YearTo == null || YearTo.equals("--")) YearTo = "";
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo ==null || MonthTo.equals("--")) MonthTo = "";
String DayTo=request.getParameter("DAYTO");
if (DayTo == null || DayTo.equals("--")) DayTo = "";
String HIS_FLAG=request.getParameter("HIS_FLAG");
if (HIS_FLAG==null) HIS_FLAG="N";

String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="";
int fontsize=9,colcnt=0;
int row =0,col=0,reccnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	

	OutputStream os = null;	
	RPTName = "Outsourcing_Quotation_Report";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(font_nobold);   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(font_nobold);   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(font_nobold);   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
		
	if (HIS_FLAG.equals("Y"))
	{
		sql = " select a.VENDOR_NAME,b.INVENTORY_ITEM_NAME,b.ITEM_DESCRIPTION description,b.START_QTY || ' - '|| b.END_QTY QTY_RANGE,b.UNIT_PRICE,b.uom,a.CURRENCY_CODE,to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE,a.CREATED_BY_NAME,a.request_no,b.request_reason,b.TSC_PROD_GROUP,b.organization_id,tsc_inv_category(b.inventory_item_id,b.organization_id,?) tsc_package"+
              " from oraddman.tspmd_quotation_headers_all a"+
              " ,oraddman.tspmd_quotation_lines_all b"+
              ",ap.ap_supplier_sites_all d"+
              " where b.STATUS=?"+
              " and a.request_no=b.request_no "+
              " and a.vendor_site_id=d.vendor_site_id"+ 
			  " and a.creation_date >= to_date(?,'yyyymmdd')"+
              " and a.CREATION_DATE <= to_date(?,'yyyymmdd')+0.99999 "+
	          " and a.vendor_name like ?||'%'"+
			  " and (b.ITEM_DESCRIPTION like ?||'%' or  b.INVENTORY_ITEM_NAME like ?||'%')"+
			  " order by a.VENDOR_NAME,b.INVENTORY_ITEM_NAME,a.CREATION_DATE";	  
	}
	else
	{			
		sql = " select a.VENDOR_NAME,a.INVENTORY_ITEM_NAME,c.description,min(a.START_QTY)||' - '||max(a.END_QTY) QTY_RANGE,a.UOM,a.UNIT_PRICE,b.INVOICE_CURRENCY_CODE CURRENCY_CODE,to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE,d.CREATED_BY_NAME,d.request_no,d.REQUEST_REASON"+
			  " ,a.tsc_prod_group,a.organization_id"+ //add by Peggy 20161110
			  " ,tsc_inv_category(a.inventory_item_id,a.organization_id,?) tsc_package"+ //add by Peggy 20201015
			  " from oraddman.tspmd_item_quotation a,ap.ap_supplier_sites_all b,inv.mtl_system_items_b c,"+
			  " (select x.* from (select a.REQUEST_NO, a.VENDOR_CODE,a.VENDOR_SITE_ID,b.INVENTORY_ITEM_ID,b.REQUEST_REASON,a.CREATED_BY_NAME,min(b.START_QTY) || ' - '|| max(b.END_QTY) QTY_RANGE,b.UNIT_PRICE,row_number() over (partition by a.VENDOR_CODE,a.VENDOR_SITE_ID,b.INVENTORY_ITEM_ID,b.UNIT_PRICE order by b.LAST_UPDATE_DATE desc) seq_no"+
			  " from oraddman.tspmd_quotation_headers_all a,oraddman.tspmd_quotation_lines_all b"+
			  " where b.STATUS=? "+
			  " and a.request_no=b.request_no "+
			  " group by a.REQUEST_NO, a.VENDOR_CODE,a.VENDOR_SITE_ID,b.INVENTORY_ITEM_ID,a.CREATED_BY_NAME,b.UNIT_PRICE,b.LAST_UPDATE_DATE,b.REQUEST_REASON) x where seq_no=1) d "+
			  " where a.vendor_site_id=b.vendor_site_id "+
			  " and a.inventory_item_id=c.inventory_item_id"+
			  " and c.organization_id=?"+
			  " and a.vendor_site_id=d.vendor_site_id"+
			  " and a.inventory_item_id=d.inventory_item_id "+
			  " and a.UNIT_PRICE=d.UNIT_PRICE"+
	          " and a.vendor_name like ?||'%'"+
			  " and (c.description like ?||'%' or  a.inventory_item_name like ?||'%')"+			  
		//if (VENDOR!=null && !VENDOR.equals("")) sql += " and a.vendor_name like '"+VENDOR+"%'";
		//if (ITEMNAME!=null && !ITEMNAME.equals("")) sql += " and (c.description like '"+ ITEMNAME +"%' or  a.inventory_item_name like '"+ITEMNAME +"%')";
		      " group by a.VENDOR_NAME,a.INVENTORY_ITEM_NAME,c.description,a.UOM,a.UNIT_PRICE,b.INVOICE_CURRENCY_CODE ,to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi'),d.CREATED_BY_NAME ,d.request_no,a.tsc_prod_group,a.organization_id,d.REQUEST_REASON,a.inventory_item_id"+
			  " order by a.VENDOR_NAME,a.INVENTORY_ITEM_NAME";
	}
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setInt(1,23);
	statement.setString(2,"Approved");
	if (HIS_FLAG.equals("Y"))
	{	
		//out.println((YearFr.equals("")?"2012":YearFr)+(MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("")?"01":DayFr));
		//out.println((YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("")?dateBean.getDayString():DayTo));
		statement.setString(3,(YearFr.equals("")?"2012":YearFr)+(MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("")?"01":DayFr));
		statement.setString(4,(YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("")?dateBean.getDayString():DayTo));
		statement.setString(5,VENDOR);
		statement.setString(6,ITEMNAME);
		statement.setString(7,ITEMNAME);
	}
	else
	{
		statement.setInt(3,49);
		statement.setString(4,VENDOR);
		statement.setString(5,ITEMNAME);
		statement.setString(6,ITEMNAME);
	}
	ResultSet rs=statement.executeQuery();
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			//廠商名稱
			ws.addCell(new jxl.write.Label(col, row, "廠商名稱" , ACenterBLB));
			ws.setColumnView(col,50);	
			col++;	
			
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;
			
			//品名
			ws.addCell(new jxl.write.Label(col, row, "品名" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//起訖訂單量
			ws.addCell(new jxl.write.Label(col, row, "起訖訂單量" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//單位
			ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//單價
			ws.addCell(new jxl.write.Label(col, row, "單價" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//幣別
			ws.addCell(new jxl.write.Label(col, row, "幣別" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//申請日期
			ws.addCell(new jxl.write.Label(col, row, "申請日期" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//申請人
			ws.addCell(new jxl.write.Label(col, row, "申請人" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;

			//申請單號
			ws.addCell(new jxl.write.Label(col, row, "申請單號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//異動原因
			ws.addCell(new jxl.write.Label(col, row, "異動原因" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_NAME"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("INVENTORY_ITEM_NAME"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE") , ALeftL));  //add by Peggy 20201015
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("QTY_RANGE") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("uom") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("unit_price")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CURRENCY_CODE") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATION_DATE"),  ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("created_by_name") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_NO") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_REASON") , ALeftL)); //add by Peggy 20190124,新增異動原因
		col++;	
		
		row++;
		
		reccnt ++;
	}	
	wwb.write(); 
	wwb.close();

	rs.close();
	statement.close();
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
	if (reccnt >0)
	{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/report/"+FileName; 
		response.sendRedirect(strURL);
	}
	else
	{
		out.println("no data found!!");
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
