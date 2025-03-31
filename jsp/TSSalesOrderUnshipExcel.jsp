<!-- 20160304 Peggy,add two field=>ship to org id & end customer number-->
<!-- 20170220 Peggy,add order header ship to contact for tscr-->
<!-- 20170222 Peggy,add LINE_CHARGE field for tsce-->
<!-- 20170428 Peggy,add carton_qty,carton_size,ship_customer_num-->
<!-- 20170829 Peggy,蘇州/上海/深圳業務單位變更郵件domain由mail.tew.com.cn改為ts-china.com.cn-->
<!-- 20170920 Peggy,fairchild change to on semi-->
<!-- 20171204 Peggy,新增"材積重 M3(volume)"欄位-->
<!-- 20180119 Peggy,ship_to_contact header無值,改抓line-->
<!-- 20180320 Peggy,add a bill address column-->
<!-- 20180822 Peggy,the tsc package column move to the right side of the description column-->
<!-- 20181227 Peggy,新增Hold code,Hold reason,工單/採購單開立日-->
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
<FORM ACTION="../jsp/TSSalesOrderUnshipExcel.jsp" METHOD="post" name="MYFORM">
<%
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String MONO=request.getParameter("MONO");
if (MONO==null) MONO="";
String ITEMDESC=request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
String ORDERTYPE = request.getParameter("ORDERTYPE");
if (ORDERTYPE==null) ORDERTYPE="";
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
if (ACTTYPE.equals("TSCE") || ACTTYPE.equals("TSCA") || ACTTYPE.equals("TSCR")) //add by Peggy 20200807
{
	salesGroup = ACTTYPE;
}
String RPTTYPE = request.getParameter("RPTTYPE");
if (RPTTYPE==null) RPTTYPE="";
String UserName = request.getParameter("UserName");
if (UserName==null) UserName="";
String UserRoles =request.getParameter("UserRoles");
if (UserRoles==null) UserRoles="";
String FileName="",RPTName="",PLANTNAME="",sql="",ERP_USERID="",remarks="",price_show="N";
int fontsize=8,colcnt=0,sheetcnt=0;
String v_sample_order="樣品訂單",v_inside_order="內銷訂單",v_outside_order="外銷訂單",v_consignment_order="consignment訂單",v_fsc_order="FSC訂單",v_onsemi_order="ON Semi訂單";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
String SHIPFROMLOCATION = request.getParameter("SHIPFROMLOCATION");  //add by Peggy 20201019
if (SHIPFROMLOCATION==null) SHIPFROMLOCATION="";
String SHIPPINGMETHOD = request.getParameter("SHIPPINGMETHOD");  //add by Peggy 20201019
if (SHIPPINGMETHOD==null) SHIPPINGMETHOD="";
String V_PULLIN_NEW_SSD=""; //add by Peggy 20230824
String V_SYS_DATE=dateBean.getYearMonthDay();

