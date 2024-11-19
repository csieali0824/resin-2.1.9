<!-- 20170829 Peggy,蘇州/上海/深圳業務單位變更郵件domain由mail.tew.com.cn改為ts-china.com.cn-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Email Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSSalesOrderSalcompNotice.jsp" METHOD="post" name="MYFORM">
<%
String sql = "",sql1="",sql2="",sql3="",remarks="";
String FileName="",RPTName="";
int fontsize=8,colcnt=0,row=0,col=0,reccnt=0,dn_cnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");

try 
{ 	
	OutputStream os = null;	
	//sql = " SELECT X.DELIVERY_NAME,X.CARTON_NUM||X.POST_FIX_CODE CARTON_NUM,X.ITEM_DESC,X.CUST_PARTNO,X.LOT_NUMBER,X.DATE_CODE,NVL(X.V_CUST_FAMILY,'LJF')||X.VENDOR_BATCH_NO||NVL(X.V_FACTORY_CODE,'1101') VENDOR_BATCH_NO,SUM(X.LOT_QTY) QUANTITY"+
	/*
	sql = " SELECT X.DELIVERY_NAME,X.CARTON_NUM||X.POST_FIX_CODE CARTON_NUM,X.ITEM_DESC,X.CUST_PARTNO,X.LOT_NUMBER,X.DATE_CODE,X.CUST_LOT VENDOR_BATCH_NO,SUM(X.LOT_QTY) QUANTITY"+
          " FROM (SELECT DISTINCT C.NAME DELIVERY_NAME,a.cust_number, a.cust_name, a.so_no, a.so_header_id,"+
          "       a.so_line_id, a.so_line_number, a.shipping_remark,a.inventory_item_id, a.item_no, a.item_desc, a.tsc_prod_group,"+
          "       a.tsc_family, a.tsc_package, a.cust_partno, a.cust_po,a.advise_no, a.advise_header_id, a.advise_line_id, a.carton_num,"+
          "       a.lot_number, a.lot_qty, a.date_code, a.label_code,d.post_fix_code,"+
		  "       CASE 'V_CUST_LOT' WHEN a.attribute1 THEN  a.attribute1_value"+
          "       WHEN a.attribute2 THEN a.attribute2_value"+
          "       WHEN a.attribute3 THEN a.attribute3_value"+
          "       WHEN a.attribute4 THEN a.attribute4_value"+
          "       WHEN a.attribute5 THEN a.attribute5_value"+
          "       WHEN a.attribute6 THEN a.attribute6_value"+
          "       WHEN a.attribute7 THEN a.attribute7_value"+
          "       WHEN a.attribute8 THEN a.attribute8_value"+
          "       WHEN a.attribute9 THEN a.attribute9_value"+
          "       WHEN a.attribute10 THEN a.attribute10_value"+
          "       WHEN a.attribute11 THEN a.attribute11_value"+
          "       WHEN a.attribute12 THEN a.attribute12_value"+ 
          "       WHEN a.attribute13 THEN a.attribute13_value"+
          "       WHEN a.attribute14 THEN a.attribute14_value"+
          "       WHEN a.attribute15 THEN a.attribute15_value"+
          "       WHEN a.attribute16 THEN a.attribute16_value"+
          "       WHEN a.attribute17 THEN a.attribute17_value"+
          "       WHEN a.attribute18 THEN a.attribute18_value"+
          "       WHEN a.attribute19 THEN a.attribute19_value"+
          "       WHEN a.attribute20 THEN a.attribute20_value"+
          "       WHEN a.attribute21 THEN a.attribute21_value"+
          "       WHEN a.attribute22 THEN a.attribute22_value"+ 
          "       WHEN a.attribute23 THEN a.attribute23_value"+
          "       WHEN a.attribute24 THEN a.attribute24_value"+
          "       WHEN a.attribute25 THEN a.attribute25_value"+
          "       WHEN a.attribute26 THEN a.attribute26_value"+
          "       WHEN a.attribute27 THEN a.attribute27_value"+
          "       WHEN a.attribute28 THEN a.attribute28_value"+
          "       WHEN a.attribute29 THEN a.attribute29_value"+
          "       WHEN a.attribute30 THEN a.attribute30_value END AS CUST_LOT"+
		  //"       CASE 'V_VendorFamilyDefinition' WHEN a.attribute1 THEN  a.attribute1_value"+
          //"       WHEN a.attribute2 THEN a.attribute2_value"+
          //"       WHEN a.attribute3 THEN a.attribute3_value"+
          //"       WHEN a.attribute4 THEN a.attribute4_value"+
          //"       WHEN a.attribute5 THEN a.attribute5_value"+
          //"       WHEN a.attribute6 THEN a.attribute6_value"+
          //"       WHEN a.attribute7 THEN a.attribute7_value"+
          //"       WHEN a.attribute8 THEN a.attribute8_value"+
          //"       WHEN a.attribute9 THEN a.attribute9_value"+
          //"       WHEN a.attribute10 THEN a.attribute10_value"+
          //"       WHEN a.attribute11 THEN a.attribute11_value"+
          //"       WHEN a.attribute12 THEN a.attribute12_value"+ 
          //"       WHEN a.attribute13 THEN a.attribute13_value"+
          //"       WHEN a.attribute14 THEN a.attribute14_value"+
          //"       WHEN a.attribute15 THEN a.attribute15_value"+
          //"       WHEN a.attribute16 THEN a.attribute16_value"+
          //"       WHEN a.attribute17 THEN a.attribute17_value"+
          //"       WHEN a.attribute18 THEN a.attribute18_value"+
          //"       WHEN a.attribute19 THEN a.attribute19_value"+
          //"       WHEN a.attribute20 THEN a.attribute20_value END AS V_CUST_FAMILY,"+
          //"       CASE 'V_DC_WEEK' WHEN a.attribute1 THEN  a.attribute1_value"+
          //"       WHEN a.attribute2 THEN  a.attribute2_value"+
          //"       WHEN a.attribute3 THEN   a.attribute3_value"+
          //"       WHEN a.attribute4 THEN a.attribute4_value"+
          //"       WHEN a.attribute5 THEN a.attribute5_value"+
          //"       WHEN a.attribute6 THEN a.attribute6_value"+
          //"       WHEN a.attribute7 THEN a.attribute7_value"+
          //"       WHEN a.attribute8 THEN a.attribute8_value"+
          //"       WHEN a.attribute9 THEN a.attribute9_value"+
          //"       WHEN a.attribute10 THEN a.attribute10_value"+
          //"       WHEN a.attribute11 THEN a.attribute11_value"+
          //"       WHEN a.attribute12 THEN a.attribute12_value"+ 
          //"       WHEN a.attribute13 THEN a.attribute13_value"+
          //"       WHEN a.attribute14 THEN a.attribute14_value"+
          //"       WHEN a.attribute15 THEN a.attribute15_value"+
          //"       WHEN a.attribute16 THEN a.attribute16_value"+
          //"       WHEN a.attribute17 THEN a.attribute17_value"+
          //"       WHEN a.attribute18 THEN a.attribute18_value"+
          //"       WHEN a.attribute19 THEN a.attribute19_value"+
          //"       WHEN a.attribute20 THEN a.attribute20_value END AS VENDOR_BATCH_NO,"+
          //"       CASE 'V_FactoryDefinition' WHEN a.attribute1 THEN  a.attribute1_value"+
          //"       WHEN a.attribute2 THEN  a.attribute2_value"+
          //"       WHEN a.attribute3 THEN   a.attribute3_value"+
          //"       WHEN a.attribute4 THEN a.attribute4_value"+
          //"       WHEN a.attribute5 THEN a.attribute5_value"+
          //"       WHEN a.attribute6 THEN a.attribute6_value"+
          //"       WHEN a.attribute7 THEN a.attribute7_value"+
          //"       WHEN a.attribute8 THEN a.attribute8_value"+
          //"       WHEN a.attribute9 THEN a.attribute9_value"+
          //"       WHEN a.attribute10 THEN a.attribute10_value"+ 
          //"       WHEN a.attribute11 THEN a.attribute11_value"+
          //"       WHEN a.attribute12 THEN a.attribute12_value"+
          //"       WHEN a.attribute13 THEN a.attribute13_value"+
          //"       WHEN a.attribute14 THEN a.attribute14_value"+
          //"       WHEN a.attribute15 THEN a.attribute15_value"+
          //"       WHEN a.attribute16 THEN a.attribute16_value"+
          //"       WHEN a.attribute17 THEN a.attribute17_value"+
          //"       WHEN a.attribute18 THEN a.attribute18_value"+
          //"       WHEN a.attribute19 THEN a.attribute19_value"+
          //"       WHEN a.attribute20 THEN a.attribute20_value END AS V_FACTORY_CODE"+
          "       FROM oraddman.ts_label_print_log a,tsc.tsc_advise_dn_line_int B,wsh.wsh_new_deliveries C,TSC_SHIPPING_ADVISE_HEADERS D"+
          "       WHERE LABEL_CODE='TS184'"+
          "       AND B.ADVISE_LINE_ID=A.ADVISE_LINE_ID"+
          "       AND NVL(C.ITINERARY_COMPLETE,'N')='Y'"+
          "       AND C.NAME=B.delivery_name"+
          "       AND B.ADVISE_HEADER_ID=D.ADVISE_HEADER_ID"+
          "       AND C.ATTRIBUTE6 IS NULL"+
		  "       AND 'V_CUST_LOT' IN ( a.attribute1,a.attribute2,a.attribute3,a.attribute4,a.attribute5,a.attribute6,a.attribute7,a.attribute8,a.attribute9,a.attribute10,"+
          "       a.attribute11,a.attribute12,a.attribute13,a.attribute14,a.attribute15,a.attribute16,a.attribute17,a.attribute18,a.attribute19,a.attribute20,"+
          "       a.attribute21,a.attribute22,a.attribute23,a.attribute24,a.attribute25,a.attribute26,a.attribute27,a.attribute28,a.attribute29,a.attribute30)"+
          "       ORDER BY ADVISE_HEADER_ID, ADVISE_LINE_ID) X "+
          " WHERE 1=1 ?01"+
          //" GROUP BY X.DELIVERY_NAME,X.CARTON_NUM,X.POST_FIX_CODE ,X.ITEM_DESC,X.CUST_PARTNO,X.LOT_NUMBER,X.DATE_CODE,NVL(X.V_CUST_FAMILY,'LJF')||X.VENDOR_BATCH_NO||NVL(X.V_FACTORY_CODE,'1101') "+
		  " GROUP BY X.DELIVERY_NAME,X.CARTON_NUM,X.POST_FIX_CODE ,X.ITEM_DESC,X.CUST_PARTNO,X.LOT_NUMBER,X.DATE_CODE,X.CUST_LOT "+
          " ORDER BY X.DELIVERY_NAME,X.CARTON_NUM,X.DATE_CODE";
	*/
	sql = " select x.name DELIVERY_NAME,x.carton,x.CARTON_NO carton_num,x.TSC_ITEM_DESC ITEM_DESC,x.CUST_PARTNO,x.CUST_BATCHNO,x.LOT LOT_NUMBER,x.DATE_CODE,sum(x.QTY) QUANTITY"+
          " from (select b.name,g.carton_no carton,g.carton_no||d.post_fix_code CARTON_NO,e.description tsc_item_desc,decode(f.ordered_item,e.segment1,'',f.ordered_item) cust_partno,'LJF'||substr(tsc_get_calendar_week(g.MANUFACTURE_DATE,null),-4)||'1101' CUST_BATCHNO,g.lot,g.date_code,g.qty"+
          " from tsc.tsc_advise_dn_line_int a,wsh.wsh_new_deliveries b,TSC_SHIPPING_ADVISE_LINES c,TSC_SHIPPING_ADVISE_HEADERS d,INV.MTL_SYSTEM_ITEMS_B e,ont.oe_order_lines_all f,TSC_PICK_CONFIRM_LINES g"+
          " WHERE NVL(b.ITINERARY_COMPLETE,'N')='Y'"+
          " AND b.NAME=a.delivery_name"+
          " AND a.ADVISE_HEADER_ID=c.ADVISE_HEADER_ID"+
          " AND a.ADVISE_LINE_ID=c.ADVISE_LINE_ID"+
          " AND c.ADVISE_HEADER_ID=d.ADVISE_HEADER_ID"+
          " AND a.ADVISE_HEADER_ID=g.ADVISE_HEADER_ID"+
          " AND a.ADVISE_LINE_ID=g.ADVISE_LINE_ID    "+             
          " AND c.so_line_id=f.line_id"+
          " AND c.shipping_remark LIKE '%SALCOMP%'"+
          " AND c.inventory_item_id=e.inventory_item_id"+
          " AND c.organization_id=e.organization_id"+
          " AND c.TEW_ADVISE_NO IS null"+
          " AND d.creation_date >= TO_DATE('20160101','yyyymmdd')"+
          " AND b.ATTRIBUTE6 IS NULL) x "+
          " group by x.name,x.carton,x.CARTON_NO,x.TSC_ITEM_DESC,x.CUST_PARTNO,x.CUST_BATCHNO,x.LOT,x.DATE_CODE"+
          " ORDER BY to_number(x.carton)";
	sql1 = " select  DISTINCT DELIVERY_NAME FROM ("+sql.replace("?01"," ")+") X ORDER BY 1";
	//out.println(sql1);
	Statement state1=con.createStatement();     
	ResultSet rs1=state1.executeQuery(sql1);
	while (rs1.next())	
	{
		RPTName =rs1.getString("DELIVERY_NAME");				
	
		FileName = RPTName+"_"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		WritableWorkbook wwb = Workbook.createWorkbook(os); 
		wwb.createSheet(RPTName, 0);
		WritableSheet ws = null;
	
		WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		
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
		
		//英文內文水平垂直置中-粗體-格線-底色橘
		WritableCellFormat ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
		ACenterBLO.setWrap(true);	
		
		//英文內文水平垂直置中-粗體-格線-底色黃
		WritableCellFormat ALeftBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeftBLG.setAlignment(jxl.format.Alignment.LEFT);
		ALeftBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ALeftBLG.setBackground(jxl.write.Colour.YELLOW); 
		ALeftBLG.setWrap(true);	
				
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
			
		//日期格式
		WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
		DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
		DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		DATE_FORMAT.setWrap(true);
	
		sql2 = sql.replace("?01"," AND X.DELIVERY_NAME='"+rs1.getString("DELIVERY_NAME")+"'");
		//out.println(sql2);
		reccnt=0;
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql2);
		String sheetname [] = wwb.getSheetNames();
		while (rs.next()) 
		{ 
			if (reccnt==0)
			{
				col=0;row=0;
				ws = wwb.getSheet(sheetname[0]);
				SheetSettings sst = ws.getSettings(); 
				sst.setSelected();
				sst.setVerticalFreeze(row);  //凍結窗格

				//台半發票號
				ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Invoice No#" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;						

				//C/NO.
				ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "C/NO#" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
	
				//Description
				ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Description" , ACenterBL));
				ws.setColumnView(col,16);	
				col++;	

				//Customer P/N
				ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Customer P/N" , ACenterBL));
				ws.setColumnView(col,16);	
				col++;	
	
				//供應商批次號
				ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "客戶批次號" , ACenterBL));
				ws.setColumnView(col,16);	
				col++;	
				
				//Lot NO
				ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Lot NO" , ACenterBL));
				ws.setColumnView(col,16);	
				col++;	
	
				//D/C
				ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
					
				//Qty/PCS
				ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Qty/PCS" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
				row++;				
			}

			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("DELIVERY_NAME"), ACenterL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CARTON_NUM"), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PARTNO") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_BATCHNO") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
			col++;					
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("QUANTITY")).doubleValue(), ARightL));
			col++;	
			row++;				
			
			reccnt ++;
			
			sql3 = " update wsh.wsh_new_deliveries a"+
				  " set ATTRIBUTE6='Y'"+
				  " where NAME=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql3);  
			pstmtDt.setString(1,rs1.getString("DELIVERY_NAME"));
			pstmtDt.executeQuery();
			pstmtDt.close();
		}	
		wwb.write(); 
		wwb.close();
	
		rs.close();
		statement.close();

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
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				remarks="(這是來自RFQ測試區的信件)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{
				remarks="";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs002@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sophia_li@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("tin.chang@ts.com.tw"));
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
			message.setHeader("Subject", MimeUtility.encodeText("INVOICE:"+rs1.getString("DELIVERY_NAME")+ " 之SALCOMP客戶批次號明細"+remarks, "UTF-8", null));				
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
			mbp.setDataHandler(new javax.activation.DataHandler(fds));
			mbp.setFileName(fds.getName());
		
			// create the Multipart and add its parts to it
			mp.addBodyPart(mbp);
			message.setContent(mp);
			Transport.send(message);	
			dn_cnt++;
		}
	}
	rs1.close();
	state1.close();	
	if (dn_cnt>0)
	{
		os.close();  
		out.close(); 
		con.commit();	
	}
}   
catch (Exception e) 
{ 
	con.rollback();		
	out.println("Exception:"+e.getMessage()); 
} 	
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
