<!--20180912 Peggy,新增"類別"欄位 -->
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
<FORM ACTION="../jsp/TSA01WIPWareHouseExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String dateStartType="";
String dateEndType="";
String YearFr=request.getParameter("YEARFR");
dateBean.setAdjDate(-7);
if (YearFr ==null) YearFr = dateBean.getYearString();
if (YearFr.equals("--")){YearFr ="";}else{dateStartType +="yyyy";}
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr ==null) MonthFr = dateBean.getMonthString();
if (MonthFr.equals("--")){MonthFr ="";}else{	dateStartType +="mm";}
String DayFr=request.getParameter("DAYFR");
if (DayFr == null) DayFr = dateBean.getDayString();
if (DayFr.equals("--")){DayFr ="";}else{dateStartType +="dd";}
String dateSetBegin=YearFr+MonthFr+DayFr;  
dateSetBegin.replace("--","");
dateBean.setAdjDate(7);
String YearTo=request.getParameter("YEARTO");
if (YearTo == null) YearTo = dateBean.getYearString();
if (YearTo.equals("--")){YearTo ="";}else{dateEndType +="yyyy";}
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo ==null) MonthTo = dateBean.getMonthString();
if (MonthTo.equals("--") ){MonthTo ="";}else{dateEndType +="mm";}
String DayTo=request.getParameter("DAYTO");
if (DayTo == null) DayTo = dateBean.getDayString();
if (DayTo.equals("--")){DayTo ="";}else{ dateEndType +="dd";}
String dateSetEnd = YearTo+MonthTo+DayTo;

