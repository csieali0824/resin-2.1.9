<%@ page contentType="text/html;charset=utf-8"  pageEncoding="big5" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>  
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSPCOrderReviseExcel.jsp" METHOD="post" name="MYFORM">
<%
String sql = "";
String REQ_TYPE =request.getParameter("REQ_TYPE");
if (REQ_TYPE==null) REQ_TYPE="";
String MO_LIST = request.getParameter("MO_LIST");
if (MO_LIST==null) MO_LIST="";
String SALES_GROUP_LIST = request.getParameter("SALES_GROUP_LIST");
if (SALES_GROUP_LIST==null)SALES_GROUP_LIST="";
String ITEM_LIST = request.getParameter("ITEM_LIST");
if (ITEM_LIST==null) ITEM_LIST="";
String PLANTCODE = request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
String SSD_SDATE = request.getParameter("SSD_SDATE");
if (SSD_SDATE==null) SSD_SDATE="";
String SSD_EDATE = request.getParameter("SSD_EDATE");
if (SSD_EDATE==null) SSD_EDATE="";
String FileName="",RPTName="",v_orderno="",v_lineno="";
int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
String sheetArray[][]=null;
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = REQ_TYPE;
	sql = " select MANUFACTORY_NO,ALENGNAME,ALNAME,COUNT(1) OVER (PARTITION BY 1) REC_CNT,ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY MANUFACTORY_NO) LINE_SEQ"+
	      " from oraddman.tsprod_manufactory a "+
	      " where MANUFACTORY_NO not in ('001','003','004')";
	if (!PLANTCODE.equals("")) sql += " AND MANUFACTORY_NO='"+PLANTCODE+"'";
	sql += " and ALNAME in ('Y','I','T','A','E') ORDER BY MANUFACTORY_NO";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (rs.getInt("line_seq")==1)
		{
			sheetArray=new String[rs.getInt("REC_CNT")][3];
			if (rs.getInt("line_seq")==1)
			{
				RPTName= rs.getString("ALENGNAME")+"-"+RPTName;
			}	
			else
			{
				RPTName= "All Factory-"+RPTName;
			}
		}
		sheetArray[rs.getInt("line_seq")-1][0]=rs.getString("MANUFACTORY_NO");
		sheetArray[rs.getInt("line_seq")-1][1]=rs.getString("ALENGNAME");
		sheetArray[rs.getInt("line_seq")-1][2]=rs.getString("ALNAME");
	}
	rs.close();
	statement.close();
	
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableSheet ws = null;
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	for (int sht=0 ; sht<sheetArray.length; sht++)
	{
		reccnt=0;col=0;row=0;
		wwb.createSheet(sheetArray[sht][1], sht);
	
		WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		WritableFont font_nobold_b = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE);
	
		//英文內文水平垂直置中-粗體-格線-底色藍  
		WritableCellFormat ACenterBL = new WritableCellFormat(font_bold);   
		ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBL.setBackground(jxl.write.Colour.ICE_BLUE); 
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
	
		//日期格式-紅字
		WritableCellFormat DATE_FORMAT_R = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED) ,new jxl.write.DateFormat("yyyy/MM/dd")); 
		DATE_FORMAT_R.setAlignment(jxl.format.Alignment.CENTRE);
		DATE_FORMAT_R.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		DATE_FORMAT_R.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		DATE_FORMAT_R.setWrap(true);
	
		//日期格式-藍字
		WritableCellFormat DATE_FORMAT_B = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE) ,new jxl.write.DateFormat("yyyy/MM/dd")); 
		DATE_FORMAT_B.setAlignment(jxl.format.Alignment.CENTRE);
		DATE_FORMAT_B.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		DATE_FORMAT_B.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		DATE_FORMAT_B.setWrap(true);
	
		sql = " SELECT TSC_INTERCOMPANY_PKG.GET_SALES_GROUP(NVL(TSC_OHA.HEADER_ID,OHA.HEADER_ID)) SALES_GROUP"+
			  ",OHA.ORG_ID"+
			  ",'('||ACS.ACCOUNT_NUMBER||')'||NVL(ACS.CUSTOMER_SNAME,ACS.CUSTOMER_NAME) CUSTOMER_NAME"+
			  ",OHA.HEADER_ID"+
			  ",OHA.ORDER_NUMBER"+
			  //",OHA.VERSION_NUMBER"+
			  ",TO_NUMBER(OHA.ATTRIBUTE3) VERSION_NUMBER"+
			  ",OHA.TRANSACTIONAL_CURR_CODE CURR_CODE"+
			  ",OLA.LINE_ID"+
			  ",OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER LINE_NO"+
			  ",DECODE(OLA.ITEM_IDENTIFIER_TYPE,'CUST',OLA.ORDERED_ITEM,'') ORDERED_ITEM"+
			  ",MSI.SEGMENT1 ITEM_NAME"+
			  ",MSI.DESCRIPTION ITEM_DESC"+
			  ",TO_CHAR(OHA.ORDERED_DATE,'yyyy/mm/dd') ORDERED_DATE"+
			  ",TO_CHAR(OLA.REQUEST_DATE,'yyyy/mm/dd') REQUEST_DATE"+
			  ",TO_CHAR(OLA.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') SCHEDULE_SHIP_DATE"+
			  ",OLA.ORDERED_QUANTITY"+
			  ",OLA.FLOW_STATUS_CODE"+
			  ",NVL(OLA.CUSTOMER_LINE_NUMBER,OLA.CUST_PO_NUMBER) CUSTOMER_PO_NUMBER"+
			  ",OLA.CUSTOMER_SHIPMENT_NUMBER"+
			  ",LC.MEANING SHIPPING_METHOD_NAME"+
			  ",OLA.ATTRIBUTE20 HOLD_SHIPMENT"+
			  ",OLA.ATTRIBUTE5 HOLD_REASON"+
			  ",OLA.PACKING_INSTRUCTIONS"+
			  ",OLA.SHIP_FROM_ORG_ID"+
			  //",CASE WHEN SUBSTR(OHA.ORDER_NUMBER,1,4)='1121' THEN 'CELINE' ELSE (SELECT DISTINCT res.resource_name FROM apps.jtf_rs_salesreps rs,apps.JTF_RS_RESOURCE_EXTNS_VL RES,hr_organization_units hou WHERE hou.organization_id = rs.org_id AND rs.resource_id = res.resource_id AND rs.salesrep_id(+)=NVL(TSC_OHA.salesrep_id,OHA.salesrep_id)) END SALES_NAME"+
			  ",(SELECT DISTINCT res.resource_name FROM apps.jtf_rs_salesreps rs,apps.JTF_RS_RESOURCE_EXTNS_VL RES,hr_organization_units hou WHERE hou.organization_id = rs.org_id AND rs.resource_id = res.resource_id AND rs.salesrep_id(+)=NVL(TSC_OHA.salesrep_id,OHA.salesrep_id)) SALES_NAME"+
			  ",to_char(OLA.LAST_UPDATE_DATE,'yyyy/mm/dd') ORDER_LAST_UPDATE_DATE"+
			  ",TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,23) TSC_PACKAGE"+
			  ",TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,21) TSC_FAMILY"+
			  ",HIS.SO_QTY"+
			  ",TO_CHAR(HIS.SCHEDULE_SHIP_DATE,'YYYY/MM/DD') NEW_SCHEDULE_SHIP_DATE"+
			  ",HIS.REASON_DESC"+
			  ",HIS.REMARKS"+
			  ",HIS.ASCRIPTION_BY"+
			  " FROM ONT.OE_ORDER_HEADERS_ALL OHA,"+
			  " ONT.OE_ORDER_LINES_ALL OLA,"+
			  //" AR_CUSTOMERS ACS,"+
			  " TSC_CUSTOMER_ALL_V ACS,"+ 
			  " INV.MTL_SYSTEM_ITEMS_B MSI,"+
			  " (SELECT LOOKUP_CODE,MEANING FROM FND_LOOKUP_VALUES WHERE LANGUAGE='US' AND LOOKUP_TYPE='SHIP_METHOD') LC,"+
			  " (SELECT HEADER_ID,ORDER_NUMBER,SALESREP_ID FROM ONT.OE_ORDER_HEADERS_ALL WHERE ORG_ID=41) TSC_OHA,"+
			  " (SELECT HIS.* FROM (SELECT REQUEST_TYPE,ASCRIPTION_BY,SO_HEADER_ID,SO_LINE_ID,SO_QTY,SCHEDULE_SHIP_DATE,REASON_DESC,REMARKS,DENSE_RANK() OVER (PARTITION BY REQUEST_TYPE,SO_HEADER_ID,SO_LINE_ID ORDER BY REQUEST_NO DESC) ROW_SEQ FROM oraddman.tsc_om_salesorderrevise_pc X WHERE REQUEST_TYPE='"+REQ_TYPE +"') HIS WHERE ROW_SEQ=1) HIS"+
			  " WHERE ?01"+
			  " AND OHA.HEADER_ID=OLA.HEADER_ID"+
			  " AND OHA.ORDER_NUMBER=TSC_OHA.ORDER_NUMBER(+)"+
			  " AND OHA.SOLD_TO_ORG_ID=ACS.CUSTOMER_ID"+
			  " AND OLA.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID"+
			  " AND OLA.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID"+
			  " AND OLA.SHIPPING_METHOD_CODE=LC.LOOKUP_CODE"+
			  " AND OLA.LINE_ID=HIS.SO_LINE_ID(+)"+
			  " AND OLA.FLOW_STATUS_CODE IN ('AWAITING_SHIPPING','AWAITING_APPROVE')";
			  //" AND OLA.ATTRIBUTE20 IS NULL"+
		if (REQ_TYPE.equals("Overdue"))
		{
			sql += " AND OLA.SCHEDULE_SHIP_DATE < trunc(SYSDATE)";
		}
		else
		{
			sql += " AND OLA.SCHEDULE_SHIP_DATE >= trunc(SYSDATE)";
		
			if (!SSD_SDATE.equals("") || !SSD_EDATE.equals(""))
			{
				sql += " AND OLA.SCHEDULE_SHIP_DATE between TO_DATE(nvl('"+SSD_SDATE+"','20110101'),'YYYYMMDD') and TO_DATE(nvl('"+SSD_EDATE+"','20990101'),'YYYYMMDD')+0.99999";
			}
			if (!SALES_GROUP_LIST.equals(""))
			{
				String [] sArray =SALES_GROUP_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += " and TSC_INTERCOMPANY_PKG.GET_SALES_GROUP(NVL(TSC_OHA.HEADER_ID,OHA.HEADER_ID)) in ( '"+sArray[x].trim()+"'";
					}
					else
					{
						sql += ",'"+sArray[x].trim()+"'";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}	
						
			if (!MO_LIST.equals(""))
			{
				String [] sArray = MO_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					v_orderno="";
					v_lineno="";
					if (sArray[x].trim().indexOf("/")>0)
					{
						v_orderno=sArray[x].trim().substring(0,sArray[x].trim().indexOf("/"));
						v_lineno=sArray[x].trim().substring(sArray[x].trim().indexOf("/")+1);
					}
					else
					{
						v_orderno=sArray[x].trim();
					}
					if (x==0)
					{
						sql += " and ((OHA.ORDER_NUMBER ='"+v_orderno+"'";
						if (!v_lineno.equals("")) sql += " and OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER='"+v_lineno+"'";
						sql += ")";
					}
					else
					{
						sql += " or (OHA.ORDER_NUMBER ='"+v_orderno+"'";
						if (!v_lineno.equals("")) sql += " and OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER='"+v_lineno+"'";
						sql += ")";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}			
			if (!ITEM_LIST.equals(""))
			{
				String [] sArray = ITEM_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += " and (upper(msi.description) like '"+sArray[x].trim().toUpperCase()+"%'";
					}
					else
					{
						sql += " or upper(msi.description) like '"+sArray[x].trim().toUpperCase()+"%'";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}
		}		
		if (sheetArray[sht][0].equals("002"))
		{	
			sql= sql.replace("?01"," (OHA.ORG_ID =325 OR (OHA.ORG_ID=41 AND SUBSTR(OHA.ORDER_NUMBER,1,4) IN ('1156','1214'))) AND OLA.PACKING_INSTRUCTIONS='"+sheetArray[sht][2]+"'");
		}
		else if (sheetArray[sht][0].equals("005"))
		{
			sql= sql.replace("?01"," (OHA.ORG_ID =906 OR (OHA.ORG_ID=41 AND SUBSTR(OHA.ORDER_NUMBER,1,4) IN ('1142','1214') AND OLA.PACKING_INSTRUCTIONS='"+sheetArray[sht][2]+"') OR (OHA.ORG_ID=41 AND OLA.PACKING_INSTRUCTIONS='I')) AND TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003)='SSD'");
		}			
		else if (sheetArray[sht][0].equals("008"))
		{
			sql= sql.replace("?01"," (OHA.ORG_ID =906 OR (OHA.ORG_ID=41 AND SUBSTR(OHA.ORDER_NUMBER,1,4) IN ('1142','1214'))) AND OLA.PACKING_INSTRUCTIONS='"+sheetArray[sht][2]+"' AND TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003)='PRD-Subcon'");
		}
		else if (sheetArray[sht][0].equals("006") || sheetArray[sht][0].equals("010") || sheetArray[sht][0].equals("011"))
		{
			sql= sql.replace("?01"," OHA.ORG_ID =41 AND OLA.PACKING_INSTRUCTIONS='"+sheetArray[sht][2]+"' AND TSC_INV_CATEGORY(OLA.INVENTORY_ITEM_ID,43,1100000003) IN ('PMD','PRD','PRD-Subcon')");
		}
		sql += " ORDER BY OLA.SCHEDULE_SHIP_DATE,OHA.ORDER_NUMBER,TO_NUMBER(OLA.LINE_NUMBER||'.'||OLA.SHIPMENT_NUMBER),NVL(HIS.SCHEDULE_SHIP_DATE,OLA.SCHEDULE_SHIP_DATE)";
		//out.println(sql);
		statement=con.createStatement(); 
		rs=statement.executeQuery(sql);
		//String sheetname [] = wwb.getSheetNames();
		while (rs.next()) 
		{ 	
			if (reccnt==0)
			{
				col=0;row=0;
				ws = wwb.getSheet(sheetArray[sht][1]);
				SheetSettings sst = ws.getSettings(); 
				sst.setSelected();
				sst.setVerticalFreeze(1);  //凍結窗格
				for (int g =1 ; g <= 12 ;g++ )
				{
					sst.setHorizontalFreeze(g);
				}	
				
				//M/O No
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "M/O No" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;					

				//Revision No.
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Revision No." , ACenterBL));
				ws.setColumnView(col,5);	
				col++;					
					
				//Line NO
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Line NO" , ACenterBL));
				ws.setColumnView(col,6);	
				col++;	
								
				//Part Number
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Part Number" , ACenterBL));
				ws.setColumnView(col,25);	
				col++;	
	
				//Area
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Area" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
	
				//customer
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
				ws.setColumnView(col,30);	
				col++;	

				//package
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Package" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	

				//Family
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Family" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	
		
				//Order Entry Date
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Order Entry Date" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
		
				//CRD
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "CRD" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
				
				//Schedule Ship Date
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Schedule Ship Date" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;		
				
				//Quantity
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Quantity" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
				
				//Sales
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Sales" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
				
				//Ship Method
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Ship Method" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;		
				
				//Customer PN
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Customer PN" , ACenterBL));
				ws.setColumnView(col,20);
				col++;	
				
				//P/O
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "P/O" , ACenterBL));
				ws.setColumnView(col,30);	
				col++;	
				
				//Unit Price
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Unit Price" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;		
				
				//CURRENCY
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Currency" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;																						
	
				//TOTAL
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Total" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;
				
				//ETA Customer
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "ETA Customer" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;		
				
				//Order Update Date
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Order Update Date" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;		
				
				//Customer line NO
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Customer line NO" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;	
				
				//OC NUMBER
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "OC Number" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;
				
				//Hold
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Hold" , ACenterBLY));
				ws.setColumnView(col,8);	
				col++;	
				
				//Hold Reason
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Hold Reason" , ACenterBLY));
				ws.setColumnView(col,12);	
				col++;		
				
				//Status
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Status" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;		
				
				//ASCRIPTION_BY
				ws.addCell(new jxl.write.Label(col, row, "Ascription By" , ACenterBLO));
				ws.setColumnView(col,10);	
				col++;	
				
				//Balance date(factory)
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Balance date(factory)" , ACenterBLO));
				ws.setColumnView(col,12);	
				col++;	
				
				//Balance QTY (factory)  (Pcs)
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Balance QTY\r\n(factory)  (Pcs)" , ACenterBLO));
				ws.setColumnView(col,12);	
				col++;	
				
				//Produce Status
				//ws.mergeCells(col, row, col, row); 
				ws.addCell(new jxl.write.Label(col, row, "Produce Status" , ACenterBLO));
				ws.setColumnView(col,12);	
				col++;	
				row++;																							
			}			

			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_NUMBER"), ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("VERSION_NUMBER"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_GROUP"),ALeftL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME"),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PACKAGE"),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_FAMILY"),ALeftL));
			col++;	
			if (rs.getString("ORDERED_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ORDERED_DATE")) ,DATE_FORMAT));
			}
			col++;					
			if (rs.getString("REQUEST_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("REQUEST_DATE")) ,DATE_FORMAT));
			}
			col++;		
			if (rs.getString("SCHEDULE_SHIP_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
			}
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ORDERED_QUANTITY")).doubleValue(), ARightL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SALES_NAME"),ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_METHOD_NAME"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("ORDERED_ITEM")==null?"":rs.getString("ORDERED_ITEM")),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_PO_NUMBER"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, "",ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CURR_CODE"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, "",ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, "",ALeftL));
			col++;
			if (rs.getString("ORDER_LAST_UPDATE_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ORDER_LAST_UPDATE_DATE")) ,DATE_FORMAT));
			}
			col++;														
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUSTOMER_SHIPMENT_NUMBER")==null?"":rs.getString("CUSTOMER_SHIPMENT_NUMBER")),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, "",ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("HOLD_SHIPMENT"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("HOLD_REASON"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, REQ_TYPE ,ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("ASCRIPTION_BY")==null?"":rs.getString("ASCRIPTION_BY")),ALeftL));
			col++;
			if (rs.getString("NEW_SCHEDULE_SHIP_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("NEW_SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
			}			
			col++;
			if (rs.getString("SO_QTY")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
			}
			else
			{		
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SO_QTY")).doubleValue(), ARightL));
			}			
			col++;
			ws.addCell(new jxl.write.Label(col, row,(rs.getString("reason_desc")==null?"":rs.getString("reason_desc"))+(rs.getString("reason_desc")!=null && rs.getString("remarks")!=null?",":"")+(rs.getString("remarks")==null?"":rs.getString("remarks")),ALeftL));
			col++;
			row++;				
			
			reccnt ++;
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
	out.println("Exception:"+e.getMessage()+sql); 
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
	String strURL = "/oradds/report/"+FileName; 
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
