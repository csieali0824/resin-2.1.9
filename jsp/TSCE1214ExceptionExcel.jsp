<!--20140724 Peggy,客戶品號或台半品號與上版不同時,在exception notice欄位提示user -->
<!--20150723 Peggy,tsce_buffernet_po_pkg.GET_PO_SSD增加sysdate參數-->
<!--20151002 Peggy,add excel format condition-->
<!--20151209 Peggy,TSC_PROD_GROUP Issue-->
<!--20151218 Peggy,已close訂單要顯示,以藍色粗體標示-->
<!--20160630 Peggy,add new field-改單申請單號-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ page import="java.text.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCE1214ExceptionExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER == null) CUSTOMER ="";
String ODRTYPE = request.getParameter("ODRTYPE");
if (ODRTYPE == null) ODRTYPE ="";
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO == null) CUSTPO ="";
String CYEARFR = request.getParameter("CYEARFR");
if (CYEARFR==null) CYEARFR="--";
String CMONTHFR = request.getParameter("CMONTHFR");
if (CMONTHFR==null) CMONTHFR="--";
String CDAYFR = request.getParameter("CDAYFR");
if (CDAYFR==null) CDAYFR="--";
String CYEARTO = request.getParameter("CYEARTO");
if (CYEARTO==null) CYEARTO="--";
String CMONTHTO = request.getParameter("CMONTHTO");
if (CMONTHTO==null) CMONTHTO="--";
String CDAYTO = request.getParameter("CDAYTO");
if (CDAYTO==null) CDAYTO="--";
String EXLFMT = request.getParameter("EXLFMT");
if (EXLFMT==null) EXLFMT="";
String ORDERS = "ORDERS",ORDCHG="ORDCHG";
String ORDERS_Sheet= "New_PO";
String ORDCHG_Sheet= "PO_Change";
String FileName="",ColumnName="",DEPTNAME="",sql="";
String array[][]=new String[1][1];
int fontsize=8,colcnt=0;
String SDATE ="";//add by Peggy 20140410
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");

