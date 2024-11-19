<!-- 20150109 by Peggy, PHIHONG151 目的地顯示保稅-->
<!-- 20150703 by Peggy,新增TEW_RCV_PKG.GET_SO_DESTINATION取代JSP 取訂單目的地的code-->
<!-- 20150710 by Peggy,新增TEW_RCV_PKG.GET_SO_SHIPPING_MARKS取代JSP程式判斷code-->
<!-- 20161216 by Peggy,加入須附出貨檢驗報告資料-->
<!-- 20170524 by Peggy,客戶WITTY+SHIP_TO_ID=25856-->
<!-- 20171101 by Peggy,CHICONY-DG + 1N5406 A0G出貨通知單顯示"隨貨需提供膜厚測試數據以及彎腳鍍錫報告"-->
<!-- 20181015 by Peggy,電子檔出貨檢驗報告-->
<!-- 20190425 by Peggy,新增英文說明-->
<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>出貨通知單</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TEWShippingAdviseExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String MO = request.getParameter("MO");
if (MO==null) MO="";
String ADVISE_NO = request.getParameter("ADVISE_NO");
if (ADVISE_NO==null) ADVISE_NO="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String VENDOR = request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String ITEMNAME = request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String SALESAREA = request.getParameter("SALESAREA");
if (SALESAREA==null) SALESAREA="";
String AdviseNoList = request.getParameter("ADVISENOLIST");
if (AdviseNoList==null) AdviseNoList="";
String FileName="",RPTName="",sql="",sqla="",swhere="",to_tw="",basic_package="內外P/N",package_mode="",shipping_mark="",so_no="",shipping_method="";
String shipping_mark_text ="",destination="";
int fontsize=9,colcnt=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,totcnt=0,reccnt=0,mergeCol=0;
	String advise_no="";
	OutputStream os = null;	
	FileName = "ShippingAdvise("+UserName+")-"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
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
	settings.setZoomFactor(90);    //顯示縮放比例
	settings.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
	settings.setScaleFactor(70);   // 打印縮放比例
	settings.setHeaderMargin(0.3);
	settings.setBottomMargin(0.5);
	settings.setLeftMargin(0.2);
	settings.setRightMargin(0.2);
	settings.setTopMargin(0.5);
	settings.setFooterMargin(0.3);	
	
	sql = " select tsa.PC_ADVISE_ID,"+
          " ass.vendor_site_code,"+
          " tsa.SO_NO,"+
          " tsa.SO_LINE_NUMBER,"+
          " tsa.ITEM_NO,"+
          " tsa.item_desc,"+
          //" (tsa.ship_qty/1000) ship_qty,"+
		  " (tspp.order_qty/1000) ship_qty,"+
          " to_char(tsa.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,"+
		  " tsa.TO_TW,"+
          " decode(tsa.TO_TW,'N','否','Y','是',to_tw) TO_TW1,"+
         // " tsa.SHIPPING_REMARK,"+
		  " tew_rcv_pkg.GET_SO_SHIPPING_MARKS(tsa.advise_no,tsa.so_no) SHIPPING_REMARK,"+ //add by Peggy 20150710
          " tsa.CUST_PO_NUMBER,"+
          " tsa.SHIPPING_METHOD,"+
          //" pha.segment1 PONO,"+
		  " apps.tew_rcv_pkg.GET_ADVISE_PO(tsa.pc_advise_id,tspp.po_unit_price) PONO,"+
          " tspp.PO_UNIT_PRICE,"+
		  " tsa.orig_advise_no ADVISE_NO,"+
          " decode(oolla.item_identifier_type,'CUST',oolla.ordered_item,'') CUST_ITEM,"+
		  " RA.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME,"+
		  " tsa.SO_HEADER_ID,"+
		  " tsa.REGION_CODE,"+
	      " tew_rcv_pkg.GET_SO_DESTINATION(tsa.advise_no,tsa.so_no) destination,"+   //add by Peggy 20150703
		  " TSC_GET_REMARK(tsa.so_header_id,'SHIPPING MARKS') shipping_mark_text,"+  //add by Peggy 20150703
		  " TSC_GET_OQC_RPT(tsa.SO_LINE_ID,'TEW',null) as QC_RPT_FLAG"+ //add by Peggy 20161216
		  ",tsa.SHIP_TO_ORG_ID"+ //add by Peggy 20170524
          " FROM tsc.tsc_shipping_advise_pc_tew tsa,"+
          " ap.ap_supplier_sites_all  ass ,"+
          //" po.po_line_locations_all plla,"+
          //" po.po_headers_all pha,"+
          " ONT.OE_ORDER_LINES_ALL oolla,"+
		  " AR_CUSTOMERS ra,"+
		  " (select pc_advise_id,po_unit_price,sum(order_qty) ORDER_QTY from tsc.tsc_shipping_po_price group by pc_advise_id,po_unit_price) tspp"+
          " where shipping_from ='TEW'"+
		  " and tsa.orig_advise_no is not null"+
          " and tsa.vendor_site_id = ass.vendor_site_id"+
		  " and tsa.pc_advise_id = tspp.pc_advise_id"+
          //" and tspp.po_header_id = pha.po_header_id"+
          " and tsa.so_line_id = oolla.line_id"+
		  " and tsa.CUSTOMER_ID = ra.CUSTOMER_ID";
	if (!SDATE.equals(""))
	{
		swhere += " and tsa.PC_SCHEDULE_SHIP_DATE >= TO_DATE('"+SDATE+"','yyyymmdd')";
	}
	if (!EDATE.equals(""))
	{
		swhere += " and tsa.PC_SCHEDULE_SHIP_DATE <= TO_DATE('"+EDATE+"','yyyymmdd')";
	}
	if (!MO.equals(""))
	{
		swhere += " and tsa.SO_NO like '"+MO+"%'";
	}
	if (!PONO.equals(""))
	{
		swhere += " and exists (select 1 from tsc.tsc_shipping_po_price x,po.po_headers_all y where x.po_header_id=y.po_header_id and y.SEGMENT1 like '"+PONO+"%' and x.pc_advse_id = tsa.pc_advise_id)";
	}
	if (!ADVISE_NO.equals(""))
	{
		swhere += " and tsa.orig_ADVISE_NO like '"+ADVISE_NO+"%'";
	}
	if (!ITEMNAME.equals(""))
	{
		swhere += " and (tsa.ITEM_NO like '"+ITEMNAME +"%' OR tsa.ITEM_DESC like '"+ ITEMNAME+"%')";
	}
	if (!CUSTOMER.equals(""))
	{
		swhere += " AND RA.CUSTOMER_NAME_PHONETIC like '"+CUSTOMER+"%' ";
	}
	if (!VENDOR.equals("") && !VENDOR.equals("--"))
	{
		swhere += " and ass.vendor_site_id = '"+VENDOR+"'";
	}
	if (!SALESAREA.equals("") && !SALESAREA.equals("--"))
	{
		swhere += " and tsa.REGION_CODE='"+ SALESAREA+"'";
	}
	if (!AdviseNoList.equals(""))
	{
		swhere += " and tsa.orig_advise_no in ("+AdviseNoList+")";
	}
	sql +=  swhere;
	sql += " order by tsa.orig_ADVISE_NO,nvl(tsa.seq_no,99999),tsa.REGION_CODE,tsa.SHIPPING_REMARK,tsa.item_desc,tsa.PC_ADVISE_ID";
	
	//out.println(sql);
	
	//報表名稱平行置中    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 16, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName.setAlignment(jxl.format.Alignment.CENTRE);

	//報表名稱平行置中    
	WritableCellFormat wRptName1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 12, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName1.setAlignment(jxl.format.Alignment.CENTRE);
	
	//表尾行置中     
	WritableCellFormat wRptEnd = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptEnd.setAlignment(jxl.format.Alignment.CENTRE);
		
	//英文內文水平垂直置左  
	WritableCellFormat ALEFT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"),fontsize ,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFT.setAlignment(jxl.format.Alignment.LEFT);
	//ALEFT.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);
	ALEFT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALEFT.setWrap(true);
	
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
		
	Statement statement=con.createStatement();
	//out.println(sql+" order by to_char(tsa.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd'),tsa.advise_no");
	ResultSet rs=statement.executeQuery(sql);
	String ssd ="",so_header_id="";
	while (rs.next())
	{
		if (!advise_no.equals(rs.getString("advise_no")))
		{
			if (reccnt >0)
			{
				row+=2;
				col=0;
				ws.addCell(new jxl.write.Label(col, row, "目的地" , ALEFT ));
				ws.setColumnView(col,8);	
				col++;
				ws.addCell(new jxl.write.Label(col, row, destination, ALEFT ));
				row++;
				if (to_tw.equals("Y"))
				{
					ws.addCell(new jxl.write.Label(col, row, "C/NO", ALEFT ));
					row++;
				}
				else
				{
					if (shipping_mark.startsWith("PHIHONG"))
					{
						ws.addCell(new jxl.write.Label(col, row, "P/O NO:", ALEFT ));
						row++;
					}									
					ws.addCell(new jxl.write.Label(col, row, "C/NO.:", ALEFT ));
					row++;
					ws.addCell(new jxl.write.Label(col, row, "MADE IN CHINA", ALEFT ));
					row++;
					if (shipping_mark_text.indexOf("保稅")>=0)
					{
						ws.addCell(new jxl.write.Label(col, row, "保稅", ALEFT ));
						row++;
					}
				}
				row+=1;	
				col=0;				
				ws.mergeCells(col, row, col+13, row);     
				ws.addCell(new jxl.write.Label(col, row,"****** The copyright of document and business secret belong to TSC, and no copies should be made without any permission ******(OQ4PC06-A)" , wRptEnd));
				col=0;
				row+=2;
				ws.addRowPageBreak(row);
			}	
			ssd=rs.getString("PC_SCHEDULE_SHIP_DATE");
			advise_no = rs.getString("advise_no");	
			so_header_id = rs.getString("so_header_id");
			to_tw = rs.getString("to_tw");
			so_no = rs.getString("SO_NO");
			reccnt=0;
		}
		shipping_mark = rs.getString("SHIPPING_REMARK");
		if (shipping_mark==null) shipping_mark="";
		shipping_mark_text=rs.getString("shipping_mark_text");
		destination=rs.getString("destination");
		
		if (reccnt==0)
		{
			row++;
			String strRPTtitle = "出貨通知單";
			ws.mergeCells(col, row, col+12, row);     
			ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wRptName));
			row++;
			strRPTtitle = "Shipping note";  //add by Peggy 20190425
			ws.mergeCells(col, row, col+12, row);     
			ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wRptName1));
			//row+=2;//列+1
			row+=2;
		
			ws.setRowView(row, 600);   
			ws.mergeCells(col, row, col+2, row);  
			ws.addCell(new jxl.write.Label(col, row,"出貨日期："+ ssd+"\r\nShipping date",ALEFT));
			ws.mergeCells(col+10, row, col+12, row);     
			ws.addCell(new jxl.write.Label(col+10, row,"Advise No："+rs.getString("advise_no"),ARIGHT));
			row++;//列+1

			ws.setRowView(row, 800);   
			ws.addCell(new jxl.write.Label(col, row, "項次\r\nNumber" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "供應商\r\nSupplier" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "型號\r\nType" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "數量(K)\r\nQuality" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "箱號\r\nCarton NO." , ACenterBL));
			ws.setColumnView(col,10);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "P/N" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "P/O" , ACenterBL));
			ws.setColumnView(col,25);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "嘜頭\r\nShipping mark" , ACenterBL));
			ws.setColumnView(col,20);	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, "出貨方式\r\nShipping method" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;		
			
			ws.addCell(new jxl.write.Label(col, row, "包裝方式\r\nPacking method" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;
			
			ws.addCell(new jxl.write.Label(col, row, "採購單號\r\nPurchase order number" , ACenterBL));
			ws.setColumnView(col,15);	
			col++;
			
			ws.addCell(new jxl.write.Label(col, row, "單價\r\nUnit price" , ACenterBL));
			ws.setColumnView(col,10);	
			col++;
																									
			row++;
		}

		col=0;
		package_mode=basic_package;
		//if (to_tw.equals("Y") && !so_no.startsWith("1121"))
		//if ((to_tw.equals("Y") && !so_no.startsWith("1121")) || shipping_mark.toUpperCase().indexOf("CHANNEL WELL") >=0) //客戶:CHANNEL WELL也須附檢驗報告,add by Peggy 20140819
		ws.setRowView(row, 800);
		if ((to_tw.equals("Y") && !so_no.startsWith("1121")) || shipping_mark.toUpperCase().indexOf("CHANNEL WELL") >=0 || rs.getString("QC_RPT_FLAG").equals("Y") || rs.getString("QC_RPT_FLAG").equals("PDF")) //add by Peggy 20161216
		{
			package_mode+="\r\n附"+(rs.getString("QC_RPT_FLAG").equals("PDF")?"電子檔":"出貨")+"檢驗報告";  //modify by Peggy 20181015
		}
		else if (shipping_mark.toUpperCase().indexOf("CHICONY") >=0 )
		{
			package_mode+="\r\n附安重部品標籤";
		}
		if (shipping_mark.toUpperCase().indexOf("CHICONY") >=0 && shipping_mark.toUpperCase().indexOf("DG") >=0 && rs.getString("item_desc").equals("1N5406 A0G"))
		{
			package_mode+="\r\n隨貨需提供膜厚測試數據以及彎腳鍍錫報告";
			ws.setRowView(row, 1200);
		}
		if (shipping_mark.toUpperCase().indexOf("WITTY") >=0 && rs.getString("SHIP_TO_ORG_ID").equals("25856"))  //add by Peggy 20170524
		{
			package_mode+="\r\n隨機文件附1號箱";
		}
		
		ws.addCell(new jxl.write.Label(col, row, ""+(reccnt+1), ALeftL));
		ws.setColumnView(col,8);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("vendor_site_code") , ALeftL));
		ws.setColumnView(col,10);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO"),ALeftL));
		ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("item_desc") , ALeftL));
		ws.setColumnView(col,25);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ship_qty"))), ARightL));
		ws.setColumnView(col,10);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		ws.setColumnView(col,10);	
		col++;			
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_ITEM")==null?"":rs.getString("CUST_ITEM")) , ALeftL));
		ws.setColumnView(col,20);	
		col++;		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PO_NUMBER") ,ALeftL));
		ws.setColumnView(col,25);	
		col++;	
		//if (to_tw.equals("Y") && shipping_mark.indexOf("元超")<0)
		//{
		//	if (so_no.startsWith("1121"))
		//	{
		//		shipping_mark ="T(SAMPLE)";
		//	}
		//	else
		//	{
		//		shipping_mark ="T";
		//	}
		//}
		//else if (shipping_mark.toUpperCase().indexOf("DELTA") >=0)
		//else if (!rs.getString("REGION_CODE").equals("TSCE") && shipping_mark.toUpperCase().indexOf("DELTA") >=0)  //非歐洲區的DELTA才要轉換,modify by Peggy 20140910
		//{
		//	shipping_mark ="DELTA";
		//}
		//else if (shipping_mark.toUpperCase().indexOf("PHIHONG") >=0)
		//{
		//	shipping_mark = "PHIHONG";
		//}
		ws.addCell(new jxl.write.Label(col, row, shipping_mark  , ALeftL));
		ws.setColumnView(col,20);	
		col++;
		shipping_method=rs.getString("SHIPPING_METHOD");	
		//if (to_tw.equals("Y"))
		//{
		//	if (!shipping_method.toUpperCase().startsWith("UPS") && !shipping_method.toUpperCase().startsWith("TNT") && !shipping_method.toUpperCase().startsWith("DHL") &&  !shipping_method.toUpperCase().startsWith("FEDEX"))
		//	{
		//		shipping_method="SEA(C)";
		//	}
		//}
		ws.addCell(new jxl.write.Label(col, row, shipping_method , ALeftL));
		ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, package_mode , ALeftL));
		ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PONO")  , ALeftL));
		ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PO_UNIT_PRICE")  , ARightL));
		ws.setColumnView(col,10);	
		col++;	
																
		row++;
		reccnt++;
		totcnt++;
	}
	if (reccnt >0)
	{
		col=0;
		row++;
		ws.addCell(new jxl.write.Label(col, row, "目的地" , ALEFT ));
		ws.setColumnView(col,8);	
		col++;
		ws.addCell(new jxl.write.Label(col, row, destination, ALEFT ));
		row++;
		if (to_tw.equals("Y"))
		{
			ws.addCell(new jxl.write.Label(col, row, "C/NO", ALEFT ));
			row++;
		}
		else
		{
			if (shipping_mark.startsWith("PHIHONG"))
			{
				ws.addCell(new jxl.write.Label(col, row, "P/O NO:", ALEFT ));
				row++;
			}									
			ws.addCell(new jxl.write.Label(col, row, "C/NO.:", ALEFT ));
			row++;
			ws.addCell(new jxl.write.Label(col, row, "MADE IN CHINA", ALEFT ));
			row++;
			if (shipping_mark_text.indexOf("保稅")>=0)
			{
				ws.addCell(new jxl.write.Label(col, row, "保稅", ALEFT ));
				row++;
			}
		}
		row+=1;	
		col=0;		
		ws.mergeCells(col, row, col+12, row);     
		ws.addCell(new jxl.write.Label(col, row,"****** The copyright of document and business secret belong to TSC, and no copies should be made without any permission ******(OQ4PC06-A)" , wRptEnd));
		row++;//列+1
	}
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
