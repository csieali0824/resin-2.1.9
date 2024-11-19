<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/CoonBPCS.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>BPCS 財務發票刪除輸入畫面</title>
<!--created by cherrry chang  date : 2005.04.14 !-->
<!--input  : atx, aph, apl, apo, gxr output : atx, aph, apl, apo, gxr!-->

</head>
<form name="MYFORM" action="BPCSFinInvDelDB.jsp" method="post">
<body>
<br><br>
<font size="+2"><strong>發票刪除</strong></font><br>
<table align="center">
	  <tr><td>請輸入廠商代碼</td><td><input name="VENDOR" type="text"></td></tr>
	  <tr><td>請輸入發票號碼</td><td><input name="INVOICE" type="text"></td></tr>
	  <tr><td><input name="SUBMIT" type="submit"></td><td><input name="RESET" type="reset"></td></tr>
</table>
</body>
</form>
</html>
<%@ include file="/jsp/ReleaseConnBPCS.jsp"%>