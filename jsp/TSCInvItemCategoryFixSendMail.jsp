<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,SendMailBean,WorkingDateBean,CodeUtil" %>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
</head>

<body>
<%
    

    String userMail=null;
	String UserID=null;
	String urAddress=null;		
	String urAddress1=null;
	
	String serverHostName=request.getServerName();
	String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name	
	String sSqlMailUser = "";
	
	String sqlExists = "select count(*) from MTL_ITEM_CATEGORIES where last_updated_by = 3077 "+
	                   "and to_char(last_update_date,'YYYYMMDD') >="+dateBean.getYearMonthDay();
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(sqlExists);
	if (rs.next() && rs.getInt(1)>0)
	{	

     sSqlMailUser = "select DISTINCT USERMAIL,USERNAME from ORADDMAN.WSUSER, ORADDMAN.WSGROUPUSERROLE where USERNAME=GROUPUSERNAME and ROLENAME in ('admin','sysaudit') "+
	                      //"and USERNAME='kerwin' "+
	                "and LOCKFLAG='N' ";
	
	 Statement stmentMail=con.createStatement();
     ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	 while(rsMail.next())
	 {
	   try 
          {		     
		  
           sendMailBean.setMailHost(mailHost);					  
	       userMail=rsMail.getString("USERMAIL");
		   UserID = rsMail.getString("USERNAME");		   
		   urAddress = serverHostName+":8080/oradds/LogFile/TSCInvCategoryFix"+dateBean.getYearMonthDay()+".html";	
		   urAddress1 = serverHostName+":8080/oradds/LogFile/TSCInvI3CategoryCostAccountFix"+dateBean.getYearMonthDay()+".html";		
		   
           sendMailBean.setReception(userMail);
           sendMailBean.setFrom(UserID);     
        //   sendMailBean.setSubject(CodeUtil.unicodeToBig5("來自ORACLE系統的郵件:每週料件分類設定異常檢核表-("+strFirstDayWeek+"~"+strLastDayWeek+")")); 
		   sendMailBean.setSubject(CodeUtil.unicodeToBig5("Oracle ERP Alert E-Mail-Daily Inventory Item Category Fix List("+dateBean.getYearMonthDay()+")"));         
		   sendMailBean.setUrlName("Dear "+UserID+",\n"+CodeUtil.unicodeToBig5("   請點擊來自ORACLE系統的郵件:每日料件分類異常系統自動更新表-("+dateBean.getYearMonthDay()+")"));     		   
		   //System.out.println("UserID="+UserID);
	       sendMailBean.setUrlAddr(urAddress);		   		  
		    sendMailBean.setUrlName1("\n"+CodeUtil.unicodeToBig5("   請點擊來自ORACLE系統的郵件:每日I3料件分類對應會計科目異常系統自動更新表-("+dateBean.getYearMonthDay()+")")); 
		   sendMailBean.setUrlAddr1(urAddress1);
           sendMailBean.sendMail();
		
		  } //end of try
          catch (Exception e)
          {
           e.printStackTrace();
           out.println(e.getMessage());
          }//end of catch	
     }  // End of While
	 stmentMail.close();
	 rsMail.close();
  } // End of If	
  rs.close(); 
  statement.close();
	
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
