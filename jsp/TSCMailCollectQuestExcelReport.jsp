<!-- 20150119 by Peggy,顯示滿意度調查問題內容-->
<!-- 20180530 by Peggy,comment依設定決定是否顯示-->
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.io.*,jxl.*,jxl.write.*,jxl.format.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean,DateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<html>
<head>
<title>Package Category Download</title>
</head>
<body>
<FORM ACTION="../jsp/TSCMailCollectQuestExcelReport.jsp" METHOD="post" NAME="MYFORM">
<% 
String strYear = request.getParameter("SYEAR");
if (strYear == null) strYear ="";
String terrorty=request.getParameter("TERRORITY");
if (terrorty == null) terrorty = "";
String region=request.getParameter("REGION");
if (region == null) region ="";
String company=request.getParameter("COMPANY");
if (company == null) company ="";
String rdogp = request.getParameter("RDOGP");
if (rdogp == null) rdogp = "ALL";
String v_comment_show="N";
int col=15;
String sheetName = "";
if (rdogp.equals("ALL"))
{
	sheetName  ="All list";
}
else if (rdogp.equals("YES"))
{
	sheetName ="Replied List";
}
else if (rdogp.equals("NO"))
{
	sheetName ="Not Reply List";
}
String ymdCurr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
String hmsCurr = dateBean.getHourMinuteSecond();
String fileName = "D6002_"+ymdCurr+"_"+hmsCurr+".xls";

