<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,java.lang.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSCC EDI Order Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCCEDIOrderStatusNotice.jsp" METHOD="post" name="MYFORM">
<%
String v_batch_id = request.getParameter("BATCH_ID");
if (v_batch_id==null) v_batch_id="";
String FileName="",sql="",remarks="",v_cust_po="";
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
		
	sql = " select distinct d.cust_code,b.edi_cust_code,case when b.edi_cust_code ='8018' then '世倍特' when b.edi_cust_code ='8530' then '大陸汽車' when b.edi_cust_code ='050' then '大陸泰密克' else  e.cust_name end cust_name"+
          " from edi.tscc_edi_customers a,"+
          " edi.tscc_delfor_elements b,"+
          " edi.tscc_delfor_headers_all c,"+
          " oraddman.tscc_k3_cust_link_erp d,"+
          " oraddman.tscc_k3_cust e"+
          " where a.edi_cust_code=b.edi_cust_code"+
          " and b.doc_no=c.cust_po"+
          " and b.doc_version_no=c.cust_po_version_no"+
          " and a.erp_cust_number=d.erp_cust_number"+
          " and d.cust_code=e.cust_code"+
          " and c.notice_date is null"+
		  " and b.status_code='F'"+ //add by Peggy 20200121
          " and c.batch_id='"+v_batch_id+"'"+
		  " and nvl(a.INACTIVE_DATE,to_date('20990101','yyyymmdd'))>trunc(sysdate)"; //add by Peggy 20200827
	Statement statex=con.createStatement();     
	ResultSet rsx=statex.executeQuery(sql);
	while (rsx.next())	
	{	
		FileName="TSCC EDI Order Notice("+rsx.getString("cust_code")+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	
		OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\tsccedi\\"+FileName);
		WritableWorkbook wwb = Workbook.createWorkbook(os); 
		int sheet_cnt =0;
		
		sql = " select a.cust_name, a.cust_po "+
		      " from edi.tscc_delfor_headers_all a,edi.tscc_delfor_elements b "+
		      " where b.doc_no=a.cust_po"+
              " and b.doc_version_no=a.cust_po_version_no"+
              " and a.batch_id='"+v_batch_id+"'"+
			  " and b.edi_cust_code='"+ rsx.getString("edi_cust_code")+"'"+
			  " and notice_date is null"+
			  " GROUP BY a.cust_name, a.cust_po";
		//out.println(sql);
		Statement state=con.createStatement();     
		ResultSet rs=state.executeQuery(sql);
		while (rs.next())	
		{	
			wwb.createSheet(rs.getString("cust_po"), sheet_cnt);
			sheet_cnt++;
		}
		rs.close();
		state.close();
		WritableSheet ws = null;

		sql = " SELECT K3.CUST_CODE,K3.CUST_NAME K3_CUST_NAME,TEH.CUST_NAME,TEH.CUST_PO,TEH.SCHEDULE_CONTACT,TEH.MIN_VERSION_NO,TEH.MAX_VERSION_NO,TEH.PO_CNT,TO_CHAR(TEH.REQUEST_DATE,'YYYYMMDD') REQUEST_DATE,TEL.CUST_PO_VERSION_NO,TEL.CUST_PO_LINE_NO,TEL.CUST_PART_NO,TEL.CUST_PART_DESC,TEL.TSC_ITEM_NO,TEL.TSC_ITEM_DESC,"+
			  " TO_CHAR(TELD.DELIVERY_DATE,'YYYYMMDD') DELIVERY_DATE,TELD.OLD_QTY,TELD.NEW_QTY,TELD.UOM"+
			  ",NVL(TELD.NEW_QTY,0)-NVL(TELD.OLD_QTY,0) REMARKS"+
			  ",(SELECT SUM(RECEIVED_QTY) FROM EDI.TSCC_DELFOR_LINE_RECEIVES_ALL TELR WHERE TELR.CUST_NAME=TEL.CUST_NAME AND TELR.CUST_PO=TEL.CUST_PO AND TELR.CUST_PO_LINE_NO = TEL.CUST_PO_LINE_NO AND TELR.CUST_PO_VERSION_NO=TEL.CUST_PO_VERSION_NO) RECEIVED_QTY"+
			  ",(SELECT LISTAGG(DESPATH_DOC_NO ||' | '||TO_CHAR(REFERENCE_DATE,'YYYY/MM/DD'),CHR(13)) WITHIN GROUP(ORDER BY SEQ_NO) FROM EDI.TSCC_DELFOR_LINE_RCV_DOCS_ALL  TELR WHERE TELR.CUST_NAME=TEL.CUST_NAME AND TELR.CUST_PO=TEL.CUST_PO AND TELR.CUST_PO_LINE_NO = TEL.CUST_PO_LINE_NO AND TELR.CUST_PO_VERSION_NO=TEL.CUST_PO_VERSION_NO GROUP BY CUST_NAME,CUST_PO,CUST_PO_LINE_NO,CUST_PO_VERSION_NO) DESPATCH_DOC_LIST"+
			  " FROM ( SELECT X.CUST_NAME ,X.CUST_PO ,X.SCHEDULE_CONTACT,MAX(X.REQUEST_DATE) REQUEST_DATE,MIN(X.CUST_PO_VERSION_NO) MIN_VERSION_NO,MAX(X.CUST_PO_VERSION_NO) MAX_VERSION_NO,COUNT(DISTINCT X.CUST_PO) OVER (PARTITION BY X.CUST_NAME) PO_CNT "+
			  "        FROM EDI.TSCC_DELFOR_HEADERS_ALL X,EDI.TSCC_DELFOR_ELEMENTS Y"+
			  "        WHERE X.BATCH_ID='"+v_batch_id+"'"+
			  "        AND X.NOTICE_DATE IS NULL"+
			  "        AND X.CUST_PO=Y.DOC_NO"+
			  "        AND X.CUST_PO_VERSION_NO=Y.DOC_VERSION_NO"+
			  "        AND X.BATCH_ID=Y.BATCH_ID"+
			  "        AND Y.STATUS_CODE='F'"+
			  "        AND Y.EDI_CUST_CODE='"+rsx.getString("edi_cust_code")+"'"+
			  "        GROUP BY X.CUST_NAME ,X.CUST_PO,X.SCHEDULE_CONTACT) TEH"+
			  " ,EDI.TSCC_DELFOR_LINES_ALL TEL"+
			  //" ,EDI.TSCC_EDI_CUSTOMERS TEC"+
			  " ,(SELECT * FROM EDI.TSCC_EDI_CUSTOMERS WHERE nvl(INACTIVE_DATE,to_date('20990101','yyyymmdd'))>trunc(sysdate)) TEC"+ //modify by Peggy 20200827
			  " ,(SELECT A.ERP_CUST_NUMBER,A.CUST_CODE,B.CUST_NAME FROM ORADDMAN.TSCC_K3_CUST_LINK_ERP A,ORADDMAN.TSCC_K3_CUST B WHERE A.ACTIVE_FLAG='A' AND A.CUST_CODE=B.CUST_CODE) K3"+
			  " ,(SELECT TOT.CUST_NAME,TOT.CUST_PO,TOT.CUST_PO_LINE_NO,TOT.DELIVERY_DATE,SUM(TOT.OLD_QTY) OLD_QTY,SUM(TOT.NEW_QTY) NEW_QTY,TOT.UOM"+
			  "   FROM (SELECT A.CUST_NAME,A.CUST_PO,A.CUST_PO_LINE_NO,A.EARLIEST_DELIVERY_DATE DELIVERY_DATE,A.QTY OLD_QTY, NULL NEW_QTY,A.UOM"+
			  "         FROM EDI.TSCC_DELFOR_LINE_DELIVERS_ALL A "+
			  "         WHERE EXISTS (SELECT CUST_PO,PRE_VERSION_NO FROM (SELECT CUST_PO,MIN(CUST_PO_VERSION_NO)-1 PRE_VERSION_NO FROM EDI.TSCC_DELFOR_HEADERS_ALL"+
			  "                                                           WHERE BATCH_ID='"+v_batch_id+"'"+
			  "                                                           AND NOTICE_DATE IS NULL "+
 			  "                                                           GROUP BY CUST_PO) X"+
			  "                       WHERE X.CUST_PO=A.CUST_PO"+
			  "                       AND X.PRE_VERSION_NO=A.CUST_PO_VERSION_NO)"+
			  "                       AND NVL(A.QTY,0)<>0"+
			  "         UNION ALL "+
			  "         SELECT A.CUST_NAME,A.CUST_PO,A.CUST_PO_LINE_NO, A.EARLIEST_DELIVERY_DATE DELIVERY_DATE,NULL OLD_QTY,A.QTY NEW_QTY,A.UOM"+
			  "         FROM EDI.TSCC_DELFOR_LINE_DELIVERS_ALL A "+
			  "         WHERE EXISTS (SELECT CUST_PO,LAST_VERSION_NO FROM (SELECT CUST_PO,MAX(CUST_PO_VERSION_NO) LAST_VERSION_NO FROM EDI.TSCC_DELFOR_HEADERS_ALL"+
			  "                                                            WHERE BATCH_ID='"+v_batch_id+"'"+
			  "                                                            AND NOTICE_DATE IS NULL"+
			  "                                                            GROUP BY CUST_PO) X"+
			  "                       WHERE X.CUST_PO=A.CUST_PO"+
			  "                       AND X.LAST_VERSION_NO=A.CUST_PO_VERSION_NO)"+
			  "          ) TOT "+
			  "       GROUP BY TOT.CUST_NAME,TOT.CUST_PO,TOT.CUST_PO_LINE_NO,TOT.DELIVERY_DATE,TOT.UOM ORDER BY 1,2,3,4) TELD "+
			  " WHERE TEH.CUST_NAME=TEL.CUST_NAME"+
			  " AND TEH.CUST_PO=TEL.CUST_PO"+
			  " AND TEH.MAX_VERSION_NO=TEL.CUST_PO_VERSION_NO"+
			  " AND TEL.CUST_NAME=TELD.CUST_NAME"+
			  " AND TEL.CUST_PO=TELD.CUST_PO"+
			  " AND TEL.CUST_PO_LINE_NO=TELD.CUST_PO_LINE_NO"+
			  " AND TEL.SHIP_TO_CODE=TEC.EDI_CUST_CODE"+
			  " AND TEC.ERP_CUST_NUMBER=K3.ERP_CUST_NUMBER(+)"+
			  " ORDER BY K3.CUST_CODE,TEH.CUST_PO,TEL.CUST_PO_LINE_NO,TELD.DELIVERY_DATE";
		//out.println(sql);
		Statement state1=con.createStatement();     
		ResultSet rs1=state1.executeQuery(sql);
		reccnt=0;
		while (rs1.next())	
		{
			reccnt++;
			if (!rs1.getString("CUST_PO").equals(v_cust_po))
			{
				ws = wwb.getSheet(rs1.getString("CUST_PO"));
				v_cust_po= rs1.getString("CUST_PO");
				col=0;row=0;
				//K3客戶代碼
				ws.addCell(new jxl.write.Label(col, row, "K3客戶代碼" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;
				//K3客戶名稱
				ws.addCell(new jxl.write.Label(col, row, "K3客戶名稱" , ACenterBL));
				ws.setColumnView(col,35);	
				col++;
				//版次
				ws.addCell(new jxl.write.Label(col, row, "版次" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;				
				//客戶銷售訂單號
				ws.addCell(new jxl.write.Label(col, row, "客戶訂單號" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;				
				//客戶銷售訂單號項次
				ws.addCell(new jxl.write.Label(col, row, "客戶訂單項次" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;				
				//申請日期
				ws.addCell(new jxl.write.Label(col, row, "申請日期" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;				
				//客戶品號
				ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBL));
				ws.setColumnView(col,20);	
				col++;				
				//料號
				ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBL));
				ws.setColumnView(col,30);	
				col++;				
				//型號
				ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBL));
				ws.setColumnView(col,25);	
				col++;				
				//客戶需求日
				ws.addCell(new jxl.write.Label(col, row, "客戶需求日" , ACenterBL));
				ws.setColumnView(col,12);
				col++;				
				//客戶需求數量
				ws.addCell(new jxl.write.Label(col, row, "客戶需求數量" , ACenterBL));
				ws.setColumnView(col,12);
				col++;				
				//數量單位
				ws.addCell(new jxl.write.Label(col, row, "數量單位" , ACenterBL));
				ws.setColumnView(col,8);
				col++;				
				//備註
				ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;			
				//CONTACT
				ws.addCell(new jxl.write.Label(col, row, "聯絡人" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;				
				//已出數量
				ws.addCell(new jxl.write.Label(col, row, "已出數量" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;				
				//Delivery Note info
				ws.addCell(new jxl.write.Label(col, row, "Delivery Note Info" , ACenterBL));
				ws.setColumnView(col,30);	
				col++;				
				row++;
			}
			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUST_CODE"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("K3_CUST_NAME") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUST_PO_VERSION_NO") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUST_PO") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUST_PO_LINE_NO") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("REQUEST_DATE") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUST_PART_NO") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("TSC_ITEM_NO") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("TSC_ITEM_DESC") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("DELIVERY_DATE") ,  ALeftL));
			col++;
			if (rs1.getString("NEW_QTY")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, null,  ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs1.getString("NEW_QTY")).doubleValue(), ARightL));
			}
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("UOM") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("REMARKS") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("SCHEDULE_CONTACT") ,  ALeftL));
			col++;
			if (rs1.getString("RECEIVED_QTY")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, null,  ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs1.getString("RECEIVED_QTY")).doubleValue(), ARightL));
			}
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("DESPATCH_DOC_LIST") ,  ALeftL));
			col++;
			row++;
		}
		if (reccnt>0)
		{
			wwb.write(); 
			wwb.close();
			rs1.close();
			state1.close();
		
			sql = " update EDI.TSCC_DELFOR_HEADERS_ALL a "+
				  " set a.NOTICE_DATE =SYSDATE"+
				  " where a.BATCH_ID='"+v_batch_id+"'"+
				  " and exists (select 1 from edi.tscc_delfor_elements b "+
        		  "             where b.doc_no=a.cust_po"+
                  "             and b.doc_version_no=a.cust_po_version_no"+
 			      "             and b.edi_cust_code='"+ rsx.getString("edi_cust_code")+"')"+				  			  
				  " AND a.NOTICE_DATE IS NULL";
			PreparedStatement pstmtDtl=con.prepareStatement(sql);	
			pstmtDtl.executeQuery();
			pstmtDtl.close();
			con.commit();
				
			Properties props = System.getProperties();
			props.put("mail.transport.protocol","smtp");
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				props.put("mail.smtp.host", "mail3.ts.com.tw");
			}
			else
			{
				props.put("mail.smtp.host", "mail.ts.com.tw");
			}
			
			props.put("mail.smtp.port", "25");
			
			Session s = Session.getInstance(props, null);
			javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
			message.setSentDate(new java.util.Date());
			message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				remarks="(This is a test letter, please ignore it)";
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anna_qiu@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("kevin@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nancy_yan@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lily_yin@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tina@ts-china.com.cn"));
			}
			else
			{
				remarks="";
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anna_qiu@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("kevin@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nancy_yan@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@ts-china.com.cn"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lily_yin@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tina@ts-china.com.cn"));
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				
			message.setSubject("TSCC EDI DELFOR Order Notice("+rsx.getString("cust_code")+")-"+dateBean.getYearMonthDay()+remarks);
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			String str_d = "P.S此為系統自動發送的EMAIL信件，請勿直接回信，謝謝!";
			mbp.setContent(str_d, "text/html;charset=UTF-8");
			mp.addBodyPart(mbp);
			mbp = new javax.mail.internet.MimeBodyPart();
			javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\tsccedi\\"+FileName);
			mbp.setDataHandler(new javax.activation.DataHandler(fds));
			mbp.setFileName(fds.getName());
		
			// create the Multipart and add its parts to it
			mp.addBodyPart(mbp);
			message.setContent(mp);
			Transport.send(message);	
			os.close();  
		}
	}
	rsx.close();
	statex.close();
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

