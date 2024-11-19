<%@ page language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<html>
<head>
<title>Query All Sales Forecast that need to approve </title>
</head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
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
function searchDocNo() 
{   
  location.href="../jsp/WSForeToApproveQueryAll.jsp?SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value;
}
function submitCheck()
{  
  if (document.MYFORM.ACTION.value=="--")  //表示沒選任何動作
  {       
   return(false);
  }   
  
  flag=confirm("Submit Confirm with "+document.MYFORM.ACTION.value+"?");  
  if (flag!=true)
  {
   return flag;   
  } 
 
  document.MYFORM.submit();      
}  
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
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
	 sql="select count(*) from PSALES_FORE_APP_HD where STATUS='IN_PROGRESS' and DOCNO like '"+searchString+"%' and TYPE!='999'";	
   } else {    
	 sql="select count(*) from PSALES_FORE_APP_HD where STATUS='IN_PROGRESS' and TYPE!='999'";	  
   }   
   
   //取得資料總筆數
   if (UserRoles.indexOf("admin")>=0) //若為Admin則可看到全部
   {	    
	  rs=statement.executeQuery(sql);	 
   } else {     
	  rs=statement.executeQuery(sql+" and NEXTPRCSMAN='"+userID+"'");	 	 
   }   
   rs.next();   
   maxrow=rs.getInt(1);    
   
   rs.close();   
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  } 
  
  String scrollRow=request.getParameter("SCROLLROW");    
  int rowNumber=qryAllChkBoxEditBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   qryAllChkBoxEditBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {  	 	 
	 qryAllChkBoxEditBean.setRowNumber(maxrow);	 
	 rowNumber=maxrow-100;	 	 	   
   } else {     
	 rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     qryAllChkBoxEditBean.setRowNumber(rowNumber);
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
<strong>Purchase Requirement Approval for  Forecast</strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="/wins/WinsMainMenu.jsp">HOME</A>
&nbsp;&nbsp;&nbsp;&nbsp;Doc No:
<INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
<input name="search" type=button onClick="searchDocNo()" value='<-search'>
<table width="100%" border="0">
  <tr bgcolor="0099CC">
    <td width="9%">
&nbsp;
<input name="button" type=button onClick="this.value=check(this.form.CH)" value='Select All'></td>
    <td width="25%"><font color="#333399" face="Arial Black">ACTION:</font>
      <%
try
{   
   if (true)
   {      
     String a[]={"AGREE","REJECT"};	
	 arrayComboBoxBean.setArrayString(a);  
   } else {
     String a[]={""};	
	 arrayComboBoxBean.setArrayString(a);
   }         		 
   arrayComboBoxBean.setFieldName("ACTION");	             		    	
   out.println(arrayComboBoxBean.getArrayString());		
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}	
%>
      <input name="Button" type="Button" onClick='submitCheck()' value="Submit"></td>
    <td width="66%" class="style2"><font color="#333399" face="Arial Black"><strong>Comment:</strong></font>
      <input name="COMMENT" type="text" size="40">
    </td>
  </tr>
  <tr>
    <td colspan="3"><%    
 try
  {         
   if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
   {	
	 sql="select DOCNO,REGION,LOCALE_ENG_NAME as COUNTRY,STATUS,USERNAME||'('||NEXTPRCSMAN||')' as NEXTPRCSMAN,RQYEAR||'/'||RQMONTH as TARGET_DATE from PSALES_FORE_APP_HD,WSLOCALE,WSUSER where COUNTRY=LOCALE and STATUS='IN_PROGRESS' and NEXTPRCSMAN=WEBID and DOCNO like '"+searchString+"%' and TYPE!='999'";	
   } else {    
	 sql="select DOCNO,REGION,LOCALE_ENG_NAME as COUNTRY,STATUS,USERNAME||'('||NEXTPRCSMAN||')' as NEXTPRCSMAN,RQYEAR||'/'||RQMONTH as TARGET_DATE from PSALES_FORE_APP_HD,WSLOCALE,WSUSER where COUNTRY=LOCALE and STATUS='IN_PROGRESS' and NEXTPRCSMAN=WEBID and TYPE!='999'";	  
   }    
   
   if (UserRoles.indexOf("admin")>=0) //若為Admin則可看到全部
   {	    
	  rs=statement.executeQuery(sql);	 
   } else {     
	  rs=statement.executeQuery(sql+" and NEXTPRCSMAN='"+userID+"'");	 	 
   }   
   
   if (rowNumber==1 || rowNumber<0)
   {
     rs.beforeFirst(); //移至第一筆資料列  
   } else { 
      if (rowNumber<=maxrow) //若小於總筆數時才繼續換頁
	  {
        rs.absolute(rowNumber); //移至指定資料列	 
	  }	
   }
   
   String a[]={"","","DOC NO","REGION","COUNTRY","STATUS","NEXT PROCESS BY","TARGET DATE"};	
   qryAllChkBoxEditBean.setPageURL("../jsp/WSForeToApprove.jsp");
   qryAllChkBoxEditBean.setPageURL2("");     
   qryAllChkBoxEditBean.setHeaderArray(a);
   qryAllChkBoxEditBean.setSearchKey("DOCNO");
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setRs(rs);   
   qryAllChkBoxEditBean.setScrollRowNumber(100);
       
   out.println(qryAllChkBoxEditBean.getRsString());   
  
   rs.close();  
   //取得維修處理狀態      
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
