<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setSubmit2(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function subWindowCustInfoFind(custNo,custName)
{ 
   if (event.keyCode==13)
   {    
    subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custNo+"&NAME="+custName,"subwin");  
   }	
}
function setCustInfoFind(custNo,custName)
{      
    subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custNo+"&NAME="+custName,"subwin");  
}
function workflowLineDetailQuery(erpURL, itemType,itemKey,xAccessKey)
{     
  subWin=window.open(erpURL);  
  //subWin=window.open(erpURL+"/wf_monitor.html?x_item_type=OEOL&x_item_key="+itemKey+"&x_admin_mode=Y&x_access_key="+xAccessKey+"&x_nls_lang=AMERICAN","subwin");  
}
</script>
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
<title>Oracle Add On System Information Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
int rs1__numRows = 200;
int rs1__index = 0;
int rs_numRows = 0;

rs_numRows += rs1__numRows;

String sSql = "";
String sSqlCNT = "";
String sWhere = "";
String sWhereSDRQ = "";
String sWhereGP = "";
String havingGrpSDRQ = "";
String sOrder = "";

String havingGrp = "";
String lightStatus ="";

//String fjamDesc = ""; 

//String link2ExcelURL = "";


int CASECOUNT=0;
float CASECOUNTPCT=0;
String sCSCountPCT="";
int idxCSCount=0;

float CASECOUNTORG=0;

//String RepLocale=(String)session.getAttribute("LOCALE"); 		
String SWHERECOND = "";
int CaseCount = 0;
int CaseCountORG =0;
float CaseCountPCT = 0;

String colorStr = "";

String dateStringBegin=request.getParameter("DATEBEGIN");
String dateStringEnd=request.getParameter("DATEEND");

String dateSetBegin=request.getParameter("DATESETBEGIN");
String dateSetEnd=request.getParameter("DATESETEND");

String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");
      if (dateSetBegin==null && YearFr==null && MonthFr==null && DayFr==null) 
	  {
	    dateBean.setAdjDate(-4);
	    dateSetBegin = dateBean.getYearMonthDay();	    
        dateBean.setAdjDate(4);
		YearFr = dateSetBegin.substring(0,4);
		MonthFr = dateSetBegin.substring(4,6);
		DayFr = dateSetBegin.substring(6,8);
	  }
	  else dateSetBegin=YearFr+MonthFr+DayFr;  

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
      if (dateSetEnd==null && YearTo==null && MonthTo==null && DayTo==null) 
	  {   
	    dateSetEnd = dateBean.getYearMonthDay();	 
      }
	  else dateSetEnd=YearTo+MonthTo+DayTo; 


String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");
String spanning=request.getParameter("SPANNING");
String dnDocNoSet=request.getParameter("DNDOCNOSET");
String invItem=request.getParameter("INVITEM");
String dnDocNo=request.getParameter("DNDOCNO");

