<!--20171108 Peggy,add selling price for tschk-->
<!--20171221 Peggy,TSCH-HK RFQ region code from 002 change to 018-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*"%>
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
<FORM ACTION="../jsp/TSRFQFactoryNoResponseExcel.jsp" METHOD="post" name="MYFORM">
<%
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr="--";
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="--";
String DayFr=request.getParameter("DAYFR");
if (DayFr==null) DayFr="--";
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo="--";
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="--";
String DayTo=request.getParameter("DAYTO");
if (DayTo==null) DayTo="--";
String prodManufactory=request.getParameter("PRODMANUFACTORY");
String status=request.getParameter("STATUS");
String createdBy = request.getParameter("CREATOR");
String salesAreaNo = request.getParameter("SALESAREANO");
if (salesAreaNo==null) salesAreaNo="";

String serverHostName=request.getServerName();
String FileName="",RPTName="",ColumnName="",sql="",where="";
int fontsize=8,colcnt=0;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	int row =0,col=0,reccnt=0;
	OutputStream os = null;	
	RPTName = "TSRFQFactoryNoResponse";
	FileName = RPTName+"-"+dateBean.getYearMonthDay()+dateBean.getHourMinute()+".xls";
	os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet(RPTName, 0); 
	
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

	sql = " SELECT a.ALNAME TSGROUP,C.DNDOCNO,C.CUSTOMER,D.ITEM_SEGMENT1 ITEM_NO,D.ITEM_DESCRIPTION PART_NO,D.PRIMARY_UOM UOM, "+
          " D.QUANTITY, to_char(TO_date(SUBSTR(D.CREATION_DATE,1,8),'YYYYMMDD'),'YYYY/MM/DD') CREATION_DATE, "+
          " to_char(TO_date(SUBSTR(D.REQUEST_DATE,1,8),'YYYYMMDD'),'YYYY/MM/DD') REQUEST_DATE,"+
          " D.REMARK,D.CUST_PO_NUMBER,E.MANUFACTORY_NAME,D.LSTATUS"+
		  " ,nvl(f.username,c.created_by) created_by"+
		  ",TRUNC(SYSDATE)-TO_date(SUBSTR(D.CREATION_DATE,1,8),'YYYYMMDD') OVER_DAYS"+
		  ",d.SELLING_PRICE,nvl(d.SELLING_PRICE,0)* case when D.PRIMARY_UOM='KPC' THEN 1000 ELSE 1 END*d.QUANTITY AMOUNT,c.CURR"+ //add by Peggy 20171108
          " FROM oraddman.TSDELIVERY_NOTICE c"+
		  ",oraddman.TSDELIVERY_NOTICE_DETAIL d"+
		  ",oraddman.TSPROD_MANUFACTORY e "+
          ",ORADDMAN.TSSALES_AREA A"+
		  ",(SELECT x.* FROM (SELECT WEBID,USERNAME,ROW_NUMBER() OVER (PARTITION BY WEBID ORDER BY USERNAME) ROWSEQ FROM oraddman.wsuser WHERE NVL(LOCKFLAG ,'Y')='N') x where ROWSEQ=1) f"+
          " WHERE c.dndocno = d.dndocno  "+
          " AND d.assign_manufact = e.manufactory_no(+) "+
          " AND c.tsareano = a.sales_area_no"+
		  " AND c.created_by=f.webid(+)"+
          " AND d.lstatusid IN ('003','004')";
	if (!UserRoles.equals("admin") && UserRoles.indexOf("PMD_Approver")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0) 
	{ 
		sql += " and exists (select 1 from oraddman.tsrecperson x where x.tssaleareano=c.TSAREANO and x.USERNAME='"+UserName+"')";	
	}		
	if (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) 
	{ 
		sql += " and exists (select 1 from oraddman.tsprod_person x where x.PROD_FACNO=d.ASSIGN_MANUFACT and nvl(x.PACTIVE,'N')='Y' and x.USERNAME='"+UserName+"')";	
	}	
   	if (prodManufactory!=null && !prodManufactory.equals("--") && !prodManufactory.equals("")) 
	{
		sql +=" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; 
	}
  
   	if (status!=null && !status.equals("--"))  
	{
		sql +=" and d.LSTATUSID ='"+status+"'"; 
	}
   
	if (salesAreaNo != null && !salesAreaNo.equals("--") && !salesAreaNo.equals(""))
	{
		sql +=" and c.TSAREANO ='" +salesAreaNo+"'";  
	}
		
	if (createdBy!=null && !createdBy.equals("")) 
	{ 
		sql +=" and exists (select 1 from  oraddman.WSUSER x where UPPER(x.USERNAME)='"+createdBy.toUpperCase()+"' and x.WEBID=d.created_by)"; 
	}
	
	if ((YearFr !=null && !YearFr.equals("--")) || (MonthFr !=null && !MonthFr.equals("--")) || (DayFr !=null && !DayFr.equals("--")))
	{
		sql +=" and substr(c.CREATION_DATE,0,8)>="+ (!YearFr.equals("--")?YearFr:"0000")+(!MonthFr.equals("--")?MonthFr:"00")+(!DayFr.equals("--")?DayFr:"00");
	}
	if ((YearTo != null && !YearTo.equals("--")) || (MonthTo !=null && !MonthTo.equals("--")) || (DayTo!=null && !DayTo.equals("--")))
	{
		sql +=" and substr(c.CREATION_DATE,0,8)<="+ (!YearTo.equals("--")?YearTo:dateBean.getYearString())+(!MonthTo.equals("--")?MonthTo:dateBean.getMonthString())+(!DayTo.equals("--")?DayTo:dateBean.getDayString());
	}
	sql += " order by c.DNDOCNO";			  
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (reccnt==0)
		{
			col=0;row=0;
			
			//業務區
			ws.addCell(new jxl.write.Label(col, row, "業務區" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	
			
			//RFQ單號
			ws.addCell(new jxl.write.Label(col, row, "RFQ單號" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;
			
			//客戶名稱
			ws.addCell(new jxl.write.Label(col, row, "客戶名稱" , ACenterBLB));
			ws.setColumnView(col,45);	
			col++;	

			//台半料號
			ws.addCell(new jxl.write.Label(col, row, "料號" , ACenterBLB));
			ws.setColumnView(col,24);	
			col++;	

			//型號
			ws.addCell(new jxl.write.Label(col, row, "型號" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//數量
			ws.addCell(new jxl.write.Label(col, row, "數量" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//單位
			ws.addCell(new jxl.write.Label(col, row, "單位" , ACenterBLB));
			ws.setColumnView(col,10);	
			col++;	

			//金額
			if (UserRoles.indexOf("admin")>=0 || UserName.equals("COCO"))
			{
				//單價
				ws.addCell(new jxl.write.Label(col, row, "單價" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;	

				//金額
				ws.addCell(new jxl.write.Label(col, row, "金額" , ACenterBLB));
				ws.setColumnView(col,10);	
				col++;	

				//幣別
				ws.addCell(new jxl.write.Label(col, row, "幣別" , ACenterBLB));
				ws.setColumnView(col,6);	
				col++;	
			}
			
			//開單人
			ws.addCell(new jxl.write.Label(col, row, "開單人" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//開單日期
			ws.addCell(new jxl.write.Label(col, row, "開單日期" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//業務需求日
			ws.addCell(new jxl.write.Label(col, row, "業務需求日" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;

			//備註
			ws.addCell(new jxl.write.Label(col, row, "備註" , ACenterBLB));
			ws.setColumnView(col,30);	
			col++;	

			//客戶PO
			ws.addCell(new jxl.write.Label(col, row, "Customer PO" , ACenterBLB));
			ws.setColumnView(col,45);	
			col++;	

			//工廠別
			ws.addCell(new jxl.write.Label(col, row, "工廠別" , ACenterBLB));
			ws.setColumnView(col,20);	
			col++;	

			//狀態
			ws.addCell(new jxl.write.Label(col, row, "狀態" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			//逾時天數
			ws.addCell(new jxl.write.Label(col, row, "逾時天數" , ACenterBLB));
			ws.setColumnView(col,15);	
			col++;	

			row++;
		}
		col=0;

		ws.addCell(new jxl.write.Label(col, row, rs.getString("TSGROUP"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("DNDOCNO"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CUSTOMER"), ALeftL));
		col++;			
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_NO"), ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("PART_NO") , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("QUANTITY")).doubleValue(), ARightL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("UOM") , ACenterL));
		col++;	
		//金額
		if (UserRoles.indexOf("admin")>=0 || UserName.equals("COCO"))
		{	
			if (rs.getString("selling_price")==null || (!rs.getString("CREATED_BY").equals("COCO") && UserRoles.indexOf("admin")<0))
			{
				ws.addCell(new jxl.write.Label(col, row, null , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, null , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, null , ALeftL));
				col++;	
			}
			else
			{
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("selling_price")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("amount")).doubleValue(), ARightL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("curr") , ALeftL));
				col++;	
			}
		}
		ws.addCell(new jxl.write.Label(col, row, rs.getString("CREATED_BY") , ALeftL));
		col++;		
		if (rs.getString("CREATION_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("CREATION_DATE")) ,DATE_FORMAT));
		}
		col++;	
		if (rs.getString("REQUEST_DATE")==null)
		{
			ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
		}
		else
		{
			ws.addCell(new jxl.write.DateTime(col, row, formatter.parse(rs.getString("REQUEST_DATE")) ,DATE_FORMAT));
		}
		col++;					
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("REMARK")==null?"":rs.getString("REMARK")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST_PO_NUMBER")==null?"":rs.getString("CUST_PO_NUMBER")) , ALeftL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, rs.getString("MANUFACTORY_NAME") , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Label(col, row, (rs.getString("LSTATUS")==null?"":rs.getString("LSTATUS")) , ACenterL));
		col++;	
		ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs.getString("OVER_DAYS")).doubleValue(), ARightL));
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
