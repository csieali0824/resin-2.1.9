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
<FORM ACTION="../jsp/TSCMfgWoExceltype3.jsp" METHOD="post" name="MYFORM">
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
	
    String mfgDeptNo=request.getParameter("MFGDEPTNO");
	
	String invItem=request.getParameter("INVITEM");
	String waferLot=request.getParameter("WAFERLOT");		
	
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
	  
	String marketCode="",iqcResult="",tscAmp="",itemDesc="",woQty="",waferDesc="",waferQty="";
	String startDate="",endDate="",waferYld="",woRemark="",altRouting="",altBom="";  
	String oeOrderNo ="",customerName="",customerItem="",customerPo="",tscPackage="",tscPacking="",moRemark="";
    String pcName="",pcDirector="",schShipDate="",QcRptFlag="",QcRptCust="";
	int icol=0,irow=0;
	if (marketType=="--" || marketType.equals("--"))
	 {marketType="";}
	 
     if (sqlGlobal==null || sqlGlobal=="")
	 { 		
	     // out.print("step1");
	   /*
		   sql = " select YWA.WO_NO,YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_QTY,YWA.WO_UOM,YWA.OE_ORDER_NO,YWA.ORDER_LINE_ID, "+
       			 "	      YWA.CUSTOMER_NAME,OEL.OEL.CUST_PO_NUMBER,YWA.TSC_AMP,YWA.TSC_PACKAGE,YWA.TSC_FAMILY, "+
       			 "        TO_DATE(SUBSTR(YWA.SCHEDULE_STRART_DATE,1,8),'YYYY/MM/DD') START_DATE,  "+
	   			 "        TO_DATE(SUBSTR(YWA.SCHEDULE_END_DATE,1,8),'YYYY/MM/DD') END_DATE,  "+
				 "        decode(YWA.MARKET_TYPE,1,'內銷',2,'外銷','') as MARKET_TYPE,YWA.WO_REMARK ,YWA.ALTERNATE_ROUTING_DESIGNATOR ALT_ROUTING "+
				 "   from APPS.YEW_WORKORDER_ALL YWA,APPS.OE_ORDER_LINES_ALL OEL ";
		   sWhere =  " where YWA.ORDER_LINE_ID=OEL.LINE_ID(+) "+
	   		   		  "		 and YWA.WORKORDER_TYPE='"+woType+"' and YWA.MARKET_TYPE = nvl('"+marketType+"',YWA.MARKET_TYPE) "+
					  "       and substr(YWA.CREATION_DATE,0,8) >= '"+dateSetBegin+"' and substr(YWA.CREATION_DATE,0,8) <= '"+dateSetEnd+"' ";
	  
	      orderBy =  "  order by YWA.WO_NO ";	
		*/  
		  sql = " select DISTINCT YWA.WO_NO,YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_QTY,YWA.WO_UOM,YWA.OE_ORDER_NO,YWA.ORDER_LINE_ID, "+
       			 "	      YWA.CUSTOMER_NAME,YWA.CUSTOMER_PO as CUST_PO_NUMBER, YWA.TSC_AMP, YWA.TSC_PACKAGE,YWA.TSC_FAMILY, "+
       			 "        TO_DATE(SUBSTR(YWA.SCHEDULE_STRART_DATE,1,8),'YYYY/MM/DD') START_DATE,  "+
	   			 "        TO_DATE(SUBSTR(YWA.SCHEDULE_END_DATE,1,8),'YYYY/MM/DD') END_DATE , "+
				 "        decode(YWA.MARKET_TYPE,1,'內銷',2,'外銷','') as MARKET_TYPE,YWA.WO_REMARK , "+
				 "        decode(YWA.ALTERNATE_ROUTING_DESIGNATOR,'PUR1','外購','PUR','外購','')  ALT_ROUTING , "+
				 "        YWA.INVENTORY_ITEM_ID, YWA.ORDER_HEADER_ID as HEADER_ID, "+
				 "        YWA.ORG_OEHEADER_ID, YWA.ORG_OELINE_ID, YWA.OE_ORDER_NO as ORDER_NUMBER "+
				 "       ,OLA.LINE_NUMBER || CASE WHEN OLA.SHIPMENT_NUMBER IS NOT NULL THEN  '.'||OLA.SHIPMENT_NUMBER ELSE NULL END ERP_LINE_NO"+ //add by Peggy 20190729				 
				 "   from APPS.YEW_WORKORDER_ALL YWA, YEW_RUNCARD_ALL RC "+
			     " ,ONT.OE_ORDER_HEADERS_ALL OHA,ONT.OE_ORDER_LINES_ALL OLA ";//add by Peggy 20190729
		   sWhere =  " where YWA.WO_NO = RC.WO_NO(+) "+		             
	   		   		  "	 and YWA.WORKORDER_TYPE='"+woType+"' and YWA.STATUSID !='050'"+
					  "       and substr(YWA.CREATION_DATE,0,8) >= '"+dateSetBegin+"' and substr(YWA.CREATION_DATE,0,8) <= '"+dateSetEnd+"' "+		   
					 " AND YWA.order_line_id=OLA.LINE_ID(+)"+ //add by Peggy 20190729
					 " AND OLA.HEADER_ID=OHA.HEADER_ID(+)"; //add by Peggy 20190729
	       orderBy =  "  order by YWA.WO_NO ";	
		   
	   if (marketType==null || marketType.equals("") || marketType.equals("--"))  { sWhere=sWhere+" ";}
	   else { sWhere=sWhere+" and YWA.MARKET_TYPE = '"+marketType+"' "  ; }  	    
	   
	   if (woNo==null || woNo.equals(""))  { sWhere=sWhere+" "; }
       else { sWhere=sWhere+" and ( YWA.WO_NO ='"+woNo+"' or RC.RUNCARD_NO= '"+woNo+"'  or YWA.OE_ORDER_NO= '"+woNo+"' or YWA.WAFER_IQC_NO = '"+woNo+"' or YWA.CUSTOMER_PO like '%"+woNo+"%') "  ; }   
	   
	   if (invItem==null || invItem.equals(""))  {sWhere=sWhere+" ";}
       else {sWhere=sWhere+" and YWA.INV_ITEM ='"+invItem+"'"; }   
   
       if (waferLot==null || waferLot.equals(""))  {sWhere=sWhere+" ";}
       else {sWhere=sWhere+" and YWA.WAFER_LOT_NO ='"+waferLot+"'"; } 

	 
	   if (UserRoles.indexOf("admin")>=0) 
	   {  sWhere=sWhere+" ";  }
	   else if (UserRoles.indexOf("YEW_WIP_QUERY")>=0) 
       {
         sWhere=sWhere+" "; 	 	    
       }
       else 
		  {  sWhere=sWhere+" and YWA.DEPT_NO ='"+userMfgDeptNo+"'"; } 
		  
	   
	 } // End of if (sqlGlobal==null)  
	 else
      {
	     /*
		   sql = " select YWA.WO_NO,YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_QTY,YWA.WO_UOM,YWA.OE_ORDER_NO,YWA.ORDER_LINE_ID, "+
       			 "	      YWA.CUSTOMER_NAME,OEL.CUST_PO_NUMBER,YWA.TSC_AMP,YWA.TSC_PACKAGE,YWA.TSC_FAMILY, "+
       			 "        TO_DATE(SUBSTR(YWA.SCHEDULE_STRART_DATE,1,8),'YYYY/MM/DD') START_DATE,  "+
	   			 "        TO_DATE(SUBSTR(YWA.SCHEDULE_END_DATE,1,8),'YYYY/MM/DD') END_DATE , "+
				 "        decode(YWA.MARKET_TYPE,1,'內銷',2,'外銷','') as MARKET_TYPE,YWA.WO_REMARK ,YWA.ALTERNATE_ROUTING_DESIGNATOR ALT_ROUTING "+
				 "   from APPS.YEW_WORKORDER_ALL YWA,APPS.OE_ORDER_LINES_ALL OEL ";
		   sWhere =  " where YWA.ORDER_LINE_ID=OEL.LINE_ID(+) "+
	   		   		  "		 and YWA.WORKORDER_TYPE='"+woType+"' and YWA.MARKET_TYPE = nvl('"+marketType+"',YWA.MARKET_TYPE) "+
					  "       and substr(YWA.CREATION_DATE,0,8) >= '"+dateSetBegin+"' and substr(YWA.CREATION_DATE,0,8) <= '"+dateSetEnd+"' ";
		   
	       orderBy =  "  order by YWA.WO_NO ";	  
		  */ 
		   sql = " select DISTINCT YWA.WO_NO,YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_QTY,YWA.WO_UOM,YWA.OE_ORDER_NO,YWA.ORDER_LINE_ID, "+
       			 "	      YWA.CUSTOMER_NAME,YWA.CUSTOMER_PO as CUST_PO_NUMBER, YWA.TSC_AMP, YWA.TSC_PACKAGE,YWA.TSC_FAMILY, "+
       			 "        TO_DATE(SUBSTR(YWA.SCHEDULE_STRART_DATE,1,8),'YYYY/MM/DD') START_DATE,  "+
	   			 "        TO_DATE(SUBSTR(YWA.SCHEDULE_END_DATE,1,8),'YYYY/MM/DD') END_DATE , "+
				 "        decode(YWA.MARKET_TYPE,1,'內銷',2,'外銷','') as MARKET_TYPE,YWA.WO_REMARK , "+ 
				 "        decode(YWA.ALTERNATE_ROUTING_DESIGNATOR,'PUR','外購','PUR1','外購',YWA.ALTERNATE_ROUTING_DESIGNATOR ) ALT_ROUTING, "+
				 "        YWA.INVENTORY_ITEM_ID, YWA.ORDER_HEADER_ID as HEADER_ID, "+
				 "        YWA.ORG_OEHEADER_ID, YWA.ORG_OELINE_ID, YWA.OE_ORDER_NO as ORDER_NUMBER "+
				 "       ,OLA.LINE_NUMBER || CASE WHEN OLA.SHIPMENT_NUMBER IS NOT NULL THEN  '.'||OLA.SHIPMENT_NUMBER ELSE NULL END ERP_LINE_NO"+ //add by Peggy 20190729				 
				 "   from APPS.YEW_WORKORDER_ALL YWA, YEW_RUNCARD_ALL RC "+
			     " ,ONT.OE_ORDER_HEADERS_ALL OHA,ONT.OE_ORDER_LINES_ALL OLA ";//add by Peggy 20190729
		   sWhere =  " where YWA.WO_NO = RC.WO_NO(+) "+		             
	   		   		  "	 and YWA.WORKORDER_TYPE='"+woType+"' and YWA.STATUSID !='050'"+
					  "       and substr(YWA.CREATION_DATE,0,8) >= '"+dateSetBegin+"' and substr(YWA.CREATION_DATE,0,8) <= '"+dateSetEnd+"' "+
					 " AND YWA.order_line_id=OLA.LINE_ID(+)"+ //add by Peggy 20190729
					 " AND OLA.HEADER_ID=OHA.HEADER_ID(+)"; //add by Peggy 20190729
					  
	       orderBy =  "  order by YWA.WO_NO ";	 


        if (marketType==null || marketType.equals("") || marketType.equals("--"))  { sWhere=sWhere+" ";}
	    else { sWhere=sWhere+" and YWA.MARKET_TYPE = '"+marketType+"' "  ; } 		
		
		if (woNo==null || woNo.equals(""))  {sWhere=sWhere+" ";}
        else { sWhere=sWhere+" and ( YWA.WO_NO ='"+woNo+"' or RC.RUNCARD_NO= '"+woNo+"'  or YWA.OE_ORDER_NO= '"+woNo+"' or YWA.WAFER_IQC_NO = '"+woNo+"' or YWA.CUSTOMER_PO like '%"+woNo+"%') "  ; }   
		
		if (invItem==null || invItem.equals(""))  {sWhere=sWhere+" ";}
        else {sWhere=sWhere+" and YWA.INV_ITEM ='"+invItem+"'"; }   
   
        if (waferLot==null || waferLot.equals(""))  {sWhere=sWhere+" ";}
        else {sWhere=sWhere+" and YWA.WAFER_LOT_NO ='"+waferLot+"'"; } 
		 	    
	 
	   if (UserRoles.indexOf("admin")>=0) 
	   {  sWhere=sWhere+" "; }
	   else if (UserRoles.indexOf("YEW_WIP_QUERY")>=0) 
       {
         sWhere=sWhere+" "; 	 	    
       }
       else 
		  {  sWhere=sWhere+" and YWA.DEPT_NO ='"+userMfgDeptNo+"'"; } 
		  
 //  	 if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and substr(YWA.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
 //      if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and substr(YWA.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(YWA.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'";  
     	  
          }       
	
 
  // 取內外銷_起
  		 //out.print("<br>markettype="+marketType);
	     String sqlm1 = " select code_desc MARKETCODE from yew_mfg_defdata where def_type='MARKETTYPE' and code='"+marketType+"' ";
		//out.print("sqlm1"+sqlm1);		 
		 Statement statem1=con.createStatement();
	     ResultSet rsm1=statem1.executeQuery(sqlm1);
		 if (rsm1.next())
			 { 	marketCode   = rsm1.getString("MARKETCODE");   }
		 rsm1.close();
	     statem1.close();  
		 
		  //out.print("<br>markettype="+marketType+"   "+marketCode);		 
	 
   // 取內外銷_迄
 /*  
   // 取指派人員_起
     Statement stateAssign=con.createStatement();
     String sqlAssign = "select b.USERID from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a,ORADDMAN.TSSPLANER_PERSON b where a.UPDATEUSERID = b.USERNAME and DNDOCNO= '"+dnDocNo+"' and ORISTATUSID='002' ";
     ResultSet rsAssign=stateAssign.executeQuery(sqlAssign);
	 if (rsAssign.next())
	 {
	    assignUserName = rsAssign.getString(1);
	 }
	 rsAssign.close();
	 stateAssign.close();
	 
   // 取指派人員_迄
  */
