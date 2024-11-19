<!--20171024 Peggy,新增remarks欄位-->
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
<FORM ACTION="../jsp/TSLabelGroupExcel.jsp" METHOD="post" name="MYFORM">
<%
String LABEL_GROUP = request.getParameter("LABEL_GROUP");
if (LABEL_GROUP==null) LABEL_GROUP="";
String MODULE_CODE = request.getParameter("MODULE_CODE");
if (MODULE_CODE==null) MODULE_CODE="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String FileName="",RPTName="",sql="",sql1="";
int fontsize=9,colcnt=0,row =0,col=0,reccnt=0,area_cnt=0;

try 
{ 	

	OutputStream os = null;	
	RPTName = "TS_Label_Group";
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
		
	sql = " select a.label_group_code,a.label_group_name, a.label_group_desc, a.remarks,"+
          " to_char(a.effective_from_date,'yyyy-mm-dd') effective_from_date, to_char(a.effective_to_date,'yyyy-mm-dd') effective_to_date, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date, a.last_updated_by ";
	sql1 = " SELECT a.module_code FROM oraddman.ts_label_modules a "+
		  " where trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date)) "+
		  " order by a.module_code";
	Statement statement1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rs1=statement1.executeQuery(sql1);
	while (rs1.next())
	{
		sql += ",(select nvl(isactive_flag,'N') from oraddman.ts_label_group_assignments x where x.label_group_code=a.label_group_code and NVL(x.isactive_flag,'N') ='Y' and x.module_code='"+rs1.getString("module_code")+"' ) AS "+rs1.getString("module_code")+"";
		area_cnt++;
	}

    sql += " from oraddman.ts_label_groups a"+
		  " where 1=1";
	if (! LABEL_GROUP.equals("") && ! LABEL_GROUP.equals("--"))
	{
	 	//sql += " and (a.label_group_code='"+ LABEL_GROUP+"' or a.label_group_name like '"+ LABEL_GROUP+"%')";
	 	sql += " and (upper(a.label_group_code)='"+ LABEL_GROUP.toUpperCase()+"' or upper(a.label_group_name) like '"+ LABEL_GROUP.toUpperCase()+"%')";
	}
	if (!MODULE_CODE.equals("") && !MODULE_CODE.equals("--"))
	{
		sql += " and exists (select 1 from oraddman.ts_label_group_assignments b where b.module_code = '" + MODULE_CODE +"' and b.label_group_code=a.label_group_code and NVL(b.isactive_flag,'N')='Y')";
	}
	if (STATUS.equals("Y"))
	{
		sql += " and trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	else if (STATUS.equals("N"))
	{
		sql += " and trunc(sysdate) not between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	sql += " order by a.label_group_code";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//群組代碼
			ws.mergeCells(col, row, col, row+1); 
			ws.addCell(new jxl.write.Label(col, row, "群組代碼" , ACenterBLB));
			ws.setColumnView(col,10);
			col++;	
						
			//群組名稱
			ws.mergeCells(col, row, col, row+1); 
			ws.addCell(new jxl.write.Label(col, row, "群組名稱" , ACenterBLB));
			ws.setColumnView(col,40);
			col++;	

			//群組說明
			ws.mergeCells(col, row, col, row+1); 
			ws.addCell(new jxl.write.Label(col, row, "群組說明" , ACenterBLB));
			ws.setColumnView(col,40);	
			col++;	

			//備註
			ws.mergeCells(col, row, col, row+1); 
			ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	
			
			//業務模組
			ws.mergeCells(col, row, col+(area_cnt-1), row); 
			ws.addCell(new jxl.write.Label(col, row, "業務模組" , ACenterBLB));
			ws.setColumnView(col,10);	
			col+=area_cnt;	

			//啟用起日
			ws.mergeCells(col, row, col, row+1); 
			ws.addCell(new jxl.write.Label(col, row, "啟用起日" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//啟用迄日
			ws.mergeCells(col, row, col, row+1); 
			ws.addCell(new jxl.write.Label(col, row, "啟用迄日" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//最後異動日
			ws.mergeCells(col, row, col, row+1); 
			ws.addCell(new jxl.write.Label(col, row, "最後異動日" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//最後異動者
			ws.mergeCells(col, row, col, row+1); 
			ws.addCell(new jxl.write.Label(col, row, "最後異動者" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			row++;

			col=4;
			if (rs1.isBeforeFirst() ==false) rs1.beforeFirst();
			while (rs1.next())
			{
				ws.addCell(new jxl.write.Label(col, row, rs1.getString(1) , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;	
			}
			rs1.close();   
			statement1.close();	
			row++;	
		}
		col=0;
		ws.addCell(new jxl.write.Label(col, row, rs.getString("label_group_code"), ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("label_group_name"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("label_group_desc"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("remarks"), ALeftL));
		col++;	
		for (int i = 1 ; i <=area_cnt ; i++)
		{
			ws.addCell(new jxl.write.Label(col, row, rs.getString(9+(i-1)) , ACenterL));
			col++;	
		}
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("effective_from_date")==null?"":rs.getString("effective_from_date")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("effective_to_date")==null?"":rs.getString("effective_to_date")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("last_update_date") ,ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("last_updated_by") , ACenterL));
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
