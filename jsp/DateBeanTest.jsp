<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,DateBean"%>
<!-- page session="false" %>-->
<html>
<head>
<title>DateBean Test</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>

<body>
<jsp:useBean id='dateBean' scope='page' class='DateBean' />
yearMonthDate=<jsp:getProperty name='dateBean' property="yearMonthDay"/>
hourMinuteSecond=<jsp:getProperty name='dateBean' property="hourMinuteSecond"/>
<BR>
<table width="75%" border="1">
  <tr>
    <td width="32%">&nbsp;</td>
    <td width="68%">
      <img src="ShowFile.jsp" width="5%">
	</td>
  </tr>
</table>
</body>
</html>
