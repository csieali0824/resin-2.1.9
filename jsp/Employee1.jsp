<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Employee1.jsp</title>
</head>

<body>
<table bgcolor=#708090 cellpadding=5 cellspacing=1 align=center>
        
        <tr vAlign="top" align="middle">
          
    <td width="199" bgcolor=#CCFFFF> <div align="center"> 
      <table cellSpacing="8" cellPadding="0" width="100%" border="0">
			     <font color="#e8eef7"></font>
              </table>  
			   
<form action="../jsp/EmployeeDb.jsp" method="post" name="signform" onSubmit="return check();">  
請輸入員工編號: 
<input name="USERNAME" type="text" size="15" maxlength="20">
<input name="submit1" type="submit" value="確定"><br>
<a href="/wins/WinsMainMenu.jsp">回首頁</a>
</form>
</table>
</body>         
</html>


<script language="JavaScript"> 
function check() {
      if (document.signform.USERNAME.value == "" ) {
           alert("請輸入員工編號!");
		   return false;
      }
	  else{
		  
		   return true;
	  }
}

</script>