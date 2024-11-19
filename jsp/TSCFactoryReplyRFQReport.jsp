<!--20171114 Peggy,add new column=>Total Pending Hours-->
<!--20171221 Peggy,TSCH-HK RFQ region code from 002 change to 018-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCFactoryReplyRFQReport.jsp" METHOD="post" name="MYFORM">
<%
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr="--";
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="--";
String DayFr=request.getParameter("DAYFR");
if (DayFr==null || DayFr.equals("--")) DayFr="01";
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo="--"; 
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="--";
String DayTo=request.getParameter("DAYTO");
if (DayTo==null || DayTo.equals("--")) DayTo=dateBean.getDayString();
String PLANTCODE= request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",sqlx="",sqly="",where="",remarks;
int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd hh24:mm:ss");
//String tot_pending_hours = "";
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,line=0,mergeCol=0;
	String column1="",column2="",column3="",column4="",column5="",mo_CRD="",mo_QTY="",mo_PRICE="",mo_SSD="";
	OutputStream os = null;	
	RPTName = "PCReplyRFQ";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	
	sql = " SELECT a.manufactory_no, a.alengname,rownum-1 row_cnt"+
          " FROM oraddman.tsprod_manufactory a"+
          " WHERE a.leadtime_flag='Y'";
   	if (PLANTCODE!=null && !PLANTCODE.equals("--") && !PLANTCODE.equals("")) 
	{
		sql +=" and a.manufactory_no ='"+PLANTCODE+"'"; 
	}		  
    sql += " ORDER BY MANUFACTORY_NO";
	Statement statement1=con.createStatement(); 
	ResultSet rs1=statement1.executeQuery(sql);
	while (rs1.next()) 
	{
		wwb.createSheet(rs1.getString("alengname")+"("+rs1.getString("manufactory_no")+")", rs1.getInt("row_cnt"));		  
	}
	rs1.close();
	statement1.close();
		
	WritableSheet ws = null;		
	//WritableSheet ws = wwb.createSheet(RPTName, 0); 
	//SheetSettings sst = ws.getSettings(); 
	//sst.setSelected();
	//sst.setVerticalFreeze(1);  //凍結窗格
	//sst.setVerticalFreeze(2);  //凍結窗格
	//for (int g =1 ; g <=7 ;g++ )
	//{
	//	sst.setHorizontalFreeze(g);
	//}
	
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
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd hh24:mm:ss")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();

	String sheetname [] = wwb.getSheetNames();
	for (int i =0 ; i < sheetname.length ; i++)
	{
		reccnt=0;col=0;row=0;
		ws = wwb.getSheet(sheetname[i]);
		SheetSettings sst = ws.getSettings(); 
		sst.setSelected();
		sst.setVerticalFreeze(1);  //凍結窗格
		sst.setVerticalFreeze(2);  //凍結窗格
		for (int g =1 ; g <=7 ;g++ )
		{
			sst.setHorizontalFreeze(g);
		}

		/*sql = " SELECT Y.TSGROUP"+
		      ",Y.CUSTOMER"+
			  ",Y.RFQNO"+
			  ",Y.LINE_NO"+
			  ",Y.ITEM_NO"+
			  ",Y.ITEM_DESC"+
			  ",Y.MANUFACTORY_NAME"+
			  ",Y.LSTATUS"+
			  ",TO_CHAR(Y.CREATION_DATE,'yyyy/mm/dd hh24:mi') CREATION_DATE"+
			  ",TO_CHAR(Y.SLOW_MOVING_CONFIRM_DATE,'yyyy/mm/dd hh24:mi') SLOW_MOVING_CONFIRM_DATE"+
			  ",TO_CHAR(Y.PC1_CONFIRM_DATE,'yyyy/mm/dd hh24:mi') PC1_CONFIRM_DATE"+
			  ",TO_CHAR(Y.PC2_CONFIRM_DATE,'yyyy/mm/dd hh24:mi') PC2_CONFIRM_DATE"+
			  ",Y.SLOW_MOVING_S_DATE"+
			  ",Y.SLOW_MOVING_E_DATE"+
			  ",Y.PC1_S_DATE"+
			  ",Y.PC1_E_DATE"+
			  ",Y.PC2_S_DATE"+
			  ",Y.PC2_E_DATE"+
			  ",ROUND((Y.SLOW_MOVING_E_DATE-CASE WHEN Y.SLOW_MOVING_S_DATE>Y.SLOW_MOVING_E_DATE THEN Y.SLOW_MOVING_E_DATE ELSE Y.SLOW_MOVING_S_DATE END-tsc_get_holiday_days(TRUNC(Y.SLOW_MOVING_S_DATE), TRUNC(Y.SLOW_MOVING_E_DATE)-1,NULL))*24,2) SLOW_MOVING_PENDING_HOURS"+
			  //",ROUND((Y.PC1_E_DATE-Y.PC1_S_DATE-tsc_get_holiday_days(Y.PC1_S_DATE, Y.PC1_E_DATE-1,NULL))*24,2) PC1_PENDING_HOURS"+
			  //",ROUND((Y.PC2_E_DATE-Y.PC2_S_DATE-tsc_get_holiday_days(Y.PC2_S_DATE, Y.PC2_E_DATE-1,NULL))*24,2) PC2_PENDING_HOURS"+
              ",ROUND((CASE WHEN tsc_get_holiday_days(TRUNC(Y.PC1_S_DATE), TRUNC(Y.PC1_E_DATE)-1,Y.MANUFACTORY_NO)= TRUNC(Y.PC1_E_DATE)-TRUNC(Y.PC1_S_DATE) AND TRUNC(Y.PC1_S_DATE)<> TRUNC(Y.PC1_E_DATE) THEN Y.PC1_E_DATE - (TRUNC(Y.PC1_E_DATE)+8/24) ELSE Y.PC1_E_DATE-Y.PC1_S_DATE-tsc_get_holiday_days(TRUNC(Y.PC1_S_DATE), TRUNC(Y.PC1_E_DATE)-1,Y.MANUFACTORY_NO) END)*24 ,2) PC1_PENDING_HOURS"+  //modify by Peggy 20191009
              ",ROUND((CASE WHEN tsc_get_holiday_days(TRUNC(Y.PC2_S_DATE), TRUNC(Y.PC2_E_DATE)-1,Y.MANUFACTORY_NO)= TRUNC(Y.PC2_E_DATE)-TRUNC(Y.PC2_S_DATE) AND TRUNC(Y.PC2_S_DATE)<> TRUNC(Y.PC2_E_DATE) THEN Y.PC2_E_DATE - (TRUNC(Y.PC2_E_DATE)+8/24) ELSE Y.PC2_E_DATE-Y.PC2_S_DATE-tsc_get_holiday_days(TRUNC(Y.PC2_S_DATE), TRUNC(Y.PC2_E_DATE)-1,Y.MANUFACTORY_NO) END)*24 ,2) PC2_PENDING_HOURS"+  //modify by Peggy 20191009
			  ",NVL(ROUND((Y.SLOW_MOVING_E_DATE-CASE WHEN Y.SLOW_MOVING_S_DATE>Y.SLOW_MOVING_E_DATE THEN Y.SLOW_MOVING_E_DATE ELSE Y.SLOW_MOVING_S_DATE END-tsc_get_holiday_days(TRUNC(Y.SLOW_MOVING_S_DATE), TRUNC(Y.SLOW_MOVING_E_DATE)-1,NULL))*24,2),0)"+
			  //"+NVL(ROUND((Y.PC1_E_DATE-Y.PC1_S_DATE-tsc_get_holiday_days(Y.PC1_S_DATE, Y.PC1_E_DATE-1,NULL))*24,2),0)+ NVL(ROUND((Y.PC2_E_DATE-Y.PC2_S_DATE-tsc_get_holiday_days(Y.PC2_S_DATE, Y.PC2_E_DATE-1,NULL))*24,2),0) as tot_pending_hours"+
              "+NVL(ROUND((CASE WHEN tsc_get_holiday_days(TRUNC(Y.PC1_S_DATE), TRUNC(Y.PC1_E_DATE)-1,Y.MANUFACTORY_NO)= TRUNC(Y.PC1_E_DATE)-TRUNC(Y.PC1_S_DATE) AND TRUNC(Y.PC1_S_DATE)<> TRUNC(Y.PC1_E_DATE) THEN Y.PC1_E_DATE - (TRUNC(Y.PC1_E_DATE)+8/24) ELSE Y.PC1_E_DATE-Y.PC1_S_DATE-tsc_get_holiday_days(TRUNC(Y.PC1_S_DATE), TRUNC(Y.PC1_E_DATE)-1,Y.MANUFACTORY_NO) END)*24 ,2),0)"+
              "+NVL(ROUND((CASE WHEN tsc_get_holiday_days(TRUNC(Y.PC2_S_DATE), TRUNC(Y.PC2_E_DATE)-1,Y.MANUFACTORY_NO)= TRUNC(Y.PC2_E_DATE)-TRUNC(Y.PC2_S_DATE) AND TRUNC(Y.PC2_S_DATE)<> TRUNC(Y.PC2_E_DATE) THEN Y.PC2_E_DATE - (TRUNC(Y.PC2_E_DATE)+8/24) ELSE Y.PC2_E_DATE-Y.PC2_S_DATE-tsc_get_holiday_days(TRUNC(Y.PC2_S_DATE), TRUNC(Y.PC2_E_DATE)-1,Y.MANUFACTORY_NO) END)*24 ,2),0) as tot_pending_hours"+  //modify by Peggy 20191009
			  " FROM (SELECT  X.TSGROUP"+
			  "       ,X.CUSTOMER"+
			  "       ,X.DNDOCNO RFQNO"+
			  "       ,X.LINE_NO"+
			  "       ,X.ITEM_NO"+
			  "       ,X.PART_NO ITEM_DESC"+
			  "       ,X.MANUFACTORY_NAME"+
			  "       ,X.LSTATUS"+
			  "       ,X.CREATION_DATE"+
			  "       ,X.SLOW_MOVING_CONFIRM_DATE"+
			  "       ,CASE WHEN TRUNC(X.CREATION_DATE)<>TRUNC(CASE WHEN X.LSTATUSID='014' THEN SYSDATE ELSE X.SLOW_MOVING_CONFIRM_DATE END ) AND TO_CHAR(X.CREATION_DATE,'HH24')>=17  THEN TRUNC(X.CREATION_DATE)+32/24 ELSE X.CREATION_DATE END SLOW_MOVING_S_DATE "+
			  "       ,CASE WHEN X.LSTATUSID='014' THEN SYSDATE ELSE X.SLOW_MOVING_CONFIRM_DATE END SLOW_MOVING_E_DATE"+
			  "       ,X.PC1_CONFIRM_DATE"+
			  "       ,CASE WHEN X.SLOW_MOVING_CONFIRM_DATE IS NULL THEN CASE WHEN TRUNC(X.CREATION_DATE)<>TRUNC(X.PC1_CONFIRM_DATE) AND TO_CHAR(X.CREATION_DATE,'HH24')>=17  THEN CASE WHEN TRUNC(X.CREATION_DATE)+32/24 > X.PC1_CONFIRM_DATE THEN X.PC1_CONFIRM_DATE ELSE TRUNC(X.CREATION_DATE)+32/24 END  ELSE X.CREATION_DATE END ELSE X.SLOW_MOVING_CONFIRM_DATE END PC1_S_DATE "+
			  "       ,CASE WHEN X.LSTATUSID='003' THEN SYSDATE ELSE X.PC1_CONFIRM_DATE END PC1_E_DATE"+
			  "       ,X.PC2_CONFIRM_DATE"+
			  "       ,X.PC1_CONFIRM_DATE AS PC2_S_DATE "+
			  "       ,CASE WHEN X.LSTATUSID='004' THEN SYSDATE ELSE X.PC2_CONFIRM_DATE END PC2_E_DATE"+
			  "       ,X.MANUFACTORY_NO"+
			  //"       FROM (SELECT CASE WHEN c.tsareano = '002' AND c.created_by = 'TSCCSZ020' THEN 'TSCH-HK' WHEN c.tsareano = '002' THEN 'TSCC-SH' ELSE a.alname END tsgroup,"+
			  "       FROM (SELECT a.alname tsgroup,"+  //modify by Peggy 20171221
			  "             c.customer,"+
			  "             c.dndocno,"+
			  "             d.line_no,"+
			  "             d.item_segment1 item_no,"+
			  "             d.item_description part_no,"+
			  "             TO_DATE (SUBSTR (d.request_date, 1, 8), 'YYYY/MM/DD') request_date,"+
			  "             CASE WHEN d.lstatusid = '014' THEN 'Slow Moving Confirm' ELSE e.manufactory_name END  manufactory_name,"+
			  "             d.lstatus,"+
			  "             TO_DATE (SUBSTR (d.creation_date, 1, 12),'YYYYMMDD hh24mi') creation_date,"+
			  "             (SELECT MAX (TO_DATE (updatedate || updatetime,'yyyymmddhh24miss')) FROM oraddman.tsdelivery_detail_history x "+
			  "             WHERE x.dndocno = d.dndocno"+
			  "             AND x.line_no = d.line_no"+
			  "             AND x.oristatusid = '014') slow_moving_confirm_date,"+
			  "             (SELECT MAX (TO_DATE (updatedate || updatetime,'yyyymmddhh24miss')) FROM oraddman.tsdelivery_detail_history x "+
			  "             WHERE x.dndocno = d.dndocno"+
			  "             AND x.line_no = d.line_no"+
			  "             AND x.oristatusid = '003') pc1_confirm_date,"+
			  "             (SELECT MAX (TO_DATE (updatedate || updatetime,'yyyymmddhh24miss')) FROM oraddman.tsdelivery_detail_history x"+
			  "             WHERE x.dndocno = d.dndocno"+
			  "             AND x.line_no = d.line_no"+
			  "             AND x.oristatusid = '004') pc2_confirm_date,"+
			  "             d.lstatusid,"+
			  "             e.manufactory_no"+
			  "             FROM oraddman.tsdelivery_notice c,"+
			  "                  oraddman.tsdelivery_notice_detail d,"+
			  "                  oraddman.tsprod_manufactory e,"+
			  "                  oraddman.tssales_area a"+
			  "             WHERE c.dndocno = d.dndocno"+
			  "             AND d.assign_manufact = e.manufactory_no(+)"+
			  "             AND SUBSTR (d.creation_date, 1, 8) BETWEEN ? AND ?"+
			  //"             AND e.manufactory_no=NVL(?,e.manufactory_no)"+
			  "             AND e.manufactory_no ='"+sheetname[i].substring(sheetname[i].indexOf("(")+1,sheetname[i].indexOf(")"))+"'"+
			  "             AND c.tsareano = a.sales_area_no"+
			  "             AND d.assign_manufact IS NOT NULL"+
			  "             AND d.assign_manufact <> 'N/A'"+
			  "             AND d.lstatusid NOT IN ('012','001')"+
			  " ) x ) Y  "+
			  " ORDER BY CREATION_DATE,Y.RFQNO,Y.LINE_NO";*/
		sql =" SELECT a.alname tsgroup,"+
             " c.customer,"+
             " c.dndocno RFQNO,"+
             " d.line_no,"+
             " d.item_segment1 item_no,"+
             " d.item_description ITEM_DESC,"+
             " TO_DATE (SUBSTR (d.request_date, 1, 8), 'YYYY/MM/DD') request_date,"+
             " CASE WHEN d.lstatusid = '014' THEN 'Slow Moving Confirm' ELSE e.manufactory_name END  manufactory_name,"+
             " d.lstatus,"+
             " TO_DATE (SUBSTR (d.creation_date, 1, 12),'YYYYMMDD hh24mi') creation_date,"+
             " d.lstatusid,"+
             " e.manufactory_no,"+
             " ped.*"+
  		     ",nvl(ped.pc1_pending_hours,0)+nvl(ped.pc2_pending_hours,0) tot_pending_hours "+
             " FROM oraddman.tsdelivery_notice c,"+
             "      oraddman.tsdelivery_notice_detail d,"+
             "      oraddman.tsprod_manufactory e,"+
             "      oraddman.tssales_area a,"+
             "      table(tsc_rfq_create_erp_odr_pkg.rfq_pending_info(d.dndocno,d.line_no))  ped"+
             " WHERE c.dndocno = d.dndocno(+)"+
             " AND d.assign_manufact = e.manufactory_no(+)"+
             " AND SUBSTR (d.creation_date, 1, 8) BETWEEN ? AND ?"+
			 " AND e.manufactory_no ='"+sheetname[i].substring(sheetname[i].indexOf("(")+1,sheetname[i].indexOf(")"))+"'"+
			 " AND c.tsareano = a.sales_area_no"+
			 " AND d.assign_manufact IS NOT NULL"+
			 " AND d.assign_manufact <> 'N/A'"+
			 " AND d.lstatusid NOT IN ('012','001')"+
			 " ORDER BY d.CREATION_DATE,c.dndocno,d.line_no";
		//out.println(sql);
		//out.println(YearFr+MonthFr+DayFr);
		//out.println(YearTo+MonthTo+DayTo);
		//out.println(PLANTCODE);
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,YearFr+MonthFr+DayFr);
		statement.setString(2,YearTo+MonthTo+DayTo);
		//statement.setString(3,PLANTCODE);
		ResultSet rs=statement.executeQuery();	
		while (rs.next()) 
		{ 	
			if (reccnt==0)
			{
				col=0;row=0;
				
				//資料日期
				ws.mergeCells(col, row, col+2, row);     
				ws.addCell(new jxl.write.Label(col, row, "Date:" +YearFr+"/"+MonthFr+"/"+DayFr+"~"+YearTo+"/"+MonthTo+"/"+DayTo, LeftBLY));
				row++;
							
				//業務區
				ws.addCell(new jxl.write.Label(col, row, "Sales Region" , ACenterBLB));
				ws.setColumnView(col,12);	
				col++;	
				
				//客戶
				ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLB));
				ws.setColumnView(col,35);	
				col++;
	
				//RFQ
				ws.addCell(new jxl.write.Label(col, row, "RFQ" , ACenterBLB));
				ws.setColumnView(col,18);	
				col++;
	
				//LINE NO
				ws.addCell(new jxl.write.Label(col, row, "Line No" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;
				
				//料號
				ws.addCell(new jxl.write.Label(col, row, "Item Name" , ACenterBLB));
				ws.setColumnView(col,24);	
				col++;	
	
				//型號
				ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBLB));
				ws.setColumnView(col,24);	
				col++;	
	
				//工廠別
				ws.addCell(new jxl.write.Label(col, row, "Manufactory" , ACenterBLB));
				ws.setColumnView(col,20);	
				col++;	
	
				//狀態
				ws.addCell(new jxl.write.Label(col, row, "Status" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;	
	
				//開單日期
				ws.addCell(new jxl.write.Label(col, row, "Creation Date" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	
	
				//Slow Moving Confirm Date
				ws.addCell(new jxl.write.Label(col, row, "Slow Moving Confirm Date" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	
	
				//Slow Moving Pending Hours
				ws.addCell(new jxl.write.Label(col, row, "Slow Moving Pending Hours" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;
	
				//PC1 confirm date
				ws.addCell(new jxl.write.Label(col, row, "PC1 Confirm Date" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;
	
				//PC1 Pending Hours
				ws.addCell(new jxl.write.Label(col, row, "PC1 Pending Hours" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	
	
				//PC2 Confirm date
				ws.addCell(new jxl.write.Label(col, row, "PC2 Confirm Date" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;		
	
				//PC2 Pending Hours
				ws.addCell(new jxl.write.Label(col, row, "PC2 Pending Hours" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;	
				
				//Total Pending Hours,add by Peggy 20171114
				ws.addCell(new jxl.write.Label(col, row, "Total Pending Hours" , ACenterBLB));
				ws.setColumnView(col,15);	
				col++;				
				row++;
			}
			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSGROUP"), ACenterL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER"), ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("RFQNO") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NO") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("MANUFACTORY_NAME") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LSTATUS") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATION_DATE") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SLOW_MOVING_CONFIRM_DATE") , ALeftL));
			col++;	
			if (rs.getString("SLOW_MOVING_PENDING_HOURS")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SLOW_MOVING_PENDING_HOURS")).doubleValue(), ARightL));
			}
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PC1_CONFIRM_DATE") , ALeftL));
			col++;			
			if (rs.getString("PC1_PENDING_HOURS")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PC1_PENDING_HOURS")).doubleValue(), ARightL));
			}
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PC2_CONFIRM_DATE") , ALeftL));
			col++;			
			if (rs.getString("PC2_PENDING_HOURS")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PC2_PENDING_HOURS")).doubleValue(), ARightL));
			}
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("tot_pending_hours")).doubleValue(), ARightL));
			col++;							
			row++;
			reccnt++;
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
	String strURL = "/oradds/report/"+FileName; 
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
