<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<html>
<head>
<title>CONNECTIVITY SPECIFICS INPUT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="PIConnInsert.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>Connectivity Specifics</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td>Connectivity Name: 
        <INPUT TYPE="text" NAME="CONNNAME" size="30"> </td>
    </tr>
    <tr> 
      <td>Connectivity Feature: 
        <INPUT TYPE="text" NAME="CONNFEATURE" size="60"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
  </FORM>
  <A HREF="PIConnQueryAll.jsp">Query All Connectivity Specifics</A> 
</body>
</html>
