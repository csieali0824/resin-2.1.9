<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="QryAllChkBoxEditBean,DateBean,ArrayCheckBoxBean,CodeUtil,WriteLogToFileBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnILNAssistPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="page" class="ArrayCheckBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>ILAN Assist Management - Printer Salary Correction</title>
</head>
<body>
<A HREF="/Oradds/ORAddsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;<A HREF="../jsp/ILNAssistEmpPrinterOpSalary.jsp">宜蘭事務機作業員薪資核算確認</A>&nbsp;&nbsp;<% out.println("<A HREF='../LogFile/ILN70Assist/ILN70SalaryMonth"+dateBean.getYearMonthDay()+".html'>本次薪資核算確認記錄</A><BR>"); %>
<% 
     String [] choice=request.getParameterValues("CHKFLAG");        
     String sqlGlobal=request.getParameter("SQLGLOBAL");    
      
     String YearFr=request.getParameter("YEARFR");
     String MonthFr=request.getParameter("MONTHFR");
	 String num=request.getParameter("NUM");
    
     String dateCurrent = dateBean.getYearMonthDay();
	 String corrKey = "";
	 //String organizationId = "";
	
	 userID = userID.toUpperCase(); // 將系統取得之 User Name轉為大寫
       
     //out.println(choice.length);
	 String aa = "";
	 
	  for (int i=0;i<choice.length ;i++)    
      { 
        aa = choice[i];    
		//out.println(aa+"<BR>");  
      }
	  
     
     String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取文件新增日期時間 //
     String txGetDate = "";      
	 
	 int categoryLength = 0;
	            
