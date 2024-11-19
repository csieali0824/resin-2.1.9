<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,ArrayComboBoxBean"%>
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
<%@ include file="/jsp/include/ConnORADDSPoolPage.jsp"%>
<!--=================================-->
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
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


String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");

%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
</head>
<body topmargin="0" bottommargin="0">  
  
<FORM ACTION="../jsp/OraSysPbjQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
 <font color="#009999" face="Arial Black" size="5"><strong>TSC</strong></font>
 <font color="#000066" face="標楷體" size="+2"><strong>系統管理員-物件明細查詢</strong></font>  
<BR>
  <!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = " and OWNER IS NOT NULL ";
 

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if (owner==null || owner.equals(""))
{
   sSql = "select OWNER, OBJECT_NAME, OBJECT_ID, OBJECT_TYPE, CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS, TEMPORARY from DBA_OBJECTS ";
   sSqlCNT = "select count(OBJECT_NAME) as CaseCount from DBA_OBJECTS a ";
   sWhere =  "where OWNER IS NULL ";                  
   sOrder = "order by OWNER ";

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
   sSql = "select OWNER, OBJECT_NAME, OBJECT_ID, OBJECT_TYPE, CREATED, LAST_DDL_TIME, TIMESTAMP, STATUS, TEMPORARY from DBA_OBJECTS ";
   sSqlCNT = "select count(OBJECT_NAME) as CaseCount from DBA_OBJECTS a ";
   sWhere =  "where OWNER IS NOT NULL ";                  
   sOrder = "order by OWNER ";
  
  //out.println(sSql);    
  if (owner!=null && !owner.equals("--") && !owner.equals("")) 
  {sWhere=sWhere+"and OWNER ='"+owner+"' ";}
  if (objectType!=null && !objectType.equals("--") && !objectType.equals("")) 
  {sWhere=sWhere+"and OBJECT_TYPE ='"+objectType+"' ";}
   

  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereGP + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP;
	 
 //out.println("sSqlCNT="+sSqlCNT);
 //out.println(sSql);  
   Statement statement2=con.createStatement();
   ResultSet rs2=statement2.executeQuery("select count(OBJECT_NAME) as CaseCountORG from DBA_OBJECTS ");
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
			 out.println(CaseCountPCT);
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
 <A HREF="/oradds/ORAddsMainMenu.jsp">回首頁</A>
  &nbsp; 
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
     <tr>
	    <td width="32%"><font color="#000066"><strong>擁有者</strong></font>
		   <%
		      //String owner="";
	          try
              {       
                Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery("select DISTINCT OWNER,OWNER from DBA_OBJECTS");
                comboBoxAllBean.setRs(rs);
		        comboBoxAllBean.setSelection(owner);
	            comboBoxAllBean.setFieldName("OWNER");	   
                out.println(comboBoxAllBean.getRsString());
		 		 
                rs.close();  
				statement.close();    
             } //end of try
             catch (Exception e)
             {
              out.println("Exception:"+e.getMessage());
             }
          %>
		</td>
		<td width="32%"><font color="#000066"><strong>物件類型</strong></font>
		   <%
		      
	          try
              {       
                Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery("select DISTINCT OBJECT_TYPE as A,OBJECT_TYPE as B from DBA_OBJECTS order by A");
                comboBoxAllBean.setRs(rs);
		        comboBoxAllBean.setSelection(objectType);
	            comboBoxAllBean.setFieldName("OBJECTTYPE");	   
                out.println(comboBoxAllBean.getRsString());
		 		 
                rs.close(); 
				statement.close();       
             } //end of try
             catch (Exception e)
             {
              out.println("Exception:"+e.getMessage());
             }
          %>
		</td>
		<td width="68%">
		    <INPUT TYPE="button" align="middle"  value='查詢' onClick='setSubmit("../jsp/OraSysObjQuery.jsp")' >   
		</td>
	 </tr>
  </table>  
 
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
    <tr bgcolor="#CC3366"> 
	  <td width="3%" height="22" nowrap><div align="center"><font color="#000000" size="-1">&nbsp;</font></div></td>
	  <td width="3%" height="22" nowrap><div align="center"><font color="#CCFF99"  size="-1">Object <br>Schema</font></div></td>
      <td width="9%" height="22" nowrap><div align="center"><font color="#FFFFFF" size="-1">物件擁有者</font></div></td>
      <td width="12%" nowrap><div align="center"><font color="#FFFFFF" size="-1">物件名稱</font></div></td>     
      <td width="8%" nowrap><div align="center"><font color="#FFFFFF" size="-1">物件識別碼</font></div></td>
      <td width="11%" nowrap><div align="center"><font color="#FFFFFF" size="-1">物件類型</font></div></td>      
      <td width="14%" nowrap><div align="center"><font color="#FFFFFF" size="-1">建立日期</font></div></td>
      <td width="14%" nowrap><div align="center"><font color="#FFFFFF" size="-1">前次DDL時間</font></div></td>
      <td width="12%"><div align="center"><font color="#FFFFFF" size="-1">時間戳記</font></div></td>
      <td width="9%" nowrap><div align="center"><font color="#FFFFFF" size="-1">狀態</font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#FFFFFF" size="-1">暫存狀態</font></div></td>	         
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "FFFFFF";
	     }
	    else{
	       colorStr = "FFFFCC"; }
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#CC3366"><div align="center"><font size="-1" color="#FFFFFF"><%out.println(rs1__index+1);%></font></div></td>
	  <td><div align="center"><a href="../jsp/OraSysStoredObjectTextPage.jsp?OBJECT=<%=rsTC.getString("OBJECT_NAME")%>"><img src="../image/docicon.gif" width="14" height="15" border="0"></a></div></td>         
	  <td><font size="-1"><%=rsTC.getString("OWNER") %></font></td>
      <td width="12%" nowrap><font size="-1"><%=rsTC.getString("OBJECT_NAME")%></font></td>
      <td width="8%"><font size="-1"><%=rsTC.getString("OBJECT_ID")%></font></td>
      <td width="11%" nowrap><font size="-1"><%=rsTC.getString("OBJECT_TYPE")%></font></td>
      <td width="14%"><font size="-1"><%=rsTC.getString("CREATED")%></font></td>
      <td width="14%"><font size="-1"><%=rsTC.getString("LAST_DDL_TIME")%></font></td>
      <td width="12%"><font size="-1"><%=rsTC.getString("TIMESTAMP")%></font></td>
      <td width="9%"><font size="-1"><%=rsTC.getString("STATUS")%></font></td>      
      <td width="8%"><font size="-1"><%=rsTC.getString("TEMPORARY")%></font></td>      
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
}
%>
    <tr bgcolor="#CC3366"> 
      <td height="23" colspan="11" ><font color="#FFFFFF">查詢筆數</font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5"  readonly=""><%out.println("<font color='#99FFCC'><strong><em>"+CaseCount+"</em></strong></font>");%> 
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
</FORM>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong>[<A HREF="<%=MM_moveFirst%>">第一頁</A>]</strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong>[<A HREF="<%=MM_movePrev%>">上一頁</A>]</strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong>[<A HREF="<%=MM_moveNext%>">下一頁</A>]</strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong>[<A HREF="<%=MM_moveLast%>">最後一頁</A>]</strong></font></pre>
      </div></td>
  </tr>
</table>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnORADDSPage.jsp"%>
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
