<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QueryAllEditBean,RsCountBean"%>
<jsp:useBean id="queryAllEditBean" scope="session" class="QueryAllEditBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Query All Material Request Confirmation that need to reply</title>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
function searchDocNo() 
{   
  location.href="../jsp/WSFore_MRC_ReplyQueryAll.jsp?SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value;
}
</script>
<%   
  String searchString=request.getParameter("SEARCHSTRING");
  if (searchString==null) searchString=""; 
  int maxrow=0;//查詢資料總筆數 
  
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
  ResultSet  rs=null;   
  String sql="";
    
 try
 {         
   if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
   {	
	 sql="select DOCNO,STATUS,USERNAME||'('||NEXTPRCSMAN||')' as NEXTPRCSMAN,TARGETYEAR||'/'||TARGETMONTH as TARGET_DATE from PSALES_FORE_MRC_HD,WSUSER where IS_COMPLETE!='Y' and NEXTPRCSMAN=WEBID and DOCNO like '"+searchString+"%'";	
   } else {    
	 sql="select DOCNO,STATUS,USERNAME||'('||NEXTPRCSMAN||')' as NEXTPRCSMAN,TARGETYEAR||'/'||TARGETMONTH as TARGET_DATE from PSALES_FORE_MRC_HD,WSUSER where IS_COMPLETE!='Y' and NEXTPRCSMAN=WEBID";	  
   }        
  
   rs=statement.executeQuery(sql);	 
   rsCountBean.setRs(rs); //取得其line detail總筆數         
   maxrow=rsCountBean.getRsCount();   
    
 } //end of try
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 } 
  
  String scrollRow=request.getParameter("SCROLLROW");    
  int rowNumber=queryAllEditBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   queryAllEditBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {  	 	 
	 queryAllEditBean.setRowNumber(maxrow);	 
	 rowNumber=maxrow-100;	 	 	   
   } else {     
	 rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     queryAllEditBean.setRowNumber(rowNumber);
   }	 
  }          
  
  int currentPageNumber=0,totalPageNumber=0;
  totalPageNumber=maxrow/100+1;
  if (rowNumber==0 || rowNumber<0)
  {
    currentPageNumber=rowNumber/101+1;  
  } else {
    currentPageNumber=rowNumber/100+1; 
  }	
  if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
%>
<body>
<FORM NAME="MYFORM" onsubmit='return submitCheck()' ACTION="WSForeToBatchProcess.jsp" METHOD="POST"> 
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+1" face="Times New Roman"> 
<strong>Material Request Confirmation List(</strong></font><font size="+1" face="Times New Roman"><strong><span class="style1">need to reply</span></strong></font><font color="#000000" size="+1" face="Times New Roman"><strong>)</strong></font>
<BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>
&nbsp;&nbsp;&nbsp;&nbsp;Doc No:
<INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
<input name="search" type=button onClick="searchDocNo()" value='<-search'>
<table width="100%" border="0">
  <tr>
    <td width="100%"><%    
 try
 {       
   if (rowNumber==1 || rowNumber<0)
   {
     rs.beforeFirst(); //移至第一筆資料列  
   } else { 
      if (rowNumber<=maxrow) //若小於總筆數時才繼續換頁
	  {
        rs.absolute(rowNumber); //移至指定資料列	 
	  }	
   }
   
   String a[]={"","DOC NO","STATUS","NEXT PROCESS BY","TARGET DATE"};	
   queryAllEditBean.setPageURL("../jsp/WSFore_MRC_Reply.jsp");      
   queryAllEditBean.setHeaderArray(a);
   queryAllEditBean.setOptionURI("OPTION=NEW");
   queryAllEditBean.setSearchKey("DOCNO");   
   queryAllEditBean.setRowColor1("B0E0E6");
   queryAllEditBean.setRowColor2("ADD8E6");
   queryAllEditBean.setRs(rs);   
   queryAllEditBean.setScrollRowNumber(50);
       
   out.println(queryAllEditBean.getRsString());   
  
   rs.close();       
 } //end of try
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }
 %></td>
  </tr>
</table>
</FORM>
</body>
<%
 statement.close();
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
