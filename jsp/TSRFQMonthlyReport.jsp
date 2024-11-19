<!-- 20170829 Peggy,蘇州/上海/深圳業務單位變更郵件domain由mail.tew.com.cn改為ts-china.com.cn-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.text.DecimalFormat,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSRFQMonthlyReport.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",sql = "",sql1="",sql2="",sql3="",sql4="";
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String YearFr= request.getParameter("YEARFR");
if (YearFr==null) YearFr="";
String MonthFr= request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="";
String YearTo= request.getParameter("YEARTO");
if (YearTo==null) YearTo="";
String MonthTo= request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="";
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
if (RTYPE.equals("AUTO"))
{
	YearTo=dateBean.getYearString();
	MonthTo=dateBean.getMonthString();
	dateBean.setAdjMonth(-11);
	YearFr=dateBean.getYearString();
	MonthFr=dateBean.getMonthString();
	dateBean.setAdjMonth(11);
}
String UserName = request.getParameter("UserName");
if (UserName==null) UserName="";
String ACODE=request.getParameter("ACODE");
if ( ACODE==null) ACODE="";
int colnum=1;
if (ACODE.equals("$$$$$") || UserName.indexOf("PEGGY_CHEN")>=0) colnum=0;
int rowcnt=0,fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "RFQOrderQtyOverView";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	for (int g =1 ; g <=6 ;g++ )
	{
		sst.setHorizontalFreeze(g);
	}
	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_noboldred = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置右-正常-格線-底色綠  
	WritableCellFormat ARightLGreen = new WritableCellFormat(font_nobold);   
	ARightLGreen.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLGreen.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLGreen.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLGreen.setBackground(jxl.write.Colour.BRIGHT_GREEN); 
	ARightLGreen.setWrap(true);

	//英文內文水平垂直置右-正常-格線-底色黃  
	WritableCellFormat ARightLYellow = new WritableCellFormat(font_nobold);   
	ARightLYellow.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLYellow.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLYellow.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLYellow.setBackground(jxl.write.Colour.YELLOW); 
	ARightLYellow.setWrap(true);

	//英文內文水平垂直置右-正常-格線-底色粉紅  
	WritableCellFormat ARightLPink = new WritableCellFormat(font_nobold);   
	ARightLPink.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLPink.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLPink.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLPink.setBackground(jxl.write.Colour.ROSE); 
	ARightLPink.setWrap(true);
	
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
	
	//英文內文水平垂直靠右-字體紅色
	WritableCellFormat ARightRED = new WritableCellFormat(font_noboldred);   
	ARightRED.setAlignment(jxl.format.Alignment.RIGHT);
	ARightRED.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightRED.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightRED.setWrap(true);	
	
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();

	sql = " SELECT TOG.GROUP_NAME sales_group"+
		  ",c.customer"+
		  ",CASE WHEN TOG.GROUP_NAME='TSCH-HK' THEN case when INSTR(a.cust_po_number,'(')>0 then substr(a.cust_po_number,instr(a.cust_po_number,'(')+1,instr(a.cust_po_number,')',-1)-instr(a.cust_po_number,'(')-1) else a.cust_po_number end ELSE NVL(ACS.customer_name_phonetic, ACS.CUSTOMER_NAME) END as end_customer"+
		  ",a.item_segment1 item_name"+
		  ",a.item_description item_desc"+
		  //",substr(listagg( '0'||to_char(selling_price)||',', '') within group (order by TOG.GROUP_NAME,a.creation_date desc),1,instr(listagg( to_char(selling_price)||',', '') within group (order by TOG.GROUP_NAME,a.creation_date desc),',')) selling_price"+
		  ",a.uom";
	Statement statement1=con.createStatement(); 
	sql1 =" SELECT to_char(ADD_MONTHS(TO_DATE('"+YearFr+MonthFr+"01','YYYYMMDD'),ROWNUM-1),'yyyymm') mon_value"+
		  ",TO_CHAR(ADD_MONTHS(TO_DATE('"+YearFr+MonthFr+"01','YYYYMMDD'),ROWNUM-1),'YYYY MON') MONTHS "+
		  ",(MONTHS_BETWEEN(to_date('"+YearTo+MonthTo+"01','yyyymmdd'),to_date('"+YearFr+MonthFr+"01','yyyymmdd'))+1)-rownum row_cnt"+
		  " FROM DUAL CONNECT BY ROWNUM<=MONTHS_BETWEEN(to_date('"+YearTo+MonthTo+"01','yyyymmdd'),to_date('"+YearFr+MonthFr+"01','yyyymmdd'))+1";
	//out.println(sql1);
	ResultSet rs1=statement1.executeQuery(sql1);
	while (rs1.next()) 
	{ 	
		sql += ",sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity else 0 end) as \""+rs1.getString(2)+"\"";
		if (rs1.getInt(3)==1 || rs1.getInt(3)==2  || rs1.getInt(3)==3)
		{
			if (!sql2.equals("")) sql2+= "+";
			sql2 += " sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity else 0 end)";
		}
		if (rs1.getInt(3)==0)
		{
			sql3 =" ,round((sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity else 0 end)-sum(case when substr(a.creation_date,1,6)=substr(to_char(add_months(to_date('"+rs1.getString(1)+"01','yyyymmdd'),-1),'yyyymmdd'),1,6) then a.quantity else 0 end))/ case when sum(case when substr(a.creation_date,1,6)=substr(to_char(add_months(to_date('"+rs1.getString(1)+"01','yyyymmdd'),-1),'yyyymmdd'),1,6) then a.quantity else 0 end)=0 then 1 else sum(case when substr(a.creation_date,1,6)=substr(to_char(add_months(to_date('"+rs1.getString(1)+"01','yyyymmdd'),-1),'yyyymmdd'),1,6) then a.quantity else 0 end) end *100,2) as \"當月下單率(與上月比)\""+
			      " ,sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity*NVL(a.selling_price,0)*1000 else 0 end)-sum(case when substr(a.creation_date,1,6)=substr(to_char(add_months(to_date('"+rs1.getString(1)+"01','yyyymmdd'),-1),'yyyymmdd'),1,6) then a.quantity*NVL(a.selling_price,0)*1000 else 0 end) as \"當月金額差(與上月比)\""+
				  " ,sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity*NVL(a.selling_price,0)*1000 else 0 end) 當月下單金額 ";
			sql4 =" sum(case when substr(a.creation_date,1,6)='"+rs1.getString(1)+"' then a.quantity*NVL(a.selling_price,0)*1000 else 0 end)-sum(case when substr(a.creation_date,1,6)=substr(to_char(add_months(to_date('"+rs1.getString(1)+"01','yyyymmdd'),-1),'yyyymmdd'),1,6) then a.quantity*NVL(a.selling_price,0)*1000 else 0 end)";
		}
	}
	rs1.close();
	statement1.close();
	
	if (!sql2.equals(""))
	{
		sql +=",to_char(round(("+sql2+")/3,2),'99990D099') \"前三個月平圴下單量\"";
	}
	if (!sql3.equals(""))
	{
		sql += sql3;
	}
			 
	sql += " FROM oraddman.tsdelivery_notice_detail a"+
		  ",oraddman.tsdelivery_notice c"+
		  ",HZ_CUST_SITE_USES_ALL hcsu"+
		  ",TSC_OM_GROUP TOG"+
		  ",AR_CUSTOMERS ACS"+
		  " WHERE SUBSTR(A.CREATION_DATE,1,6)>="+YearFr+MonthFr+
		  " AND SUBSTR(A.CREATION_DATE,1,6)<="+YearTo+MonthTo+
		  " AND A.DNDOCNO=C.DNDOCNO"+
		  " AND C.SHIP_TO_ORG=hcsu.SITE_USE_ID "+
		  " AND TO_NUMBER(hcsu.ATTRIBUTE1) = TOG.GROUP_ID"+
		  " AND A.END_CUSTOMER_ID=ACS.CUSTOMER_ID(+)"+
		  " AND A.LSTATUSID NOT IN ('012','001')";
	if (!salesGroup.equals("--") && !salesGroup.equals(""))
	{
		sql += " AND TOG.GROUP_NAME='"+salesGroup+"'";
	}
	
	if (!CUST.equals(""))
	{
		sql += " and CASE WHEN TOG.GROUP_NAME='TSCH-HK' THEN case when INSTR(a.cust_po_number,'(')>0 then substr(a.cust_po_number,instr(a.cust_po_number,'(')+1,instr(a.cust_po_number,')',-1)-instr(a.cust_po_number,'(')-1) else a.cust_po_number end ELSE NVL(NVL(ACS.customer_name_phonetic, ACS.CUSTOMER_NAME),c.customer) END like '%"+CUST+"%'";
	}

	if (!ITEMDESC.equals(""))
	{
		sql += " and a.item_description like '"+ITEMDESC+"%'";
	}	
	
	sql += " group by TOG.GROUP_NAME,c.tscustomerid,c.customer,CASE WHEN TOG.GROUP_NAME='TSCH-HK' THEN case when INSTR(a.cust_po_number,'(')>0 then substr(a.cust_po_number,instr(a.cust_po_number,'(')+1,instr(a.cust_po_number,')',-1)-instr(a.cust_po_number,'(')-1) else a.cust_po_number end ELSE NVL(ACS.customer_name_phonetic, ACS.CUSTOMER_NAME) END ,a.item_segment1,a.item_description,a.uom"+
		   " order by ("+sql4+"),item_description,end_customer,a.item_segment1";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			ResultSetMetaData md=rs.getMetaData();
			colcnt=md.getColumnCount();
			for(int icol =1 ; icol <= colcnt-colnum ; icol++)
			{
				ws.addCell(new jxl.write.Label(col, row, md.getColumnLabel(icol) , ACenterBLB));
				ws.setColumnView(col,((icol ==2 || icol==3 || icol==4 || icol==5)?20:13));	
				col++;	
			}
			row++;
		}
		col=0;

		for(int icol =1 ; icol <= colcnt-colnum ; icol++)
		{
			if (icol>=7)
			{
				if (icol==colcnt-3)
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString(icol)).doubleValue(), ARightLGreen));
				}
				else if (icol == colcnt-2)
				{
					if (rs.getInt(icol)<=-30)
					{
						ws.addCell(new jxl.write.Label(col, row, rs.getString(icol)+"%", ARightLPink));
					}
					else if (rs.getInt(icol)>=50)
					{
						ws.addCell(new jxl.write.Label(col, row, rs.getString(icol)+"%", ARightLYellow));
					}
					else
					{
						ws.addCell(new jxl.write.Label(col, row, rs.getString(icol)+"%", ARightL));
					}
				}
				else if (icol == colcnt-1)
				{
					if (rs.getInt(icol)<0)
					{

						//ws.addCell(new jxl.write.Label(col, row, "("+rs.getString(icol).replace("-","")+")", ARightRED));
						ws.addCell(new jxl.write.Label(col, row, "("+(new DecimalFormat("#,###,###.####")).format(Float.parseFloat(rs.getString(icol).replace("-","")))+")",  ARightRED));
					}				
					else
					{
						ws.addCell(new jxl.write.Label(col, row, rs.getString(icol), ARightL));
					}
				}
				else if (icol == colcnt)
				{
					ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("#,###,###.####")).format(Float.parseFloat(rs.getString(icol))), ARightL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString(icol)).doubleValue(), ARightL));
				}
			}
			else
			{
				ws.addCell(new jxl.write.Label(col, row, rs.getString(icol), ALeftL));
			}
			col++;	
		}
		row++;
		
		reccnt ++;
	}	
	wwb.write(); 
	wwb.close();

	rs.close();
	statement.close();

	if (RTYPE.equals("AUTO") && reccnt>0)
	{
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		String remarks="";

		
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
			if (colnum==0)
			{
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("amy.liu@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jodie@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("SANSAN@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Sophia_li@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-Sample@ts-china.com.cn"));
			}
			else
			{
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wendy_cai@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Fiona_chen@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Sandy_sun@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sky@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Regina_pu@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Angel_He@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-Sample@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS001@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS002@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS003@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs004@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS005@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS006@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("TSCHK-CS007@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs008@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tingting@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Shelly@ts-china.com.cn"));
			}
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("TSCH Order Qty Overview - "+dateBean.getYearMonthDay()+remarks);
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		mbp = new javax.mail.internet.MimeBodyPart();
		javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		mbp.setDataHandler(new javax.activation.DataHandler(fds));
		mbp.setFileName(fds.getName());
	
		// create the Multipart and add its parts to it
		mp.addBodyPart(mbp);
		message.setContent(mp);
		Transport.send(message);	
	}	 
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
