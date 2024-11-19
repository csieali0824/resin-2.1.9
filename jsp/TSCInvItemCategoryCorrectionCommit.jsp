<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean,CodeUtil,TelnetBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--%@ include file="/jsp/include/ConnBPCSDisttstPoolPage.jsp"%-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<jsp:useBean id="telnetBean" scope="page" class="TelnetBean"/>

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
     String sqlGlobal=request.getParameter("SQLGLOBAL");    

     String tTicketNo=request.getParameter("TTICKETNO");
     String toLine=request.getParameter("TOLINE");
     String txDate=request.getParameter("TXDATE");
     String txTime=request.getParameter("TXTIME");
     String tCom=request.getParameter("TCOM");
     
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
	 String userName = userID;	 
	 userID = userID.toUpperCase(); // 將系統取得之 User Name轉為大寫
	 
	 String respID = "50159"; // 預設值為 TSC_INV_Semi_SU 
	 
       
     //out.println(sqlGlobal);
    
     String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取文件新增日期時間 //
     String txGetDate = "";      
	 
	 int categoryLength = 0;
	            
%>
<%
  try
  {  
     String tItemNo = "";
     int txQty = 0; 
	 String tItemNo2 = "";
       int txQty2 = 0; 
     String toLine2 = "";      
       int batchCnt = 0; 
       int failCnt = 0; 
     String bpBatchNo = ""; //
	 
	 // 先取 Btach Job 執行人員 ID, 否則設為 Kerwin = 3077
	 
	                  Statement stateUser=con.createStatement();
		              String sqlUser = "select USER_ID from FND_USER where USER_NAME = '"+userID+"' "; 
					  ResultSet rsUser=stateUser.executeQuery(sqlUser); 
					  if (rsUser.next()) 
					  { userID = rsUser.getString("USER_ID"); }
					  else { userID = "3077"; }
					  rsUser.close();
					  stateUser.close(); 
	 // 先取 Btach Job 執行人員 ID
	 
		
	 out.println("<table border='1'>");   
	        
     Statement statement=con.createStatement();
     //out.println("sqlGlobal="+sqlGlobal);
     ResultSet rs=statement.executeQuery(sqlGlobal);
     while (rs.next())
     { 
      for (int j=0;j<choice.length ;j++)    
      { 
        txGetDate = choice[j];      
      }
      //out.println("txGetDate.substring(0,3)="+txGetDate.substring(0,3).trim());           
      //out.println("txGetDate.substring(6,14)="+txGetDate.substring(6,14));     
      for (int k=0;k<choice.length ;k++)    
      { 
       corrKey = rs.getString("CORRKEY");
       inventoryItemId = rs.getString("INVENTORY_ITEM_ID");
       
       //out.println("choice[k]="+choice[k]);  
	   
	   categoryLength = choice[k].length(); // 取字串總長度;
	   
       if ( (rs.getString("CORRKEY").substring(0,3)==txGetDate.substring(0,3) && rs.getString("INVENTORY_ITEM_ID")==txGetDate.substring(3,27).trim() ) || (rs.getString("CORRKEY").substring(0,3).equals(txGetDate.substring(0,3)) && rs.getString("INVENTORY_ITEM_ID").equals( txGetDate.substring(3,27).trim() ) ) ) 
       { 
	     //out.println("<font color='#CC3366'>choice OK ="+choice[k]+"</font>"); 
		 
		 try
         {
		    Statement stateItem=con.createStatement();
		   
			//String sqlGetItem = "select M.INVENTORY_ITEM_ID, M.ORGANIZATION_ID, M.CATEGORY_ID, M.LAST_UPDATE_DATE, M.LAST_UPDATED_BY FROM MTL_ITEM_CATEGORIES M where M.CATEGORY_SET_ID = 4 and M.ORGANIZATION_ID = '"+choice[k].substring(0,3).trim()+"' and M.INVENTORY_ITEM_ID = '"+choice[k].substring(3,27).trim()+"' "; // 2005/10/11 更新由 Item Categories API 作分類更新                     
			String sqlGetItem = "select I.SEGMENT1, M.SEGMENT2, M.SEGMENT1 as MSEGMENT1, M.INVENTORY_ITEM_ID, M.ORGANIZATION_ID, M.CATEGORY_ID, M.LAST_UPDATE_DATE, M.LAST_UPDATED_BY FROM MTL_ITEM_CATEGORIES_V M, MTL_SYSTEM_ITEMS I where M.ORGANIZATION_ID = I.ORGANIZATION_ID and M.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID and M.CATEGORY_SET_ID = 4 and M.ORGANIZATION_ID = '"+choice[k].substring(0,3).trim()+"' and M.INVENTORY_ITEM_ID = '"+choice[k].substring(3,27).trim()+"' "; 
			//out.println("sqlGetItem ="+sqlGetItem);
			String cateSegmnt1Name = "";
			
			
				
			 if (batchCnt==0) // 取成功入帳BPCS 批號,當第一筆成功寫入出現時
             { 
               out.println("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>Oracle Request ID</strong></font></td><td>Org.ID</td><td>Item.ID</td><td>Error CategoryID</td><td>Correct CategoryID</td><td>UserID</td><td>UserName</td><td>LastUpdateTime</td></tr>");   
               // 取成功帳入 BPCS 時所需的 流水號
               batchCnt++;   // 取成功入帳BPCS 批號,當第一筆成功寫入出現時 
             } // end of if (batchCnt =0 ) 取成功入帳BPCS 批號,當第一筆成功寫入出現時	
					   
								   
            ResultSet rsGetItem=stateItem.executeQuery(sqlGetItem);
			if (rsGetItem.next()) 
			{  
			   // 依取到的分類1名稱決定分類代碼
			   cateSegmnt1Name = rsGetItem.getString("MSEGMENT1");
			   // I1 Organization
			   if (choice[k].substring(0,3).trim()=="49" || choice[k].substring(0,3).trim().equals("49"))
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
			     else if (choice[k].substring(0,3).trim()=="48" || choice[k].substring(0,3).trim().equals("48")) 
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
			     else if (choice[k].substring(0,3).trim()=="46" || choice[k].substring(0,3).trim().equals("46"))
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
				 else if (choice[k].substring(0,3).trim()=="190" || choice[k].substring(0,3).trim().equals("190"))
			     {  
				      if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
					  { categoryId="24389"; categoryCode ="Nano,Materials"; }					 
			     }  // I6 Organization 
				 else if (choice[k].substring(0,3).trim()=="163" || choice[k].substring(0,3).trim().equals("163")) 
				 { 
								        if (cateSegmnt1Name=="Finished Goods" || cateSegmnt1Name.equals("Finished Goods"))
								        { categoryId="23775"; categoryCode ="Consignment,Finished Goods"; }
									    else if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
									    { categoryId="23776"; categoryCode ="Consignment,Materials"; }
				 } // I7 Organization
				 else if (choice[k].substring(0,3).trim()=="143" || choice[k].substring(0,3).trim().equals("143"))
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
				 else if (choice[k].substring(0,3).trim()=="44" || choice[k].substring(0,3).trim().equals("44"))
			     {  
				      if (cateSegmnt1Name=="Finished Goods" || cateSegmnt1Name.equals("Finished Goods"))
				      { categoryId="22239"; categoryCode ="Drop-Ship,Finished Goods"; }
					  else if (cateSegmnt1Name=="Materials" || cateSegmnt1Name.equals("Materials"))
					  { categoryId="22231"; categoryCode ="Drop-Ship,Materials"; }
					  else if (cateSegmnt1Name=="Semi-Finished Goods" || cateSegmnt1Name.equals("Semi-Finished Goods"))
					  { categoryId="22247"; categoryCode ="Drop-Ship,Semi-Finished Goods"; }
					  
			     } // I9 Organization
				 else if (choice[k].substring(0,3).trim()=="50" || choice[k].substring(0,3).trim().equals("50"))
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
				else if (choice[k].substring(0,3).trim()=="188" || choice[k].substring(0,3).trim().equals("188"))
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
				stmtCateS1.setString(5,choice[k].substring(0,3).trim());
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
				stmtCateS2.setString(5,choice[k].substring(0,3).trim());
				stmtCateS2.setString(6,"1");
				stmtCateS2.setString(7,"CREATE");
				stmtCateS2.executeUpdate();
                stmtCateS2.close();
				
				      
				
			    //	Step3. 寫入 Item Import API 更新Item Category步驟3. 呼叫 Item Import submit request 的Procedure 並取回 Oracle Request ID	
				 CallableStatement cs3 = con.prepareCall("{call TSC_RUN_ITEM_IMPORT(?,?,?,?,?)}");			 
	             cs3.setString(1,choice[k].substring(0,3).trim());  /*  Org ID */	
				 cs3.setString(2,"2");  /*  access flag 為修改 */	
				 cs3.setString(3,userID);  /*  user_id 修改人ID */	
				 cs3.setString(4,respID);  /*  使用的Responsibility ID --> TSC_INV_Semi_SU  */	
	             cs3.registerOutParameter(5, Types.INTEGER); 
	             cs3.execute();
                 // out.println("Procedure : Execute Success !!! ");
	             int requestID = cs3.getInt(5);
                 cs3.close();
	 
	             //out.println("Request ID="+requestID);
			
			    /*
			
			          String sSqPostN="update MTL_ITEM_CATEGORIES set CATEGORY_ID=?,LAST_UPDATED_BY=?, LAST_UPDATE_DATE=TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM-DD AM HH:MI:SS'),'YYYY/MM/DD AM HH:MI:SS') where ORGANIZATION_ID ='"+choice[k].substring(0,3).trim()+"' and INVENTORY_ITEM_ID='"+choice[k].substring(3,27).trim()+"' and CATEGORY_ID = '"+rsGetItem.getString("CATEGORY_ID")+"' ";   
                      //out.println("sSqPostN="+sSqPostN);
                      PreparedStatement stmtPostN=con.prepareStatement(sSqPostN); 
                      stmtPostN.setString(1,choice[k].substring(27,categoryLength));  					  
					  Statement stateUser=con.createStatement();
		              String sqlUser = "select USER_ID from FND_USER where USER_NAME = '"+userID+"' "; 
					  ResultSet rsUser=stateUser.executeQuery(sqlUser); 
					  if (rsUser.next()) 
					  { userID = rsUser.getString("USER_ID"); }
					  else { userID = "3077"; }
					  rsUser.close();
					  stateUser.close();           
					  stmtPostN.setString(2,userID);      
                      stmtPostN.executeUpdate();
                      stmtPostN.close();
                */       
					  
					  organizationId = rsGetItem.getString("ORGANIZATION_ID");
                      inventoryItemId = rsGetItem.getString("INVENTORY_ITEM_ID");                     
					  
					  out.println("<TR bgcolor='#FFFFCC'><TD>"+
                      "<a href='../jsp/RPIssueAPPReportPrint.jsp?RPTXCOM="+rsGetItem.getString("ORGANIZATION_ID")+" '>"+                       
		              "<div align='center'><img src='../image/docicon.gif' width='14' height='15' border='0'></div></a></TD><TD><font color='#CC3366'><strong>"+requestID+"</strong></font></TD>"+"<TD>"+rsGetItem.getString("ORGANIZATION_ID")+"</TD>"+"<TD>"+inventoryItemId+"</TD>"+"<TD>"+rsGetItem.getString("CATEGORY_ID")+"</TD>"+"<TD>"+categoryId+"</TD>"+"<TD>"+userID+"</TD>"+"<TD>"+userName+"</TD>"+"<TD>"+strDateTime+"</TD></TR>");
			}
			rsGetItem.close();
			stateItem.close();
              
		 } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }  
	  
    
       }  // end of if      
      } // End of for (k)  
	  
     } //End of While 
	 out.println("</table>");
	
	 
     rs.close();
     statement.close();
     

  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());		  
  } 

