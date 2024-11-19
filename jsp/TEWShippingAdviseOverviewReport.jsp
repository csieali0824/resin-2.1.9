<!-- modify by Peggy 20150703,新增TEW_RCV_PKG.GET_SO_DESTINATION取代JSP 取訂單目的地的code-->
<!--20180620 Peggy,add TSC_PARTNO欄位取代attribute1-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TEWStockOverviewReport.jsp" METHOD="post" name="MYFORM">
<%
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",where="",destination="",adviseNo="",carton_list="";
int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	//String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	//PreparedStatement pstmt1=con.prepareStatement(sql1);
	//pstmt1.executeUpdate(); 
	//pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TewShippingAdviseOverView";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setVerticalFreeze(2);  //凍結窗格	
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(font_bold);   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	

	//英文內文水平垂直置左-格線-底色黃
	WritableCellFormat LeftBLY = new WritableCellFormat(font_bold);   
	LeftBLY.setAlignment(jxl.format.Alignment.LEFT);
	LeftBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	LeftBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	LeftBLY.setBackground(jxl.write.Colour.YELLOW); 
	LeftBLY.setWrap(true);	

	
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(font_nobold);   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(font_nobold);   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(font_nobold);   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
	
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
					
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();

	sql = " select x.* "+
	      ",tew_rcv_pkg.GET_SO_DESTINATION(x.advise_no,x.so_no) destination"+ //add by Peggy 20150703
	      " from (select a.ADVISE_NO"+
		  "             ,d.customer_number"+
		  "             ,a.REGION_CODE"+
		  "             ,a.customer_name"+
		  "             ,a.SHIPPING_REMARK"+
		  "             ,A.SO_NO"+
		  "             ,a.SO_LINE_NUMBER"+
		  "             ,a.item_no"+
		  "             ,a.item_desc"+
		  "             ,decode(c.item_identifier_type,'CUST',c.ordered_item,'') CUST_ITEM"+
		  "             ,a.pc_confirm_qty/1000 pc_confirm_qty"+
		  "             ,to_char(a.pc_schedule_ship_date,'yyyymmdd') pc_schedule_ship_date"+
		  "             ,a.SHIPPING_METHOD"+
          "             ,A.CUST_LABEL_GROUP"+
          "             ,tsc_om_category(a.inventory_item_id,49,'TSC_PROD_TYPE') TSC_PROD_TYPE"+
          "             ,a.tsc_package"+
		  "             ,A.TSC_PACKING_CODE"+
          "             ,a.CARTON_NUM CARTON_NUM "+
          "             ,ceil(a.pc_confirm_qty/e.CARTON_QTY) SYS_CARTON_NUM "+
          "             ,e.CARTON_QTY/1000 CARTON_QTY	"+
          "             ,A.vendor_site_code"+
		  "             ,a.so_header_id"+
		  "             ,a.to_tw"+
		  "             ,TEW_RCV_PKG.GET_ORDER_CARTON_LIST('ORDER_LINE',A.ADVISE_NO,A.SO_LINE_ID,NULL,NULL) CARTON_LIST"+
          "             ,row_number() over(partition by a.so_line_id,a.PC_ADVISE_ID,e.TSC_PACKAGE,e.PACKING_CODE,e.VENDOR_ID order by CASE WHEN e.TSC_PARTNO IS NOT NULL AND e.TSC_PARTNO=A.ITEM_DESC THEN 1 WHEN e.TSC_PARTNO IS NOT NULL AND e.TSC_PARTNO<>A.ITEM_DESC THEN 3 ELSE 2 END ) rec_seq "+
          "      from (select x.*"+
		  "            ,y.vendor_id"+
		  "            ,y.vendor_site_code"+
		  "            ,TSC_GET_ITEM_PACKING_CODE(49,X.INVENTORY_ITEM_ID) TSC_PACKING_CODE"+
		  "            ,tsc_label_pkg.TSC_GET_CUST_LABEL_GROUP(X.so_line_id) CUST_LABEL_GROUP"+
          //"            ,(SELECT SUM(CARTON_QTY) FROM tsc_shipping_advise_lines b WHERE x.pc_advise_id=b.pc_advise_id ) CARTON_NUM "+
		  "            ,(SELECT SUM(round(b.CARTON_QTY*b.TOTAL_QTY/(select sum(c.TOTAL_QTY) from tsc.tsc_shipping_advise_lines c where c.tew_advise_no=b.tew_advise_no and c.carton_num_fr =b.carton_num_fr and c.carton_num_to=b.carton_num_to),1))   FROM tsc.tsc_shipping_advise_lines b WHERE x.pc_advise_id=b.pc_advise_id) CARTON_NUM "+
		  "            FROM tsc_shipping_advise_pc_tew x"+
		  "                 ,ap.ap_supplier_sites_all y "+
		  "            where x.advise_no is not null "+
		  "            and x.vendor_site_id=y.vendor_site_id "+
		  "            and x.pc_schedule_ship_date between to_date('"+SDATE+"','yyyymmdd') and to_date('"+EDATE+"','yyyymmdd')+0.99999) a"+
          "      ,ONT.OE_ORDER_LINES_ALL c"+
          "      ,ar_customers d "+
          " ,(select * from tsc_item_packing_master where INT_TYPE ='TEW' and STATUS='Y') e"+
          " where a.customer_id=d.customer_id"+
          " and a.so_line_id = c.line_id"+
          " and a.TSC_PACKAGE=e.TSC_PACKAGE(+)"+
          " and TSC_PACKING_CODE =e.PACKING_CODE(+)"+
          " AND a.VENDOR_ID=e.VENDOR_ID(+)) x "+
 		  " where rec_seq =1"+
          " order by x.advise_no,x.CARTON_LIST,x.SO_NO,x.SO_LINE_NUMBER";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//資料日期
			ws.mergeCells(col, row, col+2, row);     
			ws.addCell(new jxl.write.Label(col, row, "PC排定出貨日期:" +SDATE+"~"+EDATE, LeftBLY));
			row++;
						
			//Advise NO
			ws.addCell(new jxl.write.Label(col, row, "ADVISE NO" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//業務區
			ws.addCell(new jxl.write.Label(col, row, "業務區" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
						
			//客戶
			ws.addCell(new jxl.write.Label(col, row, "客戶" , ACenterBLB));
			ws.setColumnView(col,50);	
			col++;
			
			//嘜頭
			ws.addCell(new jxl.write.Label(col, row, "嘜頭" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;

			//訂單號碼
			ws.addCell(new jxl.write.Label(col, row, "訂單號碼" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//訂單項次
			ws.addCell(new jxl.write.Label(col, row, "訂單項次" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;
			
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,24);	
			col++;	
						
			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//客戶品號
			ws.addCell(new jxl.write.Label(col, row, "客戶品號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	
			
			//出貨數量
			ws.addCell(new jxl.write.Label(col, row, "出貨數量(K)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//目的地
			ws.addCell(new jxl.write.Label(col, row, "目的地" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;					

			//排定出貨日
			ws.addCell(new jxl.write.Label(col, row, "排定出貨日" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//出貨方式
			ws.addCell(new jxl.write.Label(col, row, "出貨方式" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//系統預估箱數
			ws.addCell(new jxl.write.Label(col, row, "系統預估箱數" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;			
			
			//進出口編箱數
			ws.addCell(new jxl.write.Label(col, row, "進出口編箱數" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;			
			
			//單箱數量(K)
			ws.addCell(new jxl.write.Label(col, row, "單箱數量(K)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
						
			//客戶標籤
			ws.addCell(new jxl.write.Label(col, row, "客戶標籤" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//供應商
			ws.addCell(new jxl.write.Label(col, row, "供應商" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//TSC_PROD_TYPE
			ws.addCell(new jxl.write.Label(col, row, "TSC PROD TYPE" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//TSC_PACKAGE
			ws.addCell(new jxl.write.Label(col, row, "TSC PACKAGE" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			row++;

					
		}
		col=0;
		destination=rs.getString("destination");
		//modify by Peggy 20150703,call TEW_RCV_PKG.GET_SO_DESTINATION取目的地
		//if (rs.getString("so_no") != null)
		//{
		//	if (rs.getString("to_tw").equals("N"))
		//	{
		//		sql = " SELECT  FDLT.LONG_TEXT  FROM FND_ATTACHED_DOCS_FORM_VL FADFV, FND_DOCUMENTS_LONG_TEXT FDLT"+
		//			  " WHERE FADFV.FUNCTION_NAME = 'OEXOEORD' AND FADFV.CATEGORY_DESCRIPTION = 'SHIPPING MARKS' AND FADFV.PK1_VALUE = to_char(?) AND FADFV.MEDIA_ID = FDLT.MEDIA_ID  AND fadfv.USER_ENTITY_NAME = 'OM Order Header'";  
		//		//out.println(sql);
		//		//out.println(rs.getString("so_header_id"));
		//		PreparedStatement statementp = con.prepareStatement(sql);
		//		statementp.setString(1,rs.getString("so_header_id"));
		//		ResultSet rsp=statementp.executeQuery();
		//		if  (rsp.next())
		//		{
		//			String splitStr[] = rsp.getString("LONG_TEXT").split("\n");	
		//			for (int k=0;k <splitStr.length;k++)
		//			{
		//				if (splitStr[k].indexOf("C/N")>=0 || splitStr[k].indexOf("C/O NO")>=0)
		//				{
		//					for (int m=k-1 ; m>=0 ; m--)
		//					{
		//						if (splitStr[m].equals("") || splitStr[m].indexOf("P/NO") >= 0 || splitStr[m].indexOf("P/N NO")>=0 || splitStr[m].indexOf("P/O NO")>=0) continue;
		//						destination = splitStr[m].replace("CHINA","");
		//						break;
		//					}
		//				}
		//			}			
		//		}
		//		rsp.close();
		//		statementp.close();
		//	}
		//	else if (rs.getString("so_no").startsWith("1121"))
		//	{
		//		destination="CKS AIRPORT";
		//	}
		//	else if (!rs.getString("so_no").startsWith("1121"))
		//	{
		//		destination="KEELUNG";
		//	}
		//}
				

		ws.addCell(new jxl.write.Label(col, row, rs.getString("ADVISE_NO"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REGION_CODE"),  ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, "("+rs.getString("CUSTOMER_NUMBER")+")"+rs.getString("CUSTOMER_NAME"),  ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_REMARK"),  ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_NO"),  ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SO_LINE_NUMBER"),  ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NO"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUST_ITEM") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("PC_CONFIRM_QTY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, destination , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PC_SCHEDULE_SHIP_DATE") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SHIPPING_METHOD") , ACenterL));
		col++;	
		if (rs.getString("SYS_CARTON_NUM")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SYS_CARTON_NUM")).doubleValue(), ARightL));
		}
		col++;	
		//if (rs.getString("CARTON_NUM")==null || (adviseNo.equals(rs.getString("ADVISE_NO")) &&  carton_list.equals(rs.getString("carton_list"))))
		if (rs.getString("CARTON_NUM")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("CARTON_NUM")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("CARTON_QTY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("CARTON_QTY")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_LABEL_GROUP")==null?"": rs.getString("CUST_LABEL_GROUP")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("vendor_site_code") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PROD_TYPE")==null?"": rs.getString("TSC_PROD_TYPE")), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC_PACKAGE")==null?"":rs.getString("TSC_PACKAGE")) , ALeftL));
		col++;	
		row++;
		adviseNo = rs.getString("ADVISE_NO");
		carton_list = rs.getString("CARTON_LIST");
		
		reccnt ++;
	}	
	wwb.write(); 
	wwb.close();

	rs.close();
	statement.close();

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
	String strURL = "/oradds/report/"+FileName; 
	response.sendRedirect(strURL);
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
