<!-- modify by Peggy 20140902,客戶=CHANNEL WELL, 箱碼固定為D,且放置在箱數前面,例D1,D2..-->
<!-- modify by Peggy 20151118,增加調撥數量,調撥日期欄位-->
<!-- modify by Peggy 20160202,新增備註欄位-->
<!-- modify by Peggy 20160620,驗收單號改放至tsc_pick_confirm_lines-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TEWStockOverviewReport.jsp" METHOD="post" name="MYFORM">
<%
String RTYPE=request.getParameter("RTYPE");
if (RTYPE==null) RTYPE="";
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr="--";
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="--";
String DayFr=request.getParameter("DAYFR");
if (DayFr==null || DayFr.equals("--")) DayFr="01";
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo="--"; 
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="--";
String DayTo=request.getParameter("DAYTO");
if (DayTo==null || DayTo.equals("--")) DayTo=dateBean.getDayString();
if (RTYPE.equals("AUTO"))
{
	dateBean.setAdjDate(-1);
	YearFr = YearTo= dateBean.getYearString();
	MonthFr = MonthTo = dateBean.getMonthString();
	DayFr = "01";
	DayTo=dateBean.getDayString();
	//dateBean.setAdjDate(1);
}

String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",sqlx="",sqly="",where="",destination="",remarks;
int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,line=0,mergeCol=0;
	String column1="",column2="",column3="",column4="",column5="",mo_CRD="",mo_QTY="",mo_PRICE="",mo_SSD="";
	OutputStream os = null;	
	RPTName = "TewStockOverView";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setVerticalFreeze(2);  //凍結窗格
	for (int g =1 ; g <=6 ;g++ )
	{
		sst.setHorizontalFreeze(g);
	}
	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置左-格線-底色黃
	WritableCellFormat LeftBLY = new WritableCellFormat(font_bold);   
	LeftBLY.setAlignment(jxl.format.Alignment.LEFT);
	LeftBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	LeftBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	LeftBLY.setBackground(jxl.write.Colour.YELLOW); 
	LeftBLY.setWrap(true);	

	
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(font_nobold);   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(font_nobold);   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(font_nobold);   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
	
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();

	sql = " SELECT tot.vendor_site_code,"+
          " tot.po_no,"+
          " tot.po_header_id,"+
          " tot.item_name,"+
          " tot.item_desc,"+
          " tot.inventory_item_id,"+
          " tot.lot_number,"+
          " tot.date_code,"+
          " to_char (tot.received_date, 'yyyy/mm/dd') received_date,"+
          " tot.order_number,"+
          " tot.line_number,"+
          " tot.cust_partno,"+
          " to_char (tot.return_date, 'yyyy/mm/dd') return_date,"+
          " to_char (tot.allocation_date, 'yyyy/mm/dd') allocation_date,"+
          " tot.tew_advise_no,"+
          " tot.so_no,"+
          " tot.shipping_remark,"+
          " TO_CHAR (tot.pc_schedule_ship_date, 'yyyy/mm/dd') pc_schedule_ship_date,"+
          " tot.post_fix_code,"+
          " TO_CHAR (tot.pick_confirm_date, 'yyyy/mm/dd') pick_confirm_date,"+
          " tot.receipt_num,"+
          " tot.invoice_no,"+
          " tot.delivery_name,"+
          " tot.so_header_id,"+
          " tot.to_tw,"+
          " tot.remark,"+
		  " TEW_RCV_PKG.GET_ORDER_CARTON_LIST('LOT',tot.seq_id,tot.so_header_id,tot.tew_advise_no,'0') carton_list,"+
		  " SUM (tot.opening_qty) opening_qty,"+
          " SUM (tot.received_qty) received_qty,"+
          " SUM (tot.allot_qty) allot_qty,"+
          " SUM (tot.onhand) onhand,"+
          " SUM (return_quantity) return_qty,"+
          " SUM (allocation_quantity) allocation_qty,"+
          " MIN (carton_num_s) carton_num_s,"+
          " MAX (carton_num_e) carton_num_e,"+
          " SUM (shipped_qty) shipped_qty"+
          " FROM  (SELECT ass.vendor_site_code,"+
          "       trh.po_no,"+
          "       trh.po_header_id,"+
          "       trh.item_name,"+
          "       trh.item_desc,"+
          "       trh.inventory_item_id,"+
          "       trh.po_line_location_id,"+
          "       trd.seq_id,"+
          "       trd.lot_number,"+
          "       trd.date_code,"+
          "       trd.received_date,"+
          "       case when trd.received_date not between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then trd.received_quantity - NVL (tls.ship_qty, 0) else 0 end as opening_qty,"+
          "       case when trd.received_date between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then trd.received_quantity - NVL (tls.ship_qty, 0) + NVL(trr.OLD_RECEIVED_QUANTITY,0) else 0 end as received_qty,"+
          "       NVL (tla.allot_qty, 0) allot_qty,"+
          "       trd.received_quantity - NVL (tls.ship_qty, 0) - NVL (tla.allot_qty, 0)  + NVL(trr.OLD_RECEIVED_QUANTITY,0) onhand,"+
          "       odr.order_number,"+
          "       odr.line_number,"+
          "       NVL (odr.cust_partno, decode(trh.po_line_location_id,3619679,'4502A07XXXX0JPLF',pla.note_to_vendor)) cust_partno,"+
          "       0 return_quantity,"+
		  "       0 allocation_quantity,"+
          "       NULL return_date,"+
		  "       NULL allocation_date,"+
          "       NULL tew_advise_no,"+
          "       NULL advise_line_id,"+
          "       NULL so_no,"+
          "       NULL shipping_remark,"+
          "       NULL pc_schedule_ship_date,"+
          "       NULL post_fix_code,"+
          "       NULL pick_confirm_date,"+
          "       NULL receipt_num,"+
          "       NULL invoice_no,"+
          "       NULL delivery_name,"+
          "       NULL carton_num_s,"+
          "       NULL carton_num_e,"+
          "       0 shipped_qty,"+
          "       'N' AS to_tw,"+
          "       0 AS so_header_id,"+
          "       '' remark"+
          "       FROM oraddman.tewpo_receive_header trh,"+
          "            oraddman.tewpo_receive_detail trd,"+
          "            ap.ap_supplier_sites_all ass,"+
          "            (SELECT po_header_id,"+
          "                   po_line_location_id,"+
          "                   seq_id,"+
          "                   lot_number,"+
          "                   SUM (allot_qty) / 1000 allot_qty"+
          "            FROM oraddman.tew_lot_allot_detail"+
          "            WHERE confirm_flag <> 'Y'"+
          "            and LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999"+
          "            GROUP BY po_header_id, po_line_location_id, seq_id, lot_number) tla,"+
          "            (SELECT po_header_id,"+
          "                    po_line_location_id,"+
          "                    seq_id,"+
          "                    lot_number,"+
          "                    SUM (allot_qty) / 1000 ship_qty"+
          "            FROM oraddman.tew_lot_allot_detail"+
          "            WHERE confirm_flag = 'Y'"+
          "            AND LAST_UPDATE_DATE  <= (to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999)"+
          "            GROUP BY po_header_id,po_line_location_id,seq_id,lot_number) tls,"+      
		  "            (select SEQ_ID,PO_LINE_LOCATION_ID,OLD_LOT_NUMBER,SUM(OLD_RECEIVED_QUANTITY) OLD_RECEIVED_QUANTITY from oraddman.tewpo_receive_revise  where OLD_RECEIVED_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999  "+
          "             and APPROVE_FLAG='Y' AND to_char(LAST_UPDATE_DATE,'yyyymm')<>to_char(OLD_RECEIVED_DATE,'yyyymm')"+
          "             AND change_type = '2'"+
          "             AND LAST_UPDATE_DATE  >  (to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999)"+
          "             and NEW_SEQ_ID=SEQ_ID"+
          "             and OLD_LOT_NUMBER=NEW_LOT_NUMBER"+
          "             AND OLD_DATE_CODE=NEW_DATE_CODE"+
          "             AND NEW_RECEIVED_QUANTITY=0"+
          "             GROUP BY  SEQ_ID,PO_LINE_LOCATION_ID,OLD_LOT_NUMBER) trr ,"+                   
          "            (SELECT * FROM (SELECT a.order_number,"+
          "                                  b.line_number,"+
          "                                  DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,"+
          "                                  ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number ORDER BY shipment_number) seqno"+
          "                           FROM ont.oe_order_headers_all a,"+
          "                                ont.oe_order_lines_all b"+
          "                           WHERE a.header_id = b.header_id)"+
          "            WHERE seqno = 1) odr,"+
          "            po.po_line_locations_all pll,"+
          "            po.po_lines_all pla"+
          "       WHERE     trh.po_line_location_id = trd.po_line_location_id"+
          "       AND trh.vendor_site_id = ass.vendor_site_id"+
          "       AND trd.po_line_location_id = tla.po_line_location_id(+)"+
          "       AND trd.seq_id = tla.seq_id(+)"+
          "       AND trd.lot_number = tla.lot_number(+)"+
          "       AND trd.po_line_location_id = tls.po_line_location_id(+)"+
          "       AND trd.seq_id = tls.seq_id(+)"+
          "       AND trd.lot_number = tls.lot_number(+)"+
          "       AND trh.po_line_location_id = pll.line_location_id(+)"+
          "       AND trd.po_line_location_id = trr.po_line_location_id(+)"+
          "       AND trd.seq_id = trr.seq_id(+)"+
          "       AND pll.po_line_id = pla.po_line_id"+
          "       AND pll.po_header_id = pla.po_header_id"+
          "       AND SUBSTR (pll.note_to_receiver,1,INSTR (pll.note_to_receiver, '.') - 1) =odr.order_number(+)"+
          "       AND SUBSTR (pll.note_to_receiver,INSTR (pll.note_to_receiver, '.') + 1,LENGTH (pll.note_to_receiver)) = odr.line_number(+)"+
          "       AND   trd.received_quantity - NVL (tls.ship_qty, 0) + NVL (tla.allot_qty, 0) + NVL(trr.OLD_RECEIVED_QUANTITY,0) > 0"+
          "       AND trd.RECEIVED_DATE <=  to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999"+
          "       UNION ALL"+
          "       SELECT ass.vendor_site_code,"+
          "       trh.po_no,"+
          "       trh.po_header_id,"+
          "       trh.item_name,"+
          "       trh.item_desc,"+
          "       trh.inventory_item_id,"+
          "       trh.po_line_location_id,"+
          "       trr.seq_id,"+
          "       trr.lot_number,"+
          "       trr.date_code,"+
          "       trr.received_date,"+
          "       case when trr.received_date not between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then trr.return_quantity else 0 end as opening_qty,"+
          "       case when trr.received_date between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then trr.return_quantity else 0 end as received_qty,"+
          "       0 allot_qty,"+
          "       trr.return_quantity-trr.return_quantity_1 onhand,"+
          "       odr.order_number,"+
          "       odr.line_number,"+
          "       NVL (odr.cust_partno,  decode(trh.po_line_location_id,3619679,'4502A07XXXX0JPLF',pla.note_to_vendor)) cust_partno,"+
          "       trr.return_quantity_1 return_quantity,"+
		  "       0 allocation_quantity,"+
          "       trr.return_date,"+
		  "       NULL allocation_date,"+
          "       NULL tew_advise_no,"+
          "       NULL advise_line_id,"+
          "       NULL so_no,"+
          "       NULL shipping_remark,"+
          "       NULL pc_schedule_ship_date,"+
          "       NULL post_fix_code,"+
          "       NULL pick_confirm_date,"+
          "       NULL receipt_num,"+
          "       NULL invoice_no,"+
          "       NULL delivery_name,"+
          "       NULL carton_num_s,"+
          "       NULL carton_num_e,"+
          "       0 shipped_qty,"+
          "       'N' AS to_tw,"+
          "       0 AS so_header_id,"+
          "       trr.remark "+
          "       FROM oraddman.tewpo_receive_header trh,"+
          "       (SELECT po_line_location_id,"+
          "               seq_id,"+
          "               new_lot_number lot_number,"+
          "               new_date_code date_code,"+
          "               new_received_date received_date,"+
          "               case when LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then TRUNC (LAST_UPDATE_DATE) else null end as return_date,"+
          "               SUM ( (old_received_quantity - new_received_quantity)) return_quantity,"+
          "               SUM (case when LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then  (old_received_quantity - new_received_quantity) else 0 end ) "+
          "               return_quantity_1,"+
          "               case when LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then remark else '' end as remark"+
          "        FROM oraddman.tewpo_receive_revise"+
          "        WHERE NVL (approve_flag, 'N') = 'Y' AND change_type = '1' "+
          "        AND (CREATION_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.999999"+
          "        OR LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.999999"+
		  "        OR OLD_RECEIVED_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.999999)"+
          "        GROUP BY po_line_location_id,"+
          "                 seq_id,"+
          "                 new_lot_number,"+
          "                 new_date_code,"+
          "                 new_received_date,"+
          "                 case when LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then TRUNC (LAST_UPDATE_DATE) else null end,"+
          "                 case when LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then remark else '' end) trr,"+
          "        ap.ap_supplier_sites_all ass,"+
          "        (SELECT * FROM (SELECT a.order_number, b.line_number, DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,"+
          "                               ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number ORDER BY shipment_number) seqno"+
          "                        FROM ont.oe_order_headers_all a,"+
          "                             ont.oe_order_lines_all b"+
          "                        WHERE a.header_id = b.header_id)"+
          "        WHERE seqno = 1) odr,"+
          "        po.po_line_locations_all pll,"+
          "        po.po_lines_all pla"+
          "        WHERE     trh.po_line_location_id = trr.po_line_location_id"+
          "        AND trh.vendor_site_id = ass.vendor_site_id"+
          "        AND trh.po_line_location_id = pll.line_location_id(+)"+
          "        AND pll.po_line_id = pla.po_line_id"+
          "        AND pll.po_header_id = pla.po_header_id"+
          "        AND SUBSTR (pll.note_to_receiver,1,INSTR (pll.note_to_receiver, '.') - 1) = odr.order_number(+)"+
          "        AND SUBSTR (pll.note_to_receiver,INSTR (pll.note_to_receiver, '.') + 1,LENGTH (pll.note_to_receiver)) = odr.line_number(+)"+
	      "        UNION ALL"+
          "       SELECT ass.vendor_site_code,"+
          "       trh.po_no,"+
          "       trh.po_header_id,"+
          "       trh.item_name,"+
          "       trh.item_desc,"+
          "       trh.inventory_item_id,"+
          "       trh.po_line_location_id,"+
          "       tra.seq_id,"+
          "       tra.lot_number,"+
          "       tra.date_code,"+
          "       tra.received_date,"+
          "       case when tra.received_date not between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then tra.allocation_quantity else 0 end as opening_qty,"+
          "       case when tra.received_date between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then tra.allocation_quantity else 0 end as received_qty,"+
          "       0 allot_qty,"+
          "       tra.allocation_quantity-tra.allocation_quantity_1 onhand,"+
          "       odr.order_number,"+
          "       odr.line_number,"+
          "       NVL (odr.cust_partno,  decode(trh.po_line_location_id,3619679,'4502A07XXXX0JPLF',pla.note_to_vendor)) cust_partno,"+
		  "       0 return_quantity,"+
          "       tra.allocation_quantity_1 allocation_quantity,"+
          "       NULL return_date,"+
		  "       tra.allocation_date,"+
          "       NULL tew_advise_no,"+
          "       NULL advise_line_id,"+
          "       NULL so_no,"+
          "       NULL shipping_remark,"+
          "       NULL pc_schedule_ship_date,"+
          "       NULL post_fix_code,"+
          "       NULL pick_confirm_date,"+
          "       NULL receipt_num,"+
          "       NULL invoice_no,"+
          "       NULL delivery_name,"+
          "       NULL carton_num_s,"+
          "       NULL carton_num_e,"+
          "       0 shipped_qty,"+
          "       'N' AS to_tw,"+
          "       0 AS so_header_id,"+
          "       tra.remark "+
          "       FROM oraddman.tewpo_receive_header trh,"+
          "       (SELECT po_line_location_id,"+
          "               seq_id,"+
          "               new_lot_number lot_number,"+
          "               new_date_code date_code,"+
          "               new_received_date received_date,"+
          "               case when LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then TRUNC (LAST_UPDATE_DATE) else null end as allocation_date,"+
          "               SUM ( (old_received_quantity - new_received_quantity)) allocation_quantity,"+
          "               SUM (case when LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then  (old_received_quantity - new_received_quantity) else 0 end ) "+
          "               allocation_quantity_1,"+
          "               case when LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then remark else '' end as remark"+
          "        FROM oraddman.tewpo_receive_revise"+
          "        WHERE NVL (approve_flag, 'N') = 'Y' AND change_type = '3' "+
          "        AND (CREATION_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.999999"+
          "        OR LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.999999"+
		  "        OR OLD_RECEIVED_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.999999)"+
          "        GROUP BY po_line_location_id,"+
          "                 seq_id,"+
          "                 new_lot_number,"+
          "                 new_date_code,"+
          "                 new_received_date,"+
          "                 case when LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then TRUNC (LAST_UPDATE_DATE) else null end,"+
          "                 case when LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then remark else '' end) tra,"+
          "        ap.ap_supplier_sites_all ass,"+
          "        (SELECT * FROM (SELECT a.order_number, b.line_number, DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,"+
          "                               ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number ORDER BY shipment_number) seqno"+
          "                        FROM ont.oe_order_headers_all a,"+
          "                             ont.oe_order_lines_all b"+
          "                        WHERE a.header_id = b.header_id)"+
          "        WHERE seqno = 1) odr,"+
          "        po.po_line_locations_all pll,"+
          "        po.po_lines_all pla"+
          "        WHERE  trh.po_line_location_id = tra.po_line_location_id"+
          "        AND trh.vendor_site_id = ass.vendor_site_id"+
          "        AND trh.po_line_location_id = pll.line_location_id(+)"+
          "        AND pll.po_line_id = pla.po_line_id"+
          "        AND pll.po_header_id = pla.po_header_id"+
          "        AND SUBSTR (pll.note_to_receiver,1,INSTR (pll.note_to_receiver, '.') - 1) = odr.order_number(+)"+
          "        AND SUBSTR (pll.note_to_receiver,INSTR (pll.note_to_receiver, '.') + 1,LENGTH (pll.note_to_receiver)) = odr.line_number(+)"+
	      "        UNION ALL"+
          "        SELECT ass.vendor_site_code,"+
          "        trh.po_no,"+
          "        trh.po_header_id,"+
          "        trh.item_name,"+
          "        trh.item_desc,"+
          "        trh.inventory_item_id,"+
          "        trh.po_line_location_id,"+
          "        trd.seq_id,"+
          "        trd.lot_number,"+
          "        trd.date_code,"+
          "        trd.received_date,"+
          "        case when trd.received_date not between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then ship.shipped_qty else 0 end as opening_qty,"+
          "        case when trd.received_date between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999 then ship.shipped_qty else 0 end as received_qty,"+
          "        0 allot_qty,"+
          "        0 onhand,"+
          "        odr.order_number,"+
          "        odr.line_number,"+
          "        NVL (odr.cust_partno,  decode(trh.po_line_location_id,3619679,'4502A07XXXX0JPLF',pla.note_to_vendor)) cust_partno,"+
          "        0 return_quantity,"+
		  "        0 allocation_quantity,"+
          "        NULL return_date,"+
		  "        NULL allocation_date,"+
          "        ship.tew_advise_no,"+
          "        ship.advise_line_id,"+
          "        ship.so_no,"+
          "        ship.shipping_remark,"+
          "        ship.pc_schedule_ship_date,"+
          "        ship.post_fix_code,"+
          "        ship.pick_confirm_date,"+
          "        ship.receipt_num,"+
          "        ship.invoice_no,"+
          "        ship.delivery_name,"+
          "        ship.carton_num_s,"+
          "        ship.carton_num_e,"+
          "        ship.shipped_qty,"+
          "        ship.to_tw,"+
          "        ship.so_header_id,"+
          "        '' remark"+
          "        FROM oraddman.tewpo_receive_detail trd,"+
          "        oraddman.tewpo_receive_header trh,"+
          "        ap.ap_supplier_sites_all ass,"+
          "        (SELECT *  FROM (SELECT a.order_number,b.line_number, DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,"+
          "                         ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number  ORDER BY shipment_number) seqno"+
          "                         FROM ont.oe_order_headers_all a,"+
          "                         ont.oe_order_lines_all b"+
          "                         WHERE a.header_id = b.header_id)"+
          "        WHERE seqno = 1) odr,"+
          "        po.po_line_locations_all pll,"+
          "        po.po_lines_all pla,"+
          "        (SELECT tsal.tew_advise_no,"+
          "                tsal.advise_line_id,"+
          "                tsal.so_no,"+
          "                tsal.so_header_id,"+
          "                tsal.shipping_remark,"+
          "                TRUNC (tsal.pc_schedule_ship_date) pc_schedule_ship_date,"+
          "                tlad.po_line_location_id,"+
          "                tlad.seq_id,"+
          "                tlad.lot_number,"+
          "                tsah.post_fix_code,"+
          "                TRUNC (tpcl.pick_confirm_date) pick_confirm_date,"+
          //"                tpch.receipt_num,"+ //add by Peggy 20160620
		  "                tpcl.receipt_num,"+
          "                tvil.invoice_no,"+
          "                tadl.delivery_name,"+
          "                tsah.to_tw,"+
          "                MIN (tlad.carton_num) carton_num_s,"+
          "                MAX (tlad.carton_num) carton_num_e,"+
          "                SUM (allot_qty) / 1000 shipped_qty"+
          "        FROM tsc.tsc_shipping_advise_headers tsah,"+
          "             tsc.tsc_shipping_advise_lines tsal,"+
          "             oraddman.tew_lot_allot_detail tlad,"+
          //"             tsc.tsc_pick_confirm_headers tpch,"+
		  "             (select x.advise_header_id,x.advise_line_id,x.receipt_num,TRUNC (y.pick_confirm_date) pick_confirm_date from tsc.tsc_pick_confirm_lines x,tsc.tsc_pick_confirm_headers y where x.tew_advise_no is not null and x.advise_header_id=y.advise_header_id group by x.advise_header_id,x.advise_line_id,x.receipt_num,TRUNC (y.pick_confirm_date)) tpcl,"+  //add by Peggy 20160620
          "             (SELECT tew_advise_no, invoice_no FROM apps.tsc_vendor_invoice_lines GROUP BY tew_advise_no, invoice_no) tvil,"+
          "             (SELECT b.advise_line_id, b.delivery_name  FROM tsc.tsc_advise_dn_header_int a,tsc.tsc_advise_dn_line_int b"+
          "             WHERE a.batch_id = b.batch_id"+
          "             AND a.interface_header_id = b.interface_header_id"+
          "             AND a.advise_header_id = b.advise_header_id"+
          "             AND a.status = 'S'"+
          "             GROUP BY b.advise_line_id, b.delivery_name) tadl"+
          "        WHERE     tsah.advise_header_id = tsal.advise_header_id"+
          "        AND tsal.advise_line_id = tlad.advise_line_id"+
          "        AND tsal.advise_header_id = tpcl.advise_header_id(+)"+
          "        AND tsal.advise_line_id = tpcl.advise_line_id(+)"+
          "        AND tsal.tew_advise_no = tvil.tew_advise_no(+)"+
          "        AND tsal.advise_line_id = tadl.advise_line_id(+)"+
          "        AND tsal.tew_advise_no IS NOT NULL"+
          "        AND tlad.confirm_flag = 'Y'"+
          "        AND tlad.LAST_UPDATE_DATE between to_date('"+YearFr+"/"+MonthFr+"/"+DayFr+"','yyyy/mm/dd') and to_date('"+YearTo+"/"+MonthTo+"/"+DayTo+"','yyyy/mm/dd')+0.99999"+
          "        GROUP BY tsal.tew_advise_no,"+
          "                 tsal.advise_line_id,"+
          "                 tsal.so_no,"+
          "                 tsal.so_header_id,"+
          "                 tsal.shipping_remark,"+
          "                 TRUNC (tsal.pc_schedule_ship_date),"+
          "                 tlad.po_line_location_id,"+
          "                 tlad.seq_id,"+
          "                 tlad.lot_number,"+
          "                 tsah.post_fix_code,"+
          "                 TRUNC (tpcl.pick_confirm_date),"+
          "                 tpcl.receipt_num,"+
          "                 tvil.invoice_no,"+
          "                 tadl.delivery_name,"+
          "                 tsah.to_tw"+
          "        ORDER BY tsal.advise_line_id, carton_num_s) ship"+
          " WHERE     trh.po_line_location_id = trd.po_line_location_id"+
          " AND trh.vendor_site_id = ass.vendor_site_id"+
          " AND trh.po_line_location_id = pll.line_location_id(+)"+
          " AND pll.po_line_id = pla.po_line_id"+
          " AND pll.po_header_id = pla.po_header_id"+
          " AND SUBSTR (pll.note_to_receiver,1,INSTR (pll.note_to_receiver, '.') - 1) = odr.order_number(+)"+
          " AND SUBSTR (pll.note_to_receiver,INSTR (pll.note_to_receiver, '.') + 1,LENGTH (pll.note_to_receiver)) =odr.line_number(+)"+
          " AND trd.po_line_location_id = ship.po_line_location_id"+
          " AND trd.seq_id = ship.seq_id) tot"+
          " GROUP BY tot.vendor_site_code,"+
          " tot.po_no,"+
          " tot.po_header_id,"+
          " tot.item_name,"+
          " tot.item_desc,"+
          " tot.inventory_item_id,"+
          " tot.lot_number,"+
          " tot.date_code,"+
          " tot.received_date,"+
          " tot.order_number,"+
          " tot.line_number,"+
          " tot.cust_partno,"+
          " tot.return_date,"+
		  " tot.allocation_date,"+
          " tot.tew_advise_no,"+
          " tot.so_no,"+
          " tot.shipping_remark,"+
          " tot.pc_schedule_ship_date,"+
          " tot.post_fix_code,"+
          " tot.pick_confirm_date,"+
          " tot.receipt_num,"+
          " tot.invoice_no,"+
          " tot.delivery_name,"+
          " tot.so_header_id,"+
          " tot.to_tw,"+
          " tot.remark,"+
		  " tot.seq_id"+
		  " ORDER BY tot.received_date, tot.vendor_site_code, tot.item_desc,tot.lot_number,tot.date_code";
	//out.println(sql);
	//out.println(sqlx);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//資料日期
			ws.mergeCells(col, row, col+2, row);     
			ws.addCell(new jxl.write.Label(col, row, "資料日期:" +YearFr+"/"+MonthFr+"/"+DayFr+"~"+YearTo+"/"+MonthTo+"/"+DayTo, LeftBLY));
			row++;
						
			//收料日期
			ws.addCell(new jxl.write.Label(col, row, "收料日期" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,24);	
			col++;	

			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,24);	
			col++;	

			//LOT
			ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//D/C
			ws.addCell(new jxl.write.Label(col, row, "D/C" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//期初數量(K)
			ws.addCell(new jxl.write.Label(col, row, "期初數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//收貨數量(K)
			ws.addCell(new jxl.write.Label(col, row, "收貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//退貨數量
			ws.addCell(new jxl.write.Label(col, row, "退貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//調撥數量
			ws.addCell(new jxl.write.Label(col, row, "調撥數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//撿貨數量
			ws.addCell(new jxl.write.Label(col, row, "撿貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//出貨數量(K)
			ws.addCell(new jxl.write.Label(col, row, "出貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		

			//庫存
			ws.addCell(new jxl.write.Label(col, row, "庫存數量(K)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//M/O單號
			ws.addCell(new jxl.write.Label(col, row, "收貨MO#" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//客戶品號
			ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//採購單號
			ws.addCell(new jxl.write.Label(col, row, "採購單號" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//Advise No
			ws.addCell(new jxl.write.Label(col, row, "Advise No" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//出貨MO
			ws.addCell(new jxl.write.Label(col, row, "出貨MO#" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;		
									
			//嘜頭
			ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	
				
			//目的地
			ws.addCell(new jxl.write.Label(col, row, "目的地" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;					
					
			//出貨日期
			ws.addCell(new jxl.write.Label(col, row, "出貨日期" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
						
			//箱號
			ws.addCell(new jxl.write.Label(col, row, "箱號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			//ERP交易日
			ws.addCell(new jxl.write.Label(col, row, "ERP交易日" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
			
			//驗收單號
			ws.addCell(new jxl.write.Label(col, row, "驗收單號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;					
						
			//供應商發票號
			ws.addCell(new jxl.write.Label(col, row, "供應商發票號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
					
			//台半發票號
			ws.addCell(new jxl.write.Label(col, row, "台半發票號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	
																					
			//退貨日期
			ws.addCell(new jxl.write.Label(col, row, "退貨日期" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//退貨原因
			ws.addCell(new jxl.write.Label(col, row, "退貨原因" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;

			//調撥日期
			ws.addCell(new jxl.write.Label(col, row, "調撥日期" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//備註
			ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;
						
			row++;
		}
		col=0;

		destination="";
		if (rs.getString("so_no") != null)
		{
			if (rs.getString("to_tw").equals("N"))
			{
				sql = " SELECT  FDLT.LONG_TEXT  FROM FND_ATTACHED_DOCS_FORM_VL FADFV, FND_DOCUMENTS_LONG_TEXT FDLT"+
					  " WHERE FADFV.FUNCTION_NAME = 'OEXOEORD' AND FADFV.CATEGORY_DESCRIPTION = 'SHIPPING MARKS' AND FADFV.PK1_VALUE = to_char(?) AND FADFV.MEDIA_ID = FDLT.MEDIA_ID  AND fadfv.USER_ENTITY_NAME = 'OM Order Header'";  
				//out.println(sql);
				//out.println(rs.getString("so_header_id"));
				PreparedStatement statementp = con.prepareStatement(sql);
				statementp.setString(1,rs.getString("so_header_id"));
				ResultSet rsp=statementp.executeQuery();
				if  (rsp.next())
				{
					String splitStr[] = rsp.getString("LONG_TEXT").split("\n");	
					for (int k=0;k <splitStr.length;k++)
					{
						if (splitStr[k].indexOf("C/N")>=0 || splitStr[k].indexOf("C/O NO")>=0)
						{
							for (int m=k-1 ; m>=0 ; m--)
							{
								if (splitStr[m].equals("") || splitStr[m].indexOf("P/NO") >= 0 || splitStr[m].indexOf("P/N NO")>=0 || splitStr[m].indexOf("P/O NO")>=0) continue;
								destination = splitStr[m].replace("CHINA","");
								break;
							}
						}
					}			
				}
				rsp.close();
				statementp.close();
			}
			else if (rs.getString("so_no").startsWith("1121"))
			{
				destination="CKS AIRPORT";
			}
			else if (!rs.getString("so_no").startsWith("1121"))
			{
				destination="KEELUNG";
			}
		}
				
		if (rs.getString("RECEIVED_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("RECEIVED_DATE")) ,DATE_FORMAT));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("VENDOR_SITE_CODE"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("OPENING_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("RECEIVED_QTY")).doubleValue(), ARightL));
		col++;	
		if (rs.getString("RETURN_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			col++;	
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("RETURN_QTY")).doubleValue(), ARightL));
			col++;	
		}
		if (rs.getString("ALLOCATION_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			col++;	
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ALLOCATION_QTY")).doubleValue(), ARightL));
			col++;	
		}
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ALLOT_QTY")).doubleValue(), ARightL));
		col++;	
		if (rs.getString("TEW_ADVISE_NO")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SHIPPED_QTY")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ONHAND")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ORDER_NUMBER")==null?"": rs.getString("ORDER_NUMBER")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_PARTNO")==null?"":rs.getString("CUST_PARTNO")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PO_NO") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TEW_ADVISE_NO")==null?"":rs.getString("TEW_ADVISE_NO")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SO_NO")==null?"":rs.getString("SO_NO")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIPPING_REMARK")==null?"":rs.getString("SHIPPING_REMARK")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, destination , ACenterL));
		col++;	
		if (rs.getString("PC_SCHEDULE_SHIP_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("PC_SCHEDULE_SHIP_DATE")) ,DATE_FORMAT));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CARTON_LIST") , ACenterL));
		//if (rs.getString("CARTON_NUM_S")==null && rs.getString("CARTON_NUM_E")==null)
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		//}
		//else
		//{
		//	//add by Peggy 20140902,channel well客戶箱碼在前面
		//	if (rs.getString("SHIPPING_REMARK") != null && rs.getString("SHIPPING_REMARK").length()>=12 && rs.getString("SHIPPING_REMARK").substring(0,12).equals("CHANNEL WELL"))
		//	{
		//		ws.addCell(new jxl.write.Label(col, row, rs.getString("POST_FIX_CODE")+rs.getString("CARTON_NUM_S")+(rs.getString("CARTON_NUM_S").equals(rs.getString("CARTON_NUM_E"))?"":" - " +rs.getString("POST_FIX_CODE") + rs.getString("CARTON_NUM_E")), ACenterL));
		//	}
		//	else
		//	{
		//		ws.addCell(new jxl.write.Label(col, row, rs.getString("CARTON_NUM_S")+rs.getString("POST_FIX_CODE") +(rs.getString("CARTON_NUM_S").equals(rs.getString("CARTON_NUM_E"))?"":" - " + rs.getString("CARTON_NUM_E")+rs.getString("POST_FIX_CODE")), ACenterL));
		//	}
		//}
		col++;	
		if (rs.getString("PICK_CONFIRM_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("PICK_CONFIRM_DATE")) ,DATE_FORMAT));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("RECEIPT_NUM") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("INVOICE_NO") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DELIVERY_NAME") , ACenterL));
		col++;	
		if (rs.getString("RETURN_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			col++;	
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("RETURN_DATE")) ,DATE_FORMAT));
			col++;	
		}
		ws.addCell(new jxl.write.Label(col, row, rs.getString("remark") ,  ALeftL));
		col++;	
		if (rs.getString("ALLOCATION_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
			col++;	
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("ALLOCATION_DATE")) ,DATE_FORMAT));
			col++;	
		}
		if (rs.getString("LOT_NUMBER").equals("BN11-135") && rs.getString("TEW_ADVISE_NO")!=null && rs.getString("TEW_ADVISE_NO").equals("20160121113"))
		{
			remarks ="實際出貨LOT=BD17-174 18K";
		}
		else
		{
			remarks ="";
		}
		ws.addCell(new jxl.write.Label(col, row, remarks , ALeftL));
		col++;			
		row++;
		
		reccnt ++;
	}	
	wwb.write(); 
	wwb.close();

	rs.close();
	statement.close();

	if (RTYPE.equals("AUTO") && reccnt>0)
	{
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		remarks="";
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			remarks="(This is a test letter, please ignore it)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("jojo@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ivy@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("zhangdi@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("sunjun@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("coco@mail.tew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("eva@mail.tew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("aggie@mail.tew.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("wws@mail.tew.com.cn"));
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ian@mail.tew.com.cn"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject("TEW In & Out Stock Report - "+dateBean.getYearMonthDay()+remarks);
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		mbp = new javax.mail.internet.MimeBodyPart();
		javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
		mbp.setDataHandler(new javax.activation.DataHandler(fds));
		mbp.setFileName(fds.getName());
	
		// create the Multipart and add its parts to it
		mp.addBodyPart(mbp);
		message.setContent(mp);
		Transport.send(message);	
	}	 
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
	if (!RTYPE.equals("AUTO"))
	{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/report/"+FileName; 
		response.sendRedirect(strURL);
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
