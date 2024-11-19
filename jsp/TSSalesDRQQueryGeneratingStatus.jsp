<%@ page language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<html>
<head>
<title>Query All Sales Devivery Request Data by status</title>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
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
  location.href="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value ;
}
function searchDNDocNo(statusID,pageURL) 
{   
  location.href="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value ;
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
<jsp:useBean id="qryAllChkBoxArrayEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
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
   if (UserRoles.indexOf("admin")>=0) //若為Admin則可看到全部
   {	 
     if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	 {	  
	    
		lotRs=lotStat.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
		lotRs.next();
	    if (lotRs.getInt(1)>0) //若有存在批號的話
	    {		   
	       rs=statement.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and a.DNDOCNO ='"+searchString+"' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	    } else {
           rs=statement.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and (a.CUSTOMER like '"+searchString+"%' or a.DNDOCNO like '"+searchString+"%' or a.CUST_PO like '"+searchString+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
        } //end of lotRs if
		  
     } else { 
	   rs=statement.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	 }	 
   } else { 
           if (UserRoles.indexOf("SalesAdmin")>=0)
           {  //out.println("1"); // 若為業務管理員或PC生管人員則可檢視所有詢問單
                    
           }  // end of if (UserRoles.indexOf("Qassurer")>=0)
              
    if (statusID.equals("004") || statusID.equals("005") || statusID.equals("011")) //若為維修中或判定中狀態則select條件為維修工程師個人
	{ 
	   if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  {  
	     lotRs=lotStat.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
  		 lotRs.next();
	     if (lotRs.getInt(1)>0) //若有存在批號的話
	     {
		   sql = "select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.LSTATUSID != '010' and a.REQPERSONID='"+userID+"' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";		
		 } else {
	       sql = "select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and b.LSTATUSID != '010' and a.REQPERSONID='"+userID+"' and (a.CUSTOMER like '"+searchString+"%' or a.DNDOCNO  like '"+searchString+"%' or a.CUST_PO like '"+searchString+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";	
		 } 
			 
		 
	  } else {
		
	         }	
	 
 	  rs=statement.executeQuery(sql);	out.println("Step10"); 
    } else {
	   if (statusID.equals("009")) //若為等待生成訂單中,依各區業務,只看得到自己開立的單據
       {	
	      if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	      {
		    lotRs=lotStat.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
  		    lotRs.next();
	        if (lotRs.getInt(1)>0) //若有存在批號的話
	        {
		      sql = "select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO='"+userActCenterNo+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";		
		    } else {
	                sql = "select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO='"+userActCenterNo+"') and (a.CUSTOMER like '"+searchString+"%' or a.DNDOCNO  like '"+searchString+"%' or a.CUST_PO like '"+searchString+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";	
		           } 
       } else {
	               sql ="select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO = '"+userActCenterNo+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";
    	      }	
	      rs=statement.executeQuery(sql);	   
	   } else {
	       
	          } //end of 三級維修狀態判定
	} //end of 維修中狀態判定	  
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
  int rowNumber=qryAllChkBoxArrayEditBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   qryAllChkBoxArrayEditBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {  	 	 
	 qryAllChkBoxArrayEditBean.setRowNumber(maxrow);	 
	 rowNumber=maxrow-300;	 	 	   
   } else {     
	 rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     qryAllChkBoxArrayEditBean.setRowNumber(rowNumber);
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
<FORM NAME="MYFORM" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertCancel"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>")' ACTION="../jsp/TSSalesDRQMBatchProcess.jsp?FORMID=TS&FROMSTATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>" METHOD="POST"> 

<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgSalesDRQ"/><jsp:getProperty name="rPH" property="pgProcess"/></font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgRepStatus"/>:<%=statusName%>(<%=statusDesc%>)</FONT><FONT COLOR=BLACK SIZE=2>(<jsp:getProperty name="rPH" property="pgTotal"/><%=maxrow%>&nbsp;<jsp:getProperty name="rPH" property="pgRecord"/>)</FONT>
<table width="100%" border="0">
  <tr>
    <td width="23%"> <input name="button" type=button onClick="this.value=check(this.form.CH)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
      &nbsp;<A HREF="/oradds/OraddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>&nbsp;</td>
    <td width="77%"><strong><font color="#400040" size="2"><jsp:getProperty name="rPH" property="pgPlsEnter"/><jsp:getProperty name="rPH" property="pgQDocNo"/>,<jsp:getProperty name="rPH" property="pgCustInfo"/>,<jsp:getProperty name="rPH" property="pgCustPONo"/>:</font></strong>
<INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
      <input name="search" type=button onClick="searchDNDocNo('<%=statusID%>','<%=pageURL%>')" value='<-<jsp:getProperty name="rPH" property="pgSearch"/>'> 
    </td>
  </tr>
</table>
<A HREF="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=FIRST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080"><jsp:getProperty name="rPH" property="pgFirst"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=LAST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080"><jsp:getProperty name="rPH" property="pgLast"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><jsp:getProperty name="rPH" property="pgNext"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSSalesDRQQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=-300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><jsp:getProperty name="rPH" property="pgPrevious"/>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/></A>&nbsp;&nbsp;(<jsp:getProperty name="rPH" property="pgTheNo"/><%=currentPageNumber%>&nbsp;<jsp:getProperty name="rPH" property="pgPage"/>/<jsp:getProperty name="rPH" property="pgTotal"/><%=totalPageNumber%>&nbsp;<jsp:getProperty name="rPH" property="pgPages"/>)</font></strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgCreateFormDate"/>
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
   Statement lotStat=con.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集   
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql=null;  
   if (UserRoles.indexOf("admin")>=0) //若為Admin則可看到全部
   {   //out.println("Step11");    	 	 
       if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	   {
	      lotRs=lotStat.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
 		  lotRs.next();
	      if (lotRs.getInt(1)>0) //若有存在批號的話
	      {
		    rs=statement.executeQuery("select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and a.DNDOCNO ='"+searchString+"' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC"); 
		  } else {		   
            rs=statement.executeQuery("select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC");	 	 
          }			
       } else {	  
	           rs=statement.executeQuery("select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC");
	          }	  		
   } else {
                     
     //out.println("Step12"); 

    if (statusID.equals("004") || statusID.equals("005") || statusID.equals("011") || statusID.equals("018") || statusID.equals("021")) //若為維修中或判定中狀態則select條件為維修工程師個人
	{ 
	   if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  {
	     lotRs=lotStat.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
 		 lotRs.next();
	     if (lotRs.getInt(1)>0) //若有存在批號的話
	     {
		    sql = "select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and REQPERSONID='"+userID+"' and a.DNDOCNO ='"+searchString+"' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";	
	     } else {
		    sql = "select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and REQPERSONID='"+userID+"' and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";	     
         }
		
		 //if (statusID.equals("018"))			
		 //  { sql = "select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') and REQUIRE_DATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";	   }

      } else {
		 //if (statusID.equals("018")) //2005-05-16 add			
		 //  { sql = "select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') and REQUIRE_DATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";	   }
         //else
   	     //  { sql = "select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and REQPERSONID='"+userID+"' and REQUIRE_DATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC"; }
	  }		
	  rs=statement.executeQuery(sql);	  
    } else { //out.println("Step15");  
	  if (statusID.equals("009")) //若為業務人員生成訂單
	  {//out.println("Step16");
	      if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	     { //out.println("Step17");
		    lotRs=lotStat.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
 		    lotRs.next();
	        if (lotRs.getInt(1)>0) //若有存在批號的話
	        { //out.println("Step18");
			  sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO in (Select TSSALEAREANO from ORADDMAN.TSRECPERSON where TSSALEAREANO='"+userActCenterNo+"')) and a.DNDOCNO ='"+searchString+"' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";			 
	        } else { //out.println("Step19");
			  sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and (TSAREANO in (Select TSSALEAREANO from ORADDMAN.TSRECPERSON where TSSALEAREANO='"+userActCenterNo+"')) and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";	 
            }			  
         } else {//out.println("Step20");
	       sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,LINE_TYPE from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and b.LSTATUSID='"+statusID+"' and TSAREANO in (Select TSSALEAREANO from ORADDMAN.TSRECPERSON where TSSALEAREANO='"+userActCenterNo+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";
	     }		
		 //out.println("sql="+sql);
	     rs=statement.executeQuery(sql);
	  } else { //out.println("Step16");
	     if (statusID.equals("020")) //若狀態為準備後送中,則只有原收件中心及相屬之維修中心可看到應後送之件
		 {                                                      // 2004-10-05 028 三級完修回二級在途中
		     if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	         {
		        lotRs=lotStat.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
 		        lotRs.next();
	            if (lotRs.getInt(1)>0) //若有存在批號的話
	            {
  		           if (UserRoles.equals("Planner") && statusID.equals("028"))
 			          { sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and a.DNDOCNO ='"+searchString+"' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";}
                   else 
//			          { sql ="select REPNO,SVRDOCNO,IMEI,DSN,CMRNAME,BUYDATE,MODEL,COLOR,JAMDESC,JAMFREQ,OTHERJAMDESC,WARRTYPE,RECDATE,STATUS,SVRTYPENAME,ITEMNO,REPLVLNO,REPCENTERNO,REPPERSONID,a.REMARK from RPREPAIR where SVRTYPENO='"+svrTypeNo+"' and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (IMEI!='$' OR IMEI IS NULL) and (substr(RECCENTERNO,1,3)='"+userRepCenterNo+"') and REPNO in (select trim(REPNO) from RPREPLOT where LOTNO='"+searchString+"') and RECDATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by REPNO,RECDATE ASC"; }
			          { sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') and a.DNDOCNO ='"+searchString+"' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC"; }
			    } else {  // 無批號				   
  		           ///if (UserRoles.equals("Planner") && statusID.equals("028"))
	               ///   { sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and REQUIRE_DATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC"; }
                   ///else 
   		           ///  if (statusID.equals("020"))
 	               ///   { sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and REQUIRE_DATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC"; }
                   ///  else
 	               ///   { sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and REQUIRE_DATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC"; }
                }			   
             } else {			   
                      if (UserRoles.equals("Planner") && statusID.equals("028"))
                      { sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC"; }
                      else
                      if (statusID.equals("020"))
 	                  { sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC"; }
                      else
 	                  { sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (substr(TSAREANO,1,3)='"+userActCenterNo+"') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC"; }
	                  }			
                     /*
                      if (UserRoles.indexOf("Qassurer")>=0)
                      {  
                        if (statusID.equals("036")) // 若狀態為工廠品檢判定中,則品檢員可看任何維修件
                        {  
                             if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	                         {
	                            lotRs=lotStat.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and LOTNO='"+searchString+"'");	
 		                        lotRs.next();
	                            if (lotRs.getInt(1)>0) //若有存在批號的話
	                            {
		                          rs=statement.executeQuery("select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"' and a.DNDOCNO ='"+searchString+"') and REQUIRE_DATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC"); 
		                        } else {		   
                                          rs=statement.executeQuery("select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"'  and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"') and REQUIRE_DATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC");	 	 
                                       }			
                             } else {	 //out.println("select REPNO,SVRDOCNO,IMEI,DSN,CMRNAME,BUYDATE,MODEL,COLOR,JAMDESC,JAMFREQ,OTHERJAMDESC,WARRTYPE,RECDATE,STATUS,SVRTYPENAME,ITEMNO,REPLVLNO,REPCENTERNO,REPPERSONID,a.REMARK from RPREPAIR where trim(SVRTYPENO)='"+svrTypeNo+"' and  trim(STATUSID)='"+statusID+"' and RECDATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by REPNO,RECDATE ASC");  
	                                 rs=statement.executeQuery("select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and trim(b.LSTATUSID)='"+statusID+"'  and REQUIRE_DATE between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC");
	                                }	          
                        }  // end of if (statusID.equals("036"))       
                      }  // end of if (UserRoles.indexOf("Qassurer")>=0) 
					  */  
              rs=statement.executeQuery(sql);            
     
		 }         
          else            
          { out.println("Step17");
             if (UserRoles.indexOf("Qassurer")>=0 && (statusID.equals("036") || statusID.equals("006"))) // 2005-05-16 ADD 006
             {
                                    
             } else
               { out.println("Step18=任何狀態條件都不成立時");
 	            if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	            {
		          lotRs=lotStat.executeQuery("select count(distinct ASSIGN_MANUFACT) from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+searchString+"'");	
 		          lotRs.next();
	              if (lotRs.getInt(1)>0) //若有存在批號的話
	              {
			        sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) and a.DNDOCNO ='"+searchString+"' and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";
			      } else {
	                       sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) and (CUSTOMER like '"+searchString+"%' or DNDOCNO like '"+searchString+"%' or CUST_PO like '"+searchString+"%') and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";	 
                         }			   
                } else {
	                    sql ="select DISTINCT a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT as DNDOCNO,b.LINE_NO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,ASSIGN_MANUFACT,a.REMARK,STATUSID,STATUS,a.CREATION_DATE,a.CREATED_BY,a.LAST_UPDATE_DATE,a.LAST_UPDATED_BY,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG from ORADDMAN.TSDELIVERY_NOTICE a, ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where a.DNDOCNO = b.DNDOCNO and STATUSID='"+statusID+"' and b.LSTATUSID != '010' and (TSAREANO='"+userActCenterNo+"' or (ISTRANSFERRED='Y' and TSMANUFACTORYNO='"+userActCenterNo+"') ) and substr(a.REQUIRE_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' order by a.DNDOCNO||'-'|| b.ASSIGN_MANUFACT,REQUIRE_DATE ASC";
	                   }		               
                    
	              rs=statement.executeQuery(sql);	
              }
		 }	//enf of 是否為020準備後送三級中狀態
	  } //end of 三級維修狀態判定	 
	} //end of 維修中狀態判定	  
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
   
   
   String sKeyArray[]=new String[5];   
   sKeyArray[0]="DNDOCNO";
   sKeyArray[1]="ASSIGN_MANUFACT";
   sKeyArray[2]="ORDER_TYPE_ID";
   sKeyArray[3]="LINE_NO";
   sKeyArray[4]="LINE_TYPE";
   
   qryAllChkBoxArrayEditBean.setSubSearchStrIndx(4);	// 設定取搜尋字串-4的長度
   qryAllChkBoxArrayEditBean.setPageURL("../jsp/"+pageURL);
   qryAllChkBoxArrayEditBean.setPageURL2("");     
   qryAllChkBoxArrayEditBean.setHeaderArray(null);
   //qryAllChkBoxArrayEditBean.setSearchKey("DNDOCNO"); //
   qryAllChkBoxArrayEditBean.setSearchKeyArray(sKeyArray); // 以setSearchKeyArray取代之, 因本頁需傳遞三個網頁參數
   qryAllChkBoxArrayEditBean.setFieldName("CH");
   qryAllChkBoxArrayEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxArrayEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxArrayEditBean.setRs(rs);   
   qryAllChkBoxArrayEditBean.setScrollRowNumber(300);
       
   out.println(qryAllChkBoxArrayEditBean.getRsString());
   
   statement.close();
   rs.close();
   if (lotRs!=null) lotRs.close();
   lotStat.close();
   //取得維修處理狀態      
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
	   if (statusID.equals("003"))
	   {
         Statement statement=con.createStatement();
         // 2005-02-16 update userid must be active and unlock
         //ResultSet rs=statement.executeQuery("select a.USERID,a.RECPERSONNO||'--'||a.USERNAME from ORADDMAN.TSRECPERSON a,ORADDMAN.WSUSER b where a.USERID = b.WEBID AND b.LOCKFLAG='N' AND a.RECPERSONNO='"+userActCenterNo+"' and a.LOCALE='"+locale+"' order by a.RECPERSONNO");
         //comboBoxBean.setRs(rs);
	     //comboBoxBean.setFieldName("CHANGEREPPERSONID");	   
		 /*out.println("<table><tr bgcolor='#FFFF99'><td>");%><jsp:getProperty name="rPH" property="pgAssignTo"/><%out.println("<strong><font color='#FF0000'>:");*/
         //out.println(comboBoxBean.getRsString());		 		 
		 ResultSet rs=statement.executeQuery("select MANUFACTORY_NO,MANUFACTORY_NO||'('||MANUFACTORY_NAME||')' from ORADDMAN.TSPROD_MANUFACTORY where LOCALE > '0' order by MANUFACTORY_NO");
         comboBoxBean.setRs(rs);	   
	     comboBoxBean.setFieldName("CHANGEREPCENTERNO");	
		 out.println("<table width='100%'><tr bgcolor='#FFFF99'>"); 
		 out.println("<td>");%><jsp:getProperty name="rPH" property="pgProdTransferTo"/><%out.println("<strong><font color='#FF0000'>:");
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
       //2005-05-13 add 038
	   if (statusID.equals("003") || statusID.equals("010") || statusID.equals("004") || statusID.equals("007") || statusID.equals("008"))
	   { 
	    
	     //out.println("select x1.ACTIONID,x2.ACTIONNAME from RPWORKFLOW x1,RPWFACTION x2 WHERE FORMID='RP'AND TYPENO='"+svrTypeNo+"' AND FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID");
         Statement statement=con.createStatement();
         ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' and FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
         comboBoxBean.setRs(rs);
	     comboBoxBean.setFieldName("ACTIONID");	 
		 out.println("</font></strong></td><TR><TR><td>");%><jsp:getProperty name="rPH" property="pgRemark"/><%out.println(":<INPUT TYPE='TEXT' NAME='REMARK' SIZE=60></td></tr></table>");
         // 2005-05-13 add 038 
		// if ((statusID.equals("003") && userActCenterNo.equals("001")) || UserRoles.equals("admin"))
		 if (UserRoles.equals("PCController"))
		 { 
		 
		   out.println("<strong><font color='#CC3366'>");%><jsp:getProperty name="rPH" property="pgProdManufactory"/>-><%out.println("</font></strong>");
		   Statement stateShip=con.createStatement();
           ResultSet rsShip=stateShip.executeQuery("select MANUFACTORY_NO,MANUFACTORY_NO||'('||MANUFACTORY_NAME||')' from ORADDMAN.TSPROD_MANUFACTORY where LOCALE='86' order by MANUFACTORY_NO");	   
	       shipTypecomboBoxBean.setRs(rsShip);	   
	       shipTypecomboBoxBean.setSelection("--");
	       shipTypecomboBoxBean.setFieldName("MANUFACTORY_NO");	   
           out.println(shipTypecomboBoxBean.getRsString());	
		   stateShip.close();
		   rsShip.close();
		   out.println("<BR>");
		   
		}
	     out.println("<strong><font color='#FF0000'>");%><jsp:getProperty name="rPH" property="pgAction"/>-><%out.println("</font></strong>");
         out.println(comboBoxBean.getRsString());           
	     rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFACTION x2 WHERE FORMID='TS' AND FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	     rs.next();
	     if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	     {	      
           out.println("<INPUT TYPE='submit' NAME='submit' value='Submit'>");
		   if (statusID.equals("003") || statusID.equals("010") || statusID.equals("017") )
		   {
		     out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES'>");%><jsp:getProperty name="rPH" property="pgMailNotice"/><%
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

