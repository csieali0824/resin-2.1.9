<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QryAllChkBoxEditBean,ArrayCheckBoxBean,ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
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
<%@ include file="/jsp/include/ConnILNAssistPoolPage.jsp"%>
<!--=================================-->
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="arrayChechBoxBean" scope="session" class="ArrayCheckBoxBean"/>
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



String dept=request.getParameter("DEPT");
String organizationId=request.getParameter("ORGPARID");
//String orderType=request.getParameter("ORDERTYPE");
String num=request.getParameter("NUM");

String sqlGlobal = "";

//if (dateStringBegin==null || dateStringBegin.equals(""))
//{ dateStringBegin = dateBean.getYearMonthDay(); }


%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
  
<FORM ACTION="../jsp/ILNAssistEmpPrinterOpSalary.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#003366"  size="+2" face="Times New Roman"> 
<strong>宜蘭事務機作業員薪資核算確認</strong></font>
<BR>
  <A href="/oradds/ORAddsMainMenu.jsp">回首頁</A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = " and EMPLOYNO > '0' ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if (dateStringBegin==null || dateStringBegin.equals(""))
{
    sSql = "select EMPLOYNO, CNAME, SALARYADD01, SALARYADD02, SALARYADD03, SALARYADD04, SALARYADD05, SALARYADD06, SALARYADD07, SALARYADD08, SALARYADD09, SALARYADD10, SALARYADDTL, "+
                  "SALARYDEL01, SALARYDEL02, SALARYDEL03, SALARYDEL04, SALARYDEL05, SALARYDEL06, SALARYDEL07, SALARYDEL08, SALARYDEL09, SALARYDEL10, SALARYDELTL, "+	
				  "EMPLOYNO+' '+YEARS+' '+MONTH as CHKKEY "+			 
		  "from SALARYMONTH ";
   sSqlCNT = "select count(EMPLOYNO) as CaseCount from SALARYMONTH   ";
   sWhere =  "where DEPT = '551' and YEARS ='"+YearFr+"' and MONTH = '"+MonthFr+"' "+            
			   "and NUM = '"+num+"' ";			        
   sOrder = "order by EMPLOYNO ";

   SWHERECOND = sWhere + sWhereGP;
   sSql = sSql + sWhere + sWhereGP + sOrder;
   sSqlCNT = sSqlCNT + sWhere + sWhereGP;   
   //out.println("sSql="+ sSql);   
   
   try
        {		
         Statement statement1=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
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
   sSql = "select EMPLOYNO, CNAME, SALARYADD01, SALARYADD02, SALARYADD03, SALARYADD04, SALARYADD05, SALARYADD06, SALARYADD07, SALARYADD08, SALARYADD09, SALARYADD10, SALARYADDTL, "+
                  "SALARYDEL01, SALARYDEL02, SALARYDEL03, SALARYDEL04, SALARYDEL05, SALARYDEL06, SALARYDEL07, SALARYDEL08, SALARYDEL09, SALARYDEL10, SALARYDELTL, "+				 
				  "EMPLOYNO+' '+YEARS+' '+MONTH as CHKKEY "+
		  "from SALARYMONTH ";
   sSqlCNT = "select count(EMPLOYNO) as CaseCount from SALARYMONTH   ";
   sWhere =  "where DEPT = '551' and YEARS ='"+YearFr+"' and MONTH = '"+MonthFr+"' "+            
			   "and NUM = '"+num+"' ";			        
   sOrder = "order by EMPLOYNO ";
  
  //if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and TO_CHAR(OOHA.CREATION_DATE,'YYYYMMDD') >="+"'"+dateSetBegin+"'";
  //if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and TO_CHAR(OOHA.CREATION_DATE,'YYYYMMDD') between "+"'"+dateSetBegin+"'"+" and "+"'"+dateSetEnd+"'";
   

  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereGP + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP;
  //out.println(sSql);    
   
   String sqlOrgCnt = "select count(EMPLOYNO) as CaseCountORG from SALARYMONTH ";
   sqlOrgCnt = sqlOrgCnt + sWhere + sWhereGP;
   Statement statement2=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
   ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
   if (rs2.next())
   {
     CaseCountORG = rs2.getInt("CaseCountORG");     
   }
   rs2.close();
   statement2.close();

   try
   {       	 
		
         Statement statement3=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
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
Statement statementTC=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY); 
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
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
     <tr><td width="35%" bgcolor="#FFFF99"><font face="Arial" color="#000066"><span class="style1">&nbsp;</span>部門</font>
			   <%
			       try
                   {   
		             Statement statement=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY); 
                     ResultSet rs=null;	
			         String sql = "select WORKCODE, WORKCODE +'('+WORKNAME+')' "+
			                      "from DEPT "+
			                      "where DIVISION = '2' "+		
								  "order by 1 ";  			  
                     rs=statement.executeQuery(sql);
		             comboBoxBean.setRs(rs);
		             comboBoxBean.setSelection(dept);
	                 comboBoxBean.setFieldName("DEPT");	   
                     out.println(comboBoxBean.getRsString());				    
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }                     
			   %>
		     </td>
			 <td bgcolor="#FFFF99" bordercolor="#CCCCFF"  colspan="2"><font color="#000066" face="Arial"><span class="style1">&nbsp;</span>發薪年份</font>
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
    <font color="#000066" face="Arial"><span class="style1">&nbsp;</span>月份</font> 
	<%		     			 
				 try
                 {   
		           Statement stateMon=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                   ResultSet rsMon=null;		      
									  
				   String sql = "select DISTINCT MONTH, MONTH as MON "+
			                    " from SALARYMONTH ";			                    				   
			  
                   rsMon=stateMon.executeQuery(sql);
		           out.println("<select NAME='MONTHFR' onChange='setSubmit2("+'"'+"../jsp/ILNAssistEmpPrinterOpSalary.jsp"+'"'+")'>");
		           out.println("<OPTION VALUE=-->--");     
		           while (rsMon.next())
		           {            
		             String s1=(String)rsMon.getString(1); 
		             String s2=(String)rsMon.getString(2); 
                     
		             if (s1==MonthFr || s1.equals(MonthFr)) 
  		             {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
					  //priceListCode = s1; 					                                 
                     } else {
                             out.println("<OPTION VALUE='"+s1+"'>"+s2);
                            }        
		            } //end of while
		            out.println("</select>"); 
				    stateMon.close();		  		  
		            //rsMon.close();        	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage());
				  }  
			  %>	
        </td> 
	 </tr>
     <tr bgcolor="#FFFF99">
	     <td bgcolor="#FFFF99" colspan="2"><font face="Arial" color="#000066"><span class="style1">&nbsp;</span>次數</font>
			    <%
		         try
                 {   
		           Statement stateNum=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                   ResultSet rsNum=null;	
			       String sqlOrgInf = "select DISTINCT NUM, NUM as NUMBER "+
			                          "from SALARYMONTH "+
			                          "where YEARS = '"+YearFr+"' and MONTH = '"+MonthFr+"'  "+								  
								      "order by NUM ";  
			  
                   rsNum=stateNum.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rsNum);
		           comboBoxBean.setSelection(num);
	               comboBoxBean.setFieldName("NUM");	   
                   out.println(comboBoxBean.getRsString());		
				   stateNum.close();		  		  
		           //rsNum.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		       %>
			 </td> 
			 <td width="24%">
		      <INPUT TYPE="button" align="middle"  value='查詢' onClick='setSubmit("../jsp/ILNAssistEmpPrinterOpSalary.jsp")' >   
	         </td>           	
   </tr>
   <tr>
             <td bgcolor="#FFFF99" colspan="3"><font face="Arial" color="#000066"><span class="style1">&nbsp;</span>考勤區間</font>
			    <%
		         try
                 {   
		           Statement stateDateRange=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                   ResultSet rsDateRange=null;	
			       String sqlOrgInf = "select DISTINCT DATERANGE "+
			                          "from SALARYMONTH "+
			                          "where YEARS = '"+YearFr+"' and MONTH = '"+MonthFr+"'  "+								  
								      "order by DATERANGE ";  
			  
                   rsDateRange=stateDateRange.executeQuery(sqlOrgInf);
		           if (rsDateRange.next())
				   {
				      out.println("<font color='#FF0000' face='Arial'>"+rsDateRange.getString("DATERANGE")+"</font>");
				   } else {
				             out.println("<font color='#FF0000' >尚未結薪</font>");       
				          }	                     			     		  
		           rsDateRange.close();   
				   stateDateRange.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		       %>
			 </td>
			 
   </tr>
  </table>  
 
  <table cellspacing="0" bordercolordark="#FFFFFF" cellpadding="1" width="100%" align="center" bordercolorlight="#999999" border="1">
  </table>    
  <table cellSpacing="0" bordercolordark="#FFCC99" cellPadding="1" width="100%" align="center" bordercolorlight="#FFFF99" border="1">
   <tbody>
    <tr bgcolor="#FFFF99"> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#000000" size="-1">&nbsp;</font></div></td>
	  <td width="2%"  height="19" nowrap><div align="center"><font color="#330099" face="Arial" size="-1"><strong>OK</strong></font></div></td>   
      <td width="5%" height="22" nowrap><div align="center"><font color="#330099" face="Arial" size="-1">員工編號</font></div></td> 
	  <td width="6%" height="22" nowrap><div align="center"><font color="#330099" face="Arial" size="-1">中文姓名</font></div></td>           
      <td width="85%" nowrap><div align="center"><font color="#330099" face="Arial" size="-1">薪資明細</font></div></td>               
    </tr>
    <% 
	   int newSalaryAddTL = 0;
	   int newSalaryDelTL = 0;
	   String employeeNo= null;
	   while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "FFFFDD";
	     }
	    else{
	       colorStr = "FFFFCC"; }
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td><div align="center"><font size="-1" color="#003399"><%out.println(rs1__index+1);%></font></div></td>	  
	  <td height="20"><div align="center"><font size="2" color="#000000">	               
		  <input type="checkbox" name="CHKFLAG" value="<%=rsTC.getString("EMPLOYNO")%>">
          </font></div>
	  </td>     
	  <td nowrap><font size="-1"><% employeeNo=rsTC.getString("EMPLOYNO"); 
									out.println(employeeNo); 
								%></font></td>
	  <td nowrap><font size="-1"><%=rsTC.getString("CNAME") %></font></td>         
      <td width="85%" nowrap><font size="-1">
	  <!--%=rsTC.getString("HEADER_ID")%-->
	        <table cellspacing="0" bordercolordark="#FFFFFF" cellpadding="1" width="100%" align="center" bordercolorlight="#999999" border="1">
			    <tr>
				     <td rowspan="2">加項</td><td>01.本薪</td><td>02.加給</td><td>03.績效獎金</td><td>04.全勤獎金</td><td>05.伙食津貼</td><td>06.交通津貼</td><td>07.夜班津貼</td><td>08.加班費</td><td>09.不休假獎金</td><td>10.持股獎勵</td><td>應發總額</td>	 					                    
				</tr>
				<tr><td><%=rsTC.getInt("SALARYADD01")%></td><td><%=rsTC.getInt("SALARYADD02")%></td><td><%=rsTC.getInt("SALARYADD03")%></td><td><%=rsTC.getInt("SALARYADD04")%></td><td><%=rsTC.getInt("SALARYADD05")%></td><td><%=rsTC.getInt("SALARYADD06")%></td><td><%=rsTC.getInt("SALARYADD07")%></td>
				    <td><% 
					      // 修正加班費,先抓出當月最新序號之原計算依據   
						    int oldSalaryAdd08 = rsTC.getInt("SALARYADD08");
						    int fixSalaryAdd08 = 0;
							int newSalaryAdd08 = 0; 
							out.println("<font color='#FF0000'><strong>"+oldSalaryAdd08+"--></strong></font>");
						    try
                            {   
		                      Statement stateAdd08=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                              ResultSet rsAdd08=null;	
			                  String sqlAdd08 = "select SALARYAMTS,SALARYMARK "+
			                                     "from SALARYMONTHLOG "+
			                                     "where EMPLOYNO='"+employeeNo+"' and YEARS = '"+YearFr+"' and MONTH = '"+MonthFr+"'  and ITEMNUM like '18%' "+		
												   "and NUM = (select max(NUM) from SALARYMONTHLOG where EMPLOYNO= '"+employeeNo+"' and YEARS = '"+YearFr+"' and MONTH = '"+MonthFr+"'  and ITEMNUM like '18%' ) ";		  
								               
			                
                            rsAdd08=stateAdd08.executeQuery(sqlAdd08);
		                    while (rsAdd08.next())
							{ 
							   newSalaryAdd08=rsAdd08.getInt("SALARYAMTS")*(30*8)/248;   // 先乘回去舊的計算因子(30天*8hr),再除以新的(248)
								//out.println("newSalaryDel06="+newSalaryDel06);
							   fixSalaryAdd08 = fixSalaryAdd08 + newSalaryAdd08; // 總加班費 = 當次原因加總
							}	
							rsAdd08.close();
				            stateAdd08.close();	     
							out.println("<font color='#FF0000'><strong>"+fixSalaryAdd08+"</strong></font>");       	 
                           } //end of try		 
                           catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
						   
					    %>
					</td>
					<td><%=rsTC.getInt("SALARYADD09")%></td><td><%=rsTC.getInt("SALARYADD10")%></td>
					<td><% int oldSalaryAddTL = rsTC.getInt("SALARYADDTL"); 
					       newSalaryAddTL = oldSalaryAddTL + (oldSalaryAdd08-fixSalaryAdd08);
					       out.println("<font color='#FF0000'>"+oldSalaryAddTL+" --> "+newSalaryAddTL+"</font>");
						%>
				    </td></tr>			
			    <tr height="100%">
				     <td rowspan="2">減項</td><td>01.所得稅</td><td>02.勞保費</td><td>03.健保費</td><td>04.伙食費</td><td>05.職工福利</td><td>06.缺勤扣薪</td><td>07.持股提撥</td><td>08.持股獎勵</td><td>09.自提額</td><td>10.公提額</td><td>應扣總額</td>		 					                    
				</tr>
				<tr><td><%=rsTC.getInt("SALARYDEL01")%></td><td><%=rsTC.getInt("SALARYDEL02")%></td><td><%=rsTC.getInt("SALARYDEL02")%></td><td><%=rsTC.getInt("SALARYDEL04")%></td><td><%=rsTC.getInt("SALARYDEL05")%></td>
				    <td><% 
					       int oldSalaryDel06=rsTC.getInt("SALARYDEL06");
						   int fixSalaryDel06 = 0;
						   int newSalaryDel06 = 0;
						   
						   out.println("<font color='#FF0000'><strong>"+oldSalaryDel06+"--></strong></font>");
						    try
                            {   
		                      Statement stateDel06=ilnAsistcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                              ResultSet rsDel06=null;	
			                  String sqlDel06 = "select SALARYAMTS,SALARYMARK "+
			                                     "from SALARYMONTHLOG "+
			                                     "where EMPLOYNO='"+employeeNo+"' and YEARS = '"+YearFr+"' and MONTH = '"+MonthFr+"'  and ITEMNUM like '26%' "+	
												 "and NUM = (select max(NUM) from SALARYMONTHLOG where EMPLOYNO= '"+employeeNo+"' and YEARS = '"+YearFr+"' and MONTH = '"+MonthFr+"'  and ITEMNUM like '26%' ) ";		  
							 //out.println(sqlDel06);	               
			                 
                             rsDel06=stateDel06.executeQuery(sqlDel06);
		                     while (rsDel06.next())
							 {
							    newSalaryDel06=rsDel06.getInt("SALARYAMTS")*(30*8)/248;   // 先乘回去舊的計算因子(30天*8hr),再除以新的(248)
								//out.println("newSalaryDel06="+newSalaryDel06);
								fixSalaryDel06 = fixSalaryDel06 + newSalaryDel06; // 總缺勤扣薪 = 當次原因加總
							 }
							 rsDel06.close();
				             stateDel06.close();	
							 out.println("<font color='#FF0000'><strong>"+fixSalaryDel06+"</strong></font>");    	 
                           } //end of try		 
                           catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
						 //*/
					    %>
					</td>
					<td><%=rsTC.getInt("SALARYDEL07")%></td><td><%=rsTC.getInt("SALARYDEL08")%></td><td><%=rsTC.getInt("SALARYDEL09")%></td><td><%=rsTC.getInt("SALARYDEL10")%></td>
					<td><%//out.println("<font color='#FF0000'>"+rsTC.getInt("SALARYDELTL")+"</font>");
					      int oldSalaryDelTL = rsTC.getInt("SALARYDELTL"); 
					      newSalaryDelTL = oldSalaryDelTL + (oldSalaryDel06-fixSalaryDel06);
					      out.println("<font color='#FF0000'>"+oldSalaryDelTL+" --> "+newSalaryDelTL+"</font>");   
					    %>
					</td>					
					</tr>
			</table>
	  </font></td>           
    </tr>
    <%
      rs1__index++;
      rs_hasDataTC = rsTC.next();
              qryAllChkBoxEditBean.setPageURL("../jsp/ILNAssistEmpPrinterOpSalary.jsp");
              qryAllChkBoxEditBean.setSearchKey("EMPLOYNO");
              qryAllChkBoxEditBean.setFieldName("FIRMFLAG");
              qryAllChkBoxEditBean.setRowColor1("B0E0E6");
              qryAllChkBoxEditBean.setRowColor2("ADD8E6");
              qryAllChkBoxEditBean.setRs(rsTC);   
}
%>
    <tr bgcolor="#FFFF99"> 
      <td height="23" colspan="5" ><font color="#330099" size="-1">未確認筆數</font> 
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
    <div align="center"><font color="#993366" size="2"><strong>目前查無符合查詢條件的資料</strong></font></div>
    <% } else {
	           %>
			   <div align="left"><input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value="全選"></div> 
			   <%                    
	          }
	/*若有資料則顯示可全選擇的按鈕 */ %>    
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=sWhere%>" maxlength="256" size="256">
<BR>
<div align="left"><input name="submit2" type="submit" value="批次更新結算薪資" onClick='return setSubmit2("../jsp/ILNAssistEmpPrinterOpSalaryConfirm.jsp")'></div>
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
<%@ include file="/jsp/include/ReleaseConnILNAssistPage.jsp"%>
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
