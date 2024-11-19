<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="TelnetBean,DateBean" %>
<jsp:useBean id="telnetBean" scope="application" class="TelnetBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TEST CONNECTION TO UNIX</title>
</head>
<body>
<%
telnetBean.setHost("203.66.141.2");
telnetBean.setPort("23");
telnetBean.setUser("pgsrc");
telnetBean.setPassword("mis110");
telnetBean.setOpMan("BO1732");
telnetBean.setOpTime(dateBean.getYearMonthDay()+"-"+dateBean.getHourMinuteSecond());

telnetBean.connTelnet();

//out.println(telnetBean.runComnd("/home/informix/util/dbspace-space.sh"));

//out.println(telnetBean.runComnd("/home/pgsrc/cron610/tpodist001_test.sh"));
//out.println("<BR>"+telnetBean.runComnd("who"));
out.println("<BR>"+telnetBean.runComnd(""));
telnetBean.disconnect();
%>
</body>
</html>
