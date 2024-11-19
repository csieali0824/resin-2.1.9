<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>


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
  A:visited { color: #990066; text-decoration: underline }
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
<title>SEA(C) Deffered Call RCV API Process</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM ACTION="TSDefferedSEAMBatchProcess.jsp" METHOD="post" NAME="MYFORM">
<%
String serverHostName=request.getServerName();
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
String pageURL=request.getParameter("PAGEURL");//承接前一頁所傳來之參數
String [] choice=request.getParameterValues("CH");
String previousPageAddress=request.getParameter("PREVIOUSPAGEADDRESS");
String dnDocNo=request.getParameter("DNDOCNO");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String isTransmitted=request.getParameter("ISTRANSMITTED");//取得前一頁處理之維修案件是否已後送之FLAG

String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
String remark=request.getParameter("REMARK");

String oriStatus=null;
String actionName=null;

String organizationId=request.getParameter("ORGANIZATION_ID");
String organizationCode=request.getParameter("ORGANIZATION_CODE");

String tsInvoiceNo=request.getParameter("TSINVOICENO");
String createBy = request.getParameter("CREATE_BY");
String poHeaderId = request.getParameter("POHEADERID");
String poLineId = request.getParameter("POLINEID");
String poLocationLineId = request.getParameter("POLOCATIONLINEID");
String shipDate = request.getParameter("SHIPDATE");
String systemDate = request.getParameter("SYSTEMDATE");
String rcvQty   = request.getParameter("RCVQTY");  
String employeeId   = request.getParameter("EMPLOYEE_ID");  
//String userName   = request.getParameter("USERNAME"); 
String periodStatus   = request.getParameter("PERIOD_STATUS");
int headerID   = 0;  
int requestID  = 0;
String errorMessageHeader ="";
String errorMessageLine ="";
String statusMessageHeader ="";
String statusMessageLine ="";
String processStatus="";
String countRate = request.getParameter("COUNTRATE");   //判斷出貨日的幣別轉換匯率是否存在

 String devStatus = "";
 String devMessage = ""; 

String inspLotNo   = request.getParameter("INSPLOTNO");
String lineNo   = request.getParameter("LINENO");

    userMail=null;
	String UserID=null;
	String urAddress=null;
	String getWebID = null;
	


// 若使用者未於批次作業點選任一Check Box	  
if (choice==null || choice[0].equals(null))    // 2004/11/25 for fileter user don't choosen any item to process // 2004/11/25
{ 
  out.println("<font color='#FF0000' face='ARIAL BLACK' size='3'> Warning !!!</font>,<font color='#000099' face='ARIAL'><strong>Nothing gonna to Process,Please choice Case .</strong></font>"); 
} 
else 
{

  // formID = 基本資料頁傳來固定常數='DS'
  // fromStatusID = 基本資料頁傳來Hidden 參數
  // actionID = 前頁取得動作 ID( Assign = 012 )
try
{ // 先取得下一狀態及狀態描述並作流程狀態更新 

		
String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);

  if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
  if (shipDate==null || shipDate.equals("")) shipDate = dateBean.getYearMonthDay(); // 取當天處理日

// 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
     String clientID = "";
	 if (organizationId=="46" || organizationId.equals("46"))
	 {  clientID = "42"; }
	 else { clientID = "41"; }
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機 */
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();
	 
	 
	   // 為存入日期格式為US考量,將語系先設為美國
	   String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
       PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	   pstmtNLS.executeUpdate(); 
       pstmtNLS.close();
	   //完成存檔後回復
	   
 for (int k=0;k<choice.length ;k++)    
 {    
 	 
	String sqlStat = "";
	String whereStat = "";
	//out.println("FORMID="+formID);
	sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 ";
	whereStat ="WHERE FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
      // 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
		 if (UserRoles.equals("admin")) whereStat = whereStat+" and FORMID='DS' ";  //若是管理員,則任何動作不受限制
		 else {
				 whereStat = whereStat+"and FORMID='DS' "; // 一律皆為DropShip(DamnShit)
		      }
	 // 2006/04/13加入特殊內銷流程,針對上海內銷_迄		
     sqlStat = sqlStat+whereStat;
     Statement getStatusStat=con.createStatement();  
     ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
     getStatusRs.next();
	 
  if (actionID.equals("012")) // 出貨延遲處理(STATUS = (080)OPEN) --> ActionID = 012(COMPLETE)
  { //out.println("Step1=");
	 

    //抓取系統日期
  
    Statement statesd=con.createStatement();
	ResultSet sd=statesd.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE from dual" );
	if (sd.next())
	 {
	   systemDate=sd.getString("SYSTEMDATE");	 
	  }
	sd.close();
    statesd.close();	


 java.sql.Date shippingDate = null; //將SHIPDATE轉換成日期格式以符丟入API格式
 if (shipDate!=null && shipDate.length()>=8)
 {   
    shippingDate = new java.sql.Date(Integer.parseInt(shipDate.substring(0,4))-1900,Integer.parseInt(shipDate.substring(4,6))-1,Integer.parseInt(shipDate.substring(6,8)));  // 給Shipping Date
    String shipTime = dateBean.getHourMinuteSecond();  // 給Shipping Time
	
	     String sqlDate="  select TO_DATE('"+shipDate+shipTime+"','YYYYMMDDHH24MISS') from DUAL   ";  					
         Statement stateDate=con.createStatement();
         ResultSet rsDate=stateDate.executeQuery(sqlDate);
		 if (rsDate.next())
		 { shippingDate  = rsDate.getDate(1);  }
		 rsDate.close();
         stateDate.close();	
         //out.println("shippingDate"+shippingDate);
 }   
//java.sql.Date shipDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
%>
<A href="/oradds/jsp/TSDefferedSEAQueryAllStatus.jsp?STATUSID=080&PAGEURL=N/A">出貨延遲處理</A>
<BR><HR>
<%
  try
  {
  
  if( shipDate !=null )  //檢查shipdate是否為open的GL PERIOD
  {
    String sql=" select UPPER(STATUS) as PERIOD_STATUS from APPS.ORG_ACCT_PERIODS_V "+
               " where ORGANIZATION_ID="+organizationId+" and PERIOD_NAME = TO_CHAR(TO_DATE("+shipDate+",'YYYYMMDD'),'MON-YY') ";
  
    Statement statest=con.createStatement();
	ResultSet st=statest.executeQuery(sql);
	//out.println("sql"+sql+"<BR>");
	if (st.next())
	 {
	   periodStatus=st.getString("PERIOD_STATUS");	 
	  }
	//out.print("shipDate"+shipDate+"periodStatus="+periodStatus+"<br>");
	st.close();
    statest.close();	
   }// end if( shipDate !=null ) 

if (shipDate!=null)
{
	     //判斷此shipdate的幣別?率是否存在
         String sqlcurr="  select COUNT(A.FROM_CURRENCY) as COUNTRATE from  APPS.GL_DAILY_RATES_V A   "+
  						"    where A.FROM_CURRENCY in ('USD','EUR','TWD') and A.USER_CONVERSION_TYPE='TSC-Export'  "+
      					"      and A.CONVERSION_DATE = TO_DATE('"+shipDate+"','YYYY/MM/DD') ";
         Statement statefndsc=con.createStatement();
         ResultSet rsfndsc=statefndsc.executeQuery(sqlcurr);
		 if (rsfndsc.next())
		   { countRate     = rsfndsc.getString("COUNTRATE");  }
		  rsfndsc.close();
          statefndsc.close();	
         // out.println("countRate"+countRate);
}

  } //end of try
  catch (Exception e)
      {
         out.println("Exception:"+e.getMessage());
      }    
	 
 try
 {
   if (periodStatus==null || periodStatus=="" || periodStatus.equals("") ) 
   { out.print("<font color='#0000cc'><strong>ShipDate="+shipDate+" the Period is Future!!<br>Can not ship confirm!!</font></strong>"); 
     }
   else if (periodStatus=="CLOSED" || periodStatus.equals("CLOSED"))
   { out.print("<font color='#0000cc'><strong>ShipDate="+shipDate+" the Period has been Closed!!<br>Can not ship confirm!!</font></strong>");}

  // else if (shipDate > systemDate )
   else if ( Integer.parseInt(shipDate) > Integer.parseInt(systemDate) )
   { out.print("<font color='#0000cc'><strong>ShipDate over Today!! </font></strong>");}

   else if ( countRate=="0" || countRate.equals("0") )
   { out.print("<font color='#0000cc'><strong>ShipDate= "+shipDate+"<br>  Missing Currency Rate,Please Contact Finance Create!! </font></strong>");}
  
   else if (periodStatus=="OPEN" || periodStatus.equals("OPEN"))
   { //out.println("COUNT RATE="+countRate);
              Statement statement=con.createStatement();			  
			  String sql1a=  " select B.SALESORDERNO||'-'|| B.LINE_NO as SELECTFLAG, A.TSINVOICENO,B.RCVQTY ,A.CREATE_BY,B.PO_HEADER_ID,B.PO_LINE_ID,B.PO_LOCATION_LINE_ID, "+
			                 "        A.EMPLOYEE_ID,B.ORGANIZATION_ID,B.ORDER_HEADER_ID,B.ORDER_LINE_ID, C.PACKING_SLIP  "+
                             " from APPS.TSC_DROPSHIP_SHIP_HEADER A,APPS.TSC_DROPSHIP_SHIP_LINE B, APPS.TSC_RCV_TRANSACTIONS_INTERFACE C "+
                             " where A.TSINVOICENO=B.TSINVOICENO and B.ORDER_LINE_ID = C.OE_ORDER_LINE_ID and B.ORDER_HEADER_ID = C.OE_ORDER_HEADER_ID "+
							// "   and NVL(A.STATUS,'OPEN') != 'CLOSED'  and NVL(A.PRINTED_FLAG,'N') = 'Y'  and NVL(b.line_STATUS,'OPEN') != 'CLOSED' "+  
                            // "   and A.TSINVOICENO = upper('"+tsInvoiceNo+"') "+
							 "   and to_char(C.INTERFACE_TRANSACTION_ID) = '"+choice[k]+"' ";
                          
              ResultSet rs=statement.executeQuery(sql1a);  
			  //out.println("sql1a="+sql1a);
              while (rs.next())		  
              {   //out.println("Step2="+shippingDate+"<BR>");
			  
			         String sqlInvSt = " select STATUS from APPS.TSC_INVOICE_HEADERS "+
 									 " where INVOICE_NO = '"+rs.getString("PACKING_SLIP")+ "' and STATUS = '40' ";
					 Statement stateInvSt=con.createStatement();
                     ResultSet rsInvSt=stateInvSt.executeQuery(sqlInvSt);
					 if (rsInvSt.next())
					 {	// 發票已經執行 Branch Confirm 才執行 RCV_Transaction_interface	     
			    
                        CallableStatement cs3 = con.prepareCall("{call TSC_RCV_API_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
				        //out.println("2="+shippingDate);
				        cs3.setString(1,rs.getString("PACKING_SLIP"));  //發票號碼
				        cs3.setDate(2,shippingDate);     //收料日期
				        cs3.setInt(3,Integer.parseInt(rs.getString("CREATE_BY")));     
				        cs3.setInt(4,Integer.parseInt(rs.getString("PO_HEADER_ID")));  
				        cs3.setInt(5,Integer.parseInt(rs.getString("PO_LINE_ID")));  
				        cs3.setFloat(6,Float.parseFloat(rs.getString("RCVQTY")));  
	                    cs3.registerOutParameter(7, Types.VARCHAR); //   HEADER處理訊息 
				        cs3.registerOutParameter(8, Types.VARCHAR); //   LINE處理訊息  
				        cs3.registerOutParameter(9, Types.INTEGER); //   PO_LINE_ID 
				        cs3.registerOutParameter(10, Types.VARCHAR); //   HEADER error訊息 
				        cs3.registerOutParameter(11, Types.VARCHAR); //   LINE error訊息 
				        cs3.setInt(12,Integer.parseInt(rs.getString("PO_LOCATION_LINE_ID")));   //PO_LOCATION_LINE_ID
				        cs3.setInt(13,Integer.parseInt(rs.getString("EMPLOYEE_ID")));   //EMPLOYEE_ID
			            cs3.setInt(14,Integer.parseInt(rs.getString("ORGANIZATION_ID")));   //ORGANIZATION_ID
			            cs3.setInt(15,Integer.parseInt(rs.getString("ORDER_HEADER_ID")));   //ORDER_HEADER_ID
			            cs3.setInt(16,Integer.parseInt(rs.getString("ORDER_LINE_ID")));   //ORDER_LINE_ID			     			     
	                    cs3.execute();
                        // out.println("Procedure : Execute Success !!! ");
				        statusMessageHeader = cs3.getString(7);	             
				        statusMessageLine = cs3.getString(8);
				        headerID = cs3.getInt(9);   // 把第二次的更新 Header ID 取到
				        errorMessageHeader = cs3.getString(10);	             
				        errorMessageLine = cs3.getString(11);
                        cs3.close();			
				 	  
	                   if (errorMessageHeader==null ) 
				       { errorMessageHeader = "&nbsp;";}
					   else  out.println("Error Message="+errorMessageHeader);	
					   			
				       if (errorMessageLine==null ) { errorMessageLine = "&nbsp;";}		
				       // out.println("Step2="+"<BR>");  					   
			           else  out.println("Error Message Line="+errorMessageLine);
						
						
			%>
			<table bgcolor='#FFFFCC'><font color='#000099'>
	                <TR><TD colspan=2> <font color='#000099'>Process Status </font></TD><TD colspan=4><%=statusMessageHeader+statusMessageLine%></TD></TR>
					 </FONT> 
            </table>
			<%			
	
					// _ Call Concurrent RCV Request Processor_起	
					  if ((errorMessageHeader==null || errorMessageHeader=="" || errorMessageHeader.equals("&nbsp;") ) && (errorMessageLine==null || errorMessageLine=="" || errorMessageLine.equals("&nbsp;"))) 
					  {
					    
					     errorMessageHeader = "&nbsp;"; 
						 errorMessageLine = "&nbsp;"; 				 
					    				       
            
						//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor
						 String sqlfnd = " select USER_ID from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 									     " where A.USER_NAME = UPPER(B.USERNAME)  and B.USERNAME = '"+UserName+ "'";
						 Statement stateFndId=con.createStatement();
                         ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
						 //out.println("sqlfnd="+sqlfnd);
		                    if (rsFndId.next())
		                    {		                      						
						       // Run "Receiving Transaction Processor"
						       CallableStatement cs4 = con.prepareCall("{call TSC_CALL_RCV_REQUEST_JSP(?,?,?,?)}");			 
			  	               cs4.setInt(1,Integer.parseInt(rsFndId.getString("USER_ID")));       //USER REQUEST 
				               cs4.registerOutParameter(2, Types.VARCHAR);                  //回傳 REQUEST_ID
							   cs4.registerOutParameter(3, Types.VARCHAR);                  //回傳 DEV_STATUS
				               cs4.registerOutParameter(4, Types.VARCHAR);                  //回傳 DEV_MASSAGE
						       cs4.execute();
               	   		       requestID = cs4.getInt(2);   //  回傳 REQUEST_ID
							   devStatus = cs4.getString(3);   //  回傳 REQUEST 執行狀況
				               devMessage = cs4.getString(4);   //  回傳 REQUEST 執行狀況訊息
				               cs4.close();			
						       out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");
							   rsFndId.close();
                               stateFndId.close();
							   
							   con.commit(); // 確認執行choice[k] 的 Processor;
							   
							 // 2006/09/26 新增判斷若發票含SEA(C) 出貨延遲項目,則E-Mail通知ShipConfirm人員及管理員_By Kerwin
						      Statement stateSEAC=con.createStatement();
			                  String sqlSEAC=  " select * from RCV_TRANSACTIONS_INTERFACE "+
			                                   " where OE_ORDER_LINE_ID in ( select LINE_ID from OE_ORDER_LINES_ALL "+
                                                                           " where HEADER_ID in (  select HEADER_ID from OE_ORDER_HEADERS_ALL where ORDER_NUMBER like '1152%' "+
                                                                                                 " and to_char(creation_date, 'YYYYMMDD') >= '20060802' ) "+ 
													                       " and LINE_TYPE_ID in (1159) and SHIPPING_METHOD_CODE = 'SEA(C)' "+ 
                                                                       "   )   and PACKING_SLIP = upper('"+tsInvoiceNo+"') " ; 
                              ResultSet rsSEAC=stateSEAC.executeQuery(sqlSEAC);
							  if (rsSEAC.next()) 
							  {
							       String sSqlMailUser = "select DISTINCT USERMAIL,USERNAME,WEBID from ORADDMAN.WSUSER where LOCKFLAG='N' and USERNAME in ('"+UserName+ "','kerwin','suming','jingker') ";
	                                //out.println(sSqlMailUser);
	                               Statement stmentMail=con.createStatement();
                                   ResultSet rsMail=stmentMail.executeQuery(sSqlMailUser);
	                               while(rsMail.next())
	                               {
								        try 
                                        {  
                                         sendMailBean.setMailHost(mailHost);					  
	                                     userMail=rsMail.getString("USERMAIL");
		                                 UserID = rsMail.getString("USERNAME");		
		                                 getWebID = rsMail.getString("WEBID");   
		                                 urAddress = "http://prod.ts.com.tw:8000/OA_HTML/AppsLocalLogin.jsp?langCode=US";		
                                         sendMailBean.setReception(userMail);
                                         sendMailBean.setFrom(UserID);                    
		                                 sendMailBean.setSubject(CodeUtil.unicodeToBig5("出貨發票延遲通知System E-Mail- 來自1152訂單SEA(C)出貨延遲立帳:發票號("+tsInvoiceNo+")"));         
		                                 sendMailBean.setUrlName("Dear "+UserID+",\n"+CodeUtil.unicodeToBig5("   請檢視來自發票延遲出貨系統的郵件:每日訂單SEA(C)出貨延遲立帳:發票號-("+tsInvoiceNo+") REQUEST ID-("+requestID+") "));     
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
								   rsMail.close();
								   stmentMail.close();
							  }
						      rsSEAC.close();
							  stateSEAC.close();
						 
						    // 2006/09/26 新增判斷若發票含SEA(C) 出貨延遲項目,則E-Mail通知ShipConfirm人員及管理員_By Kerwin
							   
							   
							   
						       //out.println("sqlfnd="+sqlfnd);	
						     }  //end if (rsFndId.next()) 
							 
							 
						 java.lang.Thread.sleep(5000);	 // 延遲五秒,等待Concurrent執行完畢,取結果判斷	 
							 
					     Statement stateError=con.createStatement();
			             String sqlError= " select INTERFACE_TRANSACTION_ID "+			                         
                                          " from RCV_TRANSACTIONS_INTERFACE "+
                                          " where INTERFACE_TRANSACTION_ID ="+choice[k]+" and PROCESSING_STATUS_CODE='ERROR' ";	
				                      //out.println("ID2="+sqlGroupID+"<BR>");					                                     
                         ResultSet rsError=stateError.executeQuery(sqlError);	  
				         if (!rsError.next()) // 不存在 ERROR 的資料
				         { 
							 
							  String sqlRCV="update APPS.TSC_RCV_TRANSACTIONS_INTERFACE set STATUSID=?,STATUS=?,J_LAST_UPDATED_BY=?,J_LAST_UPDATE_DATE=? where INTERFACE_TRANSACTION_ID='"+choice[k]+"'";
                              PreparedStatement pstmtRCV=con.prepareStatement(sqlRCV);   
                              pstmtRCV.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
                              pstmtRCV.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS 
							  pstmtRCV.setString(3,UserName); //寫入更新者
							  pstmtRCV.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //寫入更新日期 
                              pstmtRCV.executeUpdate();
                              pstmtRCV.close(); 
							  
						}
				        rsError.close();
				        stateError.close();	  
					  }							 
					  else {  
					        out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Success!! </FONT></TD><TD colspan=3>"+requestID+"</TD></TR>");
					        out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Error Message</FONT></TD><TD colspan=3>"+errorMessageHeader+errorMessageLine+"</TD></TR>");
					       }		
						
					//_ Call Concurrent RCV Request Processor_迄 	
						
				 } else
				        {
				             out.println("<strong><font color='#FF0099'>警告!!!, 發票號=</FONT><font color='#FF0000'>"+rs.getString("PACKING_SLIP")+"</font><font color='#FF0099'> 尚未執行Branch Confirm,此筆資料仍不予出貨處理</FONT></strong>");				          
				 
				        }
				 rsInvSt.close();
				 stateInvSt.close();		
 %> 			 
			  
 <BR>     
			   
  <%            
              
			  } // End of while ()  
			  rs.close();
              statement.close();


     }//end if (periodStatus=="OPEN" || periodStatus.equals("OPEN"))
	 
    } //end of try 
    catch (Exception e)
    {
	 e.printStackTrace();
     out.println(e.getMessage());
    }
	
   // }  // End of if (k==0) 
	
   } // End of if (actionID=="080") // 工廠安排交期確認
   // 在 For 迴圈內   
  } //end of for (int i=0;i<choice.length;i++)
  
 } //end of try 
 catch (Exception e)
 {
	e.printStackTrace();
   out.println(e.getMessage());
 }//end of catch
 
}  // End of if (choice==null || choice[0].equals(null)) for fileter user don't choosen any item to process // 2006/09/23

%>
<input type="hidden" size="5" name="SYSTEMDATE" value="<%=systemDate%>">
</FORM>
</body>
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

