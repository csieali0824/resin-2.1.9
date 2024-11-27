<%@ page contentType="text/html; charset=utf-8" language="java" import="java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSCE ITEM INFO</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCItemInfoReportTSCE.jsp" METHOD="post" name="MYFORM">
<%
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
String SYSDATE=request.getParameter("SYSDATE");
if (SYSDATE==null) SYSDATE="";
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",sql2="",sql3="",where="";
int fontsize=8,colcnt=0;
int row =0,col=0,reccnt=0;
String strAECQ="",strDesc="",strCartonSize="",strGW="",strwebstatus="",strgroup="",obsoletedate="",strPath="",strPartName="";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	OutputStream os = null;	
	RPTName = "TSCE distribution price book";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+(SYSDATE.equals("")?"":"(price date"+SYSDATE+")")+".xls";
	strPath ="\\resin-2.1.9\\webapps\\oradds\\TSCEPriceBook\\"+FileName;
	os = new FileOutputStream(strPath);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setVerticalFreeze(2);  //凍結窗格
	for (int g =1 ; g <=5 ;g++ )
	{
		sst.setHorizontalFreeze(g);
	}
	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_bold_red = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(false);	

	//英文內文水平垂直置左-格線-底色黃
	WritableCellFormat LeftBLY = new WritableCellFormat(font_bold);   
	LeftBLY.setAlignment(jxl.format.Alignment.LEFT);
	LeftBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	LeftBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	LeftBLY.setBackground(jxl.write.Colour.YELLOW); 
	LeftBLY.setWrap(false);	

	
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
	
	//英文內文水平垂直置右-正常-格線-紅字   
	WritableCellFormat ALeftLR = new WritableCellFormat(font_bold_red);   
	ALeftLR.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLR.setWrap(false);	
		
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(false);
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();

	sql = "with s1 as (\n" +
			"    select a.*,case when a.attribute3 in ('005') and a.tw_vendor_flag='N' \n" +
			"    then round(decode( pp_ssd.TP_PRICE_UOM,'KPC',pp_ssd.TP_PRICE/1000,pp_ssd.TP_PRICE),5)\n" +
			"     when a.attribute3 in ('008') and a.tw_vendor_flag='N' \n" +
			"     then round(decode( pp_prod.TP_PRICE_UOM,'KPC',pp_prod.TP_PRICE/1000,pp_prod.TP_PRICE),5) \n" +
			"     else decode( pp.TP_PRICE_UOM,'KPC',pp.TP_PRICE/1000,pp.TP_PRICE) end AS PRICE\n" +
			"     ,case when a.attribute3 in ('005') and a.tw_vendor_flag='N' \n" +
			"     then to_char(pp_ssd.last_update_date,'yyyy-mm-dd')  \n" +
			"     when a.attribute3 in ('008') and a.tw_vendor_flag='N' \n" +
			"     then to_char(pp_prod.last_update_date,'yyyy-mm-dd') \n" +
			"     else to_char(pp.last_update_date,'yyyy-mm-dd') end AS price_last_update_date,\n" +
			"     case when a.attribute3 in ('005') and a.tw_vendor_flag='N' \n" +
			"     then pp_ssd.TP_PRICE_UOM when a.attribute3 in ('008') and a.tw_vendor_flag='N' \n" +
			"     then pp_prod.TP_PRICE_UOM else pp.TP_PRICE_UOM end as PRODUCT_UOM_CODE,'\n" +
			"     PCE' UOM,qq.SPQ,qq.MOQ,qq.SAMPLE_SPQ,tt.LEAD_TIME,tt.NO_WAFER_LEAD_TIME,\n" +
			"     TSC_INV_Prod_Group_7(a.inventory_item_id ,a.organization_id) Product_Group_8,\n" +
			"     aecq.series_aecq,aecq.part_spec,aecq.website_status,\n" +
			"     to_char(aecq.obsolete_timestamp,'yyyy/mm/dd') obsolete_timestamp,\n" +
			"     to_char(aecq.first_on_website_date,'yyyy/mm/dd') first_on_website_date,\n" +
			"     nvl(aecq.msl,'NA') msl,case when substr(a.ITEM_DESC1,-3)='-ON' \n" +
			"     then on_packing.reel_qty else  replace(nvl(tpi.reel_pc,tpii.reel_pc),'-','')  end reel_pc,\n" +
			"     case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.box_qty else replace(nvl(tpi.innerbox_pc,tpii.innerbox_pc),'-','')  end innerbox_pc,\n" +
			"     case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.carton_qty else replace(nvl(tpi.carton_pc,tpii.carton_pc),'-','') end carton_pc,\n" +
			"     case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.carton_size else nvl(tpi.CartonSize,tpii.CartonSize) end CartonSize_mm ,\n" +
			"     case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.carton_weight else nvl(tpi.GW_KG,tpii.GW_KG) end GW_KG_CARTON ,\n" +
			"     (select to_char(max(oola.creation_date),'yyyy/mm/dd') from ont.oe_order_headers_all ooha,ont.oe_order_lines_all oola \n" +
			"     where ooha.header_id=oola.header_id \n" +
			"      and oola.inventory_item_id=a.inventory_item_id \n" +
			"        and substr(ooha.order_number ,1,4) in ('1121','1131','1141','1142','1156','1214','7141','7214','7121')) last_order_date,\n" +
			"        case when substr(a.ITEM_DESC1,-3)='-ON' \n" +
			"        then on_packing.PACKAGINGDESCRIPTION  \n" +
			"        else nvl(tpi.PACKAGINGDESCRIPTION,tpii.PACKAGINGDESCRIPTION) end PACKAGINGDESCRIPTION ,\n" +
			"        case when substr(a.ITEM_DESC1,-3)='-ON' then null else nvl(tpi.PART_NO_LIST,tpii.PART_NO_LIST) end PART_NO_LIST1 ,\n" +
			"        row_number() over(partition by a.SEGMENT1 order by decode(a.ITEM_DESC1,nvl(tpi.part_no_list,tpii.part_no_list),1,2)) item_cnt,\n" +
			"        fair.cust_partno fairchild_cpn,case when  a.attribute3 ='005' and a.tw_vendor_flag='N' then 'CHINA' else a.COO_CODE end COO,\n" +
			"        case a.TSC_PROD_GROUP when 'PRD' then case when substr(a.segment1,11,1) in ('2','H') then 'Yes' else '' end \n" +
			"        when 'SSD' then case when substr(a.segment1,11,1) in ('2','H') then 'Yes' else '' end\n" +
			"        when 'PMD' then case when substr(a.segment1,11,2) ='TP' then 'Yes' else '' end\n" +
			"        else '' end AEC_Q101,tsc_packing_info_preferred(a.inventory_item_id) prefeered_packing_code_flag,\n" +
			"        (select distinct pl_category from oraddman.ts_pl_category ttpc \n" +
			"        where ttpc.TSC_PROD_GROUP=a.TSC_PROD_GROUP \n" +
			"        and NVL(ttpc.TSC_PROD_CATEGORY,a.TSC_PROD_CATEGORY)=a.TSC_PROD_CATEGORY \n" +
			"        and ttpc.TSC_FAMILY=a.TSC_FAMILY \n" +
			"        and NVL(ttpc.TSC_PROD_FAMILY,nvl(a.TSC_PROD_FAMILY,'XXX'))=nvl(a.TSC_PROD_FAMILY,'XXX')) pl_category,\n" +
			"        case when tfp.tsc_ordering_code is not null then 'YES' else '' end as F400_PRODUCT,\n" +
			"        tdpb.bottom_price_usd_pcs,tdpb.sales_head_price_usd_pcs,tdpb.recommend_stock_in_channel,\n" +
			"        tdpb.price_book_code,tdpb.design_registration,tdpb.recommend_replacement,tdpb.distribution_book_price price1,tdpb.distribution_mpp_price price2,\n" +
			"        tdpb.design_registration_price price3 FROM (SELECT msi.organization_id,msi.segment1,msi.description,msi.inventory_item_id,msi.attribute3,\n" +
			"               TSC_INV_CATEGORY(msi.inventory_item_id,43,23) TSC_PACKAGE ,\n" +
			"               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) TSC_PROD_GROUP,\n" +
			"               TSC_INV_CATEGORY(msi.inventory_item_id,43,21) TSC_FAMILY,\n" +
			"               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000123) TSC_PROD_CATEGORY,\n" +
			"               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000203) TSC_prod_hierarchy_1,\n" +
			"               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000204) TSC_prod_hierarchy_2,\n" +
			"               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000205) TSC_prod_hierarchy_3,\n" +
			"               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000206) TSC_prod_hierarchy_4,\n" +
			"                CASE WHEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) IN ('PMD','SSD','SSP') \n" +
			"                THEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000004) ELSE '' END TSC_PROD_FAMILY,\n" +
			"                TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id) PACKAGE_CODE ,\n" +
			"                TSCA_GET_HTS_CODE(msi.inventory_item_id,trim(substr(cc.cccode,-11))) HTS_CODE,\n" +
			"                TSC_GET_ITEM_DESC_NOPACKING(MSI.ORGANIZATION_ID ,MSI.INVENTORY_ITEM_ID) ITEM_DESC1,\n" +
			"                tm.ALENGNAME factory_code,pcn.pcn_list,to_char(pt.creation_date,'yyyy-mm-dd') parts_release_date,\n" +
			"                case when TSC_INV_CATEGORY(msi.inventory_item_id,49,1100000003) in ('PRD','PRD-Subcon') \n" +
			"                THEN TO_CHAR(MIN(pt.CREATION_DATE) over (partition by substr(msi.segment1,1,10)||'1'||substr(msi.segment1,12)),'yyyy-mm-dd') \n" +
			"                ELSE to_char(pt.creation_date,'yyyy-mm-dd') END new_parts_release_date,\n" +
			"                to_char(msi.creation_date,'yyyy-mm-dd') item_creation_date,\n" +
			"                case when tm.manufactory_no in ('002','008') then 'CHINA' \n" +
			"                when tm.manufactory_no in ('005','006','010','011') then 'TAIWAN' else '' end as COO_CODE,\n" +
			"                trim(substr(cc.cccode,-11)) cccode,\n" +
			"                NVL(NVL((SELECT DISTINCT 'Y' FROM po_headers_all x,po_lines_all y WHERE x.TYPE_LOOKUP_CODE='BLANKET'\n" +
			"                AND x.ORG_ID in (41)\n" +
			"                 AND NVL(x.cancel_flag,'N') = 'N' \n" +
			"                 AND NVL(x.closed_code,'OPEN') NOT LIKE '%CLOSED%' \n" +
			"                 AND NVL(y.cancel_flag,'N') = 'N'\n" +
			"                 AND NVL(y.closed_code,'OPEN') <> 'CLOSED'  \n" +
			"                 AND NVL(y.closed_flag,'N') <> 'Y' \n" +
			"                 AND y.item_id =msi.inventory_item_id AND x.po_header_id=y.po_header_id\n" +
			"                 AND EXISTS (SELECT 1 FROM oraddman.tssg_vendor_tw z \n" +
			"                 WHERE z.vendor_site_id=x.VENDOR_SITE_ID \n" +
			"                 AND nvl(z.active_flag,'N')='A')),(SELECT 'Y' FROM ORADDMAN.TSSG_VENDOR_TW_PARTS X\n" +
			"                 WHERE X.PART_NAME=TSC_GET_ITEM_DESC_NOPACKING(MSI.ORGANIZATION_ID ,MSI.INVENTORY_ITEM_ID))),'N') tw_vendor_flag\n" +
			"                 ,nvl(tpcl.default_packing_code,tsc_get_item_packing_code (43, msi.inventory_item_id))  default_packing_code\n" +
			"                 ,case when instr(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id),'QQ')>0 then msi.description \n" +
			"                 else trim(substr(msi.description,0,length(msi.description)-length(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id)))) end part_id\n" +
			"                 FROM MTL_SYSTEM_ITEMS  msi,MTL_SYSTEM_ITEMS  msii,oraddman.tsprod_manufactory tm,\n" +
			"                 (SELECT TSC_PART_NO,listagg(PCN_NUMBER,',') within group(order by PCN_NUMBER) pcn_list\n" +
			"                 FROM (SELECT TSC_PART_NO,PCN_NUMBER FROM oraddman.tsqra_pcn_item_detail a WHERE SOURCE_TYPE=2\n" +
			"                 GROUP BY TSC_PART_NO,PCN_NUMBER) X\n" +
			"                 group by TSC_PART_NO) pcn,(SELECT distinct y.INVENTORY_ITEM_ID,y.ORGANIZATION_ID, x.SEGMENT1,x.CREATION_DATE\n" +
			"                 FROM inv.mtl_categories_b x,inv.mtl_item_categories y\n" +
			"                 WHERE STRUCTURE_ID=50203\n" +
			"                 and x.CATEGORY_ID=y.CATEGORY_ID\n" +
			"                 and y.ORGANIZATION_ID=49\n" +
			"                 and y.CATEGORY_SET_ID=24) pt\n" +
			"                 ,(select mc.inventory_item_id ,mc.organization_id , tc.cccode from mtl_item_categories mc, mtl_categories_tl mct,tsc_cccode tc \n" +
			"                 where mc.CATEGORY_SET_ID=6\n" +
			"                 and mc.category_id = mct.category_id and mct.language = 'US'\n" +
			"                 and tc.category_id = mct.category_id and tc.language = mct.language) cc\n" +
			"                 ,(SELECT * FROM oraddman.tsc_packing_conversion_list where nvl(INACTIVE_DATE,to_date('20991231','yyyymmdd'))>TRUNC(SYSDATE)) tpcl\n" +
			"                 WHERE msi.ORGANIZATION_ID=49\n" +
			"                 AND LENGTH(msi.SEGMENT1)>=22\n" +
			"                 AND TSC_INV_Category(msi.inventory_item_id,43, 23)=tpcl.tsc_package(+)\n" +
			"                 AND tsc_get_item_packing_code (43, msi.inventory_item_id)=tpcl.packing_code(+)\n" +
			"                 AND msi.ITEM_TYPE='FG'\n" +
			"                 AND msi.INVENTORY_ITEM_STATUS_CODE <>'Inactive'\n" +
			"                 AND msii.ORGANIZATION_ID=43\n" +
			"                 AND LENGTH(msii.SEGMENT1)>=22\n" +
			"                 AND msii.ITEM_TYPE='FG'\n" +
			"                 AND msii.INVENTORY_ITEM_STATUS_CODE <>'Inactive'\n" +
			"                 AND msi.inventory_item_id=msii.inventory_item_id\n" +
			"                 AND UPPER(msi.DESCRIPTION) NOT LIKE '%DISABLE%'\n" +
			"                 AND msi.attribute3=tm.manufactory_no(+)\n" +
			"                 and msi.description=pcn.TSC_PART_NO(+)\n" +
			"                 and msi.organization_id=pt.ORGANIZATION_ID(+)\n" +
			"                 and msi.INVENTORY_ITEM_ID=pt.INVENTORY_ITEM_ID(+)\n" +
			"                 and msi.organization_id=cc.ORGANIZATION_ID(+)\n" +
			"                 and msi.INVENTORY_ITEM_ID=cc.INVENTORY_ITEM_ID(+)\n" +
			"                 AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'\n" +
			"                 AND NVL(msi.INTERNAL_ORDER_ENABLED_FLAG,'N')='Y'\n" +
			"                 and tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'\n" +
			"                 and (((length(msi.segment1)=22 and substr(msi.segment1,21,1)='0') or (length(msi.segment1)=30 \n" +
			"                 and substr(msi.segment1,21,1)='0' and substr(msi.segment1,29,2)='00'))\n" +
			"                 and substr(msi.segment1,22,1) in ('0','A','B','C','D','F','G','H','I','J','K','L','N','O','P','Q','R','S','T','V','W','X','Y','Z'))\n" +
			"                 and instr(msi.description,'/')<=0) A\n" +
			"                 ,TABLE(TSC_GET_ITEM_SPQ_MOQ(a.inventory_item_id,'TS',NULL)) qq\n" +
			"                 ,TABLE(TSC_GET_ITEM_LEADTIME(a.inventory_item_id,a.attribute3,NULL)) tt\n" +
			"                 ,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',7257,\n" +
			"                 nvl(TO_DATE('','YYYY/MM/DD'),trunc(sysdate)),'USD',\n" +
			"                 CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E' \n" +
			"                 ELSE 'X' END ,NULL)) pp\n" +
			"                 ,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',9455,\n" +
			"                 nvl(TO_DATE('','YYYY/MM/DD'),trunc(sysdate)),'CNY',\n" +
			"                 CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E'\n" +
			"                 ELSE 'X' END ,NULL)) pp_cny\n" +
			"                 ,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',8534,\n" +
			"                 nvl(TO_DATE('','YYYY/MM/DD'),trunc(sysdate)),'USD',\n" +
			"                 CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E' \n" +
			"                 ELSE 'X' END ,NULL)) pp_ssd,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',8508,\n" +
			"                 nvl(TO_DATE('','YYYY/MM/DD'),trunc(sysdate)),'USD',\n" +
			"                 CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E' \n" +
			"                 ELSE 'X' END ,NULL)) pp_prod,table(tsc_get_aecq_info(a.inventory_item_id)) aecq\n" +
			"                 ,(select * from oraddman.tsc_packing_info_list where part_no_list is not null) tpi\n" +
			"                 ,(select * from oraddman.tsc_packing_info_list where part_no_list is null) tpii\n" +
			"                 ,oraddman.tsc_sales_bottom_price tsbp       ,oraddman.tsc_sales_bottom_price_tvs tsbpt\n" +
			"                 ,(SELECT a.ALTERNATE_ROUTING TSC_PACKAGE, a.DEM_LOCATION_ID SPQ, a.EXP_LOCATION_ID MOQ, a.CODE_DESC REEL_QTY, a.CODE_DESC2 BOX_QTY,\n" +
			"                 a.CODE_DESC3 CARTON_QTY,a.CODE_DESC4 CARTON_SIZE,a.CODE_DESC5 CARTON_WEIGHT,a.code_desc6 PACKAGINGDESCRIPTION\n" +
			"                 FROM yew_mfg_defdata a WHERE DEF_TYPE='ON') on_packing\n" +
			"                 ,(select  cust_partno, tsc_partno from oraddman.ts_label_onsemi_item where tsc_partno like '%-ON%') fair\n" +
			"                 ,(SELECT x.PCN_NUMBER,x.TSC_PART_NO,case when substr(y.segment1,21,1) not in ('0') \n" +
			"                 or substr(y.segment1,22,1) not in ('0','E','M','N','U') THEN ''\n" +
			"                  ELSE REPLACE_PART_NO END REPLACE_PART_NO\n" +
			"                  FROM (SELECT a.*,ROW_NUMBER () OVER (PARTITION BY tsc_part_no ORDER BY pcn_number) row_seq\n" +
			"                   FROM (SELECT DISTINCT pcn_number, tsc_part_no, replace_part_no FROM oraddman.tsqra_pcn_item_detail a \n" +
			"                   WHERE source_type = '2' AND replace_part_no IS NOT NULL\n" +
			"                   AND TRIM (UPPER (replace_part_no)) NOT IN ('NO CHANGE', 'NONE')) a) x,\n" +
			"                   (select a.* from (select description,segment1,row_number() \n" +
			"                    over (partition by description order by creation_date desc) row_seq from inv.mtl_system_items_b\n" +
			"                     where organization_id=43 and inventory_item_status_code<>'Inactive' ) a where row_seq=1) y\n" +
			"                     WHERE x.row_seq = 1 and x.REPLACE_PART_NO=y.description(+)) new_pn\n" +
			"                     ,oraddman.tsc_f400_product tfp\n" +
			"                     ,oraddman.tsc_distribution_price_book tdpb\n" +
			"                     WHERE 1=1\n" +
			"                     AND a.ITEM_DESC1=tpi.PART_NO_LIST(+)\n" +
			"                     AND a.TSC_PACKAGE=tpii.TSC_PACKAGE(+)\n" +
			"                     AND substr(upper(TRIM(a.PACKAGE_CODE)),1,2)=tpii.PackingCode(+)\n" +
			"                     AND case when UPPER(a.TSC_PROD_GROUP)='PRD-SUBCON' or upper(a.TSC_PACKAGE)='I2PAK'\n" +
			"                     THEN 'PRD' else a.TSC_PROD_GROUP END =tpii.GROUPTYPE(+)\n" +
			"                     AND a.description=tsbp.tsc_partno(+)\n" +
			"                     AND a.TSC_PACKAGE=on_packing.TSC_PACKAGE(+)\n" +
			"                     AND a.description=new_pn.TSC_PART_NO(+)\n" +
			"                     AND a.part_id=tsbpt.part_id(+)\n" +
			"                     AND a.item_desc1=fair.tsc_partno(+)\n" +
			"                     AND a.description=tdpb.tsc_ordering_code(+)\n" +
			"                     AND a.description=tfp.tsc_ordering_code(+)\n" +
			") select SEGMENT1, PART_ID, PACKAGE_CODE, DESCRIPTION, PL_CATEGORY, TSC_PROD_GROUP,TSC_PROD_CATEGORY,TSC_FAMILY,\n" +
			"    TSC_PROD_FAMILY, TSC_PACKAGE, SPQ, MOQ, LEAD_TIME, PRICE, PRICE_LAST_UPDATE_DATE, item_creation_date, bottom_price_usd_pcs,\n" +
			"    sales_head_price_usd_pcs, recommend_stock_in_channel, price_book_code, price1, price2, design_registration, price3, recommend_replacement,\n" +
			"    factory_code, attribute3, coo, coo_code, part_spec, AEC_Q101,msl, website_status,PACKAGINGDESCRIPTION, reel_pc, innerbox_pc, carton_pc,\n" +
			"    CartonSize_mm, GW_KG_CARTON, pcn_list, cccode,HTS_CODE, NEW_PARTS_RELEASE_DATE, TW_VENDOR_FLAG, first_on_website_date, F400_PRODUCT,\n" +
			"    TSC_prod_hierarchy_1, TSC_prod_hierarchy_2, TSC_prod_hierarchy_3, TSC_prod_hierarchy_4, fairchild_cpn, ITEM_CNT, prefeered_packing_code_flag \n" +
			"   from s1\n";