// 2003/12/11 加入新條件 迄	 
/*
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
   
*/
	  sql=sql+sWhere+orderBy;
	
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
	sst.setVerticalFreeze(11);
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
	
	jxl.write.WritableFont wf3 = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF3 = new jxl.write.WritableCellFormat(wf3); 
	wcfF3.setAlignment(jxl.format.Alignment.CENTRE);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
   // jxl.write.Label labelCF2 = new jxl.write.Label(0, 1, "TEL:(0543)8691091 FAX:(0543)8691089 Web Site: http://www.ts.com.tw E-mail:name@mail.tsyew.com.cn", wcfF2);  // (行,列)
    jxl.write.Label labelCF3 = new jxl.write.Label(0, 2, "MANUFACTURE ORDER (ASSEMBLY)", wcfF3);  // (行,列)
    ws.addCell(labelCF3);
	ws.mergeCells(0, 2, 14, 2);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
	
	//file://抬頭:(第1列第1行)
	jxl.write.WritableFont wf4 = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF4 = new jxl.write.WritableCellFormat(wf4); 
	wcfF4.setAlignment(jxl.format.Alignment.CENTRE);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    String title="後 段 製 造 工 令 (EXPORT)";
    if (woType=="5" || woType.equals("5")) title="樣 品 製 造 工 令";
    jxl.write.Label labelCFF4 = new jxl.write.Label(0, 3, title, wcfF4);  // (行,列)
    ws.addCell(labelCFF4);
	ws.mergeCells(0, 3, 14, 3);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
                                     
	jxl.write.Label labelCustPO = new jxl.write.Label(0, 6, "版本Edition:", wcfT); // 客戶訂購單號資料(行,列)
    ws.addCell(labelCustPO);
	ws.setColumnView(1, 10);	
	
	jxl.write.Label labelCFC1 = new jxl.write.Label(0, 8, "設立日期Assign Date:"+dateSetBegin+"~"+dateSetEnd, wcfT); // 指派人員(行,列)
    ws.addCell(labelCFC1);
	ws.setColumnView(1,3);

	//抬頭:(第6列第0行)		// 明細抬頭說明
	icol=0;
	ws.setColumnView(icol,3);
	jxl.write.Label labelCF0 = new jxl.write.Label(icol, 10, "項次 ITEM", wcfT); // (行,列)
    ws.addCell(labelCF0);
	
	icol++;
	ws.setColumnView(icol,8);		
    jxl.write.Label labelC1 = new jxl.write.Label(icol, 10, "內/外銷別 Export/Domestic", wcfT); // (行,列)
    ws.addCell(labelC1);
	
	icol++;
	ws.setColumnView(icol,15);	
	jxl.write.Label labelCFC2 = new jxl.write.Label(icol, 10, "工令編號 Oder No", wcfT); // (行,列)
    ws.addCell(labelCFC2);
	
	icol++;
	ws.setColumnView(icol,12);
	jxl.write.Label labelCFC3 = new jxl.write.Label(icol, 10, "銷售訂單號 M/O NO", wcfT); // (行,列)
    ws.addCell(labelCFC3);

	icol++;
	//抬頭:(第6列第3行)
	jxl.write.Label labelCF4 = new jxl.write.Label(icol, 10, "品名 P/N", wcfT); // (行,列)
    ws.addCell(labelCF4);
	
	icol++;
	ws.setColumnView(icol,18);
	jxl.write.Label labelCF5 = new jxl.write.Label(icol, 10, "客戶名稱 Customer", wcfT); // (行,列)
    ws.addCell(labelCF5);
	
	icol++;
	ws.setColumnView(icol,20);
	jxl.write.Label labelC6 = new jxl.write.Label(icol, 10, "客戶品號 Customer PO Number", wcfT); // (行,列)
    ws.addCell(labelC6);
	
	icol++;
	ws.setColumnView(icol, 15);
	jxl.write.Label labelCFC7 = new jxl.write.Label(icol, 10, "Package", wcfT); // (行,列)
    ws.addCell(labelCFC7);

	icol++;
	ws.setColumnView(icol, 15);
	jxl.write.Label labelCFC71 = new jxl.write.Label(icol, 10, "TSC Family", wcfT); //add by Peggy 20221201
    ws.addCell(labelCFC71);
	
	icol++;
	//抬頭:(第6列第5行)
	jxl.write.Label labelCFC8 = new jxl.write.Label(icol, 10, "Packing", wcfT); // (行,列)
    ws.addCell(labelCFC8);
	
	//抬頭:(第6列第6行)
	icol++;
	ws.setColumnView(icol,8);
	jxl.write.Label labelCF9 = new jxl.write.Label(icol, 10, "訂單量 Deliver Q'ty", wcfT); // (行,列)
    ws.addCell(labelCF9);
	
	icol++;
	ws.setColumnView(icol,8);
	jxl.write.Label labelC10 = new jxl.write.Label(icol, 10, "預計生產日 Produce Date", wcfT); // (行,列)
    ws.addCell(labelC10);

	icol++;
	ws.setColumnView(icol,8);
	jxl.write.Label labelC11 = new jxl.write.Label(icol, 10, "預計入庫日 Due Date", wcfT); // (行,列)
    ws.addCell(labelC11);

	icol++;
	ws.setColumnView(icol,12);
	jxl.write.Label labelC12 = new jxl.write.Label(icol, 10, "預計出貨日", wcfT); // (行,列)
    ws.addCell(labelC12);

	icol++;
	ws.setColumnView(icol, 12);
	jxl.write.Label labelC13 = new jxl.write.Label(icol, 10, "MAKE_TYPE", wcfT); // (行,列)
    ws.addCell(labelC13);
	
	icol++;
	ws.setColumnView(icol, 30);
    jxl.write.Label labelC14 = new jxl.write.Label(icol, 10, "備註", wcfT); // (行,列)
    ws.addCell(labelC14);
	
	icol++;
	ws.setColumnView(icol, 5);	
    jxl.write.Label labelC15 = new jxl.write.Label(icol, 10, "隨貨附檢驗報告", wcfT); // (行,列)
    ws.addCell(labelC15);

	icol++;
	ws.setColumnView(icol, 10);	
    jxl.write.Label labelC16 = new jxl.write.Label(icol, 10, "ERP NO", wcfT); // (行,列)
    ws.addCell(labelC16);

	icol++;
	ws.setColumnView(icol, 5);	
    jxl.write.Label labelC17 = new jxl.write.Label(icol, 10, "ERP MO Line", wcfT); // (行,列)
    ws.addCell(labelC17);
   
	
	    int noSeq = 0;
		String noSeqStr = "";
		int colNo = 1;
		int rowNo = 11;
		
        //sql = sqlGlobal;

        out.println("sql="+sql+"<BR>"); 

		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sql); 		

		while (rs.next())
		{	//out.println("S2");  		 
		  noSeq = noSeq + 1;
		  noSeqStr = Integer.toString(noSeq);
		  String rowNoStr = Integer.toString(rowNo);		  
		  String yewHeaderID = rs.getString("HEADER_ID");
		  String orderLineId = rs.getString("ORDER_LINE_ID");
	      String itemId = rs.getString("INVENTORY_ITEM_ID");
	  
		  
		              String orgMOHeaderID = rs.getString("ORG_OEHEADER_ID");
					  String orgMOLineID = rs.getString("ORG_OELINE_ID");
					  int idxHeader = 0;
					  int idxLine = 0;
					  String shipToOrgID = "0";		 
		  		 
		  	  
		 
		  if ( orderLineId !="0" && !orderLineId.equals("0") )
		  {
            String orderExImJdge = rs.getString("OE_ORDER_NO").substring(0,4); // 依原訂單號判斷是否需要取台北MO單資訊	
           
			if (orderExImJdge=="1156" || orderExImJdge.equals("1156"))
		    {	 // 以Drop Ship 給山東工廠1156的MO客戶資訊(外銷)  
			    try
				{	
			         String sqlCSItem = " select DECODE(ITEM_IDENTIFIER_TYPE,'INT',NULL,ORDERED_ITEM) as CUSTOMER_ITEM "+
					                       " ,to_char(SCHEDULE_SHIP_DATE,'yyyy-mm-dd') SCHEDULE_SHIP_DATE "+	  //20121016 liling add			 
			                               "  from OE_ORDER_LINES_ALL "+
								           " where LINE_ID = "+orderLineId+" ";
			         //out.print("sqlm3"+sqlm3);
			         Statement stateCSItem=con.createStatement();
		             ResultSet rsCSItem=stateCSItem.executeQuery(sqlCSItem);
		             if (rsCSItem.next())
				     { 	
					   customerItem = rsCSItem.getString("CUSTOMER_ITEM");  
					   schShipDate = rsCSItem.getString("SCHEDULE_SHIP_DATE");  
					 } else {  customerItem = "";  // 表示原MO單未輸入客戶品號
					           schShipDate =""; } 
			         rsCSItem.close();
		             stateCSItem.close();	
					 
					     Statement stateOrgHdr=con.createStatement();
		                 ResultSet rsOrgHdr=stateOrgHdr.executeQuery("select HEADER_ID, SOLD_TO_ORG_ID from OE_ORDER_HEADERS_ALL where ORDER_NUMBER = "+rs.getString("ORDER_NUMBER")+" ");
						 if (rsOrgHdr.next()) 
						 { 
						   orgMOHeaderID = rsOrgHdr.getString("HEADER_ID");
						   shipToOrgID = rsOrgHdr.getString("SOLD_TO_ORG_ID"); // 取外銷出貨地
						 }
						 rsOrgHdr.close();
						 stateOrgHdr.close();	
						 
				   //  out.println("1156="+" select CUSTOMER_NAME_PHONETIC from RA_CUSTOMERS "+
					//                                           "  where CUSTOMER_ID = "+shipToOrgID+"  ");		 	   
			   	
			         Statement stateEndCS=con.createStatement();
		         //    ResultSet rsEndCS=stateEndCS.executeQuery(" select CUSTOMER_NAME_PHONETIC from RA_CUSTOMERS "+
		             ResultSet rsEndCS=stateEndCS.executeQuery(" select CUSTOMER_NAME_PHONETIC from AR_CUSTOMERS "+					 
					                                           "  where CUSTOMER_ID = "+shipToOrgID+"  ");
		             if (rsEndCS.next())
				     { 	
					   customerName = rsEndCS.getString("CUSTOMER_NAME_PHONETIC");  
					 }
			         rsEndCS.close();
		             stateEndCS.close();  

                    //取MO_REMARK  liling 2007/04/09
			         Statement statemoRemark=con.createStatement();
		             ResultSet rsmoRemark=statemoRemark.executeQuery(" SELECT FDLT.LONG_TEXT  MO_REMARK FROM FND_ATTACHED_DOCS_FORM_VL FADFV, FND_DOCUMENTS_LONG_TEXT FDLT "+
           															 "  WHERE FADFV.FUNCTION_NAME = 'OEXOEORD' AND UPPER(FADFV.CATEGORY_DESCRIPTION) = 'REMARKS' "+	         
             														 "    AND FADFV.MEDIA_ID = FDLT.MEDIA_ID   AND fadfv.USER_ENTITY_NAME = 'OM Order Header' "+
             														 "    AND FADFV.PK1_VALUE =  "+orgMOHeaderID+"  ");
		             if (rsmoRemark.next())
				     { 	
					   moRemark = rsmoRemark.getString("MO_REMARK");  
					 }
                     else moRemark="";

			         rsmoRemark.close();
		             statemoRemark.close();  


				 }   // End of try
                 catch (SQLException e) 
                 { 
	                 out.println("Exception 取山東客戶品號資訊:"+e.getMessage()); 
                     //e.printStackTrace(); 
                 } 
		     
		    } else if ((orderExImJdge=="4131" ||  orderExImJdge.equals("4131")) || (orderExImJdge=="4141" ||  orderExImJdge.equals("4141"))) 
			{ // 大陸內銷銷售訂單_起
			         try
					 {	   
						// out.println("idxHeader="+idxHeader);
						// out.println("orgMOHeaderID="+orgMOHeaderID);						 
						// out.println("idxLine="+idxLine);
						// out.println("orgMOLineID="+orgMOLineID+"<BR>");	
					  
						 Statement stateOrgHdr=con.createStatement();
		                 ResultSet rsOrgHdr=stateOrgHdr.executeQuery("select HEADER_ID, SHIP_TO_ORG_ID from OE_ORDER_HEADERS_ALL where ORDER_NUMBER = "+rs.getString("ORDER_NUMBER")+" and ORG_ID = 325 ");
						 if (rsOrgHdr.next()) 
						 { 
						   orgMOHeaderID = rsOrgHdr.getString("HEADER_ID");
						   shipToOrgID = rsOrgHdr.getString("SHIP_TO_ORG_ID"); // 取內銷出貨地
						 }
						 rsOrgHdr.close();
						 stateOrgHdr.close();				 
						 
						 Statement stateOrgLine=con.createStatement();
		                 ResultSet rsOrgLine=stateOrgLine.executeQuery("select LINE_ID from OE_ORDER_LINES_ALL where HEADER_ID = "+orgMOHeaderID+" and INVENTORY_ITEM_ID = "+itemId+" and LINE_ID="+orderLineId+" ");  //2007/10/30 liling ADD  and LINE_ID="+orderLineId+ 
						 if (rsOrgLine.next()) orgMOLineID = rsOrgLine.getString("LINE_ID");
						 rsOrgLine.close();
						 stateOrgLine.close();				 
		  
		                 String sqlOrgCSItem = " select DECODE(ITEM_IDENTIFIER_TYPE,'INT',NULL,ORDERED_ITEM) as CUSTOMER_ITEM "+
					                           "        ,to_char(SCHEDULE_SHIP_DATE,'yyyy-mm-dd') SCHEDULE_SHIP_DATE "+	  //20121016 liling add								 
			                                   "  from OE_ORDER_LINES_ALL "+
								               " where LINE_ID = "+orgMOLineID+" ";
			             //out.print("sqlm3"+sqlm3);
			             Statement stateOrgCSItem=con.createStatement();
		                 ResultSet rsOrgCSItem=stateOrgCSItem.executeQuery(sqlOrgCSItem);
		                 if (rsOrgCSItem.next())
				         { 	
					       customerItem = rsOrgCSItem.getString("CUSTOMER_ITEM");  
					       schShipDate = rsOrgCSItem.getString("SCHEDULE_SHIP_DATE");  						   
					     } else { customerItem = "";  
						          schShipDate = ""; } // 表示原MO單未輸入客戶品號
			             rsOrgCSItem.close();
		                 stateOrgCSItem.close(); 
						 
						// out.println("4131="+"select CUSTOMER_NAME from RA_CUSTOMERS "+
					    //                                                 "  where PARTY_ID in ( select b.PARTY_ID from RA_SITE_USES_ALL a, RA_ADDRESSES_ALL b where a.ADDRESS_ID = b.ADDRESS_ID and a.SITE_USE_ID = "+shipToOrgID+" ) "); 
					 

						//20111222 for r12 
		               //  ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select CUSTOMER_NAME from AR_CUSTOMERS "+
					   //                                                  "  where PARTY_ID in ( select b.PARTY_ID from RA_SITE_USES_ALL a, RA_ADDRESSES_ALL b where a.ADDRESS_ID = b.ADDRESS_ID and a.SITE_USE_ID = "+shipToOrgID+" ) ");
					     Statement stateOrgEndCS=con.createStatement();
		                 ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select CUSTOMER_NAME from AR_CUSTOMERS "+
					                                                     "  where customer_id in( SELECT hcas.CUST_ACCOUNT_ID FROM HZ_CUST_ACCT_SITES hcas,HZ_CUST_SITE_USES hcsu WHERE hcas.cust_acct_site_id=hcsu.cust_acct_site_id and hcsu.site_use_id= "+shipToOrgID+" ) ");
						 //customerName =shipFromOrgID;												 
		                 if (rsOrgEndCS.next())
				         { 	
						    customerName = rsOrgEndCS.getString("CUSTOMER_NAME");	
							//out.print("<br>customerName="+customerName);					    
						 }
			             rsOrgEndCS.close();
		                 stateOrgEndCS.close(); 
					//		out.print("<br>2.customerName="+customerName);						 
					//	 out.print("<br>select CUSTOMER_NAME from AR_CUSTOMERS "+
					//                                                     "  where customer_id in( SELECT hcas.CUST_ACCOUNT_ID FROM HZ_CUST_ACCT_SITES hcas,HZ_CUST_SITE_USES hcsu WHERE hcas.cust_acct_site_id=hcsu.cust_acct_site_id and hcsu.site_use_id= "+shipToOrgID+")");

                    //取MO_REMARK  liling 2007/04/09
			         Statement statemoRemark=con.createStatement();
		             ResultSet rsmoRemark=statemoRemark.executeQuery(" SELECT FDLT.LONG_TEXT  MO_REMARK FROM FND_ATTACHED_DOCS_FORM_VL FADFV, FND_DOCUMENTS_LONG_TEXT FDLT "+
           															 "  WHERE FADFV.FUNCTION_NAME = 'OEXOEORD' AND UPPER(FADFV.CATEGORY_DESCRIPTION) = 'REMARKS' "+	         
             														 "    AND FADFV.MEDIA_ID = FDLT.MEDIA_ID   AND fadfv.USER_ENTITY_NAME = 'OM Order Header' "+
             														 "    AND FADFV.PK1_VALUE =  "+yewHeaderID+"  ");
		             if (rsmoRemark.next())
				     { 	
					   moRemark = rsmoRemark.getString("MO_REMARK");  
					 }else moRemark="";
			         rsmoRemark.close();
		             statemoRemark.close();  

 	
					  }   // End of try
                      catch (SQLException e) 
                      { 
	                   out.println("Exception 取內銷客戶品號資訊:"+e.getMessage()); 
                       //e.printStackTrace(); 
                      } 		   
			 // 大陸內銷銷售訂單_迄
		//	}else if (orderExImJdge=="1213" ||  orderExImJdge.equals("1213")) 
			}else if (orderExImJdge=="1213" ||  orderExImJdge.equals("1213") || orderExImJdge=="1214" ||  orderExImJdge.equals("1214")) 		
			  { // 1213訂單_起
			         try
					 {	   
					     Statement stateOrgHdr=con.createStatement();
		                 ResultSet rsOrgHdr=stateOrgHdr.executeQuery("select HEADER_ID from OE_ORDER_HEADERS_ALL where ORDER_NUMBER = "+rs.getString("ORDER_NUMBER")+" and ORG_ID = 41 ");
						 if (rsOrgHdr.next()) orgMOHeaderID = rsOrgHdr.getString("HEADER_ID");
						 rsOrgHdr.close();
						 stateOrgHdr.close();				 
						 
						 Statement stateOrgLine=con.createStatement();
		                 ResultSet rsOrgLine=stateOrgLine.executeQuery("select LINE_ID from OE_ORDER_LINES_ALL where HEADER_ID = "+orgMOHeaderID+" and INVENTORY_ITEM_ID = "+itemId+" ");
						 if (rsOrgLine.next()) orgMOLineID = rsOrgLine.getString("LINE_ID");
						 rsOrgLine.close();
						 stateOrgLine.close();
						 
						// out.println("idxHeader="+idxHeader);
						// out.println("orgMOHeaderID="+orgMOHeaderID);						 
						// out.println("idxLine="+idxLine);
						// out.println("orgMOLineID="+orgMOLineID+"<BR>");						 
					 
		  
		               String sqlOrgCSItem = " select DECODE(ITEM_IDENTIFIER_TYPE,'INT',NULL,ORDERED_ITEM) as CUSTOMER_ITEM "+
					                           "        ,to_char(SCHEDULE_SHIP_DATE,'yyyy-mm-dd') SCHEDULE_SHIP_DATE "+	  //20121016 liling add						   
			                                 "  from OE_ORDER_LINES_ALL "+
								             " where LINE_ID = "+orgMOLineID+" ";
			           //out.print("sqlm3"+sqlm3);
			           Statement stateOrgCSItem=con.createStatement();
		               ResultSet rsOrgCSItem=stateOrgCSItem.executeQuery(sqlOrgCSItem);
		               if (rsOrgCSItem.next())
				       { 	
					    customerItem = rsOrgCSItem.getString("CUSTOMER_ITEM");  
					    schShipDate = rsOrgCSItem.getString("SCHEDULE_SHIP_DATE");  						
					   } else { customerItem = "";
					             schShipDate = "";
					           } // 表示原MO單未輸入客戶品號
			           rsOrgCSItem.close();
		               stateOrgCSItem.close();  
					   
					  // out.println("1141="+" select CUSTOMER_NAME_PHONETIC from RA_CUSTOMERS "+
					   //                                                "  where CUSTOMER_ID = ( select SOLD_TO_ORG_ID from OE_ORDER_HEADERS_ALL where HEADER_ID = "+orgMOHeaderID+" ) ");
					 
					   Statement stateOrgEndCS=con.createStatement();
		               ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select FADFV.DOCUMENT_DESCRIPTION as CUSTOMER_NAME_PHONETIC  from FND_ATTACHED_DOCS_FORM_VL FADFV "+
					                                                   "  where FADFV.FUNCTION_NAME = 'OEXOEORD'  and UPPER(FADFV.CATEGORY_DESCRIPTION) = 'SHIPPING MARKS' and FADFV.PK1_VALUE = "+orgMOHeaderID+" ");
		               if (rsOrgEndCS.next())
				       { 	customerName = rsOrgEndCS.getString("CUSTOMER_NAME_PHONETIC");   }
			           rsOrgEndCS.close();
		               stateOrgEndCS.close(); 
					String moRmkSql=" SELECT FDLT.LONG_TEXT  MO_REMARK FROM FND_ATTACHED_DOCS_FORM_VL FADFV, FND_DOCUMENTS_LONG_TEXT FDLT "+
           															 "  WHERE FADFV.FUNCTION_NAME = 'OEXOEORD' AND UPPER(FADFV.CATEGORY_DESCRIPTION) = 'REMARKS' "+	         
             														 "    AND FADFV.MEDIA_ID = FDLT.MEDIA_ID   AND fadfv.USER_ENTITY_NAME = 'OM Order Header' "+
             														 "    AND FADFV.PK1_VALUE =  "+orgMOHeaderID+"  ";
                    // out.print("<br>"+moRmkSql);
                    //取MO_REMARK  liling 2007/04/09
			         Statement statemoRemark=con.createStatement();
		             ResultSet rsmoRemark=statemoRemark.executeQuery(" SELECT FDLT.LONG_TEXT  MO_REMARK FROM FND_ATTACHED_DOCS_FORM_VL FADFV, FND_DOCUMENTS_LONG_TEXT FDLT "+
           															 "  WHERE FADFV.FUNCTION_NAME = 'OEXOEORD' AND UPPER(FADFV.CATEGORY_DESCRIPTION) = 'REMARKS' "+	         
             														 "    AND FADFV.MEDIA_ID = FDLT.MEDIA_ID   AND fadfv.USER_ENTITY_NAME = 'OM Order Header' "+
             														 "    AND FADFV.PK1_VALUE =  "+orgMOHeaderID+"  ");
		             if (rsmoRemark.next())
				     { 	
					   moRemark = rsmoRemark.getString("MO_REMARK");  
					 }else moRemark="";
			         rsmoRemark.close();
		             statemoRemark.close();  

					  }   // End of try
                      catch (SQLException e) 
                      { 
	                   out.println("Exception 取1213客戶品號資訊:"+e.getMessage()); 
                       //e.printStackTrace(); 
                      } 		   
			 // 1213銷售訂單_迄
			} else { // 1141、1131 需取台北MO 的客戶及客戶品號資訊	
			         try
					 {	               
					 
					  /*   
					  
			           out.print("select ORIG_SYS_DOCUMENT_REF, ORIG_SYS_LINE_REF from OE_ORDER_LINES_ALL where LINE_ID = "+orderLineId+" "+"<BR>");
			           Statement stateOrgMO=con.createStatement();
		               ResultSet rsOrgMO=stateOrgMO.executeQuery("select ORIG_SYS_DOCUMENT_REF, ORIG_SYS_LINE_REF from OE_ORDER_LINES_ALL where LINE_ID = "+orderLineId+" ");
		               if (rsOrgMO.next()) 
					   {		              
					     idxHeader = rsOrgMO.getString("ORIG_SYS_DOCUMENT_REF").indexOf("-"); // 從第1個位置找原訂單Header ID
						 orgMOHeaderID = rsOrgMO.getString("ORIG_SYS_DOCUMENT_REF").substring( idxHeader+1,rsOrgMO.getString("ORIG_SYS_DOCUMENT_REF").length() ); 
					     idxLine = rsOrgMO.getString("ORIG_SYS_LINE_REF").indexOf("-",12); // 從第13個位置之後找原訂單 Line ID "-"
						 orgMOLineID = rsOrgMO.getString("ORIG_SYS_LINE_REF").substring( idxLine+1,rsOrgMO.getString("ORIG_SYS_LINE_REF").length() );
						 
						 out.println("ORIG_SYS_DOCUMENT_REF="+rsOrgMO.getString("ORIG_SYS_DOCUMENT_REF"));
						 out.println("ORIG_SYS_LINE_REF="+rsOrgMO.getString("ORIG_SYS_LINE_REF")+"<BR>");
					   }	 
					   rsOrgMO.close();
					   stateOrgMO.close();
					  */	 
						 
					  
						 Statement stateOrgHdr=con.createStatement();
		                 ResultSet rsOrgHdr=stateOrgHdr.executeQuery("select HEADER_ID from OE_ORDER_HEADERS_ALL where ORDER_NUMBER = "+rs.getString("ORDER_NUMBER")+" and ORG_ID = 41 ");
						 if (rsOrgHdr.next()) orgMOHeaderID = rsOrgHdr.getString("HEADER_ID");
						 rsOrgHdr.close();
						 stateOrgHdr.close();				 
						 
						 Statement stateOrgLine=con.createStatement();
		                 ResultSet rsOrgLine=stateOrgLine.executeQuery("select LINE_ID from OE_ORDER_LINES_ALL where HEADER_ID = "+orgMOHeaderID+" and INVENTORY_ITEM_ID = "+itemId+" ");
						 if (rsOrgLine.next()) orgMOLineID = rsOrgLine.getString("LINE_ID");
						 rsOrgLine.close();
						 stateOrgLine.close();
						 
						// out.println("idxHeader="+idxHeader);
						// out.println("orgMOHeaderID="+orgMOHeaderID);						 
						// out.println("idxLine="+idxLine);
						// out.println("orgMOLineID="+orgMOLineID+"<BR>");						 
					 
		  
		               String sqlOrgCSItem = " select DECODE(ITEM_IDENTIFIER_TYPE,'INT',NULL,ORDERED_ITEM) as CUSTOMER_ITEM "+
					                       //    "        ,to_char(SCHEDULE_SHIP_DATE,'yyyy-mm-dd') SCHEDULE_SHIP_DATE "+	  //20121016 liling add						   					   
			                                 "  from OE_ORDER_LINES_ALL "+
								             " where LINE_ID = "+orgMOLineID+"  ";
			          // out.print("<br>sqlOrgCSItem="+sqlOrgCSItem);
			           Statement stateOrgCSItem=con.createStatement();
		               ResultSet rsOrgCSItem=stateOrgCSItem.executeQuery(sqlOrgCSItem);
		               if (rsOrgCSItem.next())
				       { 	
					    customerItem = rsOrgCSItem.getString("CUSTOMER_ITEM");  
					   // schShipDate = rsOrgCSItem.getString("SCHEDULE_SHIP_DATE");  
					   } else { customerItem = "";  } // 表示原MO單未輸入客戶品號
			           rsOrgCSItem.close();
		               stateOrgCSItem.close();  
					     
					   //1131 1141 ssd要抓原來yew的訂單    20140428
		               String sqlOrgCSssd = "  SELECT to_char(SCHEDULE_SHIP_DATE,'yyyy/mm/dd') SCHEDULE_SHIP_DATE FROM OE_ORDER_LINES_ALL WHERE LINE_ID= '"+orderLineId+"' ";
			           Statement stateOrgCSssd=con.createStatement();
		               ResultSet rsOrgCSssd=stateOrgCSssd.executeQuery(sqlOrgCSssd);
		               if (rsOrgCSssd.next())
				       { 	
					  //  customerItem = rsOrgCSssd.getString("CUSTOMER_ITEM");  
					     schShipDate = rsOrgCSssd.getString("SCHEDULE_SHIP_DATE");  
					   } else {  
					            schShipDate = "";  } // 表示原MO單未輸入ssd
			           rsOrgCSssd.close();
		               stateOrgCSssd.close(); 					   
					   
					  // out.println("1141="+" select CUSTOMER_NAME_PHONETIC from RA_CUSTOMERS "+
					   //                                                "  where CUSTOMER_ID = ( select SOLD_TO_ORG_ID from OE_ORDER_HEADERS_ALL where HEADER_ID = "+orgMOHeaderID+" ) ");
					 
					   Statement stateOrgEndCS=con.createStatement();
		               ResultSet rsOrgEndCS=stateOrgEndCS.executeQuery(" select CUSTOMER_NAME_PHONETIC from AR_CUSTOMERS "+
					                                                   "  where CUSTOMER_ID = ( select SOLD_TO_ORG_ID from OE_ORDER_HEADERS_ALL where HEADER_ID = "+orgMOHeaderID+" ) ");
		               if (rsOrgEndCS.next())
				       { 	customerName = rsOrgEndCS.getString("CUSTOMER_NAME_PHONETIC");   }
			           rsOrgEndCS.close();
		               stateOrgEndCS.close(); 

                    //取MO_REMARK  liling 2007/04/09
			         Statement statemoRemark=con.createStatement();
		             ResultSet rsmoRemark=statemoRemark.executeQuery(" SELECT FDLT.LONG_TEXT  MO_REMARK FROM FND_ATTACHED_DOCS_FORM_VL FADFV, FND_DOCUMENTS_LONG_TEXT FDLT "+
           															 "  WHERE FADFV.FUNCTION_NAME = 'OEXOEORD' AND UPPER(FADFV.CATEGORY_DESCRIPTION) = 'REMARKS' "+	         
             														 "    AND FADFV.MEDIA_ID = FDLT.MEDIA_ID   AND fadfv.USER_ENTITY_NAME = 'OM Order Header' "+
             														 "    AND FADFV.PK1_VALUE =  "+orgMOHeaderID+"  ");
		             if (rsmoRemark.next())
				     { 	
					   moRemark = rsmoRemark.getString("MO_REMARK");  
					 }else moRemark="";
			         rsmoRemark.close();
		             statemoRemark.close();  

					}   // End of try
                    catch (SQLException e) 
                    { 
	                   out.println("Exception 取台北客戶品號資訊:"+e.getMessage()); 
                       //e.printStackTrace(); 
                    } 	
		              
		     } // End of else // 1141、1131、1213
			 
		  } 
		  else 
		   { 
		     customerItem="";
 			 moRemark="";
		   }  

