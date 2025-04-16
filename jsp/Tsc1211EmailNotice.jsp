<!-- 20160805 by Peggy,add customer query condition-->
<%@ page contentType="text/html; charset=big5" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
	<title>TSCE Packing List Notice</title>
	<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/Tsc1211EmailNotice.jsp" METHOD="post" name="MYFORM">
	<%
		String FileName="",sql="",remarks="";
		String RTYPE=request.getParameter("RTYPE");
		if (RTYPE==null) RTYPE="";
		String V_BATCH_ID = "", SDATE = "",EDATE = "",CUSTNAME="",PACKINGLIST="",cust="";
		if (RTYPE.equals("AUTO"))
		{
			V_BATCH_ID = request.getParameter("V_BATCH_ID");
			if (V_BATCH_ID ==null) V_BATCH_ID="";
		}
		else if (RTYPE.equals("PACKING"))
		{
			SDATE = request.getParameter("q_begin_date");
			if (SDATE==null) SDATE="";
			EDATE = request.getParameter("q_end_date");
			if (EDATE==null) EDATE="";
			CUSTNAME=request.getParameter("q_customerName");
			if (CUSTNAME==null) CUSTNAME ="";
			PACKINGLIST = request.getParameter("packingnumber");
			if (PACKINGLIST==null) PACKINGLIST="";
		}
		else if (RTYPE.equals("WAITING"))
		{
			SDATE = request.getParameter("q_Begin_Date");
			if (SDATE==null) SDATE="";
			EDATE = request.getParameter("q_End_Date");
			if (EDATE==null) EDATE="";
		}
		else
		{
			SDATE = request.getParameter("sdate");
			if (SDATE==null) SDATE="";
			EDATE = request.getParameter("edate");
			if (EDATE==null) EDATE="";
			PACKINGLIST = request.getParameter("packingnumber");
			if (PACKINGLIST==null) PACKINGLIST="";
			cust=request.getParameter("cust");  //add by Peggy 20160805
			if (cust==null) cust="";
		}
		int fontsize=8,colcnt=0;
		int row =0,col=0,reccnt=0,totcnt=0;
		try
		{
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

			//英文內文水平垂直置左-正常-格線-紅字
			WritableCellFormat ALeftLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));
			ALeftLR.setAlignment(jxl.format.Alignment.LEFT);
			ALeftLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ALeftLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ALeftLR.setWrap(true);

			//英文內文水平垂直置中-正常-格線-紅字
			WritableCellFormat ACenterLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));
			ACenterLR.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterLR.setWrap(true);

			//英文內文水平垂直置左-正常-格線-藍字
			WritableCellFormat ALeftLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));
			ALeftLB.setAlignment(jxl.format.Alignment.LEFT);
			ALeftLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ALeftLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ALeftLB.setWrap(true);

			//英文內文水平垂直置中-正常-格線-藍字
			WritableCellFormat ACenterLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE));
			ACenterLB.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterLB.setWrap(true);

			CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
			cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
			cs1.execute();
			cs1.close();

			FileName="PackingList_"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";

			OutputStream os = null;
			os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
			WritableWorkbook wwb = Workbook.createWorkbook(os);

			if (RTYPE.equals("AUTO"))
			{
				wwb.createSheet("1211 MO list", 0);
				wwb.createSheet("PL 未轉 1211 list", 1);
			}
			else if (RTYPE.equals("PACKING"))
			{
				wwb.createSheet("1211 MO list", 0);
			}
			else if (RTYPE.equals("WAITING"))
			{
				wwb.createSheet("PL 未轉 1211 list", 0);
			}
			else
			{
				wwb.createSheet("PL Source List", 0);
			}

			WritableSheet ws = null;
			String sheetname [] = wwb.getSheetNames();
			for (int k =0 ; k < sheetname.length ; k++)
			{
				//out.println(sheetname[k]);
				ws = wwb.getSheet(sheetname[k]);
				SheetSettings sst = ws.getSettings();
				sst.setSelected();
				sst.setVerticalFreeze(1);  //凍結窗格
				sst.setFitToPages(true);
				sst.setFitWidth(1);        // 設定一頁寬

				if (sheetname[k].equals("1211 MO list"))
				{
					reccnt=0;row =0;col=0;
					ws.addCell(new jxl.write.Label(col, row, "MO #", ACenterBL));
					ws.setColumnView(col,12);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "FOB", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Customer", ACenterBL));
					ws.setColumnView(col,25);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Cust Full Name", ACenterBL));
					ws.setColumnView(col,40);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "P/L", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Ship To Contact", ACenterBL));
					ws.setColumnView(col,40);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Bill To Address1", ACenterBL));
					ws.setColumnView(col,50);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Ship To Address1", ACenterBL));
					ws.setColumnView(col,50);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "P/N", ACenterBL));
					ws.setColumnView(col,20);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Ordered Item", ACenterBL));
					ws.setColumnView(col,20);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Customer PO Line Number", ACenterBL));
					ws.setColumnView(col,25);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Q'ty", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Unit Selling Price", ACenterBL));
					ws.setColumnView(col,15	);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Currency", ACenterBL));
					ws.setColumnView(col,30);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Amount", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Creation Date", ACenterBL));
					ws.setColumnView(col,15	);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Order Status", ACenterBL));
					ws.setColumnView(col,25	);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Invoice No", ACenterBL));
					ws.setColumnView(col,15	);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Tax Code", ACenterBL));
					ws.setColumnView(col,25	);
					col++;

					row++;
			
			/*
			sql = " SELECT a.ORDER_NUMBER"+
				  ",a.SHIPMENTTERMS"+
				  ",a.CUSTOMERNAME"+
				  ",a.packinglistnumber"+
				  ",a.SHIP_TO_CONTACT_ID"+
				  ",(select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) from ar_contacts_v x where x.contact_id=a.SHIP_TO_CONTACT_ID) ship_to_contact"+
				  ",(select loc.ADDRESS1 from AR_SITE_USES_V asuv,HZ_CUST_ACCT_SITES hcas, hz_party_sites party_site, hz_locations loc"+
				  " where  asuv.ADDRESS_ID = hcas.cust_acct_site_id"+
				  " AND hcas.party_site_id = party_site.party_site_id"+
				  " AND loc.location_id = party_site.location_id "+
				  " and asuv.STATUS='A' "+
				  " and asuv.SITE_USE_ID = a.SHIPTOID ) shipto "+
				  ",(select loc.ADDRESS1 from AR_SITE_USES_V asuv,HZ_CUST_ACCT_SITES hcas, hz_party_sites party_site, hz_locations loc"+
				  " where  asuv.ADDRESS_ID = hcas.cust_acct_site_id"+
				  " AND hcas.party_site_id = party_site.party_site_id"+
				  " AND loc.location_id = party_site.location_id "+
				  " and asuv.STATUS='A' "+
				  " and asuv.SITE_USE_ID = a.BILLTOID ) billto"+
				  " ,b.ITEM_DESCRIPTION"+
				  " ,b.CUSTOMERPRODUCTNUMBER"+
				  " ,b.customerpo"+
				  " ,b.QUANTITY"+
				  " ,b.SELLING_PRICE"+
				  " ,(select NAME from qp_list_headers_v where  LIST_HEADER_ID=a.PRICE_LIST) price_list"+
				  " ,b.QUANTITY * b.SELLING_PRICE amount"+
				  " FROM tsc_oe_auto_headers a,tsc_oe_auto_lines b"+
				  " WHERE a.id=b.id and EXISTS (SELECT 1 FROM tsc_packinglist_data x WHERE x.PACKINGLISTNUMBER=A.packinglistnumber AND x.customerpo=A.CUSTOMERPO ";
			*/
					sql = " SELECT A.ORDER_NUMBER"+
							",B.fob_point_code SHIPMENTTERMS"+
							",nvl(c.CUSTOMER_NAME_PHONETIC,C.customer_name) CUSTOMERNAME"+
							",C.customer_name cust_full_name"+ //add by Peggy 20200805
							",A.cust_po_number packinglistnumber"+
							",A.ship_to_contact_id"+
							//",(select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) from ar_contacts_v x where x.contact_id=A.ship_to_contact_id) ship_to_contact"+
							",(select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) from ar_contacts_v x where x.contact_id=nvl(A.attribute11,A.ship_to_contact_id)) ship_to_contact"+
							",(select loc.ADDRESS1 from AR_SITE_USES_V asuv,HZ_CUST_ACCT_SITES hcas, hz_party_sites party_site, hz_locations loc"+
							"                 where  asuv.ADDRESS_ID = hcas.cust_acct_site_id"+
							"                 AND hcas.party_site_id = party_site.party_site_id"+
							"                 AND loc.location_id = party_site.location_id "+
							"                 and asuv.STATUS='A' "+
							"                 and asuv.SITE_USE_ID = A.ship_to_org_id) shipto"+
							",(select loc.ADDRESS1 from AR_SITE_USES_V asuv,HZ_CUST_ACCT_SITES hcas, hz_party_sites party_site, hz_locations loc"+
							" where  asuv.ADDRESS_ID = hcas.cust_acct_site_id"+
							" AND hcas.party_site_id = party_site.party_site_id"+
							" AND loc.location_id = party_site.location_id "+
							" and asuv.STATUS='A' "+
							" and asuv.SITE_USE_ID = a.invoice_to_org_id) billto"+
							",D.DESCRIPTION ITEM_DESCRIPTION"+
							",B.ordered_item CUSTOMERPRODUCTNUMBER"+
							",B.customer_line_number customerpo"+
							",B.ordered_quantity QUANTITY"+
							",B.unit_selling_price SELLING_PRICE"+
							",(select NAME from qp_list_headers_v where  LIST_HEADER_ID=A.price_list_id) price_list"+
							",B.ordered_quantity * B.unit_selling_price amount"+
							",TO_CHAR(b.CREATION_DATE,'yyyy-mm-dd') CREATION_DATE"+
							",B.FLOW_STATUS_CODE"+
							",E.NAME INVOICE_NO"+
							",B.HEADER_ID"+
							",B.LINE_ID"+
							",B.TAX_CODE"+ //add by Peggy 20200702
							" FROM ONT.OE_ORDER_HEADERS_ALL A,"+
							" ONT.OE_ORDER_LINES_ALL B,"+
							" AR_CUSTOMERS C,"+
							" INV.MTL_SYSTEM_ITEMS_B D,"+
							" (SELECT x.SOURCE_HEADER_ID, x.SOURCE_LINE_ID,x.DELIVERY_DETAIL_ID,x.SRC_REQUESTED_QUANTITY,x.SRC_REQUESTED_QUANTITY_UOM, y.DELIVERY_ID,z.NAME"+
							" FROM wsh.wsh_delivery_details x,wsh.wsh_delivery_assignments y,wsh.wsh_new_deliveries z "+
							" WHERE x.delivery_detail_id = y.delivery_detail_id "+
							" AND y.delivery_id = z.delivery_id) E"+
							" WHERE A.HEADER_ID = B.HEADER_ID "+
							" AND A.SOLD_TO_ORG_ID = C.customer_id(+)"+
							" AND B.SHIP_FROM_ORG_ID=D.ORGANIZATION_id(+)"+
							" AND B.INVENTORY_ITEM_ID=D.INVENTORY_ITEM_ID(+)"+
							" AND B.HEADER_ID = E.SOURCE_HEADER_ID(+)"+
							" AND B.LINE_ID = E.SOURCE_LINE_ID(+)"+
							" AND B.FLOW_STATUS_CODE <>'CANCELLED'"+
							" AND EXISTS (SELECT 1 FROM tsc_oe_auto_headers X "+
							"             WHERE X.order_number=A.ORDER_NUMBER "+
							"             AND EXISTS (SELECT 1 FROM tsc_packinglist_data Y "+
							"                         WHERE Y.PACKINGLISTNUMBER=X.packinglistnumber AND Y.customerpo=X.CUSTOMERPO";
					if (RTYPE.equals("AUTO"))
					{
						sql +="  AND Y.BATCH_ID='"+V_BATCH_ID+"'))";
					}
					else if (RTYPE.equals("PACKING"))
					{
						sql += " AND Y.CREATION_DATE between to_date('"+SDATE+"','yyyymmdd') AND to_date('"+EDATE+"','yyyymmdd')+0.99999))";
						if (!CUSTNAME.equals(""))
						{
							sql += " AND C.customer_name like '" +CUSTNAME+"%'";
						}
						if (!PACKINGLIST.equals(""))
						{
							sql += " AND A.cust_po_number LIKE '"+ PACKINGLIST+"%'";
						}
					}
					sql +=" order by b.CREATION_DATE,A.cust_po_number,B.customer_line_number";
					//out.println(sql);
					Statement state1=con.createStatement();
					ResultSet rs1=state1.executeQuery(sql);
					while (rs1.next())
					{
						col=0;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("ORDER_NUMBER") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("SHIPMENTTERMS") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUSTOMERNAME") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUST_full_name") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("PACKINGLISTNUMBER") ,  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("SHIP_TO_CONTACT") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("BILLTO") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("SHIPTO") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("ITEM_DESCRIPTION"),  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUSTOMERPRODUCTNUMBER"),  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUSTOMERPO"),  ALeftL));col++;
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs1.getString("QUANTITY")).doubleValue(), ARightL));col++;
						if (rs1.getString("SELLING_PRICE")==null)
						{
							ws.addCell(new jxl.write.Label(col, row, "",  ALeftL));col++;
						}
						else
						{
							ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs1.getString("SELLING_PRICE")).doubleValue(),  ARightL));col++;
						}
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("PRICE_LIST"),  ACenterL));col++;
						if (rs1.getString("amount")==null)
						{
							ws.addCell(new jxl.write.Label(col, row, "",  ALeftL));col++;
						}
						else
						{
							ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs1.getString("amount")).doubleValue(),  ARightL));col++;
						}
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CREATION_DATE") ,  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("FLOW_STATUS_CODE") ,  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, (rs1.getString("invoice_no")==null?" ":rs1.getString("invoice_no")) , ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, (rs1.getString("TAX_CODE")==null?"":rs1.getString("TAX_CODE")) ,  ACenterL));col++;  //add by Peggy 20200702
						row++;
						reccnt++;
					}
					rs1.close();
					state1.close();
					totcnt +=reccnt;

				}
				else if (sheetname[k].equals("PL 未轉 1211 list"))
				{
					reccnt=0;row =0;col=0;
					ws.addCell(new jxl.write.Label(col, row, "ERP Customer Name", ACenterBL));
					ws.setColumnView(col,40);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "PackingListNumber", ACenterBL));
					ws.setColumnView(col,20);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "CustomerPO", ACenterBL));
					ws.setColumnView(col,20);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "P/L Date", ACenterBL));
					ws.setColumnView(col,12);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Ship to ID", ACenterBL));
					ws.setColumnView(col,10);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Ship to", ACenterBL));
					ws.setColumnView(col,50);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Bill to ID", ACenterBL));
					ws.setColumnView(col,10);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Bill to", ACenterBL));
					ws.setColumnView(col,50);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Carton NO", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Invoice", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Customer P/N", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "TSC P/N", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Shipment Term", ACenterBL));
					ws.setColumnView(col,25);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Quantity", ACenterBL));
					ws.setColumnView(col,10);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Price", ACenterBL));
					ws.setColumnView(col,10);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Currency", ACenterBL));
					ws.setColumnView(col,10);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Error Message", ACenterBL));
					ws.setColumnView(col,30);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Import Date", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Tax Code", ACenterBL));
					ws.setColumnView(col,25);
					col++;
					row++;


					sql = " SELECT a.packinglistnumber"+
							",to_char(a.packinglistdate,'yyyy-mm-dd') packinglistdate "+
							",a.cartonnumber"+
							",a.awb"+
							",a.invoicenumber"+
							",a.customerpo"+
							",a.customerproductnumber"+
							",a.quantity"+
							",a.price"+
							",nvl(d.CUSTOMER_NAME_PHONETIC,a.customer_name) customer_name"+
							",a.tsc_prod_description"+
							",a.shipmentterm"+
							",'('||d.customer_number||')' || REPLACE(d.CUSTOMER_NAME,''\'',' ') erp_customer "+
							",a.SHIPTOADDRESSID"+
							",a.BILLTOADDRESSID"+
							",(select loc.ADDRESS1 from AR_SITE_USES_V asuv,HZ_CUST_ACCT_SITES hcas, hz_party_sites party_site, hz_locations loc"+
							" where  asuv.ADDRESS_ID = hcas.cust_acct_site_id"+
							" AND hcas.party_site_id = party_site.party_site_id"+
							" AND loc.location_id = party_site.location_id "+
							" and asuv.STATUS='A' "+
							" and asuv.SITE_USE_ID = a.SHIPTOADDRESSID ) shipto"+
							",(select loc.ADDRESS1 from AR_SITE_USES_V asuv,HZ_CUST_ACCT_SITES hcas, hz_party_sites party_site, hz_locations loc"+
							" where  asuv.ADDRESS_ID = hcas.cust_acct_site_id"+
							" AND hcas.party_site_id = party_site.party_site_id"+
							" AND loc.location_id = party_site.location_id "+
							" and asuv.STATUS='A' "+
							" and asuv.SITE_USE_ID = a.BILLTOADDRESSID ) billto"+
							",a.CURRENCY"+
							",a.ERROR_EXCEPTION"+
							",to_char(a.CREATION_DATE,'yyyy/mm/dd') CREATION_DATE"+
							",a.tax_code"+ //add by Peggy 20200702
							" FROM tsc_packinglist_data a ,hz_cust_site_uses_all b,HZ_CUST_ACCT_SITES_all c,APPS.AR_CUSTOMERS d"+
							" where a.BILLTOADDRESSID=b.site_use_id(+)"+
							" and b.cust_acct_site_id=c.cust_acct_site_id(+)"+
							" and c.cust_account_id=d.CUSTOMER_ID(+)"+
							" and NOT EXISTS (SELECT 1 FROM tsc_oe_auto_headers x WHERE x.PACKINGLISTNUMBER=A.packinglistnumber AND x.customerpo=A.CUSTOMERPO)";
					if (RTYPE.equals("AUTO"))
					{
						sql +="  AND a.BATCH_ID='"+V_BATCH_ID+"'";
					}
					else
					{
						sql += " AND a.CREATION_DATE between to_date('"+SDATE+"','yyyymmdd') AND to_date('"+EDATE+"','yyyymmdd')+0.99999";
					}
					sql += " order by 	a.packinglistnumber	,a.customerpo";

					//out.println(sql);
					Statement state1=con.createStatement();
					ResultSet rs1=state1.executeQuery(sql);
					while (rs1.next())
					{
						col=0;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("ERP_CUSTOMER") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("PACKINGLISTNUMBER") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUSTOMERPO") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("PACKINGLISTDATE") ,  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("SHIPTOADDRESSID") ,  ARightL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("SHIPTO") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("BILLTOADDRESSID") ,  ARightL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("BILLTO") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CARTONNUMBER"),  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("INVOICENUMBER"),  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUSTOMERPRODUCTNUMBER"),  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("TSC_PROD_DESCRIPTION"),  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("SHIPMENTTERM"),  ALeftL));col++;
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs1.getString("QUANTITY")).doubleValue(), ARightL));col++;
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs1.getString("PRICE")).doubleValue(),  ARightL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CURRENCY"),  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("ERROR_EXCEPTION"),  ALeftLR));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CREATION_DATE"),  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, (rs1.getString("TAX_CODE")==null?"":rs1.getString("TAX_CODE")),  ACenterL));col++; //add by Peggy 20200702
						row++;
						reccnt++;
					}
					rs1.close();
					state1.close();
					totcnt +=reccnt;
				}
				else if (sheetname[k].equals("PL Source List"))
				{
					reccnt=0;row =0;col=0;
					ws.addCell(new jxl.write.Label(col, row, "ERP Customer Name", ACenterBL));
					ws.setColumnView(col,40);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "PackingListNumber", ACenterBL));
					ws.setColumnView(col,20);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "CustomerPO", ACenterBL));
					ws.setColumnView(col,20);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "P/L Date", ACenterBL));
					ws.setColumnView(col,12);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Ship to ID", ACenterBL));
					ws.setColumnView(col,10);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Ship to", ACenterBL));
					ws.setColumnView(col,50);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Bill to ID", ACenterBL));
					ws.setColumnView(col,10);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Bill to", ACenterBL));
					ws.setColumnView(col,50);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Carton NO", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Invoice", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Customer P/N", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "TSC P/N", ACenterBL));
					ws.setColumnView(col,15);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Shipment Term", ACenterBL));
					ws.setColumnView(col,25);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Quantity", ACenterBL));
					ws.setColumnView(col,10);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Price", ACenterBL));
					ws.setColumnView(col,10);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Currency", ACenterBL));
					ws.setColumnView(col,10);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "MO#", ACenterBL));
					ws.setColumnView(col,12);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "MO Creation Date", ACenterBL));
					ws.setColumnView(col,15	);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Invoice No", ACenterBL));
					ws.setColumnView(col,15	);
					col++;

					ws.addCell(new jxl.write.Label(col, row, "Tax Code", ACenterBL));
					ws.setColumnView(col,25	);
					col++;
					row++;


					sql = " SELECT a.packinglistnumber"+ //modify by Peggy 20210217
							",to_char(a.packinglistdate,'yyyy-mm-dd') packinglistdate "+
							",a.cartonnumber"+
							",a.awb"+
							",a.invoicenumber"+
							",a.customerpo"+
							",a.customerproductnumber"+
							",a.quantity"+
							",a.price"+
							",nvl(d.CUSTOMER_NAME_PHONETIC,a.customer_name) customer_name"+
							",a.tsc_prod_description"+
							",a.shipmentterm"+
							",'('||d.customer_number||')' || REPLACE(d.CUSTOMER_NAME,''\'',' ') erp_customer "+
							",a.SHIPTOADDRESSID"+
							",a.BILLTOADDRESSID"+
							",(select loc.ADDRESS1 from AR_SITE_USES_V asuv,HZ_CUST_ACCT_SITES hcas, hz_party_sites party_site, hz_locations loc"+
							" where  asuv.ADDRESS_ID = hcas.cust_acct_site_id"+
							" AND hcas.party_site_id = party_site.party_site_id"+
							" AND loc.location_id = party_site.location_id "+
							" and asuv.STATUS='A' "+
							" and asuv.SITE_USE_ID = a.SHIPTOADDRESSID ) shipto"+
							",(select loc.ADDRESS1 from AR_SITE_USES_V asuv,HZ_CUST_ACCT_SITES hcas, hz_party_sites party_site, hz_locations loc"+
							" where  asuv.ADDRESS_ID = hcas.cust_acct_site_id"+
							" AND hcas.party_site_id = party_site.party_site_id"+
							" AND loc.location_id = party_site.location_id "+
							" and asuv.STATUS='A' "+
							" and asuv.SITE_USE_ID = a.BILLTOADDRESSID ) billto"+
							",a.CURRENCY"+
							",a.ERROR_EXCEPTION"+
							",e.ORDER_NUMBER"+
							",TO_CHAR(f.CREATION_DATE,'yyyy-mm-dd') MO_CREATION_DATE"+
							//",g.FLOW_STATUS_CODE"+ //modify by Peggy 20210217
							//",h.NAME INVOICE_NO"+
							",f.INVOICE_NO"+ //modify by Peggy 20210217
							//",g.HEADER_ID"+  //modify by Peggy 20210217
							//",g.LINE_ID"+	 //modify by Peggy 20210217
							",a.tax_code"+ //add by Peggy 202020702
							" FROM tsc_packinglist_data a "+
							",hz_cust_site_uses_all b"+
							",HZ_CUST_ACCT_SITES_all c"+
							",APPS.AR_CUSTOMERS d"+
							",tsc_oe_auto_headers e"+
							//",ONT.OE_ORDER_HEADERS_ALL f"+
							//",ONT.OE_ORDER_LINES_ALL g"+
							//",(SELECT x.SOURCE_HEADER_ID, x.SOURCE_LINE_ID,x.DELIVERY_DETAIL_ID,x.SRC_REQUESTED_QUANTITY,x.SRC_REQUESTED_QUANTITY_UOM, y.DELIVERY_ID,z.NAME"+
							//",(SELECT distinct x.SOURCE_HEADER_ID,z.NAME"+
							//" FROM wsh.wsh_delivery_details x,wsh.wsh_delivery_assignments y,wsh.wsh_new_deliveries z "+
							//" WHERE x.delivery_detail_id = y.delivery_detail_id "+
							//" AND y.delivery_id = z.delivery_id) h"+
							",(select F.order_number,f.creation_date,listagg(h.name,'/') within group (order by h.name) INVOICE_NO from ont.oe_order_headers_all f, (SELECT DISTINCT x.source_header_id,"+
							" z.name FROM wsh.wsh_delivery_details x, wsh.wsh_delivery_assignments y, wsh.wsh_new_deliveries z WHERE x.delivery_detail_id = y.delivery_detail_id"+
							" AND y.delivery_id = z.delivery_id) h"+
							" where substr(f.order_number,1,4)=1211 and f.header_id=h.SOURCE_HEADER_ID(+)"+
							" group by F.order_number,f.creation_date) f"+
							" where a.BILLTOADDRESSID=b.site_use_id(+)"+
							" and b.cust_acct_site_id=c.cust_acct_site_id(+)"+
							" and c.cust_account_id=d.CUSTOMER_ID(+)"+
							" and a.PACKINGLISTNUMBER=e.packinglistnumber(+)"+
							" and a.customerpo=e.CUSTOMERPO(+)"+
							" and e.order_number=f.order_number(+)";
					//" and f.header_id=g.header_id(+)"+
					//" AND g.HEADER_ID = h.SOURCE_HEADER_ID(+)"+
					//" AND g.LINE_ID = h.SOURCE_LINE_ID(+)";
					sql += " AND a.CREATION_DATE between to_date('"+SDATE+"','yyyymmdd') AND to_date('"+EDATE+"','yyyymmdd')+0.99999";
					if (!PACKINGLIST.equals(""))
					{
						sql += " AND (a.packinglistnumber LIKE '"+ PACKINGLIST+"%' or a.customerpo like '"+ PACKINGLIST+"%')";
					}
					if (!cust.equals(""))
					{
						sql += " and (d.customer_number = "+cust+" or d.CUSTOMER_NAME like '%"+cust+"%')"; //add by Peggy 20160805
					}
					sql += " order by 	a.packinglistnumber	,a.customerpo";
					//out.println(sql);
					Statement state1=con.createStatement();
					ResultSet rs1=state1.executeQuery(sql);
					while (rs1.next())
					{
						col=0;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("ERP_CUSTOMER") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("PACKINGLISTNUMBER") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUSTOMERPO") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("PACKINGLISTDATE") ,  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("SHIPTOADDRESSID") ,  ARightL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("SHIPTO") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("BILLTOADDRESSID") ,  ARightL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("BILLTO") ,  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CARTONNUMBER"),  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("INVOICENUMBER"),  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CUSTOMERPRODUCTNUMBER"),  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("TSC_PROD_DESCRIPTION"),  ALeftL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("SHIPMENTTERM"),  ALeftL));col++;
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs1.getString("QUANTITY")).doubleValue(), ARightL));col++;
						ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs1.getString("PRICE")).doubleValue(),  ARightL));col++;
						ws.addCell(new jxl.write.Label(col, row, rs1.getString("CURRENCY"),  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, (rs1.getString("ORDER_NUMBER")==null?"":rs1.getString("ORDER_NUMBER")),  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, (rs1.getString("MO_CREATION_DATE")==null?"":rs1.getString("MO_CREATION_DATE")),  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, (rs1.getString("INVOICE_NO")==null?"":rs1.getString("INVOICE_NO")),  ACenterL));col++;
						ws.addCell(new jxl.write.Label(col, row, (rs1.getString("TAX_CODE")==null?"":rs1.getString("TAX_CODE")),  ACenterL));col++;
						row++;
						reccnt++;
					}
					rs1.close();
					state1.close();
					totcnt +=reccnt;
				}
			}
			wwb.write();
			wwb.close();

			if (RTYPE.equals("AUTO") && totcnt >0)
			{
				Properties props = System.getProperties();
				props.put("mail.transport.protocol","smtp");
				props.put("mail.smtp.host", "mail.ts.com.tw");
				props.put("mail.smtp.port", "25");

				Session s = Session.getInstance(props, null);
				javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
				message.setSentDate(new java.util.Date());
				message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
				if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 &&  request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
				{
					remarks="(This is a test letter, please ignore it)";
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
				}
				else
				{
					remarks="";
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("emily.hsin@ts.com.tw"));
				}
				message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));

				message.setSubject("Packing Notice: TSCE PackingList-"+dateBean.getYearMonthDay()+remarks);
				javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
				javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
				String str_d = "<font style='font-size:14px;font-family:Times New Roman;'>當Remark欄位出現紅字訊息,表示資料異常,請到<a href='http://tsrfq.ts.com.tw:8080/oradds/jsp/Tsc1211GenerateXmlAll.jsp'>RFQ D4-001</a> 功能畫面進行確認,謝謝!<p><p>"+
						"P.S此為系統自動發送的EMAIL信件，請勿直接回信，謝謝!";
				mbp.setContent(str_d, "text/html;charset=UTF-8");
				mp.addBodyPart(mbp);
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

