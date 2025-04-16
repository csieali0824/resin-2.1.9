<!--20190221 Peggy,2019/2/25起由weekly改為daily-->
<%@ page contentType="text/html; charset=big5" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
	<title>EDI New Order Notice</title>
	<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCEDIHistoryExcel.jsp" METHOD="post" name="MYFORM">
	<%
		String FileName="EDI_NEW_ORDER_LIST",sql="",remarks="";
		String RPT_DATE=request.getParameter("RPT_DATE");
		if (RPT_DATE==null) RPT_DATE="";
		String RPT_NAME="";
		int fontsize=9,colcnt=0;
		try
		{
			int row =0,col=0,reccnt=0;
			OutputStream os = null;
			if (RPT_DATE.equals(""))
			{
				RPT_NAME ="\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+"-"+dateBean.getYearMonthDay()+".xls";
			}
			else
			{
				RPT_NAME ="\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+"-"+RPT_DATE+".xls";
			}
			os = new FileOutputStream(RPT_NAME);
			WritableWorkbook wwb = Workbook.createWorkbook(os);
			WritableSheet ws = wwb.createSheet("Sheet1", 0);
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

			sql = " SELECT  d.CUSTOMER_NUMBER \"Customer ID\""+
					",c.customer_name \"Customer\""+
					",a.customer_po \"Customer PO#\""+
					",a.request_date \"PO Receiving Date\""+
					",b.cust_po_line_no \"Customer PO Line No.\""+
					",b.cust_item_name \"Customer P/N\""+
					",b.tsc_item_name \"Part Number\""+
					",b.quantity Qty"+
					",b.uom UNIT"+
					",b.cust_request_date CRD"+
					",a.CURRENCY_CODE \"Currency\""+
					",b.unit_price \"U/P\""+
					",to_char(b.quantity*b.unit_price) \"Total Price\""+
					",b.quote_number \"Quote Number\""+  //add by Peggy 20190415
					",a.creation_date"+
					" from tsc_edi_orders_his_h a, tsc_edi_orders_his_d b,tsc_edi_customer c,ar_customers d"+
					" where a.order_type='ORDERS'"+
					" AND a.request_no=b.request_no"+
					" AND a.erp_customer_id=b.erp_customer_id"+
					" AND a.erp_customer_id=c.customer_id"+
					" AND a.erp_customer_id=d.customer_id";
			//" AND a.CREATION_DATE between trunc(SYSDATE-7)+22/24 and trunc(SYSDATE)+22/24"+
			if (RPT_DATE.equals(""))
			{
				sql += " AND a.CREATION_DATE between trunc(SYSDATE-CASE WHEN trunc(SYSDATE)>=TO_DATE('20190225','yyyymmdd') THEN 1 ELSE 7 END)+22/24 and trunc(SYSDATE)+22/24";  //modify by Peggy 20190221
			}
			else
			{
				sql += " AND a.CREATION_DATE between (TO_DATE('"+RPT_DATE+"','yyyymmdd')-1)+22/24 and TO_DATE('"+RPT_DATE+"','yyyymmdd')+22/24";  //modify by Peggy 20190221
			}
			sql += " ORDER BY c.customer_name, a.customer_po,a.request_no,TO_NUMBER(b.cust_po_line_no)";
			Statement state=con.createStatement();
			ResultSet rs=state.executeQuery(sql);
			while (rs.next())
			{
				if (reccnt==0)
				{
					ResultSetMetaData md=rs.getMetaData();
					colcnt =md.getColumnCount();

					for (int i=1;i<=colcnt-1;i++)
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
						if (i==2 || i==6 || i==7)
						{
							ws.setColumnView(col+(i-1),30);
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
					if (i==2 || i==6 || i==7)
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) ,  ALeftL));
						ws.setColumnView(col+(i-1),30);
					}
					else if (i==12)
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, (new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString(i))), ARightL));
						ws.setColumnView(col+(i-1),15);
					}
					else if (i==8 || i==13)
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row,rs.getString(i) , ARightL));
						ws.setColumnView(col+(i-1),15);
					}
					else
					{
						ws.addCell(new jxl.write.Label(col+(i-1), row, (rs.getString(i)==null?"":rs.getString(i)) , ACenterL));
						ws.setColumnView(col+(i-1),15);
					}
				}
				reccnt++;
				row++;
			}
			wwb.write();
			wwb.close();
			os.close();
			out.close();

			rs.close();
			state.close();

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
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("fabian.storek@tsceu.com"));   //modify by Peggy 20190221
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("dieter.leinert@tsceu.com"));   //modify by Peggy 20190221
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("emily.hsin@ts.com.tw"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rachel.chen@ts.com.tw"));
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));

			if (Long.parseLong(dateBean.getYearMonthDay())>=20190225) //add by Peggy 20190221
			{
				if (RPT_DATE.equals(""))
				{
					message.setSubject("EDI NEW ORDER LIST-"+dateBean.getYearMonthDay()+remarks);
				}
				else
				{
					message.setSubject("EDI NEW ORDER LIST-"+RPT_DATE+remarks);
				}
			}
			else
			{
				message.setSubject("EDI Weekly Report-"+dateBean.getYearMonthDay()+remarks);
			}
			javax.mail.internet.MimeBodyPart mbp1 = new javax.mail.internet.MimeBodyPart();
			javax.activation.FileDataSource fds = new javax.activation.FileDataSource(RPT_NAME);
			mbp1.setDataHandler(new javax.activation.DataHandler(fds));
			mbp1.setFileName(fds.getName());

			// create the Multipart and add its parts to it
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			mp.addBodyPart(mbp1);

			message.setContent(mp);
			Transport.send(message);
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
</html>

