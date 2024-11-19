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
<FORM ACTION="../jsp/TSCQRAProductChangeExcel.jsp" METHOD="post" name="MYFORM">
<%
String QSEQNO = request.getParameter("QSEQNO");
if (QSEQNO==null) QSEQNO="";
String FileName="",RPTName="",sql="";
int fontsize=9,colcnt=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = QSEQNO;
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

					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();

	sql =(String)session.getAttribute("TSCQRAProductSQL");

	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;

			//TSC P/N
			ws.addCell(new jxl.write.Label(col, row, "TSC P/N" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	
			
			//Prod Group
			ws.addCell(new jxl.write.Label(col, row, "Prod Group" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Family
			ws.addCell(new jxl.write.Label(col, row, "Family" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			//Package
			ws.addCell(new jxl.write.Label(col, row, "Package" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Packing Code
			ws.addCell(new jxl.write.Label(col, row, "Packing Code" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Io(Amp)
			ws.addCell(new jxl.write.Label(col, row, "Io(Amp)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			row++;
		}
		col=0;

		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC P/N"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PROD_GROUP"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("FAMILY") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKAGE"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKING CODE"),ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("AMP")==null?"":rs.getString("AMP")), ALeftL));
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
	response.reset();
	response.setContentType("application/vnd.ms-excel");	
	String strURL = "/oradds/report/"+FileName; 
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
