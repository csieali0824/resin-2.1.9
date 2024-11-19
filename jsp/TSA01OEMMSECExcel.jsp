<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Export excel file</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSA01OEMMSECExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String REQUESTNO = request.getParameter("REQUESTNO");
String ITEM_DESC="",WIPNO = "",FileName="",VENDOR="",VENDOR_CODE="",ORIG_WAFER_NUMBER=""; 
String ASSEMBLY="",TAPING_REEL="",TESTING="",LAPPING="",OTHERS="",imageFile="",VERSION_ID="",APPROVED_DATE="",CHANGE_DATE="",ORIG_REQUESTNO="",sql="",imageFileName="";
String WIP_TYPE_NO="",DIE_ITEM_NAME="",REMARKS="",PONO="",NEW_ITEM_DESC="",ORIG_NEW_ITEM_DESC="";
String TSC_PROD_GROUP="";
int cnt=0,fontsize=9,i_merge_row=0;
String str_marking_two="",str_marking_three="",v_wafer_size="",v_marking_no="",v_marking_flag="N",v_pcetok_flag="";

try 
{ 	
	sql  = " select a.request_no||'-'||a.version_id request_no, a.WIP_TYPE_NO wip_name, a.vendor_name,a.vendor_contact,"+
           " to_char(TO_DATE(a.request_date,'yyyymmdd'),'yyyy-mm-dd') request_date, a.inventory_item_name, a.item_description,"+
           " a.die_name ,die_desc,(select sum(wafer_qty-nvl(scrap_qty,0)) from  oraddman.tsa01_oem_lines_all x where  x.request_no||'-'||x.version_id= a.request_no||'-'||a.version_id) quantity, a.unit_price,a.packing,a.package_spec,a.TEST_SPEC,a.tsc_package,a.wip_no, a.pr_no,"+ 
           " a.status, to_char(a.creation_date,'yyyy-mm-dd') creation_date,"+
           " a.assembly,a.taping_reel,a.testing,a.lapping,a.others,a.unit_price_uom,a.version_id,a.request_no||'-'||a.orig_version_id ORIG_REQUESTNO,"+
           " a.created_by, to_char(a.approve_date,'yyyymmdd') approve_date, a.approved_by,a.remarks,a.MARKING,a.CURRENCY_CODE,"+
           " (select count(1) from oraddman.tspmd_oem_lines_all c where c.request_no=a.request_no) total_cnt"+
           ",a.WIP_TYPE_NO,c.segment1 die_item_name  "+
           ",a.TSC_PROD_GROUP"+
           ",a.VENDOR_CODE,a.REMARKS,a.po_no,a.new_item_desc,a.new_item_name"+
           " FROM oraddman.tsa01_oem_headers_all a"+
           " ,(select * from inv.mtl_system_items_b where organization_id=?) c"+
           " where a.DIE_ITEM_ID=c.inventory_item_id(+)"+
           " and a.request_no||'-'||a.version_id=?"+
           " and a.status<>?";
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"606");
	statement.setString(2,REQUESTNO);
	statement.setString(3,"Inactive");
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{	
		VENDOR=rs.getString("vendor_name");
		ITEM_DESC=rs.getString("item_description"); 
		WIPNO=rs.getString("wip_no");
		FileName=ITEM_DESC +" "+WIPNO;
		VERSION_ID=rs.getString("version_id");         
		APPROVED_DATE = rs.getString("approve_date");    
		ORIG_REQUESTNO = rs.getString("ORIG_REQUESTNO");
		ASSEMBLY = rs.getString("ASSEMBLY");
		TAPING_REEL = rs.getString("TAPING_REEL");
		TESTING=rs.getString("TESTING");
		LAPPING=rs.getString("LAPPING");
		OTHERS=rs.getString("OTHERS");
		WIP_TYPE_NO=rs.getString("WIP_TYPE_NO");    
		DIE_ITEM_NAME=rs.getString("die_item_name");
		TSC_PROD_GROUP=rs.getString("TSC_PROD_GROUP"); 
		VENDOR_CODE=rs.getString("VENDOR_CODE");   
		REMARKS=rs.getString("REMARKS");
		PONO=rs.getString("PO_NO");
		NEW_ITEM_DESC=rs.getString("NEW_ITEM_DESC");
		if (NEW_ITEM_DESC==null) NEW_ITEM_DESC="N/A";
		
		//add by Peggy 20240613
		sql = " SELECT DISTINCT ? FROM oraddman.tsa01_oem_data_type a"+				
              " WHERE DATA_TYPE=? AND DATA_CODE=? AND STATUS_FLAG=?"+
              " AND DATA_NAME =?";
		PreparedStatement statement6=con.prepareStatement(sql);
		statement6.setString(1,"Y");
		statement6.setString(2,"PCETOKPCS");
		statement6.setString(3,"CP");
		statement6.setString(4,"A");	
		statement6.setString(5,rs.getString("inventory_item_name"));				
		ResultSet rs6=statement6.executeQuery();
		if (rs6.next())
		{
			v_pcetok_flag = rs6.getString(1);
		}	
		else
		{
			v_pcetok_flag = "N";
		}
		rs6.close();  
		statement6.close();	
						
		//out.println("FileName="+FileName);
		int row =0,col=0,line=0;
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
		sst.setScaleFactor(80);   // 打印縮放比例
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
        jxl.write.WritableImage image = new jxl.write.WritableImage(col,row,col+2.8+1,row+2, new File("..//resin-2.1.9//webapps/oradds/jsp/images/logo.png")); 
		ws.addImage(image); 

		//if (WIP_TYPE_NO.equals("BGBM")) col++;
		col++;
		i_merge_row=8;
		//if (WIP_TYPE_NO.equals("BGBM"))
		//{
		//	i_merge_row=9;
		//}
		//else
		//{
		//	i_merge_row=8;
		//}
		String strCTitle = "台 灣 半 導 體 股 份 有 限 公 司";
		ws.setColumnView(col,14);	
		ws.setColumnView(col+1,17);	
		ws.setColumnView(col+2,13);	
		ws.setColumnView(col+3,12);	
		ws.setColumnView(col+4,12);	
		ws.mergeCells(col+2, row, col+i_merge_row, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strCTitle , wCompCName));
		//ws.setColumnView(col,60);	
		ws.setColumnView(col+i_merge_row,15);	
		ws.setColumnView(col+i_merge_row+1,15);	
		row++;//列+1
		
		String strETitle = "Taiwan Semiconductor Company limited";
		ws.mergeCells(col+2, row, col+i_merge_row, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strETitle , wCompEName));
		row++;//列+1
		    	
		String strCAddr = "新北市新店區北新路三段205號11樓";
		ws.mergeCells(col+2, row, col+i_merge_row, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strCAddr , wAddrCName));
		row++;//列+1		
				
		String strEAddr = "11Fl.,No,205,Sec.3,Beishin Rd., Xindian Dist., New Taipei City 231, Taiwan";
		ws.mergeCells(col+2, row, col+i_merge_row, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strEAddr , wAddrEName));
		row++;//列+1	
		
		String strTelInfo = "Tel: 886-2-8913-1588, Fax: 886-2-8913-1788";
		ws.mergeCells(col+2, row, col+i_merge_row, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strTelInfo , wTelName));
		row++;//列+1	
					
		String strName = "委 外 託 工 單";
		ws.mergeCells(col+2, row, col+i_merge_row, row);     
    	ws.addCell(new jxl.write.Label(col+2, row,strName , wRptName));
		row++;//列+1

		col=0;line=9;
	
		row+=2;
		ws.setColumnView(col,2);	
		ws.mergeCells(col+1, row, col+1, row); 
    	ws.addCell(new jxl.write.Label(col+1, row ,"To：" , ARight));
		ws.mergeCells(col+2, row, col+3,row);
    	ws.addCell(new jxl.write.Label(col+2, row ,VENDOR ,ALeftUL));
		ws.addCell(new jxl.write.Label(col+line, row ,"Issue Date：" , ARight));
    	ws.addCell(new jxl.write.Label(col+line+1, row ,rs.getString("REQUEST_DATE") , ALeftUL));
		row++;//列+1
				
		ws.mergeCells(col+1, row, col+1, row); 
    	ws.addCell(new jxl.write.Label(col+1, row ,"Attn：" , ARight));
		ws.mergeCells(col+2, row, col+3,row);
    	ws.addCell(new jxl.write.Label(col+2, row ,rs.getString("vendor_contact") , ALeftUL));
    	ws.addCell(new jxl.write.Label(col+line, row ,"Order No：" , ARight));
    	ws.addCell(new jxl.write.Label(col+line+1, row ,WIPNO, ALeftUL));
		row++;//列+1	

		ws.mergeCells(col+1, row, col+1, row); 
    	ws.addCell(new jxl.write.Label(col+1, row ,"Foundry：" , ARight));
		ws.mergeCells(col+2, row, col+3,row);
		if (rs.getString("inventory_item_name").equals("MQ-WSGT45CLH8ANN"))
		{
			ws.addCell(new jxl.write.Label(col+2, row ,"UMC", ALeftUL));
		}
		//else if (rs.getString("inventory_item_name").equals("MQ-W033NB0408DVN"))
		//{
    	//	ws.addCell(new jxl.write.Label(col+2, row ,"PSMC", ALeftUL));
		//}
		//else if (rs.getString("inventory_item_name").equals("MQ-W050NB0608DVN"))
		//{
    	//	ws.addCell(new jxl.write.Label(col+2, row ,"PSMC", ALeftUL));
		//}	
		else if (v_pcetok_flag.equals("Y"))
		{
			ws.addCell(new jxl.write.Label(col+2, row ,"PSMC", ALeftUL));
		}	
		else
		{
			ws.addCell(new jxl.write.Label(col+2, row ,"" , ALeftUL));		
		}
		ws.addCell(new jxl.write.Label(col+line, row ,"採購單號：" , ARight));
		ws.addCell(new jxl.write.Label(col+line+1, row ,PONO, ALeftUL));
		row++;//列+1
		
		ws.mergeCells(col+1, row, col+1, row); 
    	ws.addCell(new jxl.write.Label(col+1, row ,"eMap：" , ARight));
		ws.mergeCells(col+2, row, col+3,row);
		if (rs.getString("inventory_item_name").equals("MQ-WSGT45CLH8ANN"))
		{
			ws.addCell(new jxl.write.Label(col+2, row ,"Yes", ALeftUL));
		}
		//else if (rs.getString("inventory_item_name").equals("MQ-W033NB0408DVN"))
		//{		
    	//	ws.addCell(new jxl.write.Label(col+2, row ,"NO", ALeftUL));
		//}
		//else if (rs.getString("inventory_item_name").equals("MQ-W050NB0608DVN"))
		//{		
    	//	ws.addCell(new jxl.write.Label(col+2, row ,"NO", ALeftUL));
		//}		
		else if (v_pcetok_flag.equals("Y"))
		{
			ws.addCell(new jxl.write.Label(col+2, row ,"NO", ALeftUL));
		}		
		else
		{
			ws.addCell(new jxl.write.Label(col+2, row ,"", ALeftUL));
		}
		ws.addCell(new jxl.write.Label(col+line, row ,"工單型式：" , ARight));
		ws.addCell(new jxl.write.Label(col+line+1, row ,"量產", ALeftUL));
		row++;//列+1			

		//add by Peggy 20221226
		ws.mergeCells(col+1, row, col+1, row); 
    	ws.addCell(new jxl.write.Label(col+1, row ,"II Date Upload：" , ARight));
		ws.mergeCells(col+2, row, col+3,row);
		if (rs.getString("inventory_item_name").equals("MQ-WSGT45CLH8ANN"))
		{
			ws.addCell(new jxl.write.Label(col+2, row ,"PPT" , ALeftUL));
		}
		else
		{		
    		ws.addCell(new jxl.write.Label(col+2, row ,"" , ALeftUL));
		}
		
		if (!VERSION_ID.equals("0"))
		{
			CHANGE_DATE = APPROVED_DATE+" Update";
			ws.mergeCells(col+line, row, col+line+1, row); 
			ws.addCell(new jxl.write.Label(col+line, row ,CHANGE_DATE, ACenterRED));
		}
		row+=1;
		
		ws.mergeCells(col+1, row, col+2, row);
		ws.addCell(new jxl.write.Label(col+1, row ,((TESTING.equals("Y"))?"[V] ":"[ ] ")+"測試 Testing  全測" , ALeft9));
		ws.mergeCells(col+3, row, col+3, row);
		ws.addCell(new jxl.write.Label(col+3, row ,((LAPPING.equals("Y"))?"[V] ":"[ ] ")+"減薄 Lapping" , ALeft9));
		ws.mergeCells(col+4, row, col+5, row);
		ws.addCell(new jxl.write.Label(col+4, row ,((OTHERS==null)?"[ ] ":"[V] ")+"其他 Others "+(OTHERS==null?"":OTHERS) , ALeft9));
		row++;//列+1	
									
		line=1;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Item" , ACenterBL));
		//ws.setColumnView(col+line,5);	
		line++;
		ws.addCell(new jxl.write.Label(col+line, row ,"品號" ,CACenterBL));
		line++;
		if (WIP_TYPE_NO.equals("CP"))
		{
			ws.addCell(new jxl.write.Label(col+line, row ,"新品號" ,CACenterBL));
			line++;		
		}		
    	ws.addCell(new jxl.write.Label(col+line, row ,"封裝型式" , CACenterBL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"芯片名稱" , CACenterBL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"數量 Q'ty" , CACenterBL));
		//ws.setColumnView(col+line,10);	
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"單價 u/p" , CACenterBL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"包裝" , CACenterBL));
		line++;
    	//ws.addCell(new jxl.write.Label(col+line, row ,"封裝規格" , CACenterBL));
		//line++;
		ws.mergeCells(col+line, row, col+line+1, row);
    	ws.addCell(new jxl.write.Label(col+line, row ,"測試規格" , CACenterBL));
		line++;

		row++;//列+1
		line=1;
    	ws.addCell(new jxl.write.Label(col+line, row ,"No." , ACenterBL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Device Name" , ACenterBL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"P/N" ,ACenterBL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Package" ,ACenterBL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Die Name" , ACenterBL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row , (rs.getString("unit_price_uom").equals("片"))?"片數":"(Kpcs)" , ACenterBL));
		line++;
		ws.addCell(new jxl.write.Label(col+line, row ,rs.getString("currency_code").replace("TWD","NTD")+"/"+rs.getString("unit_price_uom"), ACenterBL));  
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"Packing" , ACenterBL));
		line++;
    	//ws.addCell(new jxl.write.Label(col+line, row ,"D/B No." , ACenterBL));
		//line++;
		ws.mergeCells(col+line, row, col+line+1, row);
    	ws.addCell(new jxl.write.Label(col+line, row ,"Test Spec" , ACenterBL));
		line++;
		row++;//列+1
		
		String ORIG_QTY=rs.getString("QUANTITY"),ORIG_UNIT_PRICE=rs.getString("UNIT_PRICE"),ORIG_PACKAGE_SPEC=rs.getString("PACKAGE_SPEC"),ORIG_TEST_SPEC=rs.getString("TEST_SPEC"),ORIG_REMARKS=rs.getString("REMARKS"),ORIG_MARKING=rs.getString("MARKING");
		sql = " select (select sum(wafer_qty-nvl(scrap_qty,0)) from  oraddman.tsa01_oem_lines_all x where  x.request_no||'-'||x.version_id= a.request_no||'-'||a.version_id) quantity,a.unit_price,a.PACKAGE_SPEC,a.TEST_SPEC,a.TSC_PACKAGE,a.REMARKS,a.MARKING,a.NEW_ITEM_DESC"+
              " from oraddman.tsa01_oem_headers_all a"+
              " where  a.request_no||'-'||a.version_id=?";	
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,ORIG_REQUESTNO);
		ResultSet rs1=statement1.executeQuery();
		while (rs1.next())
		{			  		
			ORIG_QTY = rs1.getString("quantity");
			ORIG_UNIT_PRICE = rs1.getString("unit_price");
			ORIG_PACKAGE_SPEC = rs1.getString("PACKAGE_SPEC");
			ORIG_TEST_SPEC = rs1.getString("TEST_SPEC");
			ORIG_REMARKS = rs1.getString("REMARKS");
			if (ORIG_REMARKS==null) ORIG_REMARKS="";
			ORIG_MARKING = rs1.getString("MARKING");
			ORIG_NEW_ITEM_DESC=rs1.getString("NEW_ITEM_DESC");
			
		}
		rs1.close();
		statement1.close();
		 		
		line=1;	
    	ws.addCell(new jxl.write.Label(col+line, row ,"1" , ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row , rs.getString("item_description") , ACenterL));
		line++;
		ws.addCell(new jxl.write.Label(col+line, row , NEW_ITEM_DESC , ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,rs.getString("TSC_PACKAGE") ,ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,rs.getString("DIE_DESC") , ACenterL));
		line++;
		if (rs.getString("QUANTITY") != null && !ORIG_QTY.equals(rs.getString("QUANTITY")))
		{
			ws.addCell(new jxl.write.Number(col+line,row, Double.valueOf(rs.getString("QUANTITY")).doubleValue() ,ACenterLRED));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col+line,row, Double.valueOf(rs.getString("QUANTITY")).doubleValue() ,ACenterL));
		}
		line++;
   		ws.addCell(new jxl.write.Label(col+line, row , "*****" , ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,rs.getString("PACKING") , ACenterL));
		//line++;
		//if (rs.getString("PACKAGE_SPEC") != null && !ORIG_PACKAGE_SPEC.equals(rs.getString("PACKAGE_SPEC")))
		//{
    	//	ws.addCell(new jxl.write.Label(col+line, row ,rs.getString("PACKAGE_SPEC") , ACenterLRED));
		//}
		//else
		//{
    	//	ws.addCell(new jxl.write.Label(col+line, row ,rs.getString("PACKAGE_SPEC") , ACenterL));
		//}
		//line++;
		String str_test_spec [] = rs.getString("TEST_SPEC").split("\n");
		String str_test_spec1="",str_test_spec2="";
		for (int g=0; g<str_test_spec.length ;g++)
		{
			if (g==0)
			{
				str_test_spec1 = str_test_spec[g];		
			}
			else if (g==1)
			{
				str_test_spec2 = str_test_spec[g];		
			}
		}
		
		if (rs.getString("TEST_SPEC") != null && !ORIG_TEST_SPEC.equals(rs.getString("TEST_SPEC")))
		{
			line++;
    		ws.addCell(new jxl.write.Label(col+line, row ,(str_test_spec1.equals("")?"N/A":str_test_spec1), ACenterLRED));
			line++;
    		ws.addCell(new jxl.write.Label(col+line, row ,(str_test_spec2.equals("")?"N/A":str_test_spec2), ACenterLRED));
		}
		else
		{
			line++;
    		ws.addCell(new jxl.write.Label(col+line, row ,(str_test_spec1.equals("")?"N/A":str_test_spec1) , ACenterL));
			line++;
    		ws.addCell(new jxl.write.Label(col+line, row ,(str_test_spec2.equals("")?"N/A":str_test_spec2), ACenterL));
		}
		row++;//列+1	
		
		line=1;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row , "", ACenterL));
		line++;
		ws.addCell(new jxl.write.Label(col+line, row , "", ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"-- END --" ,ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		line++;
    	ws.addCell(new jxl.write.Label(col+line, row ,"" , ACenterL));
		row++;//列+1						
			
		row++;
		ws.mergeCells(col+1, row, col+2, row);     
    	ws.addCell(new jxl.write.Label(col+1, row,"備註(Remarks):" , CALeft));
		ws.mergeCells(col+3, row, col+4, row); 
		ws.addCell(new jxl.write.Label(col+3, row, "" , ALeftTRED));
		row++;//列+1																		

		ws.mergeCells(col+1, row, col+10, row+7); 
		if (ORIG_REMARKS!=null && !ORIG_REMARKS.equals(rs.getString("remarks")))
		{
    		ws.addCell(new jxl.write.Label(col+1,row, rs.getString("remarks") , ALeftTRED));
		}
		else
		{
    		ws.addCell(new jxl.write.Label(col+1,row,rs.getString("remarks") , ALeftT));
		}
		
		row+=9;//列+1																		
		
    	ws.addCell(new jxl.write.Label(col+1, row,rs.getString("inventory_item_name").length()+"碼" , ALeft));
		ws.mergeCells(col+2, row, col+2, row);     
    	ws.addCell(new jxl.write.Label(col+2, row, rs.getString("inventory_item_name") , new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 9, WritableFont.NO_BOLD,false))));
		ws.mergeCells(col+3, row, col+3, row);     
    	ws.addCell(new jxl.write.Label(col+3, row, (rs.getString("new_item_name")==null?"":rs.getString("new_item_name")) , new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 9, WritableFont.NO_BOLD,false))));
		row++;//列+1	
				
		ws.mergeCells(col+1, row, col+5, row);     
    	ws.addCell(new jxl.write.Label(col+1, row, "Production Control:" , new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 10, WritableFont.NO_BOLD,false))));
		row++;//列+1	
		
		sql = " SELECT a.line_no,a.lot_number, a.wafer_qty, 0 chip_qty,a.date_code, to_char(to_date(a.completion_date,'yyyymmdd'),'yyyy-mm-dd') completion_date,wafer_number"+
		      " FROM oraddman.tsa01_oem_lines_all a"+
			  " where a.request_no||'-'||a.version_id=? "+
			  " order by a.line_no";		
		statement1 = con.prepareStatement(sql);
		statement1.setString(1,rs.getString("REQUEST_NO"));
		rs1=statement1.executeQuery();
		cnt=0; 
		double tot_wafer =0,tot_chip=0;							  
		while (rs1.next())
		{					  		   
			if (cnt==0)
			{
				ws.addCell(new jxl.write.Label(col+2, row, "Wafer Lot #" , ACenterL));
				ws.addCell(new jxl.write.Label(col+3, row, "Wafer Qty" , ACenterL));
				ws.addCell(new jxl.write.Label(col+4, row, "Wafer No." , ACenterL));
				ws.addCell(new jxl.write.Label(col+5, row, "Request S/D" , ACenterL));
				row++;//列+1	
			}

			String ORIG_LOT=rs1.getString("lot_number"),ORIG_WAFER_QTY=rs1.getString("wafer_qty"),ORIG_CHIP_QTY=rs1.getString("chip_qty"),ORIG_DATE_CODE=rs1.getString("date_code"),ORIG_COMPLETION_DATE=rs1.getString("completion_date");
			sql = " select a.lot_number, a.wafer_qty, 0 chip_qty,a.date_code, to_char(to_date(a.completion_date,'yyyymmdd'),'yyyy-mm-dd') completion_date ,a.wafer_number"+  
		       	  " FROM oraddman.tsa01_oem_lines_all a"+
			      " where a.request_no||'-'||a.version_id= ? "+
				  " and a.line_no = ?";	 
			PreparedStatement statement2 = con.prepareStatement(sql);
			statement2.setString(1,ORIG_REQUESTNO);
			statement2.setString(2,rs1.getString("LINE_NO"));
			ResultSet rs2=statement2.executeQuery();
			while (rs2.next())
			{	
				ORIG_LOT=rs2.getString("lot_number");
				ORIG_WAFER_QTY=rs2.getString("wafer_qty");
				ORIG_CHIP_QTY=rs2.getString("chip_qty");
				ORIG_DATE_CODE=rs2.getString("date_code");
				ORIG_COMPLETION_DATE=rs2.getString("completion_date");
				ORIG_WAFER_NUMBER=rs2.getString("wafer_number"); 
			}
			rs2.close();
			statement2.close();
			
			if (rs1.getString("lot_number") != null && !ORIG_LOT.equals(rs1.getString("lot_number")))
			{
				ws.addCell(new jxl.write.Label(col+2, row, rs1.getString("lot_number") , ACenterLRED));
			}
			else
			{
				ws.addCell(new jxl.write.Label(col+2, row, rs1.getString("lot_number") , ACenterL));
			}
			
			if (rs1.getString("wafer_qty") != null && !ORIG_WAFER_QTY.equals(rs1.getString("wafer_qty")))
			{
				ws.addCell(new jxl.write.Number(col+3, row, Double.valueOf(rs1.getString("wafer_qty")).doubleValue() , ARightLRED));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col+3, row, Double.valueOf(rs1.getString("wafer_qty")).doubleValue() , ARightL));
			}
			
			if (rs1.getString("wafer_number") != null && !ORIG_WAFER_NUMBER.equals(rs1.getString("wafer_number")))
			{
				ws.addCell(new jxl.write.Label(col+4, row, rs1.getString("wafer_number") , ACenterLRED));
			}
			else
			{
				ws.addCell(new jxl.write.Label(col+4, row, rs1.getString("wafer_number") , ACenterL));
			}
						
			if (rs1.getString("completion_date") != null && !ORIG_COMPLETION_DATE.equals(rs1.getString("completion_date")))
			{
				ws.addCell(new jxl.write.Label(col+5, row, rs1.getString("completion_date") , ACenterLRED));
			}
			else
			{
				ws.addCell(new jxl.write.Label(col+5, row, rs1.getString("completion_date") , ACenterL));
			}
			line=9;

			row++;//列+1	
			tot_wafer += rs1.getDouble("wafer_qty");
			tot_chip += rs1.getDouble("chip_qty");	
			cnt++;	
		}
		rs1.close();
		statement1.close();

		if (cnt <10)
		{
			for (int i =1 ; i < (10-cnt) ; i++)
			{
				ws.addCell(new jxl.write.Label(col+2, row, "" , ACenterL));
				ws.addCell(new jxl.write.Label(col+3, row, "" , ACenterL));
				ws.addCell(new jxl.write.Label(col+4, row, "" , ACenterL));
				ws.addCell(new jxl.write.Label(col+5, row, "" , ACenterL));
				row++;//列+1	
			}
		}
		ws.addCell(new jxl.write.Label(col+2, row, "Total Qty" , ACenterL));
		ws.addCell(new jxl.write.Label(col+3, row, (new DecimalFormat("##,##0.0###")).format(tot_wafer) , ARightL));
		ws.addCell(new jxl.write.Label(col+4, row, "" , ACenterL));
		ws.addCell(new jxl.write.Label(col+5, row, "" , ACenterL));
		row++;//列+1	
		
		row+=2;
		ws.mergeCells(col+3, row, col+4, row);     
    	ws.addCell(new jxl.write.Label(col+3, row, "廠商Vendor" , CACenterBL));
		ws.mergeCells(col+line, row, col+line+1, row);     
    	ws.addCell(new jxl.write.Label(col+line, row, "Taiwan Semiconductor Company" , ACenterBL));
		row++;//列+1	
		
		ws.mergeCells(col+3, row, col+4, row);     
    	ws.addCell(new jxl.write.Label(col+3,  row, "簽回(SIGNATURE)" , CACenterBL));
    	ws.addCell(new jxl.write.Label(col+line,  row, "Approval"  , ACenterBL));
    	ws.addCell(new jxl.write.Label(col+line+1, row, "Applicant" , ACenterBL));
		row++;//列+1	
		ws.mergeCells(col+3, row, col+4, row+3); 
		imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+rs.getString("APPROVED_BY")+".PNG";
		File f = new File(imageFile);
		if(f.exists()) 
		{
			jxl.write.WritableImage image1 = new jxl.write.WritableImage(Math.floor(col)+line+0.05,row+0.5,0.9,3, f); 
			ws.addImage(image1);
		}
		imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+rs.getString("created_by")+".png";
		f = new File(imageFile);
		if(f.exists()) 
		{
			jxl.write.WritableImage image2 = new jxl.write.WritableImage(Math.floor(col)+line+1.05,row+0.5,0.9,3, f); 
			ws.addImage(image2); 
		}
    	ws.addCell(new jxl.write.Label(col+3,  row, "" ,ACenterL));
		ws.mergeCells(col+line, row, col+line, row+3);     
    	ws.addCell(new jxl.write.Label(col+line,  row, ""  , ACenterL));
		ws.mergeCells(col+line+1, row, col+line+1, row+3);     
    	ws.addCell(new jxl.write.Label(col+line+1, row, "" , ACenterL));
		
		row++;//列+1	

		wwb.write(); 
		wwb.close();
		os.close();  
		out.close(); 
	}
	rs.close();
	statement.close();
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