try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,mergeCol=0;
	String column1="",column2="",column3="",column4="",column5="",mo_CRD="",mo_QTY="",mo_PRICE="",mo_SSD="",mo_ShippingMethod ="",exception_remarks="",mo_fob="",mo_deliver_to_id="";
	OutputStream os = null;	
	FileName = "TSCE Hub PO("+userID+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os);
	sql = " select distinct case when b.version_id > 0 then 1 else 0 end as version_id from oraddman.tsce_purchase_order_lines a,oraddman.tsce_purchase_order_headers b where a.customer_po = b.customer_po and a.version_id = b.version_id and  a.DATA_FLAG ='E'";
	if (!CUSTPO.equals(""))
	{
		sql += " and b.customer_po LIKE '"+CUSTPO+"%'";
	}
	if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
	{
		sql += " and b.CUSTOMER_NAME LIKE '" + CUSTOMER +"%'";
	}
	if (ODRTYPE.equals(ORDERS))
	{
		sql += " AND b.VERSION_ID = 0";
	}
	else if (ODRTYPE.equals(ORDCHG))
	{
		sql += " AND b.VERSION_ID > 0";
	}		
	sql += " and trunc(b.CREATION_DATE) between to_date('"+CYEARFR.replace("--","2013")+"-"+CMONTHFR.replace("--","01")+"-"+CDAYFR.replace("--","01")+"','yyyy-mm-dd')";
	if (CYEARTO.equals("--")) CYEARTO = dateBean.getYearString();
	if (CMONTHTO.equals("--")) CMONTHTO = dateBean.getMonthString();
	if (CDAYTO.equals("--"))
	{
		if (CMONTHTO.equals("01") || CMONTHTO.equals("03") || CMONTHTO.equals("05") || CMONTHTO.equals("07") || CMONTHTO.equals("08") || CMONTHTO.equals("10") || CMONTHTO.equals("12"))
		{
			CDAYTO="31";
		}
		else if (CMONTHTO.equals("04") || CMONTHTO.equals("06") || CMONTHTO.equals("09") || CMONTHTO.equals("11"))
		{
			CDAYTO="30";
		}
		else
		{
			if (Integer.parseInt(CYEARTO)%4==0)
			{
				CDAYTO="29";
			}
			else
			{
				CDAYTO="28";
			}
		}
	}
	sql += " and  to_date('"+CYEARTO+"-"+CMONTHTO+"-"+CDAYTO+"','yyyy-mm-dd') order by 1";		
	Statement statement2=con.createStatement();
	//out.println(sql);
	ResultSet rs2=statement2.executeQuery(sql);
	int sheet_cnt =0;
	while (rs2.next())
	{
		wwb.createSheet((rs2.getString("version_id").equals("0")?ORDERS_Sheet:ORDCHG_Sheet), sheet_cnt);
		sheet_cnt++;
	}
	rs2.close();
	statement2.close(); 	
	WritableSheet ws = null;
		
	//英文內文水平垂直置中-粗體-格線-底色灰-字體黑   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(true);

	//英文內文水平垂直置中-粗體-格線-底色灰-字體紅   
	WritableCellFormat ACenterBLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterBLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLR.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLR.setWrap(true);
	
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

	//英文內文水平垂直置中-粗體-格線-底色天空藍
	WritableCellFormat ACenterBLS = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLS.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLS.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLS.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLS.setBackground(jxl.write.Colour.ICE_BLUE); 
	ACenterBLS.setWrap(true);	
	
	//英文內文水平垂直置左-粗體-格線-底色天空藍
	WritableCellFormat ALeftBLS = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftBLS.setAlignment(jxl.format.Alignment.LEFT);
	ALeftBLS.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftBLS.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftBLS.setBackground(jxl.write.Colour.ICE_BLUE); 
	ALeftBLS.setWrap(true);		
	
	//英文內文水平垂直置右-粗體-格線-底色天空藍
	WritableCellFormat ARightBLS = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightBLS.setAlignment(jxl.format.Alignment.RIGHT);
	ARightBLS.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightBLS.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightBLS.setBackground(jxl.write.Colour.ICE_BLUE); 
	ARightBLS.setWrap(true);		

	//英文內文水平垂直置中-粗體-格線-底色黃
	WritableCellFormat ACenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLY.setBackground(jxl.write.Colour.YELLOW); 
	ACenterBLY.setWrap(true);	

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
	
	//英文內文水平垂直置右-正常-格線-紅字   
	WritableCellFormat ARightLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 9,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ARightLR.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLR.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線-紅字   
	WritableCellFormat ACenterLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLR.setWrap(true);
		
	//英文內文水平垂直置左-正常-格線-紅字   
	WritableCellFormat ALeftLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 8,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ALeftLR.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLR.setWrap(true);	
			
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),fontsize, WritableFont.NO_BOLD),new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
				
	//日期格式-底色天空藍
	WritableCellFormat DATE_FORMAT_B = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),fontsize, WritableFont.BOLD),new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT_B.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT_B.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT_B.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT_B.setBackground(jxl.write.Colour.ICE_BLUE); 
	DATE_FORMAT_B.setWrap(true);
					
	//日期格式
	WritableCellFormat DATE_FORMAT1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 9, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED), new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT1.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT1.setWrap(true);	
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();
		
	String sheetname [] = wwb.getSheetNames();
	//out.println(sheetname.length);
	for (int i =0 ; i < sheetname.length ; i++)
	{
		if (sheetname[i].equals(ORDCHG_Sheet))
		{
			//out.println(sheetname[i]);
			reccnt=0;
			sql = " select distinct a.customer_name"+
				  ",to_char(a.creation_date,'yyyy/mm/dd hh24:mi') creation_date"+
				  ",a.customer_po"+
				  ",a.po_line_no"+
				  ",a.cust_part_no"+
				  ",a.tsc_part_no"+
				  ",to_char(to_date(a.crd,'yyyymmdd'),'yyyy/mm/dd') cust_request_date"+
				  ",a.quantity"+
				  ",a.unit_price"+
				  ",a.currency_code"+
				  ",c.attribute3 plant_code"+
				  ",a.crd"+
				  ",a.erp_customer_id"+
				  ",d.cust_part_no orig_cust_part_no"+
				  ",d.tsc_part_no orig_tsc_part_no"+
                  ",(select count(1) from ont.oe_order_lines_all j,ont.oe_order_headers_all k where k.SOLD_TO_ORG_ID=a.erp_customer_id and j.customer_line_number=a.customer_po and j.customer_shipment_number=a.po_line_no and j.header_id=k.header_id and j.ordered_quantity>0 and j.FLOW_STATUS_CODE not in ('CANCELLED')) mo_cnt"+
                  ",(select count(1) from oraddman.tsdelivery_notice_detail j,oraddman.tsdelivery_notice k where j.dndocno = k.dndocno  and k.TSCUSTOMERID=a.erp_customer_id and j.CUST_PO_NUMBER =a.customer_po  and j.CUST_PO_LINE_NO=a.po_line_no  AND (j.ORDERNO is null or j.ORDERNO ='N/A')  and j.LSTATUSID not in ('001','010','012')) rfq_cnt"+
			  	  //" from oraddman.tsce_purchase_order_lines a,oraddman.tsce_purchase_order_headers b "+
                  ",(select listagg(z.request_no,'\r\n')  within group (order by request_no) request_no "+
				  //" from oraddman.TSC_OM_SALESORDERREVISE_REQ z"+
				  " from (select distinct request_no,customer_po_ref,customer_po_line_ref,customer_id_ref,version_id_ref,status,SOURCE_CUSTOMER_PO "+
				  "       ,TO_CHAR(NVL(REQUEST_DATE,SOURCE_REQUEST_DATE),'yyyymmdd') CRD,NVL(ITEM_DESC,SOURCE_ITEM_DESC) TSC_PART_NO"+
				  "       ,NVL(CUST_ITEM_NAME,SOURCE_CUST_ITEM_NAME) CUST_PART_NO, NVL(SO_QTY,SOURCE_SO_QTY) QUANTITY "+ //add by Peggy 20220315
				  "       from oraddman.tsc_om_salesorderrevise_req) z"+
				  " where z.CUSTOMER_PO_REF=a.CUSTOMER_PO"+
				  " and z.CUSTOMER_PO_LINE_REF=a.PO_LINE_NO "+
				  " and z.CUSTOMER_ID_REF=a.ERP_CUSTOMER_ID "+
				  " and ((z.CRD=a.CRD"+  //add by Peggy 20220315
				  " and z.TSC_PART_NO=a.TSC_PART_NO"+   //add by Peggy 20220315
				  " and z.CUST_PART_NO=a.CUST_PART_NO "+  //add by Peggy 20220315
				  " and z.QUANTITY=a.QUANTITY) "+  //add by Peggy 20220315
				  " or z.VERSION_ID_REF=a.VERSION_ID) "+ // CRD/TSC PN/CUST PN/QUANTITY四欄位比對或版次符合 add by Peggy 20220322
				  " and z.status<>'CLOSED') revise_request_no"+ //add by Peggy 20160630
				  ",c.tsc_package"+  //add by Peggy 20210317
			  	  //" from oraddman.tsce_purchase_order_lines a"+
				  //",oraddman.tsce_purchase_order_headers b"+
				  " from (select a.*,b.customer_name,b.erp_customer_id,b.creation_date,b.parent_version_id "+
				  ",nvl((select max(version_id) from oraddman.tsce_purchase_order_lines x where x.customer_po=a.customer_po and x.version_id < a.version_id and x.po_line_no=a.po_line_no and x.data_flag not in ('X','I')),0) comparison_version_id"+ //add by Peggy 20210825
				  " from oraddman.tsce_purchase_order_lines a,"+
                  " oraddman.tsce_purchase_order_headers b"+
                  " where a.customer_po = b.customer_po"+
                  " AND a.version_id = b.version_id"+
                  " AND a.version_id > 0"+
                  " AND a.data_flag = 'E') a"+
				  ",oraddman.tsce_purchase_order_lines d "+
			      ",(select b.inventory_item_id,c.ATTRIBUTE3,c.segment1,b.SOLD_TO_ORG_ID,b.item,b.item_description"+
			      "  ,NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Package'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE"+
			      "  ,NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Family'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_Family')) as TSC_FAMILY"+
			      "  ,CASE when NVL(c.attribute3, 'N/A') in ('008','002') THEN d.TSC_PROD_GROUP ELSE NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_PROD_GROUP'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_PROD_GROUP')) END as TSC_PROD_GROUP"+
			      "   from oe_items_v b"+
				  "   ,inv.mtl_system_items_b c"+
				  "   ,oraddman.tsprod_manufactory d"+  //add by Peggy 20151209
				  "    where b.CROSS_REF_STATUS='ACTIVE'"+
				  "    and c.ORGANIZATION_ID = '49'"+
				  "    and c.attribute3=d.MANUFACTORY_NO(+)"+
				  "    and b.inventory_item_id=c.inventory_item_id) c"+		  
				  //" where a.customer_po = b.customer_po"+
				  //" and a.version_Id = b.version_id"+
			      " where a.cust_part_no=c.item(+)"+
				  " and a.tsc_part_no=c.ITEM_DESCRIPTION(+)"+
				  " and a.erp_customer_id = c.SOLD_TO_ORG_ID(+)"+
				  //" and a.version_Id >0"+
				  //" and a.DATA_FLAG ='E' "+
				  //" and a.PARENT_VERSION_ID =d.VERSION_ID(+)"+
				  " AND a.comparison_version_id=d.version_id(+)"+ //add by Pegy 20210825
				  " and a.PO_LINE_NO=d.PO_LINE_NO(+)"+
				  " and a.CUSTOMER_PO=d.CUSTOMER_PO(+)";
			if (!CUSTPO.equals(""))
			{
				sql += " and a.customer_po LIKE '"+CUSTPO+"%'";
			}
			if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
			{
				sql += " and a.CUSTOMER_NAME LIKE '" + CUSTOMER +"%'";
			}
			sql += " and trunc(a.CREATION_DATE) between to_date('"+CYEARFR.replace("--","2013")+"-"+CMONTHFR.replace("--","01")+"-"+CDAYFR.replace("--","01")+"','yyyy-mm-dd')";
			if (CYEARTO.equals("--")) CYEARTO = ""+dateBean.getYear();
			if (CMONTHTO.equals("--")) CMONTHTO = ""+dateBean.getMonth();
			if (CDAYTO.equals("--"))
			{
				if (CMONTHTO.equals("01") || CMONTHTO.equals("03") || CMONTHTO.equals("05") || CMONTHTO.equals("07") || CMONTHTO.equals("08") || CMONTHTO.equals("10") || CMONTHTO.equals("12"))
				{
					CDAYTO="31";
				}
				else if (CMONTHTO.equals("04") || CMONTHTO.equals("06") || CMONTHTO.equals("09") || CMONTHTO.equals("11"))
				{
					CDAYTO="30";
				}
				else
				{
					if (Integer.parseInt(CYEARTO)%4==0)
					{
						CDAYTO="29";
					}
					else
					{
						CDAYTO="28";
					}
				}
			}
			sql += " and  to_date('"+CYEARTO+"-"+CMONTHTO+"-"+CDAYTO+"','yyyy-mm-dd')";
			sql +=" order by a.customer_name,a.customer_po,a.po_line_no";
			//out.println(sql);
			Statement state=con.createStatement();     
			ResultSet rs=state.executeQuery(sql);
			while (rs.next())	
			{ 
				if (reccnt==0)
				{
					//out.println(sql);
					//ResultSetMetaData md=rs.getMetaData();
					//colcnt =md.getColumnCount();
					col=0;row=0;
					ws = wwb.getSheet(ORDCHG_Sheet);				
					
					/*D4009*/
					if (EXLFMT.equals("D4009"))
					{
						//交易類型
						ws.addCell(new jxl.write.Label(col, row, "Data Type" , ACenterBLB));
						ws.setColumnView(col,15);
						col++;	
			
						//客戶
						ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLB));
						ws.setColumnView(col,25);	
						col++;	
	
						//建立日期
						ws.addCell(new jxl.write.Label(col, row, "Creation Date" , ACenterBLB));
						ws.setColumnView(col,20);	
						col++;	
			
						//客戶訂單
						ws.addCell(new jxl.write.Label(col, row, "Customer PO" , ACenterBLB));
						ws.setColumnView(col,20);	
						col++;	
			
						//客戶訂單項次
						ws.addCell(new jxl.write.Label(col, row, "PO Line No" , ACenterBLB));
						ws.setColumnView(col,15);	
						col++;	
			
						//MO
						ws.addCell(new jxl.write.Label(col, row, "MO" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;	
			
						//Line
						ws.addCell(new jxl.write.Label(col, row, "Line" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;	
			
						//Item
						ws.addCell(new jxl.write.Label(col, row, "Item" , ACenterBL));
						ws.setColumnView(col,20);	
						col++;
			
						//Customer
						ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
						ws.setColumnView(col,45);	
						col++;
			
						//PO No
						ws.addCell(new jxl.write.Label(col, row, "PO No" , ACenterBL));
						ws.setColumnView(col,20);	
						col++;
						
						//Qty
						ws.addCell(new jxl.write.Label(col, row, "Qty" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
						
						//Price
						ws.addCell(new jxl.write.Label(col, row, "Price" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
							
						//SSD,(Initial SSD)
						ws.addCell(new jxl.write.Label(col, row, "SSD (Initial SSD)" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
							
						//New SSD ,(Request pull in to)
						ws.addCell(new jxl.write.Label(col, row, "New SSD (Request pull in to)" , ACenterBLR));
						ws.setColumnView(col,15);	
						col++;
			
						//Shipping Method
						ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
			
						//Remarks
						ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
			
						//CRD
						ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBLO));
						ws.setColumnView(col,15);	
						col++;
							
						//New CRD
						ws.addCell(new jxl.write.Label(col, row, "New CRD" , ACenterBLO));
						ws.setColumnView(col,15);	
						col++;
							
						//New Qty
						ws.addCell(new jxl.write.Label(col, row, "New Qty" , ACenterBLO));
						ws.setColumnView(col,15);	
						col++;
							
						//New Price
						ws.addCell(new jxl.write.Label(col, row, "New Price" , ACenterBLO));
						ws.setColumnView(col,15);	
						col++;
																														
						//Exception remark,add by Peggy 20140724
						ws.addCell(new jxl.write.Label(col, row, "Exception Notice" , ACenterBLY));
						ws.setColumnView(col,45);	
						col++;
						
						//TSC PACKAGE,add by Peggy 20210317
						ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
						ws.setColumnView(col,15);	
						col++;						
					}
					else
					{
						//交易類型
						ws.addCell(new jxl.write.Label(col, row, "Data Type" , ACenterBLB));
						ws.setColumnView(col,15);
						col++;	
			
						//Customer
						ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLB));
						ws.setColumnView(col,30);	
						col++;
			
						//建立日期
						ws.addCell(new jxl.write.Label(col, row, "Creation Date" , ACenterBLB));
						ws.setColumnView(col,20);	
						col++;	
			
						//客戶訂單
						ws.addCell(new jxl.write.Label(col, row, "Customer PO" , ACenterBLB));
						ws.setColumnView(col,20);	
						col++;	
			
						//客戶訂單項次
						ws.addCell(new jxl.write.Label(col, row, "PO Line No" , ACenterBLB));
						ws.setColumnView(col,15);	
						col++;	
			
						//MO
						ws.addCell(new jxl.write.Label(col, row, "MO" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;	
			
						//Line
						ws.addCell(new jxl.write.Label(col, row, "Line" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;	
			
						//Item
						ws.addCell(new jxl.write.Label(col, row, "Item" , ACenterBL));
						ws.setColumnView(col,20);	
						col++;
			
						//客戶
						ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
						ws.setColumnView(col,25);	
						col++;	
	
						//PO No
						ws.addCell(new jxl.write.Label(col, row, "PO No" , ACenterBL));
						ws.setColumnView(col,20);	
						col++;
							
						//Qty
						ws.addCell(new jxl.write.Label(col, row, "Qty" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;

						//SSD,(Initial SSD)
						ws.addCell(new jxl.write.Label(col, row, "SSD (Initial SSD)" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
																		
						//Order Type
						ws.addCell(new jxl.write.Label(col, row, "Order Type" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
					
						//Customer Number
						ws.addCell(new jxl.write.Label(col, row, "Customer Number" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
	
						//Customer
						ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
						ws.setColumnView(col,30);	
						col++;
			
						//Ship to Org ID
						ws.addCell(new jxl.write.Label(col, row, "Ship to Org ID" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
						
						//Bill to Org ID
						ws.addCell(new jxl.write.Label(col, row, "Bill to Org ID" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
																		
						//Deliver to Org ID
						ws.addCell(new jxl.write.Label(col, row, "Deliver to Org ID" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
						
						//TSC Item(22碼)
						ws.addCell(new jxl.write.Label(col, row, "TSC Item(22碼)" , ACenterBL));
						ws.setColumnView(col,20);	
						col++;					
	
						//Customer P/N
						ws.addCell(new jxl.write.Label(col, row, "Customer P/N" , ACenterBL));
						ws.setColumnView(col,20);	
						col++;					
	
						//Customer PO
						ws.addCell(new jxl.write.Label(col, row, "Customer PO" , ACenterBL));
						ws.setColumnView(col,20);	
						col++;	
						
						//Shipping Method
						ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
								
						//New Qty
						ws.addCell(new jxl.write.Label(col, row, "New Qty" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
	
						//New SSD ,(Request pull in to)
						ws.addCell(new jxl.write.Label(col, row, "New SSD (Request pull in to)" , ACenterBLR));
						ws.setColumnView(col,15);	
						col++;
			
						//New CRD
						ws.addCell(new jxl.write.Label(col, row, "New CRD" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
	
						//New TSC P/N
						ws.addCell(new jxl.write.Label(col, row, "New TSC P/N" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
						
						//New CPN
						ws.addCell(new jxl.write.Label(col, row, "New CPN" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;	
						
						//New FOB
						ws.addCell(new jxl.write.Label(col, row, "New FOB" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;						
	
						//Remarks
						ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
							
						//Change Reason
						ws.addCell(new jxl.write.Label(col, row, "Change Reason" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
						
						//Change Comments
						ws.addCell(new jxl.write.Label(col, row, "Change Comments" , ACenterBL));
						ws.setColumnView(col,15);	
						col++;
							
						//CRD
						ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBLO));
						ws.setColumnView(col,15);	
						col++;
						
						//CUST P/N
						ws.addCell(new jxl.write.Label(col, row, "Orig Cust P/N" , ACenterBLO));
						ws.setColumnView(col,20);	
						col++;						
						
						//Price
						ws.addCell(new jxl.write.Label(col, row, "Price" , ACenterBLO));
						ws.setColumnView(col,15);	
						col++;
							
						//New Price
						ws.addCell(new jxl.write.Label(col, row, "New Price" , ACenterBLO));
						ws.setColumnView(col,15);	
						col++;
									
						//push out frequency,add by Peggy 20230526
						ws.addCell(new jxl.write.Label(col, row, "Push out frequency" , ACenterBLY));
						ws.setColumnView(col,10);	
						col++;			
			
						//cancellation frequency,add by Peggy 20230526
						ws.addCell(new jxl.write.Label(col, row, "Cancellation frequency" , ACenterBLY));
						ws.setColumnView(col,10);	
						col++;
																																	
						//Exception remark,add by Peggy 20140724
						ws.addCell(new jxl.write.Label(col, row, "Exception Notice" , ACenterBLY));
						ws.setColumnView(col,45);	
						col++;

						//revise no,add by Peggy 20160630
						ws.addCell(new jxl.write.Label(col, row, "Revise No" , ACenterBLY));
						ws.setColumnView(col,15);	
						col++;
						
						//TSC PACKAGE,add by Peggy 20210317
						ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
						ws.setColumnView(col,15);	
						col++;							
					}
					row++;
				}
				
				col =0;
				merge_line=rs.getInt("MO_CNT")+rs.getInt("RFQ_CNT")-1;
				if (merge_line<0) merge_line=0;
				
				ws.mergeCells(col, row, col, row+merge_line);   
				ws.addCell(new jxl.write.Label(col, row, " Order Change", ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+merge_line);   
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME") ,  ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+merge_line);   
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATION_DATE") , ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+merge_line);   
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_PO") ,  ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+merge_line);   
				ws.addCell(new jxl.write.Label(col, row, rs.getString("PO_LINE_NO") , ACenterL));
				if (EXLFMT.equals("D4009"))
				{				
					col+=17;	
				}
				else
				{
					col+=35;	
				}
				ws.mergeCells(col, row, col, row+merge_line);   
				if (rs.getString("TSC_PACKAGE")!=null && (rs.getString("TSC_PACKAGE").equals("Matrix SMB") || rs.getString("TSC_PACKAGE").equals("Matrix SMC") || rs.getString("TSC_PACKAGE").equals("SOD-123W") || rs.getString("TSC_PACKAGE").equals("Micro SMA")))
				{
					ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE") , ACenterLR));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE") , ACenterL));
				}
					
				sql = " select '1',to_char(b.order_number) requestno,TO_NUMBER(line_number||'.'||a.shipment_number) line_no,c.description item_description,d.customer_name customer,a.customer_line_number customer_po,a.ordered_quantity,a.UNIT_SELLING_PRICE SELLING_PRICE,to_char( a.SCHEDULE_SHIP_DATE,'yyyy/mm/dd')  SCHEDULE_SHIP_DATE ,a.shipping_method_code, to_char(a.REQUEST_DATE,'yyyy/mm/dd') REQUEST_DATE,a.FLOW_STATUS_CODE status"+
					  ",a.fob_point_code fob"+   //add by Peggy 20210308
					  ",a.DELIVER_TO_ORG_ID deliver_to_id"+   //add by Peggy 20210308
					  ",case when a.item_identifier_type='CUST'	then a.ordered_item else '' end as cust_partno"+ //add by Peggy 20211130
                      ",so_m.PUST_OUT_FREQUENCY,so_m.CANCELLATION_FREQUENCY	"+	 //add by Peggy 20230526 			  
					  " from ont.oe_order_lines_all a,ont.oe_order_headers_all b ,inv.mtl_system_items_b c,ar_customers d,TABLE(TSC_GET_SO_MOVE_FREQUENCY(a.line_id)) so_m"+
					  " where b.SOLD_TO_ORG_ID='"+rs.getString("erp_customer_id")+"'"+
					  " and a.customer_line_number='"+rs.getString("CUSTOMER_PO")+"'"+
					  " and a.customer_shipment_number='"+rs.getString("PO_LINE_NO")+"'"+
					  " and a.header_id=b.header_id"+
					  " and a.ordered_quantity>0"+
					  " and a.FLOW_STATUS_CODE not in ('CANCELLED')"+
					  " and a.inventory_item_id=c.inventory_item_id"+
					  " and b.ship_from_org_id=c.organization_id"+
					  " and b.sold_to_org_id=d.customer_id"+
					  " union all"+
					  " select '2',a.dndocno requestno,to_NUMBER(a.line_no) line_no,a.ITEM_DESCRIPTION,b.customer,a.CUST_PO_NUMBER customer_po ,a.quantity*1000 ordered_quantity,a.SELLING_PRICE,substr(a.REQUEST_DATE,1,8) SCHEDULE_SHIP_DATE,a.shipping_method,a.CUST_REQUEST_DATE REQUEST_DATE,a.LSTATUS STATUS"+
					  ",a.FOB"+   //add by Peggy 20210308
					  ",b.DELIVERY_TO_ORG deliver_to_id"+   //add by Peggy 20210308
					  ",replace(a.ORDERED_ITEM,'N/A','') cust_partno"+ //add by Peggy 20211130					  
					  ",null PUST_OUT_FREQUENCY,null CANCELLATION_FREQUENCY	"+   //add by Peggy 20230526 
					  " from oraddman.tsdelivery_notice_detail a,oraddman.tsdelivery_notice b"+
					  " where a.dndocno = b.dndocno"+
					  " and b.TSCUSTOMERID='"+rs.getString("erp_customer_id")+"'"+
					  " and a.CUST_PO_NUMBER ='"+rs.getString("CUSTOMER_PO")+"'"+
					  " and a.CUST_PO_LINE_NO='"+rs.getString("PO_LINE_NO")+"'"+
					  " AND (ORDERNO is null or ORDERNO ='N/A')"+
					  " and a.LSTATUSID not in ('001','010','012')"+
					  " order by 1,3,4";
				//out.println(sql);
				Statement state1=con.createStatement();     
				ResultSet rs1=state1.executeQuery(sql);
				reccnt=0;
				while (rs1.next())	
				{ 
					mo_ShippingMethod = rs1.getString("SHIPPING_METHOD_CODE");
					mo_CRD = rs1.getString("REQUEST_DATE");     
					mo_QTY = rs1.getString("ORDERED_QUANTITY");	 
					mo_PRICE = rs1.getString("SELLING_PRICE");   
					mo_SSD = rs1.getString("SCHEDULE_SHIP_DATE"); 
					mo_fob = rs1.getString("fob");
					mo_deliver_to_id  = rs1.getString("deliver_to_id");
					if (mo_deliver_to_id==null) mo_deliver_to_id="";

					col=5;
					/*D4009*/
					if (EXLFMT.equals("D4009"))
					{					
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("requestno") , (rs1.getString("status").toUpperCase().equals("CLOSED")?ACenterBLS:ACenterL)));
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("line_no") , (rs1.getString("status").toUpperCase().equals("CLOSED")?ACenterBLS:ACenterL)));
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("ITEM_DESCRIPTION") , (rs1.getString("status").toUpperCase().equals("CLOSED")?ALeftBLS: ALeftL)));
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("customer") , (rs1.getString("status").toUpperCase().equals("CLOSED")?ALeftBLS: ALeftL)));
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("customer_po") , (rs1.getString("status").toUpperCase().equals("CLOSED")?ALeftBLS: ALeftL)));
						col++;	
						//ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("ORDERED_QUANTITY") , ARightL));
						ws.addCell(new jxl.write.Number(col, row+reccnt, Double.valueOf(rs1.getString("ORDERED_QUANTITY")).doubleValue() ,  (rs1.getString("status").toUpperCase().equals("CLOSED")?ARightBLS: ARightL)));
						col++;	
						//ws.addCell(new jxl.write.Label(col, row+reccnt, (new DecimalFormat("####0.#####")).format(Float.parseFloat(rs1.getString("SELLING_PRICE"))) , ARightL));
						ws.addCell(new jxl.write.Number(col, row+reccnt, Double.valueOf(rs1.getString("SELLING_PRICE")).doubleValue() ,  (rs1.getString("status").toUpperCase().equals("CLOSED")?ARightBLS: ARightL)));
						col++;	
						SDATE = rs1.getString("SCHEDULE_SHIP_DATE"); //modify by Peggy 20140410
						if (SDATE !=null && !SDATE.equals("")) SDATE = (SDATE.replace("/","")).substring(0,4)+"/"+Integer.parseInt((SDATE.replace("/","")).substring(4,6))+"/"+Integer.parseInt((SDATE.replace("/","")).substring(6,8));  
						//ws.addCell(new jxl.write.Label(col, row, rs1.getString("SCHEDULE_SHIP_DATE") , ACenterL));
						//ws.addCell(new jxl.write.Label(col, row+reccnt, SDATE , ACenterL));
						ws.addCell(new jxl.write.DateTime(col, row+reccnt,  formatter.parse(SDATE) ,  (rs1.getString("status").toUpperCase().equals("CLOSED")?DATE_FORMAT_B:DATE_FORMAT)));
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ACenterL));
						col++;							
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("SHIPPING_METHOD_CODE") , ACenterL));
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ACenterL));
						col++;	
						SDATE = rs1.getString("REQUEST_DATE"); //modify by Peggy 20140410
						if (SDATE !=null && !SDATE.equals("")) SDATE = (SDATE.replace("/","")).substring(0,4)+"/"+Integer.parseInt((SDATE.replace("/","")).substring(4,6))+"/"+Integer.parseInt((SDATE.replace("/","")).substring(6,8));  
						//ws.addCell(new jxl.write.Label(col, row, rs1.getString("REQUEST_DATE") , ACenterL));
						//ws.addCell(new jxl.write.Label(col, row+reccnt, SDATE , ACenterL));
						ws.addCell(new jxl.write.DateTime(col, row+reccnt,  formatter.parse(SDATE) , DATE_FORMAT));
						col++;
					}
					else
					{
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("requestno") , (rs1.getString("status").toUpperCase().equals("CLOSED")?ACenterBLS:ACenterL)));
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("line_no") , (rs1.getString("status").toUpperCase().equals("CLOSED")?ACenterBLS:ACenterL)));
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("ITEM_DESCRIPTION") , (rs1.getString("status").toUpperCase().equals("CLOSED")?ALeftBLS: ALeftL)));
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("customer") , (rs1.getString("status").toUpperCase().equals("CLOSED")?ALeftBLS: ALeftL)));
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("customer_po") , (rs1.getString("status").toUpperCase().equals("CLOSED")?ALeftBLS: ALeftL)));
						col++;	
						ws.addCell(new jxl.write.Number(col, row+reccnt, Double.valueOf(rs1.getString("ORDERED_QUANTITY")).doubleValue() ,  (rs1.getString("status").toUpperCase().equals("CLOSED")?ARightBLS: ARightL))); //28.QTY
						col++;	
						SDATE = rs1.getString("SCHEDULE_SHIP_DATE"); //modify by Peggy 20140410
						if (SDATE !=null && !SDATE.equals("")) SDATE = (SDATE.replace("/","")).substring(0,4)+"/"+Integer.parseInt((SDATE.replace("/","")).substring(4,6))+"/"+Integer.parseInt((SDATE.replace("/","")).substring(6,8));  
						ws.addCell(new jxl.write.DateTime(col, row+reccnt,  formatter.parse(SDATE) , (rs1.getString("status").toUpperCase().equals("CLOSED")?DATE_FORMAT_B:DATE_FORMAT))); //26.initial SSD
						col++;		
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //9.order type
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //10.customer number
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //11.customer
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //12.Ship to Org ID
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //13.Bill to Org ID
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //14.Deliver to Org ID
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //15.TSC Item(22碼)
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //16.Customer P/N
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //17.New Customer PO
						col++;																																																					
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("SHIPPING_METHOD_CODE") , ACenterL));  //18.New Shipping Method
						col++;																																																					
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //19.New Qty
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //20.New SSD
						col++;																																																											
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //21.New CRD
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //22.New TSC P/N
						col++;
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //23.New CUST P/N
						col++;																																																																						
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //24.New FOB
						col++;		
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //25.REMARKS
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //26.Change Reason
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //27.Change Comments
						col++;	
						SDATE = rs1.getString("REQUEST_DATE"); 
						if (SDATE !=null && !SDATE.equals("")) SDATE = (SDATE.replace("/","")).substring(0,4)+"/"+Integer.parseInt((SDATE.replace("/","")).substring(4,6))+"/"+Integer.parseInt((SDATE.replace("/","")).substring(6,8));  
						ws.addCell(new jxl.write.DateTime(col, row+reccnt,  formatter.parse(SDATE) , DATE_FORMAT));  //28.CRD
						col++;
						ws.addCell(new jxl.write.Label(col, row+reccnt, rs1.getString("cust_partno") , ALeftL));  //29,cust p/n add by Peggy 20211130
						col++;																																																																																												
						ws.addCell(new jxl.write.Number(col, row+reccnt, Double.valueOf(rs1.getString("SELLING_PRICE")).doubleValue() , ARightL));  //30.Price
						col++;																																																																																												
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //31.NEW price
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, (rs1.getString("PUST_OUT_FREQUENCY")==null?"":rs1.getString("PUST_OUT_FREQUENCY")) , ALeftL));  //32.Cancellation frequency
						col++;																																																																																																								
						ws.addCell(new jxl.write.Label(col, row+reccnt, (rs1.getString("CANCELLATION_FREQUENCY")==null?"":rs1.getString("CANCELLATION_FREQUENCY"))  , ALeftL));  //33.Exception Notice
						col++;	
						ws.addCell(new jxl.write.Label(col, row+reccnt, "" , ALeftL));  //34.Exception Notice
						col++;	
					}
					reccnt++;
				}
				rs1.close();
				state1.close();
				
				if (reccnt==0)
				{
					for (col =5 ; col <=(EXLFMT.equals("D4009")?16:35) ; col++)
					{
						ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
					}
				}
				Statement state3=con.createStatement();     
				//ResultSet rs3=state3.executeQuery("SELECT to_char(to_date(tsce_buffernet_po_pkg.GET_PO_SSD('"+rs.getString("crd")+"','"+mo_ShippingMethod+"','"+rs.getString("plant_code")+"',sysdate,'"+rs.getString("erp_customer_id")+"'),'yyyymmdd'),'yyyy/mm/dd') from dual"); //新增sysdate參數,modify by Peggy 20150723
				ResultSet rs3=state3.executeQuery("SELECT to_char(to_date(tsce_buffernet_po_pkg.GET_PO_SSD('"+rs.getString("crd")+"','"+mo_ShippingMethod+"','"+rs.getString("plant_code")+"',sysdate,'"+rs.getString("erp_customer_id")+"','"+mo_fob+"','"+mo_deliver_to_id+"'),'yyyymmdd'),'yyyy/mm/dd') from dual"); //新增sysdate參數,modify by Peggy 20150723
				if (rs3.next())	
				{ 
					SDATE = rs3.getString(1); //modify by Peggy 20140410
					if (SDATE !=null && !SDATE.equals("")) SDATE = (SDATE.replace("/","")).substring(0,4)+"/"+Integer.parseInt((SDATE.replace("/","")).substring(4,6))+"/"+Integer.parseInt((SDATE.replace("/","")).substring(6,8));  
					/*D4009*/
					if (EXLFMT.equals("D4009"))
					{
						ws.mergeCells(13, row, 13, row+merge_line);   
						if (SDATE==null)
						{
							ws.addCell(new jxl.write.Label(13, row, SDATE , ACenterL));
						}
						else
						{
							ws.addCell(new jxl.write.DateTime(13, row, formatter.parse(SDATE) , DATE_FORMAT));
						}
					}
					else
					{
						ws.mergeCells(23, row, 23, row+merge_line);   
						if (SDATE==null)
						{
							ws.addCell(new jxl.write.Label(23, row, SDATE , ACenterL));
						}
						else
						{
							ws.addCell(new jxl.write.DateTime(23, row, formatter.parse(SDATE) , DATE_FORMAT));
						}
					}
				}
				rs3.close();
				state3.close();
		
				SDATE = rs.getString("cust_request_date"); //modify by Peggy 20140410
				if (SDATE !=null && !SDATE.equals("")) SDATE = (SDATE.replace("/","")).substring(0,4)+"/"+Integer.parseInt((SDATE.replace("/","")).substring(4,6))+"/"+Integer.parseInt((SDATE.replace("/","")).substring(6,8));  
				/*D4009*/
				if (EXLFMT.equals("D4009"))
				{
					ws.mergeCells(col, row, col, row+merge_line);   
					ws.addCell(new jxl.write.DateTime(col, row,  formatter.parse(SDATE) , ((!mo_CRD.equals(rs.getString("cust_request_date")))?DATE_FORMAT1:DATE_FORMAT)));
					col++;	
					ws.mergeCells(col, row, col, row+merge_line);   
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("quantity")).doubleValue() , ((chg_cnt<mo_cnt || !mo_QTY.equals(rs.getString("quantity")))?ARightLR:ARightL)));
					col++;	
					ws.mergeCells(col, row, col, row+merge_line);   
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("unit_price")).doubleValue() ,(!mo_PRICE.equals(rs.getString("unit_price"))?ARightLR:ARightL)));
					col++;
					exception_remarks="";
					if (!rs.getString("cust_part_no").equals(rs.getString("orig_cust_part_no")) && rs.getString("orig_cust_part_no")!=null)
					{
						if (exception_remarks.length()>0) exception_remarks+="\r\n";
						exception_remarks+="客戶品號:"+rs.getString("cust_part_no")+"與上一版"+rs.getString("orig_cust_part_no")+"不符";
					}
					if (!rs.getString("tsc_part_no").equals(rs.getString("orig_tsc_part_no")) && rs.getString("orig_tsc_part_no")!=null)
					{
						if (exception_remarks.length()>0) exception_remarks+="\r\n";
						exception_remarks+="台半品號:"+rs.getString("tsc_part_no")+"與上一版"+rs.getString("orig_tsc_part_no")+"不符";
					}
					ws.mergeCells(col, row, col, row+merge_line);   
					ws.addCell(new jxl.write.Label(col, row, (exception_remarks.length() >0?"注意!!\r\n"+exception_remarks:""),ALeftLR));
					col++;
			
				}
				else
				{
					ws.mergeCells(22, row, 22, row+merge_line);   
					ws.addCell(new jxl.write.Number(22, row, Double.valueOf(rs.getString("quantity")).doubleValue() , ((chg_cnt<mo_cnt || !mo_QTY.equals(rs.getString("quantity")))?ARightLR:ARightL)));
					ws.mergeCells(24, row, 24, row+merge_line);   
					ws.addCell(new jxl.write.DateTime(24, row,  formatter.parse(SDATE) , ((!mo_CRD.equals(rs.getString("cust_request_date")))?DATE_FORMAT1:DATE_FORMAT)));
					ws.mergeCells(25, row, 25, row+merge_line);   
					ws.addCell(new jxl.write.Label(25, row, (!rs.getString("tsc_part_no").equals(rs.getString("orig_tsc_part_no")) && rs.getString("orig_tsc_part_no")!=null?rs.getString("tsc_part_no"):"") , (!rs.getString("tsc_part_no").equals(rs.getString("orig_tsc_part_no")) && rs.getString("orig_tsc_part_no")!=null?ALeftLR:ALeftL)));	    //add by Peggy 20230526
					ws.mergeCells(26, row, 26, row+merge_line);   
					ws.addCell(new jxl.write.Label(26, row, (!rs.getString("cust_part_no").equals(rs.getString("orig_cust_part_no")) && rs.getString("orig_cust_part_no")!=null?rs.getString("cust_part_no"):"") , (!rs.getString("cust_part_no").equals(rs.getString("orig_cust_part_no")) && rs.getString("orig_cust_part_no")!=null?ALeftLR:ALeftL)));	    //add by Peggy 20230526
					ws.mergeCells(34, row, 34, row+merge_line);   
					ws.addCell(new jxl.write.Number(34, row, Double.valueOf(rs.getString("unit_price")).doubleValue() ,(!mo_PRICE.equals(rs.getString("unit_price"))?ARightLR:ARightL)));
					exception_remarks="";
					if (!rs.getString("cust_part_no").equals(rs.getString("orig_cust_part_no")) && rs.getString("orig_cust_part_no")!=null)
					{
						if (exception_remarks.length()>0) exception_remarks+="\r\n";
						exception_remarks+="客戶品號:"+rs.getString("cust_part_no")+"與上一版"+rs.getString("orig_cust_part_no")+"不符";
					}
					if (!rs.getString("tsc_part_no").equals(rs.getString("orig_tsc_part_no")) && rs.getString("orig_tsc_part_no")!=null)
					{
						if (exception_remarks.length()>0) exception_remarks+="\r\n";
						exception_remarks+="台半品號:"+rs.getString("tsc_part_no")+"與上一版"+rs.getString("orig_tsc_part_no")+"不符";
					}
					ws.mergeCells(37, row,37, row+merge_line);   
					ws.addCell(new jxl.write.Label(37, row, (exception_remarks.length() >0?"注意!!\r\n"+exception_remarks:""),ALeftLR));
					ws.mergeCells(38, row,38, row+merge_line);   
					ws.addCell(new jxl.write.Label(38, row, rs.getString("REVISE_REQUEST_NO"),ACenterLR));  //add by Peggy 20160630
				}
				row+=merge_line;
				row++;
				reccnt++;
			}
			rs.close();
			state.close();
		}
		else if (sheetname[i].equals(ORDERS_Sheet))
		{
			sql = " select a.*,b.customer_name,to_char(b.creation_date,'yyyy/mm/dd hh24:mi') creation_date from oraddman.tsce_purchase_order_lines a,oraddman.tsce_purchase_order_headers b"+
			      " where a.data_flag='E'"+
				  " AND a.version_id=0"+
				  " and a.customer_po = b.customer_po"+
				  " and a.version_id = b.version_id";
				  
			if (!CUSTPO.equals(""))
			{
				sql += " and a.customer_po like '"+CUSTPO+"%'";
			}
			if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
			{
				sql += " and b.customer_name like '" + CUSTOMER +"%'";
			}
			sql += " and trunc(b.CREATION_DATE) between to_date('"+CYEARFR.replace("--","2013")+"-"+CMONTHFR.replace("--","01")+"-"+CDAYFR.replace("--","01")+"','yyyy-mm-dd')";
			if (CYEARTO.equals("--")) CYEARTO = ""+dateBean.getYear();
			if (CMONTHTO.equals("--")) CMONTHTO = ""+dateBean.getMonth();
			if (CDAYTO.equals("--"))
			{
				if (CMONTHTO.equals("01") || CMONTHTO.equals("03") || CMONTHTO.equals("05") || CMONTHTO.equals("07") || CMONTHTO.equals("08") || CMONTHTO.equals("10") || CMONTHTO.equals("12"))
				{
					CDAYTO="31";
				}
				else if (CMONTHTO.equals("04") || CMONTHTO.equals("06") || CMONTHTO.equals("09") || CMONTHTO.equals("11"))
				{
					CDAYTO="30";
				}
				else
				{
					if (Integer.parseInt(CYEARTO)%4==0)
					{
						CDAYTO="29";
					}
					else
					{
						CDAYTO="28";
					}
				}
			}
			sql += " and  to_date('"+CYEARTO+"-"+CMONTHTO+"-"+CDAYTO+"','yyyy-mm-dd')";
			sql +=" order by b.customer_name,a.customer_po,a.po_line_no";
		
			//out.println(sql);
			Statement state=con.createStatement();     
			ResultSet rs=state.executeQuery(sql);
			reccnt=0;
			while (rs.next())	
			{ 
				if (reccnt==0)
				{
					col=0;row=0;
					ws = wwb.getSheet(sheetname[i]);		
					
					//交易類型
					ws.addCell(new jxl.write.Label(col, row, "Data Type" , ACenterBLB));
					ws.setColumnView(col,15);
					col++;	
		
					//客戶
					ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLB));
					ws.setColumnView(col,25);	
					col++;	
		
					//建立日期
					ws.addCell(new jxl.write.Label(col, row, "Creation Date" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	

					//客戶訂單
					ws.addCell(new jxl.write.Label(col, row, "Customer PO" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
		
					//客戶訂單項次
					ws.addCell(new jxl.write.Label(col, row, "PO Line No" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
	
					//CUST P/N
					ws.addCell(new jxl.write.Label(col, row, "Cust P/N" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
	
					//TSC P/N
					ws.addCell(new jxl.write.Label(col, row, "TSC P/N" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
		
					//QTY
					ws.addCell(new jxl.write.Label(col, row, "QTY" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;
	
					//UOM
					ws.addCell(new jxl.write.Label(col, row, "UOM" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;
						
					//UNIT PRICE
					ws.addCell(new jxl.write.Label(col, row, "UNIT PRICE" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;
						
					//currency
					ws.addCell(new jxl.write.Label(col, row, "CURRENCY" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;

					//CRD
					ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;
						
					//New Price
					ws.addCell(new jxl.write.Label(col, row, "Exception Comment" , ACenterBLY));
					ws.setColumnView(col,50);	
					col++;
				
					row++;
				}
				col=0;
				ws.addCell(new jxl.write.Label(col, row, "New Order" , ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME") , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATION_DATE") , ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_PO") , ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("PO_LINE_NO") , ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("cust_part_no") , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_part_no") , ALeftL));
				col++;	
				//ws.addCell(new jxl.write.Label(col, row, rs.getString("quantity") , ARightL));
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("quantity")).doubleValue() , ARightL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("uom") , ACenterL));
				col++;	
				//ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("unit_price"))) , ARightL));
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("unit_price")).doubleValue() , ARightL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CURRENCY_CODE") , ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("crd") , ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("EXCEPTION_DESC") , ALeftL));
				col++;	
				row++;
				
				reccnt ++;
			}	
			
			
			rs.close();
			state.close();
		}
	}
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 


	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();			 
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
	response.reset();
	response.setContentType("application/vnd.ms-excel");	
	String strURL = "/oradds/report/"+FileName+".xls"; 
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