String organizationId=request.getParameter("ORGANIZATION_ID");
String organizationCode=request.getParameter("ORGANIZATION_CODE");

  String customerId=request.getParameter("CUSTOMERID");
  String customerNo=request.getParameter("CUSTOMERNO");
  String customerName=request.getParameter("CUSTOMERNAME");
  String custActive=request.getParameter("CUSTACTIVE");
  
  String salesAreaNo=request.getParameter("SALESAREANO");
  String salesOrderNo=request.getParameter("SALESORDERNO");
  String preOrderType=request.getParameter("PREORDERTYPE");
  String custPONo=request.getParameter("CUSTPONO");
  String createdBy=request.getParameter("CREATEDBY");
  String salesPerson=request.getParameter("SALESPERSON");
  String tsInvoiceNo=request.getParameter("TSINVOICENO");
  //String UserPlanCenterNo=request.getParameter("USERPLANCENTERNO");  
  String status=request.getParameter("STATUS");
  String statusCode=request.getParameter("STATUSCODE"); 
  
  String listMode=request.getParameter("LISTMODE");  
  
  String sqlGlobal = "";
  String sWhereGlobal = "";
  String sqlDtl = "";
  
  if (dnDocNo==null || dnDocNo.equals("")) dnDocNo=""; //選擇展開的
  if (dnDocNoSet==null || dnDocNoSet.equals("")) dnDocNoSet=""; // 使用者輸入的
  if (customerId==null || customerId.equals("")) customerId="";
  if (customerNo==null || customerNo.equals("")) customerNo="";
  if (customerName==null || customerName.equals("")) customerName="";
  if (custPONo==null || custPONo.equals("")) custPONo="";
  if (createdBy==null || createdBy.equals("")) createdBy="";
  if (salesPerson==null || salesPerson.equals("")) salesPerson="";
  if (salesOrderNo==null || salesOrderNo.equals("")) salesOrderNo="";
  
  if (tsInvoiceNo==null || tsInvoiceNo.equals("")) tsInvoiceNo="";  

  if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
  if (spanning==null || spanning.equals("")) spanning = "TRUE";
  if (listMode==null) listMode = "TRUE";
  
  int iDetailRowCount = 0;


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

