<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
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
<FORM ACTION="../jsp/TSCDeliveryScheduleExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String DELIVERY_YEAR= request.getParameter("DELIVERY_YEAR");
if (DELIVERY_YEAR==null || DELIVERY_YEAR.equals("--")) DELIVERY_YEAR="";
String SHIP_FROM = request.getParameter("SHIP_FROM");
if (SHIP_FROM==null || SHIP_FROM.equals("--")) SHIP_FROM="";
String SALES_REGION = request.getParameter("SALES_REGION");
if (SALES_REGION==null || SALES_REGION.equals("--")) SALES_REGION="";
String SHIPPING_METHOD =request.getParameter("SHIPPING_METHOD");
if (SHIPPING_METHOD==null || SHIPPING_METHOD.equals("--")) SHIPPING_METHOD="";
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=9,colcnt=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TSC_Delivery_Schedule_Report";
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
	
		
	sql = " SELECT X.DELIVERY_SCHEDULE_ID"+
	      ",X.delivery_year"+
		  ",X.ship_from"+
          ",X.sales_region"+
		  ",X.shipping_method"+
		  ",listagg(JAN,',' ) within group (order by JAN) JAN"+
          ",listagg(FEB,',' ) within group (order by FEB) FEB"+
          ",listagg(MAR,',' ) within group (order by MAR) MAR"+
          ",listagg(APR,',' ) within group (order by APR) APR"+
          ",listagg(MAY,',' ) within group (order by MAY) MAY"+
          ",listagg(JUN,',' ) within group (order by JUN) JUN"+
          ",listagg(JUL,',' ) within group (order by JUL) JUL"+
          ",listagg(AUG,',' ) within group (order by AUG) AUG"+
          ",listagg(SEP,',' ) within group (order by SEP) SEP"+
          ",listagg(OCT,',' ) within group (order by OCT) OCT"+
          ",listagg(NOV,',' ) within group (order by NOV) NOV"+
          ",listagg(DEC,',' ) within group (order by DEC) DEC"+
		  ",TO_CHAR(LAST_UPDATE_DATE,'yyyy-mm-dd') LAST_UPDATE_DATE"+
		  ",LAST_UPDATED_BY"+
          " FROM oraddman.tsc_delivery_schedule_header X, (select B.DELIVERY_SCHEDULE_ID,"+
          " case when b.MONTH_OF_YEAR ='JAN' then DAY_OF_MONTH else '' end as JAN,"+
          " case when b.MONTH_OF_YEAR ='FEB' then DAY_OF_MONTH else '' end as FEB,"+
          " case when b.MONTH_OF_YEAR ='MAR' then DAY_OF_MONTH else '' end as MAR,"+
          " case when b.MONTH_OF_YEAR ='APR' then DAY_OF_MONTH else '' end as APR,"+
          " case when b.MONTH_OF_YEAR ='MAY' then DAY_OF_MONTH else '' end as MAY,"+
          " case when b.MONTH_OF_YEAR ='JUN' then DAY_OF_MONTH else '' end as JUN,"+
          " case when b.MONTH_OF_YEAR ='JUL' then DAY_OF_MONTH else '' end as JUL,"+
          " case when b.MONTH_OF_YEAR ='AUG' then DAY_OF_MONTH else '' end as AUG,"+
          " case when b.MONTH_OF_YEAR ='SEP' then DAY_OF_MONTH else '' end as SEP,"+
          " case when b.MONTH_OF_YEAR ='OCT' then DAY_OF_MONTH else '' end as OCT,"+
          " case when b.MONTH_OF_YEAR ='NOV' then DAY_OF_MONTH else '' end as NOV,"+
          " case when b.MONTH_OF_YEAR ='DEC' then DAY_OF_MONTH else '' end as DEC"+
          " from (select DELIVERY_SCHEDULE_ID,upper(to_char(DELIVERY_SCHEDULE_DATE,'mon')) month_of_year, listagg(to_char(DELIVERY_SCHEDULE_DATE,'dd'),',' ) within group (order by DELIVERY_SCHEDULE_DATE) DAY_OF_MONTH from  oraddman.tsc_delivery_schedule_lines "+
          " group by to_char(DELIVERY_SCHEDULE_DATE,'mon'),DELIVERY_SCHEDULE_ID "+
          " order by DELIVERY_SCHEDULE_ID ) b"+
          " ORDER BY DELIVERY_SCHEDULE_ID, 2,3,4,5,6,7,8,9,10,11,12,13) Y "+
          " WHERE X.DELIVERY_SCHEDULE_ID=Y.DELIVERY_SCHEDULE_ID";
	if (!DELIVERY_YEAR.equals("")) sql += " and DELIVERY_YEAR='"+DELIVERY_YEAR+"'";
	if (!SHIP_FROM.equals("")) sql += "  and SHIP_FROM ='"+SHIP_FROM+"'";
	if (!SALES_REGION.equals("")) sql += " and SALES_REGION ='" + SALES_REGION+"'";
	if (!SHIPPING_METHOD.equals("")) sql += " and SHIPPING_METHOD='"+ SHIPPING_METHOD+"'";
    sql += " GROUP BY X.DELIVERY_SCHEDULE_ID,X.delivery_year, X.ship_from,"+
          " X.sales_region, X.shipping_method,x.LAST_UPDATE_DATE,x.LAST_UPDATED_BY";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	String destination="";
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//Year
			ws.addCell(new jxl.write.Label(col, row, "Year" , ACenterBLB));
			ws.setColumnView(col,10);
			col++;	

			//Ship From
			ws.addCell(new jxl.write.Label(col, row, "Ship From" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//Sales Region
			ws.addCell(new jxl.write.Label(col, row, "Sales Region" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
						
			//Shipping Method
			ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//JANUARY 
			ws.addCell(new jxl.write.Label(col, row, "JANUARY" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//FEBRUARY 
			ws.addCell(new jxl.write.Label(col, row, "FEBRUARY" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//MARCH 
			ws.addCell(new jxl.write.Label(col, row, "MARCH" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//APRIL
			ws.addCell(new jxl.write.Label(col, row, "APRIL" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//MAY 
			ws.addCell(new jxl.write.Label(col, row, "MAY" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//JUNE 
			ws.addCell(new jxl.write.Label(col, row, "JUNE" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//JULY 
			ws.addCell(new jxl.write.Label(col, row, "JULY" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//AUGUST 
			ws.addCell(new jxl.write.Label(col, row, "AUGUST" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			
			//SEPTEMBER
			ws.addCell(new jxl.write.Label(col, row, "SEPTEMBER" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;					
			
			//OCTOBER
			ws.addCell(new jxl.write.Label(col, row, "OCTOBER" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//NOVEMBER 
			ws.addCell(new jxl.write.Label(col, row, "NOVEMBER" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//DECEMBER
			ws.addCell(new jxl.write.Label(col, row, "DECEMBER" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DELIVERY_YEAR") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIP_FROM"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SALES_REGION")==null?"":rs.getString("SALES_REGION")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIPPING_METHOD")==null?"":rs.getString("SHIPPING_METHOD")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("JAN"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("FEB"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("MAR"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("APR"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("MAY"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("JUN"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("JUL"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("AUG"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SEP"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("OCT"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("NOV"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DEC"), ALeftL));
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
