<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>PCN X-out Customer List</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCQRAXoutCustomerList" METHOD="post" name="MYFORM">
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
String CUSTPARTNO = request.getParameter("CUSTPARTNO");
if (CUSTPARTNO==null) CUSTPARTNO="";
String TSCPARTNO = request.getParameter("TSCPARTNO");
if (TSCPARTNO==null) TSCPARTNO="";
String GROUPBY = request.getParameter("GROUPBY");
if (GROUPBY==null) GROUPBY="";
//String strGlobalCust = request.getParameter("chk1");
//if (strGlobalCust==null) strGlobalCust="N";
String FileName="",RPTName="",sql="",swhere="",sql_h="",where="",sql_x="",sql_1="";
int fontsize=9,colcnt=0;
try 
{ 	
	int row =0,col=0,totcnt=0,reccnt=0,mergeCol=0,sheet_cnt =0;
	OutputStream os = null;	
	if (!QNO.equals(""))
	{
		FileName = QNO+"_X-Out Customer List";	
	}
	else
	{
		FileName =  "X-Out Customer List-"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	}
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ 
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}

	//公司名稱中文平行置中     
	WritableCellFormat wCompCName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 16 ,WritableFont.BOLD,false));   
	wCompCName.setAlignment(jxl.format.Alignment.CENTRE);
		
	//公司名稱英文平行置中     
	WritableCellFormat wCompEName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 16 ,WritableFont.BOLD,false));   
	wCompEName.setAlignment(jxl.format.Alignment.CENTRE);
	wCompEName.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);

	WritableCellFormat wCompEName1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 14 ,WritableFont.BOLD,false));   
	wCompEName1.setAlignment(jxl.format.Alignment.CENTRE);
	
	//地址中文行置中     
	WritableCellFormat wAddrCName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 8,WritableFont.BOLD,false));     
	wAddrCName.setAlignment(jxl.format.Alignment.CENTRE);
	
	//地址英文平行置中     
	WritableCellFormat wAddrEName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 8,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wAddrEName.setAlignment(jxl.format.Alignment.CENTRE);
			
	//電話平行置中     
	WritableCellFormat wTelName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 8,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wTelName.setAlignment(jxl.format.Alignment.CENTRE);
			
	//報表名稱平行置中    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 14, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName.setAlignment(jxl.format.Alignment.CENTRE);
	
	//英文內文水平垂直置左  
	WritableCellFormat ARIGHT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARIGHT.setAlignment(jxl.format.Alignment.RIGHT);
		
	//英文內文水平垂直置中-粗體-格線-底色灰-字體黑   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.WHITE));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.SEA_GREEN); 
	ACenterBL.setWrap(true);

	//英文內文水平垂直置中-粗體-格線-底色灰-字體紅   
	WritableCellFormat ACenterBLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterBLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLR.setBackground(jxl.write.Colour.SEA_GREEN); 
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
	
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = null;

	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	sql = " select DISTINCT c.PCN_NUMBER,c.PCN_TYPE,c.PCN_CREATION_DATE,b.TSC_PART_NO  "+
		  ",b.TSC_PROD_GROUP PROD_GROUP"+
		  ",b.TSC_PACKAGE PACKAGE"+
		  ",b.TSC_FAMILY FAMILY"+
		  ",b.TSC_PACKING_CODE AS \"PACKING CODE\""+
		  ",b.TSC_AMP AMP"+
		  ",b.MARKET_GROUP"+
		  ",b.CUST_SHORT_NAME customer_name"+
		  ",b.TERRITORY"+
		  ",b.CUST_PART_NO"+
		  //",d.customer_number"+
		  ",b.CUST_SHORT_NAME customer"+
		  ",b.date_code"+
		  ",b.sales_issue_date"+
		  " from oraddman.tsqra_pcn_item_detail b ,oraddman.tsqra_pcn_item_header c"+
		  " where b.PCN_NUMBER(+)=c.PCN_NUMBER"+
		  " and b.SOURCE_TYPE='1'"; //add by Peggy 20220505
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
		where += " and (c.PCN_NUMBER in ("+QNOList+")"+
		         "  or c.SEQUENCE_ID in ("+QNOList+"))";
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
	if (!(CYEARFR+CMONTHFR+CDAYFR).replace("------","").equals(""))
	{
		sql += " and c.PCN_CREATION_DATE >= '"+CYEARFR.replace("--","2010")+CMONTHFR.replace("--","01")+CDAYFR.replace("--","01")+"'";
	}
	if (!(CYEARTO+CMONTHTO+CDAYTO).replace("------","").equals(""))
	{
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
		where += " and c.PCN_CREATION_DATE <= '"+CYEARTO+CMONTHTO+CDAYTO+"'";
	}
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
	//if (strGlobalCust.equals("Y"))
	//{
	//	where += " and exists (select 1 from oraddman.tsqra_global_customer x where upper(x.customer_group_name)=upper(b.cust_short_name))";
	//}	
	
	/*if (!where.equals(""))
	{
		if (GROUPBY.equals("1")) //TSC P/N
		{
			sql_1 = " SELECT x.TERRITORY,x.PROD_GROUP,x.FAMILY,x.PACKAGE,x.TSC_PART_NO,x.CUST_PART_NO,x.CUSTOMER,x.MARKET_GROUP,x.PCN_NUMBER,x.PCN_CREATION_DATE ISSUE_DATE"+
				  " FROM ("+sql+where+") x order by x.pcn_number ,x.TSC_PART_NO,territory,market_group,customer";
		
		}
		else if (GROUPBY.equals("2")) //CUSTOMER
		{
			sql_1 = " SELECT x.TERRITORY,x.CUSTOMER,x.CUST_PART_NO,x.TSC_PART_NO,x.MARKET_GROUP,x.PCN_NUMBER,x.PCN_CREATION_DATE ISSUE_DATE"+
				  " FROM ("+sql+where+") x order by x.pcn_number ,x.TERRITORY,x.CUSTOMER,x.TSC_PART_NO";
			sql_x =" SELECT y.cust_group_name,row_number() over (partition by y.cust_group_name order by x.pcn_number,x.territory,x.customer,x.tsc_part_no) row_seq"+
		           ",x.TERRITORY,x.CUSTOMER,x.CUST_PART_NO,x.TSC_PART_NO,x.MARKET_GROUP,x.PCN_NUMBER,x.PCN_CREATION_DATE ISSUE_DATE"+
				   " FROM ("+sql+where+") x"+
				   ",oraddman.tsqra_handling_global_cust y"+
				   " where upper(x.customer) like '%'||upper(y.end_cust)||'%'"+
				   " order by y.cust_group_name,x.pcn_number ,x.TERRITORY,x.CUSTOMER,x.TSC_PART_NO";
		
		}
		else if (GROUPBY.equals("3")) //by QPCN NUMBER
		{
			sql_1 = " SELECT x.TERRITORY,x.PCN_NUMBER,x.CUST_PART_NO,x.TSC_PART_NO,x.CUSTOMER,x.MARKET_GROUP,x.PCN_CREATION_DATE ISSUE_DATE"+
				  " FROM ("+sql+where+") x order by x.PCN_NUMBER,x.TSC_PART_NO,territory,market_group,customer";
		}
	}
	else
	{
		sql_1 = sql;
	}
	*/
	sql_1 = " SELECT x.TERRITORY,x.CUSTOMER,x.CUST_PART_NO,x.TSC_PART_NO,x.MARKET_GROUP,x.PCN_NUMBER,x.PCN_CREATION_DATE ISSUE_DATE"+
		    " FROM ("+sql+where+") x"+
		    ",oraddman.tsqra_handling_global_cust y"+
		    " where upper(x.customer) like '%'||upper(y.end_cust)||'%'"+
			" order by x.pcn_number ,x.TERRITORY,x.CUSTOMER,x.TSC_PART_NO";
	sql_x =" SELECT y.cust_group_name,row_number() over (partition by y.cust_group_name order by x.pcn_number,x.territory,x.customer,x.tsc_part_no) row_seq"+
		   ",x.TERRITORY,x.CUSTOMER,x.CUST_PART_NO,x.TSC_PART_NO,x.MARKET_GROUP,x.PCN_NUMBER,x.PCN_CREATION_DATE ISSUE_DATE"+
		   " FROM ("+sql+where+") x"+
		   ",(select * from oraddman.tsqra_handling_global_cust where nvl(GLOBAL_CONTACT_FLAG,'N')='Y') y"+
		   " where upper(x.customer) like '%'||upper(y.end_cust)||'%'"+
		   " order by y.cust_group_name,x.pcn_number ,x.TERRITORY,x.CUSTOMER,x.TSC_PART_NO";
	
	sql_h="select distinct PCN_NUMBER from ("+sql_1+") tt" ;
	//out.println(sql_h);
	Statement statement2=con.createStatement();
	ResultSet rs2=statement2.executeQuery(sql_h);
	sheet_cnt =0;
	while (rs2.next())
	{
		wwb.createSheet(rs2.getString("PCN_NUMBER"), sheet_cnt);
		sheet_cnt++;
	}
	rs2.close();
	statement2.close(); 

	//out.println(sql);
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql_1);
	String pcn_number ="";
	while (rs.next())
	{
		if (!pcn_number.equals(rs.getString("PCN_NUMBER")))
		{
			if (reccnt >0)
			{
				col=0;
				ws.mergeCells(col, row, col+4, row);     
				//ws.addCell(new jxl.write.Label(col, row,"****** The copyright of document and business secret belong to TSC, and no copies should be made without any permission ******" , wTelName));
				ws.addCell(new jxl.write.Label(col, row,"****** This document contains TSC business confidential information. Further distribution should not be made without TSC permission ******" , wTelName)); //modify by Peggy 20150714
				row++;//列+1
			}
			pcn_number=rs.getString("PCN_NUMBER");
			ws = wwb.getSheet(pcn_number);
			SheetSettings settings = ws.getSettings(); 
			settings.setSelected();	
			settings.setScaleFactor(60);   // 打印縮放比例
			settings.setHeaderMargin(0.3);
			settings.setBottomMargin(0.3);
			settings.setLeftMargin(0.2);
			settings.setRightMargin(0.2);
			settings.setTopMargin(0.3);
			settings.setFooterMargin(0.3);										
			reccnt =0;
		}
		if (reccnt==0)
		{
			col=0;row=0;
			
			//logo
			jxl.write.WritableImage image = new jxl.write.WritableImage(col,row,col+1.5,row+1, new File("..//resin-2.1.9//webapps/oradds/jsp/images/logo.png")); 
			ws.addImage(image); 
		
			//String strCTitle = "台 灣 半 導 體 股 份 有 限 公 司";
			//ws.mergeCells(col, row, col+4, row);     
			//ws.addCell(new jxl.write.Label(col, row,strCTitle , wCompCName));
			//ws.setColumnView(col,60);	
			//row++;//列+1
			
			//String strETitle = "Taiwan Semiconductor Company limited";
			String strETitle = "Taiwan Semiconductor Co., Ltd.";	
			ws.setRowView(row,650);		
			ws.mergeCells(col, row, col+4, row);     
			ws.addCell(new jxl.write.Label(col, row,strETitle , wCompEName));
			row++;//列+1
					
			//String strCAddr = "新北市新店區北新路三段205號11樓";
			//ws.mergeCells(col, row, col+4, row);     
			//ws.addCell(new jxl.write.Label(col, row,strCAddr , wAddrCName));
			//row++;//列+1		
					
			String strEAddr = "11Fl.,No,205,Sec.3,Beishin Rd., Xindian Dist., New Taipei City 231, Taiwan";
			ws.mergeCells(col, row, col+4, row);     
			ws.addCell(new jxl.write.Label(col, row,strEAddr , wAddrEName));
			row++;//列+1	
			
			String strTelInfo = "Tel: 886-2-8913-1588, Fax: 886-2-8913-1788";
			ws.mergeCells(col, row, col+4, row);     
			ws.addCell(new jxl.write.Label(col, row,strTelInfo , wTelName));
			row++;//列+1	
			row++;//列+1

			String strRPTtitle = pcn_number+"_X-Out Customer List";
			ws.mergeCells(col, row, col+4, row);     
			ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wCompEName1));
			row++;//列+1
		
			ws.addCell(new jxl.write.Label(col, row, "TSC P/N" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "Territory" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Customer P/N" , ACenterBL));
			ws.setColumnView(col,30);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Customer Name" , ACenterBL));
			ws.setColumnView(col,40);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Market Group" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PART_NO") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TERRITORY") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_PART_NO")==null?"N/A":rs.getString("CUST_PART_NO")) ,ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("market_group") , ACenterL));
		col++;	
		row++;
		reccnt++;
	}
	if (reccnt >0)
	{
		col=0;
		ws.mergeCells(col, row, col+4, row);     
		//ws.addCell(new jxl.write.Label(col, row,"****** The copyright of document and business secret belong to TSC, and no copies should be made without any permission ******" , wTelName));
		ws.addCell(new jxl.write.Label(col, row,"****** This document contains TSC business confidential information. Further distribution should not be made without TSC permission ******" , wTelName)); //modify by Peggy 20150714
		row++;//列+1
	}
	rs.close();
	statement.close();	
		
	//add by Peggy 20220418
	if (sheet_cnt==1)
	{
		//out.println(sql_x);
		statement=con.createStatement();
		rs=statement.executeQuery(sql_x);
		while (rs.next())
		{
			if (rs.getInt("row_seq")==1)
			{
				wwb.createSheet(rs.getString("cust_group_name"), sheet_cnt);
				sheet_cnt++;
				ws = wwb.getSheet(rs.getString("cust_group_name"));
				col=0;row=0;		

				//logo
				jxl.write.WritableImage image = new jxl.write.WritableImage(col,row,col+1.5,row+2, new File("..//resin-2.1.9//webapps/oradds/jsp/images/logo.png")); 
				ws.addImage(image); 
			
				//String strCTitle = "台 灣 半 導 體 股 份 有 限 公 司";
				//ws.mergeCells(col, row, col+4, row);     
				//ws.addCell(new jxl.write.Label(col, row,strCTitle , wCompCName));
				//ws.setColumnView(col,60);	
				//row++;//列+1
				
				String strETitle = "Taiwan Semiconductor Company limited";
				ws.mergeCells(col, row, col+4, row);     
				ws.addCell(new jxl.write.Label(col, row,strETitle , wCompEName));
				row++;//列+1
						
				//String strCAddr = "新北市新店區北新路三段205號11樓";
				//ws.mergeCells(col, row, col+4, row);     
				//ws.addCell(new jxl.write.Label(col, row,strCAddr , wAddrCName));
				//row++;//列+1		
						
				String strEAddr = "11Fl.,No,205,Sec.3,Beishin Rd., Xindian Dist., New Taipei City 231, Taiwan";
				ws.mergeCells(col, row, col+4, row);     
				ws.addCell(new jxl.write.Label(col, row,strEAddr , wAddrEName));
				row++;//列+1	
				
				String strTelInfo = "Tel: 886-2-8913-1588, Fax: 886-2-8913-1788";
				ws.mergeCells(col, row, col+4, row);     
				ws.addCell(new jxl.write.Label(col, row,strTelInfo , wTelName));
				row++;//列+1	
				row++;//列+1
	
				String strRPTtitle = pcn_number+"_X-Out Customer List_"+rs.getString("cust_group_name");
				ws.mergeCells(col, row, col+4, row);     
				ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wCompEName1));
				row++;//列+1
			
				ws.addCell(new jxl.write.Label(col, row, "TSC P/N" , ACenterBL));
				ws.setColumnView(col,20);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "Territory" , ACenterBL));
				ws.setColumnView(col,20);	
				col++;	
	
				ws.addCell(new jxl.write.Label(col, row, "Customer P/N" , ACenterBL));
				ws.setColumnView(col,30);	
				col++;	
	
				ws.addCell(new jxl.write.Label(col, row, "Customer Name" , ACenterBL));
				ws.setColumnView(col,40);	
				col++;	
	
				ws.addCell(new jxl.write.Label(col, row, "Market Group" , ACenterBL));
				ws.setColumnView(col,20);	
				col++;	
				row++;
			}
			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PART_NO") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TERRITORY") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_PART_NO")==null?"N/A":rs.getString("CUST_PART_NO")) ,ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("market_group") , ACenterL));
			col++;	
			row++;
		}
		rs.close();
		statement.close();			
	}
	
	wwb.write(); 
	wwb.close();
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
