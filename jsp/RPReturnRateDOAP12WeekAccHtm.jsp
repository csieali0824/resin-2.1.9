<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,MiscellaneousBean"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSTelPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<!--%@ include file="/jsp/include/ConnMESPoolPage.jsp"%-->
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<html>
<head>

<title>維修系統-近三個月累計客退率總表</title>
</head>
<body>
<% 
     
	 String ymh1="",ymh2="",ymh3="",ymh4="",ymh5="",ymh6="",ymh7="",ymh8="",ymh9="",ymh10="",ymh11="",ymh12="";
     String ymPrevYear2="",ymPrevYear2M3="", ymPrevYear1="",ymPrevYear1M3="", ym1="",ym2="",ym3="",ym4="",ym5="",ym6="",ym7="",ym8="",ym9="",ym10="",ym11="",ym12="";                 
     
     String ModelNo = request.getParameter("MODELNO");
     String ymCurr = dateBean.getYearString()+dateBean.getMonthString();
    
%>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> 近三個月<%=ModelNo%>累計DOA/DAP客退率總表</strong></font>

   <table border="1" width="70%" height="70%" cellpadding="0" cellspacing="0">
               <tr bgcolor="#FFFFFE" >
                 <td  height="19" nowrap colspan="2"><div align="center"><font color="#000000" size="2" face="標楷體"><strong>機種\月份  </strong></font></div></td>                  
                 
                   <%
                      dateBean.setAdjWeek(-12);
                      dateBean.setAdjMonth(-2);  //取前兩個月
                      ymPrevYear2 = dateBean.getYearString()+dateBean.getMonthString();
                 //     out.println("至 "+dateBean.getYearString()+"/"+dateBean.getMonthString());

                      dateBean.setAdjMonth(-3);  //再往前取3個月 
                      ymPrevYear2M3 = dateBean.getYearString()+dateBean.getMonthString();      
                      dateBean.setAdjMonth(5);  //回複月 
                      dateBean.setAdjWeek(12);  
                   
                   %>          
                   
                   <%

                      workingDateBean.setAdjWeek(-12);
                      workingDateBean.setAdjWeek(-1);;  //取前一個月
                      workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日
                      ymPrevYear1 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                   //   out.println("至 "+dateBean.getYearString()+"/"+dateBean.getMonthString());
                      workingDateBean.setAdjWeek(1);;  //取前一個月
      
                      workingDateBean.setAdjMonth(-3);  //再往前取3個月 
                      workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日
                      ymPrevYear1M3 = workingDateBean.getYearString()+workingDateBean.getMonthString();      
                      workingDateBean.setAdjMonth(3);  //取前兩月 
                      workingDateBean.setAdjWeek(12);     
                           
                  %>    
                 <td width="5%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <%   
                       
                    workingDateBean.setAdjWeek(-12); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
                    ymh1=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh1+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                  
                    ym1= workingDateBean.getYearString()+workingDateBean.getMonthString();
                        
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP12 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP12 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
                    //out.println("strFirstDWeekP12="+strFirstDWeekP12);out.println("strLastDWeekP12="+strLastDWeekP12);

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP12M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP12M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天                          
                    workingDateBean.setAdjWeek(11); //正確12週前回復 
                    //out.println("strFirstDWeekP12M3="+strFirstDWeekP12M3);out.println("strLastDWeekP12="+strLastDWeekP12);
                

                 %></strong></font></div></td>  
                 <td width="5%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <% 
                    workingDateBean.setAdjWeek(1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
                    ymh2=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh2+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym2= workingDateBean.getYearString()+workingDateBean.getMonthString();

                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay());      
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP11 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP11 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP11M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP11M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復         
                 
                 %></strong></font></div></td> 
                 <td width="6%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <% 
                    workingDateBean.setAdjWeek(1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
                    ymh3=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh3+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym3= workingDateBean.getYearString()+workingDateBean.getMonthString(); 

                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日         
                    String strFirstDWeekP10 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP10 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天     
                    //out.println("strFirstDWeekP10="+strFirstDWeekP10);out.println("strLastDWeekP10="+strLastDWeekP10); 

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP10M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP10M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復 
       
                 %></strong></font></div></td>
                 <td width="6%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <% 
                    workingDateBean.setAdjWeek(1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());      
                    ymh4=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh4+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym4= workingDateBean.getYearString()+workingDateBean.getMonthString(); 

                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay());      
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日    
                    String strFirstDWeekP9 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP9 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP9M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP9M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復  
                 
                 %></strong></font></div></td>
                 <td width="5%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <% 
                    workingDateBean.setAdjWeek(1);  //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());           
                    ymh5=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh5+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym5= workingDateBean.getYearString()+workingDateBean.getMonthString(); 
                              
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日        
                    String strFirstDWeekP8 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP8 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP8M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP8M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復
                 %></strong></font></div></td>
                 <td width="6%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <% 
                    workingDateBean.setAdjWeek(1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());        
                    ymh6=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh6+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym6= workingDateBean.getYearString()+workingDateBean.getMonthString(); 
                    
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日    
                    String strFirstDWeekP7 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP7 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP7M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP7M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復
             
                 %></strong></font></div></td> 
                 <td width="6%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <% 
                    workingDateBean.setAdjWeek(1); 
                    ymh7=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh7+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym7= workingDateBean.getYearString()+workingDateBean.getMonthString();       
                    
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日          
                    String strFirstDWeekP6 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP6 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP6M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP6M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復
                 
                 %></strong></font></div></td>  
                 <td width="5%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <% 
                    workingDateBean.setAdjWeek(1);       
                    ymh8=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh8+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym8= workingDateBean.getYearString()+workingDateBean.getMonthString(); 

                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日              
                    String strFirstDWeekP5 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP5 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
                      
                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP5M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP5M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復      
                 %></strong></font></div></td>   
                 <td width="6%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <% 
                    workingDateBean.setAdjWeek(1); 
                    ymh9=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh9+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym9= workingDateBean.getYearString()+workingDateBean.getMonthString(); 
                     
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日          
                    String strFirstDWeekP4 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP4 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP4M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP4M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復
              
                 %></strong></font></div></td>   
                 <td width="6%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <%
                    workingDateBean.setAdjWeek(1);    
                    ymh10=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh10+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym10= workingDateBean.getYearString()+workingDateBean.getMonthString(); 
                 
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay());
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日         
                    String strFirstDWeekP3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天  

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP3M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP3M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復
            
                 %></strong></font></div></td>   
                 <td width="6%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <%
                    workingDateBean.setAdjWeek(1);  
                    ymh11=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh11+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym11= workingDateBean.getYearString()+workingDateBean.getMonthString();          
                   
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay());
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日           
                    String strFirstDWeekP2 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP2 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP2M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP2M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復
            
                 %></strong></font></div></td>   
                 <td width="6%"  height="19" nowrap><div align="center"><font color="#000000" size="2"><strong>
                 <% 
                    workingDateBean.setAdjWeek(1);     
                    ymh12=workingDateBean.getYearString()+"/"+workingDateBean.getMonthString();      
		            out.println(ymh12+"<BR>");out.println("第"+"<font color='#CC0066'>"+workingDateBean.getWeek()+"</font>"+"週");                   
                    ym12= workingDateBean.getYearString()+workingDateBean.getMonthString();          
                    

                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日          
                    String strFirstDWeekP1 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
                    String strLastDWeekP1 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天         

                    workingDateBean.setAdjWeek(-11); //為了算12週平均出貨數,再以本週往前推12週,取日期
                    workingDateBean.setWorkingDate(workingDateBean.getYear(),workingDateBean.getMonth(),workingDateBean.getDay()); 
                    workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
                    String strFirstDWeekP1M3 = workingDateBean.getFirstDateOfWorkingWeek();   // 取前12週起始週第一天
                    String strLastDWeekP1M3 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
                    workingDateBean.setAdjWeek(11); //正確12週前回復 

                    dateBean.setAdjWeek(1);     

  
                 %></strong></font></div></td>   
                         
               </tr>
                 <%

                           int countYm1 = 0,countYm2 = 0,countYm3 = 0,countYm4 = 0,countYm5 = 0,countYm6 = 0;
                           int countYm7 = 0,countYm8 = 0,countYm9 = 0,countYm10 = 0,countYm11 = 0,countYm12 = 0,countPrevYear2 = 0, countPrevYear1 = 0; 

                           int countYmT1 = 0,countYmT2 = 0,countYmT3 = 0,countYmT4 = 0,countYmT5 = 0,countYmT6 = 0;
                           int countYmT7 = 0,countYmT8 = 0,countYmT9 = 0,countYmT10 = 0,countYmT11 = 0,countYmT12 = 0;   

                           float countYmf1 = 0,countYmf2 = 0,countYmf3 = 0,countYmf4 = 0,countYmf5 = 0,countYmf6 = 0;
                           float countYmf7 = 0,countYmf8 = 0,countYmf9 = 0,countYmf10 = 0,countYmf11 = 0,countYmf12 = 0,countYmTf = 0,countPrevYearf2 = 0, countPrevYearf1 = 0;
                          
                           float countTpeShipf1 = 0,countTpeShipf2 = 0,countTpeShipf3 = 0,countTpeShipf4 = 0,countTpeShipf5 = 0,countTpeShipf6 = 0;
                           float countTpeShipf7 = 0,countTpeShipf8 = 0,countTpeShipf9 = 0,countTpeShipf10 = 0,countTpeShipf11 = 0,countTpeShipf12 = 0,countTpeShipTf = 0,countTpeShipPrevYearf2 = 0, countTpeShipPrevYearf1 = 0; 
                                
                           float sumYm1 =0,sumYm2 = 0,sumYm3 = 0,sumYm4 = 0,sumYm5 = 0, sumYm6 = 0;
                           float sumYm7 =0,sumYm8 = 0,sumYm9 = 0,sumYm10 = 0,sumYm11 = 0, sumYm12 = 0, sumPrevYear2 = 0, sumPrevYear1 = 0 ;       

                           float sumTpeShip1f = 0,sumTpeShip2f = 0,sumTpeShip3f = 0,sumTpeShip4f = 0,sumTpeShip5f = 0;
                           float sumTpeShip6f = 0,sumTpeShip7f = 0,sumTpeShip8f = 0,sumTpeShip9f = 0,sumTpeShip10f = 0;  
                           float sumTpeShip11f = 0,sumTpeShip12f = 0,sumTpeShipTf = 0, sumTpeShipPrevYear2f = 0, sumTpeShipPrevYear1f = 0;        

                           float sumAcc1 =0,sumAcc2 = 0,sumAcc3 = 0,sumAcc4 = 0,sumAcc5 = 0, sumAcc6 = 0;
                           float sumAcc7 =0,sumAcc8 = 0,sumAcc9 = 0,sumAcc10 = 0,sumAcc11 = 0, sumAcc12 = 0 ; 

                           float sumAccTpeShip1 =0,sumAccTpeShip2 = 0,sumAccTpeShip3 = 0,sumAccTpeShip4 = 0,sumAccTpeShip5 = 0, sumAccTpeShip6 = 0;
                           float sumAccTpeShip7 =0,sumAccTpeShip8 = 0,sumAccTpeShip9 = 0,sumAccTpeShip10 = 0,sumAccTpeShip11 = 0, sumAccTpeShip12 = 0 ;

                           float sumTotAcc1 =0,sumTotAcc2 = 0,sumTotAcc3 = 0,sumTotAcc4 = 0,sumTotAcc5 = 0, sumTotAcc6 = 0;
                           float sumTotAcc7 =0,sumTotAcc8 = 0,sumTotAcc9 = 0,sumTotAcc10 = 0,sumTotAcc11 = 0, sumTotAcc12 = 0 ; 

                           float sumTotAccTpeShip1 =0,sumTotAccTpeShip2 = 0,sumTotAccTpeShip3 = 0,sumTotAccTpeShip4 = 0,sumTotAccTpeShip5 = 0, sumTotAccTpeShip6 = 0;
                           float sumTotAccTpeShip7 =0,sumTotAccTpeShip8 = 0,sumTotAccTpeShip9 = 0,sumTotAccTpeShip10 = 0,sumTotAccTpeShip11 = 0, sumTotAccTpeShip12 = 0 ;              

                           
                           float totCountYmRet =0; 
                           float totTpeShipOut = 0;   
      
                           float sumTotCountYmRet =0;
                           float sumTotTpeShipOut = 0;
                                 
                    //prevSpanLunDate = cntModelLunDate*3+4;
    
                    String jamCode = null;
                    String jamCodeGet = "";  
                    int jamCodeGetLength   = 0;  
                    Statement stateIM=con.createStatement();   			     
				    try
		            {  
                      String sqlIM = "select DISTINCT a.MODEL from RPREPAIR a, RPMODEL_ITEM_T b ";    
                      String whereIM = "where trim(a.MODEL) = trim(b.MODEL) and a.MODEL='"+ModelNo+"' ";
                      sqlIM = sqlIM + whereIM; 
					  //out.println(sqlIM);
					  ResultSet rsIM=stateIM.executeQuery(sqlIM);					
					  while (rsIM.next())
					  {
                          
					 // 機種下的成品料號
					             
                          String ItemDesc = null;
						  String itemCodeGet = "";
						  int itemCodeGetLength = 0;     
				          Statement stateItemDesc=con.createStatement(); 
                          ResultSet rsItemDesc=stateItemDesc.executeQuery("select DISTINCT ITEMNO as MODELDESC from RPMODEL_ITEM_T, RPMODEL  where MODEL=MODEL_CODE and (MODEL='"+rsIM.getString("MODEL")+"' or MODEL_CODE='"+rsIM.getString("MODEL")+"') and LUNLOCALE='886' ");
                          while (rsItemDesc.next()) 
                          { 
                           ItemDesc = rsItemDesc.getString(1);
						   itemCodeGet = itemCodeGet+"'"+ItemDesc+"'"+","; 
                          }
                         rsItemDesc.close();
                         stateItemDesc.close(); 

                        // 取當月條件內的機種成品料號 //
                        if (itemCodeGet.length()>0)
						{        
                         itemCodeGetLength = itemCodeGet.length()-1;            
			             itemCodeGet = itemCodeGet.substring(0,itemCodeGetLength);
						}               
                     
                 %>                
               <tr bgcolor="#FFFFFF" >               </tr>
               <tr><td rowspan="6"><div align="center"><font color="#000000" size="2"><% out.println(rsIM.getString("MODEL")); %></font></div></td></tr>             
               <tr>
                 <td nowrap><div align="center"><font face="標楷體" size="2">當週出貨數</font></div></td>
                  <%                        
                    //dateBean.setAdjMonth(-1);  
                    String jamCount = "";   
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        int sumTpeShipPrevYear2 = 0;  

                        try
		                {    
                          float distShipOut = 0;  
                          String sqlDistShip="select ABS(SUM(TQTY)) from ITH where TTDTE <= '"+ymPrevYear2+"' "+  
                                           "and TTYPE IN('B','RM') and TWHS in('81','82','83') "+    
                                           "and TREFM between 150000 and 159999 "+                 
                                           "and TPROD in ("+itemCodeGet+") "; 
                          Statement stateDistShip=ifxdistcon.createStatement(); 
                          //out.println(sqlDistShip);     
                          ResultSet rsDistShip=stateDistShip.executeQuery(sqlDistShip);
                          if (rsDistShip.next())  
                          { 
                             distShipOut = rsDistShip.getFloat(1);      
                          } else { distShipOut = 0; }
                          rsDistShip.close();
                          stateDistShip.close();
    
                          String sqlTpeShip="select ABS(SUM(TQTY)) from ITH where TTDTE <= '"+ymPrevYear2+"' "+  
                                           "and TWHS in('52','71','72','73') and TTYPE IN('B','RM') "+ 
                                           "and TREFM between 150000 and 159999 "+                
                                           "and TPROD in ("+itemCodeGet+") "; 
                          Statement stateTpeShip=ifxtelcon.createStatement(); 
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                            sumTpeShipPrevYear2 = rsTpeShip.getInt(1);  //out.println(sumYm2); 
                            countTpeShipPrevYearf2 = rsTpeShip.getFloat(1)+distShipOut;       
                            sumTpeShipPrevYear2f = sumTpeShipPrevYear2f+countTpeShipPrevYearf2;  //out.println(sumYm2);   
                            //out.println(Math.round(countTpeShipPrevYearf2));                             
                                   
                          } else { //out.println("&nbsp;"); 
                                 }
                            rsTpeShip.close();
                            stateTpeShip.close(); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                                    
                  %>
                                
                  <%                        
                    
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				       
				        int sumTpeShipPrevYear1 = 0;  
                        try
		                {     
                          float distShipOut = 0;  
                          String sqlDistShip="select ABS(SUM(TQTY)) from ITH where TTDTE <= '"+ymPrevYear1+"' "+  
                                           "and TTYPE IN('B','RM') and TWHS in('81','82','83') "+ 
                                           "and TREFM between 150000 and 159999 "+                    
                                           "and TPROD in ("+itemCodeGet+") "; 
                          Statement stateDistShip=ifxdistcon.createStatement(); 
                          //out.println(sqlDistShip);     
                          ResultSet rsDistShip=stateDistShip.executeQuery(sqlDistShip);
                          if (rsDistShip.next())  
                          { 
                             distShipOut = rsDistShip.getFloat(1);      
                          } else { distShipOut = 0; }
                          rsDistShip.close();
                          stateDistShip.close();                           
                          
                          String sqlTpeShip="select ABS(SUM(TQTY)) from ITH where TTDTE <= '"+ymPrevYear1+"' "+  
                                           "and TWHS in('52','71','72','73') and TTYPE in('B','RM') "+ 
                                           "and TREFM between 150000 and 159999 "+                          
                                           "and TPROD in ("+itemCodeGet+") "; 
                          Statement stateTpeShip=ifxtelcon.createStatement(); 
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                            sumTpeShipPrevYear1 = rsTpeShip.getInt(1);  //out.println(sumYm2); 
                            countTpeShipPrevYearf1 = rsTpeShip.getFloat(1)+distShipOut;       
                            sumTpeShipPrevYear1f = sumTpeShipPrevYear1f+countTpeShipPrevYearf1;  //out.println(sumYm2);  
                            //out.println(Math.round(countTpeShipPrevYearf1));  
                                 
                          } else { 
                                   sumTpeShipPrevYear1 = 0;
                                   countTpeShipPrevYearf1 = 0;  
                                   //out.println("&nbsp;"); 
                                 }
                              
                            rsTpeShip.close();
                            stateTpeShip.close(); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                                  
                  %>
                 
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <%    
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				      
				   //     int sumTpeShip = 0;  
                        try
		                {                       
                           
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP12+"' and RTDTTO='"+strLastDWeekP12+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement();                          
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                       
                            countTpeShipf1 = rsTpeShip.getFloat(1);
                       
                            out.println(Math.round(countTpeShipf1));    
                                                             
                          } else { 
                                  countTpeShipf1 = 0;
                                  out.println("&nbsp;");  
                                 }                     
                    
                            rsTpeShip.close();
                            stateTpeShip.close();         
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                                 
                  %>
                </font></div>
                </td>                       
                <td width="5%" rowspan="1" nowrap><div align="center"><font size="2">
                 
                  <%
                  
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				      
				       
                        try
		                {                       
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP11+"' and RTDTTO='"+strLastDWeekP11+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement();                            
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                       
                            countTpeShipf2 = rsTpeShip.getFloat(1);
                        
                            out.println(Math.round(countTpeShipf2));  
                                                                     
                          } else { 
                               
                                  countTpeShipf2 = 0; 
                                  out.println("&nbsp;");
                                 }
                                 
                            rsTpeShip.close();
                            stateTpeShip.close(); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                       
                  %></font></div>                </td>
                <td width="6%" rowspan="1" nowrap><div align="center"><font size="2">
                
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
                        try
		                {                       
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP10+"' and RTDTTO='"+strLastDWeekP10+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement(); 
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                           
                            countTpeShipf3 = rsTpeShip.getFloat(1);
                          
                            out.println(Math.round(countTpeShipf3)); 
                                                   
                          } else { 
                                
                                  countTpeShipf3 = 0;  
                                  out.println("&nbsp;");
                                 }
                             
                            rsTpeShip.close();
                            stateTpeShip.close(); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				         
                        try
		                {                       
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP9+"' and RTDTTO='"+strLastDWeekP9+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement();        
                          
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                            
                            countTpeShipf4 = rsTpeShip.getFloat(1);
                          
                            out.println(Math.round(countTpeShipf4));
                                                                         
                          } else { 
                              
                                  countTpeShipf4 = 0;  
                                  out.println("&nbsp;");
                                 }
                         
                            rsTpeShip.close();
                            stateTpeShip.close(); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                    
                  %></font></div>
                </td>
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				       
                        try
		                {                       
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP8+"' and RTDTTO='"+strLastDWeekP8+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement();       
                          
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                            
                            countTpeShipf5 = rsTpeShip.getFloat(1);
                            
                            out.println(Math.round(countTpeShipf5));  
                                                                   
                          } else { 
                                  
                                  countTpeShipf5 = 0;  
                                  out.println("&nbsp;");
                                 }
                         
                            rsTpeShip.close();
                            stateTpeShip.close(); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                    
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				       
                        try
		                {                       
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP7+"' and RTDTTO='"+strLastDWeekP7+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement();     
                          
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                           
                            countTpeShipf6 = rsTpeShip.getFloat(1);
                           
                            out.println(Math.round(countTpeShipf6));
                                                                                                            
                          } else { 
                               
                                  countTpeShipf6 = 0;  
                                  out.println("&nbsp;");
                                 }
                        
                            rsTpeShip.close();
                            stateTpeShip.close(); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                 
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				         
                        try
		                {                       
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP6+"' and RTDTTO='"+strLastDWeekP6+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement(); 
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                          
                            countTpeShipf7 = rsTpeShip.getFloat(1);
                            
                            out.println(Math.round(countTpeShipf7));  
                                                                
                          } else { 
                                
                                  countTpeShipf7 = 0;  
                                  out.println("&nbsp;");
                                 }
                      
                            rsTpeShip.close();
                            stateTpeShip.close();  
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                 
                  %></font></div>
                </td>                
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                   
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				     
                        try
		                {                       
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP5+"' and RTDTTO='"+strLastDWeekP5+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement();
                          //out.println(sqlTpeShip);  //out.println("cntModelLunDate*3+4="+cntModelLunDate);   
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0 && rsTpeShip.getString(1)!= null) 
                          { //out.println("into result Set"); 
                            
                            countTpeShipf8 = rsTpeShip.getFloat(1);
                           
                            out.println(Math.round(countTpeShipf8)); 
                         
                                                                                             
                          } else {//out.println("into NULL"); 
                          
                                  countTpeShipf8 = 0;  
                                  out.println("&nbsp;"); 
                                 }
                        
                            rsTpeShip.close();
                            stateTpeShip.close();  
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                  
                      
                %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
                        try
		                {                       
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP4+"' and RTDTTO='"+strLastDWeekP4+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement(); 
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                           
                            countTpeShipf9 = rsTpeShip.getFloat(1);
                            
                            out.println(Math.round(countTpeShipf9)); 
                                                                                                  
                          } else { 
                                 
                                  countTpeShipf9 = 0;  
                                  out.println("&nbsp;");
                                 }
                      
                            rsTpeShip.close();
                            stateTpeShip.close();  
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                    
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
                        try
		                {                       
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP3+"' and RTDTTO='"+strLastDWeekP3+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement(); 
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                           
                            countTpeShipf10 = rsTpeShip.getFloat(1);
                            sumTpeShip10f = sumTpeShip10f+countTpeShipf10;  //out.println(sumYm2);  
                            out.println(Math.round(countTpeShipf10));  
                                                             
                          } else { 
                                  
                                  countTpeShipf10 = 0;  
                                  out.println("&nbsp;");
                                 }
                         
                            rsTpeShip.close();
                            stateTpeShip.close();  
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   
                  %>
               </font></div>
                </td>                
                <td width="6%"><div align="center"><font size="2">                 
                  <%
                   try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				         
                        try
		                {                       
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP2+"' and RTDTTO='"+strLastDWeekP2+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement();   
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                           
                            countTpeShipf11 = rsTpeShip.getFloat(1);
                           
                            out.println(Math.round(countTpeShipf11)); 
                                                                 
                          } else { 
                                 
                                  countTpeShipf11 = 0;  
                                  out.println("&nbsp;");
                                 }
                         
                            rsTpeShip.close();
                            stateTpeShip.close(); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                    
                  %></font></div>
                </td>                
                <td width="6%"><div align="center"><font size="2">
                  <%
                        
                      // int sumTpeShip=0;
      
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {				     
				         String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+strFirstDWeekP1+"' and RTDTTO='"+strLastDWeekP1+"' "+  
                                           "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='WEK' ";
                          Statement stateTpeShip=con.createStatement();
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                                      
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                            
                            countTpeShipf12 = rsTpeShip.getFloat(1);
                              
                            out.println(Math.round(countTpeShipf12)); 
                                                                 
                          } else { 
                                   
                                  countTpeShipf12 = 0;  
                                  out.println("&nbsp;");
                                 }
                        
                           rsTpeShip.close();
                           stateTpeShip.close();                 
                        } 
                   
                  %>
                 </font></div>
                </td>     
               </tr> <!--%// 當週出貨數止%--> 
               <tr>
                 <td><div align="center"><font face="標楷體" size="2">當週退貨數</font></div></td> 
                 <td width="5%"><div align="center"><font size="2">
                  <%                        
                    
                    try
		            {
                     /*  
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select COUNT(DISTINCT IMEI) from RPREP_UPFILE where substr(RECDATE,1,8) between '"+strFirstDWeekP12+"' and '"+strLastDWeekP12+"' "+                               
                                          "and WARRTYPE='新品' and (MODEL='3268') "; 
                       Statement stateKeyCount=con.createStatement(); 
                       //out.println(sqlKeyCount);
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();        

                       String sqlCount="select COUNT(REPNO) from RPREPAIR where substr(REPNO,6,8) between '"+strFirstDWeekP12+"' and '"+strLastDWeekP12+"' "+
                                  //     "and substr(JAMDESC,1,3) like '%"+rsIM.getString("JAMCODE")+"%' "+
                                  //     "and substr(JAMDESC,1,3) ='"+rsIM.getString("JAMCODE")+"' "+ 
                                       "and SVRTYPENO in('002','003') and REPCENTERNO != '001' and MODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1);    
                         countYm1 = rsCount.getInt(1); 
                         countYmf1 = rsCount.getFloat(1)+keyAccount;   
                        
                       } else 
                            { 
                              countYm1 = 0;
                              countYmf1 = 0;
                            }                    
                      
                       rsCount.close();
                       stateCount.close(); 

                     */
                      float keyAccount = 0;  
                       
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP12+"' and RTDTTO='"+strLastDWeekP12+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' ";     
                       Statement stateKeyCount=con.createStatement(); 
                       //out.println(sqlKeyCount);
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();     
    

                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP12+"' and RTDTTO='"+strLastDWeekP12+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1);    
                         countYm1 = rsCount.getInt(1); 
                         countYmf1 = rsCount.getFloat(1);  
                         countYmT1 = rsCount.getInt(2); 
                       } else 
                            { 
                              countYm1 = 0;
                              countYmf1 = 0; countYmT1 = 0;
                            }                    
                      
                       rsCount.close();
                       stateCount.close();      
                    
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {     
                     //out.println(jamCount); 
                     out.println(Math.round(countYmf1)); 
                   }
                   else {  out.println("&nbsp;");  }                 
                  %>            
                 </font></div>
                 </td>                      
                 <td width="5%"><div align="center"><font size="2">
                   <%
                    //String jamCount = ""; 
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP11+"' and RTDTTO='"+strLastDWeekP11+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' ";
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();   
                       
                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP11+"' and RTDTTO='"+strLastDWeekP11+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' ";  
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1); 
                         countYm2 = rsCount.getInt(1);
                         countYmf2 = rsCount.getFloat(1); 
                         countYmT2 = rsCount.getInt(2);                                  
                       } else { 
                               countYm2 = 0;
                               countYmf2 = 0; countYmT2 = 0;
                              }
                    
                       rsCount.close();
                       stateCount.close(); 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {       
                     //out.println(jamCount); 
                     out.println(Math.round(countYmf2)); 
                   }
                   else {  out.println("&nbsp;");  }
                  %>          
                  </font></div>
                 </td>
                 <td width="6%"><div align="center"><font size="2">
                   <%
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP10+"' and RTDTTO='"+strLastDWeekP10+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();  
                  
                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP10+"' and RTDTTO='"+strLastDWeekP10+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1); 
                         countYm3 = rsCount.getInt(1);
                         countYmf3 = rsCount.getFloat(1);
                         countYmT3 = rsCount.getInt(2);
                       } else { 
                               countYm3 = 0;
                               countYmf3 = 0; countYmT3 = 0;
                              }
                      
                       rsCount.close();
                       stateCount.close();
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {        
                     //out.println(jamCount); 
                     out.println(Math.round(countYmf3)); 
                   }
                   else {  out.println("&nbsp;");  }
                  %>        
                  </font></div>
                 </td>                
                 <td width="6%" rowspan="1"><div align="center"><font size="2">
                   <%
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP9+"' and RTDTTO='"+strLastDWeekP9+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();                      

                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP9+"' and RTDTTO='"+strLastDWeekP9+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1);
                         countYm4 = rsCount.getInt(1); 
                         countYmf4 = rsCount.getFloat(1);
                         countYmT4 = rsCount.getInt(2);
                                          
                       } else { 
                               countYm4 = 0;
                               countYmf4 = 0; countYmT4 = 0;
                              }
                      
                       rsCount.close();
                       stateCount.close();  
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {        
                     //out.println(jamCount); 
                     out.println(Math.round(countYmf4)); 
                   }
                   else {  out.println("&nbsp;");  }
                  %>      
                 </font></div>
                 </td>
                 <td width="5%" rowspan="1"><div align="center"><font size="2">
                  <%
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP8+"' and RTDTTO='"+strLastDWeekP8+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' ";
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();                        

                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP8+"' and RTDTTO='"+strLastDWeekP8+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' ";
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1); 
                         countYm5 = rsCount.getInt(1);
                         countYmf5 = rsCount.getFloat(1); 
                         countYmT5 = rsCount.getInt(2);                                      
                       } else { 
                               countYm5 = 0;
                               countYmf5 = 0;
                                countYmT5 = 0;  
                              }
                    
                       rsCount.close();
                       stateCount.close(); 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {         
                     //out.println(jamCount); 
                     out.println(Math.round(countYmf5)); 
                   }
                   else {  out.println("&nbsp;");  }
                  %>             
                 </font></div> 
                 </td>                
                 <td width="6%" rowspan="1"><div align="center"><font size="2">
                   <%
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP7+"' and RTDTTO='"+strLastDWeekP7+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close(); 

                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP7+"' and RTDTTO='"+strLastDWeekP7+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' ";
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       {// out.println("jamCount="+jamCount);
                         jamCount = rsCount.getString(1);
                         countYm6 = rsCount.getInt(1);
                         countYmf6 = rsCount.getFloat(1);  
                         countYmT6 = rsCount.getInt(2);
                       } else { 
                               countYm6 = 0;
                               countYmf6 = 0;
                               countYmT6 = 0;
                              }
                   
                       rsCount.close();
                       stateCount.close();
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {          
                     //out.println(jamCount); 
                     out.println(Math.round(countYmf6)); 
                   }
                   else {  out.println("&nbsp;");  } 
                  %>         
                 </font></div>
                 </td>                
                 <td width="6%" rowspan="1"><div align="center"><font size="2">
                  <%
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP6+"' and RTDTTO='"+strLastDWeekP6+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();                           
 
                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP6+"' and RTDTTO='"+strLastDWeekP6+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1);   
                         countYm7 = rsCount.getInt(1);
                         countYmf7 = rsCount.getFloat(1);   
                         countYmT7 = rsCount.getInt(2);         
                       } else { 
                               countYm7 = 0;
                               countYmf7 = 0;
                               countYmT7 = 0;    
                              }
                
                       rsCount.close();
                       stateCount.close(); 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {           
                     //out.println(jamCount); 
                     out.println(Math.round(countYmf7)); 
                   }
                   else {  out.println("&nbsp;");  } 
                  %>      
                 </font></div>
                 </td>                
                 <td width="5%" rowspan="1"><div align="center"><font size="2">
                   <%
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP5+"' and RTDTTO='"+strLastDWeekP5+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();                        

                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP5+"' and RTDTTO='"+strLastDWeekP5+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1); 
                         countYm8 = rsCount.getInt(1); 
                         countYmf8 = rsCount.getFloat(1); 
                         countYmT8 = rsCount.getInt(2);        
                       } else { 
                               countYm8 = 0;
                               countYmf8 = 0;
                               countYmT8 = 0;
                              }
               
                       rsCount.close();
                       stateCount.close();
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {            
                     //out.println(jamCount); 
                     out.println(Math.round(countYmf8)); 
                   }
                   else {  out.println("&nbsp;");  } 
                  %>            
                 </font></div>
                 </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                    <%
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP4+"' and RTDTTO='"+strLastDWeekP4+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();   
                       
                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP4+"' and RTDTTO='"+strLastDWeekP4+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1);
                         countYm9 = rsCount.getInt(1);
                         countYmf9 = rsCount.getFloat(1); 
                         countYmT9 = rsCount.getInt(2); 
                       } else { 
                               countYm9 = 0;
                               countYmf9 = 0;
                               countYmT9 = 0;
                              }
                  
                       rsCount.close();
                       stateCount.close(); 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {             
                     //out.println(jamCount); 
                     out.println(Math.round(countYmf9)); 
                   }
                   else {  out.println("&nbsp;");  } 
                  %>       
                 </font></div>
                </td>                
                 <td width="6%" rowspan="1"><div align="center"><font size="2">
                     <%
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP3+"' and RTDTTO='"+strLastDWeekP3+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();                         

                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP3+"' and RTDTTO='"+strLastDWeekP3+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' ";
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1);
                         countYm10 = rsCount.getInt(1);
                         countYmf10 = rsCount.getFloat(1);
                         countYmT10 = rsCount.getInt(2);  
                       } else { 
                               countYm10 = 0;
                               countYmf10 = 0;
                               countYmT10 = 0;   
                              }
                         
                       rsCount.close();
                       stateCount.close();  
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {              
                     //out.println(jamCount); 
                     out.println(Math.round(countYmf10)); 
                   }
                   else {  out.println("&nbsp;");  } 
                  %>                  
                 </font></div>
                 </td>                
                 <td width="6%" rowspan="1"><div align="center"><font size="2">
                   <%
                   try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP2+"' and RTDTTO='"+strLastDWeekP2+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();    
                       
                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP2+"' and RTDTTO='"+strLastDWeekP2+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1);
                         countYm11 = rsCount.getInt(1); 
                         countYmf11 = rsCount.getFloat(1); 
                         countYmT11 = rsCount.getInt(2);
                                                            
                       } else { 
                               countYm11 = 0;
                               countYmf11 = 0;
                                countYmT11 = 0;
                              }
                 
                       rsCount.close();
                       stateCount.close(); 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                    
                    if ( jamCount != "0" && !jamCount.equals("0") )          
                    { // out.println(jamCount); 
                     out.println(Math.round(countYmf11)); 
                    }
                    else {  out.println("&nbsp;");  } 
                  %>              
                 </font></div></td>                
                 <td width="6%" rowspan="1"><div align="center"><font size="2">
                    <%
                     try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+strFirstDWeekP1+"' and RTDTTO='"+strLastDWeekP1+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='2' and RMODEL ='"+rsIM.getString("MODEL")+"' ";
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();                            

                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+strFirstDWeekP1+"' and RTDTTO='"+strLastDWeekP1+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='2' and RSRC in('D') and RMODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1); 
                         countYm12 = rsCount.getInt(1);
                         countYmf12 = rsCount.getFloat(1);
                         countYmT12 = rsCount.getInt(2);                                            
                       } else { 
                               countYm12 = 0;
                               countYmf12 = 0;
                              }
                           
                       rsCount.close();
                       stateCount.close();         
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }   
                   if ( jamCount != "0" && !jamCount.equals("0") )          
                   {  // out.println(jamCount); 
                     out.println(Math.round(countYmf12)); 
                   }
                   else {  out.println("&nbsp;");  }  
                  %>        
                 </font></div>
                 </td>                  
               </tr>                  
               <tr> <!--%// 當週累計出貨起%-->
                <td nowrap><div align="center"><font face="標楷體" size="2">當週累計出貨數</font></div></td>                
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                  <%    
                    try
		            {
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
				        int sumTpeShip = 0;  
                        try
		                { 
                          String sqlTpeShip="select RTNCOUNT from RPRTN_CNT where RTDTFR='"+ymPrevYear1+"' and RTDTTO='"+ymPrevYear1+"' "+  
                                            "and RTYPE='SHP' and RMODEL='"+rsIM.getString("MODEL")+"' and SVRTYPE='TOT' ";
                          Statement stateTpeShip=con.createStatement();                          
                          //out.println(sqlTpeShip);     
                          ResultSet rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
                          if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) 
                          { 
                       
                            countTpeShipf1 = rsTpeShip.getFloat(1)+countTpeShipf1;
                            sumTpeShip1f = countTpeShipf1; // 把值給Total 
                            out.println(Math.round(countTpeShipf1));    
                                                             
                          } else { 
                                  countTpeShipf1 = 0;
                                  out.println("&nbsp;");  
                                 }                     
                    
                            rsTpeShip.close();
                            stateTpeShip.close();      

  
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                                   
                  %>
                </font></div>
                </td>                       
                <td width="5%" rowspan="1" nowrap><div align="center"><font size="2">
                 
                  <%
                    //String jamCount = ""; 
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
				        int sumTpeShip = 0;  
                        try
		                { 

                          countTpeShipf2 = countTpeShipf2 + countTpeShipf1; 
                          sumTpeShip2f = countTpeShipf2; // 把值給Total                    
                          out.println(Math.round(countTpeShipf2));
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                         
                  %></font></div>
                </td>
                <td width="6%" rowspan="1" nowrap><div align="center"><font size="2">
                
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
				        int sumTpeShip = 0;  
                        try
		                {                       
                          countTpeShipf3 = countTpeShipf3 + countTpeShipf2; 
                          sumTpeShip3f = countTpeShipf3; // 把值給Total                   
                          out.println(Math.round(countTpeShipf3));
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                  
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {

                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
				        int sumTpeShip = 0;  
                        try
		                {                       
                           countTpeShipf4 = countTpeShipf4 + countTpeShipf3;
                           sumTpeShip4f = countTpeShipf4; // 把值給Total                       
                           out.println(Math.round(countTpeShipf4));
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                     
                  %></font></div>
                </td>
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
				        int sumTpeShip = 0;  
                        try
		                {                       
                           countTpeShipf5 = countTpeShipf5 + countTpeShipf4; 
                           sumTpeShip5f = countTpeShipf5; // 把值給Total                    
                           out.println(Math.round(countTpeShipf5));
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                      
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
				        int sumTpeShip = 0;  
                        try
		                {                       
                          countTpeShipf6 = countTpeShipf6 + countTpeShipf5;
                          sumTpeShip6f = countTpeShipf6; // 把值給Total
					      out.println(Math.round(countTpeShipf6));  
                        } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                     
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				       
				        int sumTpeShip = 0;  
                        try
		                {                       
                          countTpeShipf7 = countTpeShipf7 + countTpeShipf6;
                          sumTpeShip7f = countTpeShipf7; // 把值給Total 
					      out.println(Math.round(countTpeShipf7)); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                      
                  %></font></div>
                </td>                
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
				        int sumTpeShip = 0;  
                        try
		                {                       
                          countTpeShipf8 = countTpeShipf8+countTpeShipf7;
                          sumTpeShip8f = countTpeShipf8; // 把值給Total
					      out.println(Math.round(countTpeShipf8));
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }                             
                      
                %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
				        int sumTpeShip = 0;  
                        try
		                {                       
                          countTpeShipf9 = countTpeShipf9+countTpeShipf8;
                          sumTpeShip9f = countTpeShipf9; // 把值給Total   
					      out.println(Math.round(countTpeShipf9));
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                      
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
				        int sumTpeShip = 0;  
                        try
		                {                       
                          countTpeShipf10 = countTpeShipf10+countTpeShipf9;
                          sumTpeShip10f = countTpeShipf10; // 把值給Total
					      out.println(Math.round(countTpeShipf10)); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                     
                  %>
               </font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                   try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				       
				        int sumTpeShip = 0;  
                        try
		                {                       
                          countTpeShipf11 = countTpeShipf11+countTpeShipf10;
                          sumTpeShip11f = countTpeShipf11; // 把值給Total   
					      out.println(Math.round(countTpeShipf11));
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                     
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       
                       if (itemCodeGet==null || itemCodeGet.equals(""))
                       {
                         out.println("N/A");       
                       }  
                       else
                       {
				        
				        int sumTpeShip = 0;  
                        try
		                {                       
                          countTpeShipf12 = countTpeShipf12+countTpeShipf11;
                          sumTpeShip12f = countTpeShipf12; // 把值給Total        
					      out.println(Math.round(countTpeShipf12)); 
					        
                          } //end of try
                          catch (Exception e)
                          {
                            out.println("Exception:"+e.getMessage());
                          }  
                       } 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                      
                  %></font></div>
                </td>
               
                  <%
                      totTpeShipOut = 0;
                      //totTpeShipOut = countTpeShipPrevYearf2+countTpeShipPrevYearf1+countTpeShipf1+countTpeShipf2+countTpeShipf3+countTpeShipf4+countTpeShipf5+countTpeShipf6+countTpeShipf7+countTpeShipf8+countTpeShipf9+countTpeShipf10+countTpeShipf11+countTpeShipf12;
                      totTpeShipOut = countTpeShipPrevYearf1+countTpeShipf1+countTpeShipf2+countTpeShipf3+countTpeShipf4+countTpeShipf5+countTpeShipf6+countTpeShipf7+countTpeShipf8+countTpeShipf9+countTpeShipf10+countTpeShipf11+countTpeShipf12;           
                      //out.println(Math.round(totTpeShipOut));
                      String totTpeShipOutStr = String.valueOf(totTpeShipOut);
                       
                         
                      //out.println(rate12Str+"%");
                  %>              
               </tr> <!--%// 出貨數止%-->
               <tr>
                 <td><div align="center"><font face="標楷體" size="2">當週累計退貨數</font></div></td>
                 <%                        
                    //dateBean.setAdjMonth(-1);  
                    //String jamDesc = ""; 
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select COUNT(DISTINCT IMEI) from RPREP_UPFILE where substr(RECDATE,1,6) <= '"+ymPrevYear2+"' "+                               
                                          "and WARRTYPE='新品' and (MODEL='3268') "; 
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();
    
                       String sqlCount="select COUNT(REPNO) from RPREPAIR where substr(REPNO,6,6) <= '"+ymPrevYear2+"' "+
                                  //     "and substr(JAMDESC,1,3) like '%"+rsIM.getString("JAMCODE")+"%' "+
                                  //     "and substr(JAMDESC,1,3) ='"+rsIM.getString("JAMCODE")+"' "+ 
                                       "and SVRTYPENO in('002','003') and REPCENTERNO != '001' and MODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       //System.out.println("Test");    
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1);    
                         countPrevYear2 = rsCount.getInt(1); 
                         countPrevYearf2 = rsCount.getFloat(1)+keyAccount; //countPrevYearf2
                         sumPrevYear2 = sumPrevYear2+countPrevYearf2;                            
                       }
                       else { 
                             countPrevYear2 = 0;
                             countPrevYearf2 = 0;
                            } 
                       
                       rsCount.close();
                       stateCount.close(); 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                                   
                  %>

                  <%                        
                
                    try
		            {
                       float keyAccount = 0;  
                         
                       String sqlKeyCount="select COUNT(DISTINCT IMEI) from RPREP_UPFILE where substr(RECDATE,1,6) <= '"+ymPrevYear1+"' "+                               
                                          "and WARRTYPE='新品' and (MODEL='3268') "; 
                       Statement stateKeyCount=con.createStatement(); 
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();                             

                       String sqlCount="select COUNT(REPNO) from RPREPAIR where substr(REPNO,6,6) <= '"+ymPrevYear1+"' "+                                
                                       "and SVRTYPENO in('002','003') and REPCENTERNO != '001' and MODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1);    
                         countPrevYear1 = rsCount.getInt(1); 
                         countPrevYearf1 = rsCount.getFloat(1)+keyAccount;    
                         sumPrevYear1 = sumPrevYear1+countPrevYearf1;
                                
                       } else
                            { 
                             countPrevYear1 = 0;
                             countPrevYearf1 = 0;    
                            }
                       
                       rsCount.close();
                       stateCount.close(); 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                  %>
                
                <td width="5%" rowspan="1"><div align="center"><font size="2">                 
                  <%           
                    try
		            {
                      
                      float keyAccount = 0;  
                       
                       String sqlKeyCount="select RTNCOUNT from RPRTN_CNT where RTDTFR ='"+ymPrevYear1+"' and RTDTTO='"+ymPrevYear1+"' "+                               
                                          "and RTYPE='RTN' and RSRC='K' and SVRTYPE='002' and RPLVL='3' and RMODEL ='"+rsIM.getString("MODEL")+"' ";     
                       Statement stateKeyCount=con.createStatement(); 
                       //out.println(sqlKeyCount);
                       ResultSet rsKeyCount=stateKeyCount.executeQuery(sqlKeyCount);  
                       if (rsKeyCount.next()) 
                       {
                         keyAccount =  rsKeyCount.getFloat(1);                           
                       } else { keyAccount = 0; }             
                       rsKeyCount.close();
                       stateKeyCount.close();     
    

                       String sqlCount="select sum(RTNCOUNT),sum(TOTCOUNT) from RPRTN_CNT where RTDTFR='"+ymPrevYear1+"' and RTDTTO='"+ymPrevYear1+"' "+                                 
                                       "and RTYPE='RTN' and SVRTYPE ='002' and RPLVL='3' and RSRC in('D','K') and RMODEL='"+rsIM.getString("MODEL")+"' "; 
                       Statement stateCount=con.createStatement(); 
                       //out.println(sqlCount);     
                       ResultSet rsCount=stateCount.executeQuery(sqlCount);
                       if (rsCount.next()) 
                       { 
                         jamCount = rsCount.getString(1);    
                         countYm1 = rsCount.getInt(1); 
                         countYmf1 = rsCount.getFloat(1)+countYmf1;  // 
                         countYmT1 = rsCount.getInt(2); 
                       } else 
                            { 
                              countYm1 = 0;
                              countYmf1 = 0; countYmT1 = 0;
                            }   
                       out.println(Math.round(countYmf1));         
                       sumYm1 = countYmf1; // 把值給 Total

                       rsCount.close();
                       stateCount.close();        
                       
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }             
                 %>
                </font></div>
                </td>                      
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                   
                    try
		            {
                       countYmf2=countYmf2+countYmf1;      
                       sumYm2 = countYmf2; // 把值給 Total                      
                       out.println(Math.round(countYmf2));             
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   
                  %></font></div> 
                </td>
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       countYmf3=countYmf3+countYmf2;      
                       sumYm3 = countYmf3; // 把值給 Total                        
                       out.println(Math.round(countYmf3));
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                
                  <%
                    try
		            {
                       countYmf4=countYmf4+countYmf3;      
                       sumYm4 = countYmf4; // 把值給 Total                       
                       out.println(Math.round(countYmf4));
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                  
                  %></font></div>
                </td>
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       countYmf5=countYmf5+countYmf4;      
                       sumYm5 = countYmf5; // 把值給 Total                       
                       out.println(Math.round(countYmf5));
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       countYmf6=countYmf6+countYmf5;      
                       sumYm6 = countYmf6; // 把值給 Total                        
                       out.println(Math.round(countYmf6)); 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       countYmf7=countYmf7+countYmf6;      
                       sumYm7 = countYmf7; // 把值給 Total                      
                       out.println(Math.round(countYmf7));
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                  
                  %></font></div>
                </td>                
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       countYmf8=countYmf8+countYmf7;      
                       sumYm8 = countYmf8; // 把值給 Total                        
                       out.println(Math.round(countYmf8));
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                   
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                
                  <%
                    try
		            {
                       countYmf9=countYmf9+countYmf8;      
                       sumYm9 = countYmf9; // 把值給 Total                       
                       out.println(Math.round(countYmf9));
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                    
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       countYmf10=countYmf10+countYmf9;      
                       sumYm10 = countYmf10; // 把值給 Total                          
                       out.println(Math.round(countYmf10)); 
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                    
                  %>
                </font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                
                  <%
                   try
		            {
                       countYmf11=countYmf11+countYmf10;      
                       sumYm11 = countYmf11; // 把值給 Total                        
                       out.println(Math.round(countYmf11));  
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }           
                    
                     
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    try
		            {
                       countYmf12=countYmf12+countYmf11;      
                       sumYm12 = countYmf12; // 把值給 Total                      
                       out.println(Math.round(countYmf12));  
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }   
                    
                  %></font></div>
                </td>
               
                  <%
                      totCountYmRet =0;
                      //totCountYmRet = countPrevYearf2+countPrevYearf1+countYmf1+countYmf2+countYmf3+countYmf4+countYmf5+countYmf6+countYmf7+countYmf8+countYmf9+countYmf10+countYmf11+countYmf12;            
                      totCountYmRet = countPrevYearf1+countYmf1+countYmf2+countYmf3+countYmf4+countYmf5+countYmf6+countYmf7+countYmf8+countYmf9+countYmf10+countYmf11+countYmf12;                   
                      //out.println(Math.round(totCountYmRet)); 

                      String totCountYmRetStr = String.valueOf(totCountYmRet);
          
                  %>      
               </tr> 
               <tr>
                 <td><div align="center"><font face="標楷體" size="2"><strong>當週累計客退率</strong></font></div></td>
                                  
                  <% 
                     if (countTpeShipPrevYearf2>0 && countPrevYear2 !=0 ) 
                     {               
                      //float rate1 = Math.round((countYmf1/sumTpeShip1f)*100); 
                      //out.println(countPrevYearf2);out.println(" / "+ countTpeShipPrevYearf2);
                      float ratePrevYear2 = (countPrevYearf2/countTpeShipPrevYearf2)*100;
                      String ratePrevYear2Str = Float.toString(ratePrevYear2);
                      int ratePrevYear2Lth = ratePrevYear2Str.length();
                      if (ratePrevYear2Lth>5)
                      {   ratePrevYear2Str = ratePrevYear2Str.substring(0,5);  }
                      else if (ratePrevYear2Lth==4) {   ratePrevYear2Str = ratePrevYear2Str.substring(0,4);  }        
                      else {  ratePrevYear2Str = ratePrevYear2Str.substring(0,3);  }
  
                      if (ratePrevYear2==0.0) { out.println("&nbsp;");  }                
                      else 
                      { 
                       //out.println(ratePrevYear2Str+"%"); 
                            
                      }
                    } 
                    else if (countPrevYearf2==0.0) { out.println("&nbsp;"); }
                         else { out.println("&nbsp;"); }
                       
                  %>
                
                  <% 
                     if (countTpeShipPrevYearf1>0 && countPrevYear1 !=0) 
                     {               
                      //float rate1 = Math.round((countYmf1/sumTpeShip1f)*100); 
                      float ratePrevYear1 = (countPrevYearf1/countTpeShipPrevYearf1)*100;
                      String ratePrevYear1Str = Float.toString(ratePrevYear1);
                      int ratePrevYear1Lth = ratePrevYear1Str.length();
                      if (ratePrevYear1Lth>5)
                      {   ratePrevYear1Str = ratePrevYear1Str.substring(0,5);  }
                      else if (ratePrevYear1Lth==4) {   ratePrevYear1Str = ratePrevYear1Str.substring(0,4);  }        
                      else {  ratePrevYear1Str = ratePrevYear1Str.substring(0,3);  }
  
                      if (ratePrevYear1==0.0) { out.println("&nbsp;");  }                
                      else { 
                            // out.println(ratePrevYear1Str+"%"); 
                                 
                           }
                    } else if (countPrevYearf1==0.0) { out.println("&nbsp;"); }
                      else { out.println("&nbsp;"); }
                  				                  
                  %>
               
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <% 
                     if (countTpeShipf1>0 && countYmf1 !=0) 
                     {               
                      
                      float rate1 = (countYmf1/countTpeShipf1)*100; 
                      //double rate1 = 6.950;   
                     
                      miscellaneousBean.setRoundDigit(2);
                      String rate1Str = miscellaneousBean.getFloatRoundStr(rate1);
                      out.println(rate1Str+"%");   
       
                    } else if (countYmf1==0.0) { out.println("&nbsp;"); }
                           else { out.println("&nbsp;"); }
                   
				                  
                  %>
                </font></div>
                </td>                       
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                     if (countTpeShipf2>0 && countYmf2 !=0) 
                     {  
                        float rate2 = (countYmf2/countTpeShipf2)*100;
  
                        miscellaneousBean.setRoundDigit(2);
                        String rate2Str = miscellaneousBean.getFloatRoundStr(rate2);
                        out.println(rate2Str+"%"); 
                     }  else if (countYmf2==0.0) { out.println("&nbsp;"); }

                        else { out.println("&nbsp;"); }
                    
					                          
                  %></font></div>                </td>
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    if (countTpeShipf3>0 && countYmf3 !=0) 
                    {  
                      
                      float rate3 = (countYmf3/countTpeShipf3)*100; 

                      miscellaneousBean.setRoundDigit(2);
                      String rate3Str = miscellaneousBean.getFloatRoundStr(rate3);
                      out.println(rate3Str+"%");
      
                    }   else if (countYmf3==0.0) { out.println("&nbsp;"); }
                        else { out.println("&nbsp;"); } 
				     
				    
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                
                  <%
                    if (countTpeShipf4>0 && countYmf4 !=0) 
                    {   
                      
                      float rate4 = (countYmf4/countTpeShipf4)*100; 
                      miscellaneousBean.setRoundDigit(2);
                      String rate4Str = miscellaneousBean.getFloatRoundStr(rate4);
                      out.println(rate4Str+"%"); 

                    }   else if (countYmf4==0.0) { out.println("&nbsp;"); }
                        else { out.println("&nbsp;"); }          
				                   
                  %></font></div>
                </td>
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                
                  <%
                    if (countTpeShipf5>0 && countYmf5 !=0) 
                    { 
                      
                      float rate5 = (countYmf5/countTpeShipf5)*100;
                      miscellaneousBean.setRoundDigit(2);
                      String rate5Str = miscellaneousBean.getFloatRoundStr(rate5);
                      out.println(rate5Str+"%");  
 
                    }   else if (countYmf5==0.0) { out.println("&nbsp;"); }
                        else { out.println("&nbsp;"); }     
                                
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    if (countTpeShipf6>0 && countYmf6 !=0) 
                    { 
                      
                      float rate6 = (countYmf6/countTpeShipf6)*100;       
                      miscellaneousBean.setRoundDigit(2);
                      String rate6Str = miscellaneousBean.getFloatRoundStr(rate6);
                      out.println(rate6Str+"%");  
 
                    }   else if (countYmf6==0.0) { out.println("&nbsp;"); }
                        else { out.println("&nbsp;"); }  
				       
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    if (countTpeShipf7>0 && countYmf7 !=0) 
                    { 
                      
                      float rate7 = (countYmf7/countTpeShipf7)*100;     
                      miscellaneousBean.setRoundDigit(2);
                      String rate7Str = miscellaneousBean.getFloatRoundStr(rate7);
                      out.println(rate7Str+"%");  
        
                     }  else if (countYmf7==0.0) { out.println("&nbsp;"); }
                        else { out.println("&nbsp;"); }     
				    
                  %></font></div>
                </td>                
                <td width="5%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    if (countTpeShipf8>0 && countYmf8 !=0) 
                    { 
                      
                      float rate8 = (countYmf8/countTpeShipf8)*100;
                      miscellaneousBean.setRoundDigit(2);
                      String rate8Str = miscellaneousBean.getFloatRoundStr(rate8);
                      out.println(rate8Str+"%");  
                
                    }   else if (countYmf8==0.0) { out.println("&nbsp;"); }
                        else { out.println("&nbsp;"); }       
				                     
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    if (countTpeShipf9>0 && countYmf9 !=0) 
                    { 
                     
                      float rate9 = (countYmf9/countTpeShipf9)*100;  
                      miscellaneousBean.setRoundDigit(2);
                      String rate9Str = miscellaneousBean.getFloatRoundStr(rate9);
                      out.println(rate9Str+"%");  
                         
                    }   else if (countYmf9==0.0) { out.println("&nbsp;"); }
                        else { out.println("&nbsp;"); }        
				                      
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                
                  <%
                    if (countTpeShipf10>0 && countYmf10 !=0) 
                    { 
                      
                      float rate10 = (countYmf10/countTpeShipf10)*100; 
                      miscellaneousBean.setRoundDigit(2);
                      String rate10Str = miscellaneousBean.getFloatRoundStr(rate10);
                      out.println(rate10Str+"%");  
                                   
                    }   else if (countYmf10==0.0) { out.println("&nbsp;"); }
                        else { out.println("&nbsp;"); }      
				    
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                
                  <%
                    if (countTpeShipf11>0 && countYmf11 !=0) 
                    { 
                      
                      float rate11 = (countYmf11/countTpeShipf11)*100; 
                      //out.println("rate11Float="+rate11); 
                      miscellaneousBean.setRoundDigit(2);
                      String rate11Str = miscellaneousBean.getFloatRoundStr(rate11);
                      out.println(rate11Str+"%");

                 /*                               
                      int roundDigit =2;   
                      String roundJdgStr = null;
                      String roundNoRndStr = null;
                      String roundNoStr = Double.toString(6.960);
                      int roundNoStrLngth = roundNoStr.length();
                      int dotIndex = roundNoStr.indexOf(".");
                      int dotLeft = roundNoStrLngth-dotIndex-1;

                      if (dotLeft>=roundDigit)
                      {
                         roundJdgStr = roundNoStr.substring(dotIndex+roundDigit,dotIndex+roundDigit+1);
                      }
                      else if ((dotLeft==roundDigit))
                      {
                        roundJdgStr = roundNoStr+"0";
                        roundNoRndStr = "0";
                      }

                      int roundJdgInt = Integer.parseInt(roundJdgStr);
                      out.println("roundJdgInt="+roundJdgInt+"<BR>");
                      if (roundJdgInt>4)
                      {
                        if (roundDigit==2)
                        { 
                          roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-1,dotIndex+roundDigit); 
                          int roundNoInt = Integer.parseInt(roundNoRndStr); 
                          roundNoInt++;     
                          if (roundNoInt<10)  
                          { 
                             roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-1)+roundNoInt+"0"; out.println("Step1="+roundNoStr);
                          } else 
                               {  
                                 roundNoInt = Integer.parseInt(roundNoStr.substring(0,dotIndex));
                                 roundNoInt++;     
                                 roundNoStr = Integer.toString(roundNoInt)+".00";
                                 out.println("Step2="+roundNoStr);
                               }         
                        } else 
                          { 
                           roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-2,dotIndex+roundDigit); out.println("roundNoRndStr ="+roundNoRndStr);

                           int roundNoInt = Integer.parseInt(roundNoRndStr);
                           roundNoInt++;  out.println("roundNoInt++ ="+roundNoInt++);
                           if (roundNoInt<10) { roundNoRndStr = "0"+roundNoInt; }
                           else { roundNoRndStr = Integer.toString(roundNoInt); }  
                           roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-2)+ roundNoRndStr;         
                          }   
                      }
                      else // Else if roundJdgInt <=4
                      { 
                         if (roundDigit==2)
                         {
                            roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-1,dotIndex+roundDigit); out.println("Step3="+roundNoRndStr);
                            int roundNoInt = Integer.parseInt(roundNoRndStr); 
                            if (roundNoInt<10)  
                            { 
                              roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-1)+roundNoInt+"0";out.println("Step4="+roundNoStr);
                            } else 
                               {  
                                 roundNoInt = Integer.parseInt(roundNoStr.substring(0,dotIndex));  
                                 roundNoStr = Integer.toString(roundNoInt)+".00";   out.println("Step5="+roundNoStr);  
                               }  
                         }
                         else {
                               roundNoRndStr = roundNoStr.substring(dotIndex+roundDigit-2,dotIndex+roundDigit);
                               roundNoStr = roundNoStr.substring(0,dotIndex+roundDigit-2)+ roundNoRndStr; 
                              }     
                      }

                        
                  */
  
                                                
                    }   else if (countYmf11==0.0) { out.println("&nbsp;"); }
                        else { out.println("&nbsp;"); }  
				  
                  %></font></div>
                </td>                
                <td width="6%" rowspan="1"><div align="center"><font size="2">
                 
                  <%
                    if (countTpeShipf12>0 && countYmf12 !=0) 
                    { 
                     
                      float rate12 = (countYmf12/countTpeShipf12)*100;
                      miscellaneousBean.setRoundDigit(2);
                      String rate12Str = miscellaneousBean.getFloatRoundStr(rate12);
                      out.println(rate12Str+"%");  
                           
                     }  else if (countYmf12==0.0) { out.println("&nbsp;"); }
                        else { out.println("&nbsp;"); }                    
                  %></font></div>
                </td>
             
                  <%
                    try
                    { 
                      if (totTpeShipOut>0 && totCountYmRet>0)
                      {      
                        float rateTot = Math.round((totCountYmRet/totTpeShipOut)*100); 
                        String rateTotStr = Float.toString(rateTot);
                        int rateTotLth = rateTotStr.length();
                        if (rateTotLth>5)
                        {   rateTotStr = rateTotStr.substring(0,5);  }
                        else if (rateTotLth==4) {   rateTotStr = rateTotStr.substring(0,4);  }        
                        else {  rateTotStr = rateTotStr.substring(0,3);  }
   
                        if (rateTot==0.0) { out.println("&nbsp;");  }                
                        else { 
                              // out.println(rateTotStr+"%"); 
                                    
                             } 
                      } 
                      else { out.println("&nbsp;"); }         
                    } //end of try
                    catch (Exception e)
                    {
                      out.println("Exception:"+e.getMessage());
                    }                
                      //out.println(rate12Str+"%");
                  %>        
               </tr>               
                <%
                      //初值清空,於每個機種計算完成後            
                            sumAcc1 =0;sumAcc2 = 0;sumAcc3 = 0;sumAcc4 = 0;sumAcc5 = 0; sumAcc6 = 0;
                            sumAcc7 =0;sumAcc8 = 0;sumAcc9 = 0;sumAcc10 = 0;sumAcc11 = 0; sumAcc12 = 0 ; 

                            sumAccTpeShip1 =0;sumAccTpeShip2 = 0;sumAccTpeShip3 = 0;sumAccTpeShip4 = 0;sumAccTpeShip5 = 0; sumAccTpeShip6 = 0;
                            sumAccTpeShip7 =0;sumAccTpeShip8 = 0;sumAccTpeShip9 = 0;sumAccTpeShip10 = 0;sumAccTpeShip11 = 0; sumAccTpeShip12 = 0 ;   

                         cntModelLunDate++;  // For Excel Accmulate 
                      }  // End of While
                      //dateBean.setAdjMonth(-11);
                      rsIM.close();
                      stateIM.close(); 
   
                     //cntLunDate = cntModelLunDate*3+7;  // 本次的機種Span Grid=機種數*3(出貨數、退貨數、客退率)+3(Total)+初值(4) 
                     cntLunDate++;    
                        

                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }   
                %> 
               <TR bgcolor="#FFFFFF">
                 <td width="5%" nowrap rowspan="3"><div align="center"><span class="style2"><font size="2">Total</font></span></div></td>
                 <td width="9%" nowrap><div align="center"><font face="標楷體" size="2">當週累計出貨數</font></div></td>
                 
                    <% 
                      if (sumTpeShipPrevYear2f>0)
                      {//out.println(Math.round(sumTpeShipPrevYear2f));
                      }
                      else { out.println("&nbsp;");  }      
                    %>
                   <% 
                      if (sumTpeShipPrevYear1f>0)
                      {//out.println(Math.round(sumTpeShipPrevYear1f));
                      }
                      else { out.println("&nbsp;");  }      
                    %>    
                 <td><div align="center"><font size="2" color="#660000"><strong>
                    <% 
                       if (sumTpeShip1f>0)        
                       { out.println(Math.round(sumTpeShip1f)); }
                       else { 
                             out.println("&nbsp;");
                            } 
                        //sumTotAccTpeShip1 = sumTpeShipPrevYear2f + sumTpeShipPrevYear1f; // 加總累積出貨數 
                         sumTotAccTpeShip1 = sumTpeShipPrevYear1f; // 加總累積出貨數 
                    %></strong></font></div></td>                  
                 <td><div align="center"><font size="2" color="#660000"><strong>
                    <% 
                       if (sumTpeShip2f>0)        
                       { out.println(Math.round(sumTpeShip2f)); }
                       else { 
                             out.println("&nbsp;");
                            } 
                        sumTotAccTpeShip2 = sumTotAccTpeShip1 +  sumTpeShip1f; // 加總累積出貨數      
                    %></strong></font></div></td> 
                
                 <td><div align="center"><font size="2" color="#660000"><strong>
                        <% 
                           if (sumTpeShip3f>0)        
                           { out.println(Math.round(sumTpeShip3f)); }
                           else { 
                                 out.println("&nbsp;");
                                }
                          sumTotAccTpeShip3 = sumTotAccTpeShip2 +  sumTpeShip2f; // 加總累積出貨數        
                        %></strong></font></div></td> 
                 
                 <td><div align="center"><font size="2" color="#660000"><strong>
                        <% 
                          
                           if (sumTpeShip4f>0)        
                           { out.println(Math.round(sumTpeShip4f)); }
                           else { 
                                 out.println("&nbsp;");
                                }
                          sumTotAccTpeShip4 = sumTotAccTpeShip3 +  sumTpeShip3f; // 加總累積出貨數        
                        %></strong></font></div></td> 
                
                 <td><div align="center"><font size="2" color="#660000"><strong>
                        <% 
                           if (sumTpeShip5f>0)        
                           { out.println(Math.round(sumTpeShip5f)); }
                           else { 
                                 out.println("&nbsp;");
                                }
                          sumTotAccTpeShip5 = sumTotAccTpeShip4 +  sumTpeShip4f; // 加總累積出貨數        
                        %></strong></font></div></td> 
                 
                 <td><div align="center"><font size="2" color="#660000"><strong>
                        <% 
                           if (sumTpeShip6f>0)        
                           { out.println(Math.round(sumTpeShip6f)); }
                           else { 
                                 out.println("&nbsp;");
                                }
                          sumTotAccTpeShip6 = sumTotAccTpeShip5 +  sumTpeShip5f; // 加總累積出貨數        
                        %></strong></font></div></td> 
                 
                 <td><div align="center"><font size="2" color="#660000"><strong>
                        <% 
                           if (sumTpeShip7f>0)        
                           { out.println(Math.round(sumTpeShip7f)); }
                           else { 
                                 out.println("&nbsp;");
                                }
                          sumTotAccTpeShip7 = sumTotAccTpeShip6 +  sumTpeShip6f; // 加總累積出貨數        
                        %></strong></font></div></td> 
                 
                 <td width="5%"><div align="center"><font size="2" color="#660000"><strong>
                        <% 
                           if (sumTpeShip8f>0)        
                           { out.println(Math.round(sumTpeShip8f)); }
                           else { 
                                 out.println("&nbsp;");
                                }
                          sumTotAccTpeShip8 = sumTotAccTpeShip7 +  sumTpeShip7f; // 加總累積出貨數        
                        %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                        <% 
                           if (sumTpeShip9f>0)        
                           { out.println(Math.round(sumTpeShip9f)); }
                           else { 
                                 out.println("&nbsp;");
                                }
                          sumTotAccTpeShip9 = sumTotAccTpeShip8 +  sumTpeShip8f; // 加總累積出貨數        
                        %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                        <% 
                           if (sumTpeShip10f>0)        
                           { out.println(Math.round(sumTpeShip10f)); }
                           else { 
                                 out.println("&nbsp;");

                                }
                          sumTotAccTpeShip10 = sumTotAccTpeShip9 +  sumTpeShip9f; // 加總累積出貨數        
                        %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                        <% 
                           if (sumTpeShip11f>0)        
                           { out.println(Math.round(sumTpeShip11f)); }
                           else { 
                                 out.println("&nbsp;");
                                }
                          sumTotAccTpeShip11 = sumTotAccTpeShip10 +  sumTpeShip10f; // 加總累積出貨數        
                        %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                        <% 
                           if (sumTpeShip12f>0)        
                           { out.println(Math.round(sumTpeShip12f)); }
                           else { 
                                 out.println("&nbsp;");
                                }
                          sumTotAccTpeShip12 = sumTotAccTpeShip11 +  sumTpeShip11f; // 加總累積出貨數        
                        %></strong></font></div></td> 

               
                        <% 
                          sumTotTpeShipOut = 0;
                          //sumTotTpeShipOut = sumTpeShipPrevYear2f+sumTpeShipPrevYear1f+sumTpeShip1f+sumTpeShip2f+sumTpeShip3f+sumTpeShip4f+sumTpeShip5f+sumTpeShip6f+sumTpeShip7f+sumTpeShip8f+sumTpeShip9f+sumTpeShip10f+sumTpeShip11f+sumTpeShip12f; 
                          sumTotTpeShipOut = sumTpeShipPrevYear1f+sumTpeShip1f+sumTpeShip2f+sumTpeShip3f+sumTpeShip4f+sumTpeShip5f+sumTpeShip6f+sumTpeShip7f+sumTpeShip8f+sumTpeShip9f+sumTpeShip10f+sumTpeShip11f+sumTpeShip12f; 
                //          out.println(Math.round(sumTotTpeShipOut));
                          //sumTotAccTpeShip12 = sumTotAccTpeShip11 +  sumTpeShip11f; // 加總累積出貨數        
                        %>            
               </TR>
               <TR>
                 <td width="9%" nowrap><div align="center"><font face="標楷體" size="2">當週累計退貨數</font></div></td>
                 
                       <% 
                          if (sumPrevYear2>0)
                          {          
                          // out.println(Math.round(sumPrevYear2)); 
                          } else { out.println("&nbsp;"); }     
                       %>
                       <% 
                          if (sumPrevYear1>0)
                          {          
                           // out.println(Math.round(sumPrevYear1)); 
                          } else { out.println("&nbsp;"); } 
                       %>   
                 <td><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm1>0)
                          {    
                           out.println(Math.round(sumYm1)); 
                          } else { out.println("&nbsp;"); } 
                          //sumTotAcc1 = sumPrevYear2 + sumPrevYear1 + sumYm1; // 加總累積退貨數 
                          sumTotAcc1 = sumPrevYear1 + sumYm1; // 加總累積退貨數    
                       %></strong></font></div></td>                  
                 <td><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm2>0)
                          {    
                           out.println(Math.round(sumYm2)); 
                          } else { out.println("&nbsp;"); } 
                          sumTotAcc2 = sumTotAcc1 + sumYm2; // 加總累積退貨數       
                       %></strong></font></div></td> 
                
                 <td><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm3>0)
                          {    
                           out.println(Math.round(sumYm3)); 
                          } else { out.println("&nbsp;"); }  
                          sumTotAcc3 = sumTotAcc2 + sumYm3; // 加總累積退貨數       
                       %></strong></font></div></td> 
                 
                 <td><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm4>0)
                          {    
                           out.println(Math.round(sumYm4)); 
                          } else { out.println("&nbsp;"); }  
                          sumTotAcc4 = sumTotAcc3 + sumYm4; // 加總累積退貨數       
                       %></strong></font></div></td> 
                
                 <td><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm5>0)
                          {    
                           out.println(Math.round(sumYm5)); 
                          } else { out.println("&nbsp;"); }   
                          sumTotAcc5 = sumTotAcc4 + sumYm5; // 加總累積退貨數       
                       %></strong></font></div></td> 
                 
                 <td><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm6>0)
                          {    
                           out.println(Math.round(sumYm6)); 
                          } else { out.println("&nbsp;"); }
                          sumTotAcc6 = sumTotAcc5 + sumYm6; // 加總累積退貨數       
                       %></strong></font></div></td> 
                 
                 <td><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm7>0)
                          {    
                           out.println(Math.round(sumYm7)); 
                          } else { out.println("&nbsp;"); }
                          sumTotAcc7 = sumTotAcc6 + sumYm7; // 加總累積退貨數       
                       %></strong></font></div></td> 
                 
                 <td width="5%"><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm8>0)
                          {    
                           out.println(Math.round(sumYm8)); 
                          } else { out.println("&nbsp;"); }
                          sumTotAcc8 = sumTotAcc7 + sumYm8; // 加總累積退貨數       
                       %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm9>0)
                          {    
                           out.println(Math.round(sumYm9)); 
                          } else { out.println("&nbsp;"); }
                          sumTotAcc9 = sumTotAcc8 + sumYm9; // 加總累積退貨數       
                       %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm10>0)
                          {    
                           out.println(Math.round(sumYm10)); 
                          } else { out.println("&nbsp;"); }
                          sumTotAcc10 = sumTotAcc9 + sumYm10; // 加總累積退貨數       
                       %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                          if (sumYm11>0)
                          {    
                           out.println(Math.round(sumYm11)); 
                          } else { out.println("&nbsp;"); }
                          sumTotAcc11 = sumTotAcc10 + sumYm11; // 加總累積退貨數       
                       %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                           if (sumYm12>0)
                          {    
                           out.println(Math.round(sumYm12)); 
                          } else { out.println("&nbsp;"); }
                          sumTotAcc12 = sumTotAcc11 + sumYm12; // 加總累積退貨數       
                       %></strong></font></div></td> 

                       <% 
                          sumTotCountYmRet = 0;
                          //sumTotCountYmRet = sumPrevYear2+sumPrevYear1+sumYm1+sumYm2+sumYm3+sumYm4+sumYm5+sumYm6+sumYm7+sumYm8+sumYm9+sumYm10+ sumYm11+sumYm12;              
                          sumTotCountYmRet = sumPrevYear1+sumYm1+sumYm2+sumYm3+sumYm4+sumYm5+sumYm6+sumYm7+sumYm8+sumYm9+sumYm10+ sumYm11+sumYm12;              
                   //       out.println(Math.round(sumTotCountYmRet)); 
                          //sumTotAcc12 = sumTotAcc11 + sumYm12; // 加總累積退貨數       
                       %>           
               </TR>
               <TR>
                 <td width="9%" nowrap><div align="center"><font face="標楷體" size="2"><strong>當週累計客退率</strong></font></div></td>
                 
                       <% 
                          //out.println((countPrevYear2/sumTpeShipPrevYear2f*100)+"%"); 
                        try
                        {  
                          if (sumTpeShipPrevYear2f>0 && countPrevYear2 !=0) 
                          {               
                           //float rate1 = Math.round((countYmf1/sumTpeShip1f)*100); 
                           //float rate1 = (countYmf1/countTpeShipf1)*100;
                           //out.println(countPrevYear2);out.println(" / "+ sumTpeShipPrevYear2f);
                           float rate = (sumPrevYear2/sumTpeShipPrevYear2f)*100;  
                           String rateStr = Float.toString(rate);
                           int rateLth = rateStr.length();
                           if (rateLth>5)
                           {   rateStr = rateStr.substring(0,4);  }
                           else if (rateLth==4) {   rateStr = rateStr.substring(0,4);  }        
                           else {  rateStr = rateStr.substring(0,3);  }
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { 
                                 //out.println(rateStr+"%");
                                }
                         } else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        }         
                       %>
                      <% 
                        //  out.println((countPrevYear1/sumTpeShipPrevYear1f*100)+"%"); 
                        try
                        {  
                          if (sumTpeShipPrevYear1f>0 && sumPrevYear1 !=0) 
                          { //out.println("sumTpeShipPrevYear1f="+sumTpeShipPrevYear1f); out.println("sumPrevYear1="+sumPrevYear1);               
                           //float rate1 = Math.round((countYmf1/sumTpeShip1f)*100); 
                           //float rate1 = (countYmf1/countTpeShipf1)*100;
                           float rate = (sumPrevYear1/sumTpeShipPrevYear1f)*100;  
                           String rateStr = Float.toString(rate);
                           int rateLth = rateStr.length();
                           if (rateLth>5)
                           {   rateStr = rateStr.substring(0,4);  }
                           else if (rateLth==4) {   rateStr = rateStr.substring(0,4);  }        
                           else {  rateStr = rateStr.substring(0,3);  }
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { //out.println(rateStr+"%"); 
                                }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        }     
                      %>   
                 <td><div align="center"><font size="2" color="#660000"><strong>
                       <%
                        try
                        {  
                          if (sumTpeShip1f>0 && sumYm1 !=0) 
                          {                                                                 
                           float rate = (sumYm1/sumTpeShip1f)*100;

                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
                    
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        }       
                       %></strong></font></div>
                 </td>                  
                 <td><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                        try
                        {  
                          if (sumTpeShip2f>0 && sumYm2 !=0)  
                          {               
                           
                           //float rate = (sumTotAcc2/sumTotAccTpeShip2)*100; 
                           float rate = (sumYm2/sumTpeShip2f)*100; 

                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        }   
                      %></strong></font></div></td>                 
                 <td><div align="center"><font size="2" color="#660000"><strong>
                      <% 
                        try
                        {  
                          if (sumTpeShip3f>0 && sumYm3 !=0) 
                          {               
                          
                           //float rate = (sumTotAcc3/sumTotAccTpeShip3)*100; 
                           float rate = (sumYm3/sumTpeShip3f)*100; 
  
                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        }  
                     %></strong></font></div></td> 
                 
                 <td><div align="center"><font size="2" color="#660000"><strong>
                      <% 
                        try
                        {  
                          if (sumTpeShip4f>0 && sumYm4 !=0)  
                          {               
                           
                           //float rate = (sumTotAcc4/sumTotAccTpeShip4)*100; 
                           float rate = (sumYm4/sumTpeShip4f)*100;       
                           
                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        }  
                     %></strong></font></div></td> 
                
                 <td><div align="center"><font size="2" color="#660000"><strong>
                     <% 
                        try
                        {  
                          if (sumTpeShip5f>0 && sumYm5 !=0) 
                          {               
                           
                           //float rate = (sumTotAcc5/sumTotAccTpeShip5)*100;
                           float rate = (sumYm5/sumTpeShip5f)*100;

                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
                                    
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        }  
                     %></strong></font></div></td> 
                 
                 <td><div align="center"><font size="2" color="#660000"><strong>
                    <% 
                        try
                        {  
                          if (sumTpeShip6f>0 && sumYm6 !=0)  
                          {              
                           
                           //float rate = (sumTotAcc6/sumTotAccTpeShip6)*100;  
                           float rate = (sumYm6/sumTpeShip6f)*100; 
                           
                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
                            
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        }  
                    %></strong></font></div></td> 
                 
                 <td><div align="center"><font size="2" color="#660000"><strong>
                     <% 
                        try
                        {  
                          if (sumTpeShip7f>0 && sumYm7 !=0)
                          {                
                           
                           //float rate = (sumTotAcc7/sumTotAccTpeShip7)*100; 
                           float rate = (sumYm7/sumTpeShip7f)*100;
                           
                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
                            
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        }  
                     %></strong></font></div></td> 

                 
                 <td width="5%"><div align="center"><font size="2" color="#660000"><strong>
                       <% 
                        try
                        {  
                          if (sumTpeShip8f>0 && sumYm8 !=0) 
                          {               
                           
                           //float rate = (sumTotAcc8/sumTotAccTpeShip8)*100; 
                           float rate = (sumYm8/sumTpeShip8f)*100; 
                           
                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
                            
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        }  
                     %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                     <% 
                        try
                        {  
                          if (sumTpeShip9f>0 && sumYm9 !=0)  
                          {               
                          
                           //float rate = (sumTotAcc9/sumTotAccTpeShip9)*100; 
                           float rate = (sumYm9/sumTpeShip9f)*100;               
                           
                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
                            
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        } 
                     %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                     <% 
                        try
                        {  
                          if (sumTpeShip10f>0 && sumYm10 !=0)   
                          {                
                           
                           //float rate = (sumTotAcc10/sumTotAccTpeShip10)*100; 
                           float rate = (sumYm10/sumTpeShip10f)*100;   
                           
                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
                            
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        } 
                     %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                     <% 
                        try
                        {  
                          if (sumTpeShip11f>0 && sumYm11 !=0)
                          {               
                           
                           //float rate = (sumTotAcc11/sumTotAccTpeShip11)*100; 
                           float rate = (sumYm11/sumTpeShip11f)*100;      
                           
                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
                            
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        } 
                     %></strong></font></div></td> 
                 
                 <td width="6%"><div align="center"><font size="2" color="#660000"><strong>
                      <%
                        try
                        {  
                          if (sumTpeShip12f>0 && sumYm12 !=0)
                          {               
                           
                           //float rate = (sumTotAcc12/sumTotAccTpeShip12)*100;
                           float rate = (sumYm12/sumTpeShip12f)*100;    
                           
                           miscellaneousBean.setRoundDigit(2);
                           String rateStr = miscellaneousBean.getFloatRoundStr(rate);
                            
  
                           if (rate==0.0) { out.println("&nbsp;");  }                
                           else { out.println(rateStr+"%"); }
                         } 
                         else { out.println("&nbsp;"); }
                        } //end of try
                        catch (Exception e)
                        {
                         out.println("Exception:"+e.getMessage());
                        } 
                    %></strong></font></div></td> 

                
                    <% 
                     //  out.println(countYm12); 
                     try
                     { 
                      if (sumTotTpeShipOut>0 && sumTotCountYmRet>0)
                      {      
                        float rateSumTot = Math.round((sumTotCountYmRet/sumTotTpeShipOut)*100); 
                        
                        //miscellaneousBean.setRoundDigit(2);
                        //String rateStr = miscellaneousBean.getFloatRoundStr(rateSumTot);
                            
   
                        if (rateSumTot==0.0) { out.println("&nbsp;");  }                
                        else { 
                               //out.println(rateSumTotStr+"%");
                             } 
                      }  
                      else { out.println("&nbsp;"); }          
                    } //end of try
                    catch (Exception e)
                    {
                      out.println("Exception:"+e.getMessage());
                    }    
                    %>           
      </TR> 
      <%
                            // Total 初值依上市日期,清空 
                            sumTotAcc1 =0;sumTotAcc2 = 0;sumTotAcc3 = 0;sumTotAcc4 = 0;sumTotAcc5 = 0; sumTotAcc6 = 0;
                            sumTotAcc7 =0;sumTotAcc8 = 0;sumTotAcc9 = 0;sumTotAcc10 = 0;sumTotAcc11 = 0; sumTotAcc12 = 0 ; 

                            sumTotAccTpeShip1 =0;sumTotAccTpeShip2 = 0;sumTotAccTpeShip3 = 0;sumTotAccTpeShip4 = 0;sumTotAccTpeShip5 = 0; sumTotAccTpeShip6 = 0;
                            sumTotAccTpeShip7 =0;sumTotAccTpeShip8 = 0;sumTotAccTpeShip9 = 0;sumTotAccTpeShip10 = 0;sumTotAccTpeShip11 = 0; sumTotAccTpeShip12 = 0;                                      
      %>                    
  </table>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============¢FFFFFDH?U¢FFFFFXI?q?¢FFFFFXAAcn3s¢FFFFGg2|A==========-->
<!--%@ include file="/jsp/include/ReleaseConnMESPage.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnBPCSDistPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSTelPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
