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
<FORM ACTION="../jsp/TSShippingInvoiceNumberReport.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String INVOICE_YEAR=request.getParameter("INVOICE_YEAR");
if (INVOICE_YEAR==null || INVOICE_YEAR.equals("--")) INVOICE_YEAR=dateBean.getYearString();
String INVOICE_MONTH=request.getParameter("INVOICE_MONTH");
if (INVOICE_MONTH==null || INVOICE_MONTH.equals("--")) INVOICE_MONTH="";
String INVOICE_NO=request.getParameter("INVOICE_NO");
if (INVOICE_NO==null) INVOICE_NO="";
String INVOICEDATE=request.getParameter("INVOICEDATE");
if (INVOICEDATE==null) INVOICEDATE="";
String INVOICEDATEEND=request.getParameter("INVOICEDATEEND");
if (INVOICEDATEEND==null) INVOICEDATEEND="";
String SALES_GROUP=request.getParameter("SALES_GROUP");
if (SALES_GROUP==null) SALES_GROUP="";
String SHIPPING_MARKS=request.getParameter("SHIPPING_MARKS");
if (SHIPPING_MARKS==null) SHIPPING_MARKS="";
String SHIPPING_METHOD=request.getParameter("SHIPPING_METHOD");
if (SHIPPING_METHOD==null) SHIPPING_METHOD="";
String MO_NO=request.getParameter("MO_NO");
if (MO_NO==null) MO_NO="";
String SOURCE_NO=request.getParameter("SOURCE_NO");
if (SOURCE_NO==null) SOURCE_NO="";
String V_STATUS=request.getParameter("rdo_status");
if (V_STATUS==null) V_STATUS="UNUSED";
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=9,colcnt=0;
try 
{ 	

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TSC_InvoiceNum_Report";
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
	ACenterBLB.setWrap(false);	
		
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(false);

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
	ALeftL.setWrap(false);
	
	//英文內文水平垂直置左-正常-格線-Wrap=true   
	WritableCellFormat ALeftLT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftLT.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLT.setWrap(true);	
	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();	
		
	if (V_STATUS.equals("UNUSED"))
	{
		sql = " SELECT tsid.INVOICE_SEQ"+
			  ",tsid.INVOICE_YEAR"+
			  ",to_char(tsid.INVOICE_DATE,'yyyy/mm/dd') INVOICE_DATE"+
			  ",tsid.INVOICE_NUMBER"+
			  ",tsid.SALES_GROUP as SALES_GROUP"+
			  ",tsid.SHIPPING_MARKS as SHIPPING_MARKS"+
			  ",tsid.SHIPPING_METHOD as SHIPPING_METHOD"+
			  ",tsid.CURRENCY_CODE as CURRENCY_CODE"+
			  ",tsid.ORDER_TYPE as ORDER_LIST"+
			  ",tsid.SOURCE_REFERENCE_NO as SOURCE_NO_LIST"+
			  ",to_char(tsid.CREATION_DATE,'yyyy/mm/dd') CREATION_DATE"+
			  ",tsid.CREATED_BY"+
			  ",to_char(tsid.LAST_UPDATE_DATE ,'yyyy/mm/dd') as LAST_UPDATE_DATE"+
			  ",tsid.LAST_UPDATED_BY as LAST_UPDATED_BY"+
			  ",tsid.REMARKS"+
			  ",row_number() over (partition by tsid.invoice_year order by tsid.invoice_seq) row_seq"+
			  ",null SHIPPINGMARK"+
			  ",null pickup_date"+
			  " from oraddman.tsc_shipping_invoice_detail tsid"+	
			  " where tsid.INVOICE_YEAR="+INVOICE_YEAR+""+
			  " and tsid.INVOICE_NUMBER is null";
	}
	else
	{
		sql = " SELECT tsid.INVOICE_SEQ"+
			  ",tsid.INVOICE_YEAR"+
			  ",to_char(tsid.INVOICE_DATE,'yyyymmdd') INVOICE_DATE"+
			  //",tsid.INVOICE_NUMBER"+
			  ",NVL(ship.INVOICE_NO,tsid.INVOICE_NUMBER) INVOICE_NUMBER"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN ship.SALES_GROUP ELSE tsid.SALES_GROUP END SALES_GROUP"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN y.SHIPPING_MARKS_list ELSE tsid.SHIPPING_MARKS END SHIPPING_MARKS"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN ship.SHIPPING_METHOD_CODE ELSE tsid.SHIPPING_METHOD END SHIPPING_METHOD"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN ship.CURRENCY_CODE ELSE tsid.CURRENCY_CODE END CURRENCY_CODE"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN ship.ORDER_NUMBER_LIST ELSE tsid.ORDER_TYPE END ORDER_LIST"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN nvl(ship.SOURCE_NO_LIST,tsid.SOURCE_REFERENCE_NO) ELSE tsid.SOURCE_REFERENCE_NO END  SOURCE_NO_LIST"+
			  ",to_char(tsid.CREATION_DATE,'yyyymmdd') CREATION_DATE"+
			  ",tsid.CREATED_BY"+
			  //",to_char(CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN ship.LAST_UPDATE_DATE ELSE tsid.LAST_UPDATE_DATE END,'yyyymmdd') LAST_UPDATE_DATE"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN ship.LAST_UPDATE_BY ELSE tsid.LAST_UPDATED_BY END LAST_UPDATED_BY"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN NVL(ship.remarks,tsid.REMARKS) else tsid.REMARKS end REMARKS"+
			  ",row_number() over (partition by tsid.invoice_year order by tsid.invoice_seq) row_seq"+
			  ",to_char(ship.pickup_date,'yyyymmdd') pickup_date"+
			  ",case when ship.SALES_GROUP='TSCE' and ship.SHIPPING_METHOD_CODE in ('AIR(C)','SEA(C)') then TSC_SHIPPING_INVOICE_PKG.GET_INVOICE_SHIPPING_MARKS(NVL(ship.INVOICE_NO,tsid.INVOICE_NUMBER)) else '' end as SHIPPINGMARK"+ //add by Peggy 20211201
			  " FROM oraddman.tsc_shipping_invoice_detail tsid"+
			  " ,(SELECT DISTINCT new_dn.*,substr(new_dn.invoice_no,1,9) invoice_seq "+
			  "   FROM (SELECT distinct dn.invoice_no,dn.sales_group,dn.shipping_method_code,dn.currency_code"+
			  //"         ,listagg(dn.shipping_marks,'/') within group(order by dn.shipping_marks) over (partition by dn.invoice_no) shipping_marks"+
			  "         ,listagg(dn.order_number,'/') within group(order by dn.order_number) over (partition by dn.invoice_no) order_number_list"+
			  "         ,listagg(dn.source_no,'/') within group(order by dn.source_no) over (partition by dn.invoice_no) source_no_list"+
			  "         ,listagg(dn.erp_dn_name,'/') within group(order by dn.erp_dn_name) over (partition by dn.invoice_no) erp_dn_name_list"+
			  //"         ,dn.last_update_date"+
			  "         ,dn.last_update_by"+
			  "         ,dn.pickup_date"+
			  "         ,'' remarks"+
			  "          FROM (SELECT DISTINCT  dn_t.invoice_no,"+
              "                 dn_t.sales_group,"+
              "                 dn_t.shipping_method_code,"+
              "                 dn_t.currency_code,"+
              "                 dn_t.order_number,"+
              "                 listagg (dn_t.source_no, '/')   WITHIN GROUP (ORDER BY dn_t.source_no) OVER (PARTITION BY dn_t.invoice_no) source_no,"+
              "                 listagg(dn_t.erp_dn_name,'/') within group (order by dn_t.erp_dn_name) OVER (PARTITION BY dn_t.invoice_no) erp_dn_name,"+
              "                 dn_t.last_update_by,"+
              "                 dn_t.pickup_date"+
			  "          		FROM (SELECT distinct dn_d.invoice_no,dn_d.sales_group,dn_d.shipping_method_code,dn_d.currency_code"+
			  "                		,listagg(dn_d.order_number,'/') within group(order by dn_d.order_number) over (partition by dn_d.invoice_no) order_number"+
			  "                		,dn_d.source_no"+
			  "                		,dn_d.erp_dn_name"+
			  //"                	,dn_d.last_update_date"+
			  "                		,dn_d.last_update_by"+
			  "                		,dn_d.pickup_date"+
			  //"        				FROM (SELECT distinct trunc(tih.pickup_date) pickup_date, til.invoice_no,Tsc_Intercompany_Pkg.get_sales_group(til.order_header_id) SALES_GROUP"+
			  "        				FROM (SELECT distinct trunc(tih.pickup_date) pickup_date, til.invoice_no,TSC_OM_Get_Sales_Group(til.order_header_id) SALES_GROUP"+  //modify by Peggy 20220531
			  "                      	 ,tsc_get_remark_desc(til.order_header_id,'SHIPPING MARKS') SHIPPING_MARKS,tih.shipping_method_code,tih.currency_code"+
			  "                      	 ,til.order_number"+
			  //"                       	,til.bvi_invoice_no source_no"+
			  "                         ,til.bvi_invoice_no||case when instr(til.bvi_invoice_no,'SGT-')>0 THEN '('|| (select DISTINCT ADVISE_NO from TSC.TSC_ADVISE_DN_HEADER_INT y WHERE y.STATUS='S' AND y.INVOICE_NO=til.bvi_invoice_no)||')' ELSE '' END as source_no"+ //modify by Peggy 20230615
			  "                       	,til.ship_transaction_name erp_dn_name"+
			  //"                       ,tih.creation_date last_update_date"+
			  "                       	,tih.created_by last_update_by"+
			  "                        	FROM tsc_invoice_lines til"+
			  "                        	,tsc_invoice_headers tih"+
			  "                        	WHERE  til.invoice_no=tih.invoice_no"+
			  "                        	and til.invoice_no LIKE 'T-"+INVOICE_YEAR.substring(2)+"%'"+
			  "                        	and til.order_header_id is not null"+
			  "                         ?01"+
			  "                        	and not exists (select wnd.name from wsh.wsh_new_deliveries wnd where wnd.name like 'T-%' and case when substr(til.ship_transaction_name,1,2)<>'T-' then til.invoice_no else til.ship_transaction_name end =wnd.name)"+
			  "                       	) dn_d"+
			  "                      ) dn_t"+
			  "                  ) dn"+
			  "          UNION ALL"+
			  "          SELECT distinct dn.invoice_no,dn.sales_group,dn.shipping_method_code,dn.currency_code"+
			  "               ,listagg(dn.order_number,'/') within group(order by dn.order_number) over (partition by dn.invoice_no) order_number_list"+
			  "               ,dn.source_no source_no_list"+
			  "               ,dn.erp_dn_no erp_dn_name_list"+
			  //"               ,dn.last_update_date"+
			  "               ,dn.last_update_by"+
			  "               ,dn.pickup_date"+
			  "               ,dn.remarks ||"+
			  "               (SELECT NVL(E.vendor_name_alt,E.vendor_name)||'直出' AS VENDOR_DIRECT_DELIVERY"+
              "                FROM inv.mtl_material_transactions A,inv.mtl_transaction_lot_numbers B,po.rcv_transactions C,PO_HEADERS_ALL D,AP_SUPPLIERS E"+
              "                     ,tsc.tsc_pick_confirm_lines F,tsc.tsc_pick_confirm_headers G"+
              "                WHERE A.ORGANIZATION_ID=49"+
              "                AND A.TRANSACTION_ID=B.TRANSACTION_ID"+
              "                AND A.TRANSACTION_TYPE_ID=18"+
              "                AND B.LOT_NUMBER=F.LOT"+
              "                AND B.PRIMARY_QUANTITY>0"+
              "                AND F.ADVISE_HEADER_ID=G.ADVISE_HEADER_ID"+
              "                AND G.ADVISE_NO=dn.source_no"+
              "                AND G.file_id IS NOT NULL"+
              "                AND F.PRODUCT_GROUP='PMD'"+
              "                AND A.rcv_transaction_id=C.transaction_id"+
              "                AND C.po_header_id=D.po_header_id"+
              "                AND D.vendor_id=E.vendor_id"+
              "                AND ROWNUM=1) AS remarks"+
			  //"               FROM (SELECT distinct trunc(tih.pickup_date) pickup_date, til.invoice_no,Tsc_Intercompany_Pkg.get_sales_group(til.order_header_id) SALES_GROUP,"+
			  "               FROM (SELECT distinct trunc(tih.pickup_date) pickup_date, til.invoice_no,TSC_OM_Get_Sales_Group(til.order_header_id) SALES_GROUP,"+  //modify by Peggy 20220531
			  "                    tsc_get_remark_desc(til.order_header_id,'SHIPPING MARKS') SHIPPING_MARKS,tih.shipping_method_code,tih.currency_code,"+
			  "                    til.order_number"+
			  //"                    ,x.advise_no source_no"+
              "                    ,(select advise_no from tsc.tsc_advise_dn_header_int y where y.status='S' and substr(y.invoice_no,1,9)= substr(til.ship_transaction_name,1,9))  source_no "+
			  "                    ,x.delivery_name erp_dn_no"+
			  //"                    ,tih.creation_date last_update_date"+
			  "                    ,tih.created_by last_update_by"+
              "                    ,case when substr(til.order_number,1,4)=1181 then case when instr(RELEASE,'內銷')>0 THEN '內銷'  when instr(RELEASE,'外銷')>0 THEN '外銷' ELSE '' END ELSE '' END REMARKS"+
			  "                    FROM tsc_invoice_lines til"+
			  "                    ,tsc_invoice_headers tih"+
			  //"                    ,(select tadli.invoice_no,tadli.advise_no,listagg(tadli.delivery_name,'/') within group(order by tadli.delivery_name) over (partition by tadli.invoice_no,tadli.advise_no) delivery_name from (select distinct a.invoice_no,a.advise_no,b.delivery_name from tsc.tsc_advise_dn_line_int b,tsc.tsc_advise_dn_header_int a where a.status='S' and a.interface_header_id=b.interface_header_id AND a.advise_header_id=b.advise_header_id) tadli) x  "+
              "                    ,(select substr(wnd.name,1,9) invoice_no,listagg(wnd.name,'/') within group (order by wnd.name) over (partition by substr(wnd.name,1,9)) delivery_name  from wsh.wsh_new_deliveries wnd where wnd.name like 'T-%') x"+
			  "                    WHERE  til.invoice_no=tih.invoice_no"+
			  "                    AND til.invoice_no LIKE 'T-"+INVOICE_YEAR.substring(2)+"%'"+
			  "                    AND til.ship_transaction_name LIKE 'T-%'"+
			  "                    and til.order_header_id is not null"+
			  "                    ?01"+
			  "                    and substr(til.ship_transaction_name,1,9)=x.invoice_no"+
			  "                 ) dn"+
			  "          ) new_dn"+
			  "      ) ship"+
			  "    ,(select distinct x.invoice_no,substr(x.invoice_no,1,9) invoice_seq, listagg(x.SHIPPING_MARKS,'/') within group(order by x.SHIPPING_MARKS) over (partition by x.invoice_no) SHIPPING_MARKS_list from (select  distinct til.invoice_no,tsc_get_remark_desc(til.order_header_id,'SHIPPING MARKS') SHIPPING_MARKS  from tsc_invoice_lines til where til.invoice_no LIKE 'T-"+INVOICE_YEAR.substring(2)+"%') x) y"+
			  //" WHERE tsid.invoice_number=ship.invoice_no(+)";
			  " WHERE tsid.invoice_seq=ship.invoice_seq(+)"+
			  " and tsid.invoice_seq=y.invoice_seq(+)";
		if (V_STATUS.equals("USED"))
		{
			sql += " and tsid.INVOICE_NUMBER is not null";
		} 
		if (!INVOICE_YEAR.equals(""))
		{
			sql += " and tsid.INVOICE_YEAR="+INVOICE_YEAR+"";
		}
		if (!INVOICE_MONTH.equals(""))
		{
			//sql += " and TO_NUMBER(TO_CHAR(tsid.INVOICE_DATE,'MM'))="+INVOICE_MONTH+"";
			sql += " and TO_NUMBER(TO_CHAR(nvl(pickup_date,tsid.INVOICE_DATE),'MM'))="+INVOICE_MONTH+"";
		}				
		if (!INVOICEDATE.equals("") || !INVOICEDATEEND.equals(""))
		{
			//sql += " and tsid.INVOICE_DATE between TO_DATE('"+INVOICEDATE+"','YYYYMMDD') and TO_DATE('"+INVOICEDATE+"','YYYYMMDD')+0.99999 ";
			//sql = sql.replace("?01"," and exists (select 1 from oraddman.tsc_shipping_invoice_detail tsd where tsd.INVOICE_YEAR="+INVOICE_YEAR+" and tsd.INVOICE_DATE between TO_DATE('"+INVOICEDATE+"','YYYYMMDD') and TO_DATE('"+INVOICEDATE+"','YYYYMMDD')+0.99999 and tsd.invoice_seq=substr(til.invoice_no,1,9)) ");
			sql += " and nvl(pickup_date,tsid.INVOICE_DATE) between TO_DATE('"+INVOICEDATE+"','YYYYMMDD') and TO_DATE('"+INVOICEDATEEND+"','YYYYMMDD')+0.99999 ";
			sql = sql.replace("?01"," and exists (select 1 from oraddman.tsc_shipping_invoice_detail tsd where tsd.INVOICE_YEAR="+INVOICE_YEAR+" and tsd.invoice_seq=substr(til.invoice_no,1,9)) ");
			
		}	
		else
		{
			sql = sql.replace("?01","");
		}	  
		if (!INVOICE_NO.equals(""))
		{
			String [] sArray = INVOICE_NO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and ('"+sArray[x].trim().toUpperCase()+"' like tsid.INVOICE_SEQ||'%'";
				}
				else
				{
					sql += " or '"+sArray[x].trim().toUpperCase()+"' like tsid.INVOICE_SEQ||'%'";
				}
				if (x==sArray.length -1) sql += ")";
			}	
		}
		if (!SALES_GROUP.equals(""))
		{
			String [] sArray = SALES_GROUP.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and (CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN ship.SALES_GROUP ELSE tsid.SALES_GROUP END like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				else
				{
					sql += " or CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN ship.SALES_GROUP ELSE tsid.SALES_GROUP END like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				if (x==sArray.length -1) sql += ")";
			}	
		}	
		if (!SHIPPING_MARKS.equals(""))
		{
			String [] sArray = SHIPPING_MARKS.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and (CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN y.SHIPPING_MARKS ELSE tsid.SHIPPING_MARKS END like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				else
				{
					sql += " or CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN y.SHIPPING_MARKS ELSE tsid.SHIPPING_MARKS END like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				if (x==sArray.length -1) sql += ")";
			}	
		}	
		if (!SHIPPING_METHOD.equals(""))
		{
			String [] sArray = SHIPPING_METHOD.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN ship.SHIPPING_METHOD_CODE ELSE tsid.SHIPPING_METHOD END in ('"+sArray[x].trim().toUpperCase()+"'";
				}
				else
				{
					sql += " ,'"+sArray[x].trim().toUpperCase()+"'";
				}
				if (x==sArray.length -1) sql += ")";
			}	
		}	
		if (!MO_NO.equals(""))
		{
			String [] sArray = MO_NO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and (ship.ORDER_NUMBER_LIST like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				else
				{
					sql += " or ship.ORDER_NUMBER_LIST like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				if (x==sArray.length -1) sql += ")";
			}
		}
		if (!SOURCE_NO.equals(""))
		{
			String [] sArray = SOURCE_NO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				//if (x==0)
				//{
				//	sql += " and SHIP.SOURCE_NO_LIST in ('"+sArray[x].trim().toUpperCase()+"'";
				//}
				//else
				//{
				//	sql += " ,'"+sArray[x].trim().toUpperCase()+"'";
				//}
				if (x==0)
				{
					sql += " and (SHIP.SOURCE_NO_LIST like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				else
				{
					sql += " or SHIP.SOURCE_NO_LIST like '%"+sArray[x].trim().toUpperCase()+"%'";
				}				
				if (x==sArray.length -1) sql += ")";
			}	
		}
	}
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

			//年度
			ws.addCell(new jxl.write.Label(col, row, "年度" , ACenterBLB));
			ws.setColumnView(col,8);
			col++;	
			
			//發票序號
			ws.addCell(new jxl.write.Label(col, row, "發票序號" , ACenterBLB));
			ws.setColumnView(col,12);
			col++;	

			//取號日期
			ws.addCell(new jxl.write.Label(col, row, "取號日期" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//發票日期
			ws.addCell(new jxl.write.Label(col, row, "發票日期" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
						
			//發票號碼
			ws.addCell(new jxl.write.Label(col, row, "發票號碼" , ACenterBLB));
			ws.setColumnView(col,18);	
			col++;	
			
			//備註
			ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//來源單據號碼
			ws.addCell(new jxl.write.Label(col, row, "來源單據號碼" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
						
			//業務區
			ws.addCell(new jxl.write.Label(col, row, "業務區" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//客戶
			ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Shipping Marks
			ws.addCell(new jxl.write.Label(col, row, "Shipping Marks" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//出貨方式
			ws.addCell(new jxl.write.Label(col, row, "出貨方式" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//幣別
			ws.addCell(new jxl.write.Label(col, row, "幣別" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//訂單號碼
			ws.addCell(new jxl.write.Label(col, row, "訂單號碼" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			//最後更新者
			ws.addCell(new jxl.write.Label(col, row, "最後更新者" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			row++;
		}
		
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("INVOICE_YEAR") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("INVOICE_SEQ") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INVOICE_DATE")==null?"":rs.getString("INVOICE_DATE")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("pickup_date")==null?"":rs.getString("pickup_date")) , ACenterL));
		col++;											
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INVOICE_NUMBER")==null?"":rs.getString("INVOICE_NUMBER")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("REMARKS")==null?"":rs.getString("REMARKS")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SOURCE_NO_LIST")==null?"":rs.getString("SOURCE_NO_LIST")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SALES_GROUP")==null?"":rs.getString("SALES_GROUP")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIPPING_MARKS")==null?"":rs.getString("SHIPPING_MARKS")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIPPINGMARK")==null?"":rs.getString("SHIPPINGMARK")) , ALeftLT));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("SHIPPING_METHOD")==null?"":rs.getString("SHIPPING_METHOD")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CURRENCY_CODE")==null?"":rs.getString("CURRENCY_CODE")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("ORDER_LIST")==null?"":rs.getString("ORDER_LIST")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("LAST_UPDATED_BY")==null?"":rs.getString("LAST_UPDATED_BY")) , ACenterL));
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