try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "Order Unship Report";
	if (ACTTYPE.equals("TSCC") && RPTTYPE.equals("INSIDE"))
	{	
		RPTName +="(In)";
	}
	else if (ACTTYPE.equals("TSCC") && RPTTYPE.equals("OUTSIDE"))
	{		
		RPTName +="(Out)";
	}
	else if (ACTTYPE.equals("TSCE"))
	{
		RPTName =ACTTYPE +"-"+RPTName;
	}
	else if (ACTTYPE.equals("TSCR"))  //add by Peggy 20220303
	{
		RPTName =ACTTYPE+"&TSCI" +"-"+RPTName;
	}	
	else
	{
		RPTName +="("+UserName+")";
	}
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//WritableSheet ws = wwb.createSheet(RPTName, 0); 
	if (ACTTYPE.equals("TSCC") && RPTTYPE.equals("INSIDE"))
	{
		wwb.createSheet(v_sample_order, 0);
		wwb.createSheet(v_inside_order, 1);
	}
	else if (ACTTYPE.equals("TSCC") && RPTTYPE.equals("OUTSIDE"))
	{
		wwb.createSheet(v_outside_order, 0);
		wwb.createSheet(v_consignment_order, 1);
		//wwb.createSheet(v_fsc_order, 2);
		wwb.createSheet(v_onsemi_order, 2); //add by Peggy 20170929
	}
	else
	{
		wwb.createSheet("Unship Order", 0);
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
	ACenterBL.setWrap(false);	

	//英文內文水平垂直置中-粗體-格線-底色藍  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.PALE_BLUE); 
	ACenterBLB.setWrap(false);
	
	//英文內文水平垂直置中-粗體-格線-底色黃  
	WritableCellFormat ACenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLY.setBackground(jxl.write.Colour.YELLOW); 
	ACenterBLY.setWrap(false);	
	
	//英文內文水平垂直置中-粗體-格線-底色橘
	WritableCellFormat ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
	ACenterBLO.setWrap(false);	
	
	//英文內文水平垂直置中-粗體-格線-底色綠
	WritableCellFormat ACenterBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLG.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLG.setBackground(jxl.write.Colour.BRIGHT_GREEN); 
	ACenterBLG.setWrap(false);	
			
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(font_nobold);   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(false);


	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(font_nobold);   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(false);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(font_nobold);   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(false);
	
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterLB = new WritableCellFormat(font_nobold_b);   
	ACenterLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLB.setWrap(false);


	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightLB = new WritableCellFormat(font_nobold_b);   
	ARightLB.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLB.setWrap(false);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftLB = new WritableCellFormat(font_nobold_b);   
	ALeftLB.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLB.setWrap(false);
		
	//英文內文水平垂直置中-正常-格線-底色粉紅
	WritableCellFormat ACenterLP = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterLP.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLP.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLP.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLP.setBackground(jxl.write.Colour.PINK); 	
	ACenterLP.setWrap(false);
	
	//英文內文水平垂直置中-正常-格線-底色淺綠
	WritableCellFormat ACenterLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterLG.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLG.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
	ACenterLG.setWrap(false);	

	//英文內文水平垂直置中-正常-格線-底色粉紅-藍字
	WritableCellFormat ACenterLPB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLPB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLPB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLPB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLPB.setBackground(jxl.write.Colour.PINK); 	
	ACenterLPB.setWrap(false);
	
	//英文內文水平垂直置中-正常-格線-底色淺綠-藍字
	WritableCellFormat ACenterLGB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLGB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLGB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLGB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLGB.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
	ACenterLGB.setWrap(false);	
		
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(false);

	//日期格式
	WritableCellFormat DATE_FORMAT1 = new WritableCellFormat(font_nobold_b ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT1.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT1.setWrap(false);
	
	sql = "SELECT erp_user_id from oraddman.wsuser a where USERNAME ='"+UserName+"'";
	Statement st3=con.createStatement();
	ResultSet rs3=st3.executeQuery(sql);
	if (rs3.next())
	{
		ERP_USERID=rs3.getString(1);
	}
	rs3.close();
	st3.close();
	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
	
	//out.println(sheetname[i]);
	sql = " select  count(1) over(order by ooh.header_id desc,ool.line_id desc) cnt ,"+
		  //" upper(Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id)) sales_group,"+  
		  " upper(TSC_OM_Get_Sales_Group(ooh.header_id)) sales_group,"+  
		  " ooh.ORDER_NUMBER,"+
		  " ool.line_number ||'.'||ool.shipment_number line_no,"+
		  " msi.description,"+
		  " ooh.org_id,"+
		  " DECODE(ool.ITEM_IDENTIFIER_TYPE,'CUST',ool.ORDERED_ITEM,'') CUST_ITEM,"+
		  //" nvl(ar.CUSTOMER_NAME_PHONETIC,ar.customer_name) customer,"+
		  " nvl(ar.customer_sname,ar.customer_name) customer,"+  //modify by Peggy 20210610
		  " ar.account_number customer_number,"+ 
		  " ool.CUSTOMER_LINE_NUMBER customer_po,"+
		  " ool.ordered_quantity,"+
		  " to_char(trunc(ool.schedule_ship_date),'yyyy/mm/dd') schedule_ship_date,"+
		  " to_char(trunc(ool.REQUEST_DATE),'yyyy/mm/dd') request_date,"+
		  " to_char(trunc(ooh.ORDERED_DATE),'yyyy/mm/dd') ordered_date,"+
		  " ool.SHIPPING_METHOD_CODE,"+
		  " lc.meaning SHIP_METHOD,"+
		  " ooh.TRANSACTIONAL_CURR_CODE,"+ 
		  " ool.PACKING_INSTRUCTIONS,"+
		  " TERM.NAME,"+
		  " NVL(ool.FOB_POINT_CODE,ooh.FOB_POINT_CODE) fob_point,"+
		  //" Replace(Replace(TSC_GET_REMARK(ooh.HEADER_ID,'REMARKS'),chr(10), chr(32)),chr(13),chr(32))  REMARKS,"+
		  " TSC_GET_MO_REMARK(ooh.HEADER_ID,'REMARKS') REMARKS,"+ //modify by Peggy 20221031
		  " Replace(Replace(TSC_GET_REMARK(ooh.HEADER_ID,'SHIPPING MARKS'),chr(10), chr(32)),chr(13),chr(32))  SHIPMARKS,"+
		  " ool.ATTRIBUTE7 PCMARK,"+  
		  " ool.flow_status_code, "+
		  " ool.CUSTOMER_SHIPMENT_NUMBER CUSTOMER_PO_LINE_NUM,"+
		  " TSC_GET_REMARK_DESC(ooh.HEADER_ID,'SHIPPING MARKS') mark_desc,"+
		  " ool.end_customer_id,"+
		  //" NVL (ar1.customer_name_phonetic, ar1.customer_name) end_customer,"+
		  " NVL(NVL (ar1.customer_sname, ar1.customer_name),ool.attribute13) end_customer,"+  //modify by Peggy 20210610
		  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) as TSC_PROD_GROUP,"+
		  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,21) as TSC_FAMILY,"+
		  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000004) as TSC_PROD_FAMILY,"+
		  " tsc_inv_category(msi.inventory_item_id,msi.organization_id,23) as TSC_Package,"+
		  " tog.description yew_group,"+
		  " substr(ott.NAME,instr(ott.NAME,'_')+1,length(ott.name)) as line_type,"+
		  " addr.address1, "+
		  " (SELECT CASE WHEN substr(ooh.order_number,2,3) ='121' then SAMPLE_SPQ ELSE SPQ end as SPQ FROM TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',CASE when ool.PACKING_INSTRUCTIONS = 'Y' or substr(ooh.order_number,1,4)='1156' then '002' when ool.PACKING_INSTRUCTIONS = 'E' or substr(ooh.order_number,1,4)='1142' THEN '008' when ool.PACKING_INSTRUCTIONS = 'A'  THEN '010' WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003)='PMD' THEN '006'  WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) IN ('SSP','SSD') THEN '005' ELSE '002' END  ))) AS SPQ,"+
		  " (SELECT MOQ  FROM TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.INVENTORY_ITEM_ID,'TS',CASE when ool.PACKING_INSTRUCTIONS = 'Y' or substr(ooh.order_number,1,4)='1156' then '002' when ool.PACKING_INSTRUCTIONS = 'E' or substr(ooh.order_number,1,4)='1142' THEN '008' when ool.PACKING_INSTRUCTIONS = 'A'  THEN '010' WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003)='PMD' THEN '006'  WHEN tsc_inv_category(msi.inventory_item_id,msi.organization_id,1100000003) IN ('SSP','SSD') THEN '005' ELSE '002' END  ))) AS MOQ"+
		  ",ool.ship_to_org_id"+
		  ",end_ar.account_number end_customer_number"+
		  ",to_char(trunc(ool.schedule_ship_date-tsc_get_china_to_tw_days(ool.PACKING_INSTRUCTIONS ,ooh.oRDER_NUMBER,ool.inventory_item_id,null,null,to_char(ooh.creation_date,'yyyymmdd'),NVL(ool.CUSTOMER_LINE_NUMBER,ool.CUST_PO_NUMBER))),'yyyy/mm/dd') factory_totw_date "+  //add by Peggy 20160805
		  ",(select distinct LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) "+
          //" from ar_contacts_v con WHERE con.contact_id=ooh.attribute11  and con.status='A') ship_to_contact"+  //add by Peggy 20170220
		  " from ar_contacts_v con WHERE con.contact_id=nvl(ooh.attribute11,ool.SHIP_TO_CONTACT_ID) ) ship_to_contact"+  //add by Peggy 20180119
		  ",ool.UNIT_SELLING_PRICE"+ //add by Peggy 20170220
		  ",opa.OPERAND LINE_CHARGE"+ //add by Peggy 20170222
		  ",tgp.CARTON_QTY"+  //add by Peggy 20170427
		  ",tgp.CARTON_SIZE"+ //add by Peggy 20170427
		  ",tgp.GW"+          //add by Peggy 20170427
		  ",tgp.NW"+          //add by Peggy 20210219
		  //",round((substr(tgp.CARTON_SIZE,1,instr(REPLACE(lower(tgp.CARTON_SIZE),'x','*'),'*')-1) *substr(tgp.CARTON_SIZE,instr(REPLACE(lower(tgp.CARTON_SIZE),'x','*'),'*')+1,instr(REPLACE(lower(tgp.CARTON_SIZE),'x','*'),'*',-1)-(instr(REPLACE(lower(tgp.CARTON_SIZE),'x','*'),'*')+1))*substr(tgp.CARTON_SIZE,instr(REPLACE(lower(tgp.CARTON_SIZE),'x','*'),'*',-1)+1))/1000/5000,1) as CARTON_M3_WEIGHT"+
		  ",round((substr(tgp.CARTON_SIZE,1,instr(regexp_replace(lower(tgp.CARTON_SIZE),'×|x|X','*'),'*')-1) *substr(tgp.CARTON_SIZE,instr(regexp_replace(lower(tgp.CARTON_SIZE),'×|x|X','*'),'*')+1,instr(regexp_replace(lower(tgp.CARTON_SIZE),'×|x|X','*'),'*',-1)-(instr(regexp_replace(lower(tgp.CARTON_SIZE),'×|x|X','*'),'*')+1))*substr(tgp.CARTON_SIZE,instr(regexp_replace(lower(tgp.CARTON_SIZE),'×|x|X','*'),'*',-1)+1))/1000/5000,1) as CARTON_M3_WEIGHT"+
		  ",case when tgp.CARTON_QTY is null then null else ceil(ool.ordered_quantity/tgp.CARTON_QTY) end as CARTON_NUM"+  //add by Peggy 20170427
		  ",round(case when tgp.CARTON_QTY is null then null else round(ool.ordered_quantity/tgp.CARTON_QTY,2) end * tgp.GW,2) as ACTUL_GW"+  //add by Peggy 20201014		  
		  ",de_addr.address1 as deliver_address"+    //add by Peggy 20171214		  
		  ",bill_addr.address1 as billto_address"+   //add by Peggy 20180320	
		  ",ool.attribute20 hold_shipment_code"+     //add by Peggy 20181227  
		  ",ool.attribute5 hold_reason"+             //add by Peggy 20181227
		  ",to_char(odr_info.creation_date,'yyyy/mm/dd') wippo_creation_date "+  //add by Peggy 20181227
		  ",case when nvl(TSC_OM_check_WMS_Lock(ool.line_id,'LOCK'),'F')='T' then 'Y' else '' end wms_flag"+ //add by Peggy 20200716
		  ",mp.organization_code"+  //add by Peggy 20200807
		  ",ool.tax_code"+//add by Peggy 20200903
		  ",to_char(TSC_GET_OVERDUE_SSD(ool.line_id,null,null),'yyyy/mm/dd') OVERDUE_SSD"+ //add by Peggy 20200807
		  ",case when substr(ooh.ORDER_NUMBER,1,4) in ('1156','1142') or substr(ooh.ORDER_NUMBER,1,1) in ('4','8','7') then 'China' when substr(ooh.ORDER_NUMBER,1,4) in ('1141','1131','1121') then 'Taiwan' when substr(ooh.ORDER_NUMBER,1,4) in ('1214') then case when ool.packing_instructions in ('Y','T') then 'China' else 'Taiwan' end else '' end ship_from_location"+
          ",ooh.transactional_curr_code currency_code"+  //add by Peggy 20201204	
		  ",ool.UNIT_SELLING_PRICE * ool.ordered_quantity * case when ool.ORDER_QUANTITY_UOM ='PCE' then  1 else 1000 end as amt"+ //add by Peggy 20201204	  
		  ",ool.attribute19"+ //add by Peggy 20210106
		  //",to_char(case when upper(Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id)) in ('TSCA','TSCE') then tsce_get_eta_date(lc.meaning,NVL(ool.FOB_POINT_CODE,ooh.FOB_POINT_CODE),substr(ooh.order_number,1,4),ool.packing_instructions,trunc(ool.schedule_ship_date),ooh.sold_to_org_id,null,ool.deliver_to_org_id) else null end,'yyyy/mm/dd') eta_date"+
		  //",to_char(case when upper(Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id)) in ('TSCA','TSCE') then tsce_get_eta_date(lc.meaning,NVL(ool.FOB_POINT_CODE,ooh.FOB_POINT_CODE),substr(ooh.order_number,1,4),ool.packing_instructions,trunc(ool.schedule_ship_date),ooh.sold_to_org_id,null,ool.deliver_to_org_id) else null end,'yyyy/mm/dd') eta_date"+
		  ",to_char(case when upper(TSC_OM_Get_Sales_Group(ooh.header_id)) in ('TSCA','TSCE') then tsce_get_eta_date(lc.meaning,NVL(ool.FOB_POINT_CODE,ooh.FOB_POINT_CODE),substr(ooh.order_number,1,4),ool.packing_instructions,trunc(ool.schedule_ship_date),ooh.sold_to_org_id,null,ool.deliver_to_org_id) else null end,'yyyy/mm/dd') eta_date"+
		  ",msi.segment1 item_name"+ //add by Peggy 20211012
		  ",ool.attribute12 hold_new_ssd"+ //add by Peggy 20211104
		  //",hcsu.location ship_to_location_id"+  //add by Peggy 20211125
		  ",addr.location ship_to_location_id"+  //add by Peggy 20220902
		  ",NVL(TSC_GET_REMARK_DESC(ool.line_id,'Cust Supplier ID','OE_ORDER_LINES'),TSC_GET_REMARK_DESC(ool.first_line_id,'Cust Supplier ID','OE_ORDER_LINES')) cust_supplier_id "+ //add by Peggy 20220208		  
		  ",ool.invoice_to_org_id"+	  //add by Peggy 20220901
		  ",ool.deliver_to_org_id"+   //add by Peggy 20220901	  
		  ",de_addr.location deliver_to_location_id"+ //add by Peggy 20220902
		  ",bill_addr.location invoice_to_location_id"+ //add by Peggy 20220902
		  ",case when ool.end_customer_id in (762292,761295) or ooh.sold_to_org_id in (762292,761295) then ool.customer_job else '' end customer_purchase_item_no"+    //add by Peggy 20221026
		  ",nvl(ool.attribute18,'') quote_number"+ //add by Peggy 20230426
		  //",tsc_get_quote_info(ool.attribute18) Quote_Creater"+ //add by Peggy 20230615
		  ",(select distinct createdby from tsc_om_ref_quotenet x where x.quoteid=ool.attribute18) Quote_Creater"+ //add by Peggy 20230907
		  ",ool.attribute1 packinglistnumber"+//add by Peggy 20230619
		  ",ooh.SOLD_TO_ORG_ID"+ //add by Peggy 20230824
		  ",tsc_get_china_to_tw_days(ool.PACKING_INSTRUCTIONS ,ooh.oRDER_NUMBER,ool.inventory_item_id,null,null,to_char(ooh.creation_date,'yyyymmdd'),NVL(ool.CUSTOMER_LINE_NUMBER,ool.CUST_PO_NUMBER)) totw_days"+ //add by Peggy 20230828
		  ",fact.manufactory_no plant_code"+  //add by Peggy 20240403
		  ",fact.manufactory_name plant_name"+ //add by Peggy 20240403
		  //",(select attribute3 from inv.mtl_system_items_b msix where msix.organization_id=49 and msix.inventory_item_id=ool.inventory_item_id) plant_code"+ //add by Peggy 20230825
		  //",ROUND(ool.ordered_quantity  * ool.UNIT_SELLING_PRICE * nvl((SELECT CONVERSION_RATE FROM GL_DAILY_RATES_V WHERE USER_CONVERSION_TYPE='TSC-Export' AND TO_CURRENCY='TWD' AND CONVERSION_DATE =TRUNC(ooh.ordered_date) AND FROM_CURRENCY=ooh.transactional_curr_code),1),0) TWD_AMT"+ //add by Peggy 20230822
		  ",ROUND(ool.ordered_quantity  * ool.UNIT_SELLING_PRICE * nvl((SELECT CONVERSION_RATE FROM GL_DAILY_RATES_V WHERE USER_CONVERSION_TYPE='TSC-Export' AND TO_CURRENCY='TWD' AND CONVERSION_DATE =TRUNC(sysdate) AND FROM_CURRENCY=ooh.transactional_curr_code),1),0) TWD_AMT"+ //add by Peggy 20240219 改成sysdate
		  ",case when upper(TSC_OM_Get_Sales_Group(ooh.header_id))='TSCA' THEN TSCA_GET_ORDER_SSD(substr(ooh.ORDER_NUMBER,1,4),lc.meaning,to_char(trunc(ool.REQUEST_DATE),'yyyymmdd'),'CRD',trunc(sysdate),null) else '' end TSCA_PULLIN_SSD, tsc_get_item_coo(msi.inventory_item_id) coo"; //add by Peggy 20240217
	if (ACTTYPE.equals("TSCE"))
	{
		sql +=",so_m.PUST_OUT_FREQUENCY,so_m.CANCELLATION_FREQUENCY"; //add by Peggy 20230526
	}
	sql += " from oe_order_headers_all ooh "+
		  "      ,(select x.*,(select line_id from oe_order_lines_all y where y.header_id=x.header_id and y.line_number=x.line_number and y.shipment_number=1) first_line_id  from oe_order_lines_all x) ool"+  //for cust supplier id issue by Peggy 20220209
		  "      ,JTF_RS_SALESREPS jrs "+
		  "      ,MTL_SYSTEM_ITEMS_B msi"+
		  //"      ,AR_CUSTOMERS ar,"+
		  "      ,tsc_customer_all_v ar,"+ //modify by Peggy 20210610
		  "      ra_terms_tl term ,"+
		  "      (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') lc,"+
		  //"      ar_customers ar1,"+
		  "      tsc_customer_all_v ar1,"+ //modify by Peggy 20210610		  
		  //"      (select * from AR.HZ_CUST_SITE_USES_ALL where site_use_code = 'SHIP_TO') hcsu,"+
		  "      (select * from tsc_om_group where org_id=325) tog,"+
		  "      (SELECT * FROM OE_TRANSACTION_TYPES_TL WHERE LANGUAGE ='US') ott,"+
		  "      (select hcsu.site_use_id,hl.address1, hcsu.location,hcsu.attribute1 from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
		  "      where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
		  "      and hcas.party_site_id = hps.party_site_id  "+
		  "      and hps.location_id =hl.location_id "+
		  "      and hcsu.site_use_code = 'SHIP_TO'"+
		  "      and hcsu.status = 'A') addr"+
		  //"      ,ar_customers end_ar"+
		  "      ,tsc_customer_all_v end_ar"+ //modify by Peggy 20210610
		  "      ,(SELECT A.LINE_ID,A.OPERAND  FROM ont.oe_price_adjustments a  where LIST_LINE_TYPE_CODE='FREIGHT_CHARGE') opa"+
		  "      ,table(TSC_GET_PROD_PACKAGE_INFO(ool.line_id,null,null,'FACTORY')) tgp"+
		  "      ,(select hcsu.site_use_id,hl.address1,hcsu.location,hcsu.attribute1 from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
		  "      where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
		  "      and hcas.party_site_id = hps.party_site_id  "+
		  "      and hps.location_id =hl.location_id "+
		  "      and hcsu.site_use_code = 'DELIVER_TO'"+
		  "      and hcsu.status = 'A') de_addr"+ //add by Peggy 20171214	
		  "      ,(select hcsu.site_use_id,hl.address1,hcsu.location,hcsu.attribute1 from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
		  "      where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
		  "      and hcas.party_site_id = hps.party_site_id  "+
		  "      and hps.location_id =hl.location_id "+
		  "      and hcsu.site_use_code = 'BILL_TO'"+
		  "      and hcsu.status = 'A') bill_addr"+ //add by Peggy 20180320	 
		  "      ,(select oha.order_number,case when substr(oha.order_number,1,4) in ('1156','4121','4131','4141','1214') then ywa.order_line_id else to_number(tsc_get_hqorder_info(325,327,ywa.order_line_id,'LINE_ID')) end as order_line_id,min(trunc(wip.creation_date)) creation_date"+
          "       from yew_workorder_all ywa ,wip.wip_discrete_jobs wip,ont.oe_order_headers_all oha"+
          "       where ywa.statusid<>'050'"+
          "       and ywa.order_line_id >0"+
          "       and wip.wip_entity_id=ywa.wip_entity_id"+
          "       and ywa.order_header_id=oha.header_id"+
          //"       group by oha.order_number,ywa.order_line_id"+
		  "       group by oha.order_number,case when substr(oha.order_number,1,4) in ('1156','4121','4131','4141','1214') then ywa.order_line_id else to_number(tsc_get_hqorder_info(325,327,ywa.order_line_id,'LINE_ID')) end"+ //modify by Peggy 20220826
          "       union all "+
          "       select x.order_number,y.line_id order_line_id,min(trunc(d.creation_date)) creation_date"+
          "       from po.po_requisition_lines_all a,"+
          "       po_line_locations_all b,"+
          "       po.po_requisition_headers_all c,"+
          "       po_headers_all d,"+
          "       ont.oe_order_headers_all x,"+
          "       ont.oe_order_lines_all y"+
          "       where x.header_id = y.header_id"+
          "       and y.FLOW_STATUS_CODE not in ('CANCELLED')"+
          "       and y.packing_instructions IN ('I','E')"+
          "       and TSC_INV_Category(y.inventory_item_id,y.ship_from_org_id,1100000003) IN ('SSD','PRD-Subcon')"+
          "       and x.order_number || '.' || y.line_number =a.note_to_receiver"+
          "       and a.requisition_header_id = c.requisition_header_id"+
          "       and a.line_location_id = b.line_location_id(+)"+
          "       and b.po_header_id = d.po_header_id(+)"+
          "       group by  x.order_number,y.line_id ";
	if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") >=0) 
	{		  
    	sql +="   union all"+
          "       select to_number(SALES_ORDER_NUMBER) order_number,to_number(SALES_ORDER_LINE_ID) order_line_id ,min(to_date(MANUFACTURING_DATE,'yyyy/mm/dd')) creation_date from insitea01_oltp.TSC_SALES_ORDER_VIEW@prod_a01oltp a "+
          "       group by  SALES_ORDER_NUMBER,SALES_ORDER_LINE_ID";
	}
	sql +="	  ) odr_info "+  //add by Peggy 20181227
		  ",mtl_parameters mp"+//add by Peggy 20200807
		  ",(select distinct msix.inventory_item_id,tm.manufactory_no,tm.manufactory_name "+
          " from inv.mtl_system_items_b msix,oraddman.tsprod_manufactory tm "+
          " where msix.organization_id=49 "+
          " and msix.attribute3=tm.manufactory_no) fact";
	if (ACTTYPE.equals("TSCE"))
	{
    	sql += ",TABLE(TSC_GET_SO_MOVE_FREQUENCY(ool.line_id)) so_m";
	}
	sql +=" WHERE ooh.ORG_ID IN (906,325,41)"+ //add by Peggy 20210601
		  " AND ooh.HEADER_ID = ool.HEADER_ID(+)"+
		  " AND ooh.SALESREP_ID = jrs.SALESREP_ID(+)"+
		  " AND ool.INVENTORY_ITEM_ID = msi.INVENTORY_ITEM_ID"+
		  " AND msi.ORGANIZATION_ID = 43"+
		  " AND ooh.SOLD_TO_ORG_ID = ar.CUSTOMER_ID"+
		  " AND ool.CANCELLED_FLAG != 'Y'"+
		  " AND ool.ship_from_org_id=mp.organization_id"+//add by Peggy 20200807
		  " AND nvl(ool.ORDERED_QUANTITY,0) - nvl(ool.SHIPPED_QUANTITY,0)>0"+
		  " AND ool.FLOW_STATUS_CODE IN ('ENTERED','BOOKED','AWAITING_SHIPPING','AWAITING_APPROVE')"+
		  " AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017') "+
		  " AND ool.INVENTORY_ITEM_ID not in  (29570,29562,29560)"+
		  " AND term.language='US' "+
		  " AND nvl(ool.payment_term_id,ooh.payment_term_id) =term.term_id "+
		  " AND ooh.ORG_ID=jrs.ORG_ID(+)"+
		  " AND ool.SHIPPING_METHOD_CODE = lc.lookup_code (+)"+
		  " AND ool.end_customer_id = ar1.customer_id(+)"+
		  //" AND ool.ship_to_org_id = hcsu.site_use_id(+)"+
		  //" AND hcsu.attribute1=tog.group_id(+)"+
		  " AND ool.line_type_id= ott.transaction_type_id(+)"+
		  " AND ool.ship_to_org_id=addr.site_use_id(+)"+
		  " AND addr.attribute1=tog.group_id(+)"+
		  " AND ool.deliver_to_org_id=de_addr.site_use_id(+)"+ //add by Peggy 20171214
		  " AND ool.invoice_to_org_id=bill_addr.site_use_id(+)"+ //add by Peggy 2080320
		  " AND SUBSTR(ooh.ORDER_NUMBER,2,2) <>'19'"+			  
		  " AND ool.end_customer_id=end_ar.customer_id(+)"+
		  " AND ool.LINE_ID=opa.LINE_ID(+)"+
