<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>Features INPUT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="../jsp/PIFeaturesInsert.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>FEATURES Information</strong></font> 
  <table width="88%" border="1">
    <tr>
      <td width="20%">Feature Code: 
        <INPUT TYPE="text" NAME="FEATURECODE" size="3"></td>
      <td width="62%">Feature Name: 
        <INPUT TYPE="text" NAME="FEATURENAME" size="40"></td>
      <td width="18%">Local No: 
        <INPUT TYPE="text" NAME="LOCALE" size="3"></td>
    </tr>
    <tr> 
      <td colspan="3">Feature Local Name: 
        <INPUT TYPE="text" NAME="FEATURELOCALNAME" size="60"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
  </FORM>
  <A HREF="PIFeaturesQueryAll.jsp">Query All Features</A> 
</body>
</html>
