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
<FORM ACTION="../jsp/TSA01WIPWareHouseApproveExcel.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String REQUEST_NO = request.getParameter("REQUEST_NO");
if (REQUEST_NO==null) REQUEST_NO="";
String PICK_NO = request.getParameter("PICK_NO");
if (PICK_NO==null) PICK_NO="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String REQUEST_TYPE = request.getParameter("REQUEST_TYPE");
if (REQUEST_TYPE==null) REQUEST_TYPE="";
String WIP_NO = request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String COMPONENT_NAME = request.getParameter("COMPONENT_NAME");
if (COMPONENT_NAME==null) COMPONENT_NAME="";
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=9,colcnt=0;
try 
{ 	

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "A01_Component_Request_Rpt";
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
		
	sql = " SELECT a.request_no"+
	             ",a.request_type"+
				 ",a.organization_id"+
                 ",a.wip_entity_name"+
				 ",a.wip_entity_id"+
				 ",a.inventory_item_id"+
				 ",e.line_no"+
				 ",e.COMPONENT_NAME"+
				 ",e.REQUEST_QTY"+
				 ",f.COMP_TYPE_NAME"+
				 ",e.UOM"+
                 ",a.item_name"+
				 ",a.tsc_package"+
				 ",a.created_by"+
				 ",to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date"+
                 ",a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date"+
				 ",nvl(d.TYPE_VALUE ,a.status) status"+
				 ",a.version_id"+
				 ",c.TYPE_NAME"+
				 ",b.description item_desc"+
				 ",row_number() over (partition by a.organization_id order by a.request_no desc) tot_cnt"+
                 ",(select listagg(k.LOT ||CASE WHEN k.REMARKS IS NULL THEN '' ELSE '('||k.REMARKS||')' END ,'<br>') within group (order by k.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL k "+
				 " where e.request_no=k.request_no"+
                 " and e.line_no=k.line_no) lot_list"+
                 " FROM oraddman.tsa01_request_headers_all a"+
				 ",inv.mtl_system_items_b b"+
				 ",(select * from oraddman.tsa01_base_setup where TYPE_CODE='REQ_TYPE') c "+
				 ",(select TYPE_NAME,TYPE_VALUE  from oraddman.tsa01_base_setup where TYPE_CODE='REQ_STATUS') d"+
				 ",oraddman.TSA01_REQUEST_LINES_ALL e"+
				 ",oraddman.TSA01_COMPONENT_TYPE f"+
				 " where e.organization_id=b.organization_id "+
				 " and e.COMPONENT_item_id=b.inventory_item_id "+
				 " and a.request_no=e.request_no"+
				 " and e.COMP_TYPE_NO=f.COMP_TYPE_NO"+
				 " and a.REQUEST_TYPE=c.TYPE_VALUE(+)"+
				 " and a.status=d.TYPE_NAME(+)";
	if (!REQUEST_NO.equals(""))
	{
		sql += " and a.request_no='"+ REQUEST_NO+"'";
	}
	if (!WIP_NO.equals(""))
	{
		sql += " and upper(a.wip_entity_name) like '"+ WIP_NO.toUpperCase()+"%'";
	}
	if (!COMPONENT_NAME.equals("") && !COMPONENT_NAME.equals("--"))
	{
		sql += " and e.COMPONENT_NAME LIKE '"+ COMPONENT_NAME+"%'";
	}		
	sql += " and e.status=?"+
	       " order by a.wip_entity_name,a.request_no,e.line_no ";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"APPROVED");
	ResultSet rs=statement.executeQuery();
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

			//領用數量
			ws.addCell(new jxl.write.Label(col, row, "領用數量" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//單位
			ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBLB));
			ws.setColumnView(col,8);	
			col++;	

			//指定LOT
			ws.addCell(new jxl.write.Label(col, row, "指定LOT" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("REQUEST_NO") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TYPE_NAME"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("WIP_ENTITY_NAME"), ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("COMP_TYPE_NAME") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("COMPONENT_NAME") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESC") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("REQUEST_QTY")).doubleValue() , ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LOT_LIST") , ALeftL));
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
