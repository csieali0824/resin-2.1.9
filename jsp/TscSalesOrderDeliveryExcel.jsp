<!--20160718 Peggy,排除TSCH ORDER-->
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
<jsp:useBean id="dateBeanF" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeanT" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeanS" scope="page" class="DateBean"/>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function popMenuMsg(clkDesc)
{
 alert(clkDesc);
}
</script>
<title>Order Summary Data</title>
</head>
<body>
<FORM ACTION="../jsp/TscSalesOrderDeliveryOverview.jsp" METHOD="post" NAME="MYFORM">
<A HREF="/oradds/ORADDSMainMenu.jsp">Home <div align="right"><a href="JavaScript:self.close()">Closed Windows
</div></A>
<% 
String salesAreaNo=request.getParameter("salesAreaNo");
if (salesAreaNo == null) salesAreaNo = "";
String CUSTOMERNO=request.getParameter("CUSTOMERNO");
if (CUSTOMERNO==null) CUSTOMERNO = "";
String CUSTOMERID=request.getParameter("CUSTOMERID");
if (CUSTOMERID==null) CUSTOMERID = "";
String CUSTOMERNAME=request.getParameter("CUSTOMERNAME");
if (CUSTOMERNAME==null) CUSTOMERNAME = "";
String PartName=request.getParameter("partname");
if (PartName == null) PartName = "";
String YMF=request.getParameter("ymf");
if (YMF == null) YMF = "";
String YMT=request.getParameter("ymt");
if (YMT == null) YMT = "";
String ENDCUST = request.getParameter("ENDCUST");
if (ENDCUST ==null) ENDCUST="";
String PRODUCTGROUP = request.getParameter("PRODUCTGROUP"); //add by Peggy 20130318
if (PRODUCTGROUP==null) PRODUCTGROUP=""; 
int YearF =0,MonthF =0;
int YearT =0,MonthT =0;
int Months = 0;
try
{
	YearF = Integer.parseInt(YMF.substring(0,4));
	MonthF = Integer.parseInt(YMF.substring(5,7));

	YearT = Integer.parseInt(YMT.substring(0,4));
	MonthT = Integer.parseInt(YMT.substring(5,7));

	if (YearT==YearF) 
	{
		Months = MonthT-MonthF;
	}	
	else 
	{
		Months = (YearT-YearF) * 12 - MonthF + MonthT;
	}
}
catch(Exception e)
{
	out.println("error:"+e.getMessage());
}

String serverHostName=request.getServerName();
String hmsCurr = dateBean.getHourMinuteSecond();
String sql = "",sqlt = "",sDate="";
int row =0,col=0;
float tt_unship =0,tt_shipped =0;

