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
      

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
      


String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");

String orgID=request.getParameter("ORGID");
String orgCode=request.getParameter("ORGCODE");
String invItemID=request.getParameter("INVITEMID");
String rmaInvoice=request.getParameter("INVNO");

String description = "";

if (orgID==null) orgID = "41";


  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天  
  String currentWeek = workingDateBean.getWeekString();
  
  if (dateSetBegin==null) dateSetBegin=strFirstDayWeek; 
  if (dateSetEnd==null) dateSetEnd=strLastDayWeek; 
  
  // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
     String clientID = "";
	 if (orgID=="46" || orgID.equals("46"))
	 {  clientID = "42"; }
	 else { clientID = "41"; }
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
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
  
<FORM ACTION="../jsp/TSCInvI9SubInventoryNBReport.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black"></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#003366"  size="+2" face="Times New Roman"> 
<strong>Shipping Transactions</strong></font>
<BR>
  <!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = "  ";
  
  
  

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if ((YearFr==null || YearFr.equals("")) && (YearTo==null || YearTo.equals("")))
{
   sSql = "select b.DELIVERY_DETAIL_ID, d.SEGMENT1, a.NAME, b.INVENTORY_ITEM_ID, b.ITEM_DESCRIPTION, b.SOURCE_HEADER_NUMBER, b.REQUESTED_QUANTITY,  b.SHIPPED_QUANTITY, a.CONFIRMED_BY, b.ORGANIZATION_ID   "+                 
		  "from WSH_NEW_DELIVERIES a, WSH_DELIVERY_DETAILS b, WSH_DELIVERY_ASSIGNMENTS c, MTL_SYSTEM_ITEMS d ";
   sSqlCNT = "select count(b.DELIVERY_DETAIL_ID) as CaseCount from WSH_NEW_DELIVERIES a, WSH_DELIVERY_DETAILS b, WSH_DELIVERY_ASSIGNMENTS c, MTL_SYSTEM_ITEMS d ";
   sWhere =  "WHERE a.DELIVERY_ID = c.DELIVERY_ID and b.DELIVERY_DETAIL_ID = c.DELIVERY_DETAIL_ID "+
              "and b.INVENTORY_ITEM_ID = d.INVENTORY_ITEM_ID and b.ORGANIZATION_ID = d.ORGANIZATION_ID "+
			  "AND a.NAME = '"+rmaInvoice+"' ";	 
			
   havingGrp = " ";                  
   sOrder = "ORDER BY b.DELIVERY_DETAIL_ID ";     

   SWHERECOND = sWhere + sWhereGP + havingGrp;
   sSql = sSql + sWhere + sWhereGP + havingGrp + sOrder;
   sSqlCNT = sSqlCNT + sWhere + sWhereGP + havingGrp;   
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
   sSql = "select b.DELIVERY_DETAIL_ID, d.SEGMENT1, a.NAME, b.INVENTORY_ITEM_ID, b.ITEM_DESCRIPTION, b.SOURCE_HEADER_NUMBER, b.REQUESTED_QUANTITY,  b.SHIPPED_QUANTITY, a.CONFIRMED_BY, b.ORGANIZATION_ID   "+                 
		  "from WSH_NEW_DELIVERIES a, WSH_DELIVERY_DETAILS b, WSH_DELIVERY_ASSIGNMENTS c, MTL_SYSTEM_ITEMS d ";
   sSqlCNT = "select count(b.DELIVERY_DETAIL_ID) as CaseCount from WSH_NEW_DELIVERIES a, WSH_DELIVERY_DETAILS b, WSH_DELIVERY_ASSIGNMENTS c, MTL_SYSTEM_ITEMS d ";
   sWhere =  "WHERE a.DELIVERY_ID = c.DELIVERY_ID and b.DELIVERY_DETAIL_ID = c.DELIVERY_DETAIL_ID "+
              "and b.INVENTORY_ITEM_ID = d.INVENTORY_ITEM_ID and b.ORGANIZATION_ID = d.ORGANIZATION_ID "+
			  "AND a.NAME = '"+rmaInvoice+"' "; 
   havingGrp = " ";                  
   sOrder = "ORDER BY b.DELIVERY_DETAIL_ID ";   			     
   
  
  //if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and TO_CHAR(TRANSACTION_DATE,'YYYYMMDD') >="+"'"+dateSetBegin+"'";
  //if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and TO_CHAR(TRANSACTION_DATE,'YYYYMMDD') >= "+"'"+dateSetBegin+"'"+" AND TO_CHAR(TRANSACTION_DATE,'YYYYMMDD') <= "+"'"+dateSetEnd+"'";
   

  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereGP + havingGrp + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP + havingGrp;
  //out.println("sSqlTT="+sSql);    
   
   String sqlOrgCnt = "select count(b.DELIVERY_DETAIL_ID) as CaseCount from WSH_NEW_DELIVERIES a, WSH_DELIVERY_DETAILS b, WSH_DELIVERY_ASSIGNMENTS c, MTL_SYSTEM_ITEMS d  ";
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

String sourceOrdLine[]  = new String[CaseCountORG];  // *** 宣告一維陣列,用來存放使用取得作RMA 的Line ID;
int sourceLineIdLength = 0;

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
 
  <table cellSpacing="0" borderColorDark="#333399"  cellPadding="1" width="100%" align="center" borderColorLight="#CCFFFF" border="1">
    <tr bgcolor="#6699CC"> 
	  <td width="4%" height="22" nowrap><div align="center"><font color="#000000" size="-1">&nbsp;</font></div></td>
	  <td width="7%" height="22" nowrap><div align="center"><font color="#000000" size="-1">DELIVERY_DETAIL_ID</font></div></td>
	  <td width="7%" height="22" nowrap><div align="center"><font color="#000000" size="-1">Item Name</font></div></td>
	  <td width="12%" nowrap><div align="center"><font size="-1">Item ID</font></div></td> 
	  <td width="11%" nowrap><div align="center"><font size="-1">Item Description</font></div></td> 
	  <td width="8%" height="22" nowrap><div align="center"><font color="#000000" size="-1">Delivery</font></div></td>               
      <td width="8%" nowrap><div align="center"><font size="-1">Order</font></div></td>
      <td width="12%" nowrap><div align="center"><font size="-1">Requested Qty</font></div></td>      
      <td width="13%" nowrap><div align="center"><font size="-1">Shipped Qty</font></div></td>     
	  <td width="14%" nowrap><div align="center"><font size="-1">Confirmed By</font></div></td> 
	  <td width="15%" nowrap><div align="center"><font size="-1">Organization ID</font></div></td>                   
    </tr>
    <% 
	  int i = 0; 
	  while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "CCCCCC";
	     }
	     else{
	       colorStr = "CCCCFF"; }
		   
			
		  
		  i++; // 更新存放 Array 的 index
		  
		 // b.DELIVERY_DETAIL_ID, d.SEGMENT1, a.NAME, b.INVENTORY_ITEM_ID, b.ITEM_DESCRIPTION, b.SOURCE_HEADER_NUMBER, b.REQUESTED_QUANTITY,  b.SHIPPED_QUANTITY, a.CONFIRMED_BY, b.ORGANIZATION_ID
    %> 
    <tr bgcolor="<%=colorStr%>"> 	
	  <td><div align="center"><font size="-1"><%out.println(rs1__index+1);%></font></div></td>  
	  <td><div align="left"><font size="-1"><strong><%=rsTC.getString("DELIVERY_DETAIL_ID")%></strong></font></div></td>
      <td><div align="left"><font size="-1"><strong>
	      <%=rsTC.getString("NAME") %></strong></font></div></td>  
      <td width="8%" nowrap><font size="-1"><strong><%=rsTC.getString("SEGMENT1")%></strong></font></td>
      <td width="12%" nowrap><div align="right"><font size="-1"><strong><%out.println(rsTC.getString("INVENTORY_ITEM_ID"));%></strong></font></div></td>      
      <td width="13%" nowrap><font size="-1"><strong>
	      <%//rsTC.getString("ITEM_DESCRIPTION")	
		     if (rsTC.getString("INVENTORY_ITEM_ID").equals(invItemID))
			 {
			    out.println("<font color='#FF0000'><strong>"+rsTC.getString("ITEM_DESCRIPTION")+"</strong></font>");
			 } else { 
			          out.println(rsTC.getString("ITEM_DESCRIPTION"));
			        }
		   
		  %></strong></font>
	  </td>  
	  <td width="12%" nowrap><div align="left"><strong><font size="-1"><%=rsTC.getString("SOURCE_HEADER_NUMBER")%></font></strong></div></td> 
	  <td width="11%" nowrap><div align="left"><strong><font size="-1"><%=rsTC.getString("REQUESTED_QUANTITY")%></font></strong></div></td> 
	  <td width="14%" nowrap><div align="left"><strong><font size="-1">	   
	   <%=rsTC.getString("SHIPPED_QUANTITY")  %>	  
	   </font></strong></div></td> 
	  <td width="15%" nowrap><div align="left"><strong><font size="-1"><%=rsTC.getString("CONFIRMED_BY")%></font></strong></div></td>                
	  <td width="15%" nowrap><div align="left"><strong><font size="-1"><%=rsTC.getString("ORGANIZATION_ID")%></font></strong></div></td>
    </tr>	
    <%
	//description = rsTC.getString("DESCRIPTION");
	//if (description==null || description.equals("")) description = "";
    rs1__index++;
    rs_hasDataTC = rsTC.next();
}
%>   
    <tr bgcolor="#6699CC"> 
      <td height="23" colspan="11" ><font size="-1">Context</font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="text" name="CASECOUNT" value=<%="Delivery -"+rmaInvoice%> size="50"  readonly="">
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
<input type="hidden" name="SPANNING"  maxlength="5" size="5"><BR>
<font color="#CC0066" size="2">說明 : <BR>1.本表預設為前一週<%=orgCode%>庫存異動明細表,實際資料抓取區間如表頭所示,但不包含異動型態為"Sales Order Pick" </font><BR>
<font color="#CC0066" size="2">2.若月底前仍有特定料件項目進出不平衡,請相關人員處理,確保月結順利進行.</font><BR>
<font color="#CC0066" size="2">3.如需進一步依日期查詢資訊,請至<A href="../jsp/TSCInvORGSubInventoryNBQuery.jsp">組織庫存平衡查詢</A>.</font>
	      
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

