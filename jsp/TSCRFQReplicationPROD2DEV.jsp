<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectDevPoolPage.jsp"%>
<%@ page import="DateBean,RsCountBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<html>
<head>
<title> Telnet Command --> Replication RFQ Production To Develop</title>
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
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%> 
<FORM METHOD="POST" NAME="MYFORM"> 
<strong><font color="#004080" size="4">Execute Replication Shell Command STATUS</font></strong><BR>
<%@ include file="/jsp/include/TelnetToDev_Oracle.jsp"%>
<%
Statement statement=conDev.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
ResultSet rs=null;

if (telnetBean_TEST.getInuse()==false) //如果telnetBean_TEST無人在使用才能進入
{   
   if (telnetBean_TEST.isMonReady==true)  //測試連線是否正常且可以正常使用
   {
		telnetBean_TEST.setOpMan(UserName); 
		telnetBean_TEST.setOpTime(dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute());
		telnetBean_TEST.setInuse(true); //第一件事即先設定成使用中
		   // Step1. 執行Drop RFQ Table Schema Shell
		        try
				{      
				  telnetBean_TEST.runComnd("cd /orappl/devdb/9.2.0/dmpbackup"); 
				  telnetBean_TEST.runComnd("./drop_DEV_ORADDMAN.sh"); 
				  //telnetBean_TEST.specialRunComnd("/home/pgsrc/cron610/tppo2shco_all.sh dbexp "+userMail); //
					int cc=0;
					while (true)
					{
					  java.lang.Thread.sleep(5000);					 
					  //rs=statement.executeQuery("select * from ORADDMAN.ORADDMAN.WSUSER ");			
					  System.err.println("count:"+cc+" waiting......;");
					  if (cc>12) //若等待時間超過1分鐘則停止作業(Drop Test Schema 估計1分鐘內結束)
					  {	    
						telnetBean_TEST.disconnect(); 
						 out.println("<BR><strong><font color='RED' size=3>連線DEV主機異常...請稍後再試!!</font></strong>");
						break; 	    
					  }	else {
					           /*
						       if (!rs.next())
						       { //				倘若最後一個Drop 的Table亦不存在,表示Script 完成,則可直接完成		        
						         break;
							   } 
							   */
					         }
					  cc++;
					  //rs.close(); 
					} //enf of while -> 等待迴圈	  
				  out.println("於DEV執行Drop RFQ Table Schema Shell完成 !");
				} //end of try
				catch (Exception e)
				{
				 out.println("JSP Exception:"+e.getMessage());
				}
		 // Step2. 執行Import RFQ Table Schema Shell
				try
				{      
				  telnetBean_TEST.runComnd("cd /orappl/devdb/9.2.0/dmpbackup"); 
				  telnetBean_TEST.runComnd("./imp_2_DEV_ORADDMAN.sh"); 
				  //telnetBean_TEST.specialRunComnd("/home/pgsrc/cron610/tppo2shco_all.sh dbexp "+userMail); //
					int cc=0;
					while (true)
					{
					  java.lang.Thread.sleep(5000);					
					  //rs=statement.executeQuery("select * from ORADDMAN.ORADDMAN.WSUSER ");		 
					  System.err.println("count:"+cc+" waiting......;");
					  if (cc>24) //若等待時間超過2分鐘則停止作業(Import Test Schema估計僅需2分鐘即可結束)
					  {	    
						telnetBean_TEST.disconnect(); 
						 out.println("<BR><strong><font color='RED' size=3>連線DEV主機異常...請稍後再試!!</font></strong>");
						break; 	    
					  }	else {
					           /*
						       if (rs.next())
						       { //				倘若最後一個Import 的Table已存在,表示Script 完成,則可直接完成		        
						         break;
							   } 
							   */
					         }
					  cc++;
					  //rs.close();
					} //enf of while -> 等待迴圈	  
				  out.println("於DEV執行Import RFQ Table Schema Shell完成 !");
				} //end of try
				catch (Exception e)
				{
				 out.println("JSP Exception:"+e.getMessage());
				}
		//statement.close(); 		
		telnetBean_TEST.setInuse(false); //設定為離開使用中狀態
   } else {
      out.println("<BR><strong><font color='RED' size=3>連線DEV主機異常...請稍後再試!!</font></strong>");
   } //end of if -> telnetBean_TEST.isMonReady		
} else { 
  out.println("<BR><strong><font color='RED' size=3>連線DEV忙碌中...請稍後再試!!</font></strong>");
} //end of if -> telnetBean_TEST.getInuse()==false	
%>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnDevPage.jsp"%>
</html>
<!--=============Process End==========-->
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
