<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="DateBean,RsCountBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<html>
<head>
<title> Telnet Command --> Export RFQ Production Schema and FTP to DEV</title>
<STYLE TYPE='text/css'>
  .style1 {color: #003399}
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}
             
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
</script>
<body>
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>
<!--%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%-->
<FORM METHOD="POST" NAME="MYFORM"> 
<strong><font color="#004080" size="4">Execute Export RFQ and FTP Shell Command STATUS</font></strong><BR>
<%@ include file="/jsp/include/TelnetToProd_Oracle.jsp"%>
<%
if (telnetBean_PROD.getInuse()==false) //如果telnetBean_PROD無人在使用才能進入
{   
   if (telnetBean_PROD.isMonReady==true)  //測試連線是否正常且可以正常使用
   {
		telnetBean_PROD.setOpMan(UserName); 
		telnetBean_PROD.setOpTime(dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute());
		telnetBean_PROD.setInuse(true); //第一件事即先設定成使用中
		   // Step1. 執行Export Table Schema Shell
		        try
				{      
				  telnetBean_PROD.runComnd("/orappl/proddb/9.2.0/dmpbackup/exp_prod_ORADDMAN.sh");
				 
				  //telnetBean_PROD.specialRunComnd("/home/pgsrc/cron610/tppo2shco_all.sh dbexp "+userMail); //
					int cc=0;
					while (true)
					{
					  java.lang.Thread.sleep(5000);					 
					  System.err.println("count:"+cc+" waiting......;");
					  if (cc>24) //若等待時間超過3分鐘則停止作業(設Export2分鐘之內結束)
					  {	    
						//telnetBean_PROD.disconnect(); 
						 out.println("<BR><strong><font color='RED' size=3>連線PROD主機異常...請稍後再試!!</font></strong>");
						break; 	    
					  }	else {
						
					         }
					  cc++;
					  
					} //enf of while -> 等待迴圈	  
				  out.println("於PROD執行Export RFQ Table Schema Shell完成 !");
				} //end of try
				catch (Exception e)
				{
				 out.println("JSP Exception:"+e.getMessage());
				}
		 // Step2. 執行FTP Dump File to DEV host Shell
				try
				{      
				  telnetBean_PROD.runComnd("/orappl/proddb/9.2.0/dmpbackup/ftp_hptest_rfq.sh");				  
				  //telnetBean_PROD.specialRunComnd("/home/pgsrc/cron610/tppo2shco_all.sh dbexp "+userMail); //
					int cc=0;
					while (true)
					{
					  java.lang.Thread.sleep(5000);					 
					  System.err.println("count:"+cc+" waiting......;");
					  if (cc>12) //若等待時間超過1分鐘則停止作業(設Ftp1分鐘內完成)
					  {	    
						telnetBean_PROD.disconnect(); 
						 out.println("<BR><strong><font color='RED' size=3>連線PROD主機異常...請稍後再試!!</font></strong>");
						break; 	    
					  }	else {
						
					         }
					  cc++;
					  
					} //enf of while -> 等待迴圈	  
				  out.println("於PROD執行FTP Dump file to DEV Shell完成 !");
				} //end of try
				catch (Exception e)
				{
				 out.println("JSP Exception:"+e.getMessage());
				}
				
		
		telnetBean_PROD.setInuse(false); //設定為離開使用中狀態
   } else {
      out.println("<BR><strong><font color='RED' size=3>連線PROD主機異常...請稍後再試!!</font></strong>");
   } //end of if -> telnetBean_PROD.isMonReady		
} else { 
  out.println("<BR><strong><font color='RED' size=3>連線PROD忙碌中...請稍後再試!!</font></strong>");
} //end of if -> telnetBean_PROD.getInuse()==false	
%>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>
<!--=============Process End==========-->
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
