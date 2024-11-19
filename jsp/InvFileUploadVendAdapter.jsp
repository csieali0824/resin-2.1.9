<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Vendor File Upload Adapter</title>
</head>

<body>
<form NAME="MYFORM" ACTION="../jsp/InvFileUploadVendInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">
<font color="#004080" size="+1" face="Arial Black"><strong>Upload Vendor</strong></font>
<table border="1">
<tr>
	<td><div align="right"><font color="#004080"><strong>File Source</strong></font></div></td>
	<td><INPUT TYPE="FILE" NAME="UPLOADFILE"></td>
</tr>
</table>
<INPUT TYPE="submit" value="UPLOAD">

</form>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
