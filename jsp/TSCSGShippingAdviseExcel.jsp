<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Shipping Advise Doc</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCSGShippingAdviseExcel.jsp" METHOD="post" name="MYFORM">
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
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String TSCPRODGROUP=request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP="";
String CHK_PRT=request.getParameter("CHK_PRT");
if (CHK_PRT==null) CHK_PRT="";
String VENDOR_SITE_CODE=request.getParameter("VENDOR_SITE_CODE");
if (VENDOR_SITE_CODE==null) VENDOR_SITE_CODE="";
String FileName="",RPTName="",sql="",sqla="",swhere="",to_tw="",basic_package="內外P/N",package_mode="",shipping_mark="",so_no="",shipping_method="";
String shipping_mark_text ="",destination="",v_chk_rpt_name="";
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
          " tsa.SO_NO,"+
          " tsa.SO_LINE_NUMBER,"+
          " tsa.ITEM_NO,"+
          " tsa.item_desc,"+
		  " (tsa.PC_CONFIRM_QTY/1000) ship_qty,"+
          " to_char(tsa.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,"+
		  " tsa.TO_TW,"+
          " decode(tsa.TO_TW,'N','否','Y','是',to_tw) TO_TW1,"+
		  //" nvl(tssg_ship_pkg.GET_SO_SHIPPING_MARKS(tsa.advise_no,tsa.so_no),tsa.customer_name) SHIPPING_REMARK,"+ 
		  " tssg_ship_pkg.GET_SO_SHIPPING_MARKS(tsa.advise_no,tsa.so_no) SHIPPING_REMARK,"+ 
          " tsa.CUST_PO_NUMBER,"+
          " tsa.SHIPPING_METHOD,"+
		  " tsa.orig_advise_no ADVISE_NO,"+
          " case when substr(tsa.so_no,1,1)='8' then decode(oolla.item_identifier_type,'CUST',oolla.ordered_item,'')"+
		  " else decode(tsc_odr.item_identifier_type,'CUST',tsc_odr.ordered_item,'') end CUST_ITEM,"+
		  " RA.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME,"+
		  " tsa.SO_HEADER_ID,"+
		  " tsa.REGION_CODE,"+
	      " tssg_ship_pkg.GET_SO_DESTINATION(tsa.advise_no,tsa.so_header_id) destination,"+  
		  " TSC_GET_REMARK(tsa.so_header_id,'SHIPPING MARKS') shipping_mark_text,"+ 
		  " TSC_GET_OQC_RPT(tsa.SO_LINE_ID,'TEW',null) as QC_RPT_FLAG,"+ 
		  " tsa.SHIP_TO_ORG_ID,"+ 
		  " tsa.vendor_site_id,"+
		  " ap.vendor_site_code,"+
		  " tsa.PRODUCT_GROUP,"+
		  " tsa.delivery_type,"+
		  " tsa.chk_rpt_name,"+ //add by Peggy 20200713
		  " TSC_GET_SHIPPING_NOTE(tsa.so_line_id,NULL) SHIPPING_NOTE"+ //add by Peggy 20200730
          " FROM tsc.tsc_shipping_advise_pc_sg tsa,"+
          " ONT.OE_ORDER_LINES_ALL oolla,"+
		  " AR_CUSTOMERS ra,"+
		  " ap_supplier_sites_all ap,"+
		  //" (select x.order_number,y.line_number||'.'||y.shipment_number line_no,y.item_identifier_type,y.ordered_item from ont.oe_order_headers_all x,ont.oe_order_lines_all y where x.org_id=41 and x.header_id=y.header_id and y.packing_instructions='T') tsc_odr"+
		  " (select distinct x.order_number,y.line_number line_no,y.item_identifier_type,y.ordered_item from ont.oe_order_headers_all x,ont.oe_order_lines_all y where x.org_id=41 and x.header_id=y.header_id and y.packing_instructions='T') tsc_odr"+ //modify by Peggy 20211008		  
          " where tsa.orig_advise_no is not null"+
          " and tsa.so_line_id = oolla.line_id"+
		  " and tsa.CUSTOMER_ID = ra.CUSTOMER_ID"+
		  " and tsa.so_no=tsc_odr.order_number(+)"+
		  " and substr(tsa.so_line_number,1,instr(tsa.so_line_number,'.')-1)=tsc_odr.line_no(+)"+ //modify by Peggy 20211008
		  " and tsa.vendor_site_id=ap.vendor_site_id";
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
	if (!SALESAREA.equals("") && !SALESAREA.equals("--"))
	{
		swhere += " and tsa.REGION_CODE='"+ SALESAREA+"'";
	}
	if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
	{
		sql += " AND tsa.ORGANIZATION_ID='"+ORGCODE+"'";
	}	
	if (!TSCPRODGROUP.equals("--") && !TSCPRODGROUP.equals(""))
	{
		sql += " AND tsa.PRODUCT_GROUP='"+TSCPRODGROUP+"'";
	}	
	if (!CHK_PRT.equals(""))
	{
		sql += " AND exists (select 1 from tsc.tsc_shipping_advise_pc_sg x where x.CHK_RPT_NAME like '%"+CHK_PRT+"%' and x.advise_no=tsa.advise_no)";
	}
	if (!VENDOR_SITE_CODE.equals("--") && !VENDOR_SITE_CODE.equals(""))
	{
		sql += " AND tsa.vendor_site_id='"+VENDOR_SITE_CODE+"'";
	}	
	if (!AdviseNoList.equals(""))
	{
		swhere += " and tsa.orig_advise_no in ("+AdviseNoList+")";
	}
	sql +=  swhere;
	sql += " order by tsa.orig_ADVISE_NO,nvl(tsa.seq_no,99999),tsa.PRODUCT_GROUP,nvl(ap.vendor_site_code,''),tsa.REGION_CODE,tsa.SHIPPING_REMARK,tsa.item_desc,tsa.PC_ADVISE_ID,tsa.so_no,tsa.SO_LINE_NUMBER";
	
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
	
	//報表名稱平行置中    
	WritableCellFormat wRptName2 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 12, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName2.setAlignment(jxl.format.Alignment.CENTRE);	
	wRptName2.setBackground(jxl.write.Colour.YELLOW); 
	wRptName2.setWrap(true);	

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

	WritableCellFormat ALeftL1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 8,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL1.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL1.setWrap(true);
		
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
					//add by Peggy 20200925
					ws.addCell(new jxl.write.Label(col, row, "MADE IN CHINA", ALEFT ));
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
				ws.mergeCells(col, row, col+10, row);     
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
			ws.mergeCells(col, row, col+10, row);     
			ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wRptName));
			row++;
			strRPTtitle = "Shipping note";  //add by Peggy 20190425
			ws.mergeCells(col, row, col+10, row);     
			ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wRptName1));
			//row+=2;//列+1
			if (rs.getString("delivery_type")!=null &&rs.getString("delivery_type").equals("VENDOR"))
			{
				row+=1;
				ws.addCell(new jxl.write.Label(3, row, "廠商直出" ,wRptName2));
				row+=1;
			}
			else
			{
				row+=2;
			}
		
			ws.setRowView(row, 600);   
			ws.mergeCells(col, row, col+2, row);  
			ws.addCell(new jxl.write.Label(col, row,"出貨日期："+ ssd+"\r\nShipping date",ALEFT));
			ws.mergeCells(col+10, row, col+12, row);     
			ws.addCell(new jxl.write.Label(col+10, row,"Advise No："+rs.getString("advise_no"),ARIGHT));			
			row++;//列+1

			ws.setRowView(row, 850);   
			ws.addCell(new jxl.write.Label(col, row, "項次\r\nNumber" , ACenterBL));
			ws.setColumnView(col,8);	
			col++;	

			ws.addCell(new jxl.write.Label(col, row, "供應商\r\nSupplier" , ACenterBL));
			ws.setColumnView(col,14);	
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
		v_chk_rpt_name="";
		if (to_tw.equals("Y") && (shipping_mark.indexOf("元超")<0 || so_no.startsWith("1121"))) package_mode="";
		ws.setRowView(row, 800);
		//if ((to_tw.equals("Y") && !so_no.startsWith("1121")) || shipping_mark.toUpperCase().indexOf("CHANNEL WELL") >=0 || rs.getString("QC_RPT_FLAG").equals("Y") || rs.getString("QC_RPT_FLAG").equals("PDF"))
		if ((shipping_mark.indexOf("元超")>=0 && !so_no.startsWith("1121")) || (!to_tw.equals("Y") && (rs.getString("QC_RPT_FLAG").equals("Y") || rs.getString("QC_RPT_FLAG").indexOf("PDF")>=0 || shipping_mark.toUpperCase().indexOf("CHANNEL WELL") >=0 || rs.getString("item_desc").indexOf("FR107G-K-02")>=0)))
		{
			package_mode+="\r\n附"+(rs.getString("QC_RPT_FLAG").equals("PDF")?"電子檔":(rs.getString("QC_RPT_FLAG").equals("PPDF")?"電子檔及紙本":"出貨"))+"檢驗報告";  
			if (rs.getString("QC_RPT_FLAG").indexOf("PDF")>=0)
			{
			 	ws.setRowView(row, 1200);
				v_chk_rpt_name=(rs.getString("QC_RPT_FLAG").indexOf("PDF")>=0?rs.getString("CHK_RPT_NAME")+"":"");
			}
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
		if (shipping_mark.toUpperCase().indexOf("WITTY") >=0 && rs.getString("SHIP_TO_ORG_ID").equals("25856")) 
		{
			package_mode+="\r\n隨機文件附1號箱";
		}
		
		ws.addCell(new jxl.write.Label(col, row, ""+(reccnt+1), ALeftL));
		//ws.setColumnView(col,8);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("vendor_site_code")+"\r\n"+rs.getString("PRODUCT_GROUP") ,ACenterL));
		//ws.setColumnView(col,14);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO"),ALeftL));
		//ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("item_desc") , ALeftL));
		//ws.setColumnView(col,25);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ship_qty"))), ARightL));
		//ws.setColumnView(col,10);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		//ws.setColumnView(col,10);	
		col++;		
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_ITEM")==null?"":rs.getString("CUST_ITEM")) , ALeftL));
		//ws.setColumnView(col,20);	
		col++;		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PO_NUMBER") ,ALeftL));
		//ws.setColumnView(col,25);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, shipping_mark  , ALeftL));
		//ws.setColumnView(col,20);	
		col++;
		shipping_method=rs.getString("SHIPPING_METHOD");	
		ws.addCell(new jxl.write.Label(col, row, shipping_method+ (rs.getString("shipping_note")==null?"":"\r\n("+rs.getString("shipping_note")+")"), ALeftL));
		//ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, package_mode , ALeftL));
		//ws.setColumnView(col,15);	
		col++;	
		ws.addCell(new jxl.write.Label(col, row, v_chk_rpt_name, ALeftL1));
		//ws.setColumnView(col,10);	
		col++;
		ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		//ws.setColumnView(col,10);	
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
			//add by Peggy 20200925
			ws.addCell(new jxl.write.Label(col, row, "MADE IN CHINA", ALEFT ));
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
		ws.mergeCells(col, row, col+10, row);     
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