%>
<!--%   
  
%-->
<!--%    // ### Call store procedure for INV500 SMG POST 2 BPCS### //
  
 // ####### Call store procedure for INV500 SMG POST 2 BPCS  ###### //
  try
  {

   String tItemNo2 = "";
       int txQty2 = 0; 
   String toLine2 = "";      
       int batchCnt = 0; 
       int failCnt = 0; 
   String bpBatchNo = ""; //
      
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery(sqlGlobal);
   while (rs.next())
   {
    for (int j=0;j<choice.length ;j++)    
    { 
        txGetDate = choice[j];      
    }
   
    for (int k=0;k<choice.length ;k++)    
    { 
     if (  (rs.getString("CORRKEY").substring(0,3)==txGetDate.substring(0,3) && rs.getString("INVENTORY_ITEM_ID")==txGetDate.substring(3,27).trim() ) || (rs.getString("CORRKEY").substring(0,3).equals(txGetDate.substring(0,3)) && rs.getString("INVENTORY_ITEM_ID").equals( txGetDate.substring(3,27).trim() ) )  ) 
     { 
      	
       try
       {
          Statement stateItem=con.createStatement();
		  String sqlGetItem = "select ORGANIZATION_ID, INVENTORY_ITEM_ID, CATEGORY_ID, SEGMENT2, SEGMENT1 from MTL_ITEM_CATEGORIES_V where CATEGORY_SET_ID = 4 and TO_CHAR(LAST_UPDATE_DATE,'YYYYMMDDHH24MISS') = '"+strDateTime+"' and LAST_UPDATED_BY ='"+userID+"' ";
          //String sqlGetItem = "select trim(TITEMNO) as TITEMNO, abs(TXQTY) as TXQTY, TOLINE, TCOM, TTICKETNO, TORDER from RPITEM_TXHIST_T where TXDATE>='20040524' and TXPERSONLOC='"+rs.getString("TXPERSONLOC").substring(0,6)+"' and TXTYPE='I' and TXACTIVE = 'Y' and TXDATE='"+txGetDate.substring(6,14)+"' ";//out.println("sqlGetItem2="+sqlGetItem);
          ResultSet rsGetItem=stateItem.executeQuery(sqlGetItem);  
          while (rsGetItem.next())
          { //out.println("Step2.5=");
            organizationId = rsGetItem.getString("ORGANIZATION_ID");
            inventoryItemId = rsGetItem.getString("INVENTORY_ITEM_ID"); 
            categoryId = rsGetItem.getString("CATEGORY_ID"); 
			segment2 = 	rsGetItem.getString("SEGMENT2");	
			segment1 = 	rsGetItem.getString("SEGMENT1");	 
            
            if (organizationId!=null && inventoryItemId != null)
            { //out.println("Step5=");// Update Repair System POST FLAG TO INVALID  //			               
                 
                 out.println("<TR bgcolor='#FFFFCC'><TD>"+
                            "<a href='../jsp/RPIssueAPPReportPrint.jsp?RPTXCOM="+rsGetItem.getString("ORGANIZATION_ID")+" '>"+                       
		                    " <div align='center'><img src='../image/docicon.gif' width='14' height='15' border='0'></div></a></TD><TD>"+rsGetItem.getString("ORGANIZATION_ID")+"</TD>"+"<TD>"+inventoryItemId+"</TD>"+"<TD>"+categoryId+"</TD>"+"<TD>"+segment2+"</TD>"+"<TD>"+segment1+"</TD>"+"<TD>"+strDateTime+"</TD></TR>");
             }  // End of If
             else  // 帳入BPCS SMG作業失敗,請查明原因
             {
                 failCnt++;  // 累加失敗筆數

        
                 if (failCnt==1)
                 {      
                  //out.println("<font color='#FF0000'>維修帳自動入BPCS SMG作業失敗 !</font><BR><font color='#000099'>請連絡IT查明原因</font><font color='#000099'> [ 單號</font>=<font color='#FF0000'>"+rs.getString("TTICKETNO")+"</font> "+"<font color='#000099'>料號</font>=<font color='#FF0000'>"+rs.getString("TITEMNO")+ "</font> " +"<font color='#000099'>領料單號</font>=<font color='#FF0000'>"+rs.getString("TCOM")+"</font><font color='#000099'> ]</font>" );                
                  out.println("<table border='0' cellpadding='1' cellspacing='1'><tr bgcolor='#FF0000'><td colspan='7'><font color='#FFFFFF'>失敗項次清單--請連絡IT查明原因</font></td></tr><tr bgcolor='#FF0000'><td>&nbsp;</td><td>單據編號</td><td>項次</td><td>料號</td><td>數量</td><td>異動日期時間</td><td>單號</td></tr>");  
                 }
                 out.println("<TR bgcolor='#FF0000'><TD>"+
                            "<a href='../jsp/RPIssueAPPReportPrint.jsp?RPTXCOM=  '>"+                       
		                    " <div align='center'><img src='../image/docicon.gif' width='14' height='15' border='0'></div></a></TD><TD>"+rsGetItem.getString("ORGANIZATION_ID")+"</TD>"+"<TD>"+inventoryItemId+"</TD>"+"<TD>"+categoryId+"</TD>"+"<TD>"+categoryId+"</TD>"+"<TD>"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"</TD>"+"<TD>"+dateBean.getHourMinuteSecond()+"</TD></TR>");     
                 out.println("</table>");

              }  // end of else
       // rsIth.close();
        // statement2.close();

     }   // end of while rsItemGet.next()    
   //  rsGetItem.close();
  //   stateItem.close();
     arrayListCheckBoxBean.setArrayString(null);  // 清空 array 內的值 //               
     } //end of try
     catch (Exception e)
     {
          out.println("Exception:"+e.getMessage());		  
     } // end of try catch
	 
   
      
     }  // End of if (k==rs.getStrin())
    }  // end of for (k)
 
        

   }  // End of While

   batchCnt++;   // 取成功入帳BPCS 批號,當第一筆成功寫入出現時

   out.println("</table>");
   out.println("<BR>");

   rs.close();
   statement.close();
  }
  catch(Exception e)
  {
   System.out.println(e);
  }
 
%-->

 <input name="YEARFR" type="hidden" value="<%=YearFr%>">
 <input name="MONTHFR" type="hidden" value="<%=MonthFr%>">
 <input name="DAYFR" type="hidden" value="<%=DayFr%>">
 <input name="YEARTO" type="hidden" value="<%=YearTo%>">
 <input name="MONTHTO" type="hidden" value="<%=MonthTo%>">
 <input name="DAYTO" type="hidden" value="<%=DayTo%>">

 <input name="TTICKETNO" type="hidden" value="<%=tTicketNo%>">
 <input name="TOLINE" type="hidden" value="<%=toLine%>">
 <input name="TXTIME" type="hidden" value="<%=txTime%>">
 <input name="TCOM" type="hidden" value="<%=tCom%>">
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