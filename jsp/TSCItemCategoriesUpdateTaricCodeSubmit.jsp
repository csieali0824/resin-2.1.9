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
<A HREF="/Oradds/ORAddsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;<A HREF="../jsp/TSCItemCategoriesUpdateTaricCode.jsp"> 料件TaricCode分類設定</A>&nbsp;&nbsp;<BR>
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
	 
	 String sqlGlobal=request.getParameter("SQLGLOBAL");
	 String prodClass=request.getParameter("PRODCLASS");
     String sWhere=""; 
	 String sOrder="";
     //out.println(sqlGlobal);
    
     String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取文件新增日期時間 //
     String txGetDate = "";      
	 
	 int categoryLength = 0;
	 
	 String taricCode = "";
	 String invTaricCode = "";
	            
%>
<%

   
  try
  {       
       int batchCnt = 0; 
       int recordCnt = 1;
       
	   
	 // 先取 Btach Job 執行人員 ID	
	if (sqlGlobal==null || sqlGlobal.equals(""))  // For 每日自動啟動更新之Schedule Job
	{ 
	 sqlGlobal = "select C.ORGANIZATION_ID, C.CATEGORY_ID, I.ATTRIBUTE2, I.INVENTORY_ITEM_ID, I.SEGMENT1 || '('||I.INVENTORY_ITEM_ID||')' as SEGMENT1, I.SEGMENT1 as ITEMNO, "+
                        "I.CREATED_BY, TO_CHAR(I.CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') as CREATION_DATE, "+
                        "U.USER_NAME, P.ORGANIZATION_CODE,U.EMAIL_ADDRESS,TO_CHAR(C.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') as LAST_UPDATE_DATE, "+
				        "C.LAST_UPDATED_BY, RPAD(C.ORGANIZATION_ID,3,' ')||RPAD(I.INVENTORY_ITEM_ID,28,' ') as CORRKEY "+
		         "from MTL_ITEM_CATEGORIES C, MTL_SYSTEM_ITEMS I, MTL_PARAMETERS P, FND_USER U ";
        sWhere = "where C.ORGANIZATION_ID = 43 AND CATEGORY_SET_ID = 6 AND C.ORGANIZATION_ID = P.ORGANIZATION_ID "+
                 //"AND C.CATEGORY_ID NOT IN (SELECT CATEGORY_ID FROM CST_COST_GROUP_ASSIGNMENTS G, MTL_FISCAL_CAT_ACCOUNTS M "+
                 //                           "WHERE G.COST_GROUP_ID=M.COST_GROUP_ID AND G.ORGANIZATION_ID = C.ORGANIZATION_ID) "+
			     "AND C.ORGANIZATION_ID = I.ORGANIZATION_ID AND C.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID "+			  
			     "AND (I.LAST_UPDATED_BY = U.USER_ID) "+		
				 "AND I.ATTRIBUTE2 IS NULL "+	  
			     "AND to_char(C.LAST_UPDATE_DATE,'YYYYMMDD') <= '"+dateBean.getYearMonthDay()+"' ";     // 預設進入頁面即將小於今日的異常資料帶出            
        sOrder =   "order by C.ORGANIZATION_ID ";
	 
      if (prodClass==null || prodClass.equals(""))  sWhere=sWhere+" and I.SEGMENT1 IS NULL ";
      else if (prodClass.substring(0,2)=="01" || prodClass.substring(0,2).equals("01"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,1,1) in ('0','1','2','3','4','5','6','7','8') ";
      else if (prodClass.substring(0,2)=="02" || prodClass.substring(0,2).equals("02"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) in ('AI','VR','PW') ";
      else if (prodClass.substring(0,2)=="03" || prodClass.substring(0,2).equals("03"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) in ('SR','LR','LD','UL','CL') ";
      else if (prodClass.substring(0,2)=="04" || prodClass.substring(0,2).equals("04"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) ='TR' ";
      else if (prodClass.substring(0,2)=="05" || prodClass.substring(0,2).equals("05"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) ='MF' ";
      else if (prodClass.substring(0,2)=="06" || prodClass.substring(0,2).equals("06"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) ='AC' ";
      else if (prodClass.substring(0,2)=="07" || prodClass.substring(0,2).equals("07"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 12 and  substr(I.SEGMENT1,1,2) = '10' ";
      sqlGlobal = sqlGlobal + sWhere + sOrder;
	} 
   
		
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
		   // Statement stateItem=con.createStatement();
		   
			// 判段目前錯誤的 Categories ID, 並以此做為判斷作分類更新                     
			//String sqlGetItem = "select I.SEGMENT1, M.SEGMENT2, M.SEGMENT1 as MSEGMENT1, M.INVENTORY_ITEM_ID, M.ORGANIZATION_ID, M.CATEGORY_ID, M.LAST_UPDATE_DATE, M.LAST_UPDATED_BY FROM MTL_ITEM_CATEGORIES_V M, MTL_SYSTEM_ITEMS I where M.ORGANIZATION_ID = I.ORGANIZATION_ID and M.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID and M.CATEGORY_SET_ID = 4 and M.ORGANIZATION_ID = '"+rs.getString("ORGANIZATION_ID")+"' and M.INVENTORY_ITEM_ID = '"+rs.getString("INVENTORY_ITEM_ID")+"' "; 
			//out.println("sqlGetItem ="+sqlGetItem);
			//String cateSegmnt1Name = "";		
				
			 if (batchCnt==0) // 取成功入帳BPCS 批號,當第一筆成功寫入出現時
             { 
               //out.println("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>Oracle Request ID</strong></font></td><td>Org.ID</td><td>Item.ID</td><td>Error CategoryID</td><td>Correct CategoryID</td><td>UserID</td><td>UserName</td><td>LastUpdateTime</td></tr>");   
			   writeLogToFileBean.setTextString("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>("+dateBean.getYearMonthDay()+")成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>成品分類</strong></font></td><td>Org.ID</td><td>Item.ID</td><td>Category ID</td><td>Taric Code</td><td>UserID</td><td>UserName</td><td>LastUpdateTime</td></tr>");
			   System.out.println(writeLogToFileBean.getTextString());
               // 取成功帳入 BPCS 時所需的 流水號
               batchCnt++;   // 取成功入帳BPCS 批號,當第一筆成功寫入出現時 
             } // end of if (batchCnt =0 ) 取成功入帳BPCS 批號,當第一筆成功寫入出現時	
					   
								   
          
			
			   // 半導體類 Taric Code = 8541100000
			   if (prodClass.substring(0,2)=="01" || prodClass.substring(0,2).equals("01"))
			   {    
			     taricCode = "8541100000";
				 invTaricCode = "Diodes-"+taricCode;
			      
			   } // IC二極體 Taric Code = 8542293000 ( AI、 VR 、 TW )
			   else if (prodClass.substring(0,2)=="02" || prodClass.substring(0,2).equals("02"))
			   { 
				  taricCode = "8542293000"; 
				  invTaricCode = "Diodes - "+taricCode;
				 }  // IC線性穩壓器 Taric Code = 8542295000  ( SR、LR、LD、UL、CL )
			     else if (prodClass.substring(0,2)=="03" || prodClass.substring(0,2).equals("03"))
			     {  
				   taricCode = "8542295000";
				   invTaricCode = "Linear Voltage Regulator - "+taricCode;
		         }   // IC電晶體 Taric Code = 8541210000 ( TR )
				 else if (prodClass.substring(0,2)=="04" || prodClass.substring(0,2).equals("04"))
			     {  
				    taricCode = "8541210000"; 				
					invTaricCode = "Transistor - "+taricCode; 
			     }  // IC場效電晶體 Taric Code = 8541290001  ( MF )
				 else if (prodClass.substring(0,2)=="05" || prodClass.substring(0,2).equals("05"))
				 { 
					taricCode = "8541290001";
					invTaricCode = "Mosfets - "+taricCode;    
				 } // IC運算放大器 Taric Code = 8542293000 ( AC )  
				 else if (prodClass.substring(0,2)=="06" || prodClass.substring(0,2).equals("06"))
				 { 
					taricCode = "8542293000";   
					invTaricCode = "Operational Amplifier - "+taricCode;  
				 } // 晶圓 Taric Code = 8542293000 
				 else if (prodClass.substring(0,2)=="07" || prodClass.substring(0,2).equals("07"))
			     {  
				     taricCode = "8542293000"; 
					 invTaricCode = "PWM and PFC - "+taricCode;
			     }  
			    
			
			    // Step1.步驟1 更新料件主檔Item Taric Code(Attribute2). 於MTL_SYSTEM_ITEMS 表格Attribute2欄(設定彈性欄位)
			    String sSqlCateS1="update MTL_SYSTEM_ITEMS set ATTRIBUTE2 = ? "+
			                      "where INVENTORY_ITEM_ID = '"+rs.getString("INVENTORY_ITEM_ID")+"' ";																			   
			    PreparedStatement stmtCateS1=con.prepareStatement(sSqlCateS1);
			    stmtCateS1.setString(1,taricCode); 				
				stmtCateS1.executeUpdate();
                stmtCateS1.close();
			  /*  
				// Step2.步驟2. 判斷TSC_CCCODE表格內相同Category ID,若CCCODE攔位為空值,則取料件對應的Taric Code作更新
				  Statement stateItem=con.createStatement();
		   
			      // 判段目前錯誤的 Categories ID, 並以此做為判斷作分類更新                     
			      String sqlGetItem = "select CATEGORY_ID from TSC_CCCODE where CATEGORY_ID = '"+rs.getString("CATEGORY_ID")+"' and  ( CCCODE IS NULL or CCCODE = '')  "; 
			      //out.println("sqlGetItem ="+sqlGetItem);
			      ResultSet rsGetItem=stateItem.executeQuery(sqlGetItem);
			      if (rsGetItem.next()) 
			      {   
				    
			        String sSqlCateS2="update TSC_CCCODE set CCCODE=? "+
								      "where CATEGORY_ID = '"+rs.getString("CATEGORY_ID")+"' and ( CCCODE IS NULL or CCCODE = '') ";			   
			        PreparedStatement stmtCateS2=con.prepareStatement(sSqlCateS2);
			        stmtCateS2.setString(1,invTaricCode); 				   
				    stmtCateS2.executeUpdate();
                    stmtCateS2.close();
				      
				  }
				  rsGetItem.close();
				  stateItem.close();
				*/  
			   
	 
	             //out.println("Request ID="+requestID);			      
					  
					  organizationId = rs.getString("ORGANIZATION_ID");
                      inventoryItemId = rs.getString("INVENTORY_ITEM_ID");                     
					  
					  //out.println("<TR bgcolor='#FFFFCC'><TD><font color='#000099'>"+recordCnt+
                      //"</font></TD><TD><font color='#CC3366'><strong>"+requestID+"</strong></font></TD>"+"<TD>"+rsGetItem.getString("ORGANIZATION_ID")+"</TD>"+"<TD>"+inventoryItemId+"("+rsGetItem.getString("SEGMENT1")+")"+"</TD>"+"<TD>"+rsGetItem.getString("CATEGORY_ID")+"</TD>"+"<TD>"+categoryId+"</TD>"+"<TD>"+userID+"</TD>"+"<TD>"+userName+"</TD>"+"<TD>"+strDateTime+"</TD></TR>");
					  writeLogToFileBean.setTextString("<TR bgcolor='#FFFFCC'><TD><font color='#000099'>"+recordCnt+
                      "</font></TD><TD><font color='#CC3366'><strong>"+prodClass+"</strong></font></TD>"+"<TD>"+rs.getString("ORGANIZATION_ID")+"</TD>"+"<TD>"+inventoryItemId+"("+rs.getString("SEGMENT1")+")"+"</TD>"+"<TD>"+rs.getString("CATEGORY_ID")+"</TD>"+"<TD>"+invTaricCode+"</TD>"+"<TD>"+userID+"</TD>"+"<TD>"+userName+"</TD>"+"<TD>"+strDateTime+"</TD></TR>");
					  System.out.println(writeLogToFileBean.getTextString());
			
              
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
  writeLogToFileBean.setFileName("D:/resin-2.1.9/webapps/oradds/LogFile/TARICCODE/TSCInvTaricCodeFix"+dateBean.getYearMonthDay()+"_"+prodClass+".html");
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