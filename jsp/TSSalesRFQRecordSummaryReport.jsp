<!--modify by Peggy 20150105,年度下拉選單程式改寫-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean,MiscellaneousBean"%>
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
function RFQAllLogDetailQuery(yearfr,monthfr,dayfr,yearto,monthto,dayto,salesareano,statuscode,prodmanufactory)
{     
  //subWin=window.open("TSSalesRFQHeaderDeatilQuery.jsp?YEARFR="+yearfr+"&MONTHFR="+monthfr+"&DAYFR="+dayfr+"&YEARTO="+yearto+"&MONTHTO="+monthto+"&DAYTO="+dayto+"&SALESAREANO="+salesareano+"&STATUSCODE="+statuscode+"&PRODMANUFACTORY="+prodmanufactory,"subwin");  
  subWin=window.open("TSSDRQInformationQuery.jsp?YEARFR="+yearfr+"&MONTHFR="+monthfr+"&DAYFR="+dayfr+"&YEARTO="+yearto+"&MONTHTO="+monthto+"&DAYTO="+dayto+"&SALESAREANO="+salesareano+"&STATUSCODE="+statuscode+"&PRODMANUFACTORY="+prodmanufactory,"subwin");  
}
function RFQAllLineHistoryQuery(yearfr,monthfr,dayfr,yearto,monthto,dayto,salesareano,prodmanufactory)
{     
  subWin=window.open("TSSalesDRQHistory.jsp?YEARFR="+yearfr+"&MONTHFR="+monthfr+"&DAYFR="+dayfr+"&YEARTO="+yearto+"&MONTHTO="+monthto+"&DAYTO="+dayto+"&SALESAREANO="+salesareano+"&PRODMANUFACTORY="+prodmanufactory,"subwin");  
}
function RFQAllDetailHistoryQuery(yearfr,monthfr,dayfr,yearto,monthto,dayto,statuscode,salesareano,prodmanufactory)
{     
  subWin=window.open("TSDRQProcessHeaderHistoryQuery.jsp?YEARFR="+yearfr+"&MONTHFR="+monthfr+"&DAYFR="+dayfr+"&YEARTO="+yearto+"&MONTHTO="+monthto+"&DAYTO="+dayto+"&STATUSCODE="+statuscode+"&SALESAREANO="+salesareano+"&PRODMANUFACTORY="+prodmanufactory,"subwin");  
}
</script>
<html>
<head>

<title>Oracle Add On System Information Query</title>
<!--=============¥H?U°I?q?°|w¥t?{AO?÷‥i==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============¥H?U°I?q?°‥u±o3sμ2|A==========-->
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
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
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

String havingGrp = "";

//String fjamDesc = ""; 

//String link2ExcelURL = "";

  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 3]cw‥C?g2A?@?N?°?P’A?e  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // ‥u°_cl?g2A?@?N
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // ‥u°_cl?g3I?a?@?N 
  String currentWeek = workingDateBean.getWeekString();


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

String period=request.getParameter("PERIOD");

String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");
      if (YearFr==null && MonthFr==null && DayFr==null) 
	  { 
	    if (period==null)
	    {
	     dateSetBegin=strFirstDayWeek; 
	     YearFr = strFirstDayWeek.substring(0,4);
		 MonthFr = strFirstDayWeek.substring(4,6);
		 DayFr = strFirstDayWeek.substring(6,8);
		} else if (period.equals("D"))
		        {
		            dateBean.setAdjDate(-1);
				    YearFr = dateBean.getYearString();
				    MonthFr = dateBean.getMonthString();
				    DayFr = dateBean.getDayString();
				    dateBean.setAdjDate(1);
					dateSetBegin = YearFr+MonthFr+DayFr;
		        }
	  }
	  else  dateSetBegin = YearFr+MonthFr+DayFr;

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
      if (YearTo==null && MonthTo==null && DayTo==null) 
	  {  
	    if (period==null)
	    {
	      dateSetEnd=strLastDayWeek; 
		  YearTo = strLastDayWeek.substring(0,4);
		  MonthTo = strLastDayWeek.substring(4,6);
		  DayTo = strLastDayWeek.substring(6,8);
		} else if (period.equals("D"))
		       {
			     dateBean.setAdjDate(-1);
				 YearTo = dateBean.getYearString();
				 MonthTo = dateBean.getMonthString();
				 DayTo = dateBean.getDayString();
				 dateBean.setAdjDate(1);
				 dateSetEnd = YearTo+MonthTo+DayTo;   
		       }
	  }	
      else  dateSetEnd = YearTo+MonthTo+DayTo;

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
  
  String sqlGlobal = "";
  String sWhereGlobal = "";
  String locale = "886";
  
  if (dnDocNo==null || dnDocNo.equals("")) dnDocNo=""; //?i?URi?}ao
  if (dnDocNoSet==null || dnDocNoSet.equals("")) dnDocNoSet=""; // ‥I¥IaI?e?Jao
  if (customerId==null || customerId.equals("")) customerId="";
  if (customerNo==null || customerNo.equals("")) customerNo="";
  if (customerName==null || customerName.equals("")) customerName="";
  if (custPONo==null || custPONo.equals("")) custPONo="";
  if (createdBy==null || createdBy.equals("")) createdBy="";
  if (salesPerson==null || salesPerson.equals("")) salesPerson="";
  if (salesOrderNo==null || salesOrderNo.equals("")) salesOrderNo="";

  if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
  if (spanning==null || spanning.equals("")) spanning = "TRUE";


    // |]AoAp -q3a¥DAE?Icu2OAE,?G?YcI¥sSET Client Information Procedure
     String clientID = "";
	 if (organizationId=="46" || organizationId.equals("46"))
	 {  clientID = "42"; }
	 else { clientID = "41"; }
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 cs1.setString(1,clientID);  /*  41 --> ?°¥b?EAe  42 --> ?°‥A°E?÷ */
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();
	 
  //  


