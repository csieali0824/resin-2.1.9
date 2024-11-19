<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,DateBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>LCorderEdit.jsp</title>
</head>

<body background="../image/b01.jpg">
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
//if (confirm("Please indicate which time format you are using.  OK = Standard Time渀?散瑮?"�i????睜扥灡獰睜湩屳獪???潲????湅牴?獪pb??渠浡?"��?????��?????, CANCEL = Military Time")) {
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

if (eval(document.signform.LCAMT.value) < eval(document.signform.LCUSAGE.value) || document.signform.LCAMT.value== "") {
	      alert("值不可小於Usage!");
		  return (false);
	 }
return true; // form should never submit, returns false如要送出時return true

}
//End-->
</script>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%
     String EDITION=null;
	 String dateString=null;
	 String Month=null;
	 String Day=null;
	 String Hour=null;
	 String NEWSID=null;
	 String HourSecond=null;
	 String TIME=null;

  
  
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
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }

%>

<%
  String LCNO=request.getParameter("LCNO");
  float LCAMT=0;
  String LCCUR="";
  String firstdate="";
  String seconddate="";
  String LCUPDT="";
  String LCUPTM="";
  float LCUSAGE=0;
  String LCID="";
  try
    {
	Statement statement9=ifxshoescon.createStatement();
    ResultSet rs9=statement9.executeQuery("select LCNO from HLCM WHERE LCNO='"+LCNO+"'");
    rsBean.setRs(rs9);
     if(rs9.next())
       {

	      Statement statement=ifxshoescon.createStatement();
          String sql="select * from HLCM where LCNO='"+LCNO+"'";	
          ResultSet rs=statement.executeQuery(sql);
	      rs.next();
	      LCAMT=rs.getFloat("LCAMT");
		  LCCUR=rs.getString("LCCUR");
		  LCUSAGE=rs.getFloat("LCUSAGE");
		  firstdate=rs.getString("LCEFF");
		  seconddate=rs.getString("LCDIS");
		  LCID=rs.getString("LCID");
		      if(LCID.equals("HZ")){
               response.sendRedirect("../jsp/LCNoEdit.jsp?LCNO="+LCNO+"");
               }
	      /*out.print(LCAMT+"<br>");
		  out.print(LCCUR+"<br>");
		  out.print(LCUSAGE+"<br>");
		  out.print(firstdate+"<br>");
		  out.print(seconddate+"<br>");
		  out.print(LCID+"<br>");*/
	      rs.close();
           }//end of if
	rs9.close();
  }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>


      <form action="UpdateLC.jsp" method="post" name="signform" onSubmit="return dateDiff(this);">
	  <input type="hidden" name="LCUSAGE" value="<%= LCUSAGE %>" >
	  <input type="hidden" name="LCCUR" value="<%= LCCUR %>" >
	  <input type="hidden" name="LCNO" value="<%= LCNO %>" >
	  <input type="hidden" name="LCUPDT" value="<%= EDITION %>" >
	  <input type="hidden" name="LCUPTM" value="<%= TIME %>" >
<table width="100%" height="31" border="1">
  <tr>
    <td width="50%"><font size="+2"><strong>DBTEL</strong></font></td>
    <td width="50%"><font size="+2"><strong>L/C Maintenance</strong></font></td>
  </tr>
</table>
<table width="100%" border="1">
  <tr> 
      <td height="66">Edit Model</td>
  </tr>
</table>
  <table width="100%" border="1">
    <tr> 
      <td rowspan="2"><div align="center"><font color="#0000FF">L/C NO</font></div></td>
      <td rowspan="2"><div align="center"><font color="#0000FF">Amount</font></div></td>
      <td rowspan="2"><div align="center"><font color="#0000FF">Currency</font></div></td>
      <td rowspan="2"><div align="center"><font color="#0000FF">Usage</font></div></td>
      <td colspan="2"><div align="center"><font color="#0000FF">Effective Date</font></div></td>
    </tr>
    <tr> 
      <td><div align="center"><font color="#0000FF">From</font></div></td>
      <td><div align="center"><font color="#0000FF">To</font></div></td>
    </tr>
    <tr> 
      <td><div align="center"><%= LCNO %></div></td>
      <td><div align="center"><input type="text" name="LCAMT" size="15" maxlength="15" value=<%= LCAMT %>></div></td>
      <td><div align="center"><%= LCCUR %></div></td>
      <td><div align="center"><%= LCUSAGE %></div></td>
      <td><div align="center"> 
          <input type="text" name="firstdate" size="15" maxlength="15" value=<%= firstdate %>>
          (YYYY/MM/DD format)</div></td>
		  <input type=hidden name=firsttime value="00:00" size=10 maxlength=10>
      <td><div align="center">
          <input type="text" name="seconddate" size="15" maxlength="15" value=<%= seconddate %>>
          (YYYY/MM/DD format)</div></td>
          <input type=hidden name=secondtime value="00:00" size=10 maxlength=10>
		  <input type=hidden name=difference value="" onClick="return dateDiff();" size=50>
    </tr>
  </table>
  <table width="16%" border="0" align="center">
  <tr>
    <td><input type="submit" name="submit" value="Save" ></td>
    
  </tr>
</table>
</form>
</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>

  <script language="JavaScript"> 

  function checkYMD2(motoText)
  {
    date=motoText.match(/^(\d\d)\/(\d\d)\/(\d\d)$/);
	if(!date){alert("異常"); return false;}
	mm=eval(RegExp.$2);
	dd=eval(RegExp.$3);
	if((mm<1) || (mm>12)) { alert("月份異常"); return false;}
	if((dd<1) || (dd>12)) { alert("日期異常"); return false;}
	alert("正常"); return true;
  }
  
  
   function validate(){
     if (eval(document.signform.LCAMT.value) < eval(document.signform.LCUSAGE.value)) {
	      alert("值不可小於Usage!");
		  return (false);
	 }else {
	      document.signform.submit();
	  }
   }
   
        </script>