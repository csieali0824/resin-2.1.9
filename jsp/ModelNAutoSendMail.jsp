<%@ page contentType="text/html; charset=big5" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>  
<%@ page import="bean.DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="bean.DateBean"/>
<html>
<head>
<title>EDI New Order Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCEDIHistoryExcel.jsp" METHOD="post" name="MYFORM">
<%
String FileName="ModelNQuote",sql="",remarks="";
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
	
	jxl.write.DateFormat excelDateFormat = new jxl.write.DateFormat("yyyy/MM/dd");
	WritableCellFormat dateCellFormat = new WritableCellFormat(excelDateFormat);
	dateCellFormat.setAlignment(jxl.format.Alignment.CENTRE);
	dateCellFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	dateCellFormat.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	dateCellFormat.setAlignment(jxl.format.Alignment.CENTRE);



		
sql = 
"SELECT DISTINCT" +
"  AA.QUOTENUMBER AS QUOTEID, " +
"  AA.ITEMNUM AS \"POSITION\", " +
"  REGION, " +
//"  '' AS \"Created Person\", " +
//"  '' AS \"Modified Person\", " +
"  AA.SALESCHANNEL AS \"Channel\", " +
"  AA.CUSTOMER, " +
"  AA.ENDCUSTOMER AS \"END CUSTOMER\", " +
"  AA.ITEMENDCUSTOMER AS \"ITEM END CUSTOMER\", " +
"  AA.MPN AS \"PARTNUMBER\", " +
"  '' AS \"CUSTOMER PART NUMBER\", " +
"  AA.CURRENCYCODE AS \"CURRENCY\", " +
"  nvl(AA.ADJDISTICOSTDENOMINATED,0) AS \"UnitPrice(Original/PC)\", " +
"  nvl(AA.ADJDISTICOST,0) AS \"UnitPrice(USD/PC)\", " +
"  nvl(AA.QUOTEDDBCDENOMINATED,0) AS \"DistiBookCost(Original/PC)\", " +
"  nvl(AA.QUOTEDDBC,0) AS \"DistiBookCost(USD/PC)\", " +
"  AA.QUANTITY, " +
"  AA.DEALAUTHQTY, " +
"  TO_CHAR(TO_DATE(AA.STARTDATE, 'MM/DD/YYYY'), 'YYYY-MM-DD') AS \"FROMDATE\", " +
"  TO_CHAR(TO_DATE(AA.QUOTEITEMEXPIREDATE, 'MM/DD/YYYY'), 'YYYY-MM-DD') AS \"TODATE\", " +
" FROM APPS.TSC_OM_REF_MODELN_QUOTE_IMPORT AA " +
" LEFT JOIN TSC_OM_REF_MODELN_QUOTE_REGION RR ON AA.SALESCHANNEL = RR.SALESCHANNEL " +
" INNER JOIN (  " +
"     SELECT QUOTENUMBER, ITEMNUM, MAX(CREATION_DATE) CREATION_DATE  " +
"     FROM APPS.TSC_OM_REF_MODELN_QUOTE_IMPORT   " +
"     GROUP BY QUOTENUMBER, ITEMNUM  " +
" ) BB ON AA.QUOTENUMBER = BB.QUOTENUMBER AND AA.ITEMNUM = BB.ITEMNUM AND AA.CREATION_DATE = BB.CREATION_DATE  " +
" WHERE LINEWORKFLOWSTATUS NOT IN ('Cancelled', 'Rejected')";

	Statement state=con.createStatement();     
    ResultSet rs=state.executeQuery(sql);
	while (rs.next())	
	{ 
		if (reccnt==0)
		{
			ResultSetMetaData md=rs.getMetaData();
			colcnt =md.getColumnCount();

			for (int i=1;i<=colcnt;i++) 
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
				
				//if (i==7 || i==8 || i==9){
				//	ws.setColumnView(col+(i-1),40);	
				//}else if(i==10 || i==11){
				//	ws.setColumnView(col+(i-1),25);	
				//}else if(i==13 || i==14 || i==15 || i==16 || i==17 || i==18){
				//	ws.setColumnView(col+(i-1),20);	
				//}else{
					ws.setColumnView(col+(i-1),15);	
				//}
			}
			row++;
		}
		for (int i =1 ; i <= colcnt ; i++)
		{
			if (i==11 || i==12 || i==13 || i==14 || i==15 || i==16){	
				ws.addCell(new jxl.write.Label(col+(i-1), row, (new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString(i))), ARightL));
				ws.setColumnView(col+(i-1),20);
			}else if(i==17 || i==18){
				java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd"); // 這裡用 java.text
				java.util.Date date = sdf.parse(rs.getString(i));
				ws.addCell(new jxl.write.DateTime(col + (i - 1), row, date, dateCellFormat));
				ws.setColumnView(col+(i-1),15);
			}else if(i==5 || i==6 || i==7){
				ws.addCell(new jxl.write.Label(col+(i-1), row, (rs.getString(i)==null?"":rs.getString(i)) , ACenterL));
				ws.setColumnView(col+(i-1),40);		
			}else if(i==8 || i==9){
				ws.addCell(new jxl.write.Label(col+(i-1), row, (rs.getString(i)==null?"":rs.getString(i)) , ACenterL));
				ws.setColumnView(col+(i-1),25);		
			}else{
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
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
	}
	else
	{
		remarks="";
		message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ks.foo@ts.com.tw")); 
		message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("celine.yu@ts.com.tw"));
		message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("emily.hsin@ts.com.tw")); 
		message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bonnie.liu@ts.com.tw")); 
		message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("claire.weng@ts.com.tw")); 
		message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sammy.chang@ts.com.tw")); 
		message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("alice.yu@ts.com.tw")); 
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("sandy.huang@ts.com.tw"));
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
	}
		
	if (Long.parseLong(dateBean.getYearMonthDay())>=20190225) //add by Peggy 20190221
	{
		if (RPT_DATE.equals(""))
		{
			message.setSubject("ModelN Quote Data-"+dateBean.getYearMonthDay()+remarks);
		}
		else
		{
			message.setSubject("ModelN Quote Data-"+RPT_DATE+remarks);
		}
	}
	else
	{
		message.setSubject("ModelN Quote Data-"+dateBean.getYearMonthDay()+remarks);
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

