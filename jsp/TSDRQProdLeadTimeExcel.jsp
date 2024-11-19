<!-- 20151119 Peggy,add TSC_PROD_FAMILY column-->
<!-- 20160130 Peggy,add No Wafer Lead Time column-->
<!-- 20180802 Peggy,新增"停用/啟用"欄位-->
<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*,java.lang.Object.*" %>
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
<FORM ACTION="../jsp/TSDRQProdLeadTimeExcel.jsp" METHOD="post" name="MYFORM">
<%
String PLANT_CODE = request.getParameter("PLANT_CODE");
if (PLANT_CODE==null) PLANT_CODE="";
String TSC_PROD_GROUP = request.getParameter("TSC_PROD_GROUP");
if (TSC_PROD_GROUP==null) TSC_PROD_GROUP="";
String TSC_FAMILY = request.getParameter("TSC_FAMILY");
if (TSC_FAMILY==null) TSC_FAMILY="";
String TSC_PROD_FAMILY = request.getParameter("TSC_PROD_FAMILY");
if (TSC_PROD_FAMILY==null) TSC_PROD_FAMILY="";
String TSC_PACKAGE = request.getParameter("TSC_PACKAGE");
if (TSC_PACKAGE==null) TSC_PACKAGE="";
String ITEM_DESC = request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String FileName="",RPTName="",sql="",where="";
int fontsize=9,colcnt=0,row =0,col=0,reccnt=0;

try 
{ 	

	OutputStream os = null;	
	RPTName = "Lead_Time_List";
	FileName = RPTName+"("+UserName+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Tahoma"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBLB.setWrap(true);	
		
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Tahoma"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterL.setWrap(true);
	
	//英文內文水平垂直置中-正常-格線-紅  
	WritableCellFormat ACenterLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Tahoma"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
	ACenterLR.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLR.setWrap(true);	

	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Tahoma"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARightL.setAlignment(jxl.format.Alignment.RIGHT);
	ARightL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightL.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Tahoma"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
		
	sql = " SELECT a.seq_id,a.manufactory_no,b.MANUFACTORY_NO ||' '|| b.MANUFACTORY_NAME MANUFACTORY_NAME, a.tsc_prod_group, a.tsc_family,a.tsc_prod_family, a.tsc_package,a.tsc_desc, a.lead_time, a.lead_time_uom, a.created_by, a.creation_date, a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date"+
	      ",a.NO_WAFER_LEAD_TIME,a.s_voltage,a.e_voltage"+//add by Peggy 20160130
		  ",nvl(a.ACTIVE_FLAG,'I') ACTIVE_FLAG,REMARKS"+ //add by Peggy 20180802		  
          " FROM oraddman.tsprod_manufactory_leadtime a,oraddman.tsprod_manufactory b where a.manufactory_no=b.manufactory_no(+)";
	if (!PLANT_CODE.equals("") && !PLANT_CODE.equals("--"))
	{
	 	sql += " and a.manufactory_no='"+PLANT_CODE+"'";
	}
	if (!TSC_PROD_GROUP.equals("") && !TSC_PROD_GROUP.equals("--"))
	{
		sql += " and a.tsc_prod_group = '" + TSC_PROD_GROUP +"'";
	}
	if (!TSC_FAMILY.equals("") && !TSC_FAMILY.equals("--"))
	{
		sql += " and a.tsc_family ='"+ TSC_FAMILY+"'";
	}
	if (!TSC_PROD_FAMILY.equals("") && !TSC_PROD_FAMILY.equals("--"))
	{
		sql += " and a.tsc_prod_family ='"+ TSC_PROD_FAMILY+"'";
	}
	if (!TSC_PACKAGE.equals("") && !TSC_PACKAGE.equals("--"))
	{
		sql += " and a.tsc_package = '" + TSC_PACKAGE+"'";
	}
	if (!ITEM_DESC.equals(""))
	{
		sql += " and a.tsc_desc = '"+  ITEM_DESC+"'";
	}
	sql += " order by a.manufactory_no,a.tsc_prod_group,a.tsc_family,a.tsc_prod_family, a.tsc_package,case when a.s_voltage is null and a.e_voltage is null then 4 when a.s_voltage is null and a.e_voltage is not null then 1 when a.s_voltage is not null and a.e_voltage is not null then 2 else 3 end";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//生產廠區
			ws.addCell(new jxl.write.Label(col, row, "生產廠區" , ACenterBLB));
			ws.setColumnView(col,25);
			col++;	

			//TSC Prod Group
			ws.addCell(new jxl.write.Label(col, row, "TSC Prod Group" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			//TSC Family
			ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//TSC Prod Family
			ws.addCell(new jxl.write.Label(col, row, "TSC Prod Family" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//TSC Package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	

			//Start Voltage(V)
			ws.addCell(new jxl.write.Label(col, row, "Start Voltage(V)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//End Voltage(V)
			ws.addCell(new jxl.write.Label(col, row, "End Voltage(V)" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Lead Time
			ws.addCell(new jxl.write.Label(col, row, "Lead Time" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//Lead Time(No Wafer)
			//ws.addCell(new jxl.write.Label(col, row, "Lead Time(No Wafer)" , ACenterBLB));
			//ws.setColumnView(col,20);	
			//col++;	

			//Lead Time Uom
			ws.addCell(new jxl.write.Label(col, row, "Lead Time Uom" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//最後異動者
			ws.addCell(new jxl.write.Label(col, row, "最後異動者" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//最後異動日
			ws.addCell(new jxl.write.Label(col, row, "最後異動日" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	
			
			//狀態
			ws.addCell(new jxl.write.Label(col, row, "狀態" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
			
			//備註
			ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;				
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("MANUFACTORY_NAME"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_prod_group"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_family") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("tsc_prod_family")==null?"":rs.getString("tsc_prod_family")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_package") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("tsc_desc")==null?"":rs.getString("tsc_desc")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("s_voltage")==null?"":rs.getString("s_voltage")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("e_voltage")==null?"":rs.getString("e_voltage")) , ALeftL));
		col++;	
		if (rs.getString("lead_time")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("lead_time")).doubleValue(), ARightL));
		}
		col++;	
		//add by Peggy 20160130
		//if (rs.getString("NO_WAFER_LEAD_TIME")==null)
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
		//}
		//else
		//{
		//	ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("NO_WAFER_LEAD_TIME")).doubleValue(), ARightL));
		//}
		//col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("lead_time_uom") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("last_updated_by") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("last_update_date") ,ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("active_flag").equals("A")?"啟用":"停用") ,(rs.getString("active_flag").equals("A")?ACenterL:ACenterLR)));
		col++;
		//if (UserName.indexOf(rs.getString("last_updated_by"))>=0) //modify by Peggy 20210817 for Judy download issue 
		//{
			ws.addCell(new jxl.write.Label(col, row, (rs.getString("remarks")==null?"":rs.getString("remarks")) , ALeftL));
		//}
		//else
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
		//}
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
