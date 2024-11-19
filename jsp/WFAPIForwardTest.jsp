<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal.*,oracle.sql.*,oracle.jdbc.driver.*,oracle.apps.fnd.wf.engine.*,oracle.apps.fnd.wf.*"  %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Oracle Workflow Java Notification API Test</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
</head>
<%
   String notifyType=request.getParameter("NOTIFYTYPE"); // 傳入要處理的動作類型 
   String notifyID=request.getParameter("NOTIFYID"); // 傳入要處理的 NotificationID
  
   java.math.BigDecimal myNid = new java.math.BigDecimal(notifyID); 

 //WFContext ctx;   
 /* 
   oracle.apps.fnd.wf.WFDB myDB;
   oracle.apps.fnd.wf.WFContext ctx;
   
   myDB = new oracle.apps.fnd.wf.WFDB("apps", "apps", "jdbc:oracle:thin:@10.0.1.7:1523:CRP1", "CRP1");
   String m_charSet = System.getProperty("CHARSET");
   out.println("myDB="+myDB);
   out.println("m_charSet="+m_charSet);
   if (m_charSet == null) 
   { // cannot be null  
    m_charSet = "UTF8";
   }  
 try {  
        ctx = new oracle.apps.fnd.wf.WFContext(myDB, m_charSet);   // m_charSet is 'UTF8' by default  
		if (ctx.getDB().getConnection() == null) 
		{    // connection failed  
		 out.println("Error !!!");  
		 return;  
		}
		out.flush();
		//ctx.initCaches();

      // We now have a connection to the database.
     } catch (Exception e) 
       {
        // exit Message for this exception
		System.out.println("Error");
       }
	
*/   
 
   String  m_charSet = System.getProperty("CHARSET");
   
   if (m_charSet == null) 
   { // cannot be null   // 如果取不到字元集,則預設定為UTF8
     m_charSet = "UTF8";
   }   
   
   oracle.apps.fnd.wf.WFContext ctx = new oracle.apps.fnd.wf.WFContext(m_charSet); // m_charSet is 'UTF8' by default
   ctx.setJDBCConnection(con);  // con is a pre-established JDBC connection 
   
   
   if (notifyType==null) { out.println("You don't input Notification Type,No ID be tested !");  }
   else if (notifyType.equals("forward"))
         {
// Forward Test    (Test nid=300088)  
           // forward to KERWIN (本例會再Deligate一次,因為我又設定Delegate給SUMING)
           out.println("Delegate Test");  
           // 傳入要轉呈的人員,並取得該人員有幾筆待處理 open 的Notification
           java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, "KERWIN");
   
           // Forward 是將原Notification的RECIPIENT_ROLE改成新的人員
      
           out.println("There are " + count +     " open notification(s) for" + " KERWIN");
           out.println("Delegate nid " + myNid +     " from SUMING to KERWIN");
           WFNotificationAPI.forward(ctx, myNid, "KERWIN",    "CHEN, Please handle."); // 最後參數是顯示於 Workflow Detail的訊息
           count = WFNotificationAPI.workCount(ctx, "KERWIN");
           out.println("There are " + count +     " open notification(s) for" +     " KERWIN after Delegate.");
         }
		 else if (notifyType.equals("transfer"))
		      {
// Transfer Test    (Test nid=300016) 
                // 傳入要傳送的人員,並取得該人員有幾筆待處理 open 的Notification
                java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, "JINGKER");
                out.println("Transfer Test");
	            out.println("Transfer nid " + myNid +     " from SUMING to JINGKER");
	            WFNotificationAPI.transfer(ctx, myNid, "JINGKER",    "BY KERWIN WORKFLOW JAVA API TEST, You own this NOTIFICATION :"+myNid+" now.");
	            count = WFNotificationAPI.workCount(ctx, "JINGKER");
	            out.println("There are " + count +     " open notification(s) for" +   " JINGKER after Transfer.");

              }

%>
<body>
<!--=============以下區段為釋放連結池==========--> 
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>