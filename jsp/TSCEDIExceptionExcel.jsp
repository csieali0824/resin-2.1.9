<!--20151002 Peggy,add excel format condition-->
<!--20151209 Peggy,TSC_PROD_GROUP Issue-->
<!--20160630 Peggy,add new field-改單申請單號-->
<!--20190307 Peggy,add end csutomer partno-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*,java.text.DecimalFormat" %>
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
<FORM ACTION="../jsp/TSCEDIExceptionExcel.jsp" METHOD="post" name="MYFORM">
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
String FileName="",RPTName="",ColumnName="",DEPTNAME="",sql="";
String array[][]=new String[1][1];
int fontsize=9,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,line=0,mergeCol=0;
	String column1="",column2="",column3="",column4="",column5="",mo_CRD="",mo_QTY="",mo_PRICE="",mo_SSD="",v_deliverto="",v_billto="",v_shipto="";;
	OutputStream os = null;	
	if (ODRTYPE.equals("ORDCHG"))
	{
		RPTName = "EDI_ORDCHG_RPT";
	}
	else
	{
		RPTName = "EDI_ORDERS_RPT";
	}
	FileName = RPTName+"("+userID+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	
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
	
	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 8,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL1.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL1.setWrap(true);	
	
	//英文內文水平垂直置右-正常-格線-紅字   
	WritableCellFormat ARightLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 11,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ARightLR.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLR.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線-紅字   
	WritableCellFormat ACenterLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 11, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLR.setWrap(true);
		
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),fontsize, WritableFont.NO_BOLD),new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
	
	//日期格式
	WritableCellFormat DATE_FORMAT1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 11, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED), new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT1.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT1.setWrap(true);	
		
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();
		
	if (ODRTYPE.equals("ORDCHG"))
	{
		sql = " select decode(a.order_type1,'ORDCHG','ORDER CHANGE',a.order_type1) TRANS_TYPE"+
		      ",a.erp_customer_id"+
			  ",c.customer_name"+
			  ",a.request_no"+
			  ",'AWAITING_CONFIRM' STATUS"+
			  ",to_char(a.creation_date,'yyyy/mm/dd') creation_date"+
			  ",c.sales_contact"+
			  ",a.customer_po"+
			  ",a.cust_po_line_no"+
			  ",a.cust_item_name"+
			  ",a.tsc_item_name"+
			  ",to_char(to_date(a.cust_request_date,'yyyy/mm/dd'),'yyyy/mm/dd') cust_request_date"+
			  //",to_date(a.cust_request_date,'yyyy/mm/dd') cust_request_date"+
			  ",decode(a.action_code,2,0, a.quantity) quantity"+
			  ",a.unit_price"+
			  ",c.sales_area_no"+
			  ",d.attribute3 plantcode"+
			  ",d.order_type"+
			  ",(select count(1) from tsc_edi_orders_his_d x where x.request_no=a.request_no and x.erp_customer_id=a.erp_customer_id and x.data_flag='N' and x.cust_po_line_no=a.cust_po_line_no) ordchg_cnt"+
			  //",(select count(1) from ont.oe_order_lines_all j,ont.oe_order_headers_all k where k.SOLD_TO_ORG_ID=a.erp_customer_id and j.customer_line_number=a.customer_po and nvl(j.customer_shipment_number,case when a.erp_customer_id=7147 then 1 else null end)=a.cust_po_line_no and j.header_id=k.header_id and j.ordered_quantity>0 and j.FLOW_STATUS_CODE not in ('CANCELLED')) mo_cnt"+
			  ",(select count(1) from ont.oe_order_lines_all j,ont.oe_order_headers_all k where k.SOLD_TO_ORG_ID=a.erp_customer_id1 and j.customer_line_number=a.customer_po and nvl(j.customer_shipment_number,case when a.erp_customer_id=7147 then 1 else null end)=a.cust_po_line_no and j.header_id=k.header_id and j.ordered_quantity>0 and j.FLOW_STATUS_CODE not in ('CANCELLED')) mo_cnt"+ //modify by Peggy 20201029
			  ",(select count(1) from oraddman.tsdelivery_notice_detail j,oraddman.tsdelivery_notice k where j.dndocno = k.dndocno  and k.TSCUSTOMERID=a.erp_customer_id and j.CUST_PO_NUMBER =a.customer_po  and j.CUST_PO_LINE_NO=a.cust_po_line_no  AND (j.ORDERNO is null or j.ORDERNO ='N/A')  and j.LSTATUSID not in ('001','010','012')) rfq_cnt"+
			  //" from tsc_edi_orders_his_h a,tsc_edi_orders_his_d b ,tsc_edi_customer c"+
			  ",a.QUOTE_NUMBER"+ //add by Peggy 20140423
			  ",a.REVISE_REQUEST_NO"+ //add by Peggy 20160630
			  ",a.ORDCHG_WARNNING || case when a.erp_customer_id1<>a.erp_customer_id then '客戶變更為'||e.customer_number else '' end ORDCHG_WARNNING"+
			  //",a.ORDCHG_WARNNING"+  //add by Peggy 20190408
			  ",a.erp_customer_id1"+ //add by Peggy 20201029
			  ",e.customer_number"+  //add by Peggy 20201029
              ",e.customer_name"+    //add by Peggy 20201029
			  ",null overdue_ssd"+ //add by Peggy 20210129
			  ",d.TSC_PACKAGE "+    //add by Peggy 20210317
			  " from (select x.* ,y.customer_po,y.order_type order_type1 ,(select distinct inventory_item_id from (select k.tscustomerid,p.cust_po_number,nvl( p.cust_po_line_no,decode(k.tscustomerid,7147,'1','')) cust_po_line_no,p.inventory_item_id ,row_number() over (partition by k.tscustomerid,p.cust_po_number,p.cust_po_line_no ORDER by p.dndocno desc) rec_cnt from oraddman.tsdelivery_notice k,oraddman.tsdelivery_notice_detail p where k.dndocno=p.dndocno) where tscustomerid =y.ERP_CUSTOMER_ID and cust_po_number=y.customer_po and cust_po_line_no=x.CUST_PO_LINE_NO and rec_cnt =1) inventory_item_id"+
              " ,(select listagg(z.request_no,'<br>')  within group (order by request_no) request_no from oraddman.TSC_OM_SALESORDERREVISE_REQ z where z.CUSTOMER_PO_REF=x.request_no and z.CUSTOMER_PO_LINE_REF=x.CUST_PO_LINE_NO and z.CUSTOMER_ID_REF=x.ERP_CUSTOMER_ID and z.STATUS not in ('CLOSED') group by z.request_no) revise_request_no"+ //add by Peggy 20160630
			  " ,(select case when nvl(teod.order_change_notice_flag,'N')='Y' THEN teod.remarks else '' end from (select erp_customer_id,customer_po,cust_po_line_no,order_change_notice_flag,remarks,row_number() over (partition by erp_customer_id,customer_po,cust_po_line_no order by decode(order_change_notice_flag,'Y',1,2)) row_rank  from  tsc_edi_orders_detail) teod where teod.erp_customer_id=y.erp_customer_id and teod.customer_po =y.customer_po and teod.cust_po_line_no=x.cust_po_line_no and row_rank=1) ordchg_warnning"+ //add by Peggy 20190408
			  " ,z.erp_customer_id erp_customer_id1,z.currency_code  currency_code1"+//add by Peggy 20201029
			  "  from tsc_edi_orders_his_d x"+
			  " , tsc_edi_orders_his_h y"+
			  " ,tsc_edi_orders_header z"+ //add by Peggy 20201029
			  " where x.erp_customer_id=y.erp_customer_id "+
			  " AND x.request_no=y.request_no"+
              " AND y.customer_po=z.customer_po"+ //add by Peggy 20201029
              " and CASE WHEN y.ERP_CUSTOMER_ID IN (690290,702294,1071293,1071295) THEN 1 ELSE y.ERP_CUSTOMER_ID END=CASE WHEN z.ERP_CUSTOMER_ID IN (690290,702294,1071293,1071295) THEN 1 ELSE z.ERP_CUSTOMER_ID END"+ //add by Peggy 20201029
			  " and x.data_flag='N'"+
			  "  AND y.ORDER_TYPE='ORDCHG') a"+
			  ",tsc_edi_customer c"+
			  ",(select c.inventory_item_id"+
			  "  ,c.ATTRIBUTE3"+
			  "  ,c.segment1"+
			  "  ,c.description item_description"+
			  "  ,NVL(TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,23),TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,43,23)) as TSC_PACKAGE"+
			  "  ,NVL(TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,21),TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,43,21)) as TSC_FAMILY"+
			  "  ,CASE WHEN NVL(c.attribute3, 'N/A') in ('008','002') THEN d.TSC_PROD_GROUP ELSE NVL(TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,1100000003),TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,43,1100000003)) END as TSC_PROD_GROUP"+
			  //"  ,tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (c.attribute3) AS ORDER_TYPE"+
			  "  ,tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (c.INVENTORY_ITEM_ID) AS ORDER_TYPE"+  //modify by Peggy 20191122
			  "  from inv.mtl_system_items_b c "+
			  "  ,oraddman.tsprod_manufactory d"+ //20151209
			  "  where c.ORGANIZATION_ID = '49'"+
			  "  and c.attribute3=d.MANUFACTORY_NO(+)) d"+	
			  ", ar_customers e"+ //add by Peggy 20201029	  
			  " where a.erp_customer_id = c.customer_id"+
			  " and a.erp_customer_id=e.customer_id"+ //add by Peggy 20201029
			  //" and a.ERP_CUSTOMER_ID=d.SOLD_TO_ORG_ID(+) "+
			  //" and a.CUST_ITEM_NAME=d.item(+)"+
			  //" and b.TSC_ITEM_NAME=d.ITEM_DESCRIPTION(+)"+
			  " and a.inventory_item_id=d.inventory_item_id(+)";
			  
		if (UserRoles!="admin" && !UserRoles.equals("admin")) 
		{ 
			sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=c.SALES_AREA_NO)";
		}
		if (!CUSTPO.equals(""))
		{
			sql += " and a.customer_po ='"+CUSTPO+"'";
		}
		if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
		{
			sql += " and a.erp_customer_id = '" + CUSTOMER +"'";
		}
		sql += " and trunc(a.CREATION_DATE) between to_date('"+CYEARFR.replace("--","2013")+"-"+CMONTHFR.replace("--","01")+"-"+CDAYFR.replace("--","01")+"','yyyy-mm-dd')";
		//if (CYEARTO.equals("--")) CYEARTO = ""+dateBean.getYear();
		if (CYEARTO.equals("--")) CYEARTO = dateBean.getYearString();    //modif by Peggy 20140429
		//if (CMONTHTO.equals("--")) CMONTHTO = ""+dateBean.getMonth();
		if (CMONTHTO.equals("--")) CMONTHTO = dateBean.getMonthString(); //modif by Peggy 20140429
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
		sql +=" order by a.order_type1,c.customer_name,a.request_no,a.customer_po,a.cust_po_line_no,a.cust_request_date";
	
		//out.println(sql);
		Statement state=con.createStatement();     
		ResultSet rs=state.executeQuery(sql);
		while (rs.next())	
		{ 
			if (reccnt==0)
			{
				//ResultSetMetaData md=rs.getMetaData();
				//colcnt =md.getColumnCount();
				col=0;row=0;
					
				/*D4009*/
				if (EXLFMT.equals("D4009"))
				{
					//交易類型
					ws.addCell(new jxl.write.Label(col, row, "交易類型" , ACenterBLB));
					ws.setColumnView(col,15);
					col++;	
		
					//客戶
					ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
					
					//申請單號
					ws.addCell(new jxl.write.Label(col, row, "申請單號" , ACenterBLB));
					ws.setColumnView(col,24);	
					col++;	
		
					//狀態
					ws.addCell(new jxl.write.Label(col, row, "狀態" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
		
					//建立日期
					ws.addCell(new jxl.write.Label(col, row, "建立日期" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
		
					//建立人員
					ws.addCell(new jxl.write.Label(col, row, "建立人員" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
		
					//客戶訂單
					ws.addCell(new jxl.write.Label(col, row, "客戶訂單" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
		
					//客戶訂單項次
					ws.addCell(new jxl.write.Label(col, row, "客戶訂單項次" , ACenterBLB));
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
					ws.setColumnView(col,15);	
					col++;
		
					//Customer
					ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
					ws.setColumnView(col,30);	
					col++;
		
					//PO No
					ws.addCell(new jxl.write.Label(col, row, "PO No" , ACenterBL));
					ws.setColumnView(col,15);	
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
		
					//order status,add by Peggy 20140618
					ws.addCell(new jxl.write.Label(col, row, "Order Status" , ACenterBL));
					ws.setColumnView(col,20);	
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
						
					//Quote Number,add by Peggy 20140423
					ws.addCell(new jxl.write.Label(col, row, "Quote Number" , ACenterBLO));
					ws.setColumnView(col,15);	
					col++;	

					//order change warnning,add by Peggy 20190408
					ws.addCell(new jxl.write.Label(col, row, "Order Change Warnning" , ACenterBLO));
					ws.setColumnView(col,35);	
					col++;	
					
					//PACKAGE,ADD BY PEGGY 20210317
					ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;					
				}
				else
				{
					//交易類型
					ws.addCell(new jxl.write.Label(col, row, "交易類型" , ACenterBLB));
					ws.setColumnView(col,15);
					col++;	
		
					//客戶
					ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
					
					//申請單號
					ws.addCell(new jxl.write.Label(col, row, "申請單號" , ACenterBLB));
					ws.setColumnView(col,24);	
					col++;	
		
					//狀態
					ws.addCell(new jxl.write.Label(col, row, "狀態" , ACenterBLB));
					ws.setColumnView(col,20);	
					col++;	
		
					//建立日期
					ws.addCell(new jxl.write.Label(col, row, "建立日期" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
		
					//建立人員
					ws.addCell(new jxl.write.Label(col, row, "建立人員" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
		
					//客戶訂單
					ws.addCell(new jxl.write.Label(col, row, "客戶訂單" , ACenterBLB));
					ws.setColumnView(col,15);	
					col++;	
		
					//客戶訂單項次
					ws.addCell(new jxl.write.Label(col, row, "客戶訂單項次" , ACenterBLB));
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
					ws.setColumnView(col,15);	
					col++;
		
					//客戶
					ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
					ws.setColumnView(col,20);	
					col++;	
		
					//PO No
					ws.addCell(new jxl.write.Label(col, row, "PO No" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;

					//Qty
					ws.addCell(new jxl.write.Label(col, row, "Qty" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;
					
					//SSD,(Initial SSD)
					ws.addCell(new jxl.write.Label(col, row, "SSD (Initial SSD)" ,ACenterBL));
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

					//New Selling Price
					ws.addCell(new jxl.write.Label(col, row, "New Selling Price" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;
																				
					//CRD
					ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBLO));
					ws.setColumnView(col,15);	
					col++;
						
					//Price
					ws.addCell(new jxl.write.Label(col, row, "Price" , ACenterBLO));
					ws.setColumnView(col,15);	
					col++;
						
					//New Price
					ws.addCell(new jxl.write.Label(col, row, "New Price" , ACenterBLO));
					ws.setColumnView(col,15);	
					col++;
						
					//Quote Number
					ws.addCell(new jxl.write.Label(col, row, "Quote Number" , ACenterBLO));
					ws.setColumnView(col,15);	
					col++;	
				
					//order status
					ws.addCell(new jxl.write.Label(col, row, "Order Status" , ACenterBLO));
					ws.setColumnView(col,20);	
					col++;

					//改單申請單號,add by Peggy 20160630
					ws.addCell(new jxl.write.Label(col, row, "改單申請單號" , ACenterBLO));
					ws.setColumnView(col,20);	
					col++;
					
					//order change warnning,add by Peggy 20190408
					ws.addCell(new jxl.write.Label(col, row, "Order Change Warnning" , ACenterBLO));
					ws.setColumnView(col,35);	
					col++;	
					
					//Overdue/Early warning New SSD,add by Peggy 20210129
					ws.addCell(new jxl.write.Label(col, row, "Overdue/Early warning New SSD" , ACenterBLO));
					ws.setColumnView(col,15);	
					col++;	

					//push out frequency,add by Peggy 20230526
					ws.addCell(new jxl.write.Label(col, row, "Push out frequency" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;			
		
					//cancellation frequency,add by Peggy 20230526
					ws.addCell(new jxl.write.Label(col, row, "Cancellation frequency" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;
					
					//PACKAGE,ADD BY PEGGY 20210317
					ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	

					//CURRENCY,ADD BY PEGGY 20210428
					ws.addCell(new jxl.write.Label(col, row, "Currency" , ACenterBL));
					ws.setColumnView(col,10);	
					col++;	
					
					//delivery to,ADD BY PEGGY 20210428
					ws.addCell(new jxl.write.Label(col, row, "Delivery To" , ACenterBL));
					ws.setColumnView(col,70);	
					col++;	
					
					//order date,ADD BY PEGGY 20210428
					ws.addCell(new jxl.write.Label(col, row, "Order Date" , ACenterBL));
					ws.setColumnView(col,12);	
					col++;										

				}
				row++;
			}
				
			if (!column1.equals(rs.getString("TRANS_TYPE")) || !column2.equals(rs.getString("CUSTOMER_NAME")) || !column3.equals(rs.getString("REQUEST_NO")) || !column4.equals(rs.getString("CUSTOMER_PO")) || !column5.equals(rs.getString("CUST_PO_LINE_NO")))
			{
				col=0;line=0;
				column1=rs.getString("TRANS_TYPE");
				column2=rs.getString("CUSTOMER_NAME");
				column3=rs.getString("REQUEST_NO");
				column4=rs.getString("CUSTOMER_PO");
				column5=rs.getString("CUST_PO_LINE_NO");
				chg_cnt=rs.getInt("ORDCHG_CNT");
				mo_cnt=rs.getInt("MO_CNT");
				rfq_cnt=rs.getInt("RFQ_CNT");
				if (chg_cnt >= mo_cnt+rfq_cnt)
				{
					merge_line =chg_cnt;
				}
				else
				{
					merge_line =mo_cnt+rfq_cnt;	
				}
				//define array
				array = new String[merge_line][12];
				
				ws.mergeCells(col, row, col, row+merge_line-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TRANS_TYPE") , ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+merge_line-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME") , ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+merge_line-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_NO") , ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+merge_line-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("STATUS") , ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+merge_line-1);     
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("CREATION_DATE")) , DATE_FORMAT)); //改為日期格式,modify by Peggy 20140415
				col++;	
				ws.mergeCells(col, row, col, row+merge_line-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_CONTACT") , ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+merge_line-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_PO") , ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+merge_line-1);     
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PO_LINE_NO") , ACenterL));
				col++;	
				
				sql = " select * from (select '1',to_char(b.order_number) requestno,line_number||'.'||a.shipment_number line_no,c.description item_description,'('||d.customer_number||')'|| d.customer_name customer,a.customer_line_number customer_po,a.ordered_quantity,a.UNIT_SELLING_PRICE SELLING_PRICE,to_char( a.SCHEDULE_SHIP_DATE,'yyyy/mm/dd')  SCHEDULE_SHIP_DATE ,a.shipping_method_code, to_char(a.REQUEST_DATE,'yyyy/mm/dd') REQUEST_DATE,"+
					  " substr (b.order_number,1,4) order_type,(select x.attribute3 from inv.mtl_system_items_b x where x.organization_id=49 and x.inventory_item_id = a.inventory_item_id) plantcode"+ //add by Peggy 20140612
					  ",a.FLOW_STATUS_CODE order_status"+ //add by Peggy 20140618
					  ",lc.meaning SHIPPING_METHOD_NAME"+ //add by Peggy 20200806
					  ",TSC_GET_REMARK_DESC(a.line_id,'Overdue/Early warning New SSD','OE_ORDER_LINES') overdue_ssd"+ //add by Peggy 20210129
					  ",a.fob_point_code fob"+   //add by Peggy 20210308
					  ",a.DELIVER_TO_ORG_ID deliver_to_id"+   //add by Peggy 20210308
					  ",to_char(b.ordered_date,'yyyy/mm/dd') ordered_date "+ //add by Peggy 20210428
					  ",b.transactional_curr_code curr_code"+  //add by Peggy 20210428
					  ",(SELECT '('||loc.LOCATION_ID||')'||loc.address1  FROM hz_cust_acct_sites_all acct_site,"+
                      " hz_party_sites party_site,  hz_locations loc, hz_cust_site_uses_all site"+
					  " where site.site_use_id=a.DELIVER_TO_ORG_ID"+
                      " and site.cust_acct_site_id = acct_site.cust_acct_site_id"+
                      " AND acct_site.party_site_id = party_site.party_site_id"+
                      " AND party_site.location_id = loc.location_id) deliver_to"+  //add by Peggy 20210428		
                      ",so_m.PUST_OUT_FREQUENCY,so_m.CANCELLATION_FREQUENCY	"+	 //add by Peggy 20230526 			  
					  " from ont.oe_order_lines_all a"+
					  ",ont.oe_order_headers_all b"+
					  ",inv.mtl_system_items_b c"+
					  ",ar_customers d"+
					  ",(SELECT lookup_code,meaning  FROM fnd_lookup_values  WHERE  language='US' AND LOOKUP_TYPE='SHIP_METHOD') lc"+ //add by Peggy 20200806
					  ",TABLE(TSC_GET_SO_MOVE_FREQUENCY(a.line_id)) so_m"+
					  " where b.SOLD_TO_ORG_ID="+rs.getString("erp_customer_id1")+""+
					  " and a.customer_line_number='"+rs.getString("CUSTOMER_PO")+"'"+
					  //" and a.customer_shipment_number='"+rs.getString("CUST_PO_LINE_NO")+"'"+
					  " and nvl(a.customer_shipment_number,decode(b.SOLD_TO_ORG_ID,7147,'1',''))='"+rs.getString("CUST_PO_LINE_NO")+"'"+
					  " and a.header_id=b.header_id"+
					  " and a.ordered_quantity>0"+
					  //" and a.FLOW_STATUS_CODE not in ('CANCELLED','CLOSED')"+
					  " and a.FLOW_STATUS_CODE not in ('CANCELLED')"+
					  " and a.inventory_item_id=c.inventory_item_id"+
					  " and b.ship_from_org_id=c.organization_id"+
					  " and b.sold_to_org_id=d.customer_id"+
					  " and a.shipping_method_code = lc.lookup_code (+)"+ //add by Peggy 20200806
					  " union all"+
					  " select '2',a.dndocno requestno,to_char(a.line_no) line_no,a.ITEM_DESCRIPTION,'('||d.customer_number||')'||b.customer,a.CUST_PO_NUMBER customer_po ,a.quantity*1000 ordered_quantity,a.SELLING_PRICE,to_char(to_date(substr(a.REQUEST_DATE,1,8),'yyyy/mm/dd'),'yyyy/mm/dd') SCHEDULE_SHIP_DATE,a.shipping_method,to_char(to_date(a.CUST_REQUEST_DATE,'yyyy/mm/dd'),'yyyy/mm/dd') REQUEST_DATE,"+
					  " c.ORDER_NUM order_type,a.ASSIGN_MANUFACT plantcode"+ //add by Peggy 20140612
					  ",a.LSTATUS order_status"+//add by Peggy 20140618
					  ",lc.meaning SHIPPING_METHOD_NAME"+ //add by Peggy 20200806
					  ",null overdue_ssd"+ //add by Peggy 20210129
					  ",a.FOB"+   //add by Peggy 20210308
					  ",b.DELIVERY_TO_ORG deliver_to_id"+   //add by Peggy 20210308
					  ",'' ordered_date"+  //add by Peggy 20210428
					  ",b.curr curr_code"+ //add by Peggy 20210428
					  ",(SELECT '('||loc.LOCATION_ID||')'||loc.address1  FROM hz_cust_acct_sites_all acct_site,"+
                      " hz_party_sites party_site,  hz_locations loc, hz_cust_site_uses_all site"+
					  " where site.site_use_id=b.DELIVERY_TO_ORG"+
                      " and site.cust_acct_site_id = acct_site.cust_acct_site_id"+
                      " AND acct_site.party_site_id = party_site.party_site_id"+
                      " AND party_site.location_id = loc.location_id) deliver_to"+  //add by Peggy 20210428
					  ",null PUST_OUT_FREQUENCY,null CANCELLATION_FREQUENCY	"+   //add by Peggy 20230526 
					  " from oraddman.tsdelivery_notice_detail a"+
					  ",oraddman.tsdelivery_notice b"+
					  ",oraddman.tsarea_ordercls c"+
					  ",(SELECT lookup_code,meaning  FROM fnd_lookup_values  WHERE  language='US' AND LOOKUP_TYPE='SHIP_METHOD') lc"+ //add by Peggy 20200806
					  ",ar_customers d"+//add by Peggy 20210304
					  " where a.dndocno = b.dndocno"+
					  " and b.TSCUSTOMERID="+rs.getString("erp_customer_id1")+""+
					  " and a.CUST_PO_NUMBER ='"+rs.getString("CUSTOMER_PO")+"'"+
					  //" and a.CUST_PO_LINE_NO='"+rs.getString("CUST_PO_LINE_NO")+"'"+
					  " and nvl(a.CUST_PO_LINE_NO,decode(b.TSCUSTOMERID,7147,'1',''))='"+rs.getString("CUST_PO_LINE_NO")+"'"+
					  " AND (ORDERNO is null or ORDERNO ='N/A')"+
					  " and a.LSTATUSID not in ('001','010','012')"+
					  " AND a.order_type_id=c.OTYPE_ID"+ //add by Peggy 20140612
					  " AND b.tsareano=c.SAREA_NO"+
					  "	AND a.shipping_method = lc.lookup_code (+)"+ //add by Peggy 20200806
					  " and b.TSCUSTOMERID=d.customer_id(+)"+ //add by Peggy 20210304
                      " ) x "+	//add by Peggy 20140612		
					  " order by 1,decode(x.ordered_quantity,"+Double.valueOf(rs.getString("quantity")).doubleValue()+",0,1)+decode(x.REQUEST_DATE,'"+rs.getString("cust_request_date")+"',0,1),11,3,4";	 //modify by Peggy 20141105	  
					 // " order by 1,11,3,4";
				//out.println(sql);
				Statement state1=con.createStatement();     
				ResultSet rs1=state1.executeQuery(sql);
				while (rs1.next())	
				{ 
					array[line][0]=rs.getString("SALES_AREA_NO");
					array[line][1]=(rs1.getString("plantcode")==null?"":rs1.getString("plantcode"));
					array[line][2]="";
					//array[line][3]=rs1.getString("SHIPPING_METHOD_CODE");
					array[line][3]=rs1.getString("SHIPPING_METHOD_NAME");
					array[line][4]=(rs1.getString("order_type")==null?"":rs1.getString("order_type"));
					array[line][5]=""+(row+line);
					array[line][6]=rs1.getString("REQUEST_DATE");        //add by Peggy 20141105
					array[line][7]=rs1.getString("ORDERED_QUANTITY");    //add by Peggy 20141105
					array[line][8]=rs1.getString("SELLING_PRICE");       //add by Peggy 20141105
					array[line][9]=rs1.getString("SCHEDULE_SHIP_DATE");  //add by Peggy 20141105
					array[line][10]=rs1.getString("fob");                //add by Peggy 20210308
					array[line][11]=rs1.getString("deliver_to_id");      //add by Peggy 20210308
					/*
					mo_CRD = rs1.getString("REQUEST_DATE");       //add by Peggy 20130910
					mo_QTY = rs1.getString("ORDERED_QUANTITY");	  //add by Peggy 20130910	
					mo_PRICE = rs1.getString("SELLING_PRICE");    //add by Peggy 20130910
					mo_SSD = rs1.getString("SCHEDULE_SHIP_DATE"); //add by Peggy 20130910
					*/
												
					if ((line+1)==(mo_cnt+rfq_cnt))
					{
						mergeCol = merge_line-(mo_cnt+rfq_cnt);
						for (int k=(line+1); k <merge_line; k++)
						{
							array[k][0]=rs.getString("SALES_AREA_NO");
							array[k][1]=(rs.getString("plantcode")==null?"":rs.getString("plantcode"));
							array[k][2]="";
							//array[k][3]=rs1.getString("SHIPPING_METHOD_CODE");
							array[k][3]=rs1.getString("SHIPPING_METHOD_NAME");
							array[k][4]=(rs.getString("order_type")==null?"":rs.getString("order_type"));
							array[k][5]=""+(row+k);
							array[k][6]=rs1.getString("REQUEST_DATE");        //add by Peggy 20141105
							array[k][7]=rs1.getString("ORDERED_QUANTITY");    //add by Peggy 20141105
							array[k][8]=rs1.getString("SELLING_PRICE");       //add by Peggy 20141105
							array[k][9]=rs1.getString("SCHEDULE_SHIP_DATE");  //add by Peggy 20141105
							array[k][10]=rs1.getString("fob");                //add by Peggy 20210308
							array[k][11]=rs1.getString("deliver_to_id");      //add by Peggy 20210308
						}
					}
					else
					{
						mergeCol = 0;
					}

					/*D4009*/
					if (EXLFMT.equals("D4009"))
					{
						col=8;
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("requestno") , ACenterL));
						col++;
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("line_no") , ACenterL));
						col++;
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("ITEM_DESCRIPTION") , ALeftL));
						col++;
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("customer") , ALeftL));
						col++;
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("customer_po") , ALeftL));
						col++;	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Number(col, row+line, Double.valueOf(rs1.getString("ORDERED_QUANTITY")).doubleValue() , ARightL));
						col++;	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);    
						ws.addCell(new jxl.write.Number(col, row+line, Double.valueOf((new DecimalFormat("####0.#####")).format(Float.parseFloat(rs1.getString("SELLING_PRICE")))).doubleValue() , ARightL));
						col++;	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.DateTime(col, row+line, formatter.parse(rs1.getString("SCHEDULE_SHIP_DATE")) , DATE_FORMAT));  //改為日期格式,modify by Peggy 20140415
						col++;	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ACenterL));
						col++;	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						//ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("SHIPPING_METHOD_CODE") , ACenterL));
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("SHIPPING_METHOD_NAME") , ACenterL));
						col++;	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ACenterL));
						col++;	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("order_status") , ACenterL));
						col++;	
						ws.mergeCells(col, row+line,col, row+line+mergeCol);     
						ws.addCell(new jxl.write.DateTime(col, row+line, formatter.parse(rs1.getString("REQUEST_DATE")) , DATE_FORMAT));  //改為日期格式,modify by Peggy 20140415
						col+=6;	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						if (rs.getString("TSC_PACKAGE")!=null && (rs.getString("TSC_PACKAGE").equals("Matrix SMB") || rs.getString("TSC_PACKAGE").equals("Matrix SMC") || rs.getString("TSC_PACKAGE").equals("SOD-123W") || rs.getString("TSC_PACKAGE").equals("Micro SMA")))
						{
							ws.addCell(new jxl.write.Label(col, row+line, rs.getString("TSC_PACKAGE"), ACenterLR));
						}
						else
						{
							ws.addCell(new jxl.write.Label(col, row+line, rs.getString("TSC_PACKAGE"), ACenterL));
						}
						col++;	
						
					}
					else
					{
						
						col=8;
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("requestno") , ACenterL));
						col++;	//8
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("line_no") , ACenterL));
						col++;	//9
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("ITEM_DESCRIPTION") , ALeftL));
						col++;	//10
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("customer") , ALeftL));
						col++;  //11
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("customer_po") , ALeftL));
						col++;	//12
						//QTY
						ws.mergeCells(col, row+line,col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Number(col, row+line, Double.valueOf(rs1.getString("ORDERED_QUANTITY")).doubleValue() , ARightL));
						col++; //13
						//initial SSD
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.DateTime(col, row+line, formatter.parse(rs1.getString("SCHEDULE_SHIP_DATE")) , DATE_FORMAT)); 
						col++; //14
						//order type
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++;	//15
						//add by Peggy 20201029
						if (!rs.getString("ERP_CUSTOMER_ID1").equals(rs.getString("ERP_CUSTOMER_ID")))
						{
							v_deliverto="";v_billto="";v_shipto="";
							sql = " SELECT a.site_use_code, a.primary_flag, a.site_use_id,a.location"+
                                  " FROM ar_site_uses_v a, hz_cust_acct_sites b"+
                                  " WHERE a.address_id = b.cust_acct_site_id"+
                                  " AND a.status = ?"+
                                  " AND b.cust_account_id = ?"+
                                  " AND a.primary_flag = ?";
							PreparedStatement statement2 = con.prepareStatement(sql);
							statement2.setString(1,"A");
							statement2.setString(2,rs.getString("ERP_CUSTOMER_ID"));
							statement2.setString(3,"Y");
							ResultSet rs2=statement2.executeQuery();
							while (rs2.next())
							{
								if (rs2.getString("SITE_USE_CODE").equals("BILL_TO"))
								{
									v_billto=rs2.getString("LOCATION");
								}
								else if (rs2.getString("SITE_USE_CODE").equals("DELIVER_TO"))
								{
									v_deliverto=rs2.getString("LOCATION");
								}
								else if (rs2.getString("SITE_USE_CODE").equals("SHIP_TO"))
								{
									v_shipto=rs2.getString("LOCATION");
								}
							}
							rs2.close();
							statement2.close();
							  
							//customer number
							ws.mergeCells(col, row+line, col, row+line+mergeCol);     
							ws.addCell(new jxl.write.Label(col, row+line, rs.getString("CUSTOMER_NUMBER"), ACenterLR));
							col++;	//16
							//customer
							ws.mergeCells(col, row+line, col, row+line+mergeCol);     
							ws.addCell(new jxl.write.Label(col, row+line, rs.getString("CUSTOMER_NAME") , ACenterLR));
							col++;	//17
							//Ship to Org ID
							ws.mergeCells(col, row+line, col, row+line+mergeCol);     
							ws.addCell(new jxl.write.Label(col, row+line, v_shipto , ACenterLR));
							col++;  //18	
							//Bill to Org ID
							ws.mergeCells(col, row+line, col, row+line+mergeCol);     
							ws.addCell(new jxl.write.Label(col, row+line, v_billto , ACenterLR));
							col++; //19
							//Deliver to Org ID
							ws.mergeCells(col, row+line, col, row+line+mergeCol);     
							ws.addCell(new jxl.write.Label(col, row+line, v_deliverto , ACenterLR));
							col++; //20
						}
						else
						{
							//customer number
							ws.mergeCells(col, row+line, col, row+line+mergeCol);     
							ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
							col++;	//16
							//customer
							ws.mergeCells(col, row+line, col, row+line+mergeCol);     
							ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
							col++;	//17
							//Ship to Org ID
							ws.mergeCells(col, row+line, col, row+line+mergeCol);     
							ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
							col++;  //18	
							//Bill to Org ID
							ws.mergeCells(col, row+line, col, row+line+mergeCol);     
							ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
							col++; //19
							//Deliver to Org ID
							ws.mergeCells(col, row+line, col, row+line+mergeCol);     
							ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
							col++; //20						
						}
						//TSC Item(22碼)
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //21	
						//Customer P/N
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //22	
						//New Customer PO
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //23	
						//New Shipping Method
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						//ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("SHIPPING_METHOD_CODE")  , ALeftL));
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("SHIPPING_METHOD_NAME")  , ALeftL));
						col++; //24		
						//New Qty						
						//ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						//ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //22
						//New SSD					
						//ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						//ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //23
						//New CRD					
						//ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						//ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //24
						//New FOB					
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //25
						//REMARKS					
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //26
						//Change Reason					
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //27
						//Change Comments					
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //28
						//New Selling Price,add by Peggy 20201029	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //29					
						//CRD
						ws.mergeCells(col, row+line,col, row+line+mergeCol);     
						ws.addCell(new jxl.write.DateTime(col, row+line, formatter.parse(rs1.getString("REQUEST_DATE")) , DATE_FORMAT));
						col++; //32
						//Price																											
						ws.mergeCells(col, row+line, col, row+line+mergeCol);    
						ws.addCell(new jxl.write.Number(col, row+line, Double.valueOf((new DecimalFormat("####0.#####")).format(Float.parseFloat(rs1.getString("SELLING_PRICE")))).doubleValue() , ARightL));
						col++; //34	
						//NEW price
						//ws.mergeCells(col, row+line,col, row+line+mergeCol);     
						//ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //34						
						//Quote Number
						//ws.mergeCells(col, row+line,col, row+line+mergeCol);     
						//ws.addCell(new jxl.write.Label(col, row+line, "" , ALeftL));
						col++; //35
						//Order Status					
						ws.mergeCells(col, row+line, col, row+line+mergeCol);     
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("order_status") , ACenterL));
						col++;//36		
						ws.mergeCells(col, row+line, col, row+line+mergeCol);    //add by Peggy 20160630   
						ws.addCell(new jxl.write.Label(col, row+line, rs.getString("REVISE_REQUEST_NO") , ACenterL));
						col++;//37	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);    //add by Peggy 20190408
						ws.addCell(new jxl.write.Label(col, row+line, (rs.getString("ORDCHG_WARNNING")==null?"": rs.getString("ORDCHG_WARNNING")), ACenterLR));
						col++;//38		
						ws.mergeCells(col, row+line, col, row+line+mergeCol);    //add by Peggy 20210129
						if (rs1.getString("OVERDUE_SSD")==null)
						{
							ws.addCell(new jxl.write.Label(col, row+line, "", ACenterL));
						}
						else
						{
							ws.addCell(new jxl.write.DateTime(col, row+line, formatter.parse(rs1.getString("OVERDUE_SSD")) , DATE_FORMAT));
						}
						col++;//39	
						ws.mergeCells(col, row+line, col, row+line+mergeCol);   
						ws.addCell(new jxl.write.Label(col, row+line, (rs1.getString("PUST_OUT_FREQUENCY")==null?"":rs1.getString("PUST_OUT_FREQUENCY")), ACenterL));
						col++;//40
						ws.mergeCells(col, row+line, col, row+line+mergeCol);   
						ws.addCell(new jxl.write.Label(col, row+line, (rs1.getString("CANCELLATION_FREQUENCY")==null?"":rs1.getString("CANCELLATION_FREQUENCY")) ,ACenterL));
						col++;//41												
						ws.mergeCells(col, row+line, col, row+line+mergeCol);    //add by Peggy 20210317
						if (rs.getString("TSC_PACKAGE")!=null && (rs.getString("TSC_PACKAGE").equals("Matrix SMB") || rs.getString("TSC_PACKAGE").equals("Matrix SMC") || rs.getString("TSC_PACKAGE").equals("SOD-123W") || rs.getString("TSC_PACKAGE").equals("Micro SMA")))
						{
							ws.addCell(new jxl.write.Label(col, row+line, rs.getString("TSC_PACKAGE"), ACenterLR));
						}
						else
						{
							ws.addCell(new jxl.write.Label(col, row+line, rs.getString("TSC_PACKAGE"), ACenterL));
						}
						col++;//42		
						
						ws.mergeCells(col, row+line, col, row+line+mergeCol);    //add by Peggy 20210428
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("curr_code"), ACenterL));
						col++;//43												

						ws.mergeCells(col, row+line, col, row+line+mergeCol);    //add by Peggy 20210428
						ws.addCell(new jxl.write.Label(col, row+line, rs1.getString("deliver_to"), ALeftL1));
						col++;//44

						ws.mergeCells(col, row+line, col, row+line+mergeCol);    //add by Peggy 20210428
						ws.addCell(new jxl.write.Label(col, row+line, (rs1.getString("ordered_date")==null?"":rs1.getString("ordered_date")), ACenterL));
						col++;//45											
																			
					}
				
					line++;
				}
				rs1.close();
				state1.close();
				if (line==0)
				{
					for (col=8 ; col<=(EXLFMT.equals("D4009")?21:46) ;col++)
					{
						ws.mergeCells(col, row,col, row);     
						ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
					}
				}
				line=0; 
			}
			
			array[line][2]=rs.getString("cust_request_date");
			array[line][5]=""+(row);
			if ((line+1)==chg_cnt)
			{
				mergeCol = merge_line-chg_cnt;
				for (int k=(line+1); k <merge_line; k++)
				{
					array[k][2]=rs.getString("cust_request_date");
					array[k][5]=""+(row+k);
				}
				
				String SSD ="";			
				for (int m=0 ; m < array.length ; m++)
				{
					//if ((mo_CRD.replace("/","")).equals(array[m][2].replace("/",""))) //add by Peggy 20140423
					if (array[m][6]==null || array[m][6].replace("/","").equals(array[m][2].replace("/",""))) //add by Peggy 20140423
					{
						//SSD = mo_SSD;
						SSD =(array[m][9]==null?"":array[m][9]);
					}
					else
					{
//						System.out.println("array[m][0]="+array[m][0]);
//						System.out.println("array[m][1]="+array[m][1]);
//						System.out.println("array[m][2]="+array[m][2]);
//						System.out.println("array[m][3]="+array[m][3]);
//						System.out.println("array[m][4]="+array[m][4]);
//						System.out.println("erp_customer_id="+rs.getString("erp_customer_id"));
//						System.out.println("array[m][10]="+array[m][10]);
//						System.out.println("array[m][11]="+array[m][11]);

						CallableStatement csg = con.prepareCall("{call tsc_edi_pkg.GET_SSD(?,?,?,?,?,?,?,sysdate,?,?)}");
						csg.setString(1,array[m][0]);
						csg.setString(2,array[m][1]);      
						csg.setString(3,array[m][2].replace("/",""));                   
						csg.setString(4,array[m][3]);    
						csg.setString(5,array[m][4]);   
						csg.registerOutParameter(6, Types.VARCHAR);  
						csg.setString(7,rs.getString("erp_customer_id"));   
						csg.setString(8,array[m][10]);   
						csg.setString(9,array[m][11]);   
						csg.execute();
						//out.println("csg.getString(6)="+csg.getString(6));
						if (csg.getString(6)!=null)
						{
							//if (Long.parseLong(mo_CRD.replace("/","")) > Long.parseLong(rs.getString("cust_request_date").replace("/","")))
							if (Long.parseLong(array[m][6].replace("/","")) > Long.parseLong(rs.getString("cust_request_date").replace("/","")))
							{
								//if (Long.parseLong(csg.getString(6)) > Long.parseLong(mo_SSD.replace("/","")))
								if (Long.parseLong(csg.getString(6)) > Long.parseLong(array[m][9].replace("/","")))
								{
									//SSD = mo_SSD;
									SSD =array[m][9];
								}
								else
								{
									SSD = csg.getString(6).substring(0,4)+"/"+csg.getString(6).substring(4,6)+"/"+csg.getString(6).substring(6,8);  
								}
							}
							else
							{
								SSD = csg.getString(6).substring(0,4)+"/"+csg.getString(6).substring(4,6)+"/"+csg.getString(6).substring(6,8);                
							}
						}
						else
						{
							SSD ="";
						}
						csg.close();
					}
					
					/*D4009*/
					if (EXLFMT.equals("D4009"))
					{
						if (SSD.equals(""))
						{
							ws.addCell(new jxl.write.Label(16, Integer.parseInt(array[m][5]), SSD , ACenterL));
						}
						else
						{
							ws.addCell(new jxl.write.DateTime(16, Integer.parseInt(array[m][5]), formatter.parse(SSD) , DATE_FORMAT));  //改為日期格式,modify by Peggy 20140415
						}
						ws.setColumnView(16,15);	
					}
					else
					{
						if (SSD.equals(""))
						{
							ws.addCell(new jxl.write.Label(26, Integer.parseInt(array[m][5]), SSD , ACenterL));
						}
						else
						{
							ws.addCell(new jxl.write.DateTime(26, Integer.parseInt(array[m][5]), formatter.parse(SSD) , DATE_FORMAT)); 
						}
						ws.setColumnView(26,15);					
					}
				}
			}
			else
			{
				mergeCol = 0;
			}
			/*D4009*/
			if (EXLFMT.equals("D4009"))
			{
				ws.mergeCells(21, row, 21, row+mergeCol);     
				ws.addCell(new jxl.write.DateTime(21, row, formatter.parse(rs.getString("cust_request_date")) , ((chg_cnt<mo_cnt || array[line][6]==null || !array[line][6].equals(rs.getString("cust_request_date")))?DATE_FORMAT1:DATE_FORMAT))); //改為日期格式,modify by Peggy 20141105
		
				ws.mergeCells(22, row, 22, row+mergeCol);     
				ws.addCell(new jxl.write.Number(22, row, Double.valueOf(rs.getString("quantity")).doubleValue(),  ((chg_cnt<mo_cnt || array[line][7]==null || !array[line][7].equals(rs.getString("quantity")))?ARightLR:ARightL)));
				//ws.setColumnView(22,15);	
		
				ws.mergeCells(23, row, 23, row+mergeCol);     
				ws.addCell(new jxl.write.Number(23, row, Double.valueOf((new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("unit_price")))).doubleValue() , (array[line][8]==null || !array[line][8].equals(rs.getString("unit_price"))?ARightLR:ARightL)));
				//ws.setColumnView(23,15);	
				
				ws.mergeCells(24, row, 24, row+mergeCol);     
				ws.addCell(new jxl.write.Label(24, row, (rs.getString("QUOTE_NUMBER")==null?"":rs.getString("QUOTE_NUMBER")) , ACenterL));
				//ws.setColumnView(24,15);	

				//ORDER CHANGE WARNNING,add by Peggy 20190408
				ws.mergeCells(25, row, 25, row+mergeCol);     
				ws.addCell(new jxl.write.Label(25, row, (rs.getString("ORDCHG_WARNNING")==null?"":rs.getString("ORDCHG_WARNNING")) ,ACenterLR));
				//ws.setColumnView(25,15);	
				col++;		
			}
			else
			{
				//NEW QTY
				ws.mergeCells(25, row, 25, row+mergeCol);     
				ws.addCell(new jxl.write.Number(25, row, Double.valueOf(rs.getString("quantity")).doubleValue(),  ((chg_cnt<mo_cnt || array[line][7]==null || !array[line][7].equals(rs.getString("quantity")))?ARightLR:ARightL)));

				//new CRD
				ws.mergeCells(27, row, 27, row+mergeCol);     
				ws.addCell(new jxl.write.DateTime(27, row, formatter.parse(rs.getString("cust_request_date")) , ((chg_cnt<mo_cnt || array[line][6]==null || !array[line][6].equals(rs.getString("cust_request_date")))?DATE_FORMAT1:DATE_FORMAT))); //改為日期格式,modify by Peggy 20141105
				
				//NEW SELLING PRICE
				if (array[line][8]==null || !array[line][8].equals(rs.getString("unit_price")))
				{
					ws.mergeCells(32, row, 32, row+mergeCol);     
					ws.addCell(new jxl.write.Number(32, row, Double.valueOf((new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("unit_price")))).doubleValue() , (array[line][8]==null || !array[line][8].equals(rs.getString("unit_price"))?ARightLR:ARightL)));
				}
				
				//NEW PRICE
				ws.mergeCells(35, row, 35, row+mergeCol);     
				ws.addCell(new jxl.write.Number(35, row, Double.valueOf((new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("unit_price")))).doubleValue() , (array[line][8]==null || !array[line][8].equals(rs.getString("unit_price"))?ARightLR:ARightL)));
				
				//QUOTE NUMBER
				ws.mergeCells(36, row, 36, row+mergeCol);     
				ws.addCell(new jxl.write.Label(36, row, (rs.getString("QUOTE_NUMBER")==null?"":rs.getString("QUOTE_NUMBER")) , ACenterL));

				//ORDER CHANGE WARNNING,add by Peggy 20190408
				ws.mergeCells(39, row, 39, row+mergeCol);     
				ws.addCell(new jxl.write.Label(39, row, (rs.getString("ORDCHG_WARNNING")==null?"":rs.getString("ORDCHG_WARNNING")) ,ACenterLR));
				col++;		

				//Overdue/Early warning New SSD,add by Peggy 20210129
				ws.mergeCells(40, row, 40, row+mergeCol);     
				if (rs.getString("OVERDUE_SSD")==null)
				{
					ws.addCell(new jxl.write.Label(40, row, "", ACenterL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(40, row, formatter.parse(rs.getString("OVERDUE_SSD")) , DATE_FORMAT));
				}				
				col++;		
			}
				
			line++;
			//row+=merge_line;
			row=row+mergeCol+1;
			
			reccnt++;
		}
		wwb.write(); 
		
		rs.close();
		state.close();
	}
	else if (ODRTYPE.equals("ORDERS"))
	{
		sql = " select decode(a.order_type,'ORDERS','NEW ORDER',a.order_type) TRANS_TYPE,a.erp_customer_id,'('||d.customer_number||')'||c.customer_name customer_name,a.request_no,'AWAITING_CONFIRM' STATUS,to_char(a.creation_date,'yyyy/mm/dd') creation_date"+
			  " ,c.sales_contact,a.customer_po,b.cust_po_line_no,b.cust_item_name,b.tsc_item_name,to_char(to_date(b.cust_request_date,'yyyymmdd'),'yyyy/mm/dd') cust_request_date, b.quantity,b.unit_price,c.sales_area_no,b.UOM,b.ERR_EXPLANATION"+
			  " ,to_char(b.mailed_date,'yyyy-mm-dd hh24:mi') mailed_date"+ //add by Peggy 20140717
			  " ,case when b.cust_item_name<>b.orig_cust_item_name then b.orig_cust_item_name else '' end orig_cust_item_name "+  //add by Peggy 20190307
			  " ,b.QUOTE_NUMBER"+
			  " from tsc_edi_orders_his_h a,tsc_edi_orders_his_d b ,tsc_edi_customer c,ar_customers d"+
			  " where a.request_no=b.request_no"+
			  " and a.erp_customer_id=b.erp_customer_id"+
			  " and b.data_flag='N'"+
			  " and a.erp_customer_id = c.customer_id"+
			  " and c.customer_id=d.customer_id(+)"+ //add by Peggy 20210304
			  " AND a.ORDER_TYPE='ORDERS'";
		if (UserRoles!="admin" && !UserRoles.equals("admin")) 
		{ 
			sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=c.SALES_AREA_NO)";
		}
		if (!CUSTPO.equals(""))
		{
			sql += " and a.customer_po ='"+CUSTPO+"'";
		}
		if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
		{
			sql += " and a.erp_customer_id = '" + CUSTOMER +"'";
		}
		sql += " and trunc(a.CREATION_DATE) between to_date('"+CYEARFR.replace("--","2013")+"-"+CMONTHFR.replace("--","01")+"-"+CDAYFR.replace("--","01")+"','yyyy-mm-dd')";
		if (CYEARTO.equals("--")) CYEARTO = ""+dateBean.getYearString();
		if (CMONTHTO.equals("--")) CMONTHTO = ""+dateBean.getMonthString();
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
		sql +=" order by a.order_type,c.customer_name,a.request_no,a.customer_po,b.cust_po_line_no";
	
		//out.println(sql);
		Statement state=con.createStatement();     
		ResultSet rs=state.executeQuery(sql);
		while (rs.next())	
		{ 
			if (reccnt==0)
			{
				col=0;row=0;
				
				//交易類型
				ws.addCell(new jxl.write.Label(col, row, "交易類型" , ACenterBLB));
				ws.setColumnView(col,15);
				col++;	
	
				//客戶
				ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
				ws.setColumnView(col,30);	
				col++;	
				
				//申請單號
				ws.addCell(new jxl.write.Label(col, row, "申請單號" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	
	
				//狀態
				ws.addCell(new jxl.write.Label(col, row, "狀態" , ACenterBLB));
				ws.setColumnView(col,20);	
				col++;	
	
				//建立日期
				ws.addCell(new jxl.write.Label(col, row, "建立日期" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	
	
				//建立人員
				ws.addCell(new jxl.write.Label(col, row, "建立人員" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	
	
				//客戶訂單
				ws.addCell(new jxl.write.Label(col, row, "客戶訂單" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	
	
				//客戶訂單項次
				ws.addCell(new jxl.write.Label(col, row, "客戶訂單項次" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	

				//CUST P/N
				ws.addCell(new jxl.write.Label(col, row, "Cust P/N" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	

				//TSC P/N
				ws.addCell(new jxl.write.Label(col, row, "TSC P/N" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	

				//End Cust P/N
				ws.addCell(new jxl.write.Label(col, row, "End Cust P/N" , ACenterBLB));
				ws.setColumnView(col,15);	
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
					
				//CRD
				ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;
				
				//QUOTE NUMBER
				ws.addCell(new jxl.write.Label(col, row, "QUOTE NUMBER" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;				
					
				//異常原因
				ws.addCell(new jxl.write.Label(col, row, "異常原因" , ACenterBLY));
				ws.setColumnView(col,30);	
				col++;

				//MAIL DATE
				ws.addCell(new jxl.write.Label(col, row, "MAILED DATE" , ACenterBLY));
				ws.setColumnView(col,15);	
				col++;
				row++;
			}
			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TRANS_TYPE") , ACenterL));
			ws.setColumnView(col,15);
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME") , ALeftL));
			ws.setColumnView(col,35);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_NO") , ALeftL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("STATUS") , ACenterL));
			ws.setColumnView(col,20);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATION_DATE") , ACenterL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_CONTACT") , ACenterL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_PO") , ALeftL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PO_LINE_NO") , ACenterL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("cust_item_name") , ALeftL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_item_name") , ALeftL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("orig_cust_item_name") , ALeftL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("quantity") , ARightL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("uom") , ACenterL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("unit_price"))) , ARightL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("cust_request_date") , ACenterL));
			ws.setColumnView(col,15);	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("quote_number") , ACenterL)); //add by Peggy 20230413
			ws.setColumnView(col,15);	
			col++;			
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ERR_EXPLANATION") , ALeftL));
			ws.setColumnView(col,30);	
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("MAILED_DATE") , ALeftL));
			ws.setColumnView(col,15);	
			col++;					
			row++;
			
			reccnt ++;
		}	
		wwb.write(); 
		
		rs.close();
		state.close();
	}
	
	wwb.close();
	os.close();  
	out.close(); 

	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();		
	
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
</html>