%>
<% /* ?O¥s¥?-?-±﹐eRARw3s?u  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
</head>
<body>    
<FORM ACTION="../jsp/TSCInvORGSubInventoryNBQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/±NExcel Veiw §‥|bAEAY%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgSalesDRQ"/><jsp:getProperty name="rPH" property="pgRepAreaSummaryReport"/>(</strong></font>
<font color="#FF0000" size="+2" ><%=dateSetBegin%></font><font color="#003366" size="+2" face="Times New Roman"><strong><jsp:getProperty name="rPH" property="pgTo"/></strong></font><font color="#FF0000" size="+2"><%=dateSetEnd%></font><font color="003366" size="+2"><strong>)</strong></font>
<BR>
  <A href="/oradds/ORAddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A><!--%/20040109/±NExcel Veiw §‥|bAEAY%-->
<%
 
  sWhereGP = " and c.DNDOCNO IS NOT NULL ";
  //String stringReplace = "Text & This is a substring wait for replace !!!";
  //out.println(stringReplace.replaceAll("&", "&nbsp;"));

/*  AE?d‥I¥I?O§_|3?d﹐s‥a¥|ou-×AIou-×3aaoAv-- -- ‥Iμn?JREao‥I¥IaI﹐s2O */

 //out.println("strFirstDayWeek="+strFirstDayWeek);
 //out.println("strLastDayWeek="+strLastDayWeek);

