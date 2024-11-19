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
<FORM ACTION="../jsp/TSCHSalesOrderReviseExcelNew.jsp" METHOD="post" name="MYFORM">
<%
String ACTTYPE = request.getParameter("ACTTYPE");
if (ACTTYPE==null) ACTTYPE="";
String GROUPID = request.getParameter("GROUPID");
if (GROUPID==null) GROUPID="";
String FileName="",RPTName="",sql="",remarks="";
int fontsize=8,colcnt=0,sheetcnt=0,row =0,col=0,reccnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
OutputStream os = null;	
WritableWorkbook wwb = null; 
WritableSheet ws = null;
		

try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
	
	WritableFont font_bold = null;
	WritableFont font_nobold = null;
	WritableFont font_nobold_b = null;
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBL = null;

	//英文內文水平垂直置中-粗體-格線-底色藍  
	WritableCellFormat ACenterBLB = null;
	
	//英文內文水平垂直置中-粗體-格線-底色黃  
	WritableCellFormat ACenterBLY = null;
	
	//英文內文水平垂直置中-粗體-格線-底色橘
	WritableCellFormat ACenterBLO = null;
	
	//英文內文水平垂直置中-粗體-格線-底色綠
	WritableCellFormat ACenterBLG = null;
			
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = null;

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = null;

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = null;
	
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterLB = null;

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightLB = null;

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftLB = null;
		
	//英文內文水平垂直置中-正常-格線-底色粉紅
	WritableCellFormat ACenterLP = null;
	
	//英文內文水平垂直置中-正常-格線-底色淺綠
	WritableCellFormat ACenterLG = null;

	//英文內文水平垂直置中-正常-格線-底色粉紅-藍字
	WritableCellFormat ACenterLPB = null;
	
	//英文內文水平垂直置中-正常-格線-底色淺綠-藍字
	WritableCellFormat ACenterLGB = null;
		
	//日期格式
	WritableCellFormat DATE_FORMAT = null;

	//日期格式
	WritableCellFormat DATE_FORMAT1 =null;
		
	//out.println(sheetname[i]);
	sql = "  SELECT NVL(Z.USERNAME,'PEGGY_CHEN') USERNAME ,NVL(Z.USERMAIL,'PEGGY.CHEN@ts.com.tw') USERMAIL "+
          " ,ROW_NUMBER() OVER (PARTITION BY Z.USERMAIL ORDER BY X.HK_CUSTOMER_NAME,X.HK_ORDER_NUMBER,X.ORDER_SEQ,X.LINE_SEQ) SA_SEQ"+
          " ,COUNT(1) OVER (PARTITION BY Z.USERMAIL) SA_CNT"+
		  " ,TO_CHAR(Y.CREATION_DATE,'YYYY/MM/DD') HK_ORDER_CREATION_DATE"+
		  " ,X.*"+
          " FROM (SELECT GROUP_ID"+
          ",GROUP_SEQ_ID"+
          ",HK_CUSTOMER_ID"+
          ",HK_CUSTOMER_NAME"+
          ",HK_ORDER_NUMBER"+
          ",HK_LINE_NO"+
          ",HK_HEADER_ID"+
          ",HK_LINE_ID"+
          ",HK_INVENTORY_ITEM_ID"+
          ",HK_ITEM_DESC"+
          ",HK_CUST_ITEM_ID"+
          ",HK_CUST_ITEM"+
          ",HK_CUSTOMER_PO_NUMBER"+
          ",HK_FLOW_STATUS_CODE"+
          ",TO_CHAR(HK_SSD,'YYYY/MM/DD') HK_SSD"+
          ",HK_ORDER_QTY"+
          ",TSC_END_CUSTOMER_ID"+
          ",TSC_END_CUSTOMER_NAME"+
          ",TSC_ORDER_NUMBER"+
          ",TSC_LINE_NO"+
          ",TSC_LINE_ID"+
          ",TSC_INVENTORY_ITEM_ID"+
          ",TSC_ITEM_DESC"+
          ",TSC_CUST_ITEM_ID"+
          ",TSC_CUST_ITEM"+
          ",TSC_CUSTOMER_PO_NUMBER"+
          ",TO_CHAR(TSC_SSD,'YYYY/MM/DD') TSC_SSD"+
          ",TSC_ORDER_QTY"+
          ",TSC_FLOW_STATUS_CODE"+
          ",TO_CHAR(HK_NEW_SSD,'YYYY/MM/DD') HK_NEW_SSD"+
          ",HK_NEW_ORDER_QTY"+
          ",HK_NEW_CUSTOMER_PO_NUMBER"+
          ",HK_NEW_CUST_ITEM"+
          ",HK_NEW_CUST_ITEM_ID"+
          ",SUM(TSC_ORDER_QTY) OVER (PARTITION BY HK_CUSTOMER_NAME,HK_ORDER_NUMBER,HK_LINE_NO) TSC_TOT_QTY"+
          ",ROW_NUMBER() OVER ( PARTITION BY HK_CUSTOMER_NAME,HK_ORDER_NUMBER ORDER BY TO_NUMBER(HK_LINE_NO),DECODE(HK_CUSTOMER_ID,TSC_END_CUSTOMER_ID,1,2),DECODE(HK_INVENTORY_ITEM_ID,TSC_INVENTORY_ITEM_ID,1,2),DECODE(HK_CUST_ITEM,TSC_CUST_ITEM,1,2),DECODE(TSC_FLOW_STATUS_CODE,'CLOSED',1,2),TSC_ORDER_NUMBER,TO_NUMBER(TSC_LINE_NO)) ORDER_SEQ"+
          ",COUNT(1) OVER ( PARTITION BY HK_CUSTOMER_NAME,HK_ORDER_NUMBER) ORDER_CNT"+
          ",ROW_NUMBER() OVER (PARTITION BY HK_CUSTOMER_NAME,HK_ORDER_NUMBER,HK_LINE_NO ORDER BY TO_NUMBER(HK_LINE_NO),DECODE(HK_CUSTOMER_ID,TSC_END_CUSTOMER_ID,1,2),DECODE(HK_INVENTORY_ITEM_ID,TSC_INVENTORY_ITEM_ID,1,2),DECODE(HK_CUST_ITEM,TSC_CUST_ITEM,1,2),TSC_ORDER_NUMBER,DECODE(TSC_FLOW_STATUS_CODE,'CLOSED',1,2),TSC_ORDER_NUMBER,TO_NUMBER(TSC_LINE_NO)) LINE_SEQ"+
          ",COUNT(1) OVER (PARTITION BY HK_CUSTOMER_NAME,HK_ORDER_NUMBER,HK_LINE_NO) LINE_CNT"+
          ",HK_NEW_ORDER_NUMBER"+
          ",HK_NEW_LINE_NO"+
          ",TSC_SOURCE_DOCUMENT_ID"+
          ",TSC_ORIG_SYS_DOCUMENT_REF"+
          ",TSC_SOURCE_DOCUMENT_LINE_ID"+
          ",TSC_ORIG_SYS_LINE_REF"+
          ",REVISE_FLAG"+
          ",CANCEL_FLAG"+
          ",ADD_FLAG"+
          ",REVISE_RESULT"+
          ",REMARKS"+
          " FROM ORADDMAN.TSC_OM_SALESORDERREVISE_HK a"+
          " WHERE GROUP_ID=?"+
          " AND EXISTS (SELECT 1 FROM ORADDMAN.TSC_OM_SALESORDERREVISE_HK b WHERE b.GROUP_ID=? AND b.REVISE_FLAG IN (?,?) AND b.HK_ORDER_NUMBER=a.HK_ORDER_NUMBER)"+
          " ) X"+
          ",ONT.OE_ORDER_HEADERS_ALL Y"+
		  ",(SELECT a.CUSTOMER_ID,B.USER_NAME USERNAME,B.email_address USERMAIL "+
		  " FROM TSC_OM_ORDER_PRIVILEGE a"+
		  //",ORADDMAN.WSUSER b"+
		  ",FND_USER b"+
		  " WHERE NVL(a.END_DATE_ACTIVE,TO_DATE(?,'YYYYMMDD')) > TRUNC(SYSDATE)"+
          //" AND A.RFQ_USERNAME=b.USERNAME"+
		  " AND A.USER_ID=B.USER_ID(+)"+
          " AND A.ROLE_CODE=?"+
          " AND A.ORG_ID=?) Z"+
          " WHERE X.HK_HEADER_ID=Y.HEADER_ID"+
          " AND X.REVISE_FLAG IN (?,?)"+
		  " AND X.HK_CUSTOMER_ID=Z.CUSTOMER_ID(+)"+
          //" AND X.REVISE_RESULT=?"+
          " ORDER BY Z.USERNAME,Z.USERMAIL,X.HK_CUSTOMER_NAME,X.HK_ORDER_NUMBER,X.ORDER_SEQ,X.LINE_SEQ";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,GROUPID);
	statement.setString(2,GROUPID);
	statement.setString(3,"Y");
	statement.setString(4,"X");
	statement.setString(5,"20990101");
	statement.setString(6,"SA");
	statement.setString(7,"806");
	statement.setString(8,"Y");
	statement.setString(9,"X");
	//statement.setString(7,"OK");
	ResultSet rs=statement.executeQuery();
	while (rs.next()) 
	{ 
		if (rs.getInt("SA_SEQ")==1)
		{
	
			font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
			font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
			font_nobold_b = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE);
			
			//英文內文水平垂直置中-粗體-格線-底色灰  
			ACenterBL = new WritableCellFormat(font_bold);   
			ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
			ACenterBL.setWrap(true);	
		
			//英文內文水平垂直置中-粗體-格線-底色藍  
			ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterBLB.setBackground(jxl.write.Colour.PALE_BLUE); 
			ACenterBLB.setWrap(true);
			
			//英文內文水平垂直置中-粗體-格線-底色黃  
			ACenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ACenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterBLY.setBackground(jxl.write.Colour.YELLOW); 
			ACenterBLY.setWrap(true);	
			
			//英文內文水平垂直置中-粗體-格線-底色橘
			ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
			ACenterBLO.setWrap(true);	
			
			//英文內文水平垂直置中-粗體-格線-底色綠
			ACenterBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ACenterBLG.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterBLG.setBackground(jxl.write.Colour.BRIGHT_GREEN); 
			ACenterBLG.setWrap(true);	
					
			//英文內文水平垂直置中-正常-格線   
			ACenterL = new WritableCellFormat(font_nobold);   
			ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterL.setWrap(true);
		
		
			//英文內文水平垂直置右-正常-格線   
			ARightL = new WritableCellFormat(font_nobold);   
			ARightL.setAlignment(jxl.format.Alignment.RIGHT);
			ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ARightL.setWrap(true);
		
			//英文內文水平垂直置左-正常-格線   
			ALeftL = new WritableCellFormat(font_nobold);   
			ALeftL.setAlignment(jxl.format.Alignment.LEFT);
			ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ALeftL.setWrap(true);
			
			//英文內文水平垂直置中-正常-格線   
			ACenterLB = new WritableCellFormat(font_nobold_b);   
			ACenterLB.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterLB.setWrap(true);
		
		
			//英文內文水平垂直置右-正常-格線   
			ARightLB = new WritableCellFormat(font_nobold_b);   
			ARightLB.setAlignment(jxl.format.Alignment.RIGHT);
			ARightLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ARightLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ARightLB.setWrap(true);
		
			//英文內文水平垂直置左-正常-格線   
			ALeftLB = new WritableCellFormat(font_nobold_b);   
			ALeftLB.setAlignment(jxl.format.Alignment.LEFT);
			ALeftLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ALeftLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ALeftLB.setWrap(true);
				
			//英文內文水平垂直置中-正常-格線-底色粉紅
			ACenterLP = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ACenterLP.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterLP.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterLP.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterLP.setBackground(jxl.write.Colour.PINK); 	
			ACenterLP.setWrap(true);
			
			//英文內文水平垂直置中-正常-格線-底色淺綠
			ACenterLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ACenterLG.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterLG.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
			ACenterLG.setWrap(true);	
		
			//英文內文水平垂直置中-正常-格線-底色粉紅-藍字
			ACenterLPB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
			ACenterLPB.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterLPB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterLPB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterLPB.setBackground(jxl.write.Colour.PINK); 	
			ACenterLPB.setWrap(true);
			
			//英文內文水平垂直置中-正常-格線-底色淺綠-藍字
			ACenterLGB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));   
			ACenterLGB.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterLGB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterLGB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterLGB.setBackground(jxl.write.Colour.LIGHT_GREEN); 	
			ACenterLGB.setWrap(true);	
				
			//日期格式
			DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
			DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
			DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			DATE_FORMAT.setWrap(true);
		
			//日期格式
			DATE_FORMAT1 = new WritableCellFormat(font_nobold_b ,new jxl.write.DateFormat("yyyy/MM/dd")); 
			DATE_FORMAT1.setAlignment(jxl.format.Alignment.CENTRE);
			DATE_FORMAT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			DATE_FORMAT1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			DATE_FORMAT1.setWrap(true);		
		
			row =0;col=0;reccnt=0;
			os = null;	
			RPTName = "TSCH Order Revise Report";
			FileName = RPTName+"("+rs.getString("username")+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
			os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
			wwb = Workbook.createWorkbook(os); 
			wwb.createSheet("Revise Order", 0);
			ws = null;
		
			String sheetname [] = wwb.getSheetNames();
			reccnt=0;col=0;row=0;
			ws = wwb.getSheet(sheetname[0]);
			SheetSettings sst = ws.getSettings(); 
			sst.setSelected();
			sst.setVerticalFreeze(1);  //凍結窗格
			for (int g =1 ; g <=12 ;g++ )
			{
				sst.setHorizontalFreeze(g);
			}	
			ws.addCell(new jxl.write.Label(col, row, "HK_ORDER_CREATION_DATE" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;					
	
			ws.addCell(new jxl.write.Label(col, row, "GROUP_ID" , ACenterBL));
			ws.setColumnView(col,6);	
			col++;					
				
			ws.addCell(new jxl.write.Label(col, row, "GROUP_SEQ_ID" , ACenterBL));
			ws.setColumnView(col,6);	
			col++;	
						
			ws.addCell(new jxl.write.Label(col, row, "HK_CUSTOMER_NAME" , ACenterBL));
			ws.setColumnView(col,16);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "HK_ORDER_NUMBER" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_LINE_NO" , ACenterBL));
			ws.setColumnView(col,6);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_ITEM_DESC" , ACenterBL));
			ws.setColumnView(col,16);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_CUST_ITEM" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_CUSTOMER_PO_NUMBER" , ACenterBL));
			ws.setColumnView(col,17);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_FLOW_STATUS_CODE" , ACenterBL));
			ws.setColumnView(col,18);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "HK_SSD" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;
			
			ws.addCell(new jxl.write.Label(col, row, "HK_ORDER_QTY" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;
						
			ws.addCell(new jxl.write.Label(col, row, "TSC_END_CUSTOMER_NAME" , ACenterBL));
			ws.setColumnView(col,16);	
			col++;				
			
			ws.addCell(new jxl.write.Label(col, row, "TSC_ORDER_NUMBER" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "TSC_LINE_NO" , ACenterBL));
			ws.setColumnView(col,6);	
			col++;	
				
			ws.addCell(new jxl.write.Label(col, row, "TSC_ITEM_DESC" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "TSC_CUST_ITEM" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
				
			ws.addCell(new jxl.write.Label(col, row, "TSC_CUSTOMER_PO_NUMBER" , ACenterBL));
			ws.setColumnView(col,30);	
			col++;		
	
			ws.addCell(new jxl.write.Label(col, row, "TSC_SSD " , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "TSC_ORDER_QTY" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "TSC_FLOW_STATUS_CODE" , ACenterBL));
			ws.setColumnView(col,16);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_NEW_SSD" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_NEW_ORDER_QTY" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_NEW_CUSTOMER_PO_NUMBER" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_NEW_CUST_ITEM" , ACenterBL));
			ws.setColumnView(col,16);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_NEW_ORDER_NUMBER" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "HK_NEW_LINE_NO" , ACenterBL));
			ws.setColumnView(col,7);
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "REVISE_FLAG" , ACenterBL));
			ws.setColumnView(col,6);
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "CANCEL_FLAG" , ACenterBL));
			ws.setColumnView(col,6);
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "ADD_FLAG" , ACenterBL));
			ws.setColumnView(col,6);
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "REVISE_RESULTO" , ACenterBL));
			ws.setColumnView(col,6);
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, "REMARKS" , ACenterBL));
			ws.setColumnView(col,25);
			col++;	
			row++;
		}	
		
		col=0;
		ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("HK_ORDER_CREATION_DATE")) ,DATE_FORMAT));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("GROUP_ID"),ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("GROUP_SEQ_ID"),ALeftL));
		col++;								
		ws.addCell(new jxl.write.Label(col, row, rs.getString("HK_CUSTOMER_NAME"),ALeftL));
		col++;								
		ws.addCell(new jxl.write.Label(col, row, rs.getString("HK_ORDER_NUMBER"),ALeftL));
		col++;					
		ws.addCell(new jxl.write.Label(col, row, rs.getString("HK_LINE_NO") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("HK_ITEM_DESC") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("HK_CUST_ITEM") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("HK_CUSTOMER_PO_NUMBER") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("HK_FLOW_STATUS_CODE"), ALeftL));
		col++;	
		if (rs.getString("HK_SSD")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{			
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("HK_SSD")) ,DATE_FORMAT));
		}
		col++;
		if (rs.getString("HK_ORDER_QTY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("HK_ORDER_QTY")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_END_CUSTOMER_NAME"),ALeftL));
		col++;								
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_ORDER_NUMBER"),ALeftL));
		col++;								
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_LINE_NO"),ALeftL));
		col++;								
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_ITEM_DESC"),ALeftL));
		col++;								
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_CUST_ITEM"),ALeftL));
		col++;								
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_CUSTOMER_PO_NUMBER"),ALeftL));
		col++;			
		if (rs.getString("TSC_SSD")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{								
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("TSC_SSD")) ,DATE_FORMAT));
		}
		col++;
		if (rs.getString("TSC_ORDER_QTY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TSC_ORDER_QTY")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_FLOW_STATUS_CODE"), ALeftL));
		col++;	
		if (rs.getString("HK_NEW_SSD")==null)
		{		
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("HK_NEW_SSD")) ,DATE_FORMAT));
		}
		col++;
		if (rs.getString("HK_NEW_ORDER_QTY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("HK_NEW_ORDER_QTY")).doubleValue(), ARightL));
		}
		col++;					
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("HK_NEW_CUSTOMER_PO_NUMBER")==null?"":rs.getString("HK_NEW_CUSTOMER_PO_NUMBER"))  , ALeftL));
		col++;				
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("HK_NEW_CUST_ITEM")==null?"":rs.getString("HK_NEW_CUST_ITEM"))  , ALeftL));
		col++;				
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("HK_NEW_ORDER_NUMBER")==null?"":rs.getString("HK_NEW_ORDER_NUMBER"))  , ALeftL));
		col++;				
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("HK_NEW_LINE_NO")==null?"":rs.getString("HK_NEW_LINE_NO"))  , ALeftL));
		col++;				
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("REVISE_FLAG")==null?"":rs.getString("REVISE_FLAG")) , ACenterL));
		col++;				
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CANCEL_FLAG")==null?"":rs.getString("CANCEL_FLAG")) , ACenterL));
		col++;				
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ADD_FLAG")==null?"":rs.getString("ADD_FLAG")) , ACenterL));
		col++;				
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("REVISE_RESULT")==null?"":rs.getString("REVISE_RESULT")) , ACenterL));
		col++;				
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("REMARKS")==null?"":rs.getString("REMARKS"))  , ALeftL));
		col++;				
		row++;				
		reccnt ++;
		
		if (rs.getInt("SA_SEQ")==rs.getInt("SA_CNT"))
		{
			wwb.write(); 
			wwb.close();
			
			if (!ACTTYPE.equals(""))
			{
				Properties props = System.getProperties();
				props.put("mail.transport.protocol","smtp");
				props.put("mail.smtp.host", "mail.ts.com.tw");
				props.put("mail.smtp.port", "25");
				
				Session s = Session.getInstance(props, null);
				javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
				message.setSentDate(new java.util.Date());
				message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
				if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
				{
					remarks="(這是來自RFQ測試區的信件)";
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				}
				else
				{
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs.getString("USERMAIL")));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("tschk-sample@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				}
				
				message.setHeader("Subject", MimeUtility.encodeText(FileName.replace(".xls","")+remarks, "UTF-8", null));				
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
	}	
	rs.close();
	statement.close();		

	os.close();  
	out.close(); 
	
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 	

try
{
	if (ACTTYPE.equals(""))
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
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
