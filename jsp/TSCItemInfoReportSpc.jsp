<%@ page contentType="text/html; charset=utf-8" language="java" import="java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSC ITEM INFO</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCItemInfoReportSpc.jsp" METHOD="post" name="MYFORM">
<%
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
String DATATYPE=request.getParameter("DATATYPE");
if (DATATYPE==null) DATATYPE="";
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
	RPTName = "TSC Item Price Info";
	if (DATATYPE.equals("ALL"))
	{
		FileName = RPTName+"(Include Inactive)"+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+(SYSDATE.equals("")?"":"(price date"+SYSDATE+")")+".xls";
	}
	else if (DATATYPE.equals("INACTIVE"))
	{
		FileName = RPTName+"(Inactive)"+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+(SYSDATE.equals("")?"":"(price date"+SYSDATE+")")+".xls";
	}
	else
	{
		FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+(SYSDATE.equals("")?"":"(price date"+SYSDATE+")")+".xls";
	}	
	//FileName = RPTName+(DATATYPE.equals("ALL")?"(Include Inactive)":"")+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	strPath ="\\resin-2.1.9\\webapps\\oradds\\TSCItemListUser\\"+FileName;
	os = new FileOutputStream(strPath);
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

    sql = "select a.*"+
		  ",case when a.attribute3 in ('005') and a.tw_vendor_flag='N' then round(decode( pp_ssd.TP_PRICE_UOM,'KPC',pp_ssd.TP_PRICE/1000,pp_ssd.TP_PRICE),5) when a.attribute3 in ('008') and a.tw_vendor_flag='N' then round(decode( pp_prod.TP_PRICE_UOM,'KPC',pp_prod.TP_PRICE/1000,pp_prod.TP_PRICE),5) else decode( pp.TP_PRICE_UOM,'KPC',pp.TP_PRICE/1000,pp.TP_PRICE) end AS PRICE"+
          ",case when a.attribute3 in ('005') and a.tw_vendor_flag='N' then to_char(pp_ssd.last_update_date,'yyyy-mm-dd')  when a.attribute3 in ('008') and a.tw_vendor_flag='N' then to_char(pp_prod.last_update_date,'yyyy-mm-dd') else to_char(pp.last_update_date,'yyyy-mm-dd') end AS price_last_update_date"+
          ",case when a.attribute3 in ('005') and a.tw_vendor_flag='N' then pp_ssd.TP_PRICE_UOM when a.attribute3 in ('008') and a.tw_vendor_flag='N' then pp_prod.TP_PRICE_UOM else pp.TP_PRICE_UOM end as PRODUCT_UOM_CODE"+
          ",'PCE' UOM"+
          ",qq.SPQ"+
          ",qq.MOQ"+
          ",qq.SAMPLE_SPQ"+
          ",tt.LEAD_TIME"+
          ",tt.NO_WAFER_LEAD_TIME"+
		  ",TSC_INV_Prod_Group_7(a.inventory_item_id ,a.organization_id) Product_Group_8"+  //Product Group 8同Forecast 及 BI 都使用 Function TSC_INV_Prod_Group_7,add by Peggy 20170510
		  ",aecq.series_aecq"+
		  ",aecq.part_spec"+
		  ",aecq.website_status"+
		  ",to_char(aecq.obsolete_timestamp,'yyyy/mm/dd') obsolete_timestamp"+
		  ",to_char(aecq.first_on_website_date,'yyyy/mm/dd') first_on_website_date"+
		  ",nvl(aecq.msl,'NA') msl"+
		  ",case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.reel_qty else  replace(nvl(tpi.reel_pc,tpii.reel_pc),'-','')  end reel_pc"+       //modify by Peggy 20181115
		  ",case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.box_qty else replace(nvl(tpi.innerbox_pc,tpii.innerbox_pc),'-','')  end innerbox_pc"+ //modify by Peggy 20181115
		  ",case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.carton_qty else replace(nvl(tpi.carton_pc,tpii.carton_pc),'-','') end carton_pc"+   //modify by Peggy 20181115
          ",case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.carton_size else nvl(tpi.CartonSize,tpii.CartonSize) end CartonSize_mm "+         //modify by Peggy 20181115
          ",case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.carton_weight else nvl(tpi.GW_KG,tpii.GW_KG) end GW_KG_CARTON "+         //modify by Peggy 20181115
          ",(select to_char(max(oola.creation_date),'yyyy/mm/dd') from ont.oe_order_headers_all ooha,ont.oe_order_lines_all oola where ooha.header_id=oola.header_id"+
          "  and oola.inventory_item_id=a.inventory_item_id"+
          "  and substr(ooha.order_number ,1,4) in ('1121','1131','1141','1142','1156','1214','7141','7214','7121')) last_order_date"+ //add by Peggy 20180202
		  ",case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.PACKAGINGDESCRIPTION else nvl(tpi.PACKAGINGDESCRIPTION,tpii.PACKAGINGDESCRIPTION) end PACKAGINGDESCRIPTION "+ //modify by Peggy 20181115
		  ",case when substr(a.ITEM_DESC1,-3)='-ON' then null else nvl(tpi.PART_NO_LIST,tpii.PART_NO_LIST) end PART_NO_LIST1 "+ //modify by Peggy 20181115
          ",row_number() over(partition by a.SEGMENT1 order by decode(a.ITEM_DESC1,nvl(tpi.part_no_list,tpii.part_no_list),1,2)) item_cnt"+  //add by Peggy 20181023
		  ",case when  a.attribute3 ='005' and a.tw_vendor_flag='N' then 'CHINA' else a.COO_CODE end COO"+
		  ",case a.TSC_PROD_GROUP when 'PRD' then case when substr(a.segment1,11,1) in ('2','H') then 'Yes' else '' end"+
		  "                       when 'SSD' then case when substr(a.segment1,11,1) in ('2','H') then 'Yes' else '' end"+ //SSD add by Peggy 20240516
		  "                       when 'PMD' then case when substr(a.segment1,11,2) ='TP' then 'Yes' else '' end"+
		  "                       else '' end AEC_Q101"+ //add by Peggy 20200708
		  ",tsc_packing_info_preferred(a.inventory_item_id) prefeered_packing_code_flag"+
		  ",(select listagg(pl_category,',') within group(order by pl_category) xx  from oraddman.ts_pl_category ttpc where ttpc.TSC_PROD_GROUP=a.TSC_PROD_GROUP and NVL(ttpc.TSC_PROD_CATEGORY,a.TSC_PROD_CATEGORY)=a.TSC_PROD_CATEGORY and ttpc.TSC_FAMILY=a.TSC_FAMILY and NVL(ttpc.TSC_PROD_FAMILY,nvl(a.TSC_PROD_FAMILY,'XXX'))=nvl(a.TSC_PROD_FAMILY,'XXX')) pl_category"+ //add by Peggy 20221108 
		  ",case when tfp.tsc_ordering_code is not null then 'YES' else '' end as F400_PRODUCT"+ //add by Peggy 20230214
		  //",trs.item_name recommend_stock_item"+ //add by Peggy 20230807	
		  //",tdpb.franchise_lead_time_week"+   //add by Peggy 20231002
		  //",tdpb.bottom_price_usd_pcs"+   //add by Peggy 20231002
		  //",tdpb.sales_head_price_usd_pcs"+   //add by Peggy 20231002
		  //",tdpb.recommend_stock_in_channel"+   //add by Peggy 20231002
		  //",tdpb.price_book_code"+      //add by Peggy 20231002
		  //",tdpb.design_registration"+    //add by Peggy 20231002
		  //",tdpb.recommend_replacement"+ //add by Peggy 20231002	
		  //",tdpb.distribution_book_price price1"+ //add by Peggy 20231002		  	  
		  //",tdpb.distribution_mpp_price price2"+ //add by Peggy 20231002		  	  
		  //",tdpb.design_registration_price price3"+ //add by Peggy 20231002		  	  
          " FROM (SELECT msi.organization_id,msi.segment1,msi.description,msi.inventory_item_id,msi.attribute3,"+
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,23) TSC_PACKAGE , "+
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) TSC_PROD_GROUP, "+
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,21) TSC_FAMILY,"+
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000123) TSC_PROD_CATEGORY,"+
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000203) TSC_prod_hierarchy_1,"+	      //add by Peggy 20230525	
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000204) TSC_prod_hierarchy_2,"+		  //add by Peggy 20230525	
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000205) TSC_prod_hierarchy_3,"+		  //add by Peggy 20230525		
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000206) TSC_prod_hierarchy_4,"+		  //add by Peggy 20230525			  	  		    
          "       CASE WHEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) IN ('PMD','SSD','SSP') THEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000004) ELSE '' END TSC_PROD_FAMILY,"+
          "       TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id) PACKAGE_CODE ,"+
          "       TSC_GET_PARTNO(MSI.ORGANIZATION_ID ,MSI.INVENTORY_ITEM_ID) ITEM_DESC,"+                 //modify by Peggy 2018015
          "       TSC_GET_ITEM_DESC_NOPACKING(MSI.ORGANIZATION_ID ,MSI.INVENTORY_ITEM_ID) ITEM_DESC1,"+   //modify by Peggy 2018015
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,24) TSC_PARTNO , "+ //add by Peggy 20230426  		  
          "       tm.ALENGNAME factory_code,"+
          "       pcn.pcn_list,"+
		  "       to_char(pt.creation_date,'yyyy-mm-dd') parts_release_date,"+
          "       case when TSC_INV_CATEGORY(msi.inventory_item_id,49,1100000003) in ('PRD','PRD-Subcon') THEN TO_CHAR(MIN(pt.CREATION_DATE) over (partition by substr(msi.segment1,1,10)||'1'||substr(msi.segment1,12)),'yyyy-mm-dd') ELSE to_char(pt.creation_date,'yyyy-mm-dd') END new_parts_release_date,"+//add by Peggy 20230421
		  "       to_char(msi.creation_date,'yyyy-mm-dd') item_creation_date,"+ //add by Peggy 20171017  
		  "       case when tm.manufactory_no in ('002','008') then 'CHINA' when tm.manufactory_no in ('005','006','010','011') then 'TAIWAN' else '' end as COO_CODE,"+//add by Peggy 20180810
		  "       trim(substr(cc.cccode,-11)) cccode,"+ //add by Peggy 20180813
		  "       msii.INVENTORY_ITEM_STATUS_CODE IM_STATUS,"+ //add by Peggy 20190218
		  "       case when 'Y' IN (NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N'), NVL(msi.INTERNAL_ORDER_ENABLED_FLAG,'N')) THEN 'Y' ELSE 'N' END AS ORDER_ENABLED_FLAG"+ //20190218
          "       ,(SELECT PACKAGE_TYPE FROM ORADDMAN.TSC_PACKAGE_TYPE B WHERE TSC_PACKAGE=TSC_INV_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,23)) PACKAGE_TYPE"+ //20191209
          "       ,TSCA_GET_HTS_CODE(msi.inventory_item_id,trim(substr(cc.cccode,-11))) HTS_CODE"+ //add by Peggy 20191209 
		  "       ,NVL(NVL((SELECT DISTINCT 'Y' FROM po_headers_all x,po_lines_all y WHERE x.TYPE_LOOKUP_CODE='BLANKET'"+
          "        AND x.ORG_ID in (41) AND NVL(x.cancel_flag,'N') = 'N' AND NVL(x.closed_code,'OPEN') NOT LIKE '%CLOSED%' AND NVL(y.cancel_flag,'N') = 'N'"+
          "        AND NVL(y.closed_code,'OPEN') <> 'CLOSED'  AND NVL(y.closed_flag,'N') <> 'Y' AND y.item_id =msi.inventory_item_id AND x.po_header_id=y.po_header_id"+
          "        AND EXISTS (SELECT 1 FROM oraddman.tssg_vendor_tw z WHERE z.vendor_site_id=x.VENDOR_SITE_ID AND nvl(z.active_flag,'N')='A')),(SELECT 'Y' FROM ORADDMAN.TSSG_VENDOR_TW_PARTS X"+
          "        WHERE X.PART_NAME=TSC_GET_ITEM_DESC_NOPACKING(MSI.ORGANIZATION_ID ,MSI.INVENTORY_ITEM_ID))),'N') tw_vendor_flag"+
		  "       ,nvl(tpcl.default_packing_code,tsc_get_item_packing_code (43, msi.inventory_item_id))  default_packing_code"+  //add by Peggy 20201021
          "       ,case when instr(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id),'QQ')>0 then msi.description else trim(substr(msi.description,0,length(msi.description)-length(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id)))) end part_id"+ //add by Peggy 20210729
          "       FROM MTL_SYSTEM_ITEMS  msi"+
		  "       ,MTL_SYSTEM_ITEMS  msii"+  //add by Peggy 20190215
          "       ,oraddman.tsprod_manufactory tm"+
          "       ,(SELECT TSC_PART_NO,listagg(PCN_NUMBER,',') within group(order by PCN_NUMBER) pcn_list"+
          "         FROM (SELECT TSC_PART_NO,PCN_NUMBER FROM oraddman.tsqra_pcn_item_detail a "+
          "         WHERE SOURCE_TYPE=2"+
          "         GROUP BY TSC_PART_NO,PCN_NUMBER) X "+
          "         group by TSC_PART_NO) pcn"+
		  "        ,(SELECT y.INVENTORY_ITEM_ID,y.ORGANIZATION_ID, x.SEGMENT1,x.CREATION_DATE"+
          "         FROM inv.mtl_categories_b x,inv.mtl_item_categories y "+
          "         WHERE STRUCTURE_ID=50203"+
          "         and x.CATEGORY_ID=y.CATEGORY_ID"+
		  "         and y.ORGANIZATION_ID=49"+ //add by Peggy 20230421
          "         and y.CATEGORY_SET_ID=24) pt"+
		  "       ,(select mc.inventory_item_id ,mc.organization_id , tc.cccode from mtl_item_categories mc, mtl_categories_tl mct,tsc_cccode tc where mc.CATEGORY_SET_ID=6 "+
          "        and mc.category_id = mct.category_id and mct.language = 'US' and tc.category_id = mct.category_id and tc.language = mct.language) cc"+  //add by Peggy 20180813
		  "       ,(SELECT * FROM oraddman.tsc_packing_conversion_list where nvl(INACTIVE_DATE,to_date('20991231','yyyymmdd'))>TRUNC(SYSDATE)) tpcl"+
          "       WHERE msi.ORGANIZATION_ID=49"+
          "       AND LENGTH(msi.SEGMENT1)>=22"+
          "       AND TSC_INV_Category(msi.inventory_item_id,43, 23)=tpcl.tsc_package(+)"+ //add by Peggy 20201021
          "       AND tsc_get_item_packing_code (43, msi.inventory_item_id)=tpcl.packing_code(+)"+  //add by Peggy 20201021
		  "       AND msi.ITEM_TYPE='FG'";//add by Peggy 20190802
	if (DATATYPE.equals("INACTIVE"))		  
	{
    	sql +="       AND msi.INVENTORY_ITEM_STATUS_CODE ='Inactive'";
	}
	else if (DATATYPE.equals(""))
	{
    	sql +="       AND msi.INVENTORY_ITEM_STATUS_CODE <>'Inactive'";
	}
	sql +="       AND msii.ORGANIZATION_ID=43"+    //add by Peggy 20190215
          "       AND LENGTH(msii.SEGMENT1)>=22"+   //add by Peggy 20190215
		  "       AND msii.ITEM_TYPE='FG'"+ //add by Peggy 20190802
		  "       AND msi.inventory_item_id=msii.inventory_item_id"+  //add by Peggy 20190215
          "       AND UPPER(msi.DESCRIPTION) NOT LIKE '%DISABLE%'"+
          "       AND msi.attribute3=tm.manufactory_no(+)"+
          "       and msi.description=pcn.TSC_PART_NO(+)"+
		  "       and msi.organization_id=pt.ORGANIZATION_ID(+)"+
          "       and msi.INVENTORY_ITEM_ID=pt.INVENTORY_ITEM_ID(+)"+
		  "       and msi.organization_id=cc.ORGANIZATION_ID(+)"+       //add by Peggy 20180813
          "       and msi.INVENTORY_ITEM_ID=cc.INVENTORY_ITEM_ID(+)"+   //add by Peggy 20180813
		  //"       and msi.description=tgpbn.tsc_ordering_code(+)"+      //add by Peggy 20211029
		  //"       and msi.segment1=tgpbe.tsc_item_name(+)"+             //add by Peggy 20220503
		  "       ) A "+
          "       ,TABLE(TSC_GET_ITEM_SPQ_MOQ(a.inventory_item_id,'TS',NULL)) qq"+
          "       ,TABLE(TSC_GET_ITEM_LEADTIME(a.inventory_item_id,a.attribute3,NULL)) tt"+
          "       ,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',7257,nvl(TO_DATE('"+SYSDATE+"','YYYY/MM/DD'),trunc(sysdate)),'USD',CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E' ELSE 'X' END ,NULL)) pp"+
          "       ,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',9455,nvl(TO_DATE('"+SYSDATE+"','YYYY/MM/DD'),trunc(sysdate)),'CNY',CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E' ELSE 'X' END ,NULL)) pp_cny"+
          "       ,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',8534,nvl(TO_DATE('"+SYSDATE+"','YYYY/MM/DD'),trunc(sysdate)),'USD',CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E' ELSE 'X' END ,NULL)) pp_ssd"+
          "       ,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',8508,nvl(TO_DATE('"+SYSDATE+"','YYYY/MM/DD'),trunc(sysdate)),'USD',CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E' ELSE 'X' END ,NULL)) pp_prod"+
		  "       ,table(tsc_get_aecq_info(a.inventory_item_id)) aecq"+ //add by Peggy 20230802
		  "       ,(select * from oraddman.tsc_packing_info_list where part_no_list is not null) tpi"+ //add by Peggy 20210419
		  "       ,(select * from oraddman.tsc_packing_info_list where part_no_list is null) tpii"+ //add by Peggy 20210419
		  "       ,oraddman.tsc_sales_bottom_price tsbp"+ //add by Peggy 2020200708
		  "       ,oraddman.tsc_sales_bottom_price_tvs tsbpt"+ //add by Peggy 20210729
		  "       ,(SELECT a.ALTERNATE_ROUTING TSC_PACKAGE, a.DEM_LOCATION_ID SPQ, a.EXP_LOCATION_ID MOQ, a.CODE_DESC REEL_QTY, a.CODE_DESC2 BOX_QTY,a.CODE_DESC3 CARTON_QTY,a.CODE_DESC4 CARTON_SIZE,a.CODE_DESC5 CARTON_WEIGHT,a.code_desc6 PACKAGINGDESCRIPTION"+
          "        FROM yew_mfg_defdata a WHERE DEF_TYPE='ON') on_packing"+ 
		  "       ,oraddman.tsc_f400_product tfp"+ //add by Peggy 20230214
		  //"       ,oraddman.tsc_distribution_price_book tdpb"+ //add by Peggy 20231002
          "       WHERE 1=1"+
		  "       AND a.ITEM_DESC1=tpi.PART_NO_LIST(+)"+
		  "       AND a.TSC_PACKAGE=tpii.TSC_PACKAGE(+)"+
		  "       AND substr(upper(TRIM(a.PACKAGE_CODE)),1,2)=tpii.PackingCode(+)"+
		  "       AND case when UPPER(a.TSC_PROD_GROUP)='PRD-SUBCON' or upper(a.TSC_PACKAGE)='I2PAK' THEN 'PRD' else a.TSC_PROD_GROUP END =tpii.GROUPTYPE(+)"+
		  "       AND a.description=tsbp.tsc_partno(+)"+ //add by Peggy 20181112
		  "       AND a.part_id=tsbpt.part_id(+)"+ //add by Peggy 20210729
		  "       AND a.TSC_PACKAGE=on_packing.TSC_PACKAGE(+)"+ //add by Peggy 20181115
		  //"       AND a.description=tdpb.tsc_ordering_code(+)"+ //add by Peggy 20231002  
		  "       AND a.description=tfp.tsc_ordering_code(+)"; //add by Peggy 20230214
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (rs.getString("PACKAGE_CODE") ==null || rs.getInt("ITEM_CNT")!=1 ) continue; //add by Peggy 20181023
		if (reccnt==0)
		{
			col=0;row=0;
			
			//資料日期
			ws.mergeCells(col, row, col+2, row);     
			ws.addCell(new jxl.write.Label(col, row, "資料日期:" +dateBean.getDate(), LeftBLY));
			row++;
						
			//22/30-Digit-Code
			ws.addCell(new jxl.write.Label(col, row, "22/30-Digit-Code" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			//PART ID--add by Peggy 20180718
			ws.addCell(new jxl.write.Label(col, row, "PART ID" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;
			

			//PACKAGE CODE
			ws.addCell(new jxl.write.Label(col, row, "PACKAGE CODE" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;			
			
			//TSC PART NO rename to TSC Ordering Code, for mabel issue 20180718
			ws.addCell(new jxl.write.Label(col, row, "TSC Ordering Code" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;
			
			//PROD GROUP
			ws.addCell(new jxl.write.Label(col, row, "PROD GROUP" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//TSC PROD CATEGORY,add by Peggy 20180222
			ws.addCell(new jxl.write.Label(col, row, "TSC Prod Category" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//FAMILY
			ws.addCell(new jxl.write.Label(col, row, "FAMILY" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//PROD FAMILY
			ws.addCell(new jxl.write.Label(col, row, "PROD FAMILY" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//PACKAGE
			ws.addCell(new jxl.write.Label(col, row, "PACKAGE" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			////PACKAGE TYPE
			//ws.addCell(new jxl.write.Label(col, row, "PACKAGE TYPE" , ACenterBLB));
			//ws.setColumnView(col,20);	
			//col++;	

			//SPQ
			ws.addCell(new jxl.write.Label(col, row, "SPQ" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//MOQ
			ws.addCell(new jxl.write.Label(col, row, "MOQ" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//SAMPLE SPQ
			ws.addCell(new jxl.write.Label(col, row, "SAMPLE SPQ" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//Lead Time(Week)
			ws.addCell(new jxl.write.Label(col, row, "Standard Lead Time(Week)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//No Wafer Lead Time(Week)
			//ws.addCell(new jxl.write.Label(col, row, "No Wafer Lead Time(Week)" , ACenterBLB));
			//ws.setColumnView(col,15);	
			//col++;	

			//PRICE
			ws.addCell(new jxl.write.Label(col, row, "PRICE" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		

			////TSCE PRICE
			//ws.addCell(new jxl.write.Label(col, row, "TSCE PRICE" , ACenterBLB));
			//ws.setColumnView(col,15);	
			//col++;		

			//UOM
			ws.addCell(new jxl.write.Label(col, row, "UOM" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//PRICE last update date
			ws.addCell(new jxl.write.Label(col, row, "PRICE LAST UPDATE DATE" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		

			//22D
			ws.addCell(new jxl.write.Label(col, row, "22D Creation Date" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		

			////Bottom price (USD/PCS)
			//ws.addCell(new jxl.write.Label(col, row, " Bottom Price (USD/PCS)" , ACenterBLB));
			//ws.setColumnView(col,15);	
			//col++;		

			////Sales Head price (USD/PCS)
			//ws.addCell(new jxl.write.Label(col, row, " Sales Head price (USD/PCS)" , ACenterBLB));
			//ws.setColumnView(col,15);	
			//col++;
			
			//Factory
			ws.addCell(new jxl.write.Label(col, row, "Factory" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Factory
			ws.addCell(new jxl.write.Label(col, row, "RFQ Factory Code" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//COO,add by Peggy 20180810
			ws.addCell(new jxl.write.Label(col, row, "COO" , ACenterBLB));
			ws.setColumnView(col,7);	
			col++;				

			//COO,add by Peggy 20200203
			ws.addCell(new jxl.write.Label(col, row, "COO(TSCA use only)" , ACenterBLB));
			ws.setColumnView(col,7);	
			col++;				
			
			////Part Name
			//ws.addCell(new jxl.write.Label(col, row, "Part Name" , ACenterBLB));
			//ws.setColumnView(col,15);	
			//col++;	
			
			//Series AECQ
			//ws.addCell(new jxl.write.Label(col, row, "Series AECQ" , ACenterBLB));
			ws.addCell(new jxl.write.Label(col, row, "AEC-Q101" , ACenterBLB)); //rename to AEC-Q101,add by Peggy 2
			ws.setColumnView(col,10);	
			col++;	

			//Description
			ws.addCell(new jxl.write.Label(col, row, "Description" , ACenterBLB));
			ws.setColumnView(col,35);	
			col++;	

			//MSL,add by Peggy 20190328
			ws.addCell(new jxl.write.Label(col, row, "MSL" , ACenterBLB));
			ws.setColumnView(col,5);	
			col++;	

			//website status
			ws.addCell(new jxl.write.Label(col, row, "Website Status" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			////Sales website status
			//ws.addCell(new jxl.write.Label(col, row, "Sales Website Status" , ACenterBLB));
			//ws.setColumnView(col,12);	
			//col++;	

			////Obsolete timestamp
			//ws.addCell(new jxl.write.Label(col, row, "Obsolete Timestamp" , ACenterBLB));
			//ws.setColumnView(col,12);	
			//col++;	
			
			//Packaging Description,add by Peggy 20180928
			ws.addCell(new jxl.write.Label(col, row, "Packaging Description" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Reel(PC)
			ws.addCell(new jxl.write.Label(col, row, "Reel(PC)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Inner Box(PC)
			ws.addCell(new jxl.write.Label(col, row, "Inner Box(PC)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Carton(PC)
			ws.addCell(new jxl.write.Label(col, row, "Carton(PC)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Carton Size
			ws.addCell(new jxl.write.Label(col, row, "Carton Size(mm)" , ACenterBLB));
			ws.setColumnView(col,16);	
			col++;	

			//Carton Weight
			ws.addCell(new jxl.write.Label(col, row, "Gross Weight(kg/Carton)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//PCN/PDN
			ws.addCell(new jxl.write.Label(col, row, "PCN/PDN" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//Product Group 8
			ws.addCell(new jxl.write.Label(col, row, "Product Group 8" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Prod Group(TSCA local use)
			ws.addCell(new jxl.write.Label(col, row, "Prod Group 5" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
				
			//Part Name create Date
			ws.addCell(new jxl.write.Label(col, row, "Part Name create Date" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		
		
			////Last Order Date,add by Peggy 20180202
			//ws.addCell(new jxl.write.Label(col, row, "Last Order Date" , ACenterBLB));
			//ws.setColumnView(col,15);	
			//col++;		

			//HTS Code,add by Peggy 20180620
			ws.addCell(new jxl.write.Label(col, row, "TARIC Code" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
			
			////HTS Code,add by Peggy 20191209
			//ws.addCell(new jxl.write.Label(col, row, "HTS Code(TSCA local use)" , ACenterBLB));
			//ws.setColumnView(col,10);	
			//col++;			

			////ORG:IM status,add by Peggy 20190218
			//ws.addCell(new jxl.write.Label(col, row, "IM Org Status" , ACenterBLB));
			//ws.setColumnView(col,10);	
			//col++;		

			////ORDER_ENABLED_FLAG,add by Peggy 20190218
			//ws.addCell(new jxl.write.Label(col, row, "允許下單" , ACenterBLB));
			//ws.setColumnView(col,10);	
			//col++;		

			////TW_VENDOR_FLAG,add by Peggy 20200130
			//ws.addCell(new jxl.write.Label(col, row, "TW Vendor" , ACenterBLB));
			//ws.setColumnView(col,8);	
			//col++;		

			////Arrow Book Cost,add by Peggy 20210126
			//ws.addCell(new jxl.write.Label(col, row, "Arrow book Cost(USD/PC)" , ACenterBLB));
			//ws.setColumnView(col,10);	
			//col++;	
			
			////Avnet /Future Book cost,add by Peggy 20210126
			//ws.addCell(new jxl.write.Label(col, row, "Avnet/Future Book cost(USD/PC)" , ACenterBLB));
			//ws.setColumnView(col,10);	
			//col++;
			
			////MPP for Arrow Avnet and Future,add by Peggy 20210126
			//ws.addCell(new jxl.write.Label(col, row, "MPP for Arrow/Avnet/Future (USD/PC)" , ACenterBLB));
			//ws.setColumnView(col,10);	
			//col++;
			
			////MOQ_MPP for Arrow/Avnet/Future,add by Peggy 20210322
			//ws.addCell(new jxl.write.Label(col, row, "MOQ_MPP for Arrow/Avnet/Future(PC)" , ACenterBLB));
			//ws.setColumnView(col,10);	
			//col++;	
			
			////Catalog price (USD/PC),add by Peggy 20210322
			//ws.addCell(new jxl.write.Label(col, row, "Catalog price (USD/PC)" , ACenterBLB));
			//ws.setColumnView(col,10);	
			//col++;	
			
			//NPI released to Web,add by Peggy 20211130
			ws.addCell(new jxl.write.Label(col, row, "NPI released to Web" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//TSC PROD HIERARCHY1
			ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 1" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;
			
			//TSC PROD HIERARCHY2
			ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 2" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;
			
			//TSC PROD HIERARCHY3
			ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 3" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;
			
			///TSC PROD HIERARCHY3
			ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 4" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;												
								
			row++;

		}
		col=0;

		ws.addCell(new jxl.write.Label(col, row, rs.getString("SEGMENT1"), ALeftL));
		col++;	
		//if (rs.getString("PACKAGE_CODE").indexOf("QQ")>=0) //add by Peggy 20201021
		//{
		//	strPartName=rs.getString("DESCRIPTION");
		//}
		//else
		//{		
		//	strPartName=rs.getString("DESCRIPTION").substring(0, rs.getString("DESCRIPTION").length()-rs.getString("PACKAGE_CODE").length()).trim();
		//}
		//ws.addCell(new jxl.write.Label(col, row, strPartName, ALeftL)); //add by Peggy 20180718
		ws.addCell(new jxl.write.Label(col, row,rs.getString("PART_ID"), ALeftL)); //add by Peggy 20210729
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PACKAGE_CODE").indexOf("QQ")>=0?"":rs.getString("PACKAGE_CODE")) , (rs.getString("prefeered_packing_code_flag")!=null && rs.getString("prefeered_packing_code_flag").equals("Y")?ALeftLR:ALeftL)));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION"), ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PROD_GROUP")==null?"":rs.getString("TSC_PROD_GROUP")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PROD_CATEGORY")==null?"":rs.getString("TSC_PROD_CATEGORY")) , ALeftL));  //add by Peggy 20180222
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_FAMILY")==null?"":rs.getString("TSC_FAMILY")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PROD_FAMILY")==null?"":rs.getString("TSC_PROD_FAMILY")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PACKAGE")==null?"":rs.getString("TSC_PACKAGE")) , ALeftL));
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, (rs.getString("PACKAGE_TYPE")==null?"":rs.getString("PACKAGE_TYPE")) , ALeftL)); //add by Peggy 20191209
		//col++;	
		if (rs.getString("SPQ")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SPQ")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("MOQ")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("MOQ")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("SAMPLE_SPQ")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SAMPLE_SPQ")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("LEAD_TIME")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
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
		if (rs.getString("PRICE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
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
		ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("price_last_update_date") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("item_creation_date") , ACenterL));
		col++;	
		//if (rs.getString("BOTTOM_PRICE")==null)
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		//}
		//else
		//{		
		//	ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("BOTTOM_PRICE")).doubleValue(), ARightL));
		//}
		//col++;	
		////add by Peggy 20190321
		//if (rs.getString("SALES_HEAD_PRICE")==null)
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		//}
		//else
		//{		
		//	ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SALES_HEAD_PRICE")).doubleValue(), ARightL));
		//}
		//col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("factory_code") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("attribute3") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("coo") , ACenterL)); //add by Peggy 20180810
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("coo_code") , ACenterL)); //add by Peggy 20200203
		col++;		
		//if (rs.getString("DESCRIPTION").startsWith("HER104G-K") || (rs.getString("DESCRIPTION").startsWith("BZW04-") && !rs.getString("DESCRIPTION").startsWith("BZW04-171-01")))
		//{
		//	//ws.addCell(new jxl.write.Label(col, row, (strPartName.endsWith("H")?strPartName.substring(0,strPartName.length()-1) :strPartName), ALeftL)); //add by Peggy 20180718
		//	ws.addCell(new jxl.write.Label(col, row, (rs.getString("part_id").endsWith("H")?rs.getString("part_id").substring(0,rs.getString("part_id").length()-1) :rs.getString("part_id")), ALeftL)); //add by Peggy 20210729
		//}
		//else if (rs.getString("DESCRIPTION").startsWith("SMBJ5.0CA-ON-01"))
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "SMBJ5.0CA" , ALeftL));
		//}
		//else
		//{	
		//	ws.addCell(new jxl.write.Label(col, row, rs.getString("item_desc") , ALeftL));
		//}
		//col++;	
		//ws.addCell(new jxl.write.Label(col, row, (rs.getString("series_aecq")==null?"":rs.getString("series_aecq")), ACenterL));
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("AEC_Q101")==null?"":rs.getString("AEC_Q101")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("part_spec")==null?"":rs.getString("part_spec")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("msl")==null||rs.getString("msl").equals("0")?"":rs.getString("msl")) , ALeftL));  //add by Peggy 20190328
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, (rs.getString("website_status")==null?"":rs.getString("website_status")) , ACenterL));
		if (rs.getString("DESCRIPTION").equals("TSM3446CX6 RKG"))  //add by Pegg 20240524 from Mabel mail notice
		{
			ws.addCell(new jxl.write.Label(col, row, "Obsolete" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("website_status")==null?"":rs.getString("website_status")) , ACenterL));
		}		
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, (rs.getString("website_status")==null?"":rs.getString("website_status")) , ACenterL));
		//if (rs.getString("TSC_PROD_GROUP")!=null && rs.getString("TSC_PROD_GROUP").equals("PRD") && rs.getString("PACKAGE_CODE").indexOf("QQ")<0)//add by Peggy 20200421
		//{
		//	if (rs.getString("TSC_PACKAGE")!=null && ((rs.getString("TSC_PACKAGE").equals("C-SMA") && rs.getString("TSC_FAMILY") != null && !rs.getString("TSC_FAMILY").equals("Trench SKY")) || rs.getString("TSC_PACKAGE").equals("Folded SMA") || rs.getString("TSC_PACKAGE").equals("SMA") || rs.getString("TSC_PACKAGE").equals("SMB") || (rs.getString("TSC_PACKAGE").equals("SMC") && !rs.getString("DESCRIPTION").startsWith("5.0SMDJ"))))
		//	{
		//		if (rs.getString("website_status")!=null && rs.getString("website_status").equals("Active"))
		//		{
		//			ws.addCell(new jxl.write.Label(col, row, "NRND" , ACenterL));
		//		}
		//	}
		//}
		//col++;		
		//ws.addCell(new jxl.write.Label(col, row, (rs.getString("obsolete_timestamp")==null?"":rs.getString("obsolete_timestamp")) , ACenterL));
		//col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKAGINGDESCRIPTION") , ACenterL));  //add by Peggy 20180928
		col++;	
		if (rs.getString("reel_pc")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("reel_pc")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("innerbox_pc")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("innerbox_pc")).doubleValue(), ARightL));
		}
		col++;				
		if (rs.getString("carton_pc")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("carton_pc")).doubleValue(), ARightL));
		}
		col++;
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CartonSize_mm")==null?"":rs.getString("CartonSize_mm")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("GW_KG_CARTON")==null?"":rs.getString("GW_KG_CARTON")) , ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("pcn_list") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("Product_Group_8") , ALeftL));  //modify by Peggy 20170510
		col++;	
		if (rs.getString("Product_Group_8") != null)
		{
			if (rs.getString("Product_Group_8").equals("LIGHTING IC")) //add by Peggy 20191212
			{
				ws.addCell(new jxl.write.Label(col, row, "PMD" , ALeftL));  
			}
			else if (rs.getString("Product_Group_8").equals("MOSFET-Subcon") || rs.getString("Product_Group_8").equals("Super Junction") || rs.getString("Product_Group_8").equals("Super Junction-Subcon"))  //add Super Junction-Subcon by Peggy 20210721
			{
				ws.addCell(new jxl.write.Label(col, row, "MOSFET" , ALeftL));  
			}
			else if (rs.getString("Product_Group_8").equals("PRD-Subcon") || rs.getString("Product_Group_8").equals("TRENCH SCHOTTKY")) 
			{
				ws.addCell(new jxl.write.Label(col, row, "PRD" , ALeftL));  
			}
			else
			{
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("Product_Group_8")==null?"":rs.getString("Product_Group_8")) , ALeftL));
			}
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));  //modify by Peggy 20170510
		}
		col++;
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("NEW_PARTS_RELEASE_DATE")==null?"":rs.getString("NEW_PARTS_RELEASE_DATE")) , ACenterL));
		col++;		
		//ws.addCell(new jxl.write.Label(col, row, rs.getString("PARTS_RELEASE_DATE") , ACenterL));
		//col++;	
		//ws.addCell(new jxl.write.Label(col, row, rs.getString("last_order_date") , ACenterL));  //add by Peggy 20180202
		//col++;	
		//ws.addCell(new jxl.write.Label(col, row,  (rs.getString("attribute3")==null?"":((rs.getString("attribute3").equals("002") || rs.getString("attribute3").equals("008"))?"85411000":"")) , ACenterL));  //add by Peggy 20180602
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("cccode")==null?"":rs.getString("cccode")) , ACenterL));  //add by Peggy 20180813
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, (rs.getString("HTS_CODE")==null?"":rs.getString("HTS_CODE")) , ACenterL));  //add by Peggy 20191209
		//col++;	
		/*ws.addCell(new jxl.write.Label(col, row, (rs.getString("im_status")==null?"":rs.getString("im_status")) , ACenterL));  //add by Peggy 20190218
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_ENABLED_FLAG") , ACenterL));  //add by Peggy 20190218
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TW_VENDOR_FLAG") , ACenterL));  //add by Peggy 20200130
		col++;	
		if (rs.getString("arrow_book_cost")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("arrow_book_cost")).doubleValue(), ARightL));
		}
		col++;
		if (rs.getString("avnet_future_book_cost")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("avnet_future_book_cost")).doubleValue(), ARightL));
		}
		col++;
		if (rs.getString("mpp_for_arrow_avnet_future")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("mpp_for_arrow_avnet_future")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("moq_for_arrow_avnet_future")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("moq_for_arrow_avnet_future")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("catalog_price")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("catalog_price")).doubleValue(), ARightL));
		}
		col++;	
		*/	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("first_on_website_date")==null?"":rs.getString("first_on_website_date")) , ACenterL)); //add by Peggy 20211130
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_prod_hierarchy_1")==null?"":rs.getString("TSC_prod_hierarchy_1")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_prod_hierarchy_2")==null?"":rs.getString("TSC_prod_hierarchy_2")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_prod_hierarchy_3")==null?"":rs.getString("TSC_prod_hierarchy_3")) , ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_prod_hierarchy_4")==null?"":rs.getString("TSC_prod_hierarchy_4")) , ALeftL));
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
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
		}
		else
		{
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("judy.cho@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("perry.juan@ts.com.tw"));
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("celine.yu@ts.com.tw"));
			message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("ks.foo@ts.com.tw"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("mars.wang@ts.com.tw"));
		
		if (DATATYPE.equals("ALL"))
		{
			message.setSubject("TS Item Price Report(Include Inactive)"+" - "+dateBean.getYearMonthDay()+(SYSDATE.equals("")?"":"(price date"+SYSDATE+")")+remarks);
		}
		else if (DATATYPE.equals("INACTIVE"))
		{
			message.setSubject("TS Item Price Report(Inactive)"+" - "+dateBean.getYearMonthDay()+(SYSDATE.equals("")?"":"(price date"+SYSDATE+")")+remarks);
		}
		else
		{
			message.setSubject("TS Item Price Report - "+dateBean.getYearMonthDay()+(SYSDATE.equals("")?"":"(price date"+SYSDATE+")")+remarks);
		}
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		if (request.getRequestURL().toString().toLowerCase().indexOf("10.0.3.109")>=0)
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
		//mbp = new javax.mail.internet.MimeBodyPart();
		//javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		//mbp.setDataHandler(new javax.activation.DataHandler(fds));
		//mbp.setFileName(fds.getName());
	
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
