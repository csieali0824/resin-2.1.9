<%@ page contentType="text/html; charset=utf-8" language="java" import="java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSC ITEM Taric Code Info</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCItemTaricCodeReport.jsp" METHOD="post" name="MYFORM">
<%
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",sql2="",sql3="",where="";
int fontsize=8,colcnt=0;
int row =0,col=0,reccnt=0;
String strAECQ="",strDesc="",strCartonSize="",strGW="",strwebstatus="",strgroup="",obsoletedate="",strPath="";
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	OutputStream os = null;	
	RPTName = "TSC Item Taric Code Info";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	strPath ="\\resin-2.1.9\\webapps\\oradds\\TaricCodeList\\"+FileName;
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
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置左-格線-底色黃
	WritableCellFormat LeftBLY = new WritableCellFormat(font_bold);   
	LeftBLY.setAlignment(jxl.format.Alignment.LEFT);
	LeftBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	LeftBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	LeftBLY.setBackground(jxl.write.Colour.YELLOW); 
	LeftBLY.setWrap(true);	

	
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
	
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();

    sql = "select a.*"+
          ",qq.SPQ"+
          ",qq.MOQ"+
          ",qq.SAMPLE_SPQ"+
          ",tt.LEAD_TIME"+
          ",tt.NO_WAFER_LEAD_TIME"+
          ",TSC_INV_Prod_Group_7(a.inventory_item_id ,a.organization_id) Product_Group_8"+
          ",nvl(nvl(tai1.series_aecq,tai11.series_aecq),tai.series_aecq) series_aecq"+
          ",nvl(nvl(tai1.part_spec,tai11.part_spec),tai.part_spec) part_spec"+
          ",nvl(nvl(tai1.website_status,tai11.website_status),tai.website_status) website_status"+
          ",to_char(nvl(nvl(tai1.obsolete_timestamp,tai11.obsolete_timestamp),tai.obsolete_timestamp),'yyyy/mm/dd') obsolete_timestamp"+
		  ",tgp.CARTON_QTY"+   //add by Peggy 20210218
		  ",tgp.CARTON_SIZE"+  //add by Peggy 20210218
		  ",tgp.GW"+           //add by Peggy 20210218
		  ",tgp.NW"+           //add by Peggy 20210218
          " FROM (SELECT msi.organization_id,msi.segment1,msi.description,msi.inventory_item_id,msi.attribute3,"+
		  "       TSC_INV_CATEGORY(msi.inventory_item_id,43,23) TSC_PACKAGE , "+
		  "       TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) TSC_PROD_GROUP, "+
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,21) TSC_FAMILY,"+
		  "       TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000123) TSC_PROD_CATEGORY,"+
          "       TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000063) TSC_PROD_TYPE,"+ //add by Peggy 20191022
		  "       CASE WHEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) IN ('PMD','SSD','SSP') THEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000004) ELSE '' END TSC_PROD_FAMILY,"+
          "       TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id) PACKAGE_CODE ,"+
          "       TSC_GET_PARTNO(MSI.ORGANIZATION_ID ,MSI.INVENTORY_ITEM_ID) ITEM_DESC,"+
          "       TSC_GET_ITEM_DESC_NOPACKING(MSI.ORGANIZATION_ID ,MSI.INVENTORY_ITEM_ID) ITEM_DESC1,"+
          "       tm.ALENGNAME factory_code,"+
          "       to_char(pt.creation_date,'yyyy-mm-dd') parts_release_date,"+
          "       to_char(msi.creation_date,'yyyy-mm-dd') item_creation_date, "+ 
          "       case when tm.manufactory_no in ('002','008') then 'CHINA' "+
		  "            when tm.manufactory_no in ('005') then  case when nvl((SELECT 'Y' FROM oraddman.tssg_vendor_tw_parts tvtp WHERE tvtp.PART_NAME=msi.description OR tvtp.PART_NAME=TSC_GET_ITEM_DESC_NOPACKING(43 ,msi.inventory_item_id)),'N')='Y' then 'TAIWAN' else 'CHINA' end "+
		  "            when tm.manufactory_no in ('006','010','011') then 'TAIWAN' else '' end as COO,"+
          "       substr(cc.cccode,-10) TARIC_Code,"+
          "       cc.cccode,"+
          "       cc.category_id,"+
          "       cc.category_desciption,"+
		  "       tm.ALNAME packing_instructions"+   //add by Peggy 20210218
          "       FROM MTL_SYSTEM_ITEMS  msi"+
          "       ,oraddman.tsprod_manufactory tm"+
          "        ,(SELECT distinct y.INVENTORY_ITEM_ID,y.ORGANIZATION_ID, x.SEGMENT1,x.CREATION_DATE"+
          "         FROM inv.mtl_categories_b x,inv.mtl_item_categories y "+
          "         WHERE STRUCTURE_ID=50203"+
          "         and x.CATEGORY_ID=y.CATEGORY_ID"+
          "         and y.CATEGORY_SET_ID=24) pt"+
          "       ,(select mc.inventory_item_id ,mc.organization_id , tc.cccode,mct.category_id,mct.description category_desciption from mtl_item_categories mc, mtl_categories_tl mct,tsc_cccode tc where mc.CATEGORY_SET_ID=6 "+
          "        and mc.category_id = mct.category_id and mct.language = 'US' and tc.category_id(+) = mct.category_id and tc.language(+) = mct.language) cc"+
          "       WHERE msi.ORGANIZATION_ID=49"+
          "       AND LENGTH(msi.SEGMENT1)>=22"+
          "       AND msi.INVENTORY_ITEM_STATUS_CODE <>'Inactive'"+
          "       AND UPPER(msi.DESCRIPTION) NOT LIKE '%DISABLE%'"+
		  "       AND UPPER(msi.DESCRIPTION) NOT LIKE 'OSP-%'"+
		  "       AND msi.item_type='FG'"+
          "       AND msi.attribute3=tm.manufactory_no(+)"+
          "       and msi.organization_id=pt.ORGANIZATION_ID(+)"+
          "       and msi.INVENTORY_ITEM_ID=pt.INVENTORY_ITEM_ID(+)"+
          "       and msi.organization_id=cc.ORGANIZATION_ID(+)"+
          "       and msi.INVENTORY_ITEM_ID=cc.INVENTORY_ITEM_ID(+)"+
          "       ) A "+
          "       ,TABLE(TSC_GET_ITEM_SPQ_MOQ(a.inventory_item_id,'TS',NULL)) qq"+
          "       ,TABLE(TSC_GET_ITEM_LEADTIME(a.inventory_item_id,a.attribute3,NULL)) tt"+
          "       ,(select trim(PART_NAME) PART_NAME,case when upper(nvl(series_aecq,'NO'))='YES' then 'Y' else 'N' end as series_aecq, part_spec, website_status, obsolete_timestamp from oraddman.tsc_aecq_info) tai"+
          "       ,(select trim(PART_NAME) PART_NAME,case when upper(nvl(series_aecq,'NO'))='YES' then 'Y' else 'N' end as series_aecq, part_spec, website_status, obsolete_timestamp from oraddman.tsc_aecq_info) tai1"+
          "       ,(select trim(PART_NAME) PART_NAME,case when upper(nvl(series_aecq,'NO'))='YES' then 'Y' else 'N' end as series_aecq, part_spec, website_status, obsolete_timestamp from oraddman.tsc_aecq_info) tai11"+
          "       ,table(TSC_GET_PROD_PACKAGE_INFO(null,a.packing_instructions,a.inventory_item_id,'FACTORY')) tgp"+  //add by Peggy 20210218
          "       WHERE a.description=tai.part_name(+)"+
          "       AND a.item_desc=tai1.part_name(+)"+
          "       AND a.item_desc1=tai11.part_name(+)";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//資料日期
			ws.mergeCells(col, row, col+2, row);     
			ws.addCell(new jxl.write.Label(col, row, "資料日期:" +dateBean.getDate(), LeftBLY));
			row++;
						
			//22-Digit-Code
			ws.addCell(new jxl.write.Label(col, row, "22-Digit-Code" , ACenterBLB));
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
			
			ws.addCell(new jxl.write.Label(col, row, "TSC Ordering Code" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;
			
			ws.addCell(new jxl.write.Label(col, row, "PROD GROUP" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

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
			ws.addCell(new jxl.write.Label(col, row, "Lead Time(Week)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//No Wafer Lead Time(Week)
			ws.addCell(new jxl.write.Label(col, row, "No Wafer Lead Time(Week)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Factory
			ws.addCell(new jxl.write.Label(col, row, "Factory" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//COO
			ws.addCell(new jxl.write.Label(col, row, "COO" , ACenterBLB));
			ws.setColumnView(col,7);	
			col++;				
			
			//Part Name
			ws.addCell(new jxl.write.Label(col, row, "Part Name" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			
			//Description
			ws.addCell(new jxl.write.Label(col, row, "Description" , ACenterBLB));
			ws.setColumnView(col,35);	
			col++;	

			//website status
			ws.addCell(new jxl.write.Label(col, row, "Website Status" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Product Group 8
			ws.addCell(new jxl.write.Label(col, row, "Product Group 8" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "Taric Code" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;		
				
			ws.addCell(new jxl.write.Label(col, row, "Category ID" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;		

			//HTS Code
			ws.addCell(new jxl.write.Label(col, row, "Category Description" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//cc Code
			ws.addCell(new jxl.write.Label(col, row, "Cccode" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;				

			//TSC PROD TYPE
			ws.addCell(new jxl.write.Label(col, row, "TSC PROD TYPE" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//滿箱數量
			ws.addCell(new jxl.write.Label(col, row, "Full CTN Qty" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
	
			//淨重
			ws.addCell(new jxl.write.Label(col, row, "NW (kg)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
	
			//毛重
			ws.addCell(new jxl.write.Label(col, row, "GW (kg)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
	
			//材積
			ws.addCell(new jxl.write.Label(col, row, "Dimension (mm)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			row++;

		}
		col=0;

		ws.addCell(new jxl.write.Label(col, row, rs.getString("SEGMENT1"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION").substring(0, rs.getString("DESCRIPTION").length()-rs.getString("PACKAGE_CODE").length()).trim()  , ALeftL)); 
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKAGE_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DESCRIPTION"), ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_CATEGORY") , ALeftL));  //add by Peggy 20180222
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_FAMILY") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_FAMILY") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE") , ALeftL));
		col++;	
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
		if (rs.getString("NO_WAFER_LEAD_TIME")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("NO_WAFER_LEAD_TIME")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("factory_code") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("coo") , ACenterL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("item_desc") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("part_spec")==null?"":rs.getString("part_spec")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("website_status")==null?"":rs.getString("website_status")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("Product_Group_8") , ALeftL));  
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TARIC_Code")==null?"":rs.getString("TARIC_Code")) , ACenterL));  
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("category_id")==null?"":rs.getString("category_id")) , ACenterL));  
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CATEGORY_DESCIPTION")==null?"":rs.getString("CATEGORY_DESCIPTION")) , ACenterL));  
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("cccode")==null?"":rs.getString("cccode")) , ACenterL));  
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PROD_TYPE")==null?"":rs.getString("TSC_PROD_TYPE")) , ALeftL)); //add by Peggy 20191022,FOR CELINE CHECK   
		col++;	
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
		//材積				
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("carton_size")==null?"":rs.getString("carton_size")), ACenterL));
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
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 &&  request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("celine.yu@ts.com.tw"));  
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("TS Item Taric Code Report - "+dateBean.getYearMonthDay()+remarks);
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		if (request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.144")>=0)
		{
			mbp.setContent("<a href="+'"'+"file:///\\10.0.1.144\\"+strPath+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
		}
		else
		{
			mbp.setContent("<a href="+'"'+"file:///\\10.0.1.135\\"+strPath+'"'+">請按下此連結下載資料</a>,謝謝!&nbsp;", "text/html;charset=UTF-8");
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
