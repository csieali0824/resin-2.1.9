<!--modify by Peggy 20150105,年度下拉選單程式改寫-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
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
   // 若未選擇任一Line 作動作,則警告
   var chkFlag="FALSE";
   for (i=0;i<document.MYFORM.CHKFLAG.length;i++)
   {
     if (document.MYFORM.CHKFLAG[i].checked==true)
	 {
	   chkFlag="TURE";
	 } 
   }  
   if (chkFlag=="FALSE" && document.MYFORM.CHKFLAG.length!=null)
   {
    alert("請選擇某一筆通知單據作轉遞...");   
    return(false);
   }
  //   
  
  if (document.MYFORM.TRANSNAME.value=="" || document.MYFORM.TRANSNAME.value=="--")
  {
   alert("請選擇轉送人員!!!");
   return(false);
  }
 
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function workflowDetailQuery(notificationID)
{     
  subWin=window.open("../jsp/OracleWorkflowNotificationProcess.jsp?NOTIFYID="+notificationID,"subwin");  
}
function workflowMonitorQuery(erpURL)
{     
  subWin=window.open(erpURL);    
}
function workflowBodyQuery(getNotifyID)
{     
  subWin=window.open("../jsp/OracleWorkflowNotificationBody.jsp?NOTIFICATIONID="+getNotifyID,"subwin");  
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
<title>Oracle Workflow Notification Query</title>
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
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
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
  String userId = ""; 
  String encryptPassword = ""; 
  String decryptPassword = ""; 
  String userName = ""; 
  String sqlSSO = ""; 


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

String notifyStatus=request.getParameter("NOTIFYSTATUS");

  String name=request.getParameter("NAME");
  String transName=request.getParameter("TRANSNAME");
  String itemType=request.getParameter("ITEMTYPE");
  String notificationID=request.getParameter("NOTIFICATIONID");
  String moNo=request.getParameter("MONO");
  
  String listMode=request.getParameter("LISTMODE");  
  
  String sqlGlobal = "";
  String sWhereGlobal = "";
  String sqlDtl = "";

  if (listMode==null) listMode = "TRUE";
  if (organizationId==null || organizationId.equals("")) { organizationId="49"; }
  if (notificationID==null) notificationID = "";
  if (moNo==null) moNo = "";
  
  int iDetailRowCount = 0;
  
  if (notifyStatus==null) notifyStatus = "";
  
 // out.println("notifyStatus="+notifyStatus);


    // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
     String clientID = "";
	 if (organizationId=="46" || organizationId.equals("46"))
	 {  clientID = "42"; }
	 else { clientID = "41"; }
  
     //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
	 cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機 */
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();
	 
  //  
  
  //由Oracle ERP 中的 fnd_user 取得該使用者加密後的密碼
  Statement stmtSSO=con.createStatement(); 
  sqlSSO ="select * from fnd_user where ( user_name = '%"+UserName+"%' or lower(user_name)='"+UserName+"') "; 
  //out.println("sqlSSO="+sqlSSO);
  ResultSet rsSSO = stmtSSO.executeQuery(sqlSSO);   
  while (rsSSO.next()) 
  { 
    userId = rsSSO.getString("USER_NAME"); 
    encryptPassword = rsSSO.getString("ENCRYPTED_USER_PASSWORD"); 
  } 
  rsSSO.close();
  stmtSSO.close();
  
   //透過Oracle ERP 的API 將加密後的密碼轉成未加密的密碼 
  oracle.apps.fnd.security.AolSecurity aolsec=new oracle.apps.fnd.security.AolSecurity(); 
  decryptPassword = aolsec.decrypt("APPS",encryptPassword);   
  
  //  out.println("userId="+userId);
  //out.println("decryptPassword="+decryptPassword);
  
   String erpURL = "";  
   try {	    
		  //String sSqlERP = "select PROFILE_OPTION_VALUE from APPLSYS.FND_PROFILE_OPTION_VALUES where PROFILE_OPTION_VALUE like 'http:%/dev60cgi/f60cgi' ";
		  // 以下改抓Single Sign-On 的SQL取Profile option value的網址
		  String sSqlERP = "select PROFILE_OPTION_VALUE from APPLSYS.FND_PROFILE_OPTION_VALUES where PROFILE_OPTION_VALUE like 'http:%/pls/%' and APPLICATION_ID = 0 ";
		  Statement stERP=con.createStatement();
		  ResultSet rsERP=stERP.executeQuery(sSqlERP);
		  if (rsERP.next())
		  {
		   erpURL = rsERP.getString("PROFILE_OPTION_VALUE");		  
		  } 
		  rsERP.close();
		  stERP.close();
		} catch (Exception ee) { out.println("Exception:"+ee.getMessage());  }


%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
  
<Form name="MYFORM" action=<%=erpURL+"/oraclemypage.home"%> method="post" >
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial"></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong>Workflow Notification Query</strong></font>
<BR>
  <A href="/oradds/ORAddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = " and ORIGINAL_RECIPIENT IS NOT NULL ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  String currentWeek = workingDateBean.getWeekString();

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")))
{
  sSql = "SELECT NOTIFICATION_ID, FROM_USER, CONTEXT, "+
          " MESSAGE_TYPE, SUBJECT, BEGIN_DATE from APPLSYS.WF_NOTIFICATIONS ";	 
   sSqlCNT = " select count(NOTIFICATION_ID) as CaseCount "+
             "  from APPLSYS.WF_NOTIFICATIONS ";		 
   sWhere =  "where STATUS = 'OPEN' ";
			  
   sWhereSDRQ = "   ";
   havingGrp = " ";               
   havingGrpSDRQ = "  ";
   sOrder = "order by BEGIN_DATE";
   
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
   sSql = "SELECT NOTIFICATION_ID, FROM_USER, CONTEXT, "+
          " MESSAGE_TYPE, SUBJECT, BEGIN_DATE from APPLSYS.WF_NOTIFICATIONS ";	 
   sSqlCNT = " select count(NOTIFICATION_ID) as CaseCount "+
             "  from APPLSYS.WF_NOTIFICATIONS ";		 
   sWhere =  "where NOTIFICATION_ID > 0 ";
			  
   sWhereSDRQ = "   ";
   havingGrp = " ";               
   havingGrpSDRQ = "  ";
   sOrder = "order by BEGIN_DATE";
			 
   if (name==null || name.equals("--") || name.equals("")) {sWhere=sWhere+" ";}
   else {
         if (name.equals("SLAVO"))
		 {
          sWhere=sWhere+" and ( ORIGINAL_RECIPIENT = '"+name+"' or ORIGINAL_RECIPIENT = 'FND_RESP|ONT|TSC_OM_SEMI_VICE PRESIDENT|STANDARD') ";
		 } else {
		         sWhere=sWhere+" and ORIGINAL_RECIPIENT = '"+name+"'";
				}		  
	    }  
   
   if (itemType==null || itemType.equals("--") || itemType.equals("")) {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and MESSAGE_TYPE = '"+itemType+"'"; }  
   
   if (notificationID==null || notificationID.equals("--") || notificationID.equals("")) {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and NOTIFICATION_ID = '"+notificationID+"'"; } 
   
   if ( notifyStatus==null || notifyStatus.equals("--") || notifyStatus.equals("") ) { sWhere=sWhere + " "; }
   else { 
            
           sWhere=sWhere + " and STATUS = '"+notifyStatus+"' "; 
        }
   
   if (moNo==null || moNo.equals("--") || moNo.equals("")) {sWhere=sWhere+" ";}
   else { // 找得到Header ID就用Header ID like Context
         String headerID ="";
		 Statement stateHdr=con.createStatement();
         ResultSet rsHdr=stateHdr.executeQuery("select HEADER_ID from OE_ORDER_HEADERS_ALL where ORDER_NUMBER = '"+moNo+"' ");
		 if (rsHdr.next())
		 {
		  headerID = rsHdr.getString("HEADER_ID");
		  sWhere=sWhere+" and CONTEXT like '%"+headerID+"%'";
		 } 
		 rsHdr.close();
		 stateHdr.close();         
	    } 
  
   havingGrp = " ";               
   havingGrpSDRQ = "  ";
   sOrder = "order by BEGIN_DATE";

	// out.print("aaaaaaaaaDayFr="+DayFr+",DayTo="+DayTo+", salesAreaNo="+salesAreaNo+"......");
   if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and to_char(BEGIN_DATE,'YYYYMMDD') >="+"'"+dateSetBegin+"'";
   if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and to_char(BEGIN_DATE,'YYYYMMDD') >= "+"'"+dateSetBegin+"'"+" AND to_char(BEGIN_DATE,'YYYYMMDD') <= "+"'"+dateSetEnd+"'";  
      
   // if (salesAreaNo==null || salesAreaNo.equals("") || salesAreaNo.equals("--")) {sWhere=sWhere+" ";}
    
 
  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP;
  //out.println("sSql="+sSql);    
   
   String sqlOrgCnt = "select count(NOTIFICATION_ID) as CaseCountORG "+
                       "  from APPLSYS.WF_NOTIFICATIONS ";	
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
	    <td width="24%" colspan="1" nowrap><font color="#006666"><strong>人員</strong></font></td> 
		<td width="26%" colspan="1">
		   <div align="left">
		   <font color="#006666"><strong> </strong></font>
		   <%
		    
		         try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = "select NAME, NAME||'('||DISPLAY_NAME||')' "+
			                          "from WF_LOCAL_ROLES ";
			       String whereOType = "where STATUS ='ACTIVE' "+
				                       "  and ( ORIG_SYSTEM='PER' or ( ORIG_SYSTEM = 'FND_RESP' and DISPLAY_NAME='YEW_OM_SEMI_Vice President' ) ) "+
				                       "  and NOTIFICATION_PREFERENCE='QUERY' ";								  
				   String orderType = "order by NAME ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType + orderType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(name);
	               comboBoxBean.setFieldName("NAME");	   
                   out.println(comboBoxBean.getRsString());
				   	  		  
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		     	 
		   %>   
		   </div>
	   </td> 
		<td width="26%" colspan="1" nowrap><font color="#006666"><strong>項目類型</strong></font></td> 
		<td width="24%" colspan="1">
		   <div align="left">
		   <font color="#006666"><strong> </strong></font>
		   
		   <%
		   // REQAPPRV, OEOH , POAPPRV
		   
		         try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = "select DISTINCT a.MESSAGE_TYPE, a.MESSAGE_TYPE||'('||b.DISPLAY_NAME||')' "+
			                          "from APPLSYS.WF_NOTIFICATIONS a, APPLSYS.WF_ITEM_TYPES_TL b ";
			       String whereOType = "where a.MESSAGE_TYPE = b.NAME and b.LANGUAGE ='ZHT'  ";								  
				   String orderType = "  ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(itemType);
	               comboBoxBean.setFieldName("ITEMTYPE");	   
                   out.println(comboBoxBean.getRsString());
				   	  		  
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		      
		   %>   
		   </div>
	   </td> 
	 </tr>	  
     <tr>	    
	   <td nowrap colspan="2"><font color="#006666"><strong>通知<jsp:getProperty name="rPH" property="pgDateFr"/></strong></font>
        <%
		 // String CurrYear = null;	     		 
	     //try
         //{       
         // String a[]={"2009","2010","2011","2012","2013","2014"};
         // arrayComboBoxBean.setArrayString(a);
		 // if (YearFr==null)
		 //{
		 //   CurrYear=dateBean.getYearString();
         // 
		 //   arrayComboBoxBean.setSelection(CurrYear);
		 // } 
		 // else 
		 // {
		 //  arrayComboBoxBean.setSelection(YearFr);
		 // }
	     // arrayComboBoxBean.setFieldName("YEARFR");	   
         // out.println(arrayComboBoxBean.getArrayString());		      		 
         //} //end of try
         //catch (Exception e)
         //{
         // out.println("Exception:"+e.getMessage());
         //}
		//modify by Peggy 20150105
		try
		{     
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2009+1];
			for (int i = Integer.parseInt(dateBean.getYearString()) ; i >=2009 ; i--)
			{
				a[j++] = ""+i; 
			}
			arrayComboBoxBean.setArrayString(a);
			arrayComboBoxBean.setSelection((YearFr==null?dateBean.getYearString():YearFr));
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
		//  String CurrYearTo = null;	     		 
	    // try
        // {       
        //  String a[]={"2009","2010","2011","2012","2013","2014"};
        //  arrayComboBoxBean.setArrayString(a);
		//  if (YearTo==null)
		// {
		//   CurrYearTo=dateBean.getYearString();
		//    arrayComboBoxBean.setSelection(CurrYearTo);
		//  } 
		//  else 
		//  {
		//    arrayComboBoxBean.setSelection(YearTo);
		//  }
	    //  arrayComboBoxBean.setFieldName("YEARTO");	   
        //  out.println(arrayComboBoxBean.getArrayString());		      		 
        // } //end of try
        // catch (Exception e)
        // {
        //  out.println("Exception:"+e.getMessage());
        // }
		//modify by Peggy 20150105
		try
		{       
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2009+1];
			for (int i =Integer.parseInt(dateBean.getYearString()) ; i >= 2009 ; i--)
			{
				a[j++] = ""+i; 
			}
			arrayComboBoxBean.setArrayString(a);
			arrayComboBoxBean.setSelection((YearTo==null?dateBean.getYearString():YearTo));
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
	<td colspan="1"><font color="#006666"><strong>
	       通知識別碼		</strong></font>   			 
	</td>
	<td colspan="1">
	       <input name="NOTIFICATIONID" tabindex='9' type="text" size="20" value="<%=notificationID%>" maxlength="60">		   			 
	</td>
   </tr>   
   <tr>
     <td><font color="#006666"><strong>MO單號(option by OEOH item Type)</strong></font></td><td><font color="#006666"><strong><input name="MONO" tabindex='9' type="text" size="20" value="<%=moNo%>" maxlength="60"></strong></font></td>
	 <td colspan="1"><font color="#006666"><strong>單據狀態</strong></font>
	    <select name="NOTIFYSTATUS">
	      <option value="OPEN" <% if (notifyStatus==null || notifyStatus.equals("")) out.println("selected"); %>>Open</option>
	      <option value="CLOSED" <% if (notifyStatus.equals("CLOSED")) out.println("selected"); %>>Closed</option>
		</select>
	 </td>
     <td colspan="1"><INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/OracleWorkflowNotificationQuery.jsp")' > </td>
   </tr>
  </table>  
<%
 }  // End of if (listMode==null || listMode,equals("TRUE"))  
%>
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
    <tr bgcolor="#D8DEA9"> 
	  <td width="4%" height="22" nowrap><div align="center"><font color="#000000">&nbsp;</font></div></td>
	  <td width="4%" height="22" nowrap><div align="center"><font color="#000000">&nbsp;</font></div></td> 
	  <td width="4%" height="22" nowrap><div align="center"><font color="#006666">Select</font></div></td>
	  <td width="29%" height="22" nowrap><div align="center"><font color="#006666">From</font></div></td>               	  
	  <td width="13%" nowrap><div align="center"><font color="#006666">Type</font></div></td>
	  <td width="43%" nowrap><div align="center"><font color="#006666">Subject</font></div></td>
      <td width="11%" nowrap><div align="center"><font color="#006666">Send</font></div></td>  	   
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "FFFFCC";
	     }
	    else{
	       colorStr = "#D8DEA9"; }
		   
		   String headerID = "";
		   
		   String context = rsTC.getString("CONTEXT");
		   //out.println("context="+context);
		   if (context!=null)
		   {
		    int hdrIDBegin =context.indexOf(":") ;
            int hdrIDEnd = context.lastIndexOf(":");
		    headerID = context.substring(hdrIDBegin+1,hdrIDEnd);
		   }
		   //out.println("headerID="+headerID);
		  /* 
		   String getURL = ""; 
		   
		   try
		   {	
		   
		       if (rsTC.getString("MESSAGE_TYPE")!="CS_MSGS" && !rsTC.getString("MESSAGE_TYPE").equals("CS_MSGS")) 						 
			   {			 // 
						  CallableStatement cs4 = con.prepareCall("{? = call WF_MONITOR.GetUrl(?,?,?,?)}");			
						  cs4.registerOutParameter(1, Types.VARCHAR); //  傳回值 
					      cs4.setString(2,"WF_CORE.Translate('WF_WEB_AGENT')");                                         //  Org ID 	
					      cs4.setString(3,rsTC.getString("MESSAGE_TYPE"));                     // User ID 					 					      
						  cs4.setString(4,headerID);                                //  RFQ NO 											 
						  cs4.setString(5,"YES");                                //  BATCH MO GENERATE NO						  	 					     
					      cs4.execute();					      
					      getURL = cs4.getString(1);					
					      //out.println(" <a href="+getURL+">"+getURL+"</a>");   					    
					      cs4.close();		
			   } // End of if		  
			}	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); }
		  */ 
		   String getDiagramURL = ""; 
		   
		   try
		   {	
		   
		       if (rsTC.getString("MESSAGE_TYPE")!="CS_MSGS" && !rsTC.getString("MESSAGE_TYPE").equals("CS_MSGS")) 						 
			   {			 // 
						  CallableStatement cs4 = con.prepareCall("{? = call WF_MONITOR.GetDiagramURL(?,?,?,?)}");			
						  cs4.registerOutParameter(1, Types.VARCHAR); //  傳回值 
					      cs4.setString(2,"WF_CORE.Translate('WF_WEB_AGENT')");                                         //  Org ID 	
					      cs4.setString(3,rsTC.getString("MESSAGE_TYPE"));                     // User ID 					 					      
						  cs4.setString(4,headerID);                                //  RFQ NO 											 
						  cs4.setString(5,"YES");                                //  BATCH MO GENERATE NO						  	 					     
					      cs4.execute();					      
					      getDiagramURL = cs4.getString(1);					
					      //out.println(" <a href="+getOEOLURL+">"+getOEOLURL+"</a>");   					    
					      cs4.close();		
			   } // End of if		  
			}	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
			
			
			
		   String envelopURL = "";
		/*	
		   try
		   {	 						 
						 // 
						  CallableStatement cs4 = con.prepareCall("{? = call WF_MONITOR.GetEnvelopeURL(?,?,?,?)}");			
						  cs4.registerOutParameter(1, Types.VARCHAR); //  傳回值 
					      cs4.setString(2,"WF_CORE.Translate('WF_WEB_AGENT')");                                         //  Org ID 	
					      cs4.setString(3,rsTC.getString("MESSAGE_TYPE"));                     // User ID 					 					      
						  cs4.setString(4,headerID);                                //  RFQ NO 											 
						  cs4.setString(5,"YES");                                //  BATCH MO GENERATE NO						  	 					     
					      cs4.execute();					      
					      envelopURL = cs4.getString(1);					
					      //out.println(" envelopURL="+getOEOLURL);   					    
					      cs4.close();		
			}	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
		   */
		  /* 
		    try
		   {	
		   
		       if (rsTC.getString("MESSAGE_TYPE")!="CS_MSGS" && !rsTC.getString("MESSAGE_TYPE").equals("CS_MSGS")) 						 
			   {			 // 
						  CallableStatement cs4 = con.prepareCall("{? = call WF_ENGINE.GetItemAttrDocument(?,?,?,?)}");			
						  cs4.registerOutParameter(1, Types.VARCHAR); //  傳回值 
					      cs4.setString(2,rsTC.getString("MESSAGE_TYPE"));                                         //  Org ID 	
					      cs4.setString(3,headerID);                     // User ID 					 					      
						  cs4.setString(4,headerID);                                //  RFQ NO 											 
						  cs4.setString(5,"YES");                                //  BATCH MO GENERATE NO						  	 					     
					      cs4.execute();					      
					      getDiagramURL = cs4.getString(1);					
					      //out.println(" <a href="+getOEOLURL+">"+getOEOLURL+"</a>");   					    
					      cs4.close();		
			   } // End of if		  
			}	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
		*/	
		   
		
		   String getBody= "";
		   try
		   {	
		   
		       if (rsTC.getString("MESSAGE_TYPE")!="CS_MSGS" && !rsTC.getString("MESSAGE_TYPE").equals("CS_MSGS")) 						 
			   {			 // 
						  CallableStatement cs4 = con.prepareCall("{? = call WF_NOTIFICATION.GetBody(?,?)}");			
						  cs4.registerOutParameter(1, Types.VARCHAR); //  傳回值 
					      cs4.setString(2,rsTC.getString("NOTIFICATION_ID"));                                         //  Org ID 	
					      cs4.setString(3,"");                     // User ID 					 					      						   	 					     
					      cs4.execute();					      
					      getBody = cs4.getString(1);					
					      //out.println(" <a href="+getOEOLURL+">"+getOEOLURL+"</a>");   					    
					      cs4.close();
						  
						  //out.println("getBody="+getBody);		
			   } // End of if		  
			}	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
			
		   String getSubject= "";
		   try
		   {	
		   
		       if (rsTC.getString("MESSAGE_TYPE")!="CS_MSGS" && !rsTC.getString("MESSAGE_TYPE").equals("CS_MSGS")) 						 
			   {			 // 
						  CallableStatement cs4 = con.prepareCall("{? = call WF_NOTIFICATION.GetSubject(?)}");			
						  cs4.registerOutParameter(1, Types.VARCHAR); //  傳回值 					                                           //  Org ID 	
					      cs4.setInt(2,rsTC.getInt("NOTIFICATION_ID"));                     // User ID 					 					      						   	 					     
					      cs4.execute();					      
					      getSubject = cs4.getString(1);					
					      //out.println(" <a href="+getOEOLURL+">"+getOEOLURL+"</a>");   					    
					      cs4.close();
						  
						  //out.println("getSubject="+getSubject);		
			   } // End of if		  
			}	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
		/*
		   String getDocument= "";
		   String getDocumentType= "";
		   try
		   {	
		   
		       if (rsTC.getString("MESSAGE_TYPE")!="CS_MSGS" && !rsTC.getString("MESSAGE_TYPE").equals("CS_MSGS")) 						 
			   {			
			     //if (rsTC.getString("MESSAGE_TYPE").equals("POAPPRV:71825-229580:134646")) //CONTEXT 
				 //{
						  CallableStatement cs4 = con.prepareCall("{call APPS.PO_WF_PO_NOTIFICATION.get_po_approve_msg(?,?,?,?)}");									   					                                           //  Org ID 	
					      cs4.setString(1,rsTC.getString("CONTEXT"));                     // User ID 		
						  cs4.setString(2,"text/plain"); 			
						  cs4.registerOutParameter(3, Types.VARCHAR); //  傳回值
						  cs4.registerOutParameter(4, Types.VARCHAR); //  傳回值 	 	 					      						   	 					     
					      cs4.execute();					      
					      getDocument = cs4.getString(3);				
						  getDocumentType = cs4.getString(4);		
					      out.println("getDocument="+getDocument+"</a>");   					    
					      cs4.close();
				// }		  
						  //out.println("getPO_REQ_APPR_MSG="+getFwkBodyURL);		
			   } // End of if		  
			}	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
			*/
    %>
    <tr bgcolor="<%=colorStr%>"> 
	  <td width="4%" height="22" nowrap><div align="center"><font color="#000000"><a href='javaScript:workflowMonitorQuery("<%=getDiagramURL%>")'><img src="../image/docLink.gif" border="0"></a></font></div></td>
      <td bgcolor="#D8DEA9" width="4%" nowrap><div align="center"><font size="2" color="#006666"><a href='javaScript:workflowBodyQuery("<%=rsTC.getString("NOTIFICATION_ID")%>")'><%out.println(rs1__index+1);%></a></font></div></td>
	  <td height="20"><div align="center"><font size="2" color="#000000">
          <input type="checkbox" name="CHKFLAG" value="<%=rsTC.getString("NOTIFICATION_ID")%>">
          </font></div>
	  </td> 
	  <td nowrap><font color="#006666">
	     <%//=rsTC.getString("FROM_USER")
		    //out.println(" envelopURL="+envelopURL);
		    if (rsTC.getString("FROM_USER")==null) { out.println("&nbsp;"); }
			else { out.println(rsTC.getString("FROM_USER")); }
		 %></font></td>     	             
	  <td width="13%" nowrap><div align="left"><font size="2" color="#006666"><%=rsTC.getString("MESSAGE_TYPE")%></font></div></td>
	  <td width="43%" nowrap><div align="left"><font color="#006666">
	          <a href='javaScript:workflowDetailQuery("<%=rsTC.getString("NOTIFICATION_ID")%>")'>
                  <%=rsTC.getString("SUBJECT")%>
			  </a>	  
	      </font></div></td> 
      <td width="11%" nowrap><font size="2" color="#006666">
	     <%   out.println(rsTC.getString("BEGIN_DATE"));	 %></font>
	  </td> 	   	  	                
    </tr>	
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
}
%>
    <tr bgcolor="#D8DEA9"> 
      <td height="23" colspan="7" ><font color="#006666"><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
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
<input name="DATESETBEGIN" type="hidden" value="<%=dateSetBegin%>">
<input name="DATESETEND" type="hidden" value="<%=dateSetEnd%>">

<div align="left"><input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value="Select All">&nbsp;&nbsp;<input name="submit2" type="submit" value="Transfer" onClick='return setSubmit2("../jsp/OracleWorkflowNotifyTransferBatchSubmit.jsp?TRANSNAME=<%=transName%>")'></div>	
<table cellSpacing='0' bordercolordark='#D8DEA9'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
<tr>	    
	<td nowrap colspan="2">
	      <font color="#006666"><strong>轉單據接收人員</strong></font>
	</td>
	 <td nowrap colspan="3">
        <%
		   // REQAPPRV, OEOH , POAPPRV
		   
		         try
                 {   
		           Statement stateTrans=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = "select DISTINCT NAME, NAME||'('||DISPLAY_NAME||')' "+
			                          "from WF_LOCAL_ROLES ";
			//20120510 LILING						  
			 //      String whereOType = "where STATUS ='ACTIVE' and ORIG_SYSTEM='PER' and NOTIFICATION_PREFERENCE='QUERY' ";
			       String whereOType = "where STATUS ='ACTIVE' and ORIG_SYSTEM='PER'  ";					 								  
				   String orderType = "order by NAME ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType + orderType;
				   //out.println(sqlOrgInf);
                   rs=stateTrans.executeQuery(sqlOrgInf);
				   out.println("<select NAME='TRANSNAME' onChange='setSubmit("+'"'+"../jsp/OracleWorkflowNotificationQuery.jsp"+'"'+")'>");				  				  
	               out.println("<OPTION VALUE=-->--");     
	               while (rs.next())
	               {            
		            String s1=(String)rs.getString(1); 
		            String s2=(String)rs.getString(2); 
                    if (s1.equals(transName)) 
  		            {
                       out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
                    } else {
                             out.println("<OPTION VALUE='"+s1+"'>"+s2);
                           }        
	               } //end of while
	               out.println("</select>"); 
		           /*
				     comboBoxBean.setRs(rs);
		             comboBoxBean.setSelection(transName);
	                 comboBoxBean.setFieldName("TRANSNAME");	   
                     out.println(comboBoxBean.getRsString());
				   	*/  		  
		            rs.close();   
					stateTrans.close();   
					  	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		      
		   %> 
		   <input name="NOTIFYTYPE" type="HIDDEN" value="<%="transfer"%>" > 
    </td>  	
  </tr>
  <tr>	    
	   <td nowrap colspan="2">
	      <font color="#006666"><strong>轉單據批次處理說明</strong></font>
	   </td>
	   <td nowrap colspan="4">
         <textarea name="TRANSCOMMENT" cols="100" rows="2"></textarea>
       </td>  	
   </tr>
</table>
 <INPUT TYPE="hidden" NAME="i_1" VALUE="<%=userId%>"> 
  <INPUT TYPE="hidden" NAME="i_2" VALUE="<%=decryptPassword%>"> 
  <INPUT TYPE="hidden" NAME="rmode" VALUE="2"> 
  <INPUT TYPE="hidden" NAME="home_url" VALUE="">
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

