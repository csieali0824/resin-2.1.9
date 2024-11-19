<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSSalesShippingMethodExcel.jsp" METHOD="post" name="MYFORM">
<%
String SALES_REGION = request.getParameter("SALES_REGION");
if (SALES_REGION==null) SALES_REGION="--";
String TSC_FAMILY = request.getParameter("TSC_FAMILY");
if (TSC_FAMILY==null) TSC_FAMILY="";
String TSC_PACKAGE = request.getParameter("TSC_PACKAGE");
if (TSC_PACKAGE==null) TSC_PACKAGE="";
String ITEM_DESC = request.getParameter("ITEM_DESC");
if (ITEM_DESC==null || ITEM_DESC.equals("null")) ITEM_DESC="";
String FileName="",RPTName="",sql="";
int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "ShippingMethod"+(SALES_REGION==null || SALES_REGION.equals("") || SALES_REGION.equals("--") ?"(ALL)":"("+SALES_REGION+")");
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("Sheet1", 0);  
	SheetSettings settings = ws.getSettings();//取得分頁環境設定(如:標頭/標尾,分頁,欄長,欄高等設定
	settings.setZoomFactor(100);    //顯示縮放比例
	settings.setOrientation(jxl.format.PageOrientation.LANDSCAPE);//橫印
	settings.setScaleFactor(90);   // 打印縮放比例
	settings.setHeaderMargin(0.3);
	settings.setBottomMargin(0.5);
	settings.setLeftMargin(0.2);
	settings.setRightMargin(0.2);
	settings.setTopMargin(0.5);
	settings.setFooterMargin(0.3);		
	settings.setVerticalFreeze(1);  //凍結窗格

	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize+1, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	WritableFont font_nobold_b = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLUE);
	
	//英文內文水平垂直置中-粗體-格線-底色灰  
	WritableCellFormat ACenterBL = new WritableCellFormat(font_bold);   
	ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBL.setBackground(jxl.write.Colour.GRAY_25); 
	ACenterBL.setWrap(true);	

	//英文內文水平垂直置中-粗體-格線-底色藍  
	WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLB.setBackground(jxl.write.Colour.PALE_BLUE); 
	ACenterBLB.setWrap(true);
	
	//英文內文水平垂直置中-粗體-格線-底色黃  
	WritableCellFormat ACenterBLY = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLY.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLY.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLY.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLY.setBackground(jxl.write.Colour.YELLOW); 
	ACenterBLY.setWrap(true);	
	
	//英文內文水平垂直置中-粗體-格線-底色橘
	WritableCellFormat ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
	ACenterBLO.setWrap(true);	
	
	//英文內文水平垂直置中-粗體-格線-底色綠
	WritableCellFormat ACenterBLG = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACenterBLG.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterBLG.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterBLG.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterBLG.setBackground(jxl.write.Colour.BRIGHT_GREEN); 
	ACenterBLG.setWrap(true);	
			
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
	
	//英文內文水平垂直置中-正常-格線   
	WritableCellFormat ACenterLB = new WritableCellFormat(font_nobold_b);   
	ACenterLB.setAlignment(jxl.format.Alignment.CENTRE);
	ACenterLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACenterLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ACenterLB.setWrap(true);


	//英文內文水平垂直置右-正常-格線   
	WritableCellFormat ARightLB = new WritableCellFormat(font_nobold_b);   
	ARightLB.setAlignment(jxl.format.Alignment.RIGHT);
	ARightLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARightLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ARightLB.setWrap(true);

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftLB = new WritableCellFormat(font_nobold_b);   
	ALeftLB.setAlignment(jxl.format.Alignment.LEFT);
	ALeftLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftLB.setWrap(true);
		
	//日期格式
	WritableCellFormat DATE_FORMAT = new WritableCellFormat(font_nobold ,new jxl.write.DateFormat("yyyy/MM/dd")); 
	DATE_FORMAT.setAlignment(jxl.format.Alignment.CENTRE);
	DATE_FORMAT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	DATE_FORMAT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	DATE_FORMAT.setWrap(true);
	
		
	sql = " SELECT '('||a.sales_area_no||')'||b.sales_area_name sales_name, a.sales_area_no,a.tsc_package, a.tsc_family, a.tsc_product_name, a.freight, a.sdays, a.edays,"+
          " to_char(a.last_update_date,'yyyy/mm/dd') last_update_date,a.last_updated_by,"+
          " row_number() over (partition by a.sales_area_no,a.tsc_package, a.tsc_family, nvl(a.tsc_product_name,'xx') order by a.sdays) row_seq,"+
          " count(FREIGHT) over (partition by a.sales_area_no,a.tsc_package, a.tsc_family, nvl(a.tsc_product_name,'xx')) row_cnt"+
          " FROM oraddman.tsce_air_sea_freight_rule a,oraddman.tssales_area b"+
          " where a.sales_area_no=b.sales_area_no";
	if (!SALES_REGION.equals("") && !SALES_REGION.equals("--"))
	{
	 	sql += " and a.sales_area_no='"+SALES_REGION+"'";
	}
	else if (UserRoles.indexOf("admin")<0)
	{				  
		sql += " and exists (select 1 from oraddman.tsrecperson tp,oraddman.wsuser ws"+
               " where tp.username=ws.username"+
			   " and ws.username='"+UserName+"'"+
			   " and tp.tssaleareano=a.sales_area_no) ";
	}
	if (!TSC_FAMILY.equals("") && !TSC_FAMILY.equals("--"))
	{
		sql += " and a.tsc_family ='"+ TSC_FAMILY+"'";
	}
	if (!TSC_PACKAGE.equals("") && !TSC_PACKAGE.equals("--"))
	{
		sql += " and a.tsc_package = '" + TSC_PACKAGE+"'";
	}
	if (!ITEM_DESC.equals(""))
	{
		sql += " and '"+  ITEM_DESC+"' like tsc_product_name||'%'";
	}
    sql += " order by a.sales_area_no,a.tsc_package, a.tsc_family,a.sdays";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	col=0;row=0;
	while (rs.next()) 
	{ 	
		if (row==0)
		{
			//業務區
			ws.addCell(new jxl.write.Label(col, row, "業務區" , ACenterBL));
			ws.setColumnView(col,23);	
			col++;					
	
			//TSC Family
			ws.addCell(new jxl.write.Label(col, row, "TSC Family" , ACenterBL));
			ws.setColumnView(col,16);	
			col++;					
				
			//TSC Package
			ws.addCell(new jxl.write.Label(col, row, "TSC Package" , ACenterBL));
			ws.setColumnView(col,16);	
			col++;	
						
			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBL));
			ws.setColumnView(col,16);	
			col++;	
	
			//Shipping Method
			ws.addCell(new jxl.write.Label(col, row, "Shipping Method" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//Start Days
			ws.addCell(new jxl.write.Label(col, row, "Start Days" , ACenterBL));
			ws.setColumnView(col,9);	
			col++;	
	
			//End Days
			ws.addCell(new jxl.write.Label(col, row, "End Days" , ACenterBL));
			ws.setColumnView(col,9);	
			col++;	
	
			//Creation Date
			ws.addCell(new jxl.write.Label(col, row, "Creation Date" , ACenterBL));
			ws.setColumnView(col,12);	
			col++;	
	
			//Created by
			ws.addCell(new jxl.write.Label(col, row, "Created by" , ACenterBL));
			ws.setColumnView(col,12);
			col++;	
	
			row++;
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("sales_name"), ACenterL));
		col++;					
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_family"),  ALeftL));
		col++;					
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_package"),  ALeftL));
		col++;					
		ws.addCell(new jxl.write.Label(col, row, rs.getString("tsc_product_name"),  ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("FREIGHT"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("SDAYS")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("EDAYS")).doubleValue(), ARightL));
		col++;	
		if (rs.getString("LAST_UPDATE_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "", ALeftL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("LAST_UPDATE_DATE")) ,DATE_FORMAT));
		}
		col++;		
		ws.addCell(new jxl.write.Label(col, row, rs.getString("LAST_UPDATED_BY"), ACenterL));
		col++;	
		row++;				
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