//20140105 增加出貨檢驗報告顯示flag
		  //   String sqlQcRpt = "  select FADFV.DOCUMENT_DESCRIPTION FLAG from FND_ATTACHED_DOCS_FORM_VL FADFV ,YEW_MFG_DEFDATA A  where FADFV.FUNCTION_NAME = 'OEXOEORD'  "+
		     String sqlQcRpt = "  select FADFV.DOCUMENT_DESCRIPTION FLAG from TSC_SHIPPING_REMARK_V FADFV ,YEW_MFG_DEFDATA A  where FADFV.FUNCTION_NAME = 'OEXOEORD'  "+			 
                               "     and UPPER(FADFV.CATEGORY_DESCRIPTION) = 'SHIPPING MARKS'  and FADFV.PK1_VALUE  =  '"+orgMOHeaderID+"'  "+
                               "     and trim(FADFV.DOCUMENT_DESCRIPTION)=trim(a.CODE_DESC2)  and a.def_type='QCRPT_CUST' ";
			 Statement stateQcRpt=con.createStatement();
		     ResultSet rsQcRpt=stateQcRpt.executeQuery(sqlQcRpt);
		     if (rsQcRpt.next())
				{ 	 
				   QcRptFlag = "Y"; 
				   QcRptCust=rsQcRpt.getString("FLAG"); 
                    //20151103 liling TSCJ代理商裡只有Shipping mark是KTL(H.K), 然後END USER是Panasonic(PED)才需隨貨附出貨檢驗報告(end user可從PO號碼看出)  				      			   
				    if  ( QcRptCust.equals("KTL(H.K)"))
					 {
					      QcRptFlag = "  " ; 
		                  String sqlOrgCSPO = "  SELECT 'Y' FROM OE_ORDER_LINES_ALL WHERE LINE_ID= '"+orgMOLineID+"' and CUSTOMER_LINE_NUMBER like '%PED%' ";
			              Statement stateOrgCSPO=con.createStatement();
		                  ResultSet rsOrgCSPO=stateOrgCSPO.executeQuery(sqlOrgCSPO);
		                   if (rsOrgCSPO.next())
				            { 	
				               QcRptFlag = rsOrgCSPO.getString(1)  ; 
				               if (rsOrgCSPO.getString(1) =="" || rsOrgCSPO.getString(1).equals("")) QcRptFlag = " " ;		   
				             } 
				            else
				             { QcRptFlag = " " ;  }
			               rsOrgCSPO.close();
		                   stateOrgCSPO.close();  
			           }
                      //20151103							  
				  } else {  QcRptFlag = " " ;  } // 空白不顯示
			 rsQcRpt.close();
		     stateQcRpt.close();
