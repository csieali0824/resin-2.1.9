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
	String getWebID = null;
	String serverHostName=request.getServerName();
	String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
			
	
	 dateBean.setAdjDate(-1);
	 String strFirstDayWeek = dateBean.getYearMonthDay();
	 String strLastDayWeek = strFirstDayWeek;
     dateBean.setAdjDate(1);

    String sSqlMailUser = "select DISTINCT USERMAIL,USERNAME,WEBID from ORADDMAN.WSUSER, ORADDMAN.WSGROUPUSERROLE where USERNAME=GROUPUSERNAME and ROLENAME in ('admin','SalesDRQ_Creater') and LOCKFLAG='N' ";
	out.println(sSqlMailUser);
	Statement stmentMail=con.createStatement();
    ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	while(rsMail.next())
	{
	  // 再找 當日有開單的名單發E-Mail
	  Statement stmentRFQ=con.createStatement();
      ResultSet rsRFQ=stmentRFQ.executeQuery("select count(DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where CREATED_BY ='"+rsMail.getString("WEBID")+"' and substr(CREATION_DATE,0,8) = '"+strFirstDayWeek+"' ");
	  if (rsRFQ.next() && rsRFQ.getInt(1)>0) // 判斷昨日有開單的人,才寄送郵件
	  {
	   try 
          {		     
		  
           sendMailBean.setMailHost(mailHost);					  
	       userMail=rsMail.getString("USERMAIL");
		   UserID = rsMail.getString("USERNAME");		
		   getWebID = rsMail.getString("WEBID");   
		   urAddress = serverHostName+":8080/oradds/jsp/TSSDRQInformationQuery.jsp?LISTMODE=FALSE&CREATEDBY="+getWebID+"&DATESETBEGIN="+strFirstDayWeek+"&DATESETEND="+strLastDayWeek;		
           sendMailBean.setReception(userMail);
           sendMailBean.setFrom(UserID);     
        //   sendMailBean.setSubject(CodeUtil.unicodeToBig5("來自ORACLE系統的郵件:每週料件分類設定異常檢核表-("+strFirstDayWeek+"~"+strLastDayWeek+")")); 
		   sendMailBean.setSubject(CodeUtil.unicodeToBig5("RFQ System E-Mail- Daily Sales RFQ Document Create List("+strFirstDayWeek+"~"+strLastDayWeek+")"));         
		   sendMailBean.setUrlName("Dear "+UserID+",\n"+CodeUtil.unicodeToBig5("   請點擊來自業務交期系統的郵件:每日業務人員開立交期詢問單據清單-("+strFirstDayWeek+"~"+strLastDayWeek+")"));     
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
		}  // End of if (rsRFQ.next() && rsRFQ.getInt(1)>0)  
		stmentRFQ.close();
		rsRFQ.close();
		
		  
    } // End of while
	stmentMail.close();
	rsMail.close();
	
	workingDateBean.setAdjWeek(1);  // 把週別調整回來

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