%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>  
<FORM ACTION="../jsp/TSRFQFactResponseMOCreateRpt.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong>OM銷售訂單出貨+應收帳+庫存資料查詢</strong></font>
<%
  String erpURL = "";

  String sSqlERP = "select PROFILE_OPTION_VALUE from APPLSYS.FND_PROFILE_OPTION_VALUES where PROFILE_OPTION_VALUE like 'http:%/pls/%' and APPLICATION_ID = 0 ";
  Statement stERP=con.createStatement();
  ResultSet rsERP=stERP.executeQuery(sSqlERP);
  if (rsERP.next())
  {
	 erpURL = rsERP.getString("PROFILE_OPTION_VALUE");		  
  } 
  rsERP.close();
  stERP.close(); 

 
  sWhereGP = " and WND.NAME IS NOT NULL ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  String currentWeek = workingDateBean.getWeekString();

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")))
{
   sSql = "SELECT WND.NAME INVOICE_NUM, "+
          "    NVL(RIL.SALES_ORDER,RCT.SALES_ORDER) SALES_ORDER,"+
		  "    WDD.SOURCE_LINE_ID LINE_ID, "+
		  "    NVL(RIL.INTERFACE_LINE_ATTRIBUTE3,RCT.INTERFACE_LINE_ATTRIBUTE3) AR_INVOICE, "+
		  "    DECODE(WDD.REQUESTED_QUANTITY_UOM,'KPC',WDD.SHIPPED_QUANTITY * 1000,WDD.SHIPPED_QUANTITY) SHIPPED_QTY, "+
          "    RIL.QUANTITY INTERFACE_QTY, RCT.QUANTITY_ORDERED AR_QTY,MR.RESERVATION_QUANTITY RES_QTY, "+
		  "    DECODE(MMT.TRANSACTION_UOM,'KPC',MMT.TRANSACTION_QUANTITY * -1000,MMT.TRANSACTION_QUANTITY * -1) MMT_QTY "+
		  "  from RA_INTERFACE_LINES_ALL RIL,  RA_CUSTOMER_TRX_LINES_ALL RCT, "+
		  "       MTL_RESERVATIONS MR,WSH_DELIVERY_DETAILS WDD, "+
		  " 	  WSH_DELIVERY_ASSIGNMENTS WDA, WSH_NEW_DELIVERIES WND, "+ //計算四日過期Line的筆數
          "       MTL_MATERIAL_TRANSACTIONS MMT ";         
			   //"ORADDMAN.TSDELIVERY_DETAIL_HISTORY f ";
   sSqlCNT = " select count(WND.NAME) as CaseCount "+
             "  from RA_INTERFACE_LINES_ALL RIL,  RA_CUSTOMER_TRX_LINES_ALL RCT, "+
		     "       MTL_RESERVATIONS MR,WSH_DELIVERY_DETAILS WDD, "+
		     " 	  WSH_DELIVERY_ASSIGNMENTS WDA, WSH_NEW_DELIVERIES WND, "+ //計算四日過期Line的筆數
             "       MTL_MATERIAL_TRANSACTIONS MMT ";
   sWhere =  "where WDA.DELIVERY_DETAIL_ID = WDD.DELIVERY_DETAIL_ID "+
			 "  and WND.DELIVERY_ID = WDA.DELIVERY_ID "+
			 // "or  d.DOCNO || '-' || d.ASSIGN_LNO in ("+distDnDocNo+") ) "+
			 "  and RIL.INTERFACE_LINE_ATTRIBUTE6(+) = WDD.SOURCE_LINE_ID "+
			 "  and RCT.INTERFACE_LINE_ATTRIBUTE6(+) = WDD.SOURCE_LINE_ID "+
			 "  and MR.ORGANIZATION_ID(+) = WDD.ORGANIZATION_ID and MR.DEMAND_SOURCE_HEADER_ID(+) = WDD.SOURCE_HEADER_ID and MR.DEMAND_SOURCE_LINE_ID(+) = WDD.SOURCE_LINE_ID "+ // 找第一筆送出給工廠判定的時間(ASSIGNING)	
			 "  and MMT.TRANSACTION_TYPE_ID = 33  "+ //找開單日大於工廠處理24小時的單據
			 "  and MMT.SOURCE_LINE_ID(+) = WDD.SOURCE_LINE_ID "; 
   sWhereSDRQ = "  ";
   havingGrp = " ";               
   havingGrpSDRQ = "  ";
   sOrder = "order by 1,2,3";
   //TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";   
   
   SWHERECOND = sWhere + sWhereGP + havingGrp;
   sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
   sSqlCNT = sSqlCNT + sWhere + sWhereGP;   
   //out.println("sSql="+ sSql);   
   
   try
        {		
         Statement statement1=con.createStatement();
         ResultSet rs1=statement1.executeQuery(sSqlCNT);
		 if (rs1.next())
		 {
		   CaseCount = rs1.getInt("CaseCount");
		   CaseCountORG = rs1.getInt("CaseCount");
		   
		   if (CaseCountORG!=0)
		   {
		     CaseCountPCT = Math.round((float)(CaseCount/CaseCountORG)*100);
			 //out.println("CaseCount="+CaseCount);
			 //out.println("CaseCountPCT="+CaseCountPCT);
			 // 取小數1位
			sCSCountPCT = Float.toString(CaseCountPCT);
			idxCSCount = sCSCountPCT.indexOf('.');
			sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
		   }
		   else
		   {
		     CaseCountPCT = 0;
			 //out.println(CaseCountPCT);
		   }
		   		   
		   rs1.close();
		   statement1.close();
		 }
		 
		} //end of try
        catch (Exception e)
        {
          out.println("Exception:"+e.getMessage());
        }
}
else
{   
   sSql = "SELECT WND.NAME INVOICE_NUM, "+
          "    NVL(RIL.SALES_ORDER,RCT.SALES_ORDER) SALES_ORDER,"+
		  "    WDD.SOURCE_LINE_ID LINE_ID, "+
		  "    NVL(RIL.INTERFACE_LINE_ATTRIBUTE3,RCT.INTERFACE_LINE_ATTRIBUTE3) AR_INVOICE, "+
		  "    DECODE(WDD.REQUESTED_QUANTITY_UOM,'KPC',WDD.SHIPPED_QUANTITY * 1000,WDD.SHIPPED_QUANTITY) SHIPPED_QTY, "+
          "    RIL.QUANTITY INTERFACE_QTY, RCT.QUANTITY_ORDERED AR_QTY,MR.RESERVATION_QUANTITY RES_QTY, "+
		  "    DECODE(MMT.TRANSACTION_UOM,'KPC',MMT.TRANSACTION_QUANTITY * -1000,MMT.TRANSACTION_QUANTITY * -1) MMT_QTY "+
		  "  from RA_INTERFACE_LINES_ALL RIL,  RA_CUSTOMER_TRX_LINES_ALL RCT, "+
		  "       MTL_RESERVATIONS MR,WSH_DELIVERY_DETAILS WDD, "+
		  " 	  WSH_DELIVERY_ASSIGNMENTS WDA, WSH_NEW_DELIVERIES WND, "+ //計算四日過期Line的筆數
          "       MTL_MATERIAL_TRANSACTIONS MMT ";         
			   //"ORADDMAN.TSDELIVERY_DETAIL_HISTORY f ";
   sSqlCNT = " select count(WND.NAME) as CaseCount "+
             "  from RA_INTERFACE_LINES_ALL RIL,  RA_CUSTOMER_TRX_LINES_ALL RCT, "+
		     "       MTL_RESERVATIONS MR,WSH_DELIVERY_DETAILS WDD, "+
		     " 	  WSH_DELIVERY_ASSIGNMENTS WDA, WSH_NEW_DELIVERIES WND, "+ //計算四日過期Line的筆數
             "       MTL_MATERIAL_TRANSACTIONS MMT ";
   sWhere =  "where WDA.DELIVERY_DETAIL_ID = WDD.DELIVERY_DETAIL_ID "+
			 "  and WND.DELIVERY_ID = WDA.DELIVERY_ID "+
			 // "or  d.DOCNO || '-' || d.ASSIGN_LNO in ("+distDnDocNo+") ) "+
			 "  and RIL.INTERFACE_LINE_ATTRIBUTE6(+) = WDD.SOURCE_LINE_ID "+
			 "  and RCT.INTERFACE_LINE_ATTRIBUTE6(+) = WDD.SOURCE_LINE_ID "+
			 "  and MR.ORGANIZATION_ID(+) = WDD.ORGANIZATION_ID and MR.DEMAND_SOURCE_HEADER_ID(+) = WDD.SOURCE_HEADER_ID and MR.DEMAND_SOURCE_LINE_ID(+) = WDD.SOURCE_LINE_ID "+ // 找第一筆送出給工廠判定的時間(ASSIGNING)	
			 "  and MMT.TRANSACTION_TYPE_ID = 33  "+ //找開單日大於工廠處理24小時的單據
			 "  and MMT.SOURCE_LINE_ID(+) = WDD.SOURCE_LINE_ID "; 
   sWhereSDRQ = "   ";
   havingGrp = " ";               
   havingGrpSDRQ = "  ";
   sOrder = "order by 1,2,3";
			 
   if (tsInvoiceNo==null || tsInvoiceNo.equals("--") || tsInvoiceNo.equals("")) {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and WND.NAME ='"+tsInvoiceNo+"'"; }  
  
   havingGrp = " ";               
   havingGrpSDRQ = "  ";
   sOrder = "order by 1,2,3";

	// out.print("aaaaaaaaaDayFr="+DayFr+",DayTo="+DayTo+", salesAreaNo="+salesAreaNo+"......");
   if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and to_char(WDD.LAST_UPDATE_DATE,'YYYYMMDD') >="+"'"+dateSetBegin+"'";
   if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and to_char(WDD.LAST_UPDATE_DATE,'YYYYMMDD') >= "+"'"+dateSetBegin+"'"+" AND to_char(WDD.LAST_UPDATE_DATE,'YYYYMMDD') <= "+"'"+dateSetEnd+"'";  
      
   // if (salesAreaNo==null || salesAreaNo.equals("") || salesAreaNo.equals("--")) {sWhere=sWhere+" ";}
    
 
  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP;
  //out.println("sSqlCNT="+sSqlCNT);    
   
   String sqlOrgCnt = "select count(WND.NAME) as CaseCountORG "+
                      "  from RA_INTERFACE_LINES_ALL RIL,  RA_CUSTOMER_TRX_LINES_ALL RCT, "+
		              "       MTL_RESERVATIONS MR,WSH_DELIVERY_DETAILS WDD, "+
		              " 	  WSH_DELIVERY_ASSIGNMENTS WDA, WSH_NEW_DELIVERIES WND, "+ //計算四日過期Line的筆數
                      "       MTL_MATERIAL_TRANSACTIONS MMT ";
   sqlOrgCnt = sqlOrgCnt + sWhere + sWhereGP + havingGrp;
   //out.println("<BR>sqlOrgCnt="+sqlOrgCnt);
   Statement statement2=con.createStatement();
   ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
   if (rs2.next())
   {
     CaseCountORG = rs2.getInt("CaseCountORG");     
   }
   rs2.close();
   statement2.close();

   try
   {       	 
		
         Statement statement3=con.createStatement();
         ResultSet rs3=statement3.executeQuery(sSqlCNT);
		 if (rs3.next())
		 {
		   //CaseCountORG = CaseCount;
		   CaseCount = rs3.getInt("CaseCount");
		   if (CaseCountORG!=0)
		   {
		     CaseCountPCT = (float)(CaseCount/CaseCountORG)*100;
			 //out.println("CaseCount="+CaseCount);
			 //out.println("CaseCountPCT="+CaseCountPCT);
			 // 取小數1位
			sCSCountPCT = Float.toString(CaseCountPCT);
			idxCSCount = sCSCountPCT.indexOf('.');
			sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
		   }
		   else
		   {
		     CaseCountPCT = 0;
			 //out.println(CaseCountPCT);
		   }
		   rs3.close();
		   statement3.close();
		 }
		 
		} //end of try
        catch (Exception e)
        {
          out.println("Exception:"+e.getMessage());
        }
   
}
// 準備予維修方式使用的Statement Con //
//Statement stateAct=con.createStatement();
//out.println(sSql);
sqlGlobal = sSql;
//PreparedStatement StatementRpRepair = ConnRpRepair.prepareStatement(sSql);
Statement statementTC=con.createStatement(); 
//ResultSet rsTC = StatementRpRepair.executeQuery();
ResultSet rsTC=statementTC.executeQuery(sSql);
   //boolean RpRepair_isEmpty = !RpRepair.next();
   //boolean RpRepair_hasData = !RpRepair_isEmpty;
   //Object RpRepair_data;
boolean rs_isEmptyTC = !rsTC.next();
boolean rs_hasDataTC = !rs_isEmptyTC;
Object rs_dataTC;  
//int RpRepair_numRows = 0;

// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int rs_first = 1;
int rs_last  = 1;
int rs_total = -1;


if (rs_isEmptyTC) {
  rs_total = rs_first = rs_last = 0;
}

//set the number of rows displayed on this page
if (rs_numRows == 0) {
  rs_numRows = 1;
}

String MM_paramName = "";

// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = rsTC;
int       MM_rsCount = rs_total;
int       MM_size = rs_numRows;
String    MM_uniqueCol = "";
          MM_paramName = "";
int       MM_offset = 0;
boolean   MM_atTotal = false;
boolean   MM_paramIsDefined = (MM_paramName.length() != 0 && request.getParameter(MM_paramName) != null);

// *** Move To Record: handle 'index' or 'offset' parameter

if (!MM_paramIsDefined && MM_rsCount != 0) {

  //use index parameter if defined, otherwise use offset parameter
  String r = request.getParameter("index");
  if (r==null) r = request.getParameter("offset");
  if (r!=null) MM_offset = Integer.parseInt(r);

  // if we have a record count, check if we are past the end of the recordset
  if (MM_rsCount != -1) {
    if (MM_offset >= MM_rsCount || MM_offset == -1) {  // past end or move last
      if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  //move the cursor to the selected record
  int i;
  for (i=0; rs_hasDataTC && (i < MM_offset || MM_offset == -1); i++) {
    rs_hasDataTC = MM_rs.next();
  }
  if (!rs_hasDataTC) MM_offset = i;  // set MM_offset to the last possible record
}

// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; rs_hasDataTC && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    rs_hasDataTC = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
  if (!rs_hasDataTC) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!rs_hasDataTC && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  rsTC.close();
  rsTC = statementTC.executeQuery(sSql);
  rs_hasDataTC = rsTC.next();
  MM_rs = rsTC;

  // move the cursor to the selected record
  for (i=0; rs_hasDataTC && i < MM_offset; i++) {
    rs_hasDataTC = MM_rs.next();
  }
}

// *** Move To Record: update recordset stats

// set the first and last displayed record
rs_first = MM_offset + 1;
rs_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  rs_first = Math.min(rs_first, MM_rsCount);
  rs_last  = Math.min(rs_last, MM_rsCount);
}

// set the boolean used by hide region to check if we are on the last record
MM_atTotal  = (MM_rsCount != -1 && MM_offset + MM_size >= MM_rsCount);
%>
<%
// *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
String[] MM_removeList = { "index", MM_paramName };

// create the MM_keepURL string
if (request.getQueryString() != null) {
  MM_keepURL = '&' + request.getQueryString();
  for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) {
  int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
    if (start >= 0 && MM_keepURL.charAt(start) == '&' &&
        MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') {
      int stop = MM_keepURL.indexOf('&', start + 1);
      if (stop == -1) stop = MM_keepURL.length();
      MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
    }
  }
}

