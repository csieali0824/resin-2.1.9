<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,java.lang.*,java.util.Date"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>YEW Material Receive Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSYewMaterialReceiveReport.jsp" METHOD="post" name="MYFORM">
<%
String RPTTYPE = request.getParameter("RPTTYPE");
if (RPTTYPE==null) RPTTYPE="";
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE= request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String FileName="",sql="",remarks="";
int fontsize=9,colcnt=0;
int row =0,col=0,reccnt=0,totcnt=0;

try  
{ 	
	//英文內文水平垂直置中-粗體-格線   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(false);

	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(false);

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(false);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(false);
	
	//英文內文水平垂直置左-正常-格線-紅字   
	WritableCellFormat ALeftLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ALeftLR.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLR.setWrap(false);	
	
	//英文內文水平垂直置中-正常-格線-紅字   
	WritableCellFormat ACenterLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLR.setWrap(false);

	//英文內文水平垂直置左-正常-格線-藍字   
	WritableCellFormat ALeftLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ALeftLB.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLB.setWrap(false);
	
	//英文內文水平垂直置中-正常-格線-藍字   
	WritableCellFormat ACenterLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLB.setWrap(false);				
			
	FileName="YEW Material Receive Report-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	
	OutputStream os = null;	
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("receive", 0);	
	
	sql = " select mp.organization_code,msi.segment1,msi.description,mmt.transaction_date transaction_date,mtln.lot_number,mmt.transaction_quantity,mmt.transaction_uom,sha.receipt_num,pha.segment1 po_no,pla.line_num"+
          " from inv.mtl_material_transactions  mmt,po.rcv_transactions  rc,inv.mtl_system_items_b msi,po.rcv_shipment_headers sha,po.po_headers_all pha,po.po_lines_all pla,mtl_parameters mp,inv.mtl_transaction_lot_numbers mtln"+
          " where mmt.organization_id in (326,327)"+
          " and mmt.rcv_transaction_id=rc.transaction_id"+
          " and mmt.organization_id=msi.organization_id"+
          " and mmt.inventory_item_id=msi.inventory_item_id"+
          " and msi.item_type not in ('SA','FG')"+
          " and rc.shipment_header_id=sha.shipment_header_id"+
          " and rc.po_header_id=pha.po_header_id"+
          " and rc.po_header_id=pla.po_header_id"+
          " and rc.po_line_id=pla.po_line_id"+
          " and mmt.organization_id=mp.organization_id"+
          " and mmt.transaction_id=mtln.transaction_id";
	if (RPTTYPE.equals("AUTO1"))
	{
    	sql +=" and mmt.transaction_date between (to_date('"+SDATE+"','YYYYMMDD')-1)+(17/24) and to_date('"+EDATE+"','YYYYMMDD')+(12/24)+0.99999";
	}
	else
	{
    	sql +=" and mmt.transaction_date between (to_date('"+SDATE+"','YYYYMMDD'))+(12/24) and to_date('"+EDATE+"','YYYYMMDD')+(17/24)+0.99999";
	}
	//out.println(sql);
	Statement state1=con.createStatement();     
	ResultSet rs1=state1.executeQuery(sql);
	reccnt=0;
	while (rs1.next())	
	{
		reccnt++;
		if (reccnt==1)
		{
			col=0;row=0;
			ws.addCell(new jxl.write.Label(col, row, "內外銷" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;
			ws.addCell(new jxl.write.Label(col, row, "品名" , ACenterBL));
			ws.setColumnView(col,35);	
			col++;				
			ws.addCell(new jxl.write.Label(col, row, "收貨日" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;				
			ws.addCell(new jxl.write.Label(col, row, "批號" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;				
			ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;				
			ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;				
			ws.addCell(new jxl.write.Label(col, row, "驗收單" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;				
			ws.addCell(new jxl.write.Label(col, row, "採購單" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;				
			ws.addCell(new jxl.write.Label(col, row, "採購單項次" , ACenterBL));
			ws.setColumnView(col,10);
			col++;				
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs1.getString("ORGANIZATION_CODE"),ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs1.getString("SEGMENT1") ,  ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs1.getString("DESCRIPTION") ,  ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs1.getString("TRANSACTION_DATE") ,  ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs1.getString("LOT_NUMBER") ,  ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs1.getString("TRANSACTION_QUANTITY") ,  ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs1.getString("TRANSACTION_UOM") ,  ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs1.getString("RECEIPT_NUM") ,  ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs1.getString("PO_NO") ,  ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs1.getString("LINE_NUM") ,  ALeftL));
		col++;
		row++;
	}
	if (reccnt>=0)
	{
		wwb.write(); 
		wwb.close();
		rs1.close();
		state1.close();

		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			props.put("mail.smtp.host", "mail3.ts.com.tw");
		}
		else
		{
			props.put("mail.smtp.host", "mail.ts.com.tw");
		}
		props.put("mail.smtp.port", "25");
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("mr@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TK@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("yuan@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("dice@mail.tsyew.com.cn"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		if (RPTTYPE.equals("AUTO1"))
		{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	      	Date dt = sdf.parse(SDATE);  
	      	Calendar v_sdate = Calendar.getInstance();  
	      	v_sdate.setTime(dt);  
	      	v_sdate.add(Calendar.DAY_OF_MONTH, -1);  
  		  	message.setSubject("YEW Material Receive Report("+ (sdf.format(v_sdate.getTime())) +" 1500 - "+EDATE+" 1159)"+remarks);
		}
		else
		{
			message.setSubject("YEW Material Receive Report("+SDATE +" 1200 - "+EDATE+" 1659)"+remarks);
		}			
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		String str_d = "P.S此為系統自動發送的EMAIL信件，請勿直接回信，謝謝!";
		mbp.setContent(str_d, "text/html;charset=UTF-8");
		mp.addBodyPart(mbp);
		mbp = new javax.mail.internet.MimeBodyPart();
		javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		mbp.setDataHandler(new javax.activation.DataHandler(fds));
		mbp.setFileName(fds.getName());
	
		// create the Multipart and add its parts to it
		mp.addBodyPart(mbp);
		message.setContent(mp);
		Transport.send(message);	
		os.close();  
	}
}   
catch (Exception e) 
{ 
	con.rollback();
	out.println("Exception:"+e.getMessage()); 
} 
out.close(); 
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

