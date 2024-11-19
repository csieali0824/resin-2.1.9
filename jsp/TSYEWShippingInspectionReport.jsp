<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Shipping Inspection Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSYEWShippingInspectionReport.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",sql="",SHIP_QTY="",SHIPPING_MARKS="",TSC_PARTNO="",v_file_name="",SONO="",DOC_DATE="",UNDERLINE_FLAG="",TSC_PACKING_CODE="",TSC_PACKAGE="",V_USER_CNAME ="",LOT_NO_LIST="",ITEM_DESC="";
String KID = request.getParameter("KID");
if (KID==null) KID="";
String ELECTRICAL_MAJOR_1="",ELECTRICAL_MAJOR_2="",APPEARANCE_NUM="",ELECTRICAL_SAMPLE_SIZE="",APPEARANCE_MAJOR_1="",APPEARANCE_MAJOR_2="",APPEARANCE_SAMPLE_SIZE="",MARKING_CODE="";
String v_electrical_spec[][]=new String[10][4];
String v_electrical_item[][]=new String[10][2];
int fontsize=10,colcnt=0,v_line=0,v_line_cnt=0;
double SHIP_QTY_PCE=0;

// 為存入日期格式為US考量,將語系先設為美國
String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();
try 
{ 	
	/*sql = " SELECT OOHA.ORDER_NUMBER"+
	      ",OOLA.LINE_ID"+
		  ",YWA.WO_QTY/CASE WHEN YWA.WO_UOM='KPC' THEN 1 ELSE 1000 END WO_QTY"+
		  ",YWA.WO_UOM"+
	      ",YWA.INV_ITEM"+
		  ",YWA.ITEM_DESC"+
		  ",TSC_INV_CATEGORY(YWA.INVENTORY_ITEM_ID,?,?) TSC_PARTNAME"+
          ",CASE WHEN SUBSTR(OOHA.ORDER_NUMBER,1,4) IN (?,?,?) THEN (SELECT TSC_GET_REMARK_DESC(A.HEADER_ID,?) "+
          " FROM ONT.OE_ORDER_HEADERS_ALL A WHERE A.ORG_ID=? AND A.ORDER_NUMBER=OOHA.ORDER_NUMBER) "+
          " ELSE TSC_GET_REMARK_DESC(OOHA.HEADER_ID,?) END AS SHIPPING_MARKS"+
		  ",TO_CHAR(SYSDATE,'yyyy/mm/dd') DOC_DATE"+
          ",YWA.CREATION_DATE"+
		  ",TSC_GET_ITEM_DESC_NOPACKING(? ,YWA.INVENTORY_ITEM_ID) TSC_ITEM_NOPACKING"+
		  ",TSC_GET_ITEM_PACKING_CODE(?,YWA.INVENTORY_ITEM_ID) PACKING_CODE"+
		  ",TSC_INV_CATEGORY(YWA.INVENTORY_ITEM_ID,?,?) TSC_PACKAGE"+
		  ",TSC_LABEL_PKG.GET_WIP_LOT_LIST(YWA.WO_NO,'YEW')  LOT_NO_LIST"+
          " FROM  YEW_WORKORDER_ALL YWA"+
		  ",ONT.OE_ORDER_HEADERS_ALL OOHA"+
		  ",ONT.OE_ORDER_LINES_ALL OOLA"+
          " WHERE YWA.ORDER_LINE_ID=OOLA.LINE_ID"+
		  " AND YWA.ORDER_HEADER_ID=OOHA.HEADER_ID"+
		  " AND OOLA.HEADER_ID=OOHA.HEADER_ID"+
          " AND YWA.WO_NO=?";*/
	sql = " SELECT YWSR.WMS_DOC_NUM"+
          ",YWP.ORDER_NUMBER"+
          //",YWP.ORDER_LINE_ID"+
          ",YWP.ITEM_NO"+
          ",YWP.ITEM_DESC"+
          ",YWP.SHIP_MARK"+
          ",SUM(YWP.QUANTITY)/1000 TOT_QTY"+
          ",YWP.CUST_NAME"+
          ",CASE WHEN SUBSTR(YWP.ORDER_NUMBER,1,4) IN (1121,1131,1141) THEN (SELECT TSC_GET_REMARK_DESC(A.HEADER_ID,'SHIPPING MARKS') FROM ONT.OE_ORDER_HEADERS_ALL A WHERE A.ORG_ID=41 AND A.ORDER_NUMBER=YWP.ORDER_NUMBER) "+
          " ELSE TSC_GET_REMARK_DESC(OOLA.HEADER_ID,'SHIPPING MARKS') END AS SHIPPING_MARKS"+
          ",TSC_INV_CATEGORY(OOLA.INVENTORY_ITEM_ID,?,?) TSC_PARTNAME "+
          ",TSC_INV_CATEGORY(OOLA.INVENTORY_ITEM_ID,?,?) TSC_PACKAGE"+
          ",TSC_GET_ITEM_DESC_NOPACKING(? ,OOLA.INVENTORY_ITEM_ID) TSC_ITEM_NOPACKING"+
          ",TSC_GET_ITEM_PACKING_CODE(?,OOLA.INVENTORY_ITEM_ID) PACKING_CODE"+
          ",TO_CHAR(trunc(YWP.TXN_DATE)-7,'yyyy/mm/dd') DOC_DATE"+
          //",MIN(YWP.TSC_LOT) S_LOT"+
          //",MAX(YWP.TSC_LOT) E_LOT"+
          //",CASE WHEN MIN(YWP.TSC_LOT)=MAX(YWP.TSC_LOT) THEN MIN(YWP.TSC_LOT) ELSE MIN(YWP.TSC_LOT)||'~'||SUBSTR(MAX(YWP.TSC_LOT),-3) END LOT_NO_LIST"+
		  ",tsc_label_pkg.GET_WIP_LOT_LIST(?,'PACKING')  LOT_NO_LIST"+
		  ",YWSR.WMS_DOC_NUM||'_'||YWP.ORDER_NUMBER||'_'||REPLACE(YWP.ITEM_DESC,'/',' ')||'_'||YWP.DATE_CODE AS FILENAME"+
		  ",SUM(YWP.QUANTITY) TOT_QTY_PCE"+ //add by Peggy 20230719
          " FROM YEW_WMS_SHIPMMENT_RELS YWSR"+
          ",YEW_WMS_PACKINGLIST YWP"+
          ",ONT.OE_ORDER_LINES_ALL OOLA"+
          ",YEW_RUNCARD_ALL YRA"+
          " WHERE YWSR.WMS_DOC_NUM=YWP.WMS_DOC_NUM"+
          " AND YWSR.OM_LINE_ID=YWP.ORDER_LINE_ID"+
          " AND YWSR.OM_LINE_ID=OOLA.LINE_ID"+
          " AND YWP.TSC_LOT=YRA.RUNCARD_NO(+)"+
		  " AND YWSR.WMS_DOC_NUM||'_'||YWP.ORDER_NUMBER||'_'||OOLA.INVENTORY_ITEM_ID||'_'||YWP.DATE_CODE=?"+  
          " GROUP BY YWSR.WMS_DOC_NUM"+
          ",YWP.ORDER_NUMBER"+
          //",YWP.ORDER_LINE_ID"+
          ",YWP.ITEM_NO"+
          ",YWP.ITEM_DESC"+
          ",YWP.SHIP_MARK"+
          ",OOLA.INVENTORY_ITEM_ID"+
          ",YWP.CUST_NAME"+
          ",OOLA.HEADER_ID"+
		  ",YWP.DATE_CODE"+
		  //",OOLA.LINE_NUMBER"+
		  ",trunc(YWP.TXN_DATE)";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setInt(1,43);
	statement.setInt(2,24);
	statement.setInt(3,43);
	statement.setInt(4,23);
	statement.setInt(5,43);
	statement.setInt(6,43);
	statement.setString(7,KID);
	statement.setString(8,KID);
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{	
		SHIP_QTY=rs.getString("TOT_QTY");
		SHIPPING_MARKS=rs.getString("SHIPPING_MARKS");
		//TSC_PARTNO=rs.getString("TSC_ITEM_NOPACKING");
		//if (TSC_PARTNO.indexOf("/")>0) TSC_PARTNO=rs.getString("TSC_PARTNAME");
		TSC_PARTNO=rs.getString("TSC_PARTNAME"); //modify by Peggy 20240307
		v_file_name=rs.getString("FILENAME")+".xls";
		SONO=rs.getString("ORDER_NUMBER");
		DOC_DATE=rs.getString("DOC_DATE");
		TSC_PACKING_CODE=rs.getString("PACKING_CODE");
		TSC_PACKAGE=rs.getString("TSC_PACKAGE");
		LOT_NO_LIST=rs.getString("LOT_NO_LIST");
		ITEM_DESC=rs.getString("ITEM_DESC");
		SHIP_QTY_PCE = rs.getDouble("TOT_QTY_PCE");
		
		
		sql = " SELECT TPM.MARKING"+
			  ",NVL(TPM.UNDER_LINE_FLAG,'N') UNDER_LINE_FLAG "+
			  " FROM ORADDMAN.TSYEW_PRODUCT_MARKING TPM "+
			  " WHERE TPM.TSC_PARTNO in (?,?)"+
			  " order by decode(TPM.TSC_PARTNO,?,1,2)"; 
		//out.println(sql);
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,TSC_PARTNO);
		statement1.setString(2,ITEM_DESC);
		statement1.setString(3,ITEM_DESC);
		ResultSet rs1=statement1.executeQuery();
		if (rs1.next())
		{	
			MARKING_CODE=rs1.getString("MARKING");
			if (MARKING_CODE==null) MARKING_CODE="";
			UNDERLINE_FLAG=rs1.getString("UNDER_LINE_FLAG");
		}	
		rs1.close();
		statement1.close();
	}	
	rs.close();
	statement.close();
	
	sql = " SELECT USER_CNAME FROM oraddman.wsuser A"+
          " WHERE USERNAME=?";
	statement = con.prepareStatement(sql);
	statement.setString(1,UserName);
	rs=statement.executeQuery();
	if(rs.next())
	{	
		V_USER_CNAME = rs.getString(1);
		if (V_USER_CNAME==null) V_USER_CNAME=UserName;
	}	
	else
	{
		V_USER_CNAME = UserName;
	}
	rs.close();
	statement.close();		
	
	sql = " SELECT YPE.TSC_PARTNO, YPE.ITEM_VALUE, YPE.CONDITIONS_VALUE, YPE.MIN_VALUE,YPE.MAX_VALUE"+
	      ",count(1) over (partition by YPE.TSC_PARTNO) parts_cnt"+
          ",row_number() over (partition by YPE.TSC_PARTNO order by RANK_NUM) parts_seq"+
          " FROM ORADDMAN.TSYEW_PRODUCT_ELECTRICAL_LIST YPE"+
          " WHERE YPE.TSC_PARTNO in (?,?)"+
	      " order by decode(YPE.TSC_PARTNO,?,1,2), RANK_NUM"; 
	statement = con.prepareStatement(sql);
	statement.setString(1,TSC_PARTNO);
	statement.setString(2,ITEM_DESC);
	statement.setString(3,ITEM_DESC);
	rs=statement.executeQuery();
	v_line=0;v_line_cnt=0;
	while (rs.next())
	{	
		v_electrical_spec[v_line][0]=rs.getString("ITEM_VALUE");
		v_electrical_spec[v_line][1]=rs.getString("CONDITIONS_VALUE");
		v_electrical_spec[v_line][2]=rs.getString("MIN_VALUE");
		v_electrical_spec[v_line][3]=(rs.getString("MAX_VALUE")==null?"":rs.getString("MAX_VALUE"));
		v_line++;
		if (rs.getInt("parts_cnt")==rs.getInt("parts_seq"))
		{
			break;
		}
	}	
	rs.close();
	statement.close();	
	
	int row =0,col=0,totcnt=0,reccnt=0,mergeCol=0;
	String advise_no="";
	OutputStream os = null;	
	//FileName = CHKPRTNAME;
	FileName = v_file_name;
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ 
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName);
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("YEW檢驗報告", 0);  
	SheetSettings settings = ws.getSettings();//取得分頁環境設定(如:標頭/標尾,分頁,欄長,欄高等設定
	settings.setZoomFactor(100);    //顯示縮放比例
	//settings.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
	settings.setScaleFactor(88);   // 打印縮放比例
	settings.setHeaderMargin(0.3);
	settings.setBottomMargin(0.3);
	settings.setLeftMargin(0.5);
	settings.setRightMargin(0.3);
	settings.setTopMargin(0.5);
	settings.setFooterMargin(0.5);	
	
	//報表名稱平行置中-中文    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 14, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName.setAlignment(jxl.format.Alignment.CENTRE);

	//報表名稱平行置中-英文    
	WritableCellFormat wRptNameE = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), 14, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptNameE.setAlignment(jxl.format.Alignment.CENTRE);

	//報表名稱平行置中-英文    
	WritableCellFormat wRptNameES = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), 16, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptNameES.setAlignment(jxl.format.Alignment.CENTRE);

	//表尾行置中     
	WritableCellFormat wRptEnd = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), 9 , WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptEnd.setAlignment(jxl.format.Alignment.CENTRE);
		
	//英文內文水平垂直置左  
	WritableCellFormat ALEFT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"),fontsize ,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFT.setAlignment(jxl.format.Alignment.LEFT);
	ALEFT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALEFT.setWrap(true);
	
	//中文內文水平垂直置左  
	WritableCellFormat ALEFTC = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"),fontsize ,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFTC.setAlignment(jxl.format.Alignment.LEFT);
	ALEFTC.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALEFTC.setWrap(true);	

	//英文內文水平垂直置中-正常-格線
	WritableCellFormat ACENTREB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREB.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACENTREB.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線左右上粗   
	WritableCellFormat ACENTREBLRT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBLRT.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBLRT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBLRT.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLRT.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLRT.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLRT.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
	ACENTREBLRT.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線左右下粗   
	WritableCellFormat ACENTREBLRB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBLRB.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBLRB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBLRB.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ACENTREBLRB.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLRB.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLRB.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLRB.setWrap(true);		
		
	//英文內文水平垂直置中-正常-格線左右粗   
	WritableCellFormat ACENTREBLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBLR.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ACENTREBLR.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLR.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLR.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
	ACENTREBLR.setWrap(true);		
	
	//英文內文水平垂直置中-正常-格線左粗   
	WritableCellFormat ACENTREBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBL.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ACENTREBL.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBL.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.THIN);
	ACENTREBL.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
	ACENTREBL.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線左上粗   
	WritableCellFormat ACENTREBLT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBLT.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBLT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBLT.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLT.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLT.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.THIN);
	ACENTREBLT.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
	ACENTREBLT.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線左下粗   
	WritableCellFormat ACENTREBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBLB.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ACENTREBLB.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLB.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.THIN);
	ACENTREBLB.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBLB.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線上粗   
	WritableCellFormat ACENTREBT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBT.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBT.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBT.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.THIN);
	ACENTREBT.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.THIN);
	ACENTREBT.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
	ACENTREBT.setWrap(true);	
	
	//英文內文水平垂直置中-正常-格線下粗   
	WritableCellFormat ACENTREBB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBB.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBB.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBB.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.THIN);
	ACENTREBB.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.THIN);
	ACENTREBB.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ACENTREBB.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線右粗   
	WritableCellFormat ACENTREBR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBR.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBR.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
	ACENTREBR.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.THIN);
	ACENTREBR.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBR.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ACENTREBR.setWrap(true);	
		
	//英文內文水平垂直置中-正常-格線右上粗   
	WritableCellFormat ACENTREBRT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBRT.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBRT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBRT.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
	ACENTREBRT.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.THIN);
	ACENTREBRT.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBRT.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBRT.setWrap(true);		
	
	//英文內文水平垂直置中-正常-格線右下粗   
	WritableCellFormat ACENTREBRB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBRB.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBRB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBRB.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBRB.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.THIN);
	ACENTREBRB.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.MEDIUM);
	ACENTREBRB.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ACENTREBRB.setWrap(true);	
		
	//英文內文水平垂直置左-正常-格線左上下  
	WritableCellFormat ALEFTB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFTB.setAlignment(jxl.format.Alignment.LEFT);
	ALEFTB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALEFTB.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.MEDIUM);
	ALEFTB.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ALEFTB.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
	ALEFTB.setWrap(true);	
	
	//英文內文水平垂直置左-正常-格線左粗上正常下粗  
	WritableCellFormat ALEFTBB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFTBB.setAlignment(jxl.format.Alignment.LEFT);
	ALEFTBB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALEFTBB.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.MEDIUM);
	ALEFTBB.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ALEFTBB.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.MEDIUM);
	ALEFTBB.setWrap(true);		
	
	//中文內文水平垂直置中-正常-格線   
	WritableCellFormat ACENTREBC = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTREBC.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTREBC.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTREBC.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACENTREBC.setWrap(true);	
	
	//中文內文水平垂直置右-正常-格線上下右   
	WritableCellFormat ARIGHTBC = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARIGHTBC.setAlignment(jxl.format.Alignment.RIGHT);
	ARIGHTBC.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARIGHTBC.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ARIGHTBC.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.THIN);
	ARIGHTBC.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
	ARIGHTBC.setWrap(true);	
	
	//中文內文水平垂直置右-正常-格線上下粗右   
	WritableCellFormat ARIGHTBCB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARIGHTBCB.setAlignment(jxl.format.Alignment.RIGHT);
	ARIGHTBCB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARIGHTBCB.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.THIN);
	ARIGHTBCB.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.THIN);
	ARIGHTBCB.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.MEDIUM);
	ARIGHTBCB.setWrap(true);		
	
	//中文內文水平垂直置左-正常-格線   
	WritableCellFormat ALEFTBC = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFTBC.setAlignment(jxl.format.Alignment.LEFT);
	ALEFTBC.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALEFTBC.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALEFTBC.setWrap(true);			

	//logo
	jxl.write.WritableImage image = new jxl.write.WritableImage(col,row,col+2.8,row+2, new File("..//resin-2.1.9//webapps/oradds/jsp/images/logo.png")); 
	ws.addImage(image); 
			
	String strCTitle = "Out-going Quality Inspection Report";
	ws.mergeCells(col, row, col+13, row);     
	ws.addCell(new jxl.write.Label(col, row,strCTitle ,wRptNameES));
	ws.setColumnView(col,60);	
	row++;//列+1
	
	strCTitle = "出 貨 品 質 檢 驗 報 告";
	ws.mergeCells(col, row, col+13, row);     
	ws.addCell(new jxl.write.Label(col, row,strCTitle ,wRptName));
	//ws.setColumnView(col,60);	
	row+=2;//列+1


	ws.setColumnView(col,10);
	ws.setColumnView(col+1,7);
	ws.setColumnView(col+2,10);
	ws.setColumnView(col+3,7);
	ws.setColumnView(col+4,7);
	ws.setColumnView(col+5,7);
	ws.setColumnView(col+6,7);
	ws.setColumnView(col+7,7);
	ws.setColumnView(col+8,7);
	ws.setColumnView(col+9,7);
	ws.setColumnView(col+10,7);
	ws.setColumnView(col+11,7);
	ws.setColumnView(col+12,7);
	ws.setRowView(row,360);	
	ws.setRowView(row+1,360);	
	ws.mergeCells(col, row, col+2, row+1); 
   	ws.addCell(new jxl.write.Label(col, row ,"TYPE:\n"+"型號:   "+ITEM_DESC , ALEFT));
	ws.mergeCells(col+3, row, col+9, row+1); 
   	ws.addCell(new jxl.write.Label(col+3, row ,"PACKING:\n"+"包裝方式:   " , ALEFT));
	String imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/";
	if (TSC_PACKAGE.equals("GBPC"))
	{
		imageFile = imageFile+"yew_bulk.png";
	}
	else if (TSC_PACKAGE.equals("DBL") || TSC_PACKAGE.equals("TO-3P")||TSC_PACKAGE.equals("GBL")||TSC_PACKAGE.equals("GBU")||TSC_PACKAGE.equals("TO-220AB")||TSC_PACKAGE.equals("TO-220AC")||TSC_PACKAGE.equals("ITO-220AB")||TSC_PACKAGE.equals("ITO-220AC")||TSC_PACKAGE.equals("KBJ")
	         ||TSC_PACKAGE.equals("KBJL")||TSC_PACKAGE.equals("TS4B")||TSC_PACKAGE.equals("TS4K")||TSC_PACKAGE.equals("TS-6P")||TSC_PACKAGE.equals("TS-6PN")) 
	{
		imageFile = imageFile+"yew_tube.png";
	}
	else if (TSC_PACKAGE.equals("TS-1") ||TSC_PACKAGE.equals("A-405")||TSC_PACKAGE.equals("DO-41")||TSC_PACKAGE.equals("DO-15")||TSC_PACKAGE.equals("DO-201")||TSC_PACKAGE.equals("DO-201AD")||TSC_PACKAGE.equals("P2500")||TSC_PACKAGE.equals("R-6"))
	{
		if (TSC_PACKING_CODE.startsWith("A0"))
		{
			imageFile = imageFile+"yew_tape_bulk.png";
		}
		else if (TSC_PACKING_CODE.startsWith("X0") || TSC_PACKING_CODE.startsWith("B0"))
		{
			imageFile = imageFile+"yew_bulk.png";
		}
		else
		{
			imageFile = imageFile+"yew_tape_reel.png";
		}
	}
	else
	{
		imageFile = imageFile+"yew_tape_reel.png";
	}

	File f = new File(imageFile);
	if(f.exists()) 
	{
		jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+3+1.5, row+0.25,5.2,1.7, f); 
		ws.addImage(image1);
	}	
	ws.mergeCells(col+10, row, col+13, row+1); 
   	ws.addCell(new jxl.write.Label(col+10, row ,"RESULT:\n" +"判定結果:", ALEFT));
	imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/yew_acc.png";
	f = new File(imageFile);
	if(f.exists()) 
	{
		jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+10+1.2, row+0.25,2.7,1.7, f); 
		ws.addImage(image1);
	}
	row+=2;//列+1

	ws.setRowView(row,360);	
	ws.setRowView(row+1,360);	
	ws.mergeCells(col, row, col+2, row+1); 
   	ws.addCell(new jxl.write.Label(col, row ,"INSPECTOR:\n"+"檢驗者: "+V_USER_CNAME , ALEFT));
	ws.mergeCells(col+3, row, col+6, row+1); 
   	ws.addCell(new jxl.write.Label(col+3, row ,"SHIFT:\n"+"班別:   " , ALEFT));
	imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/yew_shift.png";
	f = new File(imageFile);
	if(f.exists()) 
	{
		jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+3+0.9, row+0.25,2.8,1.6, f); 
		ws.addImage(image1);
	}	
	ws.mergeCells(col+7, row, col+9, row+1); 
   	ws.addCell(new jxl.write.Label(col+7, row ,"DATE:\n"+"檢驗日期:  "+DOC_DATE , ALEFT));
	ws.mergeCells(col+10, row, col+13, row+1); 
   	ws.addCell(new jxl.write.Label(col+10, row ,"CHECKED BY:\n"+"審核: 戚雪萍" , ALEFT));
	row+=2;//列+1
	
	col=0;
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row+1); 
   	ws.addCell(new jxl.write.Label(col, row ,"Run card NO:\n(流程卡編號)" , ACENTREBLT));	
	ws.mergeCells(col+3, row, col+6, row+1); 
   	ws.addCell(new jxl.write.Label(col+3, row ,LOT_NO_LIST , ACENTREBT));	
	ws.mergeCells(col+7, row, col+9, row+1); 
   	ws.addCell(new jxl.write.Label(col+7, row ,"Shipping Mark:\n(運輸標誌)" , ACENTREBT));	
	ws.mergeCells(col+10, row, col+13, row+1); 
   	ws.addCell(new jxl.write.Label(col+10, row ,SHIPPING_MARKS , ACENTREBRT));
	row+=2;//列+1	

	col=0;
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row+1); 
   	ws.addCell(new jxl.write.Label(col, row ,"Quantity:\n(送  檢  量)" , ACENTREBLB));	
	ws.mergeCells(col+3, row, col+6, row+1); 
   	ws.addCell(new jxl.write.Label(col+3, row ,SHIP_QTY+(!SHIP_QTY.equals("")?"K":"") , ACENTREBB));	
	ws.mergeCells(col+7, row, col+9, row+1); 
   	ws.addCell(new jxl.write.Label(col+7, row ,"Manufacture Order NO:\n(訂單號碼)" , ACENTREBB));	
	ws.mergeCells(col+10, row, col+13, row+1); 
   	ws.addCell(new jxl.write.Label(col+10, row ,SONO , ACENTREBRB));	
	row+=3;//列+1	
	
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"AQL 允收水準" , ACENTREBLT));	
	ws.mergeCells(col+3, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"驗證水準 VL" , ACENTREBT));	
	ws.mergeCells(col+7, row, col+8, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"ACC" , ACENTREBT));	
	ws.mergeCells(col+9, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+9, row ,"REJ" , ACENTREBT));	
	ws.mergeCells(col+11, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+11, row ,"Sample Size(取樣數)" , ACENTREBRT));	
	row++;//列+1
	
	ws.setRowView(row,350);	
	ws.setRowView(row+1,350);
	ws.mergeCells(col, row, col+2, row+1); 
	ws.addCell(new jxl.write.Label(col, row ,"ELEC AQL(電性允收水準)\n依MIL-STD-1916 ACC/REJ=0/1" , ACENTREBL));	
	ws.mergeCells(col+3, row, col+6, row+1); 
	ws.addCell(new jxl.write.Label(col+3, row ,"VL=IV" , ACENTREB));	
	ws.mergeCells(col+7, row, col+8, row+1); 
	ws.addCell(new jxl.write.Label(col+7, row ,"0" , ACENTREB));	
	ws.mergeCells(col+9, row, col+10, row+1); 
	ws.addCell(new jxl.write.Label(col+9, row ,"1" , ACENTREB));	
	ws.mergeCells(col+11, row, col+13, row+1); 
	ws.addCell(new jxl.write.Label(col+11, row ,"50    PCS" , ACENTREBR));	
	row+=2;//列+1
	
	ws.setRowView(row,350);	
	ws.setRowView(row+1,350);
	ws.mergeCells(col, row, col+2, row+1); 
	ws.addCell(new jxl.write.Label(col, row ,"V/M AQL外觀允收水準\n依MIL-STD-1916 ACC/REJ=0/1" , ACENTREBL));	
	ws.mergeCells(col+3, row, col+6, row+1); 
	ws.addCell(new jxl.write.Label(col+3, row ,"VL=IV" , ACENTREB));	
	ws.mergeCells(col+7, row, col+8, row+1); 
	ws.addCell(new jxl.write.Label(col+7, row ,"0", ACENTREB));	
	ws.mergeCells(col+9, row, col+10, row+1); 
	ws.addCell(new jxl.write.Label(col+9, row ,"1", ACENTREB));	
	ws.mergeCells(col+11, row, col+13, row+1); 
	if ( SHIP_QTY_PCE<=960)
	{
		ws.addCell(new jxl.write.Label(col+11, row ,"80     PCS", ACENTREBR));	
	}
	else if (SHIP_QTY_PCE<=1632)
	{
		ws.addCell(new jxl.write.Label(col+11, row ,"96     PCS", ACENTREBR));	
	}
	else if (SHIP_QTY_PCE<=3072)
	{
		ws.addCell(new jxl.write.Label(col+11, row ,"128    PCS", ACENTREBR));	
	}
	else if (SHIP_QTY_PCE<=5440)
	{
		ws.addCell(new jxl.write.Label(col+11, row ,"160    PCS", ACENTREBR));	
	}
	else
	{
		ws.addCell(new jxl.write.Label(col+11, row ,"192    PCS", ACENTREBR));	
	}
	row+=2;//列+1
		
	ws.setRowView(row,350);	
	ws.setRowView(row+1,350);
	ws.mergeCells(col, row, col+2, row+1); 
	ws.addCell(new jxl.write.Label(col, row ,"Dimension(尺寸量測)\nMIL-S-19500J LTPD抽樣" , ACENTREBLB));	
	ws.mergeCells(col+3, row, col+4, row+1); 
	ws.addCell(new jxl.write.Label(col+3, row ,"LTPD=10" , ACENTREBB));	
	ws.mergeCells(col+5, row, col+6, row+1); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0 收 1 退" , ACENTREBB));	
	ws.mergeCells(col+7, row, col+9, row+1); 
	ws.addCell(new jxl.write.Label(col+7, row ,"Solderability(沾錫性)" , ACENTREBB));
	ws.mergeCells(col+10, row, col+11, row+1); 
	ws.addCell(new jxl.write.Label(col+10, row ,"LTPD=  10" , ACENTREBB));
	ws.mergeCells(col+12, row, col+13, row+1); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0 收 1 退" ,ACENTREBRB));
	row+=3;//列+1
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Appearance Inspection (外觀檢驗)" , ACENTREBLRT));	
	ws.mergeCells(col+7, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"Electrical Test Spec.(電性測試規格)" , ACENTREBLRT));	
	row++;//列+1	
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Defect Items(缺點項目)" , ACENTREBL));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"Quantity(數量)" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+8, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"Item" , ACENTREB));	
	ws.mergeCells(col+9, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+9, row ,"Test Conditions" , ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"MIN" , ACENTREB));	
	ws.mergeCells(col+13, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+13, row ,"MAX" , ACENTREBR));	
	row++;//列+1
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"No marking" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(無印字)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+8, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[0][0] , ACENTREB));	
	ws.mergeCells(col+9, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+9, row ,v_electrical_spec[0][1] , ALEFTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[0][2] , ACENTREB));	
	ws.mergeCells(col+13, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+13, row ,v_electrical_spec[0][3] , ACENTREBR));	
	row++;//列+1		

	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Internal Exposure" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(結構外露)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+8, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[1][0] , ACENTREB));	
	ws.mergeCells(col+9, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+9, row ,v_electrical_spec[1][1], ALEFTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row , v_electrical_spec[1][2] , ACENTREB));	
	ws.mergeCells(col+13, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+13, row ,v_electrical_spec[1][3] , ACENTREBR));	
	row++;//列+1		

	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Shortage" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(數量短少)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+8, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[2][0] , ACENTREB));	
	ws.mergeCells(col+9, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+9, row ,v_electrical_spec[2][1], ALEFTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row , v_electrical_spec[2][2] , ACENTREB));	
	ws.mergeCells(col+13, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+13, row ,v_electrical_spec[2][3] , ACENTREBR));	
	row++;//列+1		
			
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Mix Type" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(型號混料)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+8, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[3][0], ACENTREB));	
	ws.mergeCells(col+9, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+9, row ,v_electrical_spec[3][1], ALEFTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row , v_electrical_spec[3][2] , ACENTREB));	
	ws.mergeCells(col+13, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+13, row ,v_electrical_spec[3][3] , ACENTREBR));	
	row++;//列+1
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+1, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Reverse(Reel)" , ALEFTB));	
	ws.mergeCells(col+2, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+2, row ,"包裝材料反向(捲裝)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+8, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[4][0], ACENTREB));	
	ws.mergeCells(col+9, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+9, row ,v_electrical_spec[4][1],ALEFTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row , v_electrical_spec[4][2] , ACENTREB));	
	ws.mergeCells(col+13, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+13, row ,v_electrical_spec[4][3] , ACENTREBR));	
	row++;//列+1			
			
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Dimension Out Of SPEC" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(尺寸不符)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"Defect Items(缺點項目)" , ACENTREBL));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"Quantity(數量)", ACENTREBRT));	
	row++;//列+1		
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Poor Solderability" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(焊鍚不良)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"Open" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"(開路)", ARIGHTBC));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row , "0" , ACENTREBR));	
	row++;//列+1	
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Poor Forming" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(彎腳不良)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"Short" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"(短路)", ARIGHTBC));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1							
			
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Poor Tapping" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(捲裝膠帶不良)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"Reverse Polarity" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"(極性反向)", ARIGHTBC));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1	

	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Structure Misalignment" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(結構不正)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"Reverse Stability" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"(逆向穩定度)", ARIGHTBC));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1	

	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Poor Marking" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(印字不良)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"Mix Products" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"(產品混料)", ARIGHTBC));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1

	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+1, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Crack/Void/Chip" , ALEFTB));	
	ws.mergeCells(col+2, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+2, row ,"(膠体裂痕/氣孔/缺角)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"Poor Isolation" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"(絕緣不良)", ARIGHTBC));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1

	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+1, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Body Burr" , ALEFTB));	
	ws.mergeCells(col+2, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+2, row ,"(殘膠/毛頭/毛邊)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"VF" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"(順向壓降)", ARIGHTBC));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Body Shift" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(膠体錯位/撮膠)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"PIV" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"(逆向峰值壓降)", ARIGHTBC));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1	
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Flash" , ALEFTB));	
	ws.mergeCells(col+1, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+1, row ,"(沾膠/溢膠/膠量過多/膠量過少)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"IR" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"(逆向漏電流)", ARIGHTBC));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Lead Damage" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(引線損傷/刮傷)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"TRR" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"(逆向回覆時間)", ARIGHTBC));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Lead Bend" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(引線彎曲/扭曲)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"ZZK" , ALEFTB));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1	
		
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Copper Exposed" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(露銅/電鍍不良)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"ZZT" , ALEFTB));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0", ACENTREBR));	
	row++;//列+1			

	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Poor Package/Body" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(外殼/膠体不良)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"" , ACENTREB));	
	ws.mergeCells(col+12, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"", ACENTREBR));	
	row++;//列+1	


	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Poor Lead/Band" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(引線/色帶不良)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,"Marking(印碼)" , ACENTREBLT));	
	ws.mergeCells(col+10, row, col+13, row); 	
	ws.addCell(new jxl.write.Label(col+10, row ,"Remark (備注)" , ACENTREBRT));	
	row++;//列+1	
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+1, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Potting&Pin Defect" , ALEFTB));	
	ws.mergeCells(col+2, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+2, row ,"(灌膠及散熱片不良)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row+4); 	
	if (UNDERLINE_FLAG.equals("Y")) 
	{
		ws.addCell(new jxl.write.Label(col+7, row ,"", ACENTREBLB));	
		imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/"+TSC_PARTNO+".PNG";
		f = new File(imageFile);
		if(f.exists()) 
		{
			jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+7+0.5, row+0.9,1.5,2.5, f); 
			ws.addImage(image1);
		}
	}
	else
	{	
		ws.addCell(new jxl.write.Label(col+7, row ,MARKING_CODE, ACENTREBLB));	
	}
	ws.mergeCells(col+10, row, col+13, row+4); 	
	ws.addCell(new jxl.write.Label(col+10, row ,"" , ACENTREBRB));	
	row++;//列+1
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Label error" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(標簽錯誤)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));
	row++;//列+1

	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Poor Carry/ Cover" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(膠殼/膠膜不良)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));
	row++;//列+1
	
	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Side turned over" , ALEFTB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(側立)" , ARIGHTBC));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBR));
	row++;//列+1	

	ws.setRowView(row,360);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"Vacancy abnormal" ,ALEFTBB));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"(空格異常)" , ARIGHTBCB));	
	ws.mergeCells(col+5, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREBB));
	row++;//列+1
		
	ws.setRowView(row,400);	
	ws.mergeCells(col, row, col+13, row); 
	ws.addCell(new jxl.write.Label(col, row ,"*** The copyright of document and business secret belong to TSC, and no copies should be made without any permission ***（YQ4QC92-G）", wRptEnd));	
	row++;//列+1
										
	wwb.write(); 
	wwb.close();
	os.close();  
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
try
{
	response.reset();
	response.setContentType("application/vnd.ms-excel");	
	String strURL = "/oradds/report/"+FileName; 
	//String fileURL = new String(strURL.getBytes("UTF-8"),"ISO8859-1");
	//response.sendRedirect(fileURL);
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
