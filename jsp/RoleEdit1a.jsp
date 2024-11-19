<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>RoleEdit1a.jsp</title>
</head>

<body>

<table bgcolor=#708090 cellpadding=5 cellspacing=1 align=center>
        
        <tr vAlign="top" align="middle">
          
    <td width="199" bgcolor=#CCFFFF> <div align="center"> 
      <table cellSpacing="8" cellPadding="0" width="100%" border="0">
			     <font color="#e8eef7"></font>
               
			   </table>  
<form action="/wins/jsp/RoleEdit.jsp" method="post" name="signform" onSubmit="return check();"><font color="#FF0000"><strong>錯誤!請從新輸入</strong></font><br>
修改角色名稱:<input type="text" name="ROLENAME" size="20" maxlength="20"><br>
<input type="submit" name="submit1" value="修改">
<input type="reset" name="reset" value="清除"><br>
<a href="../jsp/Role1.jsp">回上一頁</a>
</form>
</table>
</body>
</html>
<script language="JavaScript"> 
function check() {
      if (document.signform.ROLENAME.value == "" ) {
           alert("請輸入角色名稱!");
		   return false;
      }
	  else{
		  
		   return true;
	  }
}

</script>