// add the Form variables to the MM_keepForm string
if (request.getParameterNames().hasMoreElements()) {
  java.util.Enumeration items = request.getParameterNames();
  while (items.hasMoreElements()) {
    String nextItem = (String)items.nextElement();
    boolean found = false;
    for (int i=0; !found && i < MM_removeList.length; i++) {
      if (MM_removeList[i].equals(nextItem)) found = true;
    }
    if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) {
      MM_keepForm = MM_keepForm + '&' + nextItem + '=' + java.net.URLEncoder.encode(request.getParameter(nextItem));
    }
  }
}

// create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL + MM_keepForm;
if (MM_keepBoth.length() > 0) MM_keepBoth = MM_keepBoth.substring(1);
if (MM_keepURL.length() > 0)  MM_keepURL = MM_keepURL.substring(1);
if (MM_keepForm.length() > 0) MM_keepForm = MM_keepForm.substring(1);


// *** Move To Record: set the strings for the first, last, next, and previous links

String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
{
  String MM_keepMove = MM_keepBoth;  // keep both Form and URL parameters for moves
  String MM_moveParam = "index=";

  // if the page has a repeated region, remove 'offset' from the maintained parameters
  if (MM_size > 1) {
    MM_moveParam = "offset=";
    int start = MM_keepMove.indexOf(MM_moveParam);
    if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) {
      int stop = MM_keepMove.indexOf('&', start);
      if (start == 0 && stop != -1) stop++;
      if (stop == -1) stop = MM_keepMove.length();
      if (start > 0) start--;
      MM_keepMove = MM_keepMove.substring(0,start) + MM_keepMove.substring(stop);
    }
  }

  // set the strings for the move to links
  StringBuffer urlStr = new StringBuffer(request.getRequestURI()).append('?').append(MM_keepMove);
  if (MM_keepMove.length() > 0) urlStr.append('&');
  urlStr.append(MM_moveParam);
  MM_moveFirst = urlStr + "0";
  MM_moveLast  = urlStr + "-1";
  MM_moveNext  = urlStr + Integer.toString(MM_offset+MM_size);
  MM_movePrev  = urlStr + Integer.toString(Math.max(MM_offset-MM_size,0));
}

