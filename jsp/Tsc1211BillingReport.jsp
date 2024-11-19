<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
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
<FORM ACTION="../jsp/Tsc1211BillingReport.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String q_begin_date=request.getParameter("q_begin_date");
String q_end_date=request.getParameter("q_end_date");	
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=8,colcnt=0;
try 
{ 	

	int row =0,col=0,reccnt=0,group_num=0;
	OutputStream os = null;	
	RPTName = "TSCE_1211_Billing_Report";
	FileName = RPTName+"("+UserName+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
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
	
	sql = " SELECT ROW_NUMBER() OVER (PARTITION BY GRP.INVOICE_GROUP,GRP.C_DATE,GRP.CUSTOMER_NUMBER,GRP.CUSTOMER_NAME,GRP.SHIP_TO_ORG_ID,GRP.SHIP_TO,GRP.INVOICE_TO_ORG_ID,GRP.CURRENCY_CODE,GRP.FOB_POINT_CODE,GRP.TAX_CODE ORDER BY CUSTOMER_NAME,ORDER_NUMBER) GROUP_SEQ"+ //ADD GRP.C_DATE BY PEGGY 20220407
          "        ,COUNT(1) OVER (PARTITION BY GRP.INVOICE_GROUP,GRP.C_DATE,GRP.CUSTOMER_NUMBER,GRP.CUSTOMER_NAME,GRP.SHIP_TO_ORG_ID,GRP.SHIP_TO,GRP.INVOICE_TO_ORG_ID,GRP.CURRENCY_CODE,GRP.FOB_POINT_CODE,GRP.TAX_CODE) GROUP_CNT"+  //ADD GRP.C_DATE BY PEGGY 20220407
		  "        ,GRP.C_DATE"+
		  "        ,GRP.INVOICE_GROUP"+
          "        ,GRP.CUSTOMER_NUMBER"+
          "        ,GRP.CUSTOMER_NAME"+
          "        ,GRP.SHIP_TO_ORG_ID"+
          "        ,GRP.SHIP_TO"+
          "        ,GRP.INVOICE_TO_ORG_ID"+
          "        ,GRP.CURRENCY_CODE"+
          "        ,GRP.FOB_POINT_CODE"+
          "        ,GRP.TAX_CODE"+
          "        ,GRP.ORDER_NUMBER"+
          "        ,GRP.cust_po_number"+
          "        ,GRP.TOT_AMT"+
		  "        ,GRP.SHIP_TO_LOCATION_ID"+
		  "        ,GRP.BILL_TO_LOCATION_ID"+
          "        ,SUM(GRP.TOT_AMT) OVER (PARTITION BY GRP.INVOICE_GROUP,GRP.C_DATE,GRP.CUSTOMER_NUMBER,GRP.CUSTOMER_NAME,GRP.SHIP_TO_ORG_ID,GRP.SHIP_TO,GRP.INVOICE_TO_ORG_ID,GRP.CURRENCY_CODE,GRP.FOB_POINT_CODE,GRP.TAX_CODE) GROUP_TOT_AMT"+  //ADD GRP.C_DATE BY PEGGY 20220407
          " FROM (SELECT B.C_DATE"+
		  "      ,CASE WHEN INSTR(UPPER(CUSTOMER_NAME),'HELLA')>0 AND INSTR(UPPER(CUSTOMER_NAME),'INNENLEUCHTEN')=0 THEN "+
          "            CASE WHEN SUBSTR(OHA.cust_po_number,1,2) IN ('BC','HC','RC') THEN OHA.cust_po_number"+
          "                 WHEN SUBSTR(OHA.cust_po_number,1,2) IN ('3-') AND (INSTR(UPPER(ship_addr.ADDRESS1),'WERK 4')>0 OR INSTR(UPPER(ship_addr.ADDRESS1),'WERK 5')>0) THEN OHA.cust_po_number"+
          "                 WHEN INSTR(UPPER(CUSTOMER_NAME),'ROMANIA')>0 OR INSTR(UPPER(CUSTOMER_NAME),'BEHR')>0 THEN SUBSTR(OHA.cust_po_number,1,5) "+
          "            ELSE AR.CUSTOMER_NUMBER END"+
          //"            WHEN INSTR(UPPER(CUSTOMER_NAME),'SIEMENS')>0 THEN OHA.cust_po_number"+
		  "            WHEN INSTR(UPPER(CUSTOMER_NAME),'SIEMENS')>0 AND INSTR(UPPER(CUSTOMER_NAME),'VALEO')=0 THEN OHA.cust_po_number"+ //modify by Peggy 20220719
          "            WHEN INSTR(UPPER(CUSTOMER_NAME),'WABCO')>0 THEN OHA.cust_po_number"+
          "            WHEN INSTR(UPPER(CUSTOMER_NAME),'HELLA')>0 AND INSTR(UPPER(CUSTOMER_NAME),'INNENLEUCHTEN')>0 THEN OHA.cust_po_number"+  //add by Peggy 20210923
          "            WHEN INSTR(UPPER(CUSTOMER_NAME),'KOSTAL')>0 AND (INSTR(UPPER(CUSTOMER_NAME),'IRELAND')>0 OR INSTR(UPPER(CUSTOMER_NAME),'MAKEDONIJA')>0) THEN OHA.cust_po_number"+ //add MAKEDONIJA by Peggy 20220428
          "            WHEN INSTR(UPPER(CUSTOMER_NAME),'JABIL')>0 AND INSTR(UPPER(CUSTOMER_NAME),'HUNGRY')>0 THEN OHA.cust_po_number"+
          //"            WHEN INSTR(UPPER(CUSTOMER_NAME),'TRIDONIC')>0 AND INSTR(UPPER(CUSTOMER_NAME),'SERBIA')>0 THEN OHA.cust_po_number"+
		  "            WHEN INSTR(UPPER(CUSTOMER_NAME),'TRIDONIC')>0 AND INSTR(UPPER(CUSTOMER_NAME),'SRB')>0 THEN OHA.cust_po_number"+  //add by Peggy 20210923
          "            WHEN INSTR(UPPER(CUSTOMER_NAME),'PROCTER')>0 AND INSTR(UPPER(CUSTOMER_NAME),'GAMBLE')>0 THEN OHA.cust_po_number"+
          "            WHEN INSTR(UPPER(CUSTOMER_NAME),'SANMINA')>0 AND INSTR(UPPER(CUSTOMER_NAME),'BULGARIA')>0 THEN OHA.cust_po_number"+ //add by Peggy 20220307
          "        ELSE AR.CUSTOMER_NUMBER END  INVOICE_GROUP"+
          "       ,AR.CUSTOMER_NUMBER"+
		  "       ,AR.CUSTOMER_NAME"+
		  "       ,OHA.ORDER_NUMBER"+
		  "       ,OHA.cust_po_number"+
		  "       ,OHA.SHIP_TO_ORG_ID"+
		  "       ,ship_addr.ADDRESS1 SHIP_TO"+
		  "       ,OHA.INVOICE_TO_ORG_ID"+
		  "       ,OHA.transactional_curr_code CURRENCY_CODE"+
		  "       ,OHA.fob_point_code"+
		  "       ,OLA.tax_code"+
		  "       ,ship_addr.location SHIP_TO_LOCATION_ID"+
		  "       ,bill_addr.location BILL_TO_LOCATION_ID"+
		  "       ,SUM(OLA.ordered_quantity*OLA.unit_selling_price) TOT_AMT "+
		  "       FROM ONT.OE_ORDER_HEADERS_ALL OHA"+
		  "            ,ONT.OE_ORDER_LINES_ALL OLA"+
		  "            ,AR_CUSTOMERS AR"+
          "            , (select hcsu.site_use_id,hl.address1,hcsu.location from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
          "             where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
          "             and hcas.party_site_id = hps.party_site_id  "+
          "             and hps.location_id =hl.location_id "+
          "             and hcsu.site_use_code = 'SHIP_TO'"+
          "             and hcsu.status = 'A') ship_addr"+
          "            , (select hcsu.site_use_id,hl.address1,hcsu.location from HZ_CUST_SITE_USES_ALL hcsu,HZ_CUST_ACCT_SITES_ALL hcas, HZ_PARTY_SITES hps, HZ_LOCATIONS hl"+
          "             where hcsu.cust_acct_site_id =hcas.cust_acct_site_id "+
          "             and hcas.party_site_id = hps.party_site_id  "+
          "             and hps.location_id =hl.location_id "+
          "             and hcsu.site_use_code = 'BILL_TO'"+
          "             and hcsu.status = 'A') bill_addr"+		  
          "            ,(select distinct ORDER_NUMBER,C_DATE,SALES_REGION from tsc_oe_auto_headers) b"+
          "        WHERE OHA.HEADER_ID=OLA.HEADER_ID"+
          "        AND OHA.SOLD_TO_ORG_ID=AR.CUSTOMER_ID"+
          "        AND OHA.SHIP_TO_ORG_ID=ship_addr.site_use_id(+)"+
          "        AND OHA.INVOICE_TO_ORG_ID=bill_addr.site_use_id(+)"+
          "        AND TO_DATE(B.C_DATE,'YYYY/MM/DD') between TO_DATE('"+q_begin_date+"','YYYYMMDD') and  TO_DATE('"+q_end_date+"','YYYYMMDD') "+
          "        AND B.ORDER_NUMBER=OHA.ORDER_NUMBER "+
          "        AND B.SALES_REGION='TSCE'"+
		  "        AND EXISTS (SELECT 1 FROM WSH_DELIVERY_ASSIGNMENTS WDA,WSH_DELIVERY_DETAILS WDD"+
          "                    WHERE WDA.delivery_detail_id=WDD.delivery_detail_id"+
          "                    AND WDA.delivery_id IS NULL "+
          "                    AND WDD.source_line_id=OLA.LINE_ID)"+
          "        GROUP BY  B.C_DATE,AR.CUSTOMER_NUMBER,AR.CUSTOMER_NAME,OHA.ORDER_NUMBER,OHA.cust_po_number,OHA.SHIP_TO_ORG_ID,ship_addr.ADDRESS1,OHA.INVOICE_TO_ORG_ID,OHA.transactional_curr_code ,OHA.fob_point_code,OLA.tax_code,ship_addr.location,bill_addr.location"+
          "        ORDER BY 2) GRP"+
          "        ORDER BY GRP.CUSTOMER_NAME";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	String destination="";
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			SheetSettings sst = ws.getSettings(); 
			sst.setSelected();
			sst.setVerticalFreeze(1);  //凍結窗格		
			col=0;row=0;

			//group no
			ws.addCell(new jxl.write.Label(col, row, "Group No" , ACenterBLB));
			ws.setColumnView(col,8);
			col++;	
			
			//Customer
			ws.addCell(new jxl.write.Label(col, row, "Customer" , ACenterBLB));
			ws.setColumnView(col,30);
			col++;	

			//MO#
			ws.addCell(new jxl.write.Label(col, row, "MO#" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//Amount
			ws.addCell(new jxl.write.Label(col, row, "Amount" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//tot Amount
			ws.addCell(new jxl.write.Label(col, row, "Tot Amount" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
						
			//PackingList Date
			ws.addCell(new jxl.write.Label(col, row, "PackingList Date" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Ship to ID
			ws.addCell(new jxl.write.Label(col, row, "Ship to ID" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//Ship to
			ws.addCell(new jxl.write.Label(col, row, "Ship to" , ACenterBLB));
			ws.setColumnView(col,40);	
			col++;			

			//Bill to ID
			ws.addCell(new jxl.write.Label(col, row, "Bill to ID" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//Currency Code
			ws.addCell(new jxl.write.Label(col, row, "Currency Code" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//FOB
			ws.addCell(new jxl.write.Label(col, row, "FOB" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Tax Code
			ws.addCell(new jxl.write.Label(col, row, "Tax Code" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//PackingList Number
			ws.addCell(new jxl.write.Label(col, row, "PackingList Number" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			row++;
		}
		
		col=0;
		if (rs.getInt("GROUP_SEQ")==1) group_num++;
		ws.addCell(new jxl.write.Label(col, row, ""+group_num , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ORDER_NUMBER")==null?"":rs.getString("ORDER_NUMBER")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOT_AMT")).doubleValue(), ARightL));
		col++;	
		if (rs.getInt("GROUP_SEQ")==rs.getInt("GROUP_CNT"))
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("GROUP_TOT_AMT")).doubleValue(), ARightL));			
		}
		else
		{
			ws.addCell(new jxl.write.Label(col, row, "", ACenterL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("C_DATE")==null?"":rs.getString("C_DATE")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIP_TO_LOCATION_ID")==null?"":rs.getString("SHIP_TO_LOCATION_ID")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIP_TO")==null?"":rs.getString("SHIP_TO")), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("BILL_TO_LOCATION_ID")==null?"":rs.getString("BILL_TO_LOCATION_ID")) ,ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CURRENCY_CODE")==null?"":rs.getString("CURRENCY_CODE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("FOB_POINT_CODE")==null?"":rs.getString("FOB_POINT_CODE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TAX_CODE")==null?"":rs.getString("TAX_CODE")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_PO_NUMBER")==null?"":rs.getString("CUST_PO_NUMBER")) , ALeftL));
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
