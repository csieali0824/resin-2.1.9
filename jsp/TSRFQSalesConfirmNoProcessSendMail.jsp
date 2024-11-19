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
			
	
	 dateBean.setAdjDate(-4); //前4天
	 String strFirstDayWeek = dateBean.getYearMonthDay();	 
     dateBean.setAdjDate(4); //取今天
	 String strLastDayWeek = dateBean.getYearMonthDay();

    String sSqlMailUser = "select DISTINCT USERMAIL,USERNAME "+
	                        "from ORADDMAN.WSUSER, ORADDMAN.WSGROUPUSERROLE "+
	                       "where USERNAME=GROUPUSERNAME and LOCKFLAG='N' and ( ROLENAME in ('admin', 'MPC_User')  "+
						   "  or WEBID in ( SELECT DISTINCT c.CREATED_BY "+
						                   "   FROM oraddman.tssales_area b, oraddman.tsdelivery_notice c, "+
										            "oraddman.tsdelivery_notice_detail d, oraddman.tsprod_manufactory e, "+
													"(SELECT d1.dndocno, SUM(DECODE(d1.sdrq_exceed, 'Y', 1, 0) ) AS sdrqcount "+
												  	  " FROM oraddman.tsdelivery_notice_detail d1 GROUP BY d1.dndocno) f, "+
													  "      oraddman.tsdelivery_detail_history g "+
						                   "  WHERE c.dndocno = d.dndocno "+
                                           "    AND d.assign_manufact = e.manufactory_no(+) "+
										   "    AND b.locale = '886' "+
										   "    AND b.sales_area_no = c.tsareano AND d.dndocno = g.dndocno "+
										   "    AND d.line_no = g.line_no AND g.oristatusid = '007' " +
                                           "    AND ( ROUND ((  TO_DATE (TO_CHAR (SYSDATE,'YYYYMMDDHH24MISS'),'YYYYMMDDHH24MISS') - TO_DATE (g.cdatetime, 'YYYYMMDDHH24MISS') )* 24,2) > 72   "+
										   "    AND d.lstatusid <= '008' ) "+
										   "    AND SUBSTR(c.creation_date, 0, 8) >= '"+strFirstDayWeek+"' AND SUBSTR(c.creation_date, 0, 8) <= '"+strLastDayWeek+"' "+
										   "    AND f.dndocno = d.dndocno AND lstatusid NOT IN ('013') "+
										  ") ) ";
	Statement stmentMail=con.createStatement();
    ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	while(rsMail.next())
	{
	   try 
          {		     
		  
           sendMailBean.setMailHost(mailHost);					  
	       userMail=rsMail.getString("USERMAIL");
		   UserID = rsMail.getString("USERNAME");		   
		   urAddress = serverHostName+":8080/oradds/jsp/TSRFQSalesConfirmNoProcessRpt.jsp";		
           sendMailBean.setReception(userMail);
           sendMailBean.setFrom(UserID);     
        //   sendMailBean.setSubject(CodeUtil.unicodeToBig5("來自ORACLE系統的郵件:每週料件分類設定異常檢核表-("+strFirstDayWeek+"~"+strLastDayWeek+")")); 
		   sendMailBean.setSubject(CodeUtil.unicodeToBig5("RFQ System E-Mail- 交期已回覆,業務超過3日未處理明細表("+strFirstDayWeek+"~"+strLastDayWeek+")"));         
		   sendMailBean.setUrlName("Dear "+UserID+",\n"+CodeUtil.unicodeToBig5("   請點擊來自業務交期系統的郵件:企劃已確認交期,業務開單人員超過3日未繼續處理詢問單明細如下連結-->"));     
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
