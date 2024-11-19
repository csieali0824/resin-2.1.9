<!-- 20141022 Peggy,Slow Moving庫存保證函下載-->
<!-- 20150114 Peggy,Show Over Lead Time Reason-->
<!-- 20160805 by Peggy,開放樣品rfq給他區查詢-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.Base64" %>
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
    subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custNo+"&NAME="+custName+"&FuncName=D2002","subwin");  
}
//add by Peggy 20111227
function changeEvent()
{
	var docNo = document.MYFORM.DNDOCNOSET.value;
	if (docNo.length >=9)
	{
		var orig_salesarea = document.MYFORM.SALESAREANO.value;
		try
		{
			document.MYFORM.SALESAREANO.value = docNo.substring(2,5);
		}
		catch(err)
		{
			document.MYFORM.SALESAREANO.value = orig_salesarea;
		}
		var year = docNo.substring(5,9);
		try
		{
			document.MYFORM.YEARFR.value = year;
			document.MYFORM.YEARTO.value = year;
		}
		catch(err)
		{
			document.MYFORM.YEARFR.value = "--";
			document.MYFORM.YEARTO.value = "--";
		}
	}
	if (docNo.length >=11)
	{
		var months = docNo.substring(9,11);
		try
		{
			document.MYFORM.MONTHFR.value = months;
			document.MYFORM.MONTHTO.value = months;
		}
		catch(err)
		{
			document.MYFORM.MONTHFR.value = "--";
			document.MYFORM.MONTHTO.value = "--";
		}
	}
	if (docNo.length >=13)
	{
		var day = docNo.substring(11,13);
		try
		{
			document.MYFORM.DAYFR.value = day;
			document.MYFORM.DAYTO.value = day;
		}
		catch(err)
		{
			document.MYFORM.DAYFR.value = "--";
			document.MYFORM.DAYTO.value = "--";
		}
	}	
	return;
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
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
.style1 {
	color: #CC0033;
	font-size: 14px;
	font-weight: bold;
}
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
int CASECOUNT=0;
float CASECOUNTPCT=0;
String sCSCountPCT="";
int idxCSCount=0;
float CASECOUNTORG=0;
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
if (dateSetBegin==null)
{
	//dateSetBegin=YearFr+MonthFr+DayFr;  
	if (YearFr==null || YearFr.equals("--") || YearFr.equals("null")){dateSetBegin=dateBean.getYearString();}else{dateSetBegin=""+YearFr;}
	if (MonthFr==null || MonthFr.equals("--") || MonthFr.equals("null")){dateSetBegin=dateSetBegin+dateBean.getMonthString();}else{dateSetBegin=dateSetBegin+MonthFr;}
	if (DayFr==null || DayFr.equals("--") || DayFr.equals("null")){dateSetBegin=dateSetBegin+dateBean.getDayString();}else{dateSetBegin=dateSetBegin+DayFr;}
}
String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
if (dateSetEnd==null)
{
	//dateSetEnd=YearTo+MonthTo+DayTo; 
	if (YearTo==null || YearTo.equals("--")){dateSetEnd=dateBean.getYearString();}else{dateSetEnd=YearTo;}
	if (MonthTo==null || MonthTo.equals("--")){dateSetEnd=dateSetEnd+dateBean.getMonthString();}else{dateSetEnd=dateSetEnd+MonthTo;}
	if (DayTo==null || DayTo.equals("--")) {dateSetEnd=dateSetEnd+dateBean.getDayString();}else{dateSetEnd=dateSetEnd+DayTo;}
}
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
String prodManufactory=request.getParameter("PRODMANUFACTORY");
String status=request.getParameter("STATUS");
String statusCode=request.getParameter("STATUSCODE"); 
String listMode=request.getParameter("LISTMODE");  
String rfqType=request.getParameter("RFQTYPE");  //add by Peggy 20130710
if (rfqType==null) rfqType="";      
String tscItem=request.getParameter("TSCITEM");   //add by Peggy 20130710
if (tscItem==null) tscItem="";
String CUSTOMERAROVERDUE = request.getParameter("CUSTOMERAROVERDUE");
if (CUSTOMERAROVERDUE==null) CUSTOMERAROVERDUE=""; //add by Peggy 20140314
String sqlGlobal = "";
String sWhereGlobal = "";
  
if (dnDocNo==null || dnDocNo.equals("")) dnDocNo=""; //選擇展開的
if (dnDocNoSet==null || dnDocNoSet.equals("")) dnDocNoSet=""; // 使用者輸入的
if (customerId==null || customerId.equals("")) customerId="";
if (customerNo==null || customerNo.equals("")) customerNo="";
if (customerName==null || customerName.equals("")) customerName="";
if (custPONo==null || custPONo.equals("")) custPONo="";
if (createdBy==null || createdBy.equals("")) createdBy="";
if (salesPerson==null || salesPerson.equals("")) salesPerson="";
if (salesOrderNo==null || salesOrderNo.equals("")) salesOrderNo="";

if (statusCode==null || statusCode.equals("")) statusCode="";  
if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
if (spanning==null || spanning.equals("")) spanning = "TRUE";
if (listMode==null) listMode = "TRUE";
int iDetailRowCount = 0;

// 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
String clientID = "";
if (organizationId=="46" || organizationId.equals("46"))
{  
	clientID = "42"; 
}
else 
{ 
	clientID = "41"; 
}
  
CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機 */
cs1.execute();
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
<FORM ACTION="../jsp/TSCInvORGSubInventoryNBQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgSalesDRQ"/><jsp:getProperty name="rPH" property="pgQuery"/></strong></font>
<BR>
  <A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
sWhereGP = " and c.DNDOCNO IS NOT NULL ";
  
workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
String currentWeek = workingDateBean.getWeekString();

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

try
{
if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")))
{
	sSql = "select DISTINCT c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+
		  "       b.SALES_AREA_NAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
		  "       c.CREATED_BY, c.SALESPERSON, c.REQREASON, count(DISTINCT  d.line_no) as MAXLINE, f.SDRQCOUNT "+
		  "       ,c.RFQ_TYPE"+ 
		  //"        ,decode(c.RFQ_TYPE,'1','Normal','2','Forecast','3','EDI','4','TSCE HUB PO',c.RFQ_TYPE) RFQ_TYPE"+   //add by Peggy 20130710
		  "        ,y.a_value rfq_type_name"+ //add by Peggy 202111119
		  "        ,TO_CHAR(TO_DATE(c.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') CREATION_DATE "+ //add by Peggy 20201204
		  "  from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE c, "+
		  "       ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e, "+
		  " 	  (select d1.DNDOCNO, sum(decode(d1.SDRQ_EXCEED,'Y',1,0)) as SDRQCOUNT "+ //計算四日過期Line的筆數
          "          from ORADDMAN.TSDELIVERY_NOTICE_DETAIL d1 "+
          "         group by d1.DNDOCNO ) f "+
		  "       ,(SELECT a_seq,a_value  FROM oraddman.tsc_rfq_setup  WHERE A_CODE='RFQ_TYPE') y";
   	sSqlCNT = "select count(DISTINCT c.DNDOCNO) as CaseCount "+
             "  from ORADDMAN.TSSALES_AREA b, "+
		     "       ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e "+
		  "       ,(SELECT a_seq,a_value  FROM oraddman.tsc_rfq_setup  WHERE A_CODE='RFQ_TYPE') y";
   	sWhere =  "where c.DNDOCNO = d.DNDOCNO "+
			 "  and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
			 "  and b.LOCALE='"+locale+"' "+
			 "  and b.SALES_AREA_NO=c.TSAREANO "+
			 "  and c.rfq_type=y.a_seq(+) ";	
   	sWhereSDRQ = "  and f.DNDOCNO = d.DNDOCNO ";
   	havingGrp = "group by c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+         
		                "b.SALES_AREA_NAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
			            "c.CREATED_BY, c.SALESPERSON, c.REQREASON,c.RFQ_TYPE,y.a_value,c.CREATION_DATE "; //RFQ_TYPE add by Peggy 20120723               
   	havingGrpSDRQ = " ,f.SDRQCOUNT ";
   	sOrder = "order by c.DNDOCNO";
   
   	SWHERECOND = sWhere + sWhereGP + havingGrp;
   	sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
   	sSqlCNT = sSqlCNT + sWhere + sWhereGP;   
   
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
			 	// 取小數1位
				sCSCountPCT = Float.toString(CaseCountPCT);
				idxCSCount = sCSCountPCT.indexOf('.');
				sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
		   	}
		   	else
		   	{
		    	CaseCountPCT = 0;
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
	sSql = "select DISTINCT c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+
		  "       b.SALES_AREA_NAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
		  "       c.CREATED_BY, c.SALESPERSON, c.REQREASON, count(DISTINCT d.line_no) as MAXLINE, f.SDRQCOUNT "+
		  "       ,c.RFQ_TYPE"+ //RFQ_TYPE add by Peggy 20120723    
		  //"        ,decode(c.RFQ_TYPE,'1','Normal','2','Forecast','3','EDI','4','TSCE HUB PO',c.RFQ_TYPE) RFQ_TYPE"+   //add by Peggy 20130710
		  "        ,TO_CHAR(TO_DATE(c.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') CREATION_DATE"+ //add by Peggy 20201204
		  "        ,y.a_value rfq_type_name"+ //add by Peggy 202111119
		  "  from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE c, "+
		  "       ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e, "+
		  " 	  (select d1.DNDOCNO, sum(decode(d1.SDRQ_EXCEED,'Y',1,0)) as SDRQCOUNT "+ //計算四日過期Line的筆數
          "          from ORADDMAN.TSDELIVERY_NOTICE_DETAIL d1 "+
          "         group by d1.DNDOCNO ) f "+
		  "       ,(SELECT a_seq,a_value  FROM oraddman.tsc_rfq_setup  WHERE A_CODE='RFQ_TYPE') y";
   	sSqlCNT = " select count(DISTINCT c.DNDOCNO) as CaseCount "+
                  "from ORADDMAN.TSSALES_AREA b, "+
		          "ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e "+
		  "       ,(SELECT a_seq,a_value  FROM oraddman.tsc_rfq_setup  WHERE A_CODE='RFQ_TYPE') y";
   	sWhere =  " where c.DNDOCNO = d.DNDOCNO "+
			 "  and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
			 "  and b.LOCALE='"+locale+"' "+
			 "  and b.SALES_AREA_NO=c.TSAREANO "+
			 "  and c.rfq_type=y.a_seq(+) ";	
   	sWhereSDRQ = "  and f.DNDOCNO = d.DNDOCNO ";
			
   	havingGrp = " group by c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+         
		       "          b.SALES_AREA_NAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
			   "          c.CREATED_BY, c.SALESPERSON, c.REQREASON ,c.rfq_type,y.a_value,c.CREATION_DATE"; //RFQ_TYPE add by Peggy 20130710      
   	havingGrpSDRQ = " ,f.SDRQCOUNT ";  
   	sOrder = "order by c.DNDOCNO";				 
	if (dnDocNoSet==null || dnDocNoSet.equals("")) 
	{ 
		if (prodManufactory!=null && !prodManufactory.equals("--") &&  !prodManufactory.equals("")) 
		{
			sWhere+=" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; 
		}
	  
		if (status!=null && !status.equals("--"))  
		{
			sWhere+=" and d.LSTATUSID ='"+status+"'"; 
		}
	   
		if (statusCode.equals("O")) 
		{ 
			sWhere+=" and d.LSTATUSID in ('001','002','003','004','007','008','009','013') ";  
		} 
		else if (statusCode.equals("C")) 
		{ 
			sWhere+=" and d.LSTATUSID in ('010') ";  
		} // 只找已結案的單據
		else if (statusCode.equals("A")) 
		{ 
			sWhere+=" and d.LSTATUSID in ('012') ";  
		} // 只找放棄的單據
	
		if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere+=" and substr(c.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
		if (DayFr!="--" && DayTo!="--") sWhere+=" and substr(c.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"
											   +" AND substr(c.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'";  
		  
		if (customerId!=null && !customerId.equals("") && customerNo!=null && !customerNo.equals("") && customerName!=null & !customerName.equals(""))  //modify by Peggy 20160805
		{ 
			sWhere+=" and c.TSCUSTOMERID ='"+customerId+"'"; 
		}
		else if (salesAreaNo!=null && !salesAreaNo.equals("--")) 
		{ 
			sWhere+=" and c.TSAREANO ='"+salesAreaNo+"'";	
		}
	  
		if (preOrderType!=null && !preOrderType.equals("--")) 
		{
			sWhere+=" and to_char(c.ORDER_TYPE_ID) ='"+preOrderType+"'"; 
		}
		
		if (custPONo!=null && !custPONo.equals("")) 
		{ 
			//sWhere+=" and c.CUST_PO ='"+custPONo+"'"; 
			sWhere += " and '"+custPONo+"' in (d.CUST_PO_NUMBER,c.CUST_PO)";  //add by Peggy 20221228
		}
		
		if (salesPerson!=null && !salesPerson.equals("")) 
		{ 
			sWhere+=" and SALESPERSON ='"+salesPerson+"'"; 
		}
		
		if (prodManufactory!=null && !prodManufactory.equals("--") && !prodManufactory.equals("")) 
		{ 
			sWhere+=" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; 
		}
		
		if (status!=null && !status.equals("--")) 
		{ 
			sWhere+=" and d.LSTATUSID ='"+status+"'"; 
		}
		
		if (salesOrderNo!=null && !salesOrderNo.equals("")) 
		{  
			sWhere+=" and d.ORDERNO = '"+salesOrderNo+"' ";  
		}
	
		if (createdBy!=null && !createdBy.equals("")) 
		{ 
			sWhere+=" and c.CREATED_BY ='"+createdBy+"'"; 
		} 
		
		//add by Peggy 20130710
		if (!rfqType.equals("") && !rfqType.equals("--"))
		{
			sWhere += " and c.RFQ_TYPE='"+ rfqType+"'";
		}
		
		//add by Peggy 20130710
		if (!tscItem.equals(""))
		{
			sWhere += " and d.ITEM_DESCRIPTION like '"+tscItem+"%'";
		}
		
	}
	else if (dnDocNoSet!=null && !dnDocNoSet.equals("")) 
	{ 
		sWhere+=" and c.dnDocNo ='"+dnDocNoSet+"'"; 
	}

	//權限檢查,add by Peggy 20190402
	if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("SMCUser")<0 && !UserName.equals("JUDY_CHO")  && !UserName.equals("PERRY.JUAN"))
	{
		//sWhere+=" and (exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=b.SALES_AREA_NO)  or  b.SALES_AREA_NO='020')";   //其他區也需要看樣本區交期,add by Peggy 20190426
		sWhere+=" AND b.SALES_AREA_NO IN ( SELECT  DISTINCT x.tssaleareano from oraddman.tsrecperson x where (x.USERNAME='"+UserName+"' or x.tssaleareano='020'))";
	}
	else if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0)
	{
		sWhere+=" and exists (select 1 from oraddman.tsprod_person x where x.USERNAME='"+UserName+"' and x.PROD_FACNO=d.ASSIGN_MANUFACT)";
	}
  	
	SWHERECOND = sWhere+ sWhereGP;
  	sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
	//out.println(sSql);
  	sSqlCNT = sSqlCNT + sWhere + sWhereGP;
   	String sqlOrgCnt = "select count(DISTINCT c.DNDOCNO) as CaseCountORG "+
                        " from ORADDMAN.TSSALES_AREA b, "+
		                     "ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e "+
		               "       ,(SELECT a_seq,a_value  FROM oraddman.tsc_rfq_setup  WHERE A_CODE='RFQ_TYPE') y";
							 
   	sqlOrgCnt = sqlOrgCnt + sWhere + sWhereGP + havingGrp;
   	Statement statement2=con.createStatement();
	//out.println(sqlOrgCnt);
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
		//out.println(sSqlCNT);
        ResultSet rs3=statement3.executeQuery(sSqlCNT);
		if (rs3.next())
		{
			CaseCount = rs3.getInt("CaseCount");
		   	if (CaseCountORG!=0)
		   	{
		    	CaseCountPCT = (float)(CaseCount/CaseCountORG)*100;
			 	// 取小數1位
				sCSCountPCT = Float.toString(CaseCountPCT);
				idxCSCount = sCSCountPCT.indexOf('.');
				sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
		   	}
		   	else
		   	{
		    	CaseCountPCT = 0;
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
}
catch(Exception e)
{
	out.println(e.getMessage());
}
// 準備予維修方式使用的Statement Con //
sqlGlobal = sSql;
//out.println(sSql);
Statement statementTC=con.createStatement(); 
//out.println(sSql);
ResultSet rsTC=statementTC.executeQuery(sSql);
boolean rs_isEmptyTC = !rsTC.next();
boolean rs_hasDataTC = !rs_isEmptyTC;
Object rs_dataTC;  

// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables
int rs_first = 1;
int rs_last  = 1;
int rs_total = -1;

if (rs_isEmptyTC) 
{
	rs_total = rs_first = rs_last = 0;
}

//set the number of rows displayed on this page
if (rs_numRows == 0) 
{
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
if (!MM_paramIsDefined && MM_rsCount != 0) 
{
	//use index parameter if defined, otherwise use offset parameter
  	String r = request.getParameter("index");
  	if (r==null) r = request.getParameter("offset");
  	if (r!=null) MM_offset = Integer.parseInt(r);

  	// if we have a record count, check if we are past the end of the recordset
  	if (MM_rsCount != -1) 
	{
    	if (MM_offset >= MM_rsCount || MM_offset == -1) 
		{  // past end or move last
      		if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
        		MM_offset = MM_rsCount - MM_rsCount % MM_size;
      		else
        		MM_offset = MM_rsCount - MM_size;
    	}
  	}

  	//move the cursor to the selected record
  	int i;
  	for (i=0; rs_hasDataTC && (i < MM_offset || MM_offset == -1); i++) 
	{
    	rs_hasDataTC = MM_rs.next();
  	}
  	if (!rs_hasDataTC) MM_offset = i;  // set MM_offset to the last possible record
}

// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) 
{
	// walk to the end of the display range for this page
  	int i;
  	for (i=MM_offset; rs_hasDataTC && (MM_size < 0 || i < MM_offset + MM_size); i++) 
	{
    	rs_hasDataTC = MM_rs.next();
  	}

  	// if we walked off the end of the recordset, set MM_rsCount and MM_size
  	if (!rs_hasDataTC) 
	{
    	MM_rsCount = i;
    	if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  	}

  	// if we walked off the end, set the offset based on page size
  	if (!rs_hasDataTC && !MM_paramIsDefined) 
	{
    	if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) 
		{ //check if past end or last
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
  	for (i=0; rs_hasDataTC && i < MM_offset; i++) 
	{
    	rs_hasDataTC = MM_rs.next();
  	}
}

// *** Move To Record: update recordset stats
// set the first and last displayed record
rs_first = MM_offset + 1;
rs_last  = MM_offset + MM_size;
if (MM_rsCount != -1) 
{
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
if (request.getQueryString() != null) 
{
	MM_keepURL = '&' + request.getQueryString();
  	for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) 
	{
  		int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
    	if (start >= 0 && MM_keepURL.charAt(start) == '&' && MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') 
		{
      		int stop = MM_keepURL.indexOf('&', start + 1);
      		if (stop == -1) stop = MM_keepURL.length();
      		MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
    	}
  	}
}

// add the Form variables to the MM_keepForm string
if (request.getParameterNames().hasMoreElements()) 
{
	java.util.Enumeration items = request.getParameterNames();
  	while (items.hasMoreElements()) 
	{
    	String nextItem = (String)items.nextElement();
    	boolean found = false;
    	for (int i=0; !found && i < MM_removeList.length; i++) 
		{
      		if (MM_removeList[i].equals(nextItem)) found = true;
    	}
    	if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) 
		{
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
  	if (MM_size > 1)
	{
    	MM_moveParam = "offset=";
    	int start = MM_keepMove.indexOf(MM_moveParam);
    	if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) 
		{
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
  <table cellSpacing='1' cellPadding='0' width='100%' align='center'  border="1" style="border-color:#CCCCCC;border:thin">
     <tr>
	    <td width="15%" colspan="1" nowrap>
		<font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgSalesArea"/></strong></font></td> 
		<td width="40%">
<%		 
	try
    {   
		Statement statement=con.createStatement();
        ResultSet rs=null;	
		String sql = "select distinct SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA ";
		sWhere = "where SALES_AREA_NO > 0 ";
		//if (UserRoles=="admin" || UserRoles.equals("admin") || UserRoles=="audit" || UserRoles.equals("audit")) 
		if (UserRoles.equals("admin") || UserRoles.equals("audit") || UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) 
		{ 
			// 若為管理員,可開立任何一區詢問單
		}  
		else 
		{  
			//sWhere = sWhere + "and SALES_AREA_NO='"+userActCenterNo+"' ";
			//modify by Peggy 20110628
			//sWhere += " and SALES_AREA_NO in (select tssaleareano from oraddman.tsrecperson "+
			//          " where (USERID='"+UserName+"' or USERNAME='"+UserName+"'))";
			sWhere += " and (SALES_AREA_NO in (select tssaleareano from oraddman.tsrecperson "+
			          " where (USERID='"+UserName+"' or USERNAME='"+UserName+"')) or SALES_AREA_NO='020')"; //其他區也需要看樣本區交期,add by Peggy 20190426
		}  // 否則,就只能開立所屬區域單
		sWhere += " ORDER BY SALES_AREA_NO";
		sql = sql + sWhere;
		//out.println(sql);
        rs=statement.executeQuery(sql);		           
		comboBoxAllBean.setRs(rs);
		if (salesAreaNo==null)
		{ 
			comboBoxAllBean.setSelection(userActCenterNo); 
		}
		else 
		{ 
			comboBoxAllBean.setSelection(salesAreaNo); 
		}
	    comboBoxAllBean.setFieldName("SALESAREANO");	   
        out.println(comboBoxAllBean.getRsString());
		rs.close();   
		statement.close(); 
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }		   
%>		</td>
		<td width="15%">
		   <font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgPreOrderType"/> </strong></font>		</td>   
		<td width="30%" colspan="1" nowrap><div align="left">   
<%
	try
    {   
		Statement statement=con.createStatement();
        ResultSet rs=null;	
		String sqlOrgInf = "select DISTINCT  OTYPE_ID, ORDER_NUM||'('||DESCRIPTION||')' as TRANSACTION_TYPE_CODE "+
		" from ORADDMAN.TSAREA_ORDERCLS "+
		//"where SAREA_NO = '"+userActCenterNo+"' and ACTIVE ='Y'  "+	
		//modify by Peggy 20110628							  
		" where  ACTIVE ='Y'  "+
		" and  SAREA_NO in (select tssaleareano from oraddman.tsrecperson "+
		" where (USERID='"+UserName+"' or USERNAME='"+UserName+"'))"+
		"order by 2 ";  
			  
        rs=statement.executeQuery(sqlOrgInf);
		comboBoxAllBean.setRs(rs);
		comboBoxAllBean.setSelection(preOrderType);
	    comboBoxAllBean.setFieldName("PREORDERTYPE");	   
        out.println(comboBoxAllBean.getRsString());
				   	  		  
		rs.close();   
		statement.close();     	 
    } //end of try		 
    catch (Exception e) 
	{ 
		out.println("Exception:"+e.getMessage()); 
	} 
 %>
		   </div>		</td>    
	 </tr>
	 <tr>
	   <td><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgQDocNo"/> </strong></font></td>
	   <td><input type="text" name="DNDOCNOSET" value="<%=dnDocNoSet%>"   onKeyUp="changeEvent()"></td>
	   <td>
		   <div align="left">
		   <font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgCreateFormUser"/> </strong></font>		   </div>	   </td>
	   <td>	   
		   <input type="text" name="CREATEDBY" size="15" value="<%=createdBy%>">	   </td> 
	 </tr>
	 <tr>
	    <td nowrap colspan="1"><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgCustPONo"/> </strong></font>        </td> 
		<td>
		   <div align="left">
		   <font color="#006666" ><strong> </strong></font><input type="text" name="CUSTPONO" value="<%=custPONo%>">
		   </div>		</td> 
		<td>
		   <div align="left">
		   <font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgSalesMan"/> </strong></font>		   </div>		</td>
		<td>   
		   <input type="text" name="SALESPERSON" size="15" value="<%=salesPerson%>">		</td>   
	 </tr>
	 <tr>
	    <td nowrap colspan="1"><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgProdFactory"/> </strong></font>        </td> 
		<td>
		   <div align="left">
		   <font color="#006666" ><strong> </strong></font>
		   <%
		       try
               { // 動態去取生產地資訊 						  
	               Statement stateGetP=con.createStatement();
                   ResultSet rsGetP=null;				      									  
				   String sqlGetP = "select MANUFACTORY_NO, MANUFACTORY_NAME as PRODMANUFACTORY "+
			                        "from ORADDMAN.TSPROD_MANUFACTORY "+
			                        "where MANUFACTORY_NO > 0 "+																  
								     "order by MANUFACTORY_NO "; 		  
                   rsGetP=stateGetP.executeQuery(sqlGetP);
				   comboBoxAllBean.setRs(rsGetP);
		           comboBoxAllBean.setSelection(prodManufactory);
	               comboBoxAllBean.setFieldName("PRODMANUFACTORY");					     
                   out.println(comboBoxAllBean.getRsString());				
					           
				    stateGetP.close();		  		  
		            rsGetP.close();
	            } //end of try		 
                catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		   %>
		   </div>		</td> 
		<td>
		   <div align="left">
		   <font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgRepStatus"/> </strong></font>		   </div>		</td>
		<td>   
		   <%
		       try
               { // 動態去取生產地資訊 						  
	               Statement stateGetP=con.createStatement();
                   ResultSet rsGetP=null;				      									  
				   String sqlGetP = "select UNIQUE STATUSID, STATUSNAME||'-'||STATUSDESC as STATUS "+
			                        "from ORADDMAN.TSWFSTATUS a, ORADDMAN.TSWORKFLOW b  "+
			                        "where a.STATUSID = b.FROMSTATUSID and b.FORMID = 'TS' and a.STATUSID not in ('006','002','007') "+																  
								     "order by a.STATUSID "; 		  
                   rsGetP=stateGetP.executeQuery(sqlGetP);
				   comboBoxAllBean.setRs(rsGetP);
		           comboBoxAllBean.setSelection(status);
	               comboBoxAllBean.setFieldName("STATUS");					     
                   out.println(comboBoxAllBean.getRsString());				
					           
				    stateGetP.close();		  		  
		            rsGetP.close();
	            } //end of try		 
                catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		   %>		</td>   
	 </tr>
	 <tr>
	   <td><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgCustomerName"/></strong></font></td>
	   <td>
	        <input type="text" size="10" name="CUSTOMERNO" onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)' value="<%=customerNo%>">
	        <INPUT TYPE="button"  value="..." onClick='setCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)'>
			<input type="text" size="50" name="CUSTOMERNAME" onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)' value="<%=customerName%>">	   </td>
	   <td><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgRFQType"/></strong></font></td>
	   <td>
	   <!--<select name="RFQTYPE" style="font-size:12;font-family:arial">
									<option value="--" <%if (rfqType.equals("")) out.println("selected");%>>ALL
									<option value="1" <%if (rfqType.equals("1")) out.println("selected");%>>Normal
									<option value="2" <%if (rfqType.equals("2")) out.println("selected");%>>Forecast
									<option value="3" <%if (rfqType.equals("3")) out.println("selected");%>>EDI
									<option value="4" <%if (rfqType.equals("4")) out.println("selected");%>>TSCE HUB PO
									<option value="5" <%if (rfqType.equals("5")) out.println("selected");%>>CRM
									</select>-->
		<%
		try
		{   
			Statement statement1=con.createStatement();
			String sql = " SELECT a_seq,a_value  FROM oraddman.tsc_rfq_setup  WHERE A_CODE='RFQ_TYPE'"; 
			ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='RFQTYPE' style='font-size:12;font-family:arial'>");
			out.println("<OPTION VALUE=-->ALL");     
			while (rs1.next())
			{            
				out.println("<OPTION VALUE='"+rs1.getString(1)+"' "+(rfqType.equals(rs1.getString(1))?" SELECTED":"")+">"+rs1.getString(2));					   
			} 
			out.println("</select>"); 
			statement1.close();		  		  
			rs1.close();        	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception1:"+e.getMessage()); 
		} 		
		%>
		</td>
	 </tr>
	 <tr>
	   <td><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgSalesOrderNo"/></strong></font></td>
	   <td><input type="text" size="10" name="SALESORDERNO" value="<%=salesOrderNo%>"></td>
	   <td><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgItemDesc"/></strong></font></td>
	   <td><input type="text" size="30" name="TSCITEM" value="<%=tscItem%>"></td>
	 </tr>
     <tr>	    
	   <td nowrap colspan="2"><font color="#006666" ><strong>
	     <jsp:getProperty name="rPH" property="pgCreateFormDate"/>         
	   </strong></font>
	     <%
		 /*
		  String CurrYear = null;	     		 
	     try
         {       
          String a[]={"2006","2007","2008","2009","2010","2011","2012","2013"};
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
		 */
		//modify by Peggy 20140102
		try
		{     
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2010+1];
			for (int i = 2010; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
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
        <font color="#CC3366"  face="Arial Black">&nbsp;</font>
        <font color="#CC3366"  face="Arial Black">&nbsp;</font>
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
       <font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgCreateFormDate"/></strong></font>
        <%
		  /*
		  String CurrYearTo = null;	     		 
	     try
         {       
          String a[]={"2006","2007","2008","2009","2010","2011","2012","2013"};
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
		 */
		try
		{       
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2010+1];
			for (int i = 2010; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
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
       %>    </td>  
	<td colspan="2">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSSDRQInformationQuery.jsp")' > 
			<INPUT TYPE="button" align="middle" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' onClick='setSubmit("../jsp/TSSalesDRQAssignInf2Excel.jsp")' >	</td>
   </tr>
  </table>  
<%
 }  // End of if (listMode==null || listMode,equals("TRUE")) 
 
%>
  <table width="100%" border="1" cellpadding="1" cellspacing="1" bordercolorlight="#999999" bordercolordark="#FFFFFF" bordercolor="#99CC99">
    <tr bgcolor="#99CC99"> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#000000" >&nbsp;</font></div></td> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#006666" ><jsp:getProperty name="rPH" property="pgProductDetail"/></font></div></td>               
	  <%
	  if (userPlanCenterNo!=null && !userPlanCenterNo.equals(""))
	  {
	     out.println("<td width='2%' height='22' nowrap><div align='center'><font color='#006666'>");
	  %>	 
		 <jsp:getProperty name="rPH" property="pgApproval"/><jsp:getProperty name="rPH" property="pgOrdCreate"/>
	  <% 
	  	 out.println("</font></div></td>");              
      } // End of if
      %>
	  <td width="9%" nowrap><div align="center"><font color="#006666" ><jsp:getProperty name="rPH" property="pgQDocNo"/></font></div></td>
	  <td width="6%" nowrap><div align="center"><font color="#006666" ><jsp:getProperty name="rPH" property="pgCType"/></font></div></td>
      <td width="20%" nowrap><div align="center"><font color="#006666" ><jsp:getProperty name="rPH" property="pgDetail"/></font></div></td>            
      <td width="10%" nowrap><div align="center"><font color="#006666" ><jsp:getProperty name="rPH" property="pgSalesMan"/></font></div></td> 
	  <td width="12%" nowrap><div align="center"><font color="#006666" ><jsp:getProperty name="rPH" property="pgCreateFormDate"/></font></div></td>                    
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "CCFFCC";
	     }
	    else{
	       colorStr = "CCFFFF"; }
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#99CC99" width="2%"><div align="center"><font  color="#006666"><a name='#<%=rsTC.getString("DNDOCNO")%>'><%out.println(rs1__index+1);%></a></font></div></td>
	  <td><div align="center"><a href="../jsp/TSSalesDRQHistoryDetail.jsp?DNDOCNO=<%=rsTC.getString("DNDOCNO")%>&DATEBEGIN=<%=dateSetBegin%>&DATEEND=<%=dateSetEnd%>"><img src="../image/docicon.gif" width="14" height="15" border="0"></a></div></td>     	        
      <%
	  try
	  {
  	  	if (userPlanCenterNo!=null && !userPlanCenterNo.equals(""))
	  	{
	  
			 out.println("<td><div align='center'>");
			 //out.println(rsTC.getString("SDRQCOUNT"));
			 if (rsTC.getString("SDRQCOUNT") != "0" && !rsTC.getString("SDRQCOUNT").equals("0") ) {
				out.println("<a href='../jsp/TSRFQRegenerateDocumentSetActive.jsp?DNDOCNO="+rsTC.getString("DNDOCNO")+"'>");
				out.println("<img src='../image/YES.gif' width='14' height='15' border='0'></a>");
			 } 
			 else
			 { 
				out.println("<a>&nbsp;</a>");
			 }
			 out.println("</div></td>");
		  }
	  } //end of try
      catch (Exception e)
      {
      	out.println("Exception:"+e.getMessage());
      }	  
	  %>
	  <td width="9%" nowrap><font  color="#006666"><a href="..\jsp\TSSDRQDetailInfo.jsp?DNDOCNO=<%=rsTC.getString("DNDOCNO")%>"><%=rsTC.getString("DNDOCNO")%></a></font></td>
	  <td width="5%" nowrap>
	  <%
	  	if (rsTC.getString("RFQ_TYPE_NAME") ==null)
		{
			out.println("<font  color='#006666'>");
		}
		else if (rsTC.getString("RFQ_TYPE_NAME").equals("Forecast"))
		{
			out.println("<font color='#F859A1'>");
		}
		else if (rsTC.getString("RFQ_TYPE_NAME").equals("Normal"))
		{
			out.println("<font color='blue'>");
		}
		else if (rsTC.getString("RFQ_TYPE_NAME").equals("EDI"))
		{
			out.println("<font color='purple'>");
		}

		out.println("&nbsp;"+(rsTC.getString("RFQ_TYPE_NAME")==null?"&nbsp;":rsTC.getString("RFQ_TYPE_NAME"))+"&nbsp;</font>");
	  %>
	  </td>
      <td width="48%" nowrap><font  color="#006666">
	          <%  // out.println(rsTC.getString("SEGMENT1"));
			    iDetailRowCount = iDetailRowCount + rsTC.getInt("MAXLINE"); // 累加明細數量
			  //out.println("wipEntID="+wipEntID);out.println("rsTC.getString(INVENTORY_ITEM_ID)="+rsTC.getString("INVENTORY_ITEM_ID"));
			       String subColStr = "";
			       if ((rs1__index % 2) == 0)
				   { subColStr = "CCFFFF"; }
	               else{ subColStr = "CCFFCC"; }			    
			       out.println("<table cellSpacing='0' bordercolordark='#99CC99'  cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='1' bordercolor='#99CC99'>");			 
			       if (spanning=="FALSE" || spanning.equals("FALSE")  )
			       { 
			          out.print("<tr><td nowrap>"); 
					  out.println("<font color='#006666'>");
					  %><jsp:getProperty name="rPH" property="pgTotal"/><%
					  out.println(rsTC.getString("MAXLINE"));
					  %><jsp:getProperty name="rPH" property="pgItemQty"/><%
					  out.println("</font>"); %><a href="../jsp/TSSDRQInformationQuery.jsp?SPANNING=TRUE&DNDOCNO=<%=rsTC.getString("DNDOCNO")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>#<%=rsTC.getString("DNDOCNO")%>"><img src="../image/PLUS.gif" width="14" height="15" border="0"></a>
					  <% 
					    out.println("<font color='#006666'>");
					  %><jsp:getProperty name="rPH" property="pgCreateFormUser"/><%
					    out.println(" : "+rsTC.getString("CREATED_BY"));					           
					    out.println("</font>"); 
					  out.println("</td></tr>");
			       } else if ( spanning==null || spanning.equals("") ||  spanning=="TRUE" || spanning.equals("TRUE") )
			              {			    
				             //再判段若是 Entity ID 才顯示明細,點擊符號顯示 MINUS 
				            // if ( dnDocNo ==rsTC.getString("DNDOCNO") || dnDocNo.equals(rsTC.getString("DNDOCNO")) )
				             //{ //out.println("wipEntID="+wipEntID);out.println("rsTC.getString(INVENTORY_ITEM_ID)="+rsTC.getString("INVENTORY_ITEM_ID"));
				               out.print("<tr>");
							   
							   out.println("<td colspan=12>"); 							   
					           out.println("<font color='#006666'>");
							   %><jsp:getProperty name="rPH" property="pgCustomerName"/><%
							   out.println(" : "+rsTC.getString("CUSTOMER")+"&nbsp;&nbsp;&nbsp;");
					           %><jsp:getProperty name="rPH" property="pgTotal"/><%
					           out.println(rsTC.getString("MAXLINE"));
					           %><jsp:getProperty name="rPH" property="pgItemQty"/><%
					           out.println("</font>"); 
							   %><a href="../jsp/TSSDRQInformationQuery.jsp?SPANNING=FALSE&DNDOCNO=<%=rsTC.getString("DNDOCNO")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>#<%=rsTC.getString("DNDOCNO")%>"><img src="../image/MINUS.gif" width="14" height="15" border="0"></a>
							   <% 
							     out.println("<font color='#006666'>");
					           %><jsp:getProperty name="rPH" property="pgCreateFormUser"/><%
					             out.println(" : "+rsTC.getString("CREATED_BY"));					           
					             out.println("</font></td>");
							   
							   //
							   
							   
							   out.println("</tr>");
							   
							   
							   
				               int iRow = 0; 	
							   
				               String sqlM = "select DISTINCT d.LINE_NO,d.LSTATUS,d.ITEM_DESCRIPTION, d.QUANTITY,d.UOM, "+
                                                   // "DECODE(d.REQUEST_DATE,'N/A','N/A',TO_CHAR(TO_DATE(d.REQUEST_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD')),"+
													"DECODE(d.REQUEST_DATE,'N/A','N/A',substr(d.REQUEST_DATE,0,8)),"+
											        "d.PCCFMDATE,d.FTACPDATE, d.PCACPDATE, d.SASCODATE, d.ORDERNO, d.SHIP_DATE , d.LSTATUSID,"+
                                                    "e.MANUFACTORY_NAME,d.REMARK , d.EDIT_CODE "+
													",f.pc_remark "+ //add by Peggy 20111122
													",d.REASON_CODE"+ //add by Peggy 20130410
													",nvl(d.PC_OVER_LEADTIME_REASON,'') PC_OVER_LEADTIME_REASON"+ //add by Peggy 20150114
													",tsc_om_category(d.inventory_item_id,49,'TSC_Package') tsc_package"+  //add by Peggy 20170920
													",d.supply_source"+  //add by Peggy 20200110
										            " from ORADDMAN.TSSALES_AREA b, "+
										          "ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e,"+
												  //"(select dndocno,line_no,pc_remark,rownumber() over from oraddman.tsdelivery_detail_history "+
												  //" where pc_remark IS NOT NULL  AND oristatusid = '003' AND actionid = '008') f ";
												  //",ORADDMAN.TSDELIVERY_DETAIL_HISTORY f ";	
                                                  " (SELECT  dndocno,line_no,pc_remark FROM (select dndocno,line_no,pc_remark,row_number() over (PARTITION BY dndocno,line_no ORDER BY CDATETIME DESC) ROWSEQ from oraddman.tsdelivery_detail_history  "+
                                                  " where pc_remark IS NOT NULL  AND oristatusid in ('003','004')) WHERE ROWSEQ=1) f "; //modify by Peggy 20131223
							  String whereM = " where (d.DNDOCNO = '"+rsTC.getString("DNDOCNO")+"' ) "+
							                  //"and d.LINE_NO = f.LINE_NO "+
											  "and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
										        // "or  d.DOCNO || '-' || d.ASSIGN_LNO in ("+distDnDocNo+") ) "+
										      "and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='"+locale+"' "+
						                      "and d.dndocno = f.dndocno(+) " +  //add by Peggy 20111122	
						                      "and d.line_no = f.line_no(+) "; //add by Peggy 20111122				
							   String orderM = "order by d.LINE_NO";				   
											   //", TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";
						       if (prodManufactory==null || prodManufactory.equals("--") || prodManufactory.equals("")) {whereM=whereM+" ";}
                               else { whereM=whereM+" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; }
  
                               if (status==null || status.equals("--")) {whereM=whereM+" ";}
                               else { whereM=whereM+" and d.LSTATUSID ='"+status+"'"; }
							   
							   if (statusCode==null || statusCode.equals("")) { } 
                               else if (statusCode.equals("O")) { whereM=whereM+" and d.LSTATUSID in ('001','002','003','004','007','008','009','013') ";  } // 只找開單處理中的單據
                               else if (statusCode.equals("C")) { whereM=whereM+" and d.LSTATUSID in ('010') ";  } // 只找已結案的單據
                               else if (statusCode.equals("A")) { whereM=whereM+" and d.LSTATUSID in ('012') ";  } // 只找放棄的單據
                               //else if (statusCode.equals("P")) { whereM=whereM+" and f.ORISTATUSID in ('002','007') ";  }   // 只找企劃處理過的單據 (對應HISTORY 的 ORISTATUSID in ('002','007') )
                               //else if (statusCode.equals("F")) { whereM=whereM+" and f.ORISTATUSID in ('003','004') ";  } // 只找工廠處理過的單據 (對應HISTORY 的 ORISTATUSID in ('003','004') )
							   
								if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0  && UserRoles.indexOf("SMCUser")<0)
								{
									whereM+=" and exists (select 1 from oraddman.tsprod_person x where x.USERNAME='"+UserName+"' and x.PROD_FACNO=d.ASSIGN_MANUFACT)";
							
								}							  
							   sqlM = sqlM + whereM + orderM;
							   //out.println("sqlM="+sqlM);
							   
				               Statement stateM=con.createStatement();
							   //out.println(sqlM);
                               ResultSet rsM=stateM.executeQuery(sqlM); 							  
				               while (rsM.next())
				               { 
							    if (iRow==0 ) // 若第一筆資料才列印標頭列 //
								{ 
								out.println("<tr align='center' bgcolor='#CC3366'><td width='1%' nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgRepStatus"/><%								
								out.println("<td width='1%' nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgAnItem"/><%								
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/><%
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgUOM"/><%
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgQty"/><%
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgRequestDate"/><%
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgFTArrangeDate"/><%
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgSSD"/><%
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgOrdCreateDate"/><%
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgRepStatus"/><%
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");								
								%><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><%	
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgProdFactory"/><%								
								out.println("</font></td><td nowrap><font color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgRemark"/><%
								out.println("</font></td><td nowrap><font color='#FFFFFF'>Certificate Export</font></td>");
								out.println("<td nowrap><font color='#FFFFFF'>PC Remark</font></td></tr>");
								}// End of if (iRow==0)
								
								out.println("<tr bgcolor="+subColStr+">");
								
								//業務confirmdate是否超過24小時
							   String sqlC = " select A.DNDOCNO,A.LINE_NO,A.ASSIGN_DATE,B.COMPLETE_DATE, "+
                                             " round((nvl(TO_DATE(B.COMPLETE_DATE,'YYYYMMDDhh24miss'),sysdate) - TO_DATE(A.ASSIGN_DATE,'YYYYMMDDhh24miss')) * 24,2) countHour "+
                                             " from  "+
                                             "    (select DNDOCNO,LINE_NO,ORISTATUSID,CDATETIME as ASSIGN_DATE "+
                                             "       from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
                                             "      where DNDOCNO = '"+rsTC.getString("DNDOCNO")+"' and LINE_NO = '"+rsM.getString("LINE_NO")+"' and ORISTATUSID='002' ) A, "+
                                             "    (select DNDOCNO,LINE_NO,ORISTATUSID,max(CDATETIME) as COMPLETE_DATE  "+
                                             "       from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
                                             "      where DNDOCNO = '"+rsTC.getString("DNDOCNO")+"' and LINE_NO = '"+rsM.getString("LINE_NO")+"' and ORISTATUSID='008'  "+
											 "		group by DNDOCNO,LINE_NO,ORISTATUSID ) B "+
											 "  where a.dndocno=b.dndocno(+) ";
							   sqlC = sqlC  ; 
							    Statement stateC=con.createStatement();
							   //out.println(sqlC);
                               ResultSet rsC=stateC.executeQuery(sqlC); 
							   if (rsC.next())
							   {
							   
							    if (rsC.getInt("countHour") >= 2 )
							    {out.println("<td align='center' width='1%' nowrap><img src='../image/light_red.gif' width='14' height='15' border='0'></td>");}
								else {out.println("<td align='center' width='1%' nowrap><img src='../image/light_green.gif' width='14' height='15' border='0'></td>");}
								
							   } else {
							            out.println("<td align='center' width='1%' nowrap>&nbsp;</td>");
							           }							
							   rsC.close();
				               stateC.close();
								 
				                out.println("<td width='1%' nowrap><font color='#006666'>"+rsM.getString("LINE_NO")+"</font></td>");								
								out.println("<td nowrap><font color='#CC0066'><a onMouseOver="+'"'+"this.T_STICKY=true;this.T_WIDTH=80;this.T_CLICKCLOSE=false;this.T_BGCOLOR='#D8EBEB';this.T_SHADOWCOLOR='#FFFF99';this.T_OFFSETY=-32;return escape('<table><tr><td>"+rsM.getString("tsc_package")+"</td></tr></table>')"+'"'+">"+rsM.getString("ITEM_DESCRIPTION")+"</a></font></td>");
								out.println("<td nowrap><font color='#006666'>"+rsM.getString("UOM")+"</font></td>");
								out.println("<td nowrap><font color='#006666'>"+rsM.getString("QUANTITY")+"</font></td>");
								out.println("<td nowrap><font color='#006666'>"+rsM.getString(6)+"</font></td>");
							//	out.println("<td nowrap><font color='#006666'>");
							//	if (rsM.getString("PCCFMDATE")==null || rsM.getString("PCCFMDATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("PCCFMDATE").substring(0,4)+"/"+rsM.getString("PCCFMDATE").substring(4,6)+"/"+rsM.getString("PCCFMDATE").substring(6,8)); 
							//	out.println("</font></td>");
								out.println("<td nowrap>");
								if (rsM.getString("FTACPDATE")==null || rsM.getString("FTACPDATE").equals("N/A"))
								{
									out.println("<font color='#006666'>N/A</font>"); 
								}
								else
								{
									if (rsM.getString("PC_OVER_LEADTIME_REASON")!=null)
									{
										out.println("<font style='color:#ff0000'>");
										out.println("<a onMouseOver="+'"'+"this.T_STICKY=true;this.T_WIDTH=180;this.T_CLICKCLOSE=false;this.T_BGCOLOR='#D8EBEB';this.T_SHADOWCOLOR='#FFFF99';this.T_OFFSETY=-32;return escape('<table><tr><td>Over Lead Time:"+rsM.getString("PC_OVER_LEADTIME_REASON")+"</td></tr></table>')"+'"'+">");
									}
									else
									{
										out.println("<font color='#006666'>");
									}
									out.println(rsM.getString("FTACPDATE").substring(0,4)+"/"+rsM.getString("FTACPDATE").substring(4,6)+"/"+rsM.getString("FTACPDATE").substring(6,8)); 
									if (rsM.getString("PC_OVER_LEADTIME_REASON")!=null) out.println("</a>");
									out.println("</font>");
								}
								out.println("</td>");								
								out.println("<td nowrap><font color='#006666'>");
                              	//if (rsM.getString("LSTATUSID").equals("001")  || rsM.getString("LSTATUSID").equals("003") || rsM.getString("LSTATUSID").equals("004") ) {out.println("N/A");}
								//改成以confirm交期才顯示,add by Peggy 20180628
								if (rsM.getString("LSTATUSID").equals("008")  || rsM.getString("LSTATUSID").equals("009") || rsM.getString("LSTATUSID").equals("010") ) 
								{
									if (rsM.getString("SHIP_DATE")==null || rsM.getString("SHIP_DATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("SHIP_DATE").substring(0,4)+"/"+rsM.getString("SHIP_DATE").substring(4,6)+"/"+rsM.getString("SHIP_DATE").substring(6,8));  
								}
                              	else
                                { 
									out.println("N/A");
								}
                                out.println("</font></td>");						
								out.println("<td nowrap><font color='#006666'>");
								if (rsM.getString("SASCODATE")==null || rsM.getString("SASCODATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("SASCODATE").substring(0,4)+"/"+rsM.getString("SASCODATE").substring(4,6)+"/"+rsM.getString("SASCODATE").substring(6,8)); 
								out.println("</font></td>");	
                                if (rsM.getString("EDIT_CODE")=="R" ||rsM.getString("EDIT_CODE").equals("R") )	
                                 {	out.println("<td nowrap><font color='#006666'>"+rsM.getString("LSTATUS")+"(Reject)"+"</font></td>"); }
                                else
                                 {  out.println("<td nowrap><font color='#006666'>"+rsM.getString("LSTATUS")+"</font></td>"); }
								out.println("<td nowrap><font color='#006666'>");
								if (rsM.getString("ORDERNO")==null || rsM.getString("ORDERNO").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("ORDERNO")); 
								out.println("<td nowrap><font color='#006666'>"+rsM.getString("MANUFACTORY_NAME")+"</font></td>");
								out.println("<td nowrap><font color='#006666'>");
								if (rsM.getString("REMARK")==null || rsM.getString("REMARK").equals("N/A")) out.println("&nbsp;"); else out.println(rsM.getString("REMARK")); 
								out.println("</font></td>");
								//add by Peggy 20130410
								if ((rsM.getString("REASON_CODE")!= null && (rsM.getString("REASON_CODE").equals("08") || rsM.getString("REASON_CODE").equals("09"))) || rsM.getString("supply_source") != null)
								{
									out.println("<td align='center' width='1%' nowrap><img src='../image/Excel_16.gif' width='14' height='15' border='0' title='按下滑鼠左鍵,可下載保證函' onClick='setSubmit("+'"'+"../jsp/TSSalseItemCertificate.jsp?DNDOCNO="+rsTC.getString("DNDOCNO")+"&LINENO="+rsM.getString("LINE_NO") +'"'+")'></td>");
								}
								else
								{
									out.println("<td align='center' width='1%' nowrap><font color='#006666'>--</font></td>");
								}
								out.println("<td nowrap><font color='#006666'>");
								if (rsM.getString("PC_REMARK")==null || rsM.getString("PC_REMARK").equals("N/A")) out.println("&nbsp;"); else out.println(rsM.getString("PC_REMARK")); 
								out.println("</font></td>");
				                out.println("</tr>");
								
								iRow++;
				               } // End of while
				               rsM.close();
				               stateM.close();
							  							   
				           //  }  // End of if (dnDocNo ==rsTC.getString("DNDOCNO") || dnDocNo.equals(rsTC.getString("DNDOCNO"))) 
							  /*
							     else {  // 否則只顯示 PLUS 符號
				                        out.print("<tr><td nowrap>"); 
										//out.println("<font color='#006666'>"+rsTC.getString("DNDOCNO")+"</font>"); 
										out.print("<tr><td nowrap>"); 
					                    out.println("<font color='#006666'>");
					                    %><jsp:getProperty name="rPH" property="pgTotal"/><%
					                    out.println(rsTC.getString("MAXLINE"));
					                    %><jsp:getProperty name="rPH" property="pgItemQty"/><%
					                    out.println("</font>"); 
										 %><a href="../jsp/TSSDRQInformationQuery.jsp?SPANNING=TRUE&ORGANIZATION_ID=<%=organizationId%>&DNDOCNO=<%=rsTC.getString("DNDOCNO")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>#<%=rsTC.getString("DNDOCNO")%>"><img src="../image/PLUS.gif" width="14" height="15" border="0"></a>
										 <% 
										 out.println("<font color='#006666'>");
					                     %><jsp:getProperty name="rPH" property="pgCreateFormUser"/><%
					                     out.println(" : "+rsTC.getString("CREATED_BY"));					           
					                     out.println("</font>");
										out.println("</td></tr>");    
										
				                     }  // End of else
									 */
			            }  // End of else if (spannin==null)
			            out.println("</table>");   
			  
			  
			  %></font></td> 
	  <td width="10%" nowrap><div align="center"><strong><font  color="#CC3366"><%=rsTC.getString("SALESPERSON")%></font></strong></div></td>
	  <td width="12%" nowrap><div align="center"><strong><font  color="#CC3366"><%=rsTC.getString(13)%></font></strong></div></td> 
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
}

%>
    <tr bgcolor="#99CC99"> 
      <td height="23" colspan="10" ><font color="#006666" ><jsp:getProperty name="rPH" property="pgQDocNo"/><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">	 <font color='#000066' face="Arial"><strong><%=CaseCount%></strong></font>
	 &nbsp;&nbsp;<font color="#006666" ><jsp:getProperty name="rPH" property="pgGTotal"/><jsp:getProperty name="rPH" property="pgItemQty"/></font>
	 <font color='#000066' face="Arial"><strong><%=iDetailRowCount%></strong></font>
	 </td>      
    </tr>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" >
    <% if (rs_isEmptyTC ) {  %>
    <strong>No Record Found</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
<%
Base64.Encoder encoder = Base64.getEncoder();
byte[] textByte = sqlGlobal.getBytes("UTF-8");
sqlGlobal = encoder.encodeToString(textByte);
textByte = SWHERECOND.getBytes("UTF-8");
SWHERECOND = encoder.encodeToString(textByte);
%>	
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="CUSTOMERAROVERDUE" value="<%=CUSTOMERAROVERDUE%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
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
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
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
