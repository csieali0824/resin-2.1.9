<!--20161201 by Peggy,業務改單通知PMD工廠-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Email Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSSalesOrderReviseMail.jsp" METHOD="post" name="MYFORM">
<%
String sql = "",request_no="",so_line_id="",remarks="";
String FileName="",RPTName="",PLANTNAME="";
String REPORT_TYPE=request.getParameter("RTYPE");
if (REPORT_TYPE==null) REPORT_TYPE="";
String DATA_DATE=request.getParameter("D_DATE");
if (DATA_DATE==null) DATA_DATE="";
String PLANTCODE=request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
int fontsize=8,colcnt=0,row=0,col=0,reccnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
String mailsubject="";

try 
{ 	
	OutputStream os = null;	
	sql = " select distinct plant_code from oraddman.tsc_om_salesorderrevise_req a where 1=1";
	if (REPORT_TYPE.equals("NOCHANGE"))
	{
		sql += " and a.PC_CONFIRMED_RESULT ='A' and a.STATUS='CLOSED' and a.SALES_CONFIRMED_RESULT in (3,4) ";
		sql += " and a.LAST_UPDATE_DATE BETWEEN to_date('"+DATA_DATE+"','yyyymmdd') AND to_date('"+DATA_DATE+"','yyyymmdd')+0.99999";
	}
	else if (REPORT_TYPE.equals("AGREENOTICE"))
	{
		sql += " and a.PC_CONFIRMED_RESULT ='A' and a.NOTICE_PC_DATE is null "; 
		//sql += " and a.PC_CONFIRMED_DATE BETWEEN to_date('"+DATA_DATE+"','yyyymmdd') AND to_date('"+DATA_DATE+"','yyyymmdd')+0.99999 ";
	}
	else if (REPORT_TYPE.equals("REVISED"))  //add by Peggy 20161201
	{
		sql += " and a.SALES_CONFIRMED_RESULT='1' and a.STATUS='CLOSED' and a.NOTICE_PC_DATE is null and a.LAST_UPDATE_DATE>= trunc(sysdate-2)+0.99999 ";
	}
	if (!PLANTCODE.equals(""))
	{
		sql += " and a.plant_code='"+PLANTCODE+"'";
	}
	sql+=" order by a.plant_code";
	//out.println(sql);
	Statement state1=con.createStatement();     
	ResultSet rs1=state1.executeQuery(sql);
	while (rs1.next())	
	{
		if (REPORT_TYPE.equals("AGREENOTICE"))
		{
			RPTName = "AgreeToReviseOrderDetail";
		}
		else if (REPORT_TYPE.equals("NOCHANGE"))
		{
			RPTName = "SalesNoReviseOrderList";
		}
		else if (REPORT_TYPE.equals("REVISED"))  //add by Peggy 20161201
		{
			RPTName = "SalesReviseOrderList";		
		}
		else if (REPORT_TYPE.equals("AUTOCONFIRM"))  //add by Peggy 20230512
		{
			RPTName = "AutoConfirmOrderList";
		}		
		
		if (rs1.getString("plant_code").equals("002")) 
		{
			PLANTNAME= "(YEW)";
		}	
		else if (rs1.getString("plant_code").equals("005"))
		{
			PLANTNAME= "(SSP)";		
		}
		else if (rs1.getString("plant_code").equals("006"))
		{
			PLANTNAME= "(PMD)";		
		}
		else if (rs1.getString("plant_code").equals("008"))
		{
			PLANTNAME= "(TEW)";		
		}
		else if (rs1.getString("plant_code").equals("010"))
		{
			PLANTNAME= "(A01)";		
		}
		else
		{
			PLANTNAME= "(ALL)";	
		}	
		RPTName += PLANTNAME;				
	
		FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		WritableWorkbook wwb = Workbook.createWorkbook(os); 
		wwb.createSheet(RPTName, 0);
		WritableSheet ws = null;
	
		WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
		
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
		
		//英文內文水平垂直置中-粗體-格線-底色橘
		WritableCellFormat ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
		ACenterBLO.setWrap(true);	
		
		//英文內文水平垂直置中-粗體-格線-底色黃
		WritableCellFormat ALeftBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ALeftBLG.setAlignment(jxl.format.Alignment.LEFT);
		ALeftBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ALeftBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ALeftBLG.setBackground(jxl.write.Colour.YELLOW); 
		ALeftBLG.setWrap(true);	
				
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
			
		//日期格式
		WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
		DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
		DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		DATE_FORMAT.setWrap(true);
	
		sql = " select a.request_no"+
			  ",a.sales_group"+
			  ",a.so_no"+
			  ",a.line_no"+
			  ",a.so_header_id"+
			  ",a.so_line_id"+
			  ",a.order_type"+
			  ",a.customer_number"+
			  ",a.customer_name"+
			  ",a.ship_to_org_id"+
			  ",a.tsc_prod_group"+
			  ",a.inventory_item_id"+
			  ",a.item_name"+
			  ",a.item_desc"+
			  ",a.cust_item_id"+
			  ",a.cust_item_name"+
			  ",a.customer_po"+
			  ",a.shipping_method"+
			  ",a.so_qty"+
			  ",to_char(a.request_date,'yyyy/mm/dd') request_date"+
			  ",to_char(a.schedule_ship_date,'yyyy/mm/dd') schedule_ship_date"+
			  ",to_char(a.pc_schedule_ship_date,'yyyy/mm/dd') pc_schedule_ship_date"+
			  ",a.packing_instructions"+
			  ",a.plant_code"+
			  ",a.change_reason"+
			  ",a.change_comments"+
			  ",a.created_by"+
			  ",to_char(a.creation_date,'yyyy/mm/dd') creation_date"+
			  ",a.pc_confirmed_by"+
			  ",to_char(a.pc_confirmed_date,'yyyy/mm/dd') pc_confirmed_date"+
			  ",a.last_updated_by"+
			  ",to_char(a.last_update_date,'yyyy/mm/dd') last_update_date"+
			  ",a.status"+
			  ",a.temp_id"+
			  ",a.seq_id"+
			  ",a.ship_to"+
			  ",a.pc_remarks"+
			  ",a.remarks"+
			  ",a.pc_confirmed_result"+
			  ",a.pc_so_qty"+
			  ",b.ALENGNAME"+
			  ",a.SOURCE_SO_QTY orig_so_qty"+
			  ",a.SOURCE_ITEM_DESC orig_item_desc"+
			  ",to_char(a.SOURCE_SSD,'yyyy/mm/dd') orig_schedule_ship_date"+
			  ",nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) orig_customer"+
			  ",count(a.SO_LINE_ID) over (partition by SO_HEADER_ID,SO_LINE_ID) line_cnt"+
			  ",decode(a.NEW_SO_NO ,null,'',a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '/'||a.NEW_LINE_NO) as new_order"+
			  ",a.NEW_SO_NO"+
			  ",a.NEW_LINE_NO"+
			  ",a.ship_to_location_id"+
			  ",a.SOURCE_CUSTOMER_PO"+
			  ",a.deliver_to_location_id"+
			  ",a.DELIVER_TO_ORG_ID"+
			  ",a.DELIVER_TO"+
			  ",a.BILL_TO_LOCATION_ID"+
			  ",a.BILL_TO_ORG_ID"+
			  ",a.BILL_TO"+
			  ",a.SOURCE_BILL_TO_ORG_ID"+		
			  ",a.SOURCE_BILL_TO_LOCATION_ID"+
			  ",a.SOURCE_SHIP_TO_LOCATION_ID"+
			  ",a.SOURCE_DELIVER_TO_LOCATION_ID"+
			  ",a.FOB_POINT_CODE"+
			  ",a.SOURCE_FOB_POINT_CODE"+
			  ",a.FOB"+		  
			  ",replace(replace(tsc_order_revise_pkg.GET_REVISE_DESC(a.temp_id,a.seq_id,'SALES'),chr(13),''),chr(10),'<br>') others_field_revise_desc"+
			  " from oraddman.tsc_om_salesorderrevise_req a"+
			  ",oraddman.tsprod_manufactory b"+
			  ",ar_customers e"+
			  " where a.source_customer_id=e.customer_id"+
			  " and a.plant_code =b.manufactory_no(+)"+
			  " and a.PLANT_CODE='"+ rs1.getString("plant_code")+"'";
		if (REPORT_TYPE.equals("NOCHANGE"))
		{
			sql += " and a.PC_CONFIRMED_RESULT ='A' and a.STATUS='CLOSED' and a.SALES_CONFIRMED_RESULT in (0,4)";
			sql += " and a.LAST_UPDATE_DATE BETWEEN to_date('"+DATA_DATE+"','yyyymmdd') AND to_date('"+DATA_DATE+"','yyyymmdd')+0.99999";
		}
		else if (REPORT_TYPE.equals("AGREENOTICE"))
		{
			sql += " and a.PC_CONFIRMED_RESULT ='A' and a.NOTICE_PC_DATE is null";
			//sql += " and a.PC_CONFIRMED_DATE BETWEEN to_date('"+DATA_DATE+"','yyyymmdd') AND to_date('"+DATA_DATE+"','yyyymmdd')+0.99999 ";
		}
		else if (REPORT_TYPE.equals("REVISED"))  //add by Peggy 20161201
		{
			sql += " and a.SALES_CONFIRMED_RESULT='1' and a.STATUS='CLOSED' and a.NOTICE_PC_DATE is null and a.LAST_UPDATE_DATE>= trunc(sysdate-2)+0.99999 ";
		}	
		else if (REPORT_TYPE.equals("AUTOCONFIRM"))  //add by Peggy 20230512
		{
			sql += " and NVL(a.CANCEL_MOVE_FLAG,'N') not in ('N') and NVL(a.PC_CONFIRMED_RESULT,'')='A'";
		}			
		sql += " order by a.PLANT_CODE,a.SALES_GROUP,a.request_no,a.SO_NO||'-'||a.LINE_NO,a.seq_id";
		//out.println(sql);
		so_line_id="";reccnt=0;
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);
		String sheetname [] = wwb.getSheetNames();
		while (rs.next()) 
		{ 
			if (reccnt==0)
			{
				col=0;row=0;
				ws = wwb.getSheet(sheetname[0]);
				SheetSettings sst = ws.getSettings(); 
				sst.setSelected();
				
				if (REPORT_TYPE.equals("NOCHANGE"))				
				{
					//資料日期
					ws.mergeCells(col, row, col+1, row);     
					ws.addCell(new jxl.write.Label(col, row, "資料日期:" +DATA_DATE, ALeftBLG));
					row++;
				}
				
				col=0;
				sst.setVerticalFreeze(row+1);  //凍結窗格
				sst.setVerticalFreeze(row+2);  //凍結窗格
				for (int g =1 ; g <=9 ;g++ )
				{
					sst.setHorizontalFreeze(g);
				}	
				//Request No
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "Request No" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;						
							
				//Sales Group
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "Sales Group" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	
	
				//customer
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
				ws.setColumnView(col,22);	
				col++;	
	
				//MO#
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
	
				//Line#
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "Line#" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;	
	
				//原品名
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "原品名" , ACenterBL));
				ws.setColumnView(col,20);	
				col++;	
					
				//原Cust PO
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "原Cust PO" , ACenterBL));
				ws.setColumnView(col,20);	
				col++;	
				
				//原訂單量
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "原訂單量" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
	
				//原交期
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "原交期" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
	
				//訂單修改明細
				ws.mergeCells(col, row, col+3, row); 
				ws.addCell(new jxl.write.Label(col, row, "訂單修改明細" , ACenterBLB));
				ws.setColumnView(col,10);	
				col+=4;	
				
				//工廠回覆結果
				ws.mergeCells(col, row, col+4, row); 
				ws.addCell(new jxl.write.Label(col, row, "工廠回覆結果" , ACenterBLO));
				ws.setColumnView(col,10);	
				col+=5;
	
				//Requester
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "Requester" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	
				
				//Request DATE
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "Request Date" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
				
				//PC Confirmed
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "PC Confirmed" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
								
				//pc confirm date
				ws.mergeCells(col, row, col, row+1); 
				ws.addCell(new jxl.write.Label(col, row, "PC Confirmed Date" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;										
				row++;
				
		
				col=9;
				//Order Qty
				ws.addCell(new jxl.write.Label(col, row, "Order Qty" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;													
	
				//SSD pull in/out
				ws.addCell(new jxl.write.Label(col, row, "SSD pull in/out" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;
						
				ws.addCell(new jxl.write.Label(col, row, "Others field revise description" , ACenterBLB));
				ws.setColumnView(col,12);	
				col++;
				/*
				//Order Type
				ws.addCell(new jxl.write.Label(col, row, "Order Type" , ACenterBLB));
				ws.setColumnView(col,12);	
				col++;
	
				//Customer
				ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLB));
				ws.setColumnView(col,25);	
				col++;	
				
	
				//Ship To
				ws.addCell(new jxl.write.Label(col, row, "Ship To" , ACenterBLB));
				ws.setColumnView(col,25);	
				col++;		
	
				//Item Desc
				ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBLB));
				ws.setColumnView(col,20);	
				col++;	
	
				//Cust P/N
				ws.addCell(new jxl.write.Label(col, row, "Cust P/N" , ACenterBLB));
				ws.setColumnView(col,20);	
				col++;
				
				//Cust PO
				ws.addCell(new jxl.write.Label(col, row, "Cust PO" , ACenterBLB));
				ws.setColumnView(col,20);	
				col++;	
	
				//Shipping Method
				ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	
				*/
				
				//Remarks
				ws.addCell(new jxl.write.Label(col, row, "Sales Remarks" , ACenterBLB));
				ws.setColumnView(col,20);	
				col++;								
	
				//工廠別
				ws.addCell(new jxl.write.Label(col, row, "工廠別" , ACenterBLO));
				ws.setColumnView(col,8);	
				col++;	
	
				
				//工廠確認數量
				ws.addCell(new jxl.write.Label(col, row, "確認數量" , ACenterBLO));
				ws.setColumnView(col,10);	
				col++;
	
				//工廠確認交期
				ws.addCell(new jxl.write.Label(col, row, "確認交期" , ACenterBLO));
				ws.setColumnView(col,10);	
				col++;	
				
	
				//工廠回覆結果
				ws.addCell(new jxl.write.Label(col, row, "回覆結果" , ACenterBLO));
				ws.setColumnView(col,10);	
				col++;		
	
				//工廠備註
				ws.addCell(new jxl.write.Label(col, row, "工廠備註" , ACenterBLO));
				ws.setColumnView(col,20);	
				col++;	
				row++;				
			}

			col=0;
			if (!rs.getString("so_line_id").equals(so_line_id))
			{	
				so_line_id=rs.getString("so_line_id");
				ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("request_no"), ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("sales_group"), ACenterL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("orig_customer"), ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("so_no") , ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("line_no") , ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("orig_item_desc") , ALeftL));
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("source_customer_po") , ALeftL));
				col++;					
				ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
				if (rs.getString("orig_so_qty")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("orig_so_qty")).doubleValue(), ARightL));
				}
				col++;	
				ws.mergeCells(col, row, col, row+rs.getInt("line_cnt")-1); 	
				if (rs.getString("orig_schedule_ship_date")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
				}
				else
				{
					ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("orig_schedule_ship_date")) ,DATE_FORMAT));
				}
				col++;	
			}
			else
			{
				col=9;
			}
			
			/*
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("order_type")==null?"":rs.getString("order_type")), ACenterL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("customer_name")==null?"":rs.getString("customer_name")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("ship_to")==null?"":rs.getString("ship_to")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("item_desc")==null?"":rs.getString("item_desc")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("cust_item_name")==null?"":rs.getString("cust_item_name")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("customer_po")==null?"":rs.getString("customer_po")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("shipping_method")==null?"":rs.getString("shipping_method")), ALeftL));
			col++;	
			*/
			if (rs.getString("so_qty")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("so_qty")).doubleValue(), ARightL));
			}			
			col++;	
			if (rs.getString("schedule_ship_date")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("schedule_ship_date")) ,DATE_FORMAT));
			}	
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("others_field_revise_desc")==null?"":rs.getString("others_field_revise_desc")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("remarks")==null?"":rs.getString("remarks")), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ALENGNAME"), ACenterL));
			col++;	
			if (rs.getString("pc_so_qty")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("pc_so_qty")).doubleValue(), ARightL));
			}			
			col++;	
			if (rs.getString("pc_schedule_ship_date")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("pc_schedule_ship_date")) ,DATE_FORMAT));
			}
			col++;
			if (rs.getString("pc_confirmed_result") ==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			}
			else
			{
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("pc_confirmed_result").equals("A")?"Accept":"Reject"), (rs.getString("pc_confirmed_result").equals("A")? ACenterLG:ACenterLP)));
			}
			col++;				
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("pc_remarks")==null?"":rs.getString("pc_remarks")), ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATED_BY"), ALeftL));
			col++;	
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("CREATION_DATE")) ,DATE_FORMAT));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("PC_CONFIRMED_BY")==null?"":rs.getString("PC_CONFIRMED_BY")), ALeftL));
			col++;	
			if (rs.getString("PC_CONFIRMED_DATE")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			}
			else
			{
				ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("PC_CONFIRMED_DATE")) ,DATE_FORMAT));
			}
			col++;	
			row++;				
			
			reccnt ++;
			
			if (REPORT_TYPE.equals("AGREENOTICE") || REPORT_TYPE.equals("REVISED"))  //add REVISED by Peggy 20161201
			{			
				sql = " update oraddman.tsc_om_salesorderrevise_req a"+
					  " set NOTICE_PC_DATE=sysdate"+
					  " where temp_id=?"+				  
					  " and seq_id=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,rs.getString("temp_id"));
				pstmtDt.setString(2,rs.getString("seq_id"));
				pstmtDt.executeQuery();
				pstmtDt.close();
			}				  
		}	
		wwb.write(); 
		wwb.close();
	
		rs.close();
		statement.close();
		
		if (reccnt >0)
		{
			Properties props = System.getProperties();
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", "mail.ts.com.tw");
			props.put("mail.smtp.port", "25");
			
			Session s = Session.getInstance(props, null);
			javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
			message.setSentDate(new java.util.Date());
			message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
			if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
			{
				remarks="(這是來自RFQ測試區的信件)";
				message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			}
			else
			{
				remarks="";
				if (rs1.getString("plant_code").equals("002"))
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("amanda@mail.tsyew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ice@mail.tsyew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lixia.wang@mail.tsyew.com.cn"));
				}
				else if (rs1.getString("plant_code").equals("005"))
				{				
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("aggie@mail.tew.com.cn"));
				}
				else if (rs1.getString("plant_code").equals("006"))
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("esther.yang@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tin.chang@ts.com.tw"));
				}
				else if (rs1.getString("plant_code").equals("008"))
				{				
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zhangdi@mail.tew.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("outsourcingpc1@mail.tew.com.cn"));
				}
				else if (rs1.getString("plant_code").equals("010"))
				{				
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("may.huang@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nono.huang@ts.com.tw"));
				}	
				else if (rs1.getString("plant_code").equals("011"))
				{				
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("aggie@ts.com.tw"));
				}					
				else
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				}	
			}
			message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
			if (REPORT_TYPE.equals("AGREENOTICE"))
			{
				mailsubject ="工廠同意改單明細";
			}
			else if ( REPORT_TYPE.equals("REVISED"))  //add REVISED by Peggy 20161201
			{
				mailsubject ="業務改單明細";
			}
			else if ( REPORT_TYPE.equals("AUTOCONFIRM"))  //add AUTOCONFIRM by Peggy 20230512
			{
				mailsubject ="系統自動confirm業務第一次Cancel/Move明細";
			}			
			else 
			{
				mailsubject ="工廠同意但業務未改單";
			}
			message.setHeader("Subject", MimeUtility.encodeText(mailsubject+remarks, "UTF-8", null));				
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
	rs1.close();
	state1.close();	
	os.close();  
	out.close(); 
	if (REPORT_TYPE.equals("AGREENOTICE") || REPORT_TYPE.equals("REVISED"))   //add REVISED by Peggy 20161201
	{			
		con.commit();	
	}
}   
catch (Exception e) 
{ 
	if (REPORT_TYPE.equals("AGREENOTICE") || REPORT_TYPE.equals("REVISED"))   //add REVISED by Peggy 20161201
	{	
		con.rollback();		
	}	
	out.println("Exception:"+e.getMessage()); 
} 	
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
