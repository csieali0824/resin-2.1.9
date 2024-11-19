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
<FORM ACTION="../jsp/TSCMailCollectQuestFollowupExcelReport.jsp" METHOD="post" NAME="MYFORM1">
<% 
String strYear = request.getParameter("SYEAR");
if (strYear == null) strYear ="";
String terrorty=request.getParameter("TERRORITY");
if (terrorty == null) terrorty = "";
String region=request.getParameter("REGION");
if (region == null) region ="";
String company=request.getParameter("COMPANY");
if (company == null) company ="";
int col=0,row=0;
String sheetName = "sheet1";
String ymdCurr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
String hmsCurr = dateBean.getHourMinuteSecond();
String fileName = "D6002_Followup_"+ymdCurr+"_"+hmsCurr+".xls";

try
{  
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
	col=0;row=0;
	
	// 明細抬頭說明
	ws.addCell(new jxl.write.Label(col, row, "YEAR", wcf2Header));
	ws.setColumnView(col,10);
	col++;

	ws.addCell(new jxl.write.Label(col, row, "CUSTOMER ID", wcf2Header));
	ws.setColumnView(col,10);
	col++;
	
	ws.addCell(new jxl.write.Label(col, row, "COMPANY", wcf2Header));
	ws.setColumnView(col,25);		
	col++;
	
	ws.addCell(new jxl.write.Label(col, row, "TERRITORY", wcf2Header));
	ws.setColumnView(col,10);
	col++;
	
	ws.addCell(new jxl.write.Label(col, row, "NAME", wcf2Header));
	ws.setColumnView(col,20);
	col++;
	
	ws.addCell(new jxl.write.Label(col, row, "Close Date", wcf2Header));
	ws.setColumnView(col,10);
	col++;
	
	ws.addCell(new jxl.write.Label(col, row, "Question", wcf2Header));
	ws.setColumnView(col,30);
	col++;	

	ws.addCell(new jxl.write.Label(col, row, "Score", wcf2Header));
	ws.setColumnView(col,15);
	col++;	

	ws.addCell(new jxl.write.Label(col, row, "What/Event", wcf2Header));
	ws.setColumnView(col,30);
	col++;	

	ws.addCell(new jxl.write.Label(col, row, "Where/Plant", wcf2Header));
	ws.setColumnView(col,30);
	col++;	

	ws.addCell(new jxl.write.Label(col, row, "Who/Issue Owner", wcf2Header));
	ws.setColumnView(col,30);
	col++;	

	ws.addCell(new jxl.write.Label(col, row, "When/When happened", wcf2Header));
	ws.setColumnView(col,30);
	col++;	

	ws.addCell(new jxl.write.Label(col, row, "Why/Happened reason", wcf2Header));
	ws.setColumnView(col,30);
	col++;	

	ws.addCell(new jxl.write.Label(col, row, "How/Solution", wcf2Header));
	ws.setColumnView(col,30);
	col++;	

	ws.addCell(new jxl.write.Label(col, row, "Result", wcf2Header));
	ws.setColumnView(col,30);
	col++;	

	ws.addCell(new jxl.write.Label(col, row, "Attached Evidence", wcf2Header));
	ws.setColumnView(col,30);
	col++;row++;

	String sSql =  " select b.* ,rowid from ORADDMAN.CUST_MAIL b"+
			       " where b.id is not null "+
      			   " and  b.YEAR is not null "+
   			       " and b.BIANNUAL_CODE is not null "+
   			       " and b.ACTIVE_FLAG='Y'";
	if (strYear!=null && !strYear.equals("--") && !strYear.equals("")) sSql += " and b.YEAR||b.BIANNUAL_CODE ='"+strYear+"'"; 	
	if (terrorty!=null && !terrorty.equals("--") && !terrorty.equals("")) sSql +=" and a.TERRORITY ='"+terrorty+"'"; 
	if (region!=null && !region.equals("--") && !region.equals("")) sSql +=" and a.REGION ='"+region+"'"; 
	if (company!=null && !company.equals("--") && !company.equals(""))  sSql +=" and a.COMPANY ='"+company+"' ";
	sSql +=" order by b.YEAR||b.BIANNUAL_CODE,b.TERRORITY,b.NAME";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sSql); 	
	while (rs.next())
	{	

		sSql =" SELECT QUEST_CODE,QUESTION "+
              " ,NVL((select case WHEN a.QUEST_CODE ='Q1' THEN Q1 "+
              " WHEN a.QUEST_CODE ='Q2' THEN Q2 "+
              " WHEN a.QUEST_CODE ='Q3' THEN Q3 "+
              " WHEN a.QUEST_CODE ='Q4' THEN Q4 "+
              " WHEN a.QUEST_CODE ='Q5' THEN Q5 "+
              " WHEN a.QUEST_CODE ='Q6' THEN Q6 "+
              " WHEN a.QUEST_CODE ='Q7' THEN Q7 "+
              " WHEN a.QUEST_CODE ='Q8' THEN Q8 "+
              " WHEN a.QUEST_CODE ='Q9' THEN Q9 "+
              " WHEN a.QUEST_CODE ='Q10' THEN Q10 "+
              " WHEN a.QUEST_CODE ='Q11' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q11)"+
              " WHEN a.QUEST_CODE ='Q12' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q12)"+
              " WHEN a.QUEST_CODE ='Q13' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q13)"+
              " WHEN a.QUEST_CODE ='Q14' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q14)"+
              " WHEN a.QUEST_CODE ='Q15' THEN DECODE( a.OBJ_TYPE,'textarea', COMMENTS, Q15) END "+
              " from oraddman.cust_collect_questionnaire c "+
			  " where customer_id='"+rs.getString("id")+"' "+
		      " and c.year='"+rs.getString("year")+"'"+
			  " and c.BIANNUAL_CODE='"+rs.getString("BIANNUAL_CODE")+"'"+"),0) AS SCORE_LEVEL"+
			  " ,OBJ_TYPE"+
			  " ,FONT_SIZE"+
			  " ,ALIGN_TYPE"+
			  " ,FONT_STYLE"+
			  " ,a.QUESTION_TYPE"+
			  " ,to_char((SELECT followup_closed_date from oraddman.cust_collect_questionnaire c "+
			  " where c.customer_id='"+rs.getString("id")+"' "+
		      " and c.year='"+rs.getString("year")+"'"+
			  " and c.BIANNUAL_CODE='"+rs.getString("BIANNUAL_CODE")+"'),'yyyy/mm/dd') followup_closed_date"+
			  " ,b.*"+
              " from oraddman.cust_quest_define a"+
			  " ,(select QUESTION_NO,question_what qu1, question_where qu2, question_who qu3, question_when qu4, question_why qu5, question_solution qu6, question_result qu7, attachment_id, last_update_date, remote_addr from oraddman.cust_questionnaire_trace where customer_id='"+rs.getString("id")+"' and year='"+rs.getString("year")+"' and biannual_code='"+rs.getString("BIANNUAL_CODE")+"') b"+
              " WHERE SUBSTR(a.QUEST_CODE,1,1) NOT IN ('A','B') "+
              " AND SUBSTR(a.QUEST_CODE,1,2) NOT IN ('Q0') "+
			  " AND a.QUEST_CODE LIKE 'Q%' "+
			  " AND NVL(a.AUDIT_HIDE_FLAG,'N')='N'"+ 
			  " AND DECODE( a.OBJ_TYPE,'textarea', 'comment',a.QUEST_CODE) = b.QUESTION_NO(+)"+ 
              " ORDER BY DECODE(SUBSTR(a.QUEST_CODE,1,1),'X',1,'C',2,3),TO_NUMBER(a.QUEST_ID) ";	
		//out.println(sSql);	
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(sSql); 	
		while (rs1.next())
		{	
			col=0;
			ws.addCell(new jxl.write.Label(col, row, rs.getString("YEAR")+rs.getString("BIANNUAL_CODE") , wcfFL));
			col++;	
			  
			ws.addCell(new jxl.write.Label(col, row, rs.getString("ID") , wcfFL));	
			col++;	
		  
			ws.addCell(new jxl.write.Label(col, row, rs.getString("COMPANY") , wcfFL));			  
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("TERRORITY") , wcfFL));
			col++;	
	
			ws.addCell(new jxl.write.Label(col, row, rs.getString("NAME") , wcfFL));	
			col++;	
			
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("followup_closed_date") , wcfFL));	
			col++;	
						
			ws.addCell(new jxl.write.Label(col, row, rs1.getString("QUEST_CODE")+"."+rs1.getString("QUESTION") , wcfFL));	
			col++;				
				
			if (rs1.getString("QUESTION_TYPE").equals("QUESTION"))
			{  
				if (rs1.getString("SCORE_LEVEL")==null)
				{
					ws.addCell(new jxl.write.Label(col, row, "" , wcfFR));
				}
				else
				{
					ws.addCell(new jxl.write.Number(col, row, Double.valueOf(rs1.getString("SCORE_LEVEL")).doubleValue(), wcfFR ));
				}
			}
			else if (rs1.getString("QUESTION_TYPE").equals("COMMENT")) 
			{
				ws.addCell(new jxl.write.Label(col, row, rs1.getString("SCORE_LEVEL"), wcfFL));
			}
			col++;
			
			for (int i_num=1 ; i_num <=7 ; i_num++)
			{	
				ws.addCell(new jxl.write.Label(col, row, rs1.getString("QU"+i_num) , wcfFL));	
				col++;	
			}	
			ws.addCell(new jxl.write.Label(col, row,"", wcfFL));	
			col++;			
			//String rootName1 = "http://tsrfq.ts.com.tw:8080/oradds/jsp/CustomerQuestion_Attache/"+rs.getString("id")+rs.getString("rowid")+(rs1.getString("QUESTION_TYPE").toLowerCase().equals("comment")?"comment":rs1.getString("QUEST_CODE"));
			//String rootName = "/jsp/CustomerQuestion_Attache/"+rs.getString("id")+rs.getString("rowid")+(rs1.getString("QUESTION_TYPE").toLowerCase().equals("comment")?"comment":rs1.getString("QUEST_CODE"));
			/*String rootPath = application.getRealPath(rootName);
			String filelist ="";
			File fp = new File(rootPath);
			if (fp.exists()) 
			{
				String[] list = fp.list();
				if (list.length > 0)
				{
					for(int i=0; i<list.length;i++)
					{
						File inFp = new File(rootPath + File.separator + list[i]);
						filelist += "<a href='.."+rootName1+"/"+list[i]+"' target='_blank'>"+list[i]+"</a>\r\n";
					}
				}
			}
			ws.addCell(new jxl.write.Label(col, row, filelist , wcfFL));
			*/
	    	//WritableHyperlink hlk =new WritableHyperlink(col,row, new File(rootName1),"r4r projects");        
			//new WritableHyperlink(0, currentSheet - 1 + NUMBER_OF_ROWS_IN_TITLE, names[currentSheet], workbook.getSheet(currentSheet), 0, 0);  
			//ws.addCell(new jxl.write.Label(col, row,"<a href='.."+rootName1+"' target='_blank'>download</a>", wcfFL));
	   		//ws.addHyperlink(new WritableHyperlink(col, row,  new File(".."+rootName1), "home page")); 
			
			//WritableHyperlink link = new WritableHyperlink(12, i, new URL("file://\\10.0.3.16\resin-2.1.9\webapps\oradds\jsp\CustomerQuestion_Attache\1193AAIQTgAK5AAALl2AAUcomment"));
			
			//String formu = "HYPERLINK(\"\\\10.0.3.16\\resin-2.1.9\\webapps\\oradds\\jsp\\CustomerQuestion_Attache\\1193AAIQTgAK5AAALl2AAUcomment\",\"folder\")";
			//Formula formula = new Formula(col, row, formu);
			//ws.addCell(formula);

			col++;						
			row++;
		}
		rs1.close();
		statement1.close();
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

