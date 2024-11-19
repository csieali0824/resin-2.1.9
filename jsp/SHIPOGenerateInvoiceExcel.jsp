<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*" %>
<%@ page import="DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/RepInfQuery2Excel.jsp" METHOD="post" name="MYFORM">
<%
  //String RepLocale=(String)session.getAttribute("LOCALE");  // 改抓Session內的登入資料
  //String UserID=request.getParameter("USERID");             // 改抓Session內的登入資料
  String sqlGlobal = request.getParameter("SQLGLOBAL");

  String invoiceNo=request.getParameter("INVOICENO");
 
  String dateStringBegin=request.getParameter("DATEBEGIN");
  String dateStringEnd=request.getParameter("DATEEND");  
  
  String RepNo=request.getParameter("REPNO");
  String IMEI=request.getParameter("IMEI");
  
  
  String SWHERE=request.getParameter("SWHERECOND");
 
  if (dateStringBegin==null){dateStringBegin=dateBean.getYearMonthDay();}
  if (dateStringEnd==null){dateStringEnd=dateBean.getYearMonthDay();}

  String ymdCurr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
  String hmsCurr = dateBean.getHourMinuteSecond();
  
  String strHMSec = request.getParameter("HOURTIME");
  
  
  
  
 
  
 try 
    { 	
	
	 String orderBy = "";
	 	    
	 String invOf="";
	 String invNote = "";
	 String vndInvNo = "";
	 String shippedPer = "";
	 String sailingAB = "";
	 String invDate = "";
	 String shippedFm = "";
	 String shippedTo = "";
	 String totQty = "";
	 String totAmount = "";
	 String shipTo = "";
	 String invtoTel = "";
	 String invtoFax = "";
	 String cust = "";
	 String tradeTerm = "";
	 String currency = "";
	 String iprodNo = "";
	 String poNo = "";
	 String orgCountry = "";
	 String poEcst = "";
	 String qty =""; 
     String amount ="";
	 String pamentTerm ="";
     String vndAlph ="";    

     String sql =  "select a.INVOF, a.INVNOTE, a.VNDINV_NO, a.SHIPPED_PER, a.SAILING_AB, a.INVDATE, a.SHIPPED_FM, a.SHIPPED_TO, a.REMH, "+
                     "a.QUANTITY, a.TOTAMOUNT, a.INVTO_HD, a.SHIPTO, a.INVTO, a.INVTO_TEL, a.INVTO_FAX, a.CUST, a.TRADE_TERM, a.CURR, "+
                     "a.PAYMENT_TERM, a.VNALPH, a.SHIPTO_TEL, a.SHIPTO_FAX "+     
			         "from IPOINV_H a ";
	 String sWhere = "where a.INVH = '"+invoiceNo+"' ";

     sql = sql + sWhere; out.println(sql);   

	 String sqlTC =  "select a.INVOF, a.INVNOTE, a.VNDINV_NO, a.SHIPPED_PER, a.SAILING_AB, a.INVDATE, a.SHIPPED_FM, a.SHIPPED_TO, a.REMH, "+
                     "a.QUANTITY, a.TOTAMOUNT, a.INVTO_HD, a.SHIPTO, a.INVTO, a.INVTO_TEL, a.INVTO_FAX, a.CUST, a.TRADE_TERM, a.CURR, "+
                     "b.IPRODNO, b.PORD, b.PLINE, b.ORG_COUNTRY, b.PO_ECST, b.QTY, b.AMOUNT, a.PAYMENT_TERM, a.VNALPH, a.SHIPTO_TEL, a.SHIPTO_FAX "+     
			         "from IPOINV_H a, IPOINV_D b ";
	 String sWhereTC = "where a.HID= 'HO' and b.DID='DO' and a.INVH=b.INVD and a.VNDINV_NO=b.VNDINV_NO and a.VENDOR = b.VENDOR  "+
                       "and a.INVH = '"+invoiceNo+"' ";
	 //sWhere = "where RECDATE between '20031103' and  '20031103'  ";
			   
	 orderBy =  "order by b.PORD, b.PLINE ";
	
     sqlTC = sqlTC + sWhereTC + orderBy;               

	 out.println(sqlTC);
		
	out.println("Step0");
	
	// 產生報表
	OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\wins\\report\\"+userID+"_"+ymdCurr+hmsCurr+"_"+invoiceNo+".xls"); 	
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("Invoice", 0);
    /*               */
    out.println("Step1a");
    // 抬頭列字型15
	jxl.write.WritableFont wf2Title = new jxl.write.WritableFont(WritableFont.TIMES, 15, WritableFont.BOLD, false, UnderlineStyle.SINGLE); 
    jxl.write.WritableCellFormat wcf2Title = new jxl.write.WritableCellFormat(wf2Title); 
	wcf2Title.setBorder(jxl.format.Border.NONE,jxl.format.BorderLineStyle.THIN); 
    wcf2Title.setAlignment(jxl.format.Alignment.CENTRE); 
    // 條件列字型12
    jxl.write.WritableFont wf2Cond = new jxl.write.WritableFont(WritableFont.TIMES, 12, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Cond = new jxl.write.WritableCellFormat(wf2Cond); 
	wcf2Cond.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    // Header 列背景灰色
    jxl.write.WritableFont wf2Header = new jxl.write.WritableFont(WritableFont.TIMES, 12, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(wf2Header); 
	wcf2Header.setBorder(jxl.format.Border.NONE,jxl.format.BorderLineStyle.THIN);
    //wcf2Header.setShrinkToFit(true); // 字會縮的與儲存格一樣小
    //wcf2Header.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色
    // 內容 列 定義
    jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
	wcf2Content.setBorder(jxl.format.Border.NONE,jxl.format.BorderLineStyle.THIN);
    //wcf2Content.setBackground(jxl.format.Colour.GRAY_25); // 
	  
    jxl.write.WritableFont wfLeftBorder = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcfLeftBorder = new jxl.write.WritableCellFormat(wfLeftBorder); 
	wcfLeftBorder.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.THIN);
    wcfLeftBorder.setAlignment(jxl.format.Alignment.CENTRE); 

    jxl.write.WritableFont wfLeftAB = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcfLeftAB = new jxl.write.WritableCellFormat(wfLeftAB); 
	wcfLeftAB.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.THIN);
    wcfLeftAB.setAlignment(jxl.format.Alignment.LEFT);

    jxl.write.WritableFont wfLBBorder = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcfLBBorder = new jxl.write.WritableCellFormat(wfLBBorder); 
	wcfLBBorder.setBorder(jxl.format.Border.ALL ,jxl.format.BorderLineStyle.THIN);    
    wcfLBBorder.setAlignment(jxl.format.Alignment.CENTRE);               
    wcfLBBorder.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);

    jxl.write.WritableFont wfRightBorder = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcfRightBorder = new jxl.write.WritableCellFormat(wfRightBorder); 
	wcfRightBorder.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.THIN);  

    jxl.write.WritableFont wfLABUD = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.SINGLE); 
    jxl.write.WritableCellFormat wcfLABUD = new jxl.write.WritableCellFormat(wfLABUD); 
	wcfLABUD.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.THIN); 
    wcfLABUD.setAlignment(jxl.format.Alignment.LEFT);

    jxl.write.WritableFont wfLABD = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfLABD = new jxl.write.WritableCellFormat(wfLABD); 
	wcfLABD.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.THIN); 
    wcfLABD.setAlignment(jxl.format.Alignment.LEFT);     

    jxl.write.WritableFont wfLBUD = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false, UnderlineStyle.SINGLE); 
    jxl.write.WritableCellFormat wcfLBUD = new jxl.write.WritableCellFormat(wfLBUD); 
	wcfLBUD.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.THIN); 
    wcfLBUD.setAlignment(jxl.format.Alignment.CENTRE);  

    jxl.write.WritableFont wfUBUD = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfUBUD = new jxl.write.WritableCellFormat(wfUBUD); 
	wcfUBUD.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN); 
    wcfUBUD.setAlignment(jxl.format.Alignment.LEFT);

    jxl.write.WritableFont wfBOLA = new jxl.write.WritableFont(WritableFont.TIMES, 16, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfBOLA = new jxl.write.WritableCellFormat(wfBOLA); 
	wcfBOLA.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    wcfBOLA.setAlignment(jxl.format.Alignment.LEFT);  
    wcfBOLA.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);     

          
          
   /*                  */
	jxl.SheetSettings ss = new jxl.SheetSettings();
	ss.setSelected();
	ss.setVerticalFreeze(5);
	//ss.setShowGridLines(true);
	ss.setFitToPages(true);	

    Statement statement=ifxdbexpcon.createStatement();
    out.println("Step1c");   
    ResultSet rs=statement.executeQuery(sql); out.println("Step1d");  
    if (rs.next())
	{	
			
    jxl.write.Label cellLabel00 = new jxl.write.Label(0, 0, "", wcf2Header); // (Column,Row)第二個Sheet ws2 
    ws.addCell(cellLabel00);  // 第二個Sheet ws2    
	ws.setColumnView(0, 0);  // 第二個Sheet ws2 	

    jxl.write.Label cellLabel01 = new jxl.write.Label(1, 0, "", wcf2Header); // (Column,Row)第二個Sheet ws2 
    ws.addCell(cellLabel01);  // 第二個Sheet ws2    
	ws.setColumnView(1, 0);  // 第二個Sheet ws2  

    jxl.write.Label label2Title = new jxl.write.Label(0, 5, "INVOICE", wcf2Title); // (Column,Row)第二個Sheet ws2 
    ws.addCell(label2Title);  // 第二個Sheet ws2 
    ws.mergeCells(0, 5, 14, 5);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 10);  // 第二個Sheet ws2 

    	    
    jxl.write.Label label2Head1 = new jxl.write.Label(2, 6, "Invoice No.         :", wcf2Header); // 第二個Sheet ws2 
    ws.addCell(label2Head1);  // 第二個Sheet ws2 
	ws.setColumnView(2, 12);  // 第二個Sheet ws2
    
    jxl.write.Label label2Head2 = new jxl.write.Label(2, 7, "Shipped Per       :", wcf2Header); // 第二個Sheet ws2 
    ws.addCell(label2Head2);  // 第二個Sheet ws2 
	ws.setColumnView(2, 12);  // 第二個Sheet ws2 

    jxl.write.Label label2Head3 = new jxl.write.Label(2, 8, "Sailing on/ab     :", wcf2Header); // 第二個Sheet ws2 
    ws.addCell(label2Head3);  // 第二個Sheet ws2 
	ws.setColumnView(2, 12);  // 第二個Sheet ws2 
    
    jxl.write.Label label2Head4 = new jxl.write.Label(13, 7, "Date:", wcf2Header); // 第二個Sheet ws2 
    ws.addCell(label2Head4);  // 第二個Sheet ws2 
	ws.setColumnView(13, 12);  // 第二個Sheet ws2

    jxl.write.Label label2Head5 = new jxl.write.Label(2, 9, "Shipped from     :", wcf2Header); // 第二個Sheet ws2 
    ws.addCell(label2Head5);  // 第二個Sheet ws2 
	ws.setColumnView(2, 12);  // 第二個Sheet ws2

    jxl.write.Label label2Head6 = new jxl.write.Label(5, 9, "TO:", wcf2Header); // 第二個Sheet ws2 
    ws.addCell(label2Head6);  // 第二個Sheet ws2 
	ws.setColumnView(5, 5);  // 第二個Sheet ws2

    jxl.write.Label label2Head7 = new jxl.write.Label(12, 8, "On Account & Risk of Messrs.:", wcf2Header); // 第二個Sheet ws2 
    ws.addCell(label2Head7);  // 第二個Sheet ws2 
	ws.setColumnView(12, 15);  // 第二個Sheet ws2 

    jxl.write.Label label2Head8 = new jxl.write.Label(2, 10, "SHIP TO            :", wcf2Header); // 第二個Sheet ws2 
    ws.addCell(label2Head8);  // 第二個Sheet ws2 
	ws.setColumnView(2, 5);  // 第二個Sheet ws2 

    jxl.write.Label labelMarks = new jxl.write.Label(2, 16, "MARKS", wcf2Cond); // 第二個Sheet ws2 
    ws.addCell(labelMarks);  // 第二個Sheet ws2 
    ws.mergeCells(2, 16, 4, 16);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格           
	ws.setColumnView(2, 10);  // 第二個Sheet ws2 

    jxl.write.Label labelDesc = new jxl.write.Label(5, 16, "DESCRIPTION", wcf2Cond); // 第二個Sheet ws2 
    ws.addCell(labelDesc);  // 第二個Sheet ws2 
    ws.mergeCells(5, 16, 10, 16);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格           
	ws.setColumnView(5, 10);  // 第二個Sheet ws2  

    jxl.write.Label labelQty = new jxl.write.Label(11, 16, "Q'TY", wcf2Cond); // 第二個Sheet ws2 
    ws.addCell(labelQty);  // 第二個Sheet ws2 
    ws.mergeCells(11, 16, 12, 16);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格           
	ws.setColumnView(11, 10);  // 第二個Sheet ws2   

    jxl.write.Label labelUPrice = new jxl.write.Label(13, 16, "UNIT PRICE", wcf2Cond); // 第二個Sheet ws2 
    ws.addCell(labelUPrice);  // 第二個Sheet ws2 
    ws.mergeCells(13, 16, 14, 16);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格           
	ws.setColumnView(13, 10);  // 第二個Sheet ws2

    jxl.write.Label labelTAmount = new jxl.write.Label(15, 16, "TOTAL AMOUNT", wcf2Cond); // 第二個Sheet ws2 
    ws.addCell(labelTAmount);  // 第二個Sheet ws2 
    ws.mergeCells(15, 16, 16, 16);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格           
	ws.setColumnView(15, 15);  // 第二個Sheet ws2   

    jxl.write.Label labelCF217 = new jxl.write.Label(2, 17, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF217);
    ws.mergeCells(2, 17, 4, 17);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(2, 15);    

    jxl.write.Label labelCF517 = new jxl.write.Label(5, 17, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF517);
    ws.mergeCells(5, 17, 10, 17);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(5, 15);  

    jxl.write.Label labelCF1117 = new jxl.write.Label(11, 17, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF1117);
    ws.mergeCells(11, 17, 12, 17);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(11, 15);

  //  jxl.write.Label labelCF1317 = new jxl.write.Label(13, 17, "", wcfLeftBorder); //(行,列)
  //  ws.addCell(labelCF1317);
  //  ws.mergeCells(13, 17, 14, 17);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	//ws.setColumnView(13, 15);    

    jxl.write.Label labelCF1517 = new jxl.write.Label(15, 17, "", wcfRightBorder); //(行,列)
    ws.addCell(labelCF1517);
    ws.mergeCells(15, 17, 16, 17);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(15, 15);

    jxl.write.Label labelCF218 = new jxl.write.Label(2, 18, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF218);
    ws.mergeCells(2, 18, 4, 18);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(2, 15);    

    jxl.write.Label labelCF518 = new jxl.write.Label(5, 18, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF518);
    ws.mergeCells(5, 18, 10, 18);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(5, 15);  

    jxl.write.Label labelCF1118 = new jxl.write.Label(11, 18, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF1118);
    ws.mergeCells(11, 18, 12, 18);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(11, 15);

    jxl.write.Label labelCF1318 = new jxl.write.Label(13, 17, rs.getString("TRADE_TERM"), wcfLBBorder); //(行,列)
    ws.addCell(labelCF1318);
    ws.mergeCells(13, 17, 14, 18);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(13, 15);    

    jxl.write.Label labelCF1518 = new jxl.write.Label(15, 18, "", wcfRightBorder); //(行,列)
    ws.addCell(labelCF1518);
    ws.mergeCells(15, 18, 16, 18);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(15, 15);

    jxl.write.Label labelCF219 = new jxl.write.Label(2, 19, "", wcfLBUD); //(行,列)
    ws.addCell(labelCF219);
    ws.mergeCells(2, 19, 4, 19);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(2, 15);    

    jxl.write.Label labelCF519 = new jxl.write.Label(5, 19, rs.getString("CUST").trim(), wcfLABUD); //(行,列)
    ws.addCell(labelCF519);
    ws.mergeCells(5, 19, 10, 19);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(5, 15);  

    jxl.write.Label labelCF1119 = new jxl.write.Label(11, 19, "PCS", wcfLBUD); //(行,列)
    ws.addCell(labelCF1119);
    ws.mergeCells(11, 19, 12, 19);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(11, 15);

    jxl.write.Label labelCF1319 = new jxl.write.Label(13, 19, rs.getString("CURR"), wcfLBUD); //(行,列)
    ws.addCell(labelCF1319);    
    ws.mergeCells(13, 19, 14, 19);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格     
	ws.setColumnView(13, 15);    

    jxl.write.Label labelCF1519 = new jxl.write.Label(15, 19, rs.getString("CURR"), wcfLBUD); //(行,列)
    ws.addCell(labelCF1519);
    ws.mergeCells(15, 19, 16, 19);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(15, 15); 

    jxl.write.Label labelCF1719 = new jxl.write.Label(17, 19, "", wcfLBUD); //(行,列)
    ws.addCell(labelCF1719);
    ws.mergeCells(17, 19, 17, 19);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(17, 15);       

    jxl.write.Label labelCF220 = new jxl.write.Label(2, 20, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF220);
    ws.mergeCells(2, 20, 4, 20);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(2, 15);    

    jxl.write.Label labelCF520 = new jxl.write.Label(5, 20, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF520);
    ws.mergeCells(5, 20, 10, 20);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(5, 15);  

    jxl.write.Label labelCF1120 = new jxl.write.Label(11, 20, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF1120);
    ws.mergeCells(11, 20, 12, 20);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(11, 15);

    jxl.write.Label labelCF1320 = new jxl.write.Label(13, 20, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF1320);
    ws.mergeCells(13, 20, 14, 20);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(13, 15);    

    jxl.write.Label labelCF1520 = new jxl.write.Label(15, 20, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF1520);
    ws.mergeCells(15, 20, 16, 20);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(15, 15); 

    jxl.write.Label labelCF1720 = new jxl.write.Label(17, 20, "", wcfLeftBorder); //(行,列)
    ws.addCell(labelCF1720);
    ws.mergeCells(17, 20, 17, 20);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	ws.setColumnView(17, 15);                     
                                 
    out.println("Step1b");
		
	//out.println(sql);
	
	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 1;
		int rowNo = 1;
		
        //sql = sqlGlobal;
        //out.println(sql); 
	    	
		  out.println("Step1");
		  shipTo = rs.getString("INVTO");
 
		  noSeq = noSeq + 1;
		  noSeqStr = Integer.toString(noSeq);

         jxl.write.Label labelInvS1 = new jxl.write.Label(13, 0, rs.getString("INVOF"), wcf2Header); // 第二個Sheet ws2 
         ws.addCell(labelInvS1);  // 第二個Sheet ws2 
	     ws.setColumnView(13, 5);  // 第二個Sheet ws2

         jxl.write.Label labelInvS2 = new jxl.write.Label(13, 1, rs.getString("INVNOTE").substring(0,23), wcf2Content); // 第二個Sheet ws2 
         ws.addCell(labelInvS2);  // 第二個Sheet ws2 
	     ws.setColumnView(13, 5);  // 第二個Sheet ws2

         jxl.write.Label labelInvS3 = new jxl.write.Label(13, 2, rs.getString("INVNOTE").substring(23,52), wcf2Content); // 第二個Sheet ws2 
         ws.addCell(labelInvS3);  // 第二個Sheet ws2 
	     ws.setColumnView(13, 5);  // 第二個Sheet ws2  

         jxl.write.Label labelInvS4 = new jxl.write.Label(13, 3, rs.getString("INVNOTE").substring(52,rs.getString("INVNOTE").length()), wcf2Content); // 第二個Sheet ws2 
         ws.addCell(labelInvS4);  // 第二個Sheet ws2 
	     ws.setColumnView(13, 5);  // 第二個Sheet ws2  

         jxl.write.Label labelInvS5 = new jxl.write.Label(13, 4, rs.getString("REMH"), wcf2Content); // 第二個Sheet ws2 
         ws.addCell(labelInvS5);  // 第二個Sheet ws2 
	     ws.setColumnView(13, 5);  // 第二個Sheet ws2                 

	out.println("Step2");	
          //抬頭:(第6列第3行)
	      jxl.write.Label labelCF36 = new jxl.write.Label(3, 6, rs.getString("VNDINV_NO"), wcf2Header); //(行,列)
          ws.addCell(labelCF36);
	      ws.setColumnView(3, 15);  
