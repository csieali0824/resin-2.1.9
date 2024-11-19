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
	String countError = "0";
	String serverHostName=request.getServerName();
	String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
			
	
	 dateBean.setAdjDate(-1);
	 String strFirstDayWeek = dateBean.getYearMonthDay();
	 String strLastDayWeek = strFirstDayWeek;
     dateBean.setAdjDate(1);

    String sSqlMailUser = "select DISTINCT USERMAIL,USERNAME,WEBID from ORADDMAN.WSUSER, ORADDMAN.WSGROUPUSERROLE where USERNAME=GROUPUSERNAME and ROLENAME in ('sysaudit') and LOCKFLAG='N' ";
	//out.println(sSqlMailUser);
	Statement stmentMail=con.createStatement();
    ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	while(rsMail.next())
	{
	  // 再找 當日有開單的名單發E-Mail
String Sqla=" select count(RHI.HEADER_INTERFACE_ID) 	as COUNTERROR "+	 
			"   from RCV_HEADERS_INTERFACE RHI,RCV_TRANSACTIONS_INTERFACE RTI,PO_INTERFACE_ERRORS PIE,PO_HEADERS_ALL POH  "+	
			"  where RHI.HEADER_INTERFACE_ID=RTI.HEADER_INTERFACE_ID "+	
			"        and PIE.INTERFACE_TRANSACTION_ID=RTI.INTERFACE_TRANSACTION_ID "+	
			"        and RTI.PO_HEADER_ID=POH.PO_HEADER_ID and RTI.PROCESSING_MODE_CODE = 'BATCH'		";	

	  Statement stmentRFQ=con.createStatement();
      ResultSet rsRFQ=stmentRFQ.executeQuery(Sqla);
	 // out.println(Sqla);
	  if (rsRFQ.next() && rsRFQ.getInt(1)>0) // 判斷昨日有開單的人,才寄送郵件
	  {
	   try 
          {		     
		  
           sendMailBean.setMailHost(mailHost);					  
	       userMail=rsMail.getString("USERMAIL");
		   UserID = rsMail.getString("USERNAME");		
		   getWebID = rsMail.getString("WEBID"); 
		   countError=rsRFQ.getString("COUNTERROR");
	       //userMail="lilian@mail.ts.com.tw";
		   //UserID ="liling";		
		   //getWebID ="AG000392"; 

 
		   urAddress = serverHostName+":8080/oradds/jsp/TSSHPRCVErrorManager.jsp";		
           sendMailBean.setReception(userMail);
           sendMailBean.setFrom(UserID);     
        //   sendMailBean.setSubject(CodeUtil.unicodeToBig5("來自ORACLE系統的郵件:每週料件分類設定異常檢核表-("+strFirstDayWeek+"~"+strLastDayWeek+")")); 
		   sendMailBean.setSubject(CodeUtil.unicodeToBig5("DropShip System E-Mail- Dropship Reveiving Interface Error("+strFirstDayWeek+"~"+strLastDayWeek+")"));         
		   sendMailBean.setUrlName("Dear "+UserID+",\n"+CodeUtil.unicodeToBig5("   請點擊來自DropShip系統的郵件:Reveiving Interface Error-("+strFirstDayWeek+"~"+strLastDayWeek+")"));     
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
   out.println(countError+" mails send completed!!");
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

