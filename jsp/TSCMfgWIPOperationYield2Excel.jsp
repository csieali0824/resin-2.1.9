<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*" %>
<%@ page import="DateBean,MiscellaneousBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCMfgWIPOperationYield2Excel.jsp" METHOD="post" name="MYFORM">
<%
  //String RepLocale=(String)session.getAttribute("LOCALE");  // 改抓Session內的登入資料
  //String UserID=request.getParameter("USERID");             // 改抓Session內的登入資料
  
  String serverHostName=request.getServerName();
  
  String sqlGlobal = request.getParameter("SQLGLOBAL");

  String RepCenterNo=request.getParameter("REPCENTERNO");   // 改抓Session內的登入資料

  String dnDocNo=request.getParameter("DNDOCNO");
  
  String SWHERE=request.getParameter("SWHERECOND");
  
  
 String dateStringBegin=request.getParameter("DATEBEGIN");
 String dateStringEnd=request.getParameter("DATEEND");

String dateSetBegin=request.getParameter("DATESETBEGIN");
String dateSetEnd=request.getParameter("DATESETEND");

String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");
      if (YearFr==null ) YearFr = dateBean.getYearString();
	  if (MonthFr==null ) MonthFr = dateBean.getMonthString();

      if (dateSetBegin==null ) dateSetBegin=YearFr+MonthFr;

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
      if (dateSetEnd==null ) dateSetEnd=YearTo+MonthTo; 
  
  if (dateStringBegin==null){ dateStringBegin=dateBean.getYearMonthDay(); }
  if (dateStringEnd==null){ dateStringEnd=dateBean.getYearMonthDay(); }

  String ymdCurr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
  String hmsCurr = dateBean.getHourMinuteSecond();
  //2005.5.24 Gray Modify for new field shiptype 
  String ShipType=request.getParameter("SHIPTYPE");
  String ShipName=request.getParameter("SHIPNAME");
  //end
  
  String strHMSec = request.getParameter("HOURTIME");
  
  String marketType=request.getParameter("MARKETTYPE"); // 內外銷別
  if (marketType==null) marketType = "326";
  
  String orgCode = "內銷";
  if (marketType.equals("326")) orgCode = "內銷";
  else if (marketType.equals("327")) orgCode = "外銷";
  
  String opCode=request.getParameter("OPCODE");
  if (opCode==null || opCode.equals("")) opCode="ALL"; // 沒特別指定 = ALL
	
  String organizationId=request.getParameter("ORGANIZATION_ID");
  
 try 
 { 	
	 String sql = "";
	 String sWhere = "";
   //String sWRpModel = "";
	 String orderBy = "";
	 	    
	 String customer="";
	 String tscItemDesc = "";
	
	 String requestDate = "";
	
	 String prodFactoryName="";
     String assignUserName="";
	 String prodUserName="";
	 String uom = "";
	 String qty="";
	 String schShipDate="";
	 String remark="";
	 String custPO = "";
	 
	
	 
     if (sqlGlobal==null || sqlGlobal=="")
	 { 		
	   sql = " select select DISTINCT YWW.OPERATION_CODE, WOP.DESCRIPTION, YWW.ACCT_PERIOD_ID "+
	         "   from YEW_WIP_WIPIO YWW, ORG_ACCT_PERIODS OAP, WIP_OPERATIONS WOP   ";	
	   sWhere = " where YWW.ORGANIZATION_ID = OAP.ORGANIZATION_ID and YWW.ACCT_PERIOD_ID = OAP.ACCT_PERIOD_ID  "+
	            "   and YWW.WIP_ENTITY_ID = WOP.WIP_ENTITY_ID and YWW.OPERATION_SEQ_NUM = WOP.OPERATION_SEQ_NUM ";
		   
	   orderBy =  " order by YWW.OPERATION_CODE ";	  
	 
	   if (marketType==null || marketType.equals("--") || marketType.equals("")) { sWhere=sWhere+" and YWW.ORGANIZATION_ID = 326 "; }
       else {sWhere=sWhere+" and YWW.ORGANIZATION_ID = "+marketType+" "; }
   
       if (MonthFr!="--" && !MonthFr.equals("--")) sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateSetBegin+"' ";  
       else	sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateBean.getYearString()+dateBean.getMonthString()+"' ";   
	 
	   if (opCode==null || opCode.equals("--") || opCode.equals("ALL")) { sWhere=sWhere+"  "; }
       else {sWhere=sWhere+" and YWW.OPERATION_CODE = "+opCode+" "; }   
	   
	   
	   
	 } // End of if (sqlGlobal==null)  
	 else
    	 {
		   sql = " select DISTINCT YWW.OPERATION_CODE, WOP.DESCRIPTION, YWW.ACCT_PERIOD_ID "+
	             "   from YEW_WIP_WIPIO YWW, ORG_ACCT_PERIODS OAP, WIP_OPERATIONS WOP   ";	
	       sWhere = " where YWW.ORGANIZATION_ID = OAP.ORGANIZATION_ID and YWW.ACCT_PERIOD_ID = OAP.ACCT_PERIOD_ID  "+
	                "   and YWW.WIP_ENTITY_ID = WOP.WIP_ENTITY_ID and YWW.OPERATION_SEQ_NUM = WOP.OPERATION_SEQ_NUM ";
		   
	       orderBy =  " order by YWW.OPERATION_CODE ";	
		  		   
		   if (marketType==null || marketType.equals("--") || marketType.equals("")) { sWhere=sWhere+" and YWW.ORGANIZATION_ID = 326 "; }
           else {sWhere=sWhere+" and YWW.ORGANIZATION_ID = "+marketType+" "; }
   
           if (MonthFr!="--" && !MonthFr.equals("--")) sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateSetBegin+"' ";  
           else	sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateBean.getYearString()+dateBean.getMonthString()+"' ";   
	 
	       if (opCode==null || opCode.equals("--") || opCode.equals("ALL")) { sWhere=sWhere+"  "; }
           else {sWhere=sWhere+" and YWW.OPERATION_CODE = "+opCode+" "; }   
		  
		 }
	     
// 2003/12/11 加入新條件 迄	 

        if (SWHERE==null || SWHERE=="" || SWHERE.equals("")) // 若為傳入條件式,則為單據
        {     
	      sql = sql + sWhere + orderBy;
		  //out.println("sWhere="+sql);
        }
        else // 否則則是查詢頁
        {      
          sql = sql + SWHERE + orderBy;  // 測試傳表單參數 // 
		  //out.println("SWHERE="+sql);                
        }
	
	
	// 產生報表
	OutputStream os = null;	
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
	   os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/WOY"+userID+"_"+ymdCurr+hmsCurr+".xls");
	} else {  // For Windows Platform
	         os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\WOY"+userID+"_"+ymdCurr+hmsCurr+".xls");
		   }
	//OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\WOY"+userID+"_"+ymdCurr+hmsCurr+".xls"); 	
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("生產系統站別良率統計表", 0); //-- TEST
	
	//jxl.Sheet ws = wwb.createSheet("Sales Delivery Request", 0);
	
	jxl.SheetSettings sst = ws.getSettings(); 
	
	//out.println("2<BR>");
   /*               */
    // 第二個Sheet ws2
    //jxl.write.WritableSheet ws2 = wwb.createSheet("Sales Delivery Record", 0);
    // 抬頭列字型15
	jxl.write.WritableFont wf2Title = new jxl.write.WritableFont(WritableFont.TIMES, 15,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Title = new jxl.write.WritableCellFormat(wf2Title); 
	wcf2Title.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    // 條件列字型12
    jxl.write.WritableFont wf2Cond = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Cond = new jxl.write.WritableCellFormat(wf2Cond); 
	wcf2Cond.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    // Header 列背景灰色
    jxl.write.WritableFont wf2Header = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(wf2Header); 
	wcf2Header.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    wcf2Header.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色
    // 內容 列 定義
    jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 9,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
	wcf2Content.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    //wcf2Content.setBackground(jxl.format.Colour.GRAY_25); // 	  
	
	jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 9, WritableFont.NO_BOLD, false, UnderlineStyle.SINGLE); 
    jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
	wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    wcfT.setAlignment(jxl.format.Alignment.LEFT);
	wcfT.setBackground(jxl.format.Colour.ICE_BLUE);
   /*                  */
	
	sst.setSelected();
	sst.setVerticalFreeze(0);  // 垂直凍結欄
	//sst.setProtected(true);
	sst.setFitToPages(true);	
	sst.setFitWidth(1);  // 設定一頁寬
	//sst.setFitHeight(1);  // 設定一頁高
	//sst.setPassword("kerwin");
			
	   java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位 
	   java.math.BigDecimal bd = null;
	   
	   java.text.DecimalFormat nf2 = new java.text.DecimalFormat("###,##0.00"); // 取小數後二位 
	   java.math.BigDecimal bd2 = null;
	
	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 0;  // 行由零開始
		int rowNo = 0;  // 列由零開始
		
		int opCount = 0;
        //sql = sqlGlobal;
        out.println(sql+"<BR>"); 
	    //out.println("S1");
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sql); 		
		//out.println("S2");
		while (rs.next())
		{	//out.println("S2");  
		            
					 int titleShift = rowNo+opCount;
					
				     titleShift = rowNo+opCount+rowNo*5;
					 
					 out.println("第"+rowNo+"列 站別,opCount = "+opCount+", titleShift="+titleShift+"<BR>");
					
		              //file://抬頭:(第0列第1行)
                    jxl.write.WritableFont wf1 = new jxl.write.WritableFont(WritableFont.TIMES, 9,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
                    jxl.write.WritableCellFormat wcfF1 = new jxl.write.WritableCellFormat(wf1); 
	                //wcfF1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	                wcfF1.setAlignment(jxl.format.Alignment.CENTRE);
                    jxl.write.Label labelCF1 = new jxl.write.Label(colNo, titleShift, "陽信長威電子有限公司", wcfF1);  // (行,列)
                    ws.addCell(labelCF1);
	                ws.mergeCells(0, titleShift, 11, titleShift);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	                ws.setColumnView(colNo, 20);
	
	                //file://抬頭:(第1列第1行)
	                jxl.write.WritableFont wf2 = new jxl.write.WritableFont(WritableFont.TIMES, 9, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
                    jxl.write.WritableCellFormat wcfF2 = new jxl.write.WritableCellFormat(wf2); 
	                wcfF2.setAlignment(jxl.format.Alignment.CENTRE);
	                //wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
                    jxl.write.Label labelCF2 = new jxl.write.Label(colNo, titleShift+1, "生產月報統計表--站別良率("+orgCode+")", wcfF2);  // (行,列)
                    ws.addCell(labelCF2);
	                ws.mergeCells(colNo, titleShift+1, colNo+11, titleShift+1);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	                ws.setColumnView(colNo, 20);
                                     
                    //2005.5.26 Gray end
                     //抬頭:(第0列第2行)
                    // jxl.write.WritableFont wfc = new jxl.write.WritableFont(WritableFont.ARIAL,10, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.RED); 
					jxl.write.WritableFont wfc = new jxl.write.WritableFont(WritableFont.ARIAL,9, WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE);
                    jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfc); 
					wcfFC.setAlignment(jxl.format.Alignment.CENTRE);
	                //wcfFC.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
                    jxl.write.Label labelCFC1 = new jxl.write.Label(colNo, titleShift+2, "站別:"+rs.getString("OPERATION_CODE")+"("+rs.getString("DESCRIPTION")+")", wcfFC);  // 取工廠產地名稱 // (行,列)
	                //jxl.write.Label labelCFC1 = new jxl.write.Label(0, 3, "TEW", wcfFC);  // 取工廠產地名稱 // (行,列)
                    ws.addCell(labelCFC1);
	                ws.mergeCells(colNo, titleShift+2, colNo+11, titleShift+2);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	                ws.setColumnView(colNo, 20);
	                //抬頭:(第0列第3行)
	                //jxl.write.WritableFont wfB = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
                    //jxl.write.WritableCellFormat wcfFB = new jxl.write.WritableCellFormat(wfB);
	                //wcfFB.setBackground(jxl.format.Colour.AQUA); // 設定背景顏色    
	
	
	                //抬頭:(第3列第0行)		// 明細抬頭說明
	                jxl.write.Label labelAcct = new jxl.write.Label(colNo, titleShift+3, "成本代號", wcfT); // (行,列)
                    ws.addCell(labelAcct);
	                ws.setColumnView(colNo, 10);
	
	                //抬頭:(第3列第1行)
	                jxl.write.Label labelCFC2 = new jxl.write.Label(colNo+1, titleShift+3, "站別", wcfT); // (行,列)
                    ws.addCell(labelCFC2);
	                ws.setColumnView(colNo+1, 15);
	
	                //抬頭:(第3列第2行)
	                jxl.write.Label labelCF3 = new jxl.write.Label(colNo+2, titleShift+3, "期初數", wcfT); // (行,列)
                    ws.addCell(labelCF3);
	                ws.setColumnView(colNo+2, 10);
	
	                 //抬頭:(第3列第3行)
	                jxl.write.Label labelCF4 = new jxl.write.Label(colNo+3, titleShift+3, "接收數", wcfT); // (行,列)
                    ws.addCell(labelCF4);
	                ws.setColumnView(colNo+3, 10);
	
	                //抬頭:(第3列第4行)
	                jxl.write.Label labelCF5 = new jxl.write.Label(colNo+4, titleShift+3, "處理數", wcfT); // (行,列)
                    ws.addCell(labelCF5);
	                ws.setColumnView(colNo+4, 10);
	
	                //抬頭:(第3列第5行)
	                jxl.write.Label labelCFC6 = new jxl.write.Label(colNo+5, titleShift+3, "產出數", wcfT); // (行,列)
                    ws.addCell(labelCFC6);
	                ws.setColumnView(colNo+5, 10);
	
	                //抬頭:(第3列第6行)
	                jxl.write.Label labelCFC7 = new jxl.write.Label(colNo+6, titleShift+3, "耗損數", wcfT); // (行,列)
                    ws.addCell(labelCFC7);
	                ws.setColumnView(colNo+6, 10);
	
	                //抬頭:(第3列第7行)
	                jxl.write.Label labelCF8 = new jxl.write.Label(colNo+7, titleShift+3, "期末數", wcfT); // (行,列)
                    ws.addCell(labelCF8);
	                ws.setColumnView(colNo+7, 10);
	
	                jxl.write.Label labelCF9 = new jxl.write.Label(colNo+8, titleShift+3, "工時", wcfT); // (行,列)
                    ws.addCell(labelCF9);
	                ws.setColumnView(colNo+8, 10);
	
	                jxl.write.Label labelCF10 = new jxl.write.Label(colNo+9, titleShift+3, "良品率", wcfT); // (行,列)
                    ws.addCell(labelCF10);
	                ws.setColumnView(colNo+9, 10);
	
	                jxl.write.Label labelCF11 = new jxl.write.Label(colNo+10, titleShift+3, "PPH", wcfT); // (行,列)
                    ws.addCell(labelCF11);
	                ws.setColumnView(colNo+10, 10);
	
	                jxl.write.Label labelCF12 = new jxl.write.Label(colNo+11, titleShift+3, "UPH", wcfT); // (行,列)
                    ws.addCell(labelCF12);
	                ws.setColumnView(colNo+11, 10);  
		           
		
		           // 取各個站別的處理明細_SQL起
		  
		           
	               float frontBeginBalTotal=0, frontReceiptTotal=0, frontProcessTotal=0, frontCompleteTotal=0, frontScrapTotal=0, frontEndBalTotal=0,frontWorkTimeTotal=0;
	 
		           float frontLPLRate=0, frontPPH=0, LPLRateTotal=0, PPHTotal=0;
		           float frontUPH=0, UPHTotal=0;  // 2007/05/01 增加UPH欄位,值為PPH倒數
				   
		           Statement stateFront=con.createStatement();                   
			       String sqlFront = " select YWW.PART_NO, YWW.OPERATION_CODE, WOP.DESCRIPTION, "+
				                     "        sum(YWW.QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, sum(YWW.QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(YWW.QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
	                                 "        sum(YWW.QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(YWW.QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, sum(YWW.QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE, sum(YWW.WORK_TIME) as WORK_TIME "+
									 "   from YEW_WIP_WIPIO YWW , WIP_OPERATIONS WOP ";
			       String whereFront = " where YWW.OPERATION_CODE = '"+rs.getString("OPERATION_CODE")+"' and YWW.ORGANIZATION_ID = "+marketType+" and YWW.ACCT_PERIOD_ID = "+rs.getString("ACCT_PERIOD_ID")+"  "+
				                       "   and YWW.WIP_ENTITY_ID = WOP.WIP_ENTITY_ID and YWW.OPERATION_SEQ_NUM = WOP.OPERATION_SEQ_NUM "+
									   "   and YWW.DEPT_NO in ('1','2','3') "; //  確保由生產系統(不含一月份舊系統麗玲手開工令)	
				   String groupFront = " group by YWW.PART_NO, YWW.OPERATION_CODE, WOP.DESCRIPTION ";						  
				   String orderFront = "  order by YWW.PART_NO "; 				   
				   sqlFront = sqlFront + whereFront + groupFront + orderFront;
				   //out.println("sqlFront<BR>");
				   ResultSet rsFront=stateFront.executeQuery(sqlFront);			 
		           while (rsFront.next())
		           // 依各個成本代號,找對應結轉各項數據_迄	
		           {  	
    
	                //out.clearBuffer();
	                //out.println("333<BR>");
	                //out.println(sql);
	
	    		 
		             //noSeq = noSeq + 1;
		              titleShift = rowNo+opCount+rowNo*5;						  
					
		     
		              
		              if (rsFront.getFloat(4)>0 || rsFront.getFloat(5)>0 || rsFront.getFloat(6)>0 || rsFront.getFloat(7)>0 || rsFront.getFloat(8)>0 || rsFront.getFloat(9)>0 || rsFront.getFloat(10)>0)  
		              { // 判斷若各個欄位不為零,才顯示
		                //out.println("S3");
		  
		               jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.TIMES, 9,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
                       jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		               wcfFL.setBackground(jxl.format.Colour.LIGHT_GREEN); // 設定背景顏色	 
		               wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
		               //out.println("S4"); 		  
		                
		               jxl.write.Label lablePartNo = new jxl.write.Label(0, titleShift+4, rsFront.getString("PART_NO") , wcfFL); // (行,列);由第七列開始顯示動態資料
                       ws.addCell(lablePartNo);
		  
		               String stationName=rsFront.getString("OPERATION_CODE")+"("+rsFront.getString("DESCRIPTION")+")";
		               //out.println("customer="+customer); 
		               if ((stationName == null ||  stationName.equals("")))
		               { stationName =""; }	 
	                   jxl.write.Label lableStatName = new jxl.write.Label(1, titleShift+4, stationName , wcfFL); // (行,列);由第七列開始顯示動態資料
                       ws.addCell(lableStatName);
					   
					   
					   float qtyBeginBalance =0;
				       try
		               { 		           
			              String qtyBeginBalStr = nf.format(rsFront.getFloat("QUANTITY_BEGIN_BALANCE"));
				          bd = new java.math.BigDecimal(qtyBeginBalStr);
				          java.math.BigDecimal qtyBeginBalStrQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				          qtyBeginBalance = qtyBeginBalStrQty.floatValue();
		               } //end of try
                       catch (NumberFormatException e)
                       {
                        System.out.println("Exception: Begin Balance"+e.getMessage());
                       }
		               
					   
		               //noSeqStr = integer.toString(noSeq);		               
	                   jxl.write.Label lableBegBlanceQty = new jxl.write.Label(2, titleShift+4, Float.toString(qtyBeginBalance), wcfFL); // (行,列); 台半料號
                       ws.addCell(lableBegBlanceQty);
		               frontBeginBalTotal=frontBeginBalTotal+rsFront.getFloat("QUANTITY_BEGIN_BALANCE"); 
		              
		               jxl.write.Label lableReceiveQty = new jxl.write.Label(3, titleShift+4, rsFront.getString("QUANTITY_RECEIVED") , wcfFL); // (行,列); 單位
                       ws.addCell(lableReceiveQty);
					   frontReceiptTotal=frontReceiptTotal+rsFront.getFloat("QUANTITY_RECEIVED"); 
		  
		               					  
		               jxl.write.Label lableProcessQty = new jxl.write.Label(4, titleShift+4, rsFront.getString("QUANTITY_PROCESSED") , wcfFL); 
                       ws.addCell(lableProcessQty);		
					   frontProcessTotal=frontProcessTotal+rsFront.getFloat("QUANTITY_PROCESSED");
					   					            		  
		              
		               jxl.write.Label lableCompleteQty = new jxl.write.Label(5, titleShift+4, rsFront.getString("QUANTITY_COMPLETED") , wcfFL); 
                       ws.addCell(lableCompleteQty);	
					   frontCompleteTotal=frontCompleteTotal+rsFront.getFloat("QUANTITY_COMPLETED");	 	  
		 
		        
		               jxl.write.Label lableScrapQty = new jxl.write.Label(6, titleShift+4, rsFront.getString("QUANTITY_SCRAPPED") , wcfFL); 
                       ws.addCell(lableScrapQty);
					   frontScrapTotal=frontScrapTotal+rsFront.getFloat("QUANTITY_SCRAPPED");
		  
		               	  			  
		               jxl.write.Label lableEndBalanceQty = new jxl.write.Label(7, titleShift+4, rsFront.getString("QUANTITY_END_BALANCE") , wcfFL); 
                       ws.addCell(lableEndBalanceQty);	
					   frontEndBalTotal=frontEndBalTotal+rsFront.getFloat("QUANTITY_END_BALANCE"); 
		  
		               		  
		               jxl.write.Label lableWorkTime = new jxl.write.Label(8, titleShift+4, rsFront.getString("WORK_TIME") , wcfFL); 
                       ws.addCell(lableWorkTime);	
					   frontWorkTimeTotal=frontWorkTimeTotal+rsFront.getFloat("WORK_TIME");
					   
					   
					   frontLPLRate=(rsFront.getFloat("QUANTITY_COMPLETED")/rsFront.getFloat("QUANTITY_PROCESSED"))*100;
					   float YieldRate = 0;
				       try
		               { 		           
			             String yieldRateStr = nf2.format(frontLPLRate);
				         bd2 = new java.math.BigDecimal(yieldRateStr);
				         java.math.BigDecimal yieldRateStrQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				         YieldRate = yieldRateStrQty.floatValue();
					    //out.println(frontLPLRate);
		               } //end of try
                       catch (NumberFormatException e)
                       {
				        e.printStackTrace();
                        System.out.println("Exception: YIELD RATE"+e.getMessage());				   
                       } 
					   
					   jxl.write.Label lableYieldRate = new jxl.write.Label(9, titleShift+4, YieldRate+"%" , wcfFL); 
                       ws.addCell(lableYieldRate);	
					   
					   
					   frontPPH=(rsFront.getFloat("QUANTITY_COMPLETED")/rsFront.getFloat("WORK_TIME"));				  
				       float pphValue = 0;
				       try
		               { 		           
			             String pphValueStr = nf2.format(frontPPH);
				         bd2 = new java.math.BigDecimal(pphValueStr);
				         java.math.BigDecimal pphValueStrQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				         pphValue = pphValueStrQty.floatValue();
		               } //end of try
                       catch (NumberFormatException e)
                       {
				        e.printStackTrace();
                        System.out.println("Exception: PPH "+e.getMessage());
                       } 
					   
					   jxl.write.Label lablePPHValue = new jxl.write.Label(10, titleShift+4, Float.toString(pphValue) , wcfFL); 
                       ws.addCell(lablePPHValue);	
					   
				  
				       frontUPH=(1/frontPPH);  // 計算 UPH = 1/PPH
				       float uphValue = 0;
				       try
		               { 		           
			             String uphValueStr = nf2.format(frontUPH);
				         bd2 = new java.math.BigDecimal(uphValueStr);
				         java.math.BigDecimal uphValueStrQty = bd2.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				         uphValue = uphValueStrQty.floatValue();
		               } //end of try
                       catch (NumberFormatException e)
                       {
				        e.printStackTrace();
                        System.out.println("Exception: UPH "+e.getMessage());
                       } 
				  
				       jxl.write.Label lableUPHValue = new jxl.write.Label(11, titleShift+4, Float.toString(uphValue) , wcfFL); 
                       ws.addCell(lableUPHValue);
				     
					   opCount++;  // 計數,判斷是否為該機種的第一站,如為第一站(焊接)則存入變數   
					   
				  } // End of if (rsFront.getFloat(4)>0 || rsFront.getFloat(5)>0 || rsFront.getFloat(6)>0 || rsFront.getFloat(7)>0 || rsFront.getFloat(8)>0 || rsFront.getFloat(9)>0 || rsFront.getFloat(10)>0) // 判斷若各個欄位不為零,才顯示
				  
			      
				  
	     } // End of while (rsFront.next())
	     rsFront.close();
	     stateFront.close();			 
		 
		          jxl.write.WritableFont wfTTL = new jxl.write.WritableFont(WritableFont.TIMES, 9, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
                  jxl.write.WritableCellFormat wcfTTL = new jxl.write.WritableCellFormat(wfTTL); 
	              //wcfF1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	              wcfTTL.setAlignment(jxl.format.Alignment.CENTRE);
                  jxl.write.Label labelTTL = new jxl.write.Label(0, titleShift+5, "總計", wcfTTL);  // (行,列)
                  ws.addCell(labelTTL);
	              ws.mergeCells(0, titleShift+5, 1, titleShift+5);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	              ws.setColumnView(0, 10);	
		 
		          jxl.write.WritableFont wfFL = new jxl.write.WritableFont(WritableFont.TIMES, 9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
                  jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfFL); 
		          wcfFL.setBackground(jxl.format.Colour.IVORY);
		 
   	              miscellaneousBean.setRoundDigit(3);
		          String totBegQty = miscellaneousBean.getFloatRoundStr(frontBeginBalTotal);
		          jxl.write.Label lableTTLBegQty = new jxl.write.Label(2, titleShift+5, totBegQty , wcfFL); // 總計期初數
                  ws.addCell(lableTTLBegQty);	
		 
		          //miscellaneousBean.setRoundDigit(3);
		          String totRecptQty = miscellaneousBean.getFloatRoundStr(frontReceiptTotal);
		          jxl.write.Label lableTTLRecptQty = new jxl.write.Label(3, titleShift+5, totRecptQty , wcfFL); // 總計接收數
                  ws.addCell(lableTTLRecptQty);		 
		 
		          String totProcesQty = miscellaneousBean.getFloatRoundStr(frontProcessTotal);
		          jxl.write.Label lableTTLProcesQty = new jxl.write.Label(4, titleShift+5, totProcesQty , wcfFL); // 總計處理數
                  ws.addCell(lableTTLProcesQty);	
		 
		          String totCompleteQty = miscellaneousBean.getFloatRoundStr(frontCompleteTotal);
		          jxl.write.Label lableTTLCompleteQty = new jxl.write.Label(5, titleShift+5, totCompleteQty , wcfFL); // 總計完工數
                  ws.addCell(lableTTLCompleteQty);	
		 
		          String totScrapQty = miscellaneousBean.getFloatRoundStr(frontScrapTotal);
		          jxl.write.Label lableTTLScrapQty = new jxl.write.Label(6, titleShift+5, totScrapQty , wcfFL); // 總計報廢數
                  ws.addCell(lableTTLScrapQty);	
		 
		          String totEndBalQty = miscellaneousBean.getFloatRoundStr(frontEndBalTotal);
		          jxl.write.Label lableTTLEndQty = new jxl.write.Label(7, titleShift+5, totEndBalQty , wcfFL); // 總計期末數
                  ws.addCell(lableTTLEndQty);	
		 
		          String totWorkTimeQty = miscellaneousBean.getFloatRoundStr(frontWorkTimeTotal);
		          jxl.write.Label lableTTLWorkTime = new jxl.write.Label(8, titleShift+5, totWorkTimeQty , wcfFL); // 總計工時
                  ws.addCell(lableTTLWorkTime); 
		 
		          LPLRateTotal=frontCompleteTotal/(frontBeginBalTotal+frontReceiptTotal-frontEndBalTotal)*100;  //公式:(期初+接收-期末)/產出=良率     
		          float YieldRateTotal = 0;
		          try
		          { 		           
			         String yieldRateTotStr = nf2.format(LPLRateTotal);
				     bd2 = new java.math.BigDecimal(yieldRateTotStr);
				     java.math.BigDecimal yieldRateStrTotQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				     YieldRateTotal = yieldRateStrTotQty.floatValue();
					 //out.println(frontLPLRate);
		          } //end of try
                  catch (NumberFormatException e)
                  {
				    e.printStackTrace();
                    System.out.println("Exception: YIELD RATE"+e.getMessage());				   
                  } 
				  
		          String yieldRateTTL = "";
		          if (YieldRateTotal>100)  yieldRateTTL = "100.00%";
		          else yieldRateTTL = Float.toString(YieldRateTotal)+"%";	
			 
		 
		          jxl.write.Label lableTTLYieldRate = new jxl.write.Label(9, titleShift+5, yieldRateTTL , wcfFL); // 總計良品率
                  ws.addCell(lableTTLYieldRate); 
		
		          PPHTotal=(frontCompleteTotal/frontWorkTimeTotal);		    // pph= 總產出/總工時   2007/04/11   liling update
		          String totPPHValue = miscellaneousBean.getFloatRoundStr(PPHTotal); 
		          jxl.write.Label lableTTLPPHValue = new jxl.write.Label(10, titleShift+5, totPPHValue , wcfFL); // 總計產出率
                  ws.addCell(lableTTLPPHValue);
		
		          UPHTotal=(1/PPHTotal);		    // pph= 總產出/總工時   2007/04/11   liling update
		          String totUPHValue = miscellaneousBean.getFloatRoundStr(UPHTotal);
		          jxl.write.Label lableTTLUPHValue = new jxl.write.Label(11, titleShift+5, totUPHValue , wcfFL); // 總計UPH
                  ws.addCell(lableTTLUPHValue);                
		  
		rowNo = rowNo + 1;
		
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
   //ws.close();   // close workbook's sheet //
   wwb.close(); // close workbook //
   os.close();   // close file outputstream //
   out.close(); 
	

    }   // End of try
    catch (Exception e) 
    { 
	 e.printStackTrace();
	 out.println("Exception:"+e.getMessage()); 
     // 
    } 	

       
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
     response.reset();
     response.setContentType("application/vnd.ms-excel");					
     response.sendRedirect("/oradds/report/WOY"+userID+"_"+ymdCurr+hmsCurr+".xls");  

%>

</html>
