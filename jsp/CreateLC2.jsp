<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,ArrayComboBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateLC.jsp</title>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
</head>

<body background="../image/b01.jpg" topmargin="0">
<SCRIPT LANGUAGE="JavaScript">

<!-- Begin
function isValidDate(dateStr) {
// Date validation function courtesty of 
// Sandeep V. Tamhankar (stamhankar@hotmail.com) -->

// Checks for the following valid date formats:
// MM/DD/YY   MM/DD/YYYY   MM-DD-YY   MM-DD-YYYY

var datePat = /^(\d{4})(\/|-)(\d{1,2})\2(\d{1,2})$/; // requires 4 digit year

var matchArray = dateStr.match(datePat); // is the format ok?
if (matchArray == null) {
alert(dateStr + " Date is not in a valid format.")
return false;
}
year = matchArray[1];
month = matchArray[2]; // parse date into variables
day = matchArray[4];

if (month < 1 || month > 12) { // check month range
alert("Month must be between 1 and 12.");
return false;
}
if (day < 1 || day > 31) {
alert("Day must be between 1 and 31.");
return false;
}
if ((month==4 || month==6 || month==9 || month==11) && day==31) {
alert("Month "+month+" doesn't have 31 days!")
return false;
}
if (month == 2) { // check for february 29th
var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
if (day>29 || (day==29 && !isleap)) {
alert("February " + year + " doesn't have " + day + " days!");
return false;
   }
}
return true;
}

function isValidTime(timeStr) {
// Time validation function courtesty of 
// Sandeep V. Tamhankar (stamhankar@hotmail.com) -->

// Checks if time is in HH:MM:SS AM/PM format.
// The seconds and AM/PM are optional.

var timePat = /^(\d{1,2}):(\d{2})(:(\d{2}))?(\s?(AM|am|PM|pm))?$/;

var matchArray = timeStr.match(timePat);
if (matchArray == null) {
alert("Time is not in a valid format.");
return false;
}
hour = matchArray[1];
minute = matchArray[2];
second = matchArray[4];
ampm = matchArray[6];

if (second=="") { second = null; }
if (ampm=="") { ampm = null }

if (hour < 0  || hour > 23) {
alert("Hour must be between 1 and 12. (or 0 and 23 for military time)");
return false;
}
//if (hour <= 12 && ampm == null) {
//if (confirm("Please indicate which time format you are using.  OK = Standard Time??渠浡?"��?????��?????, CANCEL = Military Time")) {
//alert("You must specify AM or PM.");
//return false;
//   }
//}
if  (hour > 12 && ampm != null) {
alert("You can't specify AM or PM for military time.");
return false;
}
if (minute < 0 || minute > 59) {
alert ("Minute must be between 0 and 59.");
return false;
}
if (second != null && (second < 0 || second > 59)) {
alert ("Second must be between 0 and 59.");
return false;
}
return true;
}

function dateDiff() {
dateform = document.forms[0];
date1 = new Date();
date2 = new Date();
diff  = new Date();

if (isValidDate(dateform.firstdate.value) && isValidTime(dateform.firsttime.value)) { // Validates first date 
date1temp = new Date(dateform.firstdate.value + " " + dateform.firsttime.value);
date1.setTime(date1temp.getTime());
}
else return false; // otherwise exits

if (isValidDate(dateform.seconddate.value) && isValidTime(dateform.secondtime.value)) { // Validates second date 
date2temp = new Date(dateform.seconddate.value + " " + dateform.secondtime.value);
date2.setTime(date2temp.getTime());
}
else return false; // otherwise exits

// sets difference date to difference of first date and second date

if (date2.getTime() < date1.getTime()) {
alert ("日期錯誤!!");
return false;
}
diff.setTime(Math.abs(date1.getTime() - date2.getTime()));

timediff = diff.getTime();



weeks = Math.floor(timediff / (1000 * 60 * 60 * 24 * 7));
timediff -= weeks * (1000 * 60 * 60 * 24 * 7);

days = Math.floor(timediff / (1000 * 60 * 60 * 24)); 
timediff -= days * (1000 * 60 * 60 * 24);

hours = Math.floor(timediff / (1000 * 60 * 60)); 
timediff -= hours * (1000 * 60 * 60);

mins = Math.floor(timediff / (1000 * 60)); 
timediff -= mins * (1000 * 60);

secs = Math.floor(timediff / 1000); 
timediff -= secs * 1000;

dateform.difference.value = weeks + " weeks, " + days + " days, " + hours + " hours, " + mins + " minutes, and " + secs + " seconds";


return true; // form should never submit, returns false如要送出時return true
}
//  End-->
</script>
<%
     String EDITION=null;
	 String dateString=null;
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
     Month=dateBean.getMonthString();
     Day=dateBean.getDayString();
     Hour=dateBean.getHourMinute();
	 HourSecond=dateBean.getHourMinuteSecond();
	 EDITION=dateString;
	 TIME=HourSecond;
     NEWSID=Month+Day+Hour;
	 //out.print(TIME+"<br>");
	 //out.print(EDITION+"<br>");
	 //out.print(NEWSID);

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


      <form action="CreateLCDB.jsp" method="post" name="signform" onSubmit="return dateDiff(this);">
	  <input type="hidden" name="LCID" value="HC" >
	  <input type="hidden" name="LCUSGE" value="0" >
	  <input type="hidden" name="LCSTAT" value="N" >
	  <input type="hidden" name="LCENDT" value="<%= EDITION %>" >
	  <input type="hidden" name="LCENTM" value="<%= TIME %>" >
	  <input type="hidden" name="FLGE" value="<%= flge %>" >
