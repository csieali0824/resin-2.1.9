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
<FORM ACTION="../jsp/TSCSGItemSafetyStockReqNotice.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="";
String JOB_ID = request.getParameter("JOB_ID");
if (JOB_ID==null) JOB_ID="";
String RTYPE="AUTO";

int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,line=0,mergeCol=0;
	String column1="",column2="",column3="",column4="",column5="",mo_CRD="",mo_QTY="",mo_PRICE="",mo_SSD="";
	String v_created_by="",v_created_by_mail="",v_request_mon="";
	OutputStream os = null;	
	RPTName = "SGForeCastPODetail";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setVerticalFreeze(2);  //凍結窗格
	for (int g =1 ; g <=6 ;g++ )
	{
		sst.setHorizontalFreeze(g);
	}
	
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
	cs1.setString(1,"906"); 
	cs1.execute();
	cs1.close();

	sql = " SELECT a.ORGANIZATION_CODE"+
	      ",case substr(a.ORGANIZATION_CODE,-2) when '-D' then '內銷' when '-E' then '外銷' else a.ORGANIZATION_CODE end as ORGANIZATION_NAME"+
	      ",TO_CHAR(to_date(a.C_MONTH,'yyyymm'),'YYYY/MM') c_month"+
		  ",a.INVENTORY_ITEM_ID"+
		  ",a.ITEM_NAME"+
		  ",a.ITEM_DESC"+
		  ",a.SUGGEST_SAFETY_STOCK/1000 AS SUGGEST_SAFETY_STOCK"+
		  ",to_char(a.CREATION_DATE,'yyyy/mm/dd') CREATION_DATE "+
		  ",a.CREATED_BY "+
		  ",b.vendor_site_code"+
		  ",b.currency_code"+
		  ",b.unit_price * case when b.uom='KPC' then 1 else 1000 end unit_price"+
		  ",(a.SUGGEST_SAFETY_STOCK/1000) * b.unit_price as amount"+
          ",sum((a.SUGGEST_SAFETY_STOCK/1000) * b.unit_price) over (partition by a.ORGANIZATION_CODE) TOTAL_AMT"+
          ",row_number() over (partition by a.ORGANIZATION_CODE order by (a.SUGGEST_SAFETY_STOCK/1000) * b.unit_price desc ) org_seq"+
          ",count(1) over (partition by a.ORGANIZATION_CODE) org_cnt"+
		  ",tsc_inv_category(a.inventory_item_id,43,1100000003) TSC_PROD_GROUP"+
          ",c.usermail"+
          ",d.user_name"+
		  " FROM oraddman.TSSG_ITEM_SAFETY_STOCK_REQUEST A"+
		  ",(select * from (select z.vendor_name, x.vendor_site_id,x.CURRENCY_CODE,x.ship_to_location_id,y.item_id,y.unit_price,y.unit_meas_lookup_code uom ,k.vendor_site_code"+
		  ",row_number() over (partition by y.item_id,substr(k.vendor_site_code,-2) order by y.item_id,substr(k.vendor_site_code,-2),y.unit_price desc) item_rank"+
		  " from po_headers_all x,po_lines_all y,ap.ap_suppliers z,ap_supplier_sites_all k"+
          "  where x.TYPE_LOOKUP_CODE='BLANKET'"+
          "  and x.ORG_ID in (?)"+
          "  and NVL(x.cancel_flag,'N') = 'N'"+
          "  and NVL(x.closed_code,'OPEN') NOT LIKE '%CLOSED%'"+
          "  and NVL(y.cancel_flag,'N') = 'N'"+
          "  and NVL(y.closed_code,'OPEN') <> 'CLOSED'"+
          "  and NVL(y.closed_flag,'N') <> 'Y'"+      
          "  and x.po_header_id=y.po_header_id"+
          "  and x.vendor_site_id=k.vendor_site_id "+
          "  and k.vendor_id=z.vendor_id) x where x.item_rank=1) B"+
          " ,ORADDMAN.WSUSER C"+
          " ,FND_USER D"+
		  " WHERE a.JOB_ID=?"+
		  " and a.inventory_item_id=b.item_id"+
		  " and substr(a.ORGANIZATION_CODE,-2)=substr(b.vendor_site_code,-2)"+
          " and a.created_by=c.username"+
          " and c.erp_user_id=d.user_id"+
		  " order by a.ORGANIZATION_CODE, (a.SUGGEST_SAFETY_STOCK/1000) * b.unit_price desc";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"906");
	statement.setString(2,JOB_ID);
	ResultSet rs = statement.executeQuery();	
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//內外銷
			ws.addCell(new jxl.write.Label(col, row, "內外銷" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
						
			//申請月份
			ws.addCell(new jxl.write.Label(col, row, "申請月份" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//申請人
			ws.addCell(new jxl.write.Label(col, row, "申請人" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//申請日期
			ws.addCell(new jxl.write.Label(col, row, "申請日期" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			////供應商
			//ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			//ws.setColumnView(col,12);	
			//col++;	

			//TSC PROD GROUP
			ws.addCell(new jxl.write.Label(col, row, "TSC PROD GROUP" , ACenterBLB));
			ws.setColumnView(col,16);	
			col++;	

			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//品名
			ws.addCell(new jxl.write.Label(col, row, "品名" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//數量
			ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//單位
			ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//幣別
			ws.addCell(new jxl.write.Label(col, row, "幣別" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			
			//單價
			ws.addCell(new jxl.write.Label(col, row, "採購單價(K)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;

			//金額
			ws.addCell(new jxl.write.Label(col, row, "金額" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//合計
			ws.addCell(new jxl.write.Label(col, row, "合計" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			row++;
		}
		col=0;
		if (row==1)
		{
			v_created_by=rs.getString("USER_NAME");
			v_created_by_mail=rs.getString("USERMAIL");
			v_request_mon=rs.getString("C_MONTH");
		}
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORGANIZATION_NAME"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("C_MONTH"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATED_BY"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATION_DATE"), ALeftL));
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_SITE_CODE"),ALeftL));
		//col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP"),ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME"),ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"), ALeftL));
		col++;	
		if (rs.getString("SUGGEST_SAFETY_STOCK")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SUGGEST_SAFETY_STOCK")).doubleValue(), ARightL));
		}		
		col++;		
		ws.addCell(new jxl.write.Label(col, row, "KPC", ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CURRENCY_CODE"),ALeftL));
		col++;	
		if (rs.getString("UNIT_PRICE")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("UNIT_PRICE")).doubleValue(), ARightL));
		}		
		col++;
		if (rs.getString("AMOUNT")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("AMOUNT")).doubleValue(), ARightL));
		}					
		col++;
		if (rs.getInt("org_seq")==rs.getInt("org_cnt"))
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOTAL_AMT")).doubleValue(), ARightL));
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
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
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.1353") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("amy.liu@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("casey@ts-china.com.cn"));
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("jojo@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("ivy@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("coco@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("zhangdi@mail.tew.com.cn"));
			//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("cytsou@ts.com.tw"));
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("judy.cho@ts.com.tw"));    //add Judy by Peggy 20211007
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("perry.juan@ts.com.tw"));  //add perry by Peggy 20230703
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("SG Forecast PO Request Notice - "+dateBean.getYearMonthDay()+remarks);
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		String str_d = "<font style='font-size:14px;font-family:Times New Roman;'>Dear All:<p>"+
					   "附檔是?01申請?02 SG Forecast採購明細資料,請參考,有任何問題請與?03(?04) 聯繫,謝謝!<p><p>"+
					   "P.S此為系統自動發送的EMAIL信件，請勿直接回信，謝謝!";
		mbp.setContent(str_d.replace("?01",v_created_by).replace("?02",v_request_mon).replace("?03",v_created_by).replace("?04",v_created_by_mail), "text/html;charset=UTF-8");
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
