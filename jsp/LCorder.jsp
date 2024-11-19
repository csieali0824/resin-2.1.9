<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QueryAllRepairBean2" %>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<html>
<head>
<title>LCorder.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">

var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
}
function NeedConfirm()
{ 
 flag=confirm("是否確定刪除?"); 
 return flag;
}

function searchRepNo(pageURL) 
{   
  location.href="../jsp/LCorder.jsp?PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value ; 
}
</script>
<body background="../image/b01.jpg">
<jsp:useBean id="queryAllRepairBean" scope="session" class="QueryAllRepairBean2"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<FORM ACTION="../jsp/LCorderDel.jsp" METHOD="POST" NAME="MYFORM" onSubmit="return NeedConfirm()">
  <strong><font color="#0080C0" size="5">查詢所有LC記錄</font></strong> 
  <%
     String EDITION=null;
	 String dateString=null;
	 String Year=null;
	 String Month=null;
	 String Day=null;
	 String Hour=null;
	 String NEWSID=null;
	 String HourSecond=null;
	 String TIME=null;
		   String YearFr=request.getParameter("YEARFR");
       String MonthFr=request.getParameter("MONTHFR");
       String DayFr=request.getParameter("DAYFR");
               String YearTo=request.getParameter("YEARTO");
        String MonthTo=request.getParameter("MONTHTO");
        String DayTo=request.getParameter("DAYTO");
		String dateStringBegin=YearFr+MonthFr+DayFr;
        String dateStringEnd=YearTo+MonthTo+DayTo; 
		boolean flge=false;
		//out.print(dateStringBegin+"<br>");
		//out.print(dateStringEnd+"<br>");
  
  
 try
    {
	Statement statement=ifxshoescon.createStatement();
	
	 dateString=dateBean.getYearMonthDay();
	 Year=dateBean.getYearString();
     Month=dateBean.getMonthString();
     Day=dateBean.getDayString();
     Hour=dateBean.getHourMinute();
	 HourSecond=dateBean.getHourMinuteSecond();
	 EDITION=dateString;
	 TIME=HourSecond;
     NEWSID=Month+Day+Hour;
	 /*out.print(Year+"<br>");
	 out.print(Month+"<br>");
	 out.print(Day+"<br>");*/

	    /* int a=Integer.parseInt(dateStringBegin);
	     int b=Integer.parseInt(dateStringEnd);
	     if(a <= b){
	         flge=true;
		     out.print(flge);
	     }*/
	 
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }

