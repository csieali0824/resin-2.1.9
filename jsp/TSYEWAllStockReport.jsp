<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,java.lang.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>YEW All Stock Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSYEWAllStockReport.jsp" METHOD="post" name="MYFORM">
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
//String EDATE=request.getParameter("EDATE");
//if (EDATE==null) EDATE="";
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
String FileName="",RPTName="",PLANTNAME="",ERP_USERID="",remarks="",sql="",item_desc="",s_debug="";
int fontsize=8,colcnt=0,sheetcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
int row =0,col=0,reccnt=0;
String trans_date="";
try 
{ 	
	OutputStream os = null;	
	RPTName = SDATE+" - YEW All Stock Report";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("sheet1", 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBL = new WritableCellFormat(font_bold);   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(false);	
			
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
	
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(false);

	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
	
	sql = " select tot.ITEM_TYPE_NAME "+
          ",tot.ORG_CODE"+
		  ",tot.ITEM_NO"+
		  ",tot.DESCRIPTION"+
          ",tot.SUB_INV"+
          ",tot.LOC"+
          ",tot.LOT_NO"+
          ",TSC_GET_CALENDAR_WEEK(add_months(tot.EXPIRATION_DATE,CASE WHEN tot.ITEM_TYPE IN ('SA','FG') THEN -12 ELSE 0 END),'YYMM') as EXP_YYMM"+
          ",TSC_GET_CALENDAR_WEEK(add_months(tot.EXPIRATION_DATE,CASE WHEN tot.ITEM_TYPE IN ('SA','FG') THEN -12 ELSE 0 END),'YEAR') as MFG_YY"+
          ",tot.DEPT"+
          ",tot.WAFER_LOT_NO"+
          ",tot.VENDOR"+
          ",tot.QUANTITY"+
		  ",tot.uom"+//add by Peggy 20200902
          ",to_char(tot.RECEIVED_DATE,'yyyy/mm/dd') RECEIVED_DATE"+
          ",to_char(tot.EXPIRATION_DATE,'yyyy/mm/dd') EXPIRATION_DATE"+
          ",tot.tsc_package"+
          ",tot.PACKAGE_TYPE"+
          ",tot.TSC_FAMILY"+
		  ",to_char(tot.TRANSACTION_DATE,'yyyy/mm/dd') TRANSACTION_DATE"+  //add by Peggy 20181115
          " from (SELECT  msi.item_type,case msi.item_type when 'FG' then '成品' WHEN 'SA' THEN '半成品' WHEN 'CHIP' THEN '晶片晶粒' ELSE '原物料' END AS ITEM_TYPE_NAME, decode(moqd.organization_id,'326','Y1','327','Y2') org_code,msi.segment1 item_no "+
          "      ,msi.description"+
		  "      ,moqd.subinventory_code sub_inv"+
		  "      ,mii.attribute2  as LOC"+
          "      ,moqd.lot_number lot_no"+
		  "      ,wlot.WAFER_LOT_NO"+
          //"      ,SUM (moqd.transaction_quantity) quantity"+
          //"      ,moqd.transaction_uom_code uom"+
          "      ,case when moqd.transaction_uom_code='KPC' AND msi.uom='PCE' then SUM (moqd.transaction_quantity) *1000 when moqd.transaction_uom_code='PCE' AND msi.uom='KPC' then SUM (moqd.transaction_quantity) /1000 else SUM (moqd.transaction_quantity) end  quantity"+
          "      ,msi.uom"+
		  "      ,trunc(moqd.ORIG_DATE_RECEIVED) RECEIVED_DATE"+
          "      ,trunc(nvl(ML.EXPIRATION_DATE,  CASE WHEN  ( MSI.ITEM_TYPE IN ('SA','FG') AND LENGTH(trim(moqd.lot_number)) IN (12,13)  and substr(trim(moqd.lot_number),3,1)='-'  and substr(trim(moqd.lot_number),-4,1)='-' and substr(trim(moqd.lot_number),6,2)<=12  )THEN add_months(to_date(substr(trim(moqd.lot_number),4,6),'yy/mm/dd'),12) "+
          "        ELSE  NULL END )) EXPIRATION_DATE"+
		  "      ,TSC_INV_Category(moqd.inventory_item_id, moqd.organization_id, 23) TSC_PACKAGE "+
		  "      ,TSC_INV_Category(moqd.inventory_item_id, moqd.organization_id, 21) TSC_FAMILY "+
		  "      ,ymd.dept"+
		  "      ,ymd.package_type"+
          "      ,CASE WHEN   MSI.ITEM_TYPE IN ('SA','FG') THEN wlot.wafer_vendor ELSE  iqc.supplier_site_name END AS vendor"+
		  "      ,(SELECT TRUNC(MAX(TRANSACTION_DATE))  FROM inv.MTL_MATERIAL_TRANSACTIONS A"+
          "        WHERE TRANSACTION_QUANTITY <0"+
          "        AND a.ORGANIZATION_ID=msi.ORGANIZATION_ID"+
          "        AND a.INVENTORY_ITEM_ID=msi.INVENTORY_ITEM_ID"+
		  "        AND a.TRANSACTION_TYPE_ID IN (35,33)"+
          //"        AND NOT EXISTS ( SELECT 1 FROM FND_USER B WHERE B.USER_NAME IN ('ZHANG_AIXIN','ZHAO_FANGFANG') AND B.USER_ID=A.CREATED_BY)"+
		  "        ) TRANSACTION_DATE"+ //add by Peggy 20181115
          "      FROM mtl_onhand_quantities_detail moqd"+
		  "      ,(select * from MTL_LOT_NUMBERS where organization_id IN (326, 327)) ML"+
		  "      ,(SELECT organization_id, inventory_item_id, segment1, description, item_type,primary_unit_of_measure uom FROM mtl_system_items_b where organization_id IN (326, 327)) msi"+
		  "      ,(SELECT ywa.WAFER_LOT_NO,yra.runcard_no ,ywa.wafer_vendor FROM yew_workorder_all ywa ,yew_runcard_all yra  WHERE ywa.wo_no=yra.wo_no  AND ywa.workorder_type='2') wlot"+
		  "      ,MTL_ITEM_SUB_INVENTORIES mii "+
          "      ,yew_mfg_dept ymd "+
          //"      ,(SELECT tld.inv_item_id,tld.supplier_lot_no,tlh.supplier_site_name from oraddman.tsciqc_lotinspect_header  tlh,oraddman.tsciqc_lotinspect_detail tld  WHERE tlh.insplot_no=tld.insplot_no) iqc"+
		  "      ,(SELECT distinct tlh.organization_id,tld.inv_item_id,tld.supplier_lot_no,tlh.supplier_site_name from oraddman.tsciqc_lotinspect_header  tlh,oraddman.tsciqc_lotinspect_detail tld  WHERE tlh.insplot_no=tld.insplot_no) iqc"+ //modify by Peggy 20200821
          "      WHERE moqd.inventory_item_id = msi.inventory_item_id "+
          "      AND moqd.organization_id = msi.organization_id "+    
          "      AND moqd.organization_id IN (326, 327) "+     
          "      AND moqd.inventory_item_id = ML.inventory_item_id(+) "+ 
          "      AND moqd.organization_id = ML.organization_id(+) "+    
          "      AND moqd.lot_number =wlot.runcard_no(+) "+    
          "      AND NVL(moqd.lot_number,'xx') = NVL(ML.lot_number,'xx') "+
          "      AND moqd.inventory_item_id = mii.inventory_item_id(+) "+
          "      AND moqd.organization_id = mii.organization_id(+) "+
          "      AND moqd.subinventory_code = mii.SECONDARY_INVENTORY(+)  "+
          "      AND NVL(TSC_OM_CATEGORY(moqd.inventory_item_id,moqd.organization_id,'TSC_Package'),'XX')= ymd.tsc_package(+)"+
		  "      AND moqd.organization_id=iqc.organization_id(+)"+ //add by Peggy 20210610
          "      AND moqd.inventory_item_id=iqc.inv_item_id(+)"+
          "      AND moqd.lot_number= iqc.supplier_lot_no(+)"+
          "      GROUP BY moqd.organization_id,msi.segment1,msi.description,moqd.subinventory_code,WAFER_LOT_NO,MSI.ITEM_TYPE"+
          "      ,moqd.lot_number,moqd.transaction_uom_code,msi.uom,ML.EXPIRATION_DATE,moqd.ORIG_DATE_RECEIVED ,mii.attribute2,moqd.inventory_item_id"+
          "      ,ymd.dept, ymd.package_type,wlot.wafer_vendor,iqc.supplier_site_name,msi.inventory_item_id,msi.organization_id"+
          "      ORDER BY moqd.organization_id,moqd.subinventory_code,msi.segment1,ML.EXPIRATION_DATE) tot";
	/*sql = " select tot.ITEM_TYPE_NAME "+
          ",tot.ORG_CODE"+
          ",tot.ITEM_NO"+
          ",tot.DESCRIPTION"+
          ",tot.SUB_INV"+
          ",tot.LOC"+
          ",tot.LOT_NO"+
          ",TSC_GET_CALENDAR_WEEK(add_months(tot.EXPIRATION_DATE,CASE WHEN tot.ITEM_TYPE IN ('SA','FG') THEN -12 ELSE 0 END),'YYMM') as EXP_YYMM"+
          ",TSC_GET_CALENDAR_WEEK(add_months(tot.EXPIRATION_DATE,CASE WHEN tot.ITEM_TYPE IN ('SA','FG') THEN -12 ELSE 0 END),'YEAR') as MFG_YY"+
          ",tot.DEPT"+
          ",tot.WAFER_LOT_NO"+
          ",tot.VENDOR"+
          ",tot.QUANTITY"+
          ",to_char(tot.RECEIVED_DATE,'yyyy/mm/dd') RECEIVED_DATE"+
          ",to_char(tot.EXPIRATION_DATE,'yyyy/mm/dd') EXPIRATION_DATE"+
          ",tot.tsc_package"+
          ",tot.PACKAGE_TYPE"+
          ",tot.TSC_FAMILY"+
		  //",to_char((select MAX (transaction_date) from inv.mtl_material_transactions x where x.inventory_item_id=tot.inventory_item_id and x.organization_id=tot.organization_id and x.transaction_date>=to_date('20100101','yyyymmdd') and x.transaction_type_id IN (35, 33) and x.created_by not in (5689,5698)),'yyyy/mm/dd') transaction_date"+
          //",to_char(tot.TRANSACTION_DATE,'yyyy/mm/dd') TRANSACTION_DATE"+
		  ",tot.inventory_item_id"+
		  ",tot.organization_id"+
          " from (SELECT  msi.item_type,case msi.item_type when 'FG' then '成品' WHEN 'SA' THEN '半成品' WHEN 'CHIP' THEN '晶片晶粒' ELSE '原物料' END AS ITEM_TYPE_NAME, decode(moqd.organization_id,'326','Y1','327','Y2') org_code,msi.segment1 item_no "+
          "      ,msi.description"+
          "      ,moqd.organization_id"+
          "      ,moqd.inventory_item_id"+
          "      ,moqd.subinventory_code sub_inv"+
          "      ,mii.attribute2  as LOC"+
          "      ,moqd.lot_number lot_no"+
          "      ,wlot.WAFER_LOT_NO"+
          "      ,SUM (moqd.transaction_quantity) quantity"+
          "      ,moqd.transaction_uom_code uom"+
          "      ,trunc(moqd.ORIG_DATE_RECEIVED) RECEIVED_DATE"+
          "      ,trunc(nvl(ML.EXPIRATION_DATE,  CASE WHEN  ( MSI.ITEM_TYPE IN ('SA','FG') AND LENGTH(trim(moqd.lot_number)) IN (12,13)  and substr(trim(moqd.lot_number),3,1)='-' and substr(trim(moqd.lot_number),-4,1)='-' and substr(trim(moqd.lot_number),6,2)<=12  )THEN add_months(to_date(substr(trim(moqd.lot_number),4,6),'yy/mm/dd'),12) "+
          "        ELSE  NULL END )) EXPIRATION_DATE"+
          "      ,TSC_INV_Category(moqd.inventory_item_id, moqd.organization_id, 23) TSC_PACKAGE "+
          "      ,TSC_INV_Category(moqd.inventory_item_id, moqd.organization_id, 21) TSC_FAMILY"+
          "      ,ymd.dept"+
          "      ,ymd.package_type"+
          "      ,CASE WHEN  MSI.ITEM_TYPE IN ('SA','FG') THEN wlot.wafer_vendor ELSE  iqc.supplier_site_name END AS vendor"+
          //"      ,moqd.TRANSACTION_DATE"+
          "      FROM (SELECT moqd.lot_number , moqd.inventory_item_id, moqd.organization_id,"+
          "            moqd.subinventory_code,"+
          "            moqd.transaction_uom_code,"+
          "            moqd.orig_date_received ,"+
          //"            SUM (moqd.transaction_quantity) transaction_quantity,"+
		  "            sum(moqd.PRIMARY_TRANSACTION_QUANTITY) transaction_quantity"+ //modify by Peggy 20190119
          //"            a.transaction_date"+
          "            FROM mtl_onhand_quantities_detail moqd"+
		  //", (select inventory_item_id,organization_id,MAX (transaction_date) transaction_date from inv.mtl_material_transactions where organization_id in (326, 327) and transaction_type_id IN (35, 33) and created_by not in (5689,5698) group by inventory_item_id,organization_id) a"+
          "            WHERE     moqd.organization_id in (326, 327)"+
          //"            AND moqd.inventory_item_id = a.inventory_item_id(+)"+
          //"            AND moqd.organization_id = a.organization_id(+)"+
          "            GROUP BY moqd.lot_number,"+
          "                     moqd.inventory_item_id,"+
          "                     moqd.organization_id,"+
          "                     moqd.subinventory_code,"+
          "                     moqd.transaction_uom_code,"+
          "                     moqd.orig_date_received"+
		  //"                     a.TRANSACTION_DATE"+
		  "                     ) moqd"+
          "     ,MTL_LOT_NUMBERS ML"+
          "     ,(SELECT organization_id, inventory_item_id, segment1, description, item_type FROM mtl_system_items_b) msi"+
          "     ,(SELECT ywa.WAFER_LOT_NO,yra.runcard_no ,ywa.wafer_vendor FROM yew_workorder_all ywa ,yew_runcard_all yra  WHERE ywa.wo_no=yra.wo_no  AND ywa.workorder_type='2') wlot"+
          "     ,MTL_ITEM_SUB_INVENTORIES mii "+
          "     ,yew_mfg_dept ymd "+
          "     ,(select x.inv_item_id,x.supplier_lot_no,listagg(x.supplier_site_name,',') within group (order by x.supplier_site_name) supplier_site_name from (select distinct tld.inv_item_id,tld.supplier_lot_no,tlh.supplier_site_name  from oraddman.tsciqc_lotinspect_header tlh,oraddman.tsciqc_lotinspect_detail tld  WHERE tlh.insplot_no=tld.insplot_no) x  group by x.inv_item_id,x.supplier_lot_no) iqc"+
          "     WHERE ml.organization_id in (326,327)"+
		  "      AND moqd.inventory_item_id = msi.inventory_item_id "+
          "      AND moqd.organization_id = msi.organization_id  "+
          "      AND moqd.organization_id IN (326, 327) "+
          "      AND moqd.inventory_item_id = ML.inventory_item_id(+) "+
          "      AND moqd.organization_id = ML.organization_id(+)  "+ 
          "      AND moqd.lot_number =wlot.runcard_no(+) "+
          //"      AND NVL(moqd.lot_number,'xx') = NVL(ML.lot_number,'xx') "+
		  "      AND nvl(moqd.lot_number,'xx') = ML.lot_number(+)"+
          "      AND moqd.inventory_item_id = mii.inventory_item_id(+)"+
          "      AND moqd.organization_id = mii.organization_id(+) "+
          "      AND moqd.subinventory_code = mii.SECONDARY_INVENTORY(+)  "+
          "      AND NVL(TSC_OM_CATEGORY(moqd.inventory_item_id,moqd.organization_id,'TSC_Package'),'XX')= ymd.tsc_package(+)"+
          "      AND moqd.inventory_item_id=iqc.inv_item_id(+)"+
          "      AND moqd.lot_number= iqc.supplier_lot_no(+)"+
          "      GROUP BY moqd.organization_id,msi.segment1,msi.description,moqd.subinventory_code,WAFER_LOT_NO,MSI.ITEM_TYPE"+
          "      ,moqd.lot_number,moqd.transaction_uom_code,ML.EXPIRATION_DATE,moqd.ORIG_DATE_RECEIVED ,mii.attribute2,moqd.inventory_item_id"+
          "      ,ymd.dept, ymd.package_type,wlot.wafer_vendor,iqc.supplier_site_name"+
		  //"      ,moqd.TRANSACTION_DATE"+
          "     ORDER BY moqd.organization_id,moqd.subinventory_code,msi.description,msi.segment1,ML.EXPIRATION_DATE) tot";*/
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	row=0;col=0;
	PreparedStatement statement2=null;ResultSet rs2=null;
	while (rs.next()) 
	{	
		if (row==0)
		{	
			col=0;
			//物料分類
			ws.addCell(new jxl.write.Label(col, row, "物料分類" , ACenterBL));
			ws.setColumnView(col,14);	
			col++;					
	
			//ORG_CODE
			ws.addCell(new jxl.write.Label(col, row, "ORG_CODE" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;					
				
			//ITEM_NO
			ws.addCell(new jxl.write.Label(col, row, "ITEM_NO" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;	
						
			//DESCRIPTION
			ws.addCell(new jxl.write.Label(col, row, "DESCRIPTION" , ACenterBL));
			ws.setColumnView(col,35);	
			col++;	
	
			//SUB_INV
			ws.addCell(new jxl.write.Label(col, row, "SUB_INV" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
	
			//LOC
			ws.addCell(new jxl.write.Label(col, row, "LOC" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//LOT_NO
			ws.addCell(new jxl.write.Label(col, row, "LOT_NO" , ACenterBL));
			ws.setColumnView(col,20);
			col++;	
	
			//製造/有效年月份
			ws.addCell(new jxl.write.Label(col, row, "製造/有效年月份" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
	
			//製造/有效年
			ws.addCell(new jxl.write.Label(col, row, "製造/有效年" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
			
			//製造部門
			ws.addCell(new jxl.write.Label(col, row, "製造部門" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;
			
			//WAFER_LOT_NO
			ws.addCell(new jxl.write.Label(col, row, "WAFER_LOT_NO" , ACenterBL));
			ws.setColumnView(col,15);
			col++;
						
			//Wafer供應商
			ws.addCell(new jxl.write.Label(col, row, "Wafer供應商" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;				
			
			//QUANTITY
			ws.addCell(new jxl.write.Label(col, row, "QUANTITY" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	

			//單位
			ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;	
			
			//單價
			ws.addCell(new jxl.write.Label(col, row, "單價" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;		
			
			//金額
			ws.addCell(new jxl.write.Label(col, row, "金額" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
			
			//RECEIVED_DATE
			ws.addCell(new jxl.write.Label(col, row, "RECEIVED DATE" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//EXPIRATION DATE
			ws.addCell(new jxl.write.Label(col, row, "EXPIRATION DATE" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;		
			
			//TSC_PACKAGE
			ws.addCell(new jxl.write.Label(col, row, "TSC PACKAGE" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
			
			//Package大類
			ws.addCell(new jxl.write.Label(col, row, "Package大類" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	

			//TSC_FAMILY
			ws.addCell(new jxl.write.Label(col, row, "TSC FAMILY" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
			
			//最後領料/出貨日
			ws.addCell(new jxl.write.Label(col, row, "最後領料/出貨日" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;			
			row++;
		}	
		col=0;
		item_desc=rs.getString("DESCRIPTION");
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_TYPE_NAME"),ALeftL));
		col++;					
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORG_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NO") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SUB_INV") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOC") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NO") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("EXP_YYMM") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("MFG_YY") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DEPT") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("WAFER_LOT_NO")==null?"":rs.getString("WAFER_LOT_NO")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("VENDOR")==null?"":rs.getString("VENDOR")) , ALeftL));
		col++;	
		//ws.addCell(new jxl.write.Label(col, row, rs.getString("QUANTITY") , ARightL));
		if (rs.getString("QUANTITY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("QUANTITY")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("UOM")==null?"":rs.getString("UOM")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
		col++;	
		if (rs.getString("RECEIVED_DATE")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("RECEIVED_DATE")) ,DATE_FORMAT));
		}			
		col++;	
		if (rs.getString("EXPIRATION_DATE")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("EXPIRATION_DATE")) ,DATE_FORMAT));
		}			
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PACKAGE")==null?"":rs.getString("TSC_PACKAGE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PACKAGE_TYPE")==null?"":rs.getString("PACKAGE_TYPE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_FAMILY")==null?"":rs.getString("TSC_FAMILY")) , ALeftL));
		col++;	
		/*sql = " select to_char(MAX (transaction_date),'yyyy/mm/dd') from inv.mtl_material_transactions x "+
		      " where x.inventory_item_id=?"+
			  " and x.organization_id=? "+
			  " and x.transaction_type_id IN (35, 33)"+
			  " and x.created_by not in (5689,5698)";
		statement2 = con.prepareStatement(sql);
		statement2.setString(1,rs.getString("inventory_item_id"));
		statement2.setString(2,rs.getString("organization_id"));
		rs2=statement2.executeQuery();
		if (rs2.next())
		{
			trans_date=rs2.getString(1);
		}
		else
		{
			trans_date =null;
		}		
		rs2.close();
		statement2.close();				
		*/
		if (rs.getString("TRANSACTION_DATE")==null)  //add by Peggy 20181115
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("TRANSACTION_DATE")) ,DATE_FORMAT));
		}			
		col++;		
		row++;				
	}
	rs.close();
	statement.close();			

	wwb.write(); 
	wwb.close();

	if (row >0 && !ACTTYPE.equals(""))
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
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("shirley@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("yuan@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tk@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zhang_qiang@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("smf@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wan_xueming@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("amanda@mail.tsyew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("maomao@mail.tsyew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("yanyan@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ice@mail.tsyew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("guoying@mail.tsyew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("yq_li@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wang_junxia@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("hana@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("yifan.cao@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jia.song@mail.tsyew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("mr@mail.tsyew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lixia.wang@mail.tsyew.com.cn"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		
		message.setHeader("Subject", MimeUtility.encodeText(SDATE+" - YEW All Stock Report"+remarks, "UTF-8", null));				
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
	os.close();  
	out.close(); 
	
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()+item_desc+" col="+col+"  row="+row); 
} 	
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
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
