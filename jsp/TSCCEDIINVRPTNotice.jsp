<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,java.lang.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TSCC EDI INV Notice</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSCCEDIINVRPTNotice.jsp" METHOD="post" name="MYFORM">
<%
String v_batch_id = request.getParameter("BATCH_ID");
if (v_batch_id==null) v_batch_id="";
String DTYPE_LIST []= new String[]{"Stock Report","Stock Movement(Reception)","Stock Movement(Consumption)"};
String DTYPE=request.getParameter("DTYPE");
if (DTYPE==null || DTYPE.equals("--")) DTYPE="";
String SYEAR=request.getParameter("SYEAR");
if (SYEAR==null || SYEAR.equals("--")) SYEAR="";
String SMON=request.getParameter("SMON");
if (SMON==null || SMON.equals("--")) SMON="";
String ERPCUSTOMER=request.getParameter("ERPCUSTOMER");
if(ERPCUSTOMER==null || ERPCUSTOMER.equals("--")) ERPCUSTOMER="";
String CUSTPARTNO =request.getParameter("CUSTPARTNO");
if(CUSTPARTNO==null) CUSTPARTNO="";
String TSCPARTNO=request.getParameter("TSCPARTNO");
if(TSCPARTNO==null) TSCPARTNO="";
String FileName="",sql="",remarks="",v_cust_po="";
int fontsize=9,colcnt=0;
int row =0,col=0,reccnt=0,totcnt=0;
String TOT_ALL_STOCK_MOVE_QTY ="",TOT_ALL_ACTUAL_STOCK_QTY="";
try  
{ 	
	OutputStream os = null;
	WritableWorkbook wwb = null;
	WritableSheet ws = null;
	SheetSettings sst = null;
	WritableCellFormat ACenterBL=null,ACenterL=null,ARightL=null,ALeftL=null;
	
	sql = " select row_number() over (partition by e.customer_number,case a.doc_code when '78' then 'Stock Movement' when '35' then 'Stock Report' else a.doc_code end,c.cust_part_no,inv_move_reason_name order by a.doc_issue_date,a.doc_header_id) group_seq"+
	      ",count(1) over (partition by e.customer_number,case a.doc_code when '78' then 'Stock Movement' when '35' then 'Stock Report' else a.doc_code end,c.cust_part_no,inv_move_reason_name) group_cnt"+
          ",e.customer_number,e.customer_name,a.doc_no,case a.doc_code when '78' then 'Stock Movement' when '35' then 'Stock Report' else a.doc_code end doc_name"+
		  ",to_char(a.doc_issue_date,'yyyy/mm/dd') doc_issue_date,b.location_code,c.cust_part_no"+
		  ",d.doc_header_id, d.line_number, d.inv_move_code,d.inv_move_reason_code, d.inv_move_reason_name, d.stock_move_qty,"+
          " d.stock_move_qty_uom, d.actual_stock_qty, d.actual_stock_qty_uom,d.previous_qty, d.previous_qty_uom, to_char(d.posting_date,'yyyymmdd') posting_date,"+
          " d.previous_report_date, d.delivery_note_number,d.goods_receipt_number, d.aggregation_number, d.orig_delivery_note_number, d.order_document"+
          ",sum(d.stock_move_qty) over (partition by e.customer_number,c.cust_part_no,a.doc_code,d.INV_MOVE_REASON_NAME) tot_stock_move_qty"+
          ",sum(d.actual_stock_qty) over (partition by e.customer_number,c.cust_part_no,a.doc_code,d.INV_MOVE_REASON_NAME) tot_actual_stock_qty"+
          ",row_number() over (partition by e.customer_number,c.cust_part_no,a.doc_code ,d.INV_MOVE_REASON_NAME order by a.doc_issue_date,1,a.doc_header_id) row_seq"+
          ",count(1) over (partition by e.customer_number,c.cust_part_no,a.doc_code ,d.INV_MOVE_REASON_NAME) row_cnt"+
          ",sum(d.stock_move_qty) over (partition by 1) tot_all_stock_move_qty"+
          ",sum(d.actual_stock_qty) over (partition by 1) tot_all_actual_stock_qty"+
          " from edi.tscc_invrpt_elements a"+
		  ",edi.tscc_invrpt_headers_all b"+
		  ",edi.tscc_invrpt_lines_all c"+
		  ",edi.tscc_invrpt_line_stock_all d"+
		  ",ar_customers e"+
          " where a.doc_header_id=b.doc_header_id"+
          " and b.doc_header_id=c.doc_header_id"+
          " and c.doc_header_id=d.doc_header_id"+
          " and c.line_number=d.line_number"+
          " and a.erp_cust_number=e.customer_number";
	if (!v_batch_id.equals(""))
	{		  
    	sql +=" and a.batch_id=?"+
		      " and a.NOTICE_DATE is null"+
              " order by e.customer_number,c.cust_part_no,a.doc_code,d.INV_MOVE_REASON_NAME,a.doc_issue_date,1,a.doc_header_id";
	}
	else
	{
		if (DTYPE.equals(DTYPE_LIST[0]))
		{
			sql += " and a.doc_code='35'";
		}
		else if (DTYPE.equals(DTYPE_LIST[1]))
		{
			sql += " and a.doc_code='78' and d.inv_move_reason_name='Reception'";	
		}
		else if (DTYPE.equals(DTYPE_LIST[2]))
		{
			sql += " and a.doc_code='78' and d.inv_move_reason_name='Consumption'";	
		}	
		if (!ERPCUSTOMER.equals(""))
		{
			sql += " and e.customer_number ='"+ERPCUSTOMER+"'";
		}		  
		if (!TSCPARTNO.equals(""))
		{
			String [] strTSCPARTNO = TSCPARTNO.split("\n");
			String TSCPARTNOList = "";
			for (int x = 0 ; x < strTSCPARTNO.length ; x++)
			{
				if (TSCPARTNOList.length() >0) TSCPARTNOList += ",";
				TSCPARTNOList += "'"+strTSCPARTNO[x].trim()+"'";
			}
			sql += " and c.tsc_part_no in ("+TSCPARTNOList+")";
		}	
		if (!CUSTPARTNO.equals(""))
		{
			String [] strCUSTPARTNO = CUSTPARTNO.split("\n");
			String CUSTPARTNOList = "";
			for (int x = 0 ; x < strCUSTPARTNO.length ; x++)
			{
				if (CUSTPARTNOList.length() >0) CUSTPARTNOList += ",";
				CUSTPARTNOList += "'"+strCUSTPARTNO[x].trim()+"'";
			}
			sql += " and c.cust_part_no in ("+CUSTPARTNOList+")";
		}	
		if (!SYEAR.equals(""))
		{
			sql += " and to_char(a.doc_issue_date,'yyyy') ='"+SYEAR+"'";
		}
		if (!SMON.equals(""))
		{
			sql += " and to_char(a.doc_issue_date,'mm') ='"+SMON+"'";
		}
		sql +=  " order by e.customer_number,c.cust_part_no,a.doc_code,d.INV_MOVE_REASON_NAME,a.doc_issue_date,1,a.doc_header_id";		
	}
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	if (!v_batch_id.equals(""))
	{
		statement.setString(1,v_batch_id);
	}
	ResultSet rs=statement.executeQuery();		  
	col=0;row=0;
	while (rs.next())	
	{
		if ((!v_batch_id.equals("") && rs.getInt("group_seq")==1) || (v_batch_id.equals("") && row==0))
		{	
			TOT_ALL_STOCK_MOVE_QTY = rs.getString("TOT_ALL_STOCK_MOVE_QTY");
			TOT_ALL_ACTUAL_STOCK_QTY = rs.getString("TOT_ALL_ACTUAL_STOCK_QTY");
			
			//英文內文水平垂直置中-粗體-格線   
			ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
			ACenterBL.setWrap(true);
		
			//英文內文水平垂直置中-正常-格線   
			ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
			ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ACenterL.setWrap(true);
		
			//英文內文水平垂直置右-正常-格線   
			ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ARightL.setAlignment(jxl.format.Alignment.RIGHT);
			ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ARightL.setWrap(true);
		
			//英文內文水平垂直置左-正常-格線   
			ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
			ALeftL.setAlignment(jxl.format.Alignment.LEFT);
			ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
			ALeftL.setWrap(true);

			if (!v_batch_id.equals(""))
			{
				FileName="TSCC EDI "+rs.getString("DOC_NAME")+(rs.getString("INV_MOVE_REASON_NAME")==null?"":"("+rs.getString("INV_MOVE_REASON_NAME")+")")+" Notice-"+rs.getString("customer_number")+"-"+rs.getString("doc_header_id")+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
			}
			else
			{
				FileName="TSCC EDI "+rs.getString("DOC_NAME")+(rs.getString("INV_MOVE_REASON_NAME")==null?"":"("+rs.getString("INV_MOVE_REASON_NAME")+")")+" Notice-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
			}
		
			os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\tsccedi\\"+FileName);
			wwb = Workbook.createWorkbook(os); 
			ws = wwb.createSheet("Sheet1", 0); 
			sst = ws.getSettings(); 			
			//sst.setScaleFactor(100);   // 打印縮放比例
			//sst.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
			//sst.setHeaderMargin(0.3);
			//sst.setBottomMargin(0.5);
			//sst.setLeftMargin(0.2);
			//sst.setRightMargin(0.2);
			//sst.setTopMargin(0.5);
			//sst.setFooterMargin(0.3);					
			
			col=0;row=0;
			//out.println(rs.getString("DOC_NAME"));
			if (rs.getString("DOC_NAME").equals("Stock Report"))
			{
				ws.addCell(new jxl.write.Label(col, row, "ERP CUST NUMBER" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;
	
				ws.addCell(new jxl.write.Label(col, row, "ERP CUST NAME" , ACenterBL));
				ws.setColumnView(col,35);	
				col++;
	
				ws.addCell(new jxl.write.Label(col, row, "CUST PART NO" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	
							
				ws.addCell(new jxl.write.Label(col, row, "ISSUE DATE" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;		
				
				ws.addCell(new jxl.write.Label(col, row, "LOCATION" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;		
				
				ws.addCell(new jxl.write.Label(col, row, "ACTUAL STOCK QTY" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "UOM" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;
				
				ws.addCell(new jxl.write.Label(col, row, "TOT STOCK QTY" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
																	
				row++;
			}
			else if (rs.getString("INV_MOVE_REASON_NAME").equals("Reception"))
			{
				ws.addCell(new jxl.write.Label(col, row, "ERP CUST NUMBER" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;
	
				ws.addCell(new jxl.write.Label(col, row, "ERP CUST NAME" , ACenterBL));
				ws.setColumnView(col,35);	
				col++;
	
				ws.addCell(new jxl.write.Label(col, row, "CUST PART NO" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	
							
				ws.addCell(new jxl.write.Label(col, row, "ISSUE DATE" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;		
				
				ws.addCell(new jxl.write.Label(col, row, "DATA TYPE" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;		
				
				ws.addCell(new jxl.write.Label(col, row, "QTY" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "UOM" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;													

				ws.addCell(new jxl.write.Label(col, row, "ACTUAL STOCK QTY" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "UOM" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;													

				ws.addCell(new jxl.write.Label(col, row, "POSTING DATE" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;		

				ws.addCell(new jxl.write.Label(col, row, "DELIVERY NOTE NUMBER" , ACenterBL));
				ws.setColumnView(col,16);	
				col++;																
				
				ws.addCell(new jxl.write.Label(col, row, "TOT QTY" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "TOT STOCK QTY" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
				
				row++;			
			}
			else if (rs.getString("INV_MOVE_REASON_NAME").equals("Consumption"))
			{
				ws.addCell(new jxl.write.Label(col, row, "ERP CUST NUMBER" , ACenterBL));
				ws.setColumnView(col,10);	
				col++;
	
				ws.addCell(new jxl.write.Label(col, row, "ERP CUST NAME" , ACenterBL));
				ws.setColumnView(col,35);	
				col++;

				ws.addCell(new jxl.write.Label(col, row, "CUST PO" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	
	
				ws.addCell(new jxl.write.Label(col, row, "CUST PART NO" , ACenterBL));
				ws.setColumnView(col,15);	
				col++;	
							
				ws.addCell(new jxl.write.Label(col, row, "ISSUE DATE" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;		
				
				ws.addCell(new jxl.write.Label(col, row, "DATA TYPE" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;		

				ws.addCell(new jxl.write.Label(col, row, "AGGREGATION NUMBER" , ACenterBL));
				ws.setColumnView(col,16);	
				col++;		
				
				ws.addCell(new jxl.write.Label(col, row, "QTY" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
				
				ws.addCell(new jxl.write.Label(col, row, "UOM" , ACenterBL));
				ws.setColumnView(col,8);	
				col++;													

				ws.addCell(new jxl.write.Label(col, row, "POSTING DATE" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;		

				ws.addCell(new jxl.write.Label(col, row, "DELIVERY NOTE NUMBER" , ACenterBL));
				ws.setColumnView(col,16);	
				col++;		
				
				ws.addCell(new jxl.write.Label(col, row, "TOT QTY" , ACenterBL));
				ws.setColumnView(col,12);	
				col++;	
																		
				row++;				
			}
			else
			{
				throw new Exception("not found report format");
			}
		}
		
		col=0;
		if (rs.getString("DOC_NAME").equals("Stock Report"))
		{
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NUMBER"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PART_NO") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("DOC_ISSUE_DATE") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("LOCATION_CODE") ,  ALeftL));
			col++;
			if (rs.getString("ACTUAL_STOCK_QTY")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, null,  ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ACTUAL_STOCK_QTY")).doubleValue(), ARightL));
			}
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ACTUAL_STOCK_QTY_UOM") ,  ALeftL));
			col++;
			if (rs.getInt("ROW_SEQ")==rs.getInt("ROW_CNT"))
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOT_ACTUAL_STOCK_QTY")).doubleValue(), ARightL));
				col++;			
			}
			else
			{
				ws.addCell(new jxl.write.Label(col, row, null,  ALeftL));
				col++;			
			}
			row++;
		}
		else if (rs.getString("INV_MOVE_REASON_NAME").equals("Reception"))
		{			
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NUMBER"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PART_NO") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("DOC_ISSUE_DATE") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("INV_MOVE_REASON_NAME") ,  ALeftL));
			col++;
			if (rs.getString("STOCK_MOVE_QTY")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, null,  ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("STOCK_MOVE_QTY")).doubleValue(), ARightL));
			}
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("STOCK_MOVE_QTY_UOM") ,  ALeftL));
			col++;
			if (rs.getString("ACTUAL_STOCK_QTY")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, null,  ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("ACTUAL_STOCK_QTY")).doubleValue(), ARightL));
			}
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ACTUAL_STOCK_QTY_UOM") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("POSTING_DATE") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ORIG_DELIVERY_NOTE_NUMBER") ,  ALeftL));
			col++;
			if (rs.getInt("ROW_SEQ")==rs.getInt("ROW_CNT"))
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOT_STOCK_MOVE_QTY")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOT_ACTUAL_STOCK_QTY")).doubleValue(), ARightL));
				col++;	
			}
			else
			{
				ws.addCell(new jxl.write.Label(col, row, null,  ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, null,  ALeftL));
				col++;	
			}
			row++;
		
		}
		else if (rs.getString("INV_MOVE_REASON_NAME").equals("Consumption"))
		{
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NUMBER"),ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER_NAME") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ORDER_DOCUMENT") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_PART_NO") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("DOC_ISSUE_DATE") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("INV_MOVE_REASON_NAME") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("AGGREGATION_NUMBER") ,  ALeftL));
			col++;
			if (rs.getString("STOCK_MOVE_QTY")==null)
			{
				ws.addCell(new jxl.write.Label(col, row, null,  ALeftL));
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("STOCK_MOVE_QTY")).doubleValue(), ARightL));
			}
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("STOCK_MOVE_QTY_UOM") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("POSTING_DATE") ,  ALeftL));
			col++;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ORIG_DELIVERY_NOTE_NUMBER") ,  ALeftL));
			col++;
			if (rs.getInt("ROW_SEQ")==rs.getInt("ROW_CNT"))
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("TOT_STOCK_MOVE_QTY")).doubleValue(), ARightL));
				col++;	
			}
			else
			{
				ws.addCell(new jxl.write.Label(col, row, null,  ALeftL));
				col++;	
			}			
			row++;
		}	
		
		if (!v_batch_id.equals(""))
		{
			sql = " update edi.tscc_invrpt_elements a "+
				  " set a.NOTICE_DATE =SYSDATE"+
				  " where a.batch_id=?"+
				  " and a.doc_header_id=?"+
				  " AND a.NOTICE_DATE IS NULL";
			PreparedStatement pstmtDtl=con.prepareStatement(sql);	
			pstmtDtl.setString(1,v_batch_id);
			pstmtDtl.setString(2,rs.getString("doc_header_id"));
			pstmtDtl.executeQuery();
			pstmtDtl.close();			
				
			if (rs.getInt("group_seq")==rs.getInt("group_cnt"))
			{
				con.commit();
	
				wwb.write(); 
				wwb.close();
					
				Properties props = System.getProperties();
				props.put("mail.transport.protocol","smtp");
				if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
				{
					props.put("mail.smtp.host", "mail3.ts.com.tw");
				}
				else
				{
					props.put("mail.smtp.host", "mail.ts.com.tw");
				}
				
				props.put("mail.smtp.port", "25");
				
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
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("anna_qiu@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("kevin@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress("rita_zhou@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("nancy_yan@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("annie@ts-china.com.cn"));
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("lily_yin@ts-china.com.cn"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("tina@ts-china.com.cn"));
				}
				message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
					
				message.setSubject("TSCC EDI "+rs.getString("DOC_NAME")+(rs.getString("INV_MOVE_REASON_NAME")==null?"":"("+rs.getString("INV_MOVE_REASON_NAME")+")")+" Notice-"+rs.getString("customer_number")+"-"+rs.getString("doc_header_id")+"-"+dateBean.getYearMonthDay()+remarks);
				javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
				javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
				String str_d = "P.S此為系統自動發送的EMAIL信件，請勿直接回信，謝謝!";
				mbp.setContent(str_d, "text/html;charset=UTF-8");
				mp.addBodyPart(mbp);
				//ANNA不想收附件,modify by Peggy 20220608
				//mbp = new javax.mail.internet.MimeBodyPart();
				//javax.activation.FileDataSource fds = new javax.activation.FileDataSource("\\resin-2.1.9\\webapps\\oradds\\tsccedi\\"+FileName);
				//mbp.setDataHandler(new javax.activation.DataHandler(fds));
				//mbp.setFileName(fds.getName());
				//mp.addBodyPart(mbp);
				
				message.setContent(mp);
				Transport.send(message);
			}	
		}
	}
	if (v_batch_id.equals(""))
	{
		if (DTYPE.equals(DTYPE_LIST[0]))
		{
			ws.addCell(new jxl.write.Label(4, row, "合計:" , ACenterBL));
			ws.setColumnView(4,12);	
			
			ws.addCell(new jxl.write.Number(5, row, Double.valueOf(TOT_ALL_ACTUAL_STOCK_QTY).doubleValue(), ARightL));
			ws.setColumnView(4,12);	
			row++;
		}
		else if (DTYPE.equals(DTYPE_LIST[1]))
		{

			ws.addCell(new jxl.write.Label(4, row, "合計:" , ACenterBL));
			ws.setColumnView(4,12);	
			
			ws.addCell(new jxl.write.Number(5, row, Double.valueOf(TOT_ALL_STOCK_MOVE_QTY).doubleValue(), ARightL));
			ws.setColumnView(5,12);	

			ws.addCell(new jxl.write.Number(7, row, Double.valueOf(TOT_ALL_ACTUAL_STOCK_QTY).doubleValue(), ARightL));
			ws.setColumnView(7,12);	
			row++;

		}
		else if (DTYPE.equals(DTYPE_LIST[2]))
		{
			ws.addCell(new jxl.write.Label(6, row, "合計:" , ACenterBL));
			ws.setColumnView(6,12);	
			
			ws.addCell(new jxl.write.Number(7, row, Double.valueOf(TOT_ALL_STOCK_MOVE_QTY).doubleValue(), ARightL));
			ws.setColumnView(7,12);	
			row++;
		}		
		wwb.write(); 
		wwb.close();	
	}
	rs.close();
	statement.close();
	os.close();  
}   
catch (Exception e) 
{ 
	con.rollback();
	out.println("Exception:"+e.getMessage()); 
} 
out.close(); 
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
try
{
	if (v_batch_id.equals(""))
	{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/tsccedi/"+FileName; 
		response.sendRedirect(strURL);
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>

