<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal.*,oracle.sql.*,oracle.jdbc.driver.*,oracle.apps.fnd.common.*,oracle.apps.fnd.wf.engine.*,oracle.apps.fnd.wf.*"  %>
<html>
<head>
<STYLE TYPE='text/css'>
  .style1 {color: #003399}
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
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
   String notifyType=request.getParameter("NOTIFYTYPE"); // 傳入要處理的動作類型 
   String notifyID=request.getParameter("NOTIFYID"); // 傳入要處理的 NotificationID
   String docNO=request.getParameter("DOCNO"); // 傳入要處理的ITEM TYPE (OEOH , POAPPRV, REQAPPRV )
   String itemTYPE=request.getParameter("ITEMTYPE"); // 傳入要處理的ITEM TYPE (OEOH , POAPPRV, REQAPPRV )
   String itemKEY=request.getParameter("ITEMKEY"); // 傳入要處理的 ITEM KEY ( )
   
   //String r[][]=new String[rowLength+1][8]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
   
   if (notifyID==null) notifyID = "50"; // 如果未給Notification ID則為 Priority 設為 50
   if (docNO==null) docNO = ""; // 如果未給ITEM KEY ( )
   if (itemTYPE==null) itemTYPE = ""; // 如果未給ITEM TYPE (OEOH , POAPPRV, REQAPPRV )
   if (itemKEY==null) itemKEY = ""; // 如果未給ITEM KEY ( )
   
  
   java.math.BigDecimal myNid = new java.math.BigDecimal(notifyID); 
   java.math.BigDecimal procStatID = new java.math.BigDecimal("103793");
   
   try
   {
     if (itemTYPE.equals("OEOH"))
	 {
                   Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = "select HEADER_ID "+
			                          "from OE_ORDER_HEADERS_ALL ";
			       String whereOType = "where ORDER_NUMBER = '"+docNO+"' "; 
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
				   if (rs.next())
				   {
				       itemKEY = rs.getString("HEADER_ID");
				   }
				   rs.close();
				   statement.close();
	  } else if (itemTYPE.equals("OEOL"))
	    {
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = "select LINE_ID "+
			                          "from OE_ORDER_LINES_ALL ";
			       String whereOType = "where LINE_ID = '"+docNO+"' "; 
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
				   if (rs.next())
				   {
				       itemKEY = rs.getString("LINE_ID");
				   }
				   rs.close();
				   statement.close();
		}
	    else {  // 不是MO 就是PO或PR
	  
	               Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = "select WF_ITEM_KEY "+
			                          "from PO_HEADERS_ALL ";
			       String whereOType = "where SEGMENT1 = '"+docNO+"' and ORG_ID in (41,325,385) and AUTHORIZATION_STATUS != 'APPROVED' "; 
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
				   if (rs.next())
				   {
				       itemKEY = rs.getString("WF_ITEM_KEY");
				   }
				   rs.close();
				   statement.close();
	         }		   
	} //end of try		 
    catch (Exception e) { out.println("Exception:"+e.getMessage()); }  

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
	 //m_charSet = "WE8ISO8859P1";
   }   
   
   oracle.apps.fnd.wf.WFContext ctx = new oracle.apps.fnd.wf.WFContext(m_charSet); // m_charSet is 'UTF8' by default
   ctx.setJDBCConnection(con);  // con is a pre-established JDBC connection 
   
   
   if (notifyType==null) { out.println("You don't input Notification Type,No ID be tested !");  }
   else if (notifyType.equals("createProcess"))
   {
// CreateProcess Test    (用workflow CreateProcess???否...要用startProcess)  
           //  
           out.println("CreateProcess Test");  
           // 傳入要轉呈的人員,並取得該人員有幾筆待處理 open 的Notification
           java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, "KERWIN");
   
           // Forward 是將原Notification的RECIPIENT_ROLE改成新的人員
      
           out.println("There are " + count +     " open notification(s) for" + " KERWIN"+"<BR>");
           out.println("Delegate nid " + myNid +     " from KERWIN to SUMING"+"<BR>");
		   
		   //boolean itemCreate = WFEngineAPI.createProcess(ctx,"OEOH","101479","TSC_R_STANDARD_HEADER");
		   boolean itemCreate = WFEngineAPI.createProcess(ctx,"OEOH","101507","T_RETURN_HEADER_WITH_APPROVAL");
		   
		   // ITEM KEY是不能重覆的,對應於Process檔內
		   //if (WFEngineAPI.createProcess(ctx,"OEOH","101480","TSC_R_STANDARD_HEADER"))
		   if (itemCreate==true)
		   {		    
			out.println("create Process with this ITEM KEY"); 
		   }
		   else {
		          out.println("unable create Process with this ITEM KEY");      
		        }
		   
           count = WFNotificationAPI.workCount(ctx, "KERWIN");
           out.println("There are " + count +     " open notification(s) for" +     " KERWIN after Delegate.");
   }
   else if (notifyType.equals("getItemUserKey"))
   {
// Get Item UserKey Test    (取得WF_ITEMS資料表的USER_KEY欄的值)  
           //  
           out.println("getItemUserKey Test");  
           // 傳入要轉呈的人員,並取得該人員有幾筆待處理 open 的Notification
           java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, "KERWIN");
   
           // Forward 是將原Notification的RECIPIENT_ROLE改成新的人員
      
           out.println("There are " + count +     " open notification(s) for" + " KERWIN"+"<BR>");
           out.println("Delegate nid " + myNid +     " from KERWIN to SUMING"+"<BR>");
		   
		   String itemUserKey = WFEngineAPI.getItemUserKey(ctx,"OEOH","101480");
		   
		   // ITEM KEY是不能重覆的,對應於Process檔內
		   //if (WFEngineAPI.createProcess(ctx,"OEOH","101480","TSC_R_STANDARD_HEADER"))
		   if (itemUserKey!=null)
		   {		    
			out.println("itemUserKey ="+itemUserKey); 
		   }
		   else {
		          out.println("unable get Process with this ITEM USER KEY");      
		        }
		   
           count = WFNotificationAPI.workCount(ctx, "KERWIN");
           out.println("There are " + count +     " open notification(s) for" +     " KERWIN after Delegate.");
   }
   else if (notifyType.equals("startProcess"))
   {
 // StartProcess Test    (真正用來重新產生workflow的 API !!!,)  
           //  
           out.println("StartProcess Test");  
           // 傳入要轉呈的人員,並取得該人員有幾筆待處理 open 的Notification
           java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, "KERWIN");
   
              
           out.println("itemTYPE =  " + itemTYPE +"<BR>");
           out.println("itemKEY = " + itemKEY +"<BR>");
		   // 傳入WF Context、Item Type及 Item Key(如果是OM Header即是 Header ID)
		   //boolean procStart = WFEngineAPI.startProcess(ctx,"OEOH","101479");
		   // 找 PO_HEADER 內的WF_ITEM_KEY,可重送PO Workflow 
		   boolean procStart = false;
		   if (itemKEY.equals("") || itemTYPE.equals(""))
		   {  }
		   else
		      {
		          procStart =  WFEngineAPI.startProcess(ctx,itemTYPE,itemKEY);//"T_RETURN_HEADER_WITH_APPROVAL");
				//procStart = WFEngineAPI.startProcess(ctx,"POAPPRV","89567-361260");//"T_RETURN_HEADER_WITH_APPROVAL");
			  }	
		   
		  // boolean procStart = WFEngineAPI.startProcess(ctx,"POAPPRV","71930-230478");//"T_RETURN_HEADER_WITH_APPROVAL");
		   
		  
		   //if (WFEngineAPI.createProcess(ctx,"OEOH","101480","TSC_R_STANDARD_HEADER"))
		   if (procStart==true)
		   {		    
			out.println("<font color='#FFFF00'>start Process with this ITEM KEY"+"</font><BR>"); 
		   }
		   else {
		          out.println("<font color='#FF0000'>Unable start Process with this ITEM KEY"+"</font><BR>");      
		        }
		   
           //count = WFNotificationAPI.workCount(ctx, "KERWIN");
           //out.println("There are " + count +     " open notification(s) for" +     " KERWIN after Delegate.");
   }
   else if (notifyType.equals("getProcessStatus"))
   {
 // Get Process Status Test    (真正用來重新產生workflow的 API !!!,)  
           //  
           out.println("Get Process Status Test");  
           // 傳入要轉呈的人員,並取得該人員有幾筆待處理 open 的Notification
           java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, "KERWIN");
   
              
           out.println("There are " + count +     " open notification(s) for" + " KERWIN"+"<BR>");
           out.println("Delegate nid " + myNid +     " from KERWIN to SUMING"+"<BR>");
		   // 傳入WF Context、Item Type及 Item Key(如果是OM Header即是 Header ID)
		   oracle.apps.fnd.wf.WFTwoDArray procStatus = WFEngineAPI.getProcessStatus(ctx,"OEOH","101480",procStatID);
		   int colCount = procStatus.getColumnCount();
		   int rowCount = procStatus.getRowCount();
		  
		   //if (WFEngineAPI.createProcess(ctx,"OEOH","101480","TSC_R_STANDARD_HEADER"))
		   if (colCount>0)
		   {		    
			out.println("Column Count = "+colCount+"<BR>"); 
		   }
		   else if (rowCount>0)
		        {
		          out.println("Row Count = "+rowCount+"<BR>");    
		        }
				
				//out.println(procStatus.getData(0,1));
		   
           count = WFNotificationAPI.workCount(ctx, "KERWIN");
           out.println("There are " + count +     " open notification(s) for" +     " KERWIN after Delegate.");
   }
   else if (notifyType.equals("setItemAttrText"))
   {
// setItemAttrText Test (設定workflow(WF_ITEM_ATTRIBUTE_VALUES)資料表值的api)  
           //  
           out.println("setItemAttrText Test");  
           // 傳入要轉呈的人員,並取得該人員有幾筆待處理 open 的Notification
           java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, "KERWIN");
   
           // Forward 是將原Notification的RECIPIENT_ROLE改成新的人員
      
           out.println("There are " + count +     " open notification(s) for" + " KERWIN"+"<BR>");
           out.println("Delegate nid " + myNid +     " from KERWIN to VINCENT_CHIANG"+"<BR>");
		   // ITEM KEY是不能重覆的,對應於Process檔內
		   if (WFEngineAPI.setItemAttrText(ctx,"POAPPRV","71519-226862","NOTIFICATION_APPROVER","VINCENT_CHIANG"))
		   out.println("Requestor:"+"VINCENT_CHIANG");
		   else {
		           WFEngineAPI.showError(ctx);
		        }
		   
           count = WFNotificationAPI.workCount(ctx, "KERWIN");
           out.println("There are " + count +     " open notification(s) for" +     " KERWIN after Delegate.");
   }
   else if (notifyType.equals("send"))
         {
// Send Test    (Test messageType="OEOH" 、messageName="TSC SEND ORDER TO APPROVED"、dueDate="20060609"、callback=""、context=""、sendComment="Send java API Test"、priority=NULL)  
           // forward to KERWIN (本例會再Delegate一次,因為我又設定Delegate給SUMING)
           out.println("Send Test");  
           // 傳入要轉呈的人員,並取得該人員有幾筆待處理 open 的Notification
           java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, "KERWIN");
   
           // Forward 是將原Notification的RECIPIENT_ROLE改成新的人員
      
           out.println("There are " + count +     " open notification(s) for" + " KERWIN"+"<BR>");
           out.println("Delegate nid " + myNid +     " from KERWIN to SUMING"+"<BR>");
		   // 這一段是預設都不給,會送出一筆空白表身的Notification_起
             //WFNotificationAPI.send(ctx, "KERWIN", "OEOH", "TSC SEND ORDER TO APPROVED", null,null,null,"Send java API Test",myNid); // 倒數第二參數是顯示於 Workflow Detail的訊息
		   // 這一段是預設都不給,會送出一筆空白表身的Notification_迄(除日期外,Call Back Function, CONTEXT="OEOH:Order Header ID:PROCESS ACTIVITY"--> 在wf_item_activity_statuses內)	 
		   // -- 能夠Send至Folw完全跑一次前提是狀態為Open
		        //WFNotificationAPI.send(ctx, "KERWIN", "OEOH", "TSC SEND ORDER TO APPROVED", null,"WF_ENGINE.CB","OEOH:101441:103749","Send java API Test",myNid); // 倒數第二參數是顯示於 Workflow Detail的訊息
		   // -- 能夠Send至Folw完全跑一次前提是狀態為Open		
		   WFNotificationAPI.send(ctx, "KERWIN", "OEOH", "TSC SEND ORDER TO APPROVED", null,"WF_ENGINE.CB","OEOH:100399:103753","Send java API Test",myNid); // 倒數第二參數是顯示於 Workflow Detail的訊息
           count = WFNotificationAPI.workCount(ctx, "KERWIN");
           out.println("There are " + count +     " open notification(s) for" +     " KERWIN after Delegate.");
         }
   else if (notifyType.equals("forward"))
         { // 基本上算是設定 Delegate
// Forward Test    (Test nid=300088)  
           // forward to KERWIN (本例會再Delegate一次,因為我又設定Delegate給SUMING)
           out.println("Delegate Test");  
           // 傳入要轉呈的人員,並取得該人員有幾筆待處理 open 的Notification
           java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, "KERWIN");
   
           // Forward 是將原Notification的RECIPIENT_ROLE改成新的人員
      
           out.println("There are " + count +     " open notification(s) for" + " KERWIN"+"<BR>");
           out.println("Delegate nid " + myNid +     " from SUMING to KERWIN"+"<BR>");
           WFNotificationAPI.forward(ctx, myNid, "KERWIN",    "CHEN, Please handle."); // 最後參數是顯示於 Workflow Detail的訊息
           count = WFNotificationAPI.workCount(ctx, "KERWIN");
           out.println("There are " + count +     " open notification(s) for" +     " KERWIN after Delegate."+"<BR>");
         }
		 else if (notifyType.equals("transfer"))
		      {
// Transfer Test    (Test nid=300016) 
                // 傳入要傳送的人員,並取得該人員有幾筆待處理 open 的Notification
                java.math.BigDecimal count = WFNotificationAPI.workCount(ctx, "JINGKER");
                out.println("Transfer Test"+"<BR>");
	            out.println("Transfer nid " + myNid +     " from SUMING to JINGKER"+"<BR>");
	            WFNotificationAPI.transfer(ctx, myNid, "JINGKER",    "BY KERWIN WORKFLOW JAVA API TEST, You own this NOTIFICATION :"+myNid+" now.");
	            count = WFNotificationAPI.workCount(ctx, "JINGKER");
	            out.println("There are " + count +     " open notification(s) for" +   " JINGKER after Transfer.");

              }

%>
<body>
<A href="/oradds/ORAddsMainMenu.jsp">回首頁</A>
<!--=============以下區段為釋放連結池==========--> 
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>