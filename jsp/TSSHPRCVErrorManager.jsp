<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QryAllChkBoxEditBean,ComboBoxAllBean,ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
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
</script>
<html>
<head>
<title>Oracle Drop-Ship RCV Error Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
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
<%
int rs1__numRows = 200;
int rs1__index = 0;
int rs_numRows = 0;

rs_numRows += rs1__numRows;

String sSql = "";
String sSqlCNT = "";
String sWhere = "";
String sWhereGP = "";
String sOrder = "";


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

String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");
String dateSetBegin=YearFr+MonthFr+DayFr;  

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
String dateSetEnd=YearTo+MonthTo+DayTo; 

String organizationId=request.getParameter("ORGPARID");
String orderType=request.getParameter("ORDERTYPE");
String sqlGlobal = "";

if (dateStringBegin==null || dateStringBegin.equals(""))
{ dateStringBegin = dateBean.getYearMonthDay(); }


%>
<% /* 建立本頁面資料庫連線  */ %>

<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body topmargin="0" bottommargin="0">
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>    
<FORM ACTION="../jsp/TestOracleOrderProcessBook.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#003366"  size="+2" face="Times New Roman"> 
<strong>Drop-Ship RCV Interface Error Manager</strong></font>
<%
 
  sWhereGP = " ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
 

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if (dateStringBegin==null || dateStringBegin.equals(""))
{
  sSql = "select RHI.HEADER_INTERFACE_ID,RHI.PROCESSING_STATUS_CODE as HEADER_STATUS, "+
          "RTI.PROCESSING_STATUS_CODE as LINE_STATUS1,RTI.TRANSACTION_STATUS_CODE as LINE_STATUS2,POH.SEGMENT1 as PO_NUMBER, "+	
		  "RHI.LAST_UPDATE_DATE,RHI.LAST_UPDATED_BY,RHI.RECEIPT_HEADER_ID,RHI.PACKING_SLIP,RHI.VALIDATION_FLAG,RHI.PROCESSING_REQUEST_ID, "+
		  "RTI.REQUEST_ID,RTI.TRANSACTION_TYPE,RTI.TRANSACTION_DATE,RTI.AUTO_TRANSACT_CODE,RTI.SHIPMENT_HEADER_ID, "+
		  "RTI.PO_HEADER_ID,RTI.PO_LINE_ID,RTI.PO_LINE_LOCATION_ID,RTI.CURRENCY_CODE,PIE.ERROR_MESSAGE "+			 
		  "from RCV_HEADERS_INTERFACE RHI,RCV_TRANSACTIONS_INTERFACE RTI,PO_INTERFACE_ERRORS PIE,PO_HEADERS_ALL POH ";
   sSqlCNT = "SELECT count(*) as CaseCount from RCV_HEADERS_INTERFACE RHI,RCV_TRANSACTIONS_INTERFACE RTI,PO_INTERFACE_ERRORS PIE,PO_HEADERS_ALL POH ";
   sWhere =  "where RHI.HEADER_INTERFACE_ID=RTI.HEADER_INTERFACE_ID "+
             "and PIE.INTERFACE_TRANSACTION_ID=RTI.INTERFACE_TRANSACTION_ID "+
			 "and RTI.PO_HEADER_ID=POH.PO_HEADER_ID and RTI.PROCESSING_MODE_CODE = 'BATCH' ";     // 預設進入頁面即將小於今日            
   sOrder = "order by 1 ";

   SWHERECOND = sWhere + sWhereGP;
   sSql = sSql + sWhere + sWhereGP + sOrder;
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
  sSql = "select RHI.HEADER_INTERFACE_ID,RHI.PROCESSING_STATUS_CODE as HEADER_STATUS, "+
          "RTI.PROCESSING_STATUS_CODE as LINE_STATUS1,RTI.TRANSACTION_STATUS_CODE as LINE_STATUS2,POH.SEGMENT1 as PO_NUMBER, "+	
		  "RHI.LAST_UPDATE_DATE,RHI.LAST_UPDATED_BY,RHI.RECEIPT_HEADER_ID,RHI.PACKING_SLIP,RHI.VALIDATION_FLAG,RHI.PROCESSING_REQUEST_ID, "+
		  "RTI.REQUEST_ID,RTI.TRANSACTION_TYPE,RTI.TRANSACTION_DATE,RTI.AUTO_TRANSACT_CODE,RTI.SHIPMENT_HEADER_ID, "+
		  "RTI.PO_HEADER_ID,RTI.PO_LINE_ID,RTI.PO_LINE_LOCATION_ID,RTI.CURRENCY_CODE,PIE.ERROR_MESSAGE "+			 
		  "from RCV_HEADERS_INTERFACE RHI,RCV_TRANSACTIONS_INTERFACE RTI,PO_INTERFACE_ERRORS PIE,PO_HEADERS_ALL POH ";
   sSqlCNT = "SELECT count(*) as CaseCount from RCV_HEADERS_INTERFACE RHI,RCV_TRANSACTIONS_INTERFACE RTI,PO_INTERFACE_ERRORS PIE,PO_HEADERS_ALL POH ";
   sWhere =  "where RHI.HEADER_INTERFACE_ID=RTI.HEADER_INTERFACE_ID "+
             "and PIE.INTERFACE_TRANSACTION_ID=RTI.INTERFACE_TRANSACTION_ID "+
			 "and RTI.PO_HEADER_ID=POH.PO_HEADER_ID and RTI.PROCESSING_MODE_CODE = 'BATCH' ";     // 預設進入頁面即將小於今日            
   sOrder = "order by 1 ";
       

  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereGP + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP;
  //out.println(sSql);    
   
   String sqlOrgCnt = "select count(*) as CaseCountORG from RCV_HEADERS_INTERFACE RHI,RCV_TRANSACTIONS_INTERFACE RTI,PO_INTERFACE_ERRORS PIE,PO_HEADERS_ALL POH ";
   sqlOrgCnt = sqlOrgCnt + sWhere + sWhereGP;
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
  <table cellSpacing="0" bordercolordark="#FFCC99" cellPadding="1" width="97%" align="center" bordercolorlight="#99CCCC"  border="1">
   <tbody>
    <tr bgcolor="#99CCFF"> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#000099" size="-1">&nbsp;</font></div></td>
	  <td width="7%"  height="19" nowrap><div align="center"><font color="#000099" face="Arial" size="2"><strong>Set<BR>Process</strong></font></div></td>   
      <td width="8%" height="22" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Interface<BR>Header ID</font></div></td>          
      <td width="16%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Header Status</font></div></td>
      <td width="10%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Line Status1</font></div></td>      
      <td width="9%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Line Status2</font></div></td>
      <td width="14%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">PO Number</font></div></td>      
      <td width="21%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Last Update Date</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Last Update By</font></div></td>	 
	          
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Receipt<BR>Header ID</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">TS Invoice No.</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Request ID</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Transaction Type</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Transaction Date</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Auto Transaction Code</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Shipment<BR>Header ID</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">PO Header ID</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">PO Line ID</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">PO Line<BR>Location ID</font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#000099" face="Arial" size="-1">Error Messsage</font></div></td>
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "FFFFDD";
	     }
	    else{
	       colorStr = "FFFFCC"; }
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#336666"><div align="center"><font size="-1" color="#FFFF00"><%out.println(rs1__index+1);%></font></div></td>	  
	  <td height="20"><div align="center"><font size="2" color="#000000">
          <input type="checkbox" name="CHKFLAG" value="<%=rsTC.getString("PROCESSING_REQUEST_ID")%>">
          </font></div>	  </td>        
	  <td nowrap><font size="-1"><%=rsTC.getString("HEADER_INTERFACE_ID") %></font></td>      
      <td width="16%" nowrap><font size="-1"><%=rsTC.getString("HEADER_STATUS")%></font></td>
      <td width="10%" nowrap><font size="-1"><%=rsTC.getString("LINE_STATUS1")%></font></td>
      <td width="9%" nowrap><font size="-1"><%=rsTC.getString("LINE_STATUS2")%></font></td>
      <td width="14%" nowrap><font size="-1"><%=rsTC.getString("PO_NUMBER")%></font></td>      
      <td width="21%" nowrap><font size="-1"><%=rsTC.getString("LAST_UPDATE_DATE")%></font></td>      
      <td width="13%" nowrap><font size="-1"><%=rsTC.getString("LAST_UPDATED_BY")%></font></td>  	  
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("RECEIPT_HEADER_ID")%></font></td>
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("PACKING_SLIP")%></font></td>	 
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("PROCESSING_REQUEST_ID")%></font></td>	  
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("TRANSACTION_TYPE")%></font></td>
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("TRANSACTION_DATE")%></font></td>
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("AUTO_TRANSACT_CODE")%></font></td>
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("SHIPMENT_HEADER_ID")%></font></td>
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("PO_HEADER_ID")%></font></td>
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("PO_LINE_ID")%></font></td> 
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("PO_LINE_LOCATION_ID")%></font></td>
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("ERROR_MESSAGE")%></font></td>    
    </tr>
    <%
      rs1__index++;
      rs_hasDataTC = rsTC.next();
              qryAllChkBoxEditBean.setPageURL("../jsp/TSSHPRCVErrorManager.jsp");
              qryAllChkBoxEditBean.setSearchKey("PROCESSING_REQUEST_ID");
              qryAllChkBoxEditBean.setFieldName("CHKFLAG");
              qryAllChkBoxEditBean.setRowColor1("B0E0E6");
              qryAllChkBoxEditBean.setRowColor2("ADD8E6");
              qryAllChkBoxEditBean.setRs(rsTC);   
}
%>
    <tr bgcolor="#99CCFF"> 
      <td height="23" colspan="20" ><font color="#000099" size="-1">總資料筆數</font> 
        <% 
	      if (CaseCount==0) 
		  { //若 	  
		  } 
		  else { 
		        out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>");
				// 若 有資料則顯示可全選的按鈕
				
			   }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5"  readonly=""><%out.println("<font color='#000099' face='Arial'><strong>"+CaseCount+"</strong></font>");%>	 </td>      
    </tr>
	<tbody>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->  
    <% if (rs_isEmptyTC ) {  %>
    <div align="center"><font color="#993366" size="2"><strong>No Record Found</strong></font></div>
    <% } else {
	           %>
			   <div align="left"><input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value="Select All"></div> 
			   <%                    
	          }
	/*若有資料則顯示可全選擇的按鈕 */ %>    
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=sWhere%>" maxlength="256" size="256">
<BR>
<div align="left"><input name="submit2" type="submit" value="Batch Setting Active / Inactive" onClick='return setSubmit2("../jsp/TSSalesAreaMapOrderTypeSetActiveSubmit.jsp")'></div>
</FORM>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#000066"><strong>[<A HREF="<%=MM_moveFirst%>">第一頁</A>]</strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#000066"><strong>[<A HREF="<%=MM_movePrev%>">上一頁</A>]</strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#000066"><strong>[<A HREF="<%=MM_moveNext%>">下一頁</A>]</strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#000066"><strong>[<A HREF="<%=MM_moveLast%>">最後一頁</A>]</strong></font></pre>
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
//rsAct.close();
//stateAct.close();  // 結束Statement Con
//ConnRpRepair.close();
%>