String ERPdateStartType="";
String ERPdateEndType="";
String ERPYearFr=request.getParameter("ERPYEARFR");
if (ERPYearFr ==null) ERPYearFr = dateBean.getYearString();
if (ERPYearFr.equals("--"))
{
	ERPYearFr ="";
}
else
{
	ERPdateStartType +="yyyy";
}
String ERPMonthFr=request.getParameter("ERPMONTHFR");
if (ERPMonthFr ==null) ERPMonthFr = dateBean.getMonthString();
if (ERPMonthFr.equals("--"))
{
	ERPMonthFr ="";
}
else
{	
	ERPdateStartType +="mm";
}
String ERPDayFr=request.getParameter("ERPDAYFR");
if (ERPDayFr == null) ERPDayFr = dateBean.getDayString();
if (ERPDayFr.equals("--"))
{
	ERPDayFr ="";
}
else
{
	ERPdateStartType +="dd";
}
String ERPdateSetBegin=ERPYearFr+ERPMonthFr+ERPDayFr;  
ERPdateSetBegin.replace("--","");
//dateBean.setAdjDate(1);
String ERPYearTo=request.getParameter("ERPYEARTO");
if (ERPYearTo == null) ERPYearTo = dateBean.getYearString();
if (ERPYearTo.equals("--"))
{
	ERPYearTo ="";
}
else
{
	ERPdateEndType +="yyyy";
}
String ERPMonthTo=request.getParameter("ERPMONTHTO");
if (ERPMonthTo ==null) ERPMonthTo = dateBean.getMonthString();
if (ERPMonthTo.equals("--"))
{
	ERPMonthTo ="";
}
else
{
	ERPdateEndType +="mm";
}
String ERPDayTo=request.getParameter("ERPDAYTO");
if (ERPDayTo == null) ERPDayTo = dateBean.getDayString();
if (ERPDayTo.equals("--"))
{
	ERPDayTo ="";
}
else
{ 
	ERPdateEndType +="dd";
}
String ERPdateSetEnd = ERPYearTo+ERPMonthTo+ERPDayTo; 

 
String TRANS_TYPE=request.getParameter("TRANS_TYPE");
if (TRANS_TYPE==null) TRANS_TYPE="";
String WIP_NO=request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String ITEM_NAME=request.getParameter("ITEM_NAME");
if (ITEM_NAME==null) ITEM_NAME="";
String REQUEST_NO=request.getParameter("REQUEST_NO");
if (REQUEST_NO==null) REQUEST_NO="";
String PICK_NO=request.getParameter("PICK_NO");
if (PICK_NO==null) PICK_NO="";
String LOT=request.getParameter("LOT");
if (LOT==null) LOT="";
String COMP_TYPE=request.getParameter("COMP_TYPE");  //add by Peggy 20180912
if (COMP_TYPE==null) COMP_TYPE="";
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=9,colcnt=0;
try 
{ 	

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "A01_WIP_ISSUE_Report";
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
		
	sql = " SELECT A.REQUEST_NO"+
	      ",A.REQUEST_TYPE"+
		  ",E.TYPE_NAME REQUEST_TYPE_NAME"+
		  ",A.WIP_ENTITY_NAME"+
		  ",D.ORGANIZATION_CODE"+
		  ",A.ORGANIZATION_ID"+
		  ",A.ITEM_NAME"+
		  ",A.CREATED_BY"+
		  ",TO_CHAR(A.CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE"+
		  ",B.LINE_NO"+
		  ",B.COMP_TYPE_NO"+
		  ",F.COMP_TYPE_NAME"+
		  ",C.COMPONENT_NAME"+
		  ",G.DESCRIPTION ITEM_DESC"+
		  ",C.UOM"+
		  ",C.SUBINVENTORY_CODE"+
		  ",C.LOT_NUMBER"+
		  ",C.LOT_QTY"+
		  ",b.PICK_NO"+
		  ",TO_CHAR(C.EXPIRATION_DATE,'yyyy-mm-dd') EXPIRATION_DATE"+
		  ",B.INV_WORKED_BY"+
		  ",TO_CHAR(B.INV_WORK_DATE,'yyyy-mm-dd hh24:mi') INV_WORK_DATE"+
		  ",C.TRANSFER_SUBINVENTORY"+
		  ",row_number() over (partition by a.organization_id order by a.request_no desc) tot_cnt"+
		  ",H.REMARKS LOT_REMARKS"+
          " FROM ORADDMAN.TSA01_REQUEST_HEADERS_ALL A"+
		  ",ORADDMAN.TSA01_REQUEST_LINES_ALL B"+
		  ",ORADDMAN.TSA01_REQUEST_LINE_LOTS_ALL C"+
		  ",INV.MTL_PARAMETERS D"+
          ",(select * from oraddman.tsa01_base_setup where type_code='REQ_TYPE') E"+
		  ",ORADDMAN.TSA01_COMPONENT_TYPE F"+
		  ",INV.MTL_SYSTEM_ITEMS_B G"+
		  ",ORADDMAN.TSA01_REQUEST_WAFER_LOT_ALL H"+
          " WHERE A.REQUEST_NO=B.REQUEST_NO"+
          " AND B.REQUEST_NO=C.REQUEST_NO"+
          " AND B.LINE_NO=C.LINE_NO"+
          " AND A.ORGANIZATION_ID=D.ORGANIZATION_ID"+
          " AND A.REQUEST_TYPE=E.TYPE_VALUE"+
		  " AND B.ORGANIZATION_ID=G.ORGANIZATION_ID"+
		  " AND B.COMPONENT_ITEM_ID=G.INVENTORY_ITEM_ID"+
          " AND B.COMP_TYPE_NO=F.COMP_TYPE_NO"+
		  " AND C.REQUEST_NO=H.REQUEST_NO(+)"+
		  " AND C.LINE_NO=H.LINE_NO(+)"+
		  " AND C.COMPONENT_ITEM_ID=H.INVENTORY_ITEM_ID(+)"+
		  " AND C.LOT_NUMBER=H.LOT(+)"+
		  " AND C.LOT_QTY >0";
	if (TRANS_TYPE!=null && !TRANS_TYPE.equals("--") && !TRANS_TYPE.equals("")) sql += " and a.request_type='"+TRANS_TYPE+"'";
	if (COMP_TYPE!=null && !COMP_TYPE.equals("--") && !COMP_TYPE.equals("")) sql += " and b.comp_type_no='"+COMP_TYPE+"'"; //add by Peggy 20180912
	if (WIP_NO!=null && !WIP_NO.equals("")) sql += " and UPPER(a.wip_entity_name) like '"+ WIP_NO.toUpperCase()+"%'";
	if (REQUEST_NO!=null && !REQUEST_NO.equals("")) sql += " and a.REQUEST_NO LIKE '"+REQUEST_NO+"%'";
	if (PICK_NO!=null && !PICK_NO.equals("")) sql += " and b.PICK_NO='"+ PICK_NO+"'";
	if (LOT!=null && !LOT.equals("")) sql += " and c.LOT_NUMBER='"+ LOT+"'";
	if (ITEM_NAME!=null && !ITEM_NAME.equals("")) sql += " and (a.ITEM_NAME like '"+ ITEM_NAME +"%' or  b.COMPONENT_NAME like '"+ITEM_NAME +"%')";
	if (dateSetBegin!=null && !dateSetBegin.equals("")) sql += " and a.creation_date >=to_date('"+dateSetBegin+"','"+dateStartType+"')";
	if (dateSetEnd!=null && !dateSetEnd.equals("")) sql += " and a.creation_date <= to_date('"+dateSetEnd+"','"+dateEndType+"')+0.99999";
	if (ERPdateSetBegin!=null && !ERPdateSetBegin.equals("")) sql += " and B.INV_WORK_DATE >=to_date('"+ERPdateSetBegin+"','"+ERPdateStartType+"')";
	if (ERPdateSetEnd!=null && !ERPdateSetEnd.equals("")) sql += " and B.INV_WORK_DATE <= to_date('"+ERPdateSetEnd+"','"+ERPdateEndType+"')+0.99999";
	sql += " ORDER BY A.WIP_ENTITY_NAME,A.REQUEST_NO,B.LINE_NO";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	String destination="";
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//領料單號
			ws.addCell(new jxl.write.Label(col, row, "領料單號" , ACenterBLB));
			ws.setColumnView(col,15);
			col++;	

			//交易類型
			ws.addCell(new jxl.write.Label(col, row, "交易類型" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
			
			//工單號碼
			ws.addCell(new jxl.write.Label(col, row, "工單號碼" , ACenterBLB));
			ws.setColumnView(col,16);	
			col++;	
						
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//類別
			ws.addCell(new jxl.write.Label(col, row, "類別" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//原物料料號
			ws.addCell(new jxl.write.Label(col, row, "原物料料號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//原物料品名
			ws.addCell(new jxl.write.Label(col, row, "原物料品名" , ACenterBLB));
			ws.setColumnView(col,35);	
			col++;	

			//組織
			ws.addCell(new jxl.write.Label(col, row, "組織" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//倉庫名稱
			ws.addCell(new jxl.write.Label(col, row, "來源庫房" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//倉庫名稱
			ws.addCell(new jxl.write.Label(col, row, "目的庫房" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//LOT
			ws.addCell(new jxl.write.Label(col, row, "LOT" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//LOT備註
			ws.addCell(new jxl.write.Label(col, row, "LOT備註" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//數量
			ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	
			
			//單位
			ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
					
			//有效日
			ws.addCell(new jxl.write.Label(col, row, "有效日" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
				
			//申請人
			ws.addCell(new jxl.write.Label(col, row, "申請人" , ACenterBLB));
			ws.setColumnView(col,16);	
			col++;	

			//申請日期
			ws.addCell(new jxl.write.Label(col, row, "申請日期" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//撿貨單號
			ws.addCell(new jxl.write.Label(col, row, "撿貨單號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
				
			//倉庫人員
			ws.addCell(new jxl.write.Label(col, row, "倉庫人員" , ACenterBLB));
			ws.setColumnView(col,16);	
			col++;	

			//ERP交易日
			ws.addCell(new jxl.write.Label(col, row, "ERP交易日" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_NO") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_TYPE_NAME"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("WIP_ENTITY_NAME"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NAME"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("COMP_TYPE_NAME") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("COMPONENT_NAME") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ORGANIZATION_CODE") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("SUBINVENTORY_CODE") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TRANSFER_SUBINVENTORY") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_NUMBER") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("LOT_REMARKS")==null?"":rs.getString("LOT_REMARKS")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("LOT_QTY")).doubleValue() , ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("EXPIRATION_DATE") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATED_BY") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATION_DATE") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PICK_NO")==null?"":rs.getString("PICK_NO")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INV_WORKED_BY")==null?"":rs.getString("INV_WORKED_BY")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("INV_WORK_DATE")==null?"":rs.getString("INV_WORK_DATE")) , ACenterL));
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
