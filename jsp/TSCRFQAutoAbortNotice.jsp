<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>RFQ Auto Abort Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCRFQAutoAbortNotice.jsp" METHOD="post" name="MYFORM">
<%
String v_rfq_abort_id=request.getParameter("ID");
if (v_rfq_abort_id==null) v_rfq_abort_id="0";
String sql="",FileName="",remarks="";
int fontsize=9,colcnt=0;
int row =0,col=0,reccnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
OutputStream os = null;	
try  
{ 	
	if (v_rfq_abort_id.equals("0"))
	{
		CallableStatement cse = con.prepareCall("{call TSC_RFQ_AUTO_ABORT_JOB(?)}");
		cse.registerOutParameter(1, Types.VARCHAR);  
		cse.execute();
		v_rfq_abort_id = cse.getString(1);                     
		cse.close();
	}
		
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
			
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);		
		
	sql = " select distinct tdl.ASSIGN_MANUFACT"+
		  " FROM oraddman.TSDELIVERY_NOTICE_DETAIL tdl, oraddman.TSDELIVERY_DETAIL_HISTORY tdh "+
		  " WHERE tdl.DNDOCNO = tdh.DNDOCNO"+
		  " AND tdl.line_no = tdh.line_no"+
		  " AND tdh.ORISTATUSID = '004'"+
		  " AND tdl.ASSIGN_MANUFACT='002'"+
		  " AND tdl.AUTO_ABORT_ID='"+v_rfq_abort_id+"'";
	Statement state1=con.createStatement();     
	ResultSet rs1=state1.executeQuery(sql);
	while (rs1.next())	
	{
		reccnt=0;row=0;

		FileName="RFQ_List("+rs1.getString("ASSIGN_MANUFACT")+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
		WritableWorkbook wwb = Workbook.createWorkbook(os); 
		WritableSheet ws = wwb.createSheet("Sheet1", 0); 
		SheetSettings sst = ws.getSettings(); 
	 
		sql = " select tdl.DNDOCNO \"詢問單號\" ,TDL.LINE_NO \"項次\" ,TDL.ITEM_SEGMENT1 \"料號\",TDL.ITEM_DESCRIPTION  \"品名\","+
			  " TDL.QUANTITY \"數量\",TDL.UOM  \"單位\",to_char(TO_DATE(SUBSTR(TDL.REQUEST_DATE,1,8),'yyyy/mm/dd'),'yyyy/mm/dd')  \"需求日\","+
			  " to_char(TO_DATE(SUBSTR(TDL.FTACPDATE,1,8),'yyyy/mm/dd'),'yyyy/mm/dd') \"工廠建議日\","+
			  " to_char(TO_DATE(SUBSTR(TDL.CREATION_DATE,1,8),'yyyy/mm/dd'),'yyyy/mm/dd') \"開單日\","+ 
			  " to_char(TO_DATE(SUBSTR(TDH.CDATETIME,1,8),'yyyy/mm/dd'),'yyyy/mm/dd') \"工廠回覆日\","+
			  " LSTATUS STATUS ,TM.ALNAME \"廠別\""+
			  " FROM oraddman.TSDELIVERY_NOTICE_DETAIL tdl, oraddman.TSDELIVERY_DETAIL_HISTORY tdh, "+
			  " oraddman.TSPROD_MANUFACTORY tm"+
			  " WHERE tdl.DNDOCNO = tdh.DNDOCNO"+
			  " AND tdl.line_no = tdh.line_no"+
			  " AND TM.MANUFACTORY_NO = TDL.ASSIGN_MANUFACT "+
			  " AND tdh.ORISTATUSID = '004'"+
			  " AND tdl.ASSIGN_MANUFACT='"+rs1.getString("ASSIGN_MANUFACT")+"'"+
			  " AND tdl.AUTO_ABORT_ID='"+v_rfq_abort_id+"'"+
			  " ORDER BY  TDL.ITEM_DESCRIPTION,tdl.DNDOCNO, TDL.LINE_NO";
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
					if (i==3 || i==4)
					{
						ws.setColumnView(col+(i-1),30);	
					}
					else
					{
						ws.setColumnView(col+(i-1),20);	
					}
				}
				row++;
			}
			for (int i =1 ; i <= colcnt ; i++)
			{
				if (i <=4)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) ,  ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) ,  ACenterL));
				}
			}	
			reccnt++;
			row++;
		}
		wwb.write(); 
		wwb.close();
		
		rs.close();
		state.close();
		 
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
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				remarks="(此為測試信件，請勿理會)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{
				remarks="";
				if (rs1.getString("ASSIGN_MANUFACT").equals("002"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("amanda@mail.tsyew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ice@mail.tsyew.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("mable@mail.tsyew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("hana@mail.tsyew.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zhang_qiang@mail.tsyew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("shirley@mail.tsyew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("eleen@mail.tsyew.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bruce@mail.tsyew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("yifan.cao@mail.tsyew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wan_xueming@mail.tsyew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("song_xiaodi@mail.tsyew.com.cn"));  //add by Peggy 20210930
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(" lixia.wang@mail.tsyew.com.cn"));  //add by Peggy 20230703
				}	
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				
			message.setHeader("Subject", MimeUtility.encodeText("RFQ abort reply - ABORT 回覆超過三日業務未生成訂單"+remarks, "UTF-8", null));	
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
      		mbp.setContent("", "text/html;charset=UTF-8");
			mp.addBodyPart(mbp);
			mbp = new javax.mail.internet.MimeBodyPart();
			javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
			mbp.setDataHandler(new javax.activation.DataHandler(fds));
			mbp.setFileName(fds.getName());
		
			// create the Multipart and add its parts to it
			mp.addBodyPart(mbp);
			message.setContent(mp);
			Transport.send(message);	
		}
	}
	rs1.close();
	state1.close();
	os.close();  
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

