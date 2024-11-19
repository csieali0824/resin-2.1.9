<%@ page contentType="text/html;charset=utf-8"  pageEncoding="big5" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>  
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSSalesOrderReviseExcelNotice.jsp" METHOD="post" name="MYFORM">
<%
String REPORT_TYPE=request.getParameter("RTYPE");
if (REPORT_TYPE==null) REPORT_TYPE="";
String sql = "",request_no="",so_line_id="";
String TEMP_ID=request.getParameter("TEMP_ID");
if (TEMP_ID ==null) TEMP_ID="";
String PLANTCODE=request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String PULL_SDATE=request.getParameter("PULL_SDATE");
if (PULL_SDATE==null) PULL_SDATE="";
String PULL_EDATE=request.getParameter("PULL_EDATE");
if (PULL_EDATE==null) PULL_EDATE="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String MONO=request.getParameter("MONO");
if (MONO==null) MONO="";
String CREATEDBY=request.getParameter("CREATEDBY");
if (CREATEDBY==null) CREATEDBY="";
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
//out.println(CUST);
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String RESULT = request.getParameter("RESULT");
if (RESULT==null) RESULT="";
String SALES_RESULT = request.getParameter("SALES_RESULT");
if(SALES_RESULT==null) SALES_RESULT="";
String GROUP_ID = request.getParameter("GROUP_ID");
if (GROUP_ID==null) GROUP_ID="";
String REQUEST_DATE = request.getParameter("REQUEST_DATE");  //add by Peggy 20151130
if (REQUEST_DATE==null || REQUEST_DATE.equals("--")) REQUEST_DATE="";
String CUSTPO=request.getParameter("CUSTPO");  //add by Peggy 20160325
if (CUSTPO==null) CUSTPO="";
String REVISE_SDATE=request.getParameter("REVISE_SDATE");
if (REVISE_SDATE==null) REVISE_SDATE="";
String REVISE_EDATE=request.getParameter("REVISE_EDATE");
if (REVISE_EDATE==null) REVISE_EDATE="";
String ORGCODE = request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String PC_SDATE=request.getParameter("PC_SDATE");
if (PC_SDATE==null) PC_SDATE="";
String PC_EDATE=request.getParameter("PC_EDATE");
if (PC_EDATE==null) PC_EDATE="";
String chkma=request.getParameter("chkma");  //add by Peggy 20190117
if (chkma==null) chkma="N";
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
String FileName="",RPTName="",PLANTNAME="",tsch_user="",SALES_REGION="",remarks="",V_CUST_LIST="";
int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0;
	String strContent="",strUrl= request.getRequestURL().toString(),strProgram="";
	strUrl=strUrl.substring(0,strUrl.lastIndexOf("/"));
	strUrl=strUrl.replace("10.0.3.109:8081","10.0.1.144:8080");
		
	OutputStream os = null;	
	if (ACTTYPE.equals("REMINDER"))
	{
		RPTName="Order Change Request Reply to Notification";
		sql = " SELECT DISTINCT DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC',a.sales_group) sales_region"+
              " FROM oraddman.tsc_om_salesorderrevise_req a"+
              " WHERE STATUS=?"+
              " ORDER BY  1";	
	}
	PreparedStatement statement1 = con.prepareStatement(sql);
	if (ACTTYPE.equals("REMINDER"))
	{
		statement1.setString(1,REPORT_TYPE);
	}	
	ResultSet rs1=statement1.executeQuery();
	while (rs1.next())
	{	
		SALES_REGION=rs1.getString("sales_region");
		strProgram =strUrl+"/TSSalesOrderReviseConfirm.jsp" ;
		FileName = SALES_REGION+" "+RPTName+ "-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	
	
		//FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		WritableWorkbook wwb = Workbook.createWorkbook(os); 
		//WritableSheet ws = wwb.createSheet(RPTName, 0); 
		if (ACTTYPE.equals("REMINDER"))
		{
			wwb.createSheet("sheet1", 0);
		}
		else
		{
			wwb.createSheet(RPTName, 0);
		}
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
	
		//英文內文水平垂直置右-正常-格線-藍字   
		WritableCellFormat ARightL_B = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
		ARightL_B.setAlignment(jxl.format.Alignment.RIGHT);
		ARightL_B.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ARightL_B.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ARightL_B.setWrap(true);
		
		//英文內文水平垂直置右-正常-格線-紅字   
		WritableCellFormat ARightL_R = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		ARightL_R.setAlignment(jxl.format.Alignment.RIGHT);
		ARightL_R.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ARightL_R.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ARightL_R.setWrap(true);
		
		//英文內文水平垂直置右-正常-格線-紅字置中  
		WritableCellFormat ACenter_R = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		ACenter_R.setAlignment(jxl.format.Alignment.CENTRE);
		ACenter_R.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenter_R.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenter_R.setWrap(true);		
	
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
	
		//日期格式-紅字
		WritableCellFormat DATE_FORMAT_R = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED) ,new jxl.write.DateFormat("yyyy/MM/dd")); 
		DATE_FORMAT_R.setAlignment(jxl.format.Alignment.CENTRE);
		DATE_FORMAT_R.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		DATE_FORMAT_R.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		DATE_FORMAT_R.setWrap(true);
	
		//日期格式-藍字
		WritableCellFormat DATE_FORMAT_B = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE) ,new jxl.write.DateFormat("yyyy/MM/dd")); 
		DATE_FORMAT_B.setAlignment(jxl.format.Alignment.CENTRE);
		DATE_FORMAT_B.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		DATE_FORMAT_B.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		DATE_FORMAT_B.setWrap(true);
		
		sql = " select a.request_no"+
			  ",a.sales_group"+
			  ",a.so_no"+
			  ",a.line_no"+
			  ",a.so_header_id"+
			  ",a.so_line_id"+
			  ",a.order_type"+
			  ",a.customer_number"+
			  ",a.customer_name"+
			  //",nvl(h.customer_name_phonetic,h.customer_name) end_customer"+
			  ",NVL(NVL( DECODE (pp.party_type,'ORGANIZATION', pp.organization_name_phonetic,NULL), SUBSTRB (pp.party_name, 1, 50)),CASE WHEN a.sales_group IN ('TSCA','TSCR-ROW','TSCI','TSCJ') then d.attribute13 else '' end) end_customer"+
			  ",a.ship_to_org_id"+
			  ",a.tsc_prod_group"+
			  ",a.inventory_item_id"+
			  ",a.item_name"+
			  ",a.item_desc"+
			  ",a.cust_item_id"+
			  ",a.cust_item_name"+
			  ",a.customer_po"+
			  ",a.shipping_method"+
			  ",NVL(a.so_qty,a.SOURCE_SO_QTY) so_qty"+
			  ",to_char(a.request_date,'yyyy/mm/dd') request_date"+
			  ",to_char(NVL(a.schedule_ship_date_tw,a.source_ssd),'yyyy/mm/dd') schedule_ship_date_tw"+
			  ",to_char(NVL(a.schedule_ship_date,a.source_ssd),'yyyy/mm/dd') schedule_ship_date"+
			  //",to_char(NVL(a.schedule_ship_date,a.source_ssd-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else NVL(f.TRANSPORTATION_DAYS,0) end),'yyyy/mm/dd') schedule_ship_date"+
			  ",to_char(a.pc_schedule_ship_date,'yyyy/mm/dd') pc_schedule_ship_date"+
			  ",case when nvl(a.to_tw_days,0)=0 then null else to_char(a.pc_schedule_ship_date+nvl(a.to_tw_days,0),'yyyy/mm/dd') end pc_schedule_ship_date_tw"+ //add by Peggy 20191104
			  ",a.packing_instructions"+
			  ",a.plant_code"+
			  ",a.change_reason"+
			  ",a.change_comments"+
			  ",a.created_by"+
			  ",to_char(a.creation_date,'yyyy/mm/dd hh24:mi') creation_date"+
			  ",a.pc_confirmed_by"+
			  ",to_char(a.pc_confirmed_date,'yyyy/mm/dd hh24:mi') pc_confirmed_date"+
			  ",a.last_updated_by"+
			  ",to_char(a.last_update_date,'yyyy/mm/dd hh24:mi') last_update_date"+
			  ",a.status"+
			  ",a.temp_id"+
			  ",a.seq_id"+
			  ",a.ship_to"+
			  ",a.pc_remarks"+
			  ",a.remarks";
		if (REPORT_TYPE.equals("AWAITING_CONFIRM"))	
		{			 
			sql += "||CASE WHEN a.remarks is null then '' else chr(10) end||tsc_order_revise_pkg.GET_REVISE_DESC(a.temp_id,a.seq_id,'PC')";
		}
		sql +=" remarks"+
			  ",a.pc_confirmed_result"+
			  ",a.pc_so_qty"+
			  ",b.ALENGNAME"+
			  ",NVL(a.SOURCE_SO_QTY,d.ordered_quantity) orig_so_qty"+
			  ",a.SOURCE_ITEM_DESC orig_item_desc"+
			  ",(select segment1 from inv.mtl_system_items_b xx where xx.organization_id=43 and xx.inventory_item_id=a.source_item_id) orig_item_name"+ //add by Peggy 20200206
			  //",to_char(a.SOURCE_SSD,'yyyy/mm/dd') orig_schedule_ship_date"+
			  //",to_char(a.SOURCE_SSD-NVL(f.TRANSPORTATION_DAYS,0),'yyyy/mm/dd') orig_schedule_ship_date"+
			  //",to_char(a.SOURCE_SSD-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else NVL(f.TRANSPORTATION_DAYS,0) end,'yyyy/mm/dd')  orig_schedule_ship_date"+
			  //",to_char(CASE WHEN a.plant_code IN ('002') AND SUBSTR(a.so_no,1,4) IN ('1131','1141','1121') THEN TO_DATE(TSC_GET_YEW_TOTW_ORDER_INFO(a.so_line_id,'TSC','SSD',NULL),'YYYYMMDD') "+
			  ",to_char(CASE WHEN a.PACKING_INSTRUCTIONS in ('Y','T') AND SUBSTR(a.so_no,1,4) IN ('1131','1141','1121') THEN NVL(a.SOURCE_YEW_SSD,TO_DATE(TSC_GET_YEW_TOTW_ORDER_INFO(a.so_line_id,'TSC','SSD',NULL),'YYYYMMDD')) "+
			  ////"  (SELECT schedule_ship_date FROM ont.oe_order_headers_all yew_h,ont.oe_order_lines_all yew_l"+
			  ////"   WHERE yew_h.header_id=yew_l.header_id "+
			  ////"   AND yew_h.org_id=325 "+
			  ////"   AND yew_h.order_number=c.order_number"+
			  ////"   AND yew_l.line_number||'.'||yew_l.shipment_number=d.line_number||'.'||d.shipment_number) "+
			  "  ELSE a.source_ssd - CASE WHEN NVL (d.attribute19, 'xx') = '1' THEN 0 ELSE NVL (a.to_tw_days, 0) END END ,'yyyy/mm/dd') AS  orig_schedule_ship_date"+
			  ", to_char(a.source_ssd,'yyyy/mm/dd') AS  orig_schedule_ship_date_tw"+
			  //",nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) orig_customer"+
			  //",case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')')-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end  else nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) end as orig_customer"+
			  ",case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')')-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
			  " else  NVL ( DECODE (party.party_type,'ORGANIZATION', party.organization_name_phonetic, NULL), SUBSTRB (party.party_name, 1, 50)) "+(REPORT_TYPE.equals("AWAITING_CONFIRM")?" ||case when a.source_customer_id=14980 then nvl2(end_cust.account_name,'('||end_cust.account_name ||')','') else '' end":"")+" end as orig_customer"+
			  ",count(a.SO_LINE_ID) over (partition by SO_HEADER_ID,SO_LINE_ID) line_cnt"+
			  ",decode(a.NEW_SO_NO ,null,'',a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '/'||a.NEW_LINE_NO) as new_order"+
			  ",a.NEW_SO_NO"+
			  ",a.NEW_LINE_NO";
		if (REPORT_TYPE.equals("AWAITING_CONFIRM"))
		{		  
			if (PLANTCODE.equals("005") || PLANTCODE.equals("008"))
			{
				sql +=",g.PO_NO"+
					  ",g.VENDOR_SITE_CODE"+
					  ",to_char(g.NEED_BY_DATE,'yyyy/mm/dd') NEED_BY_DATE"+
					  ",DECODE(g.PO_UOM,'KPC',g.QUANTITY,g.QUANTITY/1000) PO_QTY";
			}
			else if (PLANTCODE.equals("002"))  //add by Peggy 20171020
			{
				//sql += ",k.wip_list,k.wip_completed_qty"; //add by Peggy 20180817
			}
		}
		sql +=",k.wip_list,k.wip_completed_qty,k.wo_qty"; //add by Peggy 20180817	
		sql +=",a.ship_to_location_id"+
			  ",a.SOURCE_CUSTOMER_PO"+
			  ",a.deliver_to_location_id"+
			  ",a.DELIVER_TO_ORG_ID"+
			  ",a.DELIVER_TO"+
			  ",a.BILL_TO_LOCATION_ID"+
			  ",a.BILL_TO_ORG_ID"+
			  ",a.BILL_TO"+
			  ",a.SOURCE_BILL_TO_ORG_ID"+		
			  ",a.SOURCE_BILL_TO_LOCATION_ID"+
			  ",a.SOURCE_SHIP_TO_LOCATION_ID"+
			  ",a.SOURCE_DELIVER_TO_LOCATION_ID"+
			  ",a.FOB_POINT_CODE"+
			  ",a.SOURCE_FOB_POINT_CODE"+
			  ",a.FOB"+	
			  ",decode(a.SALES_CONFIRMED_RESULT,'1','Revise Order','2','Hold Order','0','No Revise','4','No Revise',a.SALES_CONFIRMED_RESULT) SALES_CONFIRMED_RESULT"+
			  ",(select count(1) from tsc_om_salesorderrevise_req_v x where x.temp_id = a.temp_id and x.so_line_id=a.so_line_id) partial_cnt"+
			  //",TSC_OM_CATEGORY(d.INVENTORY_ITEM_ID,d.ship_from_org_ID,'TSC_Family') tsc_Family"+
			  //",tsc_inv_category(a.SOURCE_ITEM_ID,a.SOURCE_SHIP_FROM_ORG_ID,21) tsc_Family"+
			  ",tsc_inv_category(a.SOURCE_ITEM_ID,43,21) tsc_Family"+
			  //",TSC_OM_CATEGORY(d.INVENTORY_ITEM_ID,d.ship_from_org_ID,'TSC_Package') tsc_package"+
			  ",tsc_inv_category(a.SOURCE_ITEM_ID,43,23) tsc_package"+ 
			  ",case when send_from_temp_id is null then null else row_number() over(partition by send_from_temp_id,send_from_seq_id order by temp_id) end resend_times"+//add by Peggy 20170426
			  ",(select distinct request_no from tsc_om_salesorderrevise_req_v x where x.temp_id=a.send_from_temp_id) resend_from_request_no"+//add by Peggy 20170426
			  ",case when a.plant_code='002' then (select DEPT from yew_mfg_dept x where x.tsc_package=tsc_inv_category(a.SOURCE_ITEM_ID,43,23)) else '' end as yew_departno"+ //add by Peggy 20180412
			  ",case when NVL(a.so_qty,a.SOURCE_SO_QTY)=0 then 'Cancel'"+
			  //"      when NVL(a.schedule_ship_date,a.source_ssd-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else NVL(f.TRANSPORTATION_DAYS,0) end) < a.source_ssd then 'Pull in'"+
			  //"      when NVL(a.schedule_ship_date,a.source_ssd-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else NVL(f.TRANSPORTATION_DAYS,0) end) > a.source_ssd then 'Push Out'"+
			  "      when NVL(a.schedule_ship_date,a.source_ssd-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else tsc_get_mo_line_totw_days(d.packing_instructions,c.order_number,d.line_id,trunc(sysdate)) end) < a.source_ssd then 'Pull in'"+ //modify Peggy 20200911
			  "      when NVL(a.schedule_ship_date,a.source_ssd-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else tsc_get_mo_line_totw_days(d.packing_instructions,c.order_number,d.line_id,trunc(sysdate)) end) > a.source_ssd then 'Push Out'"+ //modify Peggy 20200911
			  "      else '其他' end as revise_remarks"+
			  ",rank() over (partition by d.header_id,d.line_id order by a.request_no desc) odr_revise_seq"+  //add by Peggy 20190117
			  ",to_char(d.schedule_ship_date,'yyyy/mm/dd') erp_ssd"+  //add by Peggy 20190117		  
			  ",to_char(c.ordered_date,'yyyy/mm/dd') ordered_date"+ //add by Peggy 20190612
			  ",to_char(a.source_request_date,'yyyy/mm/dd') crd"+   //add by Peggy 20190612
			  ",count(1) over (partition by a.so_no,a.line_no) - ((SELECT COUNT (1) FROM tsc_om_salesorderrevise_req_v x WHERE x.temp_id = a.temp_id AND x.so_line_id = a.so_line_id)-1) request_cnt"+ //add by Peggy 20190612
			  ",sum (case when a.so_qty is null then a.source_so_qty else a.so_qty end) over (partition by  so_header_id, so_line_id) - a.source_so_qty  change_qty"+
			  ",to_number(to_char(a.source_ssd,'yyyymmdd'))-to_number(to_char(case when a.schedule_ship_date is null then a.source_ssd else  case when nvl(a.TO_TW_DAYS,0)<>0 then a.SCHEDULE_SHIP_DATE_TW else a.schedule_ship_date end end,'yyyymmdd')) change_ssd"+
			  ",sum (case when a.so_qty is null then a.source_so_qty else a.so_qty end) over (partition by  so_header_id, so_line_id)  change_new_qty"+
			  ",nvl(a.to_tw_days,0) to_tw_days"+ //add by Peggy 20200325
			  ",to_char(d.schedule_ship_date,'yyyy/mm/dd') erp_ssd"+ //add by Peggy 20210401
			  ",case when d.packing_instructions ='Y' then tsc_get_bom_material_item(case when substr(c.order_number,1,1)='4' THEN 326 ELSE 327 END,d.inventory_item_id) else '' end wafer_item"+
			  ",a.supplier_number"+ //add by Peggy 20220428
			  " from tsc_om_salesorderrevise_req_v a"+
			  ",oraddman.tsprod_manufactory b"+
			  ",ont.oe_order_headers_all c"+
			  ",ont.oe_order_lines_all d"+
			  //",ar_customers e";
			  ",hz_cust_accounts cust"+
			  ",hz_cust_accounts end_cust"+
			  ",hz_parties party";
		if (REPORT_TYPE.equals("AWAITING_CONFIRM"))
		{			  
			if (PLANTCODE.equals("005") || PLANTCODE.equals("008"))
			{
				sql+=",(SELECT A.SEGMENT1 PO_NO,C.VENDOR_SITE_CODE,TRUNC(B.NEED_BY_DATE) NEED_BY_DATE,B.QUANTITY-NVL(B.QUANTITY_CANCELLED,0) QUANTITY,SUBSTR (B.NOTE_TO_RECEIVER,1, INSTR (B.NOTE_TO_RECEIVER, '.') - 1) SO_NO"+
				  " , SUBSTR (B.NOTE_TO_RECEIVER,INSTR (B.NOTE_TO_RECEIVER, '.') + 1,LENGTH (B.NOTE_TO_RECEIVER)) SO_LINE_NO,B.UNIT_MEAS_LOOKUP_CODE PO_UOM"+
				  "   FROM PO.PO_HEADERS_ALL A,"+
				  "        PO.PO_LINE_LOCATIONS_ALL B,"+
				  "        AP.AP_SUPPLIER_SITES_ALL C"+
				  "        WHERE A.PO_HEADER_ID=B.PO_HEADER_ID"+
				  "        AND NVL(A.cancel_flag,'N') = 'N'"+
				  "        AND NVL(B.cancel_flag,'N') <> 'Y'"+
				  "        AND A.VENDOR_SITE_ID=C.VENDOR_SITE_ID"+
				  "        AND B.NOTE_TO_RECEIVER IS NOT NULL) g";
			}
			else if (PLANTCODE.equals("002")) //add by Peggy 20171020
			{
				//sql+=",(select order_line_id,listagg(wo_no,',') within group (order by wo_no) wip_list from yew_workorder_all ywa "+
				//     " where ywa.statusid<>'050'"+
				//     " and order_line_id >0"+
				//     " group by order_line_id) k";
				/*sql += ",(select order_line_id,listagg(wo_no,',') within group (order by wo_no) wip_list"+
					   ",sum(wip.quantity_completed* case when msi.primary_uom_code ='KPC' then 1000 else 1 end ) wip_completed_qty "+
					   " from yew_workorder_all ywa ,wip.wip_discrete_jobs wip,inv.mtl_system_items_b msi"+
					   " where ywa.statusid<>'050'"+
					   " and order_line_id >0"+
					   " and  wip.wip_entity_id=ywa.wip_entity_id"+
					   " and wip.organization_id=msi.organization_id"+
					   " and wip.primary_item_id=msi.inventory_item_id"+
					   " group by order_line_id) k";  //加入完工數量,add by Peggy 20180817*/
			}
		}
		/*sql += ",(select order_line_id,listagg(wo_no,',') within group (order by wo_no) wip_list"+
			   ",sum(wip.quantity_completed* case when msi.primary_uom_code ='KPC' then 1000 else 1 end ) wip_completed_qty "+
			   " from yew_workorder_all ywa ,wip.wip_discrete_jobs wip,inv.mtl_system_items_b msi"+
			   " where ywa.statusid<>'050'"+
			   " and order_line_id >0"+
			   " and  wip.wip_entity_id=ywa.wip_entity_id"+
			   " and wip.organization_id=msi.organization_id"+
			   " and wip.primary_item_id=msi.inventory_item_id"+
			   " group by order_line_id) k";  //加入完工數量,add by Peggy 20180817*/
		/*sql += ",(select order_line_id,listagg(wo_no,',') within group (order by wo_no) wip_list"+
			   ",sum(ywa.WO_QTY* case when msi.primary_uom_code ='KPC' then 1000 else 1 end ) wip_completed_qty "+
			   " from yew_workorder_all ywa ,inv.mtl_system_items_b msi"+
			   " where ywa.statusid<>'050'"+
			   " and ywa.order_line_id >0"+
			   " and ywa.inventory_item_id=msi.inventory_item_id"+
			   " and ywa.organization_id=msi.organization_id"+
			   " group by order_line_id) k";  //modify by Peggy 20190618,製造系統有開工單就顯示*/
		sql += ",(select order_line_id,listagg(wo_no,',') within group (order by wo_no) wip_list"+
			   ",sum(wipp.quantity_completed* case when wipp.primary_uom_code ='KPC' then 1000 else 1 end ) wip_completed_qty "+
			   ",sum(ywa.WO_QTY * case when ywa.WO_UOM='KPC' THEN 1000 ELSE 1 END) wo_qty"+
			   " from yew_workorder_all ywa ,(select wip.*,msi.primary_uom_code from wip.wip_discrete_jobs wip,inv.mtl_system_items_b msi"+
			   " where wip.organization_id=msi.organization_id"+
			   " and wip.primary_item_id=msi.inventory_item_id) wipp"+
			   " where ywa.statusid<>'050'"+
			   " and ywa.order_line_id >0"+
			   " and  wipp.wip_entity_id(+)=ywa.wip_entity_id"+
			   " group by ywa.order_line_id) k";  //加入完工數量,add by Peggy 20180817
		sql += " "+
			  //",ORADDMAN.TSC_CHINA_TO_TAIWAN_DAYS f"+  //modify by Peggy 20200911
			  //",ORADDMAN.TSC_CHINA_TO_TAIWAN_DAYS m"+ //modify by Peggy 20200911
			  //",ar_customers h"+
			  ",hz_cust_accounts cc"+
			  ",hz_parties pp "+
			  " where a.so_header_id=c.header_id(+)"+  //modify by Peggy 20180809
			  " and a.so_line_id=d.line_id(+)"+
			  //" and d.header_id=c.header_id"+
			  //" and c.sold_to_org_id=e.customer_id"+
			  " AND c.org_id in (41,325,906)"+  //add by Peggy 20210427
			  " AND c.sold_to_org_id = cust.cust_account_id"+   //modify by Peggy 20180809
			  " AND d.end_customer_id = end_cust.cust_account_id(+)"+   //modify by Peggy 20200520
			  " AND a.source_customer_id = cust.cust_account_id"+
			  " AND cust.party_id = party.party_id"+
			  " and a.plant_code =b.manufactory_no(+)";
		if (REPORT_TYPE.equals("AWAITING_CONFIRM"))
		{		  
			if (PLANTCODE.equals("005") || PLANTCODE.equals("008"))
			{
				sql+=" and to_char(a.so_no)=g.so_no(+)"+
					 " and SUBSTR (a.line_no,1, INSTR (a.line_no, '.') - 1)=g.so_line_no(+)";
			}
			else if (PLANTCODE.equals("002"))  //add by Peggy 20171020
			{
				//sql+= " and d.line_id = k.order_line_id(+)";
				//sql+= " and TSC_GET_YEW_TOTW_ORDER_INFO(d.line_id,'TSC','LINE_ID',NULL) = k.order_line_id(+)";  
			}		
		}
		sql+= " and TSC_GET_YEW_TOTW_ORDER_INFO(d.line_id,'TSC','LINE_ID',NULL) = k.order_line_id(+)";  	
		sql += " "+
			  //" AND A.PLANT_CODE=f.PLANT_CODE(+)"+
			  //" AND NVL(A.ORDER_TYPE,SUBSTR(A.SO_NO,1,4))=f.ORDER_NUM(+)"+
			  //" AND A.PLANT_CODE=m.PLANT_CODE(+)"+
			  //" AND SUBSTR(A.SO_NO,1,4)=m.ORDER_NUM(+)"+		  
			  //" AND d.end_customer_id = h.customer_id(+)";
			  " AND d.end_customer_id = cc.cust_account_id(+)"+  //modify by Peggy 20180809
			  " AND cc.party_id = pp.party_id(+)";
		if (REPORT_TYPE.equals("RESEND"))
		{
			sql += " and a.GROUP_ID ='"+ GROUP_ID+"' and a.STATUS = 'CLOSED'";	
		}
		else
		{
			if (!PLANTCODE.equals("--") && !PLANTCODE.equals(""))
			{
				sql += " and a.PLANT_CODE='"+PLANTCODE+"'";
			}	
			if (ORGCODE.equals("SG"))
			{
				sql += " and a.packing_instructions='T'";
			}
			else if (ORGCODE.equals("TSC"))		
			{
				sql += " and a.packing_instructions<>'T'";
			}			  
			if (!salesGroup.equals("--") && !salesGroup.equals(""))
			{
				sql += " and a.SALES_GROUP='"+salesGroup+"'";
			}
			if (!CUST.equals("") && !CUST.equals("--"))
			{
				sql += " and upper(case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end  else  NVL ( DECODE (party.party_type,'ORGANIZATION', party.organization_name_phonetic, NULL), SUBSTRB (party.party_name, 1, 50)) end) like '%"+CUST.toUpperCase()+"%'";
			}
			if (!ITEMDESC.equals("") && !ITEMDESC.equals("--"))
			{
				sql += " and a.SOURCE_ITEM_DESC like '"+ITEMDESC+"%'";
			}	
			if (!CREATEDBY.equals("") && !CREATEDBY.equals("--"))
			{
				sql += " and a.CREATED_BY ='"+CREATEDBY+"'";
			}
			if (!MONO.equals(""))
			{
				sql += " and c.ORDER_NUMBER LIKE '"+MONO+"%'";
			}
			if (!STATUS.equals("") && !STATUS.equals("--"))
			{
				sql += " and a.STATUS = '"+STATUS+"'";
				if (STATUS.equals("CONFIRMED")) sql += " and a.GROUP_ID is null";
			}	
			if (!SDATE.equals("") || !EDATE.equals(""))
			{
				sql += " and a.CREATION_DATE  BETWEEN TO_DATE('"+(SDATE.equals("")?"20150101":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?dateBean.getYearMonthDay():EDATE)+"','yyyymmdd')+0.99999";
			}	
			if (!PC_SDATE.equals("") || !PC_EDATE.equals(""))
			{
				sql += " and a.PC_CONFIRMED_DATE  BETWEEN TO_DATE('"+(PC_SDATE.equals("")?"20150101":PC_SDATE)+"','yyyymmdd') AND TO_DATE('"+ (PC_EDATE.equals("")?dateBean.getYearMonthDay():PC_EDATE)+"','yyyymmdd')+0.99999";
			}			
			if (!TEMP_ID.equals(""))
			{
				sql += " and a.TEMP_ID ='"+ TEMP_ID+"'";
			}
			if (!REPORT_TYPE.equals("QUERY"))
			{
				 sql += " and a.STATUS='"+REPORT_TYPE+"'";
			}
			if (!REQUESTNO.equals(""))
			{
				sql += " and a.REQUEST_NO='"+ REQUESTNO+"'";
			}
			if (!RESULT.equals("") && !RESULT.equals("--"))
			{
				sql += " and a.PC_CONFIRMED_RESULT = '"+RESULT+"'";
			}
			if (!SALES_RESULT.equals("") && !SALES_RESULT.equals("--"))
			{
				if (SALES_RESULT.equals("No Revise"))
				{
					sql += " and a.SALES_CONFIRMED_RESULT in (0,4)";
				}
				else if (SALES_RESULT.equals("Hold Order"))
				{
					sql += " and a.SALES_CONFIRMED_RESULT in (2)";
				}
				else if (SALES_RESULT.equals("Revise Order"))
				{
					sql += " and a.SALES_CONFIRMED_RESULT in (1)";
				}
			}	
			if (!REQUEST_DATE.equals("") && !REQUEST_DATE.equals("--"))
			{
				sql += " and a.CREATION_DATE BETWEEN TO_DATE('"+ REQUEST_DATE+"','yyyymmdd') and TO_DATE('"+ REQUEST_DATE+"','yyyymmdd')+0.99999";
			}	
			if (!CUSTPO.equals(""))  //add by Peggy 20160325
			{
				sql += " and (a.CUSTOMER_PO LIKE '"+CUSTPO+"%' or a.SOURCE_CUSTOMER_PO LIKE '"+CUSTPO+"%')";
			}
			if (!PULL_SDATE.equals("") || !PULL_EDATE.equals(""))
			{
				sql += " and a.schedule_ship_date  BETWEEN TO_DATE('"+(PULL_SDATE.equals("")?"20150101":PULL_SDATE)+"','yyyymmdd') AND TO_DATE("+ (PULL_EDATE.equals("")?"TO_CHAR(SYSDATE+365,'yyyymmdd')":"'"+PULL_EDATE+"'")+",'yyyymmdd')+0.99999";
			}	
			if (!REVISE_SDATE.equals("") || !REVISE_EDATE.equals(""))
			{
				//sql += " and a.schedule_ship_date  BETWEEN TO_DATE('"+(PULL_SDATE.equals("")?"20150101":PULL_SDATE)+"','yyyymmdd') AND TO_DATE('"+ (PULL_EDATE.equals("")?"TO_CHAR(SYSDATE+365,'yyyymmdd')":PULL_EDATE)+"','yyyymmdd')+0.99999";
				sql += " and (a.STATUS = 'CLOSED' and a.last_update_date  BETWEEN TO_DATE('"+(REVISE_SDATE.equals("")?"20150101":REVISE_SDATE)+"','yyyymmdd') AND TO_DATE("+ (REVISE_EDATE.equals("")?"TO_CHAR(SYSDATE,'yyyymmdd')":"'"+REVISE_EDATE+"'")+",'yyyymmdd')+0.99999)";
			}	
			if (ACTTYPE.equals("REMINDER"))
		    {			       
				sql += " and DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC',a.sales_group)='"+SALES_REGION+"'";
			}										
		}
		//sql += " order by a.SALES_GROUP,a.customer_number,a.item_desc,a.SO_NO||'-'||a.LINE_NO";
		sql += " order by a.SALES_GROUP,a.SO_NO||'-'||a.LINE_NO";
		//out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);
		String sheetname [] = wwb.getSheetNames();
		reccnt=0;
		while (rs.next()) 
		{ 	
			if (chkma.equals("Y")) 
			{
				if (rs.getInt("ODR_REVISE_SEQ")!=1) continue;
			}	
			//out.println(reccnt+"  "+rs.getString("so_no"));
			if (reccnt==0)
			{
				col=0;row=0;
				ws = wwb.getSheet(sheetname[0]);
				SheetSettings sst = ws.getSettings(); 
				sst.setSelected();
				if (REPORT_TYPE.equals("AWAITING_CONFIRM"))
				{
					sst.setVerticalFreeze(1);  //凍結窗格
					for (int g =1 ; g <=13+(PLANTCODE.equals("002")?3:0) ;g++ )
					{
						sst.setHorizontalFreeze(g);
					}	
					//申請單號
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Request No" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;					
	
					//序號
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Seq No" , ACenterBL));
					ws.setColumnView(col,5);	
					col++;					
						
					//工廠別
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Plant Code" , ACenterBL));
					ws.setColumnView(col,8);	
					col++;	
								
					//Sales Group
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Sales Group" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
	
					//Requester
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Requester" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
	
					//customer
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
					ws.setColumnView(col,25);	
					col++;	
		
					//MO#
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
		
					//Line#
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Line#" , ACenterBL));
					ws.setColumnView(col,8);	
					col++;	
	
					//原料號
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Original Item Name" , ACenterBL));
					ws.setColumnView(col,30);	
					col++;	
		
					//原品名
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Original Item Desc" , ACenterBL));
					ws.setColumnView(col,25);	
					col++;	
	
					//WAFER料號
					if (PLANTCODE.equals("002")) //add by Peggy 20210427
					{
						ws.mergeCells(col, row, col, row); 
						ws.addCell(new jxl.write.Label(col, row, "Wafer料號" , ACenterBL));
						ws.setColumnView(col,20);	
						col++;				
					}
					
					//Family
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
	
					//package
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
		
					//原訂單量
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Original Qty" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
					
					if (PLANTCODE.equals("002"))  //add by Peggy 20190618
					{
						//下單日期
						ws.mergeCells(col, row, col, row); 
						ws.addCell(new jxl.write.Label(col, row, "下單日期" , ACenterBL));
						ws.setColumnView(col,10);	
						col++;	
		
						//CRD
						ws.mergeCells(col, row, col, row); 
						ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBL));
						ws.setColumnView(col,10);	
						col++;	
					}
		
					//原交期
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "Original SSD" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
		
					//Order Type
					ws.addCell(new jxl.write.Label(col, row, "Order Type" , ACenterBLB));
					ws.setColumnView(col,12);	
					col++;
		
					//Customer
					ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLB));
					ws.setColumnView(col,25);	
					col++;	
		
					//Ship To
					ws.addCell(new jxl.write.Label(col, row, "Ship To" , ACenterBLB));
					ws.setColumnView(col,25);	
					col++;		
		
					//Item Name
					ws.addCell(new jxl.write.Label(col, row, "Item Name" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
						
					//Item Desc
					ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
		
					//Cust P/N
					ws.addCell(new jxl.write.Label(col, row, "Cust P/N" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;
					
					//Cust PO
					ws.addCell(new jxl.write.Label(col, row, "Cust PO" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
	
					//Shipping Method
					ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
					
					//add by Peggy 20220428
					ws.addCell(new jxl.write.Label(col, row, "Supplier Number" , ACenterBLB));
					ws.setColumnView(col,12);	
					col++;
									
					//Order Qty
					ws.addCell(new jxl.write.Label(col, row, "Sales Qty pull in/out" , ACenterBLB));
					ws.setColumnView(col,10);	
					col++;													
	
					//SSD pull in/out
					ws.addCell(new jxl.write.Label(col, row, "Sales SSD pull in/out" , ACenterBLB));
					ws.setColumnView(col,10);	
					col++;
	
					//Factory CFM Qty
					ws.addCell(new jxl.write.Label(col, row, "Factory CFM Qty" , ACenterBLY));
					ws.setColumnView(col,10);	
					col++;													
	
					//Factory CFM SSD
					ws.addCell(new jxl.write.Label(col, row, "Factory CFM SSD" , ACenterBLY));
					ws.setColumnView(col,10);	
					col++;
	
					//Factory CFM Result
					ws.addCell(new jxl.write.Label(col, row, "Factory CFM Result" , ACenterBLY));
					ws.setColumnView(col,10);	
					col++;	
	
					//Factory Remark
					ws.addCell(new jxl.write.Label(col, row, "Factory Remark" , ACenterBLY));
					ws.setColumnView(col,15);	
					col++;	
	
					//Remarks
					ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
	
					if (PLANTCODE.equals("005") || PLANTCODE.equals("008"))
					{
						//供應商
						ws.addCell(new jxl.write.Label(col, row, "Vendor Name" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
	
						//採購單
						ws.addCell(new jxl.write.Label(col, row, "PO#" , ACenterBL));
						ws.setColumnView(col,12);	
						col++;	
	
						//採購需求日
						ws.addCell(new jxl.write.Label(col, row, "PO Need by Date" , ACenterBL));
						ws.setColumnView(col,12);	
						col++;
						
						//採購數量
						ws.addCell(new jxl.write.Label(col, row, "PO Qty(K)" , ACenterBL));
						ws.setColumnView(col,12);	
						col++;																	
					}	
					else if (PLANTCODE.equals("002"))  //add by Peggy 20171020
					{	
						//工單號
						ws.addCell(new jxl.write.Label(col, row, "工單號" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
	
						//工單數量
						ws.addCell(new jxl.write.Label(col, row, "工單數量" , ACenterBL));
						ws.setColumnView(col,10);	
						col++;
	
						//完工入庫量
						ws.addCell(new jxl.write.Label(col, row, "完工入庫量" , ACenterBL));
						ws.setColumnView(col,10);	
						col++;
					}
					//add by Peggy 20200325
					ws.addCell(new jxl.write.Label(col, row, "回T" , ACenterBL));
					ws.setColumnView(col,8);	
					col++;	
					row++;
				}
				else if (REPORT_TYPE.equals("CONFIRMED") || REPORT_TYPE.equals("QUERY"))
				{
					ws.mergeCells(col, row, col+2, row); 
					ws.addCell(new jxl.write.Label(col, row, "註:訂單項次分批出貨以藍色字體標示" , ACenterBLY));
					row++;						
				
					sst.setVerticalFreeze(2);  //凍結窗格
					//sst.setVerticalFreeze(2);  //凍結窗格
					for (int g =1 ; g <=14 ;g++ )
					{
						sst.setHorizontalFreeze(g);
					}	
					
					//Request No
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Request No" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;						
								
					//Sales Group
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Sales Group" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
	
					//customer
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
					ws.setColumnView(col,25);	
					col++;	
	
					//end customer
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "End Customer" , ACenterBL));
					ws.setColumnView(col,25);	
					col++;	
		
					//MO#
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
		
					//Line#
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Line#" , ACenterBL));
					ws.setColumnView(col,8);	
					col++;	
		
					//原品名
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Original Item Desc" , ACenterBL));
					ws.setColumnView(col,20);	
					col++;	
						
					//package
					ws.mergeCells(col, row, col, row); 
					ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	

					//原Cust PO
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Original Cust PO" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
					
					//原訂單量
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Original Qty" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
	
					//下單日期
					ws.addCell(new jxl.write.Label(col, row, "下單日期" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
	
					//CRD
					ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
		
					//原交期
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Original TW SSD" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
					
					//原交期
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Original SSD" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;				
						
					//訂單修改明細
					//ws.mergeCells(col, row, col+13, row); 
					//ws.addCell(new jxl.write.Label(col, row, "Order Revise Detail" , ACenterBLB));
					//ws.setColumnView(col,10);	
					//col+=14;	
					
					//工廠回覆結果
					//ws.mergeCells(col, row, col+4, row); 
					//ws.addCell(new jxl.write.Label(col, row, "PC Replied Detail " , ACenterBLO));
					//ws.setColumnView(col,10);	
					//col+=5;
					//Order Type
					ws.addCell(new jxl.write.Label(col, row, "Order Type" , ACenterBLB));
					ws.setColumnView(col,12);	
					col++;
		
					//Customer
					ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLB));
					ws.setColumnView(col,25);	
					col++;	
					
		
					//Ship To
					ws.addCell(new jxl.write.Label(col, row, "Ship To" , ACenterBLB));
					ws.setColumnView(col,25);	
					col++;		
		
		
					//Bill To
					ws.addCell(new jxl.write.Label(col, row, "Bill To" , ACenterBLB));
					ws.setColumnView(col,25);	
					col++;		
					
					//Deliver To
					ws.addCell(new jxl.write.Label(col, row, "Deliver To" , ACenterBLB));
					ws.setColumnView(col,30);	
					col++;	
					
					//Item Desc
					ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
		
					//Cust P/N
					ws.addCell(new jxl.write.Label(col, row, "Cust P/N" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;
					
					//Cust PO
					ws.addCell(new jxl.write.Label(col, row, "Cust PO" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
	
					//Shipping Method
					ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
						
					//add by Peggy 20220428
					ws.addCell(new jxl.write.Label(col, row, "Supplier Number" , ACenterBLB));
					ws.setColumnView(col,12);	
					col++;	
													
					//Order Qty
					ws.addCell(new jxl.write.Label(col, row, "Order Qty" , ACenterBLB));
					ws.setColumnView(col,10);	
					col++;													
	
					//TW SSD pull in/out
					ws.addCell(new jxl.write.Label(col, row, "TW SSD pull in/out" , ACenterBLB));
					ws.setColumnView(col,10);	
					col++;
	
					//SSD pull in/out
					ws.addCell(new jxl.write.Label(col, row, "SSD pull in/out" , ACenterBLB));
					ws.setColumnView(col,10);	
					col++;
							
					//REQUEST DATE
					ws.addCell(new jxl.write.Label(col, row, "Request Date(New CRD)" , ACenterBLB));
					ws.setColumnView(col,10);	
					col++;
											
					//FOB
					ws.addCell(new jxl.write.Label(col, row, "FOB" , ACenterBLB));
					ws.setColumnView(col,10);	
					col++;
											
					//Remarks
					ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;								
	
					//工廠別
					ws.addCell(new jxl.write.Label(col, row, "Plant Code" , ACenterBLO));
					ws.setColumnView(col,8);	
					col++;	
					
					//工廠確認數量
					ws.addCell(new jxl.write.Label(col, row, "PC QTY" , ACenterBLO));
					ws.setColumnView(col,10);	
					col++;
		
					//工廠確認交期
					ws.addCell(new jxl.write.Label(col, row, "PC SSD" , ACenterBLO));
					ws.setColumnView(col,10);	
					col++;	
	
					//工廠確認交期TW
					ws.addCell(new jxl.write.Label(col, row, "PC TW SSD" , ACenterBLO));
					ws.setColumnView(col,10);	
					col++;	
		
					//工廠回覆結果
					ws.addCell(new jxl.write.Label(col, row, "PC Result" , ACenterBLO));
					ws.setColumnView(col,10);	
					col++;		
		
					//工廠備註
					ws.addCell(new jxl.write.Label(col, row, "PC Remarks" , ACenterBLO));
					ws.setColumnView(col,20);	
					col++;	
	
					//Requester
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Requester" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
					
					//Request DATE
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "Request Date" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
					
					//PC Confirmed
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "PC Confirmed" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;	
									
					//pc confirm date
					//ws.mergeCells(col, row, col, row+1); 
					ws.addCell(new jxl.write.Label(col, row, "PC Confirmed Date" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;										
									
					if (REPORT_TYPE.equals("QUERY"))
					{
					
						//Last Updated By
						//ws.mergeCells(col, row, col, row+1); 
						ws.addCell(new jxl.write.Label(col, row, "Last Updated By" , ACenterBL));
						ws.setColumnView(col,12);	
						col++;	
										
						//Last Update Date
						//ws.mergeCells(col, row, col, row+1); 
						ws.addCell(new jxl.write.Label(col, row, "Last Update Date" , ACenterBL));
						ws.setColumnView(col,12);	
						col++;	
										
						//Sales Confirm Status
						//ws.mergeCells(col, row, col, row+1); 
						ws.addCell(new jxl.write.Label(col, row, "Sales Confirm Result" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;	
					

						//Change Reason
						//ws.mergeCells(col, row, col, row+1); 
						ws.addCell(new jxl.write.Label(col, row, "Change Reason" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;	
					
						//Change Comments
						//ws.mergeCells(col, row, col, row+1); 
						ws.addCell(new jxl.write.Label(col, row, "Change Comments" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;		
									
						//新訂單
						//ws.mergeCells(col, row, col, row+1); 
						ws.addCell(new jxl.write.Label(col, row, "New MO#" , ACenterBL));
						ws.setColumnView(col,12);	
						col++;	
						
						//新項次
						//ws.mergeCells(col, row, col, row+1); 
						ws.addCell(new jxl.write.Label(col, row, "New Line#" , ACenterBL));
						ws.setColumnView(col,8);	
						col++;	
						
						//狀態
						//ws.mergeCells(col, row, col, row+1); 
						ws.addCell(new jxl.write.Label(col, row, "STATUS" , ACenterBL));
						ws.setColumnView(col,16);	
						col++;		
						
						//PROD GROUP
						ws.mergeCells(col, row, col, row); 
						ws.addCell(new jxl.write.Label(col, row, "PROD GROUP" , ACenterBL));
						ws.setColumnView(col,12);	
						col++;
											
						//Family
						ws.mergeCells(col, row, col, row); 
						ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBL));
						ws.setColumnView(col,16);	
						col++;	
		
						//RESEND_TIMES
						ws.addCell(new jxl.write.Label(col, row, "Resend Times" , ACenterBLB));
						ws.setColumnView(col,8);	
						col++;	
		
						//RESEND_FROM_REQUEST_NO
						ws.addCell(new jxl.write.Label(col, row, "Resend From Request" , ACenterBLB));
						ws.setColumnView(col,12);	
						col++;	
							
						//if ((UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) ||  UserRoles.indexOf("Sale")<0)
						//{
							//revise分析
							ws.addCell(new jxl.write.Label(col, row, "類別分析" , ACenterBL));
							ws.setColumnView(col,10);	
							col++;	
	
							//工單號
							ws.addCell(new jxl.write.Label(col, row, "工單號" , ACenterBL));
							ws.setColumnView(col,15);	
							col++;
		
							//完工入庫量
							ws.addCell(new jxl.write.Label(col, row, "完工入庫量" , ACenterBL));
							ws.setColumnView(col,10);	
							col++;
	
							//次數統計
							ws.addCell(new jxl.write.Label(col, row, "次數統計" , ACenterBL));
							ws.setColumnView(col,10);	
							col++;
						//}					
					}
	
					if (chkma.equals("Y"))
					{
						//erp order ssd,add by Peggy 20190117 for Mabel issue
						ws.addCell(new jxl.write.Label(col, row, "ERP MO SSD" , ACenterBL));
						ws.setColumnView(col,10);	
						col++;	
					}
					//add by Peggy 20200325
					ws.addCell(new jxl.write.Label(col, row, "回T" , ACenterBL));
					ws.setColumnView(col,8);	
					col++;	
					row++;
				}
				
			}
			col=0;
			if (REPORT_TYPE.equals("AWAITING_CONFIRM"))
			{
				ws.addCell(new jxl.write.Label(col, row, rs.getString("request_no"), ACenterL));
				col++;					
				ws.addCell(new jxl.write.Label(col, row, rs.getString("seq_id"), ACenterL));
				col++;					
				if (!rs.getString("so_line_id").equals(so_line_id))
				{
					so_line_id=rs.getString("so_line_id");	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("ALENGNAME"), ACenterL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("sales_group"), ACenterL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATED_BY"), ALeftL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("orig_customer"), ALeftL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("so_no") , ALeftL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("line_no") , ALeftL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("orig_item_name") , ALeftL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("orig_item_desc") , ALeftL));
					col++;	
					//WAFER料號
					if (PLANTCODE.equals("002")) //add by Peggy 20210427
					{
						ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
						ws.addCell(new jxl.write.Label(col, row, rs.getString("wafer_item") , ALeftL));
						col++;	
					}				
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_family") , ALeftL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_package") , ALeftL));
					col++;	
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("orig_so_qty")).doubleValue(), ARightL));
					col++;	
					if (PLANTCODE.equals("002"))  //add by Peggy 20190618
					{
						ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
						if (rs.getString("ordered_date")==null)
						{
							ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						}
						else
						{
							ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ordered_date")) ,DATE_FORMAT));
						}
						col++;					
						ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
						if (rs.getString("crd")==null)
						{
							ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						}
						else
						{
							ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("crd")) ,DATE_FORMAT));
						}
						col++;	
					}
					ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					if (rs.getString("orig_schedule_ship_date")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
					}
					else
					{
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("orig_schedule_ship_date")) ,DATE_FORMAT));
					}
					col++;	
				}
				else
				{
					col+=(12+(PLANTCODE.equals("002")?3:0));
				}
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("order_type")==null?"":rs.getString("order_type")), ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("customer_name")==null?"":rs.getString("customer_name")), ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("ship_to")==null?"":rs.getString("ship_to")), ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("item_name")==null?"":rs.getString("item_name")), ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("item_desc")==null?"":rs.getString("item_desc")), ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("cust_item_name")==null?"":rs.getString("cust_item_name")), ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("customer_po")==null?"":rs.getString("customer_po")), ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("shipping_method")==null?"":rs.getString("shipping_method")), ALeftL));
				col++;	
				//supplier number,add by Peggy 20220428
				ws.addCell(new jxl.write.Label(col, row,  (rs.getString("supplier_number")==null?"":rs.getString("supplier_number")), ACenterL));
				col++;				
				//if (rs.getString("so_qty")==null)
				//{
				//	ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
				//}
				//else
				//{
				if (rs.getInt("change_qty")>0)
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("so_qty")).doubleValue(), ARightL_B));
				}
				else if (rs.getInt("change_qty")<0)
				{		
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("so_qty")).doubleValue(), ARightL_R));
				}
				else
				{	
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("so_qty")).doubleValue(), ARightL));
				}
				//}			
				col++;	
				//if (rs.getString("schedule_ship_date")==null)
				//{
				//	ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
				//}
				//else
				//{
				if (Double.valueOf(rs.getString("so_qty")).doubleValue()==0)
				{
					ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
				}
				else
				{
					if (rs.getInt("change_ssd")>0)
					{
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("schedule_ship_date")) ,DATE_FORMAT_B));
					}
					else if (rs.getInt("change_ssd")<0)
					{
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("schedule_ship_date")) ,DATE_FORMAT_R));
					}
					else
					{
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("schedule_ship_date")) ,DATE_FORMAT));
					}
				}
				//}	
				col++;		
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("so_qty")).doubleValue(), ARightL));
				col++;	
				if ((rs.getString("plant_code").equals("005") || rs.getString("plant_code").equals("008")) || Double.valueOf(rs.getString("so_qty")).doubleValue()==0)
				{
					ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("schedule_ship_date")) ,DATE_FORMAT));
				}
				col++;	
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("remarks")==null?"":rs.getString("remarks")), ALeftL));
				col++;	
				if (PLANTCODE.equals("005") || PLANTCODE.equals("008"))
				{
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("vendor_site_code")==null?"":rs.getString("vendor_site_code")), ALeftL));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("po_no")==null?"":rs.getString("po_no")), ALeftL));
					col++;							
					if (rs.getString("need_by_date")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
					}
					else
					{
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("need_by_date")) ,DATE_FORMAT));
					}	
					col++;				
					if (rs.getString("po_qty")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
					}
					else
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("po_qty")).doubleValue(), ARightL));
					}			
					col++;					
				}
				else if (PLANTCODE.equals("002"))  //add by Peggy 20171020
				{	
					//工單號
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("wip_list")==null?"":rs.getString("wip_list")), ACenterL));
					col++;	
					//工單數量
					if (rs.getString("WO_QTY")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
					}
					else
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("WO_QTY")).doubleValue(), ARightL));
					}				
					col++;	
					//完工入庫量,add by Peggy 20180817
					if (rs.getString("wip_completed_qty")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
					}
					else
					{
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("wip_completed_qty")).doubleValue(), ARightL));
					}			
					col++;				
				}	
				//to tw,add by Peggy 20200325	
				ws.addCell(new jxl.write.Label(col, row, (rs.getInt("to_tw_days")>0?"Y":"N") , (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;						
				row++;				
			}
			else if (REPORT_TYPE.equals("CONFIRMED") || REPORT_TYPE.equals("QUERY"))
			{
				//if (!rs.getString("so_line_id").equals(so_line_id))
				//{
					so_line_id=rs.getString("so_line_id");	
					//ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("request_no"), (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
					col++;	
					//ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("sales_group"), (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
					col++;	
					//ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("orig_customer"), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("end_customer"), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					//ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("so_no") , (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					//ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("line_no") , (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("orig_item_desc") , (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_package") , (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					//ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("source_customer_po") , (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;					
					//ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("orig_so_qty")).doubleValue(), (rs.getInt("partial_cnt")>1?ARightLB:ARightL)));
					col++;	
					if (rs.getString("ordered_date")==null)  //add by Peggy 20190612
					{
						ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
					}
					else
					{
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ordered_date")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
					}
					col++;	
					if (rs.getString("crd")==null)  //add by Peggy 20190612
					{
						ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
					}
					else
					{
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("crd")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
					}	
					col++;
					//ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 
					if (rs.getString("orig_schedule_ship_date_tw")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
					}
					else
					{	
						//add by Peggy 20210401
						if (!chkma.equals("Y") && (rs.getString("status").equals("AWAITING_CONFIRM") ||rs.getString("status").equals("CONFIRMED"))  && !rs.getString("orig_schedule_ship_date_tw").equals(rs.getString("erp_ssd")))
						{
							ws.addCell(new jxl.write.Label(col, row, rs.getString("orig_schedule_ship_date_tw")+"\r\nERP SSD:"+rs.getString("erp_ssd") , ACenter_R));
						}
						else
						{
							ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("orig_schedule_ship_date_tw")) , (rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
						}
					}
					col++;	
					if (rs.getString("orig_schedule_ship_date")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
					}
					else
					{	
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("orig_schedule_ship_date")) , (rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
	
					}
					col++;					
				//}
				//else
				//{
				//	col=9;
				//}
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("order_type")==null?"":rs.getString("order_type")), (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("customer_name")==null?"":rs.getString("customer_name")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("ship_to")==null?"":rs.getString("ship_to")),(rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("bill_to")==null?"":rs.getString("bill_to")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("deliver_to")==null?"":rs.getString("deliver_to")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("item_desc")==null?"":rs.getString("item_desc")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("cust_item_name")==null?"":rs.getString("cust_item_name")),(rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("customer_po")==null?"":rs.getString("customer_po")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("shipping_method")==null?"":rs.getString("shipping_method")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				//supplier number,add by Peggy 20220428
				ws.addCell(new jxl.write.Label(col, row,  (rs.getString("supplier_number")==null?"":rs.getString("supplier_number")), ACenterL));
				col++;				
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("so_qty")).doubleValue(), (rs.getInt("partial_cnt")>1?ARightLB:ARightL)));
				col++;	
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("schedule_ship_date_tw")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
				col++;	
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("schedule_ship_date")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
				col++;	
				if (rs.getString("request_date")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("request_date")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
				}	
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("fob")==null?"":rs.getString("fob")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("remarks")==null?"":rs.getString("remarks")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("ALENGNAME"),(rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
				col++;	
				if (rs.getString("pc_so_qty")==null || (rs.getString("pc_confirmed_result") != null && rs.getString("pc_confirmed_result").equals("R")))
				{
					ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("pc_so_qty")).doubleValue(),  (rs.getInt("partial_cnt")>1?ARightLB:ARightL)));
				}			
				col++;	
				if (rs.getString("pc_schedule_ship_date")==null || (rs.getString("pc_confirmed_result") != null && rs.getString("pc_confirmed_result").equals("R")))
				{
					ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("pc_schedule_ship_date")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
				}
				col++;
				if (rs.getString("pc_schedule_ship_date_tw")==null)  //add by Peggy 20191004
				{
					ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("pc_schedule_ship_date_tw")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
				}
				col++;
				if (rs.getString("pc_confirmed_result") ==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("pc_confirmed_result").equals("A")?"Accept":"Reject"), (rs.getInt("partial_cnt")>1?(rs.getString("pc_confirmed_result").equals("A")? ACenterLGB:ACenterLPB):(rs.getString("pc_confirmed_result").equals("A")? ACenterLG:ACenterLP))));
				}
				col++;				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("pc_remarks")==null?"":rs.getString("pc_remarks")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATED_BY"), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("CREATION_DATE")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("PC_CONFIRMED_BY")==null?"":rs.getString("PC_CONFIRMED_BY")),(rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				if (rs.getString("PC_CONFIRMED_DATE")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("PC_CONFIRMED_DATE")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
				}
				col++;	
				if (REPORT_TYPE.equals("QUERY"))
				{
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("LAST_UPDATED_BY")==null?"":rs.getString("LAST_UPDATED_BY")),(rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("LAST_UPDATE_DATE")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("SALES_CONFIRMED_RESULT")==null?"":rs.getString("SALES_CONFIRMED_RESULT")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("CHANGE_REASON")==null?"":rs.getString("CHANGE_REASON")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("CHANGE_COMMENTS")==null?"":rs.getString("CHANGE_COMMENTS")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;					
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("NEW_SO_NO")==null?"":rs.getString("NEW_SO_NO")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("NEW_LINE_NO")==null?"":rs.getString("NEW_LINE_NO")), (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("STATUS"),(rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_prod_group") , (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));  //add by Peggy 20210325
					col++;					
					ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_family") , (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("RESEND_TIMES")==null?"":rs.getString("RESEND_TIMES")) , (rs.getInt("partial_cnt")>1?ARightLB:ARightL)));
					col++;	
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("RESEND_FROM_REQUEST_NO")==null?"":rs.getString("RESEND_FROM_REQUEST_NO")) , (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
					col++;	
					//if ((UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) ||  UserRoles.indexOf("Sale")<0)
					//{	
						//類別分析
						ws.addCell(new jxl.write.Label(col, row, (rs.getString("revise_remarks")==null?"":rs.getString("revise_remarks")), ACenterL));
						col++;	
						
						//工單號,add by Peggy 20190612
						ws.addCell(new jxl.write.Label(col, row, (rs.getString("wip_list")==null?"":rs.getString("wip_list")), (rs.getInt("partial_cnt")>1?ARightLB:ARightL)));
						col++;	
						//完工入庫量,add by Peggy 20190612
						if (rs.getString("wip_completed_qty")==null)
						{
							ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ARightLB:ARightL)));
						}
						else
						{
							ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("wip_completed_qty")).doubleValue(),(rs.getInt("partial_cnt")>1?ARightLB:ARightL)));
						}			
						col++;				
						//次數統計,add by Peggy 20190612
						if (rs.getString("request_cnt")==null)
						{
							ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
						}
						else
						{
							ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("request_cnt")).doubleValue(),  (rs.getInt("partial_cnt")>1?ARightLB:ARightL)));
						}
						col++;				
					//}				
				}	
				if (chkma.equals("Y"))
				{
					//erp order ssd,add by Peggy 20190117 for Mabel issue
					if (rs.getString("erp_ssd")==null)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , (rs.getInt("partial_cnt")>1?ACenterLB:ACenterL)));
					}
					else
					{				
						ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("erp_ssd")) ,(rs.getInt("partial_cnt")>1?DATE_FORMAT1:DATE_FORMAT)));
					}
					col++;	
				}
				//to tw,add by Peggy 20200325	
				ws.addCell(new jxl.write.Label(col, row, (rs.getInt("to_tw_days")>0?"Y":"N") , (rs.getInt("partial_cnt")>1?ALeftLB:ALeftL)));
				col++;	
				//out.println("row="+row);		
				row++;				
			}
			
			reccnt ++;
		}	
		rs.close();
		statement.close();
		wwb.write(); 
		wwb.close();
	
		if (ACTTYPE.equals("REMINDER") && reccnt>0)
		{
			Properties props = System.getProperties();
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", "mail.ts.com.tw");
			props.put("mail.smtp.port", "25");
			
			Session s = Session.getInstance(props, null);
			javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
			message.setSentDate(new java.util.Date());
			message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
			remarks="";
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				remarks="(這是來自RFQ測試區的信件)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else 
			{
				if (SALES_REGION.equals("TSCE"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("emily.hsin@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sammy.chang@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rachel.chen@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("celine.yu@ts.com.tw"));
				}
				else if (SALES_REGION.equals("TSCA"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("cynthia.tseng@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("cindy.huang@ts.com.tw"));
				}
				else if (SALES_REGION.equals("TSCJ"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bonnie.liu@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("jacksonl@ts.com.tw"));
				}
				else if (SALES_REGION.equals("TSCH-HK"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("demi_duan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("fiona_chen@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("gina@mail.tew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jodie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("regina_pu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sandy_sun@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sophia_li@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tina@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tingting@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs001@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs002@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs003@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs006@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs007@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs008@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-sample@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wendy_cai@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("xiongyu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("winnie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anna_qiu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jason@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kevin@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("Lauren_pei@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peter_zheng@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kara_tian@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sandy@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("william_wu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jack_tang@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nina_zan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("hongmei_li@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lisahou@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peter_zheng@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kara_tian@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs005@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
				}	
				else if (SALES_REGION.equals("TSCC"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs002@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs003@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs006@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs007@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs008@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("joyce@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("xiongyu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("winnie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tina@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anna_qiu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jason@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kevin@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lauren_pei@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peter_zheng@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kara_tian@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("demi_duan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sandy@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("william_wu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jack_tang@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nina_zan@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("hongmei_li@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-cs002@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lisahou@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("chris_wen@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("daphne_zhang@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lily_yin@ts-china.com.cn"));					
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("tschk-sample@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("ccyang@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("tschk-cs004@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("tschk-cs001@ts-china.com.cn"));					
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn"));
				}
				else if (SALES_REGION.equals("TSCK"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("bonnie.liu@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("june.wang@ts.com.tw"));
					
				}							
				else if (SALES_REGION.equals("TSCR-ROW"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("alvin.lin@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("lisa.chen@ts.com.tw"));
				}							
				else if (SALES_REGION.equals("TSCT-DA"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("vivian.chou@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zoe.wu@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rika_lin@ts.com.tw"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("olivia.hsu@ts.com.tw"));
				}							
				else if (SALES_REGION.equals("TSCT-Disty"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("kristin.wu@ts.com.tw"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("sofia.liu@ts.com.tw"));
				}		
				else if (SALES_REGION.equals("SAMPLE"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jenny.liao@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("demi.kao@ts.com.tw"));
				}								
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
	
			V_CUST_LIST="";
			sql = " SELECT DISTINCT '('||ar.account_number||')'|| case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end"+
				  " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id in (14980,1019) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as customer"+
				  " FROM oraddman.tsc_om_salesorderrevise_req a"+
				  " ,ont.oe_order_lines_all d"+
				  " ,tsc_customer_all_v ar"+
				  " ,hz_cust_accounts end_cust"+
				  " WHERE DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC',a.sales_group)=?"+
				  " AND a.STATUS=?"+
				  " AND a.so_line_id=d.line_id"+
				  " AND a.SOURCE_CUSTOMER_ID=ar.customer_id"+
				  " AND d.end_customer_id = end_cust.cust_account_id(+)";
			PreparedStatement statement2 = con.prepareStatement(sql);
			statement2.setString(1,SALES_REGION);
			statement2.setString(2,REPORT_TYPE);
			//out.println(SALES_REGION);
			ResultSet rs2=statement2.executeQuery();
			while (rs2.next())
			{	
				if (!V_CUST_LIST.equals("")) V_CUST_LIST =V_CUST_LIST+"<br>";
				V_CUST_LIST =V_CUST_LIST+rs2.getString(1);	
			}
			rs2.close();
			statement2.close();
			strContent = "Request Notification,<p>Please login at:<a href="+'"'+strProgram+'"'+">"+strUrl+"</a> to confirm order revise.<p>"+
						 "Include the following customer list in this request..<br>"+V_CUST_LIST;
			
			message.setHeader("Subject", MimeUtility.encodeText((ACTTYPE.equals("REMINDER")?"Reminder-":"")+"工廠已回覆申請改單通知"+remarks, "UTF-8", null));	
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			mbp.setContent(strContent, "text/html;charset=UTF-8");
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
	}
	rs1.close();
	statement1.close();	
	os.close();  
	out.close(); 
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()+sql); 
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
	else
	{
	%>
	<script language="JavaScript" type="text/JavaScript">
		window.close();		
	</script>	
	<%	
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
