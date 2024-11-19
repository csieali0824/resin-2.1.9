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
<FORM ACTION="../jsp/TSA01WIPComponentDetailExcel.jsp" METHOD="post" name="MYFORM">
<%
String COMP_TYPE_NAME = request.getParameter("COMP_TYPE_NAME");
if (COMP_TYPE_NAME==null) COMP_TYPE_NAME="";
String ITEM_NAME = request.getParameter("ITEM_NAME");
if (ITEM_NAME==null) ITEM_NAME="";
String FileName="",RPTName="",sql="",where="";
int fontsize=9,colcnt=0,row =0,col=0,reccnt=0;

try 
{ 	

	OutputStream os = null;	
	RPTName = "WIP_ITEM_List";
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
		
	sql = " SELECT a.comp_type_no"+
	      ", b.comp_type_name"+
	      ", a.organization_id"+
		  ", a.inventory_item_id"+
		  ", a.item_name"+
		  ", c.description"+
		  ", a.uom"+
		  ", a.spq"+
		  ", a.moq"+
		  ", a.change_rate"+
		  ", a.created_by"+
		  ", to_char(a.creation_date,'yyyy/mm/dd') creation_date"+
		  ", a.last_updated_by"+
		  ", to_char(a.last_update_date,'yyyy/mm/dd') last_update_date"+
		  ", nvl(a.inactive_flag,'') inactive_flag"+
		  ", a.level1_packing_name"+
		  ", a.level1_packing_value"+
		  ", a.level2_packing_name"+
		  ", a.level2_packing_value"+
          ", a.level3_packing_name"+
		  ", a.level3_packing_value"+
		  ", a.level4_packing_name"+
		  ", a.level4_packing_value"+
		  ", a.moq_level"+
          " FROM oraddman.tsa01_component_detail a,oraddman.tsa01_component_type b,inv.mtl_system_items_b c"+
		  " where a.comp_type_no=b.comp_type_no"+
		  " and a.inventory_item_id=c.inventory_item_id"+
		  " and a.organization_id=c.organization_id";
	if (!COMP_TYPE_NAME.equals(""))
	{
	 	sql += " and b.comp_type_name like '"+ COMP_TYPE_NAME.toUpperCase()+"%'";
	}
	if (!ITEM_NAME.equals(""))
	{
		sql += " and a.item_name like '"+ITEM_NAME+"%'";
	}
	sql += " order by a.comp_type_no,a.item_name";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//原物料類別代碼
			ws.addCell(new jxl.write.Label(col, row, "原物料類別代碼" , ACenterBLB));
			ws.setColumnView(col,15);
			col++;	

			//原物料類別名稱
			ws.addCell(new jxl.write.Label(col, row, "原物料類別名稱" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//品名
			ws.addCell(new jxl.write.Label(col, row, "品名" , ACenterBLB));
			ws.setColumnView(col,40);	
			col++;	

			//第一層包裝
			ws.addCell(new jxl.write.Label(col, row, "第一層包裝" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//第二層包裝
			ws.addCell(new jxl.write.Label(col, row, "第二層包裝" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//第三層包裝
			ws.addCell(new jxl.write.Label(col, row, "第三層包裝" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//第四層包裝
			ws.addCell(new jxl.write.Label(col, row, "第四層包裝" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//單位
			ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//發料包裝層
			ws.addCell(new jxl.write.Label(col, row, "發料包裝層" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//最後異動者
			ws.addCell(new jxl.write.Label(col, row, "最後異動者" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//最後異動日
			ws.addCell(new jxl.write.Label(col, row, "最後異動日" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//是否停用
			ws.addCell(new jxl.write.Label(col, row, "是否停用" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;		
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("comp_type_no"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("comp_type_name"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("item_name") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("description") , ALeftL));
		col++;	
		//if (rs.getString("spq")==null)
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
		//}
		//else
		//{
		//	ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("spq")).doubleValue(), ARightL));
		//}
		//col++;	
		//if (rs.getString("moq")==null)
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
		//}
		//else
		//{
		//	ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("moq")).doubleValue(), ARightL));
		//}
		//col++;	
		//if (rs.getString("change_rate")==null)
		//{
		//	ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
		//}
		//else
		//{
		//	ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("change_rate")).doubleValue(), ARightL));
		//}
		//col++;				
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("level1_packing_value")==null?"":(new DecimalFormat("######0.####")).format(rs.getFloat("level1_packing_value"))+(rs.getString("level1_packing_name")==null?"":"/"+rs.getString("level1_packing_name"))) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("level2_packing_value")==null?"":(new DecimalFormat("######0.####")).format(rs.getFloat("level2_packing_value"))+(rs.getString("level2_packing_name")==null?"":"/"+rs.getString("level2_packing_name"))) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("level3_packing_value")==null?"":(new DecimalFormat("######0.####")).format(rs.getFloat("level3_packing_value"))+(rs.getString("level3_packing_name")==null?"":"/"+rs.getString("level3_packing_name"))) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("level4_packing_value")==null?"":(new DecimalFormat("######0.####")).format(rs.getFloat("level4_packing_value"))+(rs.getString("level4_packing_name")==null?"":"/"+rs.getString("level4_packing_name"))) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("uom") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("moq_level") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("last_updated_by") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("last_update_date") ,ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("inactive_flag") ,ACenterL));
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