//		  " AND ooh.org_id = case  WHEN SUBSTR( OOH.ORDER_NUMBER,1,1) =1  then 41 else ooh.org_id end"+
		  " AND ool.line_id=odr_info.order_line_id(+)"+
		  " AND ool.inventory_item_id=fact.inventory_item_id"; //add by Peggy 20240403
		  //" AND not exists (select 1 from ont.oe_order_headers_all x where org_id = 325 and substr(x.order_number,1,4) in ('1141','1131','1121') and x.header_id=ooh.header_id)";
	if (!salesGroup.equals("--") && !salesGroup.equals(""))
	{
		if (ACTTYPE.equals("TSCR"))
		{
			//sql += " and  Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id) in ('TSCI','TSCR-ROW')";
			sql += " and  TSC_OM_Get_Sales_Group(ooh.header_id) in ('TSCI','TSCR-ROW')";
		}
		else
		{
			//sql += " and  Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id)='"+salesGroup+"'";
			sql += " and  TSC_OM_Get_Sales_Group(ooh.header_id)='"+salesGroup+"'";			
		}
	}
	else if (UserRoles.indexOf("admin")<0)
	{
		sql += " and exists (select 1 from (SELECT tog.group_name "+
				 " FROM tsc_om_group_salesrep togs,"+
				 " ahr_employees_all aea,"+
				 " jtf_rs_salesreps jrs,"+
				 " fnd_user us,"+
				 " tsc_om_group tog,"+
				 " oraddman.wsuser ow"+
				 //" WHERE  aea.employee_no = jrs.salesrep_number"+
				 " WHERE  (aea.employee_no = jrs.salesrep_number or us.user_name =jrs.salesrep_number)"+  //for forecase demain issue by Peggy 20230407
				 " AND us.employee_id = aea.person_id"+
				 " AND togs.salesrep_id = jrs.salesrep_id"+
				 " AND togs.GROUP_ID = tog.GROUP_ID"+
				 " AND (tog.end_date IS NULL OR tog.end_date > TRUNC (SYSDATE))"+
				 " AND us.user_id=ow.ERP_USER_ID"+
				 " AND ow.username='"+UserName+"'"+
				 " UNION ALL"+
				 " SELECT tog.group_name"+
				 " FROM tsc_om_group_salesrep togs,"+
				 " fnd_user us, "+
				 " tsc_om_group tog,"+
				 " oraddman.wsuser ow"+
				 " WHERE  togs.user_id = us.user_id"+
				 " AND togs.GROUP_ID = tog.GROUP_ID"+
				 " AND (tog.end_date IS NULL OR tog.end_date > TRUNC (SYSDATE))"+
				 " AND us.user_id=ow.ERP_USER_ID"+
				 " AND ow.username='"+UserName+"'"+
				 " UNION ALL"+
				 " SELECT 'SAMPLE' group_name "+
				 " FROM oraddman.tssales_area A,oraddman.tsrecperson B,oraddman.wsuser C"+
				 " WHERE A.sales_area_no ='020'"+
				 " AND A.sales_area_no=B.tssaleareano "+
				 " AND B.username=C.username "+
				 " AND NVL(C.lockflag,'Y')='N'"+
				 //" AND c.username='"+UserName+"') x where x.group_name=Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id))";	
				 " AND c.username='"+UserName+"') x where x.group_name=TSC_OM_Get_Sales_Group(ooh.header_id))";	
	}
	if (!CUST.equals(""))
	{
		sql += " and (upper(nvl(ar.customer_sname,ar.customer_name)) like '%"+CUST.toUpperCase()+"%'"+
			   "   or upper(NVL (ar1.customer_sname, ar1.customer_name)) like '%"+CUST.toUpperCase()+"%'"+
			   "   or upper(TSC_GET_REMARK_DESC(ooh.HEADER_ID,'SHIPPING MARKS')) like '%"+CUST.toUpperCase()+"%'"+
			   "   or upper(case when instr(ool.CUSTOMER_LINE_NUMBER,'(')>0  then substr(ool.CUSTOMER_LINE_NUMBER,instr(ool.CUSTOMER_LINE_NUMBER,'(')+1,instr(ool.CUSTOMER_LINE_NUMBER,')')-instr(ool.CUSTOMER_LINE_NUMBER,'(')-1) else ool.CUSTOMER_LINE_NUMBER end) like '%"+CUST.toUpperCase()+"%'"+
			   "   )";
	}
	if (!ITEMDESC.equals(""))
	{
		sql += " and msi.DESCRIPTION like '"+ITEMDESC+"%'";
	}	
	if (!MONO.equals(""))
	{
		sql += " and ooh.ORDER_NUMBER = '"+MONO+"'";
	}
	//if (ORDERTYPE.equals("INSITE") || ERP_USERID.equals("5870"))
	if (ORDERTYPE.equals("INSITE"))
	{	
		sql += " and substr(ooh.ORDER_NUMBER,2,3) in ('131','121')";
	}
	else if (ORDERTYPE.equals("OUTSITE"))
	{
		sql += " and substr(ooh.ORDER_NUMBER,2,3) not in ('214','131','121')";
	}
	else if (ORDERTYPE.equals("CONSIGNMENT"))
	{
		sql += " and substr(ooh.ORDER_NUMBER,2,3) in ('214')";
	}
	else if (ERP_USERID.equals("15196"))
	{
		sql += " and (substr(ooh.ORDER_NUMBER,2,3)  not in ('131','121') or  substr(ooh.ORDER_NUMBER,2,3) in ('214')) ";
	}
	if (!SDATE.equals("") || !EDATE.equals(""))
	{
		sql += " and ool.schedule_ship_date  BETWEEN TO_DATE('"+(SDATE.equals("")?"trunc(add_months(sysdate,-48))":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?"trunc(add_months(sysdate,24))":EDATE)+"','yyyymmdd')+0.99999";
	}	
	if (!SHIPPINGMETHOD.equals("--") && !SHIPPINGMETHOD.equals(""))  //add by Peggy 20201019
	{
		sql += " and ool.SHIPPING_METHOD_CODE='"+SHIPPINGMETHOD+"'";
	}
	if (!SHIPFROMLOCATION.equals(""))  //add by Peggy 20201019
	{
		sql += " and case when substr(ooh.ORDER_NUMBER,1,4) in ('1156','1142') or substr(ooh.ORDER_NUMBER,1,1) in ('4','8','7') then 'China' when substr(ooh.ORDER_NUMBER,1,4) in ('1141','1131','1121') then 'Taiwan' when substr(ooh.ORDER_NUMBER,1,4) in ('1214') then case when ool.packing_instructions in ('Y','T') then 'China' else 'Taiwan' end else '' end='"+SHIPFROMLOCATION+"'";
	}	