try
{
	OutputStream os = null;	
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{ // For Unix Platform
    	os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/D7003_"+userID+"_"+hmsCurr+".xls");
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\D7003_"+userID+"_"+hmsCurr+".xls");
	}
   	WritableWorkbook wwb = Workbook.createWorkbook(os); 
    WritableSheet ws = wwb.createSheet("OrderDetail", 0); 
	SheetSettings sst = ws.getSettings(); 
	
	//宣告中文字格式   
	WritableFont txtfont = new WritableFont(WritableFont.createFont("標楷體"), 12);
	//宣告英數字格式
	WritableFont numfont = new WritableFont(WritableFont.createFont("Book Antiqua"),12); 
	
	//標題文字垂直置中     
	WritableCellFormat HLeft = new WritableCellFormat(numfont);   
	HLeft.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	HLeft.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	HLeft.setBackground(jxl.format.Colour.GRAY_25);
	//內容文字水平靠左
	WritableCellFormat LLeft = new WritableCellFormat(numfont);   
	LLeft.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	//標題文字水平置中     
	WritableCellFormat HCenter = new WritableCellFormat(numfont);   
	HCenter.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	HCenter.setAlignment(jxl.format.Alignment.CENTRE);
	HCenter.setBackground(jxl.format.Colour.GRAY_25);
	//標題中文字水平置中     
	WritableCellFormat HCCenter = new WritableCellFormat(txtfont);   
	HCCenter.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	HCCenter.setAlignment(jxl.format.Alignment.CENTRE);
	HCCenter.setBackground(jxl.format.Colour.GRAY_25);
                  
	//宣告數字格式                           
	NumberFormat nf = new NumberFormat("###,##0.##");   
	WritableCellFormat numFormat = new WritableCellFormat(nf);   
	//numFormat.setFont(numfont);  
	numFormat.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	numFormat.setAlignment(jxl.format.Alignment.RIGHT);
	
	ws.mergeCells(col, row, col, row+1);     
    ws.addCell(new jxl.write.Label(col, row, "CustomerName", HLeft));
	ws.setColumnView(col,60);
	col++;
	ws.mergeCells(col, row, col, row+1);     
    ws.addCell(new jxl.write.Label(col, row, "EndCustomer", HLeft));
	ws.setColumnView(col,30);
	col++;
	ws.mergeCells(col, row, col, row+1);     
    ws.addCell(new jxl.write.Label(col, row, "ItemName", HLeft));
	ws.setColumnView(col,30);
	col++;
	ws.mergeCells(col, row, col, row+1);     
    ws.addCell(new jxl.write.Label(col, row, "Description", HLeft));
	ws.setColumnView(col,25);
	col++;
	ws.mergeCells(col, row, col, row+1);     
    ws.addCell(new jxl.write.Label(col, row, "Uom", HLeft));
	col++;
	ws.mergeCells(col, row, col, row+1);     
    ws.addCell(new jxl.write.Label(col, row, "TSC PROD GROUP", HLeft));
	ws.setColumnView(col,25);
	col++;
	dateBeanS.setDate(YearF,MonthF,1); 
	for (int i =0 ; i <= Months ; i++)
	{	
		sDate = dateBeanS.getYearString() +"-"+dateBeanS.getMonthString(); 
		ws.mergeCells(col, 0, col+1, 0);     
    	ws.addCell(new jxl.write.Label(col  , row  , sDate,  HCenter));
    	ws.addCell(new jxl.write.Label(col  , row+1, "未交", HCCenter));
    	ws.addCell(new jxl.write.Label(col+1, row+1, "已交", HCCenter));
		dateBeanS.setAdjMonth(1);
		col+=2;
	}					
	ws.mergeCells(col, row, col+1, row);     
    ws.addCell(new jxl.write.Label(col  , row  , "Total", HCenter));
	ws.addCell(new jxl.write.Label(col  , row+1, "未交" , HCCenter));
	ws.addCell(new jxl.write.Label(col+1, row+1, "已交" , HCCenter));
		
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	
		
	sql = " SELECT a.order_number,"+
		  " TO_NUMBER (b.line_number || '.' || b.shipment_number) line_number,"+
		  " c.segment1 item_name, c.description item_desc,a.sold_to_org_id, d.account_number,e.party_name , b.schedule_ship_date,"+
		  " b.actual_shipment_date, case b.order_quantity_uom when 'PCE' then 'KPC' else b.order_quantity_uom end as item_uom ,f.document_description,"+
          " TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Package') as TSC_PACKAGE, "+         
		  " TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Family') as TSC_FAMILY, "+	         
		  " TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_PROD_GROUP') as TSC_PROD_GROUP ";
	dateBeanS.setDate(YearF,MonthF,1); 
	for (int i =0 ; i <= Months ; i++)
	{	
		sDate = dateBeanS.getYearString() +"-"+dateBeanS.getMonthString(); 
		sql += ",case to_char(nvl( actual_shipment_date,schedule_ship_date),'yyyy-mm') "+
			   " when '"+ sDate + "' then "+
			   " 	to_number((case b.order_quantity_uom "+
			   "     when 'PCE' then "+
			   "        (case when nvl(b.shipped_quantity,0) >0 then 0 else nvl(b.ordered_quantity,0) end) /1000"+
			   "     else"+
			   "        (case when nvl(b.shipped_quantity,0) >0 then 0 else nvl(b.ordered_quantity,0) end)"+
			   "     end))"+
			   " else 0 end as \""+ sDate+"_unship\"";
		sql += ",case to_char(nvl( actual_shipment_date,schedule_ship_date),'yyyy-mm') "+
			   " when '"+ sDate + "' then "+
			   " 	to_number((case b.order_quantity_uom "+
			   "     when 'PCE' then "+
			   "        (case when nvl(b.shipped_quantity,0) >0 then NVL (b.shipped_quantity, 0) else 0 end) /1000"+
			   "     else"+
			   "        (case when nvl(b.shipped_quantity,0) >0 then NVL (b.shipped_quantity, 0) else 0 end)"+
			   "     end))"+
			   " else 0 end as \""+ sDate+"_shipped\"";
		dateBeanS.setAdjMonth(1);
	}
	sql +=" FROM ont.oe_order_headers_all a,"+
		  " ont.oe_order_lines_all b,"+
		  " inv.mtl_system_items_b c,"+
		  " hz_cust_accounts d,"+
		  " hz_parties e,"+
		  " (select fadfv.pk1_value,fadfv.document_description from  fnd_attached_docs_form_vl fadfv where fadfv.function_name = 'OEXOEORD'"+
		  " AND fadfv.category_description = 'SHIPPING MARKS' AND fadfv.user_entity_name = 'OM Order Header') f"+
		  " WHERE a.header_id = b.header_id"+
		  " AND b.inventory_item_id = c.inventory_item_id"+
		  " AND b.ship_from_org_id = c.organization_id"+
		  " AND a.sold_to_org_id = d.cust_account_id"+
		  " AND d.party_id = e.party_id"+
		  " AND a.header_id = f.pk1_value(+)"+
		  //" AND to_char(nvl(b.actual_shipment_date,b.schedule_ship_date),'yyyy-mm') between '"+ YMF +"' and '"+ YMT +"'"+
		  " AND nvl(b.actual_shipment_date,b.schedule_ship_date) between to_date('"+ YMF +"','yyyy-mm') and add_months(to_date('"+ YMT +"','yyyy-mm'),1)-1+0.99999"+
		  " AND a.org_id in (41,325)"+ //add by Peggy 20160718
		  " AND (b.schedule_ship_date IS NOT NULL OR b.actual_shipment_date IS NOT NULL)";
	if (!CUSTOMERNO.equals("")) sql += " AND d.account_number = '"+ CUSTOMERNO +"' ";
	if (!CUSTOMERNAME.equals("")) sql += " AND e.party_name LIKE '%"+ CUSTOMERNAME +"%' ";
	if (!PartName.equals("")) sql += " AND (c.segment1 like '%"+PartName + "%' or c.description like '%"+PartName + "%')";
	if (!salesAreaNo.equals("") &&!salesAreaNo.equals("--") )
	{
		sql += " AND exists ( SELECT 1  FROM apps.hz_cust_acct_sites_all a,ar.hz_cust_site_uses_all b,oraddman.tssales_area c"+
			   " WHERE a.cust_acct_site_id = b.cust_acct_site_id and c.sales_area_no ='"+salesAreaNo+"'  and ','||c.GROUP_ID||',' LIKE '%,'||b.attribute1||',%'"+
			   " AND a.status = b.status   AND a.org_id = b.org_id AND a.cust_account_id = d.cust_account_id)";
	}
	//else if (!UserRoles.equals("admin") && !UserName.equals("CCYANG")) 
	else if (!UserRoles.equals("admin") && !UserName.equals("CCYANG") && !UserName.equals("RITA_ZHOU") && !UserName.startsWith("JUDY_"))   //modify by Peggy 20140513,CELIA,CYTSOU可查全部區域 
	{
		//sql += " AND exists ( SELECT 1  FROM apps.hz_cust_acct_sites_all a,ar.hz_cust_site_uses_all b"+
		//	   " WHERE a.cust_acct_site_id = b.cust_acct_site_id"+
		//	   " AND b.attribute1 IN (SELECT GROUP_ID  FROM oraddman.tssales_area x,oraddman.tsrecperson y where USERNAME='"+ UserName +"' and x.sales_area_no = y.tssaleareano)"+
		//	   " AND a.status = b.status   AND a.org_id = b.org_id AND a.cust_account_id = d.cust_account_id)";
		sql += " AND exists ( SELECT 1  FROM apps.hz_cust_acct_sites_all a,ar.hz_cust_site_uses_all b,oraddman.tssales_area c,oraddman.tsrecperson d"+
		   " WHERE a.cust_acct_site_id = b.cust_acct_site_id and c.sales_area_no ='"+salesAreaNo+"'  and ','||c.GROUP_ID||',' LIKE '%,'||b.attribute1||',%'"+
		   " AND c.sales_area_no = d.tssaleareano and d.USERNAME='"+ UserName +"' "+
		   " AND a.status = b.status   AND a.org_id = b.org_id AND a.cust_account_id = d.cust_account_id)";

	}
	if (!ENDCUST.equals("")) sql += " AND f.document_description LIKE '%"+ENDCUST+"%'";
	if (!PRODUCTGROUP.equals("") && !PRODUCTGROUP.equals("--")) sql += " AND TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_PROD_GROUP') ='"+ PRODUCTGROUP+"'"; //add by Peggy 20130318
	sqlt = " SELECT '('||tt.account_number ||')'|| tt.party_name customer_name,tt.document_description,tt.item_name,tt.item_desc,tt.item_uom,tt.tsc_package,tt.tsc_family,tt.tsc_prod_group";
	dateBeanS.setDate(YearF,MonthF,1); 
	for (int i =0 ; i <= Months ; i++)
	{	
		sDate = dateBeanS.getYearString() +"-"+dateBeanS.getMonthString();
		sqlt += " ,sum(\""+sDate+"_unship\") as \""+ sDate+"_unship\",sum(\""+sDate+"_shipped\") as \""+ sDate+"_shipped\"";
		dateBeanS.setAdjMonth(1);
	}
	sqlt += " from ("+ sql +") tt"+
		  " group by '('||tt.account_number ||')'|| tt.party_name,tt.document_description,tt.item_name,tt.item_uom,tt.item_desc,tt.tsc_package,tt.tsc_family,tt.tsc_prod_group "+
		  " order by '('||tt.account_number ||')'|| tt.party_name,tt.item_name";	
	//out.println(sqlt);  
	Statement statement=con.createStatement(); 
	ResultSet rs =statement.executeQuery(sqlt);
	row=2;
	while (rs.next()) 
	{ 
		col=0;tt_unship =0;tt_shipped =0;
	   	ws.addCell(new jxl.write.Label(col, row, rs.getString("customer_name"), LLeft));
		col++;
	   	ws.addCell(new jxl.write.Label(col, row, rs.getString("document_description"), LLeft));
		col++;
    	ws.addCell(new jxl.write.Label(col, row, rs.getString("item_name"), LLeft));
		col++;
    	ws.addCell(new jxl.write.Label(col, row, rs.getString("item_desc"), LLeft));
		col++;
    	ws.addCell(new jxl.write.Label(col, row, rs.getString("item_uom"), LLeft));
		col++;
    	ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP"), LLeft)); //add by Peggy 20130318
		col++;
		dateBeanS.setDate(YearF,MonthF,1); 
		for (int i =0 ; i <= Months ; i++)
		{	
			sDate = dateBeanS.getYearString() +"-"+dateBeanS.getMonthString(); 
    		ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("#,##0.###")).format(rs.getFloat(sDate+"_unship")), numFormat));
			col++;
			ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("#,##0.###")).format(rs.getFloat(sDate+"_shipped")), numFormat));
			col++;
			tt_unship += rs.getFloat(sDate+"_unship");
			tt_shipped += rs.getFloat(sDate+"_shipped");
			dateBeanS.setAdjMonth(1);
		}
		ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("#,##0.###")).format(tt_unship), numFormat));
		col++;
		ws.addCell(new jxl.write.Label(col, row, (new DecimalFormat("#,##0.###")).format(tt_shipped), numFormat));
		col++;
		row++;
	}  
	rs.close();
	statement.close();

	wwb.write(); 
	wwb.close(); 
	os.close();   
	out.close(); 

	sql1="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	
	
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
    response.sendRedirect("/oradds/report/D7003_"+userID+"_"+hmsCurr+".xls"); 
%>
</html>

