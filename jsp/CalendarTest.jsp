<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="java.util.Calendar,WorkingDateBean,DateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<%
 Calendar  cal=Calendar.getInstance();
 //cal.add(Calendar.YEAR,1); 
 //cal.set(2004,10,27);
 out.println(cal.getTime());
 cal.add(Calendar.WEEK_OF_YEAR,-3);
 out.println("<BR>3 weeks before is"+cal.getTime());
 
 cal.set(2004,1,1);
 out.println("<BR>this month max is "+cal.getActualMaximum(Calendar.DATE)); 
 cal.set(Calendar.DAY_OF_WEEK,2);
 out.println("<BR>this week begin is "+(cal.get(Calendar.MONTH)+1)+"/"+cal.get(Calendar.DAY_OF_MONTH));
 out.println("<BR>=========Date Bean================<BR>");
 //dateBean.setDate(2004,6,1);
 out.println("today is "+dateBean.getYearMonthDay());
 out.println("<BR>Max day of this Month is "+dateBean.getMonthMaxDay()); 
 out.println("<BR>this week begin is "+dateBean.getWeekBeginDate());
 out.println("<BR>the day of week is "+dateBean.getDayOfWeek());  
 out.println("<BR>today is "+dateBean.getYearMonthDay());   
 out.println("<BR>=========Date Bean================<BR>");
 //out.println("<BR>");
 //out.println(cal.get(Calendar.YEAR));
 //out.println("<BR>week of the year:"+cal.get(Calendar.WEEK_OF_YEAR));
 //out.println("<BR>day of the year:"+cal.get(Calendar.DAY_OF_YEAR));
 //out.println("<BR>First day of the week:"+cal.getFirstDayOfWeek());
  
 workingDateBean.setWorkingDate(2004,2,6);
 out.println("<BR><BR>THE WORKING WEEK IS:"+workingDateBean.getWorkingWeek());
 out.println("<BR><BR>THE WEEK IS:"+workingDateBean.getYearString()+"-"+workingDateBean.getMonthString());
  out.println("<BR>The first day of week is : "+workingDateBean.getFirstDateOfWorkingWeek());
   out.println("<BR>The last day of week is : "+workingDateBean.getLastDateOfWorkingWeek());
 out.println("<BR>The day of week is : "+workingDateBean.getDayOfWeek()); 

 for (int i=1;i<=24;i++)
 {
  workingDateBean.setAdjWeek(1); 
  out.println("<BR><BR>NOW ! THE WORKING WEEK IS:"+workingDateBean.getWorkingWeek());
 } 
 

%>
</body>
</html>
