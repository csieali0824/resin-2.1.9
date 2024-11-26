<!-- 20160705 by Peggy,排除ORG ID:807庫存-->
<!-- 20170210 by Peggy,單價調整AWAITING_APPROVE也要加入-->
<!-- 20170426 by Peggy,add tsc_package field for matrix SMA,Matrix SMB-->
<!-- 20170829 by Peggy,蘇州/上海/深圳業務單位變更郵件domain由mail.tew.com.cn改為ts-china.com.cn-->
<!-- 20171128 by Peggy,顯示海外庫存資訊-->
<%@ page contentType="text/html;charset=utf-8"  language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Stock Qty > Unship Qty</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCITEMStockExcel.jsp" METHOD="post" name="MYFORM">
<%
String FileName="",sql="",remarks="";
String item = request.getParameter("ITEM");
if (item==null) item="";
String TSCPRODGROUP = request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP="--";  
String OFILTER = request.getParameter("OFILTER");
if (OFILTER==null) OFILTER="--";
String ROLE = request.getParameter("ROLE");
if (ROLE==null) ROLE="";
OutputStream os = null;	
int fontsize=9,colcnt=0;
int row =0,col=0,reccnt=0;
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
	
	FileName="SSD-"+"Onhand Qty granter than Unship Qty";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("Sheet1", 0); 
	SheetSettings sst = ws.getSettings(); 
	
	/*	 
	sql = " SELECT  x.item_no, x.description,x.organization_code, x.uom, x.onhand_qty,x.unship_qty"+
		   " FROM ( select a.organization_code,a.organization_id,a.inventory_item_id,a.segment1 item_no,a.description,a.uom,sum(onhand_qty) onhand_qty,sum(unship_qty) unship_qty"+
		   " from (select  mp.organization_code,msi.organization_id,msi.inventory_item_id,msi.segment1 ,msi.description,MSI.PRIMARY_UNIT_OF_MEASURE UOM"+
		   ",nvl((SELECT  SUM (moq.primary_transaction_quantity) "+
		   " FROM mtl_onhand_quantities_detail moq"+
		   //" WHERE moq.organization_id NOT IN (46, 386)"+
		   " WHERE moq.organization_id NOT IN (46, 386,807)"+  //add by Peggy 20160705
		   " AND moq.organization_id = msi.organization_id"+
		   " AND moq.inventory_item_id = msi.inventory_item_id"+
		   " ),0)  onhand_qty,"+
		   " nvl((SELECT SUM (DECODE (order_quantity_uom,'PCE', ordered_quantity / 1000, ordered_quantity))"+
		   " FROM oe_order_lines_all ool"+
		   //" WHERE ool.ship_from_org_id NOT IN (46, 386)"+
		   " WHERE ool.ship_from_org_id NOT IN (46, 386,807)"+  //add by Peggy 20160705
		   " AND ool.line_category_code = 'ORDER'"+
		   " AND ool.cancelled_flag = 'N'"+
		   " AND ool.flow_status_code IN ('ENTERED', 'BOOKED', 'AWAITING_SHIPPING','AWAITING_APPROVE')"+ //add by Peggy 20170210
		   " AND ool.ship_from_org_id = msi.organization_id"+
		   " AND ool.inventory_item_id = msi.inventory_item_id"+
		   " ),0)  unship_qty"+
		   " from mtl_system_items msi,mtl_parameters mp"+
		   " where msi.organization_id=mp.organization_id ";
	if (!TSCPRODGROUP.equals("") && !TSCPRODGROUP.equals("--"))
	{
		sql += " and tsc_om_category(msi.inventory_item_id,msi.organization_id,'TSC_PROD_GROUP')='"+TSCPRODGROUP+"'";
	}	
	if (item !=null && !item.equals(""))
	{					   
		sql += " and ( MSI.SEGMENT1 LIKE upper('%"+item+"%') or upper(MSI.DESCRIPTION) like upper('%"+item+"%')) ";
	}		   
	sql += " ) a"+
		   " group by a.organization_code,a.organization_id,a.inventory_item_id,a.segment1,a.description,a.uom"+
		   " having sum(onhand_qty)>0 or sum(unship_qty)>0) x";
	if (OFILTER.equals("1"))
	{
		sql +=	 " where nvl(x.onhand_qty,0) >nvl(x.unship_qty,0) ";
	}
	sql += " ORDER BY 1";
	*/
	sql = "select x.source_stock \"Stock source\", x.item_no, x.description,x.TSC_Package,x.organization_code, x.uom, x.onhand_qty,x.unship_qty ,x.customer, x.item_info"+
	       " from (SELECT 'ERP' source_stock,mp.organization_code,"+
		   "         msi.organization_id,"+
		   "         msi.inventory_item_id,"+
		   "         msi.segment1 item_no,"+
		   "         msi.description,"+
		   "         TSC_INV_Category(msi.inventory_item_id,43,'1100000003') TSC_Prod_Group,"+
		   "         TSC_INV_Category(msi.inventory_item_id,43,'21') TSC_Family,"+
		   "         TSC_INV_Category(msi.inventory_item_id,43,'1100000004') TSC_Prod_Family,"+
		   "         TSC_INV_Category(msi.inventory_item_id,43,'23') TSC_Package,"+
		   "         msi.primary_unit_of_measure uom,"+
		   "         NVL ((SELECT SUM (moq.primary_transaction_quantity) FROM mtl_onhand_quantities_detail moq WHERE  moq.organization_id = msi.organization_id  AND moq.inventory_item_id = msi.inventory_item_id),0) onhand_qty,"+
		   "         NVL ((SELECT SUM (DECODE (order_quantity_uom,'PCE', ordered_quantity / 1000, ordered_quantity)) FROM oe_order_lines_all ool WHERE ool.line_category_code = 'ORDER' AND ool.cancelled_flag = 'N' AND ool.flow_status_code IN ('ENTERED','BOOKED','AWAITING_SHIPPING','AWAITING_APPROVE') AND ool.ship_from_org_id = msi.organization_id  AND ool.inventory_item_id = msi.inventory_item_id),0)  unship_qty"+
		   "         ,'' customer,'' item_info"+
		   "         FROM mtl_system_items msi,"+
		   "         mtl_parameters mp"+
		   "         WHERE msi.organization_id = mp.organization_id"+
		   "         and msi.organization_id NOT IN (46, 386,807)";
	if (item !=null && !item.equals(""))
	{
		sql += " and ( MSI.SEGMENT1 LIKE upper('%"+item.trim()+"%') or MSI.DESCRIPTION like upper('%"+item.trim()+"%')) ";
	}	
	sql += " union all"+
			" select 'Out Side' source_stock ,a.AREA organization_code,"+
			" 0 organization_id,"+
			" a.inventory_item_id,"+
			" a.item_name item_no,"+
			" a.item_desc description,"+
			" TSC_INV_Category(a.inventory_item_id,43,'1100000003') TSC_Prod_Group,"+
			" TSC_INV_Category(a.inventory_item_id,43,'21') TSC_Family,"+
			" TSC_INV_Category(a.inventory_item_id,43,'1100000004') TSC_Prod_Family,"+
			" TSC_INV_Category(a.inventory_item_id,43,'23') TSC_Package,"+
			" 'KPC' uom,"+
			" A.QTY/1000 onhand_qty,"+
			" 0 unship_qty"+
		    " ,a.customer,a.DATE_CODE||case when a.DATE_CODE is null then '' else '/' end ||a.LOT_NUMBER item_info"+
			" from oraddman.tsc_wws_stock_detail a,oraddman.tsc_wws_stock_header  b"+
			" where a.VERSION_ID=b.VERSION_ID"+
			" and VERSION_FLAG='A'";
	if (item !=null && !item.equals(""))
	{
		sql += " and ( a.item_name LIKE upper('%"+item.trim()+"%') or a.item_desc like upper('%"+item.trim()+"%')) ";
	}								   
					   
	sql +="         ) x "+
		   " where ONHAND_QTY+UNSHIP_QTY >0";
	if (!TSCPRODGROUP.equals("") && !TSCPRODGROUP.equals("--"))
	{					   
		sql+=" and TSC_Prod_Group='"+TSCPRODGROUP+"'";
	}
	if (OFILTER.equals("1"))
	{				
		sql+=" and ONHAND_QTY-UNSHIP_QTY >0";
	}
	sql+=" order by 1,2,4,5";	
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
				if (i==2 || i == 3 || i==9 || i==10)
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
					ws.setColumnView(col+(i-1),35);	
				}
				else
				{
					ws.addCell(new jxl.write.Label(col+(i-1), row, md.getColumnLabel(i) , ACenterBL));
					ws.setColumnView(col+(i-1),15);	
				}
			}
			row++;
		}
		for (int i =1 ; i <= colcnt ; i++)
		{
			if (i==7|| i==8)
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, (new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString(i))) , ARightL));
				//ws.setColumnView(col+(i-1),15);
			}
			else 
			{
				ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ALeftL));
				//if (i==2 || i==3 || i==9 || i==10)
				//{
				//	ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ALeftL));
					//ws.setColumnView(col+(i-1),35);
				//}
				//else
				//{
				//	ws.addCell(new jxl.write.Label(col+(i-1), row, rs.getString(i) , ALeftL));
					//ws.setColumnView(col+(i-1),15);
				//}
			}
		}	
		reccnt++;
		row++;
	}
	wwb.write(); 
	wwb.close();
	
	rs.close();
	state.close();
 
	if (ROLE.equals("SYS") && reccnt >0)
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
			remarks="(此為測試信件，請勿理會)";
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
		}
		else
		{
			remarks="";
			//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("ccyang@ts-china.com.cn"));
			message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
		}
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject(dateBean.getYearMonthDay()+" - Onhand > Unship Notification!"+remarks);
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		String str_d = "<font style='font-size:14px;font-family:Times New Roman;'>Dear All:<p>"+
					   "附檔為SSD Onhand > Unship的item明細,請知悉!<p>"+
					   "P.S此為系統自動發送的EMAIL信件，請勿直接回信，謝謝!";
		mbp.setContent(str_d,"text/html;charset=UTF-8");
		mp.addBodyPart(mbp);
		mbp = new javax.mail.internet.MimeBodyPart();
		javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
		mbp.setDataHandler(new javax.activation.DataHandler(fds));
		mbp.setFileName(fds.getName());
	
		// create the Multipart and add its parts to it
		mp.addBodyPart(mbp);
		message.setContent(mp);
		Transport.send(message);	
	}
}   
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 
out.close(); 
%>
</FORM>
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
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

