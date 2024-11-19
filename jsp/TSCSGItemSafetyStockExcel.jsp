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
<FORM ACTION="../jsp/TSCSGItemSafetyStockExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="";
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
String ITEM = request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String C_MONTH = request.getParameter("C_MONTH");
if (C_MONTH==null || C_MONTH.equals("--")) C_MONTH="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";

int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "SG_Safety_Stock_Item";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setVerticalFreeze(2);  //凍結窗格
	for (int g =1 ; g <=6 ;g++ )
	{
		sst.setHorizontalFreeze(g);
	}
	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置左-格線-底色黃
	WritableCellFormat LeftBLY = new WritableCellFormat(font_bold);   
	LeftBLY.setAlignment(jxl.format.Alignment.LEFT);
	LeftBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	LeftBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	LeftBLY.setBackground(jxl.write.Colour.YELLOW); 
	LeftBLY.setWrap(true);	

	
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
	
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);

	sql = " SELECT A.ORGANIZATION_CODE,A.ITEM_NAME,A.ITEM_DESC,A.C_MONTH,A.SAFETY_STOCK,A.TSC_PROD_GROUP,TO_CHAR(A.CREATION_DATE,'yyyy/mm/dd hh24:mi') CREATION_DATE,A.SPQ,A.SUGGEST_SAFETY_STOCK "+
		  ",tsc_inv_category(a.inventory_item_id,43,23) TSC_PACKAGE"+
		  ",CASE WHEN A.ORGANIZATION_CODE='SG1' THEN 'SG-D' ELSE 'SG-E' END ORGANIZATION_NAME"+
	      " FROM ORADDMAN.TSSG_ITEM_SAFETY_STOCK A "+
	      " WHERE 1=1";
	if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
	{
		sql += " AND A.ORGANIZATION_CODE='"+ORGCODE+"'";
	}		  
	if (!ITEM.equals(""))
	{
		sql += " AND (A.ITEM_NAME LIKE '"+ ITEM.toUpperCase()+"%' OR A.ITEM_DESC LIKE '"+ITEM.toUpperCase()+"%')";
	}
	if (!C_MONTH.equals(""))
	{
		sql += " AND a.JOB_ID IN (SELECT MAX(JOB_ID) FROM ORADDMAN.TSSG_ITEM_SAFETY_STOCK B WHERE B.C_MONTH='"+C_MONTH +"')";
	}
	sql += " order by A.ORGANIZATION_CODE,a.C_MONTH desc,a.TSC_PROD_GROUP,a.ITEM_DESC";
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;

			//org code
			ws.addCell(new jxl.write.Label(col, row, "ORG CODE" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
						
			//Calculate Month
			ws.addCell(new jxl.write.Label(col, row, "Calculate Month" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//TSC Prod Group
			ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;

			//TSC Package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;
			
			
			//Item Name
			ws.addCell(new jxl.write.Label(col, row, "Item Name" , ACenterBLB));
			ws.setColumnView(col,24);	
			col++;	

			//Item Desc
			ws.addCell(new jxl.write.Label(col, row, "Item Desc)" , ACenterBLB));
			ws.setColumnView(col,24);	
			col++;	

			//Safety Stock(PCS)
			ws.addCell(new jxl.write.Label(col, row, "Safety Stock(PCS)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//SPQ
			ws.addCell(new jxl.write.Label(col, row, "SPQ" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//Suggest Safety Stock(PCS)
			ws.addCell(new jxl.write.Label(col, row, "Suggest Safety Stock(PCS)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			row++;
		}
		col=0;

		//org code
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORGANIZATION_NAME"), ACenterL));
		col++;	
		//Calculate Month
		ws.addCell(new jxl.write.Label(col, row, rs.getString("C_MONTH"), ACenterL));
		col++;	
		//TSC Prod Group
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP") , ALeftL));
		col++;	
		//TSC package
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE") , ALeftL));
		col++;	
		//Item Name
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME") , ALeftL));
		col++;	
		//Item Desc
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"), ALeftL));
		col++;	
		//Safety Stock(PCS)
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SAFETY_STOCK")).doubleValue(), ARightL));
		col++;	
		//SPQ
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SPQ")).doubleValue(), ARightL));
		col++;
		//Suggest Safety Stock(PCS)			
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SUGGEST_SAFETY_STOCK")).doubleValue(), ARightL));
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
	if (!RTYPE.equals("AUTO"))
	{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/report/"+FileName; 
		response.sendRedirect(strURL);
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
