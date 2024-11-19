<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Employee1.jsp</title>
</head>

<body background="../image/b01.jpg" topmargin="0">
<form action="../jsp/LCDeleteDB.jsp" method="post" name="signform" onSubmit="return check();">
<table width="100%" height="31" border="1" dwcopytype="CopyTableRow">
  <tr>
    <td width="50%"><font size="+2"><strong>DBTEL</strong></font></td>
    <td width="50%"><font size="+2"><strong>L/C Maintenance</strong></font></td>
  </tr>
</table>
<table width="100%" border="1">
  <tr>
    <td>請輸入LC NO:
      <input name="LCNO" type="text" size="18" maxlength="20">
      <input name="submit1" type="submit" value="確定"></td>
  </tr>
</table>
<p><a href="/wins/WinsMainMenu.jsp">回首頁</a></p>
      </form>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>         
</html>


<script language="JavaScript"> 
function check() {
      if (document.signform.LCNO.value == "" ) {
           alert("請輸入LC號!");
		   return false;
      }
	  else{
		  
		   return true;
	  }
}

</script>