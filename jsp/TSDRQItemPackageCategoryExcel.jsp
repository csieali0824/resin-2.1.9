<!--20151122 Peggy,add TSC_PROD_FAMILY column-->
<!--20160113 Peggy,新增ITEM DESC欄位-->
<!--20160727 Peggy,add catalog_cust_moq欄位-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.write.*,jxl.format.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean,DateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function popMenuMsg(clkDesc)
{
	alert(clkDesc);
}
</script>
<title>Package Category Download</title>
</head>
<body>
<FORM ACTION="../jsp/TSDRQItemPackageCategorySetting.jsp" METHOD="post" NAME="MYFORM">
<% 
  	workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  	workingDateBean.setDefineWeekFirstDay(1);  //  
  
  	String sSql = "";
	String sSqlCNT = "";
	String sWhere = "";
	String sWhereGP = "";
	String sOrder = "";
	String subSql = "";
	String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   //  
  	String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 
  	String currentWeek = workingDateBean.getWeekString();

	String intType=request.getParameter("INTTYPE");
	String packClass=request.getParameter("PACKCLASS");
	String TSCFAMILY = request.getParameter("TSCFAMILY");
	if (TSCFAMILY == null) TSCFAMILY = "";
	String TSCPRODFAMILY = request.getParameter("TSCPRODFAMILY");
	if (TSCPRODFAMILY == null) TSCPRODFAMILY = "";
	String PACKAGECODE = request.getParameter("PACKAGECODE");
	if (PACKAGECODE == null) PACKAGECODE = "";
	String TSCOUTLINE = request.getParameter("TSCOUTLINE");
	if (TSCOUTLINE == null) TSCOUTLINE = "";
	String PRODUCTGROUP = request.getParameter("PRODUCTGROUP");
	if (PRODUCTGROUP == null) PRODUCTGROUP = "";
	String ITEM_DESC = request.getParameter("ITEM_DESC"); //add by Peggy 20160113
	if (ITEM_DESC == null) ITEM_DESC = "";	
	String invItem="",itemDesc="",groupArea="",hub="",custName="",orderNo="",orderDate="",schDate="",orderQty="",itemUom="KPC";
  	String txnType="",docNo="",sourceCode="",sourceLineId="";
  	float orderQtyf=0,sumQtyf=0;
	int col=0;

  	String serverHostName=request.getServerName();
  	String ymdCurr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
  	String hmsCurr = dateBean.getHourMinuteSecond();
  	String strHMSec = request.getParameter("HOURTIME");
	String fileName = "TSC_D3002_"+userID+"_"+hmsCurr+".xls";

	try
  	{  
		//sWhereGP = " and a.INT_TYPE > '0' ";
		sWhereGP = " and 1=1";
		subSql = "SELECT int_type,"+
           "    int_type || '-' || packing_class || '_' || tsc_outline || '_'"+
           "    || package_code || '_' || TSC_PROD_GROUP || '_'|| tsc_family AS okey,"+
           "    packing_class, tsc_family, tsc_outline, spq, moq, sample_spq,package_code,"+ //add sample_spq field by Peggy on 20120516
		   "    tsc_prod_family,"+ //add by Peggy 20151122
		   //"    to_char(TO_date(creation_date, 'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd') creation_date"+
		   //"    ,created_by,TSC_PROD_GROUP,"+
 		   "    CATALOG_CUST_MOQ,"+ //add by Peggy 20160727
		   "    VENDOR_MOQ,"+ //add by Peggy 20211206
		   "    to_char(TO_date(CASE WHEN LAST_UPDATE_DATE IS NULL OR LAST_UPDATE_DATE='N/A' THEN creation_date ELSE LAST_UPDATE_DATE END, 'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd') creation_date"+
		   "    ,CASE WHEN LAST_UPDATE_DATE IS NULL OR LAST_UPDATE_DATE='N/A' THEN created_by ELSE LAST_UPDATED_BY END created_by,TSC_PROD_GROUP,"+
		   "    ITEM_DESCRIPTION,"+ //add by Peggy 20160113
		   "    ITEM_NO,"+  //add by Peggy 20190724
           "    CASE WHEN NVL(item_description,'XX')='XX' THEN ROW_NUMBER () OVER (PARTITION BY int_type"+
           "                                    || '_'"+
           "                                     || packing_class"+
           "                                     || '_'"+
           "                                     || tsc_outline"+
           "                                     || '_'"+
           "                                     || package_code"+
		   "                                     || '_'"+
		   "                                     || TSC_PROD_GROUP"+
		   "                                     || '_'"+
		   //"                                     || tsc_family"+
		   //"                                     || CASE WHEN tsc_prod_group not IN ('PMD') THEN tsc_family ELSE '' END "+ //add by Peggy 20200716
		   "                                     || CASE WHEN tsc_prod_group not IN ('PMD') THEN tsc_family ELSE NVL(item_description, 'XX') END "+ //add by Peggy 20210802
		   "                                     || '_'"+
		   //"                                     || tsc_prod_family"+
		   //"                                     || '-'|| nvl(INVENTORY_ITEM_ID,0)"+
		   "                                     ||CASE WHEN tsc_prod_group IN ('SSP', 'SSD') THEN tsc_prod_family || '-' ELSE '' END "+ //add by Peggy 20200716
		   "                                     ORDER BY nvl(last_update_date,creation_date) DESC) ELSE ROW_NUMBER () OVER (PARTITION BY int_type,item_description order by NVL (last_update_date, creation_date) DESC) END "+
           "                                                           row_num"+
           " FROM oraddman.tsitem_packing_cate"+
		   " WHERE upper(int_type) not in ('YEW','YE')"+
		   //" AND ((TSC_PROD_GROUP IN ('PMD','SSP','SSD') AND tsc_prod_family IS NOT NULL)"+
		   //" or (TSC_PROD_GROUP not in ('PMD','SSP','SSD') AND tsc_prod_family IS NULL))";
		   " AND ((TSC_PROD_GROUP IN ('SSP','SSD') AND tsc_prod_family IS NOT NULL)"+
		   //" or (TSC_PROD_GROUP not in ('SSP','SSD') AND tsc_prod_family IS NULL))";
		   " or TSC_PROD_GROUP not in ('SSP','SSD'))"; //modify by Peggy 20200716
    	sSql = " SELECT int_type, okey, packing_class, tsc_family, tsc_prod_family,tsc_outline, spq, moq,sample_spq,package_code,TSC_PROD_GROUP,creation_date,created_by"+ //add sample_spq field by Peggy on 20120516
		  ",ITEM_DESCRIPTION "+ //add by Peggy 20160113
		  ",ITEM_NO"+ //add by Peggy 20190724
		  ",CATALOG_CUST_MOQ"+//add by Peggy 20160727
		  ",VENDOR_MOQ"+  //add by Peggy 20211206
          " from ("+ subSql + ") a  WHERE row_num = 1 ";
		sSqlCNT = " SELECT COUNT(1) as CaseCount FROM ("+ subSql + ") a where row_num = 1 ";
   		sWhere =  " and a.INT_TYPE IS NOT NULL ";       
   		if (intType!=null && !intType.equals("") && !intType.equals("--")) sWhere += " and a.INT_TYPE ='"+intType+"' ";    
   		if (packClass!=null && !packClass.equals("") && !packClass.equals("--")) sWhere += " and a.PACKING_CLASS='"+packClass+"' ";
   		if (TSCFAMILY !=null && !TSCFAMILY.equals("") && !TSCFAMILY.equals("--"))  sWhere += " and a.TSC_FAMILY='"+TSCFAMILY+"' ";
   		if (TSCOUTLINE !=null && !TSCOUTLINE.equals("") && !TSCOUTLINE.equals("--"))  sWhere += " and a.TSC_OUTLINE='"+TSCOUTLINE+"' ";
   		if (PACKAGECODE !=null && !PACKAGECODE.equals("") && !PACKAGECODE.equals("--"))  sWhere += " and a.PACKAGE_CODE='"+PACKAGECODE+"' ";
   		if (PRODUCTGROUP !=null && !PRODUCTGROUP.equals("") && !PRODUCTGROUP.equals("--"))  sWhere += " and a.TSC_PROD_GROUP='"+PRODUCTGROUP+"' ";
   		if (TSCPRODFAMILY !=null && !TSCPRODFAMILY.equals("") && !TSCPRODFAMILY.equals("--"))  sWhere += " and a.TSC_PROD_FAMILY='"+TSCPRODFAMILY+"' ";
		if (ITEM_DESC !=null && !ITEM_DESC.equals("") && !ITEM_DESC.equals("--"))  sWhere += " and a.ITEM_DESCRIPTION='"+ITEM_DESC+"' ";
   		sOrder = " order by INT_TYPE,TSC_PROD_GROUP,TSC_FAMILY,TSC_PROD_FAMILY,TSC_OUTLINE,PACKAGE_CODE ";
		sSql = sSql + sWhere + sWhereGP + sOrder;
		//out.println("sql="+sSql);
		OutputStream os = null;	
		if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
		{ // For Unix Platform
			os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+fileName);
		}  
		else 
		{ // For Windows Platform
			os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+fileName);
		}
		jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
		//file://建立Excel工作表的 sheet名稱
		jxl.write.WritableSheet ws = wwb.createSheet("package category", 0); //-- TEST
		
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
		//wcf2Content.setBackground(jxl.format.Colour.GRAY_25); // 	  
		
		jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
		jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
		wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
		wcfT.setAlignment(jxl.format.Alignment.LEFT);
		
		sst.setSelected();
		sst.setVerticalFreeze(1);  //凍結窗格
		sst.setFitToPages(true);	
		sst.setFitWidth(1);  // 設定一頁寬
		col=0;
	
		//抬頭:(第6列第0行)		// 明細抬頭說明
		ws.addCell(new jxl.write.Label(col, 0, "Internal/External", wcf2Header));
		ws.setColumnView(col,15);
		col++;
		
		ws.addCell(new jxl.write.Label(col, 0, "Packing Class", wcf2Header));
		ws.setColumnView(col,25);		
		col++;

		ws.addCell(new jxl.write.Label(col, 0, "TSC Prod Group", wcf2Header));
		ws.setColumnView(col,17);
		col++;
		
		ws.addCell(new jxl.write.Label(col, 0, "TSC Family", wcf2Header));
		ws.setColumnView(col,25);	
		col++;

		ws.addCell(new jxl.write.Label(col, 0, "TSC Prod Family", wcf2Header));
		ws.setColumnView(col,25);
		col++;	
		
		ws.addCell(new jxl.write.Label(col, 0, "TSC Package", wcf2Header));
		ws.setColumnView(col,15);
		col++;
		
		ws.addCell(new jxl.write.Label(col, 0, "Packing Code", wcf2Header));
		ws.setColumnView(col,17);
		col++;
		
		ws.addCell(new jxl.write.Label(col, 0, "Item Desc", wcf2Header));
		ws.setColumnView(col,25);
		col++;		
	
		ws.addCell(new jxl.write.Label(col, 0, "SPQ(PCE)", wcf2Header));
		ws.setColumnView(col,11);
		col++;

		ws.addCell(new jxl.write.Label(col, 0, "Sample_SPQ(PCE)", wcf2Header));
		ws.setColumnView(col,11);
		col++;
	
		ws.addCell(new jxl.write.Label(col, 0, "MOQ(PCE)", wcf2Header));
		ws.setColumnView(col,11);
		col++;

		ws.addCell(new jxl.write.Label(col, 0, "Catalog Cust MOQ(PCE)", wcf2Header));  //add by Peggy 20160727
		ws.setColumnView(col,16);
		col++;

		ws.addCell(new jxl.write.Label(col, 0, "Vendor MOQ(PCE)", wcf2Header));  //add by Peggy 20211206
		ws.setColumnView(col,16);
		col++;
	
		ws.addCell(new jxl.write.Label(col, 0, "Last Update Date", wcf2Header));
		ws.setColumnView(col,15);
		col++;
	
		ws.addCell(new jxl.write.Label(col, 0, "Last Updated By", wcf2Header));
		ws.setColumnView(col,15);
		col++;

		//料號 for 22D change to 30D,add by Peggy 20190724
		ws.addCell(new jxl.write.Label(col, 0, "ITEM NO", wcf2Header));
		ws.setColumnView(col,30);
		col++;
	
		int rowNo = 1;  //第二列開始
		
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sSql); 	
		
		jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
		jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  
        jxl.write.WritableCellFormat wcfFR = new jxl.write.WritableCellFormat(wfL);
        wcfFR.setAlignment(jxl.format.Alignment.RIGHT);
		wcfFR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  
        jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfL);
        wcfFC.setAlignment(jxl.format.Alignment.CENTRE);
		wcfFC.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  
		
		while (rs.next())
		{	
			col=0;  
			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("INT_TYPE") , wcfFL));	
			col++;
		  
			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("PACKING_CLASS") , wcfFL));			  
			col++;
	
			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("TSC_PROD_GROUP") , wcfFL));
			col++;
			  
			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("TSC_FAMILY") , wcfFL));
			col++;
	
			ws.addCell(new jxl.write.Label(col, rowNo, (rs.getString("TSC_PROD_FAMILY")==null?"":rs.getString("TSC_PROD_FAMILY")) , wcfFL));
			col++;
	
			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("TSC_OUTLINE") , wcfFL));	
			col++;
					  
			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("PACKAGE_CODE") , wcfFL));
			col++;

			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("ITEM_DESCRIPTION") , wcfFL));
			col++;
			  
			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("SPQ") , wcfFR));
			col++;
	
			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("SAMPLE_SPQ") , wcfFR));
			col++;

			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("MOQ") , wcfFR));
			col++;

			ws.addCell(new jxl.write.Label(col, rowNo, (rs.getString("CATALOG_CUST_MOQ")==null?"":rs.getString("CATALOG_CUST_MOQ")) , wcfFR));  //add by Peggy 20160727
			col++;

			ws.addCell(new jxl.write.Label(col, rowNo, (rs.getString("VENDOR_MOQ")==null?"":rs.getString("VENDOR_MOQ")) , wcfFR));  //add by Peggy 20211206
			col++;
			  
			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("CREATION_DATE") , wcfFC));		
			col++;
					  
			ws.addCell(new jxl.write.Label(col, rowNo, rs.getString("CREATED_BY") , wcfFL));	
			col++;

			ws.addCell(new jxl.write.Label(col, rowNo, (rs.getString("ITEM_NO")==null?"":rs.getString("ITEM_NO")) , wcfFL));	
			col++;
			
			rowNo ++;
	  	}   // End of While rs.next()
		
	 	rs.close();
	 	statement.close();

		//寫入Excel 
		wwb.write(); 
		//關閉Excel工作薄 
		wwb.close(); // close workbook //
		os.close();   // close file outputstream //
		out.close(); 
	} //end of try
  	catch (Exception e)
  	{
   		out.println("Exception D3002:"+e.getMessage());
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
    response.sendRedirect("/oradds/report/"+fileName); 
%>
</html>

