<!--modify by Peggy 20150105,年度下拉選單程式改寫-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
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
</script>
<html>
<head>

<title>Oracle Add On System Information Query</title>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
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
String sWhereGP = "";
String sOrder = "";

String havingGrp = "";

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
      if (dateSetBegin==null) dateSetBegin=YearFr+MonthFr+DayFr;  

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
      if (dateSetEnd==null) dateSetEnd=YearTo+MonthTo+DayTo; 


String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");
String spanning=request.getParameter("SPANNING");
String wipEntID=request.getParameter("WIPENTID");
String invItem=request.getParameter("INVITEM");

String organizationId=request.getParameter("ORGANIZATION_ID");
String organizationCode=request.getParameter("ORGANIZATION_CODE");

if (organizationId==null || organizationId.equals("")) { organizationId="44"; }


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


%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
</head>
<body topmargin="0" bottommargin="0">  
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>  
<FORM ACTION="../jsp/TSCInvORGSubInventoryNBQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong>Organization Inventory Non-Balance Query</strong></font>
<%
 
  sWhereGP = " and T.ORGANIZATION_ID > 0 ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  String currentWeek = workingDateBean.getWeekString();

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")))
{
//20110103 liling update for performance issue
/*
   sSql = "select T.INVENTORY_ITEM_ID, M.SEGMENT1, M.DESCRIPTION, SUM(T.PRIMARY_QUANTITY) as SUMQTY "+                 
		  "from MTL_MATERIAL_TRANSACTIONS T, MTL_SYSTEM_ITEMS_B M ";
   sSqlCNT = "select sum(count(DISTINCT M.SEGMENT1)) as CaseCount from MTL_MATERIAL_TRANSACTIONS T,MTL_SYSTEM_ITEMS_B M ";
   sWhere =  "WHERE T.INVENTORY_ITEM_ID = M.INVENTORY_ITEM_ID AND T.ORGANIZATION_ID = M.ORGANIZATION_ID "+
             "AND T.ORGANIZATION_ID='44' AND TRANSACTION_TYPE_ID != 52 "+	 
			 "and TO_CHAR(TRANSACTION_DATE,'YYYYMMDD')>='"+strFirstDayWeek+"' AND TO_CHAR(TRANSACTION_DATE,'YYYYMMDD')<'"+strLastDayWeek+"' ";
   havingGrp = "GROUP BY T.INVENTORY_ITEM_ID,M.SEGMENT1,M.DESCRIPTION HAVING SUM(PRIMARY_QUANTITY) != 0 ";                  
   sOrder = "ORDER BY T.INVENTORY_ITEM_ID ";     

   SWHERECOND = sWhere + sWhereGP + havingGrp;
   sSql = sSql + sWhere + sWhereGP + havingGrp + sOrder;
   sSqlCNT = sSqlCNT + sWhere + sWhereGP + havingGrp;   
   //out.println("sSql="+ sSql);   
 */
  sSql = " SELECT '' INVENTORY_ITEM_ID, '' SEGMENT1, '' DESCRIPTION, ''  SUMQTY FROM dual ";
  sSqlCNT =" SELECT 0  CaseCount FROM dual "; 

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
   sSql = "select T.INVENTORY_ITEM_ID, M.SEGMENT1, M.DESCRIPTION, SUM(T.PRIMARY_QUANTITY) as SUMQTY "+                 
		  "from MTL_MATERIAL_TRANSACTIONS T,MTL_SYSTEM_ITEMS_B M ";
   sSqlCNT = "select sum(count(DISTINCT M.SEGMENT1)) as CaseCount from MTL_MATERIAL_TRANSACTIONS T, MTL_SYSTEM_ITEMS_B M ";
   sWhere =  "WHERE T.INVENTORY_ITEM_ID = M.INVENTORY_ITEM_ID AND T.ORGANIZATION_ID = M.ORGANIZATION_ID "+
          //   "AND to_chaar(T.ORGANIZATION_ID)='"+organizationId+"' AND TRANSACTION_TYPE_ID != 52 ";	//20120203 liling for fong issue
             "AND T.ORGANIZATION_ID='"+organizationId+"' AND TRANSACTION_TYPE_ID not in (52,10008) ";				 		   
   havingGrp = "GROUP BY T.INVENTORY_ITEM_ID,M.SEGMENT1,M.DESCRIPTION HAVING SUM(PRIMARY_QUANTITY) != 0 ";			                 
   sOrder = "ORDER BY T.INVENTORY_ITEM_ID ";     
  
  if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and TO_CHAR(TRANSACTION_DATE,'YYYYMMDD') >="+"'"+dateSetBegin+"'";
  if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and TO_CHAR(TRANSACTION_DATE,'YYYYMMDD') >= "+"'"+dateSetBegin+"'"+" AND TO_CHAR(TRANSACTION_DATE,'YYYYMMDD') <= "+"'"+dateSetEnd+"'";
  
  if (invItem==null || invItem.equals("")) {sWhere=sWhere+" ";}
  else { sWhere=sWhere+" and M.SEGMENT1 ='"+invItem+"'"; }
   

  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereGP + havingGrp + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP + havingGrp;
  //out.println("sSqlTT="+sSql);    
   
   String sqlOrgCnt = "select sum(count(DISTINCT M.SEGMENT1)) as CaseCountORG from MTL_MATERIAL_TRANSACTIONS T, MTL_SYSTEM_ITEMS_B M ";
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
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
     <tr>
	    <td bordercolor="#CCCCFF" nowrap colspan="2"><font color="#006666"><strong>Organization</strong></font>
          <%				  
		   //String APPLICATION_ID="";		 		 
	       try
           {   
		      Statement statement=con.createStatement();
              ResultSet rs=null;	
			  String sqlOrgInf = "select a.ORGANIZATION_ID as ORGANIZATION_ID, a.ORGANIZATION_ID||'('||a.ORGANIZATION_CODE||'-'||b.NAME||')' as ORGANIZATION_CODE "+
			                     "from MTL_PARAMETERS a, HR_ORGANIZATION_UNITS b, PER_ORG_STRUCTURE_ELEMENTS c, HR_ORGANIZATION_UNITS d "+
			                     "where a.ORGANIZATION_ID=b.ORGANIZATION_ID and a.ORGANIZATION_ID=c.ORGANIZATION_ID_CHILD "+
								 "and c.ORGANIZATION_ID_PARENT = d.ORGANIZATION_ID "+
								// "order by to_number(substr(a.ORGANIZATION_CODE,2,3)) ";  
								 "order by a.ORGANIZATION_CODE  ";  								 
			  
              rs=statement.executeQuery(sqlOrgInf);
		  
		      out.println("<select NAME='ORGANIZATION_ID' onChange='setSubmit("+'"'+"../jsp/TSCInvORGSubInventoryNBQuery.jsp"+'"'+")'>");
		      out.println("<OPTION VALUE=-->--");     
		      while (rs.next())
		        {            
		          String s1=(String)rs.getString(1); 
		          String s2=(String)rs.getString(2); 
                        
		          if (s1.equals(organizationId)) 
  		          {
                     out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);   
					 organizationCode = s2;                                  
                  } else {
                     out.println("<OPTION VALUE='"+s1+"'>"+s2);
                  }        
		        } //end of while
		      out.println("</select>"); 	  		  		  
		      rs.close();        	 
           } //end of try		 
           catch (Exception e) { out.println("Exception:"+e.getMessage()); }
         %>
        </td> 
		<td>
		   <div align="left">
		   <font color="#006666"><strong>Inventory Item </strong></font><input type="text" name="INVITEM">
		   </div>
		</td>    
	 </tr>
     <tr>	    
	   <td width="26%" bordercolor="#CCCCFF" nowrap><font color="#006666"><strong>Date From</strong></font>
        <%
		 // String CurrYear = null;	     		 
	     //try
         //{       
         // String a[]={"2006","2007","2008","2009","2010","2011","2012","2013","2014"};
         // arrayComboBoxBean.setArrayString(a);
		 // if (YearFr==null)
		 // {
		 //   CurrYear=dateBean.getYearString();
         //
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
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2006+1];
			for (int i = Integer.parseInt(dateBean.getYearString()) ; i >=2006 ; i--)
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
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
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
    </td>  
	<td width="28%" bordercolor="#CCCCFF" nowrap><font color="#006666"><strong>Date To</strong></font>
        <%
		 // String CurrYearTo = null;	     		 
	     //try
         //{       
         // String a[]={"2006","2007","2008","2009","2010","2011","2012","2013","2014"};
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
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2006+1];
			for (int i =Integer.parseInt(dateBean.getYearString()) ; i >= 2006 ; i--)
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
	<td width="46%" bordercolor="#CCCCFF">
		    <INPUT TYPE="button" align="middle"  value='查詢' onClick='setSubmit("../jsp/TSCInvORGSubInventoryNBQuery.jsp")' >   
	</td>
   </tr>
  </table>  
 
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
    <tr bgcolor="#99CC99"> 
	  <td width="4%" height="22" nowrap><div align="center"><font color="#000000" size="-1">&nbsp;</font></div></td> 
	  <td width="4%" height="22" nowrap><div align="center"><font color="#000000" size="-1">&nbsp;</font></div></td>               
      <td width="8%" nowrap><div align="center"><font color="#006666" size="-1">Item ID</font></div></td>
      <td width="64%" nowrap><div align="center"><font color="#006666" size="-1">Inventory Item</font></div></td>      
      <td width="16%" nowrap><div align="center"><font color="#006666" size="-1">Description</font></div></td>
      <td width="8%" nowrap><div align="center"><font color="#006666" size="-1">Sum Q'ty</font></div></td>                     
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "CCFFCC";
	     }
	    else{
	       colorStr = "CCFFFF"; }
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#99CC99"><div align="center"><font size="-1" color="#006666"><%out.println(rs1__index+1);%></font></div></td>
	  <td><div align="center"><a href="../jsp/TSCInvTransactionDetailPage.jsp?ORGID=<%=organizationId%>&ORGCODE=<%=organizationCode%>&INVITEMID=<%=rsTC.getString("INVENTORY_ITEM_ID")%>&DATEBEGIN=<%=dateSetBegin%>&DATEEND=<%=dateSetEnd%>"><img src="../image/docicon.gif" width="14" height="15" border="0"></a></div></td>     	        
      <td width="8%" nowrap><font size="-1" color="#006666"><%=rsTC.getString("INVENTORY_ITEM_ID")%></font></td>
      <td width="64%" nowrap><font size="-1" color="#006666">
	          <%  // out.println(rsTC.getString("SEGMENT1"));
			  
			  //out.println("wipEntID="+wipEntID);out.println("rsTC.getString(INVENTORY_ITEM_ID)="+rsTC.getString("INVENTORY_ITEM_ID"));
			       String subColStr = "";
			       if ((rs1__index % 2) == 0)
				   { subColStr = "CCFFFF"; }
	               else{ subColStr = "CCFFCC"; }			    
			       out.println("<table width='100%' height='100%' bordercolor='#006699'>");			 
			       if ( spanning==null || spanning.equals("") || spanning=="FALSE" || spanning.equals("FALSE")  )
			       {
			          out.print("<tr><td nowrap>"); out.println("<font size='-1' color='#006666'>"+rsTC.getString("SEGMENT1")+"</font>"); %><a href="../jsp/TSCInvORGSubInventoryNBQuery.jsp?SPANNING=TRUE&ORGANIZATION_ID=<%=organizationId%>&WIPENTID=<%=rsTC.getString("INVENTORY_ITEM_ID")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>"><img src="../image/PLUS.gif" width="14" height="15" border="0"></a><% out.println("</td></tr>");
			       } else if ( spanning!= null && (spanning=="TRUE" || spanning.equals("TRUE") ) )
			              {			    
				             //再判段若是 Entity ID 才顯示明細,點擊符號顯示 MINUS 
				             if ( wipEntID ==rsTC.getString("INVENTORY_ITEM_ID") || wipEntID.equals(rsTC.getString("INVENTORY_ITEM_ID")) )
				             { //out.println("wipEntID="+wipEntID);out.println("rsTC.getString(INVENTORY_ITEM_ID)="+rsTC.getString("INVENTORY_ITEM_ID"));
				               out.print("<tr><td nowrap>"); out.println("<font size='-2' color='#CC0000'><strong>"+rsTC.getString("SEGMENT1")+"</strong></font>");  %><a href="../jsp/TSCInvORGSubInventoryNBQuery.jsp?SPANNING=FALSE&ORGANIZATION_ID=<%=organizationId%>&WIPENTID=<%=rsTC.getString("INVENTORY_ITEM_ID")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>"><img src="../image/MINUS.gif" width="14" height="15" border="0"></a><% out.println("</td></tr>");
				               int iRow = 0;
							   /* 
				               String sqlM = "select DISTINCT TRANSACTION_TYPE_NAME, DESCRIPTION, RCV_TRANSACTION_ID, R.RECEIPT_NUM, VENDOR_ID, PACKING_SLIP, EMPLOYEE_ID, RECEIVER, PRIMARY_QUANTITY "+
				                             "from MTL_MATERIAL_TRANSACTIONS T,MTL_TRANSACTION_TYPES_COPY C,RCV_VRC_HDS_V R "+
							                 "where T.TRANSACTION_TYPE_ID = C.TRANSACTION_TYPE_ID "+
											   "and T.TRANSACTION_TYPE_ID != 52 "+
											   "and R.ORGANIZATION_ID = T.ORGANIZATION_ID "+											   
											   "and T.ORGANIZATION_ID  ='"+organizationId+"' "+											   
							                   "and T.INVENTORY_ITEM_ID = '"+rsTC.getString("INVENTORY_ITEM_ID")+"' "+
											   "and to_char(transaction_date,'YYYYMMDD') between '"+dateSetBegin+"' and '"+dateSetEnd+"' "+
											   "and to_char(RECEIPT_DATE,'YYYYMMDDHH24MI') = to_char(T.CREATION_DATE,'YYYYMMDDHH24MI') ";
				               Statement stateM=con.createStatement();
							   //out.println(sqlM);
                               ResultSet rsM=stateM.executeQuery(sqlM); 							  
				               while (rsM.next())
				               {
							    if (iRow==0 ) // 若第一筆資料才列印標頭列 //
								{ out.println("<tr bgcolor='#CC3366'><td nowrap><font size='-2' color='#FFFFFF'>Transaction Type Name</font></td><td nowrap><font size='-2' color='#FFFFFF'>Description</font></td><td nowrap><font size='-2' color='#FFFFFF'>RCV Trans. ID</font></td><td nowrap><font size='-2' color='#FFFFFF'>Receipt No.</font></td><td nowrap><font size='-2' color='#FFFFFF'>Vendor ID</font></td><td nowrap><font size='-2' color='#FFFFFF'>Pick SlipNo.</font></td><td nowrap><font size='-2' color='#FFFFFF'>EmpID</font></td><td nowrap><font size='-2' color='#FFFFFF'>Receiver</font></td><td nowrap><font size='-2' color='#FFFFFF'>Primary Q'ty</font></td></tr>");}
								
				                out.println("<tr bgcolor="+subColStr+">");
				                out.println("<td nowrap><font size='-2' color='#006666'>"+rsM.getString("TRANSACTION_TYPE_NAME")+"</font></td><td nowrap><font size='-2' color='#006666'>"+rsM.getString("DESCRIPTION")+"</font></td><td nowrap><font size='-2' color='#CC0066'>"+rsM.getString("RCV_TRANSACTION_ID")+"</font></td><td nowrap><font size='-2' color='#006666'>"+rsM.getString("RECEIPT_NUM")+"</font></td><td nowrap><font size='-2' color='#006666'>"+rsM.getString("VENDOR_ID")+"</font></td><td nowrap><font size='-2' color='#006666'>"+rsM.getString("PACKING_SLIP")+"</font></td><td nowrap><font size='-2' color='#006666'>"+rsM.getString("EMPLOYEE_ID")+"</font></td><td nowrap><font size='-2' color='#006666'>"+rsM.getString("RECEIVER")+"</font></td><td nowrap><font size='-2' color='#006666'>"+rsM.getFloat("PRIMARY_QUANTITY")+"</font></td>");
				                out.println("</tr>");
								
								iRow++;
				               }
				               rsM.close();
				               stateM.close();
							  */							   
				             }  else {  // 否則只顯示 PLUS 符號
				                        out.print("<tr><td nowrap>"); out.println("<font size='-1' color='#006666'>"+rsTC.getString("SEGMENT1")+"</font>");  %><a href="../jsp/TSCInvORGSubInventoryNBQuery.jsp?SPANNING=TRUE&ORGANIZATION_ID=<%=organizationId%>&WIPENTID=<%=rsTC.getString("INVENTORY_ITEM_ID")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>"><img src="../image/PLUS.gif" width="14" height="15" border="0"></a><% out.println("</td></tr>");    
										
				                     }  // End of else
			            }  // End of else if (spannin==null)
			            out.println("</table>");   
			  
			  
			  %></font></td>      
      <td width="16%" nowrap><font size="-1" color='#006666'><%=rsTC.getString("DESCRIPTION")%></font></td>  
	  <td width="8%" nowrap><div align="right"><strong><font size="-1" color="#CC3366"><%=rsTC.getFloat("SUMQTY")%></font></strong></div></td>                
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
}
%>
    <tr bgcolor="#99CC99"> 
      <td height="23" colspan="10" ><font color="#006666" size="-1">(第<%=currentWeek%>週)<%=organizationCode%>倉料項庫存不平衡筆數</font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly=""><%out.println("<font color='#000066'><strong><em>"+CaseCount+"</em></strong></font>");%> 
	 </td>      
    </tr>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="2">
    <% if (rs_isEmptyTC ) {  %>
    <strong>目前查無符合查詢條件的資料</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
<input type="hidden" name="SWHERECOND" value="<%=sWhere%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
</FORM>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveFirst%>">第一頁</A>]</strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_movePrev%>">上一頁</A>]</strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveNext%>">下一頁</A>]</strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveLast%>">最後一頁</A>]</strong></font></pre>
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
