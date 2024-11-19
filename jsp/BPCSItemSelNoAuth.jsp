<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得授權==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<script>
function wopen(field) {
	if ((document.MYFORM.PROD.value==null||document.MYFORM.PROD.value=="")
		&& (document.MYFORM.DESC.value==null||document.MYFORM.DESC.value=="")) {
		alert("Can't Be Empty"); return false;
	}
	document.MYFORM.action="BPCSItemShowNoAuth.jsp";
	document.MYFORM.submit();
	
} // end function
</script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Item Inquiry</title>
</head>

<body>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>
<form method="post" name="MYFORM">
<table align="left">
<tr><td colspan="3"><font size="+2" face="sans-serif" color="#00CCFF">Item Inquiry</font></td></tr>
<tr><td colspan="3">請輸入以下條件<input name="PRT" type="hidden" value="1"><!--//控制是否能印表, 0=否,1=可--></td></tr>
<tr>
	<td colspan="3">Company
		<select name="COMP">
		<option value="01">大霸電子</option>
		<option value="2">大霸控股</option>
		<option value="45">上海迪比特</option>
		<option value="999">BOM Center</option>
		<%
		/*
		for (int i=0;i<userCompCodeArray[1].length;i++) {
			if (userCompCodeArray[1][i].equals("01")||userCompCodeArray[1][i].equals("1") //大霸電
			||userCompCodeArray[1][i].equals("2")||userCompCodeArray[1][i].equals("02") //DBH
			||userCompCodeArray[1][i].equals("45") //迪比特
			||userCompCodeArray[1][i].equals("999") ) //BOM Center
			{
			%><option value="<%=userCompCodeArray[1][i]%>"><%=userCompCodeArray[0][i]%></option><%
			} // end if
		} // end for
		*/
		%>
		</select>
	</td>
</tr>

<tr>
	<td>Item<input name="PROD" maxlength="15" size="15"></td>
	<td>Description<input name="DESC"></td>
</tr>
<tr>
	<td colspan="3"><font color="#FF0000">*輸入部份的料號或說明, 可以進行模糊搜尋</font></td>
</tr>
<tr><td colspan="3" align="center"><input type="button" value="確定" onClick="return wopen(document.MYFORM.TYP)"></td></tr>
</table>
</form>

</body>
</html>
