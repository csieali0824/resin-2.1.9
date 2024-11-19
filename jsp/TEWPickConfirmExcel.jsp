<!-- modify by Peggy 20140902,客戶=CHANNEL WELL, 箱碼固定為D,且放置在箱數前面,例D1,D2..-->
<!-- modify by Peggy 20160205,無庫存也可預先下載報表 & 新增客戶標籤欄位-->
<!-- modify by Peggy 20160303,顯示訂單項次數量及修改customer p/n訊息-->
<!-- modify by Peggy 20160406,顯示標籤備註-->
<!-- modify by Peggy 20181116,新增簽名欄-->
<!-- 20151119 Peggy,for同一lot d/c不同,畫面增加datecode欄位-->
<!-- 20181211 by Peggy,客戶=駱騰, 箱碼固定為I,且放置在箱數前面,例I1,I2..
<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.lang.*,java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>出貨批號明細表</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TEWPickConfirmExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String ADVISENO=request.getParameter("ADVISENO");
if (ADVISENO==null) ADVISENO="";
String ATYPE = request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String FileName="",RPTName="",sql="",so_line_id="",carton_no="";
int fontsize=9,colcnt=0,page_num=25,lot_cnt=0,tot_cnt=0;
String ADVISE_LINE_ID="",S_CNO="",E_CNO="",CNO="",LOT_LIST="",QTY_LIST="",BOX_CODE="",LOT="",DC="",SHIPPING_REMARK="",DC_LIST=""; 
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
	settings.setScaleFactor(58);   // 設置打印縮放比例
	settings.setHeaderMargin(0.3);
	settings.setBottomMargin(0.5);
	settings.setLeftMargin(0.3);
	settings.setRightMargin(0.3);
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
		sql = " select c.VENDOR_SITE_CODE"+
			  ",a.vendor_site_id"+
			  ",b.shipping_method"+
			  ",a.SHIPPING_REMARK"+
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
			  ",b.POST_FIX_CODE"+
			  ",d.carton_num"+
			  ",(select count(1) from oraddman.tew_lot_allot_detail x where x.ADVISE_LINE_ID=d.ADVISE_LINE_ID and x.carton_num=d.carton_num) lot_cnt"+
			  ",d.lot_number"+
			  ",d.date_code"+
			  ",d.allot_qty/1000 allot_qty"+
			  ",DECODE(e.ITEM_IDENTIFIER_TYPE,'CUST',e.ORDERED_ITEM,'') CUST_ITEM"+
			  ",a.PO_NO CUSTOMER_PO"+
			  //",g.segment1 PONO"+
			  ",apps.tew_rcv_pkg.GET_ADVISE_PO(a.pc_advise_id,i.po_unit_price) PONO"+
			  ",tsc_label_pkg.TSC_GET_CUST_LABEL_GROUP(a.so_line_id) CUST_LABEL_GROUP"+
			  ",a.CARTON_PER_QTY/1000 PC_CONFIRM_QTY "+
			  ",d.PO_CUSTPN_LIST"+
			  ",ROW_NUMBER() OVER (PARTITION BY A.SO_LINE_ID,d.carton_num ORDER BY D.LOT_NUMBER) CARTON_CNT"+
			  ",a.TSC_PACKAGE"+  //add by Peggy 20160406
			  ",tsc_om_category(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_Amp') TSC_AMP"+    //add by Peggy 20160406
			  ",tsc_om_category(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_VOLT') TSC_VOLT"+  //add by Peggy 20160406
			  ",a.REGION_CODE"+   //add by Peggy 20160406
			  " FROM tsc.tsc_shipping_advise_lines a"+
			  ",tsc.tsc_shipping_advise_headers b"+
			  ",ap.ap_supplier_sites_all c"+
			  //",oraddman.tew_lot_allot_detail d"+
			  ",(SELECT TEW_ADVISE_NO,PO_HEADER_ID,ADVISE_HEADER_ID,ADVISE_LINE_ID,CARTON_NUM,LOT_NUMBER,DATE_CODE,ALLOT_QTY"+
              ",listagg(x.PO_CUSTPN,',') within group(order by TEW_ADVISE_NO,PO_HEADER_ID,ADVISE_HEADER_ID,ADVISE_LINE_ID,CARTON_NUM,LOT_NUMBER,DATE_CODE,ALLOT_QTY) po_custpn_list"+
			  " from  (select x.TEW_ADVISE_NO,x.PO_HEADER_ID,x.ADVISE_HEADER_ID,x.ADVISE_LINE_ID,x.CARTON_NUM,x.LOT_NUMBER,y.date_code,sum(x.allot_qty) allot_qty,NVL (odr.cust_partno, pla.note_to_vendor) po_custpn "+
			  " from oraddman.tew_lot_allot_detail x,oraddman.tewpo_receive_detail y"+
              ",(SELECT *  FROM (SELECT a.order_number, b.line_number,DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number  ORDER BY shipment_number) seqno"+
              "                  FROM ont.oe_order_headers_all a, ont.oe_order_lines_all b"+
              "                  WHERE a.header_id = b.header_id) WHERE seqno = 1) odr"+
              ",po.po_line_locations_all pll"+
			  ",po.po_lines_all pla"+
			  " where x.seq_id = y.seq_id "+
			  " and y.po_line_location_id=pll.line_location_id"+
		      " and pll.po_line_id=pla.po_line_id"+
		      " and pll.po_header_id=pla.po_header_id"+
              " and SUBSTR (pll.note_to_receiver,1, INSTR (pll.note_to_receiver, '.') - 1) = odr.order_number(+)"+
              " and SUBSTR (pll.note_to_receiver,INSTR (pll.note_to_receiver, '.') + 1,LENGTH (pll.note_to_receiver)) = odr.line_number(+)"+
              " group by x.TEW_ADVISE_NO,x.PO_HEADER_ID,x.ADVISE_HEADER_ID,x.ADVISE_LINE_ID,x.CARTON_NUM,x.LOT_NUMBER,y.date_code,NVL (odr.cust_partno, pla.note_to_vendor)) x"+
			  " group by TEW_ADVISE_NO,PO_HEADER_ID,ADVISE_HEADER_ID,ADVISE_LINE_ID,CARTON_NUM,LOT_NUMBER,DATE_CODE,ALLOT_QTY) d"+
			  ",ont.oe_order_lines_all e"+
			  ",po.po_headers_all g"+
			  ",ap.ap_supplier_sites_all h"+
			  ",(select pc_advise_id,po_header_id,po_unit_price,sum(order_qty) ORDER_QTY from tsc.tsc_shipping_po_price group by pc_advise_id,po_header_id,po_unit_price) i"+
			  " where  A.tew_advise_no=? "+
			  " and b.SHIPPING_FROM=? "+
			  " and b.advise_header_id = a.advise_header_id "+
			  " and a.vendor_site_id = c.vendor_site_id(+)"+
			  " and a.advise_header_id = d.advise_header_id"+
			  " and a.advise_line_id = d.advise_line_id"+
			  " and a.so_header_id = e.header_id(+) "+
			  " and a.so_line_id = e.line_id(+)"+
			  " and d.po_header_id =g.po_header_id"+
			  " and g.vendor_site_id = h.vendor_site_id"+
			  " and a.pc_advise_id = i.pc_advise_id"+
			  " and g.po_header_id= i.po_header_id"+
			  " order by a.CARTON_NUM_FR,a.CARTON_NUM_TO,d.CARTON_NUM,a.advise_line_id ,d.lot_number";
	}
	else
	{		  
		sql = " select b.VENDOR_SITE_CODE"+
			  ",b.VENDOR_SITE_ID"+
			  ",b.SHIPPING_METHOD"+
			  ",b.SHIPPING_REMARK"+
			  ",b.TEW_ADVISE_NO ADVISE_NO"+
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
			  ",b.CARTON_NUM"+
			  ",b.CARTON_LOT_CNT LOT_CNT"+
			  ",b.LOT_NUMBER"+
			  ",b.DATE_CODE"+
			  ",b.LOT_ALLOT_QTY/1000 ALLOT_QTY"+
			  ",b.CUST_PARTNO CUST_ITEM"+
			  ",b.CUST_PO CUSTOMER_PO"+
			  ",d.SEGMENT1 PONO"+
			  ",tsc_label_pkg.TSC_GET_CUST_LABEL_GROUP(c.so_line_id) CUST_LABEL_GROUP"+
			  ",c.CARTON_PER_QTY/1000 PC_CONFIRM_QTY"+
			  ",b.PO_CUST_PARTNO PO_CUSTPN_LIST"+
			  ",b.CARTON_CNT"+
			  ",c.TSC_PACKAGE"+ //add by Peggy 20160406
			  ",tsc_om_category(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Amp') TSC_AMP"+     //add by Peggy 20160406
			  ",tsc_om_category(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_VOLT') TSC_VOLT"+  //add by Peggy 20160406
			  ",c.REGION_CODE"+   //add by Peggy 20160406
			  " from (SELECT  row_number() over(partition by ADVISE_LINE_ID order by carton_num desc) advise_line_cnt,"+
			  " row_number() over(partition by ADVISE_LINE_ID,carton_num order by lot_number) carton_cnt,"+
			  " sum(LOT_ALLOT_QTY) over(partition by ADVISE_LINE_ID order by carton_num desc) advise_line_sum,"+
			  " sum(LOT_ALLOT_QTY) over(partition by ADVISE_LINE_ID,carton_num order by lot_number) carton_sum,"+
			  " count(distinct LOT_NUMBER) over(partition by ADVISE_LINE_ID,CUST_PARTNO,carton_num) carton_lot_cnt,"+
			  " a.* FROM TABLE(TEW_RCV_PKG.GET_LOT_ALLOT_VIEW(?)) a"+
			  " ) b "+
			  ",TSC.TSC_SHIPPING_ADVISE_LINES c"+
			  ",PO_HEADERS_ALL d"+
			  " WHERE b.ADVISE_LINE_ID=c.ADVISE_LINE_ID  "+
			  " AND b.PO_HEADER_ID=d.PO_HEADER_ID(+)"+
			  " order by CARTON_NUM,ADVISE_LINE_ID,ADVISE_LINE_CNT desc,CARTON_CNT desc";
	}		  
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,ADVISENO);
	if (ATYPE.equals(""))
	{
		statement.setString(2,"TEW");
	}
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{	
		//if ((!ADVISE_LINE_ID.equals(rs.getString("ADVISE_LINE_ID")) || rs.getInt("LOT_CNT") !=1 || !LOT.equals(rs.getString("LOT_NUMBER"))) || !CNO.equals(rs.getString("CARTON_NUM")))
		//if ((!ADVISE_LINE_ID.equals(rs.getString("ADVISE_LINE_ID")) || (rs.getInt("LOT_CNT") !=1 && lot_cnt!=rs.getInt("LOT_CNT"))) || (!CNO.equals(rs.getString("CARTON_NUM")) && !LOT.equals(rs.getString("LOT_NUMBER"))))		
		if (!so_line_id.equals(rs.getString("so_line_id")))
		{
			if (!so_line_id.equals("")) ws.addCell(new jxl.write.Number(12, row-1, Double.valueOf(""+(so_line_qty/1000)).doubleValue() , ARightL));
			so_line_id=rs.getString("so_line_id");   //add by Peggy 20160303	
			so_line_qty = 0;  //add by Peggy 20160303	
		}
		if (rs.getInt("CARTON_CNT")==1)
		{
			so_line_qty +=(rs.getFloat("PC_CONFIRM_QTY")*1000);
		}
		if (reccnt ==0 || (tot_cnt>0 && tot_cnt%page_num==0) || !ADVISE_LINE_ID.equals(rs.getString("ADVISE_LINE_ID")) || (!CNO.equals(rs.getString("CARTON_NUM")) && (rs.getInt("LOT_CNT")>1 || lot_cnt >1 || !rs.getString("LOT_NUMBER").equals(LOT) || !rs.getString("DATE_CODE").equals(DC))))		
		{
 			if (tot_cnt>0)
			{
				//add by Peggy 20140902,channel well客戶箱碼在前面
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
					//ws.addCell(new jxl.write.Number(col, row-1,(TOT_QTY/1000) , ARightL));
					ws.addCell(new jxl.write.Number(col, row-1, Double.valueOf(""+(TOT_QTY/1000)).doubleValue(), ARightL));
					col++;	
				}
				else
				{
					ws.addCell(new jxl.write.Label(col, row-1, LOT_LIST,  ALeftL));
					ws.setRowView(row-1, (lot_cnt-2)*250+500);
					col++;	
					ws.addCell(new jxl.write.Label(col, row-1, DC_LIST,  ALeftL));  //add by Peggy 20141205
					col++;	
					ws.addCell(new jxl.write.Label(col, row-1,QTY_LIST , ARightL));
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
				//ws.addCell(new jxl.write.Label(col+8, row,"頁數："+((int)(reccnt/page_num)+1)+"/"+ ((int)Math.ceil((float)tot_cnt/page_num)),ARIGHT));
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
				
				ws.addCell(new jxl.write.Label(col, row, "採購單號" , ACenterBL));
				ws.setColumnView(col,18);	
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
				
				ws.addCell(new jxl.write.Label(col, row, "撿貨量(K)" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;	
																													
				ws.addCell(new jxl.write.Label(col, row, "出貨總量(K)" , ACenterBL));  //add by Peggy 20160303
				ws.setColumnView(col,12);	
				col++;	

				ws.addCell(new jxl.write.Label(col, row, "客戶標籤" , ACenterBL));  //add by Peggy 20160205
				ws.setColumnView(col,17);	
				col++;	

				ws.addCell(new jxl.write.Label(col, row, "標籤備註" , ACenterBL));  //add by Peggy 20160303
				ws.setColumnView(col,20);	
				col++;	
				row++;
			}
			
			ADVISE_LINE_ID = rs.getString("ADVISE_LINE_ID");
			CNO = rs.getString("CARTON_NUM");
			BOX_CODE=rs.getString("POST_FIX_CODE");
			LOT=rs.getString("LOT_NUMBER");
			DC=rs.getString("DATE_CODE");                    //add by Peggy 20141205
			TOT_QTY = (rs.getFloat("ALLOT_QTY")*1000);
			lot_cnt = rs.getInt("LOT_CNT");
			S_CNO=CNO;
			E_CNO=CNO;
			LOT_LIST=rs.getString("LOT_NUMBER");
			DC_LIST=rs.getString("DATE_CODE");                //add by Peggy 20141205
			QTY_LIST=rs.getString("ALLOT_QTY");
			SHIPPING_REMARK=rs.getString("SHIPPING_REMARK");  //add by Peggy 20140902
			if (SHIPPING_REMARK==null) SHIPPING_REMARK="";
				
			col=0;
			//ws.setRowView(row, 500);
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
			ws.addCell(new jxl.write.Label(col, row, rs.getString("PONO")  , ACenterL));
			col++;	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("vendor_site_code") , ALeftL));
			col++;		
			ws.addCell(new jxl.write.Label(12, row, "" , ALeftL));  //add by Peggy 20160303
			ws.addCell(new jxl.write.Label(13, row, rs.getString("CUST_LABEL_GROUP") , ALeftL));  //add by Peggy 20160205
			label_remarks=((rs.getString("CUST_ITEM")==null && rs.getString("PO_CUSTPN_LIST")==null) || (rs.getString("CUST_ITEM")!= null && rs.getString("CUST_ITEM").equals((rs.getString("PO_CUSTPN_LIST")==null?"":rs.getString("PO_CUSTPN_LIST"))))?"":"改PN");
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
			ws.addCell(new jxl.write.Label(14, row, label_remarks , ALeftL));  //add by Peggy 20160303
			row++;
			reccnt++;
			tot_cnt++;
		}
		else
		{
			E_CNO = rs.getString("CARTON_NUM");
			TOT_QTY+=(rs.getFloat("ALLOT_QTY")*1000);
			LOT_LIST=(LOT_LIST.equals("")?LOT_LIST:LOT_LIST+"\r\n")+rs.getString("LOT_NUMBER");
			DC_LIST=(DC_LIST.equals("")?DC_LIST:DC_LIST+"\r\n")+rs.getString("DATE_CODE");   //add by Peggy 20141205
			QTY_LIST=(QTY_LIST.equals("")?QTY_LIST:QTY_LIST+"\r\n")+rs.getString("ALLOT_QTY");
		}
	}
	if (tot_cnt>0)
	{
		//add by Peggy 20140902,channel well客戶箱碼在前面
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
			//ws.addCell(new jxl.write.Number(col, row-1,(TOT_QTY/1000) , ARightL));
			ws.addCell(new jxl.write.Number(col, row-1, Double.valueOf(""+(TOT_QTY/1000)).doubleValue(), ARightL));
			col++;	
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row-1, LOT_LIST,  ALeftL));
			ws.setRowView(row-1, (lot_cnt-2)*250+500);
			col++;	
			ws.addCell(new jxl.write.Label(col, row-1, DC_LIST,  ALeftL));   //add by Peggy 20141205
			col++;	
			ws.addCell(new jxl.write.Label(col, row-1,QTY_LIST , ARightL));
			col++;	
		}
		//ws.addCell(new jxl.write.Number(12, row-1, Double.valueOf(""+(Math.round(so_line_qty*1000)/1000)).doubleValue() , ARightL));
		ws.addCell(new jxl.write.Number(12, row-1, Double.valueOf(""+(so_line_qty/1000)).doubleValue() , ARightL));
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