//	sql += "order by 1 desc,2,3,4";
	sql = "select * from (".concat(sql).concat(") a \n"+
			"where a.org_id = case  WHEN SUBSTR(a.ORDER_NUMBER,1,1) =1  then 41 else a.org_id end \n"+
			" order by 1 desc,2,3,4"
	);
//	out.println(sql);
	Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY); 
	ResultSet rs=statement.executeQuery(sql);
		
	String sheetname [] = wwb.getSheetNames();
	for (int i =0 ; i < sheetname.length ; i++)
	{	
		reccnt=0;col=0;row=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings sst = ws.getSettings(); 
		sst.setSelected();
		sst.setVerticalFreeze(1);  //凍結窗格
		for (int g =1 ; g <=9 ;g++ )
		{
			sst.setHorizontalFreeze(g);
		}	
		ws.setRowView(i,200);
		//Sales Group
		ws.addCell(new jxl.write.Label(col, row, "Sales Group" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;					

		//MO#
		ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
		ws.setColumnView(col,14);	
		col++;					
			
		//Line#
		ws.addCell(new jxl.write.Label(col, row, "Line#" , ACenterBL));
		ws.setColumnView(col,8);	
		col++;	
					
		//Item Desc
		ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	
		
		//TSC_Package
		ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;	
		
		if (!ACTTYPE.equals(""))  //add by Peggy 20200310
		{
			//Customer Number
			ws.addCell(new jxl.write.Label(col, row, "Customer Number" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
		}		
		
		//Customer
		ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	

		//Customer PO
		ws.addCell(new jxl.write.Label(col, row, "Customer PO" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	

		//Order Qty
		ws.addCell(new jxl.write.Label(col, row, "Order Qty" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	

		//Schedule Ship Date
		ws.addCell(new jxl.write.Label(col, row, "Schedule Ship Date" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	

		//嘜頭
		ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;	
		
		//CRD
		ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;
		
		//Ordered Date
		ws.addCell(new jxl.write.Label(col, row, "Order Date" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;
					
		//Customer ITEM
		ws.addCell(new jxl.write.Label(col, row, "Customer P/N" , ACenterBL));
		ws.setColumnView(col,25);	
		col++;				
		
		//Shipping Method
		ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;	

		//Packing Instrucations
		ws.addCell(new jxl.write.Label(col, row, "Packing Instrucations" , ACenterBL));
		ws.setColumnView(col,8);	
		col++;	
				
		//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
		if (!ACTTYPE.equals("TSCC"))					
		{
			//Payment Term
			ws.addCell(new jxl.write.Label(col, row, "Payment Term" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;
			
			//Fob Term
			ws.addCell(new jxl.write.Label(col, row, "Fob Term" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;
	
			//End Customer
			ws.addCell(new jxl.write.Label(col, row, "End Customer" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;
			
			if (ACTTYPE.equals("TSCR") || (salesGroup!=null && (salesGroup.equals("TSCI") || salesGroup.equals("TSCR-ROW"))))					
			{
				//End Customer
				ws.addCell(new jxl.write.Label(col, row, "Quote Creater" , ACenterBL));
				ws.setColumnView(col,16);	
				col++;			
			}			
		}
				
		//Order Status
		ws.addCell(new jxl.write.Label(col, row, "Order Status" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;
		
		//Shipping Marks
		ws.addCell(new jxl.write.Label(col, row, "Shipping Marks" , ACenterBL));
		ws.setColumnView(col,50);	
		col++;

		//Ship to location id
		ws.addCell(new jxl.write.Label(col, row, "Ship To Location ID" , ACenterBL));
		ws.setColumnView(col,15);	
		col++;

		//End Customer Number
		ws.addCell(new jxl.write.Label(col, row, "End Customer Number" , ACenterBL));
		ws.setColumnView(col,30);	
		col++;							
			
		//Remarks
		ws.addCell(new jxl.write.Label(col, row, "Remarks" , ACenterBL));
		ws.setColumnView(col,50);	
		col++;
			
		//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
		if (!ACTTYPE.equals("TSCC"))					
		{			
			//spq
			ws.addCell(new jxl.write.Label(col, row, "SPQ" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//moq
			ws.addCell(new jxl.write.Label(col, row, "MOQ" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
		}
			
		//TSC_PROD_GROUP
		ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;		
		
		//TSC_Family
		ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;	
			
		//TSC_prod_Family
		ws.addCell(new jxl.write.Label(col, row, "TSC Prod Family" , ACenterBL));
		ws.setColumnView(col,20);	
		col++;		
		
		//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
		if (!ACTTYPE.equals("TSCC"))					
		{		
			//Ship to Contact
			ws.addCell(new jxl.write.Label(col, row, "Ship to Contact" , ACenterBL));
			ws.setColumnView(col,40);	
			col++;
		}
			
		//ship to
		ws.addCell(new jxl.write.Label(col, row, "Ship to Address" , ACenterBL));
		ws.setColumnView(col,50);	
		col++;		
		
		//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
		if (!ACTTYPE.equals("TSCC"))					
		{		
			//line type
			ws.addCell(new jxl.write.Label(col, row, "Line Type" , ACenterBL));
			ws.setColumnView(col,30);	
			col++;
			
			//yew group
			ws.addCell(new jxl.write.Label(col, row, "Yew Group" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
	
			//工廠回T出貨日
			ws.addCell(new jxl.write.Label(col, row, "工廠回T出貨日" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
			
			//Line Charge
			ws.addCell(new jxl.write.Label(col, row, "Line Charge" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
		}
		
		if (ACTTYPE.equals("") || ACTTYPE.equals("TSCE") || ACTTYPE.equals("TSCA") || ACTTYPE.equals("TSCR"))
		{
			//滿箱數量
			ws.addCell(new jxl.write.Label(col, row, "滿箱數量" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
	
			//預估出貨箱數
			ws.addCell(new jxl.write.Label(col, row, "預估出貨箱數" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
	
			//淨重
			ws.addCell(new jxl.write.Label(col, row, "淨重" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
				
			//毛重
			ws.addCell(new jxl.write.Label(col, row, "毛重" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
	
			//Total Qty GW(實際出貨箱數*毛重),add by Peggy 20201014
			ws.addCell(new jxl.write.Label(col, row, "Total Qty GW\n(實際出貨箱數*毛重)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//材積
			ws.addCell(new jxl.write.Label(col, row, "材積" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//"材積重 M3(volume)
			ws.addCell(new jxl.write.Label(col, row, "材積重 M3(volume)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;				
		}

		//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
		if (!ACTTYPE.equals("TSCC"))					
		{		
			if (ACTTYPE.equals("TSCE"))
			{
				//ship to
				ws.addCell(new jxl.write.Label(col, row, "Bill to Location ID" , ACenterBL));
				ws.setColumnView(col,6);	
				col++;		
			}
					
			//bill to
			ws.addCell(new jxl.write.Label(col, row, "Bill to Address" , ACenterBL));
			ws.setColumnView(col,50);	
			col++;	
			
			if (ACTTYPE.equals("TSCE"))
			{
				//ship to
				ws.addCell(new jxl.write.Label(col, row, "Deliver to Location ID" , ACenterBL));
				ws.setColumnView(col,6);	
				col++;		
			}			
					
			//deliver to
			ws.addCell(new jxl.write.Label(col, row, "Deliver to Address" , ACenterBL));
			ws.setColumnView(col,50);	
			col++;		
		}	

		//hold
		ws.addCell(new jxl.write.Label(col, row, "HOLD" , ACenterBL));
		ws.setColumnView(col,15);	
		col++;	
		
		//hold new SSD
		ws.addCell(new jxl.write.Label(col, row, "FCST Ship Date" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;					

		//工單/採購下單日
		ws.addCell(new jxl.write.Label(col, row, "工單/採購下單日" , ACenterBL));
		ws.setColumnView(col,15);	
		col++;		
		
		//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
		if (!ACTTYPE.equals("TSCC"))					
		{		
			//customer po line number,add by Peggy 20190408
			ws.addCell(new jxl.write.Label(col, row, "Cust PO Line Number" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;		
			
			//WMS FLAG,add by Peggy 20200716
			ws.addCell(new jxl.write.Label(col, row, "WMS Flag" , ACenterBL));
			ws.setColumnView(col,7);	
			col++;		
			
			//Overdue/Early warning New SSD ,add by Peggy 20200807
			ws.addCell(new jxl.write.Label(col, row, "Overdue/Early warning New SSD " , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
			
			//Warehouse,add by Peggy 20200807
			ws.addCell(new jxl.write.Label(col, row, "Warehouse" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
			
			//tax code,add by Peggy 20200903
			ws.addCell(new jxl.write.Label(col, row, "Tax Code" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;		
					
			//Ship-From Location(China / Taiwan)
			ws.addCell(new jxl.write.Label(col, row, "Ship-From Location\n(China / Taiwan)" , ACenterBL));
			ws.setColumnView(col,10);
			col++;
		}
				
		if (ACTTYPE.equals("TSCE"))
		{
			//U/P
			ws.addCell(new jxl.write.Label(col, row, "U/P" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
			
			//QUOTE NUMBER
			ws.addCell(new jxl.write.Label(col, row, "Quote Number" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;			
			
			//Currency
			ws.addCell(new jxl.write.Label(col, row, "Currency" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;
				
			//Order Amt
			ws.addCell(new jxl.write.Label(col, row, "Order	AMT" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	

			//ETA DATE
			ws.addCell(new jxl.write.Label(col, row, "ETA DATE" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
			
			//SUPPLIER Number
			ws.addCell(new jxl.write.Label(col, row, "Supplier Number " , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//22D/30D,add by Peggy 20220901
			ws.addCell(new jxl.write.Label(col, row, "22D/30D" , ACenterBL));
			ws.setColumnView(col,35);	
			col++;		
			
			//PC REMARK,add by Peggy 20230107
			ws.addCell(new jxl.write.Label(col, row, "PC Remarks" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;		
			
			//push out frequency,add by Peggy 20230526
			ws.addCell(new jxl.write.Label(col, row, "Push out frequency" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;
			
			//cancellation frequency,add by Peggy 20230526
			ws.addCell(new jxl.write.Label(col, row, "Cancellation frequency" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;
			
			//Packing List Number,add by Peggy 20230619
			ws.addCell(new jxl.write.Label(col, row, "Packing List Number" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;																	
		}	
		
		//add by Peggy 20210106
		if (ACTTYPE.equals("TSCC") && RPTTYPE.equals("OUTSIDE"))
		{
			//Delivery to Branch office
			ws.addCell(new jxl.write.Label(col, row, "Delivery to Branch office" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
		}
		
		if (ACTTYPE.equals("TSCC"))
		{		
			//22D/30D,add by Peggy 20211012
			ws.addCell(new jxl.write.Label(col, row, "22D/30D" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
			
			//Fob Term
			ws.addCell(new jxl.write.Label(col, row, "Fob Term" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;
			
			//Ship to Contact
			ws.addCell(new jxl.write.Label(col, row, "Ship to Contact" , ACenterBL));
			ws.setColumnView(col,40);	
			col++;											

			//客戶採購項目代碼
			ws.addCell(new jxl.write.Label(col, row, "客戶採購項目代碼" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;											
		}
			
		//add by Peggy 20230821
		if (UserName.startsWith("JUNE") || UserRoles.indexOf("admin")>=0 || ACTTYPE.equals("TSCE"))
		{ 
			ws.addCell(new jxl.write.Label(col, row, "Order Amount(TWD)" , ACenterBL));  //add tsce by Peggy 20240219
			ws.setColumnView(col,8);	
			col++;							

			ws.addCell(new jxl.write.Label(col, row, "Pull in New SSD" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;			
		}
		
		if (ACTTYPE.equals("TSCA")) //add by Peggy 20240219
		{	
			ws.addCell(new jxl.write.Label(col, row, "Order Amount" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;			
		}
		ws.addCell(new jxl.write.Label(col, row, "Plant Name" , ACenterBL));
		ws.setColumnView(col,8);	
		col++;																		
		row++;
		
		
		if (rs.isBeforeFirst() ==false) rs.beforeFirst();
		while (rs.next()) 
		{ 	
			if (sheetname[i].equals(v_sample_order))	
			{
				//sql += " and substr(ooh.ORDER_NUMBER,2,3) in ('121')";
				if (!rs.getString("ORDER_NUMBER").substring(1,4).equals("121")) continue;
			}
			else if (sheetname[i].equals(v_inside_order))
			{
				//sql += " and substr(ooh.ORDER_NUMBER,2,3) in ('131')";	
				if (!rs.getString("ORDER_NUMBER").substring(1,4).equals("131")) continue;			
			}
			else if (sheetname[i].equals(v_outside_order))	
			{
				//sql += " and substr(ooh.ORDER_NUMBER,2,3) not in ('214','121','131') and upper(Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id)) <>'TSC-FSC'";
				//if (rs.getString("ORDER_NUMBER").substring(1,4).equals("214") || rs.getString("ORDER_NUMBER").substring(1,4).equals("121")|| rs.getString("ORDER_NUMBER").substring(1,4).equals("131") || rs.getString("SALES_GROUP").equals("TSCC-FSC")) continue;
				if (rs.getString("ORDER_NUMBER").substring(1,4).equals("214") || rs.getString("ORDER_NUMBER").substring(1,4).equals("121")|| rs.getString("ORDER_NUMBER").substring(1,4).equals("131") || rs.getString("SALES_GROUP").equals("TSCC-FSC") || rs.getString("customer_number").equals("25071")) continue;
			}	
			else if (sheetname[i].equals(v_consignment_order))	
			{
				//sql += " and substr(ooh.ORDER_NUMBER,2,3) in ('214')";
				if (!rs.getString("ORDER_NUMBER").substring(1,4).equals("214")) continue;	
			}		
			else if (sheetname[i].equals(v_fsc_order))	
			{
				//sql += " and upper(Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id)) ='TSC-FSC'";
				//if (!rs.getString("SALES_GROUP").equals("TSCC-FSC")) continue;
				if (!rs.getString("SALES_GROUP").equals("TSCC-FSC") || rs.getString("customer_number").equals("25071")) continue;
			}		
			else if (sheetname[i].equals(v_onsemi_order)) //add by Peggy 20170929
			{
				if (!rs.getString("customer_number").equals("25071")) continue;
			}				
			col=0;
			//Sales Group
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_GROUP"),ALeftL));
			col++;					
			//MO#
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_NUMBER"), ACenterL));
			col++;					
			//Line#
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO") , ACenterL));
			col++;	
			//Item Desc
			ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION") , ALeftL));
			col++;	
			//TSC_Package
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE") , ALeftL));
			col++;	
			if (!ACTTYPE.equals("")) //add by Peggy 20200310
			{					
				//Customer Number
				ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_number") , ALeftL));
				col++;	
			}
			//Customer
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER") , ALeftL));
			col++;	
			//Customer PO
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_PO"), ALeftL));
			col++;	
			//Order Qty
			if (rs.getString("ORDERED_QUANTITY")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ORDERED_QUANTITY")).doubleValue(), ARightL));
			}
			col++;	
			//Schedule Ship Date
			if (rs.getString("SCHEDULE_SHIP_DATE")==null)
			{		
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
			}
			col++;	
			//嘜頭
			ws.addCell(new jxl.write.Label(col, row, rs.getString("MARK_DESC")  , ALeftL));
			col++;				
			//CRD
			if (rs.getString("REQUEST_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("REQUEST_DATE")) ,DATE_FORMAT));
			}
			col++;
			//Ordered Date
			if (rs.getString("ORDERED_DATE")==null)
			{		
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ORDERED_DATE")) ,DATE_FORMAT));
			}
			col++;		
			//Customer ITEM
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_ITEM") , ALeftL));
			col++;				
			//Shipping Method
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIP_METHOD") , ALeftL));
			col++;	
			//Packing Instrucations
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKING_INSTRUCTIONS")  ,ACenterL));
			col++;	
			//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
			if (!ACTTYPE.equals("TSCC"))					
			{			
				//Payment Term
				ws.addCell(new jxl.write.Label(col, row, rs.getString("NAME")  , ALeftL));
				col++;
				//Fob Term
				ws.addCell(new jxl.write.Label(col, row, rs.getString("FOB_POINT")  ,ALeftL));
				col++;
				//End Customer
				ws.addCell(new jxl.write.Label(col, row, rs.getString("END_CUSTOMER")  , ALeftL));
				col++;
				if (ACTTYPE.equals("TSCR") || (salesGroup!=null && (salesGroup.equals("TSCI") || salesGroup.equals("TSCR-ROW")))) 				
				{
					//Quote Creater
					ws.addCell(new jxl.write.Label(col, row, rs.getString("QUOTE_CREATER")  , ALeftL));  //add by Peggy 20230615
					col++;				
				}				
			}
			
			//Order Status
			ws.addCell(new jxl.write.Label(col, row, rs.getString("FLOW_STATUS_CODE")  , ALeftL));
			col++;
			//Shipping Marks
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPMARKS")  , ALeftL));
			col++;
			//ship to location id
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIP_TO_LOCATION_ID")  , ALeftL));
			col++;
			//end customer number
			ws.addCell(new jxl.write.Label(col, row, rs.getString("END_CUSTOMER_NUMBER")  , ALeftL));
			col++;
			//Remarks
			ws.addCell(new jxl.write.Label(col, row, rs.getString("REMARKS")  , ALeftL));
			col++;	
			//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
			if (!ACTTYPE.equals("TSCC"))					
			{									
				//spq
				ws.addCell(new jxl.write.Label(col, row, rs.getString("spq")  , ARightL));
				col++;	
				//moq
				ws.addCell(new jxl.write.Label(col, row, rs.getString("MOQ") , ARightL));
				col++;	
			}
			//TSC_PROD_GROUP
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP") , ALeftL));
			col++;		
			//TSC_Family
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_FAMILY") , ALeftL));
			col++;	
			//TSC_prod_Family
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_FAMILY") , ALeftL));
			col++;	
			//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
			if (!ACTTYPE.equals("TSCC"))					
			{				
				//ship to contact
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("ship_to_contact")==null?"":rs.getString("ship_to_contact")) , ALeftL));  //add by Peggy 20170220
				col++;					
			}
			
			//ship to
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ADDRESS1") , ALeftL));
			col++;	
			
			//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
			if (!ACTTYPE.equals("TSCC"))					
			{				
				//line type
				ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_TYPE") , ALeftL));
				col++;
				//yew group
				ws.addCell(new jxl.write.Label(col, row, rs.getString("YEW_GROUP") , ALeftL));
				col++;	
				//工廠回T出貨日,add by Peggy 20160805
				if (rs.getString("SCHEDULE_SHIP_DATE")==null || rs.getString("factory_totw_date")==null || rs.getString("SCHEDULE_SHIP_DATE").equals(rs.getString("factory_totw_date")) )  
				{		
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("factory_totw_date")) ,DATE_FORMAT));
				}	
				col++;
				//line charge
				if (rs.getString("line_charge")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("line_charge")).doubleValue(), ARightL));
				}
				col++;	
			}
			if (ACTTYPE.equals("") || ACTTYPE.equals("TSCE") || ACTTYPE.equals("TSCA") || ACTTYPE.equals("TSCR"))
			{			
				//滿箱數量				
				if (rs.getString("carton_qty")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("carton_qty")).doubleValue(), ARightL));
				}
				col++;					
				//預估出貨箱數
				if (rs.getString("carton_num")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("carton_num")).doubleValue(), ARightL));
				}
				col++;	
				//淨重			
				if (rs.getString("nw")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("nw")).doubleValue(), ARightL));
				}
				col++;						
				//毛重			
				if (rs.getString("gw")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("gw")).doubleValue(), ARightL));
				}
				col++;	
				//Total Qty GW(實際出貨箱數*毛重),add by Peggy 20201014
				if (rs.getString("actul_gw")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("actul_gw")).doubleValue(), ARightL));
				}
				col++;				
				//材積				
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("carton_size")==null?"":rs.getString("carton_size")), ACenterL));
				col++;	
				//"材積重 M3(volume)		
				if (rs.getString("CARTON_M3_WEIGHT")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("CARTON_M3_WEIGHT")).doubleValue(), ARightL));
				}
				col++;	
			}
			
			//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
			if (!ACTTYPE.equals("TSCC"))					
			{	
				if (ACTTYPE.equals("TSCE"))  //add by Peggy 20220901
				{
					//bill to location id
					ws.addCell(new jxl.write.Label(col, row, rs.getString("invoice_to_location_id") , ALeftL));
					col++;			
				}	
									
				//bill to
				ws.addCell(new jxl.write.Label(col, row, rs.getString("BILLTO_ADDRESS") , ALeftL));
				col++;	
				
				if (ACTTYPE.equals("TSCE"))  //add by Peggy 20220901
				{
					//deliver to location id
					ws.addCell(new jxl.write.Label(col, row, rs.getString("deliver_to_location_id") , ALeftL));
					col++;			
				}					
				
				//deliver to
				ws.addCell(new jxl.write.Label(col, row, rs.getString("DELIVER_ADDRESS") , ALeftL));
				col++;	
			}	

			//HOLD
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("hold_shipment_code")==null?"":rs.getString("hold_shipment_code"))+(rs.getString("hold_reason")==null?"":","+rs.getString("hold_reason")) , ALeftL));
			col++;	

			//hold new ssd,add by Peggy 20211104
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("HOLD_NEW_SSD")==null?"":rs.getString("HOLD_NEW_SSD")) , ALeftL));
			col++;	

			//工單/採購下單日
			if (rs.getString("wippo_creation_date")==null)  
			{		
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("wippo_creation_date")) ,DATE_FORMAT));
			}	
			col++;	
				
			//if (!ACTTYPE.equals("TSCC") || !RPTTYPE.equals("INSIDE"))					
			if (!ACTTYPE.equals("TSCC"))					
			{				
				//customer po line number,add by Peggy 20190408
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUSTOMER_PO_LINE_NUM")==null?"":rs.getString("CUSTOMER_PO_LINE_NUM")) , ALeftL));
				col++;	
	
				//WMS Flag,add by Peggy 20200716
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("wms_flag")==null?"":rs.getString("wms_flag")) , ACenterL));
				col++;	
	
				//Overdue/Early warning New SSD,add by Peggy 20200807
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("overdue_ssd")==null?"":rs.getString("overdue_ssd")) , ACenterL));
				col++;	
	
				//warehouseadd by Peggy 20200807
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("organization_code")==null?"":rs.getString("organization_code")) , ACenterL));
				col++;	
	
				//tax,add by Peggy 20200903
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("tax_code")==null?"":rs.getString("tax_code")) , ACenterL));
				col++;	
						
				//ship from loatcion
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("ship_from_location")==null?"":rs.getString("ship_from_location")) , ACenterL));
				col++;	
			}
				
			if (ACTTYPE.equals("TSCE"))
			{
				//U/P
				if (rs.getString("UNIT_SELLING_PRICE")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("UNIT_SELLING_PRICE")).doubleValue(), ARightL));
				}
				col++;		
				//QUOTE NUMBER
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("quote_number")==null?"":rs.getString("quote_number")) , ACenterL));  //add by Peggy 20230426		
				col++;			
				//CURRENCY
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("currency_code")==null?"":rs.getString("currency_code")) , ACenterL));	
				col++;	
				//AMT
				if (rs.getString("AMT")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("AMT")).doubleValue(), ARightL));
				}
				col++;	
				//ETA DATE
				if (rs.getString("eta_date")==null)  
				{		
					ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("eta_date")) ,DATE_FORMAT));
				}	
				col++;	
				//cust_supplier_id,add by Peggy 20220210
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("cust_supplier_id")==null?"":rs.getString("cust_supplier_id")) , ACenterL));	
				col++;	
				
				//22D/30D,add by Peggy 20220901
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("item_name")==null?"":rs.getString("item_name")) , ALeftL));
				col++;		
				
				//PC REMARK,add by Peggy 20230107
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("PCMARK")==null?"":rs.getString("PCMARK")) , ALeftL));
				col++;	
				
				//PUST_OUT_FREQUENCY,add by Peggy 20230526
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("PUST_OUT_FREQUENCY")==null?"":rs.getString("PUST_OUT_FREQUENCY")) , ALeftL));
				col++;
				
				//CANCELLATION_FREQUENCY,add by Peggy 20230526
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("CANCELLATION_FREQUENCY")==null?"":rs.getString("CANCELLATION_FREQUENCY")) , ALeftL));
				col++;		
				
				//Packing List Number,add by Peggy 20230619
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("packinglistnumber")==null?"":rs.getString("packinglistnumber")) , ALeftL));
				col++;																						
			}	
			//add by Peggy 20210106
			if (ACTTYPE.equals("TSCC") && RPTTYPE.equals("OUTSIDE"))
			{
				//Delivery to Branch office
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("attribute19")==null || !rs.getString("attribute19").equals("3")?"":"Y") , ACenterL));
				col++;			
			}
			
			if (ACTTYPE.equals("TSCC"))
			{
				//22D/30D,add by Peggy 20211012
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("item_name")==null?"":rs.getString("item_name")) , ALeftL));
				col++;	
				
				//Fob Term
				ws.addCell(new jxl.write.Label(col, row, rs.getString("FOB_POINT")  ,ALeftL));
				col++;	
				
				//ship to contact
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("ship_to_contact")==null?"":rs.getString("ship_to_contact")) , ALeftL));  //add by Peggy 20170220
				col++;	
				
				//科易採購項目號,add by Peggy 20221026
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("customer_purchase_item_no")==null?"":rs.getString("customer_purchase_item_no")) , ACenterL));
				col++;			
														
			}	
			//add by Peggy 20230821
			if (UserName.startsWith("JUNE") || UserRoles.indexOf("admin")>0 || ACTTYPE.equals("TSCE"))
			{
				if (rs.getString("twd_amt")==null)
				{
					ws.addCell(new jxl.write.Label(col, row,"",ALeftL));					
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("twd_amt")).doubleValue(), ARightL));
				}
				col++;

				if (rs.getString("SCHEDULE_SHIP_DATE")==null || Integer.parseInt(rs.getString("SCHEDULE_SHIP_DATE").replace("/",""))<Integer.parseInt(V_SYS_DATE))
				{
					ws.addCell(new jxl.write.Label(col, row,"",ALeftL));
				}
				else
				{
					if (rs.getString("sales_group").equals("TSCE"))
					{
						if (rs.getString("coo").equals("CN")) {
							String sales_group = rs.getString("sales_group");
							String plant_code = rs.getString("PACKING_INSTRUCTIONS").equals("I") || rs.getInt("totw_days")>0 ? "006" : rs.getString("plant_code");
							String request_date = rs.getString("request_date").replace("/","");
							String ship_method = rs.getString("ship_method");
							String orderType = rs.getString("order_number").substring(0,4);
							String customerId = rs.getString("sold_to_org_id");
							String fob = rs.getString("fob_point");
							String deliverid = rs.getString("deliver_to_org_id");
							String coo = rs.getString("coo");
							Statement stm =con.createStatement();
							System.out.println("order_number="+rs.getString("order_number"));
							System.out.println("sales_group="+sales_group);
							System.out.println("plant_code="+plant_code);
							System.out.println("request_date="+request_date);
							System.out.println("ship_method="+ship_method);
							System.out.println("orderType="+orderType);
							System.out.println("CUSTOMER_PO="+rs.getString("CUSTOMER_PO"));
							System.out.println("customerId="+customerId);
							System.out.println("fob="+fob);
							System.out.println("deliverid="+deliverid);
							System.out.println("coo="+coo);
							System.out.println("-------------------------------------------------");
							ResultSet resultSet = stm.executeQuery("select GET_TSCE_PMD_SSD('"+sales_group+"','"+plant_code+"','"+request_date+"','"+ship_method+"','"+orderType+"','"+customerId+"',sysdate,'"+fob+"','"+deliverid+"','"+coo+"') as SSD from dual");
							if (resultSet.next()) {
								V_PULLIN_NEW_SSD = resultSet.getString("SSD");
							}
							resultSet.close();
							stm.close();

						} else {
							CallableStatement csg = con.prepareCall("{call tsc_edi_pkg.GET_SSD(?,?,?,?,?,?,?,sysdate,?,?)}");
							csg.setString(1, rs.getString("sales_group"));
							if (rs.getString("PACKING_INSTRUCTIONS").equals("I") || rs.getInt("totw_days") > 0) {
								csg.setString(2, "006");
							} else {
								csg.setString(2, rs.getString("plant_code"));
							}
							csg.setString(3, rs.getString("request_date").replace("/", ""));
							csg.setString(4, rs.getString("ship_method"));
							csg.setString(5, rs.getString("order_number").substring(0, 4));
							csg.registerOutParameter(6, Types.VARCHAR);
							csg.setString(7, rs.getString("sold_to_org_id"));
							csg.setString(8, rs.getString("fob_point"));
							csg.setString(9, rs.getString("deliver_to_org_id"));
							csg.execute();
							V_PULLIN_NEW_SSD = csg.getString(6);
							csg.close();
						}
						if (rs.getString("SCHEDULE_SHIP_DATE") != null && Integer.parseInt(rs.getString("SCHEDULE_SHIP_DATE").replace("/", "")) <= Integer.parseInt(V_PULLIN_NEW_SSD)) {
							ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
						} else {
							ws.addCell(new jxl.write.Label(col, row, V_PULLIN_NEW_SSD, ALeftL));
						}

					}
					else if (rs.getString("sales_group").equals("TSCA"))
					{
						if (rs.getString("tsca_pullin_ssd") ==null || Integer.parseInt(rs.getString("SCHEDULE_SHIP_DATE").replace("/",""))<=Integer.parseInt(rs.getString("tsca_pullin_ssd")))
						{
							ws.addCell(new jxl.write.Label(col, row,"",ALeftL));
						}
						else
						{
							ws.addCell(new jxl.write.Label(col, row,rs.getString("tsca_pullin_ssd") ,ALeftL));	
						}
					}
					else
					{
						ws.addCell(new jxl.write.Label(col, row,"",ALeftL));	
					}
				}
				col++;	
			}	
			
			if (ACTTYPE.equals("TSCA"))
			{
				if (rs.getString("amt")==null)
				{
					ws.addCell(new jxl.write.Label(col, row,"",ALeftL));					
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("amt")).doubleValue(), ARightL));
				}
				col++;	
			}	
			ws.addCell(new jxl.write.Label(col, row,rs.getString("plant_name") ,ALeftL)); //add by Peggy 20240403
			col++;																			
			row++;				
			reccnt ++;
		}
		if (reccnt>0) sheetcnt++;
	}	
	rs.close();
	statement.close();		
	wwb.write(); 
	wwb.close();

	if (sheetcnt >0)
	{
		if (!ACTTYPE.equals("") || (request.getRemoteAddr().indexOf("10.0.")<0 && UserName.equals("SU CS-003")))
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
				if (RPTTYPE.equals("FORM"))
				{
					sql = " SELECT a.usermail  FROM oraddman.wsuser a where a.username=?";
					PreparedStatement statement1 = con.prepareStatement(sql);
					statement1.setString(1,UserName);
					ResultSet rs1=statement1.executeQuery();
					if (rs1.next())
					{
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs1.getString(1)));
					} 
					rs1.close();
					statement1.close();		
				}
				else
				{				
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
				}
			}
			else if (ACTTYPE.equals("TSCC") && RPTTYPE.equals("INSIDE"))
			{
				remarks="";
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-sample@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn"));  //add by Peggy 20221011 sansan skype要求
			}
			else if (ACTTYPE.equals("TSCC") && RPTTYPE.equals("OUTSIDE"))
			{				
				remarks="";
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tschk-sample@ts-china.com.cn"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sansan@ts-china.com.cn")); //add by Peggy 20221011 sansan skype要求
			}
			else if (ACTTYPE.equals("TSCE"))
			{
				if (RPTTYPE.equals("FORM"))
				{
					sql = " SELECT a.usermail  FROM oraddman.wsuser a where a.username=?";
					PreparedStatement statement1 = con.prepareStatement(sql);
					statement1.setString(1,UserName);
					ResultSet rs1=statement1.executeQuery();
					if (rs1.next())
					{
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs1.getString(1)));
					} 
					rs1.close();
					statement1.close();				
				}
				else
				{
//					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("emily.hsin@ts.com.tw"));
//					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rachel.chen@ts.com.tw"));
//					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zoe.wu@ts.com.tw"));
				}
			}
			else if (ACTTYPE.equals("TSCA"))
			{
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("cindy.huang@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("cynthia.tseng@ts.com.tw"));
			}			
			else if (ACTTYPE.equals("TSCR"))
			{
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anu@tscind.in"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("priya.thakur@tscind.in")); //add by Peggy 20230410
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("alvin.lin@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("june.wang@ts.com.tw"));
			}			
			else
			{
				ResultSet rs1=con.createStatement().executeQuery("select usermail from oraddman.wsuser a where username='"+UserName+"'");
				if ( rs1.next())
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs1.getString(1)));
				}
				rs1.close();
				if (UserName.equals("SU CS-003"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("demi_duan@ts-china.com.cn"));
				}
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
			
			if (ACTTYPE.equals("TSCC"))
			{
				message.setHeader("Subject", MimeUtility.encodeText((RPTTYPE.equals("INSIDE")?"TSCC內銷未交訂單明細":"TSCC外銷未交訂單明細")+"-"+dateBean.getYearMonthDay()+remarks, "UTF-8", null));				
			}
			else if (ACTTYPE.equals("TSCE") || ACTTYPE.equals("TSCA") || ACTTYPE.equals("TSCR"))
			{
				if (ACTTYPE.equals("TSCR"))
				{
					message.setHeader("Subject", MimeUtility.encodeText("TSCI/TSCR Backlog List"+remarks, "UTF-8", null));
				}
				else
				{
					message.setHeader("Subject", MimeUtility.encodeText(ACTTYPE+"未交訂單明細"+remarks, "UTF-8", null));
				}			
			}	
			else
			{
				message.setHeader("Subject", MimeUtility.encodeText(salesGroup+"未交訂單明細"+remarks, "UTF-8", null));				
			}		
			javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
			javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
			if (ACTTYPE.equals("TSCE"))
			{
				if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135")>=0)
				{
					mbp.setContent("<a href="+'"'+"file:///\\10.0.1.135"+"\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
				}
				else if (request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134")>=0)
				{
					mbp.setContent("<a href="+'"'+"file:///\\10.0.1.134"+"\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
				}
				else
				{					
					mbp.setContent("<a href="+'"'+"file:///\\10.0.1.144"+"\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
				}
			}
			else
			{
				javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
				mbp.setDataHandler(new javax.activation.DataHandler(fds));
				mbp.setFileName(fds.getName());
			}		
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
	if (ACTTYPE.equals("") && (request.getRemoteAddr().indexOf("10.0.")>=0 || !UserName.equals("SU CS-003")))
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
