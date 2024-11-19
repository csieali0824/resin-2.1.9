<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,java.lang.*"%>
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
<FORM ACTION="../jsp/TSCSGShipCommissionDetailExcel.jsp" METHOD="post" name="MYFORM">
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String FileName="",RPTName="",sql="",remarks="";
int fontsize=8,colcnt=0,sheetcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0,idx=0;
	OutputStream os = null;	
	RPTName = "TEW Ship Commission Detail";
	FileName = RPTName+"("+SDATE+(!EDATE.equals("")&&!EDATE.equals(SDATE)?"-"+EDATE:"")+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);

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
	
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = null;
	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
	//sql = " SELECT A.* ,a.UNIT_PRICE * a.SHIPPED_QTY amt"+
    //      ",to_char(a.TRANSACTION_DATE,'yyyy/mm/dd') receive_date,to_char(a.SHIP_DATE,'yyyy/mm/dd') mo_ship_date "+
    //      ",row_number() over (order by 6,1,4,9,10,12 desc) seq_num"+
    //      " FROM TABLE(TSSG_SHIP_PKG.SG_SHIP_RCV_VIEW('"+((!ORGCODE.equals("--") && !ORGCODE.equals(""))?ORGCODE:"")+"','"+SDATE+"','"+EDATE+"')) A"+
    //      " order by 6,1,26,4,9,10,12 DESC";
	sql = " SELECT TO_CHAR(TPCH.PICK_CONFIRM_DATE,'YYYY/MM') YYMM"+
	      " ,TO_CHAR(TSO.LAST_UPDATE_DATE,'YYYY/MM/DD') RECEIVE_DATE"+
		  " ,TSO.ORGANIZATION_ID"+
		  " ,TSO.VENDOR_SITE_ID"+
		  " ,TSO.VENDOR_SITE_CODE"+
		  " ,TSO.RECEIPT_NUM"+
		  " ,TSO.ITEM_NAME"+
		  " ,TSO.ITEM_DESC"+
		  " ,TSO.LOT_NUMBER"+
		  " ,TSO.DATE_CODE"+
		  " ,PLA.UNIT_PRICE"+
		  " ,SUM(TPCL.QTY)/CASE PLA.UNIT_MEAS_LOOKUP_CODE WHEN 'KPC' THEN 1000 ELSE 1 END QTY"+
		  " ,PLA.UNIT_PRICE * SUM(TPCL.QTY)/CASE PLA.UNIT_MEAS_LOOKUP_CODE WHEN 'KPC' THEN 1000 ELSE 1 END AMT"+
		  " ,TADH.INVOICE_NO"+
		  " ,TPCL.SO_NO"+
		  " ,TO_CHAR(TPCH.PICK_CONFIRM_DATE,'YYYY/MM/DD') MO_SHIP_DATE"+
		  " ,TSO.REMARKS"+
          " FROM TSC_PICK_CONFIRM_HEADERS TPCH"+
          " ,TSC_PICK_CONFIRM_LINES TPCL"+
          " ,(SELECT NVL(B.ORGANIZATION_ID,A.ORGANIZATION_ID) ORGANIZATION_ID,NVL(B.VENDOR_SITE_ID,A.VENDOR_SITE_ID) VENDOR_SITE_ID,NVL(B.VENDOR_SITE_CODE,A.VENDOR_SITE_CODE) VENDOR_SITE_CODE"+
          " ,NVL(B.RECEIPT_NUM,A.RECEIPT_NUM) RECEIPT_NUM,NVL(B.PO_LINE_LOCATION_ID,A.PO_LINE_LOCATION_ID) PO_LINE_LOCATION_ID"+
          " ,NVL(B.CREATION_DATE,A.LAST_UPDATE_DATE) LAST_UPDATE_DATE"+
          " ,A.SG_STOCK_ID,A.LOT_NUMBER,A.DATE_CODE,A.ITEM_NAME,A.ITEM_DESC"+
          " ,CASE WHEN NVL(A.FROM_SG_STOCK_ID,0) >0 THEN TO_CHAR(A.CREATION_DATE,'YYYY/MM/DD') || CASE B.ORGANIZATION_ID WHEN 907 THEN '內銷' WHEN 908 THEN '外銷' ELSE  TO_CHAR(B.ORGANIZATION_ID) END ||'轉'|| CASE A.ORGANIZATION_ID WHEN 907 THEN '內銷' WHEN 908 THEN '外銷' ELSE  TO_CHAR(A.ORGANIZATION_ID) END ELSE '' END REMARKS"+
          " FROM ORADDMAN.TSSG_STOCK_OVERVIEW A,ORADDMAN.TSSG_STOCK_OVERVIEW B WHERE A.FROM_SG_STOCK_ID=B.SG_STOCK_ID(+)) TSO"+
          " ,(SELECT ADVISE_HEADER_ID,INVOICE_NO FROM TSC_ADVISE_DN_HEADER_INT X WHERE X.STATUS='S') TADH"+
          " ,PO_LINE_LOCATIONS_ALL PLLA"+
          " ,PO_LINES_ALL PLA"+
          " WHERE TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID"+
          " AND TPCL.ORGANIZATION_ID IN (907,908)";
	if (!ORGCODE.equals(""))
	{
		sql += " AND TPCL.ORGANIZATION_ID="+ORGCODE+"";
	}
			  
    sql += " AND TPCH.PICK_CONFIRM_DATE BETWEEN to_date('"+SDATE+"','yyyymmdd') AND to_date('"+EDATE+"','yyyymmdd')+0.99999"+
          " AND TPCL.SG_STOCK_ID=TSO.SG_STOCK_ID"+
          " AND TSO.PO_LINE_LOCATION_ID=PLLA.LINE_LOCATION_ID"+
          " AND PLLA.PO_LINE_ID=PLA.PO_LINE_ID"+
          " AND TPCH.ADVISE_HEADER_ID=TADH.ADVISE_HEADER_ID"+
          " GROUP BY TO_CHAR(TPCH.PICK_CONFIRM_DATE,'YYYY/MM'),TO_CHAR(TSO.LAST_UPDATE_DATE,'YYYY/MM/DD') ,TSO.ORGANIZATION_ID,TSO.VENDOR_SITE_ID,TSO.VENDOR_SITE_CODE,TSO.RECEIPT_NUM,TSO.ITEM_NAME,TSO.ITEM_DESC,TSO.LOT_NUMBER,TSO.DATE_CODE,PLA.UNIT_PRICE,TADH.INVOICE_NO,TPCL.SO_NO,TO_CHAR(TPCH.PICK_CONFIRM_DATE,'YYYY/MM/DD'),TSO.REMARKS,PLA.UNIT_MEAS_LOOKUP_CODE"+
          " ORDER BY TSO.VENDOR_SITE_CODE,TO_CHAR(TSO.LAST_UPDATE_DATE,'YYYY/MM/DD'), TSO.ITEM_NAME,TSO.LOT_NUMBER";

	Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
	ResultSet rs=statement.executeQuery(sql);
	int sheet_cnt =0;
	while (rs.next())
	{
		if (reccnt==0)
		{
			wwb.createSheet("sheet1", sheet_cnt);
			ws = wwb.getSheet("sheet1");
			sheet_cnt++;
			col=0;row=0;
			
			//項次
			ws.addCell(new jxl.write.Label(col, row, "項次" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;					
	
			//廠商
			ws.addCell(new jxl.write.Label(col, row, "廠商" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;					

			//驗收日
			ws.addCell(new jxl.write.Label(col, row, "驗收日" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
			
			//驗收單號
			ws.addCell(new jxl.write.Label(col, row, "驗收單號" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;				

			//TSC料號
			ws.addCell(new jxl.write.Label(col, row, "TSC料號" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;				

			//數量(K)
			ws.addCell(new jxl.write.Label(col, row, "數量(K)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;				

			//單價(未稅)
			ws.addCell(new jxl.write.Label(col, row, "單價(未稅)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;				

			//總價(未稅)
			ws.addCell(new jxl.write.Label(col, row, "總價(未稅)" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;				

			//批號
			ws.addCell(new jxl.write.Label(col, row, "批號" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;				

			//Date code
			ws.addCell(new jxl.write.Label(col, row, "Date Code" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;				

			//發票號
			ws.addCell(new jxl.write.Label(col, row, "發票號" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;				

			//訂單號碼
			ws.addCell(new jxl.write.Label(col, row, "訂單號碼" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;				

			//出庫日
			ws.addCell(new jxl.write.Label(col, row, "出庫日" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;				

			//備註
			ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;	
			row++;			
		}
		reccnt ++;
		col=0;
		
		//項次
		//ws.addCell(new jxl.write.Label(col, row, rs.getString("seq_num"), ALeftL));
		ws.addCell(new jxl.write.Label(col, row, ""+row, ALeftL));
		col++;
		//廠商
		ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_SITE_CODE"), ALeftL));
		col++;
		//驗收日
		if (rs.getString("RECEIVE_DATE")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("RECEIVE_DATE")) ,DATE_FORMAT));
		}			
		col++;
		//驗收單號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIPT_NUM"), ALeftL));
		col++;
		//TSC料號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"), ALeftL));
		col++;
		//數量(K)
		if (rs.getString("QTY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("QTY")).doubleValue(), ARightL));
		}
		col++;			
		//單價(未稅)
		if (rs.getString("UNIT_PRICE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("UNIT_PRICE")).doubleValue(), ARightL));
		}
		col++;			
		//總價(未稅)
		if (rs.getString("AMT")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("AMT")).doubleValue(), ARightL));
		}
		col++;				
		//批號
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER"),ALeftL));
		col++;					
		//Date Code
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE"),ALeftL));
		col++;					
		//發票號
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INVOICE_NO")==null?"":rs.getString("INVOICE_NO")),ALeftL));
		col++;					
		//訂單號碼
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SO_NO")==null?"":rs.getString("SO_NO")),ALeftL));
		col++;					
		//出貨日
		if (rs.getString("mo_ship_date")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("mo_ship_date")) ,DATE_FORMAT));
		}		
		col++;				
		//備註
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("REMARKS")==null?"":rs.getString("REMARKS")),ALeftL));
		col++;	
		row++;
		
	}
	rs.close();
	statement.close();	
	
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
