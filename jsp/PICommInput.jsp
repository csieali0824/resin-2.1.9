<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<html>
<head>
<title>COMM INPUT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="../jsp/PICommInsert.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>COMM Information</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td width="45%">COMM Name: 
        <INPUT TYPE="text" NAME="COMMNAME" size="20"></td>
      <td width="55%">Local No:
        <INPUT TYPE="text" NAME="LOCALE" size="3"></td>
    </tr>
    <tr> 
      <td colspan="2">COMM Local Name: 
        <INPUT TYPE="text" NAME="COMMLOCALNAME" size="60"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
  </FORM>
  <A HREF="PICommQueryAll.jsp">Query All COMM</A> 
</body>
</html>
