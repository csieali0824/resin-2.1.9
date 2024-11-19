<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*" %>
<%@ page import="DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCMfgWoExceltype2.jsp" METHOD="post" name="MYFORM">
<%
  //String RepLocale=(String)session.getAttribute("LOCALE");  // 改抓Session內的登入資料
  //String UserID=request.getParameter("USERID");             // 改抓Session內的登入資料
  String serverHostName=request.getServerName();
  String sqlGlobal = request.getParameter("SQLGLOBAL");

  String RepCenterNo=request.getParameter("REPCENTERNO");   // 改抓Session內的登入資料

  String dateStringBegin=request.getParameter("DATEBEGIN");
  String dateStringEnd=request.getParameter("DATEEND");  
  
  
  String SWHERE=request.getParameter("SWHERECOND");
//  if (dateStringBegin==null){dateStringBegin=dateBean.getYearMonthDay();}
 // if (dateStringEnd==null){dateStringEnd=dateBean.getYearMonthDay();}

  String ymdCurr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
  String hmsCurr = dateBean.getHourMinuteSecond();
  
  String strHMSec = request.getParameter("HOURTIME");
 
  
 try 
    { 	
	 String sql = "";
	 String sWhere = "";
   //String sWRpModel = "";
	 String orderBy = "";
	 	    
	String woNo=request.getParameter("WONO"); 
    String marketType=request.getParameter("MARKETTYPE");
	String woType=request.getParameter("WOTYPE");

	String dateSetBegin=request.getParameter("DATESETBEGIN");
	String dateSetEnd=request.getParameter("DATESETEND");

	String YearFr=request.getParameter("YEARFR");
	String MonthFr=request.getParameter("MONTHFR");
	String DayFr=request.getParameter("DAYFR");
      if (dateSetBegin==null ) dateSetBegin=YearFr+MonthFr+DayFr;

	String YearTo=request.getParameter("YEARTO");
	String MonthTo=request.getParameter("MONTHTO");
	String DayTo=request.getParameter("DAYTO");
      if (dateSetEnd==null ) dateSetEnd=YearTo+MonthTo+DayTo; 
	  
	String marketCode="",iqcResult="",tscAmp="",invItem="",itemDesc="",woQty="",waferDesc="",waferLot="",waferQty="";
	String startDate="",endDate="",waferYld="",woRemark=""; 
	String waiveNo="",waferKind="",waferVendor="",waferElect="",waferSize="",waferUsedPce="";
	if (marketType=="--" || marketType.equals("--"))
	 {marketType="";}
	 
     if (sqlGlobal==null || sqlGlobal=="")
	 { 		
	     // out.print("step1");
	     /*
		   sql = " select YWA.WO_NO,YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_QTY,YWA.WO_UOM,YWA.TSC_AMP, IQCR.RESULT_NAME RESULT,TLD.INSPLOT_NO,TLD.INSPECT_QTY, "+
		  		 "		  YWA.WAFER_KIND,YWA.WAFER_VENDOR,TLH.WF_RESIST,TWS.WF_SIZE_NAME,TLD.PROD_YIELD,TLD.INV_ITEM_DESC,TLD.SUPPLIER_LOT_NO,"+
	       		 "        TLD.RESULT,TO_DATE(SUBSTR(YWA.SCHEDULE_STRART_DATE,1,8),'YYYY/MM/DD') START_DATE,TLD.LWAIVE_NO,decode(YWA.MARKET_TYPE,1,'內銷',2,'外銷','') as MARKET_TYPE ,  "+
		   		 "        TO_DATE(SUBSTR(YWA.SCHEDULE_END_DATE,1,8),'YYYY/MM/DD') END_DATE,YWA.WO_REMARK ,YWA.WAFER_USED_PCE"+
				 "   from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD,ORADDMAN.TSCIQC_LOTINSPECT_HEADER TLH,ORADDMAN.TSCIQC_RESULT IQCR,"+
	     	     "        APPS.YEW_WORKORDER_ALL YWA,ORADDMAN.TSCIQC_WAFER_SIZE TWS ";
		  sWhere =   "  where  YWA.WAFER_IQC_NO = TLD.INSPLOT_NO and YWA.WAFER_LINE_NO=to_char(TLD.LINE_NO) "+
	  				 " 		and TLH.INSPLOT_NO=TLD.INSPLOT_NO and TLD.WAFER_SIZE=TWS.WF_SIZE_ID  and IQCR.RESULT_ID=tld.RESULT "+
	   		  		 "		 and YWA.WORKORDER_TYPE='"+woType+"' and YWA.MARKET_TYPE = nvl('"+marketType+"',YWA.MARKET_TYPE) "+
				 	 "       and substr(YWA.CREATION_DATE,0,8) >= '"+dateSetBegin+"' and substr(YWA.CREATION_DATE,0,8) <= '"+dateSetEnd+"' ";
		 */
		 sql = " select DISTINCT YWA.WO_NO,YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_QTY,YWA.WO_UOM,YWA.TSC_AMP,                                 "+
		  		 "		         YWA.WAFER_KIND,YWA.WAFER_VENDOR,                                                                      "+
	       		 "               TO_DATE(SUBSTR(YWA.SCHEDULE_STRART_DATE,1,8),'YYYY/MM/DD') START_DATE, decode(YWA.MARKET_TYPE,1,'內銷',2,'外銷','') as MARKET_TYPE ,  "+
		   		 "               TO_DATE(SUBSTR(YWA.SCHEDULE_END_DATE,1,8),'YYYY/MM/DD') END_DATE, YWA.WO_REMARK , YWA.WAFER_USED_PCE, "+
				 "               RC.STATUS"+
				 "   from APPS.YEW_WORKORDER_ALL YWA,YEW_RUNCARD_ALL RC ";
	   sWhere =  "  where YWA.WO_NO=RC.WO_NO(+) and YWA.WORKORDER_TYPE='"+woType+"' and YWA.STATUSID !='050' "+
				 "   and substr(YWA.CREATION_DATE,0,8) >= '"+dateSetBegin+"' and substr(YWA.CREATION_DATE,0,8) <= '"+dateSetEnd+"' ";
		   
		   orderBy =  " order by YWA.WO_NO ";	
		   
	   if (marketType==null || marketType.equals("") || marketType.equals("--"))  { sWhere=sWhere+" ";}
	   else { sWhere=sWhere+" and YWA.MARKET_TYPE = '"+marketType+"' "  ; }         

	   if (woNo==null || woNo.equals(""))  {sWhere=sWhere+" ";}
	   else { sWhere=sWhere+" and YWA.WO_NO ='"+woNo+"' "  ; }   

	 
	   if (UserRoles.indexOf("admin")>=0)  
	   {  sWhere=sWhere+" ";}
	   else if (UserRoles.indexOf("YEW_WIP_QUERY")>=0) 
       {
         sWhere=sWhere+" "; 	 	    
       }
       else  // 依製造部看到各自的工令
		  { sWhere=sWhere+" and YWA.DEPT_NO ='"+userMfgDeptNo+"'"; } 
		  
	   
	 } // End of if (sqlGlobal==null)  
	 else
      {
	    /*
	 	  sql = " select YWA.WO_NO,YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_QTY,YWA.WO_UOM,YWA.TSC_AMP, IQCR.RESULT_NAME RESULT,TLD.INSPLOT_NO,TLD.INSPECT_QTY, "+
		  		 "		  YWA.WAFER_KIND,YWA.WAFER_VENDOR,TLH.WF_RESIST,TWS.WF_SIZE_NAME,TLD.PROD_YIELD,TLD.INV_ITEM_DESC,TLD.SUPPLIER_LOT_NO,"+
       			 "        TO_DATE(SUBSTR(YWA.SCHEDULE_STRART_DATE,1,8),'YYYY/MM/DD') START_DATE,TLD.LWAIVE_NO,decode(YWA.MARKET_TYPE,1,'內銷',2,'外銷','') as MARKET_TYPE,  "+
	   			 "        TO_DATE(SUBSTR(YWA.SCHEDULE_END_DATE,1,8),'YYYY/MM/DD') END_DATE ,YWA.WO_REMARK,YWA.WAFER_USED_PCE "+
				 "   from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD,ORADDMAN.TSCIQC_LOTINSPECT_HEADER TLH,ORADDMAN.TSCIQC_RESULT IQCR, "+
     		     "        APPS.YEW_WORKORDER_ALL YWA,ORADDMAN.TSCIQC_WAFER_SIZE TWS ";
	   sWhere =  "  where YWA.WAFER_IQC_NO = TLD.INSPLOT_NO and YWA.WAFER_LINE_NO=to_char(TLD.LINE_NO) "+
	  				 " 		and TLH.INSPLOT_NO=TLD.INSPLOT_NO and TLD.WAFER_SIZE=TWS.WF_SIZE_ID and IQCR.RESULT_ID=tld.RESULT "+
	   		  		 "		 and YWA.WORKORDER_TYPE='"+woType+"' and YWA.MARKET_TYPE = nvl('"+marketType+"',YWA.MARKET_TYPE) "+
				 	 "       and substr(YWA.CREATION_DATE,0,8) >= '"+dateSetBegin+"' and substr(YWA.CREATION_DATE,0,8) <= '"+dateSetEnd+"' ";
		 */
		   sql = " select DISTINCT YWA.WO_NO,YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_QTY,YWA.WO_UOM,YWA.TSC_AMP,                                 "+
		  		 "		           YWA.WAFER_KIND,YWA.WAFER_VENDOR, YWA.WAFER_IQC_NO, YWA.WAFER_LINE_NO,                                                                     "+
	       		 "                 TO_DATE(SUBSTR(YWA.SCHEDULE_STRART_DATE,1,8),'YYYY/MM/DD') START_DATE, decode(YWA.MARKET_TYPE,1,'內銷',2,'外銷','') as MARKET_TYPE ,  "+
		   		 "                 TO_DATE(SUBSTR(YWA.SCHEDULE_END_DATE,1,8),'YYYY/MM/DD') END_DATE, YWA.WO_REMARK , YWA.WAFER_USED_PCE, "+
				 "                 RC.STATUS "+
				 "   from APPS.YEW_WORKORDER_ALL YWA,YEW_RUNCARD_ALL RC ";
	   sWhere =  "  where YWA.WO_NO =RC.WO_NO(+) and YWA.WORKORDER_TYPE='"+woType+"' and YWA.STATUSID !='050'"+
				 	 "       and substr(YWA.CREATION_DATE,0,8) >= '"+dateSetBegin+"' and substr(YWA.CREATION_DATE,0,8) <= '"+dateSetEnd+"' ";
		   
	   orderBy =  "  order by YWA.WO_NO ";	  

//	   if (woNo==null || woNo.equals(""))  {sWhere=sWhere+" ";}
//	   else {sWhere=sWhere+" and YWA.WO_NO ='"+woNo+"' "  ; }  

       if (marketType==null || marketType.equals("") || marketType.equals("--"))  { sWhere=sWhere+" ";}
	   else { sWhere=sWhere+" and YWA.MARKET_TYPE = '"+marketType+"' "  ; }   
	   
	   if (woNo==null || woNo.equals(""))  {sWhere=sWhere+" ";}
	   else { sWhere=sWhere+" and YWA.WO_NO ='"+woNo+"' "  ; }        
	 
	   if (UserRoles.indexOf("admin")>=0) 
	   {  sWhere=sWhere+" ";  }
	   else if (UserRoles.indexOf("YEW_WIP_QUERY")>=0) 
       {
         sWhere=sWhere+" "; 	 
	     //out.println(sSql+sWhere);
       }	   
       else 
		  {  sWhere=sWhere+" and YWA.DEPT_NO ='"+userMfgDeptNo+"'";   } 
		  
//  	   if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and substr(YWA.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
 //      if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and substr(YWA.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(YWA.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'";  
	  
        }       

	  sql=sql+	sWhere + orderBy;
	
	// 產生報表
	//OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+userID+"_"+ymdCurr+hmsCurr+"_WO.xls"); 
	//OutputStream os = new FileOutputStream("/resin-2.1.9/webapps/oradds/report/"+userID+"_"+ymdCurr+hmsCurr+"_WO.xls");	
	OutputStream os = null;	
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
      os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+userID+"_"+ymdCurr+hmsCurr+"_WO.xls");
	}  else { // For Windows Platform
	          os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+userID+"_"+ymdCurr+hmsCurr+"_WO.xls");
	        }
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("workorder", 0); //-- TEST
	
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
    jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
	wcf2Content.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    //wcf2Content.setBackground(jxl.format.Colour.GRAY_25); // 	  
	
	jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
	wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    wcfT.setAlignment(jxl.format.Alignment.LEFT);
   /*                  */
	
	sst.setSelected();
	sst.setVerticalFreeze(7);
	//sst.setProtected(true);
	sst.setFitToPages(true);	
	sst.setFitWidth(1);  // 設定一頁寬
	//sst.setFitHeight(1);  // 設定一頁高
	//sst.setPassword("kerwin");
			
	//file://抬頭:(第0列第1行)
    jxl.write.WritableFont wf1 = new jxl.write.WritableFont(WritableFont.TIMES, 14,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF1 = new jxl.write.WritableCellFormat(wf1); 
	//wcfF1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	wcfF1.setAlignment(jxl.format.Alignment.CENTRE);
    jxl.write.Label labelCF1 = new jxl.write.Label(0, 0, "YANGXIN EVERWELL ELECTRONIC CO.,  LTD.", wcfF1);  // (行,列)
    ws.addCell(labelCF1);
	ws.mergeCells(0, 0, 14, 0);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 11);
	
	jxl.write.WritableFont wf2 = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF2 = new jxl.write.WritableCellFormat(wf2); 
	wcfF2.setAlignment(jxl.format.Alignment.CENTRE);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCF2 = new jxl.write.Label(0, 1, "Heliu Town Yangxin City Shandong Province CHINA P.R.C Postcode:251807", wcfF2);  // (行,列)
    ws.addCell(labelCF2);
	ws.mergeCells(0, 1, 14, 1);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
	
	//file://抬頭:(第1列第1行)
	jxl.write.WritableFont wf4 = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF4 = new jxl.write.WritableCellFormat(wf4); 
	wcfF4.setAlignment(jxl.format.Alignment.CENTRE);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCF4 = new jxl.write.Label(0, 3, "矽晶片切割/裂片作業指示", wcfF4);  // (行,列)
    ws.addCell(labelCF4);
	ws.mergeCells(0, 3, 14, 3);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
                                     
    //2005.5.26 Gray end
    //抬頭:(第0列第2行)

	jxl.write.Label labelCFC1 = new jxl.write.Label(0, 4, "設立日期:"+dateSetBegin+"~"+dateSetEnd, wcfT); // 指派人員(行,列)
    ws.addCell(labelCFC1);
	ws.setColumnView(1,3);

	//抬頭:(第6列第0行)		// 明細抬頭說明
	jxl.write.Label labelCF5 = new jxl.write.Label(0, 7, "項次", wcfT); // (行,列)
    ws.addCell(labelCF5);
	ws.setColumnView(0,3);
	
    jxl.write.Label labelC19 = new jxl.write.Label(1, 7, "內/外銷別", wcfT); // (行,列)
    ws.addCell(labelC19);
	ws.setColumnView(1, 8);		
	
	jxl.write.Label labelCFC4 = new jxl.write.Label(2, 7, "工令編號", wcfT); // (行,列)
    ws.addCell(labelCFC4);
	ws.setColumnView(2,15);	
	
	jxl.write.Label labelCFC6 = new jxl.write.Label(3, 7, "來料情況", wcfT); // (行,列)
    ws.addCell(labelCFC6);
	ws.setColumnView(3,9);
	
	//抬頭:(第6列第1行)
	jxl.write.Label labelCF7 = new jxl.write.Label(4, 7, "WAIVE單號", wcfT); // (行,列)
    ws.addCell(labelCF7);
	ws.setColumnView(4,9);
	//抬頭:(第6列第2行)
	jxl.write.Label labelCF8 = new jxl.write.Label(5, 7, "種類", wcfT); // (行,列)
    ws.addCell(labelCF8);
	ws.setColumnView(5,6);
	//抬頭:(第6列第3行)
	jxl.write.Label labelCF9 = new jxl.write.Label(6, 7, "晶片批號", wcfT); // (行,列)
    ws.addCell(labelCF9);
	ws.setColumnView(6,20);
	//抬頭:(第6列第4行)
	jxl.write.Label labelCFC10 = new jxl.write.Label(7, 7, "供應商", wcfT); // (行,列)
    ws.addCell(labelCFC10);
	ws.setColumnView(7,20);
	//抬頭:(第6列第5行)
	jxl.write.Label labelCFC11 = new jxl.write.Label(8, 7, "電阻系數", wcfT); // (行,列)
    ws.addCell(labelCFC11);
	ws.setColumnView(8,8);
	//抬頭:(第6列第6行)
	jxl.write.Label labelCF12 = new jxl.write.Label(9, 7, "切割尺寸", wcfT); // (行,列)
    ws.addCell(labelCF12);
	ws.setColumnView(9,8);
	
	jxl.write.Label labelC14 = new jxl.write.Label(10, 7, "下線片數", wcfT); // (行,列)
    ws.addCell(labelC14);
	ws.setColumnView(10,10);

	jxl.write.Label labelC15 = new jxl.write.Label(11, 7, "下線數量", wcfT); // (行,列)
    ws.addCell(labelC15);
	ws.setColumnView(11, 10);
	
	jxl.write.Label labelC16 = new jxl.write.Label(12, 7, "下線型號", wcfT); // (行,列)
    ws.addCell(labelC16);
	ws.setColumnView(12, 20);
	
    jxl.write.Label labelC17 = new jxl.write.Label(13, 7, "備註", wcfT); // (行,列)
    ws.addCell(labelC17);
	ws.setColumnView(13,20);
