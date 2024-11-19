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
<FORM ACTION="../jsp/TSCDateCodeExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String TSCPACKAGE = request.getParameter("TSCPACKAGE");
if (TSCPACKAGE==null) TSCPACKAGE="";
String TSCDATECODE = request.getParameter("TSCDATECODE");
if (TSCDATECODE==null) TSCDATECODE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String TSCPARTNO=request.getParameter("TSCPARTNO");
if (TSCPARTNO==null) TSCPARTNO="";
String PRD_FLAG = request.getParameter("check1");
if (PRD_FLAG==null) PRD_FLAG="";
String SSD_FLAG = request.getParameter("check2");
if (SSD_FLAG==null) SSD_FLAG="";
String PMD_FLAG = request.getParameter("check3");
if (PMD_FLAG==null) PMD_FLAG="";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
String sql ="";
String FileName="",RPTName="";
int fontsize=9,reccnt=0;
try 
{ 	

	int row =0,col=0;
	OutputStream os = null;	
	RPTName = "TSC_DATECODE_LIST";
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
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);	

	sql = " SELECT a.year"+
		  ",a.date_type"+
		  ",a.date_value"+
		  ",a.date_code"+
		  ",a.prod_group"+
		  ",a.vendor"+
		  ",a.customer"+
		  ",a.factory_code"+
		  ",a.green_flag"+
		  ",to_char(to_date(case date_type when 'MONTH' THEN year||LPAD(DATE_VALUE,2,'0') ||'01' WHEN 'WEEK' then '20'||tsc_get_calendar_date(year||lpad(date_value,2,'0'),null) else '' end,'yyyymmdd'),'yyyy/mm/dd') as manufacture_date"+
		  ",case date_type when 'MONTH' then TO_CHAR(a.date_value) else '' end as MONTH"+
		  ",case date_type when 'WEEK' then TO_CHAR(a.date_value) else '' end as WEEK"+
		  ",a.dc_rule"+
		  " FROM tsc.tsc_date_code a"+
		  " where 1=1 ";
	if (!PRD_FLAG.equals("")|| !SSD_FLAG.equals("") || !PMD_FLAG.equals(""))
	{
		sql += " and a.prod_group in ('"+PRD_FLAG+"','"+SSD_FLAG+"','"+PMD_FLAG+"')";
	}
	//if (!TSCPACKAGE.equals("") && !TSCPACKAGE.equals("--"))
	//{
	//	String [] strPackage = TSCPACKAGE.split("\n");
	//	String PackageList = "";
	//	for (int x = 0 ; x < strPackage.length ; x++)
	//	{
	//		if (PackageList.length() >0) PackageList += ",";
	//		PackageList += "'"+strPackage[x].trim().toUpperCase()+"'";
	//	}
	//	sql += " and exists (select 1 from inv.mtl_system_items_b msi where msi.organization_id=43 substr(tsc_inv_category(msi.inventory_item_id,43,1100000003),1,3)=a.prod_group and tsc_inv_category(msi.inventory_item_id,43,23) IN  ("+PackageList+"))";
	//}
	if (!TSCPARTNO.equals(""))
	{
		String [] sArray = TSCPARTNO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and exists (select 1 from inv.mtl_system_items_b msi where msi.organization_id=43 and substr(tsc_inv_category(msi.inventory_item_id,43,1100000003),1,3)=a.prod_group and (upper(msi.description) like '"+sArray[x].trim().toUpperCase()+"%'";
			}
			else
			{
				sql += " or upper(msi.description) like '"+sArray[x].trim().toUpperCase()+"%'";
			}
			if (x==sArray.length -1) sql += "))";
		}
	}
	if (!TSCDATECODE.equals(""))
	{
		String [] strDC = TSCDATECODE.split("\n");
		String DCList = "";
		for (int x = 0 ; x < strDC.length ; x++)
		{
			if (x==0)
			{
				sql += " and (a.date_code like '"+strDC[x].trim()+"'";
			}
			else
			{
				sql += " or a.date_code like '"+strDC[x].trim()+"'";
			}				
			if (x==strDC.length -1) sql +=")";
		}
	}	
	if (!SDATE.equals("") || !EDATE.equals(""))
	{
		sql += " and to_date(case date_type when 'MONTH' THEN year||LPAD(DATE_VALUE,2,'0') ||'01' WHEN 'WEEK' then '20'||tsc_get_calendar_date(year||lpad(date_value,2,'0'),null) else '' end,'yyyymmdd') between to_date(nvl('"+SDATE+"','"+(Integer.parseInt(dateBean.getYearString())-3)+"0101'),'yyyymmdd') and to_date(NVL('"+EDATE+"','20991231'),'yyyymmdd')";
	}	

	sql +=" order by decode(a.prod_group,'PRD',1,'PMD',2,3),a.YEAR,a.DC_RULE,a.DATE_TYPE,a.DATE_VALUE,a.DATE_CODE";
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			

			//Division
			ws.addCell(new jxl.write.Label(col, row, "Division" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//TSC D/C
			ws.addCell(new jxl.write.Label(col, row, "TSC D/C" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//D/C(Year)
			ws.addCell(new jxl.write.Label(col, row, "D/C(Year)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//"D/C(Month)
			ws.addCell(new jxl.write.Label(col, row, "D/C(Month)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//D/C(Week)
			ws.addCell(new jxl.write.Label(col, row, "D/C(Week)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//D/C(DATE)
			ws.addCell(new jxl.write.Label(col, row, "D/C(YYYY/MM/DD)" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//D/C Rule
			ws.addCell(new jxl.write.Label(col, row, "DC Rule" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PROD_GROUP"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("YEAR") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("MONTH")==null?"":rs.getString("MONTH")) , ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row,(rs.getString("WEEK")==null?"":rs.getString("WEEK")) , ALeftL));
		col++;	
		if (rs.getString("MANUFACTURE_DATE")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("MANUFACTURE_DATE")) ,DATE_FORMAT));
		}				
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DC_RULE") , ALeftL));
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
