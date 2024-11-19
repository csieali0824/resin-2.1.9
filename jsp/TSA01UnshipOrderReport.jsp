<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,java.lang.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TS A01 Unship Order Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSA01UnshipOrderReport.jsp" METHOD="post" name="MYFORM">
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
String FileName="",RPTName="",PLANTNAME="",ERP_USERID="",remarks="",sql="";
int fontsize=8,colcnt=0,sheetcnt=0;
String v_sheet1="A01封裝未交訂單"+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TS A01 Unship Report";
	FileName = RPTName+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//WritableSheet ws = wwb.createSheet(RPTName, 0); 
	wwb.createSheet( v_sheet1, 0);
	WritableSheet ws = null;

	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold_b = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBL = new WritableCellFormat(font_bold);   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(true);	

	//英文內文水平垂直置中-粗體-格線-底色藍  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.PALE_BLUE); 
	ACenterBLB.setWrap(true);
	
	//英文內文水平垂直置中-粗體-格線-底色黃  
	WritableCellFormat ACenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLY.setBackground(jxl.write.Colour.YELLOW); 
	ACenterBLY.setWrap(true);	
	
	//英文內文水平垂直置中-粗體-格線-底色橘
	WritableCellFormat ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
	ACenterBLO.setWrap(true);	
	
	//英文內文水平垂直置中-粗體-格線-底色綠
	WritableCellFormat ACenterBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLG.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLG.setBackground(jxl.write.Colour.BRIGHT_GREEN); 
	ACenterBLG.setWrap(true);	
			
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
	
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterLB = new WritableCellFormat(font_nobold_b);   
	ACenterLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLB.setWrap(true);


	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightLB = new WritableCellFormat(font_nobold_b);   
	ARightLB.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLB.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftLB = new WritableCellFormat(font_nobold_b);   
	ALeftLB.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLB.setWrap(true);
		
	//英文內文水平垂直置中-正常-格線-底色粉紅
	WritableCellFormat ACenterLP = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterLP.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLP.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLP.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLP.setBackground(jxl.write.Colour.PINK); 	
	ACenterLP.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線-底色淺綠
	WritableCellFormat ACenterLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterLG.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLG.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
	ACenterLG.setWrap(true);	

	//英文內文水平垂直置中-正常-格線-底色粉紅-藍字
	WritableCellFormat ACenterLPB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLPB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLPB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLPB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLPB.setBackground(jxl.write.Colour.PINK); 	
	ACenterLPB.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線-底色淺綠-藍字
	WritableCellFormat ACenterLGB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLGB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLGB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLGB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLGB.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
	ACenterLGB.setWrap(true);	
		
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);

	//日期格式
	WritableCellFormat DATE_FORMAT1 = new WritableCellFormat(font_nobold_b ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT1.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT1.setWrap(true);
	
	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
	
	
	String sheetname [] = wwb.getSheetNames();
	for (int i =0 ; i < sheetname.length ; i++)
	{	
		reccnt=0;col=0;row=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings sst = ws.getSettings(); 
		sst.setSelected();
		sst.setVerticalFreeze(1);  //凍結窗格
		for (int g =1 ; g <=8 ;g++ )
		{
			sst.setHorizontalFreeze(g);
		}	
		//訂單號碼
		ws.addCell(new jxl.write.Label(col, row, "訂單號碼" , ACenterBL));
		ws.setColumnView(col,14);	
		col++;					

		//訂單項次
		ws.addCell(new jxl.write.Label(col, row, "訂單項次" , ACenterBL));
		ws.setColumnView(col,7);	
		col++;					
			
		//料號(22D)
		ws.addCell(new jxl.write.Label(col, row, "料號(22D)" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	
					
		//品名
		ws.addCell(new jxl.write.Label(col, row, "品名" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	

		//預計出貨日
		ws.addCell(new jxl.write.Label(col, row, "預計出貨日" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;	

		//PC預計出貨日
		ws.addCell(new jxl.write.Label(col, row, "PC排定出貨日" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;	

		//訂單未交量
		ws.addCell(new jxl.write.Label(col, row, "訂單未交量" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;	

		//PC排定出貨量
		ws.addCell(new jxl.write.Label(col, row, "PC排定出貨量" , ACenterBL));
		ws.setColumnView(col,15);	
		col++;	

		//嘜頭
		ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	
		
		//客戶
		ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBL));
		ws.setColumnView(col,35);	
		col++;
		
		//工單入庫量
		ws.addCell(new jxl.write.Label(col, row, "工單入庫量" , ACenterBL));
		ws.setColumnView(col,25);
		col++;
					
		//工單號
		ws.addCell(new jxl.write.Label(col, row, "工單號" , ACenterBL));
		ws.setColumnView(col,35);	
		col++;				
		
		//LOT
		ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBL));
		ws.setColumnView(col,30);	
		col++;	
		row++;
			
		sql = " select ord.so_no"+
		      ",ord.so_line_number"+
			  ",ord.line_id"+
			  ",ord.item_no"+
			  ",ord.item_desc"+
			  ",to_char(ord.schedule_ship_date,'yyyy/mm/dd') schedule_ship_date"+
			  ",to_char(tsap.pc_schedule_ship_date,'yyyy/mm/dd') pc_schedule_ship_date"+
			  ",ord.unship_qty"+
			  ",tsap.ship_qty pc_ship_qty"+
			  ",ord.shipping_remark"+
			  ",ord.customer_name"+
			  ",listagg(onhand.mono,',') within group (order by onhand.mono) wip_list"+
			  ",listagg(onhand.baselotno,',') within group (order by onhand.baselotno) lot_list"+
			  ",sum(onhand.transaction_quantity) onhand_qty"+
              " from (select oha.header_id, oha.order_number so_no,ola.line_id,ola.line_number||'.'||ola.shipment_number so_line_number,msi.segment1 item_no,msi.description item_desc,TSC_GET_REMARK_DESC(oha.header_id,'SHIPPING MARKS')  shipping_remark,SUBSTRB (party.party_name, 1, 50) customer_name"+
              "       ,ola.schedule_ship_date,ola.ordered_quantity-nvl(ola.shipped_quantity,0) unship_qty,ola.packing_instructions"+
              "       from ont.oe_order_headers_all oha,ont.oe_order_lines_all ola,inv.mtl_system_items_b msi,hz_cust_accounts cust, hz_parties party"+
              "       where ola.schedule_ship_date between add_months(trunc(sysdate),-18) and add_months(trunc(sysdate),12) +0.99999"+
              "       and oha.header_id=ola.header_id"+
              "       and oha.org_id=41"+
              "       and NVL(ola.packing_instructions,'') ='A'"+
              "       and ola.flow_status_code IN ('ENTERED','BOOKED','AWAITING_SHIPPING','AWAITING_APPROVE')"+
              "       and ola.ship_from_org_id=msi.organization_id"+
              "       and ola.inventory_item_id=msi.inventory_item_id"+
              "       and oha.sold_to_org_id=cust.cust_account_id"+
              "       and cust.party_id = party.party_id) ord"+
              "       ,tsc.tsc_shipping_advise_pc tsap"+
			  "       ,(select  tmes.rono,tmes.itemno,tmes.mono,listagg(tmes.baselotno,',') within group (order by tmes.baselotno) baselotno,sum(case when upper(erp.transaction_uom_code) ='KPC' then 1000 else 1 end * erp.transaction_quantity) as transaction_quantity"+
              "       from (select msi.segment1 ,moqd.lot_number,moqd.transaction_uom_code,moqd.transaction_quantity from inv.mtl_onhand_quantities_detail moqd,inv.mtl_system_items_b msi"+
              "       where moqd.organization_id(+)=msi.organization_id"+
              "       and moqd.inventory_item_id(+)=msi.inventory_item_id"+
              "       and msi.organization_id=606) erp"+
			  ",mesaprd.tblwiplotbasis@prod_mesprod tmes"+
              " where tmes.productno=erp.segment1(+)"+
              " and tmes.baselotno=erp.lot_number(+)"+
              " and tmes.RONO <>'N/A'"+
              " group by tmes.rono,tmes.itemno,tmes.mono) onhand"+
			  " where nvl(tsap.pc_schedule_ship_date,ord.schedule_ship_date) between to_date('"+SDATE+"','yyyymmdd') and TO_DATE('"+EDATE+"','yyyymmdd') +0.99999"+
              " and ord.line_id=tsap.so_line_id(+)"+
              " and ord.so_no=onhand.rono(+)"+
              " and ord.so_line_number=onhand.itemno(+)"+
              " and not exists (select 1 from  tsc.tsc_shipping_advise_lines tsal,tsc.tsc_pick_confirm_lines tpcl where tsal.advise_line_id=tpcl.advise_line_id and tsal.pc_advise_id = tsap.pc_advise_id)"+
              " group by ord.so_no,ord.so_line_number,ord.line_id,ord.item_no,ord.item_desc,ord.schedule_ship_date,tsap.pc_schedule_ship_date,ord.unship_qty,tsap.ship_qty,ord.shipping_remark,ord.customer_name"+
              " ORDER BY  nvl(to_char(tsap.pc_schedule_ship_date,'yyyy/mm/dd'),ord.schedule_ship_date) ,ord.so_no,to_number(ord.so_line_number)";
		//out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);		
		while (rs.next()) 
		{ 	
			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("so_no"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("so_line_number") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("item_no") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("item_desc") , ALeftL));
			col++;	
			if (rs.getString("schedule_ship_date")==null)
			{		
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("schedule_ship_date")) ,DATE_FORMAT));
			}			
			col++;	
			if (rs.getString("pc_schedule_ship_date")==null)
			{		
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("pc_schedule_ship_date")) ,DATE_FORMAT));
			}			
			col++;	
			if (rs.getString("unship_qty")==null) 
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("unship_qty")).doubleValue(), ARightL));
			}
			col++;	
			if (rs.getString("pc_ship_qty")==null) 
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("pc_ship_qty")).doubleValue(), ARightL));
			}
			col++;													
			ws.addCell(new jxl.write.Label(col, row, rs.getString("shipping_remark") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("customer_name") , ALeftL));
			col++;	
			if (rs.getString("onhand_qty")==null) 
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("onhand_qty")).doubleValue(), ARightL));
			}
			col++;
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("wip_list")==null?"":rs.getString("wip_list")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("lot_list")==null?"":rs.getString("lot_list")), ALeftL));
			col++;										
			row++;				
			reccnt++;
		}
		rs.close();
		statement.close();			
		sheetcnt++;
	}	
	wwb.write(); 
	wwb.close();

	if (sheetcnt >0)
	{
		if (!ACTTYPE.equals(""))
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
				remarks="(這是來自RFQ測試區的信件)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{
				remarks="";
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ilanmc@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jason.lin@ts.com.tw"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("vivian_tsai@ts.com.tw"));
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
			message.setHeader("Subject", MimeUtility.encodeText("A01封裝廠一個月內未交訂單"+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")"+remarks, "UTF-8", null));				
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
			mbp.setDataHandler(new javax.activation.DataHandler(fds));
			mbp.setFileName(fds.getName());
		
			// create the Multipart and add its parts to it
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
	if (ACTTYPE.equals(""))
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