%> 
<%
  if (listMode==null || listMode.equals("TRUE"))
  {
%> 
  <table cellSpacing='0' bordercolordark='#D8DEA9'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>     	 	 
	 <tr>
	    <td width="14%" colspan="2" nowrap><font color="#006666"><strong>發票號碼</strong></font>         
        </td> 
		<td width="47%" colspan="2">
		   <div align="left">
		   <font color="#006666"><strong> </strong></font>
		   <input type="text" name="TSINVOICENO" value="<%=tsInvoiceNo%>">		   
		   </div>
		</td> 
		 
	 </tr>	  
     <tr>	    
	   <td nowrap colspan="2"><font color="#006666"><strong>出貨<jsp:getProperty name="rPH" property="pgDateFr"/></strong></font>
        <%
		  String CurrYear = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (YearFr==null)
		  {
		    CurrYear=dateBean.getYearString();

		    arrayComboBoxBean.setSelection(CurrYear);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(YearFr);
		  }
	      arrayComboBoxBean.setFieldName("YEARFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <%
		  String CurrMonth = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthFr==null)
		  {
		    CurrMonth=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonth);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthFr);
		  }
	      arrayComboBoxBean.setFieldName("MONTHFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <font color="#CC3366" size="2" face="Arial Black">&nbsp;</font>
        <font color="#CC3366" size="2" face="Arial Black">&nbsp;</font>
        <%
		  String CurrDay = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayFr==null)
		  {
		    CurrDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDay);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayFr);
		  }
	      arrayComboBoxBean.setFieldName("DAYFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
       <font color="#006666"><strong><jsp:getProperty name="rPH" property="pgDateTo"/></strong></font>
        <%
		  String CurrYearTo = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (YearTo==null)
		  {
		    CurrYearTo=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYearTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(YearTo);
		  }
	      arrayComboBoxBean.setFieldName("YEARTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>        
       <%
		  String CurrMonthTo = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthTo==null)
		  {
		    CurrMonthTo=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonthTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthTo);
		  }
	      arrayComboBoxBean.setFieldName("MONTHTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>        
       <%
		  String CurrDayTo = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayTo==null)
		  {
		    CurrDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDayTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayTo);
		  }
	      arrayComboBoxBean.setFieldName("DAYTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
    </td>  
	<td colspan="2">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSOMShipARMMTCheckProcessRpt.jsp")' > 			 
	</td>
   </tr>
  </table>  
<%
 }  // End of if (listMode==null || listMode,equals("TRUE")) 
 
