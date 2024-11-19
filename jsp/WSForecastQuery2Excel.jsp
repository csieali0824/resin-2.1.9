<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean" %>
<!--%@ page contentType="image/jpeg; charset=Big5" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*" %-->
<%@ page import="DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
  //String userID=request.getParameter("USERID");
 //String WSUserID=(String)session.getAttribute("USERID"); 
  workingDateBean.setWorkingDate(dateBean.getYear(),dateBean.getMonth(),dateBean.getDay());   
  String WSUserID=request.getParameter("USERNAME");    
  //String compNo=request.getParameter("COMPNO");
  String type=request.getParameter("TYPE");
  String regionNo=request.getParameter("REGION");
  String locale=request.getParameter("LOCALE");
  String YearFr=Integer.toString(dateBean.getYear());
  String MonthFr=Integer.toString(dateBean.getMonth());
  String model=request.getParameter("MODEL"); 
  
  String dateStringBegin="";
  String dateStringEnd = "";
  
  if (dateStringBegin==null || dateStringBegin==""){dateStringBegin=dateBean.getYearMonthDay();}
  if (dateStringEnd==null || dateStringEnd==""){dateStringEnd=dateBean.getYearMonthDay();}
 /* 
  if (regionNo==null || regionNo==""){}
  else {regionNo=Integer.toString(Integer.parseInt(regionNo));}
  out.println(regionNo);
 */
  if (WSUserID==null){}   
  else
  {out.println("<A HREF='/wins/report/"+WSUserID+"_Query.xls'>Forecast Excel View</A>");}	
       int modLength = 0;
  String modPlus = "";
  
  if (model == null || model.equals("--"))
  {}
  else 
  {
    modLength = model.length();
	modPlus =  model.substring(modLength-4,modLength);
	//out.println("modPlus ="+modPlus);
	if (modPlus.equals("PLUS"))
	{model = model.substring(0,modLength-4)+"+";}
	 
  }
  
 try 
    { 	
	 String sql = "";
	 String swhere  = "";
	 String sWhere = "";
	
	 String designHouse = "";
	 String systemMode = "";
	 String fwReg = "";
	 String fwCoun = "";
	 String fwType = "";
	 String fwPrjCD = "";
	 String fwColor = "";
	 String sWeek1 = "";
	 String sWeek2 = "";
	 String sWeek3 = "";
	 String sWeek4 = "";
	 String sWeek5 = "";
	 String sWeek6 = "";
	 String sWeek7 = "";
	 String sWeek8 = "";
	 String sWeek9 = "";
	 String sWeek10 = "";
	 String sWeek11 = "";
	 String sWeek12 = "";
	 String sWeek13 = "";
	 String sWeek14 = "";
	 String sWeek15 = "";
	 String sWeek16 = "";
	 String sWeek17 = "";
	 String sWeek18 = "";
	 String sWeek19 = "";
	 String sWeek20 = "";
	 String sWeek21 = "";
	 String sWeek22 = "";
	 String sWeek23 = "";
	 String sWeek24 = "";
	 
	 sql = "select  DISTINCT m.DESIGNHOUSE as DESIGNHOUSE, m.SYSTEMMODE, w.FWREG, w.FWCOUN , w.FWTYPE, w.FWPRJCD, w.FWCOLOR, w.FWWVER from WSADMIN.PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";
	 swhere = "where w.FWPRJCD = m.PROJECTCODE ";                          			  
									   
	 sWhere = "and m.PROJECTCODE >= '0' ";    
								  
	 if (locale==null || locale.equals("--")) {   sWhere = sWhere + "and to_char(w.FWCOUN) !=  'ALL'  "; }
	 else { sWhere = sWhere + "and to_char(w.FWCOUN) =  '"+locale+"'  ";}	
	 if (type==null || type.equals("--")) {   sWhere = sWhere + "and w.FWTYPE !=  'ALL'  "; }
	 else { sWhere = sWhere + "and w.FWTYPE =  '"+type+"'  "; }
     if (regionNo==null || regionNo.equals("--")) { sWhere = sWhere + "and to_char(w.FWREG) != 'ALL'  "; }
	 else { sWhere = sWhere +  "and to_char(w.FWREG) = '"+regionNo+"'  "; }
	 if (model==null || model.equals("--")) { sWhere = sWhere +  "and w.FWPRJCD !=  'ALL' "; }
	 else { sWhere = sWhere +  "and w.FWPRJCD =  '"+model+"' "; }
		  
	 String sOrder = "ORDER BY w.FWWVER, w.FWPRJCD ";
			
	 sql = sql + swhere + sWhere + sOrder;
	 //sql = sql + swhere ;
	 
	 
	 
// 2003/12/11 加入新條件 迄	 
	 //sql = sql + sWhere + orderBy;
	 out.println(sql);
		
	 /*InputStream is = new FileInputStream("C:\\resin-2.1.9\\webapps\\repair\\report\\RepairStaticReturnList(10).xls"); 
       jxl.Workbook rwb = Workbook.getWorkbook(is); 
	
       Sheet rs = rwb.getSheet(0); 
	   Cell c00 = rs.getCell(0, 0); 
	   String strc00 = c00.getContents(); 	
       //?取第二行，第二列的值 
       Cell c11 = rs.getCell(1, 1); 
       String strc11 = c11.getContents(); 
       out.println("Cell(0, 0)" + " value : " + strc00 + "; type : " + c00.getType()); 
	 */
   
    /*   // Start of Example successful
	
    //建構Excel 的 Workbook
    //Method 1：建可入的Excel工作薄 
    //jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(new File("C:\\test.xls")); 
    //Method 2：WritableWorkbook直接入到出流 
       // 利用方法 2: 於 Server 位置產生一 Excel 檔
    OutputStream os = new FileOutputStream("c:\\test1.xls"); 	
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 	
	
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("Return List", 0); 	
	//file://1.添加Label 
    jxl.write.Label labelC = new jxl.write.Label(0, 0, "NO"); 
    ws.addCell(labelC); 
    //添加有字型Formatting 
    jxl.write.WritableFont wf = new jxl.write.WritableFont(WritableFont.TIMES, 18,WritableFont.BOLD, true); 
    jxl.write.WritableCellFormat wcfF = new jxl.write.WritableCellFormat(wf); 
    jxl.write.Label labelCF = new jxl.write.Label(1, 0, "This is a Label Cell", wcfF); 
    ws.addCell(labelCF); 
    //添加有字体顏色Formatting 
    jxl.write.WritableFont wfc = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.RED); 
    jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfc); 
    jxl.write.Label labelCFC = new jxl.write.Label(2, 0, "This is a Label Cell", wcfFC); 
    ws.addCell(labelCFC);  
    //2.添加Number 
    jxl.write.Number labelN = new jxl.write.Number(0, 1, 3.1415926); 
    ws.addCell(labelN); 
    //添加有formatting的Number
    jxl.write.NumberFormat nf = new jxl.write.NumberFormat("#.##"); 
    jxl.write.WritableCellFormat wcfN = new jxl.write.WritableCellFormat(nf); 
    jxl.write.Number labelNF = new jxl.write.Number(1, 1, 3.1415926, wcfN); 
    ws.addCell(labelNF); 
    //3.添加Boolean象 
    jxl.write.Boolean labelB = new jxl.write.Boolean(0, 2, false); 
    ws.addCell(labelB); 
    //4.添加DateTime?象 
    jxl.write.DateTime labelDT = new jxl.write.DateTime(0, 3, new java.util.Date()); 
    ws.addCell(labelDT); 
    //添加?有formatting的DateFormat?象 
    jxl.write.DateFormat df = new jxl.write.DateFormat("dd MM yyyy hh:mm:ss"); 
    jxl.write.WritableCellFormat wcfDF = new jxl.write.WritableCellFormat(df); 
    jxl.write.DateTime labelDTF = new jxl.write.DateTime(1, 3, new java.util.Date(), wcfDF); 
    ws.addCell(labelDTF); 
	out.clearBuffer();
	//寫入Excel 
	wwb.write(); 
    //關閉Excel工作薄 
    wwb.close(); 
	
	*/ // End of Example
	//out.clearBuffer();
	//out.flush();
	
	
	// 產生報表
	OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\wins\\report\\"+WSUserID+"_Query.xls"); 	
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("Forecast List", 0); 
	
	//jxl.format.Border fB = new jxl.format.Border(ALL);
	
	jxl.SheetSettings ss = new jxl.SheetSettings();
	ss.setSelected();
	ss.setVerticalFreeze(5);
	//ss.setShowGridLines(true);
	ss.setFitToPages(true);	
			
	//file://抬頭:(第0列第1行)
    jxl.write.WritableFont wf = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF = new jxl.write.WritableCellFormat(wf); 
	wcfF.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCF0 = new jxl.write.Label(0, 0, "DESIGN HOUSE", wcfF); 
    ws.addCell(labelCF0);
	ws.setColumnView(0, 20);
    //抬頭:(第0列第2行)
    jxl.write.WritableFont wfc = new jxl.write.WritableFont(WritableFont.ARIAL,12,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.RED); 
    jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfc); 
	wcfFC.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFC1 = new jxl.write.Label(1, 0, "MODE", wcfFC); 
    ws.addCell(labelCFC1);
	ws.setColumnView(1, 13);
	//抬頭:(第0列第3行)
	//jxl.write.WritableFont wfB = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    //jxl.write.WritableCellFormat wcfFB = new jxl.write.WritableCellFormat(wfB);
	//wcfFB.setBackground(jxl.format.Colour.AQUA); // 設定背景顏色    
	jxl.write.Label labelCFC2 = new jxl.write.Label(2, 0, "REGION", wcfFC); 
    ws.addCell(labelCFC2);
	ws.setColumnView(2, 20);
	//抬頭:(第0列第3行) 
    jxl.write.Label labelCF3 = new jxl.write.Label(3, 0, "COUNTRY", wcfF); 
    ws.addCell(labelCF3);
	ws.setColumnView(3, 15);
	//抬頭:(第0列第4行)
	jxl.write.Label labelCF4 = new jxl.write.Label(4, 0, "TYPE", wcfF); 
    ws.addCell(labelCF4);
	ws.setColumnView(4, 10);
	//抬頭:(第0列第5行)
	jxl.write.Label labelCF5 = new jxl.write.Label(5, 0, "MODEL", wcfF); 
    ws.addCell(labelCF5);
	ws.setColumnView(5, 15);
	//抬頭:(第0列第6行)
	jxl.write.WritableFont wfcOrange = new jxl.write.WritableFont(WritableFont.ARIAL,12,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.ORANGE); 
    jxl.write.WritableCellFormat wcfFCOrange = new jxl.write.WritableCellFormat(wfcOrange); 
	wcfFCOrange.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	jxl.write.Label labelCFC6 = new jxl.write.Label(6, 0, "COLOR", wcfFCOrange); 
    ws.addCell(labelCFC6);
	ws.setColumnView(6, 0);
	//抬頭:(第0列第7行)
	workingDateBean.setAdjWeek(1);
	int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek1 = Integer.toString(week1);
	jxl.write.Label labelCF7 = new jxl.write.Label(7, 0, strWeek1, wcfF); 
	//wcfFB.setBackground(jxl.format.Colour.YELLOW); // 設定背景顏色
    ws.addCell(labelCF7);
	ws.setColumnView(7, 10);
	//抬頭:(第0列第8行)
	workingDateBean.setAdjWeek(1);
	int week2 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek2 = Integer.toString(week2);
	jxl.write.Label labelCF8 = new jxl.write.Label(8, 0, strWeek2, wcfF); 
    ws.addCell(labelCF8);
	ws.setColumnView(8, 10);
	//抬頭:(第0列第9行) // 第3週
	workingDateBean.setAdjWeek(1);
	int week3 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek3 = Integer.toString(week3);
	jxl.write.Label labelCF9 = new jxl.write.Label(9, 0, strWeek3, wcfF); 
    ws.addCell(labelCF9);
	ws.setColumnView(9, 10);
	//抬頭:(第0列第10行) // 第4週
	workingDateBean.setAdjWeek(1);
	int week4 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek4 = Integer.toString(week4);
	jxl.write.Label labelCFC10 = new jxl.write.Label(10, 0, strWeek4, wcfFCOrange); 
    ws.addCell(labelCFC10);
	ws.setColumnView(10, 10);
	//抬頭:(第0列第11行) // 第5週
	workingDateBean.setAdjWeek(1);
	int week5 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek5 = Integer.toString(week5);
	jxl.write.Label labelCFC11 = new jxl.write.Label(11, 0, strWeek5, wcfFCOrange); 
    ws.addCell(labelCFC11);
	ws.setColumnView(11, 10);
	//抬頭:(第0列第12行) // 第6週
	workingDateBean.setAdjWeek(1);
	int week6 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek6 = Integer.toString(week6);
	jxl.write.Label labelCF12 = new jxl.write.Label(12, 0, strWeek6, wcfF); 
    ws.addCell(labelCF12);
	ws.setColumnView(12, 10);
	//抬頭:(第0列第13行) // 第7週
	workingDateBean.setAdjWeek(1);
	int week7 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek7 = Integer.toString(week7);
	jxl.write.Label labelCF13 = new jxl.write.Label(13, 0, strWeek7, wcfF); 
    ws.addCell(labelCF13);
	ws.setColumnView(13, 10);
	//抬頭:(第0列第14行) // 第8週
	workingDateBean.setAdjWeek(1);
	int week8 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek8 = Integer.toString(week8);
	jxl.write.Label labelCF14 = new jxl.write.Label(14, 0, strWeek8, wcfF); 
    ws.addCell(labelCF14);
	ws.setColumnView(14, 10);
	//抬頭:(第0列第15行) // 第9週
	workingDateBean.setAdjWeek(1);
	int week9 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek9 = Integer.toString(week9);
	jxl.write.Label labelCF15 = new jxl.write.Label(15, 0, strWeek9 , wcfF); 
    ws.addCell(labelCF15);
	ws.setColumnView(15, 10);
	//抬頭:(第0列第16行) // 第10週
	workingDateBean.setAdjWeek(1);
	int week10 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek10 = Integer.toString(week10);
	jxl.write.Label labelCF16 = new jxl.write.Label(16, 0, strWeek10, wcfF); 
    ws.addCell(labelCF16);
	ws.setColumnView(16, 10);
	//抬頭:(第0列第17行) // 第11週
	workingDateBean.setAdjWeek(1);
	int week11 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek11 = Integer.toString(week11);
	jxl.write.WritableFont wfB = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFB = new jxl.write.WritableCellFormat(wfB);
	wcfFB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	wcfFB.setBackground(jxl.format.Colour.YELLOW); // 設定背景顏色
	//wcfFB.setShrinkToFit(true);
	jxl.write.Label labelCF17 = new jxl.write.Label(17, 0, strWeek11, wcfFB); 
    ws.addCell(labelCF17);
	ws.setColumnView(17, 10);
	//抬頭:(第0列第18行) // 第12週
	workingDateBean.setAdjWeek(1);
	int week12 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek12 = Integer.toString(week12);
	jxl.write.Label labelCF18 = new jxl.write.Label(18, 0, strWeek12, wcfF); 
    ws.addCell(labelCF18);
	ws.setColumnView(18, 10);
	//抬頭:(第0列第19行) // 第13週
	workingDateBean.setAdjWeek(1);
	int week13 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek13 = Integer.toString(week13);
	jxl.write.Label labelCF19 = new jxl.write.Label(19, 0, strWeek13, wcfF); 
    ws.addCell(labelCF19);
	ws.setColumnView(19, 10);
	//抬頭:(第0列第20行) // 第14週
	workingDateBean.setAdjWeek(1);
	int week14 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek14 = Integer.toString(week14);
	jxl.write.Label labelCF20 = new jxl.write.Label(20, 0, strWeek14, wcfF); 
    ws.addCell(labelCF20);
	ws.setColumnView(20, 10);
	//抬頭:(第0列第21行) // 第15週
	workingDateBean.setAdjWeek(1);
	int week15 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek15 = Integer.toString(week15);
	jxl.write.Label labelCF21 = new jxl.write.Label(21, 0, strWeek15 , wcfF); 
    ws.addCell(labelCF21);
	ws.setColumnView(21, 10);
	//抬頭:(第0列第22行) // 第16週
	workingDateBean.setAdjWeek(1);
	int week16 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek16 = Integer.toString(week16);
	jxl.write.Label labelCF22 = new jxl.write.Label(22, 0, strWeek16 , wcfF); 
    ws.addCell(labelCF22);
	ws.setColumnView(22, 10);
	//抬頭:(第0列第23行) // 第17週
	workingDateBean.setAdjWeek(1);
	int week17 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek17 = Integer.toString(week17);
	jxl.write.Label labelCF23 = new jxl.write.Label(23, 0, strWeek17 , wcfF); 
    ws.addCell(labelCF23);
	ws.setColumnView(23, 10);
	//抬頭:(第0列第24行) // 第18週
	workingDateBean.setAdjWeek(1);
	int week18 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek18 = Integer.toString(week18);
	jxl.write.Label labelCF24 = new jxl.write.Label(24, 0, strWeek18 , wcfF); 
    ws.addCell(labelCF24);
	ws.setColumnView(24, 10);
	//抬頭:(第0列第25行) // 第19週
	workingDateBean.setAdjWeek(1);
	int week19 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek19 = Integer.toString(week19);
	jxl.write.Label labelCF25 = new jxl.write.Label(25, 0, strWeek19 , wcfF); 
    ws.addCell(labelCF25);
	ws.setColumnView(25, 10);
	//抬頭:(第0列第26行) // 第20週
	workingDateBean.setAdjWeek(1);
	int week20 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek20 = Integer.toString(week20);
	jxl.write.Label labelCF26 = new jxl.write.Label(26, 0, strWeek20 , wcfF); 
    ws.addCell(labelCF26);
	ws.setColumnView(26, 10);
	//抬頭:(第0列第27行) // 第21週
	workingDateBean.setAdjWeek(1);
	int week21 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek21 = Integer.toString(week21);
	jxl.write.Label labelCF27 = new jxl.write.Label(27, 0, strWeek21 , wcfF); 
    ws.addCell(labelCF27);
	ws.setColumnView(27, 10);
	//抬頭:(第0列第28行) // 第22週
	workingDateBean.setAdjWeek(1);
	int week22 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek22 = Integer.toString(week22);
	jxl.write.Label labelCF28 = new jxl.write.Label(28, 0, strWeek22 , wcfF); 
    ws.addCell(labelCF28);
	ws.setColumnView(28, 10);
	//抬頭:(第0列第29行) // 第23週
	workingDateBean.setAdjWeek(1);
	int week23 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek23 = Integer.toString(week23);
	jxl.write.Label labelCF29 = new jxl.write.Label(29, 0, strWeek23 , wcfF); 
    ws.addCell(labelCF29);
	ws.setColumnView(29, 10);
	//抬頭:(第0列第29行) // 第24週
	workingDateBean.setAdjWeek(1);
	int week24 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek24 = Integer.toString(week24);
	jxl.write.Label labelCF30 = new jxl.write.Label(30, 0, strWeek24 , wcfF); 
    ws.addCell(labelCF30);
	ws.setColumnView(30, 10);
	/*
	//抬頭:(第0列第30行) // 第24週
	workingDateBean.setAdjWeek(1);
	int week25 = Integer.parseInt(workingDateBean.getWorkingWeek());
	String strWeek25 = Integer.toString(week25);
	jxl.write.Label labelCF31 = new jxl.write.Label(31, 0, strWeek25 , wcfF); 
    ws.addCell(labelCF31);
	ws.setColumnView(31, 10);
    */
	//out.clearBuffer();
	
	
	//out.println(sql);
	
	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 1;
		int rowNo = 1;
		//String temp="";				
	    	
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sql); 		
		
		while (rs.next())
		{	  
		 //out.println("RowNow "+noSeq);
		 /*
		  for (colNo = 2; colNo <= 22; colNo++)
		  {		  
		   temp=rs.getString(colNo);
		   //lableCFD = "lableD"+integer.toString(colNo)+integer.toString(rowNo);
		   wcfFB.setBackground(jxl.format.Colour.BLUE); // 設定背景顏色	     
	       jxl.write.Label lableCFD = new jxl.write.Label(colNo, rowNo, temp , wcfFB); 
           ws.addCell(lableCFD);
		   out.println(temp);
		  }
	     */ 
		 
		  noSeq = noSeq + 1;
		  noSeqStr = Integer.toString(noSeq);
		  jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		  wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);   
	      
		 // jxl.write.Label lableCFD = new jxl.write.Label(colNo-1, rowNo, noSeqStr , wcfFL); 		 
        //  ws.addCell(lableCFD);
		  
		  //out.println(noSeq);  
		 
		  
		  //noSeqStr = integer.toString(noSeq);
		  designHouse=rs.getString("DESIGNHOUSE");
		  if ((designHouse == null ||  designHouse.equals("")))
		  {designHouse ="";}	 
	      jxl.write.Label lable11 = new jxl.write.Label(0, rowNo, designHouse , wcfFL); 
          ws.addCell(lable11);
		  		  
		  //out.println(designHouse);
		  
		  //noSeqStr = integer.toString(noSeq);
		  systemMode=rs.getString("SYSTEMMODE");
		  if ((systemMode == null ||  systemMode.equals("")))
		  {systemMode ="";}		 		       
	      jxl.write.Label lable21 = new jxl.write.Label(1, rowNo, systemMode , wcfFL); 
          ws.addCell(lable21);
		  //out.println(systemMode);
		  
		  fwReg=rs.getString("FWREG");
		  if ((fwReg == null ||  fwReg.equals("")))
		  {fwReg ="";}
		  jxl.write.Label lable31 = new jxl.write.Label(2, rowNo, fwReg , wcfFL); 
          ws.addCell(lable31);
		  //out.println(fwReg);
		  
		  fwCoun=rs.getString("FWCOUN");
		  if ((fwCoun == null ||  fwCoun.equals("")))
		  {fwCoun ="";}
		  jxl.write.Label lable41 = new jxl.write.Label(3, rowNo, fwCoun , wcfFL); 
          ws.addCell(lable41);
		  //out.println(fwCoun);
		  
		  fwType=rs.getString("FWTYPE");
		  if ((fwType == null ||  fwType.equals("")))
		  {fwType ="";}
		  jxl.write.Label lable51 = new jxl.write.Label(4, rowNo, fwType , wcfFL); 
          ws.addCell(lable51);
		  //out.println(fwType);
		  
		  fwPrjCD=rs.getString("FWPRJCD");
		  if ((fwPrjCD == null ||  fwPrjCD.equals("")))
		  {fwPrjCD ="";}		 	  
		  jxl.write.Label lable61 = new jxl.write.Label(5, rowNo, fwPrjCD , wcfFL); 
          ws.addCell(lable61);
		  //out.println(fwPrjCD);
		  
		  fwColor=rs.getString("FWCOLOR");
		  if ((fwColor== null ||  fwColor.equals("")))
		  {fwColor ="";}
		  jxl.write.Label lable71 = new jxl.write.Label(6, rowNo, fwColor , wcfFL); 
          ws.addCell(lable71);
		  //out.println(fwColor);
		  
		 // int week1 = Integer.parseInt(workingDateBean.getWorkingWeek())+1;
		  String V1 = "";
		  String sqlV1 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";	 		 
		   sqlV1 = sqlV1 + swhere + sWhere + "and w.FWORKWEEK = '"+week1+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"' ";
		  
		  Statement stateV1=con.createStatement();
		  ResultSet rsV1=stateV1.executeQuery(sqlV1);
		  if (rsV1.next()){V1= rsV1.getString("FWQTY");}
		  else { V1 = "";}
		  out.println(V1);
		  rsV1.close();
		  stateV1.close();	  
		  
		  jxl.write.Label lable81 = new jxl.write.Label(7, rowNo, V1 , wcfFL); 
          ws.addCell(lable81);
		  
		  String V2 = "";
		  String sqlV2 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		  
		  sqlV2 = sqlV2 + swhere + sWhere+ "and w.FWORKWEEK = '"+week2+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  out.println(sqlV2);
		  Statement stateV2=con.createStatement();
		  ResultSet rsV2=stateV2.executeQuery(sqlV2);
		  if (rsV2.next()){V2= rsV2.getString("FWQTY");}
		  else { V2 = "";}
		  out.println(V2);
		  rsV2.close();
		  stateV2.close();	 
		  
		  jxl.write.Label lable91 = new jxl.write.Label(8, rowNo, V2 , wcfFL); 
          ws.addCell(lable91);
		  
		  String V3 = "";
		  String sqlV3 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		 
		  sqlV3 = sqlV3 + swhere + sWhere+ "and w.FWORKWEEK = '"+week3+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV3=con.createStatement();
		  ResultSet rsV3=stateV3.executeQuery(sqlV3);
		  if (rsV3.next()){V3= rsV3.getString("FWQTY");}
		  else { V3 = "";}
		  rsV3.close();
		  stateV3.close();	 	  
		  
		  jxl.write.Label lable101 = new jxl.write.Label(9, rowNo, V3 , wcfFL); 
          ws.addCell(lable101);
		  
		  String V4 = "";
		  String sqlV4 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m ";	  
		  sqlV4 = sqlV4 + swhere + sWhere+ "and w.FWORKWEEK = '"+week4+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"' ";
		  ///out.println(sqlV1);
		  Statement stateV4=con.createStatement();
		  ResultSet rsV4=stateV4.executeQuery(sqlV4);
		  if (rsV4.next()){V4= rsV4.getString("FWQTY");}
		  else { V4 = "";}
		  rsV4.close();
		  stateV4.close();	 	  
		  
		  jxl.write.Label lable111 = new jxl.write.Label(10, rowNo, V4 , wcfFL); 
          ws.addCell(lable111);
		  
		  String V5 = "";
		  String sqlV5 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";		 			  
		  sqlV5 = sqlV5 + swhere + sWhere+ "and w.FWORKWEEK = '"+week5+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV5=con.createStatement();
		  ResultSet rsV5=stateV5.executeQuery(sqlV5);
		  if (rsV5.next()){V5= rsV5.getString("FWQTY");}
		  else { V5 = "";}
		  rsV5.close();
		  stateV5.close();	 
		  
		  jxl.write.Label lable121 = new jxl.write.Label(11, rowNo, V5 , wcfFL); 
          ws.addCell(lable121);
		  
		  String V6 = "";
		  String sqlV6 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		
		  sqlV6 = sqlV6 + swhere + sWhere+ "and w.FWORKWEEK = '"+week6+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV6=con.createStatement();
		  ResultSet rsV6=stateV6.executeQuery(sqlV6);
		  if (rsV6.next()){V6= rsV6.getString("FWQTY");}
		  else { V6 = "";}
		  rsV6.close();
		  stateV6.close();	 
		  
		  jxl.write.Label lable131 = new jxl.write.Label(12, rowNo, V6 , wcfFL); 
          ws.addCell(lable131);
		  
		  String V7 = "";
		  String sqlV7 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		  
		  sqlV7 = sqlV7 + swhere + sWhere+ "and w.FWORKWEEK = '"+week7+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"' ";
		  ///out.println(sqlV1);
		  Statement stateV7=con.createStatement();
		  ResultSet rsV7=stateV7.executeQuery(sqlV7);
		  if (rsV7.next()){V7= rsV7.getString("FWQTY");}
		  else { V7 = "";}
		  rsV7.close();
		  stateV7.close();		  
		  
		  //jamDesc=rs.getString("JAMDESC");   // Replace by jamDesc from rprepjam
		  jxl.write.Label lable141 = new jxl.write.Label(13, rowNo, V7 , wcfFL); 
          ws.addCell(lable141);
		  
		  String V8 = "";
		  String sqlV8 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		  
		  sqlV8 = sqlV8 + swhere + sWhere+ "and w.FWORKWEEK = '"+week8+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"' ";
		  ///out.println(sqlV1);
		  Statement stateV8=con.createStatement();
		  ResultSet rsV8=stateV8.executeQuery(sqlV8);
		  if (rsV8.next()){V8= rsV8.getString("FWQTY");}
		  else { V8 = "";}
		  rsV8.close();
		  stateV8.close();
		  
		  jxl.write.Label lable151 = new jxl.write.Label(14, rowNo, V8 , wcfFL); 
          ws.addCell(lable151);
		  
		  String V9 = "";
		  String sqlV9 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		  
		  sqlV9 = sqlV9 + swhere + sWhere+ "and w.FWORKWEEK = '"+week9+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV9=con.createStatement();
		  ResultSet rsV9=stateV9.executeQuery(sqlV9);
		  if (rsV9.next()){V9= rsV9.getString("FWQTY");}
		  else { V9 = "";}
		  rsV9.close();
		  stateV9.close();
		  
		  jxl.write.Label lable161 = new jxl.write.Label(15, rowNo, V9 , wcfFL); 
          ws.addCell(lable161);
		  
		  String V10 = "";
		  String sqlV10 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		  
		  sqlV10 = sqlV10 + swhere + sWhere+ "and w.FWORKWEEK = '"+week10+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"' ";
		  ///out.println(sqlV1);
		  Statement stateV10=con.createStatement();
		  ResultSet rsV10=stateV10.executeQuery(sqlV10);
		  if (rsV10.next()){V10= rsV10.getString("FWQTY");}
		  else { V10 = "";}
		  rsV10.close();
		  stateV10.close();
		  
		  jxl.write.Label lable171 = new jxl.write.Label(16, rowNo, V10 , wcfFL); 
          ws.addCell(lable171);
		  
		  String V11 = "";
		  String sqlV11 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		  
		  sqlV11 = sqlV11 + swhere + sWhere+ "and w.FWORKWEEK = '"+week11+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV11=con.createStatement();
		  ResultSet rsV11=stateV11.executeQuery(sqlV11);
		  if (rsV11.next()){V11= rsV11.getString("FWQTY");}
		  else { V11 = "";}
		  rsV11.close();
		  stateV11.close();
		  
		  jxl.write.Label lable181 = new jxl.write.Label(17, rowNo, V11 , wcfFL); 
          ws.addCell(lable181);
		  
		  String V12 = "";
		  String sqlV12 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";		  			  
		  sqlV12 = sqlV12 + swhere + sWhere+ "and w.FWORKWEEK = '"+week12+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV12=con.createStatement();
		  ResultSet rsV12=stateV12.executeQuery(sqlV12);
		  if (rsV12.next()){V12= rsV12.getString("FWQTY");}
		  else { V12 = "";}
		  rsV12.close();
		  stateV12.close();
		  
		  jxl.write.Label lable191 = new jxl.write.Label(18, rowNo, V12 , wcfFL); 
          ws.addCell(lable191);
		  
		  String V13 = "";
		  String sqlV13 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		  
		  sqlV13 = sqlV13 + swhere + sWhere+ "and w.FWORKWEEK = '"+week13+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"' ";
		  ///out.println(sqlV1);
		  Statement stateV13=con.createStatement();
		  ResultSet rsV13=stateV13.executeQuery(sqlV13);
		  if (rsV13.next()){V13= rsV13.getString("FWQTY");}
		  else { V13 = "";}
		  rsV13.close();
		  stateV13.close();
		  
		  jxl.write.Label lable201 = new jxl.write.Label(19, rowNo, V13 , wcfFL); 
          ws.addCell(lable201);
		  
		  String V14 = "";
		  String sqlV14 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";		  
		  sqlV14 = sqlV14 + swhere + sWhere+ "and w.FWORKWEEK = '"+week14+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV14=con.createStatement();
		  ResultSet rsV14=stateV14.executeQuery(sqlV14);
		  if (rsV14.next()){V14= rsV14.getString("FWQTY");}
		  else { V14 = "";}
		  rsV14.close();
		  stateV14.close();
		  
		  jxl.write.Label lable211 = new jxl.write.Label(20, rowNo, V14 , wcfFL); 
          ws.addCell(lable211);
		  
		  String V15 = "";
		  String sqlV15 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";		  			  
		  sqlV15 = sqlV15 + swhere + sWhere+ "and w.FWORKWEEK = '"+week15+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV15=con.createStatement();
		  ResultSet rsV15=stateV15.executeQuery(sqlV15);
		  if (rsV15.next()){V15= rsV15.getString("FWQTY");}
		  else { V15 = "";}
		  rsV15.close();
		  stateV15.close();
		  
		  jxl.write.Label lable221 = new jxl.write.Label(21, rowNo, V15 , wcfFL); 
          ws.addCell(lable221);
		  
		  String V16 = "";
		  String sqlV16 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		 
		  sqlV16 = sqlV16 + swhere + sWhere+ "and w.FWORKWEEK = '"+week16+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV16=con.createStatement();
		  ResultSet rsV16=stateV16.executeQuery(sqlV16);
		  if (rsV16.next()){V16= rsV16.getString("FWQTY");}
		  else { V16 = "";}
		  rsV16.close();
		  stateV16.close();
		  
		  jxl.write.Label lable231 = new jxl.write.Label(22, rowNo, V16 , wcfFL); 
          ws.addCell(lable231);
		  
		  String V17 = "";
		  String sqlV17 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		  
		  sqlV17 = sqlV17 + swhere + sWhere+ "and w.FWORKWEEK = '"+week17+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"' ";
		  ///out.println(sqlV1);
		  Statement stateV17=con.createStatement();
		  ResultSet rsV17=stateV17.executeQuery(sqlV17);
		  if (rsV17.next()){V17= rsV17.getString("FWQTY");}
		  else { V17 = "";}
		  rsV17.close();
		  stateV17.close();
		  
		  jxl.write.Label lable241 = new jxl.write.Label(23, rowNo, V17 , wcfFL); 
          ws.addCell(lable241);
		  
		  String V18 = "";
		  String sqlV18 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";		 			  
		  sqlV18 = sqlV18 + swhere + sWhere+ "and w.FWORKWEEK = '"+week18+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV18=con.createStatement();
		  ResultSet rsV18=stateV18.executeQuery(sqlV18);
		  if (rsV18.next()){V18= rsV18.getString("FWQTY");}
		  else { V18 = "";}
		  rsV18.close();
		  stateV18.close();
		  
		  jxl.write.Label lable251 = new jxl.write.Label(24, rowNo, V18 , wcfFL); 
          ws.addCell(lable251);
		  
		  String V19 = "";
		  String sqlV19 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		 
		  sqlV19 = sqlV19 + swhere + sWhere+ "and w.FWORKWEEK = '"+week19+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"' ";
		  ///out.println(sqlV1);
		  Statement stateV19=con.createStatement();
		  ResultSet rsV19=stateV19.executeQuery(sqlV19);
		  if (rsV19.next()){V19= rsV19.getString("FWQTY");}
		  else { V19 = "";}
		  rsV19.close();
		  stateV19.close();
		  
		  jxl.write.Label lable261 = new jxl.write.Label(25, rowNo, V19 , wcfFL); 
          ws.addCell(lable261);
		  
		  String V20 = "";
		  String sqlV20 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		 
		  sqlV20 = sqlV20 + swhere + sWhere+ "and w.FWORKWEEK = '"+week20+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV20=con.createStatement();
		  ResultSet rsV20=stateV20.executeQuery(sqlV20);
		  if (rsV20.next()){V20= rsV20.getString("FWQTY");}
		  else { V20 = "";}
		  rsV20.close();
		  stateV20.close();
		  
		  jxl.write.Label lable271 = new jxl.write.Label(26, rowNo, V20 , wcfFL); 
          ws.addCell(lable271);
		  
		  String V21 = "";
		  String sqlV21 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";		  			  
		  sqlV21 = sqlV21 + swhere + sWhere+ "and w.FWORKWEEK = '"+week21+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";
		  ///out.println(sqlV1);
		  Statement stateV21=con.createStatement();
		  ResultSet rsV21=stateV21.executeQuery(sqlV21);
		  if (rsV21.next()){V21= rsV21.getString("FWQTY");}
		  else { V21 = "";}
		  rsV21.close();
		  stateV21.close();
		  
		  jxl.write.Label lable281 = new jxl.write.Label(27, rowNo, V21 , wcfFL); 
          ws.addCell(lable281);
		  
		  String V22 = "";
		  String sqlV22 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			 		  
		  sqlV22 = sqlV22 + swhere + sWhere+ "and w.FWORKWEEK = '"+week22+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  "; 
		  ///out.println(sqlV1);
		  Statement stateV22=con.createStatement();
		  ResultSet rsV22=stateV22.executeQuery(sqlV22);
		  if (rsV22.next()){V22= rsV22.getString("FWQTY");}
		  else { V22 = "";}
		  rsV22.close();
		  stateV22.close();
		  
		  jxl.write.Label lable291 = new jxl.write.Label(28, rowNo, V22 , wcfFL); 
          ws.addCell(lable291);
		  
		  String V23 = "";
		  String sqlV23 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";			  		  
		  sqlV23 = sqlV23 + swhere + sWhere+ "and w.FWORKWEEK = '"+week23+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"' ";
		  ///out.println(sqlV1);
		  Statement stateV23=con.createStatement();
		  ResultSet rsV23=stateV23.executeQuery(sqlV23);
		  if (rsV23.next()){V23= rsV23.getString("FWQTY");}
		  else { V23 = "";}
		  rsV23.close();
		  stateV23.close();
		  
		  jxl.write.Label lable301 = new jxl.write.Label(29, rowNo, V23 , wcfFL); 
          ws.addCell(lable301);
		  
		  String V24 = "";
		  String sqlV24 = "select FWQTY from PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";		  
		  sqlV24 = sqlV24 + swhere + sWhere+ "and w.FWORKWEEK = '"+week24+"'  and w.FWPRJCD = '"+rs.getString("FWPRJCD")+"' and w.FWWVER =  '"+rs.getString("FWWVER")+"'  ";			  
		  ///out.println(sqlV1);
		  Statement stateV24=con.createStatement();
		  ResultSet rsV24=stateV24.executeQuery(sqlV24);
		  if (rsV24.next()){V24= rsV24.getString("FWQTY");}
		  else { V24 = "";}
		  rsV24.close();
		  stateV24.close();
		  
		  jxl.write.Label lable311 = new jxl.write.Label(30, rowNo, V24 , wcfFL); 
          ws.addCell(lable311);
		  
		  rowNo = rowNo + 1;
		  
		  //rs.getObject(colNo);
		  
		  /*		  
		  svrDocNo = rs.getString("SVRDOCNO");
		  repNo=rs.getString("REPNO");
		  model=rs.getString("MODEL");
		  color=rs.getString("COLOR");
		  cmrName=rs.getString("CMRNAME");
		  warrType=rs.getString("WARRTYPE");
		  softwareVer=rs.getString("SOFTWAREVER");
		  imei=rs.getString("IMEI");
		  dsn=rs.getString("DSN");
		  jamFreq=rs.getString("JAMFREQ");
		  fctDate=rs.getString("FCTDATE");
		  recDate=rs.getString("RECDATE");
		  jamCode=rs.getString("JAMCODE");
		  jamDesc=rs.getString("JAMDESC");
		  jamDesc2=rs.getString("JAMDESC2");
		  repLvlNo=rs.getString("REPLVLNO");
		  actRepDesc=rs.getString("ACTREPDESC");
		  repPersonID=rs.getString("REPPERSONID");
		  outGoingDate=rs.getString("OUTGOINGDATE");
		  buyDate=rs.getString("BUYDATE");
		  svrTypeName=rs.getString("SVRTYPENAME");  
		  */
	 }   // End of While rs.next()
		
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
   wwb.close();
    out.close(); 
	
