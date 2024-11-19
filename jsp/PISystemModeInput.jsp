<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<html>
<head>
<title>SYSTEM MODE INPUT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="PISystemModeInsert.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>System Mode</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td>Mode Name: 
        <INPUT TYPE="text" NAME="SYSTEMMODE" size="10"> </td>
    </tr>
    <tr> 
      <td>Mode Desc: 
        <INPUT TYPE="text" NAME="MODEDESC" size="40"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
  </FORM>
  <A HREF="PISystemModeQueryAll.jsp">Query All System Mode</A> 
</body>
</html>
