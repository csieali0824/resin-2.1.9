<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.lang.*,java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Lot Detail</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCSGLotDistributionExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String ADVISENO=request.getParameter("ADVISENO");
if (ADVISENO==null) ADVISENO="";
String ATYPE = request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String SG_DIST_ID=request.getParameter("SG_DIST_ID");
if (SG_DIST_ID==null) SG_DIST_ID="";
String FileName="",RPTName="",sql="",so_line_id="",carton_no="";
int fontsize=9,colcnt=0,page_num=25,lot_cnt=0,tot_cnt=0;
String ADVISE_LINE_ID="",S_CNO="",E_CNO="",CNO="",LOT_LIST="",QTY_LIST="",BOX_CODE="",LOT="",DC="",DC_YYWW="",SHIPPING_REMARK="",DC_LIST="",DC_YYWW_LIST="",VENDOR_CARTON_LIST="",VENDOR_CARTON=""; 
float TOT_QTY=0,so_line_qty=0;
String label_remarks="";
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0,mergeCol=0;
	OutputStream os = null;	
	FileName = "AdviseNo-"+ADVISENO+"_"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ 
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("Sheet1", 0);  
	SheetSettings settings = ws.getSettings();//取得分頁環境設定(如:標頭/標尾,分頁,欄長,欄高等設定
	settings.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
	settings.setZoomFactor(78);    //顯示縮放比例
	settings.setScaleFactor(55);   // 設置打印縮放比例
	settings.setHeaderMargin(0.3);
	settings.setBottomMargin(0.5);
	settings.setLeftMargin(0.1);
	settings.setRightMargin(0.1);
	settings.setTopMargin(0.5);
	settings.setFooterMargin(0.3);	
	
	//報表名稱平行置中    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 16, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName.setAlignment(jxl.format.Alignment.CENTRE);
	
	//表尾行置中     
	WritableCellFormat wRptEnd = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptEnd.setAlignment(jxl.format.Alignment.CENTRE);
		
	//英文內文水平垂直置左  
	WritableCellFormat ALEFT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),fontsize ,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFT.setAlignment(jxl.format.Alignment.LEFT);
	ALEFT.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);
	
	//英文內文水平垂直置右 
	WritableCellFormat ARIGHT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),fontsize ,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARIGHT.setAlignment(jxl.format.Alignment.RIGHT);
	ARIGHT.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);	
		
	//英文內文水平垂直置中-粗體-格線-底色灰-字體黑   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.WHITE));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.SEA_GREEN); 
	ACenterBL.setWrap(true);

	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
		
	//英文內文水平垂直置左-正常-無格線   
	WritableCellFormat ANLeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 11,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ANLeftL.setAlignment(jxl.format.Alignment.LEFT);
	ANLeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ANLeftL.setWrap(true);
			
	if (ATYPE.equals(""))
	{		
		/*sql = " select c.vendor_site_code"+
			  ",a.vendor_site_id"+
			  ",b.shipping_method"+
			  ",a.shipping_remark"+
			  ",a.tew_advise_no advise_no"+
			  ",b.advise_header_id"+
			  ",a.advise_line_id"+
			  ",a.so_no"+
			  ",a.so_header_id"+
			  ",a.so_line_id"+
			  ",a.so_line_number"+
			  ",a.item_no"+
			  ",a.item_desc"+
			  ",a.inventory_item_id"+
			  ",to_char(a.pc_schedule_ship_date,'yyyy-mm-dd') pc_schedule_ship_date"+
			  ",(a.ship_qty/1000) SHIP_QTY"+
			  ",a.carton_num_fr"+
			  ",a.carton_num_to"+
			  ",(a.CARTON_PER_QTY/1000) CARTON_PER_QTY"+
			  ",nvl(a.post_code,b.post_fix_code) post_fix_code"+
			  ",d.carton_no"+
			  ",(select count(1) from tsc.tsc_pick_confirm_lines x where x.ADVISE_LINE_ID=d.ADVISE_LINE_ID and x.carton_no=d.carton_no) lot_cnt"+
			  ",d.lot lot_number"+
			  ",d.date_code"+
			  ",d.qty/1000 allot_qty"+
			  //",DECODE(e.ITEM_IDENTIFIER_TYPE,'CUST',e.ORDERED_ITEM,'') CUST_ITEM"+
			  ",case when substr(a.so_no,1,1)='8' then decode(e.item_identifier_type,'CUST',e.ordered_item,'')"+
			  " else decode(tsc_odr.item_identifier_type,'CUST',tsc_odr.ordered_item,'') end CUST_ITEM"+
			  ",a.PO_NO CUSTOMER_PO"+
			  ",'' PONO"+
			  ",tsc_label_pkg.TSC_GET_CUST_LABEL_GROUP(a.so_line_id) CUST_LABEL_GROUP"+
			  ",a.CARTON_PER_QTY/1000 PC_CONFIRM_QTY "+
			  ",d.PO_CUST_PARTNO PO_CUSTPN_LIST"+
			  ",ROW_NUMBER() OVER (PARTITION BY A.SO_LINE_ID,d.carton_no ORDER BY D.LOT) CARTON_CNT"+
			  ",a.TSC_PACKAGE"+  
			  ",tsc_om_category(a.INVENTORY_ITEM_ID,43,'TSC_Amp') TSC_AMP"+   
			  ",tsc_om_category(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_VOLT') TSC_VOLT"+  
			  ",a.REGION_CODE"+ 
			  " FROM tsc.tsc_shipping_advise_lines a"+
			  ",tsc.tsc_shipping_advise_headers b"+
			  ",ap.ap_supplier_sites_all c"+
			  ",tsc.tsc_pick_confirm_lines d"+
			  ",ont.oe_order_lines_all e"+
			  ",ap.ap_supplier_sites_all h"+
		      ", (select x.order_number,y.line_number||'.'||y.shipment_number line_no,y.item_identifier_type,y.ordered_item from ont.oe_order_headers_all x,ont.oe_order_lines_all y where x.org_id=41 and x.header_id=y.header_id and y.packing_instructions='T') tsc_odr"+
			  " where  A.tew_advise_no=? "+
			  " and b.SHIPPING_FROM LIKE ?||'%' "+
			  " and b.advise_header_id = a.advise_header_id "+
			  " and a.vendor_site_id = c.vendor_site_id(+)"+
			  " and a.advise_header_id = d.advise_header_id"+
			  " and a.advise_line_id = d.advise_line_id"+
			  " and a.so_header_id = e.header_id(+) "+
			  " and a.so_line_id = e.line_id(+)"+
			  " and a.vendor_site_id = h.vendor_site_id"+
			  " and a.so_no=tsc_odr.order_number(+)"+
			  " and a.so_line_number=tsc_odr.line_no(+)"+
			  " order by a.CARTON_NUM_FR,a.CARTON_NUM_TO,to_number(replace(d.CARTON_NO,'A','')),a.advise_line_id ,d.lot";*/
		sql = " select c.vendor_site_code"+
              ",a.vendor_site_id"+
              ",b.shipping_method"+
              ",a.shipping_remark"+
              ",a.tew_advise_no advise_no"+
              ",b.advise_header_id"+
              ",a.advise_line_id"+
              ",a.so_no"+
              ",a.so_header_id"+
              ",a.so_line_id"+
              ",a.so_line_number"+
              ",a.item_no"+
              ",a.item_desc"+
              ",a.inventory_item_id"+
              ",to_char(a.pc_schedule_ship_date,'yyyy-mm-dd') pc_schedule_ship_date"+
              ",(a.ship_qty/1000) SHIP_QTY"+
              ",a.carton_num_fr"+
              ",a.carton_num_to"+
              ",(a.CARTON_PER_QTY/1000) CARTON_PER_QTY"+
              ",nvl(a.post_code,b.post_fix_code) post_fix_code"+
              ",d.carton_no"+
              ",count(1) over (partition by d.advise_line_id,d.carton_no) lot_cnt"+
              ",d.lot lot_number"+
              ",d.date_code"+
			  ",d.dc_yyww"+
              ",d.qty/1000 allot_qty"+
              ",case when substr(a.so_no,1,1)='8' then decode(e.item_identifier_type,'CUST',e.ordered_item,'')"+
              " else decode(tsc_odr.item_identifier_type,'CUST',tsc_odr.ordered_item,'') end CUST_ITEM"+
              ",a.PO_NO CUSTOMER_PO"+
              ",'' PONO"+
              //",replace(tsc_label_pkg.TSC_GET_CUST_LABEL_GROUP(a.so_line_id),'ARROW(TSCE)','') CUST_LABEL_GROUP"+
			  ",replace(tsc_label_pkg.TSC_GET_CUST_LABEL_GROUP(nvl(tsc_odr.tsc_line_id,a.so_line_id)),'ARROW(TSCE)','') CUST_LABEL_GROUP"+  //modify by Peggy 20211220
              ",a.CARTON_PER_QTY/1000 PC_CONFIRM_QTY "+
              ",d.PO_CUST_PARTNO PO_CUSTPN_LIST"+
              ",ROW_NUMBER() OVER (PARTITION BY A.SO_LINE_ID,d.carton_no ORDER BY D.LOT) CARTON_CNT"+
              ",a.TSC_PACKAGE"+
              ",tsc_om_category(a.INVENTORY_ITEM_ID,43,'TSC_Amp') TSC_AMP "+
              ",tsc_om_category(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_VOLT') TSC_VOLT "+
              ",a.REGION_CODE"+
              ",d.vendor_carton_no"+
			  ",a.gross_weight"+ //add by Peggy 20201123
			  ",case when d.dc_yyww is not null and to_char(d.dc_yyww)>=2331 then tssg_ship_pkg.GET_TOTW(a.so_header_id,'LABEL') else '' end coo_info"+ //add by Peggy 20230808			  
              " FROM tsc.tsc_shipping_advise_lines a"+
              ",tsc.tsc_shipping_advise_headers b"+
              ",ap.ap_supplier_sites_all c"+
              ",(select x.advise_header_id,x.advise_line_id,x.carton_no,x.lot,x.date_code,x.dc_yyww,y.vendor_carton_no,x.po_cust_partno,"+
              " sum(QTY) QTY  from tsc.tsc_pick_confirm_lines x,oraddman.tssg_stock_overview y"+
              " where x.sg_stock_id=y.sg_stock_id and x.tew_advise_no=?"+
              " group by x.advise_header_id,x.advise_line_id,x.carton_no,x.lot,x.date_code,x.dc_yyww,y.vendor_carton_no,x.po_cust_partno) d"+
              ",ont.oe_order_lines_all e"+
              ",ap.ap_supplier_sites_all h"+
              //", (select x.order_number,y.line_number||'.'||y.shipment_number line_no,y.item_identifier_type,y.ordered_item,y.line_id tsc_line_id from ont.oe_order_headers_all x,ont.oe_order_lines_all y where x.org_id=41 and x.header_id=y.header_id and y.packing_instructions='T') tsc_odr"+
			  ", (select distinct x.order_number,y.line_number line_no,y.item_identifier_type,y.ordered_item,y.line_id tsc_line_id from ont.oe_order_headers_all x,ont.oe_order_lines_all y where x.org_id=41 and x.header_id=y.header_id and y.packing_instructions='T' and y.shipment_number=1) tsc_odr"+  //add shipment_number=1 by Peggy 20220614
              " where  A.tew_advise_no=?"+
              " and b.SHIPPING_FROM LIKE ?||'%' "+
              " and b.advise_header_id = a.advise_header_id "+
              " and a.vendor_site_id = c.vendor_site_id(+)"+
              " and a.advise_header_id = d.advise_header_id"+
              " and a.advise_line_id = d.advise_line_id"+
              " and a.so_header_id = e.header_id(+) "+
              " and a.so_line_id = e.line_id(+)"+
              " and a.vendor_site_id = h.vendor_site_id"+
              " and a.so_no=tsc_odr.order_number(+)"+
              //" and a.so_line_number=tsc_odr.line_no(+)"+
              " and substr(a.so_line_number,1,instr(a.so_line_number,'.')-1)=tsc_odr.line_no(+)"+//modify by Peggy 20220601
              " order by a.CARTON_NUM_FR,a.CARTON_NUM_TO,to_number(replace(d.CARTON_NO,'A','')),a.advise_line_id ,d.lot";
	}
	else
	{		  
		sql = " select b.VENDOR_SITE_CODE"+
			  ",b.VENDOR_SITE_ID"+
			  ",b.SHIPPING_METHOD"+
			  ",b.SHIPPING_REMARK"+
			  ",b.ADVISE_NO"+
			  ",b.ADVISE_HEADER_ID"+
			  ",b.ADVISE_LINE_ID"+
			  ",b.SO_NO"+
			  ",c.SO_HEADER_ID"+
			  ",c.SO_LINE_ID"+
			  ",b.ITEM_NAME ITEM_NO"+
			  ",B.ITEM_DESC"+
			  ",b.SCHEDULE_SHIP_DATE PC_SCHEDULE_SHIP_DATE"+
			  ",b.SHIP_QTY"+
			  ",CARTON_NUM CARTON_NUM_FR"+
			  ",CARTON_NUM CARTON_NUM_TO"+
			  ",b.POST_FIX_CODE"+
			  ",b.CARTON_NUM CARTON_NO"+
			  ",b.CARTON_LOT_CNT LOT_CNT"+
			  ",b.LOT_NUMBER"+
			  ",b.DATE_CODE"+
			  ",b.DC_YYWW"+ //add by Peggy 20220721
			  ",case when LOT_NUMBER='庫存不足' THEN 0 else b.QTY end/1000 ALLOT_QTY"+
			  ",b.CUST_PARTNO CUST_ITEM"+
			  ",b.CUST_PO CUSTOMER_PO"+
			  ",'' PONO"+
			  //",replace(tsc_label_pkg.TSC_GET_CUST_LABEL_GROUP(c.so_line_id),'ARROW(TSCE)','') CUST_LABEL_GROUP"+
			  ",replace(tsc_label_pkg.TSC_GET_CUST_LABEL_GROUP(nvl(c.tsc_so_line_id,c.so_line_id)),'ARROW(TSCE)','') CUST_LABEL_GROUP"+  //modify by Peggy 20210913
			  ",c.CARTON_PER_QTY/1000 PC_CONFIRM_QTY"+
			  ",b.PO_CUST_PARTNO PO_CUSTPN_LIST"+
			  ",b.CARTON_CNT"+
			  ",c.TSC_PACKAGE"+ 
			  ",tsc_om_category(c.INVENTORY_ITEM_ID,43,'TSC_Amp') TSC_AMP"+    
			  ",tsc_om_category(c.INVENTORY_ITEM_ID,43,'TSC_VOLT') TSC_VOLT"+  
			  ",c.REGION_CODE"+  
			  ",b.VENDOR_CARTON_NO"+ 
			  ",c.gross_weight"+ //add by Peggy 20201123
			  ",case when b.DC_YYWW is not null and to_char(b.DC_YYWW)>=2331 then tssg_ship_pkg.GET_TOTW(c.SO_HEADER_ID,'LABEL') else '' end coo_info"+ //add by Peggy 20230808
			  " from (SELECT  count(1) over(partition by ADVISE_LINE_ID order by carton_num desc) advise_line_cnt,"+
              "               count(1) over(partition by ADVISE_LINE_ID,carton_num) carton_cnt,"+
			  "               sum(case when LOT_NUMBER='庫存不足' THEN 0 ELSE QTY END) over(partition by ADVISE_LINE_ID order by carton_num desc) advise_line_sum,"+
              "               sum(case when LOT_NUMBER='庫存不足' THEN 0 ELSE QTY END) over(partition by ADVISE_LINE_ID,carton_num order by lot_number) carton_sum,"+
              "               count(distinct LOT_NUMBER) over(partition by ADVISE_LINE_ID,CUST_PARTNO,carton_num,DATE_CODE,DC_YYWW) carton_lot_cnt,"+ 
			  //"       a.* FROM oraddman.TSSG_LOT_DISTRIBUTION_TEMP a"+
			  //"         where SG_DISTRIBUTION_ID=?) a"+
			  "        a.* from (SELECT a.SG_DISTRIBUTION_ID,a.advise_no,a.VENDOR_SITE_CODE,a.VENDOR_SITE_ID,"+
              "        a.ADVISE_HEADER_ID,a.ADVISE_LINE_ID,a.PC_ADVISE_ID,a.SO_NO,a.SO_LINE_NO,a.ITEM_ID,a.ITEM_NAME,"+
              "        a.ITEM_DESC,a.SHIP_QTY,a.CUST_PO,a.CUST_PARTNO,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.SCHEDULE_SHIP_DATE,a.CARTON_NUM,"+
              "        a.POST_FIX_CODE,a.LOT_NUMBER,a.DATE_CODE,a.DC_YYWW,SUM(a.QTY) QTY,a.PO_CUST_PARTNO,a.VENDOR_CARTON_NO"+
              "        FROM oraddman.TSSG_LOT_DISTRIBUTION_TEMP A where SG_DISTRIBUTION_ID=?"+
              "        GROUP BY a.SG_DISTRIBUTION_ID,a.advise_no,a.VENDOR_SITE_CODE,a.VENDOR_SITE_ID,"+
              "        a.ADVISE_HEADER_ID,a.ADVISE_LINE_ID,a.PC_ADVISE_ID,a.SO_NO,a.SO_LINE_NO,a.ITEM_ID,a.ITEM_NAME,"+
              "        a.ITEM_DESC,a.SHIP_QTY,a.CUST_PO,a.CUST_PARTNO,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.SCHEDULE_SHIP_DATE,a.CARTON_NUM,"+
              "        a.POST_FIX_CODE,a.LOT_NUMBER,a.DATE_CODE,a.DC_YYWW,a.PO_CUST_PARTNO,a.VENDOR_CARTON_NO) a"+
			  "      ) b "+
              ",(select z.*,(select line_id from ont.oe_order_lines_all x,ont.oe_order_headers_all y where y.org_id=41 and x.header_id=y.header_id and y.order_number=z.so_no and x.line_number||'.'||x.shipment_number=z.so_line_number) tsc_so_line_id from  TSC.TSC_SHIPPING_ADVISE_LINES z where tew_advise_no is not null and ORGANIZATION_ID in (?,?)) c"+ //modify by Peggy 20210913
			  " WHERE b.ADVISE_LINE_ID=c.ADVISE_LINE_ID "+
			  " order by to_number(replace(CARTON_NUM,'A','')),ADVISE_LINE_ID,ADVISE_LINE_CNT desc,CARTON_CNT desc";
	}		  
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	if (ATYPE.equals(""))
	{	
		statement.setString(1,ADVISENO);
		statement.setString(2,ADVISENO);
		statement.setString(3,"SG");
	}
	else
	{
		statement.setString(1,SG_DIST_ID);
		statement.setString(2,"907");  //add by Peggy 20210913
		statement.setString(3,"908");  //add by Peggy 20210913
	}
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{
		if (!so_line_id.equals(rs.getString("so_line_id")))
		{
			if (!so_line_id.equals("")) ws.addCell(new jxl.write.Number(13, row-1, Double.valueOf(""+(so_line_qty/1000)).doubleValue() , ARightL));
			so_line_id=rs.getString("so_line_id");  
			so_line_qty = 0; 	
		}
		if (rs.getInt("CARTON_CNT")==1)
		{
			so_line_qty +=(rs.getFloat("PC_CONFIRM_QTY")*1000);
		}
		if (reccnt ==0 || (tot_cnt>0 && tot_cnt%page_num==0) || !ADVISE_LINE_ID.equals(rs.getString("ADVISE_LINE_ID")) || (!CNO.equals(rs.getString("CARTON_NO")) && (rs.getInt("LOT_CNT")>1 || lot_cnt >1 || !rs.getString("LOT_NUMBER").equals(LOT) || (rs.getString("DATE_CODE")!=null && !rs.getString("DATE_CODE").equals(DC)) || (rs.getString("DC_YYWW")!=null && !rs.getString("DC_YYWW").equals(DC_YYWW)))))		
		{
 			if (tot_cnt>0)
			{
				if (!SHIPPING_REMARK.equals("") && ((SHIPPING_REMARK.length()>=12 && SHIPPING_REMARK.substring(0,12).equals("CHANNEL WELL")) || (SHIPPING_REMARK.indexOf("駱騰")>=0)))
				{
					ws.addCell(new jxl.write.Label(col, row-1,  (S_CNO.equals(E_CNO)?BOX_CODE+S_CNO:BOX_CODE+S_CNO +" - "+BOX_CODE+E_CNO),  ACenterL));
				}
				else
				{
					ws.addCell(new jxl.write.Label(col, row-1,  (S_CNO.equals(E_CNO)?S_CNO+BOX_CODE:S_CNO+BOX_CODE +" - "+E_CNO+BOX_CODE),  ACenterL));
				}
				col++;	
				if (lot_cnt ==1)
				{
					ws.addCell(new jxl.write.Label(col, row-1, LOT,  ALeftL));
					ws.setRowView(row-1, 500);
					col++;	
					ws.addCell(new jxl.write.Label(col, row-1, DC,  ALeftL));
					col++;	
					ws.addCell(new jxl.write.Label(col, row-1, DC_YYWW,  ALeftL));
					col++;	
					ws.addCell(new jxl.write.Number(col, row-1, Double.valueOf(""+(TOT_QTY/1000)).doubleValue(), ARightL));
					col++;	
					ws.addCell(new jxl.write.Label(16, row-1, VENDOR_CARTON,  ALeftL));
					col++;	
				}
				else
				{
					ws.addCell(new jxl.write.Label(col, row-1, LOT_LIST,  ALeftL));
					ws.setRowView(row-1, (lot_cnt-2)*250+500);
					col++;	
					ws.addCell(new jxl.write.Label(col, row-1, DC_LIST,  ALeftL)); 
					col++;	
					ws.addCell(new jxl.write.Label(col, row-1, DC_YYWW_LIST,  ALeftL)); 
					col++;	
					ws.addCell(new jxl.write.Label(col, row-1,QTY_LIST , ARightL));
					col++;	
					ws.addCell(new jxl.write.Label(16, row-1, VENDOR_CARTON_LIST,  ALeftL)); 
					col++;	
				}
			}
			if (tot_cnt>0 && tot_cnt%page_num==0)
			{
				ws.addRowPageBreak(row);
				reccnt=0;
			}	
			if (reccnt==0)
			{
				col=0;
				row++;
				String strRPTtitle = "出貨批號明細表";
				ws.mergeCells(col, row, col+14, row);     
				ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wRptName));
				row+=2;//列+1
			
				ws.mergeCells(col, row, col+2, row);     
				ws.addCell(new jxl.write.Label(col, row,"Advise No："+rs.getString("advise_no"),ALEFT));
				row++;//列+1
				ws.mergeCells(col, row, col+3, row);     
				ws.addCell(new jxl.write.Label(col, row,"出貨日期："+rs.getString("pc_schedule_ship_date") ,ALEFT));
				ws.mergeCells(col+10, row, col+12, row);     
				ws.addCell(new jxl.write.Label(col+10, row,"頁數："+((int)(tot_cnt/page_num)+1),ARIGHT));
				row++;//列+1
	
				ws.setRowView(row, 500);
				ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	
	
				ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBL));
				ws.setColumnView(col,18);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "P/N" , ACenterBL));
				ws.setColumnView(col,18);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "P/O" , ACenterBL));
				ws.setColumnView(col,28);	
				col++;		
				
				ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBL));
				ws.setColumnView(col,28);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "出貨方式" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;		
				
				//ws.addCell(new jxl.write.Label(col, row, "採購單號" , ACenterBL));
				ws.addCell(new jxl.write.Label(col, row, "毛重" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;
				
				ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	
	
				ws.addCell(new jxl.write.Label(col, row, "箱號" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBL));
				ws.setColumnView(col,13);	
				col++;				

				ws.addCell(new jxl.write.Label(col, row, "Date Code " , ACenterBL));
				ws.setColumnView(col,10);	
				col++;				

				ws.addCell(new jxl.write.Label(col, row, "DC YYWW" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;				
				
				ws.addCell(new jxl.write.Label(col, row, "撿貨量(K)" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
																													
				ws.addCell(new jxl.write.Label(col, row, "出貨總量(K)" , ACenterBL));  
				ws.setColumnView(col,12);	
				col++;	

				ws.addCell(new jxl.write.Label(col, row, "客戶標籤" , ACenterBL)); 
				ws.setColumnView(col,17);	
				col++;	

				ws.addCell(new jxl.write.Label(col, row, "標籤備註" , ACenterBL));  
				ws.setColumnView(col,20);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "供應商箱號" , ACenterBL));  
				ws.setColumnView(col,12);	
				col++;	
				row++;
			}
			
			ADVISE_LINE_ID = rs.getString("ADVISE_LINE_ID");
			CNO = rs.getString("CARTON_NO");
			BOX_CODE=rs.getString("POST_FIX_CODE");
			LOT=rs.getString("LOT_NUMBER");
			DC=rs.getString("DATE_CODE");  
			DC_YYWW=rs.getString("DC_YYWW"); //add by Peggy 20220721                 
			TOT_QTY = (rs.getFloat("ALLOT_QTY")*1000);
			lot_cnt = rs.getInt("LOT_CNT");
			S_CNO=CNO;
			E_CNO=CNO;
			LOT_LIST=rs.getString("LOT_NUMBER");
			DC_LIST=rs.getString("DATE_CODE");
			if (DC_LIST==null) DC_LIST="";//ADD BY PEGGY 20220601
			DC_YYWW_LIST=rs.getString("DC_YYWW"); //add by Peggy 20220721 
			if (DC_YYWW_LIST==null) DC_YYWW_LIST="";
			QTY_LIST=rs.getString("ALLOT_QTY");
			VENDOR_CARTON=rs.getString("VENDOR_CARTON_NO");
			if (VENDOR_CARTON==null) VENDOR_CARTON="";
			VENDOR_CARTON_LIST=rs.getString("VENDOR_CARTON_NO");
			if (VENDOR_CARTON_LIST==null) VENDOR_CARTON_LIST="";
			SHIPPING_REMARK=rs.getString("SHIPPING_REMARK"); 
			if (SHIPPING_REMARK==null) SHIPPING_REMARK="";
				
			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO"),ACenterL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("item_desc") , ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_ITEM") , ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_PO") , ALeftL));
			col++;				
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_REMARK") ,ALeftL ));
			col++;		
			ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_METHOD") , ALeftL));
			col++;
			if (rs.getString("gross_weight")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("gross_weight")).doubleValue() , ARightL));
			}
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("vendor_site_code") , ALeftL));
			col++;		
			ws.addCell(new jxl.write.Label(13, row, "" , ALeftL)); 
			ws.addCell(new jxl.write.Label(14, row, rs.getString("CUST_LABEL_GROUP") , ALeftL)); 
			label_remarks=((rs.getString("CUST_ITEM")==null && rs.getString("PO_CUSTPN_LIST")==null) || rs.getString("LOT_NUMBER").equals("庫存不足")|| (rs.getString("CUST_ITEM")!= null && (rs.getString("CUST_ITEM").equals((rs.getString("PO_CUSTPN_LIST")==null?"":rs.getString("PO_CUSTPN_LIST"))) || ((rs.getString("PO_CUSTPN_LIST")==null?"":","+rs.getString("PO_CUSTPN_LIST")+",")).indexOf(","+rs.getString("CUST_ITEM")+",")>=0)) ?"":"改PN");
			if (rs.getString("CUST_LABEL_GROUP") !=null && rs.getString("CUST_LABEL_GROUP").toUpperCase().indexOf("SIEMENS")>=0)
			{
				label_remarks += (label_remarks.length()>0?"\r\n":"")+ "Part Name:"+rs.getString("tsc_amp")+" "+rs.getString("tsc_volt")+" "+rs.getString("tsc_package");
			}
			if (rs.getString("CUST_LABEL_GROUP") !=null && rs.getString("CUST_LABEL_GROUP").toUpperCase().indexOf("FLEXTRONICS")>=0)
			{	
				if (rs.getString("REGION_CODE").equals("TSCR-ROW") || SHIPPING_REMARK.toUpperCase().indexOf("CHENNAI-MAA")>0)
				{
					label_remarks += (label_remarks.length()>0?"\r\n":"")+ "Vendor Code:SUI000736";
				}
				else
				{
					label_remarks += (label_remarks.length()>0?"\r\n":"")+ "Vendor Code:SPT10026";
				}	
			}
			if (rs.getString("REGION_CODE").equals("TSCH-HK") &&  SHIPPING_REMARK.toUpperCase().equals("LITE ON-2680") && rs.getString("item_desc").equals("ES1J-T"))
			{
				label_remarks += (label_remarks.length()>0?"\r\n":"")+ "加嚴品標籤";			
			}
			
			//ws.addCell(new jxl.write.Label(15, row, label_remarks , ALeftL)); 
			ws.addCell(new jxl.write.Label(15, row, label_remarks+(rs.getString("coo_info")==null?"":","+rs.getString("coo_info")) , ALeftL));  //modify by Peggy 20230808
			row++;
			reccnt++;
			tot_cnt++;
		}
		else
		{
			E_CNO = rs.getString("CARTON_NO");
			TOT_QTY+=(rs.getFloat("ALLOT_QTY")*1000);
			LOT_LIST=(LOT_LIST.equals("")?LOT_LIST:LOT_LIST+"\r\n")+rs.getString("LOT_NUMBER");
			if(rs.getString("DATE_CODE")!=null) DC_LIST=(DC_LIST.equals("")?DC_LIST:DC_LIST+"\r\n")+rs.getString("DATE_CODE");   
			if(rs.getString("DC_YYWW")!=null) DC_YYWW_LIST=(DC_YYWW_LIST.equals("")?DC_YYWW_LIST:DC_YYWW_LIST+"\r\n")+rs.getString("DC_YYWW");    //add by Peggy 20220721
			QTY_LIST=(QTY_LIST.equals("")?QTY_LIST:QTY_LIST+"\r\n")+rs.getString("ALLOT_QTY");
			if(rs.getString("VENDOR_CARTON_NO")!=null) VENDOR_CARTON_LIST=(VENDOR_CARTON_LIST.equals("")?VENDOR_CARTON_LIST:VENDOR_CARTON_LIST+"\r\n")+rs.getString("VENDOR_CARTON_NO");
		}
	}
	if (tot_cnt>0)
	{
		if (!SHIPPING_REMARK.equals("") && ((SHIPPING_REMARK.length()>=12 && SHIPPING_REMARK.substring(0,12).equals("CHANNEL WELL")) || (SHIPPING_REMARK.indexOf("駱騰")>=0)))
		{
			ws.addCell(new jxl.write.Label(col, row-1, (S_CNO.equals(E_CNO)?BOX_CODE+S_CNO:BOX_CODE+S_CNO +" - "+BOX_CODE+E_CNO),  ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row-1, (S_CNO.equals(E_CNO)?S_CNO+BOX_CODE:S_CNO+BOX_CODE +" - "+E_CNO+BOX_CODE),  ACenterL));
		}
		col++;	
		if (lot_cnt ==1)
		{
			ws.addCell(new jxl.write.Label(col, row-1, LOT,  ALeftL));
			ws.setRowView(row-1, 500);
			col++;	
			ws.addCell(new jxl.write.Label(col, row-1, DC,  ALeftL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row-1, DC_YYWW,  ALeftL));
			col++;	
			ws.addCell(new jxl.write.Number(col, row-1, Double.valueOf(""+(TOT_QTY/1000)).doubleValue(), ARightL));
			col++;	
			ws.addCell(new jxl.write.Label(16, row-1, (VENDOR_CARTON==null?"":VENDOR_CARTON),  ALeftL));
			col++;	
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row-1, LOT_LIST,  ALeftL));
			ws.setRowView(row-1, (lot_cnt-2)*250+500);
			col++;	
			ws.addCell(new jxl.write.Label(col, row-1, DC_LIST,  ALeftL));  
			col++;	
			ws.addCell(new jxl.write.Label(col, row-1, DC_YYWW_LIST,  ALeftL));  
			col++;	
			ws.addCell(new jxl.write.Label(col, row-1,QTY_LIST , ARightL));
			col++;	
			ws.addCell(new jxl.write.Label(16, row-1,(VENDOR_CARTON_LIST==null?"":VENDOR_CARTON_LIST) , ARightL));
			col++;	
		}
		ws.addCell(new jxl.write.Number(13, row-1, Double.valueOf(""+(so_line_qty/1000)).doubleValue() , ARightL));
	}

	row+=2;
	ws.setRowView(row, 600);
	ws.mergeCells(0, row, 2, row);     
	ws.addCell(new jxl.write.Label(0, row, "編箱:",  ANLeftL));
	ws.mergeCells(3, row, 4, row);     
	ws.addCell(new jxl.write.Label(3, row, "改標籤:",  ANLeftL));
	ws.mergeCells(5, row, 10, row);     
	ws.addCell(new jxl.write.Label(5, row, "改標籤檢驗:",  ANLeftL));
	ws.mergeCells(11, row, 14, row);     
	ws.addCell(new jxl.write.Label(11, row, "出貨檢驗:",  ANLeftL));
	
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 
	
	rs.close();
	statement.close();

	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();			 
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
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