try
{  
	String sSql =  " select b.* ,decode(b.cnt ,0, '' ,round(b.tot / b.cnt ,2)) avg "+
	        " from (select * from (select a.*,row_number() over (order by a.SYEAR desc,a.TERRORITY,a.COMPANY,to_number(a.id)) rowno "+
	        " from (select b.YEAR || b.BIANNUAL_CODE SYEAR,b.id customer_id, a.ID, b.NAME, b.DEPARTMENT, b.TITLE, b.COMPANY, b.EMAIL, b.TELEPHONE, b.FAX,b.LANGUAGE_VERSION,b.SALES_EMAIL,b.SALES_MANAGER_EMAIL,b.HQ_SALES_EMAIL,b.REGION,b.TERRORITY,  "+
			" a.Q1, a.Q2, a.Q3, a.Q4, a.Q5, a.Q6, a.Q7, a.Q8, a.Q9, a.Q10,a.COMMENTS,"+
			" TO_CHAR(TO_DATE(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD') CREATION_DATE, "+
			" a.orig_rowid,row_number() over (PARTITION BY b.id ORDER BY NVL(a.CREATION_DATE,b.CREATION_DATE) desc) row_num,"+
			" (NVL(a.Q1,0)+NVL(a.Q2,0)+NVL(a.Q3,0)+NVL(a.Q4,0)+NVL(a.Q5,0)+NVL(a.Q6,0)+NVL(a.Q7,0)+NVL(a.Q8,0)+NVL(a.Q9,0)+NVL(a.Q10,0)) tot,"+
			" (NVL2(a.Q1,1,0)+NVL2(a.Q2,1,0)+NVL2(a.Q3,1,0)+NVL2(a.Q4,1,0)+NVL2(a.Q5,1,0)+NVL2(a.Q6,1,0)+NVL2(a.Q7,1,0)+NVL2(a.Q8,1,0)+NVL2(a.Q9,1,0)+NVL2(a.Q10,1,0)) cnt"+
			" from ORADDMAN.CUST_MAIL b"+
			",ORADDMAN.CUST_COLLECT_QUESTIONNAIRE a "+
			" where  b.rowid= a.orig_rowid(+) "+
			" and b.id is not null "+
			" and  b.YEAR is not null "+
			" and b.BIANNUAL_CODE is not null "+
			" and b.ACTIVE_FLAG='Y'";
	if (rdogp.equals("NO"))
	{
      	sSql  +=" AND a.q1 is null  AND a.q2 is null  AND a.q3 is null AND a.q4 is null AND a.q5 is null AND a.q6 is null AND a.q7 is null AND a.q8 is null AND a.q9 is null AND a.q10 is null ";
	}
	if (strYear!=null && !strYear.equals("--") && !strYear.equals("")) sSql += " and b.YEAR||b.BIANNUAL_CODE ='"+strYear+"'"; 	
	if (terrorty!=null && !terrorty.equals("--") && !terrorty.equals("")) sSql +=" and a.TERRORITY ='"+terrorty+"'"; 
	if (region!=null && !region.equals("--") && !region.equals("")) sSql +=" and a.REGION ='"+region+"'"; 
	if (company!=null && !company.equals("--") && !company.equals(""))  sSql +=" and a.COMPANY ='"+company+"' ";
	sSql += ") a where a.row_num=1) b  where 1=1 ";
	if (rdogp.equals("YES"))
	{
		sSql += " and (Q1 is not null or Q2 is not null or Q3 is not null or Q4 is not null or Q5 is not null or Q6 is not null"+
			    " or Q7 is not null or Q8 is not null or Q9 is not null or Q10 is not null)";
	}
	sSql += " ) b order by rowno";
	//out.println("sql="+sSql);
	OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+fileName);

	jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
	jxl.write.WritableSheet ws = wwb.createSheet(sheetName, 0); //sheet name
	jxl.SheetSettings sst = ws.getSettings(); 
	
	// 條件列字型12
	WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), 9, WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE ,jxl.format.Colour.BLACK);
	//jxl.write.WritableFont wf2Cond = new jxl.write.WritableFont(WritableFont.TIMES, 11,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE); 
	//jxl.write.WritableCellFormat wcf2Cond = new jxl.write.WritableCellFormat(wf2Cond); 
	//wcf2Cond.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
   
	// Header 列背景灰色
	//jxl.write.WritableFont wf2Header = new jxl.write.WritableFont(WritableFont.TIMES, 9,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
	//jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(wf2Header); 
	jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(font_bold); 
	wcf2Header.setAlignment(jxl.format.Alignment.LEFT);
	wcf2Header.setVerticalAlignment(jxl.format.VerticalAlignment.TOP);
	wcf2Header.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	wcf2Header.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色
	wcf2Header.setWrap(true);
   
	// 內容 列 定義
	//jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 9,WritableFont.NO_BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
	//jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
	jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(font_bold); 
	wcf2Content.setAlignment(jxl.format.Alignment.CENTRE);
	wcf2Content.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	wcf2Content.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	wcf2Content.setWrap(true);
	
	//jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.ARIAL,10,WritableFont.NO_BOLD, false, UnderlineStyle.NO_UNDERLINE); 
	//jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
	jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(font_bold);
	wcfFL.setAlignment(jxl.format.Alignment.LEFT);
	wcfFL.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	wcfFL.setWrap(true);
	
	//jxl.write.WritableCellFormat wcfFR = new jxl.write.WritableCellFormat(wfL);
	//wcfFR.setAlignment(jxl.format.Alignment.RIGHT);
	jxl.write.WritableCellFormat wcfFR = new jxl.write.WritableCellFormat(font_bold);
	wcfFR.setAlignment(jxl.format.Alignment.RIGHT);
	wcfFR.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	wcfFR.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	wcfFR.setWrap(true);	
	
	//jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfL);
	//wcfFC.setAlignment(jxl.format.Alignment.CENTRE);
	jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(font_bold);
	wcfFC.setAlignment(jxl.format.Alignment.CENTRE);
	wcfFC.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
	wcfFC.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	wcfFC.setWrap(true);
	
	sst.setSelected();
	sst.setVerticalFreeze(1);  //凍結窗格
	sst.setFitToPages(true);	
	sst.setFitWidth(1);        // 設定一頁寬

	// 明細抬頭說明
	jxl.write.Label labelCF99 = new jxl.write.Label(0, 0, "YEAR", wcf2Header); // (行,列)
	ws.addCell(labelCF99);
	ws.setColumnView(0,10);

	jxl.write.Label labelCF0 = new jxl.write.Label(1, 0, "CUSTOMER ID", wcf2Header); // (行,列)
	ws.addCell(labelCF0);
	ws.setColumnView(1,10);
	
	jxl.write.Label labelCF1 = new jxl.write.Label(2, 0, "COMPANY", wcf2Header); // (行,列)
	ws.addCell(labelCF1);
	ws.setColumnView(2,40);		
	
	jxl.write.Label labelCF2 = new jxl.write.Label(3, 0, "DEPARTMENT", wcf2Header); // (行,列)
	ws.addCell(labelCF2);
	ws.setColumnView(3,30);	
	
	jxl.write.Label labelCF3 = new jxl.write.Label(4, 0, "NAME", wcf2Header); // (行,列)
	ws.addCell(labelCF3);
	ws.setColumnView(4,20);
	
	jxl.write.Label labelCF4 = new jxl.write.Label(5, 0, "TITLE", wcf2Header); // (行,列)
	ws.addCell(labelCF4);
	ws.setColumnView(5,40);

	jxl.write.Label labelCF5 = new jxl.write.Label(6, 0, "EMAIL", wcf2Header); // (行,列)
	ws.addCell(labelCF5);
	ws.setColumnView(6,40);

	jxl.write.Label labelCF6 = new jxl.write.Label(7, 0, "TELEPHONE", wcf2Header); // (行,列)
	ws.addCell(labelCF6);
	ws.setColumnView(7,30);

	jxl.write.Label labelCF7 = new jxl.write.Label(8, 0, "FAX", wcf2Header); // (行,列)
	ws.addCell(labelCF7);
	ws.setColumnView(8,30);

	//add by Peggy 20130402
	jxl.write.Label labelCF8 = new jxl.write.Label(9, 0, "REGION", wcf2Header); // (行,列)
	ws.addCell(labelCF8);
	ws.setColumnView(9,10);

	jxl.write.Label labelCF9 = new jxl.write.Label(10, 0, "TERRITORY", wcf2Header); // (行,列)
	ws.addCell(labelCF9);
	ws.setColumnView(10,10);

	if (rdogp.equals("NO"))
	{
		//add by Peggy 20131223
		jxl.write.Label labelCF10 = new jxl.write.Label(11, 0, "Language", wcf2Header); // (行,列)
		ws.addCell(labelCF10);
		ws.setColumnView(11,20);
	
		jxl.write.Label labelCF11 = new jxl.write.Label(12, 0, "Sales Email", wcf2Header); // (行,列)
		ws.addCell(labelCF11);
		ws.setColumnView(12,40);
	
		jxl.write.Label labelCF12 = new jxl.write.Label(13, 0, "Manager Email", wcf2Header); // (行,列)
		ws.addCell(labelCF12);
		ws.setColumnView(13,40);
	
		jxl.write.Label labelCF13 = new jxl.write.Label(14, 0, "HQ Contact Email", wcf2Header); // (行,列)
		ws.addCell(labelCF13);
		ws.setColumnView(14,40);

	}
	else
	{
		//add by Peggy 20131223
		jxl.write.Label labelCF10 = new jxl.write.Label(11, 0, "Language", wcf2Header); // (行,列)
		ws.addCell(labelCF10);
		ws.setColumnView(11,20);
	
		//add by Peggy 20131223
		jxl.write.Label labelCF11 = new jxl.write.Label(12, 0, "Sales Email", wcf2Header); // (行,列)
		ws.addCell(labelCF11);
		ws.setColumnView(12,40);
	
		//add by Peggy 20131223
		jxl.write.Label labelCF12 = new jxl.write.Label(13, 0, "Sales Supervisor Email", wcf2Header); // (行,列)
		ws.addCell(labelCF12);
		ws.setColumnView(13,40);
	
		//add by Peggy 20131223
		jxl.write.Label labelCF13 = new jxl.write.Label(14, 0, "HQ Contact Sales Email", wcf2Header); // (行,列)
		ws.addCell(labelCF13);
		ws.setColumnView(14,40);
	
		//String strQ1="",strQ2="",strQ3="",strQ4="",strQ5="",strQ6="",strQ7="",strQ8="",strQ9="",strQ10="";	
		String Sql = "select QUEST_CODE,TRADITIONAL_CHINESE,QUESTION_TYPE,AUDIT_HIDE_FLAG FROM oraddman.cust_quest_define a where QUEST_CODE like 'Q%' and nvl(AUDIT_HIDE_FLAG,'N')='N' and QUESTION_TYPE in ('QUESTION','COMMENT') order by to_number(QUEST_ID)";
		Statement statement1=con.createStatement(); 
		ResultSet rs1 =statement1.executeQuery(Sql);
		//out.println(Sql);
		while (rs1.next())
		{
			/*
			if (rs1.getString("QUEST_CODE").equals("Q1"))
			{
				strQ1=rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE");
			}
			else if (rs1.getString("QUEST_CODE").equals("Q2"))
			{
				strQ2=rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE");
			}
			else if (rs1.getString("QUEST_CODE").equals("Q3"))
			{
				strQ3=rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE");
			}
			else if (rs1.getString("QUEST_CODE").equals("Q4"))
			{
				strQ4=rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE");
			}
			else if (rs1.getString("QUEST_CODE").equals("Q5"))
			{
				strQ5=rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE");
			}
			else if (rs1.getString("QUEST_CODE").equals("Q6"))
			{
				strQ6=rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE");
			}
			else if (rs1.getString("QUEST_CODE").equals("Q7"))
			{
				strQ7=rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE");
			}
			else if (rs1.getString("QUEST_CODE").equals("Q8"))
			{
				strQ8=rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE");
			}
			else if (rs1.getString("QUEST_CODE").equals("Q9"))
			{
				strQ9=rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE");
			}
			else if (rs1.getString("QUEST_CODE").equals("Q10"))
			{
				strQ10=rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE");
			}
			*/
			if (rs1.getString("QUESTION_TYPE").equals("COMMENT")) v_comment_show="Y";
			ws.addCell(new jxl.write.Label(col, 0, (rs1.getString("QUESTION_TYPE").equals("COMMENT")?"Comment":rs1.getString("QUEST_CODE")+"."+rs1.getString("TRADITIONAL_CHINESE")) , wcf2Header));		
			ws.setColumnView(col,10);
			col++;
		}
		rs1.close();
		statement1.close();
	
		/*
		jxl.write.Label labelCF14 = new jxl.write.Label(15, 0, strQ1, wcf2Header); // (行,列)
		ws.addCell(labelCF14);
		ws.setColumnView(15,5);
	
		jxl.write.Label labelCF15 = new jxl.write.Label(16, 0, strQ2, wcf2Header); // (行,列)
		ws.addCell(labelCF15);
		ws.setColumnView(16,5);
	
		jxl.write.Label labelCF16 = new jxl.write.Label(17, 0, strQ3, wcf2Header); // (行,列)
		ws.addCell(labelCF16);
		ws.setColumnView(17,5);
	
		jxl.write.Label labelCF17 = new jxl.write.Label(18, 0, strQ4,wcf2Header); // (行,列)
		ws.addCell(labelCF17);
		ws.setColumnView(18,5);
	
		jxl.write.Label labelCF18 = new jxl.write.Label(19, 0, strQ5, wcf2Header); // (行,列)
		ws.addCell(labelCF18);
		ws.setColumnView(19,5);
	
		jxl.write.Label labelCF19 = new jxl.write.Label(20, 0, strQ6, wcf2Header); // (行,列)
		ws.addCell(labelCF19);
		ws.setColumnView(20,5);
	
		jxl.write.Label labelCF20 = new jxl.write.Label(21, 0, strQ7, wcf2Header); // (行,列)
		ws.addCell(labelCF20);
		ws.setColumnView(21,5);
	
		jxl.write.Label labelCF21 = new jxl.write.Label(22, 0, strQ8, wcf2Header); // (行,列)
		ws.addCell(labelCF21);
		ws.setColumnView(22,5);
	
		jxl.write.Label labelCF22 = new jxl.write.Label(23, 0, strQ9, wcf2Header); // (行,列)
		ws.addCell(labelCF22);
		ws.setColumnView(23,5);
	
		jxl.write.Label labelCF23 = new jxl.write.Label(24, 0, strQ10, wcf2Header); // (行,列)
		ws.addCell(labelCF23);
		ws.setColumnView(24,5);
	
		//jxl.write.Label labelCF18 = new jxl.write.Label(19, 0, "Q11", wcf2Header); // (行,列)
		//ws.addCell(labelCF18);
		//ws.setColumnView(18,5);
	
		jxl.write.Label labelCF24 = new jxl.write.Label(25, 0, "Comment", wcf2Header); // (行,列)
		ws.addCell(labelCF24);
		ws.setColumnView(25,120);
		*/
	}
	int rowNo = 1;  //第二列開始
	
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sSql); 	
	while (rs.next())
	{	
		jxl.write.Label lable99 = new jxl.write.Label(0, rowNo, rs.getString("SYEAR") , wcfFL);  // (行,列)
		ws.addCell(lable99);	
		  
		jxl.write.Label lable1 = new jxl.write.Label(1, rowNo, rs.getString("CUSTOMER_ID") , wcfFL);  // (行,列)
		ws.addCell(lable1);	
	  
		jxl.write.Label lable2 = new jxl.write.Label(2, rowNo, rs.getString("COMPANY") , wcfFL);  // (行,列)
		ws.addCell(lable2);			  

		jxl.write.Label lable3 = new jxl.write.Label(3, rowNo, rs.getString("DEPARTMENT") , wcfFL); // (行,列);
		ws.addCell(lable3);

		jxl.write.Label lable4 = new jxl.write.Label(4, rowNo, rs.getString("NAME") , wcfFL); // (行,列);
		ws.addCell(lable4);	
				  
		jxl.write.Label lable5 = new jxl.write.Label(5, rowNo, rs.getString("TITLE") , wcfFL); // (行,列); 
		ws.addCell(lable5);
		  
		jxl.write.Label lable6 = new jxl.write.Label(6, rowNo, rs.getString("EMAIL") , wcfFL); // (行,列); 
		ws.addCell(lable6);
		  
		jxl.write.Label lable7 = new jxl.write.Label(7, rowNo, rs.getString("TELEPHONE") , wcfFL); // (行,列); 
		ws.addCell(lable7);

		jxl.write.Label lable8 = new jxl.write.Label(8, rowNo, rs.getString("FAX") , wcfFL); // (行,列); 
		ws.addCell(lable8);

		//add by Peggy 20130402
		jxl.write.Label lable9 = new jxl.write.Label(9, rowNo, rs.getString("REGION") , wcfFL); // (行,列); 
		ws.addCell(lable9);

		//add by Peggy 20130402
		jxl.write.Label lable10 = new jxl.write.Label(10, rowNo, rs.getString("TERRORITY") , wcfFL); // (行,列); 
		ws.addCell(lable10);

	    if (rdogp.equals("NO"))
		{
			//add by Peggy 20131223
			jxl.write.Label lable11 = new jxl.write.Label(11, rowNo, rs.getString("LANGUAGE_VERSION") , wcfFL); // (行,列); 
			ws.addCell(lable11);
		
			jxl.write.Label lable12 = new jxl.write.Label(12, rowNo, rs.getString("SALES_EMAIL") , wcfFL); // (行,列); 
			ws.addCell(lable12);
	
			jxl.write.Label lable13 = new jxl.write.Label(13, rowNo, rs.getString("SALES_MANAGER_EMAIL") , wcfFL); // (行,列); 
			ws.addCell(lable13);
			  
			jxl.write.Label lable14 = new jxl.write.Label(14, rowNo, rs.getString("HQ_SALES_EMAIL") , wcfFL); 
			ws.addCell(lable14);		
		}
		else
		{
			//add by Peggy 20131223
			jxl.write.Label lable11 = new jxl.write.Label(11, rowNo, rs.getString("LANGUAGE_VERSION") , wcfFL); // (行,列); 
			ws.addCell(lable11);
		
			//add by Peggy 20131223
			jxl.write.Label lable12 = new jxl.write.Label(12, rowNo, rs.getString("SALES_EMAIL") , wcfFL); // (行,列); 
			ws.addCell(lable12);
		
			//add by Peggy 20131223
			jxl.write.Label lable13 = new jxl.write.Label(13, rowNo, rs.getString("SALES_MANAGER_EMAIL") , wcfFL); // (行,列); 
			ws.addCell(lable13);
			  
			//add by Peggy 20131223
			jxl.write.Label lable14 = new jxl.write.Label(14, rowNo, rs.getString("HQ_SALES_EMAIL") , wcfFL); 
			ws.addCell(lable14);		
			
			col = 15;
			for (int i_num=1 ; i_num <=10 ; i_num++)
			{
				if (rs.getString("Q"+i_num)==null)
				{
					ws.addCell(new jxl.write.Label(col, rowNo, "" , wcfFR));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, rowNo, Double.valueOf(rs.getString("Q"+i_num)).doubleValue(), wcfFR ));
				}
				col++;
			}
			/*		
			jxl.write.Label lable15 = new jxl.write.Label(15, rowNo, rs.getString("Q1") , wcfFC); // (行,列); 
			ws.addCell(lable15);
	
			jxl.write.Label lable16 = new jxl.write.Label(16, rowNo, rs.getString("Q2") , wcfFC); // (行,列); 
			ws.addCell(lable16);
			  
			jxl.write.Label lable17 = new jxl.write.Label(17, rowNo, rs.getString("Q3") , wcfFC); 
			ws.addCell(lable17);		
					  
			jxl.write.Label lable18 = new jxl.write.Label(18, rowNo, rs.getString("Q4") , wcfFC); 
			ws.addCell(lable18);	
	
			jxl.write.Label lable19 = new jxl.write.Label(19, rowNo, rs.getString("Q5") , wcfFC); 
			ws.addCell(lable19);	
	
			jxl.write.Label lable20 = new jxl.write.Label(20, rowNo, rs.getString("Q6") , wcfFC); 
			ws.addCell(lable20);	
	
			jxl.write.Label lable21 = new jxl.write.Label(21, rowNo, rs.getString("Q7") , wcfFC); 
			ws.addCell(lable21);	
	
			jxl.write.Label lable22 = new jxl.write.Label(22, rowNo, rs.getString("Q8") , wcfFC); 
			ws.addCell(lable22);	
	
			jxl.write.Label lable23 = new jxl.write.Label(23, rowNo, rs.getString("Q9") , wcfFC); 
			ws.addCell(lable23);	
	
			jxl.write.Label lable24 = new jxl.write.Label(24, rowNo, rs.getString("Q10") , wcfFC); 
			ws.addCell(lable24);	
			*/
			//jxl.write.Label lable19 = new jxl.write.Label(19, rowNo, rs.getString("Q11") , wcfFC); 
			//ws.addCell(lable19);	
	
			if (v_comment_show.equals("Y"))
			{
				jxl.write.Label lable25 = new jxl.write.Label(25, rowNo, rs.getString("comments") , wcfFL); 
				ws.addCell(lable25);	
			}
		}
		rowNo ++;
	}
	
	rs.close();
	statement.close();

	//寫入Excel 
	wwb.write(); 
	wwb.close();
	os.close(); 
	out.close(); 
} //end of try
catch (Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
 %>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
   	response.reset();
    response.setContentType("application/vnd.ms-excel");					
    response.sendRedirect("/oradds/report/"+fileName); 
%>
</html>

