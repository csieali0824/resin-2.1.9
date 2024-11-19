<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal.*,oracle.sql.*,oracle.jdbc.driver.*,oracle.apps.fnd.common.*,oracle.apps.fnd.wf.engine.*,oracle.apps.fnd.wf.*"  %>
<html>
<head>
<STYLE TYPE='text/css'>  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}
             
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Oracle Workflow Java Notification API Test</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="Array2DimensionInputBean"%>
<jsp:useBean id="wfProcess2DStatusBean" scope="session" class="Array2DimensionInputBean"/>
</head>
<%
   String [] choice=request.getParameterValues("CHKFLAG");

   String notifyType=request.getParameter("NOTIFYTYPE"); // 傳入要處理的動作類型 
   String notifyID=request.getParameter("NOTIFYID"); // 傳入要處理的 NotificationID
   String origName=request.getParameter("NAME"); // 原單據處理的人員
   String transName=request.getParameter("TRANSNAME"); // 傳入轉單的人員
   String transComment=request.getParameter("TRANSCOMMENT"); // 傳入轉單的處理說明
   
   //String r[][]=new String[rowLength+1][8]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
  
  
   
   java.math.BigDecimal procStatID = new java.math.BigDecimal("103793");
 
   String  m_charSet = System.getProperty("CHARSET");
   
   if (m_charSet == null) 
   { // cannot be null   // 如果取不到字元集,則預設定為UTF8
     m_charSet = "UTF8";
	 //m_charSet = "WE8ISO8859P1";
   }   
   
   oracle.apps.fnd.wf.WFContext ctx = new oracle.apps.fnd.wf.WFContext(m_charSet); // m_charSet is 'UTF8' by default
   ctx.setJDBCConnection(con);  // con is a pre-established JDBC connection 
   
   
//   sSql = "SELECT NOTIFICATION_ID, FROM_USER,ORIGINAL_RECIPIENT, "+
//          " MESSAGE_TYPE, SUBJECT, BEGIN_DATE from APPLSYS.WF_NOTIFICATIONS ";	   		 
//   sWhere =  "where STATUS = 'OPEN' ";		  
//   sOrder = "order by BEGIN_DATE";
   
//   if (notificationID==null || notificationID.equals("--") || notificationID.equals("")) {sWhere=sWhere+"and NOTIFICATION_ID = 0 ";}
//   else {sWhere=sWhere+" and NOTIFICATION_ID = '"+notificationID+"'"; }   
//   if (origName==null || origName.equals("--") || origName.equals("")) {sWhere=sWhere+" ";}
//   else {sWhere=sWhere+" and ORIGINAL_RECIPIENT = '"+origName+"'"; }     
 
//   sOrder = "order by BEGIN_DATE";
  
//   sSql = sSql + sWhere+ sOrder;  
  //out.println("sSqlCNT="+sSqlCNT);  
//   Statement statementTC=con.createStatement();
//   ResultSet rsTC=statementTC.executeQuery(sSql);
//   while (rsTC.next())
//   {
       for (int j=0;j<choice.length ;j++)    
       {  
	       //out.println("choice[j]="+choice[j]);
   
           java.math.BigDecimal myNid = new java.math.BigDecimal(choice[j]); 
   
           if (notifyType==null) { out.println("You don't input Notification Type,No ID be tested !");  }
           else if (notifyType.equals("transfer"))
		        { String messageType = "";
				  String sSql = "SELECT NOTIFICATION_ID, FROM_USER, CONTEXT, "+
                                 " MESSAGE_TYPE, SUBJECT, BEGIN_DATE from APPLSYS.WF_NOTIFICATIONS "; 
                  String sWhere =  "where NOTIFICATION_ID = '"+choice[j]+"' ";
				  sSql = sSql + sWhere;
				  //out.println(sSql);
				  Statement state=con.createStatement();
                  ResultSet rs=state.executeQuery(sSql);
		          if (rs.next())
		          {
		            messageType = rs.getString("MESSAGE_TYPE");		            
		          } 
		          rs.close();
		          state.close();  
				
                // Transfer Test    (Test nid=300016) 
                 // 傳入要傳送的人員,並取得該人員有幾筆待處理 open 的Notification
                  java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, transName);
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
	              out.println("There are " + count +     " open notification(s) for <font color='#0000CC'>" +  transName+ "</font> after Transfer."+"<BR>");

                }
				
		} // End Of for		
			  
	// }  // End of While

%>
<BR>
<body>
<A href="/oradds/ORAddsMainMenu.jsp">Home</A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<A href="/oradds/jsp/OracleWorkflowNotificationQuery.jsp">Workflow Notification Query</A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<!--=============以下區段為釋放連結池==========--> 
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