out.println("Step3");
          //抬頭:(第7列第3行)
	      jxl.write.Label labelCF37 = new jxl.write.Label(3, 7, rs.getString("SHIPPED_PER"), wcf2Content); //(行,列)
          ws.addCell(labelCF37);
	      ws.setColumnView(3, 15);
out.println("Step4");
          //抬頭:(第8列第3行)
	      jxl.write.Label labelCF38 = new jxl.write.Label(3, 8, rs.getString("SAILING_AB"), wcf2Content); //(行,列)
          ws.addCell(labelCF38);
	      ws.setColumnView(3, 15);   
   out.println("Step5"); 
		  //抬頭:(第8列第11行)
	      jxl.write.Label labelCF118 = new jxl.write.Label(14, 7, rs.getString("INVDATE"), wcf2Content); //(行,列)
          ws.addCell(labelCF118);
	      ws.setColumnView(14, 15); 
out.println("Step6");
          //抬頭:(第9列第3行)
	      jxl.write.Label labelCF39 = new jxl.write.Label(3, 9, rs.getString("SHIPPED_FM"), wcf2Content); //(行,列)
          ws.addCell(labelCF39);
	      ws.setColumnView(3, 15); 
out.println("Step7");
          //抬頭:(第9列第3行)
	      jxl.write.Label labelCF79 = new jxl.write.Label(6, 9, rs.getString("SHIPPED_TO"), wcf2Content); //(行,列)
          ws.addCell(labelCF79);
	      ws.setColumnView(6, 15); 
