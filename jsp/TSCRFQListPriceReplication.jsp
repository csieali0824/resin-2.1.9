<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,SendMailBean,SendMailBean,CodeUtil" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSC RFQ ITEM LIST PRICE REPLICATION</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
</head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%> 
<%
  String serverHostName=request.getServerName();
  String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name

  String dateTransfer = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();	 
  String processStatus="";

  CallableStatement cs1 = con.prepareCall("{call TSC_RFQ_LISTPRICE_REPLICATE(?,?)}");		
  cs1.setString(1,dateTransfer);  /* 價格檔轉換日期時間 */	
  cs1.registerOutParameter(2, Types.VARCHAR); /*  轉換處理訊息 */	
  cs1.execute();
  processStatus = cs1.getString(2);
  
  out.println("Process Status Message :"+processStatus);
  
  if (processStatus=="Transfer Error" || processStatus.equals("Transfer Error"))
  {
       String UserName = "";
       Statement stateList=con.createStatement();
	   String sqlList = "select a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a,ORADDMAN.WSGROUPUSERROLE b where a.USERNAME = b.GROUPUSERNAME and b.ROLENAME = 'admin' ";
	   out.println("sqlList =:"+sqlList);	
       ResultSet rsList=stateList.executeQuery(sqlList);
	   while (rsList.next())
	   {   //out.println("USERMAIL="+rsList.getString("USERMAIL"));	
	       UserName = rsList.getString("USERNAME"); 
           sendMailBean.setMailHost(mailHost);
           sendMailBean.setReception(rsList.getString("USERMAIL"));
		   //sendMailBean.setReception("kerwin@mail.ts.com.tw");
           sendMailBean.setFrom(UserName);   	 	 
           sendMailBean.setSubject(CodeUtil.unicodeToBig5("Oracle QP List Price Transfer To RFQ System Error "));	 
           //sendMailBean.setBody(CodeUtil.unicodeToBig5("Case No.:")+dnDocNo);	
		   sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自交期詢問系統的郵件:Oracle QP List Line價格表同步RFQ系統異常-("+processStatus+")"));   	 
           sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSCRFQListPriceReplication.jsp");//
           sendMailBean.sendMail();
	   }
	   rsList.close();
	   stateList.close();
  } //End of if ()
%>
</body>
</html>
