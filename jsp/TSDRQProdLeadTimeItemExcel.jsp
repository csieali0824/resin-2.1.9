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
<body>TSSalesOrderReviseOverviewExcel
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
	RPTName = "Lead_Time_Item_List";
	FileName = RPTName+"("+UserName+")"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	SheetSettings sst = ws.getSettings(); 	
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	
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
		
	sql = " SELECT TM.manufactory_name FACTORY,SEGMENT1 as \"22/30-Digit-Code\""+
	      ",msi.DESCRIPTION as \"TSC Ordering Code\""+
          ",TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) as \"PROD GROUP\""+
		  ",TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000123) as \"TSC Prod Category\""+
		  ",TSC_INV_CATEGORY(msi.inventory_item_id,43,21) as \"FAMILY\""+
		  ",CASE WHEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) IN ('PMD','SSD','SSP') THEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000004) ELSE '' END as \"PROD FAMILY\""+
		  ",TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000203) as \"PROD HIERARCHY 1\""+
		  ",TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000204) as \"PROD HIERARCHY 2\""+
		  ",TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000205) as \"PROD HIERARCHY 3\""+
		  ",TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000206) as \"PROD HIERARCHY 4\""+
		  ",TSC_INV_CATEGORY(msi.inventory_item_id,43,23) as \"PACKAGE\""+
          ",qq.SPQ"+
          ",qq.MOQ"+
          ",qq.SAMPLE_SPQ as \"SAMPLE SPQ\""+
          ",tt.LEAD_TIME  as \"Standard Lead Time(Week)\""+            
          ",msi.INVENTORY_ITEM_STATUS_CODE as \"ITEM STATUS\""+
          ",tt.factory_REMARKS"+
		  ",(select attribute19 from INV.MTL_SYSTEM_ITEMS_B x where x.organization_id=43 and x.inventory_item_id=msi.inventory_item_id) \"PCN/PDN Date\""+ 
          " FROM INV.MTL_SYSTEM_ITEMS_B MSI "+
          ",oraddman.TSPROD_MANUFACTORY TM"+
          ",TABLE(TSC_GET_ITEM_SPQ_MOQ(MSI.inventory_item_id,'TS',NULL)) qq"+
          ",TABLE(TSC_GET_ITEM_LEADTIME(MSI.inventory_item_id,MSI.attribute3,NULL)) tt "+              
          " WHERE  ORGANIZATION_ID=49 "+
          " AND LENGTH(msi.SEGMENT1)>=22 "+
          " AND  msi.ITEM_TYPE='FG'"+
          " AND msi.attribute3=TM.manufactory_no(+)"+
          //" AND msi.INVENTORY_ITEM_STATUS_CODE <>'Inactive'"+
          " AND TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000204) IS NOT NULL";
	if (!PLANT_CODE.equals("") && !PLANT_CODE.equals("--"))
	{
	 	sql += " and TM.manufactory_no='"+PLANT_CODE+"'";
	}
	if (!TSC_PROD_GROUP.equals("") && !TSC_PROD_GROUP.equals("--"))
	{
		sql += " and TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) = '" + TSC_PROD_GROUP +"'";
	}
	if (!TSC_FAMILY.equals("") && !TSC_FAMILY.equals("--"))
	{
		sql += " and TSC_INV_CATEGORY(msi.inventory_item_id,43,21) ='"+ TSC_FAMILY+"'";
	}
	if (!TSC_PROD_FAMILY.equals("") && !TSC_PROD_FAMILY.equals("--"))
	{
		sql += " and CASE WHEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) IN ('PMD','SSD','SSP') THEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000004) ELSE '' END ='"+ TSC_PROD_FAMILY+"'";
	}
	if (!TSC_PACKAGE.equals("") && !TSC_PACKAGE.equals("--"))
	{
		sql += " and TSC_INV_CATEGORY(msi.inventory_item_id,43,23) = '" + TSC_PACKAGE+"'";
	}
	if (!ITEM_DESC.equals(""))
	{
		sql += " and msi.DESCRIPTION = '"+  ITEM_DESC+"'";
	}
	sql += " order by 1,2";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//Factory
			ws.addCell(new jxl.write.Label(col, row, "Factory" , ACenterBLB));
			ws.setColumnView(col,15);
			col++;	

			//22/30-Digit-Code
			ws.addCell(new jxl.write.Label(col, row, "22/30-Digit-Code" , ACenterBLB));
			ws.setColumnView(col,35);	
			col++;	
			
			//TSC Ordering Code
			ws.addCell(new jxl.write.Label(col, row, "TSC Ordering Code" , ACenterBLB));
			ws.setColumnView(col,25);	
			col++;	
					
			//PROD GROUP
			ws.addCell(new jxl.write.Label(col, row, "PROD GROUP" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;
			
			//TSC Prod Category
			ws.addCell(new jxl.write.Label(col, row, "TSC Prod Category" , ACenterBLB));
			ws.setColumnView(col,22);	
			col++;					
									
			//TSC Family
			ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBLB));
			ws.setColumnView(col,22);	
			col++;	

			//TSC Prod Family
			ws.addCell(new jxl.write.Label(col, row, "TSC Prod Family" , ACenterBLB));
			ws.setColumnView(col,22);	
			col++;	

			//PROD HIERARCHY 1
			ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 1" , ACenterBLB));
			ws.setColumnView(col,22);	
			col++;	
			
			//PROD HIERARCHY 2
			ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 2" , ACenterBLB));
			ws.setColumnView(col,22);	
			col++;	
			
			//PROD HIERARCHY 3
			ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 3" , ACenterBLB));
			ws.setColumnView(col,22);	
			col++;	
			
			//PROD HIERARCHY 4
			ws.addCell(new jxl.write.Label(col, row, "PROD HIERARCHY 4" , ACenterBLB));
			ws.setColumnView(col,22);	
			col++;				
									
			//TSC Package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBLB));
			ws.setColumnView(col,22);	
			col++;	

			//SPQ
			ws.addCell(new jxl.write.Label(col, row, "SPQ" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
			
			//MOQ
			ws.addCell(new jxl.write.Label(col, row, "MOQ" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
			
			//SAMPLE SPQ
			ws.addCell(new jxl.write.Label(col, row, "SAMPLE SPQ" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	
									
			//Lead Time
			ws.addCell(new jxl.write.Label(col, row, "Standard Lead Time(Week)" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//ITEM STATUS
			ws.addCell(new jxl.write.Label(col, row, "ITEM STATUS" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;	

			//FACTORY_REMARKS
			ws.addCell(new jxl.write.Label(col, row, "FACTORY_REMARKS" , ACenterBLB));
			ws.setColumnView(col,60);	
			col++;
			
			//PCN/PDN Date
			ws.addCell(new jxl.write.Label(col, row, "PCN/PDN Date" , ACenterBLB));
			ws.setColumnView(col,12);	
			col++;				
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("FACTORY"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("22/30-Digit-Code"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC Ordering Code") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PROD GROUP") , ALeftL));		
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("TSC Prod Category")==null?"":rs.getString("TSC Prod Category")) , ALeftL));
		col++;		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("Family") , ALeftL));		
		col++;		
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PROD FAMILY")==null?"":rs.getString("PROD FAMILY")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PROD HIERARCHY 1") , ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PROD HIERARCHY 2") , ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PROD HIERARCHY 3") , ALeftL));
		col++;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PROD HIERARCHY 4") , ALeftL));
		col++;								
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKAGE") , ALeftL));
		col++;	
		if (rs.getString("SPQ")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SPQ")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("MOQ")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("MOQ")).doubleValue(), ARightL));
		}
		col++;	
		if (rs.getString("SAMPLE SPQ")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SAMPLE SPQ")).doubleValue(), ARightL));
		}
		col++;							
		if (rs.getString("Standard Lead Time(Week)")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("Standard Lead Time(Week)")).doubleValue(), ARightL));
		}
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM STATUS") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("FACTORY_REMARKS") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("PCN/PDN Date")==null?"":rs.getString("PCN/PDN Date")) , ACenterL));
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