%>
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
    <tr bgcolor="#D8DEA9"> 
	  <td width="4%" height="22" nowrap><div align="center"><font color="#000000">&nbsp;</font></div></td> 
	  <td width="11%" height="22" nowrap><div align="center"><font color="#006666">發票號碼</font></div></td>               	  
	  <td width="10%" nowrap><div align="center"><font color="#006666">銷售訂單號</font></div></td>
	  <td width="15%" nowrap><div align="center"><font color="#006666">訂單項識別碼</font></div></td>
      <td width="13%" nowrap><div align="center"><font color="#006666">應收帳發票號</font></div></td>  
	  <td width="15%" nowrap><div align="center"><font color="#006666">已出貨數量</font></div></td> 
	  <td width="8%" nowrap><div align="center"><font color="#006666">異動數量</font></div></td> 
	  <td width="8%" nowrap><div align="center"><font color="#006666">應收帳數量</div></td> 
	  <td width="8%" nowrap><div align="center"><font color="#006666">保留數量</font></div></td>                  	  
	  <td width="8%" nowrap><div align="center"><font color="#006666">庫存異動數量</font></div></td> 
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "FFFFCC";
	     }
	    else{
	       colorStr = "#D8DEA9"; }
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#D8DEA9" width="4%" nowrap><div align="center"><font size="2" color="#006666"><a name='#<%=rsTC.getString("INVOICE_NUM")%>'><%out.println(rs1__index+1);%></a></font></div></td>
	  <td nowrap><font color="#006666"><%=rsTC.getString("INVOICE_NUM")%></font></td>     	             
	  <td width="10%" nowrap><div align="center"><font size="2" color="#006666"><%=rsTC.getString("SALES_ORDER")%></font></div></td>
	  <td width="15%" nowrap><div align="center"><font color="#006666">
	  
	           <% //out.println(rsTC.getString("LINE_ID"));
			          String xAccessKey = "";
			          String sSqlXAccKey = "select TEXT_VALUE from APPLSYS.WF_ITEM_ATTRIBUTE_VALUES where  ITEM_TYPE ='OEOL' and ITEM_KEY = '"+rsTC.getString("LINE_ID")+"' and NAME = '.ADMIN_KEY' ";
	                  //out.println(sSqlXAccKey);
	                  Statement stmentXAccKey=con.createStatement();
                      ResultSet rsXAccKey=stmentXAccKey.executeQuery(sSqlXAccKey);
					  if (rsXAccKey.next())
					  { xAccessKey = rsXAccKey.getString("TEXT_VALUE"); }
					  rsXAccKey.close();
					  stmentXAccKey.close();
					  
					 String getOEOLURL = ""; 
					  
					 try
					 {	 						 
						 // 
						  CallableStatement cs4 = con.prepareCall("{? = call WF_MONITOR.GetDiagramURL(?,?,?,?)}");			
						  cs4.registerOutParameter(1, Types.VARCHAR); //  傳回值 
					      cs4.setString(2,"WF_CORE.Translate('WF_WEB_AGENT')");                                         //  Org ID 	
					      cs4.setString(3,"OEOL");                     // User ID 					 					      
						  cs4.setString(4,rsTC.getString("LINE_ID"));                                //  RFQ NO 											 
						  cs4.setString(5,"YES");                                //  BATCH MO GENERATE NO						  	 					     
					      cs4.execute();					      
					      getOEOLURL = cs4.getString(1);					
					      //out.println(" <a href="+getOEOLURL+">"+getOEOLURL+"</a>");   					    
					      cs4.close();		
					   }	  
				       catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
					  
					  
			   %>
			     <a href='javaScript:workflowLineDetailQuery("<%=getOEOLURL%>","<%="OEOL"%>","<%=rsTC.getString("LINE_ID")%>","<%=xAccessKey%>")'>
                  <%=rsTC.getString("LINE_ID")%>
				 </a>
			   </font></div></td> 
      <td width="13%" nowrap><font size="2" color="#006666"><%   out.println(rsTC.getString("AR_INVOICE"));	 %></font></td> 
	  <td width="15%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("SHIPPED_QTY")%></font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("INTERFACE_QTY")%></font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("AR_QTY")%></font></div></td>	
	  <td width="8%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("RES_QTY")%></font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("MMT_QTY")%></font></div></td>	    	  	                
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
}
%>
    <tr bgcolor="#D8DEA9"> 
      <td height="23" colspan="10" ><font color="#006666"><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">
	 <font color='#000066' face="Arial"><strong><%=CaseCount%></strong></font>
	 &nbsp;&nbsp;
	 </td>      
    </tr>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="2">
    <% if (rs_isEmptyTC ) {  %>
    <strong>No Record Found</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input name="SQLDETAIL" type="hidden" value="<%=sqlDtl%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
<input name="DATESETBEGIN" type="hidden" value="<%=dateSetBegin%>">
<input name="DATESETEND" type="hidden" value="<%=dateSetEnd%>">
<input name="STATUS" type="hidden" value="<%=status%>">
</FORM>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveFirst%>"><jsp:getProperty name="rPH" property="pgFirst"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_movePrev%>"><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveNext%>"><jsp:getProperty name="rPH" property="pgNext"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveLast%>"><jsp:getProperty name="rPH" property="pgLast"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
  </tr>
</table>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
<%
rsTC.close();
statementTC.close();
%>

