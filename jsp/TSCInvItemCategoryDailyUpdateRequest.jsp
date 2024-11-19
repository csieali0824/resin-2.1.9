<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean,CodeUtil,WriteLogToFileBean"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--%@ include file="/jsp/include/ConnBPCSDisttstPoolPage.jsp"%-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Oracle AddsOn System Correction Item Category</title>
</head>
<body>
<A HREF="/Oradds/ORAddsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;<A HREF="../jsp/TSCInvItemCategoryCorrection.jsp"> 料件分類設定</A>&nbsp;&nbsp;<A HREF="../jsp/TSCInvItemCategoryWeeklyAuditReport.jsp"> 料件分類設定異常查詢</A>&nbsp;&nbsp;<BR>
<% 
     String [] choice=request.getParameterValues("CHKFLAG");
     String [] TTDate=request.getParameterValues("TTDATE");      
        
         
     String YearFr=request.getParameter("YEARFR");
     String MonthFr=request.getParameter("MONTHFR");
     String DayFr=request.getParameter("DAYFR");
     String dateStringBegin=YearFr+MonthFr+DayFr;
     String YearTo=request.getParameter("YEARTO");
     String MonthTo=request.getParameter("MONTHTO");
     String DayTo=request.getParameter("DAYTO");
     String dateStringEnd=YearTo+MonthTo+DayTo;    
    
     String dateCurrent = dateBean.getYearMonthDay();
	 String corrKey = "";
	 String organizationId = "";
	 String inventoryItemId = "";
	 String categoryId = "";
	 String categoryCode = "";
	 String segment2 = "";
	 String segment1 = "";
	 //String userName = userID;
	 //userID = userID.toUpperCase(); // 將系統取得之 User Name 轉為大寫
	 
	 String userName = "OF000886";	// 因系統每日自動啟動,故使用者設定為 KERWIN	 
	 String userID = "3077";  // 因系統每日自動啟動,故使用者設定為 KERWIN
	 String respID = "50159"; // 預設值為 TSC_INV_Semi_SU, 判斷若為 Printer Org 則設定為 TSC_INV_Printer_SU = 50158
	 
	 String sqlGlobal="";
     String sWhere=""; 
	 String sOrder="";
     //out.println(sqlGlobal);
    
     String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取文件新增日期時間 //
     String txGetDate = "";      
	 
	 int categoryLength = 0;
	            
