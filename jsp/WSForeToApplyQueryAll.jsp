<%@ page language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QueryAllEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<html>
<head>
<title>Query All Sales Forecast that need to approve </title>
<style type="text/css">
<!--
.style1 {color: #FFFFFF}
-->
</style>
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
  location.href="../jsp/WSForeToApplyQueryAll.jsp?SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&STATUS="+document.MYFORM.STATUS.value;
}
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="queryAllEditBean" scope="session" class="QueryAllEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%   
  String searchString=request.getParameter("SEARCHSTRING");
  if (searchString==null) searchString="";
  String status=request.getParameter("STATUS");  
  String fromYearString="",fromMonthString="",fromDayString="",toYearString="",toMonthString="",toDayString=""; 
  String queryDateFrom="",queryDateTo=""; 
  String fromYear=request.getParameter("FROMYEAR");  
  if (fromYear==null || fromYear.equals("--") || fromYear.equals("null")) fromYearString="2000"; else fromYearString=fromYear;
  String fromMonth=request.getParameter("FROMMONTH"); 
  if (fromMonth==null || fromMonth.equals("--") || fromMonth.equals("null")) fromMonthString="01"; else fromMonthString=fromMonth; 
  queryDateFrom=fromYearString+fromMonthString;//設為搜尋收件起始日期的條件
  String toYear=request.getParameter("TOYEAR");
  if (toYear==null || toYear.equals("--") || toYear.equals("null")) toYearString="3000"; else toYearString=toYear;
  String toMonth=request.getParameter("TOMONTH");
  if (toMonth==null || toMonth.equals("--") || toMonth.equals("null")) toMonthString="12"; else toMonthString=toMonth; 
  queryDateTo=toYearString+toMonthString;//設為搜尋收件截止日期的條件
  int maxrow=0;//查詢資料總筆數 
  
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);   
  ResultSet rs=null;
  String sql="";    
 try
  {       
   if (status!=null && !status.equals("--"))
   {
      if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  {	
	    sql="select count(*) from PSALES_FORE_APP_HD where STATUS='"+status+"' and DOCNO like '"+searchString+"%' and RQYEAR||RQMONTH between '"+queryDateFrom+"' and '"+queryDateTo+"' and TYPE!='999'";
	  } else {
	    sql="select count(*) from PSALES_FORE_APP_HD where STATUS='"+status+"' and RQYEAR||RQMONTH between '"+queryDateFrom+"' and '"+queryDateTo+"' and TYPE!='999'";
	  }
   } else {
      if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  {
         sql="select count(*) from PSALES_FORE_APP_HD where DOCNO like '"+searchString+"%' and RQYEAR||RQMONTH between '"+queryDateFrom+"' and '"+queryDateTo+"' and TYPE!='999'";
	  } else {
	     sql="select count(*) from PSALES_FORE_APP_HD where STATUS!='--' and RQYEAR||RQMONTH between '"+queryDateFrom+"' and '"+queryDateTo+"' and TYPE!='999'";
	  }
   }      
   
   //取得資料總筆數
   if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("MCUser")>=0) //若為Admin或者物管MCUser則可看到全部
   {	    
	  rs=statement.executeQuery(sql);	 
   } else {     //否則只有文件建立者或文件已簽核人員或下一個簽核人員可以看到
	  rs=statement.executeQuery(sql+" and (CREATEDBY='"+userID+"' or DOCNO in (select Unique DOCNO from PSALES_FORE_APP_HIST where WHO='"+userID+"'))");	 	 
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
<FORM NAME="MYFORM" METHOD="POST"> 
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>Purchase Requirement for Forecast </strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back
to submenu</A>
<table width="100%" border="0">
  <tr bgcolor="0099CC">
    <td width="18%"><span class="style1">STATUS:</span>
      <%
try
{         
   String a[]={"IN_PROGRESS","COMPLETE","REJECT"};	
   arrayComboBoxBean.setArrayString(a);  
   arrayComboBoxBean.setFieldName("STATUS");	             		    	
   arrayComboBoxBean.setSelection(status);
   out.println(arrayComboBoxBean.getArrayString());		
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}	
%></td>
    <td width="21%"><span class="style1">Doc No:</span>
      <INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>      </td>
    <td width="46%"><span class="style1">Set the query date-&gt;&gt;</span>
      <%
     try
      {	   
       String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
       arrayComboBoxBean.setArrayString(a);	   
	   if (fromYear!=null) arrayComboBoxBean.setSelection(fromYearString); 
	   arrayComboBoxBean.setFieldName("FROMYEAR");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      <span class="style1">/</span>
      <%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
       arrayComboBoxBean.setArrayString(a);
	   if (fromMonth!=null) arrayComboBoxBean.setSelection(fromMonth);     	   
	   arrayComboBoxBean.setFieldName("FROMMONTH");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      <span class="style1">~ TO</span>
      <%
     try
      {	   
       String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
       arrayComboBoxBean.setArrayString(a);	   
	   if (toYear!=null) arrayComboBoxBean.setSelection(toYear); 
	   arrayComboBoxBean.setFieldName("TOYEAR");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      <span class="style1">/</span>
      <%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
       arrayComboBoxBean.setArrayString(a);
	   if (toMonth!=null) arrayComboBoxBean.setSelection(toMonth);     	   
	   arrayComboBoxBean.setFieldName("TOMONTH");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></td>
    <td width="15%"><input name="search" type=button onClick="searchDocNo()" value='<-Query'></td>
  </tr>
  <tr>
    <td colspan="4"><%    
 try
  {       
   if (status!=null && !status.equals("--"))
   {
      if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  {	
	    sql="select DOCNO,REGION,LOCALE_ENG_NAME as COUNTRY,STATUS,USERNAME||'('||NEXTPRCSMAN||')' as NEXTPRCSMAN,RQYEAR||'/'||RQMONTH as TARGET_DATE from PSALES_FORE_APP_HD,WSUSER,WSLOCALE where COUNTRY=LOCALE and STATUS='"+status+"' and NEXTPRCSMAN=WEBID(+) and DOCNO like '"+searchString+"%' and RQYEAR||RQMONTH between '"+queryDateFrom+"' and '"+queryDateTo+"' and TYPE!='999'";
	  } else {
	    sql="select DOCNO,REGION,LOCALE_ENG_NAME as COUNTRY,STATUS,USERNAME||'('||NEXTPRCSMAN||')' as NEXTPRCSMAN,RQYEAR||'/'||RQMONTH as TARGET_DATE from PSALES_FORE_APP_HD,WSUSER,WSLOCALE where COUNTRY=LOCALE and STATUS='"+status+"' and NEXTPRCSMAN=WEBID(+) and RQYEAR||RQMONTH between '"+queryDateFrom+"' and '"+queryDateTo+"' and TYPE!='999'";
	  }
   } else {
      if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  {
         sql="select DOCNO,REGION,LOCALE_ENG_NAME as COUNTRY,STATUS,USERNAME||'('||NEXTPRCSMAN||')' as NEXTPRCSMAN,RQYEAR||'/'||RQMONTH as TARGET_DATE from PSALES_FORE_APP_HD,WSUSER,WSLOCALE where COUNTRY=LOCALE and DOCNO like '"+searchString+"%' and NEXTPRCSMAN=WEBID(+) and RQYEAR||RQMONTH between '"+queryDateFrom+"' and '"+queryDateTo+"' and TYPE!='999'";
	  } else {
	     sql="select DOCNO,REGION,LOCALE_ENG_NAME as COUNTRY,STATUS,USERNAME||'('||NEXTPRCSMAN||')' as NEXTPRCSMAN,RQYEAR||'/'||RQMONTH as TARGET_DATE from PSALES_FORE_APP_HD,WSUSER,WSLOCALE where COUNTRY=LOCALE and NEXTPRCSMAN=WEBID(+) and RQYEAR||RQMONTH between '"+queryDateFrom+"' and '"+queryDateTo+"' and TYPE!='999'";
	  }
   }     
   
   if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("MCUser")>=0) //若為Admin或者物管MCUser則可看到全部
   {	    
	  rs=statement.executeQuery(sql+" order by DOCNO DESC");	 
   } else {     
	  rs=statement.executeQuery(sql+" and (CREATEDBY='"+userID+"' or DOCNO in (select Unique DOCNO from PSALES_FORE_APP_HIST where WHO='"+userID+"')) order by DOCNO DESC");	 	 
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
   	
   String a[]={"","DOC NO","REGION","COUNTRY","STATUS","NEXT PROCESS BY","TARGET DATE"};	
   queryAllEditBean.setPageURL("../jsp/WSForeToApprove.jsp");  
   queryAllEditBean.setHeaderArray(a);   
   queryAllEditBean.setSearchKey("DOCNO");  
   queryAllEditBean.setRowColor1("B0E0E6");
   queryAllEditBean.setRowColor2("ADD8E6");
   queryAllEditBean.setRs(rs);   
   queryAllEditBean.setScrollRowNumber(100);
       
   out.println(queryAllEditBean.getRsString());   
   
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
