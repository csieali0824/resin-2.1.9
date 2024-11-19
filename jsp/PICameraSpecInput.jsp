<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<html>
<head>
<title>CAMERA SPECIFICS INPUT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="PICameraSpecInsert.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>CAMERA Specifics</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td>CAMERA Name: 
        <INPUT TYPE="text" NAME="CAMERANAME" size="30"> </td>
    </tr>
    <tr> 
      <td>CAMERA Feature: 
        <INPUT TYPE="text" NAME="CAMERAFEATURE" size="60"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
  </FORM>
  <A HREF="PICameraSpecQueryAll.jsp">Query All Camera Specifics</A> 
</body>
</html>