out.println("Step8"); 
          //抬頭:(第9列第3行)
	      jxl.write.Label labelCF310 = new jxl.write.Label(3, 10, rs.getString("INVTO_HD"), wcf2Content); //(行,列)
          ws.addCell(labelCF310);
	      ws.setColumnView(3, 20); 
out.println("Step9");
          //抬頭:(第9列第3行)
	      jxl.write.Label labelCF311 = new jxl.write.Label(3, 11, shipTo.substring(0,32), wcf2Content); //(行,列)
          ws.addCell(labelCF311);
	      ws.setColumnView(3, 20); 
out.println("Step10"); out.println(shipTo.length());
          //抬頭:(第9列第3行)
	      jxl.write.Label labelCF312 = new jxl.write.Label(3, 12, shipTo.substring(32,53), wcf2Content); //(行,列)
          ws.addCell(labelCF312);
	      ws.setColumnView(3, 20); 
out.println("Step11");
          //抬頭:(第9列第3行)
	      jxl.write.Label labelCF313 = new jxl.write.Label(3, 13, shipTo.substring(53,shipTo.length()), wcf2Content); //(行,列)
          ws.addCell(labelCF313);
	      ws.setColumnView(3, 20);
out.println("Step12");
          jxl.write.Label labelCF314 = new jxl.write.Label(3, 14, rs.getString("INVTO_TEL") + "  "+rs.getString("INVTO_FAX"), wcf2Content); //(行,列)
          ws.addCell(labelCF314);
	      ws.setColumnView(3, 15);

      //    jxl.write.Label labelCF315 = new jxl.write.Label(4, 14, rs.getString("INVTO_FAX"), wcf2Content); //(行,列)
      //    ws.addCell(labelCF315);
	  //    ws.setColumnView(3, 15);   

          jxl.write.Label labelCF129 = new jxl.write.Label(12, 9, rs.getString("INVTO_HD"), wcf2Header); //(行,列)
          ws.addCell(labelCF129);
	      ws.setColumnView(12, 15); 

          jxl.write.Label labelCF1210 = new jxl.write.Label(12, 10, shipTo.substring(0,32), wcf2Content); //(行,列)
          ws.addCell(labelCF1210);
	      ws.setColumnView(12, 15); 

          jxl.write.Label labelCF1211 = new jxl.write.Label(12, 11, shipTo.substring(32,53), wcf2Content); //(行,列)
          ws.addCell(labelCF1211);
	      ws.setColumnView(12, 15); 

          jxl.write.Label labelCF1212 = new jxl.write.Label(12, 12, shipTo.substring(53,shipTo.length()), wcf2Content); //(行,列)
          ws.addCell(labelCF1212);
	      ws.setColumnView(12, 15);   

          jxl.write.Label labelCF1213 = new jxl.write.Label(12, 14, rs.getString("SHIPTO_TEL")+"   "+rs.getString("SHIPTO_FAX"), wcf2Content); //(行,列)
          ws.addCell(labelCF1213);
	      ws.setColumnView(12, 15);   

        //  jxl.write.Label labelCF1313 = new jxl.write.Label(13, 14, rs.getString("SHIPTO_FAX"), wcf2Content); //(行,列)
        //  ws.addCell(labelCF1313);
	    //  ws.setColumnView(13, 15); 
          int i = 0; 

          Statement stateTC=ifxdbexpcon.createStatement();             
          ResultSet rsTC=stateTC.executeQuery(sqlTC); 
		  while (rsTC.next())
          {
              jxl.write.Label labelCF221 = new jxl.write.Label(2, 21+i, "", wcfLeftBorder); //(行,列)
              ws.addCell(labelCF221);
              ws.mergeCells(2, 21+i, 4, 21+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(2, 15);    

              jxl.write.Label labelCF521 = new jxl.write.Label(5, 21+i, rsTC.getString("IPRODNO") +"   PO#"+ rsTC.getString("PORD"), wcfLABD); //(行,列)
              ws.addCell(labelCF521);
              ws.mergeCells(5, 21+i, 10, 21+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(5, 15);  

              jxl.write.Label labelCF1121 = new jxl.write.Label(11, 21+i, rsTC.getString("QTY"), wcfLeftBorder); //(行,列)
              ws.addCell(labelCF1121);
              ws.mergeCells(11, 21+i, 12, 21+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(11, 15);

              jxl.write.Label labelCF1321 = new jxl.write.Label(13, 21+i, rsTC.getString("PO_ECST"), wcfLeftBorder); //(行,列)
              ws.addCell(labelCF1321);
              ws.mergeCells(13, 21+i, 14, 21+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(13, 15);    

              jxl.write.Label labelCF1521 = new jxl.write.Label(15, 21+i, rsTC.getString("AMOUNT"), wcfLeftBorder); //(行,列)
              ws.addCell(labelCF1521);
              ws.mergeCells(15, 21+i, 16, 21+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(15, 15);  

              jxl.write.Label labelCF1721 = new jxl.write.Label(17, 21+i, "", wcfLeftBorder); //(行,列)
              ws.addCell(labelCF1721);
              ws.mergeCells(17, 21+i, 17, 21+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(17, 15);

              jxl.write.Label labelCF222 = new jxl.write.Label(2, 22+i, "", wcfLeftBorder); //(行,列)
              ws.addCell(labelCF222);
              ws.mergeCells(2, 22+i, 4, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(2, 15);    

             
              jxl.write.Label labelCF522 = new jxl.write.Label(5, 22+i, "ORIGINAL OF COUNTRY:" + rsTC.getString("ORG_COUNTRY"), wcfLeftAB); //(行,列)
              ws.addCell(labelCF522);
              ws.mergeCells(5, 22+i, 10, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(5, 15);  

              jxl.write.Label labelCF1122 = new jxl.write.Label(11, 22+i, "", wcfLeftBorder); //(行,列)
              ws.addCell(labelCF1122);
              ws.mergeCells(11, 22+i, 12, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(11, 15);

              jxl.write.Label labelCF1322 = new jxl.write.Label(13, 22+i, "", wcfLeftBorder); //(行,列)
              ws.addCell(labelCF1322);
              ws.mergeCells(13, 22+i, 14, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(13, 15);    

              jxl.write.Label labelCF1522 = new jxl.write.Label(15, 22+i, "", wcfLeftBorder); //(行,列)
              ws.addCell(labelCF1522);
              ws.mergeCells(15, 22+i, 16, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(15, 15);  

              jxl.write.Label labelCF1722 = new jxl.write.Label(17, 22+i, "", wcfLeftBorder); //(行,列)
              ws.addCell(labelCF1722);
              ws.mergeCells(17, 22+i, 17, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(17, 15); 

              i=i+2;         
          }
          rsTC.close();
	      stateTC.close(); 

          i--;

          jxl.write.Label labelCF222 = new jxl.write.Label(2, 22+i, "", wcfLeftBorder); //(行,列)
          ws.addCell(labelCF222);
          ws.mergeCells(2, 22+i, 4, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(2, 15);    

          jxl.write.Label labelCF522 = new jxl.write.Label(5, 22+i, "" , wcfLeftBorder); //(行,列)
          ws.addCell(labelCF522);
          ws.mergeCells(5, 22+i, 10, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(5, 15);  

          jxl.write.Label labelCF1122 = new jxl.write.Label(11, 22+i, "", wcfLeftBorder); //(行,列)
          ws.addCell(labelCF1122);
          ws.mergeCells(11, 22+i, 12, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(11, 15);

          jxl.write.Label labelCF1322 = new jxl.write.Label(13, 22+i, "", wcfLeftBorder); //(行,列)
          ws.addCell(labelCF1322);
          ws.mergeCells(13, 22+i, 14, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(13, 15);    

          jxl.write.Label labelCF1522 = new jxl.write.Label(15, 22+i, "", wcfLeftBorder); //(行,列)
          ws.addCell(labelCF1522);
          ws.mergeCells(15, 22+i, 16, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(15, 15);  

          jxl.write.Label labelCF1722 = new jxl.write.Label(17, 22+i, "", wcfLeftBorder); //(行,列)
          ws.addCell(labelCF1722);
          ws.mergeCells(17, 22+i, 17, 22+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(17, 15);   
//
        int t=0;   
        while (t<26)
        {
          jxl.write.Label labelCF223 = new jxl.write.Label(2, 23+i+t, "", wcfLeftBorder); //(行,列)
          ws.addCell(labelCF223);
          ws.mergeCells(2, 23+i+t, 4, 23+i+t);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(2, 15);    

          t++;     
        }

          jxl.write.Label labelCF523 = new jxl.write.Label(5, 23+i, "" , wcfLeftBorder); //(行,列)
          ws.addCell(labelCF523);
          ws.mergeCells(5, 23+i, 10, 23+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(5, 15);  

          jxl.write.Label labelCF1123 = new jxl.write.Label(11, 23+i, rs.getString("QUANTITY"), wcfLBBorder); //(行,列)
          ws.addCell(labelCF1123);
          ws.mergeCells(11, 23+i, 12, 23+i+18);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(11, 15);

          jxl.write.Label labelCF1323 = new jxl.write.Label(13, 23+i, "", wcfLBBorder); //(行,列)
          ws.addCell(labelCF1323);
          ws.mergeCells(13, 23+i, 14, 23+i+18);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(13, 15);    

          jxl.write.Label labelCF1523 = new jxl.write.Label(15, 23+i, rs.getString("TOTAMOUNT"), wcfLBBorder); //(行,列)
          ws.addCell(labelCF1523);
          ws.mergeCells(15, 23+i, 16, 23+i+18);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(15, 15);  

          jxl.write.Label labelCF1723 = new jxl.write.Label(17, 23+i, "", wcfLeftBorder); //(行,列)
          ws.addCell(labelCF1723);
          ws.mergeCells(17, 23+i, 17, 23+i+18);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(17, 15);  

           
          jxl.write.Label labelCF224 = new jxl.write.Label(2, 23+i+t, "", wcfLeftBorder); //(行,列)
          ws.addCell(labelCF224);
          // ws.mergeCells(2, 23+i, 4, 23+i+t);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(2, 15); 
             
          jxl.write.Label labelCF524 = new jxl.write.Label(5, 24+i, "SAY TOTAL U.S. DOLLARS" , wcfLeftAB); //(行,列)
          ws.addCell(labelCF524);
          //ws.mergeCells(5, 24+i, 10, 24+i);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(5, 15);

          int j = 1;
          while (j<8)
          {
              jxl.write.Label labelCF525 = new jxl.write.Label(5, 24+i+j, "" , wcfLeftBorder); //(行,列)
              ws.addCell(labelCF525);
              //ws.mergeCells(5, 24+i+j, 10, 24+i+j);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(5, 15); 
              j++;
          }  // end of while j<7

          jxl.write.Label labelCF526 = new jxl.write.Label(5, 24+i+j, "PAYMENT TERM:"+rs.getString("PAYMENT_TERM") , wcfLeftAB); //(行,列)
          ws.addCell(labelCF526);
          //ws.mergeCells(5, 24+i+j+1, 10, 24+i+j+1);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	      ws.setColumnView(5, 15);

          int k = 1;
          while (k<17)
          {
              jxl.write.Label labelCF527 = new jxl.write.Label(5, 24+i+j+k, "" , wcfLeftBorder); //(行,列)
              ws.addCell(labelCF527);
              //ws.mergeCells(5, 24+i+j+1+k, 10, 24+i+j+1+k);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	          ws.setColumnView(5, 15); 
              k++;
          }  // end of while j<7    

           jxl.write.Label labelCF528 = new jxl.write.Label(2, 23+i+t, rs.getString("VNALPH"), wcfUBUD); //(行,列)
           ws.addCell(labelCF528);
           ws.mergeCells(2, 23+i+t, 4, 23+i+t);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	       ws.setColumnView(5, 15); 

           jxl.write.Label labelCF529 = new jxl.write.Label(5, 24+i+j+k, invoiceNo, wcfUBUD); //(行,列)
           ws.addCell(labelCF529);
           ws.mergeCells(5, 24+i+j+k, 10, 24+i+j+k);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	       ws.setColumnView(5, 15); 

           jxl.write.Label labelCF530 = new jxl.write.Label(6, 24+i+j+k+1, "DBTEL PROPRIETARY 大霸機密 翻印必究", wcf2Content); //(行,列)
           ws.addCell(labelCF530);
           //ws.mergeCells(6, 24+i+j+k, 10, 24+i+j+k);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	       ws.setColumnView(6, 15);         
               
           jxl.write.Label labelCF1124 = new jxl.write.Label(11, 24+i+18, rs.getString("INVOF"), wcfBOLA); //(行,列)
           ws.addCell(labelCF1124);
           ws.mergeCells(11, 24+i+18, 16, 24+i+18+6);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格  
	       ws.setColumnView(11, 15);  
          
   	   }   // End of if rs.next()		
	   rs.close();
	   statement.close();
	 
	
	//寫入Excel 
	wwb.write(); 
    //關閉Excel工作薄 
    //wwb.close();
	
	//rs.close();
	
	 
    //response.setContentType("application/vnd.ms-excel");  
   // response.getOutputStream().write(wwb) ;
   //response.getOutputStream().flush();  
   //ws.close();   // close workbook's sheet //
   wwb.close(); // close workbook //
   os.close();   // close file outputstream //
   out.close(); 
	

    }   // End of try
    catch (Exception e) 
    { 
	 out.println("Exception:"+e.getMessage()); 
     //e.printStackTrace(); 
    } 	

       
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
   response.setContentType("application/vnd.ms-excel");					
   response.sendRedirect("/wins/report/"+userID+"_"+ymdCurr+hmsCurr+"_"+invoiceNo+".xls");  
%>

</html>
