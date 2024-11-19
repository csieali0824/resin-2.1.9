<!-- 20161114 Peggy,新增only global customer查詢條件-->
<!-- 20170602 Peggy,新增package & family查詢條件-->
<%@ page contentType="text/html; charset=utf-8" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Download Excel File</title>
</head>
<body>
<FORM ACTION="../jsp/TSCQRAProductNoticeExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String QNO = request.getParameter("QNO");
if (QNO==null) QNO="";
String QTYPE = request.getParameter("QTYPE");
if (QTYPE==null) QTYPE="";
String PROD1 = request.getParameter("PROD1");
if (PROD1==null) PROD1="";
String PROD2 = request.getParameter("PROD2");
if (PROD2==null) PROD2="";
String PROD3 = request.getParameter("PROD3");
if (PROD3==null) PROD3="";
String TSCFAMILY = request.getParameter("ERPTSCFAMILY");
if (TSCFAMILY==null) TSCFAMILY="";
String TSCPACKAGE = request.getParameter("ERPTSCPACKAGE");
if (TSCPACKAGE==null) TSCPACKAGE="";
String TSCPACKINGCODE = request.getParameter("TSCPACKINGCODE");
if (TSCPACKINGCODE==null) TSCPACKINGCODE="";
String TSCAMP = request.getParameter("TSCAMP");
if (TSCAMP==null) TSCAMP="";
String TERRITORY = request.getParameter("TERRITORY");
if (TERRITORY==null) TERRITORY=(String)session.getAttribute("G1AREA");
if (TERRITORY.equals("QRA")) TERRITORY="ALL";
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String MARKETGROUP = request.getParameter("MARKETGROUP");
if (MARKETGROUP==null) MARKETGROUP="";
String MANUFACTORY = request.getParameter("MANUFACTORY");
if (MANUFACTORY==null) MANUFACTORY="";
//String CYEARFR = request.getParameter("CYEARFR");
//if (CYEARFR==null) CYEARFR="--";
//String CMONTHFR = request.getParameter("CMONTHFR");
//if (CMONTHFR==null) CMONTHFR="--";
//String CDAYFR = request.getParameter("CDAYFR");
//if (CDAYFR==null) CDAYFR="--";
//String CYEARTO = request.getParameter("CYEARTO");
//if (CYEARTO==null) CYEARTO="--";
//String CMONTHTO = request.getParameter("CMONTHTO");
//if (CMONTHTO==null) CMONTHTO="--";
//String CDAYTO = request.getParameter("CDAYTO");
//if (CDAYTO==null) CDAYTO="--";
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String CUSTPARTNO = request.getParameter("CUSTPARTNO");
if (CUSTPARTNO==null) CUSTPARTNO="";
String TSCPARTNO = request.getParameter("TSCPARTNO");
if (TSCPARTNO==null) TSCPARTNO="";
String GROUPBY = request.getParameter("GROUPBY");
if (GROUPBY==null) GROUPBY="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String strGlobalCust = request.getParameter("chk1");
if (strGlobalCust==null) strGlobalCust="N";
String v_cn_number =""; //add by Peggy 20240524