/*
    jxl.write.Label labelC18 = new jxl.write.Label(14, 7, "備註", wcfT); // (行,列)
    ws.addCell(labelC18);
	ws.setColumnView(14, 20);	
*/
    
	//out.clearBuffer();
	//out.println("333<BR>");
	out.println(sql);
	
	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 1;
		int rowNo = 8;
		
        //sql = sqlGlobal;
        //out.println(sql+"<BR>"); 
	    //out.println("S1");
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sql); 		
		//out.println("S2");
		while (rs.next())
		{	//out.println("S2");  		 
		  noSeq = noSeq + 1;
		  noSeqStr = Integer.toString(noSeq);
		  String rowNoStr = Integer.toString(rowNo);		  
		  
		  // 依工令使用晶片批去找出原使用IQC 檢驗批資訊
		   String sqlIQC = "  select IQCR.RESULT_NAME , TLD.INSPLOT_NO,TLD.INSPECT_QTY, "+
		                   "         TLH.WF_RESIST, TWS.WF_SIZE_NAME, TLD.PROD_YIELD,TLD.INV_ITEM_DESC, "+
						   "         TLD.SUPPLIER_LOT_NO, TLD.RESULT, TLD.LWAIVE_NO "+
		                   "  from  ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD,ORADDMAN.TSCIQC_LOTINSPECT_HEADER TLH, "+
						   "        ORADDMAN.TSCIQC_RESULT IQCR, ORADDMAN.TSCIQC_WAFER_SIZE TWS "+
						   "  where TLD.INSPLOT_NO = '"+rs.getString("WAFER_IQC_NO")+"' and TLD.LINE_NO="+rs.getString("WAFER_LINE_NO")+" " +
	  				       " 		and TLH.INSPLOT_NO=TLD.INSPLOT_NO and TLD.WAFER_SIZE=TWS.WF_SIZE_ID and ( IQCR.RESULT_ID=tld.RESULT or IQCR.RESULT_NAME=tld.RESULT ) ";
		  // 依工令使用晶片批去找出原使用IQC 檢驗批資訊
		   Statement stateIQC=con.createStatement();
           ResultSet rsIQC=stateIQC.executeQuery(sqlIQC);
		   if (rsIQC.next())
		   {	
		     iqcResult = rsIQC.getString("RESULT_NAME");  //來料情況   
			 waiveNo=rsIQC.getString("LWAIVE_NO");
			 waferLot=rsIQC.getString("SUPPLIER_LOT_NO");
			 waferElect=rsIQC.getString("WF_RESIST");
			 waferSize=rsIQC.getString("WF_SIZE_NAME");
		   } else {
		            iqcResult = "N/A"; 
		            waiveNo = "N/A";
					waferLot = "N/A";
					waferElect = "N/A";
					waferSize = "N/A";
		          }  
			// End of if (rsIQC.next())
		    rsIQC.close();
		    stateIQC.close();
		  //		  
		  //out.println("S3");
		  
		  jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.ARIAL,11,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		  wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  
		   
		  
		  //out.println("S4"); 

		  jxl.write.Label lable9 = new jxl.write.Label(0, rowNo, noSeqStr , wcfFL); // (行,列);由第七列開始顯示動態資料
          ws.addCell(lable9);	
	  
		  marketType=rs.getString("MARKET_TYPE");			  
		  jxl.write.Label lable121 = new jxl.write.Label(1, rowNo, marketType , wcfFL); 
          ws.addCell(lable121);			  
		  
		  woNo = rs.getString("WO_NO");  //工令編號
		  jxl.write.Label lable8 = new jxl.write.Label(2, rowNo, woNo , wcfFL); // (行,列);由第七列開始顯示動態資料
          ws.addCell(lable8);	
		  	  	  
		//  iqcResult = rsIQC.getString("RESULT_NAME");  //來料情況
		  jxl.write.Label lable10 = new jxl.write.Label(3, rowNo, iqcResult , wcfFL); // (行,列);由第七列開始顯示動態資料
          ws.addCell(lable10);
		  
		//  waiveNo=rsIQC.getString("LWAIVE_NO");    //
		  //out.println("customer="+customer); 
	      jxl.write.Label lable11 = new jxl.write.Label(4, rowNo, waiveNo , wcfFL); // (行,列);由第七列開始顯示動態資料
          ws.addCell(lable11);
		  
		  //noSeqStr = integer.toString(noSeq);		  //料號  
		  waferKind=rs.getString("WAFER_KIND");
		  //out.println("tscItemDesc="+tscItemDesc); 
	      jxl.write.Label lable21 = new jxl.write.Label(5, rowNo, waferKind , wcfFL); // (行,列); 
          ws.addCell(lable21);
	 
		//  waferLot=rsIQC.getString("SUPPLIER_LOT_NO");
		  jxl.write.Label lable31 = new jxl.write.Label(6, rowNo, waferLot , wcfFL); // (行,列); 
          ws.addCell(lable31);
		  
		  waferVendor=rs.getString("WAFER_VENDOR");					  
		  jxl.write.Label lable41 = new jxl.write.Label(7, rowNo, waferVendor , wcfFL); 
          ws.addCell(lable41);		
          		  
		//  waferElect=rsIQC.getString("WF_RESIST");
		  jxl.write.Label lable51 = new jxl.write.Label(8, rowNo, waferElect , wcfFL); 
          ws.addCell(lable51);		  
		 
		//  waferSize=rsIQC.getString("WF_SIZE_NAME");
		  jxl.write.Label lable61 = new jxl.write.Label(9, rowNo, waferSize, wcfFL); 
          ws.addCell(lable61);
		  
		  waferUsedPce=rs.getString("WAFER_USED_PCE");		  			  
		  jxl.write.Label lable71 = new jxl.write.Label(10, rowNo, waferUsedPce , wcfFL); 
          ws.addCell(lable71);	

		  woQty=rs.getString("WO_QTY");		  			  
		  jxl.write.Label lable81 = new jxl.write.Label(11, rowNo, woQty , wcfFL); 
          ws.addCell(lable81);	

		  itemDesc=rs.getString("ITEM_DESC");		  			  
		  jxl.write.Label lable91 = new jxl.write.Label(12, rowNo, itemDesc , wcfFL); 
          ws.addCell(lable91);	
	  
/*		  
		  waferYld=rs.getString("PROD_YIELD");	
		  if ( waferYld==null || waferYld.equals("null") || waferYld.equals(""))	
		    {waferYld=""; }  			  
		  jxl.write.Label lable101 = new jxl.write.Label(13, rowNo, waferYld , wcfFL); 
          ws.addCell(lable101);	
*/		  
		  woRemark=rs.getString("WO_REMARK");	
		  if ( woRemark==null || woRemark.equals(""))	
		    {woRemark=""; }  			  
		  jxl.write.Label lable111 = new jxl.write.Label(13, rowNo, woRemark , wcfFL); 
          ws.addCell(lable111);	
		  
		  rowNo = rowNo + 1;		   
		
	  }   // End of While rs.next()
		
	 rs.close();
	 statement.close();