//	out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next())
		while (rs.next()) {
			//if (rs.getString("PACKAGE_CODE") ==null || rs.getString("part_spec")==null || rs.getInt("ITEM_CNT")!=1 || (rs.getString("TSC_PROD_GROUP").equals("PMD") && rs.getString("bottom_price")==null)) continue;
			if (rs.getString("PACKAGE_CODE") == null || rs.getString("part_spec") == null || rs.getInt("ITEM_CNT") != 1)
				continue;  //20230720 by Peggy 取消沒提供salse bottom 價格的條件 from Mabel 20230717 mail
			if (rs.getString("TSC_PROD_GROUP").equals("PMD") && rs.getString("SEGMENT1").length() == 30 && rs.getString("SEGMENT1").substring(21, 22).equals("V"))
				continue;  //20230720 by Peggy 在PROD GROUP下PMD的30D第22碼若為V，也屬於HsNr from Mabel 20230717 mail
			if (reccnt == 0) {
				col = 0;
				row = 0;

				//資料日期
				ws.mergeCells(col, row, col + 2, row);
				ws.addCell(new jxl.write.Label(col, row, "Data Date:" + dateBean.getDate(), LeftBLY));
				row++;

				//22/30-Digit-Code
				ws.addCell(new jxl.write.Label(col, row, "22/30-Digit-Code", ACenterBLB));
				ws.setColumnView(col, 30);
				col++;

				//PART ID--add by Peggy 20180718
				ws.addCell(new jxl.write.Label(col, row, "PART ID", ACenterBLB));
				ws.setColumnView(col, 20);
				col++;

				//PACKAGE CODE
				ws.addCell(new jxl.write.Label(col, row, "PACKAGE CODE", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//TSC Ordering Code
				ws.addCell(new jxl.write.Label(col, row, "TSC Ordering Code", ACenterBLB));
				ws.setColumnView(col, 25);
				col++;

				//PL CATEGORY
				ws.addCell(new jxl.write.Label(col, row, "PL Category", ACenterBLB));
				ws.setColumnView(col, 10);
				col++;

				//PROD GROUP
				ws.addCell(new jxl.write.Label(col, row, "PROD GROUP", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//TSC PROD CATEGORY
				ws.addCell(new jxl.write.Label(col, row, "TSC Prod Category", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//FAMILY
				ws.addCell(new jxl.write.Label(col, row, "FAMILY", ACenterBLB));
				ws.setColumnView(col, 20);
				col++;

				//PROD FAMILY
				ws.addCell(new jxl.write.Label(col, row, "PROD FAMILY", ACenterBLB));
				ws.setColumnView(col, 20);
				col++;

				//PACKAGE
				ws.addCell(new jxl.write.Label(col, row, "PACKAGE", ACenterBLB));
				ws.setColumnView(col, 20);
				col++;

				//SPQ
				ws.addCell(new jxl.write.Label(col, row, "SPQ", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//MOQ
				ws.addCell(new jxl.write.Label(col, row, "MOQ", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				////SAMPLE SPQ
				//ws.addCell(new jxl.write.Label(col, row, "SAMPLE SPQ" , ACenterBLB));
				//ws.setColumnView(col,15);
				//col++;

				//Lead Time(Week)
				ws.addCell(new jxl.write.Label(col, row, "Standard Lead Time(Week)", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//No Wafer Lead Time(Week)
				//ws.addCell(new jxl.write.Label(col, row, "No Wafer Lead Time(Week)" , ACenterBLB));
				//ws.setColumnView(col,15);
				//col++;

				//TP (USD/PCS)
				ws.addCell(new jxl.write.Label(col, row, "TP (USD/PCS)", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				////TSCE_PRICE(USD/PCS)
				//ws.addCell(new jxl.write.Label(col, row, "TSCE_PRICE" , ACenterBLB));
				//ws.setColumnView(col,15);
				//col++;

				//PRICE last update date
				ws.addCell(new jxl.write.Label(col, row, "PRICE LAST UPDATE DATE", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//22D
				ws.addCell(new jxl.write.Label(col, row, "22D Creation Date", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//Bottom price (USD/PCS)
				ws.addCell(new jxl.write.Label(col, row, " Bottom Price (USD/PCS)", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//Sales Head price (USD/PCS)
				ws.addCell(new jxl.write.Label(col, row, " Sales Head price (USD/PCS)", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//Recommended to Stock in Channel,add by Peggy 20231002
				ws.addCell(new jxl.write.Label(col, row, "Recommended to Stock in Channel", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//Price book Code,add by Peggy 20231002
				ws.addCell(new jxl.write.Label(col, row, "Price book Code", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//Distribution Book Price,add by Peggy 20231002
				ws.addCell(new jxl.write.Label(col, row, "Distribution Book Price", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//Distribution MPP Price,add by Peggy 20231002
				ws.addCell(new jxl.write.Label(col, row, "Distribution MPP Price", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//Design Registration,add by Peggy 20231002
				ws.addCell(new jxl.write.Label(col, row, "Design Registration", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//Design Registration Price,add by Peggy 20231002
				ws.addCell(new jxl.write.Label(col, row, "Design Registration Price", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//Recommended Replacement,add by Peggy 20231002
				ws.addCell(new jxl.write.Label(col, row, "Recommended Replacement", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;


				//Factory
				ws.addCell(new jxl.write.Label(col, row, "Factory", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//Factory
				ws.addCell(new jxl.write.Label(col, row, "RFQ Factory Code", ACenterBLB));
				ws.setColumnView(col, 12);
				col++;

				//COO,add by Peggy 20180810
				ws.addCell(new jxl.write.Label(col, row, "COO", ACenterBLB));
				ws.setColumnView(col, 7);
				col++;

				ws.addCell(new jxl.write.Label(col, row, "COO(TSCA use only)", ACenterBLB));
				ws.setColumnView(col, 7);
				col++;

				//Description
				ws.addCell(new jxl.write.Label(col, row, "Description", ACenterBLB));
				ws.setColumnView(col, 35);
				col++;

				//Series AECQ
				ws.addCell(new jxl.write.Label(col, row, "AEC-Q101", ACenterBLB)); //rename to AEC-Q101,add by Peggy 2
				ws.setColumnView(col, 10);
				col++;
				ws.addCell(new jxl.write.Label(col, row, "MSL", ACenterBLB));
				ws.setColumnView(col, 5);
				col++;

				//website status
				ws.addCell(new jxl.write.Label(col, row, "Website Status", ACenterBLB));
				ws.setColumnView(col, 12);
				col++;

				//Packaging Description
				ws.addCell(new jxl.write.Label(col, row, "Packaging Description", ACenterBLB));
				ws.setColumnView(col, 20);
				col++;

				//Reel(PC)
				ws.addCell(new jxl.write.Label(col, row, "Reel/Box (PC)", ACenterBLB));
				ws.setColumnView(col, 12);
				col++;

				//Inner Box(PC)
				ws.addCell(new jxl.write.Label(col, row, "Inner Box(PC)", ACenterBLB));
				ws.setColumnView(col, 12);
				col++;

				//Carton(PC)
				ws.addCell(new jxl.write.Label(col, row, "Carton(PC)", ACenterBLB));
				ws.setColumnView(col, 12);
				col++;

				//Carton Size
				ws.addCell(new jxl.write.Label(col, row, "Carton Size(mm)", ACenterBLB));
				ws.setColumnView(col, 16);
				col++;

				//Carton Weight
				ws.addCell(new jxl.write.Label(col, row, "Gross Weight(kg/Carton)", ACenterBLB));
				ws.setColumnView(col, 12);
				col++;

				//PCN/PDN
				ws.addCell(new jxl.write.Label(col, row, "PCN/PDN", ACenterBLB));
				ws.setColumnView(col, 25);
				col++;

				//TARIC Code
				ws.addCell(new jxl.write.Label(col, row, "TARIC Code", ACenterBLB));
				ws.setColumnView(col, 10);
				col++;

				//HTS Code
				ws.addCell(new jxl.write.Label(col, row, "HTS Code(TSCA local use)", ACenterBLB));
				ws.setColumnView(col, 10);
				col++;

				//Part Name create Date,add by Peggy 20200507
				ws.addCell(new jxl.write.Label(col, row, "Part Name create Date", ACenterBLB));
				ws.setColumnView(col, 15);
				col++;

				//TW_VENDOR_FLAG,add by Peggy 20200130
				ws.addCell(new jxl.write.Label(col, row, "TW Vendor", ACenterBLB));
				ws.setColumnView(col, 8);
				col++;

				//NPI released to Web,add by Peggy 20211130
				ws.addCell(new jxl.write.Label(col, row, "NPI released to Web", ACenterBLB));
				ws.setColumnView(col, 12);
				col++;

				//F400 PRODUCT,ADD BY PEGGY 20230214
				ws.addCell(new jxl.write.Label(col, row, "F400 PRODUCT", ACenterBLB));
				ws.setColumnView(col, 12);
				col++;

				//SPG STATUS,ADD BY PEGGY 20230214
				ws.addCell(new jxl.write.Label(col, row, "SPG STATUS", ACenterBLB));
				ws.setColumnView(col, 12);
				col++;

				//TSC PROD HIERARCHY1
				ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 1", ACenterBLB));
				ws.setColumnView(col, 20);
				col++;

				//TSC PROD HIERARCHY2
				ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 2", ACenterBLB));
				ws.setColumnView(col, 20);
				col++;

				//TSC PROD HIERARCHY3
				ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 3", ACenterBLB));
				ws.setColumnView(col, 20);
				col++;

				///TSC PROD HIERARCHY3
				ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 4", ACenterBLB));
				ws.setColumnView(col, 20);
				col++;
				row++;

			}
			col = 0;
			// 22/30-Digit-Code
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SEGMENT1"), ALeftL));
			col++;
			// PART ID
			if (rs.getString("fairchild_cpn") != null)  //add by Peggy 20181221
			{
				ws.addCell(new jxl.write.Label(col, row, rs.getString("fairchild_cpn"), ALeftL));
			} else {
				//ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION").substring(0, rs.getString("DESCRIPTION").length()-rs.getString("PACKAGE_CODE").length()).trim()  , ALeftL)); //add by Peggy 20180718
				//ws.addCell(new jxl.write.Label(col, row, strPartName, ALeftL));
				ws.addCell(new jxl.write.Label(col, row, rs.getString("part_id"), ALeftL));  //modify by Peggy 20210729
			}
			col++;
			// PACKAGE CODE
			if (rs.getString("fairchild_cpn") != null || rs.getString("PACKAGE_CODE").indexOf("QQ") >= 0)  //add by Peggy 20181221
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			} else {
				ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKAGE_CODE"), (rs.getString("prefeered_packing_code_flag").equals("Y") ? ALeftLR : ALeftL)));
			}
			col++;
			// TSC Ordering Code
			if (rs.getString("fairchild_cpn") != null)  //add by Peggy 20181221
			{
				ws.addCell(new jxl.write.Label(col, row, rs.getString("fairchild_cpn"), ALeftL));
			} else {
				ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION"), ALeftL));
			}
			col++;
			// PL Category
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("PL_CATEGORY") == null ? "" : rs.getString("PL_CATEGORY")), ALeftL)); //add by Peggy 20221108
			col++;
			// PROD GROUP
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PROD_GROUP") == null ? "" : rs.getString("TSC_PROD_GROUP")), ALeftL));
			col++;
			// TSC Prod Category
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PROD_CATEGORY") == null ? "" : rs.getString("TSC_PROD_CATEGORY")), ALeftL));
			col++;
			// FAMILY
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_FAMILY") == null ? "" : rs.getString("TSC_FAMILY")), ALeftL));
			col++;
			// PROD FAMILY
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PROD_FAMILY") == null ? "" : rs.getString("TSC_PROD_FAMILY")), ALeftL));
			col++;
			// PACKAGE
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PACKAGE") == null ? "" : rs.getString("TSC_PACKAGE")), ALeftL));
			col++;
			// SPQ
			if (rs.getString("SPQ") == null) {
				ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
			} else {
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SPQ")).doubleValue(), ARightL));
			}
			col++;
			// MOQ
			if (rs.getString("MOQ") == null) {
				ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
			} else {
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("MOQ")).doubleValue(), ARightL));
			}
			col++;
			// Standard Lead Time(Week)
			if (rs.getString("LEAD_TIME") == null) {
				ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
			} else {
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("LEAD_TIME")).doubleValue(), ARightL));
			}
			col++;
			//if (rs.getString("NO_WAFER_LEAD_TIME")==null)
			//{
			//	ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			//}
			//else
			//{
			//	ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("NO_WAFER_LEAD_TIME")).doubleValue(), ARightL));
			//}
			//col++;

			// TP (USD/PCS)
			if (rs.getString("PRICE") == null) {
				ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
			} else {
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PRICE")).doubleValue(), ARightL));
			}
			col++;
			//if (rs.getString("TSCE_PRICE")==null)
			//{
			//	ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			//}
			//else
			//{
			//	ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TSCE_PRICE")).doubleValue(), ARightL));
			//}
			//col++;

			// PRICE LAST UPDATE DATE
			ws.addCell(new jxl.write.Label(col, row, rs.getString("price_last_update_date"), ACenterL));
			col++;
			// 22D Creation Date
			ws.addCell(new jxl.write.Label(col, row, rs.getString("item_creation_date"), ACenterL));
			col++;

			//  Bottom Price (USD/PCS)
			if (rs.getString("bottom_price_usd_pcs") == null) {
				ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
			} else {
				//ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("BOTTOM_PRICE")).doubleValue(), ARightL));
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("bottom_price_usd_pcs")).doubleValue(), ARightL));
			}
			col++;
			// Sales Head price (USD/PCS)
			if (rs.getString("sales_head_price_usd_pcs") == null) {
				ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
			} else {
				//ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SALES_HEAD_PRICE")).doubleValue(), ARightL));
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("sales_head_price_usd_pcs")).doubleValue(), ARightL));
			}
			col++;
			// Recommended to Stock in Channel
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("recommend_stock_in_channel") == null ? "" : rs.getString("recommend_stock_in_channel")), ACenterL));
			col++;
			// Price book Code
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("price_book_code") == null ? "" : rs.getString("price_book_code")), ACenterL));
			col++;
			// Distribution Book Price
			if (rs.getString("price1") == null) {
				ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
			} else {
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("price1")).doubleValue(), ARightL));
			}
			col++;
			// Distribution MPP Price
			if (rs.getString("price2") == null) {
				ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
			} else {
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("price2")).doubleValue(), ARightL));
			}
			col++;
			// Design Registration
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("design_registration") == null ? "" : rs.getString("design_registration")), ACenterL));
			col++;
			// Design Registration Price
			if (rs.getString("price3") == null) {
				ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
			} else {
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("price3")).doubleValue(), ARightL));
			}
			col++;
			// Recommended Replacement
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("recommend_replacement") == null ? "" : rs.getString("recommend_replacement")), ACenterL));
			col++;
			// Factory
			ws.addCell(new jxl.write.Label(col, row, rs.getString("factory_code"), ACenterL));
			col++;
			// RFQ Factory Code
			ws.addCell(new jxl.write.Label(col, row, rs.getString("attribute3"), ACenterL));
			col++;
			// COO
			ws.addCell(new jxl.write.Label(col, row, rs.getString("coo"), ACenterL));
			col++;
			// COO(TSCA use only)
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("coo_code") == null ? "" : rs.getString("coo_code")), ACenterL)); //add by Peggy 20200203
			col++;
			// Description
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("part_spec") == null ? "" : rs.getString("part_spec")), ALeftL));
			col++;
			//ws.addCell(new jxl.write.Label(col, row, (rs.getString("series_aecq")==null?"":rs.getString("series_aecq")), ACenterL));
			//AEC-Q101
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("AEC_Q101") == null ? "" : rs.getString("AEC_Q101")), ACenterL));
			col++;
			// MSL
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("msl") == null || rs.getString("msl").equals("0") ? "" : rs.getString("msl")), ALeftL));
			col++;
			// Website Status
			if (rs.getString("TSC_PROD_GROUP") != null && rs.getString("TSC_PROD_GROUP").equals("PRD") && rs.getString("PACKAGE_CODE").indexOf("QQ") < 0)//add by Peggy 20200421
			{
				//if (rs.getString("TSC_PACKAGE")!=null && (rs.getString("TSC_PACKAGE").equals("C-SMA") || rs.getString("TSC_PACKAGE").equals("Folded SMA") || rs.getString("TSC_PACKAGE").equals("SMA") || rs.getString("TSC_PACKAGE").equals("SMB") || rs.getString("TSC_PACKAGE").equals("SMC")))
				if (rs.getString("TSC_PACKAGE") != null && ((rs.getString("TSC_PACKAGE").equals("C-SMA") && rs.getString("TSC_FAMILY") != null && !rs.getString("TSC_FAMILY").equals("Trench SKY")) || rs.getString("TSC_PACKAGE").equals("Folded SMA") || rs.getString("TSC_PACKAGE").equals("SMA") || rs.getString("TSC_PACKAGE").equals("SMB") || (rs.getString("TSC_PACKAGE").equals("SMC") && !rs.getString("DESCRIPTION").startsWith("5.0SMDJ")))) {
					if (rs.getString("website_status") != null && rs.getString("website_status").equals("Active")) {
						ws.addCell(new jxl.write.Label(col, row, "NRND", ACenterL));
					}
				}
			} else {
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("website_status") == null ? "" : rs.getString("website_status")), ACenterL));
			}
			col++;
			// Packaging Description
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKAGINGDESCRIPTION"), ACenterL));
			col++;
			// Reel/Box (PC)
			if (rs.getString("reel_pc") == null) {
				//ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
				if (rs.getString("SPQ") == null) {
					ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
				} else {
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SPQ")).doubleValue(), ARightL));
				}
			} else {
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("reel_pc")).doubleValue(), ARightL));
			}
			col++;
			// Inner Box(PC)
			if (rs.getString("innerbox_pc") == null) {
				//ws.addCell(new jxl.write.Label(col, row, "0" , ACenterL));
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf("0").doubleValue(), ARightL));
			} else {
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("innerbox_pc")).doubleValue(), ARightL));
			}
			col++;
			// Carton(PC)
			if (rs.getString("carton_pc") == null) {
				ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
			} else {
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("carton_pc")).doubleValue(), ARightL));
			}
			col++;
			// Carton Size(mm)
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("CartonSize_mm") == null ? "" : rs.getString("CartonSize_mm")), ACenterL));
			col++;
			// Gross Weight(kg/Carton)
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("GW_KG_CARTON") == null ? "" : rs.getString("GW_KG_CARTON")), ARightL));
			col++;
			// PCN/PDN
			ws.addCell(new jxl.write.Label(col, row, rs.getString("pcn_list"), ALeftL));
			col++;
			// TARIC Code
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("cccode") == null ? "" : rs.getString("cccode")), ACenterL));
			col++;
			// HTS Code(TSCA local use)
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("HTS_CODE") == null ? "" : rs.getString("HTS_CODE")), ALeftL));
			col++;
			// Part Name create Date
			ws.addCell(new jxl.write.Label(col, row, rs.getString("NEW_PARTS_RELEASE_DATE"), ACenterL));  //add by Peggy 20230421
			col++;
			// TW Vendor
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TW_VENDOR_FLAG"), ACenterL));  //add by Peggy 20200130
			col++;
			// NPI released to Web
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("first_on_website_date") == null ? "" : rs.getString("first_on_website_date")), ACenterL)); //add by Peggy 20211130
			col++;
			// F400 PRODUCT
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("F400_PRODUCT") == null ? "" : rs.getString("F400_PRODUCT")), ACenterL)); //add by Peggy 20230214
			col++;
			// SPG STATUS
			if ((rs.getString("F400_PRODUCT") != null && rs.getString("F400_PRODUCT").equals("YES")) || rs.getString("TSC_FAMILY").toUpperCase().equals("MOSFET-HV") || rs.getString("TSC_FAMILY").toUpperCase().equals("MOSFET-MV") || rs.getString("TSC_FAMILY").toUpperCase().equals("MOSFET-LV") || rs.getString("TSC_FAMILY").toUpperCase().equals("TVS LOAD DUMP") || ((rs.getString("TSC_FAMILY").toUpperCase().equals("TRENCH SKY") || rs.getString("TSC_FAMILY").toUpperCase().equals("LIGHTING IC")) && rs.getString("AEC_Q101") != null && rs.getString("AEC_Q101").equals("Yes"))) {
				if (rs.getString("website_status") != null && rs.getString("website_status").equals("Active")) {
					ws.addCell(new jxl.write.Label(col, row, "SPG", ACenterL)); //add by Peggy 20230214
				} else {
					ws.addCell(new jxl.write.Label(col, row, "Standard", ACenterL)); //add by Peggy 20230214
				}
			} else {
				ws.addCell(new jxl.write.Label(col, row, "Standard", ACenterL)); //add by Peggy 20230214
			}
			col++;
			//ws.addCell(new jxl.write.Label(col, row, (rs.getString("recommend_stock_item")==null?"":"Y") , ACenterL)); //add by Peggy 20230807
			//col++;
			// PROD HIERARCHY 1
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_prod_hierarchy_1") == null ? "" : rs.getString("TSC_prod_hierarchy_1")), ALeftL));
			col++;
			// PROD HIERARCHY 2
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_prod_hierarchy_2") == null ? "" : rs.getString("TSC_prod_hierarchy_2")), ALeftL));
			col++;
			// PROD HIERARCHY 3
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_prod_hierarchy_3") == null ? "" : rs.getString("TSC_prod_hierarchy_3")), ALeftL));
			col++;
			// PROD HIERARCHY 4
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_prod_hierarchy_4") == null ? "" : rs.getString("TSC_prod_hierarchy_4")), ALeftL));
			col++;

			row++;
			reccnt++;
		}

	wwb.write(); 
	wwb.close();

	rs.close();
	statement.close();
	//conn.close();

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
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0
				&& request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0
				&& request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0
				&& request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0
				&& request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
		}
		else
		{
			remarks="";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("celine.yu@ts.com.tw"));
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("ks.foo@ts.com.tw"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
			
		message.setSubject("TSCE Item Price Report - "+dateBean.getYearMonthDay()+(SYSDATE.equals("")?"":"(price date"+SYSDATE+")")+remarks);
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		if (request.getRequestURL().toString().toLowerCase().indexOf("10.0.3.16")>=0)
		{
			mbp.setContent("<a href="+'"'+"file:///\\10.0.3.109"+strPath+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
		}
		else
		{
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") >=0 || request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135")>=0)
			{
				mbp.setContent("<a href="+'"'+"file:///\\10.0.1.135"+strPath+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
			}
			else
			{		
				mbp.setContent("<a href="+'"'+"file:///\\10.0.1.134"+strPath+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
			}
		}
	
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
	out.println("Exception:"+e.getMessage()+" cnt:"+reccnt); 
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
	if (RTYPE.equals("EXL"))
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
