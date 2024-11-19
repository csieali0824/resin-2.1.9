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
<FORM ACTION="../jsp/TSSalesOrderUnshipExcelTSCE.jsp" METHOD="post" name="MYFORM">
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
if (ACTTYPE.equals("TSCE")) //add by Peggy 20200807
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
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
String SHIPFROMLOCATION = request.getParameter("SHIPFROMLOCATION");  //add by Peggy 20201019
if (SHIPFROMLOCATION==null) SHIPFROMLOCATION="";
String SHIPPINGMETHOD = request.getParameter("SHIPPINGMETHOD");  //add by Peggy 20201019
if (SHIPPINGMETHOD==null) SHIPPINGMETHOD="";

try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TSCE-Order Unship Report_ Shipment Forecast List";
	FileName = RPTName+"("+dateBean.getYearMonthDay()+").xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	wwb.createSheet("Unship Order", 0);
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
		  " upper(TSC_OM_Get_Sales_Group(ooh.header_id)) sales_group,"+   //modify by Peggy 20220531 
		  " ooh.ORDER_NUMBER,"+
		  " ool.line_number ||'.'||ool.shipment_number line_no,"+
		  " msi.description,"+
		  " DECODE(ool.ITEM_IDENTIFIER_TYPE,'CUST',ool.ORDERED_ITEM,'') CUST_ITEM,"+
		  " nvl(ar.customer_sname,ar.customer_name) customer,"+
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
		  " Replace(Replace(TSC_GET_REMARK(ooh.HEADER_ID,'REMARKS'),chr(10), chr(32)),chr(13),chr(32))  REMARKS,"+
		  " Replace(Replace(TSC_GET_REMARK(ooh.HEADER_ID,'SHIPPING MARKS'),chr(10), chr(32)),chr(13),chr(32))  SHIPMARKS,"+
		  " ool.ATTRIBUTE7 PCMARK,"+  
		  " ool.flow_status_code, "+
		  " ool.CUSTOMER_SHIPMENT_NUMBER CUSTOMER_PO_LINE_NUM,"+
		  " TSC_GET_REMARK_DESC(ooh.HEADER_ID,'SHIPPING MARKS') mark_desc,"+
		  " ool.end_customer_id,"+
		  " NVL (ar1.customer_sname, ar1.customer_name) end_customer,"+
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
		  ",to_char(trunc(ool.schedule_ship_date-tsc_get_china_to_tw_days(ool.PACKING_INSTRUCTIONS ,ooh.oRDER_NUMBER,ool.inventory_item_id,null,ooh.sold_to_org_id,to_char(ooh.creation_date,'yyyymmdd'),NVL(ool.CUSTOMER_LINE_NUMBER,ool.CUST_PO_NUMBER))),'yyyy/mm/dd') factory_totw_date "+  //add by Peggy 20160805
		  ",(select distinct LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) "+
          //" from ar_contacts_v con WHERE con.contact_id=ooh.attribute11  and con.status='A') ship_to_contact"+  //add by Peggy 20170220
		  " from ar_contacts_v con WHERE con.contact_id=nvl(ooh.attribute11,ool.SHIP_TO_CONTACT_ID) ) ship_to_contact"+  //add by Peggy 20180119
		  ",ool.UNIT_SELLING_PRICE"+ //add by Peggy 20170220
		  ",opa.OPERAND LINE_CHARGE"+ //add by Peggy 20170222
		  ",tgp.CARTON_QTY"+  //add by Peggy 20170427
		  ",tgp.CARTON_SIZE"+ //add by Peggy 20170427
		  ",tgp.GW"+          //add by Peggy 20170427
		  ",tgp.NW"+          //add by Peggy 20210218
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
		  ",ool.attribute12 hold_new_ssd"+ //add by Peggy 20211104 
		  ",fact.manufactory_no plant_code"+  //add by Peggy 20240403
		  ",fact.manufactory_name plant_name"+ //add by Peggy 20240403		  
		  " from oe_order_headers_all ooh "+
		  "      ,oe_order_lines_all ool"+
		  "      ,JTF_RS_SALESREPS jrs "+
		  "      ,MTL_SYSTEM_ITEMS_B msi"+
		  //"      ,AR_CUSTOMERS ar,"+
		  "      ,tsc_customer_all_v ar,"+ //modify by Peggy 20210610
		  "      ra_terms_tl term ,"+
		  "      (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') lc,"+
		  //"      ar_customers ar1,"+
		  "      tsc_customer_all_v ar1,"+ //modify by Peggy 20210610
		  "      (select * from AR.HZ_CUST_SITE_USES_ALL where site_use_code = 'SHIP_TO') hcsu,"+
		  "      (select * from tsc_om_group where org_id=325) tog,"+
		  "      (SELECT * FROM OE_TRANSACTION_TYPES_TL WHERE LANGUAGE ='US') ott,"+
		  "      (select hcsu.site_use_id,hl.address1  from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
		  "      where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
		  "      and hcas.party_site_id = hps.party_site_id  "+
		  "      and hps.location_id =hl.location_id "+
		  "      and hcsu.site_use_code = 'SHIP_TO'"+
		  "      and hcsu.status = 'A') addr"+
		  //"      ,ar_customers end_ar"+
		  "      ,tsc_customer_all_v end_ar"+ //modify by Peggy 20210610
		  "      ,(SELECT A.LINE_ID,A.OPERAND  FROM ont.oe_price_adjustments a  where LIST_LINE_TYPE_CODE='FREIGHT_CHARGE') opa"+
		  "      ,table(TSC_GET_PROD_PACKAGE_INFO(ool.line_id,null,null,'FACTORY')) tgp"+
		  "      ,(select hcsu.site_use_id,hl.address1  from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
		  "      where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
		  "      and hcas.party_site_id = hps.party_site_id  "+
		  "      and hps.location_id =hl.location_id "+
		  "      and hcsu.site_use_code = 'DELIVER_TO'"+
		  "      and hcsu.status = 'A') de_addr"+ //add by Peggy 20171214	
		  "      ,(select hcsu.site_use_id,hl.address1  from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
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
          "       group by oha.order_number,ywa.order_line_id"+
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
	if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") >=0 ||request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") >=0) 
	{		  
    	sql +="       union all"+
          "       select to_number(SALES_ORDER_NUMBER) order_number,to_number(SALES_ORDER_LINE_ID) order_line_id ,min(to_date(MANUFACTURING_DATE,'yyyy/mm/dd')) creation_date from insitea01_oltp.TSC_SALES_ORDER_VIEW@prod_a01oltp a "+
          "       group by  SALES_ORDER_NUMBER,SALES_ORDER_LINE_ID";
	}
	sql +="	  ) odr_info "+  //add by Peggy 20181227
		  "       ,mtl_parameters mp"+//add by Peggy 20200807
		  ",(select distinct msix.inventory_item_id,tm.manufactory_no,tm.manufactory_name "+
          " from inv.mtl_system_items_b msix,oraddman.tsprod_manufactory tm "+
          " where msix.organization_id=49 "+
          " and msix.attribute3=tm.manufactory_no) fact"+		  
		  " WHERE ooh.HEADER_ID = ool.HEADER_ID(+)"+
		  " AND ooh.SALESREP_ID = jrs.SALESREP_ID(+)"+
		  " AND ool.INVENTORY_ITEM_ID = msi.INVENTORY_ITEM_ID"+
		  " AND msi.ORGANIZATION_ID = 43"+
		  " AND ooh.SOLD_TO_ORG_ID = ar.CUSTOMER_ID"+
		  " AND ool.CANCELLED_FLAG != 'Y'"+
		  " AND ool.ship_from_org_id=mp.organization_id"+//add by Peggy 20200807
		  " AND nvl(ool.ORDERED_QUANTITY,0) - nvl(ool.SHIPPED_QUANTITY,0)>0"+
		  " AND ool.FLOW_STATUS_CODE IN ('ENTERED','BOOKED','AWAITING_SHIPPING','AWAITING_APPROVE')"+
		  " AND ooh.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1343','1017') "+
		  " and ool.INVENTORY_ITEM_ID not in  (29570,29562,29560)"+
		  " and  term.language='US' "+
		  " AND nvl(ool.payment_term_id,ooh.payment_term_id) =term.term_id "+
		  " and ooh.ORG_ID=jrs.ORG_ID(+)"+
		  " AND ool.SHIPPING_METHOD_CODE = lc.lookup_code (+)"+
		  " AND ool.end_customer_id = ar1.customer_id(+)"+
		  " AND ool.ship_to_org_id = hcsu.site_use_id(+)"+
		  " AND hcsu.attribute1=tog.group_id(+)"+
		  " AND ool.line_type_id= ott.transaction_type_id(+)"+
		  " AND ool.ship_to_org_id=addr.site_use_id(+)"+
		  " AND ool.deliver_to_org_id=de_addr.site_use_id(+)"+ //add by Peggy 20171214
		  " AND ool.invoice_to_org_id=bill_addr.site_use_id(+)"+ //add by Peggy 2080320
		  " AND SUBSTR(ooh.ORDER_NUMBER,2,2) <>'19'"+			  
		  " AND ool.end_customer_id=end_ar.customer_id(+)"+
		  " AND ool.LINE_ID=opa.LINE_ID(+)"+
		  " AND ooh.org_id = case  WHEN SUBSTR( OOH.ORDER_NUMBER,1,1) =1  then 41 else ooh.org_id end"+
		  " AND ool.line_id=odr_info.order_line_id(+)"+
		  //" AND Tsc_Intercompany_Pkg.get_sales_group(ooh.header_id)='TSCE'";
		  " AND ool.inventory_item_id=fact.inventory_item_id"+ //add by Peggy 20240403		  
		  " AND TSC_OM_Get_Sales_Group(ooh.header_id)='TSCE'";  //modify by Peggy 20220531
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
	if (!SDATE.equals("") || !EDATE.equals(""))
	{
		sql += " and ool.schedule_ship_date  BETWEEN TO_DATE('"+(SDATE.equals("")?"trunc(add_months(sysdate,-48))":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?"trunc(add_months(sysdate,24))":EDATE)+"','yyyymmdd')+0.99999";
	}
	if (!SHIPPINGMETHOD.equals("--") && !SHIPPINGMETHOD.equals(""))  //add by Peggy 20201019
	{
		sql += " and ool.SHIPPING_METHOD_CODE='"+SHIPPINGMETHOD+"'";
	}
	if (!SHIPFROMLOCATION.equals("")) //add by Peggy 20201019
	{
		sql += " and case when substr(ooh.ORDER_NUMBER,1,4) in ('1156','1142') or substr(ooh.ORDER_NUMBER,1,1) in ('4','8','7') then 'China' when substr(ooh.ORDER_NUMBER,1,4) in ('1141','1131','1121') then 'Taiwan' when substr(ooh.ORDER_NUMBER,1,4) in ('1214') then case when ool.packing_instructions in ('Y','T') then 'China' else 'Taiwan' end else '' end='"+SHIPFROMLOCATION+"'";
	}		
	sql += " order by 1 desc,2,3,4";
	//out.println(sql);
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

		//Shipping Mark
		ws.addCell(new jxl.write.Label(col, row, "Shipping Mark" , ACenterBL));
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

		if (ACTTYPE.equals("") || ACTTYPE.equals("TSCE"))
		{
			//滿箱數量
			ws.addCell(new jxl.write.Label(col, row, "Full CTN Qty" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
	
			//預估出貨箱數
			ws.addCell(new jxl.write.Label(col, row, "Carton Qty" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		

			//淨重
			ws.addCell(new jxl.write.Label(col, row, "NW (kg)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
	
			//毛重
			ws.addCell(new jxl.write.Label(col, row, "GW (kg)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
	
			//Total Qty GW
			ws.addCell(new jxl.write.Label(col, row, "Total Qty GW" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//材積
			ws.addCell(new jxl.write.Label(col, row, "Dimension (mm)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//"材積重 M3(volume)
			ws.addCell(new jxl.write.Label(col, row, "材積重 M3(volume)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;				
		}
		//hold
		ws.addCell(new jxl.write.Label(col, row, "HOLD" , ACenterBL));
		ws.setColumnView(col,15);	
		col++;			
		
		//hold
		ws.addCell(new jxl.write.Label(col, row, "FCST Ship Date" , ACenterBL));
		ws.setColumnView(col,12);	
		col++;
				
		//Overdue/Early warning New SSD 
		ws.addCell(new jxl.write.Label(col, row, "Overdue/Early warning New SSD " , ACenterBL));
		ws.setColumnView(col,15);	
		col++;	
		
		//Warehouse
		ws.addCell(new jxl.write.Label(col, row, "Warehouse" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	
		
		//Plant code
		ws.addCell(new jxl.write.Label(col, row, "Plant Name" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;		
		
		//Ship-From Location(China / Taiwan)
		ws.addCell(new jxl.write.Label(col, row, "Ship-From Location\n(China / Taiwan)" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	

		/*//U/P
		ws.addCell(new jxl.write.Label(col, row, "U/P" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;	
		
		//Currency
		ws.addCell(new jxl.write.Label(col, row, "Currency" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;
			
		//Order Amt
		ws.addCell(new jxl.write.Label(col, row, "Order	AMT" , ACenterBL));
		ws.setColumnView(col,10);	
		col++;*/	
		row++;
		
		
		if (rs.isBeforeFirst() ==false) rs.beforeFirst();
		while (rs.next()) 
		{ 	
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
			//TSC_PROD_GROUP
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP") , ALeftL));
			col++;		
			//TSC_Family
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_FAMILY") , ALeftL));
			col++;	
			//TSC_prod_Family
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_FAMILY") , ALeftL));
			col++;		
			if (ACTTYPE.equals("") || ACTTYPE.equals("TSCE"))
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
			//HOLD
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("hold_shipment_code")==null?"":rs.getString("hold_shipment_code"))+(rs.getString("hold_reason")==null?"":","+rs.getString("hold_reason")) , ALeftL));
			col++;	

			//HOLD NEW SSD,add by Peggy 20211104
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("hold_new_ssd")==null?"":rs.getString("hold_new_ssd")) , ACenterL));
			col++;	

			//Overdue/Early warning New SSD,add by Peggy 20200807
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("overdue_ssd")==null?"":rs.getString("overdue_ssd")) , ACenterL));
			col++;	

			//warehouseadd by Peggy 20200807
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("organization_code")==null?"":rs.getString("organization_code")) , ACenterL));
			col++;	
			
			//Plant name by Peggy 20240403
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("plant_name")==null?"":rs.getString("plant_name")) , ACenterL));
			col++;				

			//ship from loatcion
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("ship_from_location")==null?"":rs.getString("ship_from_location")) , ACenterL));
			col++;	
			/*//U/P
			if (rs.getString("UNIT_SELLING_PRICE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("UNIT_SELLING_PRICE")).doubleValue(), ARightL));
			}
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
			col++;	*/				
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
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("celine.yu@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("emily.hsin@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sammy.chang@ts.com.tw"));
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rachel.chen@ts.com.tw"));
				//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lisa_hung@ts.com.tw"));
			}
			
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			message.setHeader("Subject", MimeUtility.encodeText("TSCE-Order Unship Report_ Shipment Forecast List"+remarks, "UTF-8", null));				
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