//20140105


		  
		  jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.ARIAL,11,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
          jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		  //wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		  wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);    

		  icol=0;
		  jxl.write.Label lable9 = new jxl.write.Label(icol, rowNo, noSeqStr , wcfFL); // (行,列);由第七列開始顯示動態資料
          ws.addCell(lable9);	

		  icol++;
		  marketType=rs.getString("MARKET_TYPE");			  
		  jxl.write.Label lable121 = new jxl.write.Label(icol, rowNo, marketType , wcfFL); 
          ws.addCell(lable121);			  
		  
		  icol++;
		  woNo = rs.getString("WO_NO");  //工令編號
		  jxl.write.Label lable8 = new jxl.write.Label(icol, rowNo, woNo , wcfFL); // (行,列);由第七列開始顯示動態資料
          ws.addCell(lable8);	
			  	  	  
		  icol++;
		  oeOrderNo = rs.getString("OE_ORDER_NO");  //訂單號
		  jxl.write.Label lable10 = new jxl.write.Label(icol, rowNo, oeOrderNo , wcfFL); // (行,列);由第七列開始顯示動態資料
          ws.addCell(lable10);
		  
		  icol++;
		  itemDesc=rs.getString("ITEM_DESC");
		  jxl.write.Label lable31 = new jxl.write.Label(icol, rowNo, itemDesc , wcfFL); // (行,列); 
          ws.addCell(lable31);

		  icol++;
	      jxl.write.Label lable11 = new jxl.write.Label(icol, rowNo, customerName , wcfFL); // (行,列);由第七列開始顯示動態資料
          ws.addCell(lable11);
		  
		  icol++;
		  jxl.write.Label lable35 = new jxl.write.Label(icol, rowNo, customerItem , wcfFL); 
          ws.addCell(lable35);	
		  
		  icol++;
		  tscPackage=rs.getString("TSC_PACKAGE");					  
		  jxl.write.Label lable41 = new jxl.write.Label(icol, rowNo, tscPackage , wcfFL); 
          ws.addCell(lable41);		

		  icol++;
		  jxl.write.Label lable411 = new jxl.write.Label(icol, rowNo, (rs.getString("TSC_FAMILY")==null?"":rs.getString("TSC_FAMILY")), wcfFL); 
          ws.addCell(lable411);		

		  icol++;
		  tscPacking=rs.getString("INV_ITEM");  //取料號中的包裝別
		  jxl.write.Label lable51 = new jxl.write.Label(icol, rowNo, tscPacking.substring(8,10) , wcfFL); 
          ws.addCell(lable51);		  
	 
		  icol++;
		  woQty=rs.getString("WO_QTY");
		  jxl.write.Label lable61 = new jxl.write.Label(icol, rowNo, woQty, wcfFL); 
          ws.addCell(lable61);
	  
		  icol++;
		  startDate=rs.getString("START_DATE");		  			  
		  jxl.write.Label lable71 = new jxl.write.Label(icol, rowNo,  startDate.substring(0,10)  , wcfFL); 
          ws.addCell(lable71);	

		  icol++;
		  endDate=rs.getString("END_DATE");		  			  
		  jxl.write.Label lable81 = new jxl.write.Label(icol, rowNo, endDate.substring(0,10) , wcfFL); 
          ws.addCell(lable81);	
		  	  	
		  icol++;
		  if (schShipDate==null || schShipDate.equals("null") ) schShipDate="";	  			  
		  jxl.write.Label lable93 = new jxl.write.Label(icol, rowNo, schShipDate , wcfFL); 
          ws.addCell(lable93);	

		  icol++;
		  altRouting=rs.getString("ALT_ROUTING");	 			  
		  jxl.write.Label lable95 = new jxl.write.Label(icol, rowNo, altRouting , wcfFL); 
          ws.addCell(lable95);	

		  icol++;
		  woRemark=rs.getString("WO_REMARK");	
		  if ( woRemark==null || woRemark.equals(""))	
		    {woRemark=""; }  			  
		  jxl.write.Label lable111 = new jxl.write.Label(icol, rowNo, woRemark , wcfFL); 
          ws.addCell(lable111);	
		  
		  icol++;
		  jxl.write.Label lable112 = new jxl.write.Label(icol, rowNo, QcRptFlag, wcfFL); 
		//  jxl.write.Label lable112 = new jxl.write.Label(15, rowNo, QcRptCust+orgMOLineID , wcfFL); 		  
          ws.addCell(lable112);			  

		  icol++;
		  jxl.write.Label lable113 = new jxl.write.Label(icol, rowNo,(rs.getString("order_number")==null?"":rs.getString("order_number")), wcfFL); 
          ws.addCell(lable113);			  

		  icol++;
		  jxl.write.Label lable114 = new jxl.write.Label(icol, rowNo,(rs.getString("ERP_LINE_NO")==null?"":rs.getString("ERP_LINE_NO")), wcfFL); 
          ws.addCell(lable114);			  

		  rowNo = rowNo + 1;
	
		
	  }   // End of While rs.next()		
	 rs.close();
	 statement.close();
	 
