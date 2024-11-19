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
  
  String partNo=request.getParameter("PARTNO");
  
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
	   sql = " select DISTINCT YWWA.PART_NO, YWWA.ACCT_PERIOD_ID "+
	         " from YEW_WIP_WIPIO_ALL YWWA, ORG_ACCT_PERIODS OAP, "+
			 "     (select PART_NO, ACCT_PERIOD_ID,  "+
			 "             sum(QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, "+
			 "             sum(QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
			 "             sum(QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, "+
			 "             sum(QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE "+
			 "        from YEW_WIP_WIPIO_ALL "+
			 "       where ORGANIZATION_ID ="+marketType+" "+
			 "         and OPERATION_CODE != '9998' "+
			 "         and ( FIRST_OPERATION IS NULL or LAST_OPERATION IS NULL ) "+
			 "    group by PART_NO, ACCT_PERIOD_ID "+
			 "     ) YWWB ";	
	   sWhere = " where YWWA.ORGANIZATION_ID = OAP.ORGANIZATION_ID and YWWA.ACCT_PERIOD_ID = OAP.ACCT_PERIOD_ID "+
                "   and YWWA.ORGANIZATION_ID = "+marketType+" "+
				"   and YWWA.ACCT_PERIOD_ID = YWWB.ACCT_PERIOD_ID "+
				"   and YWWA.PART_NO = YWWB.PART_NO  "+
				"   and ( YWWB.QUANTITY_BEGIN_BALANCE > 0 "+
				"       or YWWB.QUANTITY_RECEIVED >0 or YWWB.QUANTITY_PROCESSED >0 "+
				"       or YWWB.QUANTITY_COMPLETED > 0 or YWWB.QUANTITY_SCRAPPED >0 "+
				"       or YWWB.QUANTITY_END_BALANCE > 0 ) "+
				"   and YWWA.OPERATION_CODE != '9998' ";
		   
	   orderBy =  " order by YWWA.PART_NO ";	  
	 
	   if (marketType==null || marketType.equals("--") || marketType.equals("")) { sWhere=sWhere+" and YWWA.ORGANIZATION_ID = 326 "; }
       else { sWhere=sWhere+" and YWWA.ORGANIZATION_ID = "+marketType+" "; }
   
       if (MonthFr!="--" && !MonthFr.equals("--")) sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateSetBegin+"' ";  
       else	sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateBean.getYearString()+dateBean.getMonthString()+"' ";   
	 	 
	   if (partNo==null || partNo.equals("--") || partNo.equals("")) { sWhere=sWhere+"  "; }
       else { sWhere=sWhere+" and YWWA.PART_NO =  '"+partNo+"' "; }   
	   
	 } // End of if (sqlGlobal==null)  
	 else
    	 {
		   sql = " select DISTINCT YWWA.PART_NO, YWWA.ACCT_PERIOD_ID "+
	         " from YEW_WIP_WIPIO_ALL YWWA, ORG_ACCT_PERIODS OAP, "+
			 "     (select PART_NO, ACCT_PERIOD_ID,  "+
			 "             sum(QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, "+
			 "             sum(QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
			 "             sum(QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, "+
			 "             sum(QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE "+
			 "        from YEW_WIP_WIPIO_ALL "+
			 "       where ORGANIZATION_ID ="+marketType+" "+
			 "         and OPERATION_CODE != '9998' "+
			 "         and ( FIRST_OPERATION IS NULL or LAST_OPERATION IS NULL ) "+
			 "    group by PART_NO, ACCT_PERIOD_ID "+
			 "     ) YWWB ";	
	      sWhere = " where YWWA.ORGANIZATION_ID = OAP.ORGANIZATION_ID and YWWA.ACCT_PERIOD_ID = OAP.ACCT_PERIOD_ID "+
                   "   and YWWA.ORGANIZATION_ID = "+marketType+" "+
				   "   and YWWA.ACCT_PERIOD_ID = YWWB.ACCT_PERIOD_ID "+
				   "   and YWWA.PART_NO = YWWB.PART_NO  "+
				   "   and ( YWWB.QUANTITY_BEGIN_BALANCE > 0 "+
				   "       or YWWB.QUANTITY_RECEIVED >0 or YWWB.QUANTITY_PROCESSED >0 "+
				   "       or YWWB.QUANTITY_COMPLETED > 0 or YWWB.QUANTITY_SCRAPPED >0 "+
				   "       or YWWB.QUANTITY_END_BALANCE > 0 ) "+
				   "   and YWWA.OPERATION_CODE != '9998' ";
		   
	     orderBy =  " order by YWWA.PART_NO ";	  
	 
	     if (marketType==null || marketType.equals("--") || marketType.equals("")) { sWhere=sWhere+" and YWWA.ORGANIZATION_ID = 326 "; }
         else { sWhere=sWhere+" and YWWA.ORGANIZATION_ID = "+marketType+" "; }
   
         if (MonthFr!="--" && !MonthFr.equals("--")) sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateSetBegin+"' ";  
         else	sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateBean.getYearString()+dateBean.getMonthString()+"' ";   
	 	 
	     if (partNo==null || partNo.equals("--") || partNo.equals("")) { sWhere=sWhere+"  "; }
         else { sWhere=sWhere+" and YWWA.PART_NO =  '"+partNo+"' "; } 
		  
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
	   os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/WPY"+userID+"_"+ymdCurr+hmsCurr+".xls");
	} else {  // For Windows Platform
	         os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\WPY"+userID+"_"+ymdCurr+hmsCurr+".xls");
		   }
	//OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\WOY"+userID+"_"+ymdCurr+hmsCurr+".xls"); 	
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("生產系統產品別良率統計表", 0); //-- TEST
	
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
		
		int opCount = 0; // 前段累計 Row Count
		
		int bkOpCount = 0; // 後段累計 Row Count
	
	                jxl.write.WritableFont wf1 = new jxl.write.WritableFont(WritableFont.TIMES, 9,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
                    jxl.write.WritableCellFormat wcfF1 = new jxl.write.WritableCellFormat(wf1); 
	                //wcfF1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	                wcfF1.setAlignment(jxl.format.Alignment.CENTRE);
                    jxl.write.Label labelCF1 = new jxl.write.Label(0, 0, "陽信長威電子有限公司", wcfF1);  // (行,列)
                    ws.addCell(labelCF1);
	                ws.mergeCells(0, 0, 9, 0);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	                ws.setColumnView(colNo, 20);
					
					//file://抬頭:(第1列第1行)
	                jxl.write.WritableFont wf2 = new jxl.write.WritableFont(WritableFont.TIMES, 9, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
                    jxl.write.WritableCellFormat wcfF2 = new jxl.write.WritableCellFormat(wf2); 
	                wcfF2.setAlignment(jxl.format.Alignment.CENTRE);
	                //wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
                    jxl.write.Label labelCF2 = new jxl.write.Label(0, 1, "生產月報統計表--產品別良率("+orgCode+")", wcfF2);  // (行,列)
                    ws.addCell(labelCF2);
	                ws.mergeCells(0, 1, 9, 1);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	                ws.setColumnView(colNo, 20);
			
	   
        //sql = sqlGlobal;
        //out.println(sql+"<BR>"); 
		int titleShift = 0;
	    //out.println("S1");
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sql); 		
		//out.println("S2");
		while (rs.next())
		{	//out.println("S2");  
		
		  
		            
					titleShift = rowNo+opCount+bkOpCount+(2+2)*rowNo;  // 加上 空白列及成本代號與站別 的 Shift 
					
					
				    // titleShift = rowNo+opCount+rowNo*5;
					 
					 //out.println("第"+rowNo+"列 站別,opCount = "+opCount+", titleShift="+titleShift+"<BR>");
					
		              //file://抬頭:(第0列第1行)	
	                
                                     
                    //2005.5.26 Gray end
                     //抬頭:(第0列第2行)
                    // jxl.write.WritableFont wfc = new jxl.write.WritableFont(WritableFont.ARIAL,10, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.RED); 
					jxl.write.WritableFont wfc = new jxl.write.WritableFont(WritableFont.ARIAL,9, WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE);
                    jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfc); 
					wcfFC.setAlignment(jxl.format.Alignment.LEFT);
	                //wcfFC.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
                    jxl.write.Label labelCFC1 = new jxl.write.Label(0, titleShift+2, "成本代號:"+rs.getString("PART_NO"), wcfFC);  // 取成本代號 // (行,列)
	                //jxl.write.Label labelCFC1 = new jxl.write.Label(0, 3, "TEW", wcfFC);  // 取工廠產地名稱 // (行,列)
                    ws.addCell(labelCFC1);
	                ws.mergeCells(0, titleShift+2, 9, titleShift+2);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	                ws.setColumnView(0, 20);
	                //抬頭:(第0列第3行)
	                //jxl.write.WritableFont wfB = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
                    //jxl.write.WritableCellFormat wcfFB = new jxl.write.WritableCellFormat(wfB);
	                //wcfFB.setBackground(jxl.format.Colour.AQUA); // 設定背景顏色     
	
	                //抬頭:(第3列第1行)
	                jxl.write.Label labelCFC2 = new jxl.write.Label(0, titleShift+3, "站別", wcfT); // (行,列)
                    ws.addCell(labelCFC2);
	                ws.setColumnView(1, 15);
					
					 //抬頭:(第3列第2行)
	                jxl.write.Label labelCF3 = new jxl.write.Label(1, titleShift+3, "站名", wcfT); // (行,列)
                    ws.addCell(labelCF3);
	                ws.setColumnView(2, 10);
	
	                //抬頭:(第3列第2行)
	                jxl.write.Label labelCF4 = new jxl.write.Label(2, titleShift+3, "期初", wcfT); // (行,列)
                    ws.addCell(labelCF4);
	                ws.setColumnView(3, 10);
	
	                 //抬頭:(第3列第3行)
	                jxl.write.Label labelCF5 = new jxl.write.Label(3, titleShift+3, "接收", wcfT); // (行,列)
                    ws.addCell(labelCF5);
	                ws.setColumnView(4, 10);	               
	
	                //抬頭:(第3列第5行)
	                jxl.write.Label labelCFC6 = new jxl.write.Label(4, titleShift+3, "產出", wcfT); // (行,列)
                    ws.addCell(labelCFC6);
	                ws.setColumnView(5, 10);
	
	                //抬頭:(第3列第6行)
	                jxl.write.Label labelCFC7 = new jxl.write.Label(5, titleShift+3, "耗損", wcfT); // (行,列)
                    ws.addCell(labelCFC7);
	                ws.setColumnView(6, 10);
	
	                //抬頭:(第3列第7行)
	                jxl.write.Label labelCF8 = new jxl.write.Label(6, titleShift+3, "期末", wcfT); // (行,列)
                    ws.addCell(labelCF8);
	                ws.setColumnView(7, 10);
	
	                jxl.write.Label labelCF9 = new jxl.write.Label(7, titleShift+3, "工時", wcfT); // (行,列)
                    ws.addCell(labelCF9);
	                ws.setColumnView(8, 10);
	
	                jxl.write.Label labelCF10 = new jxl.write.Label(8, titleShift+3, "良品率", wcfT); // (行,列)
                    ws.addCell(labelCF10);
	                ws.setColumnView(9, 10);
	
	                jxl.write.Label labelCF11 = new jxl.write.Label(9, titleShift+3, "PPH", wcfT); // (行,列)
                    ws.addCell(labelCF11);
	                ws.setColumnView(10, 10);
		           
		
		           // 取各個站別的處理明細_SQL起		  
		           
	     //int opCount = 0;
	     float frontBeginBalTotal=0, frontQtyScrapTotal=0, frontEndBalTotal=0,frontWorkTimeTotal=0,frontLPL=0,frontPPH=0;
		 float frontFirstOpRec = 0, frontOSPComplete=0;
		 float frontLPLRate=0,frontPPHRate=0,frontProdLPLRate=1;
	     // 依各個成本代號,找對應結轉各項數據_起
		           Statement stateFront=con.createStatement();
                   
			       String sqlFront = " select OPERATION_SEQ_NUM, OPERATION_CODE, OPERATION_DESCRIPTION, QUANTITY_BEGIN_BALANCE, QUANTITY_RECEIVED, "+
	                                 "        QUANTITY_COMPLETED, QUANTITY_SCRAPPED, QUANTITY_END_BALANCE, WORK_TIME, LPL, PPH "+
									 "   from YEW_WIP_WIPIO_ALL ";
			       String whereFront = " where PART_NO = '"+rs.getString("PART_NO")+"' and ORGANIZATION_ID = "+marketType+" and ACCT_PERIOD_ID = "+rs.getString("ACCT_PERIOD_ID")+"  "+
				                       "   and TYPE_ID = 1 and OPERATION_CODE != '9998' "+
									   "         and ( FIRST_OPERATION IS NULL or LAST_OPERATION IS NULL ) "+
									   "   and OPERATION_DESCRIPTION not like '%切割%' "+
									   "   and BM in ('1','2','3') ";	//  確保由生產系統(不含一月份舊系統麗玲手開工令)								  
				   String orderFront = "  order by PART_NO, OPERATION_SEQ_NUM "; 				    
				   sqlFront = sqlFront + whereFront + orderFront;
				   ResultSet rsFront=stateFront.executeQuery(sqlFront);	
				   //out.println("sqlFront="+sqlFront+"<BR>");	 
		           while (rsFront.next())
		           // 依各個成本代號,找對應結轉各項數據_迄	
		           {  	
    
	                //out.clearBuffer();
	                //out.println("333<BR>");
	                //out.println(sql);	
	    		 
		               //noSeq = noSeq + 1;
		              titleShift = rowNo+opCount+bkOpCount+(2+2)*rowNo;  // 加上 空白列的 Shift 	
					  //out.println("Front End titleShift="+titleShift+"<BR>");
					  
					 
					  
					  if (rsFront.getString("OPERATION_DESCRIPTION").indexOf("焊接")>=0 || opCount==1)  // 2007/03/22 因為第一站未必是焊接站
		              {
		                frontFirstOpRec = rsFront.getFloat("QUANTITY_RECEIVED");
		              }
					  
		              // 取委外加工(外包_9999)產出數為前段產出數
		              if (rsFront.getString("OPERATION_CODE").equals("9999"))
		              {
		               frontOSPComplete = rsFront.getFloat("QUANTITY_COMPLETED");
		              }
		  
		              if (rsFront.getFloat("QUANTITY_COMPLETED")!=0)  // 2007/03/23 若製程無外包站,則判斷產出數給變數
		              {
		                frontOSPComplete = rsFront.getFloat("QUANTITY_COMPLETED");
		              }		 
		              
		                //out.println("S3");
		  
		               jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.TIMES, 9,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
                       jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		               wcfFL.setBackground(jxl.format.Colour.LIGHT_GREEN); // 設定背景顏色	 
		               wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
		               //out.println("S4"); 		  
		                
		               jxl.write.Label lablePartNo = new jxl.write.Label(0, titleShift+4, rsFront.getString("OPERATION_CODE") , wcfFL); // (行,列);由第七列開始顯示動態資料
                       ws.addCell(lablePartNo);	  
		                
	                   jxl.write.Label lableStatName = new jxl.write.Label(1, titleShift+4, rsFront.getString("OPERATION_DESCRIPTION") , wcfFL); // (行,列);由第七列開始顯示動態資料
                       ws.addCell(lableStatName);					   
					   
					    float qtyFrontBeginBalance = 0;
				        try
		                { 
			              String strFrontBeginBalance = nf.format(rsFront.getFloat("QUANTITY_BEGIN_BALANCE"));
				          bd = new java.math.BigDecimal(rsFront.getFloat("QUANTITY_BEGIN_BALANCE"));
				          java.math.BigDecimal strFrontBeginBalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				          qtyFrontBeginBalance = strFrontBeginBalQty.floatValue();
			            } //end of try
                        catch (NumberFormatException e)
                        {
                         System.out.println("Exception: Begin Balance"+e.getMessage());
                        }
						
						//noSeqStr = integer.toString(noSeq);		               
	                    jxl.write.Label lableBegBlanceQty = new jxl.write.Label(2, titleShift+4, Float.toString(qtyFrontBeginBalance), wcfFL); // (行,列); 台半料號
                        ws.addCell(lableBegBlanceQty);
						
						frontBeginBalTotal=frontBeginBalTotal+rsFront.getFloat("QUANTITY_BEGIN_BALANCE"); 
						
						float qtyFrontReceive = 0;
				        try
		                {
			              String strFrontQtyReceive = nf.format(rsFront.getFloat("QUANTITY_RECEIVED"));
					
				          //bd = new java.math.BigDecimal(strFrontQtyReceive);
					      bd = new java.math.BigDecimal(rsFront.getDouble("QUANTITY_RECEIVED"));
					      //out.println("bd="+bd);
				          java.math.BigDecimal strFrontReceiveQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				          qtyFrontReceive = strFrontReceiveQty.floatValue();
				        } //end of try
                        catch (NumberFormatException e)
                        {
                         System.out.println("Exception: Qty to Receive"+e.getMessage());
                        }
				       		               					   
		                jxl.write.Label lableReceiveQty = new jxl.write.Label(3, titleShift+4, Float.toString(qtyFrontReceive) , wcfFL); // (行,列); 單位
                        ws.addCell(lableReceiveQty);
		                
						float calFrontCompleteQty = rsFront.getFloat("QUANTITY_RECEIVED")+rsFront.getFloat("QUANTITY_BEGIN_BALANCE")-rsFront.getFloat("QUANTITY_END_BALANCE")-rsFront.getFloat("QUANTITY_SCRAPPED"); 
			            try
				        {			         
				          bd = new java.math.BigDecimal(calFrontCompleteQty);
				          java.math.BigDecimal strCalCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				          calFrontCompleteQty = strCalCompleteQty.floatValue();				    
				        } //end of try
                        catch (NumberFormatException e)
                        {
                         System.out.println("Exception: Qty Complete"+e.getMessage());
                        }
				   			     
			            float qtyFrontComplete = 0;
				        try
				        {
			              String strFrontQtyComplete = nf.format(rsFront.getFloat("QUANTITY_COMPLETED"));
				          bd = new java.math.BigDecimal(rsFront.getFloat("QUANTITY_COMPLETED"));
				          java.math.BigDecimal strFrontCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				          qtyFrontComplete = strFrontCompleteQty.floatValue();				    
				        } //end of try
                        catch (NumberFormatException e)
                        {
                         System.out.println("Exception: Qty Complete"+e.getMessage());
                        }
				   
				        if (calFrontCompleteQty != qtyFrontComplete)  qtyFrontComplete = calFrontCompleteQty;  // 若不相等,則以計算的產出數為顯示的產出數				   
				   		              
		              		               					  
		               jxl.write.Label lableProcessQty = new jxl.write.Label(4, titleShift+4, Float.toString(qtyFrontComplete) , wcfFL); 
                       ws.addCell(lableProcessQty);
					   
					   jxl.write.Label lableCompleteQty = new jxl.write.Label(5, titleShift+4, rsFront.getString("QUANTITY_SCRAPPED") , wcfFL); 
                       ws.addCell(lableCompleteQty);						   
					   frontQtyScrapTotal=frontQtyScrapTotal+rsFront.getFloat("QUANTITY_SCRAPPED");					  	 
		        
		               jxl.write.Label lableEndBalanceQty = new jxl.write.Label(6, titleShift+4, rsFront.getString("QUANTITY_END_BALANCE") , wcfFL); 
                       ws.addCell(lableEndBalanceQty);					   
		               frontEndBalTotal=frontEndBalTotal+rsFront.getFloat("QUANTITY_END_BALANCE");  
		               		  
		               jxl.write.Label lableWorkTime = new jxl.write.Label(7, titleShift+4, rsFront.getString("WORK_TIME") , wcfFL); 
                       ws.addCell(lableWorkTime);						   
					   frontWorkTimeTotal=frontWorkTimeTotal+rsFront.getFloat("WORK_TIME");
					   
					   
					   jxl.write.Label lableYieldRate = new jxl.write.Label(8, titleShift+4, rsFront.getString("LPL")+"%" , wcfFL); 
                       ws.addCell(lableYieldRate);	
					   
					   
					   jxl.write.Label lablePPHValue = new jxl.write.Label(9, titleShift+4, rsFront.getString("PPH") , wcfFL); 
                       ws.addCell(lablePPHValue);	
					   
				       frontProdLPLRate = frontProdLPLRate*rsFront.getFloat("LPL")/100; // 前段乘績的良率
				       				     
			  opCount++;  // 計數,判斷是否為該機種的第一站,如為第一站(焊接)則存入變數  	   
							      
				  
	     } // End of while (rsFront.next())
	     rsFront.close();
	     stateFront.close();		
		 
		 // 計算前段的良品率
		 // frontLPLRate=(frontOSPComplete/frontBeginBalTotal)+frontFirstOpRec*100;
		 frontLPLRate=frontOSPComplete/(frontBeginBalTotal+frontFirstOpRec-frontEndBalTotal)*100; //公式:產出/(期初+接收-期末)=良率
		// 計算前段的產出率
		 frontPPHRate=(frontOSPComplete/frontWorkTimeTotal)*1;	
		  
		 
		          jxl.write.WritableFont wfTTL = new jxl.write.WritableFont(WritableFont.TIMES, 9, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
                  jxl.write.WritableCellFormat wcfTTL = new jxl.write.WritableCellFormat(wfTTL); 
	              wcfTTL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	              wcfTTL.setAlignment(jxl.format.Alignment.CENTRE);
                  jxl.write.Label labelTTL = new jxl.write.Label(0, titleShift+5, "前段", wcfTTL);  // (行,列)
                  ws.addCell(labelTTL);
	              ws.mergeCells(0, titleShift+5, 1, titleShift+5);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	              ws.setColumnView(0, 10);	
				  
		 
		          jxl.write.WritableFont wfFL = new jxl.write.WritableFont(WritableFont.TIMES, 9, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
                  jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfFL); 
		          //wcfFL.setBackground(jxl.format.Colour.IVORY);
		  	      wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
				  
				   float frontBeginBalTotalQty = frontBeginBalTotal;
				   try
				   {
			        String strFrontBeginBalTotal = nf.format(frontBeginBalTotal);
				    bd = new java.math.BigDecimal(strFrontBeginBalTotal);
				    java.math.BigDecimal strFrontBeginBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontBeginBalTotalQty = strFrontBeginBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Begin TotQty"+e.getMessage());
                   }
		 
   	               miscellaneousBean.setRoundDigit(3);
		           String totBegQty = miscellaneousBean.getFloatRoundStr(frontBeginBalTotalQty);
		           jxl.write.Label lableTTLBegQty = new jxl.write.Label(2, titleShift+5, Float.toString(frontBeginBalTotalQty), wcfFL); // 總計前段期初數
                   ws.addCell(lableTTLBegQty);	
				  
				   float frontFirstOpRecQty = frontFirstOpRec;
				   try
				   {
			        String strFrontFirstOpRec = nf.format(frontFirstOpRec);
				    bd = new java.math.BigDecimal(strFrontFirstOpRec);
				    java.math.BigDecimal strFrontFirstOpRecQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontFirstOpRecQty = strFrontFirstOpRecQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty First OpQty"+e.getMessage());
                   }
		 
		          //miscellaneousBean.setRoundDigit(3);
		          String totRecptQty = miscellaneousBean.getFloatRoundStr(frontFirstOpRecQty);
		          jxl.write.Label lableTTLRecptQty = new jxl.write.Label(3, titleShift+5, totRecptQty , wcfFL); // 總計接收數
                  ws.addCell(lableTTLRecptQty);		 
				  
				   float frontOSPCompleteQty = frontOSPComplete;
				   try
				   {
			        String strFrontOSPComplete = nf.format(frontOSPComplete);
				    bd = new java.math.BigDecimal(strFrontOSPComplete);
				    java.math.BigDecimal strFrontOSPCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontOSPCompleteQty = strFrontOSPCompleteQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty First OSP Qty"+e.getMessage());
                   }
		 
		          String totProcesQty = miscellaneousBean.getFloatRoundStr(frontOSPCompleteQty);
		          jxl.write.Label lableTTLProcesQty = new jxl.write.Label(4, titleShift+5, totProcesQty , wcfFL); // 總計處理數
                  ws.addCell(lableTTLProcesQty);
				  
				   float frontQtyScrapTotalQty = frontQtyScrapTotal;
				   try
				   {
			        String strFrontQtyScrapTotal = nf.format(frontQtyScrapTotal);
				    bd = new java.math.BigDecimal(strFrontQtyScrapTotal);
				    java.math.BigDecimal strFrontQtyScrapTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontQtyScrapTotalQty = strFrontQtyScrapTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Scrap Qty"+e.getMessage());
                   }	
		 
		          String totCompleteQty = miscellaneousBean.getFloatRoundStr(frontQtyScrapTotalQty);
		          jxl.write.Label lableTTLCompleteQty = new jxl.write.Label(5, titleShift+5, totCompleteQty , wcfFL); // 總計完工數
                  ws.addCell(lableTTLCompleteQty);	
				  
				   float frontEndBalTotalQty = frontEndBalTotal;
				   try
				   {
			        String strFrontEndBalTotal = nf.format(frontEndBalTotal);
				    bd = new java.math.BigDecimal(strFrontEndBalTotal);
				    java.math.BigDecimal strFrontEndBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontEndBalTotalQty = strFrontEndBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Scrap Qty"+e.getMessage());
                   }
		 
		          String totScrapQty = miscellaneousBean.getFloatRoundStr(frontEndBalTotalQty);
		          jxl.write.Label lableTTLScrapQty = new jxl.write.Label(6, titleShift+5, totScrapQty , wcfFL); // 總計報廢數
                  ws.addCell(lableTTLScrapQty);	
				  
				   float frontWorkTimeTotalQty = frontWorkTimeTotal;
				   try
				   {
			        String strFrontWorkTimeTotal = nf.format(frontWorkTimeTotal);
				    bd = new java.math.BigDecimal(strFrontWorkTimeTotal);
				    java.math.BigDecimal strFrontWorkTimeTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontWorkTimeTotalQty = strFrontWorkTimeTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Scrap Qty"+e.getMessage());
                   }		 
		        		 
		          String totWorkTimeQty = miscellaneousBean.getFloatRoundStr(frontWorkTimeTotalQty);
		          jxl.write.Label lableTTLWorkTime = new jxl.write.Label(7, titleShift+5, totWorkTimeQty , wcfFL); // 總計工時
                  ws.addCell(lableTTLWorkTime); 
				  
				   float frontLPLRateQty = frontProdLPLRate*100;  //frontLPLRate;
				   try
				   {
			        String strFrontLPLRate = nf2.format(frontProdLPLRate*100);
				    bd2 = new java.math.BigDecimal(strFrontLPLRate);
				    java.math.BigDecimal strFrontLPLRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    frontLPLRateQty = strFrontLPLRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty LPL Rate Total"+e.getMessage());
                   }
			 
		 
		          jxl.write.Label lableTTLYieldRate = new jxl.write.Label(8, titleShift+5, Float.toString(frontLPLRateQty)+"%" , wcfFL); // 總計良品率
                  ws.addCell(lableTTLYieldRate); 
		
		           float frontPPHRateQty = frontPPHRate;
				   try
				   {
			        String strFrontPPHRate = nf2.format(frontPPHRate);
				    bd2 = new java.math.BigDecimal(strFrontPPHRate);
				    java.math.BigDecimal strFrontPPHRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    frontPPHRateQty = strFrontPPHRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty PPH Rate Total"+e.getMessage());
                   }
				   
		          jxl.write.Label lableTTLPPHValue = new jxl.write.Label(9, titleShift+5, Float.toString(frontPPHRateQty) , wcfFL); // 總計產出率
                  ws.addCell(lableTTLPPHValue);
				  
		
		  // 後段各站別 迴圈_起 		  
		 //int bkOpCount = 0;
	     float backBeginBalTotal=0, backQtyScrapTotal=0, backEndBalTotal=0,backWorkTimeTotal=0,backLPL=0,backPPH=0; 
		 float backFirstOpRec=0, backPackComplete=0;
		 float backLPLRate=0,backPPHRate=0,backProdLPLRate=1;
		 float backSumRcptQty=0,backTotalRcptQty = 0;
	     // 依各個成本代號,找對應結轉各項數據_起
		           Statement stateBack=con.createStatement();
                   
			       String sqlBack = " select OPERATION_SEQ_NUM, OPERATION_CODE, OPERATION_DESCRIPTION, QUANTITY_BEGIN_BALANCE, QUANTITY_RECEIVED, "+
	                                 "        QUANTITY_COMPLETED, QUANTITY_SCRAPPED, QUANTITY_END_BALANCE, WORK_TIME, LPL, PPH "+
									 "   from YEW_WIP_WIPIO_ALL ";
			       String whereBack = " where PART_NO = '"+rs.getString("PART_NO")+"' and ORGANIZATION_ID = "+marketType+" and ACCT_PERIOD_ID = "+rs.getString("ACCT_PERIOD_ID")+"  "+
				                       "   and TYPE_ID = 2 "+
									   "   and BM in ('1','2','3') ";	//  確保由生產系統(不含一月份舊系統麗玲手開工令)
				   String orderBack = "  order by PART_NO, OPERATION_SEQ_NUM "; 
				   sqlBack = sqlBack + whereBack + orderBack;
				   ResultSet rsBack=stateBack.executeQuery(sqlBack);	
		 //out.println("sqlBack="+sqlBack+"<BR>");
		 while (rsBack.next())                      
		 {
		    titleShift = rowNo+opCount+bkOpCount+(2+2)*rowNo;  // 列號*空白列的Shift			
			
			
			//out.println("Back End titleShift="+titleShift+" bkOpCount="+bkOpCount+" titleShift+6="+titleShift+6+"<BR>");
		  
		    // 取後段接收數=TMTT的接收數 
		    if (rsBack.getString("OPERATION_DESCRIPTION").indexOf("TMT.T")>=0 || bkOpCount==1) // 2007/03/22 因為第一站未必是TMT.T 站
		    {
		      backFirstOpRec=rsBack.getFloat("QUANTITY_RECEIVED");
		    }
		 
		    // 取包裝站產出數為前段產出數
		    if (rsBack.getString("OPERATION_DESCRIPTION").indexOf("包裝")>=0)
		    {
		      backPackComplete=rsBack.getFloat("QUANTITY_COMPLETED");
		    }
		   
		    if (backPackComplete==0 && rsBack.getFloat("QUANTITY_COMPLETED")!=0)  // 2007/03/23 若 取得的站別不為包裝站,則仍把產出數給變數
		    {
		      backPackComplete=rsBack.getFloat("QUANTITY_COMPLETED");
		    }
			
			 
			           jxl.write.WritableFont wfBL = new jxl.write.WritableFont(WritableFont.TIMES, 9,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
                       jxl.write.WritableCellFormat wcfBFL = new jxl.write.WritableCellFormat(wfBL);
		               wcfBFL.setBackground(jxl.format.Colour.LIGHT_GREEN); // 設定背景顏色	 
		               wcfBFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
		               //out.println("S4"); 		  
		           
		               jxl.write.Label lablePartNo = new jxl.write.Label(0, titleShift+5, rsBack.getString("OPERATION_CODE") , wcfBFL); // (行,列);由第七列開始顯示動態資料
                       ws.addCell(lablePartNo);	  
		                
	                   jxl.write.Label lableStatName = new jxl.write.Label(1, titleShift+5, rsBack.getString("OPERATION_DESCRIPTION") , wcfBFL); // (行,列);由第七列開始顯示動態資料
                       ws.addCell(lableStatName);
					   
					   jxl.write.Label lableBkBegBlance = new jxl.write.Label(2, titleShift+5, Float.toString(rsBack.getFloat("QUANTITY_BEGIN_BALANCE")) , wcfBFL); // (行,列);由第七列開始顯示動態資料
                       ws.addCell(lableBkBegBlance);
					   
					   String backBeginRcptStrQty = "";
					   if (rsBack.getString("OPERATION_DESCRIPTION").indexOf("TMT.T")>=0 || bkOpCount==1) // 2007/03/22 因為第一站未必是TMT.T 站
		               {					   
					     float backBeginRcptQty = rsBack.getFloat("QUANTITY_COMPLETED")+rsBack.getFloat("QUANTITY_SCRAPPED");
				         try
				         {
			               String strBackBeginRcpt = nf.format(rsBack.getFloat("QUANTITY_COMPLETED")+rsBack.getFloat("QUANTITY_SCRAPPED"));
				           bd = new java.math.BigDecimal(strBackBeginRcpt);
				           java.math.BigDecimal strBackBeginRcptQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				           backBeginRcptQty = strBackBeginRcptQty.floatValue();				    
				         } //end of try
                         catch (NumberFormatException e)
                         {
                          System.out.println("Exception: Qty Back Begin Receipt "+e.getMessage());
                         }
				      
				          
						 backBeginRcptStrQty = Float.toString(backBeginRcptQty);
						 
					     backSumRcptQty = backBeginRcptQty;  // 2007/03/23 把第一站的接受數(產出 + 耗損)給後段的接收數
					     backTotalRcptQty = backBeginRcptQty;  // 2007/03/23 把第一站的接受數(產出 + 耗損)給全段的接收數
					   
					   } else { // 否則即為實際接收數					             
							    backBeginRcptStrQty = rsBack.getString("QUANTITY_RECEIVED");
					          }
					   
					   jxl.write.Label lableBkRecptStrQty = new jxl.write.Label(3, titleShift+5, backBeginRcptStrQty , wcfBFL); // (行,列);由第七列開始顯示動態資料
                       ws.addCell(lableBkRecptStrQty);
					   
				   // 2007/03/29 確認是否結轉產出數 = 接收 + 期初 - 期末 - 耗損, 否則, 以此公式計算產出數
				   String bkCompStrQty = "0";
				   float calBackCompleteQty = rsBack.getFloat("QUANTITY_RECEIVED")+rsBack.getFloat("QUANTITY_BEGIN_BALANCE")-rsBack.getFloat("QUANTITY_END_BALANCE")-rsBack.getFloat("QUANTITY_SCRAPPED"); 
			       try
				   {			         
				    bd = new java.math.BigDecimal(calBackCompleteQty);
				    java.math.BigDecimal strCalCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    calBackCompleteQty = strCalCompleteQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Complete"+e.getMessage());
                   }
			    
			      if (rsBack.getFloat("QUANTITY_COMPLETED")==0)
			      { 
			        bkCompStrQty = Float.toString(backPackComplete); 
			      } else {  // 2007/03/29 判斷若是後段結轉產出數不等於 =  接收 + 期初 - 期末 - 耗損, 否則, 以此公式計算產出數
			                if (calBackCompleteQty!=rsBack.getFloat("QUANTITY_COMPLETED")) 
							{   bkCompStrQty =Float.toString(calBackCompleteQty);  }
						    else {
			                       bkCompStrQty = rsBack.getString("QUANTITY_COMPLETED"); 
							     }
			            }
				
				   jxl.write.Label lableBkCompQty = new jxl.write.Label(4, titleShift+5, bkCompStrQty , wcfBFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkCompQty);
				   
				   jxl.write.Label lableBkScrapQty = new jxl.write.Label(5, titleShift+5, rsBack.getString("QUANTITY_SCRAPPED") , wcfBFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkScrapQty);
				   backQtyScrapTotal=backQtyScrapTotal+rsBack.getFloat("QUANTITY_SCRAPPED");
				   
				   jxl.write.Label lableBkEndBalanceQty = new jxl.write.Label(6, titleShift+5, rsBack.getString("QUANTITY_END_BALANCE") , wcfBFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkEndBalanceQty);
				   backEndBalTotal=backEndBalTotal+rsBack.getFloat("QUANTITY_END_BALANCE");
				   
				   jxl.write.Label lableBkWorkTime = new jxl.write.Label(7, titleShift+5, rsBack.getString("WORK_TIME") , wcfBFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkWorkTime);
				   backWorkTimeTotal=backWorkTimeTotal+rsBack.getFloat("WORK_TIME");
				   
				   jxl.write.Label lableBkLPL = new jxl.write.Label(8, titleShift+5, rsBack.getString("LPL")+"%" , wcfBFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkLPL);
				   
				   jxl.write.Label lableBkPPH = new jxl.write.Label(9, titleShift+5, rsBack.getString("PPH") , wcfBFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkPPH);
				   
				   backProdLPLRate = backProdLPLRate*rsBack.getFloat("LPL")/100; // 後段乘績的良率
				    	   
			
			 bkOpCount++;
		 
		 } // End of while
		 rsBack.close();
		 stateBack.close(); 
		 
		 // 計算後段的良品率
		 //backLPLRate=(backPackComplete/backBeginBalTotal)+frontFirstOpRec*100;
		 backLPLRate=backPackComplete/(backBeginBalTotal+frontFirstOpRec-backEndBalTotal)*100; //公式:產出/(期出+接收-期末)=良率
		// 計算後段的產出率
		 backPPHRate=(backPackComplete/backWorkTimeTotal)*1;
		 
		      // 後段的加總_起
		          jxl.write.WritableFont wfBKTTL = new jxl.write.WritableFont(WritableFont.TIMES, 9, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
                  jxl.write.WritableCellFormat wcfBKTTL = new jxl.write.WritableCellFormat(wfBKTTL); 
	              wcfBKTTL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	              wcfBKTTL.setAlignment(jxl.format.Alignment.CENTRE);
                  jxl.write.Label labelBKTTL = new jxl.write.Label(0, titleShift+6, "後段", wcfBKTTL);  // (行,列)
                  ws.addCell(labelBKTTL);
	              ws.mergeCells(0, titleShift+6, 1, titleShift+6);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	              ws.setColumnView(0, 10);	
				  
				   float backBeginBalTotalQty = backBeginBalTotal;
				   try
				   {
			        String strBackBeginBalTotal = nf.format(backBeginBalTotal);
				    bd = new java.math.BigDecimal(strBackBeginBalTotal);
				    java.math.BigDecimal strBackBeginBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backBeginBalTotalQty = strBackBeginBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back Begin Balance Total"+e.getMessage());
                   }
				   
				   jxl.write.Label lableBkBegBlanceTTL = new jxl.write.Label(2, titleShift+6, Float.toString(backBeginBalTotalQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkBegBlanceTTL);
				   
				   float backFirstOpRecQty = backSumRcptQty;//   backFirstOpRec; // frontFirstOpRec;
				   try
				   {
			        String strBackFirstOpRec = nf.format(backFirstOpRecQty);
				    bd = new java.math.BigDecimal(strBackFirstOpRec);
				    java.math.BigDecimal strBackFirstOpRecQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backFirstOpRecQty = strBackFirstOpRecQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back First Receipt Qty"+e.getMessage());
                   }
				   
				   jxl.write.Label lableBkOPRecTTL = new jxl.write.Label(3, titleShift+6, Float.toString(backFirstOpRecQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkOPRecTTL);
				   
				   float backPackCompleteQty = backPackComplete;
				   try
				   {
			        String strBackPackComplete = nf.format(backPackCompleteQty);
				    bd = new java.math.BigDecimal(strBackPackComplete);
				    java.math.BigDecimal strBackPackCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backPackCompleteQty = strBackPackCompleteQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back Complete Qty"+e.getMessage());
                   }		
				   				     
				   jxl.write.Label lableBkPackCompTTL = new jxl.write.Label(4, titleShift+6, Float.toString(backPackCompleteQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkPackCompTTL);
				   
				   float backQtyScrapTotalQty = backQtyScrapTotal;
				   try
				   {
			        String strBackQtyScrapTotal = nf.format(backQtyScrapTotalQty);
				    bd = new java.math.BigDecimal(strBackQtyScrapTotal);
				    java.math.BigDecimal strBackQtyScrapTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backQtyScrapTotalQty = strBackQtyScrapTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back Scrap Qty"+e.getMessage());
                   }
				   
				   jxl.write.Label lableBkScrapQtyTTL = new jxl.write.Label(5, titleShift+6, Float.toString(backQtyScrapTotalQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkScrapQtyTTL);
				   
				   float backEndBalTotalQty = backEndBalTotal;
				   try
				   {
			        String strBackEndBalTotal = nf.format(backEndBalTotalQty);
				    bd = new java.math.BigDecimal(strBackEndBalTotal);
				    java.math.BigDecimal strBackEndBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backEndBalTotalQty = strBackEndBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back End Balance Qty"+e.getMessage());
                   }
				   
				   jxl.write.Label lableBkEndQtyTTL = new jxl.write.Label(6, titleShift+6, Float.toString(backEndBalTotalQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkEndQtyTTL);
				   
				   float backWorkTimeTotalQty = backWorkTimeTotal;
				   try
				   {
			        String strBackWorkTimeTotal = nf.format(backWorkTimeTotalQty);
				    bd = new java.math.BigDecimal(strBackWorkTimeTotal);
				    java.math.BigDecimal strBackWorkTimeTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backWorkTimeTotalQty = strBackWorkTimeTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back Work Time "+e.getMessage());
                   }
				   
				   jxl.write.Label lableBkWorkTimeTTL = new jxl.write.Label(7, titleShift+6, Float.toString(backWorkTimeTotalQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkWorkTimeTTL);
				   
				   float backLPLRateQty = backProdLPLRate*100; //backLPLRate;
				   try
				   {
			        String strBackLPLRate = nf2.format(backProdLPLRate*100);
				    bd2 = new java.math.BigDecimal(strBackLPLRate);
				    java.math.BigDecimal strBackLPLRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    backLPLRateQty = strBackLPLRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back LPL Rate "+e.getMessage());
                   }
				   
				   jxl.write.Label lableBkLPLTTL = new jxl.write.Label(8, titleShift+6, Float.toString(backLPLRateQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkLPLTTL);
				   
				   float backPPHRateQty = backPPHRate;
				   try
				   {
			        String strBackPPHRate = nf2.format(backPPHRateQty);
				    bd2 = new java.math.BigDecimal(strBackPPHRate);
				    java.math.BigDecimal strBackPPHRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    backPPHRateQty = strBackPPHRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back PPH Value "+e.getMessage());
                   }
				   
				   jxl.write.Label lableBkPPHTTL = new jxl.write.Label(9, titleShift+6, Float.toString(backPPHRateQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableBkPPHTTL);
				   
		 // 計算全段的加總或判斷_起
		 float sumBeginBalTotal = 0, sumQtyScrapTotal=0, sumEndBalTotal=0, sumWorkTimeTotal=0;
		 float sumReceiptTotal=0;
		 float sumLPLRate=0, sumPPHRate=0;
		 
		 sumBeginBalTotal=frontBeginBalTotal+backBeginBalTotal;
		 sumQtyScrapTotal=frontQtyScrapTotal+backQtyScrapTotal;
		 sumEndBalTotal=frontEndBalTotal+backEndBalTotal;
		 sumWorkTimeTotal=frontWorkTimeTotal+backWorkTimeTotal;
		 sumReceiptTotal=(backPackComplete-sumBeginBalTotal+sumQtyScrapTotal+sumEndBalTotal); //全段(產出-期初+耗損+期末)=全段接收
         
		 // 計算全段的良品率
		 sumLPLRate=backPackComplete/(sumBeginBalTotal+sumReceiptTotal-sumEndBalTotal)*100;  //公式:產出/(期出+接收-期末)=良率
		 // 計算全段的產出率
		 sumPPHRate=(backPackComplete/sumWorkTimeTotal)*1; 
		 
		          jxl.write.WritableFont wfGTTL = new jxl.write.WritableFont(WritableFont.TIMES, 9, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
                  jxl.write.WritableCellFormat wcfGTTL = new jxl.write.WritableCellFormat(wfGTTL); 
	              wcfGTTL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	              wcfGTTL.setAlignment(jxl.format.Alignment.CENTRE);
                  jxl.write.Label labelGTTL = new jxl.write.Label(0, titleShift+7, "全段", wcfGTTL);  // (行,列)
                  ws.addCell(labelGTTL);
	              ws.mergeCells(0, titleShift+7, 1, titleShift+7);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	              ws.setColumnView(0, 10);
				  
				   float sumBeginBalTotalQty = sumBeginBalTotal;
				   try
				   {
			        String strSumBeginBalTotal = nf.format(sumBeginBalTotalQty);
				    bd = new java.math.BigDecimal(strSumBeginBalTotal);
				    java.math.BigDecimal strSumBeginBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumBeginBalTotalQty = strSumBeginBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum Begin Balance Qty "+e.getMessage());
                   }
				   
				   jxl.write.Label lableGBegBalTTL = new jxl.write.Label(2, titleShift+7, Float.toString(sumBeginBalTotalQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableGBegBalTTL); 
				   
				   float sumReceiptTotalQty = sumReceiptTotal;
				   try
				   {
			        String strSumReceiptTotal = nf.format(sumReceiptTotalQty);
				    bd = new java.math.BigDecimal(strSumReceiptTotal);
				    java.math.BigDecimal strSumReceiptTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumReceiptTotalQty = strSumReceiptTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum Begin Balance Qty "+e.getMessage());
                   } 
				   
				   jxl.write.Label lableGRecpTTL = new jxl.write.Label(3, titleShift+7, Float.toString(sumReceiptTotalQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableGRecpTTL);
				   
				   float sumBackPackCompleteQty = backPackComplete;
				   try
				   {
			        String strSumBackPackComplete = nf.format(sumBackPackCompleteQty);
				    bd = new java.math.BigDecimal(strSumBackPackComplete);
				    java.math.BigDecimal strSumBackPackCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumBackPackCompleteQty = strSumBackPackCompleteQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum PackComplete Qty "+e.getMessage());
                   }
				   
				   jxl.write.Label lableGCompTTL = new jxl.write.Label(4, titleShift+7, Float.toString(sumBackPackCompleteQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableGCompTTL);
				   
				   float sumQtyScrapTotalQty = sumQtyScrapTotal;
				   try
				   {
			        String strSumQtyScrapTotal = nf.format(sumQtyScrapTotalQty);
				    bd = new java.math.BigDecimal(strSumQtyScrapTotal);
				    java.math.BigDecimal strSumQtyScrapTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumQtyScrapTotalQty = strSumQtyScrapTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum Scrap Total Qty "+e.getMessage());
                   }
				   
				   jxl.write.Label lableGScrapTTL = new jxl.write.Label(5, titleShift+7, Float.toString(sumQtyScrapTotalQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableGScrapTTL);
				   
				   float sumEndBalTotalQty = sumEndBalTotal;
				   try
				   {
			        String strSumEndBalTotal = nf.format(sumEndBalTotalQty);
				    bd = new java.math.BigDecimal(strSumEndBalTotal);
				    java.math.BigDecimal strSumEndBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumEndBalTotalQty = strSumEndBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum Scrap Total Qty "+e.getMessage());
                   }
				   
				   jxl.write.Label lableGEndBalTTL = new jxl.write.Label(6, titleShift+7, Float.toString(sumEndBalTotalQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableGEndBalTTL);
				   
				   float sumWorkTimeTotalQty = sumWorkTimeTotal;
				   try
				   {
			        String strSumWorkTimeTotal = nf.format(sumWorkTimeTotalQty);
				    bd = new java.math.BigDecimal(strSumWorkTimeTotal);
				    java.math.BigDecimal strSumWorkTimeTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumWorkTimeTotalQty = strSumWorkTimeTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum WorkTIme Total Qty "+e.getMessage());
                   }
				   
				   jxl.write.Label lableGWorkTimeTTL = new jxl.write.Label(7, titleShift+7, Float.toString(sumWorkTimeTotalQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableGWorkTimeTTL);
				   
				   float sumLPLRateQty = frontLPLRateQty*backLPLRateQty/100; //sumLPLRate; // 2007/03/22 更改為全段良率 = 前段 * 後段/100
				   try
				   {
			        String strSumLPLRate = nf2.format(sumLPLRateQty);
				    bd2 = new java.math.BigDecimal(strSumLPLRate);
				    java.math.BigDecimal strSumLPLRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    sumLPLRateQty = strSumLPLRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum LPL Rate Qty "+e.getMessage());
                   }
				   
				   jxl.write.Label lableLPLRateTTL = new jxl.write.Label(8, titleShift+7, Float.toString(sumLPLRateQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lableLPLRateTTL);
				   
				   float sumPPHRateQty = sumPPHRate;
				   try
				   {
			        String strSumPPHRate = nf2.format(sumPPHRateQty);
				    bd2 = new java.math.BigDecimal(strSumPPHRate);
				    java.math.BigDecimal strSumPPHRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    sumPPHRateQty = strSumPPHRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum PPH Value Qty "+e.getMessage());
                   }
				   
				   jxl.write.Label lablePPHRateTTL = new jxl.write.Label(9, titleShift+7, Float.toString(sumPPHRateQty) , wcfFL); // (行,列);由第七列開始顯示動態資料
                   ws.addCell(lablePPHRateTTL);		 
		
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
      response.sendRedirect("/oradds/report/WPY"+userID+"_"+ymdCurr+hmsCurr+".xls");  

%>

</html>
