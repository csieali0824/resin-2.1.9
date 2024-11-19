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
<!--=================================-->
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
		
	   int dateIntYear=dateBean.getYear();
	   int dateIntMonth=dateBean.getMonth();
	   int dateIntDay=dateBean.getDay();
	   int dateCurrPre=0;
	String dateCurrPreStr=null;
	String dateStrYear=null;
	String dateStrMonth = null;
	String dateStrDay = null;
	String monEng = null;
	
	String monthFr =  Integer.toString(dateIntMonth);
	
    
	String dateCurrentStr=request.getParameter("DATECURRENT");
	if (dateCurrentStr==null){dateCurrentStr=dateBean.getYearMonthDay();}
	
	if (dateIntDay<= 7)
	{
	 dateIntMonth=dateIntMonth - 1;
	 if ((dateIntMonth==1)||(dateIntMonth==3)||(dateIntMonth==5)||(dateIntMonth==7)||(dateIntMonth==8)||(dateIntMonth==10)||(dateIntMonth==12))	
	 {	  
	  dateIntDay=(31-7+dateIntDay);
	 }
	 else if ((dateIntMonth==4)||(dateIntMonth==6)||(dateIntMonth==9)||(dateIntMonth==11))
	 {
	  dateIntDay=(30-7+dateIntDay);
	 }
	 else if ((dateIntMonth==2))
	 {
	  dateIntDay=(28-7+dateIntDay);	  
	 }
	}
	else
	{dateIntDay=dateIntDay-7;}
	
	dateStrYear=Integer.toString(dateIntYear);
	dateStrMonth=Integer.toString(dateIntMonth);
	dateStrDay=Integer.toString(dateIntDay);
	if (dateIntMonth<=9){dateStrMonth='0'+dateStrMonth;}
	if (dateIntDay<=9){dateStrDay='0'+dateStrDay;}
	
	dateCurrPre=dateIntYear*10000+dateIntMonth*100+dateIntDay;
	dateCurrPreStr=Integer.toString(dateCurrPre);
	

    String sSqlMailUser = "select USERMAIL,WEBID from WSUSER, WSGROUPUSERROLE where USERNAME=GROUPUSERNAME and ROLENAME in('admin','audit') ";
	Statement stmentMail=con.createStatement();
	ResultSet rs=stmentMail.executeQuery("select MENG from WSADMIN.WSMONTH_CODE where MMON_AR='"+monthFr+"' ");
	if (rs.next()){ monEng = rs.getString("MENG");}
	
    ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	while(rsMail.next())
	{
	   try 
          {
           sendMailBean.setMailHost(mailHost);
	       userMail=rsMail.getString("USERMAIL");
		   UserName= rsMail.getString("WEBID");
		   serverName=request.getServerName();
		   urlName = "Shipping Statistic Report :";
		   urlName1 = "Production Status Report : \n";
		   urlName2 = "AC Finished Statistic Report :";
		   urAddress = serverName+"/wins/jsp/WSShipStatisticAuto.jsp";
		   urAddress1 =  serverName+"/wins/jsp/WSProductionStatusAuto.jsp?COMPNO=08&&LOCALE=886&&YEARFR="+dateStrYear+"&&MONTHFR="+monthFr+" ";
		   urAddress2 = serverName+"/wins/jsp/ACPageByModelDbAuto.jsp?YEARFR="+dateStrYear+"&&MONTHFR="+monthFr+" ";
		
           sendMailBean.setReception(userMail);
           sendMailBean.setFrom(UserName);     
		   
           sendMailBean.setSubject(CodeUtil.unicodeToBig5("來自WINS系統的郵件:每日生產出貨報表- "+dateCurrentStr));     
           //sendMailBean.setUrlAddr("repairapp.dbtel.com.tw/repair/jsp/RPEstimatingPage.jsp?REPNO=RP00320031007-070");
		   sendMailBean.setUrlName(urlName);
		   sendMailBean.setUrlName1(urlName1);
		   sendMailBean.setUrlName2(urlName2);
	       sendMailBean.setUrlAddr(urAddress);
		   sendMailBean.setUrlAddr1(urAddress1);
		   sendMailBean.setUrlAddr2(urAddress2);
           sendMailBean.sendMail();
		   
		   
		  } //end of try
          catch (Exception e)
          {
           e.printStackTrace();
           out.println(e.getMessage());
          }//end of catch	
    }
	stmentMail.close();
	rs.close();
	rsMail.close();

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
