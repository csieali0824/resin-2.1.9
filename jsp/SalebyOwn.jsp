<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>SalebyOwn.jsp</title>
</head>

<body background="../image/b01.jpg"> 


      <form action="SalebyOwnDb.jsp" method="post" name="signform">
 
人員WEB識別碼:<input type="text" name="WEBID" size="6" maxlength="6"><br>
業務代號:<input type="text" name="SEARCHSTRING" size="6" maxlength="6"><br>
        <input type="submit" name="submit" value="加入" >
        <input name="reset" type="reset" value="清除">
		</form>
     

</body>
</html>


