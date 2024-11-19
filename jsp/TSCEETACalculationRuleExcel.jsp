<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSCE ETA Calculation Rule</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCEETACalculationRuleExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",DEPTNAME="",sql="";
int fontsize=9,colcnt=0;

try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	FileName = "ETA Caculation Rule_"+dateBean.getYearMonthDay();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("sheet1", 0); 
	SheetSettings sst = ws.getSettings(); 
	
	//英文內文水平垂直置中-粗體-格線   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(true);

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
	
	sql = " SELECT a.shipping_method, a.location, a.fob_term, a.oc_delivery_days,"+
          " a.invoice_delivery_days,b.COUNTRY_NAME,b.TRANSIT_DAYS"+
          " FROM oraddman.tsce_acceptance_rule a,oraddman.tsce_acceptance_rule_cust b"+
          " WHERE a.INCOTERM=b.INCOTERM(+)"+
          " order by a.shipping_method, a.location, a.fob_term";
	//out.println(sql);
	Statement state=con.createStatement();     
    ResultSet rs=state.executeQuery(sql);
	while (rs.next())	
	{ 
		if (reccnt==0)
		{
			col=0;
			ws.addCell(new jxl.write.Label(col, row, "SHIPPING METHOD" , ACenterBL));
			ws.setColumnView(col,20);
			col++;
			
			ws.addCell(new jxl.write.Label(col, row, "SHIP-FROM LOCATION" , ACenterBL));
			ws.setColumnView(col,20);
			col++;
			
			ws.addCell(new jxl.write.Label(col, row, "INCOTERMS" , ACenterBL));
			ws.setColumnView(col,20);
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "RFQ/OC DELIVERY_DAYS" , ACenterBL));
			ws.setColumnView(col,20);
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "INVOICE DELIVERY DAYS" , ACenterBL));
			ws.setColumnView(col,20);
			col++;		

			ws.addCell(new jxl.write.Label(col, row, "COUNTRY NAME" , ACenterBL));
			ws.setColumnView(col,30);
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "DAP COUNTRY TRANSIT DAYS" , ACenterBL));
			ws.setColumnView(col,20);
			col++;											
							
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("shipping_method") , ALeftL));
		col++;
		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("location") , ALeftL));
		col++;
		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("fob_term") , ALeftL));
		col++;
		
		//ws.addCell(new jxl.write.Label(col, row, rs.getString("oc_delivery_days") ,ARightL));
		ws.addCell(new jxl.write.Number(col,row, Double.valueOf(rs.getString("oc_delivery_days")).doubleValue() ,ARightL));
		col++;
		
		//ws.addCell(new jxl.write.Label(col, row, rs.getString("invoice_delivery_days") , ARightL));
		ws.addCell(new jxl.write.Number(col,row, Double.valueOf(rs.getString("invoice_delivery_days")).doubleValue() ,ARightL));
		col++;
		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("COUNTRY_NAME") , ALeftL));
		col++;
		
		if (rs.getString("TRANSIT_DAYS") != null)
		{		
			ws.addCell(new jxl.write.Number(col,row, Double.valueOf(rs.getString("TRANSIT_DAYS")).doubleValue() ,ARightL));
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ARightL));
		}
		col++;										

		reccnt++;
		row++;
	}
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 
	
	rs.close();
	state.close();
	 
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
