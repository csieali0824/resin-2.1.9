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
<FORM ACTION="../jsp/TSCSGItemSafetyStockReqExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="";
String ITEM = request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String C_MONTH = request.getParameter("C_MONTH");
if (C_MONTH==null || C_MONTH.equals("--")) C_MONTH="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";

int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "SG_Safety_Stock_Request";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setVerticalFreeze(2);  //凍結窗格
	for (int g =1 ; g <=6 ;g++ )
	{
		sst.setHorizontalFreeze(g);
	}
	
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

	sql = " SELECT a.organization_code,a.c_month"+
          " ,(SELECT count(distinct job_id)+1 FROM ORADDMAN.TSSG_ITEM_SAFETY_STOCK_REQUEST x WHERE x.c_month=a.c_month and x.job_id<a.job_id ) req_times"+
          " ,a.item_desc, tsc_inv_category(a.inventory_item_id,43,1100000003) TSC_PROD_GROUP,a.safety_seq_id,"+
          " a.inventory_item_id, a.item_name,"+
          " a.suggest_safety_stock, a.safety_job_id, a.approve_item_id,"+
          " a.approve_item_name, a.approve_item_desc, a.approve_qty,"+
          " a.vendor_id, a.vendor_site_id, a.pr_no, a.po_no, a.status,"+
          " a.error_msg, to_char(a.creation_date,'yyyy-mm-dd') creation_date, a.created_by, to_char(a.approved_date,'yyyy-mm-dd') approved_date,"+
          " a.approved_by, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date , a.last_updated_by,B.VENDOR_SITE_CODE "+
		  " FROM ORADDMAN.TSSG_ITEM_SAFETY_STOCK_REQUEST A,AP.AP_SUPPLIER_SITES_ALL B"+
		  " WHERE A.VENDOR_SITE_ID=B.VENDOR_SITE_ID(+)";
	if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
	{
		sql += " AND A.ORGANIZATION_CODE='"+ORGCODE+"'";
	}
	if (!ITEM.equals(""))
	{
		sql += " AND (A.ITEM_NAME LIKE '"+ ITEM.toUpperCase()+"%' OR A.ITEM_DESC LIKE '"+ITEM.toUpperCase()+"%' OR A.APPROVE_ITEM_NAME LIKE '"+ ITEM.toUpperCase()+"%' OR A.APPROVE_ITEM_DESC LIKE '"+ITEM.toUpperCase()+"%')";
	}
	if (!C_MONTH.equals(""))
	{
		sql += " AND a.C_MONTH='"+C_MONTH +"'";
	}
	sql += " order by 1,2 desc,3 desc ,a.ITEM_DESC";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;

			//org code
			ws.addCell(new jxl.write.Label(col, row, "ORG CODE" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	
						
			//Calculate Month
			ws.addCell(new jxl.write.Label(col, row, "Month" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//Req Times
			ws.addCell(new jxl.write.Label(col, row, "Req Times" , ACenterBLB));
			ws.setColumnView(col,6);	
			col++;	
			
			//PROD GROUP
			ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//Item Name
			ws.addCell(new jxl.write.Label(col, row, "Item Name" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//Item Desc
			ws.addCell(new jxl.write.Label(col, row, "Item Desc" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Suggest Safety Stock(PCS)
			ws.addCell(new jxl.write.Label(col, row, "Suggest Safety Stock(PCS)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Approve Item Desc
			ws.addCell(new jxl.write.Label(col, row, "Approve Item Desc" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//Approve Qty
			ws.addCell(new jxl.write.Label(col, row, "Approve Qty(PCS)" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Vendor Site Code
			ws.addCell(new jxl.write.Label(col, row, "Vendor Site Code" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//PR
			ws.addCell(new jxl.write.Label(col, row, "PR" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//PO
			ws.addCell(new jxl.write.Label(col, row, "PR" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Creation Date
			ws.addCell(new jxl.write.Label(col, row, "Creation Date" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Created By
			ws.addCell(new jxl.write.Label(col, row, "Created By" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Approve Date
			ws.addCell(new jxl.write.Label(col, row, "Approve Date" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//Approved By
			ws.addCell(new jxl.write.Label(col, row, "Approved By" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			row++;
		}
		col=0;

		//org code
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORGANIZATION_CODE"), ACenterL));
		col++;	
		//Calculate Month
		ws.addCell(new jxl.write.Label(col, row, rs.getString("C_MONTH"), ACenterL));
		col++;	
		//req times
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REQ_TIMES"), ACenterL));
		col++;	
		//TSC Prod Group
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC_PROD_GROUP") , ALeftL));
		col++;	
		//Item Name
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME") , ALeftL));
		col++;	
		//Item Desc
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC"), ALeftL));
		col++;	
		//Suggest Safety Stock(PCS)			
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SUGGEST_SAFETY_STOCK")).doubleValue(), ARightL));
		col++;	
		//APPROVE_ITEM_DESC
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("APPROVE_ITEM_DESC")==null?"":rs.getString("APPROVE_ITEM_DESC")), ALeftL));
		col++;	
		//APPROVE_QTY	
		if (rs.getString("APPROVE_QTY")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("APPROVE_QTY")).doubleValue(), ARightL));
		}
		col++;	
		//VENDOR_SITE_CODE
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("VENDOR_SITE_CODE")==null?"":rs.getString("VENDOR_SITE_CODE")), ALeftL));
		col++;	
		//PR
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PR_NO")==null?"":rs.getString("PR_NO")), ACenterL));
		col++;	
		//PO
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PO_NO")==null?"":rs.getString("PO_NO")), ACenterL));
		col++;	
		//CREATION_DATE
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CREATION_DATE")==null?"":rs.getString("CREATION_DATE")), ACenterL));
		col++;	
		//CREATED_BY
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CREATED_BY")==null?"":rs.getString("CREATED_BY")), ALeftL));
		col++;	
		//APPROVED_DATE
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("APPROVED_DATE")==null?"":rs.getString("APPROVED_DATE")), ACenterL));
		col++;	
		//APPROVED_BY
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("APPROVED_BY")==null?"":rs.getString("APPROVED_BY")), ALeftL));
		col++;	
		
		row++;
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
