<!-- 20170829 Peggy,蘇州/上海/深圳業務單位變更郵件domain由mail.tew.com.cn改為ts-china.com.cn-->
<!-- 20171221 Peggy,TSCH-HK RFQ region code from 002 change to 018-->
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
<FORM ACTION="../jsp/TSRFQNonConfirmedNotice.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",sql="";
Hashtable hashtb = new Hashtable();

int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "RFQ Non Confirmed List";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	//for (int g =1 ; g <=6 ;g++ )
	//{
	//	sst.setHorizontalFreeze(g);
	//}
	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置左-格線-底色黃
	WritableCellFormat LeftBLY = new WritableCellFormat(font_bold);   
	LeftBLY.setAlignment(jxl.format.Alignment.LEFT);
	LeftBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	LeftBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	LeftBLY.setBackground(jxl.write.Colour.YELLOW); 
	LeftBLY.setWrap(true);	

	
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

	sql = " SELECT X.*,Y.usermail pc_email "+
		  ",case when x.PC1_CONFIRM_DATE is not null then ceil((sysdate-to_date(x.PC1_CONFIRM_DATE,'yyyy/mm/dd hh24:mi:ss'))*24) else 0 end as second_pc_Pending_Hours"+
          //" FROM (SELECT CASE WHEN C.TSAREANO='002' AND C.CREATED_BY='TSCCSZ020' THEN 'TSCH-HK' WHEN C.TSAREANO='002' THEN 'TSCC-SH' ELSE a.ALNAME END TSGROUP"+
		  " FROM (SELECT a.ALNAME TSGROUP"+  //modify by Peggy 20171221
		  "       ,C.DNDOCNO,C.CUSTOMER,D.ITEM_SEGMENT1 ITEM_NO,D.ITEM_DESCRIPTION PART_NO,D.PRIMARY_UOM UOM"+
          "       ,to_char(TO_DATE(SUBSTR(D.REQUEST_DATE,1,8),'YYYY/MM/DD'),'yyyy/mm/dd') REQUEST_DATE"+
          "       ,D.REMARK,D.CUST_PO_NUMBER,case when d.lstatusid='014' then 'Slow Moving Confirm' else E.MANUFACTORY_NAME end MANUFACTORY_NAME"+
          "       ,D.LSTATUS,D.QUANTITY,(SELECT usermail FROM oraddman.wsuser Y WHERE Y.webid =D.CREATED_BY and nvl(Y.lockflag,'N')='N' AND ROWNUM=1) CREATED_BY_EMAIL"+
          "       ,to_char(TO_DATE(SUBSTR(D.CREATION_DATE,1,12),'YYYYMMDD hh24mi'),'yyyy/mm/dd hh24:mi') CREATION_DATE"+
          "       ,to_char((SELECT max(to_date(UPDATEDATE||UPDATETIME,'yyyymmddhh24miss'))  FROM oraddman.tsdelivery_detail_history X WHERE X.DNDOCNO=D.DNDOCNO and x.LINE_NO=D.LINE_NO and x.ORISTATUSID='014'),'yyyy/mm/dd hh24:mi') slow_moving_confirm_date"+
          "       ,to_char((SELECT max(to_date(UPDATEDATE||UPDATETIME,'yyyymmddhh24miss'))  FROM oraddman.tsdelivery_detail_history X WHERE X.DNDOCNO=D.DNDOCNO and x.LINE_NO=D.LINE_NO and x.ORISTATUSID='003'),'yyyy/mm/dd hh24:mi') pc1_confirm_date"+
          "       ,to_char((SELECT max(to_date(UPDATEDATE||UPDATETIME,'yyyymmddhh24miss'))  FROM oraddman.tsdelivery_detail_history X WHERE X.DNDOCNO=D.DNDOCNO and x.LINE_NO=D.LINE_NO and x.ORISTATUSID='004'),'yyyy/mm/dd hh24:mi') pc2_confirm_date"+
          "       ,ceil((sysdate-to_date(D.creation_date,'yyyymmddhh24miss'))*24) Pending_Hours, "+
          "       CASE  d.lstatusid WHEN '014' THEN 'RITA_ZHOU' "+
          "       WHEN '003' THEN CASE d.assign_manufact WHEN '002' THEN case when trunc(sysdate)>=to_date('20211023','yyyymmdd') then 'JUDY_Y' else 'CYTSOU' end "+
		  "                                              WHEN '005' THEN case when trunc(sysdate)>=to_date('20211023','yyyymmdd') then 'JUDY_S' else 'CYTSOU' end "+
		  "                                              WHEN '006' THEN 'ESTHER' "+
		  "                                              WHEN '008' THEN case when trunc(sysdate)>=to_date('20211023','yyyymmdd') then 'JUDY_P' else 'CYTSOU' end "+
		  "                                              WHEN '010' THEN 'MAY' "+
		  "                                              WHEN '011' THEN 'AGGIE' ELSE '' END  "+
          "       WHEN '004' THEN CASE d.assign_manufact WHEN '002' THEN 'AMANDA' WHEN '005' THEN 'ZHANGDI' WHEN '006' THEN 'TIN' WHEN '008' THEN 'PRDPC' WHEN '010' THEN 'MAY' WHEN '011' THEN 'AGGIE' ELSE '' END"+
          "       ELSE '' END AS PENDING_BY "+
          "       FROM oraddman.TSDELIVERY_NOTICE c, oraddman.TSDELIVERY_NOTICE_DETAIL d, oraddman.TSPROD_MANUFACTORY e ,ORADDMAN.TSSALES_AREA A"+
          "       WHERE c.dndocno = d.dndocno "+
          "       AND d.assign_manufact = e.manufactory_no(+) "+
          "       AND ceil((sysdate-to_date(D.creation_date,'yyyymmddhh24miss'))*24)  >=48"+
          "       AND c.tsareano = a.sales_area_no"+
          "       AND d.assign_manufact IS NOT NULL "+
          "       AND d.assign_manufact <> 'N/A'"+
          "       AND d.lstatusid IN ('003','004','014')) X ,(SELECT  UPPER(USERNAME) USERNAME,USERMAIL FROM oraddman.wsuser) Y"+
          "       WHERE x.PENDING_BY=Y.USERNAME(+)";
	//out.println(sql);
	//out.println(sqlx);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;

			//業務區
			ws.addCell(new jxl.write.Label(col, row, "Sales Region" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//RFQ號碼
			ws.addCell(new jxl.write.Label(col, row, "RFQ No" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;
			
			//客戶
			ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLB));
			ws.setColumnView(col,40);	
			col++;	

			//台半22D
			ws.addCell(new jxl.write.Label(col, row, "Item Name(22D)" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//台半品名
			ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			//客戶PO
			ws.addCell(new jxl.write.Label(col, row, "Cust PO Number" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//訂單數量
			ws.addCell(new jxl.write.Label(col, row, "RFQ Qty" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//單位
			ws.addCell(new jxl.write.Label(col, row, "UOM" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//SSD
			ws.addCell(new jxl.write.Label(col, row, "SSD" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//STATUS
			ws.addCell(new jxl.write.Label(col, row, "RFQ Status" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//REMAKRS
			ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//建立日期
			ws.addCell(new jxl.write.Label(col, row, "Creation Date" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//slow moving confirm date
			ws.addCell(new jxl.write.Label(col, row, "Slow Moving Confirm Date" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//first pc confirm date
			ws.addCell(new jxl.write.Label(col, row, "First PC Confirm Date" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//second pc confirm date
			//ws.addCell(new jxl.write.Label(col, row, "Second PC Confirm Date" , ACenterBLB));
			//ws.setColumnView(col,15);	
			//col++;	

			//工廠別
			ws.addCell(new jxl.write.Label(col, row, "Manufactory Name" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//Pending hours
			ws.addCell(new jxl.write.Label(col, row, "TOT PENDING HOURS" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;

			//Second PC Pending hours
			ws.addCell(new jxl.write.Label(col, row, "Second PC PENDING HOURS" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;

			//Pending by
			ws.addCell(new jxl.write.Label(col, row, "PENDING_BY" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			row++;
		}
		
		if (hashtb.get(rs.getString("CREATED_BY_EMAIL").toLowerCase())==null)
		{
			hashtb.put(rs.getString("CREATED_BY_EMAIL").toLowerCase(),rs.getString("CREATED_BY_EMAIL").toLowerCase());
		}
		if (hashtb.get(rs.getString("PC_EMAIL").toLowerCase())==null)
		{
			hashtb.put(rs.getString("PC_EMAIL").toLowerCase(),rs.getString("PC_EMAIL").toLowerCase());
			if (rs.getString("PC_EMAIL").toLowerCase().indexOf("cytsou")>=0) //add by Peggy 20211007
			{
				hashtb.put("judy.cho@ts.com.tw","judy.cho@ts.com.tw");
			}
		}
		if (rs.getString("TSGROUP").equals("TSCE"))
		{
			if (hashtb.get("celine.yu@ts.com.tw")==null)
			{
				hashtb.put("celine.yu@ts.com.tw","celine.yu@ts.com.tw");
			}
		}
		else if (rs.getString("TSGROUP").equals("TSCH-HK"))
		{
			//if (hashtb.get("rita_zhou@ts-china.com.cn")==null)
			//{
			//	hashtb.put("rita_zhou@ts-china.com.cn","rita_zhou@ts-china.com.cn");
			//}	
			if (hashtb.get("tschk-sample@ts-china.com.cn")==null)
			{				
				hashtb.put("tschk-sample@ts-china.com.cn","tschk-sample@ts-china.com.cn");
			}
		}
		else if (rs.getString("TSGROUP").indexOf("TSCC")>=0)
		{
			if (hashtb.get("june.wang@ts.com.tw")==null)
			{
				hashtb.put("june.wang@ts.com.tw","june.wang@ts.com.tw");
				hashtb.put("tschk-cs004@ts-china.com.cn","tschk-cs004@ts-china.com.cn");
				hashtb.put("demi_duan@ts-china.com.cn","demi_duan@ts-china.com.cn");
				if (hashtb.get("sansan@ts-china.com.cn")==null)
				{
					hashtb.put("sansan@ts-china.com.cn","sansan@ts-china.com.cn");
				}		
			}		
		}
		
		
		col=0;

		//業務區
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSGROUP") , ACenterL));
		col++;	
		
		//RFQ號碼
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DNDOCNO") , ACenterL));
		col++;
		
		//客戶
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER") , ALeftL));
		col++;	

		//台半22D
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NO") , ALeftL));
		col++;	

		//台半品名
		ws.addCell(new jxl.write.Label(col, row,  rs.getString("PART_NO") , ALeftL));
		col++;	
		
		//customer PO
		ws.addCell(new jxl.write.Label(col, row,  rs.getString("CUST_PO_NUMBER") , ALeftL));
		col++;	

		//quantity
		if (rs.getString("QUANTITY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ARightL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("QUANTITY")).doubleValue(), ARightL));
		}
		col++;	

		//uom
		ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM") , ACenterL));
		col++;	

		//SSD
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_DATE") , ACenterL));
		col++;	

		//STATUS
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LSTATUS") , ACenterL));
		col++;	

		//REMAKRS
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REMARK") , ALeftL));
		col++;	

		//creation date
		if (rs.getString("CREATION_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATION_DATE") , ACenterL));
			//ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("CREATION_DATE")) ,DATE_FORMAT));
		}
		col++;	

		//slow moving confirm date
		if (rs.getString("SLOW_MOVING_CONFIRM_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SLOW_MOVING_CONFIRM_DATE") , ACenterL));
			//ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SLOW_MOVING_CONFIRM_DATE")) ,DATE_FORMAT));
		}
		col++;	

		//first pc confirm date
		if (rs.getString("PC1_CONFIRM_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PC1_CONFIRM_DATE") , ACenterL));
			//ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("PC1_CONFIRM_DATE")) ,DATE_FORMAT));
		}
		col++;	

		//second pc confirm date
		//if (rs.getString("PC2_CONFIRM_DATE")==null)
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		//}
		//e/lse
		//{
		//	ws.addCell(new jxl.write.Label(col, row, rs.getString("PC2_CONFIRM_DATE") , ACenterL));
		//	//ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("PC2_CONFIRM_DATE")) ,DATE_FORMAT));
		//}
		//col++;	

		//工廠別
		ws.addCell(new jxl.write.Label(col, row, rs.getString("MANUFACTORY_NAME") , ALeftL));
		col++;

		//Pending hours
		if (rs.getString("PENDING_HOURS")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ARightL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PENDING_HOURS")).doubleValue(), ARightL));
		}
		col++;

		//second PC Pending hours
		if (rs.getString("second_pc_Pending_Hours")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ARightL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("second_pc_Pending_Hours")).doubleValue(), ARightL));
		}
		col++;


		//Pending by
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PENDING_BY") , ACenterL));
		col++;
		row++;
	
		reccnt ++;
	}	
	wwb.write(); 
	wwb.close();

	rs.close();
	statement.close();

	if (reccnt>0)
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
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			if (hashtb!=null)
			{
				Enumeration enkey  = hashtb.keys(); 
				while (enkey.hasMoreElements())   
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(enkey.nextElement().toString()));
				} 
			}
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("doris_lee@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("june.wang@ts.com.tw"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject(dateBean.getYear()+"/"+dateBean.getMonth()+"/"+dateBean.getDay()+"  RFQ Non_Confirmed List over 2 Days from factory"+remarks);
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
	//response.reset();
	//response.setContentType("application/vnd.ms-excel");	
	//String strURL = "/oradds/report/"+FileName; 
	//response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
