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
	String UserID=null;
	String urAddress=null;   
	 String serverName=request.getServerName();
	String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
   
		    
	//String dateCurrentStr=request.getParameter("DATECURRENT");
	//String userMailID=request.getParameter("USERMAILID");
	String appUserID=request.getParameter("APPUSERID");
	String modelNo="";
    String appNo=request.getParameter("APPNO");
	
	String sqlModel = "select MODELNO from MRMODELAPP where APPNO='"+appNo+"' ";
    Statement stmModel=con.createStatement();
    ResultSet rsModel=stmModel.executeQuery(sqlModel);
    if (rsModel.next()) { modelNo = rsModel.getString("MODELNO"); } 
    rsModel.close();
    stmModel.close();           

    String sSqlMailUser = "select DISTINCT a.USERMAIL, a.WEBID from WSUSER a, MRPM_USER b, WSGROUPUSERROLE c where a.USERNAME=c.GROUPUSERNAME and a.WEBID=b.WEBID and (c.ROLENAME in('Admin','MRAdmin') or a.WEBID='"+appUserID+"') ";
    out.println("sSqlMailUser="+sSqlMailUser);
	Statement stmentMail=con.createStatement();
    ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	while(rsMail.next())
	{
	   try 
          {
           sendMailBean.setMailHost(mailHost);
	       userMail=rsMail.getString("USERMAIL");
		   UserID = rsMail.getString("WEBID");           
           String callMode = "MAIL"; 
		   //urAddress = "repairapp.dbtel.com.tw/repair/jsp/RepInfQuery2Excel.jsp?DATECURRENT="+dateCurrentStr;
           urAddress = serverName+"/wins/jsp/WSMRModelEncodeHistory.jsp?CALLMODE="+callMode+"&PMUSER="+appUserID+"&APPNO="+appNo;     
		   //urAddress = "wins.dbtel.com.tw/wins/jsp/WSMRModelEncodeHistory.jsp?PMUSER="+appUserID+"&APPNO="+appNo;
		   
           sendMailBean.setReception(userMail);
           sendMailBean.setFrom(UserID);     
           sendMailBean.setSubject(CodeUtil.unicodeToBig5("來自WINS系統的郵件:產品編碼申請通知("+appUserID+")您的產品編碼申請核准("+modelNo+")"));     
           //sendMailBean.setUrlAddr("repairapp.dbtel.com.tw/repair/jsp/RPEstimatingPage.jsp?REPNO=RP00320031007-070");
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
	rsMail.close();

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