<table width="100%" height="31" border="1">
  <tr>
    <td width="50%"><font size="+2"><strong>DBTEL</strong></font></td>
    <td width="50%"><font size="+2"><strong>L/C Maintenance</strong></font></td>
  </tr>
</table>
<table width="100%" border="1">
  <tr> 
    <td height="66">Create Model</td>
  </tr>
</table>
<table width="100%" border="1">
  <tr> 
    <td width="21%" rowspan="2" align="center" valign="top"><font color="#0000FF">L/C 
      NO</font></td>
    <td width="18%" rowspan="2" align="center" valign="top"><font color="#0000FF">Amount</font></td>
    <td width="17%" rowspan="2" align="center" valign="top"><font color="#0000FF">Currency</font></td>
    <td colspan="2" align="center"><font color="#0000FF">Effective Date</font></td>
  </tr>
  <tr> 
    <td width="23%" align="center"><font color="#0000FF">From</font></td>
    <td width="21%" align="center"><font color="#0000FF">To</font></td>
  </tr>
  <tr> 
    <td height="18" align="center"><input type="text" name="LCNO" size="20" maxlength="20"></td>
    <td align="center"><input type="text" name="LCAMT" size="15" maxlength="15"></td>
    <td align="center"><select name="LCCUR" size="1">
                       <option>USD</option>
					   <option>JPY</option>
					   <option>RMB</option>	
	                   </select></td>
      <td align="center"> <div align="center"> 
          <input type="text" name="firstdate" size="15" maxlength="15">
          (YYYY/MM/DD format)</div></td>
	                  <input type=hidden name=firsttime value="00:00" size=10 maxlength=10>
      <td align="center"> <div align="center">
          <input type="text" name="seconddate" size="15" maxlength="15">
          (YYYY/MM/DD format)</div></td>
	                  <input type=hidden name=secondtime value="00:00" size=10 maxlength=10>
					  <input type=hidden name=difference value="" onClick="return dateDiff();" size=50>
  </tr>
</table>
<table width="27%" border="0" align="center">
  <tr>
    <td><input type="submit" name="submit" value="Save" > </td>
    <td><input name="reset" type="reset" value="Reset"></td>
  </tr>
</table>
</form>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>


<script language="JavaScript"> 
      function change_acton2(){
	if (document.signform.LCNO.value == "") {
	      alert("請輸入LCNO!");
		  return (false);
	 }else if(document.signform.LCAMT.value == ""){
	      alert("請輸入Amount!");
			return (false);
	  }else {
	      document.signform.submit();
     }
   }
   
   function change_acton(){
   var p3 = document.signform.aaa.value;
        var p4 = document.signform.bbb.value;
        var Y3 = p3.substring(0,4);
 var MD3 = p3.substring(4,8);
        var Y4 = p4.substring(0,4);
 var MD4 = p4.substring(4,8);
        var Yequal = false;
        var MDequal = false;
        if(Y3 < Y4)
        {
           Yequal = true;
           var MDequal = true;
        }
        else if(Y3 == Y4)
        {
    if(MD3 <= MD4)
           {
              Yequal = true;
              MDequal = true;
           }
           else alert("起始時間大於終止時間");
		   return (false);
        }
        else if(Y3 > Y4)
        {
           alert("起始時間大於終止時間");
		   return (false);
        }
}
    </script>  

