<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>UnShippingInput.jsp</title>
</head>

<body onLoad="this.document.UnShipform.IMEI.focus()">
<table bgcolor=#708090 cellpadding=5 cellspacing=1 align=center>
        
        <tr vAlign="top" align="middle">
          
    <td width="199" bgcolor=#CCFFFF> <div align="center"> 
      <table cellSpacing="1" cellPadding="0" width="100%" border="0">
			     <font color="#e8eef7"></font>
               
			   </table>  
			   
<form action="../jsp/UnShippingUpdate.jsp" method="post" name="UnShipform" onSubmit="return check();">
<div align="center">
<b>修改Shipping紀錄:</b><br><br><input type="text" name="IMEI" size="21" maxlength="21">
<br><br>
<!--input name="button4" type="submit" onClick='Submit1("../jsp/UnShippingUpdate.jsp")'  value="修改" -->
<input type="submit" name="submit1" value="修改" onClick='check("../jsp/UnShippingInput.jsp")'>
<input type="reset" name="reset" value="清除"><br>
</div>
</form>
</table>
</body>
</html>
<script language="JavaScript"> 
function check() {
      if (document.UnShipform.IMEI.value == "" ) {
           alert("請輸入IMEI或Carton no !!");
		   return false;
      }
	  else{
		  
		   return true;
	  }
}
</script>
