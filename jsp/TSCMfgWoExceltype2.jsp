<!--20180907 Peggy,新增"系統計算wafer片數"欄位-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*,java.lang.*,java.util.*,java.text.*" %>
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
String serverHostName=request.getServerName();
String sqlGlobal = request.getParameter("SQLGLOBAL");
String RepCenterNo=request.getParameter("REPCENTERNO");   // 改抓Session內的登入資料
String dateStringBegin=request.getParameter("DATEBEGIN");
String dateStringEnd=request.getParameter("DATEEND");  
String SWHERE=request.getParameter("SWHERECOND");
String ymdCurr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
String hmsCurr = dateBean.getHourMinuteSecond();
String strHMSec = request.getParameter("HOURTIME");
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
  
try 
{ 	
	String sql = "";
	String sWhere = "";
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
	if (marketType=="--" || marketType.equals("--")) {marketType="";}
	String woStatus = "",waiveNo="",diceLotNo="",woTypeCode="",tscPackage="",tscFamily="";
    String pcName="",pcDirector="";
	 
	//sql = " select DISTINCT YWA.WO_NO, YWA.INV_ITEM, YWA.ITEM_DESC, YWA.WO_QTY, YWA.WO_UOM, YWA.TSC_AMP, "+
	//	  " YWA.WAFER_IQC_NO, YWA.WAFER_LINE_NO,YWA.WAFER_USED_PCE, "+
	//	  "	decode(YWA.MARKET_TYPE,1,'內銷',2,'外銷',MARKET_TYPE), "+
	//	  " TO_DATE(SUBSTR(YWA.SCHEDULE_STRART_DATE,1,8),'YYYY/MM/DD') START_DATE, "+
	//	  " TO_DATE(SUBSTR(YWA.SCHEDULE_END_DATE,1,8),'YYYY/MM/DD') END_DATE, YWA.WO_REMARK, "+
	//	  " YWA.STATUS,YWA.TSC_PACKAGE,YWA.TSC_FAMILY "+
	//	  " from APPS.YEW_WORKORDER_ALL YWA"+
	//	  ", APPS.YEW_RUNCARD_ALL WDJ "+
	//	  " where YWA.WO_NO=WDJ.WO_NO(+) "+
	//	  " and YWA.WORKORDER_TYPE='"+woType+"'"+
	//	  " and YWA.STATUSID !='050' ";
	sql = " SELECT DISTINCT YWA.WO_NO"+
	      ",YWA.INV_ITEM"+
		  ",YWA.ITEM_DESC"+
		  ",YWA.WO_QTY"+
		  ",YWA.WO_UOM"+
		  ",YWA.TSC_AMP"+
          ",YWA.WAFER_IQC_NO"+
		  ",YWA.WAFER_LINE_NO"+
		  ",YWA.WAFER_USED_PCE"+
          ",decode(YWA.MARKET_TYPE,1,'內銷',2,'外銷',MARKET_TYPE) MARKET_TYPE"+
          ",TO_CHAR(TO_DATE(SUBSTR(YWA.SCHEDULE_STRART_DATE,1,8),'YYYY/MM/DD'),'YYYY/MM/DD') START_DATE"+
          ",TO_CHAR(TO_DATE(SUBSTR(YWA.SCHEDULE_END_DATE,1,8),'YYYY/MM/DD'),'YYYY/MM/DD') END_DATE"+
		  ",YWA.WO_REMARK"+
          ",YWA.STATUS"+
		  ",YWA.TSC_PACKAGE"+
		  ",YWA.TSC_FAMILY "+
          ",YME.CODE_DESC"+
          ",YMA.PRIMARY_NO"+
          ",IQC.RESULT_NAME "+
          ",IQC.INSPLOT_NO"+
          ",IQC.INSPECT_QTY"+
          ",IQC.WAFER_DESC"+
          ",IQC.WF_RESIST"+
          ",IQC.WF_SIZE_NAME"+
          ",IQC.PROD_YIELD"+
          ",IQC.INV_ITEM_DESC"+
          ",IQC.SUPPLIER_LOT_NO"+
          ",IQC.RESULT"+
          ",IQC.LWAIVE_NO "+
          ",IQC.LINE_NO"+
          ",IQC.GRAINQTY"+
		  ",ROUND(IQC.INSPECT_QTY/NVL(CASE WHEN IQC.GRAINQTY=0 THEN 1 ELSE IQC.GRAINQTY END ,1),3) WAFER_QTY"+
          ",ROUND(WO_QTY/ROUND(IQC.INSPECT_QTY/NVL(CASE WHEN IQC.GRAINQTY=0 THEN 1 ELSE IQC.GRAINQTY END ,1),3)* YWA.WO_UNIT_QTY) AS WAFER_PCE"+
		  ",YMK.MARKETCODE"+
		  ",YWA.WO_UNIT_QTY"+
          " from APPS.YEW_WORKORDER_ALL YWA"+
          ",APPS.YEW_RUNCARD_ALL WDJ "+
		  ",(SELECT CODE,CODE_DESC MARKETCODE FROM YEW_MFG_DEFDATA WHERE DEF_TYPE='MARKETTYPE') YMK"+ 
          ",(SELECT CODE,CODE_DESC FROM YEW_MFG_DEFDATA WHERE DEF_TYPE='WO_TYPE') YME "+
          ",(SELECT EXTEND_NO,PRIMARY_NO FROM YEW_MFG_TRAVELS_ALL  WHERE EXTEND_TYPE='2') YMA"+
          ",(SELECT IQCR.RESULT_NAME , TLD.INSPLOT_NO,TLD.INSPECT_QTY, TLD.INV_ITEM_DESC as WAFER_DESC, "+
          "                           TLH.WF_RESIST, TWS.WF_SIZE_NAME, TLD.PROD_YIELD, TLD.INV_ITEM_DESC, "+
          "                           TLD.SUPPLIER_LOT_NO, TLD.RESULT, TLD.LWAIVE_NO ,TLD.LINE_NO,TLD.GRAINQTY"+
          //"                    FROM  ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD"+
		  "                     FROM (SELECT X.INSPLOT_NO,X.PROD_YIELD,X.INV_ITEM_DESC,X.SUPPLIER_LOT_NO, X.WAFER_SIZE,X.RESULT, X.LWAIVE_NO ,X.LINE_NO,Y.GRAINQTY,Y.INSPECT_QTY INSPECT_QTY"+
          "                           FROM ORADDMAN.TSCIQC_LOTINSPECT_DETAIL X,(SELECT  INSPLOT_NO,SUPPLIER_LOT_NO,SUM(GRAINQTY) GRAINQTY,SUM(INSPECT_QTY) INSPECT_QTY FROM ORADDMAN.TSCIQC_LOTINSPECT_DETAIL GROUP BY  INSPLOT_NO,SUPPLIER_LOT_NO) Y "+
          "                           WHERE  X.INSPLOT_NO=Y.INSPLOT_NO"+
          "                           AND X.SUPPLIER_LOT_NO=Y.SUPPLIER_LOT_NO) TLD"+
          "                         ,ORADDMAN.TSCIQC_LOTINSPECT_HEADER TLH"+
          "                         ,ORADDMAN.TSCIQC_RESULT IQCR"+
          "                         ,ORADDMAN.TSCIQC_WAFER_SIZE TWS"+ 
          "                    where TLH.INSPLOT_NO=TLD.INSPLOT_NO "+
          "                    and TLD.WAFER_SIZE=TWS.WF_SIZE_ID "+
          "                         AND tld.RESULT IN ( IQCR.RESULT_NAME,IQCR.RESULT_ID)) IQC "+
          " WHERE YWA.WO_NO=WDJ.WO_NO(+) "+
          " AND YWA.WORKORDER_TYPE='"+woType+"'"+
          " AND YWA.STATUSID !='050'"+
		  " AND YWA.MARKET_TYPE=YMK.CODE(+)"+
          " AND YWA.WORKORDER_TYPE=YME.CODE(+)"+
          " AND YWA.WO_NO=YMA.EXTEND_NO(+)"+
          " AND YWA.WAFER_IQC_NO=IQC.INSPLOT_NO(+)"+
          " AND YWA.WAFER_LINE_NO=IQC.LINE_NO(+)";
	if (marketType!=null && !marketType.equals("") && !marketType.equals("--"))
	{ 
		sql+=" and YWA.MARKET_TYPE = '"+marketType+"' "  ; 
	}

	if (woNo!=null && !woNo.equals(""))
	{
		sql+=" and YWA.WO_NO ='"+woNo+"' "  ; 
	}   
	
	if (UserRoles.indexOf("admin") <0 && UserRoles.indexOf("YEW_WIP_QUERY")<0)
	{
		sql += " and YWA.DEPT_NO ='"+userMfgDeptNo+"'";
	}
	
	if (sqlGlobal==null || sqlGlobal=="")
	{ 	
		if ((!(DayFr=="--") &&(DayFr=="00")) && DayTo=="--") 
		{
			sql += " and substr(YWA.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
		}
		
		if (DayFr!="--" && DayTo!="--")
		{
			sql += " and substr(YWA.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(YWA.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'";
		}  
	}
	else
	{				
		sql += " and substr(YWA.CREATION_DATE,0,8) >= '"+dateSetBegin+"' and substr(YWA.CREATION_DATE,0,8) <= '"+dateSetEnd+"' ";	
	}
	sql += "  order by YWA.WO_NO ";	  

	//合併SQL提高執行效率,modify by Peggy 20180906
	//String sqlm1 = " select code_desc MARKETCODE from yew_mfg_defdata where def_type='MARKETTYPE' and code='"+marketType+"' ";
	//Statement statem1=con.createStatement();
 	//ResultSet rsm1=statem1.executeQuery(sqlm1);
	//if (rsm1.next())
	//{ 	
	//	marketCode   = rsm1.getString("MARKETCODE");   
	//}
	//rsm1.close();
	//statem1.close();  
	//out.println(sql);	 
	// 產生報表
	OutputStream os = null;	
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
    	os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+userID+"_"+ymdCurr+hmsCurr+"_WO.xls");
	}  
	else 
	{ // For Windows Platform
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+userID+"_"+ymdCurr+hmsCurr+"_WO.xls");
	}	
    
	jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	//file://建立Excel工作表的 sheet名稱
    jxl.write.WritableSheet ws = wwb.createSheet("workorder", 0); //-- TEST
	jxl.SheetSettings sst = ws.getSettings(); 
	
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

	jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
	wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    wcfT.setAlignment(jxl.format.Alignment.LEFT);

	jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
	jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
	//wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
	wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);	
	
	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 10,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);
	
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), 10, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);	
		
	sst.setSelected();
	sst.setVerticalFreeze(11);
	sst.setFitToPages(true);	
	sst.setFitWidth(1);  // 設定一頁寬
			
	//file://抬頭:(第0列第1行)
    jxl.write.WritableFont wf1 = new jxl.write.WritableFont(WritableFont.TIMES, 14,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF1 = new jxl.write.WritableCellFormat(wf1); 
	wcfF1.setAlignment(jxl.format.Alignment.CENTRE);
    jxl.write.Label labelCF1 = new jxl.write.Label(0, 0, "YANGXIN EVERWELL ELECTRONIC CO.,  LTD.", wcfF1);  // (行,列)
    ws.addCell(labelCF1);
	ws.mergeCells(0, 0, 14, 0);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 11);
	
	jxl.write.WritableFont wf2 = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF2 = new jxl.write.WritableCellFormat(wf2); 
	wcfF2.setAlignment(jxl.format.Alignment.CENTRE);

    jxl.write.Label labelCF2 = new jxl.write.Label(0, 1, "Heliu Town Yangxin City Shandong Province CHINA P.R.C Postcode:251807", wcfF2);  // (行,列)
    ws.addCell(labelCF2);
	ws.mergeCells(0, 1, 14, 1);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
	
	jxl.write.WritableFont wf3 = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF3 = new jxl.write.WritableCellFormat(wf3); 
	wcfF3.setAlignment(jxl.format.Alignment.CENTRE);

    jxl.write.Label labelCF3 = new jxl.write.Label(0, 2, "MANUFACTURE ORDER (ASSEMBLY)", wcfF3);  // (行,列)
    ws.addCell(labelCF3);
	ws.mergeCells(0, 2, 14, 2);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
			
	//file://抬頭:(第1列第1行)
	jxl.write.WritableFont wf4 = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF4 = new jxl.write.WritableCellFormat(wf4); 
	wcfF4.setAlignment(jxl.format.Alignment.CENTRE);
    String text1="";

    if (woType=="2" || woType.equals("2"))
	{ 
		text1="前 段 製 造 工 令 (EXPORT)" ; 
	}
    else if (woType=="7" || woType.equals("7"))  //20100831 liling add
    { 
		text1="工 程 實 驗 工 令 " ; 
	}
    else 
	{ 
		text1="重 工 製 造 工 令 (REWORK)" ; 
	}

    jxl.write.Label labelCF4 = new jxl.write.Label(0, 3, text1 , wcfF4);   // (行,列)
    ws.addCell(labelCF4);
	ws.mergeCells(0, 3, 14, 3);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
                                     
    //2005.5.26 Gray end
    //抬頭:(第0列第2行)

	jxl.write.Label labelCFC0 = new jxl.write.Label(0, 4, "版本Edition:", wcfT); // 指派人員(行,列)
    ws.addCell(labelCFC0);
	ws.setColumnView(1,3);

	jxl.write.Label labelCFC1 = new jxl.write.Label(0, 6, "設立日期Assign Date:"+dateSetBegin+"~"+dateSetEnd, wcfT); // 指派人員(行,列)
    ws.addCell(labelCFC1);
	ws.setColumnView(1,3);


	jxl.write.Label labelCFC2 = new jxl.write.Label(0, 8, "站別:1010/1020/1030/1040/1043/1047/1050/2010/2020/2050/2051/2057/2060/3010/3020/3050/3051/3053/3055/3057/IPQC/倉管/統計/製造課長/MANAGER ", wcfT); // 指派人員(行,列)
    ws.addCell(labelCFC2);
	ws.setColumnView(1,3);

	int noSeq = 0;
	int col = 0;
	int rowNo = 10;
	
	//抬頭:(第6列第0行)		// 明細抬頭說明
	//jxl.write.Label labelCF5 = new jxl.write.Label(col, 10, "項次 ITEM", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "項次 ITEM", wcfT));
	ws.setColumnView(col,3);
	col++;
	
    //jxl.write.Label labelC19 = new jxl.write.Label(1, 10, "內/外銷別 Export/Domestic", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "內/外銷別 Export/Domestic", wcfT));
	ws.setColumnView(col, 8);		
	col++;
	
	//jxl.write.Label labelCFC4 = new jxl.write.Label(2, 10, "工令編號 M/O No", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "工令編號 M/O No", wcfT));
	ws.setColumnView(col,15);	
	col++;
	
	//jxl.write.Label labelCFC6 = new jxl.write.Label(3, 10, "來料情況  IQC Inspection Results", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "來料情況  IQC Inspection Results", wcfT));
	ws.setColumnView(col,8);
	col++;
	
	//抬頭:(第6列第1行)
	//jxl.write.Label labelCF7 = new jxl.write.Label(4, 10, "安培數 Ampere Size", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "安培數 Ampere Size", wcfT));
	ws.setColumnView(col,6);
	col++;
	
	//抬頭:(第6列第2行)
	//jxl.write.Label labelCF8 = new jxl.write.Label(5, 10, "料號 Serial Numbers", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "料號 Serial Numbers", wcfT));
	ws.setColumnView(col,22);
	col++;
	
	//抬頭:(第6列第3行)
	//jxl.write.Label labelCF9 = new jxl.write.Label(6, 10, "產品型號 Type", wcfT); // (行,列)
    ws.addCell( new jxl.write.Label(col, rowNo, "產品型號 Type", wcfT));
	ws.setColumnView(col,25);
	col++;

    //jxl.write.Label labelC21 = new jxl.write.Label(7, 10, "TSC_PACKAGE", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "TSC_PACKAGE", wcfT));
	ws.setColumnView(col,12);
	col++;

    //jxl.write.Label labelC22 = new jxl.write.Label(8, 10, "TSC_FAMILY", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "TSC_FAMILY", wcfT));
	ws.setColumnView(col,12);
	col++;

	//抬頭:(第6列第4行)
	//jxl.write.Label labelCFC10 = new jxl.write.Label(9, 10, "預定生產數量  Lot Size(Chip)", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "預定生產數量  Lot Size(Chip)", wcfT));
	ws.setColumnView(col,8);
	col++;

	//抬頭:(第6列第5行)
	//jxl.write.Label labelCFC11 = new jxl.write.Label(10, 10, "晶粒尺寸Chip Size", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "晶粒尺寸Chip Size", wcfT));
	ws.setColumnView(col,10);
	col++;

	//抬頭:(第6列第6行)
	//jxl.write.Label labelCF12 = new jxl.write.Label(11, 10, "晶粒批號 Chip Lot No", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "晶粒批號 Chip Lot No", wcfT));
	ws.setColumnView(col,12);
	col++;
	
	//jxl.write.Label labelC14 = new jxl.write.Label(12, 10, "使用晶片數量 Lot Size (Wafer)", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "使用晶片數量 Lot Size (Wafer)", wcfT));
	ws.setColumnView(col,10);
	col++;

	//jxl.write.Label labelC141 = new jxl.write.Label(13, 10, "使用晶片數量(系統計算片數)", wcfT); // (行,列)  //add by Peggy 20180905
    ws.addCell(new jxl.write.Label(col, rowNo, "使用晶片數量(系統計算片數)", wcfT));
	ws.setColumnView(col,10);
	col++;

	//jxl.write.Label labelC15 = new jxl.write.Label(14, 10, "預計投入日 Expect Put In Date", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "預計投入日 Expect Put In Date", wcfT));
	ws.setColumnView(col, 12);
	col++;
	
	//jxl.write.Label labelC16 = new jxl.write.Label(15, 10, "預計完成日期 Expect Finished Date", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "預計完成日期 Expect Finished Date", wcfT));
	ws.setColumnView(col, 12);
	col++;
	
    //jxl.write.Label labelC17 = new jxl.write.Label(16, 10, "IQC(試作)型號 型號良率 Try Run Type and Yield", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "IQC(試作)型號 型號良率 Try Run Type and Yield", wcfT));
	ws.setColumnView(col,5);
	col++;

    //jxl.write.Label labelC18 = new jxl.write.Label(17, 10, "備註 Remark", wcfT); // (行,列)
    ws.addCell(new jxl.write.Label(col, rowNo, "備註 Remark", wcfT));
	ws.setColumnView(col, 20);
	col++;

    if (woType=="2" || woType.equals("2"))
    {
    	//jxl.write.Label labelC20 = new jxl.write.Label(18, 10, "檢驗批號 DicingLot", wcfT); // (行,列)
      	ws.addCell( new jxl.write.Label(col, rowNo, "檢驗批號 DicingLot", wcfT));
	  	ws.setColumnView(col, 20);
		col++;	
		
		//jxl.write.Label labelC181 = new jxl.write.Label(19, 10, "Wafer數量(KPC/片)", wcfT); // (行,列)
		ws.addCell(new jxl.write.Label(col, rowNo, "Wafer數量(KPC/片)", wcfT));
		ws.setColumnView(col, 15);
		col++;
			
		ws.addCell( new jxl.write.Label(col, rowNo, "工單晶片基本用量", wcfT));
		ws.setColumnView(col, 15);		
		col++;
		
    }
    else
    {
    	//jxl.write.Label labelC20 = new jxl.write.Label(18, 10, "工令類型 WO Type", wcfT); // (行,列)
      	ws.addCell(new jxl.write.Label(col, rowNo, "工令類型 WO Type", wcfT));
	  	ws.setColumnView(col, 20);	
		col++;
    }
	rowNo++;

	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql); 		
	while (rs.next())
	{
		//合併SQL提高執行效率,modify by Peggy 20180906
  		//// 取由切割來源批號_起
	    //String sqlm2 = " select PRIMARY_NO from yew_mfg_travels_all where extend_type='2' and EXTEND_NO ='"+rs.getString("WO_NO")+"' ";
		////out.print("sqlm1"+sqlm1);		 
		//Statement statem2=con.createStatement();
	    //ResultSet rsm2=statem2.executeQuery(sqlm2);
		//if (rsm2.next())
		//{ 	
		//	diceLotNo   = rsm2.getString("PRIMARY_NO");   
		//} 
		//else
		//{
		//	diceLotNo="";
		//}
		//rsm2.close();
	    //statem2.close();  
		
		noSeq ++;
		//noSeqStr = Integer.toString(noSeq);
		String rowNoStr = Integer.toString(rowNo);
		col=0;
		
		//合併SQL提高執行效率,modify by Peggy 20180906
		//// 依工令使用晶片批去找出原使用IQC 檢驗批資訊
        //if (woType=="2" || woType.equals("2"))
        //{   
		//	String sqlIQC = "  select IQCR.RESULT_NAME , TLD.INSPLOT_NO,TLD.INSPECT_QTY, TLD.INV_ITEM_DESC as WAFER_DESC, "+
		//                   "         TLH.WF_RESIST, TWS.WF_SIZE_NAME, TLD.PROD_YIELD, TLD.INV_ITEM_DESC, "+
		//				    "         TLD.SUPPLIER_LOT_NO, TLD.RESULT, TLD.LWAIVE_NO "+
		//                    "  from  ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD,ORADDMAN.TSCIQC_LOTINSPECT_HEADER TLH, "+
		//				    "        ORADDMAN.TSCIQC_RESULT IQCR, ORADDMAN.TSCIQC_WAFER_SIZE TWS "+
		//				    "  where TLD.INSPLOT_NO = '"+rs.getString("WAFER_IQC_NO")+"' and TLD.LINE_NO="+rs.getString("WAFER_LINE_NO")+" " +
	  	//			        " 		and TLH.INSPLOT_NO=TLD.INSPLOT_NO and TLD.WAFER_SIZE=TWS.WF_SIZE_ID and ( IQCR.RESULT_ID=tld.RESULT or IQCR.RESULT_NAME=tld.RESULT ) ";
		// 	// 依工令使用晶片批去找出原使用IQC 檢驗批資訊
		//   	Statement stateIQC=con.createStatement();
        //  	ResultSet rsIQC=stateIQC.executeQuery(sqlIQC);
		//   	if (rsIQC.next())
		//   	{	
		//    	iqcResult = rsIQC.getString("RESULT_NAME");  //來料情況   
		//	 	waiveNo=rsIQC.getString("LWAIVE_NO");
		//	 	waferLot=rsIQC.getString("SUPPLIER_LOT_NO");
		//	 	waferDesc=rsIQC.getString("WAFER_DESC");
		//	 	waferQty=rsIQC.getString("INSPECT_QTY");
		//	 	waferYld=rsIQC.getString("PROD_YIELD");
		//  	} 
		//	else 
		//	{
		//   	iqcResult = "N/A";  //來料情況   
		//	    waiveNo="N/A";
		//	    waferLot="N/A";
		//	    waferDesc="N/A";
		//	    waferQty="N/A";
		//		waferYld="N/A";
		//   }  
		//	// End of if (rsIQC.next())
		//   rsIQC.close();
		//	stateIQC.close();
        //}
        //else
        //{
		// 	iqcResult = "N/A";  //來料情況   
		//	waiveNo="N/A";
		//	waferLot="N/A";
		//	waferDesc="N/A";
		//	waferQty="N/A";
		//	waferYld="N/A";
		//}
		if (woType=="2" || woType.equals("2"))
		{
			iqcResult = rs.getString("RESULT_NAME");  //來料情況   
			waiveNo=rs.getString("LWAIVE_NO");
			waferLot=rs.getString("SUPPLIER_LOT_NO");
			waferDesc=rs.getString("WAFER_DESC");
			waferQty=rs.getString("INSPECT_QTY");
			waferYld=rs.getString("PROD_YIELD");		
		}
		else
		{
			iqcResult = "N/A";  //來料情況   
			waiveNo="N/A";
			waferLot="N/A";
			waferDesc="N/A";
			waferQty="N/A";
			waferYld="N/A";		
		}
 
		   
		//jxl.write.Label lable9 = new jxl.write.Label(col, rowNo, noSeqStr , wcfFL); // (行,列);由第七列開始顯示動態資料
        ws.addCell(new jxl.write.Number(col, rowNo, noSeq , ARightL));	
		col++;
		
		//marketType=rs.getString("MARKET_TYPE");			  
		//jxl.write.Label lable121 = new jxl.write.Label(1, rowNo, marketType , wcfFL); 
        ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("MARKET_TYPE") , wcfFL));	
		col++;		  
		  
		//woNo = rs.getString("WO_NO");  //工令編號
		//jxl.write.Label lable8 = new jxl.write.Label(2, rowNo, woNo , wcfFL); // (行,列);由第七列開始顯示動態資料
        ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("WO_NO") , wcfFL));	
		col++;
		  	  	  
		//  iqcResult = rs.getString("RESULT");  //來料情況
		//jxl.write.Label lable10 = new jxl.write.Label(3, rowNo, iqcResult , wcfFL); // (行,列);由第七列開始顯示動態資料
        ws.addCell(new jxl.write.Label(col, rowNo, iqcResult , wcfFL));
		col++;
		  
		//tscAmp=rs.getString("TSC_AMP");    //安培數
		//out.println("customer="+customer); 
	    //jxl.write.Label lable11 = new jxl.write.Label(4, rowNo, tscAmp , wcfFL); // (行,列);由第七列開始顯示動態資料
        ws.addCell( new jxl.write.Label(col, rowNo, rs.getString("TSC_AMP") , wcfFL));
		col++;
		  
		//noSeqStr = integer.toString(noSeq);		  //料號  
		//invItem=rs.getString("INV_ITEM");
		//out.println("tscItemDesc="+tscItemDesc); 
	    //jxl.write.Label lable21 = new jxl.write.Label(5, rowNo, invItem , wcfFL); // (行,列); 
        ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("INV_ITEM") , wcfFL));
		col++;
		 
		//itemDesc=rs.getString("ITEM_DESC");
		//jxl.write.Label lable31 = new jxl.write.Label(6, rowNo, itemDesc , wcfFL); // (行,列); 
        ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("ITEM_DESC") , wcfFL));
		col++;
		  
		//tscPackage=rs.getString("TSC_PACKAGE");	
		//if ( tscPackage==null || tscPackage.equals(""))	 {tscPackage=""; }  	
		//jxl.write.Label lable116 = new jxl.write.Label(7, rowNo, tscPackage , wcfFL); 
        ws.addCell(new jxl.write.Label(col, rowNo,(rs.getString("TSC_PACKAGE")==null?"":rs.getString("TSC_PACKAGE")) , wcfFL));	
		col++;

		//tscFamily=rs.getString("TSC_FAMILY");	
		//if ( tscFamily==null || tscFamily.equals(""))  {tscFamily=""; }  	
		//jxl.write.Label lable117 = new jxl.write.Label(8, rowNo, tscFamily , wcfFL); 
        ws.addCell(new jxl.write.Label(col, rowNo, (rs.getString("TSC_FAMILY")==null?"":rs.getString("TSC_FAMILY")) , wcfFL));	
		col++;

		//woQty=rs.getString("WO_QTY");					  
		//jxl.write.Label lable41 = new jxl.write.Label(9, rowNo, woQty , wcfFL); 
		if (rs.getString("WO_QTY")==null)
		{
			ws.addCell(new jxl.write.Label(col, rowNo, "" , wcfFL));
		}
		else
		{
        	ws.addCell( new jxl.write.Number(col, rowNo, Double.valueOf(rs.getString("WO_QTY")).doubleValue() , ARightL));
		}
		col++;		
          		  
		//waferDesc=rsIQC.getString("WAFER_DESC");
		//jxl.write.Label lable51 = new jxl.write.Label(10, rowNo, waferDesc , wcfFL); 
        ws.addCell( new jxl.write.Label(col, rowNo, waferDesc, wcfFL));	
		col++;	  
		 
		//waferLot=rsIQC.getString("WAFER_LOT_NO");
		//jxl.write.Label lable61 = new jxl.write.Label(11, rowNo, waferLot, wcfFL); 
        ws.addCell(new jxl.write.Label(col, rowNo, waferLot, wcfFL));
		col++;
		  
		//waferQty=rs.getString("INSPECT_QTY");		  			  
		//jxl.write.Label lable71 = new jxl.write.Label(12, rowNo, rs.getString("WAFER_USED_PCE") , wcfFL); 
		if (rs.getString("WAFER_PCE")==null)
		{
			ws.addCell(new jxl.write.Label(col, rowNo, "" , wcfFL));   //add by Peggy 20180905
		}
		else
		{
	        ws.addCell(new jxl.write.Number(col, rowNo, Double.valueOf(rs.getString("WAFER_USED_PCE")).doubleValue() , ARightL));
		}
		
		col++;	

		if (rs.getString("WAFER_PCE")==null)
		{
			ws.addCell(new jxl.write.Label(col, rowNo, "" , wcfFL));   //add by Peggy 20180905
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, rowNo, Double.valueOf(rs.getString("WAFER_PCE")).doubleValue() , ARightL));   //add by Peggy 20180905
		}
		col++;
		
		//startDate=rs.getString("START_DATE");		  			  
		//jxl.write.Label lable81 = new jxl.write.Label(14, rowNo, startDate.substring(0,10) , wcfFL); 
		ws.addCell(new jxl.write.DateTime(col, rowNo, formatter.parse(rs.getString("START_DATE")) ,DATE_FORMAT));
		
		col++;	

		//endDate=rs.getString("END_DATE");		  			  
		//jxl.write.Label lable91 = new jxl.write.Label(15, rowNo, endDate.substring(0,10) , wcfFL); 
		ws.addCell(new jxl.write.DateTime(col, rowNo, formatter.parse(rs.getString("END_DATE")) ,DATE_FORMAT));
		col++;	
		  
		//waferYld=rs.getString("PROD_YIELD");	
		//if ( waferYld==null || waferYld.equals("null") || waferYld.equals(""))	{waferYld=""; }  			  
		//jxl.write.Label lable101 = new jxl.write.Label(16, rowNo, waferYld , wcfFL); 
        ws.addCell(new jxl.write.Label(col, rowNo, waferYld , wcfFL));
		col++;	
		  
		//woRemark=rs.getString("WO_REMARK");	
		//if ( woRemark==null || woRemark.equals(""))	{woRemark=""; }  	
		//jxl.write.Label lable111 = new jxl.write.Label(17, rowNo, woRemark , wcfFL); 
        ws.addCell( new jxl.write.Label(col, rowNo, (rs.getString("WO_REMARK")==null?"":rs.getString("WO_REMARK")) , wcfFL));	
		col++;
		  
        if (woType=="2" || woType.equals("2"))
        {
			//jxl.write.Label lable115 = new jxl.write.Label(17, rowNo, diceLotNo , wcfFL); // 切割工令號
			//jxl.write.Label lable115 = new jxl.write.Label(18, rowNo, rs.getString("PRIMARY_NO") , wcfFL); // 檢驗單號
          	ws.addCell( new jxl.write.Label(col, rowNo, rs.getString("PRIMARY_NO") , wcfFL));	
			col++;
			
			//jxl.write.Label lable1011 = new jxl.write.Label(19, rowNo, rs.getString("wafer_qty") , wcfFL);  //add by Peggy 20180905
			ws.addCell(new jxl.write.Number(col, rowNo, Double.valueOf(rs.getString("wafer_qty")).doubleValue() , ARightL));	
			col++;	
			
			ws.addCell(new jxl.write.Number(col, rowNo, Double.valueOf(rs.getString("WO_UNIT_QTY")).doubleValue() , ARightL));	
			col++;				
        }
        else
        {
			//合併SQL提高執行效率,modify by Peggy 20180906
        	//String sqlm3="select CODE_DESC from YEW_MFG_DEFDATA  where DEF_TYPE='WO_TYPE'  and CODE= '"+woType+"' ";
		  	//Statement statem3=con.createStatement();
	      	//ResultSet rsm3=statem3.executeQuery(sqlm3);
		  	//if (rsm3.next()) { 	woTypeCode   = rsm3.getString("CODE_DESC"); } 
		  	//rsm3.close();
	      	//statem3.close();  
		  	//jxl.write.Label lable115 = new jxl.write.Label(17, rowNo, woTypeCode , wcfFL); // 切割工令號
			//jxl.write.Label lable115 = new jxl.write.Label(18, rowNo, rs.getString("CODE_DESC") , wcfFL); // 工單類型
          	ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("CODE_DESC") , wcfFL));	
			col++;
		}

		rowNo ++;
	}  
	rs.close();
	statement.close();

	//抓取PC姓名及預設部門主管姓名
 	String sqlNamea="  SELECT YMD.CODE_DESC PCDIRECTOR,YMDA.CODE_DESC PCNAME FROM YEW_MFG_DEFDATA YMD,YEW_MFG_DEFDATA YMDA,YEW_MFG_USER YMU  "+
 	  			    "  WHERE YMD.CODE = YMU.MFG_DEPT_NO  AND YMD.DEF_TYPE='MFG_DIRECTOR' AND YMDA.CODE = YMU.MFG_DEPT_NO AND YMDA.DEF_TYPE='MFG_PC' "+
 					"   AND YMU.PRIMARY_FLAG = 'Y' AND YMU.USER_ID = "+userMfgUserID+" ";
  
	Statement stateNamea=con.createStatement();
	ResultSet rsNamea=stateNamea.executeQuery(sqlNamea);
	if (rsNamea.next())
	{ 	
		pcDirector   = rsNamea.getString("PCDIRECTOR");  
        pcName   = rsNamea.getString("PCNAME");  
	} 
	rsNamea.close();
	stateNamea.close();  

	//抓取PC姓名及預設部門主管姓名
	jxl.write.WritableFont wfA = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFA = new jxl.write.WritableCellFormat(wfA); 
	wcfFA.setAlignment(jxl.format.Alignment.LEFT);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFA = new jxl.write.Label(0, rowNo+2, "製造主管:", wcfFA);  // (行,列)
    ws.addCell(labelCFA);
	ws.setColumnView(0,15);
	 
	jxl.write.WritableFont wfB = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFB = new jxl.write.WritableCellFormat(wfB); 
	wcfFB.setAlignment(jxl.format.Alignment.LEFT);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFB = new jxl.write.Label(6, rowNo+2, "部門主管:", wcfFB);  // (行,列)
    ws.addCell(labelCFB);
	ws.setColumnView(0, 15);
	 
	jxl.write.WritableFont wfC = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfC); 
	wcfFC.setAlignment(jxl.format.Alignment.LEFT);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFC = new jxl.write.Label(11, rowNo+2, "生管:"+pcName, wcfFC);  // (行,列)
    ws.addCell(labelCFC);
	ws.setColumnView(0, 15);
	 
	jxl.write.WritableFont wfD = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfFD = new jxl.write.WritableCellFormat(wfD); 
	wcfFD.setAlignment(jxl.format.Alignment.CENTRE);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCFD = new jxl.write.Label(0, rowNo+3, "*****The copyright of document and business secret belong to EVERWELL,and no copies should be made without any permission *****   (YQ4PC16-C)", wcfFD);  // (行,列)
    ws.addCell(labelCFD);
	ws.mergeCells(0, rowNo+3, 14, rowNo+3);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
	
	//寫入Excel 
	wwb.write(); 
    //關閉Excel工作薄 
	wwb.close(); // close workbook //
   	os.close();   // close file outputstream //
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
	response.reset();
    response.setContentType("application/vnd.ms-excel");	
    response.sendRedirect("/oradds/report/"+userID+"_"+ymdCurr+hmsCurr+"_WO.xls");  
%>
</html>
