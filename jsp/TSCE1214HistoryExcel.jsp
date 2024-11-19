<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSCE Hub PO List</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCE1214HistoryExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER == null) CUSTOMER ="";
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO == null) CUSTPO ="";
String ORDERS = "ORDERS",ORDCHG="ORDCHG";
String CYearFr = request.getParameter("CYEARFR");
if (CYearFr==null)  CYearFr="";
String CMonthFr = request.getParameter("CMONTHFR");
if (CMonthFr==null) CMonthFr="";
String CDayFr = request.getParameter("CDAYFR");
if (CDayFr==null) CDayFr="";
String CYearTo= request.getParameter("CYEARTO");
if (CYearTo==null) CYearTo="";
String CMonthTo = request.getParameter("CMONTHTO");
if (CMonthTo==null) CMonthTo="";
String CDayTo = request.getParameter("CDAYTO");
if (CDayTo==null) CDayTo="";
String PDNFLAG = request.getParameter("PDNFLAG");
if (PDNFLAG==null) PDNFLAG="";
String POSTATUS = request.getParameter("POSTATUS");
if (POSTATUS==null) POSTATUS="";
String OCSTATUS = request.getParameter("OCSTATUS");
if (OCSTATUS==null) OCSTATUS="";
String FileName="",RPTName="",ColumnName="",DEPTNAME="",sql="";
int fontsize=9,colcnt=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	if (PDNFLAG.equals("Y"))
	{
		RPTName = "PO_PDN";
	}
	else
	{
		RPTName = "TSCE_HUB_PO";
	}
	FileName = RPTName+"("+userID+")"+dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
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
	SheetSettings sst = ws.getSettings(); 
	
	//英文內文水平垂直置中-粗體-格線   
	WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
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
	
	if (PDNFLAG.equals("Y"))
	{

		sql = " SELECT a.order_number \"M/O\""+
			  ",b.line_number||'.'||b.shipment_number \"Line No.\""+
			  ",b.customer_shipment_number \"Customer PO Line No.\""+
			  ",e.description \"Part Number\","+
			  " b.ordered_item \"Cust P/N\""+
			  ",d.customer_name \"Customer\""+
			  ",b.customer_line_number \"P/O No.\""+
			  ",to_char(b.creation_date,'yyyy-mm-dd') \"Order Date\""+
			  ",to_char(b.schedule_ship_date,'yyyy-mm-dd') SSD"+
			  ",to_char(b.request_date,'yyyy-mm-dd') CRD"+
			  ",b.shipping_method_code \"Shipping Method\""+
			  ",b.ordered_quantity Qty "+
			  ",REMARK \"備註\""+
			  " FROM ont.oe_order_headers_all a"+
			  ",ont.oe_order_lines_all b"+
			  " ,(select distinct c.creation_date,c.customer_po,d.po_line_no cust_po_line_no,d.REMARKS REMARK,c.customer_name from oraddman.tsce_purchase_order_headers c,oraddman.tsce_purchase_order_lines d where c.customer_po =d.customer_po and c.version_id= d.version_id and d.PDN_FLAG='Y') c"+
			  ",ar_customers d"+
			  ",inv.mtl_system_items_b e"+
			  " where a.header_id = b.header_id"+
			  " and b.customer_line_number=c.customer_po"+
			  " and b.customer_shipment_number=c.cust_po_line_no"+
			  " and a.sold_to_org_id=d.customer_id"+
			  " and b.inventory_item_id=e.inventory_item_id"+
			  " and a.SHIP_FROM_ORG_ID=e.organization_id"+
			  " and a.sold_to_org_id =c.erp_customer_id";
		if (!CUSTPO.equals(""))
		{
			sql += " and c.CUSTOMER_PO LIKE '"+CUSTPO+"%'";
		}
		if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
		{
			sql += " and (c.CUSTOMER_PO like '" + CUSTOMER +"%' or  c.CUSTOMER_NAME LIKE '"+ CUSTOMER.toUpperCase() +"%')";
		}
		if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
		{
			sql += " and TO_CHAR(c.CREATION_DATE,'yyyymmdd') >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
		}
		if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
		{
			sql += " and TO_CHAR(c.CREATION_DATE,'yyyymmdd') <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
		}
		if (UserRoles!="admin" && !UserRoles.equals("admin")) 
		{ 
			sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano='001')";
		}						
	}
	else
	{
		sql = " select  b.CUSTOMER_NAME , a.CUSTOMER_PO ,VERSION_ID,to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE,b.currency_code "+
			  ",CASE WHEN (SELECT COUNT(1) FROM oraddman.tsdelivery_notice_detail y  WHERE y.CUST_PO_NUMBER =a.CUSTOMER_PO AND LSTATUSID not in ('010','012')) > 0 THEN 'In Progress' ELSE 'Closed' END  AS PO_STATUS"+
			  ", NVL((select  distinct pi_seqno ||'-'||version_number from daphne_pi_temp x where x.cust_po_number=a.CUSTOMER_PO),'') OC_STATUS"+
			  " from oraddman.tsce_purchase_order_headers a,oraddman.tsce_end_customer_list b WHERE substr(a.customer_po,0,instr(a.customer_po,'-')-1)=b.CUSTOMER_ID(+) and a.ACTIVE_FLAG='A'";
		if (!CUSTPO.equals(""))
		{
			sql += " and a.CUSTOMER_PO LIKE '"+CUSTPO+"%'";
		}
		if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
		{
			sql += " and (to_char(b.CUSTOMER_ID) ='" + CUSTOMER.toUpperCase() +"' or b.customer_name like '"+ CUSTOMER.toUpperCase()+"%')";
		}
		if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
		{
			sql += " and to_char(a.CREATION_DATE,'yyyymmdd') >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
		}
		if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
		{
			sql += " and to_char(a.CREATION_DATE,'yyyymmdd') <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
		}
		if (UserRoles!="admin" && !UserRoles.equals("admin")) 
		{ 
			sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano='001')";
		}
		if (!POSTATUS.equals("--") && !POSTATUS.equals(""))
		{
			if (POSTATUS.equals("Closed"))
			{
				sql += " AND (SELECT COUNT (1)  FROM oraddman.tsdelivery_notice_detail y  WHERE y.cust_po_number = a.customer_po AND lstatusid NOT IN  ('010', '012')) =0";
			}
			else if (POSTATUS.equals("In Progress"))
			{
				sql += " AND (SELECT COUNT (1)  FROM oraddman.tsdelivery_notice_detail y  WHERE y.cust_po_number = a.customer_po AND lstatusid NOT IN  ('010', '012')) >0";
			}
		}
		if (!OCSTATUS.equals("--") && !OCSTATUS.equals(""))
		{
			if (OCSTATUS.equals("Confirmed"))
			{
				sql += " AND NVL((select  distinct pi_seqno ||'-'||version_number from daphne_pi_temp x where x.cust_po_number=a.CUSTOMER_PO),'UnConfirm') <> 'UnConfirm'";
			}
			else if (OCSTATUS.equals("UnConfirm"))
			{
				sql += " AND NVL((select  distinct pi_seqno ||'-'||version_number from daphne_pi_temp x where x.cust_po_number=a.CUSTOMER_PO),'UnConfirm') = 'UnConfirm'";
			}
		}
		sql +="order by 1,2";
	}
	//out.println(sql);
	Statement state=con.createStatement();     
    ResultSet rs=state.executeQuery(sql);
	while (rs.next())	
	{ 
		if (reccnt==0)
		{
			ResultSetMetaData md=rs.getMetaData();
			colcnt =md.getColumnCount();

			for (int i=1;i<=colcnt;i++) 
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
				if ((PDNFLAG.equals("Y") && i==6)  || (PDNFLAG.equals("N") && i==1))
				{
					ws.setColumnView(col+(i-1),30);	
				}
				else
				{
					ws.setColumnView(col+(i-1),20);	
				}
			}
			row++;
		}
		for (int i =1 ; i <= colcnt ; i++)
		{
			if ((PDNFLAG.equals("Y") && i==6)  || (PDNFLAG.equals("N") && i==1))
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ACenterL));
				ws.setColumnView(col+(i-1),30);
			}
			else
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ACenterL));
				ws.setColumnView(col+(i-1),20);
			}
		}	
		reccnt++;
		row++;
	}
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 
	
	rs.close();
	state.close();

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
