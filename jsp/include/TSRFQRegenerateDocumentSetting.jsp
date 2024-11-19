<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
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

<title>Oracle Add On System Information Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
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

String intType=request.getParameter("INTTYPE");
String packClass=request.getParameter("PACKCLASS");

String salesOrderNo=request.getParameter("SALESORDERNO");

String sqlGlobal = "";

if (dateStringBegin==null || dateStringBegin.equals(""))
{ dateStringBegin = dateBean.getYearMonthDay(); }
if (salesOrderNo==null || salesOrderNo.equals("")) salesOrderNo="";

%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
  
<FORM ACTION="../jsp/TSDRQItemPackageCategorySetting.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#003366"  size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgSalesPlanner"/><jsp:getProperty name="rPH" property="pgSalesPlanner"/><jsp:getProperty name="rPH" property="pgApproval"/><jsp:getProperty name="rPH" property="pgOrdCreate"/></strong></font>
<BR>
  <A href="/oradds/ORAddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = " and a.LSTATUSID = '012' "; // 只找放棄的單據
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
 

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if (intType==null || intType.equals(""))
{
   
   sSql = "select d.LINE_NO,d.LSTATUS,d.ITEM_DESCRIPTION, d.QUANTITY,d.UOM, "+
                 "TO_CHAR(TO_DATE(d.REQUEST_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD'),"+
				 "d.PCCFMDATE,d.FTACPDATE, d.PCACPDATE, d.SASCODATE, d.ORDERNO,"+
                 "e.MANUFACTORY_NAME,d.REMARK "+
				 "from ORADDMAN.TSSALES_AREA b, "+
					  "ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";	
   sSqlCNT = "SELECT count(*) as CaseCount FROM ORADDMAN.TSSALES_AREA b,ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";		  									     
   sWhere = "where (d.LSTATUS = 'ABANDONING' ) "+
			  "and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
			  "and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='"+locale+"' ";				
   sOrder = "order by d.LINE_NO ";				   
											

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
   sSql = "select d.LINE_NO,d.LSTATUS,d.ITEM_DESCRIPTION, d.QUANTITY,d.UOM, "+
                 "TO_CHAR(TO_DATE(d.REQUEST_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD'),"+
				 "d.PCCFMDATE,d.FTACPDATE, d.PCACPDATE, d.SASCODATE, d.ORDERNO,"+
                 "e.MANUFACTORY_NAME,d.REMARK "+
				 "from ORADDMAN.TSSALES_AREA b, "+
					  "ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";	
   sSqlCNT = "SELECT count(*) as CaseCount FROM ORADDMAN.TSSALES_AREA b,ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";		  									     
   sWhere = "where (d.LSTATUS = 'ABANDONING' ) "+
			  "and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
			  "and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='"+locale+"' ";				
   sOrder = "order by d.LINE_NO ";				   
											
   
    if (salesOrderNo==null || salesOrderNo.equals("")) 
	{
	  if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and substr(d.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
      if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and substr(d.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(d.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'";  
	}
    else {  sWhere=sWhere+" and d.ORDERNO = '"+salesOrderNo+"' ";  } 

  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereGP + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP;
  //out.println(sSql);    
   
   String sqlOrgCnt = "select count(*) as CaseCountORG from ORADDMAN.TSSALES_AREA b,ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";
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
  <table cellSpacing="0" bordercolordark="#99CC99" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFCC"  border="1">    
  <tr>
	   <td><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgSalesOrderNo"/></strong></font></td>
	   <td colspan="3">
	        <input type="text" size="10" name="SALESORDERNO" value="<%=salesOrderNo%>">	        
	   </td>
	 </tr>
     <tr>	    
	   <td nowrap colspan="2"><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgCreateFormDate"/></strong></font>
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
       <font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgCreateFormDate"/></strong></font>
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
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSSDRQInformationQuery.jsp")' >   
	</td>
   </tr>
  </table> 
  <table cellSpacing="0" bordercolordark="#99CC99" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFCC"  border="1">
   <tbody>
    <tr bgcolor="#CCFFCC"> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#000000" size="-1">&nbsp;</font></div></td>
	  <td width="3%"  height="19" nowrap><div align="center"><font color="#006699" face="Arial" size="2"><strong><jsp:getProperty name="rPH" property="pgEdit"/></strong></font></div></td>   
      <td width="9%" height="22" nowrap><div align="center"><font color="#006699" face="Arial" size="-1"><jsp:getProperty name="rPH" property="pgAnItem"/></font></div></td>          
      <td width="10%" nowrap><div align="center"><font color="#006699" face="Arial" size="-1"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/></font></div></td>
      <td width="14%" nowrap><div align="center"><font color="#006699" face="Arial" size="-1"><jsp:getProperty name="rPH" property="pgUOM"/></font></div></td>      
      <td width="9%" nowrap><div align="center"><font color="#006699" face="Arial" size="-1"><jsp:getProperty name="rPH" property="pgQty"/></font></div></td>
      <td width="14%" nowrap><div align="center"><font color="#006699" face="Arial" size="-1"><jsp:getProperty name="rPH" property="pgRequestDate"/></font></div></td>      
      <td width="21%" nowrap><div align="center"><font color="#006699" face="Arial" size="-1"><jsp:getProperty name="rPH" property="pgPCAssignDate"/></font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#006699" face="Arial" size="-1"><jsp:getProperty name="rPH" property="pgFTArrangeDate"/></font></div></td>	
	  <td width="13%" nowrap><div align="center"><font color="#006699" face="Arial" size="-1"><jsp:getProperty name="rPH" property="pgPCConfirmDate"/></font></div></td>         
	  <td width="13%" nowrap><div align="center"><font color="#006699" face="Arial" size="-1"><jsp:getProperty name="rPH" property="pgRepStatus"/></font></div></td>
	  <td width="13%" nowrap><div align="center"><font color="#006699" face="Arial" size="-1"><jsp:getProperty name="rPH" property="pgProdFactory"/></font></div></td>
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
      <td bgcolor="#CCFFCC"><div align="center"><font size="-1" color="#006699"><%out.println(rs1__index+1);%></font></div></td>	  
	  <td height="20"><a href="../jsp/TSDRQItemPackageCategoryEdit.jsp?INTTYPE=<%=rsTC.getString("INT_TYPE")%>&PACKCLASS=<%=rsTC.getString("PACKING_CLASS")%>&OUTLINE=<%=rsTC.getString("OUTLINE")%>&PACKCODE=<%=rsTC.getString("PACKAGE_CODE")%>">
		      <div align="center"><img src="../image/docicon.gif" width="14" height="15" border="0"></div></a>
	  </td>      
	  <td nowrap><font size="-1"><%=rsTC.getString("LINE_NO") %></font></td>      
      <td width="10%" nowrap><font size="-1"><%=rsTC.getString("ITEM_DESCRIPTION")%></font></td>
      <td width="14%" nowrap><font size="-1"><%=rsTC.getString("UOM")%></font></td>
      <td width="9%" nowrap><font size="-1"><%=rsTC.getString("QUANTITY")%></font></td>
      <td width="14%" nowrap><font size="-1"><%=rsTC.getString(6)%></font></td>      
      <td width="21%" nowrap><font size="-1">
	  <%
	                   if (rsTC.getString("PCCFMDATE")==null || rsTC.getString("PCCFMDATE").equals("N/A")) out.println("N/A"); else out.println(rsTC.getString("PCCFMDATE").substring(0,4)+"/"+rsTC.getString("PCCFMDATE").substring(4,6)+"/"+rsTC.getString("PCCFMDATE").substring(6,8)); 
	  %></font></td>      
      <td width="13%" nowrap><font size="-1">
	  <%
	                 
	                   if (rsTC.getString("FTACPDATE")==null || rsTC.getString("FTACPDATE").equals("N/A")) out.println("N/A"); else out.println(rsTC.getString("FTACPDATE").substring(0,4)+"/"+rsTC.getString("FTACPDATE").substring(4,6)+"/"+rsTC.getString("FTACPDATE").substring(6,8)); 
	  %>  
	  %></font></td> 
	  <td width="13%" nowrap><font size="-1">
	  <%
	                   if (rsTC.getString("PCACPDATE")==null || rsTC.getString("PCACPDATE").equals("N/A")) out.println("N/A"); else out.println(rsTC.getString("PCACPDATE").substring(0,4)+"/"+rsTC.getString("PCACPDATE").substring(4,6)+"/"+rsTC.getString("PCACPDATE").substring(6,8)); 
	  %></font></td> 
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("LSTATUS")%></font></td> 
	  <td width="13%" nowrap><font size="-1"><%=rsTC.getString("MANUFACTORY_NAME")%></font></td>      
    </tr>
    <%
      rs1__index++;
      rs_hasDataTC = rsTC.next();
              qryAllChkBoxEditBean.setPageURL("../jsp/TSSalesAreaMapOrderTypeSetActive.jsp");
              qryAllChkBoxEditBean.setSearchKey("OKEY");
              qryAllChkBoxEditBean.setFieldName("CHKFLAG");
              qryAllChkBoxEditBean.setRowColor1("B0E0E6");
              qryAllChkBoxEditBean.setRowColor2("ADD8E6");
              qryAllChkBoxEditBean.setRs(rsTC);   
}
%>
    <tr bgcolor="#CCFFCC"> 
      <td height="23" colspan="10" ><font color="#006699" size="-1">總資料筆數</font> 
        <% 
	      if (CaseCount==0) 
		  { //若 	  
		  } 
		  else { 
		        out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>");
				// 若 有資料則顯示可全選的按鈕
				
			   }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5"  readonly=""><%out.println("<font color='#000099' face='Arial'><strong>"+CaseCount+"</strong></font>");%> 
	 </td>      
    </tr>
	<tbody>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->  
    <% if (rs_isEmptyTC ) {  %>
    <div align="center"><font color="#993366" size="2"><strong>No Record Found</strong></font></div>
    <% } else {
	           %>
			   <div align="left"></div> 
			   <%                    
	          }
	/*若有資料則顯示可全選擇的按鈕 */ %>    
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=sWhere%>" maxlength="256" size="256">
<BR>
<div align="left"></div>
</FORM>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#000066"><strong>[<A HREF="<%=MM_moveFirst%>"><jsp:getProperty name="rPH" property="pgFirst"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#000066"><strong>[<A HREF="<%=MM_movePrev%>"><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#000066"><strong>[<A HREF="<%=MM_moveNext%>"><jsp:getProperty name="rPH" property="pgNext"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#000066"><strong>[<A HREF="<%=MM_moveLast%>"><jsp:getProperty name="rPH" property="pgLast"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
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
