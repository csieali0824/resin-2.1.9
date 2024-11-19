<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal.*,oracle.sql.*,oracle.jdbc.driver.*,oracle.apps.fnd.common.*,oracle.apps.fnd.wf.engine.*,oracle.apps.fnd.wf.*"   %>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>Schedule Transfer User Workflow Notification</title>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
</head>

<body>
<% 
   String origName=request.getParameter("NAME"); // 原單據處理的人員
   String transName=request.getParameter("TRANSNAME"); // 傳入轉單的人員
   String transComment="Sytem Automatic Delegation"; // 傳入轉單的處理說明
   
   java.math.BigDecimal procStatID = new java.math.BigDecimal("103793");
 
   String  m_charSet = System.getProperty("CHARSET");
   
   if (m_charSet == null) 
   { // cannot be null   // 如果取不到字元集,則預設定為UTF8
     m_charSet = "UTF8";
	 //m_charSet = "WE8ISO8859P1";
   }   
   
   oracle.apps.fnd.wf.WFContext ctx = new oracle.apps.fnd.wf.WFContext(m_charSet); // m_charSet is 'UTF8' by default
   ctx.setJDBCConnection(con);  // con is a pre-established JDBC connection 
   
   

   Statement statement=con.createStatement();       
  
   String sSql = "SELECT NOTIFICATION_ID, FROM_USER, CONTEXT, MESSAGE_TYPE, SUBJECT, BEGIN_DATE "+
                 "  from APPLSYS.WF_NOTIFICATIONS ";	   		 
   String sWhere =  "where STATUS = 'OPEN' and MESSAGE_TYPE in ('REQAPPRV','POAPPRV') and (SUBJECT like '%2007%' or SUBJECT like '%2008%') "; // 只看PO 的
   
   if (origName!=null && !origName.equals("")) sWhere = sWhere + " and RECIPIENT_ROLE = '"+origName+"' ";
   else sWhere = sWhere + " and RECIPIENT_ROLE = 'XXX' ";  // 若沒給,表示無需轉單
   
   sSql = sSql + sWhere;
   
   java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, transName);
   
   ResultSet rs=statement.executeQuery(sSql);
   while (rs.next())
   {
      java.math.BigDecimal myNid = new java.math.BigDecimal(rs.getString("NOTIFICATION_ID")); 
	  String messageType = rs.getString("MESSAGE_TYPE");
	  
	  
	  // Transfer Test    (Test nid=300016) 
	  
         // 傳入要傳送的人員,並取得該人員有幾筆待處理 open 的Notification
                 
                  out.println("Transfer Successful !!!"+"<BR>");
	              out.println("Transfer nid <font color='#FF0000'>" + myNid +     "</font> from <font color='#0000CC'>"+origName+"</font> to <font color='#0000CC'>"+transName+"</font><BR>");
				  if (messageType.equals("OEOH"))
				  {
	                WFNotificationAPI.transfer(ctx, myNid, transName, transComment);	                
				  } else if (messageType.equals("POAPPRV") || messageType.equals("REQAPPRV")) 
				         {  //請採購單要用 Delegate
				           WFNotificationAPI.forward(ctx, myNid, transName, transComment);  
				         }	else 
						        {
						          WFNotificationAPI.transfer(ctx, myNid, transName, transComment);	      
						        }
				  count = WFNotificationAPI.workCount(ctx, transName);	
				  out.println("<font color='FF0000'>Notification:</font>"+rs.getString("SUBJECT")+" <font color='FF0000'>had been transfer to" +  transName+ "</font> <BR>");
	   
    
   }
   rs.close();
   statement.close();
   
    out.println("There are " + count +     " open notification(s) for <font color='#0000CC'>" +  transName+ "</font> after Transfer."+"<BR>");

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
