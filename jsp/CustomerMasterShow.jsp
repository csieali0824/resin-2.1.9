<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
  function Submit(URL)
 {  
  document.MYFORM.action=URL;
  document.MYFORM.submit();
 }
 
 function noSourceExplorer() {
	if (event.button==2 | event.button==3) {alert("此功能失效");}
} // end function
if (navigator.appName.indexOf("Internet Explorer")!=-1) document.onmousedown = noSourceExplorer;


//不能使用Ctrl鍵
var travel=true
var hotkey=17　 
function gogo(e) { 
	if (document.layers) {
　　	if (e.which==hotkey&&travel){alert("此功能失效");} 
	} else if (document.all) {
	　　if (event.keyCode==hotkey&&travel){ alert("此功能失效"); }
	} // end if-else
} // end function
document.onkeydown=gogo ;
</script>
<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Customer Master Inquiry</title>

</head>
<body>
<A HREF="/wins/WinsMainMenu.jsp">回首頁</A>  
<FORM ACTION="../jsp/CustomerMasterShow.jsp" METHOD="post" NAME="MYFORM" >
  <font color="#000000" face="Arial Black"><strong>
  </strong></font>
  <font color="#000000" face="Arial Black"><strong>
  </strong></font>
  <table width="100%" border="0">
    <tr> 
      <td>
        <%
          int rs1__numRows = 50;
          int rs1__index = 0;
          int rs_numRows = 0;
          rs_numRows += rs1__numRows;
        %> 
        <% 
	      String custno=request.getParameter("CUSTNO");			
		  String custname=request.getParameter("CUSTNAME"); 	   
		  String contact=request.getParameter("CONTACT");
		  String sarea = request.getParameter("SAREA");
		  String userID = request.getParameter("USERID");
	      String LoginID="T"+userID;
          String roleName = "";
		  //out.println("Step1");
		  //out.print("userID"+userID);
		  
		  if (custno=="null" || custno.equals("null")) { custno = null; }
		  if (custname=="null" || custname.equals("null") ) { custname = null; }
		  if (contact=="null" || contact.equals("null"))  {  contact= null; }
		  if (sarea=="null" || sarea.equals("null")) { sarea=null; } 
		  if (userID=="null" || userID.equals("null")  ) {   userID=null; } 
		  
	      String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";
	      String Query = "N";     
          int numRow = 0;
	      String colorStr = "";	   
	   %>
       </td>
    </tr>	
  </table> 
  <table width="20%" border="0">
  <tr>
       <%   
		//out.println("Step2");
	     try
          { 
		   
		   String sql="select ROLENAME from WSUSER,WSGROUPUSERROLE where USERNAME =GROUPUSERNAME and ROLENAME in ('admin','Audit_Admin') and WEBID='"+userID+"' ";
		   Statement stmentRole =con.createStatement();
		   ResultSet rsRole=stmentRole.executeQuery(sql);
		   //out.print("sql"+sql);
		   String sqlCust="";
		   if (rsRole.next())
		      {
               roleName = rsRole.getString("ROLENAME");
			   //Admin權限可以看所有客戶主檔資料
			   sqlCust="select CCUST,trim(CNME),trim(CCON),trim(CPHON),trim(CCON),trim(SNAME),trim(SMFAXN) from rcm,ssm where CMID='CM' and SID in('SM','SZ') "+
		               " and CSAL=SSAL ";
			  } 
		   else 
		      {
			   //USER 權限只能看所屬客戶資料
			   sqlCust="select CCUST,trim(CNME),trim(CCON),trim(CPHON),trim(CCON),trim(SNAME),trim(SMFAXN) from rcm,ssm where CMID='CM' and SID in ('SM','SZ') "+
		               "and CSAL=SSAL ";   // 解除業務員需為查詢人方可視客戶詳細資料,但若非查詢人本身,僅能看到客戶代號及客戶名稱!
                      // "and SMFAXN='"+LoginID+"' ";
			  }	  
		   rsRole.close();
		   stmentRole.close();

		   Statement stmentCust=bpcscon.createStatement();
		   //out.print("sqlCust"+sqlCust);
    	   String sWhere = "";
           if ((custno==null || custno.equals("")) && (contact==null || contact.equals("")) && (custname==null || custname.equals("")))
		      {}
		   else if (custno !=null && (contact==null || contact.equals("")) && (custname==null || custname.equals("")))
		   	  {sWhere = sWhere + "and  CCUST ='"+custno+"' ";}
		   else if (custname !=null &&  (custno==null || custno.equals("")) && (contact==null || contact.equals("")))
		      {sWhere = sWhere + "and (CNME like '%"+custname+"%') ";} 
		   else if (contact !=null && (custno==null || custno.equals("")) && (custname==null || custname.equals("")))
		      {sWhere = sWhere + "and CCON like '%"+contact+"%' ";}
		  else if (custno !=null && custname !=null && (contact==null || contact.equals("")))
		      {sWhere = sWhere + "and CCUST='"+custno+"' and CNME like '%"+custname+"%' ";}	  
		   else if (custno !=null && contact !=null && (custname==null || custname.equals("")))
		      {sWhere = sWhere + "and CCUST='"+custno+"' and  CCON like '%"+contact+"%' ";}
		   else if (contact !=null && custname !=null && (custno==null || custno.equals("")))	  
		      {sWhere = sWhere + "and CCON like '%"+contact+"%'  and cnme like '%"+custname+"%' ";}
		   else 
		      {sWhere = sWhere + "and CCUST='"+custno+"' and CNME like '%"+custname+"%' and CCON like '%"+contact+"%' ";}  
			// 2005/06/21 加入可依利潤中心為條件  
			if (sarea==null || sarea.equals("") || sarea.equals("--")) { }
			else { sWhere = sWhere + "and trim(cmdpfx)||trim(cloc) = '"+sarea+"' "; }
	   		   	   
		   sWhere = sWhere + "ORDER BY CCUST";	      		         
		   sqlCust = sqlCust+sWhere;
		  //out.println(sqlCust);
		   ResultSet rsCust=stmentCust.executeQuery(sqlCust);
		   
// 加入分頁-起	   

		 boolean rs_isEmpty = !rsCust.next();
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

ResultSet MM_rs = rsCust;
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
  rsCust.close();
  rsCust=stmentCust.executeQuery(sqlCust);
  rs_hasData = rsCust.next();
  MM_rs = rsCust;

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
%>        
  </tr>
  <tr align="left" bordercolor="#000000" > 
  
    <td width="24%"> 
      <div align="left">
        <pre><font color="#FF0000" face="新細明體" size="2"><strong><A HREF="<%=MM_moveFirst%>">第一頁</A></strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="left">
        <pre><font color="#FF0000" face="新細明體" size="2"><strong><A HREF="<%=MM_movePrev%>">上一頁</A></strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="left">
        <pre><font color="#FF0000" face="新細明體" size="2"><strong><A HREF="<%=MM_moveNext%>">下一頁</A></strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="left">
        <pre><font color="#FF0000" face="新細明體" size="2"><strong><A HREF="<%=MM_moveLast%>">最後頁</A></strong></font></pre>
      </div></td>
  </tr>
  </table>  
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF" >
    <tr><td align="center" colspan="6"><strong><font color="#0000FF" size="+2" face="Arial">Customer Master Inquiry </font></strong>    
	   </td></tr>
    <tr bgcolor="#CCFFFF" > 
      <td width="15%"><div align="center"><font size="2"><font face="新細明體">Customer 
          No</font></font></div></td>
      <td width="30%"><div align="center"><font size="2"><font face="新細明體">Customer 
          Name</font></font></div></td>
      <td width="15%"><div align="center"><font size="2"><font face="新細明體">Alpha 
          Search</font></font></div></td>
      <td width="15%"><div align="center"><font size="2" face="新細明體">Phone</font></div></td>
      <td width="15%"><div align="center"><font size="2" face="新細明體">Contact</font></div></td>
	  <td width="10%"><div align="center"><font size="2" face="新細明體">Sales</font></div></td>
    </tr>  

<%

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
             if (rsCust.getString(1) !=null && !rsCust.getString(1).equals(" ")) { out.println(rsCust.getString(1) ); } 
             else { out.println("&nbsp;"); }
         %>
        </strong></font></td>
      <td nowrap><font color="#993366" size="2"><strong><% if (rsCust.getString(2)!=null && !rsCust.getString(2).equals("") ) out.println(rsCust.getString(2)); else out.println("&nbsp");%></strong></font></td>
      <td nowrap><font color="#993366" size="2"><strong>
             <% if (rsCust.getString(3)!=null && !rsCust.getString(3).equals("")) 
                {   
                    if (rsCust.getString(7)==LoginID || rsCust.getString(7).equals(LoginID) || roleName=="admin" || roleName.equals("admin") )
                     { out.println(rsCust.getString(3)); }
                     else { out.println("XXXXXXXX"); } 
                }
                else {
                       out.println("&nbsp");
                     }   
             %></strong></font></td>
	  <td nowrap><font color="#993366" size="2"><strong>
             <% 
                  if (rsCust.getString(4)!=null && !rsCust.getString(4).equals("")) 
                  {  //out.println(LoginID); out.println(rsCust.getString(7));
                     if (rsCust.getString(7)==LoginID || rsCust.getString(7).equals(LoginID) || roleName=="admin" || roleName.equals("admin") )
                     { out.println(rsCust.getString(4)); }
                     else { out.println("XXXXXXXX"); }
                  } 
                  else { out.println("&nbsp"); }
             %></strong></font></td>
	  <td nowrap><font color="#993366" size="2"><strong>
             <% 
                  if (rsCust.getString(5)!=null && !rsCust.getString(5).equals("")) 
                  { 
                     if (rsCust.getString(7)==LoginID || rsCust.getString(7).equals(LoginID) || roleName=="admin" || roleName.equals("admin") )     
                     { out.println(rsCust.getString(5)); }
                     else { out.println("XXXXXXXX"); }
                  }
                  else { out.println("&nbsp"); }
             %></strong></font></td
	  ><td nowrap><font color="#993366" size="2"><strong><%if (rsCust.getString(6)!=null && !rsCust.getString(6).equals("")) out.println(rsCust.getString(6)); else out.println("&nbsp");%></strong></font></td
    ></tr>
    <tr> 
      <td colspan="6" bgcolor="#CCFFFF"> <div align="center"> 
          <% if (rs_isEmpty) { out.println("rs_isEmpty"+rs_isEmpty);%>
          <font color="#CC0066" size="2"><strong>目前資料庫查無符合查詢條件的資料</strong></font> 
          <% } /* end RpRepair_isEmpty */ %>
        </div></td>
    </tr>
    <%                
       //rs1__index++; // 為顯示不同底色資料列
       rs_hasData = rsCust.next();   
       }	    // End of While loop   
		 rsCust.close();
		 stmentCust.close();
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
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>