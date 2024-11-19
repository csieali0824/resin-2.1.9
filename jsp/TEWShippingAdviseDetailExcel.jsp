<!--20171204 Peggy,新增"Market Group & Market Group Desc & TSC Package"-->
<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*,java.lang.Object.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TEWShippingAdviseDetailExcel.jsp" METHOD="post" name="MYFORM">
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
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String FileName="",RPTName="",ColumnName="",sql="",swhere="";
int fontsize=9,colcnt=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	String status="";
	RPTName = "TEW_Shipping_Advise_Detail";
	FileName = RPTName+"("+userID+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置中-格線-酒紅
	WritableCellFormat CenterBL1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	CenterBL1.setAlignment(jxl.format.Alignment.CENTRE);
	CenterBL1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	CenterBL1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	CenterBL1.setBackground(jxl.write.Colour.CORAL); 
	CenterBL1.setWrap(true);	
	
	//英文內文水平垂直置中-格線-橘
	WritableCellFormat CenterBL2 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	CenterBL2.setAlignment(jxl.format.Alignment.CENTRE);
	CenterBL2.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	CenterBL2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	CenterBL2.setBackground(jxl.write.Colour.ORANGE); 
	CenterBL2.setWrap(true);		
		
	//英文內文水平垂直置中-格線-藍
	WritableCellFormat CenterBL3 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	CenterBL3.setAlignment(jxl.format.Alignment.CENTRE);
	CenterBL3.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	CenterBL3.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	CenterBL3.setBackground(jxl.write.Colour.ICE_BLUE); 
	CenterBL3.setWrap(true);
			
	//英文內文水平垂直置中-格線-綠
	WritableCellFormat CenterBL4 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	CenterBL4.setAlignment(jxl.format.Alignment.CENTRE);
	CenterBL4.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	CenterBL4.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	CenterBL4.setBackground(jxl.write.Colour.LIGHT_GREEN); 
	CenterBL4.setWrap(true);
				
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
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();
		
	int iCnt = 0;
	sql = " select tsa.PC_ADVISE_ID,"+
          " ass.vendor_site_code,"+
          " tsa.SO_NO,"+
          " tsa.SO_LINE_NUMBER,"+
          " tsa.ITEM_NO,"+
          " tsa.item_desc,"+
          " (tsa.ship_qty/1000) ship_qty,"+
          " to_char(tsa.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,"+
          " decode(tsa.TO_TW,'N','否','Y','是',to_tw) TO_TW,"+
          " tsa.SHIPPING_REMARK,"+
          " tsa.CUST_PO_NUMBER,"+
          " tsa.SHIPPING_METHOD,"+
          " pha.segment1 PONO,"+
          " tspp.PO_UNIT_PRICE,"+
		  " (tspp.order_qty/1000) order_qty,"+
		  " tsa.ADVISE_NO,"+
          " decode(oolla.item_identifier_type,'CUST',oolla.ordered_item,'') CUST_ITEM,"+
		  " RA.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME,"+
		  " tsa.REGION_CODE,"+
		  " tspp.cust_partno pc_cust_partno,"+
		  " nvl((select count(1) from tsc.tsc_shipping_advise_lines tsal where tsal.pc_advise_id = tsa.pc_advise_id and not exists (select 1 from oraddman.tew_lot_allot_detail k where k.advise_line_id= tsal.advise_line_id)),0) box_cnt,"+
		  " nvl((select count(1) from oraddman.TEW_LOT_ALLOT_DETAIL tpcl,tsc.tsc_shipping_advise_lines tsal where tpcl.advise_line_id = tsal.advise_line_id and tsal.pc_advise_id = tsa.pc_advise_id and NVL(tpcl.confirm_flag,'N') <>'Y'),0) pick_cnt,"+
		  " nvl((select count(1) from tsc.tsc_pick_confirm_headers tpc,tsc.tsc_pick_confirm_lines tpcl,tsc.tsc_shipping_advise_lines tsal where tpc.advise_header_id=tpcl.advise_header_id and tpcl.advise_line_id = tsal.advise_line_id and tsal.pc_advise_id = tsa.pc_advise_id and tpc.pick_confirm_date is not null),0) shipped_cnt,"+
		  " (select count(1) from tsc.tsc_shipping_po_price tt where tt.pc_advise_id=tsa.pc_advise_id";
	if (!PONO.equals(""))
	{ 
		sql += " and exists (select 1 from po_headers_all kk where kk.po_header_id=tt.PO_HEADER_ID and kk.segment1 LIKE '"+PONO+"%')";
	}		  
	sql +=") po_cnt"+
          ",ra.ATTRIBUTE2 market_group"+         //add by Peggy 20171204
		  ",tcl.lov_meaning market_group_desc"+  //add by Peggy 20171204
	      ",TSC_OM_CATEGORY(tsa.inventory_item_id,49,'TSC_Package') TSC_Package"+  //add by Peggy 20171204
          " FROM tsc.tsc_shipping_advise_pc_tew tsa,"+
          " ap.ap_supplier_sites_all  ass ,"+
          " po.po_headers_all pha,"+
          " ONT.OE_ORDER_LINES_ALL oolla,"+
		  " AR_CUSTOMERS ra,"+
		  " tsc.tsc_shipping_po_price tspp,"+
		  " (select * from tsc_crm_lov_v where lov_type='MARKET_GROUPS') tcl"+
          " where shipping_from ='TEW'"+
          " and tsa.vendor_site_id = ass.vendor_site_id"+
		  " and tsa.pc_advise_id = tspp.pc_advise_id(+)"+
          " and tspp.po_header_id = pha.po_header_id(+)"+
          " and tsa.so_line_id = oolla.line_id"+
		  " and tsa.CUSTOMER_ID = ra.CUSTOMER_ID"+
		  " and ra.attribute2=tcl.lov_code(+)";
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
		swhere += " and pha.SEGMENT1 like '"+PONO+"%'";
	}
	if (!ADVISE_NO.equals(""))
	{
		swhere += " and tsa.ADVISE_NO like '"+ADVISE_NO+"%'";
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
	sql +=  swhere;
	sql += " order by tsa.PC_SCHEDULE_SHIP_DATE,tsa.ADVISE_NO,tsa.REGION_CODE,tsa.SO_NO,tsa.PC_ADVISE_ID"; 
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//訂單處理狀態
			ws.addCell(new jxl.write.Label(col, row, "訂單處理狀態" , ACenterBLB));
			ws.setColumnView(col,15);
			col++;	

			//Advise NO
			ws.addCell(new jxl.write.Label(col, row, "Advise NO" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//業務區
			ws.addCell(new jxl.write.Label(col, row, "業務區" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//客戶
			ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			//嘜頭
			ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			//訂單號碼
			ws.addCell(new jxl.write.Label(col, row, "訂單號碼" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//訂單項次
			ws.addCell(new jxl.write.Label(col, row, "訂單項次" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//出貨量(K)
			ws.addCell(new jxl.write.Label(col, row, "出貨量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//出貨日
			ws.addCell(new jxl.write.Label(col, row, "出貨日" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//回T
			ws.addCell(new jxl.write.Label(col, row, "回T" , ACenterBLB));
			ws.setColumnView(col,7);	
			col++;	

			//客戶品號
			ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//客戶PO
			ws.addCell(new jxl.write.Label(col, row, "客戶PO" , ACenterBLB));
			ws.setColumnView(col,50);	
			col++;

			//出貨方式
			ws.addCell(new jxl.write.Label(col, row, "出貨方式" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;
				
			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			
			//採購單號
			ws.addCell(new jxl.write.Label(col, row, "採購單號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			
			//採購單客戶品號
			ws.addCell(new jxl.write.Label(col, row, "採購單客戶品號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;

			//單價
			ws.addCell(new jxl.write.Label(col, row, "單價" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;			

			//分配數量
			ws.addCell(new jxl.write.Label(col, row, "分配量(K)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
			
			//Market Group
			ws.addCell(new jxl.write.Label(col, row, "Market Group" , ACenterBLB));
			ws.setColumnView(col,7);	
			col++;

			//Market Group Desc
			ws.addCell(new jxl.write.Label(col, row, "Market Group Desc" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;

			//TSC Package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			
			row++;
		}
		col=0;
		if (rs.getString("ADVISE_NO")==null)
		{
			status="生管未確認";
			ws.addCell(new jxl.write.Label(col, row, status, CenterBL1));
		}
		else if (rs.getInt("BOX_CNT")>0)
		{
			status="進出口已編箱";
			ws.addCell(new jxl.write.Label(col, row, status, CenterBL2));
		}
		else if (rs.getInt("PICK_CNT")>0)
		{
			status="倉庫已撿貨";
			ws.addCell(new jxl.write.Label(col, row, status, CenterBL3));
		}
		else if (rs.getInt("shipped_CNT")>0)
		{
			status="倉庫已出貨";
			ws.addCell(new jxl.write.Label(col, row, status, CenterBL4));
		}
		else
		{
			status="生管已確認";
			ws.addCell(new jxl.write.Label(col, row, status, ACenterL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ADVISE_NO")==null?"":rs.getString("ADVISE_NO")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REGION_CODE"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("shipping_remark")==null?"":rs.getString("shipping_remark")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO") , ACenterL));
		col++;				
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_LINE_NUMBER"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"), ALeftL));
		col++;				
		if (rs.getString("order_qty")==null)
		{
			ws.addCell(new jxl.write.Label(col, row,"", ALeftL));
		}
		else
		{		
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("order_qty")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PC_SCHEDULE_SHIP_DATE"), ACenterL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("to_tw"), ACenterL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_ITEM")==null?"":rs.getString("CUST_ITEM")),  ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PO_NUMBER"), ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_METHOD"), ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("vendor_site_code"), ACenterL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PONO")==null?"":rs.getString("PONO")), ACenterL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("pc_cust_partno"), ALeftL));
		col++;
		if (rs.getString("po_unit_price")==null) 
		{
			ws.addCell(new jxl.write.Label(col, row,"", ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("po_unit_price")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("order_qty")==null)
		{
			ws.addCell(new jxl.write.Label(col, row,"", ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("order_qty")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("market_group"), ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("market_group_desc"), ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_package"), ALeftL));
		col++;
		row++;
	
		reccnt ++;
	}	
	wwb.write(); 
	
	rs.close();
	statement.close();
	
	wwb.close();
	os.close();  
	out.close(); 

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
