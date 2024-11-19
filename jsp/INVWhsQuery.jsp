<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
  function Submit(URL)
 {  
  document.MYFORM.action=URL;
  document.MYFORM.submit();
 }
</script>
<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Shipping Query</title>
</head>
<body>
<FORM ACTION="../jsp/INVWhsQuery.jsp" METHOD="post" NAME="MYFORM" >
  <font color="#000000" face="Arial Black"><strong>
  </strong></font>
  <font color="#000000" face="Arial Black"><strong>
  </strong></font>
  <table width="100%" border="0">
    <tr> 
      <td align="center"><strong><font color="#0000FF" size="+2" face="Arial">Warehouse Query&nbsp;
            <%
          int rs1__numRows = 15;
          int rs1__index = 0;
          int rs_numRows = 0;
          rs_numRows += rs1__numRows;
        %> 
        <% 
	      String whs=request.getParameter("WHS");			
		  String loc=request.getParameter("LOC");	
          String desc=request.getParameter("DESC"); 	   
	   
	      String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";
	      String Query = "N";     
          int numRow = 0;
	      String colorStr = "";	   
	   %>
      </font></strong>    </td>
    </tr>
  </table>
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> 
  <table width="96%" border="0" bordercolor="#CCFFFF" >
    <tr bgcolor="#66CCFF"> 
            	 
	  <td width="14%"><font color="#000000" face="Arial Black"><strong>Whs:
	    <input type="text" name="WHS"  size="6" maxlength="2">
      </strong></font>        
      </td>
	  <td width="16%"><font color="#000000" face="Arial Black"><strong>Loc:
	    <input type="text" name="LOC"  size="8" maxlength="6">
      </strong></font>        
      </td>	  
	  <td width="50%"><font color="#000000" face="Arial Black"><strong>Description:
	        <input type="text" name="DESC"  size="35" maxlength="15">
      </strong></font>      </td>	  
      <td width="20%"><input name="Search"  type="submit" value="Query" onClick='return Submit("../jsp/INVWhsQuery.jsp")'></td>	  
    </tr>
  </table>

  <table width="96%" border="1" cellspacing="0">
    <tr bordercolor="#000000" bgcolor="#CCFFFF" >
      <td width="15%"><div align="center"><font size="2"><font face="新細明體">Whs </font></font></div></td>
      <td width="19%"><div align="center"><font size="2" face="新細明體">Location</font></div></td>
      <td width="66%"><div align="center"><font size="2" face="新細明體"> Descrtiption </font></div></td>
    </tr>
    <%   
	   //if (Query == "Y")
	   //{ 		
	     try
          {   
		   //if (imei=="IMEI")
		   //{}
		   //else
		   //{
		   String sqlM = "";
    	   String sWhere = "";
	       
		   Statement stateM=con.createStatement();
	       sqlM = "select WHSWHS, WHSLOC, WHSDESC from INV_WHS ";
		   sWhere = " ";
		   if ((whs==null || whs.equals("")) & (loc==null || loc.equals("")) & (desc==null || desc.equals("")))
		   {}
		   else if (whs!=null & (loc==null || loc.equals("")) & (desc==null || desc.equals("")))
		   {sWhere = sWhere + " Where whswhs like '%"+whs+"%' ";}
		   else if ((whs==null || whs.equals("")) & (loc!=null) & (desc==null || desc.equals("")))
		   {sWhere = sWhere + " Where whsloc like '%"+loc+"%' ";}		   
		   else if ((whs==null || whs.equals("")) & (loc==null || loc.equals("")) & desc!=null)		
		   {sWhere = sWhere + " Where whsdesc like '%"+desc+"%' ";}		
		   else if (whs!=null & loc!=null & (desc==null || desc.equals("")))
		   {sWhere = sWhere + " Where whswhs like '%"+whs+"%' And whsloc like '%"+loc+"%' ";}		
		   else if (whs!=null & (loc==null || loc.equals("")) & desc!=null)
		   {sWhere = sWhere + " Where whswhs like '%"+whs+"%' And whsdesc like '%"+desc+"%' ";}	
		   else if ((whs==null || whs.equals("")) & loc!=null & desc!=null)
		   {sWhere = sWhere + " Where whsloc like '%"+loc+"%' And whsdesc like '%"+desc+"%' ";}	
		   else
		   {sWhere = sWhere + " Where whswhs like '%"+whs+"%' And whsloc like '%"+loc+"%' And whsdesc like '%"+desc+"%' ";}			   		   		   	   
		   sWhere = sWhere + "ORDER BY whswhs,whsloc";	      		         
		   sqlM = sqlM+sWhere;
		   //out.println(sqlM);
		   ResultSet rsM=stateM.executeQuery(sqlM);
		   
// 加入分頁-起	   

		 boolean rs_isEmpty = !rsM.next();
         boolean rs_hasData = !rs_isEmpty;
         Object rs_data;		   


		 
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int rs_first = 1;
int rs_last  = 1;
int rs_total = -1;


if (rs_isEmpty) {
  rs_total = rs_first = rs_last = 0;
}

//set the number of rows displayed on this page
if (rs_numRows == 0) {
  rs_numRows = 1;
}

String MM_paramName = "";

// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = rsM;
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
  for (i=0; rs_hasData && (i < MM_offset || MM_offset == -1); i++) {
    rs_hasData = MM_rs.next();
  }
  if (!rs_hasData) MM_offset = i;  // set MM_offset to the last possible record
}

// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; rs_hasData && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    rs_hasData = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM?佃?????o???_rsCount and MM_size
  if (!rs_hasData) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!rs_hasData && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  rsM.close();
  rsM=stateM.executeQuery(sqlM);
  rs_hasData = rsM.next();
  MM_rs = rsM;

  // move the cursor to the selected record
  for (i=0; rs_hasData && i < MM_offset; i++) {
    rs_hasData = MM_rs.next();
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

//String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
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

// 加入分頁 - 迄 /		
		while ((rs_hasData)&&(rs1__numRows-- != 0)) 
		{		 
		  numRow = numRow + 1; // 計算取得列數
		  
		%>
    <%
          rs1__index++;
          if ((rs1__index % 2) == 0)
		  {colorStr = "DDFFFF"; }
	      else
		  {colorStr = "FEFFFF"; }
        %>
    <tr bgcolor="<%=colorStr%>">
      <td width="15%" nowrap><font color="#993366" size="2"><strong>
        <%
             if (rsM.getString("WHSWHS") !=null && !rsM.getString("WHSWHS").equals(" ")) { out.println(rsM.getString("WHSWHS") ); } 
             else { out.println("&nbsp;"); }
         %>
      </strong></font></td>
      <td nowrap><font color="#993366" size="2"><strong><%=rsM.getString("WHSLOC")%></strong></font></td>
      <td nowrap><font color="#993366" size="2"><strong><%=rsM.getString("WHSDESC")%></strong></font></td>
    </tr>
    <tr>
      <td colspan="3" bgcolor="#CCFFFF">
        <div align="center">
          <% if (rs_isEmpty) { out.println("rs_isEmpty"+rs_isEmpty);%>
          <font color="#CC0066" size="2"><strong>目前資料庫查無符合查詢條件的資料</strong></font>
          <% } /* end RpRepair_isEmpty */ %>
      </div></td>
    </tr>
    <%                
       //rs1__index++; // 為顯示不同底色資料列
       rs_hasData = rsM.next();   
       }	    // End of While loop   
		 rsM.close();
		 stateM.close();
		 //}//end of else --> imei="IMEI"
		 } //end of try
           catch (Exception e)
         {
         out.println("Exception:"+e.getMessage());		  
         }  	
	 //} //end of if
	 //Query = "Y";
    %>
    <tr>
      <td colspan="8"><div align="left"></div></td>
    </tr>
  </table>
</FORM>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong><A HREF="<%=MM_moveFirst%>">第一頁</A></strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong><A HREF="<%=MM_movePrev%>">上一頁</A></strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong><A HREF="<%=MM_moveNext%>">下一頁</A></strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong><A HREF="<%=MM_moveLast%>">最後一頁</A></strong></font></pre>
      </div></td>
  </tr>
</table>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>