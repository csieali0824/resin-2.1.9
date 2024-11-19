<%@ page  contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.awt.Image.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Download Excel File</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSSalseItemCertificate.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String DNDOCNO = request.getParameter("DNDOCNO");
if (DNDOCNO==null) DNDOCNO="";
String LINENO = request.getParameter("LINENO");
if (LINENO==null) LINENO="";
String FileName="",sql="",where="",strDesc="";
int fontsize=10,colcnt=0;
int row =0,col=0,reccnt=0,line=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();
		
	//公司名稱英文平行置中     
	WritableCellFormat wCompEName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 14 ,WritableFont.BOLD,false));   
	wCompEName.setAlignment(jxl.format.Alignment.CENTRE);
	
	//地址英文平行置中     
	WritableCellFormat wAddrEName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wAddrEName.setAlignment(jxl.format.Alignment.CENTRE);
			
	//電話平行置中     
	WritableCellFormat wTelName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wTelName.setAlignment(jxl.format.Alignment.CENTRE);
			
	//報表名稱平行置中    
	WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 14, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	wRptName.setAlignment(jxl.format.Alignment.CENTRE);
	
	//英文內文水平垂直置右
	WritableCellFormat ARIGHT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARIGHT.setAlignment(jxl.format.Alignment.RIGHT);
	ARIGHT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARIGHT.setWrap(true);


	//英文內文水平垂直置右(字型大小8)
	WritableCellFormat ARIGHT1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 8,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ARIGHT1.setAlignment(jxl.format.Alignment.RIGHT);
	ARIGHT1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ARIGHT1.setWrap(true);
			
	//英文內文水平垂直置左
	WritableCellFormat ALEFT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALEFT.setAlignment(jxl.format.Alignment.LEFT);
	ALEFT.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALEFT.setWrap(true);
	
	//英文內文水平垂直置中(字型大小8)
	WritableCellFormat ACENTER1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 8,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ACENTER1.setAlignment(jxl.format.Alignment.CENTRE);
	ACENTER1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ACENTER1.setWrap(true);	

	//英文內文水平垂直置左-正常-格線   
	WritableCellFormat ALeftL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	ALeftL.setWrap(true);
		
	//英文內文水平垂直靠左-格線下   
	WritableCellFormat ALeftL1= new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
	ALeftL1.setAlignment(jxl.format.Alignment.LEFT);
	ALeftL1.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	ALeftL1.setBorder(jxl.format.Border.TOP,jxl.format.BorderLineStyle.NONE);
	ALeftL1.setBorder(jxl.format.Border.RIGHT,jxl.format.BorderLineStyle.NONE);
	ALeftL1.setBorder(jxl.format.Border.LEFT,jxl.format.BorderLineStyle.NONE);
	ALeftL1.setBorder(jxl.format.Border.BOTTOM,jxl.format.BorderLineStyle.THIN);
	ALeftL1.setWrap(true);
			
	OutputStream os = null;	
	FileName = "Certificate_"+dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString()+".xls";
	if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
	{
		os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName);
	}  
	else 
	{ 
	
		os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName);
	}
	WritableWorkbook wwb = Workbook.createWorkbook(os); 
	WritableSheet ws = wwb.createSheet("Sheet1", 0);  
	SheetSettings settings = ws.getSettings();//取得分頁環境設定(如:標頭/標尾,分頁,欄長,欄高等設定
	settings.setScaleFactor(100);   // 打印縮放比例
	settings.setHeaderMargin(0.3);
	settings.setBottomMargin(0.5);
	settings.setLeftMargin(0.3);
	settings.setRightMargin(0.3);
	settings.setTopMargin(0.5);
	settings.setFooterMargin(0.3);	
	
	sql = " select a.CUSTOMER,b.ITEM_DESCRIPTION,QUANTITY "+
	      " from oraddman.tsdelivery_notice a,oraddman.tsdelivery_notice_detail b"+
	      " where a.dndocno = b.dndocno "+
		  " and b.dndocno ='"+ DNDOCNO+"'"+
		  " and b.line_no='"+LINENO+"'";
	//out.println(sql);
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	String territory ="";
	while (rs.next())
	{
		if (reccnt==0)
		{
			
			col=0;row=0;
			//logo
			jxl.write.WritableImage image = new jxl.write.WritableImage(col,row,col+1,row+3, new File("..//resin-2.1.9//webapps/oradds/jsp/images/logo.png")); 
			ws.addImage(image); 
		
			String strETitle = "TAIWAN SEMICONDUCTOR CO.,LTD";
			ws.mergeCells(col, row, col+6, row+1);     
			ws.addCell(new jxl.write.Label(col, row,strETitle , wCompEName));
			row=3;//列+1
					
			String strEAddr = "11Fl.,No,205,Sec.3,Beishin Rd., Xindian Dist., New Taipei City 231, Taiwan";
			ws.mergeCells(col, row, col+6, row);     
			ws.addCell(new jxl.write.Label(col, row,strEAddr , wAddrEName));
			row++;//列+1	
			
			String strTelInfo = "Tel: 886-2-8913-1588, Fax: 886-2-8913-1788";
			ws.mergeCells(col, row, col+6, row);     
			ws.addCell(new jxl.write.Label(col, row,strTelInfo , wTelName));
			row+=2;//列+2

			String strRPTtitle = "Certificate of Conformance";
			ws.mergeCells(col, row, col+6, row);     
			ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wCompEName));
			row+=2;//列+2

			ws.mergeCells(col, row, col+6, row);
			ws.addCell(new jxl.write.Label(col, row, "Date:" , ALEFT));
			row++;	

			ws.mergeCells(col, row, col+6, row);
			ws.addCell(new jxl.write.Label(col, row, "TAIWAN SEMICONDUCTOR CO.,LTD" , ALEFT));
			row++;	

			ws.mergeCells(col, row, col+6, row);
			ws.addCell(new jxl.write.Label(col, row, "11Fl.,No,205,Sec.3,Beishin Rd., Xindian Dist.," , ALEFT));
			row++;	

			ws.mergeCells(col, row, col+6, row);
			ws.addCell(new jxl.write.Label(col, row, "New Taipei City 231, Taiwan" , ALEFT));
			row+=2;	
			
			strDesc ="WE GUARANTEE THAT TSC PART NUMBER ?01 (PRODUCT INFO.AS BELOW) WHICH NO"+
			         " ELECTRONIC QUALITY CONCERN WE ARE RESPONSIBLE FOR THE FURTHER QUALITY PROBLEM "+
					 " CAUSED BY OUR ?02 DEFECT UNDER PROPER OPERATION.";
		}
		col=0;
		ws.mergeCells(col, row, col+6, row);
		ws.addCell(new jxl.write.Label(col, row, "TO:"+rs.getString("CUSTOMER") , ALEFT));
		row++;	
		
		ws.mergeCells(col, row, col+6, row+4);
		ws.addCell(new jxl.write.Label(col, row, strDesc.replace("?01",rs.getString("ITEM_DESCRIPTION")).replace("?02",rs.getString("ITEM_DESCRIPTION")) , ALEFT));
		row+=5;
		
		ws.mergeCells(col, row, col+6, row);
		ws.addCell(new jxl.write.Label(col, row, "BESIDES,WE TAKE RESPONSIBILITIES FOR ELECTRONIC QUALITY CONTROL ON ALL PRODUCTS WHICH DATE CODE ARE WITHIN TWO YEARS" , ALEFT));
		ws.setRowView(row, 800);
		row+=2;	
		
		ws.mergeCells(col, row, col+1, row);
		ws.addCell(new jxl.write.Label(col, row, "P/N" , ALeftL));
		ws.setColumnView(col,20);
		ws.addCell(new jxl.write.Label(col+2, row, "D/C" , ALeftL));
		ws.setColumnView(col+2,15);	
		ws.addCell(new jxl.write.Label(col+3, row, "QTY" , ALeftL));
		ws.setColumnView(col+3,15);	
		ws.setColumnView(col+4,15);	
		ws.setColumnView(col+5,15);	
		ws.setColumnView(col+6,10);	
		row++;

		ws.mergeCells(col, row, col+1, row);
		ws.addCell(new jxl.write.Label(col, row, rs.getString("ITEM_DESCRIPTION"), ALeftL));
		ws.setColumnView(col,20);
		ws.addCell(new jxl.write.Label(col+2, row, "" , ALeftL));
		ws.setColumnView(col+2,15);	
		ws.addCell(new jxl.write.Label(col+3, row, rs.getString("QUANTITY")+"K" , ALeftL));
		ws.setColumnView(col+3,15);	
		row+=25;		
		
		reccnt++;
	}
	if (reccnt >0)
	{
		col=0;
		ws.mergeCells(col, row, col+3, row);     
		ws.addCell(new jxl.write.Label(col, row,"Director" , ALEFT));
		row++;//列+1
		ws.mergeCells(col, row, col+3, row);     
		ws.addCell(new jxl.write.Label(col, row,"Quality Reliability Assurance" , ALEFT));
		row++;//列+1
		ws.mergeCells(col, row, col+3, row);     
		ws.addCell(new jxl.write.Label(col, row,"Taiwan Semiconductor Co., LTD." , ALEFT));
		row++;//列+1
		ws.mergeCells(col, row, col+1, row);     
		ws.addCell(new jxl.write.Label(col, row,"Tel: 886-02-8913-1588" , ALEFT));
		ws.addCell(new jxl.write.Label(col+4, row,"Signature:" , ARIGHT));
		ws.mergeCells(col+5, row, col+6, row); 
		ws.addCell(new jxl.write.Label(col+5, row,"" , ALeftL1));
		row+=5;//列+1
		ws.mergeCells(col, row, col+6, row);     
		ws.addCell(new jxl.write.Label(col, row,"******The copyright of document and business secret belong to TSC, and no copies should be made without any permission******" ,  ACENTER1));
		row++;//列+1
		ws.mergeCells(col+5, row, col+6, row); 
		ws.addCell(new jxl.write.Label(col+5, row,"(HQ4QC04-A)" ,  ARIGHT1));
		row++;//列+1
	}
	wwb.write(); 
	wwb.close();
	os.close();  
	out.close(); 
	
	rs.close();
	statement.close();

	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();			 
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
	if (reccnt>0)
	{
		response.reset();
		response.setContentType("application/vnd.ms-excel");	
		String strURL = "/oradds/report/"+FileName; 
		response.sendRedirect(strURL);
	}
	else
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無相關資料,請重新確認,謝謝!");
			//this.close();
		</script>
	<%
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage()); 
}
%>
</html>
