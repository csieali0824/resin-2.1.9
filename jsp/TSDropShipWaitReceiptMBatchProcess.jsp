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
<A href="/oradds/jsp/TSDropShipWaitReceiptAllStatus.jsp?STATUSID=082&PAGEURL=N/A">三角銷售訂單未轉採購單據處理</A>
<BR><HR>
<%
    String lineID = choice[k].substring(0,choice[k].indexOf("|",0)); // 從第一個Index開始取,取到第一個
	
	out.println("lineID="+lineID);  //
	
	String prHeaderID = choice[k].substring(choice[k].indexOf("|",0)+1,13);
	
	out.println("prHeaderID="+prHeaderID);  //
	
	String prLineID = choice[k].substring(choice[k].indexOf("|",12)+1,choice[k].length());

    out.println("prLineID="+prLineID);  //
	
	
  // Step1. 先由MO的 Created By 取得開單人員的Employee ID
     String employeeID = "";
     String sugUserName = "";
     String sqlEmp=" select b.EMPLOYEE_ID, b.USER_NAME from OE_ORDER_LINES_ALL a, FND_USER b "+
                   "  where a.CREATED_BY = b.USER_ID and a.LINE_ID = "+lineID+"  ";  
     Statement stateEmp=con.createStatement();
	 ResultSet rsEMP=stateEmp.executeQuery(sqlEmp);
	 //out.println("sql"+sql+"<BR>");
	 if (rsEMP.next())
	 {
	   employeeID = rsEMP.getString("EMPLOYEE_ID");	 
	   sugUserName = rsEMP.getString("USER_NAME");	 
	   
	   out.println("employeeID="+employeeID);
	   out.println("Suggest User Name="+sugUserName);
	 }
	 //out.print("shipDate"+shipDate+"periodStatus="+periodStatus+"<br>");
	 rsEMP.close();
     stateEmp.close();	
	 
  // Step2. 再取的未轉採購單項次的料號資訊  
     String organizationID = "44";
	 String invItemID = "";
	 String prCreateDate = "";
	 float quantity = 0;
     String sqlItem=" select DESTINATION_ORGANIZATION_ID, ITEM_ID, QUANTITY, UNIT_MEAS_LOOKUP_CODE, to_char(CREATION_DATE,'YYYYMMDD') as CREATION_DATE "+
	               "   from PO_REQUISITION_LINES_ALL "+
                   " where REQUISITION_HEADER_ID = "+prHeaderID+" and REQUISITION_LINE_ID = "+prLineID+" "+
				   "   and LINE_LOCATION_ID IS NULL and CANCEL_FLAG = 'N' ";    // 找出未轉的條件
	 //out.println("sqlItem="+sqlItem);
     Statement stateItem=con.createStatement();
	 ResultSet rsItem=stateItem.executeQuery(sqlItem);
	 //out.println("sql"+sql+"<BR>");
	 if (rsItem.next())
	 {
	   organizationID = rsItem.getString("DESTINATION_ORGANIZATION_ID");
	   invItemID = rsItem.getString("ITEM_ID");
	   if (rsItem.getString("UNIT_MEAS_LOOKUP_CODE").equals("PCE"))	     
	    quantity = rsItem.getFloat("QUANTITY")/1000;  	    
	   else quantity = rsItem.getFloat("QUANTITY");	
	   
	   prCreateDate =  rsItem.getString("CREATION_DATE");  // PR轉出日期作為匯率參考日
	   
	   out.println("quantity="+quantity);
	   out.println("prCreateDate="+prCreateDate);
	 }
	 //out.print("shipDate"+shipDate+"periodStatus="+periodStatus+"<br>");
	 rsItem.close();
     stateItem.close();	
	 
  // Step3. 取得料號對應的單價
     float TPrice = 0;
     String sqlUPr=" select Tsc_Om_Get_Target_Price('"+organizationID+"', '"+invItemID+"', 'KPC',7257,'USD') from dual ";    // 美元幣別下的單價
     Statement stateUPr=con.createStatement();
	 ResultSet rsUPr=stateUPr.executeQuery(sqlUPr);
	 //out.println("sql"+sql+"<BR>");
	 if (rsUPr.next())
	 {
	   TPrice = rsUPr.getFloat(1);	   
	   out.println("TPrice ="+TPrice);
	 }
	 //out.print("shipDate"+shipDate+"periodStatus="+periodStatus+"<br>");
	 rsUPr.close();
     stateUPr.close();	
	 
  // Step4. 取得該PR 產生日期對應的匯率
     float converstionRate = 0;
     String sqlRDate=" select CONVERSION_RATE from GL_DAILY_RATES_V "+ 
                     "  where FROM_CURRENCY = 'USD' and CONVERSION_TYPE = '1001' "+
					 "    and to_char(CONVERSION_DATE,'YYYYMMDD') = '"+prCreateDate+"' ";    // 美元幣別下的單價
     Statement stateRDate=con.createStatement();
	 ResultSet rsRDate=stateRDate.executeQuery(sqlRDate);
	 //out.println("sql"+sql+"<BR>");
	 if (rsRDate.next())
	 {
	   converstionRate = rsRDate.getFloat(1);	
	   out.println("converstionRate ="+converstionRate);   
	 }	  
	 rsRDate.close();
     stateRDate.close();	
	 
  // Step5. 取得要更新的MO號及Line項次
     String orderNumber = "";
	 String lineNum = "";
     String sqlMO=   " select ORDER_NUMBER, LINE_NUMBER from OE_ORDER_HEADERS_ALL a, OE_ORDER_LINES_ALL b, OE_DROP_SHIP_SOURCES c "+ 
                     "  where a.HEADER_ID = b.HEADER_ID and a.HEADER_ID = c.HEADER_ID "+
					 "    and b.LINE_ID = c.LINE_ID and c.REQUISITION_HEADER_ID = "+prHeaderID+" and c.REQUISITION_LINE_ID = "+prLineID+" ";    // 
     Statement stateMO=con.createStatement();
	 ResultSet rsMO=stateMO.executeQuery(sqlMO);
	 //out.println("sql"+sql+"<BR>");
	 if (rsMO.next())
	 {
	   orderNumber = rsMO.getString(1);	
	   lineNum = rsMO.getString(2);	
	   out.println("Order Number ="+orderNumber);   
	   out.println("lineNum ="+lineNum);   
	 }	  
	 rsMO.close();
     stateMO.close();	
	 
  // Step6. 更新PR Line 請購明細遺漏資訊.由上述取得資料
  try
  {
      String sqlUP=" update PO_REQUISITION_LINES_ALL "+
	               "    set SUGGESTED_VENDOR_LOCATION='EVER', SUGGESTED_VENDOR_NAME='EVER Energetic International Limited', "+
	               "        CURRENCY_CODE='USD', UNIT_MEAS_LOOKUP_CODE = 'KPC', RATE_TYPE = '1001', "+
				   "        RATE_DATE = to_date('"+prCreateDate+"140000','YYYY/MM/DD HH24:MI:SS'), DESTINATION_SUBINVENTORY='80', "+
				   "        SUGGESTED_BUYER_ID=?, QUANTITY=?, CURRENCY_UNIT_PRICE=?, RATE =?, NOTE_TO_RECEIVER=?, REFERENCE_NUM=? "+				 
	               " where REQUISITION_HEADER_ID = "+prHeaderID+" and REQUISITION_LINE_ID = "+prLineID+" ";
      PreparedStatement pstmt=con.prepareStatement(sqlUP);   
      pstmt.setString(1,employeeID);             // SuggestByerID
      pstmt.setFloat(2,quantity);                // 數量(KPC)
	  pstmt.setFloat(3,TPrice);                  // 價格  
	  pstmt.setFloat(4,converstionRate);         // 匯率
      pstmt.setString(5,orderNumber+"."+lineNum); // OrderNumber + LineNo
	  pstmt.setString(6,orderNumber);            // OrderNumber 
      pstmt.executeUpdate();
      pstmt.close();   

  } //end of try
  catch (Exception e)
      {
         out.println("Exception:"+e.getMessage());
      }   
	  
  con.commit(); 
	
  // Step 7. 執行 Concurrent Request 重新轉一次產生採購單  
  try
  {  
      out.println("呼叫 TSC_PO_DropShip_CreatePO <BR>");
	  //out.println("userMfgUserID="+userMfgUserID+"<BR>");
	  //out.println("respID="+respID+"<BR>");
	  CallableStatement cs2 = con.prepareCall("{call Tsc_Drop_Ship_Order_Pkg.CREATE_PO(?,?,?)}");	
	  cs2.registerOutParameter(1, Types.VARCHAR); 
	  cs2.registerOutParameter(2, Types.VARCHAR); 	                                
	  cs2.setInt(3,41);  //*  ParOrgID //	 	                               
	  cs2.execute();
	  String statusBuf = cs2.getString(1);
	  String statusOut = cs2.getString(2);    //  回傳 REQUEST 執行狀況	
      //out.println("Procedure : Execute Success !!! ");	                                 
      cs2.close();		
	  
	  out.println("Procedure : Execute statusBuf = "+statusBuf);
	  out.println("Procedure : Execute statusOut = "+statusOut);
  } //end of try
  catch (Exception e)
      {
	     e.printStackTrace();
         out.println("Exception:"+e.getMessage());
      } 
	  
	  
 // Step8. 更改產生的 PO Distributions ALL 數量	
     String poHeaderID = "";
	 String poLineID = "";
     String sqlPO=   " select PO_HEADER_ID, PO_LINE_ID from OE_DROP_SHIP_SOURCES "+ 
                     "  where REQUISITION_HEADER_ID = "+prHeaderID+" and REQUISITION_LINE_ID = "+prLineID+" ";    // 
     Statement statePO=con.createStatement();
	 ResultSet rsPO=statePO.executeQuery(sqlPO);
	 //out.println("sql"+sql+"<BR>");
	 if (rsPO.next())
	 {
	   poHeaderID = rsPO.getString(1);	
	   poLineID = rsPO.getString(2);	
	   out.println("poHeaderID ="+poHeaderID);   
	   out.println("poLineID ="+poLineID);   
	 }	  
	 rsPO.close();
     statePO.close();	
	 
	  String sqlPOD=" update PO_DISTRIBUTIONS_ALL "+
	               "    set QUANTITY_ORDERED = ? "+				 
	               " where PO_HEADER_ID = "+poHeaderID+" and PO_LINE_ID = "+poLineID+" ";
      PreparedStatement pstmtPOD=con.prepareStatement(sqlPOD);         
      pstmtPOD.setFloat(1,quantity);                // 數量(KPC)	 
      pstmtPOD.executeUpdate();
      pstmtPOD.close();   
	  
	 String poNumber = "";
	 String sqlPOS= " select SEGMENT1 from PO_HEADERS_ALL "+ 
                    "  where PO_HEADER_ID = "+poHeaderID+" ";    // 
     Statement statePOS=con.createStatement();
	 ResultSet rsPOS=statePOS.executeQuery(sqlPOS);
	 //out.println("sql"+sql+"<BR>");
	 if (rsPOS.next())
	 {
	   poNumber = rsPOS.getString(1);		   
	   out.println("poNumber ="+poNumber);   
	     
	 }	  
	 rsPOS.close();
     statePOS.close();	
 
 // Step9. 並送出簽核 
 
     out.println("呼叫 TSC_PO_DropShip_CreatePO 2 for 送PO簽核 <BR>");  
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 cs1.setString(1,"41");    /*  41 --> 為半導體  42 --> 為事務機 */
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();
	 	 
  try
  {       
	  //out.println("userMfgUserID="+userMfgUserID+"<BR>");
	  //out.println("respID="+respID+"<BR>");
	  //CallableStatement cs3 = con.prepareCall("{call Tsc_Drop_Ship_Order_Pkg.po_approve(?)}");	
	  CallableStatement cs3 = con.prepareCall("{call TSC_PO_APPROVE(?)}");
	  cs3.setInt(1,Integer.parseInt(poHeaderID));  //*  ItemKey //		                               
	  cs3.execute();	  
      //out.println("Procedure : Execute Success !!! ");	                                 
      cs3.close();	 
  } //end of try
  catch (Exception e)
      {
         out.println("Exception:"+e.getMessage());
      } 
	  	 
     %>
      <A href="/oradds/jsp/InterRoleERPQuery.jsp?USERNAME=<%=sugUserName%>">切換轉PO單據人員送簽核</A><BR>
     <%
	
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

