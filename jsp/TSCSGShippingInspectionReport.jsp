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
<FORM ACTION="../jsp/TSCSGShippingInspectionReport.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",sql="",SHIP_QTY="",SHIPPING_MARKS="",TSC_PARTNO="",TSC_PACKING_CODE="",TSC_PARTNO1="",TSC_ITEM_NOPACKING="",PC_SSD="",v_file_name="";
String CHKPRTNAME = request.getParameter("CHK_RPT_NAME");
String ELECTRICAL_MAJOR_1="",ELECTRICAL_MAJOR_2="",APPEARANCE_NUM="",ELECTRICAL_SAMPLE_SIZE="",APPEARANCE_MAJOR_1="",APPEARANCE_MAJOR_2="",APPEARANCE_SAMPLE_SIZE="",MARKING_CODE="";
String v_electrical_spec[][]=new String[10][4];
String v_electrical_item[][]=new String[10][2];
int fontsize=10,colcnt=0,v_line=0,v_line_cnt=0;

try 
{ 	
	sql = " SELECT distinct a.item_desc"+
	      ",sum(a.SHIP_QTY) over (partition by a.CHK_RPT_NAME)/1000 SHIP_QTY"+
	      ",a.SHIPPING_REMARK"+
		  ",TSC_get_partno(?,a.inventory_item_id) tsc_partno"+
		  ",tsc_get_item_packing_code(?,a.inventory_item_id) packing_code"+
		  ",tsc_inv_category(a.inventory_item_id,?,?) tsc_partno1"+
		  ",tsc_get_item_desc_nopacking(? ,a.inventory_item_id) tsc_item_nopacking"+
		  //",(select marking from oraddman.tssg_product_marking x where x.tsc_partno=TSC_get_partno(?,inventory_item_id)) marking"+
          ",nvl(nvl((select marking from oraddman.tssg_product_marking x where x.tsc_partno=tsc_get_item_desc_nopacking(? ,a.inventory_item_id)),(select marking from oraddman.tssg_product_marking x where x.tsc_partno=case when instr(a.item_desc,'ABS8-03')>0 then 'ABS8-K' else TSC_get_partno(?,a.inventory_item_id) end)),(select marking from oraddman.tssg_product_marking x where x.tsc_partno=tsc_inv_category(a.inventory_item_id,?,?))) marking"+//modify by Peggy 20210302
		  ",to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE"+
		  ",a.CHK_RPT_NAME,a.CHK_PAPER_RPT_NAME"+
          " FROM tsc.tsc_shipping_advise_pc_sg a"+
          //" where a.CHK_RPT_NAME=?";
		  //" where a.pc_advise_id=b.pc_advise_id"+
		  " where exists (select 1 from tsc.tsc_shipping_advise_pc_sg b "+
		  " where a.CHK_RPT_NAME=b.CHK_RPT_NAME"+
		  " and ? in (b.CHK_RPT_NAME,to_char(b.PC_ADVISE_ID)))";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"43");
	statement.setString(2,"43");
	statement.setString(3,"43");
	statement.setString(4,"24");
	statement.setString(5,"43");
	statement.setString(6,"43");
	statement.setString(7,"43");
	statement.setString(8,"43");
	statement.setString(9,"24");
	statement.setString(10,CHKPRTNAME);
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{	
		SHIP_QTY=rs.getString("SHIP_QTY");
		SHIPPING_MARKS=rs.getString("SHIPPING_REMARK");
		TSC_PARTNO=rs.getString("tsc_partno");
		if (rs.getString("item_desc").startsWith("ABS8-03")) TSC_PARTNO="ABS8-K";
		TSC_PACKING_CODE=rs.getString("packing_code");
		if (TSC_PACKING_CODE.startsWith("QQ")) TSC_PACKING_CODE=""; //add by Peggy 20210623
		TSC_PARTNO1=rs.getString("tsc_partno1");
		TSC_ITEM_NOPACKING=rs.getString("tsc_item_nopacking");
		MARKING_CODE=rs.getString("marking");
		if (MARKING_CODE==null) MARKING_CODE="";
		PC_SSD=rs.getString("PC_SCHEDULE_SHIP_DATE");
		if (rs.getString("CHK_RPT_NAME").equals(CHKPRTNAME))
		{
			v_file_name=CHKPRTNAME;
		}
		else
		{	
			v_file_name=rs.getString("CHK_PAPER_RPT_NAME");
		}
	}	
	rs.close();
	statement.close();
	
	sql = " SELECT a.tsc_partno, a.tsc_outline, a.item_value, a.conditions_value,a.min_value, a.max_value"+
	      ",row_number() over (partition by a.tsc_partno,a.item_value order by a.max_value) row_seq "+
          //",case when TSC_PROD_GROUP='SSD' then a.item_value else  substr(a.item_value,1,instr(a.item_value,'(')-1) end item_value1 "+
		  //",substr(a.item_value,1,instr(a.item_value,'(')-1) item_value1 "+
          ",case when tsc_prod_group='SSD' then item_value else substr(a.item_value,1,instr(a.item_value,'(')-1) end item_value1 "+
          " FROM oraddman.tssg_product_electrical_list a"+
          " WHERE TSC_PARTNO=?"+
          " ORDER BY case when TSC_PROD_GROUP='SSD' THEN RANK_NUM ELSE DECODE(ITEM_VALUE,'VF(V)',1,'IR(uA)',2,3) END,MAX_VALUE";
	statement = con.prepareStatement(sql);
	statement.setString(1,TSC_ITEM_NOPACKING);
	rs=statement.executeQuery();
	v_line=0;v_line_cnt=0;
	while (rs.next())
	{	
		v_electrical_spec[v_line][0]=rs.getString("item_value");
		v_electrical_spec[v_line][1]=rs.getString("conditions_value");
		v_electrical_spec[v_line][2]=rs.getString("min_value");
		v_electrical_spec[v_line][3]=(rs.getString("max_value")==null?"":rs.getString("max_value"));
		if (rs.getInt("row_seq")==1)
		{
			v_electrical_item[v_line_cnt][0]=(rs.getString("item_value1")==null?"":rs.getString("item_value1"));
			v_electrical_item[v_line_cnt][1]=(v_electrical_item[v_line_cnt][0].equals("TRR") && v_electrical_spec[v_line][3].equals("\\")?(v_electrical_spec[v_line][3]==null?"0":v_electrical_spec[v_line][3]):"0");
			v_line_cnt++;		
		}
		v_line++;
	}	
	rs.close();
	statement.close();	
	
	if (v_line==0)
	{
		sql = " SELECT a.tsc_partno, a.tsc_outline, a.item_value, a.conditions_value,a.min_value, a.max_value"+
			  ",row_number() over (partition by a.tsc_partno,a.item_value order by a.max_value) row_seq "+
			  //",case when TSC_PROD_GROUP='SSD' then a.item_value else  substr(a.item_value,1,instr(a.item_value,'(')-1) end item_value1 "+
		      //",substr(a.item_value,1,instr(a.item_value,'(')-1) item_value1 "+
              ",case when tsc_prod_group='SSD' then item_value else substr(a.item_value,1,instr(a.item_value,'(')-1) end item_value1 "+
			  " FROM oraddman.tssg_product_electrical_list a"+
			  " WHERE TSC_PARTNO=?"+
			  //" ORDER BY DECODE(ITEM_VALUE,'VF(V)',1,'IR(uA)',2,3),MAX_VALUE";
			  " ORDER BY case when TSC_PROD_GROUP='SSD' THEN RANK_NUM ELSE DECODE(ITEM_VALUE,'VF(V)',1,'IR(uA)',2,3) END,MAX_VALUE";
		statement = con.prepareStatement(sql);
		statement.setString(1,TSC_PARTNO);
		rs=statement.executeQuery();
		v_line=0;v_line_cnt=0;
		while (rs.next())
		{	
			v_electrical_spec[v_line][0]=rs.getString("item_value");
			v_electrical_spec[v_line][1]=rs.getString("conditions_value");
			v_electrical_spec[v_line][2]=rs.getString("min_value");
			v_electrical_spec[v_line][3]=(rs.getString("max_value")==null?"":rs.getString("max_value"));
			if (rs.getInt("row_seq")==1)
			{
				v_electrical_item[v_line_cnt][0]=(rs.getString("item_value1")==null?"":rs.getString("item_value1"));
				v_electrical_item[v_line_cnt][1]=(v_electrical_item[v_line_cnt][0].equals("TRR") && v_electrical_spec[v_line][3].equals("\\")?(v_electrical_spec[v_line][3]==null?"0":v_electrical_spec[v_line][3]):"0");
				v_line_cnt++;		
			}
			v_line++;
		}	
		rs.close();
		statement.close();		
	}
		
	if (v_line==0)
	{
		sql = " SELECT a.tsc_partno, a.tsc_outline, a.item_value, a.conditions_value,a.min_value, a.max_value"+
			  ",row_number() over (partition by a.tsc_partno,a.item_value order by a.max_value) row_seq "+
			  //",case when TSC_PROD_GROUP='SSD' then a.item_value else substr(a.item_value,1,instr(a.item_value,'(')-1) end item_value1 "+
			  ",substr(a.item_value,1,instr(a.item_value,'(')-1) item_value1 "+
			  " FROM oraddman.tssg_product_electrical_list a"+
			  " WHERE TSC_PARTNO=?"+
			  //" ORDER BY DECODE(ITEM_VALUE,'VF(V)',1,'IR(uA)',2,3),MAX_VALUE";
			  " ORDER BY case when TSC_PROD_GROUP='SSD' THEN RANK_NUM ELSE DECODE(ITEM_VALUE,'VF(V)',1,'IR(uA)',2,3) END,MAX_VALUE";
		statement = con.prepareStatement(sql);
		statement.setString(1,TSC_PARTNO1);
		rs=statement.executeQuery();
		v_line=0;v_line_cnt=0;
		while (rs.next())
		{	
			v_electrical_spec[v_line][0]=rs.getString("item_value");
			v_electrical_spec[v_line][1]=rs.getString("conditions_value");
			v_electrical_spec[v_line][2]=rs.getString("min_value");
			v_electrical_spec[v_line][3]=(rs.getString("max_value")==null?"":rs.getString("max_value"));
			if (rs.getInt("row_seq")==1)
			{
				v_electrical_item[v_line_cnt][0]=rs.getString("item_value1");
				//v_electrical_item[v_line_cnt][1]="";
				v_electrical_item[v_line_cnt][1]=(v_electrical_item[v_line_cnt][0].equals("TRR") && v_electrical_spec[v_line][3].equals("\\")?(v_electrical_spec[v_line][3]==null?"0":v_electrical_spec[v_line][3]):"0");
				v_line_cnt++;		
			}
			v_line++;
		}	
		rs.close();
		statement.close();	
	}	  
	
	int row =0,col=0,totcnt=0,reccnt=0,mergeCol=0;
	String advise_no="";
	OutputStream os = null;	
	//FileName = CHKPRTNAME;
	FileName = v_file_name;
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ 
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("檢驗報告", 0);  
	SheetSettings settings = ws.getSettings();//取得分頁環境設定(如:標頭/標尾,分頁,欄長,欄高等設定
	settings.setZoomFactor(100);    //顯示縮放比例
	//settings.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
	settings.setScaleFactor(88);   // 打印縮放比例
	settings.setHeaderMargin(0.3);
	settings.setBottomMargin(0.2);
	settings.setLeftMargin(0.5);
	settings.setRightMargin(0.3);
	settings.setTopMargin(0.3);
	settings.setFooterMargin(0.3);	
	
	//報表名稱平行置中-中文    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 14, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName.setAlignment(jxl.format.Alignment.CENTRE);

	//報表名稱平行置中-英文    
	WritableCellFormat wRptNameE = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), 12, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptNameE.setAlignment(jxl.format.Alignment.CENTRE);

	//報表名稱平行置中-英文    
	WritableCellFormat wRptNameES = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptNameES.setAlignment(jxl.format.Alignment.CENTRE);

	//表尾行置中     
	WritableCellFormat wRptEnd = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), 8 , WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
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
	
	//中文內文水平垂直置左-正常-格線   
	WritableCellFormat ALEFTBC = new WritableCellFormat(new WritableFont(WritableFont.createFont("Times New Roman"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFTBC.setAlignment(jxl.format.Alignment.LEFT);
	ALEFTBC.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALEFTBC.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALEFTBC.setWrap(true);			

	String strCTitle = "TAIWAN SEMICONDUCTOR CO.,LTD.";
	ws.mergeCells(col, row, col+12, row);     
	ws.addCell(new jxl.write.Label(col, row,strCTitle ,wRptNameE));
	//ws.setColumnView(col,60);	
	row++;//列+1
	
	strCTitle = "出 貨 檢 驗 報 告 表";
	ws.mergeCells(col, row, col+12, row);     
	ws.addCell(new jxl.write.Label(col, row,strCTitle ,wRptName));
	//ws.setColumnView(col,60);	
	row++;//列+1

	strCTitle = "Outgoing Inspection Report";
	ws.mergeCells(col+3, row, col+8, row);     
	ws.addCell(new jxl.write.Label(col+3, row,strCTitle ,wRptNameES));
	ws.mergeCells(col+10, row, col+12, row);     
	ws.addCell(new jxl.write.Label(col+10, row,"NO:",ALEFTC));
	//ws.setRowView(col,60);	
	row++;//列+1

	ws.setRowView(row,350);	
	ws.setColumnView(col,10);
	ws.setColumnView(col+1,7);
	ws.setColumnView(col+2,10);
	ws.setColumnView(col+3,7);
	ws.setColumnView(col+4,7);
	ws.setColumnView(col+5,7);
	ws.setColumnView(col+6,7);
	ws.setColumnView(col+7,12);
	ws.setColumnView(col+8,9);
	ws.setColumnView(col+9,8);
	ws.setColumnView(col+10,7);
	ws.setColumnView(col+11,7);
	ws.setColumnView(col+12,7);
	ws.mergeCells(col, row, col+2, row+1); 
   	ws.addCell(new jxl.write.Label(col, row ,"TYPE:\n"+"型號:   "+TSC_ITEM_NOPACKING , ALEFT));
	ws.mergeCells(col+3, row, col+6, row+1); 
   	ws.addCell(new jxl.write.Label(col+3, row ,"PACKING:\n"+"包裝方式:   "+TSC_PACKING_CODE , ALEFT));
	ws.mergeCells(col+7, row, col+8, row+1); 
   	ws.addCell(new jxl.write.Label(col+7, row ,"SHIFT:\n"+"班別:   1ST" , ALEFT));
	ws.mergeCells(col+9, row, col+12, row+1); 
   	ws.addCell(new jxl.write.Label(col+9, row ,"RESULT:\n" +"判定結果:  ACC", ALEFT));
	if (v_file_name.equals(CHKPRTNAME))
	{	
		jxl.write.WritableImage image = new jxl.write.WritableImage(col+11,row,1.6,3.8, new File("..//resin-2.1.9//webapps/oradds/jsp/images/tew_qc_pass.png")); 
		ws.addImage(image);	
	}
	row+=2;//列+1

	/*ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row); 
   	ws.addCell(new jxl.write.Label(col, row ,"型號:   "+TSC_PARTNO , ALEFTC));
	ws.mergeCells(col+3, row, col+5, row); 
   	ws.addCell(new jxl.write.Label(col+3, row ,"包裝方式:   "+TSC_PACKING_CODE , ALEFTC));
	ws.mergeCells(col+6, row, col+8, row); 
   	ws.addCell(new jxl.write.Label(col+6, row ,"班別:   1ST" , ALEFTC));
	ws.mergeCells(col+9, row, col+12, row); 
   	ws.addCell(new jxl.write.Label(col+9, row ,"判定結果:" , ALEFTC));
	row++;//列+1*/

	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row+1); 
   	ws.addCell(new jxl.write.Label(col, row ,"INSPECTOR:\n"+"檢驗者:" , ALEFT));
	ws.mergeCells(col+3, row, col+6, row+1); 
   	ws.addCell(new jxl.write.Label(col+3, row ,"DATE:\n"+"日期:   "+PC_SSD , ALEFT));
	ws.mergeCells(col+7, row, col+8, row+1); 
   	ws.addCell(new jxl.write.Label(col+7, row ,"TIME:\n"+"時間:   "+(dateBean.getHour()<8?"08":(dateBean.getHour()>16?"16":dateBean.getHourString()))+":"+dateBean.getMinuteString() , ALEFT));
	ws.mergeCells(col+9, row, col+12, row+1); 
   	ws.addCell(new jxl.write.Label(col+9, row ,"CHECK BY:\n"+"審核者:" , ALEFT));
	row+=2;//列+1
	
	/*ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row); 
   	ws.addCell(new jxl.write.Label(col, row ,"檢驗者:" , ALEFTC));
	ws.mergeCells(col+3, row, col+5, row); 
   	ws.addCell(new jxl.write.Label(col+3, row ,"日期:" , ALEFTC));
	ws.mergeCells(col+6, row, col+8, row); 
   	ws.addCell(new jxl.write.Label(col+6, row ,"時間:" , ALEFTC));
	ws.mergeCells(col+9, row, col+12, row); 
   	ws.addCell(new jxl.write.Label(col+9, row ,"審核者:" , ALEFTC));
	row++;//列+1	*/
	
	col=0;
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row+1); 
   	ws.addCell(new jxl.write.Label(col, row ,"BACK PROCESS CARD\n后段流程卡" , ACENTREBLT));	
	ws.mergeCells(col+3, row, col+4, row+1); 
   	ws.addCell(new jxl.write.Label(col+3, row ,"" , ACENTREBT));	
	ws.mergeCells(col+5, row, col+6, row+1); 
   	ws.addCell(new jxl.write.Label(col+5, row ,"" , ACENTREBT));	
	ws.mergeCells(col+7, row, col+8, row+1); 
   	ws.addCell(new jxl.write.Label(col+7, row ,"" , ACENTREBT));	
	ws.mergeCells(col+9, row, col+10, row+1); 
   	ws.addCell(new jxl.write.Label(col+9, row ,"" , ACENTREBT));	
	ws.mergeCells(col+11, row, col+12, row+1); 
   	ws.addCell(new jxl.write.Label(col+11, row ,"" , ACENTREBRT));
	row+=2;//列+1	

	col=0;
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row+1); 
   	ws.addCell(new jxl.write.Label(col, row ,"QTY\n送  檢  量" , ACENTREBL));	
	ws.mergeCells(col+3, row, col+4, row+1); 
   	ws.addCell(new jxl.write.Label(col+3, row ,SHIP_QTY+(!SHIP_QTY.equals("")?"K":"") , ACENTREB));	
	ws.mergeCells(col+5, row, col+6, row+1); 
   	ws.addCell(new jxl.write.Label(col+5, row ,"" , ACENTREB));	
	ws.mergeCells(col+7, row, col+8, row+1); 
   	ws.addCell(new jxl.write.Label(col+7, row ,"" , ACENTREB));	
	ws.mergeCells(col+9, row, col+10, row+1); 
   	ws.addCell(new jxl.write.Label(col+9, row ,"" , ACENTREB));	
	ws.mergeCells(col+11, row, col+12, row+1); 
   	ws.addCell(new jxl.write.Label(col+11, row ,"" , ACENTREBR));	
	row+=2;//列+1	
	
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row+1); 
   	ws.addCell(new jxl.write.Label(col, row ,"LOT NO\n晶 片 批 號" , ACENTREBLB));	
	ws.mergeCells(col+3, row, col+4, row+1); 
   	ws.addCell(new jxl.write.Label(col+3, row ,"" , ACENTREBB));	
	ws.mergeCells(col+5, row, col+6, row+1); 
   	ws.addCell(new jxl.write.Label(col+5, row ,"" , ACENTREBB));	
	ws.mergeCells(col+7, row, col+8, row+1); 
   	ws.addCell(new jxl.write.Label(col+7, row ,"" , ACENTREBB));	
	ws.mergeCells(col+9, row, col+10, row+1); 
   	ws.addCell(new jxl.write.Label(col+9, row ,"" , ACENTREBB));	
	ws.mergeCells(col+11, row, col+12, row+1); 
   	ws.addCell(new jxl.write.Label(col+11, row ,"" , ACENTREBRB));	
	row+=3;//列+2	
	
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"" , ACENTREBLT));	
	ws.mergeCells(col+3, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"CRITICAL    嚴重" , ACENTREBT));	
	ws.mergeCells(col+7, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"MAJOR    主要" , ACENTREBT));	
	ws.mergeCells(col+11, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+11, row ,"S/S取樣數" , ACENTREBRT));	
	row++;//列+1
	
	
	sql = " select * from oraddman.tssg_product_sample_size a "+
	      " where nvl(a.inactive_date,to_date('20990101','yyyymmdd'))>trunc(sysdate)"+
		  " and ? between nvl(a.min_qty,0.001) and nvl(a.max_qty,9999999)";
	PreparedStatement statement1 = con.prepareStatement(sql);
	statement1.setString(1,SHIP_QTY);
	ResultSet rs1=statement1.executeQuery();
	if (rs1.next())
	{	
		ELECTRICAL_MAJOR_1=rs1.getString("ELECTRICAL_MAJOR_1");
		ELECTRICAL_MAJOR_2=rs1.getString("ELECTRICAL_MAJOR_2");
		APPEARANCE_NUM=rs1.getString("APPEARANCE_NUM");
		ELECTRICAL_SAMPLE_SIZE=rs1.getString("ELECTRICAL_SAMPLE_SIZE");
		APPEARANCE_MAJOR_1=rs1.getString("APPEARANCE_MAJOR_1");
		APPEARANCE_MAJOR_2=rs1.getString("APPEARANCE_MAJOR_2");
		APPEARANCE_SAMPLE_SIZE=rs1.getString("APPEARANCE_SAMPLE_SIZE");
	}	
	rs1.close();
	statement1.close();		
		
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"ELEC AQL電性允收水準" , ACENTREBL));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"" , ACENTREB));	
	ws.mergeCells(col+5, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"1" , ACENTREB));	
	ws.mergeCells(col+7, row, col+8, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"" , ACENTREB));	
	ws.mergeCells(col+9, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+9, row ,ELECTRICAL_MAJOR_1 , ACENTREB));	
	ws.mergeCells(col+10, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,ELECTRICAL_MAJOR_2 , ACENTREB));	
	ws.mergeCells(col+11, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+11, row ,ELECTRICAL_SAMPLE_SIZE , ACENTREBR));	
	row++;//列+1
	
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"MECH AQL外觀允收水準" , ACENTREBL));	
	ws.mergeCells(col+3, row, col+4, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"" , ACENTREB));	
	ws.mergeCells(col+5, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+5, row ,"0" , ACENTREB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"1" , ACENTREB));	
	ws.mergeCells(col+7, row, col+8, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,APPEARANCE_NUM , ACENTREB));	
	ws.mergeCells(col+9, row, col+9, row); 
	ws.addCell(new jxl.write.Label(col+9, row ,APPEARANCE_MAJOR_1, ACENTREB));	
	ws.mergeCells(col+10, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,APPEARANCE_MAJOR_2, ACENTREB));	
	ws.mergeCells(col+11, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+11, row ,APPEARANCE_SAMPLE_SIZE , ACENTREBR));		
	row++;//列+1
		
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+2, row+1); 
	ws.addCell(new jxl.write.Label(col, row ,"DIMESION         尺寸" , ACENTREBLB));	
	ws.mergeCells(col+3, row, col+6, row+1); 
	ws.addCell(new jxl.write.Label(col+3, row ,"LTPD=10" , ACENTREBB));	
	ws.mergeCells(col+7, row, col+10, row+1); 
	ws.addCell(new jxl.write.Label(col+7, row ,ELECTRICAL_MAJOR_1+" 收 "+ELECTRICAL_MAJOR_2+" 退\nACC   REJ" , ACENTREBB));	
	ws.mergeCells(col+11, row, col+12, row+1); 
	ws.addCell(new jxl.write.Label(col+11, row ,"22" , ACENTREBRB));
	row+=3;//列+1
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col, row ,"MECHANICAL INSPECTION     外觀檢驗" , ACENTREBLRT));	
	ws.mergeCells(col+7, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"ELECTRICAL TEST    電性檢驗" , ACENTREBLRT));	
	row++;//列+1	
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col, row ,"CRITICAL DEFECT       嚴重缺點" , ACENTREBLR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"ITEM" , ACENTREBL));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,"CONDITIONS" , ACENTREB));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row ,"MIN" , ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"MAX" , ACENTREBR));	
	row++;//列+1
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"NO MARKING" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"無印字" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[0][0] , ACENTREB));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,v_electrical_spec[0][1] , ALEFTBC));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row ,v_electrical_spec[0][2] , ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[0][3] , ACENTREBR));	
	row++;//列+1		

	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"STRUCTURE EXPOSED" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"結構外露" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[1][0] , ACENTREB));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,v_electrical_spec[1][1], ALEFTBC));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row , v_electrical_spec[1][2] , ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[1][3] , ACENTREBR));	
	row++;//列+1		

	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"POOR LEAD SIZE" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"彎腳尺寸不良" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[2][0] , ACENTREB));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,v_electrical_spec[2][1], ALEFTBC));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row , v_electrical_spec[2][2] , ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[2][3] , ACENTREBR));	
	row++;//列+1		
			
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"MIX TYPE" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"型號混料" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[3][0], ACENTREB));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,v_electrical_spec[3][1], ALEFTBC));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row , v_electrical_spec[3][2] , ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[3][3] , ACENTREBR));	
	row++;//列+1
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"REVERSE REELING" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"卷裝材料反向" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[4][0], ACENTREB));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,v_electrical_spec[4][1],ALEFTBC));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row , v_electrical_spec[4][2] , ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[4][3] , ACENTREBR));	
	row++;//列+1			
			
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"SHORT OF QTY" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"數量短少" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[5][0] , ACENTREB));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,v_electrical_spec[5][1], ALEFTBC));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row ,v_electrical_spec[5][2], ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[5][3] , ACENTREBR));	
	row++;//列+1		
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"REELING PRODUCTS VACANCY" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"空缺料" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[6][0] , ACENTREB));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,v_electrical_spec[6][1], ALEFTBC));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row , v_electrical_spec[6][2] , ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[6][3], ACENTREBR));	
	row++;//列+1	
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"MARKING DISLOCATION" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"印錯位置" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[7][0] , ACENTREB));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,v_electrical_spec[7][1], ALEFTBC));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row , v_electrical_spec[7][2], ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[7][3], ACENTREBR));	
	row++;//列+1							
			
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"TAPPING SHORT" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"膠帶不足" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[8][0] , ACENTREB));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,v_electrical_spec[8][1], ALEFTBC));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row , v_electrical_spec[8][2], ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[8][3], ACENTREBR));	
	row++;//列+1	

				
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"LEAD BEND UPWARDS" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"翹腳" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+7, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_spec[9][0] , ACENTREB));	
	ws.mergeCells(col+8, row, col+10, row); 
	ws.addCell(new jxl.write.Label(col+8, row ,v_electrical_spec[9][1], ALEFTBC));	
	ws.mergeCells(col+11, row, col+11, row); 
	ws.addCell(new jxl.write.Label(col+11, row , v_electrical_spec[9][2], ACENTREB));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_spec[9][3], ACENTREBR));	
	row++;//列+1	

	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"MATERIAL DISLOCATION" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"材料擺放不正" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,"機臺編號  Machine NO." , ACENTREBLB));	
	ws.mergeCells(col+10, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+10, row ,"ZT-722" , ACENTREBRB));
	row++;//列+1	
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col, row ,"" , ALEFTB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"" ,ACENTREBR));		
	ws.mergeCells(col+7, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+7, row ,"CRITICAL DEFECT      嚴重缺點" , ACENTREBLR));	
	row++;//列+1	
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col, row ,"" , ALEFTB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"" ,ACENTREBR));		
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,"OPEN" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	ws.addCell(new jxl.write.Label(col+10, row ,"開路" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0" , ACENTREBR));	
	row++;//列+1
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col, row ,"" , ACENTREBLB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"" ,ACENTREBRB));		
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,"SHORT " , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	ws.addCell(new jxl.write.Label(col+10, row ,"短路" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0" , ACENTREBR));		
	row++;//列+1			
				
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col, row ,"MAJOR DEFECT       主要缺點" , ACENTREBLR));
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,"REVERST POLARITY" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	ws.addCell(new jxl.write.Label(col+10, row ,"極性反向" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0" , ACENTREBR));		
	row++;//列+1
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+2, row); 
	ws.addCell(new jxl.write.Label(col, row ,"POOR REEL TAPPING" , ALEFTB));	
	ws.mergeCells(col+3, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+3, row ,"卷裝紅白膠帶不良" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,"REVERSE STABILITY" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	ws.addCell(new jxl.write.Label(col+10, row ,"逆向穩定度" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0" , ACENTREBR));		
	row++;//列+1		
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"POOR MARKING" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"印碼不良" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,"MIX PRODUCT" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	ws.addCell(new jxl.write.Label(col+10, row ," 產品混料" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0" , ACENTREBR));		
	row++;//列+1		
				
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"BODY CRACK/VOID/CHIP" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"裂痕/氣孔/缺角" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,"POOR ISOLATION" , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	ws.addCell(new jxl.write.Label(col+10, row ," 絕緣不良" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,"0" , ACENTREBR));		
	row++;//列+1
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"BURR" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"毛頭/毛邊" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+12, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,"MAJOR DEFECT        主要缺點" , ACENTREBLRT));	
	row++;//列+1	
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"BODY SHIFT" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"撮膠" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_item[0][0] , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	ws.addCell(new jxl.write.Label(col+10, row ,"" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_item[0][1] , ACENTREBR));		
	row++;//列+1	
				
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"POOR COOLING PIN" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"散熱片不良" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_item[1][0] , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	ws.addCell(new jxl.write.Label(col+10, row ,"" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	//ws.addCell(new jxl.write.Label(col+12, row ,(v_electrical_item[1][0]!=null?"0":"") , ACENTREBR));		
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_item[1][1], ACENTREBR));		
	row++;//列+1
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"STRUCTURE MISALIGNMENT" , ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"結構不正" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_item[2][0], ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	ws.addCell(new jxl.write.Label(col+10, row ,"" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	//ws.addCell(new jxl.write.Label(col+12, row ,(v_electrical_item[2][0]!=null?"0":"") , ACENTREBR));		
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_item[2][1] , ACENTREBR));		
	row++;//列+1	
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"FLASH ON LEAD/OPPER EXPOSED", ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"引線沾膠/露銅" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_item[3][0], ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	//ws.addCell(new jxl.write.Label(col+10, row ,v_electrical_item[3][1] , ARIGHTBC));	
	ws.addCell(new jxl.write.Label(col+10, row ,"" , ARIGHTBC));
	ws.mergeCells(col+12, row, col+12, row); 
	//ws.addCell(new jxl.write.Label(col+12, row ,(v_electrical_item[3][0]!=null?"0":"")  , ACENTREBR));		
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_item[3][1]  , ACENTREBR));		
	row++;//列+1	
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"LEAD DAMAGE", ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"引線損傷/壓傷" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_item[4][0] , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	//ws.addCell(new jxl.write.Label(col+10, row ,v_electrical_item[4][1] , ARIGHTBC));	
	ws.addCell(new jxl.write.Label(col+10, row ,"" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	//ws.addCell(new jxl.write.Label(col+12, row ,(v_electrical_item[4][0]!=null?"0":"")  , ACENTREBR));		
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_item[4][1]  , ACENTREBR));		
	row++;//列+1
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"REND LEAD", ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"引線彎曲/扭曲" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_item[5][0] , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	//ws.addCell(new jxl.write.Label(col+10, row ,v_electrical_item[5][1]  , ARIGHTBC));	
	ws.addCell(new jxl.write.Label(col+10, row ,""  , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	//ws.addCell(new jxl.write.Label(col+12, row ,(v_electrical_item[5][0]!=null?"0":"")  , ACENTREBR));		
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_item[5][1] , ACENTREBR));		
	row++;//列+1
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"POOR BODY", ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"膠體不良" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_item[6][0]  , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	//ws.addCell(new jxl.write.Label(col+10, row ,v_electrical_item[6][1]  , ARIGHTBC));	
	ws.addCell(new jxl.write.Label(col+10, row ,"" , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	//ws.addCell(new jxl.write.Label(col+12, row ,(v_electrical_item[6][0]!=null?"0":"")  , ACENTREBR));
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_item[6][1] , ACENTREBR));
	row++;//列+1	
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"LEADDISCORATION/DIRTY", ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"引線變色/臟污" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_item[7][0]  , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	//ws.addCell(new jxl.write.Label(col+10, row ,v_electrical_item[7][1]  , ARIGHTBC));	
	ws.addCell(new jxl.write.Label(col+10, row ,""  , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	//ws.addCell(new jxl.write.Label(col+12, row ,(v_electrical_item[7][0]!=null?"0":"") , ACENTREBRB));	
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_item[7][1] , ACENTREBR));	
	row++;//列+1	
			
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+3, row); 
	ws.addCell(new jxl.write.Label(col, row ,"BURR", ALEFTB));	
	ws.mergeCells(col+4, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col+4, row ,"毛刺" , ARIGHTBC));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"0" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_item[8][0]  , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	//ws.addCell(new jxl.write.Label(col+10, row ,v_electrical_item[7][1]  , ARIGHTBC));	
	ws.addCell(new jxl.write.Label(col+10, row ,""  , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	//ws.addCell(new jxl.write.Label(col+12, row ,(v_electrical_item[7][0]!=null?"0":"") , ACENTREBRB));	
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_item[8][1] , ACENTREBR));	
	row++;//列+1	

	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col, row ,"", ALEFTB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"" ,ACENTREBR));	
	ws.mergeCells(col+7, row, col+9, row); 	
	ws.addCell(new jxl.write.Label(col+7, row ,v_electrical_item[9][0]  , ALEFTB));	
	ws.mergeCells(col+10, row, col+11, row); 	
	//ws.addCell(new jxl.write.Label(col+10, row ,v_electrical_item[7][1]  , ARIGHTBC));	
	ws.addCell(new jxl.write.Label(col+10, row ,""  , ARIGHTBC));	
	ws.mergeCells(col+12, row, col+12, row); 
	//ws.addCell(new jxl.write.Label(col+12, row ,(v_electrical_item[7][0]!=null?"0":"") , ACENTREBRB));	
	ws.addCell(new jxl.write.Label(col+12, row ,v_electrical_item[9][1] , ACENTREBRB));		
	row++;//列+1	
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col, row ,"", ALEFTB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+8, row+1); 	
	ws.addCell(new jxl.write.Label(col+7, row ,"MARKING\n印  碼" , ACENTREBLT));	
	ws.mergeCells(col+9, row, col+12, row+1); 	
	ws.addCell(new jxl.write.Label(col+9, row ,"REMARK\n備  注" , ACENTREBRT));	
	row++;//列+1	
					
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col, row ,"", ALEFTB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"" , ACENTREBR));	
	row++;//列+1	
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col, row ,"",ALEFTB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"" , ACENTREBR));	
	ws.mergeCells(col+7, row, col+8, row+3); 	
	if (TSC_ITEM_NOPACKING.startsWith("1N4007G-K-01")) 
	{
		ws.addCell(new jxl.write.Label(col+7, row ,"", ACENTREBLB));	
		String imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/1N4007G.PNG";
		File f = new File(imageFile);
		if(f.exists()) 
		{
			jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+7+0.5, row+0.9,0.9,1.7, f); 
			ws.addImage(image1);
		}
	}
	else if (TSC_ITEM_NOPACKING.startsWith("SD103AXM5")) 
	{	
		ws.addCell(new jxl.write.Label(col+7, row ,"", ACENTREBLB));	
		String imageFile="..//resin-2.1.9//webapps/oradds/jsp/images/SD103AXM5.PNG";
		File f = new File(imageFile);
		if(f.exists()) 
		{
			jxl.write.WritableImage image1 = new jxl.write.WritableImage(col+7+0.5, row+0.9,0.9,1.7, f); 
			ws.addImage(image1);
		}	
	}
	else
	{	
		ws.addCell(new jxl.write.Label(col+7, row ,MARKING_CODE, ACENTREBLB));	
	}
	ws.mergeCells(col+9, row, col+12, row+3); 	
	ws.addCell(new jxl.write.Label(col+9, row ,SHIPPING_MARKS , ACENTREBRB));	
	row++;//列+1
	
	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col, row ,"", ALEFTB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"" ,ACENTREBR));	
	row++;//列+1

	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col, row ,"", ALEFTB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"" ,ACENTREBR));	
	row++;//列+1

	ws.setRowView(row,330);	
	ws.mergeCells(col, row, col+5, row); 
	ws.addCell(new jxl.write.Label(col, row ,"", ACENTREBLB));	
	ws.mergeCells(col+6, row, col+6, row); 
	ws.addCell(new jxl.write.Label(col+6, row ,"" , ACENTREBRB));	
	row++;//列+1
		
	ws.setRowView(row,350);	
	ws.mergeCells(col, row, col+12, row); 
	ws.addCell(new jxl.write.Label(col, row ,"*** The copyright of document and business secret belong to TSC, and no copies should be made without any permission ***（OQ4QC36-A）", wRptEnd));	
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
	String strURL = "/oradds/report/"+FileName+".xls"; 
	String fileURL = new String(strURL.getBytes("UTF-8"),"ISO8859-1");
	response.sendRedirect(fileURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
