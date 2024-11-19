<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,SendMailBean,CodeUtil" %>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<!--=============以下區段為取得連結池==========-->
<%@include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%//@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=================================-->
</head>

<body>
<%
    String userMail=null;
	String UserName=null;
	String urlName =null;
		
	String urAddress=null;
	
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
	
    
	
	
	dateStrYear=Integer.toString(dateIntYear);
	dateStrMonth=Integer.toString(dateIntMonth);
	dateStrDay=Integer.toString(dateIntDay);
	if (dateIntMonth<=9){dateStrMonth='0'+dateStrMonth;}
	if (dateIntDay<=9){dateStrDay='0'+dateStrDay;}
	
	dateCurrPre=dateIntYear*10000+dateIntMonth*100+dateIntDay;
	dateCurrPreStr=Integer.toString(dateCurrPre);
	

    String sSqlMailUser = "select USERMAIL,WEBID from WSUSER, WSGROUPUSERROLE where USERNAME=GROUPUSERNAME and ROLENAME in('Audit_Admin','ITFIN-ADMIN') ";
    //String sSqlMailUser = "select Distinct USERMAIL,WEBID from WSUSER, WSGROUPUSERROLE where USERNAME=GROUPUSERNAME and WEBID='B01970' ";
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
		   urlName = "每月新增客戶資料表 :";
		   urAddress = serverName+"/wins/jsp/BpcsNewCustomerQueryNoAuth.jsp";		 
          
		     
		   //urAddress2 = serverName+"/wins/jsp/ACPageByModelDbAuto.jsp?YEARFR="+dateStrYear+"&MONTHFR="+monthFr+" ";
		
           sendMailBean.setReception(userMail);
           sendMailBean.setFrom("WINS");     
		   
           sendMailBean.setSubject(CodeUtil.unicodeToBig5("來自WINS系統的郵件:每月新增客戶資料表- "+dateBean.getYearMonthDay()));     
           //sendMailBean.setUrlAddr("repairapp.dbtel.com.tw/repair/jsp/RPEstimatingPage.jsp?REPNO=RP00320031007-070");
		   sendMailBean.setUrlName(CodeUtil.unicodeToBig5(urlName));		 
	       sendMailBean.setUrlAddr(urAddress);
		   
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
<%//@include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
