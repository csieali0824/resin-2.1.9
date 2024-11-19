<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<html>
<head>
<STYLE TYPE='text/css'>
  .style1 {color: #003399}
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
</STYLE>
<title>Query All Sea(C) Shipment Defferd status</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
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
function searchRepNo(svrTypeNo,statusID,pageURL) 
{   
  location.href="../jsp/TSDefferedSEAQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value ;
}
function searchIQCDocNo(statusID,pageURL) 
{   
  location.href="../jsp/TSDefferedSEAQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value ;
}
function submitCheck(ms1,ms2)
{  
  if (document.MYFORM.ACTIONID.value=="--")  //表示沒選任何動作
  {       
   return(false);
  } 
  
  if (document.MYFORM.ACTIONID.value=="004")  //表示為CANCE動作
  { 
   flag=confirm(ms1);      
   if (flag==false)  return(false);
  } 
  /*
  if (document.MYFORM.ACTIONID.value=="013")  //表示為選擇ABORT動作,要求使用者確認是否客戶相同,方產生新的交期詢問單
  { 
   flag=confirm(ms1);      
   if (flag==false)  return(false);
  }
 */
  if ( document.MYFORM.ACTIONID.value=="005" & (document.MYFORM.CHANGEREPPERSONID==null || document.MYFORM.CHANGEREPPERSONID.value=="--")  )
   { 
    alert(ms2);   
    return(false);
   }  
   return(true);      
}  
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="array2DMOContactInfoBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="array2DMODeliverInfoBean" scope="session" class="Array2DimensionInputBean"/>
<%   
  String searchString=request.getParameter("SEARCHSTRING");
  if (searchString==null) searchString="";
  String statusID=request.getParameter("STATUSID");  
  String statusDesc="",statusName="";
  String pageURL=request.getParameter("PAGEURL");
  String svrTypeNo=request.getParameter("SVRTYPENO");    
  String fromYearString="",fromMonthString="",fromDayString="",toYearString="",toMonthString="",toDayString=""; 
  String queryDateFrom="",queryDateTo=""; 
  String fromYear=request.getParameter("FROMYEAR");  
  if (fromYear==null || fromYear.equals("--") || fromYear.equals("null")) fromYearString="2000"; else fromYearString=fromYear;
  String fromMonth=request.getParameter("FROMMONTH"); 
  if (fromMonth==null || fromMonth.equals("--") || fromMonth.equals("null")) fromMonthString="01"; else fromMonthString=fromMonth; 
  String fromDay=request.getParameter("FROMDAY");
  if (fromDay==null || fromDay.equals("--") || fromDay.equals("null")) fromDayString="01"; else fromDayString=fromDay;
  queryDateFrom=fromYearString+fromMonthString+fromDayString;//設為搜尋收件起始日期的條件
  String toYear=request.getParameter("TOYEAR");
  if (toYear==null || toYear.equals("--") || toYear.equals("null")) toYearString="3000"; else toYearString=toYear;
  String toMonth=request.getParameter("TOMONTH");
  if (toMonth==null || toMonth.equals("--") || toMonth.equals("null")) toMonthString="12"; else toMonthString=toMonth; 
  String toDay=request.getParameter("TODAY");
  if (toDay==null || toDay.equals("--") || toDay.equals("null")) toDayString="31"; else toDayString=toDay; 
  queryDateTo=toYearString+toMonthString+toDayString;//設為搜尋收件截止日期的條件
  int maxrow=0;//查詢資料總筆數 
  
   
 try
  {   
   Statement statement=con.createStatement();
   ResultSet  rs=statement.executeQuery("select LOCALDESC,STATUSNAME from ORADDMAN.TSWFSTATDESCRF where STATUSID='"+statusID+"' and LOCALE='"+locale+"'");
   Statement lotStat=con.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集
   String sql=null;
   rs.next();
   statusDesc=rs.getString("LOCALDESC");
   statusName=rs.getString("STATUSNAME");   
  
   
   rs.close();  
   
   //取得資料總筆數
   if (UserRoles.indexOf("admin")>=0) //若為admin則可看到全部
   {	 
     if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	 {	  
	    
		lotRs=lotStat.executeQuery("select count(a.INTERFACE_TRANSACTION_ID) from APPS.TSC_RCV_TRANSACTIONS_INTERFACE a, OE_ORDER_HEADERS_ALL b where a.OE_ORDER_HEADER_ID = b.HEADER_ID and to_char(b.ORDER_NUMBER)='"+searchString+"'");	
		lotRs.next();
	    if (lotRs.getInt(1)>0) //若有存在批號的話
	    {		   
	       rs=statement.executeQuery("select count(a.INTERFACE_TRANSACTION_ID) from APPS.TSC_RCV_TRANSACTIONS_INTERFACE a, OE_ORDER_HEADERS_ALL b where a.OE_ORDER_HEADER_ID = b.HEADER_ID and trim(a.STATUSID)='"+statusID+"' and to_char(b.ORDER_NUMBER)='"+searchString+"' and substr(a.J_CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	    } else {		   
           rs=statement.executeQuery("select count(a.INTERFACE_TRANSACTION_ID) from APPS.TSC_RCV_TRANSACTIONS_INTERFACE a, OE_ORDER_HEADERS_ALL b where a.OE_ORDER_HEADER_ID = b.HEADER_ID and trim(a.STATUSID)='"+statusID+"' and (to_char(b.ORDER_NUMBER) like '"+searchString+"%'  or a.PACKING_SLIP like '"+searchString+"%' ) and substr(a.J_CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
        } //end of lotRs if
		  
     } else { 	 
	          rs=statement.executeQuery("select count(a.INTERFACE_TRANSACTION_ID) from APPS.TSC_RCV_TRANSACTIONS_INTERFACE a, OE_ORDER_HEADERS_ALL b where a.OE_ORDER_HEADER_ID = b.HEADER_ID and trim(a.STATUSID)='"+statusID+"' and substr(a.J_CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	        }	 
   } 		   
   
   rs.next();   
   maxrow=rs.getInt(1);
    
   statement.close();
   rs.close();   
   if (lotRs!=null) lotRs.close();
   lotStat.close();
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
	 rowNumber=maxrow-300;	 	 	   
   } else {     
	 rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     qryAllChkBoxEditBean.setRowNumber(rowNumber);
   }	 
  }          
  
  int currentPageNumber=0,totalPageNumber=0;
  totalPageNumber=maxrow/300+1;
  if (rowNumber==0 || rowNumber<0)
  {
    currentPageNumber=rowNumber/301+1;  
  } else {
    currentPageNumber=rowNumber/300+1; 
  }	
  if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" onsubmit='return submitCheck("確認取消","確認特採項目")' ACTION="../jsp/TSDefferedSEAMBatchProcess.jsp?FORMID=DS&FROMSTATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>" METHOD="POST"> 
<strong><font color="#0080C0" size="5">銷售訂單延遲出貨處理</font></strong><FONT COLOR=RED SIZE=4>&nbsp;&nbsp;單據狀態:<%=statusName%>(<%=statusDesc%>)</FONT><FONT COLOR=BLACK SIZE=2>(總共<%=maxrow%>&nbsp;筆記錄)</FONT>
<table width="100%" border="0">
  <tr>
    <td width="16%"> <input name="button" type=button onClick="this.value=check(this.form.CH)" value='選擇全部'>
      &nbsp;&nbsp;</td>
    <td width="84%"><strong><font color="#400040" size="2">請輸入銷售訂單號,發票號:</font></strong>
<INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
      <input name="search" type=button onClick="searchIQCDocNo('<%=statusID%>','<%=pageURL%>')" value='<-查詢'> 
    </td>
  </tr>
</table>
<A HREF="../jsp/TSDropShipQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=FIRST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSDefferedSEAQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=LAST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080">最終頁</font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSDefferedSEAQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>">下一頁</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSDefferedSEAQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=-300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>">前一頁</A>&nbsp;&nbsp;(第<%=currentPageNumber%>&nbsp;頁/共<%=totalPageNumber%>&nbsp;頁)</font></strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;發票日期
:FROM
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
/
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
/
<%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
       arrayComboBoxBean.setArrayString(a);  	   	   
	   if (fromDay!=null) arrayComboBoxBean.setSelection(fromDay);
	   arrayComboBoxBean.setFieldName("FROMDAY");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
%>
~
TO
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
/
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
       %>
/
<%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
       arrayComboBoxBean.setArrayString(a);  	   	   
	   if (toDay!=null) arrayComboBoxBean.setSelection(toDay); 
	   arrayComboBoxBean.setFieldName("TODAY");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
%>
  <%   
 try
  {   
   //out.println("Step1");
  
   Statement lotStat=con.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集   
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql=null;  
   if (UserRoles.indexOf("admin")>=0) //若角色為admin則可看到全部檢驗單
   {      	 	 
       if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	   {
	      lotRs=lotStat.executeQuery("select count(*) from APPS.TSC_RCV_TRANSACTIONS_INTERFACE a, OE_ORDER_HEADERS_ALL b where a.OE_ORDER_HEADER_ID = b.HEADER_ID and trim(a.STATUSID)='"+statusID+"' and to_char(b.ORDER_NUMBER) ='"+searchString+"'");	
 		  lotRs.next();
	      if (lotRs.getInt(1)>0) //若有存在批號的話
	      { 
		    rs=statement.executeQuery("select a.INTERFACE_TRANSACTION_ID as INTTXN_ID, a.PACKING_SLIP, b.ORDER_NUMBER as 訂單號,a.OE_ORDER_HEADER_ID as 訂單識別碼, a.OE_ORDER_LINE_ID as 項次識別碼, a.LAST_UPDATE_DATE as 更新日,a.LAST_UPDATED_BY as 執行人員, a.PRIMARY_QUANTITY as 數量, a.PRIMARY_UNIT_OF_MEASURE as 單位, a.ITEM_ID as 料號識別碼, a.ITEM_DESCRIPTION as 料號說明 , a.TRANSACTION_DATE as 單據日期 from APPS.TSC_RCV_TRANSACTIONS_INTERFACE a, OE_ORDER_HEADERS_ALL b where a.OE_ORDER_HEADER_ID = b.HEADER_ID and trim(a.STATUSID)='"+statusID+"' and to_char(b.ORDER_NUMBER) ='"+searchString+"' and substr(a.J_CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INTERFACE_TRANSACTION_ID, a.PACKING_SLIP, a.TRANSACTION_DATE ASC"); 
		  } else {		   
            rs=statement.executeQuery("select a.INTERFACE_TRANSACTION_ID as INTTXN_ID, a.PACKING_SLIP, b.ORDER_NUMBER as 訂單號,a.OE_ORDER_HEADER_ID as 訂單識別碼, a.OE_ORDER_LINE_ID as 項次識別碼, a.LAST_UPDATE_DATE as 更新日,a.LAST_UPDATED_BY as 執行人員, a.PRIMARY_QUANTITY as 數量, a.PRIMARY_UNIT_OF_MEASURE as 單位, a.ITEM_ID as 料號識別碼, a.ITEM_DESCRIPTION as 料號說明 , a.TRANSACTION_DATE as 單據日期 from APPS.TSC_RCV_TRANSACTIONS_INTERFACE a, OE_ORDER_HEADERS_ALL b where a.OE_ORDER_HEADER_ID = b.HEADER_ID and trim(a.STATUSID)='"+statusID+"' and (to_char(b.ORDER_NUMBER) like '"+searchString+"%' or a.PACKING_SLIP like '"+searchString+"%') and substr(a.J_CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INTERFACE_TRANSACTION_ID, a.PACKING_SLIP, a.TRANSACTION_DATE ASC");	 	 
          }			
       } else {		          
	           rs=statement.executeQuery("select a.INTERFACE_TRANSACTION_ID as INTTXN_ID, a.PACKING_SLIP, b.ORDER_NUMBER as 訂單號,a.OE_ORDER_HEADER_ID as 訂單識別碼, a.OE_ORDER_LINE_ID as 項次識別碼, a.LAST_UPDATE_DATE as 更新日,a.LAST_UPDATED_BY as 執行人員, a.PRIMARY_QUANTITY as 數量, a.PRIMARY_UNIT_OF_MEASURE as 單位, a.ITEM_ID as 料號識別碼, a.ITEM_DESCRIPTION as 料號說明 , a.TRANSACTION_DATE as 單據日期 from APPS.TSC_RCV_TRANSACTIONS_INTERFACE a, OE_ORDER_HEADERS_ALL b where a.OE_ORDER_HEADER_ID = b.HEADER_ID and trim(a.STATUSID)='"+statusID+"' and (to_char(b.ORDER_NUMBER) like '"+searchString+"%' or a.PACKING_SLIP like '"+searchString+"%') and substr(a.J_CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INTERFACE_TRANSACTION_ID, a.PACKING_SLIP, a.TRANSACTION_DATE ASC");			   			  
	          }	  	
			  //out.println("select a.INTERFACE_TRANSACTION_ID as INTTXN_ID, a.PACKING_SLIP, b.ORDER_NUMBER as 訂單號,a.OE_ORDER_HEADER_ID as 訂單識別碼, a.OE_ORDER_LINE_ID as 項次識別碼, a.LAST_UPDATE_DATE as 更新日,a.LAST_UPDATED_BY as 執行人員, a.PRIMARY_QUANTITY as 數量, a.PRIMARY_UNIT_OF_MEASURE as 單位, a.ITEM_ID as 料號識別碼, a.ITEM_DESCRIPTION as 料號說明 , a.TRANSACTION_DATE as 單據日期 from APPS.TSC_RCV_TRANSACTIONS_INTERFACE a, OE_ORDER_HEADERS_ALL b where a.OE_ORDER_HEADER_ID = b.HEADER_ID and trim(a.STATUSID)='"+statusID+"' and (to_char(b.ORDER_NUMBER) like '"+searchString+"%' or a.PACKING_SLIP like '"+searchString+"%') and substr(a.J_CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.INTERFACE_TRANSACTION_ID, a.PACKING_SLIP, a.TRANSACTION_DATE ASC");	
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
   
   String sKeyArray[]=new String[1];   
   sKeyArray[0]="INTTXN_ID";
   // sKeyArray[1]="PACKING_SLIP";
   //sKeyArray[1]="LINE";
   //sKeyArray[2]="ASSIGN_MANUFACT";
   //sKeyArray[3]="ORDER_TYPE_ID";
   //sKeyArray[4]="LINE_TYPE";
   
   
   qryAllChkBoxEditBean.setPageURL("../jsp/"+pageURL);
   qryAllChkBoxEditBean.setPageURL2("");     
   qryAllChkBoxEditBean.setHeaderArray(null);
   //qryAllChkBoxEditBean.setSearchKey("INTTXN_ID");
   qryAllChkBoxEditBean.setSearchKeyArray(sKeyArray); // 以setSearchKeyArray取代之, 因本頁需傳遞兩個網頁參數
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setHeadColor("#D8DEA9");
   qryAllChkBoxEditBean.setHeadFontColor("#0066CC");
   qryAllChkBoxEditBean.setRowColor1("#E3E4B6");
   qryAllChkBoxEditBean.setRowColor2("#ECEDCD");
   //qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setTableWrapAttr("nowrap");
   qryAllChkBoxEditBean.setRs(rs);   
   qryAllChkBoxEditBean.setScrollRowNumber(300);       
   out.println(qryAllChkBoxEditBean.getRsString());   
   statement.close();
   rs.close();
   if (lotRs!=null) lotRs.close();
   lotStat.close();
   //取得處理狀態      
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
  <%
	  try
      {       
	   //if (statusID.equals("003") || UserRoles.equals("admin") )
	   if (statusID.equals("103"))
	   {
         Statement statement=con.createStatement();         		 		 
		 ResultSet rs=statement.executeQuery("select MANUFACTORY_NO,MANUFACTORY_NO||'('||MANUFACTORY_NAME||')' from ORADDMAN.TSPROD_MANUFACTORY where LOCALE > '0' order by MANUFACTORY_NO");
         comboBoxBean.setRs(rs);	   
	     comboBoxBean.setFieldName("CHANGEREPCENTERNO");	
		 out.println("<table width='100%'><tr bgcolor='#FFFF99'>"); 
		 out.println("<td>");%>單據轉送<%out.println("<strong><font color='#FF0000'>:");
         out.println(comboBoxBean.getRsString()); 		 
		 
		 statement.close();
         rs.close();       
		} //end if of "003" condition 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
  %>
  <%
	  try
      {       
       //  
	      
	   if (statusID.equals("080"))
	   { 
	     String sqlAct = null;
		 String whereAct = null;
		 		 
		
		   sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
		   whereAct = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";		   
									  
		 if (UserRoles.equals("admin")) whereAct = whereAct+"";  //若是管理員,則任何動作不受限制
		 else {		        
				  whereAct = whereAct+"and FORMID='DS' "; // 一律皆為DropShip (DS) = DamnShit
		      }
	       
	     sqlAct = sqlAct + whereAct; //out.println(sqlAct);
         Statement statement=con.createStatement();
         ResultSet rs=statement.executeQuery(sqlAct);
         comboBoxBean.setRs(rs);
	     comboBoxBean.setFieldName("ACTIONID");	 
		 out.println("</font></strong></td><TR><TR><td>");%>備註<%out.println(":<INPUT TYPE='TEXT' NAME='REMARK' SIZE=60></td></tr></table>");
         // 2005-05-13 add 038 
		
	     out.println("<strong><font color='#FF0000'>");%>執行動作-><%out.println("</font></strong>");
         out.println(comboBoxBean.getRsString());    
		 
		 String sqlCnt = "select COUNT (*) from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFACTION x2 ";
		 String whereCnt = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";       
									  
		 if (UserRoles.equals("admin")) whereCnt = whereCnt+" and FORMID='DS' ";  //若是管理員,則任何動作不受限制	 
	
		 sqlCnt = sqlCnt + whereCnt;
	     rs=statement.executeQuery(sqlCnt);
	     rs.next();
	     if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	     {	      
           out.println("<INPUT TYPE='submit' NAME='submit' value='Submit'>");
		   if (statusID.equals("003") || statusID.equals("004") || statusID.equals("017") )
		   {
		     out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>寄發郵件通知<%
           }			 
	     } 
		 
		 statement.close();		 
         rs.close();       
		} //end of if "003":"008":"010":"006":"015":"016":"017" 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
 %>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

