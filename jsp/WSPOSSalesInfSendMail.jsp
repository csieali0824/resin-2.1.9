<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,SendMailBean,CodeUtil" %>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPOSPoolPage.jsp/"%>
<!--=============以上區段為取得連結池==========-->

</head>

<body>
<%
    String userMail=null;
	String UserName=null;
	String urlName =null;
	String urlName1 =null;
	String urlName2 =null;	
	String urAddress=null;
	String urAddress1=null;
	String urAddress2=null;
	//String urAddress3=null;
	//String urAddress4=null;
	//String urAddress5=null;
	String serverName=null;
	String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host nam
    String dateCurrent = dateBean.getYearMonthDay();

    String sSqlMailUser = "select USERMAIL,WEBID from WSUSER, WSGROUPUSERROLE where USERNAME=GROUPUSERNAME and ROLENAME in('admin') "+
                          "and WEBID in('B01345','B01732','B01815','B02498') ";
                          //"and WEBID in('B01815') ";
	Statement stmentMail=con.createStatement();
	//ResultSet rs=stmentMail.executeQuery("select MENG from WSADMIN.WSMONTH_CODE where MMON_AR='"+monthFr+"' ");
	//if (rs.next()){ monEng = rs.getString("MENG");}
	
    ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	while(rsMail.next())
	{
	   try 
          {
           sendMailBean.setMailHost(mailHost);
	       userMail=rsMail.getString("USERMAIL");
		   UserName= rsMail.getString("WEBID");
		   serverName=request.getServerName();
		   urlName = "POS-BPCS CO Check Report: ";
		   //urlName1 = "Production Status Report : \n";
		   //urlName2 = "AC Finished Statistic Report :";
		   urAddress = serverName+"/wins/jsp/WSPOSSalesInquiryAuto.jsp?DATECURRENT="+dateCurrent+" ";
           //urAddress = serverName+"/wins/jsp/WSPOSSalesInquiryAuto.jsp?STORE_NO=001&YEARFR="+dateStrYear+"&MONTHFR="+dateStrMonth+"&DAYTHFR="+dateStrDay+"&YEARTO="+dateStrYear+"&MONTHTO="+dateStrMonth+"&DAYTO="+dateStrDay+" ";   
		   //urAddress1 =  serverName+"/wins/jsp/WSProductionStatusAuto.jsp?COMPNO=08&&LOCALE=886&&YEARFR="+dateStrYear+"&&MONTHFR="+monthFr+" ";
		   //urAddress2 = serverName+"/wins/jsp/ACPageByModelDbAuto.jsp?YEARFR="+dateStrYear+"&&MONTHFR="+monthFr+" ";
		
           sendMailBean.setReception(userMail);
           sendMailBean.setFrom(UserName);     
		   
           sendMailBean.setSubject(CodeUtil.unicodeToBig5("來自WINS系統的郵件:每日POS系統銷售轉BPCS訂單檢核表"));     
           //sendMailBean.setUrlAddr("repairapp.dbtel.com.tw/repair/jsp/RPEstimatingPage.jsp?REPNO=RP00320031007-070");
		   sendMailBean.setUrlName(urlName);
		   //sendMailBean.setUrlName1(urlName1);
		   //sendMailBean.setUrlName2(urlName2);
	       sendMailBean.setUrlAddr(urAddress);
		   //sendMailBean.setUrlAddr1(urAddress1);
		   //sendMailBean.setUrlAddr2(urAddress2);
           sendMailBean.sendMail();
		   
		   
		  } //end of try
          catch (Exception e)
          {
           e.printStackTrace();
           out.println(e.getMessage());
          }//end of catch	
    }
	stmentMail.close();
	//rs.close();
	rsMail.close();

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPOSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDistPage.jsp"%>
<!--=================================-->
</html>