//抓取PC姓名及預設部門主管姓名


 	      String sqlNamea="  SELECT YMD.CODE_DESC PCDIRECTOR,YMDA.CODE_DESC PCNAME FROM YEW_MFG_DEFDATA YMD,YEW_MFG_DEFDATA YMDA,YEW_MFG_USER YMU  "+
 						   "  WHERE YMD.CODE = YMU.MFG_DEPT_NO  AND YMD.DEF_TYPE='MFG_DIRECTOR' AND YMDA.CODE = YMU.MFG_DEPT_NO AND YMDA.DEF_TYPE='MFG_PC' "+
 							"   AND YMU.PRIMARY_FLAG = 'Y' AND YMU.USER_ID = "+userMfgUserID+" ";

       //   out.print("<br>sqlNamea="+sqlNamea);
  
		  Statement stateNamea=con.createStatement();
	      ResultSet rsNamea=stateNamea.executeQuery(sqlNamea);
		  if (rsNamea.next())
			 { 	pcDirector   = rsNamea.getString("PCDIRECTOR");  
                pcName   = rsNamea.getString("PCNAME");  } 
		  rsNamea.close();
	      stateNamea.close();  

       out.print("<br>pcDirector"+pcDirector+"  "+pcName);
         

//抓取PC姓名及預設部門主管姓名


	 
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