%>

  
  <%   
  int maxrow=0;//查詢資料總筆數 
  String searchString=request.getParameter("SEARCHSTRING");
  if (searchString==null) searchString="";
  String statusID=request.getParameter("STATUSID");  
  String statusDesc="",statusName="";
  String pageURL=request.getParameter("PAGEURL");
  String svrTypeNo=request.getParameter("SVRTYPENO");
  String fromYearString="",fromMonthString="",fromDayString="",toYearString="",toMonthString="",toDayString=""; 
  String queryDateFrom="",queryDateTo=""; 
  String fromYear=request.getParameter("FROMYEAR");  
  if (fromYear==null || fromYear.equals("--") || fromYear.equals("null")) fromYearString=Year; else fromYearString=fromYear;
  String fromMonth=request.getParameter("FROMMONTH"); 
  if (fromMonth==null || fromMonth.equals("--") || fromMonth.equals("null")) fromMonthString=Month; else fromMonthString=fromMonth; 
  String fromDay=request.getParameter("FROMDAY");
  if (fromDay==null || fromDay.equals("--") || fromDay.equals("null")) fromDayString=Day; else fromDayString=fromDay;
  queryDateFrom=fromYearString+fromMonthString+fromDayString;//3]?°·j’M|?¥o°_cl?e’Aao±o¥o
  String toYear=request.getParameter("TOYEAR");
  if (toYear==null || toYear.equals("--") || toYear.equals("null")) toYearString=Year; else toYearString=toYear;
  String toMonth=request.getParameter("TOMONTH");
  if (toMonth==null || toMonth.equals("--") || toMonth.equals("null")) toMonthString=Month; else toMonthString=toMonth; 
  String toDay=request.getParameter("TODAY");
  if (toDay==null || toDay.equals("--") || toDay.equals("null")) toDayString=Day; else toDayString=toDay; 
  queryDateTo=toYearString+toMonthString+toDayString;
  /*out.print(fromYear+"<br>");
  out.print(fromMonth+"<br>");
  out.print(fromDay+"<br>");
  out.print(queryDateFrom);
  out.print(queryDateTo);*/
  
  String scrollRow=request.getParameter("SCROLLROW");  
  int rowNumber=queryAllRepairBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   queryAllRepairBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {
     rowNumber=-1;	 
   } else {
     rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     queryAllRepairBean.setRowNumber(rowNumber);
   }	 
  }     
  
  int currentPageNumber=0,totalPageNumber=0;
  
  try
  {   
   Statement statement=ifxshoescon.createStatement(); 
   ResultSet rs=null;
   if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
   {  
     rs=statement.executeQuery("select count(*) from HLCM where LCNO like '"+searchString+"%' ");	 
	 //out.print("st");
   } else {    
	 rs=statement.executeQuery("select count(*) from HLCM where LCENDT between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	 //out.print("st2");
   }	 
	
   rs.next();   
   maxrow=rs.getInt(1);
   out.println("<FONT COLOR=BLACK SIZE=2>(總共"+maxrow+"筆記錄)</FONT>"); 
   statement.close();
   rs.close();
   
    
    totalPageNumber=maxrow/30+1;
    if (rowNumber==0 || rowNumber<0)
    {
      currentPageNumber=rowNumber/31+1;  
    } else {
      currentPageNumber=rowNumber/30+1; 
    }	
    if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }   
%>
  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> <BR>
  <table width="68%" border="0">
    <tr>
      <td width="36%"><input name="button" type=button onClick="this.value=check(this.form.CH)" value="全部選取">
        <input name="submit" type="submit" value="刪除">
        <font color="#FF0080"><strong><font size="2"></font><font color="#FF0080"><strong><font size="2"><A HREF="../jsp/CreateLC2.jsp">新增LC</A></font></strong></font></strong></font> 
      </td>

      <td width="41%" nowrap> 
        <div align="right"><strong><font color="#400040" size="2">LCNO:</font></strong> 
          <INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
          <input name="search" type=button onClick="searchRepNo('<%=pageURL%>')" value="<-搜尋">
        </div></td>
  </tr>
</table>                                                                                                                                                                                                                     
  <A HREF="../jsp/LCorder.jsp?SCROLLROW=FIRST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;<font color="#FF0080"><strong><font size="2">&nbsp;<A HREF="../jsp/LCorder.jsp?SCROLLROW=30&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>">下一頁</A>&nbsp;&nbsp;<A HREF="../jsp/LCorder.jsp?SCROLLROW=-30&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>">上一頁</A>(第頁<%=currentPageNumber%>/共<%=totalPageNumber%>頁)&nbsp;&nbsp; </font></strong></font>日期:FROM 
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
   Statement statement=ifxshoescon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   //Statement statement=con.createStatement();
   //ResultSet rs=statement.executeQuery("select * from RPREPAIR where REPCENTERNO='"+userRepCenterNo+"'");
    ResultSet rs=null;
    if (searchString!=null && !searchString.equals(""))
   {   
     
     
       rs=statement.executeQuery("select LCID,LCNO,LCCUR,LCAMT,LCEFF,LCDIS,LCUSAGE,LCENUS,LCCFM,LCENDT,LCENTM,LCRDTE,LCRCTM,LCUPDT,LCUPTM,LCSTAT from HLCM where LCNO like '"+searchString+"%'");	   
	 //out.print("st");
   } else {
  	   
	   rs=statement.executeQuery("select LCID,LCNO,LCCUR,LCAMT,LCEFF,LCDIS,LCUSAGE,LCENUS,LCCFM,LCENDT,LCENTM,LCRDTE,LCRCTM,LCUPDT,LCUPTM,LCSTAT from HLCM where LCENDT between '"+queryDateFrom+"' and '"+queryDateTo+"'");
	 	  //out.print("st2"); 
   }	

   if (rowNumber==1)
   {
     rs.beforeFirst(); //移至第一筆資料列  
   } else {
     if (rowNumber==-1)
	 {
	   rs.absolute(-30);
	 } else {
      rs.absolute(rowNumber); //移至指定資料列
	 }
   }
      
  /* queryAllRepairBean.setPageURL("../jsp/BBB.jsp");//小圖示連結到修改的網頁  
   queryAllRepairBean.setSearchKey("USERID");//傳到下一個網頁以那一個變數為主
   queryAllRepairBean.setRs(rs);
   queryAllRepairBean.setScrollRowNumber(30);
   out.println(queryAllRepairBean.getRsString());*/
   //另外一種呈現方式 ,沒有checkbox的
   
   qryAllChkBoxEditBean.setPageURL("../jsp/LCorderEdit.jsp");//小圖示連結到修改的網頁
   qryAllChkBoxEditBean.setPageURL2("../jsp/ByLCShow3.jsp");     
   qryAllChkBoxEditBean.setHeaderArray(null);
   String AA[]={"","","","LCID","LCNO","LCCUR","LCAMT","LCEFF","LCDIS","LCUSAGE","LCENUS","LCCFM","LCENDT","LCENTM","LCRDTE","LCRCTM","LCUPDT","LCUPTM","LCSTAT"};
   qryAllChkBoxEditBean.setHeaderArray(AA);
   qryAllChkBoxEditBean.setSearchKey("LCNO");//傳到下一個網頁以那一個變數為主
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setRs(rs);   
   out.println(qryAllChkBoxEditBean.getRsString());
   
   statement.close();    
   rs.close();     
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</FORM>

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>