if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")))
{
   sSql = "select DISTINCT b.SALES_AREA_NO, b.ALNAME, b.SALES_AREA_NAME "+
          //"TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS'),"+
		  //"b.SALES_AREA_NAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), c.CREATED_BY, c.SALESPERSON, c.REQREASON, "+
		  //"count(d.line_no) as MAXLINE "+
          //"a.ASSIGN_FACTORY,"+"d.ASSIGN_MANUFACT ||'-' ||e.MANUFACTORY_NAME, c.REMARK "+
		  "from ORADDMAN.TSSALES_AREA b, "+
		       "ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";
   sSqlCNT = "select count(DISTINCT b.SALES_AREA_NO) as CaseCount "+
                  "from ORADDMAN.TSSALES_AREA b, "+
		          "ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";
   sWhere =  "where c.DNDOCNO = d.DNDOCNO "+
			 "and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
										      // "or  d.DOCNO || '-' || d.ASSIGN_LNO in ("+distDnDocNo+") ) "+
			 "and b.LOCALE='"+locale+"' "+
			 "and b.SALES_AREA_NO=c.TSAREANO ";
   havingGrp = " ";              
   sOrder = "order by b.SALES_AREA_NO";
   //TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";   
   
   SWHERECOND = sWhere + sWhereGP + havingGrp;
   sSql = sSql + sWhere + sWhereGP + havingGrp + sOrder;
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
			 // ‥u?p?A1|i
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
   sSql = "select DISTINCT b.SALES_AREA_NO, b.ALNAME, b.SALES_AREA_NAME, b.ALCHNAME "+
          //"TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS'),"+
		  //"b.SALES_AREA_NAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), c.CREATED_BY, c.SALESPERSON, c.REQREASON, "+
		  //"count(d.line_no) as MAXLINE "+
          //"a.ASSIGN_FACTORY,"+"d.ASSIGN_MANUFACT ||'-' ||e.MANUFACTORY_NAME, c.REMARK "+
		  "from ORADDMAN.TSSALES_AREA b, "+
		       "ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";
   sSqlCNT = "select count(DISTINCT b.SALES_AREA_NO) as CaseCount "+
                  "from ORADDMAN.TSSALES_AREA b, "+
		          "ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";
   sWhere =  "where c.DNDOCNO = d.DNDOCNO "+
			 "and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
										      // "or  d.DOCNO || '-' || d.ASSIGN_LNO in ("+distDnDocNo+") ) "+
			 "and b.LOCALE='"+locale+"' "+
			 "and b.SALES_AREA_NO=c.TSAREANO ";
   havingGrp = " ";              
   sOrder = "order by b.SALES_AREA_NO";
   //, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";     
      
   
  if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and substr(c.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
  if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and substr(c.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(c.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'"; 
	
 
  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereGP + havingGrp + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP;
  //out.println("sSqlTT="+sSql);    
   
   String sqlOrgCnt = "select count(DISTINCT b.SALES_AREA_NO) as CaseCountORG "+
                        "from ORADDMAN.TSSALES_AREA b, "+
		                     "ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";
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
			 // ‥u?p?A1|i
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
// ·C3A?cou-×?e|!‥I¥IaoStatement Con //
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
  <table cellSpacing='1' bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1' bordercolor="#CCCCCC">     
     <tr>	    
	   <td nowrap colspan="2"><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgDateFr"/></strong></font>
        <%
		 // String CurrYear = null;	     		 
	     //try
         //{       
         // String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013"};
         // arrayComboBoxBean.setArrayString(a);
		 // if (YearFr==null)
		 // {
		 //   CurrYear=dateBean.getYearString();
		 //   arrayComboBoxBean.setSelection(CurrYear);
		 // } 
		 // else 
		 // {
		 //   arrayComboBoxBean.setSelection(YearFr);
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
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
			for (int i = Integer.parseInt(dateBean.getYearString()) ; i >=2002 ; i--)
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
       <font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgDateTo"/></strong></font>
        <%
		 // String CurrYearTo = null;	     		 
	     //try
         //{       
         // String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013"};
         // arrayComboBoxBean.setArrayString(a);
		 // if (YearTo==null)
		 // {
		 //   CurrYearTo=dateBean.getYearString();
		 //   arrayComboBoxBean.setSelection(CurrYearTo);
		 // } 
		 // else 
		 // {
		 //   arrayComboBoxBean.setSelection(YearTo);
		 // }
	     // arrayComboBoxBean.setFieldName("YEARTO");	   
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
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
			for (int i =Integer.parseInt(dateBean.getYearString()) ; i >= 2002 ; i--)
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
	<td colspan="2">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSSalesRFQRecordSummaryReport.jsp")' > 			 
	</td>
   </tr>
  </table>  
 <hr>
  	   
	<% // 先取日期區間內有多少工廠被處理個數_起
			    int colSpan = 1;  
		        String sqlFC = "select count(DISTINCT MANUFACTORY_NO) from  ORADDMAN.TSPROD_MANUFACTORY a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b ";
				String whereFC = "where a.MANUFACTORY_NO = b.ASSIGN_MANUFACT ";    
				if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereFC=whereFC+" and substr(b.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
                if (DayFr!="--" && DayTo!="--") whereFC=whereFC+" and substr(b.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(b.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'"; 
				sqlFC = sqlFC + whereFC;
				Statement stateFC=con.createStatement();
				//out.println(sqlFC);
                ResultSet rsFC=stateFC.executeQuery(sqlFC); 	
				if (rsFC.next())			
				{
				  colSpan = rsFC.getInt(1)*2; // 取日期條件下工廠產地的個數*3 (產地/處理件數/平均工時)
				}
				rsFC.close();
				stateFC.close();
				//out.println("colSpan="+colSpan);
   // 先取日期區間內有多少工廠被處理個數_迄			
   %>
  <table width="100%" height="30%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
    <tr> 
	  <td width="5%" height="44" nowrap rowspan="2"><div align="center"><font color="#000000" size="2">&nbsp;</font></div></td> 
	  <td width="15%" height="44" nowrap rowspan="2"><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgSalesArea"/></font></div></td>	               
      <td width="15%" height="20%" colspan="7" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgSalesMan"/><jsp:getProperty name="rPH" property="pgRFQProcessSummary"/></font></div></td>	  
      <td width="8%" nowrap colspan="2"><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgSPCProcessSummary"/></font></div></td>            
      <td width="16%" nowrap colspan="<%=colSpan%>"><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgFCTProcessSummary"/></font></div></td> 	  
    </tr> 	  
    <tr> 
      <td width="8%" nowrap colspan="2"><div align="center"><font size="2" face="Arial" color="#006666"><jsp:getProperty name="rPH" property="pgLogQty"/><BR><jsp:getProperty name="rPH" property="pgQDocNo"/><jsp:getProperty name="rPH" property="pgMRItemQty"/>(A)/<jsp:getProperty name="rPH" property="pgItemQty"/>(B)</font></div></td>	  
      <td width="8%"nowrap colspan="2"><div align="center"><font size="2" face="Arial" color="#006666"><jsp:getProperty name="rPH" property="pgRFQProcessing"/><BR><jsp:getProperty name="rPH" property="pgRecord"/>(C)/<jsp:getProperty name="rPH" property="pgWorkTime"/></font></div></td>	  
      <td width="8%" nowrap colspan="2"><div align="center"><font size="2" face="Arial" color="#006666"><jsp:getProperty name="rPH" property="pgRFQDOCNoClosed"/><BR><jsp:getProperty name="rPH" property="pgRecord"/>(D)/<jsp:getProperty name="rPH" property="pgWorkTime"/></font></div></td>	  
      <td width="9%" nowrap><div align="center"><font size="2" face="Arial" color="#006666"><jsp:getProperty name="rPH" property="pgRFQAborted"/>(E)</font></div></td>	  
      <td width="8%" nowrap colspan="2"><div align="center"><font size="2" face="Arial" color="#006666"><jsp:getProperty name="rPH" property="pgProcessQty"/><BR><jsp:getProperty name="rPH" property="pgRecord"/>/<jsp:getProperty name="rPH" property="pgWorkTime"/></font></div></td>            
      <td width="16%" colspan="<%=colSpan%>" nowrap><div align="center"><font size="2" face="Arial" color="#006666"><jsp:getProperty name="rPH" property="pgProdFactory"/><BR><jsp:getProperty name="rPH" property="pgRecord"/>/<jsp:getProperty name="rPH" property="pgWorkTime"/></font></div></td> 	  
    </tr>
	<% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	 <%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "FFFFCC";
	     }
	    else{
	       colorStr = "FFFFFF"; }
      %> 
    <tr bgcolor="<%=colorStr%>"> 
      <td width="5%"><div align="center"><font size="2" color="#006666"><a name='#<%=rsTC.getString("SALES_AREA_NO")%>'><%out.println(rs1__index+1);%></a></font></div></td>
	  <td width="15%" nowrap><div align="center"><font size="2" color="#006666"><% out.println(rsTC.getString("ALNAME")+"<BR>"+"("+rsTC.getString("ALCHNAME")+")"); %></font></div></td>     	        
      <td width="8%" nowrap><a href='javaScript:RFQAllLogDetailQuery("<%=YearFr%>","<%=MonthFr%>","<%=DayFr%>","<%=YearTo%>","<%=MonthTo%>","<%=DayTo%>","<%=rsTC.getString("SALES_AREA_NO")%>","<%=""%>","<%=""%>")'>
	  <div align="center"><font color="#333366"  size="2">
	      <% // 取業務地區日期區間下的登錄數_起
		        String sqlSa = "select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b ";
				String whereSa = "where  a.DNDOCNO = b.DNDOCNO and a.TSAREANO = '"+rsTC.getString("SALES_AREA_NO")+"' and b.LSTATUSID in ('001','002','003','004','005','007','008','009','010','011','012','013') ";    
				if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereSa=whereSa+" and substr(b.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
                if (DayFr!="--" && DayTo!="--") whereSa=whereSa+" and substr(b.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(b.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'"; 
				sqlSa = sqlSa + whereSa;
				Statement stateSa=con.createStatement();
				//out.println(sqlSa);
                ResultSet rsSa=stateSa.executeQuery(sqlSa); 	
				if (rsSa.next())			
				{
				  out.println(rsSa.getInt(1)); // 取日期條件下工廠產地的個數
				} else out.println("0");
				rsSa.close();
				stateSa.close();
				//out.println("colSpan="+colSpan);
			// 取業務地區日期區間下的登錄數_迄	
		  %>
	  </font></div></a>
	  </td>
	  <td width="8%" nowrap><a href='javaScript:RFQAllLogDetailQuery("<%=YearFr%>","<%=MonthFr%>","<%=DayFr%>","<%=YearTo%>","<%=MonthTo%>","<%=DayTo%>","<%=rsTC.getString("SALES_AREA_NO")%>","<%=""%>","<%=""%>")'>
	     <div align="center"><font color="#333366" size="2">
		   <% // 取業務地區日期區間下的登錄明細數_起
		        String sqlSad = "select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b ";
				String whereSad = "where  a.DNDOCNO = b.DNDOCNO and a.TSAREANO = '"+rsTC.getString("SALES_AREA_NO")+"' and b.LSTATUSID in ('001','002','003','004','005','007','008','009','010','011','012','013') ";    
				if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereSad=whereSad+" and substr(b.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
                if (DayFr!="--" && DayTo!="--") whereSad=whereSad+" and substr(b.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(b.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'"; 
				sqlSad = sqlSad + whereSad;
				Statement stateSad=con.createStatement();
				//out.println(sqlSa);
                ResultSet rsSad=stateSad.executeQuery(sqlSad); 	
				if (rsSad.next())			
				{
				  out.println(rsSad.getInt(1)); // 取日期條件下工廠產地的個數
				} else out.println("0");
				rsSad.close();
				stateSad.close();
				//out.println("colSpan="+colSpan);
			// 取業務地區日期區間下的登錄明細數_迄	
		  %>
	     </font></div></a>
	  </td>
      <td width="8%" nowrap><a href='javaScript:RFQAllDetailHistoryQuery("<%=YearFr%>","<%=MonthFr%>","<%=DayFr%>","<%=YearTo%>","<%=MonthTo%>","<%=DayTo%>","<%="SP"%>","<%=rsTC.getString("SALES_AREA_NO")%>","<%=""%>")'>
	   <div align="center"><font color="#333366" size="2">
	      <%
		    // 取企劃地區日期區間下的開單處理中數_起
			    float cntProcess = 0;
				String sqlPSp = "select DISTINCT a.DNDOCNO from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b ";
		        String sqlSp = "select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b ";
				String whereSp = "where a.DNDOCNO = b.DNDOCNO and a.TSAREANO = '"+rsTC.getString("SALES_AREA_NO")+"' and b.LSTATUSID in ('002','003','004','005','007','008','009','011','013') ";    
				if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereSp=whereSp+" and substr(b.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
                if (DayFr!="--" && DayTo!="--") whereSp=whereSp+" and substr(b.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(b.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'"; 
				sqlSp = sqlSp + whereSp;
				sqlPSp = sqlPSp + whereSp;
				Statement stateSp=con.createStatement();
				//out.println(sqlSp);
                ResultSet rsSp=stateSp.executeQuery(sqlSp); 	
				if (rsSp.next())			
				{
				  out.println(rsSp.getInt(1)); // 取日期條件下工廠產地的個數
				  cntProcess = rsSp.getFloat(1);
				} else out.println("0");
				rsSp.close();
				stateSp.close();
				//out.println("colSpan="+colSpan);
			// 取企劃地區日期區間下的開單處理中數_迄
		  %>
	   </font></div></a>
	  </td>
      <td width="8%" nowrap> 
	   <div align="center"><font color="#333366" size="2">
	    <%
		    // 取業務地區日期區間下的開單處理中數_起
			    float sumProcWorkTime = 0;
		        String sqlSPt = "select DISTINCT DNDOCNO, PROCESS_WORKTIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY c ";
				String whereSPt = "where substr(c.DNDOCNO,3,3) = '"+rsTC.getString("SALES_AREA_NO")+"' and c.ORISTATUSID in ('001','002','003','004','007','008') ";    
				if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereSPt=whereSPt+" and substr(c.CDATETIME,0,8) >="+"'"+dateSetBegin+"'";
                if (DayFr!="--" && DayTo!="--") whereSPt=whereSPt+" and substr(c.CDATETIME,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(c.CDATETIME,0,8) <= "+"'"+dateSetEnd+"'"; 
				if (sqlPSp!=null) whereSPt=whereSPt+ "and DNDOCNO in ("+sqlPSp+")"; 
				sqlSPt = sqlSPt + whereSPt;
				int docCount = 0;
				Statement stateSPt=con.createStatement();
				//out.println(sqlSPt);
                ResultSet rsSPt=stateSPt.executeQuery(sqlSPt); 	
				while (rsSPt.next())			
				{
				   
				  //out.println(rsSPt.getInt(1)); // 取日期條件下工廠產地的個數
				  sumProcWorkTime = sumProcWorkTime + rsSPt.getFloat(2); 
				} //else out.println("0");
				rsSPt.close();
				stateSPt.close();
				//out.println("sumProcWorkTime="+sumProcWorkTime);
				miscellaneousBean.setRoundDigit(2);
                String ProcWTimeStr = null;
				if (sumProcWorkTime>=0 && cntProcess!=0) ProcWTimeStr = miscellaneousBean.getFloatRoundStr(sumProcWorkTime/cntProcess);
				
				if (cntProcess!=0) out.println(ProcWTimeStr);
				else  out.println("0");
			// 取業務地區日期區間下的開單處理中數_迄
		%>
	   </font></div>
	  </td>
      <td width="8%" nowrap><a href='javaScript:RFQAllDetailHistoryQuery("<%=YearFr%>","<%=MonthFr%>","<%=DayFr%>","<%=YearTo%>","<%=MonthTo%>","<%=DayTo%>","<%="SC"%>","<%=rsTC.getString("SALES_AREA_NO")%>","<%=""%>")'>
	    <div align="center"><font color="#333366" size="2">
	      <%
		    // 取企劃地區日期區間下的已結案數_起
			    float cntClose = 0;
				String sqlPSc = "select DISTINCT a.DNDOCNO from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "; 
		        String sqlSc = "select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b ";
				String whereSc = "where a.DNDOCNO = b.DNDOCNO and a.TSAREANO = '"+rsTC.getString("SALES_AREA_NO")+"' and b.LSTATUSID ='010' ";    
				if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereSc=whereSc+" and substr(b.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
                if (DayFr!="--" && DayTo!="--") whereSc=whereSc+" and substr(b.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(b.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'"; 
				sqlSc = sqlSc + whereSc;
				sqlPSc = sqlPSc + whereSc;
				Statement stateSc=con.createStatement();
				//out.println(sqlSc);
                ResultSet rsSc=stateSc.executeQuery(sqlSc); 	
				if (rsSc.next())			
				{
				  out.println(rsSc.getInt(1)); // 取日期條件下工廠產地的個數
				  cntClose = rsSc.getFloat(1);
				} else out.println("0");
				rsSc.close();
				stateSc.close();
				//out.println("colSpan="+colSpan);
			// 取企劃地區日期區間下的已結案數_迄
		  %>
	   </font></div></a>
	  </td>
      <td width="8%" nowrap>
	   <div align="center"><font color="#333366" size="2">
	      <%
		      // 取業務地區日期區間下的已結案數_起
			    float sumCloseWorkTime = 0;
		        String sqlCPt = "select DISTINCT DNDOCNO, PROCESS_WORKTIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY c ";
				String whereCPt = "where substr(c.DNDOCNO,3,3) = '"+rsTC.getString("SALES_AREA_NO")+"' and c.ORISTATUSID in ('009') ";    
				if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereCPt=whereCPt+" and substr(c.CDATETIME,0,8) >="+"'"+dateSetBegin+"'";
                if (DayFr!="--" && DayTo!="--") whereCPt=whereCPt+" and substr(c.CDATETIME,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(c.CDATETIME,0,8) <= "+"'"+dateSetEnd+"'"; 
				if (sqlPSc!=null) whereCPt=whereCPt+"and DNDOCNO in ("+sqlPSc+")";
				sqlCPt = sqlCPt + whereCPt;
				Statement stateCPt=con.createStatement();
				//out.println(sqlSc);
                ResultSet rsCPt=stateCPt.executeQuery(sqlCPt); 	
				while (rsCPt.next())			
				{
				  //out.println(rsSPt.getInt(1)); // 取日期條件下工廠產地的個數
				  sumCloseWorkTime = sumCloseWorkTime + rsCPt.getFloat(2); 
				} //else out.println("0");
				rsCPt.close();
				stateCPt.close();
				
				miscellaneousBean.setRoundDigit(2);				
                String CloseWTimeStr = null;
				if (sumCloseWorkTime>=0 && cntClose!=0) CloseWTimeStr = miscellaneousBean.getFloatRoundStr(sumCloseWorkTime/cntClose);
				
				if (cntClose!=0) out.println(CloseWTimeStr);
				else  out.println("0");
			// 取業務地區日期區間下的已結案數_迄
		  %>
		</font></div>
	  </td>
      <td width="8%" nowrap><a href='javaScript:RFQAllDetailHistoryQuery("<%=YearFr%>","<%=MonthFr%>","<%=DayFr%>","<%=YearTo%>","<%=MonthTo%>","<%=DayTo%>","<%="SA"%>","<%=rsTC.getString("SALES_AREA_NO")%>","<%=""%>")'>
	  <div align="center"><font color="#333366" size="2">
	      <%
		    // 取企劃地區日期區間下的已放棄數_起
		        String sqlSAb = "select count(a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b ";
				String whereSAb = "where a.DNDOCNO = b.DNDOCNO and a.TSAREANO = '"+rsTC.getString("SALES_AREA_NO")+"' and b.LSTATUSID ='012' ";    
				if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereSAb=whereSAb+" and substr(b.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
                if (DayFr!="--" && DayTo!="--") whereSAb=whereSAb+" and substr(b.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(b.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'"; 
				sqlSAb = sqlSAb + whereSAb;
				Statement stateSAb=con.createStatement();
				//out.println(sqlSa);
                ResultSet rsSAb=stateSAb.executeQuery(sqlSAb); 	
				if (rsSAb.next())			
				{
				  out.println(rsSAb.getInt(1)); // 取日期條件下工廠產地的個數
				} else out.println("0");
				rsSAb.close();
				stateSAb.close();
				//out.println("colSpan="+colSpan);
			// 取企劃地區日期區間下的已放棄數_迄
		  %>
	   </font></div></a>
	  </td>
      <td width="8%" nowrap><a href='javaScript:RFQAllDetailHistoryQuery("<%=YearFr%>","<%=MonthFr%>","<%=DayFr%>","<%=YearTo%>","<%=MonthTo%>","<%=DayTo%>","<%="P"%>","<%=rsTC.getString("SALES_AREA_NO")%>","<%=""%>")'>
	    <div align="center"><font color="#333366" size="2">
	      <%
		    // 取企劃地區日期區間下的已處理數_起
			    float cntPlanner = 0;
				String sqlPPc = "select DISTINCT a.DNDOCNO from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_DETAIL_HISTORY b ";
		        String sqlPc = "select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_DETAIL_HISTORY b ";
				String wherePc = "where a.DNDOCNO = b.DNDOCNO and a.TSAREANO = '"+rsTC.getString("SALES_AREA_NO")+"' and b.ORISTATUSID in ('002','007') ";    
				if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") wherePc=wherePc+" and substr(b.UPDATEDATE,0,8) >="+"'"+dateSetBegin+"'";
                if (DayFr!="--" && DayTo!="--") wherePc=wherePc+" and substr(b.UPDATEDATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(b.UPDATEDATE,0,8) <= "+"'"+dateSetEnd+"'"; 
				sqlPPc = sqlPPc + wherePc;
				sqlPc = sqlPc + wherePc;
				Statement statePc=con.createStatement();
				//out.println(sqlSa);
                ResultSet rsPc=statePc.executeQuery(sqlPc); 	
				if (rsPc.next())			
				{
				  out.println(rsPc.getInt(1)); // 取日期條件下工廠產地的個數
				  cntPlanner = rsPc.getFloat(1);
				} else out.println("0");
				rsPc.close();
				statePc.close();
				//out.println("colSpan="+colSpan);
			// 取企劃地區日期區間下的已處理_迄
		  %>
	   </font></div></a>
	  </td> 	   
      <td width="8%" nowrap> 
	  <div align="center"><font color="#333366" size="2">
	     <%
		    // 取企劃地區日期區間下的處理時間_起
			    float sumPlannerWorkTime = 0;
		        String sqlPnt = "select DISTINCT DNDOCNO, PROCESS_WORKTIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY c ";
				String wherePnt = "where substr(c.DNDOCNO,3,3) = '"+rsTC.getString("SALES_AREA_NO")+"' and c.ORISTATUSID in ('002','007') ";    
				if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") wherePnt=wherePnt+" and substr(c.CDATETIME,0,8) >="+"'"+dateSetBegin+"'";
                if (DayFr!="--" && DayTo!="--") wherePnt=wherePnt+" and substr(c.CDATETIME,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(c.CDATETIME,0,8) <= "+"'"+dateSetEnd+"'"; 
				if (sqlPPc!=null) wherePnt=wherePnt+"and DNDOCNO in ("+sqlPPc+")";
				sqlPnt = sqlPnt + wherePnt;
				Statement statePnt=con.createStatement();
				//out.println(sqlSc);
                ResultSet rsPnt=statePnt.executeQuery(sqlPnt); 	
				while (rsPnt.next())			
				{
				  //out.println(rsSPt.getInt(1)); // 取日期條件下工廠產地的個數
				  sumPlannerWorkTime = sumPlannerWorkTime + rsPnt.getFloat(2); 
				} //else out.println("0");
				rsPnt.close();
				statePnt.close();
				
				miscellaneousBean.setRoundDigit(2);
				
                String PlannerWTimeStr = null;
				if (sumPlannerWorkTime>=0 && cntPlanner!=0) PlannerWTimeStr = miscellaneousBean.getFloatRoundStr(sumPlannerWorkTime/cntPlanner);
				
				if (cntPlanner!=0) out.println(PlannerWTimeStr);
				else  out.println("0");
			// 取企劃地區日期區間下的處理時間_迄   
		 %>
	  </font></div> 
	  </td>   
			<%
			      String sqlF = "select DISTINCT MANUFACTORY_NO, ALNAME, ALENGNAME, MANUFACTORY_NAME from ORADDMAN.TSPROD_MANUFACTORY a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b ";  
				  String whereF = "where a.MANUFACTORY_NO = b.ASSIGN_MANUFACT "; 
				  if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereF=whereF+" and substr(b.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
                  if (DayFr!="--" && DayTo!="--") whereF=whereF+" and substr(b.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(b.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'";  
				  sqlF =sqlF + whereF;
				  
			      Statement stateF=con.createStatement();
				  //out.println(sqlM);
                  ResultSet rsF=stateF.executeQuery(sqlF); 							  
				  
				    // = rsF.getString(3);
			%>
			  <%//工廠人員處理狀態彙整//%>			
			<% 
			     while (rsF.next())
				 {  
				 
			%>	
			   <td width="40%">
			   <table width="100%" height="100%" border="1" cellpadding="1" cellspacing="1" bordercolorlight="#999999" bordercolordark="#FFFFFF" bordercolor="#CCCCCC">
			     <tr><td colspan="2" nowrap><div align="center"><font size="2" color="#006666"><% out.println(rsF.getString(3)); %></font></div></td></tr>			     
			     <tr><td width="50%" nowrap><a href='javaScript:RFQAllDetailHistoryQuery("<%=YearFr%>","<%=MonthFr%>","<%=DayFr%>","<%=YearTo%>","<%=MonthTo%>","<%=DayTo%>","<%="F"%>","<%=rsTC.getString("SALES_AREA_NO")%>","<%=rsF.getString("MANUFACTORY_NO")%>")'>
				       <div align="center"><font size="2" color="#330066">
				        <%
						    // 取工廠地區日期區間下的已處理_起
							float cntFactory = 0;
		                    String sqlFac = "select count(DISTINCT a.DNDOCNO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,ORADDMAN.TSDELIVERY_DETAIL_HISTORY b ";
				            String whereFac = "where a.DNDOCNO = b.DNDOCNO and a.LINE_NO = b.LINE_NO and substr(a.DNDOCNO,3,3) = '"+rsTC.getString("SALES_AREA_NO")+"' and b.ORISTATUSID in ('003','004') and a.ASSIGN_MANUFACT = '"+rsF.getString("MANUFACTORY_NO")+"' ";    
				            if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereFac=whereFac+" and b.UPDATEDATE >="+"'"+dateSetBegin+"'";
                            if (DayFr!="--" && DayTo!="--") whereFac=whereFac+" and b.UPDATEDATE >= "+"'"+dateSetBegin+"'"+" and b.UPDATEDATE <= "+"'"+dateSetEnd+"'"; 
				            sqlFac = sqlFac + whereFac;
				            Statement stateFac=con.createStatement();
				            //out.println(sqlFac);
							
                            ResultSet rsFac=stateFac.executeQuery(sqlFac); 	
				            if (rsFac.next())			
				            {
				             out.println(rsFac.getInt(1)); // 取日期條件下工廠產地的個數
							 cntFactory = rsFac.getFloat(1);
				            } else out.println("0");
				            rsFac.close();
				            stateFac.close();
							
				            //out.println("colSpan="+colSpan);
			                // 取工廠地區日期區間下的已處理_迄
						
						%>
					   </font></div></a>
					 </td>
					 <td width="50%" nowrap>
					    <div align="center"><font size="2" color="#333366">
						  <%
						     // 取工廠及業務地區日期區間下的處理時間_起
			                 float sumFactoryWorkTime = 0;
		                     String sqlFctnt = "select DISTINCT a.DNDOCNO, PROCESS_WORKTIME from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a, ORADDMAN.TSDELIVERY_DETAIL_HISTORY c ";
				             String whereFctnt = "where a.DNDOCNO = c.DNDOCNO and a.LINE_NO = c.LINE_NO and substr(c.DNDOCNO,3,3) = '"+rsTC.getString("SALES_AREA_NO")+"' and c.ORISTATUSID in ('003','004') and a.ASSIGN_MANUFACT = '"+rsF.getString("MANUFACTORY_NO")+"' ";    
				             if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereFctnt=whereFctnt+" and substr(c.CDATETIME,0,8) >="+"'"+dateSetBegin+"'";
                             if (DayFr!="--" && DayTo!="--") whereFctnt=whereFctnt+" and substr(c.CDATETIME,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(c.CDATETIME,0,8) <= "+"'"+dateSetEnd+"'"; 
				             sqlFctnt = sqlFctnt + whereFctnt;
				             Statement stateFctnt=con.createStatement();
				             //out.println(sqlFctnt);
                             ResultSet rsFctnt=stateFctnt.executeQuery(sqlFctnt); 	
				             while (rsFctnt.next())			
				             {
				                //out.println(rsSPt.getInt(1)); // 取日期條件下工廠產地的個數
				              sumFactoryWorkTime = sumFactoryWorkTime + rsFctnt.getFloat(2); 
				             } //else out.println("0");
				             rsFctnt.close();
				             stateFctnt.close();
				   
				             miscellaneousBean.setRoundDigit(2);
                             String FactoryWTimeStr = null;
							 if (sumFactoryWorkTime>=0 && cntFactory!=0)
							 {	
							   FactoryWTimeStr =miscellaneousBean.getFloatRoundStr(sumFactoryWorkTime/cntFactory);
				               out.println(FactoryWTimeStr);
							 }
				             else  out.println("0");
			                 // 取企劃地區日期區間下的處理時間_迄  
						  
						  %>
						</font></div>
					 </td></tr>
			   </table>
			   </td>  
			<%
			     }
			     rsF.close();
			     stateF.close();
			%>	  	                   
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
}
int colSpanRow = colSpan + 11;
%>
    <tr> 
      <td height="23" colspan="<%=colSpanRow%>" ><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgSalesArea"/><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // §&acirc;&para;g§O&frac12;&Otilde;&frac34;&atilde;&brvbar;^&uml;&Oacute;
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly=""><%out.println("<font color='#000066'><strong><em>"+CaseCount+"</em></strong></font>");%> 
	 </td>      
    </tr>
  </table>
  <!--%‥C-?μ§!’Aa¥Uμ§‥iμ§A`|@|3﹐eRA%-->
  <div align="center"> <font color="#993366" size="2">
    <% if (rs_isEmptyTC ) {  %>
    <strong>No Record Found</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
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
<table width="80%" align="left">
<tr>
 <td width="58%">
  <table width="93%" height="100%">
   <tr><td colspan="4"><font color="#CC3366" size="2"><strong><span class="style1">&nbsp;&nbsp;</span><jsp:getProperty name="rPH" property="pgDesc"/>:</strong></font></td></tr>
   <tr><td colspan="2" nowrap><font color="#CC3366" size="2"><strong>1.<jsp:getProperty name="rPH" property="pgWorkTime"/>:</strong></font><font color="#CC3366" size="2"><strong><jsp:getProperty name="rPH" property="pgWorkTimeMsg"/></strong></font></td></tr>
   <tr><td colspan="2" nowrap><font color="#CC3366" size="2"><strong>2.<jsp:getProperty name="rPH" property="pgQDocNo"/><jsp:getProperty name="rPH" property="pgMRItemQty"/>(A)=</strong></font><font color="#CC3366" size="2"><strong><jsp:getProperty name="rPH" property="pgALogDesc"/></strong></font></td></tr>
   <tr><td width="25%" rowspan="3" valign="top" nowrap><font color="#CC3366" size="2"><strong>3.<jsp:getProperty name="rPH" property="pgItemQty"/>(B)=</strong></font></td><td width="75%"><font color="#CC3366" size="2"><strong><jsp:getProperty name="rPH" property="pgRFQProcessing"/><jsp:getProperty name="rPH" property="pgRecord"/>(C)</strong></font></td></tr>
   <tr><td nowrap><font color="#CC3366" size="2"><strong>+<jsp:getProperty name="rPH" property="pgRFQDOCNoClosed"/><jsp:getProperty name="rPH" property="pgRecord"/>(D)</strong></font></td></tr>
   <tr><td nowrap><font color="#CC3366" size="2"><strong>+<jsp:getProperty name="rPH" property="pgRFQAborted"/>(E)</strong></font></td></tr>
  </table>
 </td>
 <td width="42%">
  <table width="81%">
   <tr><td colspan="2" nowrap><font color="#CC3366" size="2"><strong><jsp:getProperty name="rPH" property="pgProdFactory"/><jsp:getProperty name="rPH" property="pgDesc"/></strong></font></td></tr>
   <tr><td width="27%" nowrap><font color="#CC3366" size="2"><strong>TEW:</strong></font></td><td width="73%"><font color="#CC3366" size="2"><strong><jsp:getProperty name="rPH" property="pgTTEW"/></strong></font></td></tr>
   <tr><td nowrap><font color="#CC3366" size="2"><strong>YEW:</strong></font></td><td><font color="#CC3366" size="2"><strong><jsp:getProperty name="rPH" property="pgYYEW"/></strong></font></td></tr>
   <tr><td nowrap><font color="#CC3366" size="2"><strong>I-ILAN:</strong></font></td><td><font color="#CC3366" size="2"><strong><jsp:getProperty name="rPH" property="pgIILAN"/></strong></font></td></tr>
   <tr><td nowrap><font color="#CC3366" size="2"><strong>S-ILAN:</strong></font></td><td><font color="#CC3366" size="2"><strong><jsp:getProperty name="rPH" property="pgSILAN"/></strong></font></td></tr>
   <tr><td nowrap><font color="#CC3366" size="2"><strong>O-ILAN:</strong></font></td><td><font color="#CC3366" size="2"><strong><jsp:getProperty name="rPH" property="pgOILAN"/></strong></font></td></tr>
   <tr><td nowrap><font color="#CC3366" size="2"><strong>NBU:</strong></font></td><td><font color="#CC3366" size="2"><strong><jsp:getProperty name="rPH" property="pgNTaipei"/></strong></font></td></tr> 
  </table>
 </td> 
</tr>
</table>

<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
<%
rsTC.close();
statementTC.close();
%>
</body>
</html>