String FileName="",RPTName="",ColumnName="",DEPTNAME="",sql="",where="",v_change_title="",v_feed_date="",v_intend_date="";
int fontsize=9,colcnt=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,line=0,mergeCol=0;
	String column1="",column2="",column3="",column4="",column5="";
	OutputStream os = null;	
	RPTName = "PCN_DETAIL_PRT";
	FileName = RPTName+"("+TERRITORY+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
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
	SheetSettings sst = ws.getSettings(); 
	
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
	
	//CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	//cs1.setString(1,"41"); 
	//cs1.execute();
	//cs1.close();
		
	sql = " select DISTINCT c.PCN_NUMBER"+
       	  ",c.PCN_TYPE"+
		  ",c.PCN_CREATION_DATE"+
		  ",b.TSC_PART_NO \"TSC P/N\" "+
		  ",b.TSC_PROD_GROUP PROD_GROUP"+
		  ",b.TSC_PACKAGE PACKAGE"+
		  ",b.TSC_FAMILY FAMILY"+
		  ",b.TSC_PACKING_CODE AS \"PACKING CODE\""+
		  ",b.TSC_AMP AMP"+
		  ",b.MARKET_GROUP"+
		  ",b.CUST_SHORT_NAME customer_name"+
		  ",b.TERRITORY"+
		  ",b.CUST_PART_NO \"CUST P/N\""+
		  //",d.customer_number"+
		  ",b.CUST_SHORT_NAME customer"+
		  ",b.date_code"+
		  ",b.sales_issue_date"+
		  ",b.REPLACE_PART_NO"+
          ",(select case when instr(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id),'QQ')>0 then msi.description else trim(substr(msi.description,0,length(msi.description)-length(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id)))) end from inv.mtl_system_items_b msi where msi.organization_id=43 and msi.segment1=b.TSC_ITEM_NAME) partid"+ //add by Peggy 20221209
		  ",c.LAST_ORDER_DATE"+ //add by Peggy 20240318
		  ",c.LAST_DELIVERY_DATE"+  //add by Peggy 20240318
		  ",c.SEQUENCE_ID"+ //add by Peggy 20240318
		  " from oraddman.tsqra_pcn_item_detail b"+
		  " ,oraddman.tsqra_pcn_item_header c"+
		  " where b.PCN_NUMBER(+)=c.PCN_NUMBER";
	if (!TERRITORY.equals("ALL"))
	{
		String [] strTerritory = TERRITORY.split("\n");
		String TerritoryList = "'N/A'";
		for (int x = 0 ; x < strTerritory.length ; x++)
		{
			if (TerritoryList.length() >0) TerritoryList += ",";
			TerritoryList += "'"+strTerritory[x].trim()+"'";
		}
		where += " and NVL(b.TERRITORY,'N/A') in ("+TerritoryList+")";
	}
	if (!QNO.equals(""))
	{
		String [] strNo = QNO.split("\n");
		String QNOList = "";
		for (int x = 0 ; x < strNo.length ; x++)
		{
			if (QNOList.length() >0) QNOList += ",";
			QNOList += "'"+strNo[x].trim()+"'";
		}
		where += " and c.PCN_NUMBER in ("+QNOList+")";
	}
	if (!PROD1.equals("") || !PROD2.equals("") || !PROD3.equals(""))
	{
		String PRODLIST="";
		if (!PROD1.equals(""))
		{ 
			if (!PRODLIST.equals("")) PRODLIST +=",";
			PRODLIST +="'"+PROD1+"'";
		}
		if (!PROD2.equals(""))
		{
			if (!PRODLIST.equals("")) PRODLIST +=",";
			PRODLIST +="'"+PROD2+"'";
		}
		if (!PROD3.equals(""))
		{
			if (!PRODLIST.equals("")) PRODLIST +=",";
			PRODLIST +="'"+PROD3+"'";
		}
		where += " and b.TSC_PROD_GROUP IN ("+PRODLIST+")";
	}
	if (!TSCFAMILY.equals("--") && !TSCFAMILY.equals(""))
	{
		String [] strFamily = TSCFAMILY.split("\n");
		String FamilyList = "";
		for (int x = 0 ; x < strFamily.length ; x++)
		{
			if (FamilyList.length() >0) FamilyList += ",";
			FamilyList += "'"+strFamily[x].trim()+"'";
		}
		//where += " and b.TSC_FAMILY in ("+FamilyList+")";
		where += " and exists (select 1 from inv.mtl_system_items_b msi where msi.organization_id=43 and TSC_INV_Category(msi.inventory_item_id, msi.organization_id,21) in ("+FamilyList+")"+
				 "  and tsc_get_item_desc_nopacking(  msi.organization_id,msi.inventory_item_id)=substr(b.tsc_part_no,1,length(b.tsc_part_no)-length(b.tsc_packing_code)-1))";
		
	}
	if (!TSCPACKAGE.equals("") && !TSCPACKAGE.equals("--"))
	{
		String [] strPackage = TSCPACKAGE.split("\n");
		String PackageList = "";
		for (int x = 0 ; x < strPackage.length ; x++)
		{
			if (PackageList.length() >0) PackageList += ",";
			PackageList += "'"+strPackage[x].trim()+"'";
		}
		//where += " and b.TSC_PACKAGE in ("+PackageList+")";
			where += " and exists (select 1 from inv.mtl_system_items_b msi where msi.organization_id=43 and TSC_INV_Category(msi.inventory_item_id, msi.organization_id,23) in ("+PackageList+")"+
			         "  and tsc_get_item_desc_nopacking(  msi.organization_id,msi.inventory_item_id)=substr(b.tsc_part_no,1,length(b.tsc_part_no)-length(b.tsc_packing_code)-1))";
	}
	if (!TSCPACKINGCODE.equals("") && !TSCPACKINGCODE.equals("--"))
	{
		String [] strPacking = TSCPACKINGCODE.split("\n");
		String PackingList = "";
		for (int x = 0 ; x < strPacking.length ; x++)
		{
			if (PackingList.length() >0) PackingList += ",";
			PackingList += "'"+strPacking[x].trim()+"'";
		}
		where += " and case when ( b.TSC_PROD_GROUP='PMD' and substr(a.segment1,4,1)='G')  then substr(a.segment1,9,2)||'G' when  ( b.TSC_PROD_GROUP<>'PMD' and substr(a.segment1,11,1)='1' ) then substr(a.segment1,9,2)||'G' else substr(a.segment1,9,2) end in ("+PackingList+")";
	}
	if (!TSCAMP.equals("") && !TSCAMP.equals("--"))
	{
		String [] strAmp = TSCAMP.split("\n");
		String AmpList = "";
		for (int x = 0 ; x < strAmp.length ; x++)
		{
			if (AmpList.length() >0) AmpList += ",";
			AmpList += "'"+strAmp[x].trim()+"'";
		}
		where += " and b.TSC_AMP in ("+AmpList+")";
	}
	if (!MARKETGROUP.equals("") && !MARKETGROUP.equals("--"))
	{
		String [] strMarketGroup = MARKETGROUP.split("\n");
		String MarketGroupList = "";
		for (int x = 0 ; x < strMarketGroup.length ; x++)
		{
			if (MarketGroupList.length() >0) MarketGroupList += ",";
			MarketGroupList += "'"+strMarketGroup[x].trim()+"'";
		}
		where += " and b.MARKET_GROUP in ("+MarketGroupList+")";
	}
	if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
	{
		String [] sArray = CUSTOMER.split("\n");
		String sList = "";
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				where += " and (";
			}
			else
			{
				where += " or ";
			}
			sArray[x] = sArray[x].trim();
			where += " lower(b.CUST_SHORT_NAME) like '%"+sArray[x].toLowerCase()+"%'";
		}
		where += " )";
	}
	if (!MANUFACTORY.equals("") && !MANUFACTORY.equals("--"))
	{
		String [] sArray = MANUFACTORY.split("\n");
		String sList = "";
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (sList.length() >0) sList += ",";
			sArray[x] = sArray[x].trim();
			sList += ("'"+sArray[x].substring(0,sArray[x].indexOf("-"))+"'");
		}
		where += " and b.packing_instructions in ("+sList+")";
	}
	if (!SDATE.equals("")) //modify by Peggy 20140416
	{
		where += " and c.pcn_creation_date >= '"+SDATE+"'";
	}
	if (!EDATE.equals(""))  //modify by Peggy 20140416
	{
		where += " and c.pcn_creation_date <= '"+EDATE+"'";
	}	
	//if (!(CYEARFR+CMONTHFR+CDAYFR).replace("------","").equals(""))
	//{
	//	sql += " and c.PCN_CREATION_DATE >= '"+CYEARFR.replace("--","2010")+CMONTHFR.replace("--","01")+CDAYFR.replace("--","01")+"'";
	//}
	//if (!(CYEARTO+CMONTHTO+CDAYTO).replace("------","").equals(""))
	//{
	//	if (CYEARTO.equals("--")) CYEARTO = ""+dateBean.getYear();
	//	if (CMONTHTO.equals("--")) CMONTHTO = ""+dateBean.getMonth();
	//	if (CDAYTO.equals("--"))
	//	{
	//		if (CMONTHTO.equals("01") || CMONTHTO.equals("03") || CMONTHTO.equals("05") || CMONTHTO.equals("07") || CMONTHTO.equals("08") || CMONTHTO.equals("10") || CMONTHTO.equals("12"))
	//		{
	//			CDAYTO="31";
	//		}
	//		else if (CMONTHTO.equals("04") || CMONTHTO.equals("06") || CMONTHTO.equals("09") || CMONTHTO.equals("11"))
	//		{
	//			CDAYTO="30";
	//		}
	//		else
	//		{
	//			if (Integer.parseInt(CYEARTO)%4==0)
	//			{
	//				CDAYTO="29";
	//			}
	//			else
	//			{
	//				CDAYTO="28";
	//			}
	//		}
	//	}
	//	where += " and c.PCN_CREATION_DATE <= '"+CYEARTO+CMONTHTO+CDAYTO+"'";
	//}
	if (!TSCPARTNO.equals("") && !TSCPARTNO.equals("--"))
	{
		String [] sArray = TSCPARTNO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				where += " and (upper(b.TSC_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%'";
				if (x==sArray.length -1) where += ")";
				
			}
			else if (x==sArray.length -1)
			{
				where += " or upper(b.TSC_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%')";
			}
			else
			{
				where += " or upper(b.TSC_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%'";
			}
		}
	}
	if (!CUSTPARTNO.equals("") && !CUSTPARTNO.equals("--"))
	{
		String [] sArray = CUSTPARTNO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				where += " and (upper(b.CUST_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%'";
				if (x==sArray.length -1) where += ")";
				
			}
			else if (x==sArray.length -1)
			{
				where += " or upper(b.CUST_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%')";
			}
			else
			{
				where += " or upper(b.CUST_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%'";
			}
		}
	}
	if (!STATUS.equals("--") && !STATUS.equals(""))
	{
		where += " and nvl(b.status,case when trunc(sysdate)-to_DATE(pcn_end_date,'yyyymmdd') >1 THEN 'Closed' else 'Open' end) ='"+STATUS+"'";
	}	
	//if (GROUPBY.equals("2")) //CUSTOMER	
	//{
	//	where += " AND b.source_type='1'";
	//}	
	//add by Peggy 20161114
	if (strGlobalCust.equals("Y"))
	{
		where += " and exists (select 1 from oraddman.tsqra_global_customer x where upper(x.customer_group_name)=upper(b.cust_short_name))";
	}	
	
	if (!where.equals(""))
	{
		//if (GROUPBY.equals("1")) //TSC P/N
		//{
		//	sql = " select (select rowid from oraddman.tsqra_pcn_item_header g where g.pcn_number=x.pcn_number) keyid,x.pcn_number,x.pcn_type,x.pcn_creation_date,x.territory,x.market_group,x.customer_name,x.customer, x.prod_group,x.\"TSC P/N\",x.family,x.package,x.\"PACKING CODE\""+
		//		  ",x.amp, x.\"CUST P/N\", x.date_code,"+
		//		  " (select count(1) from ("+sql + where+") y where y.\"TSC P/N\" = x.\"TSC P/N\" group by y.\"TSC P/N\") pcn_cnt,"+
		//		  " (select count(1) from ("+sql + where+") y where y.\"TSC P/N\" = x.\"TSC P/N\" and y.customer=x.customer and y.territory=x.territory and y.market_group=x.market_group group by \"TSC P/N\",territory,market_group,customer) cust_cnt"+
		//		  " from ("+sql + where+")  x  order by x.\"TSC P/N\",territory,market_group,customer,pcn_number";
		//
		//}
		if (GROUPBY.equals("1")) //TSC P/N
		{
			sql = " SELECT x.TERRITORY,x.PROD_GROUP,x.FAMILY,x.PACKAGE,x.\"TSC P/N\",x.\"CUST P/N\",x.CUSTOMER,x.MARKET_GROUP,x.PCN_NUMBER,x.PCN_CREATION_DATE ISSUE_DATE,x.REPLACE_PART_NO"+
				  " FROM ("+sql+where+") x order by x.\"TSC P/N\",territory,market_group,customer,pcn_number";
		
		}
		else if (GROUPBY.equals("2")) //CUSTOMER
		{
			sql = " SELECT x.TERRITORY,x.CUSTOMER,x.\"CUST P/N\",x.\"TSC P/N\",x.MARKET_GROUP,x.PCN_NUMBER,x.PCN_CREATION_DATE ISSUE_DATE,x.REPLACE_PART_NO"+
				  " FROM ("+sql+where+") x order by x.TERRITORY,x.CUSTOMER,x.\"TSC P/N\",x.pcn_number";
		
		}
		else if (GROUPBY.equals("3")) //by QPCN NUMBER
		{
			//sql = " SELECT x.TERRITORY,x.PCN_NUMBER,x.\"TSC P/N\",x.\"CUST P/N\",x.CUSTOMER,x.MARKET_GROUP,x.PCN_CREATION_DATE ISSUE_DATE,x.REPLACE_PART_NO"+
			//	  " FROM ("+sql+where+") x order by x.PCN_NUMBER,x.\"TSC P/N\",territory,market_group,customer";
			sql = " SELECT x.PCN_NUMBER,'' as \"Change Title\",x.PCN_CREATION_DATE ISSUE_DATE,'' as \"CUST Feedback Date\",'' as \"Intended Star of Delivery Date\",x.LAST_ORDER_DATE as \"Last Order Date\",x.LAST_DELIVERY_DATE as \"Last Delivery Date\""+
			      ",x.TERRITORY,x.PROD_GROUP,x.FAMILY,x.PACKAGE,x.\"TSC P/N\",x.\"CUST P/N\",x.CUSTOMER,x.MARKET_GROUP,'' as \"AIFS ID (since Oct2021)\",'' as \"Regions feedback\",'' as \"Feedback Date\""+
                  ",x.REPLACE_PART_NO,x.SEQUENCE_ID"+
				  " FROM ("+sql+where+") x order by x.PCN_NUMBER,x.\"TSC P/N\",territory,market_group,customer";			
		}
		else if (GROUPBY.equals("4")) //for judy issue增加PART ID on 20221209
		{
			sql = " SELECT x.TERRITORY,x.PROD_GROUP,x.FAMILY,x.PACKAGE,x.PARTID,x.\"TSC P/N\",x.\"CUST P/N\",x.CUSTOMER,x.MARKET_GROUP,x.PCN_NUMBER,x.PCN_CREATION_DATE ISSUE_DATE,x.REPLACE_PART_NO"+
				  " FROM ("+sql+where+") x order by x.\"TSC P/N\",territory,market_group,customer,pcn_number";
			//sql = " SELECT x.PCN_NUMBER,'' as \"Change Title\",x.PCN_CREATION_DATE ISSUE_DATE,x.LAST_ORDER_DATE as \"Last Order Date\",x.LAST_DELIVERY_DATE as \"Last Delivery Date\",x.TERRITORY,x.PROD_GROUP,x.FAMILY,x.PACKAGE,x.PARTID,x.\"TSC P/N\",x.\"CUST P/N\",x.CUSTOMER,x.MARKET_GROUP,'' as \"Regions feedback\",x.SEQUENCE_ID"+
			//	  " FROM ("+sql+where+") x order by pcn_number,territory,x.\"TSC P/N\",customer,market_group";
		}
		
		//out.println(sql);
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		while (rs.next())
		{
			if (reccnt==0)
			{
				col=0;row=0;
				for (int i =1; i <= md.getColumnCount()-(GROUPBY.equals("3")?1:0) ;i++)
				//for (int i =1; i <= md.getColumnCount() ;i++)
				{
					ws.addCell(new jxl.write.Label(col, row, (md.getColumnLabel(i).equals("REPLACE_PART_NO")?"Recommended Replacement TSC P/N":md.getColumnLabel(i)) , ACenterBL));
					ws.setColumnView(col,20);
					col++;	
				}
				row++;
			}
		
			col=0;
			for (int i = 1 ; i <= md.getColumnCount()-(GROUPBY.equals("3")?1:0) ;i++)
			//for (int i = 1 ; i <= md.getColumnCount() ;i++)
			{
				if (GROUPBY.equals("3") && (i==2 || i==4 || i==5))
				{
				
					if (!v_cn_number.equals(rs.getString(20)))
					{
						Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
						Connection conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://10.0.1.180:1433;DatabaseName=BPMPro;User=bpm;Password=S#Tsc&Bpm2@22");
						sql = " select afe.CNS_TITLE,afe.custfeed_date,afe.intend_date,afe.decision_rev"+
							  " from fm7t_change_m afe"+
							  " where afe.cn_no='"+rs.getString(20)+"'"+
							  " order by afe.decision_rev desc";
						Statement st = conn.createStatement();
						ResultSet rs1 = st.executeQuery(sql);
						if (rs1.next()) 
						{					
							v_change_title=rs1.getString(1);
							v_feed_date=rs1.getString(2);
							v_intend_date=rs1.getString(3);
						}
						else
						{
							v_change_title="";
							v_feed_date="";
							v_intend_date="";
						}	
						rs1.close();
						st.close();	

						if (v_change_title == null || v_change_title.equals(""))
						{

							sql = " select afe.CNS_TITLE,afe.custfeed_date,afe.intend_date,afe.decision_rev"+
								  " from fm7t_change_m afe"+
								  " where afe.decision_no='"+rs.getString(1)+"'"+
								  " order by afe.decision_rev desc";
							Statement st2 = conn.createStatement();
							ResultSet rs2 = st2.executeQuery(sql);
							if (rs2.next()) 
							{					
								v_change_title=rs2.getString(1);
								v_feed_date=rs2.getString(2);
								v_intend_date=rs2.getString(3);
							}	
							else
							{
								v_change_title="";
								v_feed_date="";
								v_intend_date="";
							}								
							rs2.close();
							st2.close();	
						}
						conn.close();	

						v_cn_number=rs.getString(20);							
					}
									
					if (i==2)
					{
						ws.addCell(new jxl.write.Label(col, row, v_change_title, ALeftL));
					}
					else if (i==4)
					{
						ws.addCell(new jxl.write.Label(col, row, v_feed_date, ALeftL));
					}
					else if (i==5)
					{
						ws.addCell(new jxl.write.Label(col, row, v_intend_date, ALeftL));
					}					
					col++;					
				}
				else
				{
					ws.addCell(new jxl.write.Label(col, row, rs.getString(i) , ALeftL));
					col++;	
				}
			}
			row++;
			reccnt++;
		}
		wwb.write(); 
		wwb.close();
		os.close();  
		out.close(); 
		
		rs.close();
		statement.close();
	}
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
