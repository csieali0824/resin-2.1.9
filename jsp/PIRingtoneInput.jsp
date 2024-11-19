<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<html>
<head>
<title>RINGTONE INPUT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="../jsp/PIRingtoneInsert.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>RINGTONE Information</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td width="45%">Ringtone: 
        <INPUT TYPE="text" NAME="RINGTONECODE" size="30"></td>
      <td width="55%">Local No:
        <INPUT TYPE="text" NAME="LOCALE" size="3"></td>
    </tr>
    <tr> 
      <td colspan="2">Ringtone Local Name: 
        <INPUT TYPE="text" NAME="RINGTONELOCALNAME" size="60"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
  </FORM>
  <A HREF="PIRingtoneQueryAll.jsp">Query All Ringtone</A> 
</body>
</html>
