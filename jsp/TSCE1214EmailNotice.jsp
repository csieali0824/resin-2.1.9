<%@ page contentType="text/html; charset=big5" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
	<title>TSCE Hub PO List Notice</title>
	<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCE1214EmailNotice.jsp" METHOD="post" name="MYFORM">
	<%
		String FileName="",sql="",remarks="";
		String V_BATCH_ID = request.getParameter("V_BATCH_ID");
		if (V_BATCH_ID ==null) V_BATCH_ID="";
		int fontsize=9,colcnt=0;
		int row =0,col=0,reccnt=0;
		try
		{
			if (!V_BATCH_ID.equals(""))
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

				sql = " select source_file_name from oraddman.tsce_purchase_order_headers a "+
						" WHERE a.BATCH_ID = '"+ V_BATCH_ID+"' and rownum=1";
				//out.println(sql);
				Statement statex=con.createStatement();
				ResultSet rsx=statex.executeQuery(sql);
				if (rsx.next())
				{
					FileName=rsx.getString("source_file_name");
				}
				else
				{
					FileName="PurchaseOrder_"+dateBean.getYearMonthDay()+".xls";
				}
				rsx.close();
				statex.close();

				OutputStream os = null;
				os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
				WritableWorkbook wwb = Workbook.createWorkbook(os);
				WritableSheet ws = wwb.createSheet("Sheet1", 0);
				SheetSettings sst = ws.getSettings();

				sql = " SELECT X.SEQNO"+
						",x.CUSTOMER_PO \"CUSTOMER PO\""+
						",X.PO_LINE_NO \"PO LINE NO\""+
						",X.TSC_PART_NO \"TSC PARTNO\""+
						",X.CUST_PART_NO \"CUST PARTNO\""+
						",X.CRD"+
						",X.QUANTITY"+
						",X.UOM"+
						",X.UNIT_PRICE \"UNIT_PRICE\""+
						",X.CURRENCY_CODE \"CURRENCY CODE\""+
						",X.SUPPLIER_NUMBER \"SUPPLIER NUMBER\""+  //add by Peggy 20220210
						",DECODE(X.DATA_FLAG,'Y','成功','異常') RESULT"+
						",DECODE(X.DATA_FLAG,'Y','RFQ:'||X.RFQ||' LINE:'||X.RFQ_LINE_NO,X.EXCEPTION_DESC) REMARK"+
						" FROM (SELECT CUSTOMER_PO"+
						"       ,PO_LINE_NO"+
						"       ,CRD"+
						"       ,TSC_PART_NO"+
						"       ,CUST_PART_NO"+
						"       ,QUANTITY"+
						"       ,UOM"+
						"       ,to_char(UNIT_PRICE,'999990.99999') UNIT_PRICE"+
						"       ,CURRENCY_CODE"+
						"       ,SUPPLIER_NUMBER"+ //add by Peggy 20220210
						"       ,DATA_FLAG"+
						"       ,RFQ"+
						"       ,RFQ_LINE_NO"+
						"       ,EXCEPTION_DESC"+
						"       ,row_number() over (order by CUSTOMER_PO,PO_LINE_NO) SEQNO"+
						" FROM ORADDMAN.TSCE_PURCHASE_ORDER_LINES A"+
						" WHERE EXISTS (SELECT 1 FROM ORADDMAN.TSCE_PURCHASE_ORDER_HEADERS B"+
						"               WHERE B.BATCH_ID = '"+ V_BATCH_ID+"'"+
						"               AND B.CUSTOMER_PO = A.CUSTOMER_PO"+
						"               AND B.VERSION_ID = A.VERSION_ID)"+
						" AND A.DATA_FLAG <>'X'"+
						" ORDER BY CUSTOMER_PO,PO_LINE_NO) X ";
				//out.println(sql);
				Statement state1=con.createStatement();
				ResultSet rs1=state1.executeQuery(sql);
				reccnt=0;
				while (rs1.next())
				{
					if (reccnt==0)
					{
						ResultSetMetaData md=rs1.getMetaData();
						colcnt =md.getColumnCount();

						for (int i=1;i<=colcnt;i++)
						{
							ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
							if (i==1 || (i >6 && i <12))
							{
								ws.setColumnView(col+(i-1),15);
							}
							else if (i==13)
							{
								ws.setColumnView(col+(i-1),40);
							}
							else
							{
								ws.setColumnView(col+(i-1),30);
							}
						}
						row++;
					}
					for (int i =1 ; i <= colcnt ; i++)
					{
						if (i==1)
						{
							ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) ,  ALeftL));
							ws.setColumnView(col+(i-1),10);
						}
						else if (i==6 || i ==8 || i ==10 || i==11)
						{
							ws.addCell(new jxl.write.Label(col+(i-1), row,rs1.getString(i),  ACenterL));
							ws.setColumnView(col+(i-1),15);
						}
						else if (i==12)
						{
							if (rs1.getString(i).equals("成功"))
							{
								ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) , ACenterLB));
								ws.setColumnView(col+(i-1),15);
							}
							else
							{
								ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) , ACenterLR));
								ws.setColumnView(col+(i-1),15);
							}
						}
						else if (i==7)
						{
							ws.addCell(new jxl.write.Label(col+(i-1), row, (new DecimalFormat("#,###,###,##0")).format(Float.parseFloat(rs1.getString(i))) ,  ARightL));
							ws.setColumnView(col+(i-1),15);
						}
						else if (i==9)
						{
							ws.addCell(new jxl.write.Label(col+(i-1), row, rs1.getString(i) ,  ARightL));
							ws.setColumnView(col+(i-1),15);
						}
						else if (i==13)
						{
							if (rs1.getString(12).equals("成功"))
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
							ws.setColumnView(col+(i-1),30);
						}
					}
					reccnt++;
					row++;
				}
				wwb.write();
				wwb.close();

				if (reccnt >0)
				{
					Properties props = System.getProperties();
					props.put("mail.transport.protocol","smtp");
					props.put("mail.smtp.host", "mail.ts.com.tw");
					props.put("mail.smtp.port", "25");

					Session s = Session.getInstance(props, null);
					javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
					message.setSentDate(new java.util.Date());
					message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
					if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 &&  request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
					{
						remarks="(This is a test letter, please ignore it)";
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
					}
					else
					{
						remarks="";
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("emily.hsin@ts.com.tw"));
					}
					message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));

					message.setSubject("Order Notice: TSCE HUB PO-"+dateBean.getYearMonthDay()+remarks);
					javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
					javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
					String str_d = "<font style='font-size:14px;font-family:Times New Roman;'>當Remark欄位出現紅字訊息,表示資料異常,請到<a href='http://tsrfq.ts.com.tw:8080/oradds/jsp/TSCE1214ExceptionQuery.jsp'>RFQ D11-002</a> 功能畫面進行確認,謝謝!<p><p>"+
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
				}
				rs1.close();
				state1.close();
				os.close();
			}
		}
		catch (Exception e)
		{
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

