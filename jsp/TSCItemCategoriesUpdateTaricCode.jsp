<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QryAllChkBoxEditBean,ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean,ComboBoxBean"%>
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
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
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

String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");
String dateSetBegin=YearFr+MonthFr+DayFr;  

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
String dateSetEnd=YearTo+MonthTo+DayTo; 

String corCategory=request.getParameter("CORCATEGORY");
String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");
String prodClass=request.getParameter("PRODCLASS");

String organizationId=request.getParameter("ORGPARID");
String sqlGlobal = "";

String categoryId = "";
String categoryCode ="";

%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
  
<FORM ACTION="../jsp/TSCInvItemCategoryCorrection.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#003366"  size="+2" face="Times New Roman"> 
<strong>Item Category Taric Code Correction</strong></font>
<BR>
  <A href="/oradds/ORAddsMainMenu.jsp">回首頁</A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = " and C.ORGANIZATION_ID IS NOT NULL ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
 

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if (dateStringBegin==null || dateStringBegin.equals(""))
{
   sSql = "select C.ORGANIZATION_ID, C.CATEGORY_ID, I.ATTRIBUTE2, I.INVENTORY_ITEM_ID, I.SEGMENT1 || '('||I.INVENTORY_ITEM_ID||')' as SEGMENT1, I.SEGMENT1 as ITEMNO, "+
                 "I.CREATED_BY, TO_CHAR(I.CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') as CREATION_DATE, "+
                 "U.USER_NAME, P.ORGANIZATION_CODE,U.EMAIL_ADDRESS,TO_CHAR(C.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') as LAST_UPDATE_DATE, "+
				 "C.LAST_UPDATED_BY, RPAD(C.ORGANIZATION_ID,3,' ')||RPAD(I.INVENTORY_ITEM_ID,28,' ') as CORRKEY "+
		  "from MTL_ITEM_CATEGORIES C, MTL_SYSTEM_ITEMS I, MTL_PARAMETERS P, FND_USER U ";
   sSqlCNT = "select count(I.SEGMENT1) as CaseCount from MTL_ITEM_CATEGORIES C, MTL_SYSTEM_ITEMS_B I, MTL_PARAMETERS P, FND_USER U ";
   sWhere =  "where C.ORGANIZATION_ID = 43 AND CATEGORY_SET_ID = 6 AND C.ORGANIZATION_ID = P.ORGANIZATION_ID "+
             //"AND C.CATEGORY_ID NOT IN (SELECT CATEGORY_ID FROM CST_COST_GROUP_ASSIGNMENTS G, MTL_FISCAL_CAT_ACCOUNTS M "+
             //                          "WHERE G.COST_GROUP_ID=M.COST_GROUP_ID AND G.ORGANIZATION_ID = C.ORGANIZATION_ID) "+
			"AND C.ORGANIZATION_ID = I.ORGANIZATION_ID AND C.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID "+
			"AND I.ATTRIBUTE2 IS NULL "+
			"AND (I.LAST_UPDATED_BY = U.USER_ID) ";
			//"AND to_char(C.LAST_UPDATE_DATE,'YYYYMMDD') between '"+strFirstDayWeek+"' and '"+strLastDayWeek+"' ";   
			//"AND to_char(C.LAST_UPDATE_DATE,'YYYYMMDD') <= '"+dateBean.getYearMonthDay()+"' ";     // 預設進入頁面即將小於今日的異常資料帶出            
   if (DayFr==null && DayTo==null) sWhere=sWhere+" and TO_CHAR(C.LAST_UPDATE_DATE,'YYYYMMDD')  <= '"+dateBean.getYearMonthDay()+"' ";		
   else if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and TO_CHAR(C.LAST_UPDATE_DATE,'YYYYMMDD') between "+"'"+dateSetBegin+"'"+" and "+"'"+dateSetEnd+"'";			
   if (prodClass==null || prodClass.equals(""))  sWhere=sWhere+" and I.SEGMENT1 IS NULL ";
   else if (prodClass.substring(0,2)=="01" || prodClass.substring(0,2).equals("01"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,1,1) in ('0','1','2','3','4','5','6','7','8') ";
   else if (prodClass.substring(0,2)=="02" || prodClass.substring(0,2).equals("02"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) in ('AI','VR','PW') ";
   else if (prodClass.substring(0,2)=="03" || prodClass.substring(0,2).equals("03"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) in ('SR','LR','LD','UL','CL') ";
   else if (prodClass.substring(0,2)=="04" || prodClass.substring(0,2).equals("04"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) ='TR' ";
   else if (prodClass.substring(0,2)=="05" || prodClass.substring(0,2).equals("05"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) ='MF' ";
   else if (prodClass.substring(0,2)=="06" || prodClass.substring(0,2).equals("06"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) ='AC' ";
   else if (prodClass.substring(0,2)=="07" || prodClass.substring(0,2).equals("07"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 12 and  substr(I.SEGMENT1,1,2) = '10' ";
   
   sOrder = "order by C.ORGANIZATION_ID ";

   SWHERECOND = sWhere + sWhereGP;
   sSql = sSql + sWhere + sWhereGP + sOrder;
   sSqlCNT = sSqlCNT + sWhere + sWhereGP;   
   out.println("sSql="+ sSql);   
   
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
   sSql = "select C.ORGANIZATION_ID,C.CATEGORY_ID, I.ATTRIBUTE2, I.INVENTORY_ITEM_ID, I.SEGMENT1 || '('||I.INVENTORY_ITEM_ID||')' as SEGMENT1, I.CREATED_BY, TO_CHAR(I.CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') as CREATION_DATE, "+
                 "U.USER_NAME, P.ORGANIZATION_CODE,U.EMAIL_ADDRESS,TO_CHAR(C.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') as LAST_UPDATE_DATE, "+
				 "C.LAST_UPDATED_BY, RPAD(C.ORGANIZATION_ID,3,' ')||RPAD(I.INVENTORY_ITEM_ID,28,' ') as CORRKEY "+
		  "from MTL_ITEM_CATEGORIES C, MTL_SYSTEM_ITEMS I, MTL_PARAMETERS P, FND_USER U ";
   sSqlCNT = "select count(I.SEGMENT1) as CaseCount from MTL_ITEM_CATEGORIES C, MTL_SYSTEM_ITEMS_B I, MTL_PARAMETERS P, FND_USER U ";
   sWhere =  "where C.ORGANIZATION_ID = 43 AND CATEGORY_SET_ID = 6 AND C.ORGANIZATION_ID = P.ORGANIZATION_ID "+
            // "AND C.CATEGORY_ID NOT IN (SELECT CATEGORY_ID FROM CST_COST_GROUP_ASSIGNMENTS G, MTL_FISCAL_CAT_ACCOUNTS M "+
            //                           "WHERE G.COST_GROUP_ID=M.COST_GROUP_ID AND G.ORGANIZATION_ID = C.ORGANIZATION_ID) "+
			"AND C.ORGANIZATION_ID = I.ORGANIZATION_ID AND C.INVENTORY_ITEM_ID = I.INVENTORY_ITEM_ID "+
			"AND I.ATTRIBUTE2 IS NULL "+
			"AND (I.LAST_UPDATED_BY = U.USER_ID) ";
			//"AND to_char(C.LAST_UPDATE_DATE,'YYYYMMDD') between '"+strFirstDayWeek+"' and '"+strLastDayWeek+"' ";                  
   sOrder = "order by C.ORGANIZATION_ID ";
  
  //IC二極體","IC線性穩壓器","IC電晶體","IC場效電晶體","IC運算放大器  
  
  if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and TO_CHAR(C.LAST_UPDATE_DATE,'YYYYMMDD') >="+"'"+dateSetBegin+"'";
  if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and TO_CHAR(C.LAST_UPDATE_DATE,'YYYYMMDD') between "+"'"+dateSetBegin+"'"+" and "+"'"+dateSetEnd+"'";
  if (prodClass==null || prodClass.equals(""))  sWhere=sWhere+" ";
  if (prodClass.substring(0,2)=="01" || prodClass.substring(0,2).equals("01"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,1,1) in ('0','1','2','3','4','5','6','7','8') ";
  if (prodClass.substring(0,2)=="02" || prodClass.substring(0,2).equals("02"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) in ('AI','VR','PW') ";
  if (prodClass.substring(0,2)=="03" || prodClass.substring(0,2).equals("03"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) in ('SR','LR','LD','UL','CL') ";
  if (prodClass.substring(0,2)=="04" || prodClass.substring(0,2).equals("04"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) ='TR' ";
  if (prodClass.substring(0,2)=="05" || prodClass.substring(0,2).equals("05"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) ='MF' ";
  if (prodClass.substring(0,2)=="06" || prodClass.substring(0,2).equals("06"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 22 and substr(I.SEGMENT1,6,2) ='AC' ";
  if (prodClass.substring(0,2)=="07" || prodClass.substring(0,2).equals("07"))  sWhere=sWhere+" and  LENGTH(I.SEGMENT1) = 12 and  substr(I.SEGMENT1,1,2) = '10' ";
  
  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereGP + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP;
  out.println(sSql);    
   
   String sqlOrgCnt = "select count(I.SEGMENT1) as CaseCountORG from MTL_ITEM_CATEGORIES C, MTL_SYSTEM_ITEMS_B I, MTL_PARAMETERS P, FND_USER U  ";
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
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
     <tr><td bgcolor="#FFFF99" colspan="2"><font face="Arial" color="#000066"><span class="style1">&nbsp;</span>Organization</font>
			   <%
			       try
                   {   
		             Statement statement=con.createStatement();
                     ResultSet rs=null;	
			         String sql = "select DISTINCT c.organization_id_parent, c.organization_id_parent || '('||d.name|| ')' "+
			                            "from mtl_parameters a, hr_organization_units b, per_org_structure_elements c, hr_organization_units d "+
			                            "where a.organization_id = b.organization_id and a.organization_id = c.organization_id_child "+		
										"and c.organization_id_parent = d.organization_id "+						  
								        "order by 1 ";  			  
                     rs=statement.executeQuery(sql);
		             comboBoxBean.setRs(rs);
		             comboBoxBean.setSelection(organizationId);
	                 comboBoxBean.setFieldName("ORGPARID");	   
                     out.println(comboBoxBean.getRsString());				    
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }                     
			   %>
		     </td>
			 <td width="38%" bgcolor="#FFFF99" bordercolor="#CCCCFF" nowrap>
			   <font face="Arial" color="#000066" size="2"><span class="style1">&nbsp;</span>成品分類</font>
			   <%
		         String CurrProdClass = null;	     		 
	             try
                 {       
                   String c[]={"01-半導體","02-IC二極體","03-IC線性穩壓器","04-IC電晶體","05-IC場效電晶體","06-IC運算放大器","07-晶圓"};
                   arrayComboBoxBean.setArrayString(c);
		           if (prodClass==null)
		           {
		             CurrProdClass=dateBean.getDayString();
		             arrayComboBoxBean.setSelection(CurrProdClass);
		           } 
		           else 
		           {
		            arrayComboBoxBean.setSelection(prodClass);
		           }
	               arrayComboBoxBean.setFieldName("PRODCLASS");	   
                   out.println(arrayComboBoxBean.getArrayString());		      		 
                } //end of try
                catch (Exception e)
                {
                  out.println("Exception:"+e.getMessage());
                }
       %>
			 </td>
	 </tr>
     <tr bgcolor="#FFFF99">
	    <td width="38%" bgcolor="#FFFF99" bordercolor="#CCCCFF" nowrap><font color="#000066" face="Arial"><span class="style1">&nbsp;</span>Date From</font>
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
	<td width="38%" bordercolor="#CCCCFF" nowrap><font color="#000066" face="Arial"><span class="style1">&nbsp;</span>Date To</font>
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
	<td width="68%">
		    <INPUT TYPE="button" align="middle"  value='查詢' onClick='setSubmit("../jsp/TSCItemCategoriesUpdateTaricCode.jsp")' >   
	</td>
   </tr>
  </table>  
 
  <table cellspacing="0" bordercolordark="#FFFFFF" cellpadding="1" width="100%" align="center" bordercolorlight="#999999" border="1">
  </table>    
  <table cellSpacing="0" bordercolordark="#FFCC99" cellPadding="1" width="100%" align="center" bordercolorlight="#FFFF99" border="1">
   <tbody>
    <tr bgcolor="#FFFF99"> 
	  <td width="1%" height="22" nowrap><div align="center"><font color="#000000" size="-1">&nbsp;</font></div></td>
	  <td width="7%"  height="19" nowrap><div align="center"><font color="#330099" face="Arial" size="2"><strong>Fix</strong></font></div></td>   
      <td width="9%" height="22" nowrap><div align="center"><font color="#330099" face="Arial" size="-1">Org. Information</font></div></td>          
      <td width="11%" nowrap><div align="center"><font color="#330099" face="Arial" size="-1">Item</font></div></td>
      <td width="12%" nowrap><div align="center"><font color="#330099" face="Arial" size="-1">Category</font></div></td>      
      <td width="14%" nowrap><div align="center"><font color="#330099" face="Arial" size="-1">Taric Code</font></div></td>
      <td width="11%" nowrap><div align="center"><font color="#330099" face="Arial" size="-1">Last Upate User</font></div></td>      
      <td width="16%" nowrap><div align="center"><font color="#330099" face="Arial" size="-1">Inform User Mail</font></div></td>
	  <td width="19%" nowrap><div align="center"><font color="#330099" face="Arial" size="-1">Last Update Date </font></div></td>	         
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
      <td><div align="center"><font size="-1" color="#FFFFFF"><%out.println(rs1__index+1);%></font></div></td>
	  <%
	           if (rsTC.getString("ORGANIZATION_ID")=="49" || rsTC.getString("ORGANIZATION_ID").equals("49"))
			   {
		            categoryId="260";
					categoryCode ="D-Pack,Finished Goods";
			   } else if (rsTC.getString("ORGANIZATION_ID")=="46" || rsTC.getString("ORGANIZATION_ID").equals("46"))
			     {
		            categoryId="264";
					categoryCode ="Printer,Materials";
		         } else if (rsTC.getString("ORGANIZATION_ID")=="44" || rsTC.getString("ORGANIZATION_ID").equals("44"))
			       {
			          categoryId="22239";
					  categoryCode ="Drop-Ship,Finished Goods";
			       } else if (rsTC.getString("ORGANIZATION_ID")=="50" || rsTC.getString("ORGANIZATION_ID").equals("50"))
				          { 
							categoryId="22234";
							categoryCode ="Internal-Org,Finished Goods";
						  } else if (rsTC.getString("ORGANIZATION_ID")=="163" || rsTC.getString("ORGANIZATION_ID").equals("163")) 
						           { 
								     categoryId="23775";
									 categoryCode ="Consignment,Finished Goods";
								   } else if (rsTC.getString("ORGANIZATION_ID")=="48" || rsTC.getString("ORGANIZATION_ID").equals("48")) 
								      {
									    categoryId="267";
									    categoryCode ="Sky,Finished Goods";
									  }    
	  %>
	  <td height="20"><font size="2" color="#000000">	      
          <input type="checkbox" name="CHKFLAG" value="<%=rsTC.getString("CORRKEY")+" "+categoryId%>"><input type="hidden" name="TTDATE" value="<%=rsTC.getString("INVENTORY_ITEM_ID")%>">
          </font> 
	  </td>     
	  <td nowrap><font size="-1"><%=rsTC.getString("ORGANIZATION_ID")+"("+rsTC.getString("ORGANIZATION_CODE")+")" %></font></td>      
      <td width="11%" nowrap><font size="-1"><%=rsTC.getString("SEGMENT1")%></font></td>
      <td width="12%" nowrap><font size="-1">
	     <%  out.println(rsTC.getString("CATEGORY_ID"));
		   		        
	             String sqlUserName = "select SEGMENT2|| '.' || SEGMENT1 as ERR_CATEGORY from MTL_ITEM_CATEGORIES_V where CATEGORY_SET_ID = 4 and ORGANIZATION_ID = '"+rsTC.getString("ORGANIZATION_ID")+"' and INVENTORY_ITEM_ID ='"+rsTC.getString("INVENTORY_ITEM_ID")+"' ";
				 Statement stateUName=con.createStatement();
                 ResultSet rsUserName=stateUName.executeQuery(sqlUserName); 
				 if (rsUserName.next())
				 { 
				   // out.println(rsUserName.getString("ERR_CATEGORY")); 
				 }
				 rsUserName.close();
				 stateUName.close();
		  
	     %></font>
	  </td>
      <td width="14%" nowrap><font size="-1">
	     <%=rsTC.getString("ATTRIBUTE2")
		   /*
		    categoryId = "";
		    if (rsTC.getString("ORGANIZATION_ID")=="49" || rsTC.getString("ORGANIZATION_ID").equals("49"))
			{
		            categoryId="260";
					categoryCode ="D-Pack,Finished Goods";
			} else if (rsTC.getString("ORGANIZATION_ID")=="46" || rsTC.getString("ORGANIZATION_ID").equals("46"))
			{
		       categoryId="264";
		    } else if (rsTC.getString("ORGANIZATION_ID")=="44" || rsTC.getString("ORGANIZATION_ID").equals("44"))
			       {
			          categoryId="22239";
			       } else if (rsTC.getString("ORGANIZATION_ID")=="50" || rsTC.getString("ORGANIZATION_ID").equals("50"))
				          { 
							categoryId="22234";
						  } else if (rsTC.getString("ORGANIZATION_ID")=="163" || rsTC.getString("ORGANIZATION_ID").equals("163")) 
						           { 
								     categoryId="23775";
								   }  else if (rsTC.getString("ORGANIZATION_ID")=="48" || rsTC.getString("ORGANIZATION_ID").equals("48")) 
								      {
									    categoryId="267";
									    categoryCode ="Sky,Finished Goods";
									  }   
					  	
				 sqlUserName = "select SEGMENT2|| '.' || SEGMENT1 as COR_CATEGORY from MTL_CATEGORIES_V where CATEGORY_ID = '"+categoryId+"'  ";   
				 stateUName=con.createStatement();
                 rsUserName=stateUName.executeQuery(sqlUserName); 
				 if (rsUserName.next())
				 { 
				    out.println(rsUserName.getString("COR_CATEGORY")); 
				 }
				 rsUserName.close();
				 stateUName.close();  		 
			 */       
		 %></font></td>
      <td width="11%" nowrap><font size="-1">
	        <%//=rsTC.getString("LAST_UPDATED_BY")
			     String eMailAddress = "";
			     sqlUserName = "select USER_NAME, EMAIL_ADDRESS from FND_USER where USER_ID ='"+rsTC.getString("LAST_UPDATED_BY")+"' ";
				 stateUName=con.createStatement();
                 rsUserName=stateUName.executeQuery(sqlUserName); 
				 if (rsUserName.next())
				 { 
				    out.println(rsTC.getString("LAST_UPDATED_BY")+"("+rsUserName.getString(1)+")"); 
					eMailAddress = rsUserName.getString(2);
				 }
				 rsUserName.close();
				 stateUName.close();  
			%></font></td>      
      <td width="16%" nowrap><font size="-1"><%=eMailAddress%></font></td>      
      <td width="19%" nowrap><font size="-1"><%=rsTC.getString("LAST_UPDATE_DATE")%></font></td>      
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
              qryAllChkBoxEditBean.setPageURL("../jsp/TSCInvItemCategoryCorrection.jsp");
              qryAllChkBoxEditBean.setSearchKey("TXPERSONLOC");
              qryAllChkBoxEditBean.setFieldName("CHKFLAG");
              qryAllChkBoxEditBean.setRowColor1("B0E0E6");
              qryAllChkBoxEditBean.setRowColor2("ADD8E6");
              qryAllChkBoxEditBean.setRs(rsTC);   
}
%>
    <tr bgcolor="#FFFF99"> 
      <td height="23" colspan="10" ><font color="#330099" size="-1">料號分類商品代碼未設定筆數</font> 
        <% 
	      if (CaseCount==0) 
		  { //若 	  
		  } 
		  else { 
		        out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>");
				// 若 有資料則顯示可全選的按鈕
				
			   }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5"  readonly=""><%out.println("<font color='#000066'><strong><em>"+CaseCount+"</em></strong></font>");%> 
	 </td>      
    </tr>
	<tbody>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->  
    <% if (rs_isEmptyTC ) {  %>
    <div align="center"><font color="#993366" size="2"><strong>目前查無符合查詢條件的資料</strong></font></div>
    <% } else {
	           %>
			   <div align="left"><input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value="Select All"></div> 
			   <%                    
	          }
	/*若有資料則顯示可全選擇的按鈕 */ %>    
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=sWhere%>" maxlength="256" size="256">
<BR>
<div align="left"><input name="submit2" type="submit" value="BATCH CORRECT CATEGORY" onClick='return setSubmit2("../jsp/TSCItemCategoriesUpdateTaricCodeSubmit.jsp")'></div>
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
