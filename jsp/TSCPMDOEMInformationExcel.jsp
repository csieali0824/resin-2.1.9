<!--modify by Peggy 20140814,工程&量產工單增加芯片尺吋-->
<!--modify by Peggy 20161005,車規型號在備註欄位顯示"Marking 未碼要加底線"-->
<!--modify by Peggy 20170124,D/C=HOLD 黃底紅字標示-->
<!-- 20180724 Peggy,新增晶片片號,印章第一行,印章第二行,making往下移for4056天水華天集團-->
<!--modify by Peggy 20191014,車規型號(品名第二碼為Q,在備註欄位顯示"Marking 未碼要加底線"-->
<!-- 20200107 Peggy,4746華羿微電子股份有限公司同4056天水華天集團-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCPMDOEMInformationExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String REQUESTNO = request.getParameter("REQUESTNO");
String ITEM_DESC="",WIPNO = "",FileName="",VENDOR="",VENDOR_CODE="",ORIG_WAFER_NUMBER=""; 
String ASSEMBLY="",TAPING_REEL="",TESTING="",LAPPING="",OTHERS="",imageFile="",VERSION_ID="",APPROVED_DATE="",CHANGE_DATE="",ORIG_REQUESTNO="",sql="",imageFileName="",ORIG_DC_YYWW="",ORIG_WAFER_NO="",ORIG_DIE_MODE="";
String WIP_TYPE_NO="",DIE_ITEM_NAME="";//add by Peggy 20140814
String TSC_PROD_GROUP=""; //add by Peggy 20161123
int cnt=0,fontsize=9;
String str_marking_two="",str_marking_three="",v_wafer_size="",v_marking_no="",v_marking_flag="N",v_making="Y";
int i_addline=0;
if (Long.parseLong(dateBean.getYearMonthDay())>=20221215) i_addline=1;

try 
{ 	
	String sqlh =" SELECT a.request_no||'-'||a.version_id request_no, b.type_name wip_name, a.vendor_name,a.vendor_contact,"+
             " to_char(TO_DATE(a.request_date,'yyyymmdd'),'yyyy-mm-dd') request_date, a.inventory_item_name, a.item_description, "+
             //" a.die_name || decode(a.die_name1,null,'','\r\n'||a.die_name1) die_name"+
			 " a.die_name || decode(a.die_name1,null,'',case when a.vendor_code='3864' then '/' else '\r\n' end ||a.die_name1) die_name"+ //GEM雙DIE用/區隔 BY PEGGY 20220810
			 ", a.quantity, a.unit_price,a.PACKING,a.PACKAGE_SPEC,a.TEST_SPEC,a.ITEM_PACKAGE,a.wip_no, a.pr_no, "+
			 " a.status, to_char(a.creation_date,'yyyy-mm-dd') creation_date,"+
			 " a.ASSEMBLY,a.TAPING_REEL,a.TESTING,a.LAPPING,a.OTHERS,a.unit_price_uom,a.version_id,a.request_no||'-'||a.orig_version_id ORIG_REQUESTNO,"+
             " a.created_by_name, to_char(a.approve_date,'yyyymmdd') approve_date, a.approved_by_name,a.remarks,a.MARKING,a.CURRENCY_CODE,"+
             " (select count(1) from oraddman.tspmd_oem_lines_all c where c.request_no=a.request_no) total_cnt"+
			 ",a.WIP_TYPE_NO,c.segment1 die_item_name"+  //add by Peggy 20140814
			 ",a.TSC_PROD_GROUP"+ //add by Peggy 20161123
			 ",a.VENDOR_CODE"+ //add by Peggy 20180726 
			 ",a.vendor_item_desc"+ //add by Peggy 20220930
             " FROM oraddman.tspmd_oem_headers_all a,oraddman.tspmd_data_type_tbl b"+
			 ",(select * from inv.mtl_system_items_b where organization_id=49) c"+
             " where a.wip_type_no=b.type_no"+
             " and b.data_type='WIP' "+
			 " and a.DIE_ITEM_ID=c.inventory_item_id(+)"+
			 " and a.request_no||'-'||a.version_id='"+REQUESTNO+"'"+
			 " and a.status<>'Inactive'";
	//out.println(sqlh);
	Statement stateh=con.createStatement();     
    ResultSet rsh=stateh.executeQuery(sqlh);
	if (rsh.next())	
	{ 
		VENDOR=rsh.getString("vendor_name");
		ITEM_DESC=rsh.getString("item_description");  //品名
		WIPNO=rsh.getString("wip_no"); //工單號碼
		FileName=ITEM_DESC +" "+WIPNO;
		VERSION_ID=rsh.getString("version_id");           //add by Peggy 20120726
		APPROVED_DATE = rsh.getString("approve_date");    //add by Peggy 20120726
		ORIG_REQUESTNO = rsh.getString("ORIG_REQUESTNO"); //add by Peggy 20120726     
		ASSEMBLY = rsh.getString("ASSEMBLY");
		TAPING_REEL = rsh.getString("TAPING_REEL");
		TESTING=rsh.getString("TESTING");
		LAPPING=rsh.getString("LAPPING");
		OTHERS=rsh.getString("OTHERS");
		WIP_TYPE_NO=rsh.getString("WIP_TYPE_NO");     //add by Peggy 20140814
		DIE_ITEM_NAME=rsh.getString("die_item_name"); //add by Peggy 20140814
		TSC_PROD_GROUP=rsh.getString("TSC_PROD_GROUP"); //add by Peggy 20161123
		VENDOR_CODE=rsh.getString("VENDOR_CODE");    //add by Peggy 20180726
		
		//華天科技(西安)有限公司,TSM250N02DCQ RFG & TSM500P02DCQ RFG新增印章規格,add by Peggy 20210222 from Nono issue
		if (rsh.getString("VENDOR_CODE").equals("3827"))
		{
			if (rsh.getString("ITEM_DESCRIPTION").equals("TSM250N02DCQ RFG") || rsh.getString("ITEM_DESCRIPTION").equals("TSM500P02DCQ RFG"))
			{
				v_marking_flag="Y";
				if (rsh.getString("ITEM_DESCRIPTION").equals("TSM250N02DCQ RFG"))
				{
					v_marking_no="MAT32DFN006101";
				}
				else if (rsh.getString("ITEM_DESCRIPTION").equals("TSM500P02DCQ RFG"))
				{
					v_marking_no="MAT32DFN006102";
				}
			}
		}
				
		//out.println("FileName="+FileName);
		int row =0,col=0,line=0; //add line by Peggy 20140814
		OutputStream os = null;	
		if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
		{ // For Unix Platform
			os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
		}  
		else 
		{ 
		
			os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
		}
		WritableWorkbook wwb = Workbook.createWorkbook(os); 
		WritableSheet ws = wwb.createSheet("Sheet1", 0); 
		SheetSettings sst = ws.getSettings(); 
		sst.setScaleFactor(90);   // 打印縮放比例
		sst.setHeaderMargin(0.3);
		sst.setBottomMargin(0.5);
		sst.setLeftMargin(0.2);
		sst.setRightMargin(0.2);
		sst.setTopMargin(0.5);
		sst.setFooterMargin(0.3);	
		
		//公司名稱中文平行置中     
		WritableCellFormat wCompCName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 16 ,WritableFont.BOLD,false));   
		wCompCName.setAlignment(jxl.format.Alignment.CENTRE);
			
		//公司名稱英文平行置中     
		WritableCellFormat wCompEName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 14 ,WritableFont.BOLD,false));   
		wCompEName.setAlignment(jxl.format.Alignment.CENTRE);
		
		//地址中文行置中     
		WritableCellFormat wAddrCName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), fontsize,WritableFont.BOLD,false));     
		wAddrCName.setAlignment(jxl.format.Alignment.CENTRE);
		
		//地址英文平行置中     
		WritableCellFormat wAddrEName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		wAddrEName.setAlignment(jxl.format.Alignment.CENTRE);
				
		//電話平行置中     
		WritableCellFormat wTelName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		wTelName.setAlignment(jxl.format.Alignment.CENTRE);
				
		//報表名稱平行置中    
		WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 14, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		wRptName.setAlignment(jxl.format.Alignment.CENTRE);
								
		//英文內文水平垂直置中     
		WritableCellFormat ACenter = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenter.setAlignment(jxl.format.Alignment.CENTRE);
		ACenter.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenter.setWrap(true);
		
		//英文內文水平垂直靠左
		WritableCellFormat ALeft = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeft.setAlignment(jxl.format.Alignment.LEFT);
		ALeft.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeft.setWrap(true);

		//英文內文水平垂直靠左-字體紅色
		WritableCellFormat ALeftRED = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false ,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		ALeftRED.setAlignment(jxl.format.Alignment.LEFT);
		ALeftRED.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftRED.setWrap(true);
		
		//英文內文水平垂直靠左-字體紅色
		WritableCellFormat ACenterRED = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false ,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		ACenterRED.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterRED.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterRED.setWrap(true);
				
		//英文內文水平靠左垂直TOP
		WritableCellFormat ALeftT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeftT.setAlignment(jxl.format.Alignment.LEFT);
		ALeftT.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);
		ALeftT.setWrap(true);

		//英文內文水平靠左垂直TOP-紅色
		WritableCellFormat ALeftTRED = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		ALeftTRED.setAlignment(jxl.format.Alignment.LEFT);
		ALeftTRED.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);
		ALeftTRED.setWrap(true);
				
		//英文內文水平垂直靠右
		WritableCellFormat ARight = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ARight.setAlignment(jxl.format.Alignment.RIGHT);
		ARight.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ARight.setWrap(true);

		//英文內文水平垂直置中-粗體-格線   
		WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBL.setWrap(true);
		
		//英文內文水平垂直靠左-粗體-格線   
		WritableCellFormat ALeftBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeftBL.setAlignment(jxl.format.Alignment.LEFT);
		ALeftBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ALeftBL.setWrap(true);

		//英文內文水平垂直靠右-粗體-格線   
		WritableCellFormat ARightBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ARightBL.setAlignment(jxl.format.Alignment.RIGHT);
		ARightBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ARightBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ARightBL.setWrap(true);
			
		//英文內文水平垂直置中-格線   
		WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterL.setWrap(true);

		//英文內文水平垂直置中-格線-紅色   
		WritableCellFormat ACenterLRED = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		ACenterLRED.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterLRED.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterLRED.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterLRED.setWrap(true);
		
		//英文內文水平垂直靠左-格線   
		WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeftL.setAlignment(jxl.format.Alignment.LEFT);
		ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ALeftL.setWrap(true);
		
		//英文內文水平垂直靠右-格線   
		WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ARightL.setAlignment(jxl.format.Alignment.RIGHT);
		ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ARightL.setWrap(true);

		//英文內文水平垂直靠右-格線-紅色  
		WritableCellFormat ARightLRED = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		ARightLRED.setAlignment(jxl.format.Alignment.RIGHT);
		ARightLRED.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ARightLRED.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ARightLRED.setWrap(true);
			
		//英文內文水平垂直置中-粗體   
		WritableCellFormat ACenterB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterB.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterB.setWrap(true);
		
		//英文內文水平垂直靠左-粗體  
		WritableCellFormat ALeft9 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeft9.setAlignment(jxl.format.Alignment.LEFT);
		ALeft9.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeft9.setWrap(true);
				
		//英文內文水平垂直靠左-粗體  
		WritableCellFormat ALeftB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeftB.setAlignment(jxl.format.Alignment.LEFT);
		ALeftB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftB.setWrap(true);
		
		//英文內文水平垂直靠左-粗體-紅色 
		WritableCellFormat ALeftBRED = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		ALeftBRED.setAlignment(jxl.format.Alignment.LEFT);
		ALeftBRED.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftBRED.setWrap(true);
				
		//英文內文水平垂直靠右-粗體   
		WritableCellFormat ARightB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ARightB.setAlignment(jxl.format.Alignment.RIGHT);
		ARightB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ARightB.setWrap(true);
		
		//英文內文水平垂直靠左-粗體-格線下   
		WritableCellFormat ALeft9B = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeft9B.setAlignment(jxl.format.Alignment.LEFT);
		ALeft9B.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeft9B.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.NONE);
		ALeft9B.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.NONE);
		ALeft9B.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.NONE);
		ALeft9B.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
		ALeft9B.setWrap(true);
				
		//英文內文水平垂直靠左-格線下   
		WritableCellFormat ALeftUL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeftUL.setAlignment(jxl.format.Alignment.LEFT);
		ALeftUL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftUL.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.NONE);
		ALeftUL.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.NONE);
		ALeftUL.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.NONE);
		ALeftUL.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
		ALeftUL.setWrap(true);
						
		//英文內文水平垂直靠左-粗體-格線下   
		WritableCellFormat ALeftBB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeftBB.setAlignment(jxl.format.Alignment.LEFT);
		ALeftBB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftBB.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.NONE);
		ALeftBB.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.NONE);
		ALeftBB.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.NONE);
		ALeftBB.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
		ALeftBB.setWrap(true);
		
		//英文內文水平垂直置中-粗體-格線下   
		WritableCellFormat ACenterBB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeftBB.setAlignment(jxl.format.Alignment.CENTRE);
		ALeftBB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftBB.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.NONE);
		ALeftBB.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.NONE);
		ALeftBB.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.NONE);
		ALeftBB.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
		ALeftBB.setWrap(true);		
		
		//中文內文水平垂直置中     
		WritableCellFormat CACenter = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		CACenter.setAlignment(jxl.format.Alignment.CENTRE);
		CACenter.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		CACenter.setWrap(true);
		
		//中文內文水平垂直靠左
		WritableCellFormat CALeft = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		CALeft.setAlignment(jxl.format.Alignment.LEFT);
		CALeft.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		CALeft.setWrap(true);
		
		//中文內文水平垂直靠右
		WritableCellFormat CARight = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		CARight.setAlignment(jxl.format.Alignment.RIGHT);
		CARight.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		CARight.setWrap(true);

		//中文內文水平垂直置中-粗體-格線   
		WritableCellFormat CACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		CACenterL.setAlignment(jxl.format.Alignment.CENTRE);
		CACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		CACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		CACenterL.setWrap(true);
		
		//中文內文水平垂直置中-粗體-格線   
		WritableCellFormat CACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		CACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
		CACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		CACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		CACenterBL.setWrap(true);
		
		//中文內文水平垂直靠左-粗體-格線   
		WritableCellFormat CALeftBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		CALeftBL.setAlignment(jxl.format.Alignment.LEFT);
		CALeftBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		CALeftBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		CALeftBL.setWrap(true);
		
		//中文內文水平垂直靠右-粗體-格線   
		WritableCellFormat CARightBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		CARightBL.setAlignment(jxl.format.Alignment.RIGHT);
		CARightBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		CARightBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		CARightBL.setWrap(true);
			
		//英文內文水平垂直置中-格線-底色黃
		WritableCellFormat CenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		CenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
		CenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		CenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		CenterBLY.setBackground(jxl.write.Colour.YELLOW); 
		CenterBLY.setWrap(true);	

		//英文內文水平垂直置右-格線-底色黃
		WritableCellFormat RightBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		RightBLY.setAlignment(jxl.format.Alignment.RIGHT);
		RightBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		RightBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		RightBLY.setBackground(jxl.write.Colour.YELLOW); 
		RightBLY.setWrap(true);	
				
    	//logo
        jxl.write.WritableImage image = new jxl.write.WritableImage(col,row,col+2.8+(v_marking_flag.equals("Y")?1:0),row+2, new File("..//resin-2.1.9//webapps/oradds/jsp/images/logo.png")); 
		ws.addImage(image); 

		if (v_marking_flag.equals("Y")) col++;
		
		String strCTitle = "台 灣 半 導 體 股 份 有 限 公 司";
		ws.mergeCells(col+2, row, col+9, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strCTitle , wCompCName));
		ws.setColumnView(col,60);	
		row++;//列+1
		
		String strETitle = "Taiwan Semiconductor Company limited";
		ws.mergeCells(col+2, row, col+9, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strETitle , wCompEName));
		row++;//列+1
		    	
		String strCAddr = "新北市新店區北新路三段205號11樓";
		ws.mergeCells(col+2, row, col+9, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strCAddr , wAddrCName));
		row++;//列+1		
				
		String strEAddr = "11Fl.,No,205,Sec.3,Beishin Rd., Xindian Dist., New Taipei City 231, Taiwan";
		ws.mergeCells(col+2, row, col+9, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strEAddr , wAddrEName));
		row++;//列+1	
		
		String strTelInfo = "Tel: 886-2-8913-1588, Fax: 886-2-8913-1788";
		ws.mergeCells(col+2, row, col+9, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strTelInfo , wTelName));
		row++;//列+1	
					
		String strName = "委 外 託 工 單";
		ws.mergeCells(col+2, row, col+9, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strName , wRptName));
		row++;//列+1

		col=0;
		if (WIP_TYPE_NO.equals("01") || WIP_TYPE_NO.equals("02")) //add by Peggy 20140814,工程&量產工單顯示芯片尺吋
		{
			line=9;
		}
		else
		{
			line=8;
		}			
		if (v_marking_flag.equals("Y")) line++; //add by Peggy 20210222	
		
		row+=2;
		ws.mergeCells(col, row, col+1, row); 
    	ws.addCell(new jxl.write.Label(col, row ,"To：" , ARight));
		ws.setColumnView(col,2);	
		ws.mergeCells(col+2, row, col+4,row);
    	ws.addCell(new jxl.write.Label(col+2, row ,VENDOR ,ALeftUL));
		ws.setColumnView(col+2,8);	
		if (v_marking_flag.equals("Y"))
		{
			ws.setColumnView(col+line-1,12);	
		}
		ws.addCell(new jxl.write.Label(col+line, row ,"Issue Date：" , ARight));
		ws.setColumnView(col+line,12);	
    	ws.addCell(new jxl.write.Label(col+line+1, row ,rsh.getString("REQUEST_DATE") , ALeftUL));
		ws.setColumnView(col+line+1,12);	
		row++;//列+1
				
		ws.mergeCells(col, row, col+1, row); 
    	ws.addCell(new jxl.write.Label(col, row ,"Attn：" , ARight));
		//ws.setColumnView(col,2);	
		ws.mergeCells(col+2, row, col+4,row);
    	ws.addCell(new jxl.write.Label(col+2, row ,rsh.getString("vendor_contact") , ALeftUL));
		//ws.setColumnView(col+2,8);	
    	ws.addCell(new jxl.write.Label(col+line, row ,"Order No：" , ARight));
		//ws.setColumnView(col+line,12);	
    	ws.addCell(new jxl.write.Label(col+line+1, row ,WIPNO, ALeftUL));
		//ws.setColumnView(col+line+1,10);	
		row++;//列+1	

		//add by Peggy 20120726
		if (!VERSION_ID.equals("0"))
		{
			CHANGE_DATE = APPROVED_DATE+" Update";
			ws.mergeCells(col+line, row, col+line+1, row); 
			ws.addCell(new jxl.write.Label(col+line, row ,CHANGE_DATE, ACenterRED));
			//ws.setColumnView(col+line,10);	
		}
		row+=2;
		ws.mergeCells(col, row, col+7, row);
    	//ws.addCell(new jxl.write.Label(col, row ,"  "+((ASSEMBLY.equals("Y"))?"[V] ":"    ")+"封裝 Assembly   "+((TESTING.equals("Y"))?"[V] ":"    ")+"測試 Testing    "+((TAPING_REEL.equals("Y"))?"[V] ":"    ")+"編帶 T＆R   "+((LAPPING.equals("Y"))?"[V] ":"    ")+"減薄 Lapping   "+((OTHERS!=null)?"[V] ":"    ")+"其他 Others" , ALeft9));
		ws.addCell(new jxl.write.Label(col, row ,"    "+((ASSEMBLY.equals("Y"))?"[V] ":"[ ] ")+"封裝 Assembly   "+((TESTING.equals("Y"))?"[V] ":"[ ] ")+"測試 Testing    "+((TAPING_REEL.equals("Y"))?"[V] ":"[ ] ")+"編帶 T＆R   "+((LAPPING.equals("Y"))?"[V] ":"[ ] ")+"減薄 Lapping   "+((OTHERS!=null)?"[V] ":"[ ] ")+"其他 Others" , ALeft9));
		ws.mergeCells(col+8, row, col+9, row);
    	ws.addCell(new jxl.write.Label(col+8, row ,((OTHERS!=null)?OTHERS:""), ALeft9B));
		row++;//列+1	
									
		row++;
		line=1;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Item" , ACenterBL));
		ws.setColumnView(col+line,5);	
		line++;
		ws.addCell(new jxl.write.Label(col+line, row ,"品號" ,CACenterBL));
		//ws.setColumnView(col+line,12);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"封裝型式" , CACenterBL));
		//ws.setColumnView(col+line,9);		
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"芯片名稱" , CACenterBL));
		//ws.setColumnView(col+line,10);	
		line++;
		if (WIP_TYPE_NO.equals("01") || WIP_TYPE_NO.equals("02")) //add by Peggy 20140814,工程&量產工單顯示芯片尺吋
		{
			ws.addCell(new jxl.write.Label(col+line, row ,"芯片尺吋" , CACenterBL));
			//ws.setColumnView(col+line,10);	
			line++;
		}
    	ws.addCell(new jxl.write.Label(col+line, row ,"數量 Q'ty" , CACenterBL));
		ws.setColumnView(col+line,10);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"單價 u/p" , CACenterBL));
		//ws.setColumnView(col+line,10);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"包裝" , CACenterBL));
		//ws.setColumnView(col+line,14);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"封裝規格" , CACenterBL));
		//ws.setColumnView(col+line,14);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"測試規格" , CACenterBL));
		//ws.setColumnView(col+line,14);		
		if (v_marking_flag.equals("Y"))  //add by Peggy 20210222
		{
			line++;
			ws.addCell(new jxl.write.Label(col+line, row ,"印章規格" ,CACenterBL));
		}
		//add by Peggy 20220930
		//if (rsh.getString("vendor_item_desc")!=null)
		if (VENDOR_CODE.equals("4746"))
		{
			line++;
			ws.addCell(new jxl.write.Label(col+line, row ,"TSC品號" ,CACenterBL));
		}
		row++;//列+1
		line=1;
    	ws.addCell(new jxl.write.Label(col+line, row ,"No." , ACenterBL));
		//ws.setColumnView(col+line,5);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Device Name" , ACenterBL));
		//ws.setColumnView(col+line,12);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Package" ,ACenterBL));
		//ws.setColumnView(col+line,9);		
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Die Name" , ACenterBL));
		//ws.setColumnView(col+line,10);	
		line++;
		if (WIP_TYPE_NO.equals("01") || WIP_TYPE_NO.equals("02")) //add by Peggy 20140814,工程&量產工單顯示芯片尺吋
		{
			ws.addCell(new jxl.write.Label(col+line, row ,"Wafer Size" , ACenterBL));
			//ws.setColumnView(col+line,10);	
			line++;
		}		
    	ws.addCell(new jxl.write.Label(col+line, row , (rsh.getString("unit_price_uom").equals("片"))?"片數":"(Kpcs)" , ACenterBL));
		//ws.setColumnView(col+line,10);	
		line++;
		ws.addCell(new jxl.write.Label(col+line, row ,rsh.getString("currency_code").replace("TWD","NTD")+"/"+rsh.getString("unit_price_uom"), ACenterBL));  //modify by Peggy 20120705
		//ws.setColumnView(col+line,14);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Packing" , ACenterBL));
		//ws.setColumnView(col+line,14);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"D/B No." , ACenterBL));
		//ws.setColumnView(col+line,14);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Test Spec" , ACenterBL));
		//ws.setColumnView(col+line,14);		
		if (v_marking_flag.equals("Y"))  //add by Peggy 20210222
		{
			line++;
			ws.addCell(new jxl.write.Label(col+line, row ,"Marking No." ,ACenterBL));
		}	
		//add by Peggy 20220930
		//if (rsh.getString("vendor_item_desc")!=null)
		if (VENDOR_CODE.equals("4746"))
		{
			line++;
			ws.addCell(new jxl.write.Label(col+line, row ,"TSC Device Name" ,CACenterBL));
		}			
		row++;//列+1
		
		//add by Peggy 20120726
		String ORIG_QTY=rsh.getString("QUANTITY"),ORIG_UNIT_PRICE=rsh.getString("UNIT_PRICE"),ORIG_PACKAGE_SPEC=rsh.getString("PACKAGE_SPEC"),ORIG_TEST_SPEC=rsh.getString("TEST_SPEC"),ORIG_REMARKS=rsh.getString("REMARKS"),ORIG_MARKING=rsh.getString("MARKING");
		sql = " SELECT   a.quantity,a.unit_price,a.PACKAGE_SPEC,a.TEST_SPEC,a.ITEM_PACKAGE,a.REMARKS,a.MARKING"+
              " FROM oraddman.tspmd_oem_headers_all a"+
              " where  a.request_no||'-'||a.version_id='"+ORIG_REQUESTNO+"'";			
		Statement statex=con.createStatement();     
    	ResultSet rsx=statex.executeQuery(sql);
		if (rsx.next())	
		{
			ORIG_QTY = rsx.getString("quantity");
			ORIG_UNIT_PRICE = rsx.getString("unit_price");
			ORIG_PACKAGE_SPEC = rsx.getString("PACKAGE_SPEC");
			ORIG_TEST_SPEC = rsx.getString("TEST_SPEC");
			ORIG_REMARKS = rsx.getString("REMARKS");
			ORIG_MARKING = rsx.getString("MARKING");
		}
		rsx.close();
		statex.close();
		 		
		line=1;	
    	ws.addCell(new jxl.write.Label(col+line, row ,"1" , ACenterL));
		//ws.setColumnView(col+line,5);	
		line++;
		//add by Peggy 20220930
		//if (rsh.getString("vendor_item_desc")!=null)
		if (VENDOR_CODE.equals("4746"))
		{
    		ws.addCell(new jxl.write.Label(col+line, row , (rsh.getString("vendor_item_desc")==null?rsh.getString("item_description"):rsh.getString("vendor_item_desc")) , ACenterL));
		}
		else
		{
    		ws.addCell(new jxl.write.Label(col+line, row , rsh.getString("item_description") , ACenterL));
		}		
    	//ws.addCell(new jxl.write.Label(col+line, row , rsh.getString("item_description") , ACenterL));
		//ws.setColumnView(col+line,12);	
		line++;
		//add by Peggy 20220930
		if (rsh.getString("inventory_item_name").substring(4,7).equals("SGT") && (rsh.getString("inventory_item_name").substring(13,15).equals("EV") || rsh.getString("inventory_item_name").substring(13,15).equals("EF")))
		{
	    	ws.addCell(new jxl.write.Label(col+line, row ,"TAIKO "+rsh.getString("ITEM_PACKAGE") ,ACenterL));
		}
		else
		{
	    	ws.addCell(new jxl.write.Label(col+line, row ,rsh.getString("ITEM_PACKAGE") ,ACenterL));
		}
		//ws.setColumnView(col+line,9);		
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,rsh.getString("DIE_NAME") , ACenterL));
		//ws.setColumnView(col+line,10);	
		line++;
		if (WIP_TYPE_NO.equals("01") || WIP_TYPE_NO.equals("02")) //add by Peggy 20140814,工程&量產工單顯示芯片尺吋
		{
			//晶片料號11碼的判別尺吋在第2碼
            //晶片料號14碼的判別尺吋在第7碼
            //晶片料號12碼的判別尺吋在第9碼
            //晶片料號16碼的判別尺吋在第13碼
			//modify by Peggy 20200305
			if (DIE_ITEM_NAME.length()==11)
			{
				v_wafer_size = DIE_ITEM_NAME.substring(1,2);
			}
			else if (DIE_ITEM_NAME.length()==12)
			{
				v_wafer_size = DIE_ITEM_NAME.substring(8,9);
			}
			else if (DIE_ITEM_NAME.length()==14)
			{
				v_wafer_size = DIE_ITEM_NAME.substring(6,7);
			}
			else if (DIE_ITEM_NAME.length()==16)
			{
				v_wafer_size = DIE_ITEM_NAME.substring(12,13);
			}
			else if (DIE_ITEM_NAME.length()==17)
			{
				v_wafer_size = DIE_ITEM_NAME.substring(13,14);
			}			
			else
			{
				v_wafer_size ="";
			}
			
			if (v_wafer_size.matches("[0-9]+")) 
			{
				ws.addCell(new jxl.write.Label(col+line, row ,v_wafer_size , ACenterL));
			}	
			else
			{
				ws.addCell(new jxl.write.Label(col+line, row ,"ERROR" , ACenterLRED));
			}

			/*if (TSC_PROD_GROUP.equals("PMD"))  //add by Peggy 20161123
			{
				ws.addCell(new jxl.write.Label(col+line, row ,DIE_ITEM_NAME.substring(DIE_ITEM_NAME.length()-4,DIE_ITEM_NAME.length()-3) , ACenterL));
			}
			else
			{
				if ((DIE_ITEM_NAME.substring(6,7)).matches("[0-9]+")) 
				{
					ws.addCell(new jxl.write.Label(col+line, row ,DIE_ITEM_NAME.substring(6,7) , ACenterL));
				}	
				else
				{
					ws.addCell(new jxl.write.Label(col+line, row ,DIE_ITEM_NAME.substring(1,2) , ACenterL));
				}
			}*/
			
			//ws.setColumnView(col+line,10);	
			line++;
		}		
		if (rsh.getString("QUANTITY") != null && !ORIG_QTY.equals(rsh.getString("QUANTITY")))
		{
    		//ws.addCell(new jxl.write.Label(col+line, row ,(new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rsh.getString("QUANTITY"))) , ACenterLRED));
			ws.addCell(new jxl.write.Number(col+line,row, Double.valueOf(rsh.getString("QUANTITY")).doubleValue() ,ACenterLRED));
		}
		else
		{
    		//ws.addCell(new jxl.write.Label(col+line, row ,(new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rsh.getString("QUANTITY"))) , ACenterL));
			ws.addCell(new jxl.write.Number(col+line,row, Double.valueOf(rsh.getString("QUANTITY")).doubleValue() ,ACenterL));
		}
		//ws.setColumnView(col+line,10);	
		line++;
		if (!rsh.getString("vendor_code").equals("1621"))  //天水華天不想看單價,add by Peggy 20200313
		{
			if (rsh.getString("UNIT_PRICE") != null && !ORIG_UNIT_PRICE.equals(rsh.getString("UNIT_PRICE")))
			{
				//ws.addCell(new jxl.write.Label(col+line, row ,(new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rsh.getString("UNIT_PRICE"))) , ACenterLRED));
				ws.addCell(new jxl.write.Number(col+line,row, Double.valueOf(rsh.getString("UNIT_PRICE")).doubleValue() ,ACenterLRED));
			}
			else
			{
				//ws.addCell(new jxl.write.Label(col+line, row ,(new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rsh.getString("UNIT_PRICE"))) , ACenterL));
				ws.addCell(new jxl.write.Number(col+line,row, Double.valueOf(rsh.getString("UNIT_PRICE")).doubleValue() ,ACenterL));
			}
		}
		else
		{
    		ws.addCell(new jxl.write.Label(col+line, row , "*****" , ACenterL));
		}
		//ws.setColumnView(col+line,10);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,rsh.getString("PACKING") , ACenterL));
		//ws.setColumnView(col+line,9);	
		line++;
		if (rsh.getString("PACKAGE_SPEC") != null && !ORIG_PACKAGE_SPEC.equals(rsh.getString("PACKAGE_SPEC")))
		{
    		ws.addCell(new jxl.write.Label(col+line, row ,rsh.getString("PACKAGE_SPEC") , ACenterLRED));
		}
		else
		{
    		ws.addCell(new jxl.write.Label(col+line, row ,rsh.getString("PACKAGE_SPEC") , ACenterL));
		}
		//ws.setColumnView(col+line,14);	
		line++;
		if (rsh.getString("TEST_SPEC") != null && !ORIG_TEST_SPEC.equals(rsh.getString("TEST_SPEC")))
		{
    		ws.addCell(new jxl.write.Label(col+line, row ,rsh.getString("TEST_SPEC") , ACenterLRED));
		}
		else
		{
    		ws.addCell(new jxl.write.Label(col+line, row ,rsh.getString("TEST_SPEC") , ACenterL));
		}
		//ws.setColumnView(col+line,14);		
		if (v_marking_flag.equals("Y"))  //add by Peggy 20210222
		{
			line++;
			ws.addCell(new jxl.write.Label(col+line, row ,v_marking_no , ACenterL));
		}
		//add by Peggy 20220930
		//if (rsh.getString("vendor_item_desc")!=null)
		if (VENDOR_CODE.equals("4746"))
		{
			line++;			
    		ws.addCell(new jxl.write.Label(col+line, row , rsh.getString("item_description") , ACenterL));
		}				
		row++;//列+1	
		
		line=1;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		//ws.setColumnView(col+line,5);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row , "", ACenterL));
		//ws.setColumnView(col+line,12);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"-- END --" ,ACenterL));
		//ws.setColumnView(col+line,9);		
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		//ws.setColumnView(col+line,10);	
		line++;
		if (WIP_TYPE_NO.equals("01") || WIP_TYPE_NO.equals("02")) //add by Peggy 20140814,工程&量產工單顯示芯片尺吋
		{
	    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
			//ws.setColumnView(col+line,10);	
			line++;
		}		
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		//ws.setColumnView(col+line,10);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		//ws.setColumnView(col+line,10);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		//ws.setColumnView(col+line,9);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		//ws.setColumnView(col+line,14);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		//ws.setColumnView(col+line,14);	
		if (v_marking_flag.equals("Y"))  //add by Peggy 20210222
		{	
			line++;
			ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));			
		}	
		//add by Peggy 20220930
		//if (rsh.getString("vendor_item_desc")!=null)
		if (VENDOR_CODE.equals("4746"))
		{
			line++;
			ws.addCell(new jxl.write.Label(col+line, row ,"" ,ACenterL));
		}				
		row++;//列+1						
			
		row++;
		ws.mergeCells(col+1, row, col+2, row);     
    	ws.addCell(new jxl.write.Label(col+1, row,"備註(Remarks):" , CALeft));
		ws.mergeCells(col+3, row, col+4, row); 
		ws.addCell(new jxl.write.Label(col+3, row, (rsh.getString("inventory_item_name").length() >=19 && (rsh.getString("inventory_item_name").substring(19,20).equals("H") || rsh.getString("item_description").substring(1,2).equals("Q") || rsh.getString("inventory_item_name").substring(10,12).equals("TP"))?"Marking 末碼要加底線":"") , ALeftTRED));
		row++;//列+1																		

		if (WIP_TYPE_NO.equals("01") || WIP_TYPE_NO.equals("02")) //add by Peggy 20140814,工程&量產工單顯示芯片尺吋
		{
			ws.mergeCells(col+1, row, col+10, row+7);     
		}
		else
		{
			ws.mergeCells(col+1, row, col+9, row+7);     
		}
		if (!ORIG_REMARKS.equals(rsh.getString("remarks")))
		{
    		ws.addCell(new jxl.write.Label(col+1,row, rsh.getString("remarks") , ALeftTRED));//add by Peggy 20161005
		}
		else
		{
    		ws.addCell(new jxl.write.Label(col+1,row,rsh.getString("remarks") , ALeftT));//add by Peggy 20161005
		}
		
		row+=9;//列+1																		
		
    	ws.addCell(new jxl.write.Label(col+1, row,rsh.getString("inventory_item_name").length()+"碼" , ALeft));
		ws.mergeCells(col+2, row, col+5, row);     
    	ws.addCell(new jxl.write.Label(col+2, row, rsh.getString("inventory_item_name") , new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 10, WritableFont.NO_BOLD,false))));
		row++;//列+1	
				
		ws.mergeCells(col+1, row, col+5, row);     
    	ws.addCell(new jxl.write.Label(col+1, row, "Production Control:" , new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 10, WritableFont.NO_BOLD,false))));
		row++;//列+1	
		
		if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))  //add by Peggy 20180726
		{		
			str_marking_two="";str_marking_three="";
			String a_marking [] = rsh.getString("MARKING").split("\n");
			for (int g=1; g<=2 ;g++)
			{
				if (g==1)
				{
					str_marking_two = a_marking[g];		
				}
				else if (g==2)
				{
					str_marking_three = a_marking[g];		
				}
			}
		}
		
		String sqld = " SELECT a.line_no,a.lot_number, a.wafer_qty, a.chip_qty,a.date_code, to_char(to_date(a.completion_date,'yyyymmdd'),'yyyy-mm-dd') completion_date,wafer_number,dc_yyww,die_mode"+
                  	  " FROM oraddman.tspmd_oem_lines_all a"+
					  " where a.request_no||'-'||a.version_id='"+ rsh.getString("REQUEST_NO")+"' order by a.line_no";				   
		Statement stated=con.createStatement();
		ResultSet rsd=stated.executeQuery(sqld);
		cnt=0; 
		double tot_wafer =0,tot_chip=0;
		int i_waferno=0;							  
		while (rsd.next())
		{ 
			if (cnt==0)
			{
				ws.addCell(new jxl.write.Label(col+2, row, "Wafer Lot #" , ACenterL));
				ws.addCell(new jxl.write.Label(col+3, row, "Wafer Qty" , ACenterL));
				if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))  //add by Peggy 20221208
				{
					ws.addCell(new jxl.write.Label(col+4, row, "Wafer No" , ACenterL));
					i_waferno =1;
				}				
				ws.addCell(new jxl.write.Label(col+4+i_waferno, row, "Chip Qty(kpcs)" , ACenterL));
				//ws.setColumnView(col+4,10);	
				ws.addCell(new jxl.write.Label(col+5+i_waferno, row, "Date Code" , ACenterL));
				if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))
				{				
					if (i_addline==1)
					{
						ws.addCell(new jxl.write.Label(col+5+i_addline+i_waferno, row, "DC YYWW" , ACenterL));
					}
					ws.addCell(new jxl.write.Label(col+6+i_addline+i_waferno, row, "Request S/D" , ACenterL));
				}				
				if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))  //add by Peggy 20180726
				{
					ws.addCell(new jxl.write.Label(col+6+i_waferno, row, "Request S/D" , ACenterL));
					ws.addCell(new jxl.write.Label(col+7+i_waferno, row, "Wafer No" , ACenterL));
					ws.mergeCells(col+7+i_waferno, row, col+8+i_waferno, row);  
					ws.addCell(new jxl.write.Label(col+9+i_waferno, row, "印章第二行" , ACenterL));
					ws.addCell(new jxl.write.Label(col+10+i_waferno, row, "印章第三行" , ACenterL));
					if (i_addline==1)
					{
						ws.addCell(new jxl.write.Label(col+10+i_addline+i_waferno, row, "DC YYWW" , ACenterL));
					}
				}
				else if (rsh.getString("item_description").equals("TSC497CX RFG")) //add by Peggy 20220427
				{
					ws.addCell(new jxl.write.Label(col+7+i_addline+i_waferno, row, "Marking" , ACenterL));
				}
				else if (VENDOR_CODE.equals("3864")) //捷敏科 by Peggy 20221208
				{
					ws.addCell(new jxl.write.Label(col+7+i_addline+i_waferno, row, "取Die模式" , ACenterL));
				}
				//ws.setColumnView(col+6+(VENDOR_CODE.equals("4056")?4:0),10);	
				row++;//列+1	
			}
			
			//add by Peggy 20120727
			String ORIG_LOT=rsd.getString("lot_number"),ORIG_WAFER_QTY=rsd.getString("wafer_qty"),ORIG_CHIP_QTY=rsd.getString("chip_qty"),ORIG_DATE_CODE=rsd.getString("date_code"),ORIG_COMPLETION_DATE=rsd.getString("completion_date");
			sql = " select a.lot_number, a.wafer_qty, a.chip_qty,a.date_code, to_char(to_date(a.completion_date,'yyyymmdd'),'yyyy-mm-dd') completion_date ,a.wafer_number,a.dc_yyww,a.die_mode"+  //add wafer_number by Peggy 20180726
		       	  " FROM oraddman.tspmd_oem_lines_all a"+
			      " where a.request_no||'-'||a.version_id='"+ ORIG_REQUESTNO +"' and a.line_no = '" + rsd.getString("LINE_NO")+"'";	 
			Statement statey=con.createStatement();
			ResultSet rsy=statey.executeQuery(sql);
			if (rsy.next())
			{
				ORIG_LOT=rsy.getString("lot_number");
				ORIG_WAFER_QTY=rsy.getString("wafer_qty");
				ORIG_CHIP_QTY=rsy.getString("chip_qty");
				ORIG_DATE_CODE=rsy.getString("date_code");
				if (ORIG_DATE_CODE==null) ORIG_DATE_CODE="";
				ORIG_COMPLETION_DATE=rsy.getString("completion_date");
				ORIG_WAFER_NUMBER=rsy.getString("wafer_number"); //add by Peggy 20180726
				ORIG_DC_YYWW=rsy.getString("dc_yyww"); //add by Peggy 20221205
				if (ORIG_DC_YYWW==null) ORIG_DC_YYWW="";
				ORIG_WAFER_NO=rsy.getString("wafer_number");
				if (ORIG_WAFER_NO==null) ORIG_WAFER_NO="";
				ORIG_DIE_MODE=rsy.getString("DIE_MODE");	
				if (ORIG_DIE_MODE==null) ORIG_DIE_MODE="";			
			}
			rsy.close();
			statey.close();
			
			if (rsd.getString("date_code").toUpperCase().equals("HOLD"))
			{
				ws.addCell(new jxl.write.Label(col+2, row, rsd.getString("lot_number") , CenterBLY));
			}
			else if (rsd.getString("lot_number") != null && !ORIG_LOT.equals(rsd.getString("lot_number")))
			{
				ws.addCell(new jxl.write.Label(col+2, row, rsd.getString("lot_number") , ACenterLRED));
			}
			else
			{
				ws.addCell(new jxl.write.Label(col+2, row, rsd.getString("lot_number") , ACenterL));
			}
			
			if (rsd.getString("date_code").toUpperCase().equals("HOLD"))
			{
				//ws.addCell(new jxl.write.Label(col+3, row, (new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rsd.getString("wafer_qty"))) , RightBLY));
				ws.addCell(new jxl.write.Number(col+3, row, Double.valueOf(rsd.getString("wafer_qty")).doubleValue() ,RightBLY));
			}
			else if (rsd.getString("wafer_qty") != null && !ORIG_WAFER_QTY.equals(rsd.getString("wafer_qty")))
			{
				//ws.addCell(new jxl.write.Label(col+3, row, (new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rsd.getString("wafer_qty"))) , ARightLRED));
				ws.addCell(new jxl.write.Number(col+3, row, Double.valueOf(rsd.getString("wafer_qty")).doubleValue() , ARightLRED));
			}
			else
			{
				//ws.addCell(new jxl.write.Label(col+3, row, (new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rsd.getString("wafer_qty"))) , ARightL));
				ws.addCell(new jxl.write.Number(col+3, row, Double.valueOf(rsd.getString("wafer_qty")).doubleValue() , ARightL));
			}
			if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))  //add by Peggy 20221208
			{
				if (rsd.getString("wafer_number") != null && !ORIG_WAFER_NO.equals(rsd.getString("wafer_number")))
				{
					ws.addCell(new jxl.write.Label(col+4, row, rsd.getString("wafer_number"), ACenterLRED));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col+4, row, rsd.getString("wafer_number"), ACenterL));
				}
			}			
			if (rsd.getString("date_code").toUpperCase().equals("HOLD"))
			{
				//ws.addCell(new jxl.write.Label(col+4, row, (new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rsd.getString("chip_qty"))) , RightBLY));
				ws.addCell(new jxl.write.Number(col+4+i_waferno, row, Double.valueOf(rsd.getString("chip_qty")).doubleValue() , RightBLY));
			}
			else if (rsd.getString("chip_qty") != null && !ORIG_CHIP_QTY.equals(rsd.getString("chip_qty")))
			{
				//ws.addCell(new jxl.write.Label(col+4, row, (new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rsd.getString("chip_qty"))) , ARightLRED));
				ws.addCell(new jxl.write.Number(col+4+i_waferno, row, Double.valueOf(rsd.getString("chip_qty")).doubleValue() , ARightLRED));
			}
			else
			{
				//ws.addCell(new jxl.write.Label(col+4, row, (new DecimalFormat("##,##0.0###")).format(Float.parseFloat(rsd.getString("chip_qty"))) , ARightL));
				ws.addCell(new jxl.write.Number(col+4+i_waferno, row, Double.valueOf(rsd.getString("chip_qty")).doubleValue() , ARightL));
			}
			if (rsd.getString("date_code").toUpperCase().equals("HOLD"))
			{
				ws.addCell(new jxl.write.Label(col+5+i_waferno, row, (rsd.getString("date_code")==null?"":rsd.getString("date_code")), CenterBLY));
				if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))  //add by Peggy 20180726
				{				
					if (i_addline==1)
					{
						if (rsd.getString("dc_yyww")==null || (rsd.getString("dc_yyww")!=null && rsd.getInt("dc_yyww")<=2301))
						{
							ws.addCell(new jxl.write.Label(col+5+i_addline+i_waferno, row, "", CenterBLY));
						}
						else
						{
							ws.addCell(new jxl.write.Label(col+5+i_addline+i_waferno, row, (rsd.getString("dc_yyww")==null?"":rsd.getString("dc_yyww")), CenterBLY));
						
						}
					}
				}
			}
			else if (rsd.getString("date_code") != null && !ORIG_DATE_CODE.equals(rsd.getString("date_code")))
			{
				ws.addCell(new jxl.write.Label(col+5+i_waferno, row, (rsd.getString("date_code")==null?"":rsd.getString("date_code")), ACenterLRED));
				if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))  //add by Peggy 20180726
				{	
					if (i_addline==1)
					{
						if (rsd.getString("dc_yyww")==null || (rsd.getString("dc_yyww")!=null && rsd.getInt("dc_yyww")<=2301))
						{
							ws.addCell(new jxl.write.Label(col+5+i_addline+i_waferno, row, "", CenterBLY));
						}
						else
						{				
							ws.addCell(new jxl.write.Label(col+5+i_addline+i_waferno, row, (rsd.getString("dc_yyww")==null?"":rsd.getString("dc_yyww")), ACenterLRED));
						}
					}
				}				
			}
			else
			{
				ws.addCell(new jxl.write.Label(col+5+i_waferno, row, (rsd.getString("date_code")==null?"":rsd.getString("date_code")), ACenterL));
				if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))  //add by Peggy 20180726
				{				
					if (i_addline==1)
					{
				
						if (rsd.getString("dc_yyww")==null || (rsd.getString("dc_yyww")!=null && rsd.getInt("dc_yyww")<=2301))
						{
							ws.addCell(new jxl.write.Label(col+5+i_addline+i_waferno, row, "", CenterBLY));
						}
						else
						{				
							ws.addCell(new jxl.write.Label(col+5+i_addline+i_waferno, row, (rsd.getString("dc_yyww")==null?"":rsd.getString("dc_yyww")), ACenterL));
						}
					}
				}				
			}

			if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))  //add by Peggy 20180726
			{			
				if (rsd.getString("date_code").toUpperCase().equals("HOLD"))
				{
					ws.addCell(new jxl.write.Label(col+6+i_addline+i_waferno, row, rsd.getString("completion_date") , CenterBLY));
				}
				else if (rsd.getString("completion_date") != null && !ORIG_COMPLETION_DATE.equals(rsd.getString("completion_date")))
				{
					ws.addCell(new jxl.write.Label(col+6+i_addline+i_waferno, row, rsd.getString("completion_date") , ACenterLRED));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col+6+i_addline+i_waferno, row, rsd.getString("completion_date") , ACenterL));
				}
			}
			else
			{
				if (rsd.getString("date_code").toUpperCase().equals("HOLD"))
				{
					ws.addCell(new jxl.write.Label(col+6+i_waferno, row, rsd.getString("completion_date") , CenterBLY));
				}
				else if (rsd.getString("completion_date") != null && !ORIG_COMPLETION_DATE.equals(rsd.getString("completion_date")))
				{
					ws.addCell(new jxl.write.Label(col+6+i_waferno, row, rsd.getString("completion_date") , ACenterLRED));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col+6+i_waferno, row, rsd.getString("completion_date") , ACenterL));
				}			
			}
			
			if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))  //add by Peggy 20180726
			{
				if (rsd.getString("wafer_number") != null && !ORIG_WAFER_NUMBER.equals(rsd.getString("wafer_number")))
				{
					ws.addCell(new jxl.write.Label(col+7+i_waferno, row, (rsd.getString("wafer_number")==null?"":rsd.getString("wafer_number")) , ACenterLRED));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col+7+i_waferno, row,  (rsd.getString("wafer_number")==null?"":rsd.getString("wafer_number")) , ACenterL));
				}	
				ws.mergeCells(col+7+i_waferno, row, col+8+i_waferno, row);  
				ws.addCell(new jxl.write.Label(col+9+i_waferno, row, str_marking_two.replace("YML",rsd.getString("date_code")), ACenterL));
				ws.addCell(new jxl.write.Label(col+10+i_waferno, row, str_marking_three.replace("YML",rsd.getString("date_code")), ACenterL));
				if (i_addline==1)
				{	
					if (rsd.getString("dc_yyww")==null || rsd.getInt("dc_yyww")<=2301)
					{
						ws.addCell(new jxl.write.Label(col+10+i_addline+i_waferno, row, "", CenterBLY));
					}
					else
					{				
						ws.addCell(new jxl.write.Label(col+10+i_addline+i_waferno, row, (rsd.getString("dc_yyww")==null?"":rsd.getString("dc_yyww")), ACenterL));
					}				
				}				
			}
			else if (rsh.getString("item_description").equals("TSC497CX RFG")) //add by Peggy 20220427
			{			
				ws.addCell(new jxl.write.Label(col+7+i_addline+i_waferno, row, "C9"+rsd.getString("date_code") , ACenterL));
			}
			else if (VENDOR_CODE.equals("3864")) //捷敏科 by Peggy 20221208
			{
				if (rsd.getString("die_mode") != null && !ORIG_DIE_MODE.equals(rsd.getString("die_mode")))
				{
					ws.addCell(new jxl.write.Label(col+7+i_addline+i_waferno, row, (rsd.getString("die_mode")==null?"":rsd.getString("die_mode")), ACenterLRED));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col+7+i_addline+i_waferno, row,  (rsd.getString("die_mode")==null?"":rsd.getString("die_mode")), ACenterL));
				}				
			}	
					
			if ((WIP_TYPE_NO.equals("01") || WIP_TYPE_NO.equals("02")) && i_addline==0) //add by Peggy 20140814,工程&量產工單顯示芯片尺吋
			{
				line=9+i_waferno;
			}
			else
			{
				line=8+i_addline+i_waferno;
			}			

			if (v_marking_flag.equals("Y")) line++; //add by Peggy 20210222
			
			if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))
			{			
				if (cnt==0)
				{
					ws.addCell(new jxl.write.Label(col+line+i_addline-1, row, "Marking" , ACenterBB));
				}
				else if (cnt==1)
				{
					v_making="Y";
					ws.mergeCells(col+line+i_addline-1,row,col+line+i_addline-1,row+3);
					if (!ORIG_MARKING.equals(rsh.getString("MARKING")))
					{
						//if (rsh.getString("item_description").equals("TS78L05IX RF")) //add by Peggy 20140213
						if (rsh.getString("item_description").startsWith("TS78L05IX RF")) //add by Peggy 20150522
						{
							imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/L5YML.PNG";
							File f = new File(imageFile);
							if(f.exists()) 
							{
								jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+line+0.1+i_addline-1, row+0.1,0.5,1.5, f); 
								ws.addImage(image1);
							}
						}
						else
						{
							//add by Peggy 20220530
							imageFile="..//resin-2.1.9//webapps/oradds/PMD_Marking/"+rsh.getString("item_description")+".png";
							File f = new File(imageFile);
							if(f.exists()) 
							{
								jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+line+i_addline-1, row+0.1,1,2.3, f); 
								ws.addImage(image1);
							}
							else
							{							
								ws.addCell(new jxl.write.Label(col+line+i_addline-1, row, rsh.getString("MARKING"), ALeftBRED));
								v_making="N";
							}
						}
					}
					else
					{
						//if (rsh.getString("item_description").equals("TS78L05IX RF")) //add by Peggy 20140213
						if (rsh.getString("item_description").startsWith("TS78L05IX RF")) //add by Peggy 20150522
						{
							imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/L5YML.PNG";
							File f = new File(imageFile);
							if(f.exists()) 
							{
								jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+line+0.1+i_addline-1, row+0.1,0.5,1.5, f); 
								ws.addImage(image1);
							}
						}
						else
						{
							//add by Peggy 20220530
							imageFile="..//resin-2.1.9//webapps/oradds/PMD_Marking/"+rsh.getString("item_description")+".png";
							File f = new File(imageFile);
							if(f.exists()) 
							{
								jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+line+i_addline-1, row+0.1,1,2.3, f); 
								ws.addImage(image1);
							}
							else
							{						
								ws.addCell(new jxl.write.Label(col+line+i_addline-1, row, rsh.getString("MARKING"), ALeftB));
								v_making="N";
							}
						} 
					}
				
					if (v_making.equals("N"))
					{
						String a_marking [] = rsh.getString("MARKING").split("\n");
						String str_marking ="";
						float xx=0,yy=0;
						for (int g=0; g<a_marking.length ;g++)
						{
							str_marking = a_marking[g];
							for (int k =0 ; k < str_marking.length() ; k++)
							{
								//if (str_marking.substring(k,k+1).equals("∫"))
								if (str_marking.substring(k,k+1).equals("∫") || str_marking.substring(k,k+1).equals("<") || str_marking.equals("><"))
								{
									if (str_marking.substring(k,k+1).equals("∫"))
									{
										imageFileName="tsclogo.PNG";
									}
									if (str_marking.trim().equals("><"))
									{
										imageFileName="pmd_arrow2.png";
									}
									if (str_marking.substring(k,k+1).equals("<") && !str_marking.trim().equals("><"))
									{
										imageFileName="pmd_arrow.png";
									}
									xx = (float)(line+(0.03*((float)k))); yy=(float)(((float)(g))*0.9+0.1);
									if (a_marking.length<=2) yy= yy+(float)0.5;	
									//break;
									if (xx>0 && yy>0)
									{
										//imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/tsclogo.PNG";
										imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+imageFileName;
										File f = new File(imageFile);
										if(f.exists()) 
										{
											jxl.write.WritableImage image1 = new jxl.write.WritableImage(Math.floor(col)+xx,row+yy,0.4,1.2, f); 
											ws.addImage(image1);
										}
									}					
								}
							}	
							//if (xx>0 || yy>0) break;
						}
						//date code型式已變化許多,以下remarks會造成混淆,modify by Peggy 20210506
						//add by Peggy 20130307
						//ws.mergeCells(col+line,row+5,col+line+1,row+5);
						//ws.addCell(new jxl.write.Label(col+line, row+5, "*YML is defined by date code", ALeftB));
					}
				}
			}
			row++;//列+1	
			//tot_wafer += Float.parseFloat(rsd.getString("wafer_qty"));
			//tot_chip = ((float)Math.round((tot_chip*10000) + (Float.parseFloat(rsd.getString("chip_qty"))*10000))/10000);	
			tot_wafer += rsd.getDouble("wafer_qty");
			tot_chip += rsd.getDouble("chip_qty");	
			//out.println(""+tot_chip);
			cnt++;	
		}
		rsd.close();
		stated.close();

		if (cnt <10)
		{
			for (int i =1 ; i < (10-cnt) ; i++)
			{
				ws.addCell(new jxl.write.Label(col+2, row, "" , ACenterL));
				ws.addCell(new jxl.write.Label(col+3, row, "" , ACenterL));
				if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))  //add by Peggy 20221208
				{
					ws.addCell(new jxl.write.Label(col+4, row, "" , ACenterL));
				}					
				ws.addCell(new jxl.write.Label(col+4+i_waferno, row, "" , ACenterL));
				ws.addCell(new jxl.write.Label(col+5+i_waferno, row, "" , ACenterL));
				if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))
				{
					if (i_addline==1)
					{
						ws.addCell(new jxl.write.Label(col+5+i_addline+i_waferno, row, "" , ACenterL));
					}
					ws.addCell(new jxl.write.Label(col+6+i_addline+i_waferno, row, "" , ACenterL));
				}				
				
				if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))  //add by Peggy 20180726
				{
					ws.addCell(new jxl.write.Label(col+6+i_waferno, row, "" , ACenterL));
					ws.addCell(new jxl.write.Label(col+7+i_waferno, row, "" , ACenterL));
					ws.mergeCells(col+7+i_waferno, row, col+8+i_waferno, row);  
					ws.addCell(new jxl.write.Label(col+9+i_waferno, row, "" , ACenterL));
					ws.addCell(new jxl.write.Label(col+10+i_waferno, row, "" , ACenterL));
					if (i_addline==1)
					{
						ws.addCell(new jxl.write.Label(col+10+i_addline+i_waferno, row, "" , ACenterL));
					}
				}
				else if (rsh.getString("item_description").equals("TSC497CX RFG")) //add by Peggy 20220427
				{				
					ws.addCell(new jxl.write.Label(col+7+i_addline+i_waferno, row, "" , ACenterL));
				}
				else if (VENDOR_CODE.equals("3864")) //捷敏科 by Peggy 20221208
				{
					ws.addCell(new jxl.write.Label(col+7+i_addline+i_waferno, row, "" , ACenterL));
				}	
								
				if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))
				{
					if (cnt==1)
					{
						v_making="Y";
						ws.mergeCells(col+line+i_addline-1,row,col+line+i_addline-1,row+3);
						if (!ORIG_MARKING.equals(rsh.getString("MARKING")))
						{
							//if (rsh.getString("item_description").equals("TS78L05IX RF")) //add by Peggy 20140213
							if (rsh.getString("item_description").startsWith("TS78L05IX RF")) //add by Peggy 20150522
							{
								imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/L5YML.PNG";
								File f = new File(imageFile);
								if(f.exists()) 
								{
									jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+line+0.1+i_addline-1,row+0.1,0.5,1.5, f); 
									ws.addImage(image1);
								}
							}
							else
							{
								//add by Peggy 20220530
								imageFile="..//resin-2.1.9//webapps/oradds/PMD_Marking/"+rsh.getString("item_description")+".png";
								File f = new File(imageFile);
								if(f.exists()) 
								{
									jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+line+0.1+i_addline-1, row+0.1,1,2.3, f); 
									ws.addImage(image1);
								}
								else
								{								
									ws.addCell(new jxl.write.Label(col+line+i_addline-1, row, rsh.getString("MARKING"), ALeftBRED));
									v_making="N";
								}
							}
						}
						else
						{
							//if (rsh.getString("item_description").equals("TS78L05IX RF")) //add by Peggy 20140213
							if (rsh.getString("item_description").startsWith("TS78L05IX RF")) //add by Peggy 20150522
							{
								imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/L5YML.PNG";
								File f = new File(imageFile);
								if(f.exists()) 
								{
									jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+line+0.1+i_addline-1, row+0.1,0.5,1.5, f); 
									ws.addImage(image1);
								}
							}
							else
							{
								//add by Peggy 20220530
								imageFile="..//resin-2.1.9//webapps/oradds/PMD_Marking/"+rsh.getString("item_description")+".png";
								File f = new File(imageFile);
								if(f.exists()) 
								{
									jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+line+0.1+i_addline-1, row+0.1,1,2.3, f); 
									ws.addImage(image1);
								}
								else
								{								
									ws.addCell(new jxl.write.Label(col+line+i_addline-1, row, rsh.getString("MARKING"), ALeftB));
									v_making="N";
								}
							}
						}
						
						if (v_making.equals("N"))
						{
							String a_marking [] = rsh.getString("MARKING").split("\n");
							String str_marking ="";
							float xx=0,yy=0;
							for (int g=0; g<a_marking.length ;g++)
							{
								str_marking = a_marking[g];
								for (int k =0 ; k < str_marking.length() ; k++)
								{
									//if (str_marking.substring(k,k+1).equals("∫"))
									if (str_marking.substring(k,k+1).equals("∫") || str_marking.substring(k,k+1).equals("<") || str_marking.equals("><"))
									{
										if (str_marking.substring(k,k+1).equals("∫"))
										{
											imageFileName="tsclogo.PNG";
										}
										if (str_marking.trim().equals("><"))
										{
											imageFileName="pmd_arrow2.png";
										}							
										if (str_marking.substring(k,k+1).equals("<") && !str_marking.trim().equals("><"))
										{
											imageFileName="pmd_arrow.png";
										}							
										xx = (float)(line+(0.03*((float)k))); yy=(float)(((float)(g))*0.9+0.1);
										if (a_marking.length<=2) yy= yy+(float)0.5;	
										//break;
										if (xx>0 && yy>0)
										{
											//imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/tsclogo.PNG";
											imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+imageFileName;
											File f = new File(imageFile);
											if(f.exists()) 
											{
												jxl.write.WritableImage image1 = new jxl.write.WritableImage(Math.floor(col)+xx,row+yy,0.4,1.2, f); 
												ws.addImage(image1);
											}
										}	
									}				
								}	
								//if (xx>0 || yy>0) break;
							}
						}
						//date code型式已變化許多,以下remarks會造成混淆,modify by Peggy 20210506
						//add by Peggy 20130307
						//ws.mergeCells(col+line,row+5,col+line+1,row+5);
						//ws.addCell(new jxl.write.Label(col+line, row+5, "*YML is defined by date code", ALeftB));
						cnt=0;
					}
				}
				row++;//列+1	
			}
		}
		ws.addCell(new jxl.write.Label(col+2, row, "Total Qty" , ACenterL));
		ws.addCell(new jxl.write.Label(col+3, row, (new DecimalFormat("##,##0.0###")).format(tot_wafer) , ARightL));
		if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))  //add by Peggy 20221208
		{
			ws.addCell(new jxl.write.Label(col+4, row, "" , ACenterL));
		}		
		ws.addCell(new jxl.write.Label(col+4+i_waferno, row, (new DecimalFormat("##,##0.0###")).format(tot_chip) , ARightL));
		ws.addCell(new jxl.write.Label(col+5+i_waferno, row, "" , ACenterL));
		if (!VENDOR_CODE.equals("4056") && !VENDOR_CODE.equals("4746"))
		{
			if (i_addline==1)
			{
				ws.addCell(new jxl.write.Label(col+5+i_addline+i_waferno, row, "" , ACenterL));
			}
			ws.addCell(new jxl.write.Label(col+6+i_addline+i_waferno, row, "" , ACenterL));
		}
		if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))
		{	
			ws.addCell(new jxl.write.Label(col+6+i_waferno, row, "" , ACenterL));	
			ws.addCell(new jxl.write.Label(col+7+i_waferno, row, "" , ACenterL));
			ws.mergeCells(col+7+i_waferno, row, col+8+i_waferno, row);  
			ws.addCell(new jxl.write.Label(col+9+i_waferno, row, "" , ACenterL));
			ws.addCell(new jxl.write.Label(col+10+i_waferno, row, "" , ACenterL));
			if (i_addline==1)
			{
				ws.addCell(new jxl.write.Label(col+10+i_addline+i_waferno, row, "" , ACenterL));
			}
		}		
		else if (rsh.getString("item_description").equals("TSC497CX RFG")) //add by Peggy 20220427
		{		
			ws.addCell(new jxl.write.Label(col+7+i_addline+i_waferno, row, "" , ACenterL));
		}
		else if (VENDOR_CODE.equals("3864")) //捷敏科 by Peggy 20221208
		{
			ws.addCell(new jxl.write.Label(col+7+i_addline+i_waferno, row, "" , ACenterL));
		}		
		row++;//列+1	
		
		row+=2;
		ws.mergeCells(col+3, row, col+4, row);    
    	ws.addCell(new jxl.write.Label(col+3, row, "廠商Vendor" , CACenterBL));
		ws.setRowView(row,450);	
		if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))
		{	
			ws.mergeCells(col+line, row, col+line+1, row);     
			ws.addCell(new jxl.write.Label(col+line, row, "Taiwan Semiconductor Company" , ACenterBL));
		}
		else
		{				
			ws.mergeCells(col+line-1, row, col+line, row);     
			ws.addCell(new jxl.write.Label(col+line-1, row, "Taiwan Semiconductor Company" , ACenterBL));
		}
		
		//--20191009 by Peggy,被mark的程式又開啟了..應nono將要求
		if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))
		{			
			//if (cnt==0)
			//{
				ws.mergeCells(col+6,row,col+7,row);
				ws.addCell(new jxl.write.Label(col+6, row, "Marking" , ALeftBB));
				row++;//列+1	
			//}
			//else if (cnt==1)
			//{
				v_making="Y";			
				ws.mergeCells(col+6,row,col+7,row+3);
				if (!ORIG_MARKING.equals(rsh.getString("MARKING")))
				{
					//if (rsh.getString("item_description").equals("TS78L05IX RF")) //add by Peggy 20140213
					if (rsh.getString("item_description").startsWith("TS78L05IX RF")) //add by Peggy 20150522
					{
						imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/L5YML.PNG";
						File f = new File(imageFile);
						if(f.exists()) 
						{
							jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+6+0.1, row+0.1,0.5,1.5, f); 
							ws.addImage(image1);
						}
					}
					else
					{
						//add by Peggy 20220530
						imageFile="..//resin-2.1.9//webapps/oradds/PMD_Marking/"+rsh.getString("item_description")+".png";
						File f = new File(imageFile);
						if(f.exists()) 
						{
							jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+6, row+0.1,1,2.3, f); 
							ws.addImage(image1);
						}
						else
						{					
							ws.addCell(new jxl.write.Label(col+6, row, rsh.getString("MARKING"), ALeftBRED));
							v_making="N";
						}
					}
				}
				else
				{
					//if (rsh.getString("item_description").equals("TS78L05IX RF")) //add by Peggy 20140213
					if (rsh.getString("item_description").startsWith("TS78L05IX RF")) //add by Peggy 20150522
					{
						imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/L5YML.PNG";
						File f = new File(imageFile);
						if(f.exists()) 
						{
							jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+6+0.1, row+0.1,0.5,1.5, f); 
							ws.addImage(image1);
						}
					}
					else
					{
						//add by Peggy 20220530
						imageFile="..//resin-2.1.9//webapps/oradds/PMD_Marking/"+rsh.getString("item_description")+".png";
						File f = new File(imageFile);
						if(f.exists()) 
						{
							jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+6, row+0.1,1,2.3, f); 
							ws.addImage(image1);
						}
						else
						{						
							ws.addCell(new jxl.write.Label(col+6, row, rsh.getString("MARKING"), ALeftB));
							v_making="N";
						}
					} 
				}
				if (v_making.equals("N"))
				{				
					String a_marking [] = rsh.getString("MARKING").split("\n");
					String str_marking ="";
					float xx=0,yy=0;
					for (int g=0; g<a_marking.length ;g++)
					{
						str_marking = a_marking[g];
						for (int k =0 ; k < str_marking.length() ; k++)
						{
							//if (str_marking.substring(k,k+1).equals("∫"))
							if (str_marking.substring(k,k+1).equals("∫") || str_marking.substring(k,k+1).equals("<") || str_marking.equals("><"))
							{
								if (str_marking.substring(k,k+1).equals("∫"))
								{
									imageFileName="tsclogo.PNG";
								}
								if (str_marking.trim().equals("><"))
								{
									imageFileName="pmd_arrow2.png";
								}
								if (str_marking.substring(k,k+1).equals("<") && !str_marking.trim().equals("><"))
								{
									imageFileName="pmd_arrow.png";
								}
								xx = (float)(6+(0.03*((float)k))); yy=(float)(((float)(g))*0.9+0.1);
								if (a_marking.length<=2) yy= yy+(float)0.5;	
								//break;
								if (xx>0 && yy>0)
								{
									//imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/tsclogo.PNG";
									imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+imageFileName;
									File f = new File(imageFile);
									if(f.exists()) 
									{
										jxl.write.WritableImage image1 = new jxl.write.WritableImage(Math.floor(col)+xx,row+yy,0.4,1.2, f); 
										ws.addImage(image1);
									}
								}					
							}
						}	
						//if (xx>0 || yy>0) break;
					}
					//date code型式已變化許多,以下remarks會造成混淆,modify by Peggy 20210506
					//add by Peggy 20130307
					//ws.mergeCells(col+6,row+4,col+7+1,row+4);
					//ws.addCell(new jxl.write.Label(col+6, row+4, "*YML is defined by date code", ALeftB));
				}
			//}
			
		}	
		else
		{
			row++;//列+1	
		}		
		ws.mergeCells(col+3, row, col+4, row);     
    	ws.addCell(new jxl.write.Label(col+3,  row, "簽回(SIGNATURE)" , CACenterBL));
		if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))
		{
			ws.addCell(new jxl.write.Label(col+line,  row, "Approval"  , ACenterBL));
			ws.addCell(new jxl.write.Label(col+line+1, row, "Applicant" , ACenterBL));
		}
		else
		{		
			ws.addCell(new jxl.write.Label(col+line-1,  row, "Approval"  , ACenterBL));
			ws.addCell(new jxl.write.Label(col+line, row, "Applicant" , ACenterBL));
		}
		row++;//列+1	
		ws.mergeCells(col+3, row, col+4, row+3); 
		imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+rsh.getString("APPROVED_BY_NAME")+".PNG";
		File f = new File(imageFile);
		if(f.exists()) 
		{
			if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))
			{
				jxl.write.WritableImage image1 = new jxl.write.WritableImage(Math.floor(col)+line+0.05,row+0.5,0.9,3, f); 
				ws.addImage(image1);
			}
			else
			{
				jxl.write.WritableImage image1 = new jxl.write.WritableImage(Math.floor(col)+line+0.05-1,row+0.5,0.9,3, f); 
				ws.addImage(image1);
			}
		}
		imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+rsh.getString("created_by_name")+".png";
		f = new File(imageFile);
		if(f.exists()) 
		{
			if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))
			{		
				jxl.write.WritableImage image2 = new jxl.write.WritableImage(Math.floor(col)+line+1.05,row+0.5,0.9,3, f); 
				ws.addImage(image2); 
			}
			else
			{
				jxl.write.WritableImage image2 = new jxl.write.WritableImage(Math.floor(col)+line+1.05-1,row+0.5,0.9,3, f); 
				ws.addImage(image2); 
			}
		}
    	ws.addCell(new jxl.write.Label(col+3,  row, "" ,ACenterL));
		if (VENDOR_CODE.equals("4056") || VENDOR_CODE.equals("4746"))
		{	
			ws.mergeCells(col+line, row, col+line, row+3);     
			ws.addCell(new jxl.write.Label(col+line,  row, ""  , ACenterL));
			ws.mergeCells(col+line+1, row, col+line+1, row+3);     
			ws.addCell(new jxl.write.Label(col+line+1, row, "" , ACenterL));
			
		}
		else
		{
			ws.mergeCells(col+line-1, row, col+line-1, row+3);     
			ws.addCell(new jxl.write.Label(col+line-1,  row, ""  , ACenterL));
			ws.mergeCells(col+line, row, col+line, row+3);     
			ws.addCell(new jxl.write.Label(col+line, row, "" , ACenterL));
		}
		
		row++;//列+1	

		wwb.write(); 
		wwb.close();
		os.close();  
		out.close(); 
	}
	rsh.close();
	stateh.close();
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
response.reset();
response.setContentType("application/vnd.ms-excel");	
String strURL = "/oradds/report/"+FileName+".xls"; 
response.sendRedirect(strURL);
%>

</html>
