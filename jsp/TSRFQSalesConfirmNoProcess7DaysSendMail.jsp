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
	String serverHostName=request.getServerName();
	String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
	
	String hourSet = "168"; // 7天
			
	
	 dateBean.setAdjDate(-7); //前7天
	 String strFirstDayWeek = dateBean.getYearMonthDay();	
	 String dayFr =  dateBean.getDayString();
	 String monthFr =  dateBean.getMonthString();	
	 String yearFr = dateBean.getYearString();
     dateBean.setAdjDate(7); //取今天
	 String strLastDayWeek = dateBean.getYearMonthDay();
	 String dayTo =  dateBean.getDayString();
	 String monthTo =  dateBean.getMonthString();	
	 String yearTo = dateBean.getYearString();

    String sSqlMailUser = "select DISTINCT USERMAIL,USERNAME "+
	                        "from ORADDMAN.WSUSER, ORADDMAN.WSGROUPUSERROLE "+
	                       "where USERNAME=GROUPUSERNAME and LOCKFLAG='N' and ROLENAME in ('admin', 'FactoryManager','MPC_User') ";
						   
	Statement stmentMail=con.createStatement();
    ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	while(rsMail.next())
	{
	   try 
          {		     
		  
           sendMailBean.setMailHost(mailHost);					  
	       userMail=rsMail.getString("USERMAIL");
		   UserID = rsMail.getString("USERNAME");		   
		   urAddress = serverHostName+":8080/oradds/jsp/TSRFQSalesConfirmNoProcessRpt.jsp?HOURSET="+hourSet+"&DAYFR="+dayFr+"&MONTHFR="+monthFr+"&YEARFR="+yearFr+"&DAYTO="+dayTo+"&MONTHTO="+monthTo+"&YEARTO="+yearTo+"&DATESETBEGIN="+strFirstDayWeek+"&DATESETEND="+strLastDayWeek;		
           sendMailBean.setReception(userMail);
           sendMailBean.setFrom(UserID);     
        //   sendMailBean.setSubject(CodeUtil.unicodeToBig5("來自ORACLE系統的郵件:每週料件分類設定異常檢核表-("+strFirstDayWeek+"~"+strLastDayWeek+")")); 
		   sendMailBean.setSubject(CodeUtil.unicodeToBig5("RFQ System E-Mail- 交期已回覆,業務超過7日未處理明細表("+strFirstDayWeek+"~"+strLastDayWeek+")"));         
		   sendMailBean.setUrlName("Dear "+UserID+",\n"+CodeUtil.unicodeToBig5("   請點擊來自業務交期系統的郵件:企劃已確認交期,業務開單人員超過7日未繼續處理詢問單明細如下連結-->"));     
		   System.out.println("UserID="+UserID);
	       sendMailBean.setUrlAddr(urAddress);
		   System.out.println("userMail="+userMail);
           sendMailBean.sendMail();
		
		  } //end of try
          catch (Exception e)
          {
           e.printStackTrace();
           out.println(e.getMessage());
          }//end of catch	
    }
	stmentMail.close();
	rsMail.close();
	
	//workingDateBean.setAdjWeek(1);  // 把週別調整回來

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