// ** For outputstream
/*
  try 
  {
		
	FileInputStream is=new FileInputStream("\\resin-2.1.9\\webapps\\repair\\report\\"+userID+"_Query.xls");
	jxl.Workbook wb = Workbook.getWorkbook(is); 
	jxl.Sheet sh = wb.getSheet(0); 
	//int initFileSize = 1024*1024; // 1mb
	int initFileSize = 100; // 
	byte[] d = new byte[initFileSize];  
    int bytesRead = is.read(d);
	
	
	out.clearBuffer();
	//response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-disposition", "inline; filename="+"\\resin-2.1.9\\webapps\\repair\\report\\"+userID+"_Query.xls");
    //wb.write(out);
	response.getOutputStream().write(bytesRead);
    out.flush();
    //out.close();
	wb.close();	
  } 
  catch (FileNotFoundException fne) 
  {
    out.println("File not found...");
  } 
  catch (IOException ioe) 
  {
    out.println("IOException..." + 
    ioe.toString());
  }
*/	
	
/* //    Output to Browser	
     try 
	 {
      OutputStream out1 = response.getOutputStream();
   
      // SET THE MIME TYPE
      response.setContentType("application/vnd.ms-excel");
   
      // set content dispostion to attachment in 
      // case the open/save dialog needs to appear
      response.setHeader("Content-disposition", "inline; filename=c:\\test1.xls");
      //workBook.write(out1);
	  response.getOutputStream().write(out1);
      out1.flush();
      out1.close();
      } 
	  catch (FileNotFoundException fne) 
	  {
        System.out.println("File not found...");
      } 
	  catch (IOException ioe) 
	  {
        System.out.println("IOException..." + 
           ioe.toString());
      }
*/    
    }   // End of try
    catch (Exception e) 
    { 
	 out.println("Exception:"+e.getMessage()); 
     //e.printStackTrace(); 
    } 	
%>
<img src="../image/logo.gif"><BR>
<A HREF="/wins/WinsMainMenu.jsp">回首頁</A>&nbsp;&nbsp; <A HREF='/wins/report/<%=WSUserID%>_Query.xls?DATEBEGIN=<%=dateStringBegin%>&DATEEND=<%=dateStringEnd%>'> 
Product Forecast Information Excel View</A>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