/*
	jxl.write.WritableFont wfB1 = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFB1 = new jxl.write.WritableCellFormat(wfB1); 
	wcfFB1.setAlignment(jxl.format.Alignment.LEFT);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFB1 = new jxl.write.Label(7, rowNo+2, pcDirector, wcfFB1);  // (行,列)
    ws.addCell(labelCFB1);
	//ws.mergeCells(0, rowNo+2, 14, rowNo+2);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
*/
	 
	jxl.write.WritableFont wfC = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfC); 
	wcfFC.setAlignment(jxl.format.Alignment.LEFT);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFC = new jxl.write.Label(11, rowNo+2, "生管:"+pcName, wcfFC);  // (行,列)
    ws.addCell(labelCFC);
	//ws.mergeCells(0, rowNo+2, 14, rowNo+2);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);


	 

	jxl.write.WritableFont wfD = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFD = new jxl.write.WritableCellFormat(wfD); 
	wcfFD.setAlignment(jxl.format.Alignment.CENTRE);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFD = new jxl.write.Label(0, rowNo+3, "*****The copyright of document and business secret belong to EVERWELL,and no copies should be made without any permission *****   (YQ4PC15-C)", wcfFD);  // (行,列)
    ws.addCell(labelCFD);
	ws.mergeCells(0, rowNo+3, 14, rowNo+3);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
	 
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
	 out.println("Exception a:"+e.getMessage()); 
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