/*
//表尾----起	 
	jxl.write.WritableFont wfA = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFA = new jxl.write.WritableCellFormat(wfA); 
	wcfFA.setAlignment(jxl.format.Alignment.LEFT);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFA = new jxl.write.Label(0, rowNo+2, "製造主管:", wcfFA);  // (行,列)
    ws.addCell(labelCFA);
	//ws.mergeCells(0, rowNo+2, 14, rowNo+2);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0,15);
	 
	jxl.write.WritableFont wfB = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFB = new jxl.write.WritableCellFormat(wfB); 
	wcfFB.setAlignment(jxl.format.Alignment.LEFT);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFB = new jxl.write.Label(6, rowNo+2, "部門主管:", wcfFB);  // (行,列)
    ws.addCell(labelCFB);
	//ws.mergeCells(0, rowNo+2, 14, rowNo+2);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
*/	 
	jxl.write.WritableFont wfC = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfC); 
	wcfFC.setAlignment(jxl.format.Alignment.LEFT);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFC = new jxl.write.Label(11, rowNo+2, "生管:", wcfFC);  // (行,列)
    ws.addCell(labelCFC);
	//ws.mergeCells(0, rowNo+2, 14, rowNo+2);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
	 
/*	 
	jxl.write.WritableFont wfD = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFD = new jxl.write.WritableCellFormat(wfD); 
	wcfFD.setAlignment(jxl.format.Alignment.CENTRE);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFD = new jxl.write.Label(0, rowNo+3, "*****The copyright of document and business secret belong to EVERWELL,and no copies should be made without any permission *****   (YWSB8157)", wcfFD);  // (行,列)
    ws.addCell(labelCFD);
	ws.mergeCells(0, rowNo+3, 14, rowNo+3);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
//表尾---迄

*/	 
	 
	
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
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
    
    response.reset();
    response.setContentType("application/vnd.ms-excel");					
    response.sendRedirect("/oradds/report/"+userID+"_"+ymdCurr+hmsCurr+"_WO.xls"); 
   
   
  /*
   response.reset();
   response.setContentType("application/vnd.ms-excel");	
   
   if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
   {	
    response.sendRedirect("/oradds/report/"+userID+"_"+ymdCurr+hmsCurr+"_WO.xls"); 
   } else {			
            response.sendRedirect("/oradds/report/"+userID+"_"+ymdCurr+hmsCurr+"_WO.xls");  
		  } 
   */
%>

</html>
