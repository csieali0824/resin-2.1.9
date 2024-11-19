<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<!--%@ page contentType="image/jpeg; charset=Big5" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*" %-->
<%@ page import="DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
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
  //String type=request.getParameter("TYPE");
  String region=request.getParameter("REGION");
  String country=request.getParameter("COUNTRY");
  String brand=request.getParameter("BRAND");

  //String YearFr=Integer.toString(dateBean.getYear());
  //String MonthFr=Integer.toString(dateBean.getMonth());
  String interModel=request.getParameter("INTERMODEL");   
  //String dateStringBegin="";
  //String dateStringEnd = "";
  String YearFr=request.getParameter("YEARFR"); 
  String MonthFr=request.getParameter("MONTHFR");
  String dateStringBegin = YearFr+MonthFr;         
  String YearTo=request.getParameter("YEARTO"); 
  String MonthTo=request.getParameter("MONTHTO");
  String dateStringEnd = YearTo+MonthTo;
  
  float vatBaseF = 1;

  if (interModel==null || interModel.equals("")) { interModel= ""; }

    try
    { 
     String sqlU = "select VAT from PSALES_COUNTRY_FACTOR where BASECOUNTRY = '86' and COUNTRY = '86' ";	
	 Statement stateU=con.createStatement();
	 ResultSet rsU=stateU.executeQuery(sqlU);
	 if (rsU.next())
	 { 
	  vatBaseF = 1+rsU.getFloat("VAT"); 
	 }
	 rsU.close();
	 stateU.close();
    } //end of try
    catch (Exception e)
    {
     out.println("Exception:"+e.getMessage());
    } 

  //if ( WSUserID == null || WSUserID.equals("")) { WSUserID = "KERWIN CHEN";  }
  
  //if (dateStringBegin==null || dateStringBegin==""){dateStringBegin=dateBean.getYearMonthDay();}
  //if (dateStringEnd==null || dateStringEnd==""){dateStringEnd=dateBean.getYearMonthDay();}
 /* 
  if (regionNo==null || regionNo==""){}
  else {regionNo=Integer.toString(Integer.parseInt(regionNo));}
  out.println(regionNo);
 */
  if (WSUserID==null){}   
  else
  {//out.println("<A HREF='/wins/report/"+WSUserID+"_ForecastPlanQuery.xls'>Sales Forecast Plan Excel View</A>");
  }	
    int modLength = 0;
  String modPlus = "";
  
  if (YearFr == null || YearFr.equals("--"))
  {}
  else 
  {
    //modLength = model.length();
	//modPlus =  model.substring(modLength-4,modLength);
	//out.println("modPlus ="+modPlus);
	//if (modPlus.equals("PLUS"))
	//{model = model.substring(0,modLength-4)+"+";}
	 
  }
  
 try 
    { 	
	 String sql = "";
	 String swhere  = "";
	 String sWhere = "";
	
	 String interModelGet = "";
     String sgmntFr = "";
     String sgmntTo = "";  
     String planYearMonth = "";       
	 String extModel = "";
	 String launchDate = "";
      float cogsF=0;
      float fwQtyF=0; 
      float fpPriceF=0;   
      float totFpPriceF = 0;  
      float fpExwPriceF = 0;
      float totFpExwPriceF = 0 ;
      float sellingProfitsF = 0;  
      float GrossMarginRateF = 0;    
      float vatF = 0; 
      float chnlProfitF = 0; 
      float totchnlProfitF = 0;  
      float chnlPRateF = 0;  
      float shipPriceCalF = 0; 
      float shipPriceGetF = 0;   
      float fpPriceGetF = 0; 
      float vatGetF = 1; 
      //float GrossMarginRateF = 0;                   
	 String cogs = "";
	 String fwQty = "";
	 String fpPrice = "";
	 String totFpPriceStr = "";
     String fpExwPrice = "";
     String totFpExwPriceStr = ""; 
     String sellProfitsStr = "";
     String GrossMRStr = "";  
     String chnlProfitStr = "";  
     String totchnlProfitStr = ""; 
     //String chnlPRateStr = ""; //
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
	 
	 sql = "select DISTINCT SEGMENT, SGMNT_FR, SGMNT_TO, FPYEAR, FPMONTH, SREGION, SCOUNTRY ,BRAND "+
		   "from PSALES_FORE_PRICE, PSALES_PRICE_SGMNT, PSALES_PROD_CENTER ";
	 //swhere = "where FPREG=SREGION and FPCOUN=SCOUNTRY and trim(SG_BRAND)=trim(BRAND) "+
     swhere = "where  "+
              //"and INTER_MODEL = FPPRJCD and FPPRI between SGMNT_FR and SGMNT_TO ";
              "INTER_MODEL = FPPRJCD and ISACTIVE='Y' ";                                   			  
									   
	 sWhere = " ";    
								  
	 if (region == null || region.equals("--")) { sWhere = sWhere + "and SREGION != '0'  "; }
	 else { sWhere = sWhere + "and SREGION ='"+region+"'  "; }                      			             
     if (country == null || country.equals("--")) { sWhere = sWhere + "and SCOUNTRY != '0'  "; }
	 else { sWhere = sWhere + "and SCOUNTRY = '"+country+"'  "; }
	 if (brand == null || brand.equals("--")) { sWhere = sWhere + "and trim(BRAND) != '0'  "; }
	 else { sWhere = sWhere + "and trim(BRAND) ='"+brand+"'  "; }
     if (interModel == null || interModel.equals("--")) { sWhere = sWhere + "and INTER_MODEL != '0'  "; }
	 else { sWhere = sWhere + "and INTER_MODEL = '"+interModel+"'  "; }	
     
     if ((!(MonthFr=="--")&&(MonthFr=="00")) && MonthTo=="--") sWhere=sWhere+" and FPYEAR || FPMONTH >="+"'"+dateStringBegin+"' ";
     if (MonthFr!="--" && MonthTo!="--") sWhere=sWhere+" and FPYEAR || FPMONTH between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";		
		  
	 String sOrder = "order by FPYEAR, FPMONTH, BRAND, SEGMENT ";
			
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
	OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\wins\\report\\"+WSUserID+"ForecastPlan_Query.xls"); 	
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("Forecast Table Plan", 0); 
	
	//jxl.format.Border fB = new jxl.format.Border(ALL);
	
	jxl.SheetSettings ss = new jxl.SheetSettings();
	ss.setSelected();
	ss.setVerticalFreeze(5);
    ss.setScaleFactor(50);
    ss.setZoomFactor(35);
	//ss.setShowGridLines(true);
	ss.setFitToPages(true);	

    jxl.write.WritableFont wfHD = new jxl.write.WritableFont(WritableFont.TIMES, 14,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfHD = new jxl.write.WritableCellFormat(wfHD); 
	//wcfHD.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelHD0 = new jxl.write.Label(0, 0, "DBTEL", wcfHD); 
    ws.addCell(labelHD0);
	ws.setColumnView(0, 15);

    jxl.write.WritableFont wfTitle = new jxl.write.WritableFont(WritableFont.TIMES, 14,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfTitle = new jxl.write.WritableCellFormat(wfTitle); 
	//wcfTitle.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelTitle0 = new jxl.write.Label(1, 0, "Price Plan Report", wcfTitle); 
    ws.addCell(labelTitle0);
	ws.setColumnView(1, 25);

    String rptGetDate = "Report Date:"+dateBean.getYearString()+"/"+dateBean.getMonthString()+"/"+dateBean.getDayString();
    jxl.write.WritableFont wfGetDate = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfGetDate = new jxl.write.WritableCellFormat(wfGetDate); 
	//wcfGetDate.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelGetDate = new jxl.write.Label(16, 0, rptGetDate, wcfGetDate); 
    ws.addCell(labelGetDate);
	ws.setColumnView(16, 25);

     String localeName = "";
     String curr = "";    
     try
     {
      String  sSqlL = "select a.LOCALE_NAME, b.CURR from WSLOCALE a, PSALES_COUNTRY_FACTOR b";		  
	  String sWhereL = " where a.LOCALE=b.COUNTRY and a.LOCALE='"+country+"'  ";		              
      sSqlL = sSqlL+sWhereL;
      Statement stateL=con.createStatement();
      ResultSet rsL=stateL.executeQuery(sSqlL);
      if (rsL.next()) 
      {  
       localeName=rsL.getString("LOCALE_NAME");
       curr=rsL.getString("CURR");
      }
      else {  out.println("&nbsp;"); }
      rsL.close();
      stateL.close();     
     } //end of try
     catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());		  
     }	
   
    String regionGet = "REGION :"+ region;
    jxl.write.WritableFont wfregion = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfregion = new jxl.write.WritableCellFormat(wfregion); 
	//wcfregion.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelregion = new jxl.write.Label(0, 1, regionGet, wcfregion); 
    ws.addCell(labelregion);
	ws.setColumnView(0, 25);

    String countryGet = "COUNTRY :"+ localeName;
    jxl.write.WritableFont wfcountry = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfcountry = new jxl.write.WritableCellFormat(wfcountry); 
	//wcfcountry.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelcountry = new jxl.write.Label(2, 1, countryGet, wcfcountry); 
    ws.addCell(labelcountry);
	ws.setColumnView(2, 25);
 /*
    String brandGet = "BRAND :"+ brand;
    jxl.write.WritableFont wfbrand = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfbrand = new jxl.write.WritableCellFormat(wfbrand); 
	wcfbrand.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelbrand = new jxl.write.Label(4, 1, brandGet, wcfbrand); 
    ws.addCell(labelbrand);
	ws.setColumnView(4, 25);

    String interModelCond = "INTERNAL MODEL :"+ interModel;
    jxl.write.WritableFont wfinterModel = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfinterModel = new jxl.write.WritableCellFormat(wfinterModel); 
	wcfinterModel.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelinterModel = new jxl.write.Label(6, 1, interModelCond, wcfinterModel); 
    ws.addCell(labelinterModel);
	ws.setColumnView(6, 25);
*/
    String dateFrGet = "PLAN DATE FROM :"+ YearFr+"/"+MonthFr;
    jxl.write.WritableFont wfdateFr = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfdateFr = new jxl.write.WritableCellFormat(wfdateFr); 
	//wcfdateFr.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labeldateFr = new jxl.write.Label(0, 2, dateFrGet, wcfdateFr); 
    ws.addCell(labeldateFr);
	ws.setColumnView(0, 30); 

    String dateToGet = "PLAN DATE TO :"+ YearTo+"/"+MonthTo;
    jxl.write.WritableFont wfdateTo = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfdateTo = new jxl.write.WritableCellFormat(wfdateTo); 
	//wcfdateTo.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labeldateTo = new jxl.write.Label(3, 2, dateToGet, wcfdateTo); 
    ws.addCell(labeldateTo);
	ws.setColumnView(4, 30);  

    String currGet = "Currency :"+ curr+"(W/O VAT except 價格帶)";
    jxl.write.WritableFont wfcurrGet = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfcurrGet = new jxl.write.WritableCellFormat(wfcurrGet); 
	//wcfdateTo.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelcurrGet = new jxl.write.Label(6, 2, currGet, wcfcurrGet); 
    ws.addCell(labelcurrGet);
	ws.setColumnView(6, 50); 

    //jxl.write.WritableFont wfYM = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.DARK_BLUE);
    jxl.write.WritableFont wfYM = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE);     
    jxl.write.WritableCellFormat wcfYM = new jxl.write.WritableCellFormat(wfYM); 
	wcfYM.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    wcfYM.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色	
    jxl.write.Label labelYM0 = new jxl.write.Label(0, 3, "日期", wcfYM); 
    
    ws.addCell(labelYM0);
	ws.setColumnView(1, 20);

    //jxl.write.WritableFont wfBR = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.DARK_BLUE);
    jxl.write.WritableFont wfBR = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE);          
    jxl.write.WritableCellFormat wcfBR = new jxl.write.WritableCellFormat(wfBR); 
	wcfBR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    wcfBR.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色	
    jxl.write.Label labelBR0 = new jxl.write.Label(1, 3, "系列", wcfBR); 
    
    ws.addCell(labelBR0);
	ws.setColumnView(0, 10);

    
			
	//file://抬頭:(第0列第1行) 
    jxl.write.WritableFont wf = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF = new jxl.write.WritableCellFormat(wf); 
	wcfF.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);   
    wcfF.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色	        
    jxl.write.Label labelCF0 = new jxl.write.Label(2, 3, "價格帶(含稅)", wcfF);   
    ws.addCell(labelCF0);
	ws.setColumnView(2, 20);
   
    //抬頭:(第0列第2行)
    jxl.write.WritableFont wfc = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfc); 
	wcfFC.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    wcfFC.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色	   
    jxl.write.Label labelCFC1 = new jxl.write.Label(3, 3, "內部型號", wcfFC); 
    ws.addCell(labelCFC1);
	ws.setColumnView(3, 20);
	//抬頭:(第0列第3行)
	//jxl.write.WritableFont wfB = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    //jxl.write.WritableCellFormat wcfFB = new jxl.write.WritableCellFormat(wfB);
	//wcfFB.setBackground(jxl.format.Colour.AQUA); // 設定背景顏色    
	jxl.write.Label labelCFC2 = new jxl.write.Label(4, 3, "外部型號", wcfFC); 
    ws.addCell(labelCFC2);
	ws.setColumnView(4, 20);
	//抬頭:(第0列第3行) 
    jxl.write.Label labelCF3 = new jxl.write.Label(5, 3, "上市日", wcfF); 
    ws.addCell(labelCF3);
	ws.setColumnView(5, 15);
	//抬頭:(第0列第4行)
	jxl.write.Label labelCF4 = new jxl.write.Label(6, 3, "銷貨成本", wcfF); 
    ws.addCell(labelCF4);
	ws.setColumnView(6, 10);
	//抬頭:(第0列第5行)
	jxl.write.Label labelCF5 = new jxl.write.Label(7, 3, "銷售量", wcfF); 
    ws.addCell(labelCF5);
	ws.setColumnView(7, 10);
	//抬頭:(第0列第6行)
	jxl.write.WritableFont wfcOrange = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
    jxl.write.WritableCellFormat wcfFCOrange = new jxl.write.WritableCellFormat(wfcOrange); 
	wcfFCOrange.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	jxl.write.Label labelCFC6 = new jxl.write.Label(8, 3, "最低零售價", wcfF); 
    ws.addCell(labelCFC6);
	ws.setColumnView(8, 10);
	//抬頭:(第0列第7行)
	//workingDateBean.setAdjWeek(1);
	//int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
	//String strWeek1 = Integer.toString(week1);
	jxl.write.Label labelCF7 = new jxl.write.Label(9, 3, "零售總額", wcfF); 
	//wcfFB.setBackground(jxl.format.Colour.YELLOW); // 設定背景顏色
    ws.addCell(labelCF7);
	ws.setColumnView(9, 10);
	//抬頭:(第0列第8行)
	//workingDateBean.setAdjWeek(1);
	//int week2 = Integer.parseInt(workingDateBean.getWorkingWeek());
	//String strWeek2 = Integer.toString(week2);
	jxl.write.Label labelCF8 = new jxl.write.Label(10, 3, "出廠價", wcfF); 
    ws.addCell(labelCF8);
	ws.setColumnView(10, 10);
	//抬頭:(第0列第9行) // 第3週
	//workingDateBean.setAdjWeek(1);
	//int week3 = Integer.parseInt(workingDateBean.getWorkingWeek());
	//String strWeek3 = Integer.toString(week3);
	jxl.write.Label labelCF9 = new jxl.write.Label(11, 3, "出廠總額", wcfF); 
    ws.addCell(labelCF9);
	ws.setColumnView(11, 10);
	//抬頭:(第0列第10行) // 第4週
	//workingDateBean.setAdjWeek(1);
	//int week4 = Integer.parseInt(workingDateBean.getWorkingWeek());
	//String strWeek4 = Integer.toString(week4);
	jxl.write.Label labelCFC10 = new jxl.write.Label(12, 3, "銷貨毛利", wcfF); 
    ws.addCell(labelCFC10);
	ws.setColumnView(12, 10);
	//抬頭:(第0列第11行) // 第5週
	//workingDateBean.setAdjWeek(1);
	//int week5 = Integer.parseInt(workingDateBean.getWorkingWeek());
	//String strWeek5 = Integer.toString(week5);
	jxl.write.Label labelCFC11 = new jxl.write.Label(13, 3, "毛利率", wcfF); 
    ws.addCell(labelCFC11);
	ws.setColumnView(13, 10);
	//抬頭:(第0列第12行) // 第6週
	//workingDateBean.setAdjWeek(1);
	//int week6 = Integer.parseInt(workingDateBean.getWorkingWeek());
	//String strWeek6 = Integer.toString(week6);
	jxl.write.Label labelCF12 = new jxl.write.Label(14, 3, "CHANNEL 每台利潤", wcfF); 
    ws.addCell(labelCF12);
	ws.setColumnView(14, 10);
	//抬頭:(第0列第13行) // 第7週
	//workingDateBean.setAdjWeek(1);
	//int week7 = Integer.parseInt(workingDateBean.getWorkingWeek());
	//String strWeek7 = Integer.toString(week7);
	jxl.write.Label labelCF13 = new jxl.write.Label(15, 3, "CHANNEL 總利潤", wcfF); 
    ws.addCell(labelCF13);
	ws.setColumnView(15, 10);
	//抬頭:(第0列第14行) // 第8週
	//workingDateBean.setAdjWeek(1);
	//int week8 = Integer.parseInt(workingDateBean.getWorkingWeek());
	//String strWeek8 = Integer.toString(week8);
	jxl.write.Label labelCF14 = new jxl.write.Label(16, 3, "CHANNEL 利潤率", wcfF); 
    ws.addCell(labelCF14);
	ws.setColumnView(16, 20);
	//抬頭:(第0列第15行) // 第9週
	//workingDateBean.setAdjWeek(1);
	//int week9 = Integer.parseInt(workingDateBean.getWorkingWeek());
	//String strWeek9 = Integer.toString(week9);
	//jxl.write.Label labelCF15 = new jxl.write.Label(15, 0, "Channel Profits Rate", wcfF); 
    //ws.addCell(labelCF15);
	//ws.setColumnView(15, 10);
	
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
		int rowNo = 4;
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

          // Price Segment 
          jxl.write.WritableFont wfLM = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          jxl.write.WritableCellFormat wcfFLM = new jxl.write.WritableCellFormat(wfLM);
		  //wcfFLM.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfFLM.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 

          planYearMonth = rs.getString("FPYEAR")+"/"+rs.getString("FPMONTH");       
          jxl.write.Label labelYM = new jxl.write.Label(0, rowNo, planYearMonth, wcfFLM); 
          ws.addCell(labelYM);

          jxl.write.Label lableBR = new jxl.write.Label(1, rowNo, rs.getString("BRAND") , wcfFLM); 
          ws.addCell(lableBR);     
    
          sgmntFr=rs.getString("SGMNT_FR");
          sgmntTo=rs.getString("SGMNT_TO");
		  if ((sgmntFr == null ||  sgmntFr.equals("")) || (sgmntTo == null ||  sgmntTo.equals("")) )
		  {
           sgmntFr ="";
           sgmntTo ="";   
          }	 
          else { sgmntFr = sgmntFr + "-" + sgmntTo; }       
	      jxl.write.Label lable11 = new jxl.write.Label(2, rowNo, sgmntFr , wcfFLM); 
          ws.addCell(lable11);   
		  // Price Segment 
  
         //int rowNoS = rowNo +1;       

          Statement stateIM=con.createStatement();
         /*
          String sqlIM = "select DISTINCT INTER_MODEL,EXT_MODEL,LAUNCH_DATE,FPEXWPRI,FPYEAR,FPMONTH,BRAND "+
                                   "from PSALES_FORE_EXWPRICE a, PSALES_PROD_CENTER c ";
          String whereIM = "where "+   // ?£?A Brand //
                           "trim(INTER_MODEL) = trim(FPPRJCD) and (FPEXWPRI+1 between '"+rs.getString("SGMNT_FR")+"' and '"+rs.getString("SGMNT_TO")+"') "+  // ?uRa°I?! ?£°I?A ?
                           "and FPYEAR='"+rs.getString("FPYEAR")+"' and FPMONTH='"+rs.getString("FPMONTH")+"' "+
                           "and BRAND='"+rs.getString("BRAND")+"' "+
                           "and FPMVER = (select max(FPMVER) from PSALES_FORE_EXWPRICE d where d.FPYEAR=a.FPYEAR and d.FPMONTH=a.FPMONTH and d.FPREG=a.FPREG and d.FPCOUN=a.FPCOUN and d.FPPRJCD=a.FPPRJCD) ";            
         */
          String sqlIM = "select DISTINCT trim(INTER_MODEL) as INTER_MODEL, EXT_MODEL, LAUNCH_DATE, FPPRI, FPRPRICE, FPYEAR, FPMONTH, b.BRAND, b.BRAND_ADJ "+
                         "from PSALES_FORE_PRICE a, PIBRAND b, PSALES_PROD_CENTER c ";
          String whereIM = "where FPRPRICE != 0 and b.BRAND = c.BRAND "+   // ?£?A Brand //
                           "and trim(INTER_MODEL) = trim(FPPRJCD) and (FPRPRICE+1 between '"+rs.getString("SGMNT_FR")+"' and '"+rs.getString("SGMNT_TO")+"') "+  // ?uRa°I?! ?£°I?A ?
                           "and FPYEAR='"+rs.getString("FPYEAR")+"' and FPMONTH='"+rs.getString("FPMONTH")+"' "+
                           "and b.BRAND='"+rs.getString("BRAND")+"' "+
                           "and FPMVER = (select max(FPMVER) from PSALES_FORE_PRICE d where d.FPYEAR=a.FPYEAR and d.FPMONTH=a.FPMONTH and d.FPREG=a.FPREG and d.FPCOUN=a.FPCOUN and trim(d.FPPRJCD)=trim(a.FPPRJCD)) ";                   
                
          if (interModel == null || interModel.equals("--")) { whereIM = whereIM + "and INTER_MODEL != '0'  "; }
		  else {whereIM = whereIM + "and trim(INTER_MODEL) = '"+interModel+"'  "; }        

		  sqlIM = sqlIM + whereIM;
		  out.println(sqlIM);
		  ResultSet rsIM=stateIM.executeQuery(sqlIM);					
		  while (rsIM.next())
		  { 
                     //shipPriceCal = rsIM.getFloat("FPPRI");     
            Statement stateEXWPrice=con.createStatement();
            String sqlEXWPrice = "select FPEXWPRI,VAT from PSALES_FORE_EXWPRICE a, PSALES_COUNTRY_FACTOR b where FPYEAR = '"+rsIM.getString("FPYEAR")+"' and FPMONTH='"+rsIM.getString("FPMONTH")+"' "+
                                 ///*2004/05/31 取消檢查落於價格帶限制,以取出產品出廠價 */ "and FPREG='"+region+"' and to_char(FPCOUN)='"+country+"' and (FPEXWPRI+1 between '"+rs.getString("SGMNT_FR")+"' and '"+rs.getString("SGMNT_TO")+"') "+
                                 "and FPREG='"+region+"' and to_char(FPCOUN)='"+country+"' "+
                                 "and trim(FPPRJCD)='"+rsIM.getString("INTER_MODEL")+"' "+
                                 "and FPCOUN= BASECOUNTRY and FPYEAR='"+rs.getString("FPYEAR")+"' and FPMONTH='"+rs.getString("FPMONTH")+"' and COUNTRY='"+rs.getString("SCOUNTRY")+"' and trim(FPPRJCD)='"+rsIM.getString("INTER_MODEL")+"' "+
                                 "and FPMVER = (select max(FPMVER) from PSALES_FORE_EXWPRICE c where c.FPYEAR=a.FPYEAR and c.FPMONTH=a.FPMONTH and c.FPREG=a.FPREG and c.FPCOUN=a.FPCOUN and trim(c.FPPRJCD)=trim(a.FPPRJCD)) ";
                     //out.println(sqlEXWPrice); 
            ResultSet rsEXWPrice=stateEXWPrice.executeQuery(sqlEXWPrice);
            if (rsEXWPrice.next()) 
            { 
             shipPriceGetF = rsEXWPrice.getFloat("FPEXWPRI");
             vatGetF = 1+rsEXWPrice.getFloat("VAT");     
            }
            else { shipPriceGetF = 0; }      

            //shipPriceCalF = (rsIM.getFloat("FPPRI")/vatBaseF)*rsIM.getFloat("BRAND_ADJ"); //改取最近不為零之零售價 //
            if (rsIM.getFloat("FPPRI")==0)
            {
             shipPriceCalF = (rsIM.getFloat("FPRPRICE")/vatBaseF)*rsIM.getFloat("BRAND_ADJ"); 
            }
            else 
            { shipPriceCalF = (rsIM.getFloat("FPPRI")/vatBaseF)*rsIM.getFloat("BRAND_ADJ"); }
                       

            if (shipPriceGetF>=shipPriceCalF && shipPriceCalF != 0) { fpPriceGetF = shipPriceCalF; }  // 取二者較小且零售價不為零者
            else if (shipPriceGetF>=shipPriceCalF && shipPriceCalF == 0) { fpPriceGetF = shipPriceGetF; } 
            else if (shipPriceGetF<=shipPriceCalF && shipPriceGetF != 0) { fpPriceGetF = shipPriceGetF; }
            else if (shipPriceGetF<=shipPriceCalF && shipPriceGetF == 0) { fpPriceGetF = shipPriceCalF; }             
          //jxl.write.WritableFont wfcOrange = new jxl.write.WritableFont(WritableFont.ARIAL,12,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.ORANGE); 
          //jxl.write.WritableCellFormat wcfFCOrange = new jxl.write.WritableCellFormat(wfcOrange); 
                
		  noSeq = noSeq + 1;
		  noSeqStr = Integer.toString(noSeq);
		  jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		  //wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);   
	      
		 // jxl.write.Label lableCFD = new jxl.write.Label(colNo-1, rowNo, noSeqStr , wcfFL); 		 
         //  ws.addCell(lableCFD);
		  
		  //out.println(noSeq);  
		 
		  
		  //noSeqStr = integer.toString(noSeq);
		  interModelGet=rsIM.getString("INTER_MODEL");
		  if ((interModelGet == null ||  interModelGet.equals("")))
		  {interModelGet ="";}	 
	      jxl.write.Label lable100 = new jxl.write.Label(3, rowNo, interModelGet , wcfFL); 
          ws.addCell(lable100);
		  		  
		  //out.println(designHouse);

          jxl.write.WritableFont wfB = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
          jxl.write.WritableCellFormat wcfB = new jxl.write.WritableCellFormat(wfB);
		  //wcfB.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);     
		  
		  //noSeqStr = integer.toString(noSeq);
		  extModel=rsIM.getString("EXT_MODEL");
		  if ((extModel == null ||  extModel.equals("")))
		  {extModel ="";}		 		       
	      jxl.write.Label lable21 = new jxl.write.Label(4, rowNo, extModel , wcfB); 
          ws.addCell(lable21);
		  //out.println(systemMode);
		  
		  launchDate=rsIM.getString("LAUNCH_DATE");
		  if ((launchDate == null ||  launchDate.equals("")))
		  {launchDate ="";}
          launchDate = launchDate.substring(0,2)+"/"+ launchDate.substring(2,6);

		  jxl.write.Label lable31 = new jxl.write.Label(5, rowNo, launchDate , wcfFL); 
          ws.addCell(lable31);
		  //out.println(fwReg);

        try
        {
          String V1 = "";
		  //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		  String sqlV1 = "select FCCOGS, LL_BASECOUN,  LL_COUN_ADJ, EX_RATE  from PSALES_FORE_COGS a, PSALES_COUNTRY_FACTOR b where FCCOUN= BASECOUNTRY and FCYEAR='"+rs.getString("FPYEAR")+"' and FCMONTH='"+rs.getString("FPMONTH")+"' and COUNTRY='"+rs.getString("SCOUNTRY")+"' and FCPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                         "and FCMVER = (select max(FCMVER) from  PSALES_FORE_COGS d where d.FCYEAR=a.FCYEAR and d.FCMONTH=a.FCMONTH and d.FCREG=a.FCREG and d.FCCOUN=a.FCCOUN and d.FCPRJCD=a.FCPRJCD ) ";			  
		  //sqlV1 = sqlV1 + sWhereTC;
		  //out.println(sqlV1);
		  Statement stateV1=con.createStatement();
		  ResultSet rsV1=stateV1.executeQuery(sqlV1);
		  if (rsV1.next())
		  {
               
           //cogs=Float.toString((rsV1.getFloat("FCCOGS")- rsV1.getFloat("LL_BASECOUN"))+(rsV1.getFloat("LL_COUN_ADJ")*rsV1.getFloat("EX_RATE")));
           //cogsF=(rsV1.getFloat("FCCOGS")-rsV1.getFloat("LL_BASECOUN"))+(rsV1.getFloat("LL_COUN_ADJ")*rsV1.getFloat("EX_RATE"));
           cogs=Float.toString((rsV1.getFloat("FCCOGS")- rsV1.getFloat("LL_BASECOUN"))+(rsV1.getFloat("LL_COUN_ADJ")));
           cogsF=(rsV1.getFloat("FCCOGS")-rsV1.getFloat("LL_BASECOUN"))+(rsV1.getFloat("LL_COUN_ADJ"));        
            
           out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+cogs);
           int cogsInt=0;
           cogsInt = Math.round(cogsF);          
           jxl.write.Number lable41 = new jxl.write.Number(6, rowNo, cogsInt , wcfB);  // Roundup Integer Display
           ws.addCell(lable41);    
          }
		  else
		  {
           cogs ="---";
           jxl.write.Label lable41 = new jxl.write.Label(6, rowNo, cogs , wcfB);  // Roundup Integer Display
           ws.addCell(lable41);             
          }
		   rsV1.close();
		   stateV1.close();	     
		} //end of try
        catch (Exception e)
        {
         out.println("Exception:"+e.getMessage());		  
        }	
        /*     		  
          int cogsInt=0;
          cogsInt = Math.round(cogsF); 
		  if ((cogs == null ||  cogs.equals("")))
		  {cogs ="";}
		  //jxl.write.Label lable41 = new jxl.write.Label(6, rowNo, cogs , wcfB);
          //jxl.write.Number lable41 = new jxl.write.Number(6, rowNo, cogsF , wcfB);//Float Display
          jxl.write.Number lable41 = new jxl.write.Number(6, rowNo, cogsInt , wcfB);  // Roundup Integer Display
          ws.addCell(lable41);
		  //out.println(fwCoun);
          cogsF = 0;          
          // 將上一個cogsF清空 //           
        */
           try
           {
            String V1 = "";
			/*
		    String sqlV1 = "select sum(FWQTY) as SUMFWQTY from PSALES_FORE_WEEK a  where FWYEAR='"+rs.getString("FPYEAR")+"' and FWMONTH='"+rs.getString("FPMONTH")+"' and FWREG='"+rs.getString("SREGION")+"' and FWCOUN='"+rs.getString("SCOUNTRY")+"' and FWPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                           "and FWWVER = (select max(FWWVER) from PSALES_FORE_WEEK b where b.FWYEAR=a.FWYEAR "+
                           " and b.FWMONTH=a.FWMONTH and b.FWREG=a.FWREG and b.FWCOUN=a.FWCOUN and b.FWPRJCD=a.FWPRJCD) ";			  
            */           
            String sqlV1 = "select FMQTY as SUMFWQTY from PSALES_FORE_MONTH a  where FMYEAR='"+rs.getString("FPYEAR")+"' and FMMONTH='"+rs.getString("FPMONTH")+"' and FMREG='"+rs.getString("SREGION")+"' and FMCOUN='"+rs.getString("SCOUNTRY")+"' and FMPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FMVER = (select max(FMVER) from PSALES_FORE_MONTH b where b.FMYEAR=a.FMYEAR "+
                                                    "and b.FMMONTH=a.FMMONTH and b.FMREG=a.FMREG and b.FMCOUN=a.FMCOUN and b.FMPRJCD=a.FMPRJCD and b.FMTYPE IS NOT NULL) "+
                                     "and FMTYPE IS NOT NULL";     
			//sqlV1 = sqlV1 + sWhereTC;
			//out.println(sqlV1);
		    Statement stateV1=con.createStatement();
		    ResultSet rsV1=stateV1.executeQuery(sqlV1);
		    if (rsV1.next())
		    {
             //out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+rsV1.getString("SUMFWQTY"));
             fwQty =  Float.toString(rsV1.getFloat("SUMFWQTY"));
             fwQtyF = rsV1.getFloat("SUMFWQTY");
                       if (rsV1.getString("SUMFWQTY")!=null && !rsV1.getString("SUMFWQTY").equals(""))          
                       {
                         fwQty =  Float.toString(rsV1.getFloat("SUMFWQTY"));
                         fwQtyF = rsV1.getFloat("SUMFWQTY");  
                         
                         jxl.write.Number lable51 = new jxl.write.Number(7, rowNo, fwQtyF , wcfB);
                         ws.addCell(lable51); 
                         out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+rsV1.getString("SUMFWQTY"));                                  
                       }
                       else
			           {
                         fwQty = "---";
                         fwQtyF = 0;    

                         jxl.write.Label lable51 = new jxl.write.Label(7, rowNo, fwQty , wcfB);
                         ws.addCell(lable51);  
                         out.println("---");
                       }               
            }
			else
			{
                fwQty = "---";
                fwQtyF = 0;    
                jxl.write.Label lable51 = new jxl.write.Label(7, rowNo, fwQty , wcfB);
                ws.addCell(lable51);                  
                out.println("---");
            }
			 rsV1.close();
		     stateV1.close();	
            } //end of try
            catch (Exception e)
            {
             out.println("Exception:"+e.getMessage());		  
            }	
		  
		  /*
		  if ((fwQty == null ||  fwQty.equals("")))
		  {fwQty ="";}
		  //jxl.write.Label lable51 = new jxl.write.Label(7, rowNo, fwQty , wcfB); 
          jxl.write.Number lable51 = new jxl.write.Number(7, rowNo, fwQtyF , wcfB);
          ws.addCell(lable51);
		  //out.println(fwType);
          */
           try
           {
             String V1 = "";
			 
             //String sqlV1 = "select FPPRI, EXW_ADJ, GM_INDEX from PSALES_FORE_PRICE a, PSALES_COUNTRY_FACTOR b, PSALES_AGENT_GMIDX c where FPCOUN= BASECOUNTRY and FPPRJCD= c.INT_MODEL and FPYEAR='"+rs.getString("FPYEAR")+"' and FPMONTH='"+rs.getString("FPMONTH")+"' and b.COUNTRY='"+rs.getString("SCOUNTRY")+"' and FPPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
             //               "and FPMVER = (select max(FPMVER) from PSALES_FORE_PRICE d where d.FPYEAR=a.FPYEAR and d.FPMONTH=a.FPMONTH and d.FPREG=a.FPREG and d.FPCOUN=a.FPCOUN and d.FPPRJCD=a.FPPRJCD) ";
             String sqlV1 = "select max(FPPRI) as FPPRI, EXW_ADJ, GM_INDEX, VAT  from PSALES_FORE_PRICE a, PSALES_COUNTRY_FACTOR b, PSALES_AGENT_GMIDX c where FPCOUN= b.COUNTRY and trim(FPPRJCD)= trim(c.INT_MODEL) and b.COUNTRY='"+rs.getString("SCOUNTRY")+"' and trim(FPPRJCD)='"+rsIM.getString("INTER_MODEL")+"' "+
                            "and FPMVER = (select max(FPMVER) from PSALES_FORE_PRICE d where d.FPYEAR=a.FPYEAR and d.FPMONTH=a.FPMONTH and d.FPREG=a.FPREG and d.FPCOUN=a.FPCOUN and d.FPPRJCD=a.FPPRJCD) "+
                            "group by EXW_ADJ, GM_INDEX, VAT";			  
			 //sqlV1 = sqlV1 + sWhereTC;
			 //out.println(sqlV1);
		     Statement stateV1=con.createStatement();
		     ResultSet rsV1=stateV1.executeQuery(sqlV1);
		     if (rsV1.next())
		     {
              fpPrice = Float.toString((rsV1.getFloat("FPPRI"))/(1+rsV1.getFloat("VAT")));
              fpPriceF = (rsV1.getFloat("FPPRI"))/(1+rsV1.getFloat("VAT"));
              out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+fpPrice);      
              //fpPrice =  Float.toString((rsV1.getFloat("FPEXWPRI")*rsV1.getFloat("EXW_ADJ"))/(1-rsV1.getFloat("GM_INDEX")));   
              //fpPriceF = (rsV1.getFloat("FPEXWPRI")*rsV1.getFloat("EXW_ADJ"))/(1-rsV1.getFloat("GM_INDEX"));   
             }
			 else
			 {

                String sqlV2 = "select EXW_ADJ, GM_INDEX, VAT  from PSALES_COUNTRY_FACTOR b, PSALES_AGENT_GMIDX c "+
                               "where trim(c.INT_MODEL)='"+rsIM.getString("INTER_MODEL")+"' and b.COUNTRY='"+rs.getString("SCOUNTRY")+"' ";
                Statement stateV2=con.createStatement();
		        ResultSet rsV2=stateV2.executeQuery(sqlV2);                 
                if (rsV2.next())
		        { 
                   fpPriceF =  (fpPriceGetF*rsV2.getFloat("EXW_ADJ"))/(1-rsV2.getFloat("GM_INDEX")); 
                   fpPrice = Float.toString((fpPriceGetF*rsV2.getFloat("EXW_ADJ"))/(1-rsV2.getFloat("GM_INDEX")));     
                    //fpPrice = (Math.round(fpPriceGet)*Math.round(rsV2.getFloat("EXW_ADJ")))/( Math.round(1-rsV2.getFloat("GM_INDEX")) );            
                }  
                else 
                { 
                  fpPriceF = 0; 
                }
                //fpPriceInt = Math.round(fpPriceF); 
                 //fpPriceInt = (Math.round(fpPriceGet)*Math.round(rsV2.getFloat("EXW_ADJ")))/( Math.round(1-rsV2.getFloat("GM_INDEX")) ) 
                out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+fpPrice); 
                //out.println("---");      
                rsV2.close();
		        stateV2.close(); 
              /*
              fpPrice =  Float.toString((fpPriceGetF*rsV1.getFloat("EXW_ADJ"))/(1-rsV1.getFloat("GM_INDEX")));   
              fpPriceF = (fpPriceGetF*rsV1.getFloat("EXW_ADJ"))/(1-rsV1.getFloat("GM_INDEX"));
              */  
              /*    
              fpPriceF = 0;           
              out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+"---");  
              //out.println("---");
              */
             }
			  rsV1.close();
		      stateV1.close();	
           } //end of try
           catch (Exception e)
           {
             out.println("Exception:"+e.getMessage());		  
           }	    
              		  
          int fpPriceInt = 0;
		  fpPriceInt=Math.round(fpPriceF);
       /*            
		  if ((fpPrice == null ||  fpPrice.equals("")))
		  {
              fpPrice ="";
              //out.println("step1");  
              jxl.write.Label lable61 = new jxl.write.Label(8, rowNo, fpPrice , wcfFL);
              ws.addCell(lable61);
          }		
          else
          {   //out.println("step2"); 
              if (fpPrice=="0" || fpPrice.equals("0")) { fpPriceInt = 0; out.println("step3");  }
              else {//out.println(fpPrice);  
                    //out.println("step5"); 
                                
                    int fpPricePoint = fpPrice.indexOf('.');
                    //out.println("step6"); 
                    if (fpPricePoint>=0)
                    {         
                    fpPrice = fpPrice.substring(0,fpPricePoint);
                    }            
                    fpPriceInt = Integer.parseInt(fpPrice);  
                    //out.println("step7");
                    
                   }
              jxl.write.Number lable61 = new jxl.write.Number(8, rowNo, fpPriceInt , wcfFL); 
              ws.addCell(lable61);  
          } 
          */	  
		  //
           jxl.write.Number lable61 = new jxl.write.Number(8, rowNo, fpPriceInt , wcfFL); 
           ws.addCell(lable61);       
          
		  //out.println(fwPrjCD);


          jxl.write.WritableFont wfR = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
          jxl.write.WritableCellFormat wcfR = new jxl.write.WritableCellFormat(wfR);
		  //wcfR.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 

          int totFpPriceInt =0;         
          totFpPriceF=fpPriceF*fwQtyF;
          //totFpPriceInt = Math.round(fpPriceF)*Math.round(fwQtyF); // 2004/05/19 //
          totFpPriceF = Math.round(fpPriceF)*fwQtyF;
          totFpPriceInt = Math.round(totFpPriceF);                       
          /*  
          totFpPriceStr =  Float.toString(totFpPriceF);     
          int totFpPricePoint = totFpPriceStr.indexOf('.');  // ????? //
           // out.println("sellProfitsPoin"+sellProfitsPoint);
          totFpPriceStr = totFpPriceStr.substring(0,totFpPricePoint); 
                                  
		  int totFpPriceInt = 0;
		  //fwColor=rs.getString("FWCOLOR");
		  if ((totFpPriceStr== null ||  totFpPriceStr.equals("")))
		  {
              totFpPriceStr ="";
              jxl.write.Label lable71 = new jxl.write.Label(9, rowNo, totFpPriceStr , wcfR);
          }
          else
          {   //out.println("step2"); 
              if (totFpPriceStr=="0" || totFpPriceStr.equals("0")) { totFpPriceInt = 0;  }
              else {     
                    totFpPriceInt = Integer.parseInt(totFpPriceStr);                     
                   }
              jxl.write.Number lable71 = new jxl.write.Number(9, rowNo, totFpPriceInt, wcfR); 
              ws.addCell(lable71); 
          } 	
          */
          jxl.write.Number lable71 = new jxl.write.Number(9, rowNo, totFpPriceInt, wcfR); 
          ws.addCell(lable71);                      
		  //jxl.write.Label lable71 = new jxl.write.Label(9, rowNo, totFpPriceStr , wcfR);
          
		  //out.println(fwColor);
		  
		  // int week1 = Integer.parseInt(workingDateBean.getWorkingWeek())+1;
		   try
           {
              String V1 = "";
			  //String sqlV1 = "select FPEXWPRI, EXW_ADJ  from PSALES_FORE_EXWPRICE a, PSALES_COUNTRY_FACTOR b where FPCOUN= BASECOUNTRY and FPYEAR='"+rs.getString("FPYEAR")+"' and FPMONTH='"+rs.getString("FPMONTH")+"' and COUNTRY='"+rs.getString("SCOUNTRY")+"' and FPPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
              //               "and FPMVER = (select max(FPMVER) from PSALES_FORE_EXWPRICE c where c.FPYEAR=a.FPYEAR and c.FPMONTH=a.FPMONTH and c.FPREG=a.FPREG and c.FPCOUN=a.FPCOUN and c.FPPRJCD=a.FPPRJCD) ";		      		  
			  String sqlV1 = "select FPPRI, EXW_ADJ  from PSALES_FORE_PRICE a, PSALES_COUNTRY_FACTOR b where FPCOUN= BASECOUNTRY and FPYEAR='"+rs.getString("FPYEAR")+"' and FPMONTH='"+rs.getString("FPMONTH")+"' and COUNTRY='"+rs.getString("SCOUNTRY")+"' and FPPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                             "and FPMVER = (select max(FPMVER) from PSALES_FORE_PRICE c where c.FPYEAR=a.FPYEAR and c.FPMONTH=a.FPMONTH and c.FPREG=a.FPREG and c.FPCOUN=a.FPCOUN and c.FPPRJCD=a.FPPRJCD) ";
			//out.println(sqlV1);
		      Statement stateV1=con.createStatement();
		      ResultSet rsV1=stateV1.executeQuery(sqlV1);
		      if (rsV1.next())
		      {
               fpExwPrice = Float.toString(fpPriceGetF*rsV1.getFloat("EXW_ADJ"));
               fpExwPriceF = fpPriceGetF*rsV1.getFloat("EXW_ADJ"); 
               out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+fpExwPrice);     
              }
			  else
			  {out.println("---");}
			   rsV1.close();
		       stateV1.close();	
          } //end of try
          catch (Exception e)
          {
           out.println("Exception:"+e.getMessage());		  
          }	 

          int fpExwPriceInt = 0;
          fpExwPriceInt = Math.round(fpExwPriceF);      
		  //fwPrjCD=rs.getString("FWPRJCD");
         /*          
		  if ((fpExwPrice == null ||  fpExwPrice.equals("")))
		  {
              fpExwPrice ="";
              //out.println("step1");  
              jxl.write.Label lable81 = new jxl.write.Label(10, rowNo, fpExwPrice, wcfR);
              ws.addCell(lable81);
          }		
          else
          {   //out.println("step2"); 
              if (fpExwPrice=="0" || fpExwPrice.equals("0")) { fpExwPriceInt = 0;  }
              else {//out.println(fpPrice);  
                    //out.println("step5");   
                    int fpExwPricePoint = fpExwPrice.indexOf('.');
                    //out.println("step6"); 
                    if (fpExwPricePoint>=0)
                    {         
                    fpExwPrice = fpExwPrice.substring(0,fpExwPricePoint);
                    }            
                    fpExwPriceInt = Integer.parseInt(fpExwPrice);  
                    //out.println("step7");  
                   }
              jxl.write.Number lable81 = new jxl.write.Number(10, rowNo, fpExwPriceInt, wcfR);   
              ws.addCell(lable81); 
          } 	    
         */
		 jxl.write.Number lable81 = new jxl.write.Number(10, rowNo, fpExwPriceInt, wcfR);   
         ws.addCell(lable81);  
		  //jxl.write.Label lable81 = new jxl.write.Label(10, rowNo, fpExwPrice, wcfR);
          
		  
		  totFpExwPriceF=fpExwPriceF*fwQtyF; 
        /*
             totFpExwPriceStr =  Float.toString(totFpExwPriceF);     
             int totFpExwPricePoint =totFpExwPriceStr.indexOf('.');  // ????? //             
             totFpExwPriceStr = totFpExwPriceStr.substring(0,totFpExwPricePoint); 
        */
		     //int totFpExwPriceInt = Math.round(fpExwPriceF)*Math.round(fwQtyF); // 2004/05/19 //
                  totFpExwPriceF = Math.round(fpExwPriceF)*fwQtyF;
             int  totFpExwPriceInt = Math.round(totFpExwPriceF);      
		  //jxl.write.Label lable91 = new jxl.write.Label(11, rowNo, totFpExwPriceStr , wcfR); 
          jxl.write.Number lable91 = new jxl.write.Number(11, rowNo, totFpExwPriceInt, wcfR);
          ws.addCell(lable91);
		  
          int sellProfitsInt = 0;
		  sellingProfitsF=totFpExwPriceF-(fwQtyF*cogsF);   
          //sellProfitsInt = Math.round(totFpExwPriceF)-(Math.round(fwQtyF)*Math.round(cogsF)); 
		  //sellProfitsInt = Math.round(fpExwPriceF)*Math.round(fwQtyF)-(Math.round(fwQtyF)*Math.round(cogsF));  // 2004/05/19 //
          sellingProfitsF = Math.round(fpExwPriceF)*fwQtyF-(Math.round(fwQtyF)*Math.round(cogsF));   
          sellProfitsInt = Math.round(sellingProfitsF);              
        /*                 
          if (sellingProfitsF>=0) 
          { 
           sellProfitsStr =  Float.toString(sellingProfitsF);     
           int sellProfitsPoint = sellProfitsStr.indexOf('.');  // ????? //
                // out.println("sellProfitsPoin"+sellProfitsPoint);
           sellProfitsStr = sellProfitsStr.substring(0,sellProfitsPoint); 
           sellProfitsInt = Integer.parseInt(sellProfitsStr); 
           jxl.write.Number lable101 = new jxl.write.Number(12, rowNo, sellProfitsInt, wcfR);   
           ws.addCell(lable101);          
          }       
		  else { 
                sellProfitsStr = "---"; 
                jxl.write.Label lable101 = new jxl.write.Label(12, rowNo, sellProfitsStr, wcfR);
                ws.addCell(lable101);    
               }
         */        
          jxl.write.Number lable101 = new jxl.write.Number(12, rowNo, sellProfitsInt, wcfR);   
          ws.addCell(lable101);      
            
		  //
          
		  
		  GrossMRStr = "";
          int GMRLength = 0;
          if (fpExwPriceF>=0 && sellingProfitsF>=0)
          {
            //out.println ("totFpExwPrice="+totFpExwPrice);
            //out.println ("sellingProfits="+sellingProfits);  
             //GrossMarginRateF=(sellingProfitsF/totFpExwPriceF)*100; // 2004/05/18 改採另類計算毛利率方式,避免因無數量導致毛利率無法計算
             float GrossMarginRateFTemp = Math.round(fpExwPriceF)-Math.round(cogsF);
             float fpExwPriceFTemp = Math.round(fpExwPriceF);
             GrossMarginRateF=(GrossMarginRateFTemp/fpExwPriceFTemp)*100; 
             GrossMRStr=Float.toString(GrossMarginRateF);
             
             GMRLength = GrossMRStr.length();
             if (GMRLength>=4)
             {
              GrossMRStr=GrossMRStr.substring(0,4)+"%"; 
             }
             else { GrossMRStr=GrossMRStr.substring(0,3)+"%";  } 

             if (GrossMarginRateF==0 || GrossMRStr=="NaN%" || GrossMRStr.equals("NaN%") )
             { GrossMRStr = "---"; }     
          }
          else { GrossMRStr = "---"; }  	  
		  
		  jxl.write.Label lable111 = new jxl.write.Label(13, rowNo, GrossMRStr , wcfR); 
          ws.addCell(lable111);
		  
		  try
          {
           String V1 = "";
		   //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		   String sqlV1 = "select VAT from PSALES_COUNTRY_FACTOR where REGION='"+rs.getString("SREGION")+"' and COUNTRY='"+rs.getString("SCOUNTRY")+"'  ";			  
		   //sqlV1 = sqlV1 + sWhereTC;
		   //out.println(sqlV1);
		   Statement stateV1=con.createStatement();
		   ResultSet rsV1=stateV1.executeQuery(sqlV1);
		   if (rsV1.next())
		   {
             //out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+rsV1.getString("FCCOGS"));
             vatF = 1+rsV1.getFloat("VAT");
             if (vatF !=0)
             {    
              chnlProfitF=(fpPriceF-fpExwPriceF);
              //chnlProfitF=(fpPriceF/vatF - fpExwPriceF);            
             /*
              chnlProfitStr=Float.toString(chnlProfitF);  
              int chlProfitPoint=chnlProfitStr.indexOf('.');   // ????? //
              chnlProfitStr =  chnlProfitStr.substring(0, chlProfitPoint);  // ??????? //
             */
              if (chnlProfitF>=0) { }
              else { chnlProfitStr = "---"; } 
              out.println(chnlProfitStr);
             }
             else
             {
               out.println("---");  
             }        
          }
		  else
		  {out.println("---");}
		  rsV1.close();
		  stateV1.close();	
        } //end of try
        catch (Exception e)
        {
         out.println("Exception:"+e.getMessage());		  
        }	 
		  jxl.write.WritableFont wfY = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK); 
          jxl.write.WritableCellFormat wcfY = new jxl.write.WritableCellFormat(wfY);
		  //wcfY.setBackground(jxl.format.Colour.YELLOW); // 設定背景顏色	 
		  wcfY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  

          int chnlProfitInt = 0;
		            
          if (chnlProfitF>=0) 
          { 
           
           chnlProfitInt = Math.round(fpPriceF)-Math.round(fpExwPriceF);
           jxl.write.Number lable121 = new jxl.write.Number(14, rowNo, chnlProfitInt, wcfY);  
           ws.addCell(lable121);         
          }       
		  else { 
                chnlProfitStr = "---"; 
                jxl.write.Label lable121 = new jxl.write.Label(14, rowNo, chnlProfitStr , wcfY);
                ws.addCell(lable121);    
               }
 
		  //jxl.write.Label lable121 = new jxl.write.Label(14, rowNo, chnlProfitStr , wcfY);
          
		  int totchnlProfitInt = 0;
          if (chnlProfitF>=0)    
          {
		   totchnlProfitF = chnlProfitF*fwQtyF;
          /*            
           totchnlProfitStr=Float.toString(totchnlProfitF);  
           int totchnlProfitPoint=totchnlProfitStr.indexOf('.');   // ????? //
           totchnlProfitStr =  totchnlProfitStr.substring(0, totchnlProfitPoint);  // ??????? //   
          */         
           //totchnlProfitInt = Math.round(chnlProfitF)*Math.round(fwQtyF); 
		   //totchnlProfitInt = (Math.round(fpPriceF)-Math.round(fpExwPriceF))*Math.round(fwQtyF); // 2004/05/19 //
           totchnlProfitF = (Math.round(fpPriceF)-Math.round(fpExwPriceF))*fwQtyF;  
           totchnlProfitInt = Math.round(totchnlProfitF);    
           jxl.write.Number lable131 = new jxl.write.Number(15, rowNo, totchnlProfitInt , wcfR);     
           ws.addCell(lable131);
          }    
		  else { 
                 totchnlProfitStr = "---"; 
                 jxl.write.Label lable131 = new jxl.write.Label(15, rowNo, totchnlProfitStr , wcfR);    
                 ws.addCell(lable131);
               }
             
              
		  //jxl.write.Label lable131 = new jxl.write.Label(15, rowNo, totchnlProfitStr , wcfR);
          

          String chnlPRateStr = "";
          int chnlPRateLength = 0;
          if (vatF!=0 && fpPriceF !=0 )
          {
              float chnlPRateFTemp = Math.round(fpPriceF)- Math.round(fpExwPriceF);
              float fpPriceFTemp = Math.round(fpPriceF);     
              chnlPRateF=(chnlPRateFTemp)/(fpPriceFTemp)*100;
              //out.println("((fpPrice/vat)-fpExwPrice)/(fpPrice)*100="+chnlPRate);
              chnlPRateStr=Float.toString(chnlPRateF); 
             
              chnlPRateLength = chnlPRateStr.length();
              if (chnlPRateLength>=4)
              {
               chnlPRateStr=chnlPRateStr.substring(0,4); 
              }
              else { chnlPRateStr=chnlPRateStr.substring(0,3);  }  
              chnlPRateStr = chnlPRateStr + "%";    
              out.println(chnlPRateStr+"%");
         }
         else { chnlPRateStr = "---"; }
 
         jxl.write.Label lable141 = new jxl.write.Label(16, rowNo, chnlPRateStr , wcfR); 
         ws.addCell(lable141);  

		rowNo = rowNo + 1;  
        rsEXWPrice.close();      
        stateEXWPrice.close();
	   }  // end of while rsIM.next()  
	   rsIM.close();
	   stateIM.close();  

		
		  
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
   wwb.setProtected(false);
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
<A HREF="/wins/WinsMainMenu.jsp">回首頁</A>&nbsp;&nbsp; <A HREF='/wins/report/<%=WSUserID%>ForecastPlan_Query.xls?DATEBEGIN=<%=dateStringBegin%>&DATEEND=<%=dateStringEnd%>'> 
Product Forecast Information Excel View</A>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
