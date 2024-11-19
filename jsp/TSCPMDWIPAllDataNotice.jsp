<!--modify by Peggy 20141104,增加單價欄位,來源=oraddman.tspmd_oem_headers_all.unit_price(單價單位:k)-->
<!--modify by Peggy 20151216,增加報廢數量-->
<!-- 20161108 Peggy,新增prd 外包-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSC Outsourcing All Data Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCPMDWIPAllDataNotice.jsp" METHOD="post" name="MYFORM">
<%
String FileName="",sql="",remarks="",strPath="",wip_no="";
int fontsize=9,colcnt=0;
int row =0,col=0,reccnt=0;
String RSDATE=request.getParameter("RSDATE"); //add by Peggy 20240531
if (RSDATE==null) RSDATE="20120101";
String REDATE=request.getParameter("REDATE"); //add by Peggy 20240531
if (REDATE==null) REDATE="";
String SDATE=request.getParameter("SDATE");   //add by Peggy 20151231
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");   //add by Peggy 20151231
if (EDATE==null) EDATE="";
String ACTTYPE=request.getParameter("ACTTYPE");  //add by Peggy 20151231
if (ACTTYPE==null) ACTTYPE="";

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
			
	FileName="PMDWIPData.xls";
	if (ACTTYPE.equals(""))	
	{
		strPath ="\\resin-2.1.9\\webapps\\oradds\\PMDWIP\\"+FileName;  //add by Peggy 20210901
	}
	else
	{
		strPath ="\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName;	
	}
	//OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	OutputStream os = new FileOutputStream(strPath);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("Sheet1", 0); 
	SheetSettings sst = ws.getSettings(); 			

	sql = " select to_char(trunc(b.SCHEDULED_START_DATE),'yyyy-mm-dd') \"工單開立日\""+
	      ",a.WIP_ENTITY_NAME \"工單號碼\""+
		  ",ml.MEANING \"狀態\""+
		  ",c.segment1 \"料號\""+
		  ",c.description \"機種名稱\""+
		  ",TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Package') \"封裝別\""+
		  ",apps.tsc_get_pmd_datecode(a.wip_entity_id) \"Date Code\""+
		  ",b.START_QUANTITY \"工單數量\""+
		  ",b.QUANTITY_COMPLETED \"已收數量\""+
		  ",b.QUANTITY_SCRAPPED \"報廢數量\""+ //add by Peggy 20151216
		  ",nvl(b.START_QUANTITY,0)-nvl(b.QUANTITY_COMPLETED,0)-nvl(b.QUANTITY_SCRAPPED,0) \"未收數量\""+
		  ",to_char(trunc(b.due_date),'yyyy-mm-dd') \"預設完工日\""+
		  ",d.vendor_name \"供應商\""+
		  ",d.po \"採購單號\""+
		  ",d.CURRENCY_CODE \"幣別\""+
          ",decode(toha.UNIT_PRICE_UOM,'ea',UNIT_PRICE*1000,UNIT_PRICE) \"單價(K)\""+ //add by Peggy 20141104
		  ",d.amount \"金額\","+
          " toha.REMARKS"+
		  ",toha.PACKAGE_SPEC"+
		  ",toha.TEST_SPEC"+
		  ",tsc_get_pmd_wip_die(a.WIP_ENTITY_id) die_name"+
          " from wip.wip_entities a"+
		  ",wip_discrete_jobs b"+
		  ",inv.mtl_system_items_b c"+
          ",(select a.wip_entity_id,b.segment1 po,c.vendor_name,b.CURRENCY_CODE,sum(ROUND((d.UNIT_PRICE*d.QUANTITY),3)) amount from  po.po_distributions_all a,po.po_headers_all b,ap.ap_suppliers c,po.po_lines_all d"+
          " where a.DESTINATION_ORGANIZATION_ID=49"+ 
          " and a.wip_entity_id is not null"+
          " and a.po_header_id = b.po_header_id"+
          " and a.po_header_id = d.po_header_id"+
          " and b.vendor_id = c.vendor_id"+
          " group by a.wip_entity_id,b.segment1,c.vendor_name,b.CURRENCY_CODE) d"+
          ",mfg_lookups ml"+
          " ,(select WIP_NO,REMARKS,PACKAGE_SPEC,TEST_SPEC,UNIT_PRICE_UOM,UNIT_PRICE from oraddman.tspmd_oem_headers_all where STATUS='Approved') toha"+
          " where a.wip_entity_id = b.wip_entity_id"+
          " and a.primary_item_id=c.inventory_item_id"+
          " and a.organization_id=c.organization_id "+
          " and a.wip_entity_id = d.wip_entity_id(+)"+
		  //" and a.wip_entity_id<>3654536"+
          " and a.ORGANIZATION_ID=49"+
          " and b.status_type in (3,4,12)"+
          " and b.status_type = ml.lookup_code"+
          " and ml.lookup_type='WIP_JOB_STATUS'"+
          " AND a.WIP_ENTITY_NAME = toha.WIP_NO(+)"+	
		  " and trunc(b.SCHEDULED_START_DATE) between to_date('"+RSDATE+"','yyyymmdd') and nvl(to_date('"+REDATE+"','yyyymmdd'),trunc(add_months(sysdate,12)))+0.99999"; //add by Peggy 20240531
          //" and trunc(b.due_date) between trunc(add_months(sysdate,-24)) and trunc(add_months(sysdate,12))+0.99999"+
	if ((SDATE !=null && SDATE.equals(""))|| (EDATE !=null && EDATE.equals("")))
	{
		sql += " and trunc(b.due_date) between nvl(to_date('"+SDATE+"','yyyymmdd'),to_date('20120101','yyyymmdd')) and nvl(to_date('"+EDATE+"','yyyymmdd'),trunc(add_months(sysdate,12)))+0.99999"; //改從2012/1/1抓起,by Peggy 20141103
	}
    sql += "order by trunc(b.SCHEDULED_START_DATE)";
	//out.println(sql);
	Statement state1=con.createStatement();     
	ResultSet rs1=state1.executeQuery(sql);
	reccnt=0;
	while (rs1.next())	
	{
		if (reccnt==0)
		{
			col=0;row=0;
			sst.setSelected();
			sst.setVerticalFreeze(1);  //凍結窗格
			ResultSetMetaData md=rs1.getMetaData();
			colcnt =md.getColumnCount();

			for (int i=1;i<=colcnt;i++) 
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
				
				if (i==4 || i==5 || i==13)
				{
					ws.setColumnView(col+(i-1),30);	
				}
				else if (i==18 || i==19 || i==20)
				{
					ws.setColumnView(col+(i-1),60);	
				}
				else
				{
					ws.setColumnView(col+(i-1),15);	
				}
			}
			row++;
		}
		wip_no=rs1.getString(2);
		for (int i =1 ; i <= colcnt ; i++)
		{
			//out.println("i="+i);
			if (i==4 || i==5 || i==13)
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, (rs1.getString(i)==null?"":rs1.getString(i)) ,  ALeftL));
				ws.setColumnView(col+(i-1),30);
			}
			else if (i==18 || i==19 || i==20)
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, (rs1.getString(i)==null?"":rs1.getString(i)) ,  ALeftL));
				ws.setColumnView(col+(i-1),60);
			}
			else if (i==1 || i ==2 || i ==3 || i==12 || i==14 || i==15)
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, (rs1.getString(i)==null?"":rs1.getString(i)) , ACenterL));
				ws.setColumnView(col+(i-1),15);
			}
			else if (i==8 || i==9 || i==10 || i==11 || i ==16  || i ==17)
			{
				if (i ==16 && rs1.getString(i)==null)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, "", ARightL));
				}
				else if (rs1.getString(i)==null)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, "", ARightL));
				}
				else 
				{
					//ws.addCell(new jxl.write.Label(col+(i-1), row, (new DecimalFormat("####0.####")).format(Float.parseFloat(rs1.getString(i))) , ARightL));
					ws.addCell(new jxl.write.Number(col+(i-1), row, Double.valueOf(rs1.getString(i)).doubleValue() , ARightL));					
				}
				ws.setColumnView(col+(i-1),15);
			}
			else
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, (rs1.getString(i)==null?"":rs1.getString(i)),  ALeftL));
				ws.setColumnView(col+(i-1),15);
			}				
		}	
		reccnt++;
		row++;
	}
	
	wwb.write(); 
	wwb.close();
	
	if (reccnt>0)
	{	
		if (ACTTYPE.equals(""))	
		{
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
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tin.chang@ts.com.tw"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nora.chen@ts.com.tw"));  //add by Peggy 20160713
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("esther.yang@ts.com.tw"));  //add by Peggy 20180803
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jerry.kang@ts.com.tw "));  //add by Peggy 20210702
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("coco.chang@ts.com.tw "));  //add by Peggy 20211101
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				
			message.setSubject("PMD WIP Data List - "+dateBean.getYearMonthDay()+remarks);
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			//mbp = new javax.mail.internet.MimeBodyPart();
			//javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
			//mbp.setDataHandler(new javax.activation.DataHandler(fds));
			//mbp.setFileName(fds.getName());
		
			// create the Multipart and add its parts to it
			
			if (request.getRequestURL().toString().toLowerCase().indexOf("10.0.3.109")>=0)
			{
				mbp.setContent("<a href="+'"'+"file:///\\10.0.3.109"+strPath+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
			}
			else
			{
				if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135")>=0)
				{
					mbp.setContent("<a href="+'"'+"file:///\\10.0.1.135"+strPath+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
				}
				else
				{
					mbp.setContent("<a href="+'"'+"file:///\\10.0.1.134"+strPath+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
				}
			}			
			mp.addBodyPart(mbp);
			message.setContent(mp);
			Transport.send(message);	
		}
	}
	os.close();  
	out.close(); 	
}   
catch (Exception e) 
{ 
	con.rollback();
	out.println("Exception:"+wip_no+e.getMessage()); 
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
	if (ACTTYPE.equals("RFQ"))
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