%>
<%
  try
  {  
      
     int batchCnt = 0; 
    
     int newSalaryAddTL = 0;
	 int newSalaryDelTL = 0;
	 
	 int oldSalaryAdd08 = 0;//rs.getInt("SALARYADD08");
	 int oldSalaryDel06 = 0;//rs.getInt("SALARYDEL06");
	 int oldSalaryAddTL = 0;//rs.getInt("SALARYADDTL"); 
	 int oldSalaryDelTL = 0;
	 String cName = "";
	 
	  writeLogToFileBean.setTextString("<A HREF='/Oradds/ORAddsMainMenu.jsp'>回首頁</A>&nbsp;&nbsp;<A HREF='http://kerwin.ts.com.tw:8080/oradds/jsp/ILNAssistEmpPrinterOpSalary.jsp'>宜蘭事務機作業員薪資核算確認</A><BR>");
	  System.out.println(writeLogToFileBean.getTextString());  
	 
	  writeLogToFileBean.setTextString("<table border='1'>");
	  System.out.println(writeLogToFileBean.getTextString());  
	        
     Statement statement=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY); 
     System.out.println("sqlGlobal="+sqlGlobal);
     ResultSet rs=statement.executeQuery(sqlGlobal);
     while (rs.next())
     { 
	   // 對 SQL Server 6.5 版的ODBC而言, 取得資料的順序相對於SQL是重要的..,否則會出現,無效的敘述元索引 !!!
	   cName = rs.getString("CNAME");
	 
	   oldSalaryAdd08 = rs.getInt("SALARYADD08");
	   oldSalaryAddTL = rs.getInt("SALARYADDTL");
	   oldSalaryDel06 = rs.getInt("SALARYDEL06");	   
	   oldSalaryDelTL = rs.getInt("SALARYDELTL"); 
	  
	   corrKey = rs.getString("CHKKEY");
	  
	  
	  
      for (int j=0;j<choice.length ;j++)    
      { 
        txGetDate = choice[j];      
      }
	  //out.println("txGetDate="+txGetDate);  
      //out.println("txGetDate.substring(9,15)="+txGetDate.substring(9,15));           
         
      for (int k=0;k<choice.length ;k++)    
      { 
       
       //inventoryItemId = rs.getString("INVENTORY_ITEM_ID");
       //out.println("corrKey.substring(0,8)="+corrKey.substring(0,8)); 
       //out.println("choice[k]="+choice[k]);  
	   
	   
	   categoryLength = choice[k].length(); // 取字串總長度;
	   
       if ( corrKey.substring(0,8)==choice[k].trim() ||  corrKey.substring(0,8).equals(choice[k].trim())  ) 
       { 
	     //out.println("<font color='#CC3366'>choice OK ="+choice[k]+"</font>"); 
		 //out.println(batchCnt);
	     //out.println(corrKey.substring(0,8));
		 //out.println("txGetDate[0,8]="+txGetDate.substring(0,8)); 
		 try
         {
		   			
				
			 if (batchCnt==0) // 取成功入帳BPCS 批號,當第一筆成功寫入出現時
             { 
               //out.println("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>員工編號</strong></font></td><td>發薪年份</td><td>月份</td><td>加班費</td><td>缺勤扣薪</td><td>應發總額</td><td>應扣總額</td></tr>");   
			   writeLogToFileBean.setTextString("<tr bgcolor='#FFFFCC'><td colspan='13' bgcolor='#000099'><font color='#FFFFFF'>成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>項次</td><td><font color='#CC3366'><strong>員工編號</strong></font></td><td><font color='#CC3366'><strong>姓名</strong></font></td><td>發薪年份</td><td>月份</td><td>加班費-Old</td><td>加班費-New</td><td>缺勤扣薪-Old</td><td>缺勤扣薪-New</td><td>應發總額-Old</td><td>應發總額-New</td><td>應扣總額-Old</td><td>應扣總額-New</td></tr>");
			   System.out.println(writeLogToFileBean.getTextString());
               // 取成功帳入 BPCS 時所需的 流水號                
             } // end of if (batchCnt =0 ) 取成功入帳BPCS 批號,當第一筆成功寫入出現時
			 
			batchCnt++;   // 取成功入帳批號,當第一筆成功寫入出現時
			 
			 // 修正加班費,先抓出當月最新序號之原計算依據   
						    
						    int fixSalaryAdd08 = 0;
							int newSalaryAdd08 = 0; 
							//out.println("<font color='#FF0000'><strong>"+oldSalaryAdd08+"--></strong></font>");
						    try
                            {   
		                      Statement stateAdd08=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                              ResultSet rsAdd08=null;	
			                  String sqlAdd08 = "select SALARYAMTS,SALARYMARK "+
			                                     "from SALARYMONTHLOG "+
			                                     "where EMPLOYNO='"+corrKey.substring(0,8)+"' and YEARS = '"+YearFr+"' and MONTH = '"+MonthFr+"'  and ITEMNUM like '18%' "+		
												   "and NUM = (select max(NUM) from SALARYMONTHLOG where EMPLOYNO= '"+corrKey.substring(0,8)+"' and YEARS = '"+YearFr+"' and MONTH = '"+MonthFr+"'  and ITEMNUM like '18%' ) ";		  
								               
			                
                            rsAdd08=stateAdd08.executeQuery(sqlAdd08);
		                    while (rsAdd08.next())
							{ 
							   newSalaryAdd08=rsAdd08.getInt("SALARYAMTS")*(30*8)/248;   // 先乘回去舊的計算因子(30天*8hr),再除以新的(248)
								//out.println("newSalaryDel06="+newSalaryDel06);
							   fixSalaryAdd08 = fixSalaryAdd08 + newSalaryAdd08; // 總加班費 = 當次原因加總
							}	
							rsAdd08.close();
				            stateAdd08.close();	     
							//out.println("<font color='#FF0000'><strong>"+fixSalaryAdd08+"</strong></font>");       	 
                           } //end of try		 
                           catch (Exception e) { out.println("Exception:"+e.getMessage()); } 		
						   
						   
					       newSalaryAddTL = oldSalaryAddTL + (oldSalaryAdd08-fixSalaryAdd08);
					       //out.println("<font color='#FF0000'>"+oldSalaryAddTL+" --> "+newSalaryAddTL+"</font>");   
								   
             // 修正加班費,先抓出當月最新序號之原計算依據
			  
			 // 修正缺勤扣薪,先抓出當月最新序號之原計算依據
			              
						    
						    int fixSalaryDel06 = 0;
						    int newSalaryDel06 = 0;
						    //out.println("<font color='#FF0000'><strong>"+oldSalaryDel06+"--></strong></font>");
						    try
                            {   
							
		                      Statement stateDel06=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                              ResultSet rsDel06=null;	
			                  String sqlDel06 = "select SALARYAMTS,SALARYMARK "+
			                                     "from SALARYMONTHLOG "+
			                                     "where EMPLOYNO='"+corrKey.substring(0,8)+"' and YEARS = '"+YearFr+"' and MONTH = '"+MonthFr+"'  and ITEMNUM like '26%' "+	
												 "and NUM = (select max(NUM) from SALARYMONTHLOG where EMPLOYNO= '"+corrKey.substring(0,8)+"' and YEARS = '"+YearFr+"' and MONTH = '"+MonthFr+"'  and ITEMNUM like '26%' ) ";		  
							 //out.println(sqlDel06);	               
			                 
                             rsDel06=stateDel06.executeQuery(sqlDel06);
		                     while (rsDel06.next())
							 {
							    newSalaryDel06=rsDel06.getInt("SALARYAMTS")*(30*8)/248;   // 先乘回去舊的計算因子(30天*8hr),再除以新的(248)
								//out.println("newSalaryDel06="+newSalaryDel06);
								fixSalaryDel06 = fixSalaryDel06 + newSalaryDel06; // 總缺勤扣薪 = 當次原因加總
							 }
							 rsDel06.close();
				             stateDel06.close();	
							 //out.println("<font color='#FF0000'><strong>"+fixSalaryDel06+"</strong></font>");    	 
                           } //end of try		 
                           catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
						   
						   
					       newSalaryDelTL = oldSalaryDelTL + (oldSalaryDel06-fixSalaryDel06);
					       //out.println("<font color='#FF0000'>"+oldSalaryDelTL+" --> "+newSalaryDelTL+"</font>");
				// 修正缺勤扣薪,先抓出當月最新序號之原計算依據  
			    // Step 1. 更新薪資主檔
			    String sSqPostN="update SALARYMONTH set SALARYADD08='"+fixSalaryAdd08+"',SALARYDEL06='"+fixSalaryDel06+"', SALARYADDTL='"+newSalaryAddTL+"',SALARYDELTL='"+newSalaryDelTL+"' "+
		                        "where YEARS = '"+YearFr+"' and MONTH='"+MonthFr+"' "+
						        "and EMPLOYNO = '"+corrKey.substring(0,8)+"' and NUM = '"+num+"' ";   
                //out.println("sSqPostN="+sSqPostN);
		      
            //1    PreparedStatement stmtPostN=ilnAsistcon.prepareStatement(sSqPostN);                    
            //2    stmtPostN.executeUpdate();		
            //3    stmtPostN.close(); 			     
					                   
				// Step 2. 更新薪資項目明細檔  
					  //out.println("<TR bgcolor='#FFFFCC'><TD>"+
                      //"<a href='../jsp/RPIssueAPPReportPrint.jsp?RPTXCOM="+rs.getString("EMPLOYNO")+" '>"+                       
		              //"<div align='center'><img src='../image/docicon.gif' width='14' height='15' border='0'></div></a></TD>"+"<TD>"+rs.getString("EMPLOYNO")+"</TD>"+"<TD>"+YearFr+"</TD>"+"<TD>"+MonthFr+"</TD>"+"<TD>"+fixSalaryAdd08+"</TD>"+"<TD>"+fixSalaryDel06+"</TD>"+"<TD>"+newSalaryAddTL+"</TD>"+"<TD>"+newSalaryDelTL+"</TD></TR>");
					   writeLogToFileBean.setTextString("<TR bgcolor='#FFFFCC'><TD>"+batchCnt+"</TD>"+                     
		                                                "<TD>"+corrKey.substring(0,8)+"</TD>"+"<TD>"+cName+"</TD>"+"<TD>"+YearFr+"</TD>"+"<TD>"+MonthFr+"</TD>"+"<TD>"+oldSalaryAdd08+"</TD>"+"<TD>"+fixSalaryAdd08+"</TD>"+"<TD>"+oldSalaryDel06+"</TD>"+"<TD>"+fixSalaryDel06+"</TD>"+"<TD>"+oldSalaryAddTL+"</TD>"+"<TD>"+newSalaryAddTL+"</TD>"+"<TD>"+oldSalaryDelTL+"</TD>"+"<TD>"+newSalaryDelTL+"</TD>"+"</TR>");
					   System.out.println(writeLogToFileBean.getTextString());
			
              
		 } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }  
	  
    
       }  // end of if      
      } // End of for (k)  
	 
	  
     } //End of While 
	 writeLogToFileBean.setTextString("</table>");
	 System.out.println(writeLogToFileBean.getTextString());
	
	 
     rs.close();
     statement.close();
     

  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());		  
  } 
  
  // 設定存檔路徑並存檔
  writeLogToFileBean.setFileName("D:/resin-2.1.9/webapps/oradds/LogFile/ILN70Assist/ILN70SalaryMonth"+dateBean.getYearMonthDay()+".html");
  writeLogToFileBean.StrSaveToFile();

%>
 <input name="YEARFR" type="hidden" value="<%=YearFr%>">
 <input name="MONTHFR" type="hidden" value="<%=MonthFr%>"> 

</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSDisttstPage.jsp"%-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnILNAssistPage.jsp"%>
<!--=================================-->
<%
   //response.sendRedirect("../jsp/ILN70SalaryMonth"+dateBean.getYearMonthDay()+".html");	 
%>
</html>

