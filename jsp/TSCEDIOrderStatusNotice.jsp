<!--20190225 Peggy,add End customer part name-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSC EDI Order Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCEDIOrderStatusNotice.jsp" METHOD="post" name="MYFORM">
<%
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
	
	//英文內文水平垂直置左-正常-格線-紅字   
	WritableCellFormat ALeftLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ALeftLR.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLR.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線-紅字   
	WritableCellFormat ACenterLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLR.setWrap(true);

	//英文內文水平垂直置左-正常-格線-藍字   
	WritableCellFormat ALeftLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ALeftLB.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLB.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線-藍字   
	WritableCellFormat ACenterLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLB.setWrap(true);				
			
	FileName="EDI Order Notice.xls";
	
	OutputStream os = null;	
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	int sheet_cnt =0;
	sql = " SELECT distinct b.cust_shortname  FROM tsc_edi_orders_his_h a,tsc_edi_customer b WHERE NVL(MAILED_FLAG,'N')='N'  and a.erp_customer_id=b.customer_id";
	Statement state=con.createStatement();     
	ResultSet rs=state.executeQuery(sql);
	while (rs.next())	
	{	
		wwb.createSheet(rs.getString("cust_shortname"), sheet_cnt);
		sheet_cnt++;
	}
	rs.close();
	state.close();
		
	WritableSheet ws = null;
	String sheetname [] = wwb.getSheetNames();
	for (int k =0 ; k < sheetname.length ; k++)
	{			  
		sql = " SELECT c.customer_name \"Custer Name\","+
			  " decode(a.ORDER_TYPE,'ORDERS','New Order','Order Change') \"Order Type\","+
			  " a.request_no \"Request No\","+
			  " a.REQUEST_DATE \"Request Date\","+
		      " a.customer_po \"P/O No\","+
			  " b.cust_po_line_no \"Customer PO Line No\","+
			  " b.cust_item_name \"Customer P/N\","+
			  " b.tsc_item_name \"Part Number\","+
			  " decode(b.ACTION_CODE,'2',0,b.quantity) Qty,"+
			  " b.Uom,"+
			  " to_char(b.unit_price,'999990.99999') \"U/P\","+
			  " a.currency_code \"Currency\","+
			  " b.cust_request_date CRD,"+
			  " case when b.data_flag='Y' then '成功' when b.ACTION_CODE='1' and  b.data_flag<>'Y' then '資料異常待確認' when b.ACTION_CODE='2' and  b.data_flag<>'Y' then 'Order Cancel待確認' when b.ACTION_CODE='3' and  b.data_flag<>'Y' then 'Order Change待確認' else '異常' end as  Result,"+
			  //" case when nvl(b.RFQ_QTY,0) >0 and b.data_flag='Y' then 'RFQ:'|| b.dndocno || '  LINE:' ||b.line_no else b.ERR_EXPLANATION end as Remarks, "+
			  " case when nvl(b.RFQ_QTY,0) >0 and b.data_flag='Y' then 'RFQ:'|| b.dndocno || '  LINE:' ||b.line_no  else '' end"+
			  " || case when nvl(b.erp_order_qty,0)>0 and b.data_flag='Y' then 'ERP MO#:'||b.erp_order_no|| '  Line#:'||b.erp_order_line_no else '' end"+
			  " || b.ERR_EXPLANATION  as Remarks, "+
			  " b.ORIG_CUST_ITEM_NAME \"Orig Cust Item Name\","+
			  " b.ORIG_TSC_ITEM_NAME \"Orig TSC Item Name\","+
			  " a.ERP_CUSTOMER_ID"+
              " FROM tsc_edi_orders_his_h a,tsc_edi_orders_his_d b,TSC_EDI_CUSTOMER c,oraddman.tsdelivery_notice_detail d"+
              " where a.request_no=b.request_no"+
              " and a.erp_customer_id=c.customer_id"+
              " and b.dndocno = d.dndocno(+)"+
              " AND b.line_no = d.line_NO(+)"+
			  " AND NVL(a.MAILED_FLAG,'N')='N'"+
			  " AND c.CUST_SHORTNAME='"+ sheetname[k]+"'"+
              "order by a.Order_Type,a.Request_No,to_number(b.cust_po_line_no)";
		//out.println(sql);
		Statement state1=con.createStatement();     
		ResultSet rs1=state1.executeQuery(sql);
		reccnt=0;
		while (rs1.next())	
		{
			if (reccnt==0)
			{
				col=0;row=0;
				ResultSetMetaData md=rs1.getMetaData();
				colcnt =md.getColumnCount();

				for (int i=1;i<=colcnt-1;i++) 
				{
					ws = wwb.getSheet(sheetname[k]);
					ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
					
					if (i==1 || i==15)
					{
						ws.setColumnView(col+(i-1),30);	
					}
					else if (i==3 || i ==5 || i ==7 || i==8 || i ==14)
					{
						ws.setColumnView(col+(i-1),25);	
					}
					else
					{
						ws.setColumnView(col+(i-1),15);	
					}
				}
				row++;
			}
			for (int i =1 ; i <= colcnt-1 ; i++)
			{
				if (i==1)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) ,  ALeftL));
					ws.setColumnView(col+(i-1),30);
				}
				else if (i==3 || i ==5 || i ==7 || i==8)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) ,  ALeftL));
					ws.setColumnView(col+(i-1),25);
				}
				else if (i==2 || i ==3 || i ==4 || i==10 || i==12 || i==13)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row,rs1.getString(i),  ACenterL));
					ws.setColumnView(col+(i-1),15);
				}
				else if (i==14)
				{
					if (rs1.getString(i).equals("成功"))
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) , ACenterLB));
						ws.setColumnView(col+(i-1),25);					
					}
					else
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) , ACenterLR));
						ws.setColumnView(col+(i-1),25);
					}
				}
				else if (i==9)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, (new DecimalFormat("#,###,###,##0")).format(Float.parseFloat(rs1.getString(i))) ,  ARightL));
					ws.setColumnView(col+(i-1),15);
				}
				else if (i==11)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i),  ARightL));
					ws.setColumnView(col+(i-1),15);
				}				
				else if (i==15)
				{
					if (rs1.getString(14).equals("成功"))
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) ,  ALeftLB));
						ws.setColumnView(col+(i-1),40);
					}
					else
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) ,  ALeftLR));
						ws.setColumnView(col+(i-1),40);
					}
				}
				else 
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) , ALeftL));
					ws.setColumnView(col+(i-1),15);
				}
			}	
			reccnt++;
			totcnt++;
			row++;
			
			sql = " update tsc_edi_orders_his_h "+
			      " set MAILED_FLAG =?"+
				  " where REQUEST_NO=?"+
				  " and ERP_CUSTOMER_ID =?";
			PreparedStatement pstmtDtl=con.prepareStatement(sql);	
			pstmtDtl.setString(1,"Y"); 
			pstmtDtl.setString(2,rs1.getString("Request No"));			  
			pstmtDtl.setString(3,rs1.getString("ERP_CUSTOMER_ID"));			  
			pstmtDtl.executeQuery();
			pstmtDtl.close();
		}
	}
	if (totcnt >0)
	{
		wwb.write(); 
		wwb.close();
			
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
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
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("celine.yu@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("emily.hsin@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sammy.chang@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Dieter.Leinert@tsceu.com"));  //add by Peggy 20210125
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("cynthia.tseng@ts.com.tw"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("EDI Order Notice - "+dateBean.getYearMonthDay()+remarks);
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		String str_d = "<font style='font-size:14px;font-family:Times New Roman;'>當Remark欄位出現紅字訊息,表示資料異常,請到<a href='http://tsrfq.ts.com.tw:8080/oradds/jsp/TSCEDIExceptionQuery.jsp'>RFQ D9-002</a> 功能畫面進行確認,謝謝!<p><p>"+
					   "P.S此為系統自動發送的EMAIL信件，請勿直接回信，謝謝!";
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
		con.commit();
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

