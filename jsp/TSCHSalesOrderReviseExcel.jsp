<!-- 20160517 by Peggy,簡稱不使用 Name Pronuncication ,改採用 Account Description-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
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
<FORM ACTION="../jsp/TSCHSalesOrderReviseExcel.jsp" METHOD="post" name="MYFORM">
<%
String sql = "",request_no="";
String TEMP_ID=request.getParameter("TEMP_ID");
if (TEMP_ID ==null) TEMP_ID="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String TSCH_MO=request.getParameter("TSCH_MO");
if (TSCH_MO==null) TSCH_MO="";
String TSC_MO=request.getParameter("TSC_MO");
if (TSC_MO==null) TSC_MO="";
String CREATEDBY=request.getParameter("CREATEDBY");
if (CREATEDBY==null) CREATEDBY="";
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String CUST_PARTNO = request.getParameter("CUST_PARTNO");
if (CUST_PARTNO==null) CUST_PARTNO="";
String CUSTOMER_PO = request.getParameter("CUSTOMER_PO");
if (CUSTOMER_PO==null) CUSTOMER_PO="";
String FileName="",RPTName="",seq_id="",tempid="";
int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TH Order Revise Overview("+UserName+")";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//WritableSheet ws = wwb.createSheet(RPTName, 0); 
	wwb.createSheet(RPTName, 0);
	WritableSheet ws = null;

	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold_b = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE);
	
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

	//英文內文水平垂直置中-正常-格線-底色粉紅-藍字
	WritableCellFormat ACenterLPB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLPB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLPB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLPB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLPB.setBackground(jxl.write.Colour.PINK); 	
	ACenterLPB.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線-底色淺綠-藍字
	WritableCellFormat ACenterLGB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
	ACenterLGB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLGB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLGB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLGB.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
	ACenterLGB.setWrap(true);	
		
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
	
	sql = " select a.REQUEST_NO"+
	      ",a.TEMP_ID"+
		  ",a.SEQ_ID"+
		  ",a.SO_NO"+
		  ",a.LINE_NO"+
		  ",c.customer_number"+
		  //",nvl(c.CUSTOMER_NAME_PHONETIC,c.customer_name) customer_name"+
          ",NVL(HCA.ACCOUNT_NAME,c.CUSTOMER_NAME) customer_name"+  //modify by Peggy 20160517		  
          ",a.SOURCE_ITEM_DESC"+
		  ",a.SOURCE_CUST_ITEM_NAME"+
		  ",a.SOURCE_CUSTOMER_PO"+
		  ",a.SOURCE_SO_QTY"+
		  ",to_char(a.SOURCE_SSD,'yyyy/mm/dd') SOURCE_SSD"+
          ",nvl(a.SO_QTY,a.SOURCE_SO_QTY) SO_QTY"+
		  ",to_char(nvl(a.SCHEDULE_SHIP_DATE,a.SOURCE_SSD),'yyyy/mm/dd') SCHEDULE_SHIP_DATE"+
		  ",b.REQUEST_NO TSC_REQUEST_NO"+
		  ",b.TEMP_ID TSC_TEMP_ID"+
          ",b.SEQ_ID TSC_SEQ_ID"+
		  ",b.SO_NO TSC_SO_NO"+
		  ",b.LINE_NO TSC_LINE_NO"+
          ",b.SOURCE_ITEM_DESC SOURCE_TSC_ITEM_DESC"+
		  ",B.SOURCE_CUST_ITEM_NAME SOURCE_TSC_CUST_ITEM_NAME"+
          ",b.SOURCE_CUSTOMER_PO SOURCE_TSC_CUSTOMER_PO"+
		  ",b.SOURCE_SO_QTY SOURCE_TSC_SO_QTY"+
		  ",to_char(b.SOURCE_SSD,'yyyy/mm/dd') SOURCE_TSC_SSD"+
          ",nvl(b.SO_QTY,b.SOURCE_SO_QTY) TSC_SO_QTY"+
		  ",to_char(nvl(b.SCHEDULE_SHIP_DATE,b.SOURCE_SSD),'yyyy/mm/dd') TSC_SCHEDULE_SHIP_DATE"+
		  ",a.CREATED_BY"+
		  ",to_char(a.CREATION_DATE,'yyyymmdd') CREATION_DATE"+
		  ",a.STATUS"+
		  ",row_number() over (partition by a.TEMP_ID,a.SEQ_ID ORDER BY b.seq_id) TSC_ORDER_CNT"+ 
          " from oraddman.tsc_om_salesorderrevise_tsch a"+
		  ",oraddman.tsc_om_salesorderrevise_req b"+
		  ",ar_customers c"+
		  ",HZ_CUST_ACCOUNTS HCA"+
          " where a.temp_id=b.tsch_temp_id"+
          " and a.seq_id=b.tsch_seq_id"+
		  " AND c.CUSTOMER_ID=HCA.CUST_ACCOUNT_ID"+ //add by Peggy 20160517
          " and a.SOURCE_CUSTOMER_ID=c.customer_id";
	if (!UserRoles.equals("admin") && !UserName.toUpperCase().equals("COCO"))
	{
		sql += " AND EXISTS (SELECT 1 FROM TSC_OM_ORDER_PRIVILEGE X WHERE X.RFQ_USERNAME='"+UserName+"' AND X.CUSTOMER_ID=A.SOURCE_CUSTOMER_ID AND X.ORG_ID=A.ORG_ID)";
	}		  
	if (!CUST.equals(""))
	{
		//sql += " and nvl(c.CUSTOMER_NAME_PHONETIC,c.customer_name) like '"+CUST+"%'";
		sql += " and nvl(HCA.ACCOUNT_NAME,c.customer_name) like '"+CUST+"%'";
	}
	if (!ITEMDESC.equals(""))
	{
		sql += " and a.SOURCE_ITEM_DESC like '"+ITEMDESC+"%'";
	}
	if (!CUST_PARTNO.equals(""))
	{
		sql += " and a.SOURCE_CUST_ITEM_NAME like '"+CUST_PARTNO+"%'";
	}	
	if (!CUSTOMER_PO.equals(""))
	{
		sql += " and a.SOURCE_CUSTOMER_PO like '"+CUSTOMER_PO+"%'";
	}	
	if (!CREATEDBY.equals("") && !CREATEDBY.equals("--"))
	{
		sql += " and a.CREATED_BY ='"+CREATEDBY+"'";
	}
	if (!TSCH_MO.equals(""))
	{
		sql += " and a.SO_NO LIKE '"+TSCH_MO+"%'";
	}
	if (!TSC_MO.equals(""))
	{
		sql += " and b.SO_NO LIKE '"+TSC_MO+"%'";
	}
	if (!STATUS.equals("") && !STATUS.equals("--"))
	{
		sql += " and a.STATUS = '"+STATUS+"'";
	}	
	if (!SDATE.equals("") || !EDATE.equals(""))
	{
		sql += " and a.CREATION_DATE  BETWEEN TO_DATE('"+(SDATE.equals("")?"20150101":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?dateBean.getYearMonthDay():EDATE)+"','yyyymmdd')+0.99999";
	}	
	if (!REQUESTNO.equals(""))
	{
		sql += " and a.REQUEST_NO='"+ REQUESTNO+"'";
	}
	sql += "  order by a.request_no,a.so_no,a.line_no";

	//out.println(sql);
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
			sst.setVerticalFreeze(1);  //凍結窗格
			for (int g =1 ; g <=7 ;g++ )
			{
				sst.setHorizontalFreeze(g);
			}	
			//申請單號
			ws.addCell(new jxl.write.Label(col, row, "Request No" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;					

			//Customer
			ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;					
				
			//TSCH MO#
			ws.addCell(new jxl.write.Label(col, row, "TSCH MO#" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	
						
			//TSCH MO Line#
			ws.addCell(new jxl.write.Label(col, row, "TSCH Line#" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;	

			//TSC Part No
			ws.addCell(new jxl.write.Label(col, row, "TSC Part No" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	

			//Cust Part No
			ws.addCell(new jxl.write.Label(col, row, "Cust Part No" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;	

			//Cust PO
			ws.addCell(new jxl.write.Label(col, row, "Cust PO" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;	

			//Orig Qty
			ws.addCell(new jxl.write.Label(col, row, "Orig Qty" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	

			//New Qty
			ws.addCell(new jxl.write.Label(col, row, "New Qty" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	

			//Orig SSD
			ws.addCell(new jxl.write.Label(col, row, "Orig SSD" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	

			//New SSD
			ws.addCell(new jxl.write.Label(col, row, "New SSD" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	

			//Request No
			ws.addCell(new jxl.write.Label(col, row, "TSC Request No" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//TSC MO#
			ws.addCell(new jxl.write.Label(col, row, "TSC MO#" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//TSC Line#
			ws.addCell(new jxl.write.Label(col, row, "TSC Line#" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//Orig Qty
			ws.addCell(new jxl.write.Label(col, row, "TSC Orig Qty" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//New Qty
			ws.addCell(new jxl.write.Label(col, row, "TSC New Qty" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//Orig SSD
			ws.addCell(new jxl.write.Label(col, row, "TSC Orig SSD" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;					

			//New SSD
			ws.addCell(new jxl.write.Label(col, row, "TSC New SSD" ,ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Status
			ws.addCell(new jxl.write.Label(col, row, "Status" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	

			//Requested by
			ws.addCell(new jxl.write.Label(col, row, "Requested by" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;
			
			//Request Date
			ws.addCell(new jxl.write.Label(col, row, "Request Date" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			row++;
		}
		col=0;
		if (!rs.getString("temp_id").equals(tempid) || !rs.getString("seq_id").equals(seq_id))
		{
			tempid=rs.getString("temp_id");
			seq_id=rs.getString("seq_id");

			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_NO"), ACenterL));
			col++;					
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Label(col, row, "("+rs.getString("CUSTOMER_NUMBER")+")"+rs.getString("CUSTOMER_NAME"), ALeftL));
			col++;					
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO"), ACenterL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LINE_NO"), ACenterL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SOURCE_ITEM_DESC"), ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SOURCE_CUST_ITEM_NAME"), ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SOURCE_CUSTOMER_PO"), ALeftL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SOURCE_SO_QTY")).doubleValue(), ARightL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SO_QTY")).doubleValue(), ARightL));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SOURCE_SSD")) ,DATE_FORMAT));
			col++;	
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_REQUEST_NO"), ACenterL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_SO_NO"), ACenterL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_LINE_NO"), ACenterL));
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SOURCE_TSC_SO_QTY")).doubleValue(), ARightL));
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TSC_SO_QTY")).doubleValue(), ARightL));
			col++;	
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SOURCE_TSC_SSD")) ,DATE_FORMAT));
			col++;	
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("TSC_SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
			col++;	
			
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("status") , ALeftL));
			col++;
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATED_BY") , ALeftL));
			col++;
			ws.mergeCells(col, row, col, row+rs.getInt("TSC_ORDER_CNT")-1); 	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATION_DATE") , ALeftL));
			col++;
		}
		else
		{
			col+=11;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_REQUEST_NO"), ACenterL));
			col++;					
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_SO_NO"), ACenterL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_LINE_NO"), ACenterL));
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SOURCE_TSC_SO_QTY")).doubleValue(), ARightL));
			col++;	
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TSC_SO_QTY")).doubleValue(), ARightL));
			col++;	
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("SOURCE_TSC_SSD")) ,DATE_FORMAT));
			col++;	
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("TSC_SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
			col++;	
		}			
		row++;	
		reccnt ++;
	}	
	wwb.write(); 
	wwb.close();

	rs.close();
	statement.close();

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
