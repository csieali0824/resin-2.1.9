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
	 
	
	 
	            
%>
<%

   
  try
  {       
       int batchCnt = 0; 
       int recordCnt = 1;
       
	   
	 // 先取 Btach Job 執行人員 ID	
	if (sqlGlobal==null || sqlGlobal.equals(""))  // For 每日自動啟動更新之Schedule Job
	{ 
	 sqlGlobal = "select CATEGORY_ID, LANGUAGE, CCCODE "+
		         "from TSC_CCCODE ";
        sWhere = "where ( CCCODE IS NULL or CCCODE = '') "; 
			     //"AND to_char(C.LAST_UPDATE_DATE,'YYYYMMDD') <= '"+dateBean.getYearMonthDay()+"' ";     // 預設進入頁面即將小於今日的異常資料帶出            
        sOrder =   "order by CATEGORY_ID ";
     
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
		    String taricCode = "";
	        String invTaricCode = "";
		    String remark = "";
		 
		   // Statement stateItem=con.createStatement();
		   
			// 判段目前錯誤的 Categories ID, 並以此做為判斷作分類更新                     
			//String sqlGetItem = "select I.SEGMENT1, M.SEGMENT2, M.SEGMENT1 as MSEGMENT1, M.INVENTORY_ITEM_ID, M.ORGANIZATION_ID, M.CATEGORY_ID, M.LAST_UPDATE_DATE, M.LAST_UPDATED_BY FROM MTL_ITEM_CATEGORIES_V M, MTL_SYSTEM_ITEMS I where M.ORGANIZATION_ID = I.ORGANIZATION_ID and M.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID and M.CATEGORY_SET_ID = 4 and M.ORGANIZATION_ID = '"+rs.getString("ORGANIZATION_ID")+"' and M.INVENTORY_ITEM_ID = '"+rs.getString("INVENTORY_ITEM_ID")+"' "; 
			//out.println("sqlGetItem ="+sqlGetItem);
			//String cateSegmnt1Name = "";		
				
			 if (batchCnt==0) // 取成功入帳BPCS 批號,當第一筆成功寫入出現時
             { 
               //out.println("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>Oracle Request ID</strong></font></td><td>Org.ID</td><td>Item.ID</td><td>Error CategoryID</td><td>Correct CategoryID</td><td>UserID</td><td>UserName</td><td>LastUpdateTime</td></tr>");   
			   writeLogToFileBean.setTextString("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>("+dateBean.getYearMonthDay()+")更新項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>Category ID</strong></font></td><td>Language</td><td>Taric Code</td><td>UserID</td><td>UserName</td><td>LastUpdateTime</td><td>Remark</td></tr>");
			   System.out.println(writeLogToFileBean.getTextString());
               // 取成功帳入 BPCS 時所需的 流水號
               batchCnt++;   // 取成功入帳BPCS 批號,當第一筆成功寫入出現時 
             } // end of if (batchCnt =0 ) 取成功入帳BPCS 批號,當第一筆成功寫入出現時	
					   
			      // 取出料件主檔內寫入 Taric Code 的值, 並判斷取得料件對應的分類對應Taric Code,作為更新依據  
				  Statement stateItem=con.createStatement();                
			      String sqlGetItem = "select DISTINCT I.ATTRIBUTE2, I.SEGMENT1 from MTL_SYSTEM_ITEMS I, MTL_ITEM_CATEGORIES C "+
				                      "where C.ORGANIZATION_ID = I.ORGANIZATION_ID "+
									    "and C.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID "+
										"and length(I.SEGMENT1) <> 6 "+
									    "and CATEGORY_ID = '"+rs.getString("CATEGORY_ID")+"'    "; 
			      //out.println("sqlGetItem ="+sqlGetItem);
			      ResultSet rsGetItem=stateItem.executeQuery(sqlGetItem);   
                  if (rsGetItem.next())  
			      {   
				    prodClass = rsGetItem.getString("SEGMENT1");  // 取出 Item
					out.println("prodClass ="+prodClass);
					int prodLength = prodClass.length();  // 取產品編碼長度
					out.println("prodLength="+prodLength);
					 //out.println("recordCount="+recordCnt);
				    // 以下分類
			        // 半導體類 Taric Code = 8541100000
					if (prodLength==22 && (prodClass.substring(0,1)=="0" || prodClass.substring(0,1).equals("0") || prodClass.substring(0,1)=="1" || prodClass.substring(0,1).equals("1") || prodClass.substring(0,1)=="2" || prodClass.substring(0,1).equals("2") || prodClass.substring(0,1)=="3" || prodClass.substring(0,1).equals("3") || prodClass.substring(0,1)=="4" || prodClass.substring(0,1).equals("4") || prodClass.substring(0,1)=="5" || prodClass.substring(0,1).equals("5") || prodClass.substring(0,1)=="6" || prodClass.substring(0,1).equals("6") || prodClass.substring(0,1)=="7" || prodClass.substring(0,1).equals("7") || prodClass.substring(0,1)=="8") || prodClass.substring(0,1).equals("8"))					
			        //if (prodClass.substring(0,2)=="01" || prodClass.substring(0,2).equals("01"))
			        {    
			          taricCode = "8541100000";
				      invTaricCode = "Diodes-"+taricCode;
					  //out.println("prodClass.substring(0,1)="+prodClass.substring(0,1));
			      
			        } // IC二極體 Taric Code = 8542293000 ( AI、 VR 、 PW )
					 else if (prodLength==22 && (prodClass.substring(5,7)=="AI" || prodClass.substring(5,7).equals("AI") || prodClass.substring(5,7)=="VR" || prodClass.substring(5,7).equals("VR") || prodClass.substring(5,7)=="PW") || prodClass.substring(5,7).equals("PW"))
			         //else if (prodClass.substring(0,2)=="02" || prodClass.substring(0,2).equals("02"))
			         { 
				       taricCode = "8542293000"; 
				       invTaricCode = "Diodes - "+taricCode;
					   //out.println("prodClass.substring(5,7)="+prodClass.substring(5,7));
				     }  // IC線性穩壓器 Taric Code = 8542295000  ( SR、LR、LD、UL、CL )
					 else if (prodLength==22 && (prodClass.substring(5,7)=="SR" || prodClass.substring(5,7).equals("SR") ||prodClass.substring(5,7)=="LR"  || prodClass.substring(5,7).equals("LR")|| prodClass.substring(5,7)=="LD" || prodClass.substring(5,7)=="UL" || prodClass.substring(5,7).equals("UL") || prodClass.substring(5,7)=="CL") || prodClass.substring(5,7).equals("CL"))
			         //else if (prodClass.substring(0,2)=="03" || prodClass.substring(0,2).equals("03"))
			         {  
				        taricCode = "8542295000";
				        invTaricCode = "Linear Voltage Regulator - "+taricCode;
						//out.println("prodClass.substring(5,7)="+prodClass.substring(5,7));
		             }   // IC電晶體 Taric Code = 8541210000 ( TR )
					 else if (prodLength==22 && (prodClass.substring(5,7)=="TR" || prodClass.substring(5,7).equals("TR")))
				     //else if (prodClass.substring(0,2)=="04" || prodClass.substring(0,2).equals("04"))
			         {  
				        taricCode = "8541210000"; 				
					    invTaricCode = "Transistor - "+taricCode; 
						//out.println("prodClass.substring(5,7)="+prodClass.substring(5,7) );
			         }  // IC場效電晶體 Taric Code = 8541290001  ( MF )
					 else if (prodLength==22 && (prodClass.substring(5,7)=="MF") || prodClass.substring(5,7).equals("MF"))
				     //else if (prodClass.substring(0,2)=="05" || prodClass.substring(0,2).equals("05"))
				     { 
					   taricCode = "8541290001";
					   invTaricCode = "Mosfets - "+taricCode;   
					   //out.println("prodClass.substring(5,7)="+prodClass.substring(5,7)); 
				    } // IC運算放大器 Taric Code = 8542293000 ( AC ) 
					else if (prodLength==22 && (prodClass.substring(5,7)=="AC") || prodClass.substring(5,7).equals("AC")) 
				    //else if (prodClass.substring(0,2)=="06" || prodClass.substring(0,2).equals("06"))
				    { 
					  taricCode = "8542293000";   
					  invTaricCode = "Operational Amplifier - "+taricCode; 
					  //out.println("prodClass.substring(5,7)="+prodClass.substring(5,7)); 
				    } // 晶圓 Taric Code = 8542293000 
					else if (prodLength==12 && (prodClass.substring(0,2)=="10" || prodClass.substring(0,2).equals("10")))
				    //else if (prodClass.substring(0,2)=="07" || prodClass.substring(0,2).equals("07"))
			        {  
				     taricCode = "8542293000"; 
					 invTaricCode = "PWM and PFC - "+taricCode;
					 //out.println("prodClass.substring(0,2)="+prodClass.substring(0,2));
			        }  				
					else { // 若都不屬於產品分類的編碼原則,則可能是資產類或原物料件
					       taricCode = null;
						   invTaricCode = null; 
						   remark = prodClass;  // 若找到料號但未屬任一分類,則將料號給 Remark 欄位
					     }   
				    
			         String sSqlCateS2="update TSC_CCCODE set CCCODE=?, LMUSER=?, LMDTIME=?, REMARK=? "+
								       "where CATEGORY_ID = '"+rs.getString("CATEGORY_ID")+"' and ( CCCODE IS NULL or CCCODE = '') ";			   
			         PreparedStatement stmtCateS2=con.prepareStatement(sSqlCateS2);
			         stmtCateS2.setString(1,invTaricCode); 	
					 stmtCateS2.setString(2,userName); 
					 stmtCateS2.setString(3,strDateTime);		
					 stmtCateS2.setString(4,remark);		   
				     stmtCateS2.executeUpdate();
                     stmtCateS2.close();				      
			    } else {  // 若根本查無任一料號歸屬此分類, 則於Remark 欄位標示無此料號歸屬
				            invTaricCode = "";
				            remark = "No Item belong to this Category ID";							
				            String sSqlCateS3="update TSC_CCCODE set CCCODE=?, LMUSER=?, LMDTIME=?, REMARK=? "+
								       "where CATEGORY_ID = '"+rs.getString("CATEGORY_ID")+"' and ( CCCODE IS NULL or CCCODE = '') ";			   
			                PreparedStatement stmtCateS3=con.prepareStatement(sSqlCateS3);
			                stmtCateS3.setString(1,null); 	
					        stmtCateS3.setString(2,userName); 
					        stmtCateS3.setString(3,strDateTime);		
					        stmtCateS3.setString(4,remark);		   
				            stmtCateS3.executeUpdate();
                            stmtCateS3.close();	
							
							
				       }
				rsGetItem.close();
				stateItem.close();
				
				  
			   
	 
	             //out.println("Request ID="+requestID);			      
					  
					  //organizationId = rs.getString("ORGANIZATION_ID");
                      //inventoryItemId = rs.getString("INVENTORY_ITEM_ID");                     
					  
					  //out.println("<TR bgcolor='#FFFFCC'><TD><font color='#000099'>"+recordCnt+
                      //"</font></TD><TD><font color='#CC3366'><strong>"+requestID+"</strong></font></TD>"+"<TD>"+rsGetItem.getString("ORGANIZATION_ID")+"</TD>"+"<TD>"+inventoryItemId+"("+rsGetItem.getString("SEGMENT1")+")"+"</TD>"+"<TD>"+rsGetItem.getString("CATEGORY_ID")+"</TD>"+"<TD>"+categoryId+"</TD>"+"<TD>"+userID+"</TD>"+"<TD>"+userName+"</TD>"+"<TD>"+strDateTime+"</TD></TR>");
					  writeLogToFileBean.setTextString("<TR bgcolor='#FFFFCC'><TD><font color='#000099'>"+recordCnt+
                      "</font></TD><TD><font color='#CC3366'><strong>"+rs.getString("CATEGORY_ID")+"</strong></font></TD>"+"<TD>"+rs.getString("LANGUAGE")+"</TD>"+"<TD>"+invTaricCode+"</TD>"+"<TD>"+userID+"</TD>"+"<TD>"+userName+"</TD>"+"<TD>"+strDateTime+"</TD><TD>"+remark+"</TD></TR>");
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
  writeLogToFileBean.setFileName("D:/resin-2.1.9/webapps/oradds/LogFile/TARICCODE/TSCCCCTaricCodeFix"+dateBean.getYearMonthDay()+".html");
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