%>
<%

   
  try
  {       
       int batchCnt = 0; 
       int recordCnt = 1;
       
	   
	 // 先取 Btach Job 執行人員 ID	 
	 
	sqlGlobal = "select C.ORGANIZATION_ID, I.INVENTORY_ITEM_ID, I.SEGMENT1 || '('||I.INVENTORY_ITEM_ID||')' as SEGMENT1, I.CREATED_BY, TO_CHAR(I.CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') as CREATION_DATE, "+
                       "U.USER_NAME, P.ORGANIZATION_CODE,U.EMAIL_ADDRESS,TO_CHAR(C.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') as LAST_UPDATE_DATE, "+
		               "C.LAST_UPDATED_BY, RPAD(C.ORGANIZATION_ID,3,' ')||RPAD(I.INVENTORY_ITEM_ID,28,' ') as CORRKEY "+
		        "from MTL_ITEM_CATEGORIES C, MTL_SYSTEM_ITEMS_B I, MTL_PARAMETERS P, FND_USER U ";   
    sWhere =  "where C.ORGANIZATION_ID <> 43 AND CATEGORY_SET_ID = 4 AND C.ORGANIZATION_ID = P.ORGANIZATION_ID "+
              "AND C.CATEGORY_ID NOT IN (SELECT CATEGORY_ID FROM CST_COST_GROUP_ASSIGNMENTS G, MTL_FISCAL_CAT_ACCOUNTS M "+
                                       "WHERE G.COST_GROUP_ID=M.COST_GROUP_ID AND G.ORGANIZATION_ID = C.ORGANIZATION_ID) "+
			  "AND C.ORGANIZATION_ID = I.ORGANIZATION_ID AND C.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID "+
			  //"AND I.INVENTORY_ITEM_ID in ('69256','69254') "+
			  "AND (I.LAST_UPDATED_BY = U.USER_ID) "+			  
			  "AND to_char(C.LAST_UPDATE_DATE,'YYYYMMDD') <= '"+dateBean.getYearMonthDay()+"' ";     // 預設進入頁面即將小於今日的異常資料帶出            
    sOrder = "order by C.ORGANIZATION_ID ";

    sqlGlobal = sqlGlobal + sWhere + sOrder;
   
		
	 //out.println("sqlGlobal ="+sqlGlobal);   
	 writeLogToFileBean.setTextString("<table border='1'>");
	 System.out.println(writeLogToFileBean.getTextString());  
	     
     Statement statement=con.createStatement();
     //out.println("sqlGlobal="+sqlGlobal);
     ResultSet rs=statement.executeQuery(sqlGlobal);
     while (rs.next())
     {    
         try
         {
		    Statement stateItem=con.createStatement();
		   
			// 判段目前錯誤的 Categories ID, 並以此做為判斷作分類更新                     
			String sqlGetItem = "select I.SEGMENT1, M.SEGMENT2, M.SEGMENT1 as MSEGMENT1, M.INVENTORY_ITEM_ID, M.ORGANIZATION_ID, M.CATEGORY_ID, M.LAST_UPDATE_DATE, M.LAST_UPDATED_BY FROM MTL_ITEM_CATEGORIES_V M, MTL_SYSTEM_ITEMS I where M.ORGANIZATION_ID = I.ORGANIZATION_ID and M.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID and M.CATEGORY_SET_ID = 4 and M.ORGANIZATION_ID = '"+rs.getString("ORGANIZATION_ID")+"' and M.INVENTORY_ITEM_ID = '"+rs.getString("INVENTORY_ITEM_ID")+"' "; 
			//out.println("sqlGetItem ="+sqlGetItem);
			String cateSegmnt1Name = "";		
				
			 if (batchCnt==0) // 取成功入帳BPCS 批號,當第一筆成功寫入出現時
             { 
               //out.println("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>Oracle Request ID</strong></font></td><td>Org.ID</td><td>Item.ID</td><td>Error CategoryID</td><td>Correct CategoryID</td><td>UserID</td><td>UserName</td><td>LastUpdateTime</td></tr>");   
			   writeLogToFileBean.setTextString("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>("+dateBean.getYearMonthDay()+")成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>Oracle Request ID</strong></font></td><td>Org.ID</td><td>Item.ID</td><td>Error CategoryID</td><td>Correct CategoryID</td><td>UserID</td><td>UserName</td><td>LastUpdateTime</td></tr>");
			   System.out.println(writeLogToFileBean.getTextString());
               // 取成功帳入 BPCS 時所需的 流水號
               batchCnt++;   // 取成功入帳BPCS 批號,當第一筆成功寫入出現時 
             } // end of if (batchCnt =0 ) 取成功入帳BPCS 批號,當第一筆成功寫入出現時	
					   
								   
            ResultSet rsGetItem=stateItem.executeQuery(sqlGetItem);
			if (rsGetItem.next()) 
			{  
			   // 依取到的分類1名稱決定分類代碼
			   cateSegmnt1Name = rsGetItem.getString("MSEGMENT1");
			   // I1 Organization
			   if (rs.getString("ORGANIZATION_ID")=="49" || rs.getString("ORGANIZATION_ID").equals("49"))
			   {    
			        if (cateSegmnt1Name=="Finished Goods" || cateSegmnt1Name.equals("Finished Goods"))
			        { categoryId="260";	categoryCode ="D-Pack,Finished Goods"; }
					else if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials")) 
					     { categoryId="102";	categoryCode ="D-Pack,Materials"; }
						 else if (cateSegmnt1Name=="Semi-Finished Goods" || cateSegmnt1Name.equals("Semi-Finished Goods")) 
						      { categoryId="261";	categoryCode ="D-Pack,Semi-Finished Goods"; }
							  else if (cateSegmnt1Name=="Supplies" || cateSegmnt1Name.equals("Supplies"))
							       { categoryId="262";	categoryCode ="D-Pack,Supplies";}
			   } // I2 Organization
			     else if (rs.getString("ORGANIZATION_ID")=="48" || rs.getString("ORGANIZATION_ID").equals("48")) 
				 { 
					 if (cateSegmnt1Name=="Finished Goods" || cateSegmnt1Name.equals("Finished Goods"))
					 { categoryId="267"; categoryCode ="Sky,Finished Goods"; }
					 else if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
					 { categoryId="268"; categoryCode ="Sky,Materials"; }
				     else if (cateSegmnt1Name=="Semi-Finished Goods" || cateSegmnt1Name.equals("Semi-Finished Goods"))
					 { categoryId="269"; categoryCode ="Sky,Semi-Finished Goods"; }
					 else if (cateSegmnt1Name=="Supplies" || cateSegmnt1Name.equals("Supplies"))
					 { categoryId="270"; categoryCode ="Sky,Supplies"; }
				 }  // I3 Organization 
			     else if (rs.getString("ORGANIZATION_ID")=="46" || rs.getString("ORGANIZATION_ID").equals("46"))
			     {  
				   if (cateSegmnt1Name=="Finished Goods" || cateSegmnt1Name.equals("Finished Goods"))
				   { categoryId="263"; categoryCode ="Printer,Finished Goods"; }
				   else if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
				   { categoryId="264"; categoryCode ="Printer,Materials"; }
				   else if (cateSegmnt1Name=="Semi-Finished Goods" || cateSegmnt1Name.equals("Semi-Finished Goods"))
				   { categoryId="265"; categoryCode ="Printer,Semi-Finished Goods"; }
				   else if (cateSegmnt1Name=="Supplies" || cateSegmnt1Name.equals("Supplies"))
				   { categoryId="266"; categoryCode ="Printer,Supplies"; }
					 respID = "50158"; // 若為 Printer 則設定Responsibility 為 50158
		         }   // I5 Organization 
				 else if (rs.getString("ORGANIZATION_ID")=="190" || rs.getString("ORGANIZATION_ID").equals("190"))
			     {  
				      if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
					  { categoryId="24389"; categoryCode ="Nano,Materials"; }					 
			     }  // I6 Organization 
				 else if (rs.getString("ORGANIZATION_ID")=="163" || rs.getString("ORGANIZATION_ID").equals("163")) 
				 { 
								        if (cateSegmnt1Name=="Finished Goods" || cateSegmnt1Name.equals("Finished Goods"))
								        { categoryId="23775"; categoryCode ="Consignment,Finished Goods"; }
									    else if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
									    { categoryId="23776"; categoryCode ="Consignment,Materials"; }
				 } // I7 Organization
				 else if (rs.getString("ORGANIZATION_ID")=="143" || rs.getString("ORGANIZATION_ID").equals("143"))
				 { 
						    if (cateSegmnt1Name=="Finished Goods" || cateSegmnt1Name.equals("Finished Goods"))
						    { categoryId="22234"; categoryCode ="Internal-Org,Finished Goods"; }							
							else if (cateSegmnt1Name=="Machine Equipment" || cateSegmnt1Name.equals("Machine Equipment"))
							{ categoryId="22232"; categoryCode ="Internal-Org,Machine Equipment"; }
							else if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
							{ categoryId="22235"; categoryCode ="Internal-Org,Materials"; }
							else if (cateSegmnt1Name=="Repairs and Fixation" || cateSegmnt1Name.equals("Repairs and Fixation"))
							{ categoryId="22238"; categoryCode ="Internal-Org,Repairs and Fixation"; }
							else if (cateSegmnt1Name=="Supplies" || cateSegmnt1Name.equals("Supplies"))
							{ categoryId="22237"; categoryCode ="Internal-Org,Supplies"; }							
				} // I8 Organization 
				 else if (rs.getString("ORGANIZATION_ID")=="44" || rs.getString("ORGANIZATION_ID").equals("44"))
			     {  
				      if (cateSegmnt1Name=="Finished Goods" || cateSegmnt1Name.equals("Finished Goods"))
				      { categoryId="22239"; categoryCode ="Drop-Ship,Finished Goods"; }
					  else if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
					  { categoryId="22231"; categoryCode ="Drop-Ship,Materials"; }
					  else if (cateSegmnt1Name=="Semi-Finished Goods" || cateSegmnt1Name.equals("Semi-Finished Goods"))
					  { categoryId="22247"; categoryCode ="Drop-Ship,Semi-Finished Goods"; }
					  
			     } // I9 Organization
				 else if (rs.getString("ORGANIZATION_ID")=="50" || rs.getString("ORGANIZATION_ID").equals("50"))
				 { 
						    if (cateSegmnt1Name=="Finished Goods" || cateSegmnt1Name.equals("Finished Goods"))
						    { categoryId="22234"; categoryCode ="Internal-Org,Finished Goods"; }
							else if (cateSegmnt1Name=="Goods" || cateSegmnt1Name.equals("Goods"))
							{ categoryId="22233"; categoryCode ="Internal-Org,Goods"; }
							else if (cateSegmnt1Name=="Machine Equipment" || cateSegmnt1Name.equals("Machine Equipment"))
							{ categoryId="22232"; categoryCode ="Internal-Org,Machine Equipment"; }
							else if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
							{ categoryId="22235"; categoryCode ="Internal-Org,Materials"; }
							else if (cateSegmnt1Name=="Repairs and Fixation" || cateSegmnt1Name.equals("Repairs and Fixation"))
							{ categoryId="22238"; categoryCode ="Internal-Org,Repairs and Fixation"; }
							else if (cateSegmnt1Name=="Supplies" || cateSegmnt1Name.equals("Supplies"))
							{ categoryId="22237"; categoryCode ="Internal-Org,Supplies"; }							
				} // I10 Organization 
				else if (rs.getString("ORGANIZATION_ID")=="188" || rs.getString("ORGANIZATION_ID").equals("188"))
			    {  
				      if (cateSegmnt1Name=="Finished Goods" || cateSegmnt1Name.equals("Finished Goods"))
				      { categoryId="23775"; categoryCode ="Consignment,Finished Goods"; }
					  else if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
					  { categoryId="23776"; categoryCode ="Consignment,Materials"; }
					  else if (cateSegmnt1Name=="Semi-Finished Goods" || cateSegmnt1Name.equals("Semi-Finished Goods"))
					  { categoryId="23777"; categoryCode ="Consignment,Semi-Finished Goods"; }					  
			    }
			
			    // Step1. 寫入 Item Import API 更新Item Category步驟1. 將錯誤的 Item Category 於Interface 寫入為 'DELETE'
			    String sSqlCateS1="insert into MTL_ITEM_CATEGORIES_INTERFACE(item_number, category_set_id, category_id, process_flag,"+
			                                                                "organization_id , set_process_id, transaction_type) "+
																	"VALUES(?,?,?,?,?,?,?)";			   
			    PreparedStatement stmtCateS1=con.prepareStatement(sSqlCateS1);
			    stmtCateS1.setString(1,rsGetItem.getString("SEGMENT1")); 
				stmtCateS1.setString(2,"4");  
				stmtCateS1.setString(3,rsGetItem.getString("CATEGORY_ID"));
				stmtCateS1.setString(4,"1");
				stmtCateS1.setString(5,rs.getString("ORGANIZATION_ID"));
				stmtCateS1.setString(6,"1");
				stmtCateS1.setString(7,"DELETE");
				stmtCateS1.executeUpdate();
                stmtCateS1.close();
			    
				// Step2. 寫入 Item Import API 更新Item Category步驟2. 將正確的 Item Category 於Interface 寫入為 'CREATE'
			    String sSqlCateS2="insert into MTL_ITEM_CATEGORIES_INTERFACE(item_number, category_set_id, category_id, process_flag,"+
			                                                                "organization_id , set_process_id, transaction_type) "+
																	"VALUES(?,?,?,?,?,?,?)";			   
			    PreparedStatement stmtCateS2=con.prepareStatement(sSqlCateS2);
			    stmtCateS2.setString(1,rsGetItem.getString("SEGMENT1")); 
				stmtCateS2.setString(2,"4");  
				stmtCateS2.setString(3,categoryId);
				stmtCateS2.setString(4,"1");
				stmtCateS2.setString(5,rs.getString("ORGANIZATION_ID"));
				stmtCateS2.setString(6,"1");
				stmtCateS2.setString(7,"CREATE");
				stmtCateS2.executeUpdate();
                stmtCateS2.close();
				      
				
			     //	Step3. 寫入 Item Import API 更新Item Category步驟3. 呼叫 Item Import submit request 的Procedure 並取回 Oracle Request ID	
				 CallableStatement cs3 = con.prepareCall("{call TSC_RUN_ITEM_IMPORT(?,?,?,?,?)}");			 
	             cs3.setString(1,rs.getString("ORGANIZATION_ID"));  /*  Org ID */	
				 cs3.setString(2,"2");  /*  access flag 為修改 */	
				 cs3.setString(3,userID);  /*  user_id 修改人ID */	
				 cs3.setString(4,respID);  /*  使用的Responsibility ID --> TSC_INV_Semi_SU  */	
	             cs3.registerOutParameter(5, Types.INTEGER); 
	             cs3.execute();
                 // out.println("Procedure : Execute Success !!! ");
	             int requestID = cs3.getInt(5);
                 cs3.close();
	 
	             //out.println("Request ID="+requestID);			      
					  
					  organizationId = rsGetItem.getString("ORGANIZATION_ID");
                      inventoryItemId = rsGetItem.getString("INVENTORY_ITEM_ID");                     
					  
					  //out.println("<TR bgcolor='#FFFFCC'><TD><font color='#000099'>"+recordCnt+
                      //"</font></TD><TD><font color='#CC3366'><strong>"+requestID+"</strong></font></TD>"+"<TD>"+rsGetItem.getString("ORGANIZATION_ID")+"</TD>"+"<TD>"+inventoryItemId+"("+rsGetItem.getString("SEGMENT1")+")"+"</TD>"+"<TD>"+rsGetItem.getString("CATEGORY_ID")+"</TD>"+"<TD>"+categoryId+"</TD>"+"<TD>"+userID+"</TD>"+"<TD>"+userName+"</TD>"+"<TD>"+strDateTime+"</TD></TR>");
					  writeLogToFileBean.setTextString("<TR bgcolor='#FFFFCC'><TD><font color='#000099'>"+recordCnt+
                      "</font></TD><TD><font color='#CC3366'><strong>"+requestID+"</strong></font></TD>"+"<TD>"+rsGetItem.getString("ORGANIZATION_ID")+"</TD>"+"<TD>"+inventoryItemId+"("+rsGetItem.getString("SEGMENT1")+")"+"</TD>"+"<TD>"+rsGetItem.getString("CATEGORY_ID")+"</TD>"+"<TD>"+categoryId+"</TD>"+"<TD>"+userID+"</TD>"+"<TD>"+userName+"</TD>"+"<TD>"+strDateTime+"</TD></TR>");
					  System.out.println(writeLogToFileBean.getTextString());
			}  // End of if (rsGetItem.next())
			rsGetItem.close();
			stateItem.close();
              
		 } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }  
		
	 recordCnt++; // 計算更新筆數
		  
     } //End of While 
	 //out.println("</table>");	
	 writeLogToFileBean.setTextString("</table>");
	 out.println(writeLogToFileBean.getTextString());
	 	 
     rs.close();
     statement.close();     

  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());		  
  }
   
  // 設定存檔路徑並存檔
  writeLogToFileBean.setFileName("D:/resin-2.1.9/webapps/oradds/LogFile/TSCInvCategoryFix"+dateBean.getYearMonthDay()+".html");
  writeLogToFileBean.StrSaveToFile();
  

%>

 <input name="YEARFR" type="hidden" value="<%=YearFr%>">
 <input name="MONTHFR" type="hidden" value="<%=MonthFr%>">
 <input name="DAYFR" type="hidden" value="<%=DayFr%>">
 <input name="YEARTO" type="hidden" value="<%=YearTo%>">
 <input name="MONTHTO" type="hidden" value="<%=MonthTo%>">
 <input name="DAYTO" type="hidden" value="<%=DayTo%>">


<%
   //response.sendRedirect("../jsp/RPItemConsumePost2BPCS.jsp?CENTERNO="+centerNo+"&PERSONNO="+personNo+"&REASONCODE="+reasonCode+"&YEARFR="+YearFr+"&MONTHFR="+MonthFr+"&DAYFR="+DayFr+"&YEARTO="+YearTo+"&MONTHTO="+MonthTo+"&DAYTO="+DayTo);	 
%>
</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSDisttstPage.jsp"%-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
