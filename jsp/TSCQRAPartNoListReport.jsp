<!--20150626 by Peggy,PDN 報表抬頭異動-->
<!--20171116 Peggy,show "New TSC P/N" column when query type=TSC P/N list-->
<!--20180705 by Peggy,PDN 報表抬頭異動-->
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
<FORM ACTION="../jsp/TSCQRAPartNoListReport.jsp" METHOD="post" name="MYFORM">
<%
String serverHostName=request.getServerName();
String QNO = request.getParameter("QNO");
if (QNO==null) QNO="";
String QUERYTYPE = request.getParameter("QUERYTYPE");
if (QUERYTYPE==null) QUERYTYPE="1";
String FileName="",RPTName="",ColumnName="",DEPTNAME="",sql="",where="";
int fontsize=9,colcnt=0;
int row =0,col=0,totcnt=0,reccnt=0,chg_cnt=0,mo_cnt=0,rfq_cnt=0,merge_line=0,line=0,mergeCol=0;
try 
{ 	
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();

	sql = " select c.PCN_NUMBER from oraddman.tsqra_pcn_item_header c"+
		  " where (c.PCN_NUMBER='"+QNO+"' or c.SEQUENCE_ID='"+ QNO+"')";
	//out.println(sql);
	Statement statement3=con.createStatement();
	ResultSet rs3=statement3.executeQuery(sql);
	if (rs3.next())
	{
		QNO = rs3.getString(1);
	}
	else
	{
		QNO = "";
	}
	rs3.close();
	statement3.close(); 
	
	if (!QNO.equals(""))
	{	
		String column1="",column2="",column3="",column4="",column5="";
		OutputStream os = null;	
		if (QUERYTYPE.equals("1"))
		{
			RPTName = QNO+"_involved customer order list";
		}
		else if (QUERYTYPE.equals("2"))
		{
			RPTName = QNO+"_involved P-N list";
		}
		FileName = RPTName+"_"+dateBean.getYearMonthDay()+dateBean.getHourMinute();
		if (serverHostName.equals("devap.ts.com.tw") || serverHostName.equals("prodap.ts.com.tw"))
		{ // For Unix Platform
			os = new FileOutputStream("/data/resin-2.1.9/webapps/oradds/report/"+FileName+".xls");
		}  
		else 
		{ 
		
			os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+FileName+".xls");
		}
		WritableWorkbook wwb = Workbook.createWorkbook(os); 
		if (QUERYTYPE.equals("1"))
		{
			sql = " select distinct b.TERRITORY from oraddman.tsqra_pcn_item_detail b ,oraddman.tsqra_pcn_item_header c"+
				  " where b.PCN_NUMBER(+)=c.PCN_NUMBER"+
				  " and (c.PCN_NUMBER='"+QNO+"' or c.SEQUENCE_ID='"+ QNO+"')"+
				  " and b.SOURCE_TYPE='1'"+
				  " ORDER BY 1";
			//out.println(sql);
			Statement statement2=con.createStatement();
			ResultSet rs2=statement2.executeQuery(sql);
			int sheet_cnt =0;
			while (rs2.next())
			{
				wwb.createSheet(rs2.getString("TERRITORY"), sheet_cnt);
				sheet_cnt++;
			}
			rs2.close();
			statement2.close(); 
		}
		else if (QUERYTYPE.equals("2"))
		{
			//wwb.createSheet(RPTName, 0);
			wwb.createSheet(QNO, 0); //modify by Peggy 20140514
		}
		WritableSheet ws = null;
		//WritableSheet ws = wwb.createSheet(RPTName, 0); 
		//SheetSettings sst = ws.getSettings(); 
		
		//公司名稱中文平行置中     
		WritableCellFormat wCompCName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 16 ,WritableFont.BOLD,false));   
		wCompCName.setAlignment(jxl.format.Alignment.CENTRE);
			
		//公司名稱英文平行置中     
		WritableCellFormat wCompEName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 16 ,WritableFont.BOLD,false));   
		wCompEName.setAlignment(jxl.format.Alignment.CENTRE);
		wCompEName.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);

		//公司名稱英文平行置中     
		WritableCellFormat wCompEName1 = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 14 ,WritableFont.BOLD,false));   
		wCompEName1.setAlignment(jxl.format.Alignment.CENTRE);
		
		//地址中文行置中     
		WritableCellFormat wAddrCName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 8,WritableFont.BOLD,false));     
		wAddrCName.setAlignment(jxl.format.Alignment.CENTRE);
		
		//地址英文平行置中     
		WritableCellFormat wAddrEName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 8,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		wAddrEName.setAlignment(jxl.format.Alignment.CENTRE);
				
		//電話平行置中     
		WritableCellFormat wTelName = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), 8,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		wTelName.setAlignment(jxl.format.Alignment.CENTRE);
				
		//報表名稱平行置中    
		WritableCellFormat wRptName = new WritableCellFormat(new WritableFont(WritableFont.createFont("標楷體"), 14, WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		wRptName.setAlignment(jxl.format.Alignment.CENTRE);
		
		//英文內文水平垂直置左  
		WritableCellFormat ARIGHT = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize,  WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ARIGHT.setAlignment(jxl.format.Alignment.RIGHT);
			
		//英文內文水平垂直置中-粗體-格線-底色灰-字體黑   
		WritableCellFormat ACenterBL = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.WHITE));   
		ACenterBL.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBL.setBackground(jxl.write.Colour.SEA_GREEN); 
		ACenterBL.setWrap(true);
	
		//英文內文水平垂直置中-粗體-格線-底色灰-字體紅   
		WritableCellFormat ACenterBLR = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.RED));   
		ACenterBLR.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLR.setBackground(jxl.write.Colour.SEA_GREEN); 
		ACenterBLR.setWrap(true);
		
		//英文內文水平垂直置中-粗體-格線-底色藍  
		WritableCellFormat ACenterBLB = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterBLB.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLB.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLB.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLB.setBackground(jxl.write.Colour.PALE_BLUE); 
		ACenterBLB.setWrap(true);	
	
		//英文內文水平垂直置中-粗體-格線-底色橘
		WritableCellFormat ACenterBLO = new WritableCellFormat(new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK));   
		ACenterBLO.setAlignment(jxl.format.Alignment.CENTRE);
		ACenterBLO.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
		ACenterBLO.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		ACenterBLO.setBackground(jxl.write.Colour.LIGHT_ORANGE); 
		ACenterBLO.setWrap(true);	
	
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
			
		if (QUERYTYPE.equals("1"))
		{
			sql = " select distinct c.PCN_NUMBER,b.TSC_PART_NO \"TSC P/N\" "+
				  ",b.MARKET_GROUP"+
				  ",b.CUST_SHORT_NAME customer_name"+
				  ",b.TERRITORY"+
				  ",b.CUST_PART_NO \"CUST P/N\""+
				  ",to_char(to_date(c.S_ACT_SHIP_DATE,'YYYYMMDD'),'YYYY-MON-DD') S_ACT_SHIP_DATE"+
				  ",to_char(to_date(c.E_ACT_SHIP_DATE,'YYYYMMDD'),'YYYY-MON-DD') E_ACT_SHIP_DATE"+
				  ",to_char(c.CREATION_DATE,'yyyymmdd') creation_date"+ //add by Peggy 20231013
				  " from oraddman.tsqra_pcn_item_detail b ,oraddman.tsqra_pcn_item_header c"+
				  " where b.PCN_NUMBER(+)=c.PCN_NUMBER"+
				  //" and c.PCN_NUMBER='"+QNO+"'"+
				  " and (c.PCN_NUMBER='"+QNO+"' or c.SEQUENCE_ID='"+ QNO+"')"+
				  " and b.SOURCE_TYPE='1'"+
				  //" and b.UPD_VERSION_ID=9999"+
				  " ORDER BY 1,5,2,4";
				  
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			String territory ="";
			while (rs.next())
			{
				if (!territory.equals(rs.getString("territory")))
				{
					if (reccnt >0)
					{
						col=0;
						ws.mergeCells(col, row, col+4, row);     
						//ws.addCell(new jxl.write.Label(col, row,"****** The copyright of document and business secret belong to TSC, and no copies should be made without any permission ******" , wTelName));
						ws.addCell(new jxl.write.Label(col, row,"****** This document contains TSC business confidential information. Further distribution should not be made without TSC permission ******" , wTelName)); //modify by Peggy 20150714
						row++;//列+1
					}
					territory=rs.getString("territory");
					ws = wwb.getSheet(territory);
					SheetSettings settings = ws.getSettings(); 
					settings.setSelected();	
					settings.setScaleFactor(60);   // 打印縮放比例
					settings.setHeaderMargin(0.3);
					settings.setBottomMargin(0.3);
					settings.setLeftMargin(0.2);
					settings.setRightMargin(0.2);
					settings.setTopMargin(0.3);
					settings.setFooterMargin(0.3);										
					reccnt =0;
				}
				if (reccnt==0)
				{
					col=0;row=0;
					
					//logo
					jxl.write.WritableImage image = new jxl.write.WritableImage(col,row,col+1.5,row+1, new File("..//resin-2.1.9//webapps/oradds/jsp/images/logo.png")); 
					ws.addImage(image); 
				
					//String strCTitle = "台 灣 半 導 體 股 份 有 限 公 司";
					//ws.mergeCells(col, row, col+4, row);     
					//ws.addCell(new jxl.write.Label(col, row,strCTitle , wCompCName));
					//ws.setColumnView(col,60);	
					//row++;//列+1
					
					//String strETitle = "Taiwan Semiconductor Company limited";
					String strETitle = "Taiwan Semiconductor Co., Ltd.";
					ws.setRowView(row,650);
					ws.mergeCells(col, row, col+4, row);    
					ws.addCell(new jxl.write.Label(col, row,strETitle , wCompEName));
					row++;//列+1
							
					//String strCAddr = "新北市新店區北新路三段205號11樓";
					//ws.mergeCells(col, row, col+4, row);     
					//ws.addCell(new jxl.write.Label(col, row,strCAddr , wAddrCName));
					//row++;//列+1		
							
					String strEAddr = "11Fl.,No,205,Sec.3,Beishin Rd., Xindian Dist., New Taipei City 231, Taiwan";
					ws.mergeCells(col, row, col+4, row);     
					ws.addCell(new jxl.write.Label(col, row,strEAddr , wAddrEName));
					row++;//列+1	
					
					String strTelInfo = "Tel: 886-2-8913-1588, Fax: 886-2-8913-1788";
					ws.mergeCells(col, row, col+4, row);     
					ws.addCell(new jxl.write.Label(col, row,strTelInfo , wTelName));
					row++;//列+1	
					row++;//列+1
	
					//String strRPTtitle = QNO+"_Involved customer order list";
					String strRPTtitle = "PCNPDNIN_Involved customer order list";
					ws.mergeCells(col, row, col+4, row);     
					ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wCompEName1));
					row++;//列+1
				
					ws.mergeCells(col+3, row, col+4, row);     
					if (Integer.parseInt(rs.getString("creation_date"))<=20231031)
					{
						ws.addCell(new jxl.write.Label(col+3, row,"Period of Shipment:"+rs.getString("S_ACT_SHIP_DATE")+" ~ "+ rs.getString("E_ACT_SHIP_DATE"),ARIGHT));					
					}
					else
					{
						ws.addCell(new jxl.write.Label(col+3, row,"Period of Ordered:"+rs.getString("S_ACT_SHIP_DATE")+" ~ "+ rs.getString("E_ACT_SHIP_DATE"),ARIGHT));
					}
					row++;//列+1
				
					//ws.addCell(new jxl.write.Label(col, row, "QPCN/QPDN Number" , ACenterBL));
					//ws.setColumnView(col,20);
					//col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "TSC P/N" , ACenterBL));
					ws.setColumnView(col,20);	
					col++;	
					
					ws.addCell(new jxl.write.Label(col, row, "Territory" , ACenterBL));
					ws.setColumnView(col,20);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "Customer P/N" , ACenterBL));
					ws.setColumnView(col,30);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "Customer Name" , ACenterBL));
					ws.setColumnView(col,40);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "Market Group" , ACenterBL));
					ws.setColumnView(col,20);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "Inform customer date/reason for not inform" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	

					ws.addCell(new jxl.write.Label(col, row, "Customer feedback comment" , ACenterBL));
					ws.setColumnView(col,15);	
					col++;	
					row++;
				}
				col=0;
				//ws.addCell(new jxl.write.Label(col, row, rs.getString("PCN_NUMBER") , ALeftL));
				//ws.setColumnView(col,20);
				//col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC P/N") , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("TERRITORY")==null?"":rs.getString("TERRITORY")) , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, (rs.getString("CUST P/N")==null?"N/A":rs.getString("CUST P/N")) ,ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("customer_name") , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("market_group") , ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, "" , ACenterL));
				col++;	
				row++;
				reccnt++;
				totcnt++;
			}
			if (reccnt >0)
			{
				col=0;
				ws.mergeCells(col, row, col+4, row);     
				//ws.addCell(new jxl.write.Label(col, row,"****** The copyright of document and business secret belong to TSC, and no copies should be made without any permission ******" , wTelName));
				ws.addCell(new jxl.write.Label(col, row,"****** This document contains TSC business confidential information. Further distribution should not be made without TSC permission ******" , wTelName)); //modify by Peggy 20150714
				row++;//列+1
			}
			wwb.write(); 
			wwb.close();
			os.close();  
			out.close(); 
			
			rs.close();
			statement.close();
		}
		else if (QUERYTYPE.equals("2"))
		{
			sql = " select distinct c.PCN_NUMBER,b.TSC_PART_NO \"TSC P/N\" "+
				  ",b.TSC_PROD_GROUP PROD_GROUP"+
				  ",b.TSC_PACKAGE PACKAGE"+
				  ",b.TSC_FAMILY FAMILY"+
				  ",b.DATE_CODE"+
				  ",c.PCN_TYPE"+  //add by Peggy 20140331
				  ",b.REPLACE_PART_NO"+ //add by Peggy 20171116				  
				  " from oraddman.tsqra_pcn_item_detail b ,oraddman.tsqra_pcn_item_header c"+
				  " where b.PCN_NUMBER(+)=c.PCN_NUMBER"+
				  //" and c.PCN_NUMBER='"+QNO+"'"+
				  " and (c.PCN_NUMBER='"+QNO+"' or c.SEQUENCE_ID='"+ QNO+"')"+
				  " and b.SOURCE_TYPE='2'"+
				  " ORDER BY 1,5,4";
	
			//out.println(sql);
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			String territory ="";
			while (rs.next())
			{
				if (reccnt==0)
				{
					ws = wwb.getSheet(0);
					SheetSettings settings = ws.getSettings(); 
					settings.setSelected();	
					settings.setScaleFactor(85);   // 打印縮放比例
					settings.setHeaderMargin(0.3);
					settings.setBottomMargin(0.3);
					settings.setLeftMargin(0.2);
					settings.setRightMargin(0.2);
					settings.setTopMargin(0.3);
					settings.setFooterMargin(0.3);						
					col=0;row=0;
					//logo
					jxl.write.WritableImage image = new jxl.write.WritableImage(col,row,col+1,row+1, new File("..//resin-2.1.9//webapps/oradds/jsp/images/logo.png")); 
					ws.addImage(image); 
				
					//String strCTitle = "台 灣 半 導 體 股 份 有 限 公 司";
					//ws.mergeCells(col, row, col+3, row);     
					//ws.addCell(new jxl.write.Label(col, row,strCTitle , wCompCName));
					//ws.setColumnView(col,60);	
					//row++;//列+1
					
					//String strETitle = "Taiwan Semiconductor Company limited";
					String strETitle = "Taiwan Semiconductor Co., Ltd.";
					ws.setRowView(row,650);
					ws.mergeCells(col, row, col+3, row);     
					ws.addCell(new jxl.write.Label(col, row,strETitle , wCompEName));
					row++;//列+1
							
					//String strCAddr = "新北市新店區北新路三段205號11樓";
					//ws.mergeCells(col, row, col+3, row);     
					//ws.addCell(new jxl.write.Label(col, row,strCAddr , wAddrCName));
					//row++;//列+1		
							
					String strEAddr = "11Fl.,No,205,Sec.3,Beishin Rd., Xindian Dist., New Taipei City 231, Taiwan";
					ws.mergeCells(col, row, col+3, row);     
					ws.addCell(new jxl.write.Label(col, row,strEAddr , wAddrEName));
					row++;//列+1	
					
					String strTelInfo = "Tel: 886-2-8913-1588, Fax: 886-2-8913-1788";
					ws.mergeCells(col, row, col+3, row);     
					ws.addCell(new jxl.write.Label(col, row,strTelInfo , wTelName));
					row++;//列+1	
					row++;//列+1
	
					//String strRPTtitle = QNO+"_Involved P/N list";
					String strRPTtitle = "PCNPDNIN_Involved P/N list";
					ws.mergeCells(col, row, col+3, row);     
					ws.addCell(new jxl.write.Label(col, row,strRPTtitle ,wCompEName1));
					row++;//列+1
				
					//ws.addCell(new jxl.write.Label(col, row, "QPCN/QPDN Number" , ACenterBL));
					//ws.setColumnView(col,20);	
					//col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "Family" , ACenterBL));
					ws.setColumnView(col,25);	
					col++;	
		
					ws.addCell(new jxl.write.Label(col, row, "Package" , ACenterBL));
					ws.setColumnView(col,25);	
					col++;	
		
					//mark by Peggy 20180705
					//add by Peggy 20150626
					//if (rs.getString("PCN_TYPE").equals("PDN"))
					//{
					//	ws.addCell(new jxl.write.Label(col, row, "Obsolete TSC P/N" , ACenterBL));
					//	ws.setColumnView(col,40);
					//	col++;
	                //
					//	ws.addCell(new jxl.write.Label(col, row, "Recommended Replacement TSC P/N" , ACenterBL));
					//	ws.setColumnView(col,25);
					//	col++;
					//}
					//else
					//{
						//ws.mergeCells(col, row, col+1, row);
						ws.addCell(new jxl.write.Label(col, row, "TSC P/N" , ACenterBL));
						ws.setColumnView(col,40);
						col++;
						
						//add by Peggy 20150714
						ws.addCell(new jxl.write.Label(col, row, "New TSC P/N" , ACenterBL));
						ws.setColumnView(col,25);
						col++;	
					//}	
		
					//if (rs.getString("PCN_TYPE").equals("PCN"))  //add by Peggy 20140331
					//{
					//	ws.addCell(new jxl.write.Label(col, row, "Expected Date Code" , ACenterBL));
					//}
					//ws.setColumnView(col,30);
					//col++;
					row++;
				}
				col=0;
				//ws.addCell(new jxl.write.Label(col, row, rs.getString("PCN_NUMBER") , ACenterL));
				//ws.setColumnView(col,20);	
				//col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("FAMILY") , ALeftL));
				col++;	
				ws.addCell(new jxl.write.Label(col, row, rs.getString("PACKAGE") , ALeftL));
				col++;	
				//mark by Peggy 20180705
				//add by Peggy 20150626
				//if (rs.getString("PCN_TYPE").equals("PDN"))
				//{
				//	ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC P/N") , ALeftL));
				//	col++;
				//	ws.addCell(new jxl.write.Label(col, row,  (rs.getString("REPLACE_PART_NO")==null?"":rs.getString("REPLACE_PART_NO")) , ALeftL));
				//	col++;
				//}
				//else
				//{
					//ws.mergeCells(col, row, col+1, row);
					ws.addCell(new jxl.write.Label(col, row, rs.getString("TSC P/N") , ALeftL));
					col++;
					//add by Peggy 20150714
					ws.addCell(new jxl.write.Label(col, row, (rs.getString("REPLACE_PART_NO")==null?"":rs.getString("REPLACE_PART_NO")) , ALeftL));
					col++;
				//}
				//if (rs.getString("PCN_TYPE").equals("PCN"))  //add by Peggy 20140331
				//{
				//	ws.addCell(new jxl.write.Label(col, row, rs.getString("DATE_CODE") , ALeftL));
				//}	
				//ws.setColumnView(col,30);
				//col++;	
				row++;
				reccnt++;
				totcnt++;
			}
			if (reccnt >0)
			{
				col=0;
				ws.mergeCells(col, row, col+3, row);     
				//ws.addCell(new jxl.write.Label(col, row,"****** The copyright of document and business secret belong to TSC, and no copies should be made without any permission ******" , wTelName));
				ws.addCell(new jxl.write.Label(col, row,"****** This document contains TSC business confidential information. Further distribution should not be made without TSC permission ******" , wTelName)); //modify by Peggy 20150714
				row++;//列+1
			}
			wwb.write(); 
			wwb.close();
			os.close();  
			out.close(); 
			
			rs.close();
			statement.close();
		}
		String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
		PreparedStatement pstmt2=con.prepareStatement(sql2);
		pstmt2.executeUpdate(); 
		pstmt2.close();		
	}	 
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
		String strURL = "/oradds/report/"+FileName+".xls"; 
		response.sendRedirect(strURL);
	}
	else
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("系統查無資料,請洽詢台北Judy或PM確認原因,謝謝!");
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
