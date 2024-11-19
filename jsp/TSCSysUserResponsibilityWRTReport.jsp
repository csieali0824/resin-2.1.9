<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
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

String applicationId=request.getParameter("APPLICATION_ID");
String responsibilityId=request.getParameter("RESPONSIBILITY_ID");
String responsibilityName=request.getParameter("RESPONSIBILITY_NAME");

String spanning=request.getParameter("SPANNING");
String USER_ID=request.getParameter("USER_ID");

 


%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
</head>
<body topmargin="0" bottommargin="0">  
  
<FORM ACTION="../jsp/TSCSysUserResponsibilityWRTReport.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#CC6600"  size="+2" face="Times New Roman"> 
<strong>User Responsibility with respect to Report</strong></font>
<BR>
 <A href="/oradds/ORAddsMainMenu.jsp">回首頁</A> <!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = " ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
 

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if ((applicationId==null || applicationId.equals("")) && (responsibilityId==null || responsibilityId.equals("")))
{
   sSql = "select DISTINCT G.USER_ID, U.USER_NAME, H.EMPLOYEE_NO, H.LAST_NAME1||H.FIRST_NAME1 as CHINESE_NAME, "+ 
                 "G.RESPONSIBILITY_APPLICATION_ID, G.RESPONSIBILITY_ID, R.RESPONSIBILITY_NAME "+                
		   "from FND_USER_RESP_GROUPS G, FND_RESPONSIBILITY_VL R, FND_USER U, AHR_EMPLOYEES_ALL H, FND_CONCURRENT_PROGRAMS_TL P ";
   sSqlCNT = "select count(DISTINCT G.USER_ID) as CaseCount from FND_USER_RESP_GROUPS G, FND_RESPONSIBILITY_VL R, FND_USER U, AHR_EMPLOYEES_ALL H, FND_CONCURRENT_PROGRAMS_TL P ";
   sWhere =  "WHERE U.END_DATE IS NULL and G.END_DATE IS NULL and U.USER_ID = G.USER_ID "+
               "and U.EMPLOYEE_ID = H.PERSON_ID and H.HIRE_STATUS != '離職' "+	 
			   "and G.RESPONSIBILITY_APPLICATION_ID = R.APPLICATION_ID and G.RESPONSIBILITY_ID = R.RESPONSIBILITY_ID "+
			   "and P.LANGUAGE='US' and P.CREATED_BY != 1 "+
			   "and G.RESPONSIBILITY_APPLICATION_ID IS NULL AND RESPONSIBILITY_NAME like '%"+responsibilityName+"%' ";                   
   sOrder = "order by USER_ID ";     

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
   sSql = "select DISTINCT G.USER_ID, U.USER_NAME, H.EMPLOYEE_NO, H.LAST_NAME1|| H.FIRST_NAME1 CHINESE_NAME, "+ 
                 "G.RESPONSIBILITY_APPLICATION_ID, G.RESPONSIBILITY_ID, R.RESPONSIBILITY_NAME "+                
		   "from FND_USER_RESP_GROUPS G, FND_RESPONSIBILITY_VL R, FND_USER U, AHR_EMPLOYEES_ALL H, FND_CONCURRENT_PROGRAMS_TL P ";
   sSqlCNT = "select count(DISTINCT G.USER_ID) as CaseCount from FND_USER_RESP_GROUPS G, FND_RESPONSIBILITY_VL R, FND_USER U, AHR_EMPLOYEES_ALL H, FND_CONCURRENT_PROGRAMS_TL P ";
   sWhere =  "WHERE U.END_DATE IS NULL and G.END_DATE IS NULL and U.USER_ID = G.USER_ID "+
               "and U.EMPLOYEE_ID = H.PERSON_ID and H.HIRE_STATUS != '離職' "+	 
			   "and G.RESPONSIBILITY_APPLICATION_ID = R.APPLICATION_ID and G.RESPONSIBILITY_ID = R.RESPONSIBILITY_ID "+
			   "and P.LANGUAGE='US' and P.CREATED_BY != 1 ";
			//   "and G.RESPONSIBILITY_APPLICATION_ID='"+applicationId+"' AND and RESPONSIBILITY_NAME like '%"+strLastDayWeek+"%' ";                    
   sOrder = "order by USER_ID ";      
  
 
   if (applicationId==null || applicationId.equals("")|| applicationId.equals("--") ) {sWhere=sWhere+" and G.RESPONSIBILITY_APPLICATION_ID IS NULL ";}
   else {sWhere=sWhere+" and G.RESPONSIBILITY_APPLICATION_ID ='"+applicationId+"'";}
   if (responsibilityId==null || responsibilityId.equals("") || responsibilityId.equals("--") ) { sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and G.RESPONSIBILITY_ID ='"+responsibilityId+"'";}
   if (responsibilityName !=null && !responsibilityName.equals("")) 
   {sWhere=sWhere+" and R.RESPONSIBILITY_NAME like '%"+responsibilityName+"%' "; }

  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereGP + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP;
  //out.println("sSqlTT="+sSql);    
   
   String sqlOrgCnt = "select count(DISTINCT G.USER_ID) as CaseCountORG from FND_USER_RESP_GROUPS G, FND_RESPONSIBILITY_VL R, FND_USER U, AHR_EMPLOYEES_ALL H, FND_CONCURRENT_PROGRAMS_TL P ";
   sqlOrgCnt = sqlOrgCnt + sWhere + sWhereGP;
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
	    <td width="42%" bordercolor="#CCCCFF" nowrap><font color="#CC6600"><strong>Oracle Module</strong></font>
        <%		 
			 
	     
		  
		 //String APPLICATION_ID="";		 		 
	     try
         {   
		      Statement statement=con.createStatement();
              ResultSet rs=null;	  
			  
              rs=statement.executeQuery("select APPLICATION_ID as APPLICATION_ID, APPLICATION_ID ||'('||APPLICATION_NAME ||')' as APPLICATION_NAME from APPLSYS.FND_APPLICATION_TL where LANGUAGE = 'US' order by APPLICATION_ID");
		  
		      out.println("<select NAME='APPLICATION_ID' onChange='setSubmit("+'"'+"../jsp/TSCSysUserResponsibilityWRTReport.jsp"+'"'+")'>");
		      out.println("<OPTION VALUE=-->--");     
		      while (rs.next())
		        {            
		          String s1=(String)rs.getString(1); 
		          String s2=(String)rs.getString(2); 
                        
		          if (s1.equals(applicationId)) 
  		          {
                     out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
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
	<td width="58%" bordercolor="#CCCCFF" nowrap><font color="#CC6600"><strong>Responsibility</strong></font>
        <%
		     
	          try
              {  
			    String sqlR = "select RESPONSIBILITY_ID as A, RESPONSIBILITY_ID||'('|| RESPONSIBILITY_NAME||')' as B from FND_RESPONSIBILITY_VL ";
				if (applicationId==null || applicationId.equals("")) { sqlR = sqlR + " order by A";  }   
				else { sqlR = sqlR + "where APPLICATION_ID='"+applicationId+"' order by A"; }  
                Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery(sqlR);
                comboBoxBean.setRs(rs);
		        comboBoxBean.setSelection(responsibilityId);
	            comboBoxBean.setFieldName("RESPONSIBILITY_ID");	   
                out.println(comboBoxBean.getRsString());
		 		
                rs.close(); 
				statement.close();       
             } //end of try
             catch (Exception e)
             {
              out.println("Exception:"+e.getMessage());
             }
			
          %>
    </td>	
   </tr>
   <tr>
    <td><font color="#CC6600"><strong>Responsibility Like </strong></font><INPUT type="text" name="RESPONSIBILITY_NAME" size=30 value="<%if (responsibilityName!=null) out.println(responsibilityName);%>"> </td>
	<td width="58%" bordercolor="#CCCCFF">
		    <INPUT TYPE="button" align="middle"  value='查詢' onClick='setSubmit("../jsp/TSCSysUserResponsibilityWRTReport.jsp")' >   
	</td>
   </tr>
  </table>  
 
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
    <tr bgcolor="#CCCC99"> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#000000" size="-1">&nbsp;</font></div></td>               
      <td width="5%" nowrap><div align="center"><font color="#CC6600" size="-1">User ID</font></div></td>
	  <td width="11%" nowrap><div align="center"><font color="#CC6600" size="-1">User Name</font></div></td>
	  <td width="11%" nowrap><div align="center"><font color="#CC6600" size="-1">Employee No</font></div></td>
      <td width="16%" nowrap><div align="center"><font color="#CC6600" size="-1">Chinese Name</font></div></td>      
      <td width="10%" nowrap><div align="center"><font color="#CC6600" size="-1">Responsibility ID</font></div></td>
      <td width="45%" nowrap><div align="center"><font color="#CC6600" size="-1">Responsibility Name</font></div></td>                     
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "FFFFCC";
	     }
	    else{
	       colorStr = "FFCC99"; }
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#CCCC99"><div align="center"><font size="-1" color="#CC6600"><%out.println(rs1__index+1);%></font></div></td>     	        
      <td width="5%" nowrap><font size="-1" color="#CC6600"><%=rsTC.getString("USER_ID")%></font></td>
      <td width="11%" nowrap><font size="-1" color="#CC6600"><%=rsTC.getString("USER_NAME") %></font></td>     
      <td width="11%" nowrap><font size="-1" color="#CC6600"><%=rsTC.getString("EMPLOYEE_NO")%></font></td>  
	  <td width="16%" nowrap><font size="-1" color="#CC6600"><%=rsTC.getString("CHINESE_NAME")%></font></td>  
	  <td width="10%" nowrap><font size="-1" color="#CC6600"><%=rsTC.getString("RESPONSIBILITY_ID")%></font></td>  
	  <td width="45%" nowrap><div align="right"><strong><font size="-1" color="#CC3366">
	        <%//=rsTC.getFloat("SUMQTY")
			       String subColStr = "";
			       if ((rs1__index % 2) == 0)
				   { subColStr = "FFCC99"; }
	               else{ subColStr = "FFFFCC"; }			    
			       out.println("<table width='100%' height='100%'>");			 
			       if ( spanning==null || spanning.equals("") || spanning=="FALSE" || spanning.equals("FALSE")  )
			       {
			          out.print("<tr><td nowrap>"); out.println("<font size='-1' color='#CC6600'>"+rsTC.getString("RESPONSIBILITY_NAME")+"</font>"); %><a href="../jsp/TSCSysUserResponsibilityWRTReport.jsp?SPANNING=TRUE&USER_ID=<%=rsTC.getString("USER_ID")%>&APPLICATION_ID=<%=rsTC.getString("RESPONSIBILITY_APPLICATION_ID")%>&RESPONSIBILITY_ID=<%=rsTC.getString("RESPONSIBILITY_ID")%>"><img src="../image/PLUS.gif" width="14" height="15" border="0"></a><% out.println("</td></tr>");
			       } else if ( spanning!= null && (spanning=="TRUE" || spanning.equals("TRUE") ) )
			              {			    
				             //再判段若是 Entity ID 才顯示明細,點擊符號顯示 MINUS 
				             if ( (USER_ID==rsTC.getString("USER_ID") || USER_ID.equals(rsTC.getString("USER_ID")) ) && (responsibilityId ==rsTC.getString("RESPONSIBILITY_ID") || responsibilityId.equals(rsTC.getString("RESPONSIBILITY_ID")) )  )
				             { //out.println("wipEntID="+wipEntID);out.println("rsTC.getString(INVENTORY_ITEM_ID)="+rsTC.getString("INVENTORY_ITEM_ID"));
				               out.print("<tr><td nowrap>"); out.println("<font size='-1' color='#CC6600'>"+rsTC.getString("RESPONSIBILITY_NAME")+"</font>");  %><a href="../jsp/TSCSysUserResponsibilityWRTReport.jsp?SPANNING=FALSE&USER_ID=<%=rsTC.getString("USER_ID")%>&APPLICATION_ID=<%=rsTC.getString("RESPONSIBILITY_APPLICATION_ID")%>&RESPONSIBILITY_ID=<%=rsTC.getString("RESPONSIBILITY_ID")%>"><img src="../image/MINUS.gif" width="14" height="15" border="0"></a><% out.println("</td></tr>");
				               out.println("<tr bgcolor="+subColStr+"><td><font size='-2' color='#CC6600'>Program ID</font></td><td><font size='-2'>Concurrent Program Name</font></td><td><font size='-2' color='#CC0066'>Description</font></td></tr>");
				               String sqlM = "select P.CONCURRENT_PROGRAM_ID, P.USER_CONCURRENT_PROGRAM_NAME, P.DESCRIPTION "+
				                             "from FND_USER_RESP_GROUPS G, FND_RESPONSIBILITY_VL R, FND_USER U, AHR_EMPLOYEES_ALL H, FND_CONCURRENT_PROGRAMS_TL P "+
							                 "where U.END_DATE IS NULL and G.END_DATE IS NULL and U.USER_ID = G.USER_ID "+
											   "and U.EMPLOYEE_ID = H.PERSON_ID "+											  										   
											   "and G.RESPONSIBILITY_APPLICATION_ID='"+rsTC.getString("RESPONSIBILITY_APPLICATION_ID")+"' "+											   
							                   "and RESPONSIBILITY_NAME = '"+rsTC.getString("RESPONSIBILITY_NAME")+"' "+
											   "and TO_CHAR(U.USER_ID) = '"+USER_ID+"' "+
											   "and P.APPLICATION_ID = '"+rsTC.getString("RESPONSIBILITY_APPLICATION_ID")+"' "+
											   "and G.RESPONSIBILITY_APPLICATION_ID = R.APPLICATION_ID and G.RESPONSIBILITY_ID = R.RESPONSIBILITY_ID "+
											   "and P.LANGUAGE='US' and P.CREATED_BY != 1 ";
				               Statement stateM=con.createStatement();
							   //out.println(sqlM);
                               ResultSet rsM=stateM.executeQuery(sqlM); 
				               while (rsM.next())
				               { 
				                out.println("<tr bgcolor="+subColStr+">");
				                out.println("<td nowrap><font size='-2' color='#CC6600'>"+rsM.getString("CONCURRENT_PROGRAM_ID")+"</font></td><td nowrap><font size='-2' color='#CC6600'>"+rsM.getString("USER_CONCURRENT_PROGRAM_NAME")+"</font></td><td nowrap><font size='-2' color='#CC0066'>"+rsM.getString("DESCRIPTION")+"</font></td>");
				                out.println("</tr>");
				               }
				               rsM.close();
				               stateM.close();
				             }  else {  // 否則只顯示 PLUS 符號
				                       out.print("<tr><td nowrap>"); out.println("<font size='-1' color='#CC6600'>"+rsTC.getString("RESPONSIBILITY_NAME")+"</font>");  %><a href="../jsp/TSCSysUserResponsibilityWRTReport.jsp?SPANNING=TRUE&USER_ID=<%=rsTC.getString("USER_ID")%>&APPLICATION_ID=<%=rsTC.getString("RESPONSIBILITY_APPLICATION_ID")%>&RESPONSIBILITY_ID=<%=rsTC.getString("RESPONSIBILITY_ID")%>"><img src="../image/PLUS.gif" width="14" height="15" border="0"></a><% out.println("</td></tr>");    
				                     } // End of else
			            }  // End of else if (spannin==null)
			            out.println("</table>");   
			%></font></strong></div>
	  </td>                
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
}
%>
    <tr bgcolor="#CCCC99"> 
      <td height="23" colspan="10" ><font color="#CC6600" size="-1">使用者對應責任角色資料筆數</font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCountORG%> size="2"  readonly=""><%out.println("<font color='#CC6600'><strong><em>"+CaseCountORG+"</em></strong></font>");%> 
	 </td>      
    </tr>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="3">
    <% if (rs_isEmptyTC ) {  %>
    <strong>目前查無符合查詢條件的資料</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
<input type="hidden" name="SWHERECOND" value="<%=sWhere%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5">
<input type="hidden" name="USER_ID"  value="<%=USER_ID%>"  maxlength="5" size="5">
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