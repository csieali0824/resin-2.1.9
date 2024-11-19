<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<script>
function wopen(field) {
	var typ="";
	for (i=0;i<field.length;i++) {
		if (field[i].checked) { typ=field[i].value; break; }
	}
	var url = "BPCSBomWhereUseShow.jsp";
	//+"?COMP="+document.MYFORM.COMP.value //公司別
	//+"&FAC="+document.MYFORM.FAC.value //廠別
	//+"&PROD="+document.MYFORM.PROD.value //料號
	//+"&MET="+document.MYFORM.MET.value //制程
	//+"&TYP="+typ; //0=single-level,1=multi-level,其他=最上階
	document.MYFORM.action=url;
	document.MYFORM.submit();

} // end function
function items() {
	subWin=window.open("BPCSItemSel.jsp");
} // end function
</script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Where Use Select</title>
</head>

<body>
<%
try {
%>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>
<form method="post" name="MYFORM">
<table align="left">
<tr><td colspan="3"><font size="+2" face="sans-serif" color="#00CCFF">Where Use Inquiry</font></td></tr>
<tr><td colspan="3">請輸入以下條件<input name="PRT" type="hidden" value="1"><!--//控制是否能印表, 0=否,1=可--></td></tr>
<tr>
	<td colspan="3">Company
		<select name="COMP">
		<%
		for (int i=0;i<userCompCodeArray[1].length;i++) {
			if (userCompCodeArray[1][i].equals("01")||userCompCodeArray[1][i].equals("1") //大霸電
			||userCompCodeArray[1][i].equals("2")||userCompCodeArray[1][i].equals("02") //DBH
			||userCompCodeArray[1][i].equals("45") //迪比特
			||userCompCodeArray[1][i].equals("999") ) //BOM Center
			{
			%><option value="<%=userCompCodeArray[1][i]%>"><%=userCompCodeArray[0][i]%></option><%
			} // end if
		} // end for
		%>
		</select>
	</td>
</tr>
<tr><td>Fac<input name="FAC" maxlength="2" size="2"></td></tr>
<tr><td>Method<input name="MET" maxlength="2" size="2"></td></tr>
<tr>
	<td>Item<input name="PROD" maxlength="15" size="15"><input type="button" value="查詢料號" onClick="items()"></td>
</tr>
<tr>
</tr>
<tr>
	<td>顯示資料
	<input type="radio" name="TYP" value="T" checked>最上階
	<input type="radio" name="TYP" value="S">Single-Level
	<input type="radio" name="TYP" value="M">Multi-Level
	</td>
</tr>
<tr><td colspan="3" align="center"><input type="button" value="確定" onClick="wopen(document.MYFORM.TYP)"></td></tr>
</table>
</form>

<%
} catch (Exception ee) { out.println("Exception:"+ee.getMessage());
} // end try-catch
%>
</body>
</html>
