<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>差異料表</title>
</head>

<body>
<%
String modelNo = request.getParameter("MODELNO");
if (modelNo==null) { modelNo = ""; }

%>
<font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Times New Roman"><strong><%=modelNo%> 差異料表</strong></font>
<table border="1">
<%
try {

	if (modelNo==null) {
	} else {
		PreparedStatement st = dmcon.prepareStatement("SELECT fmodelno,fitemno,fdate,fcst,famt,fqty FROM matestockdif WHERE fmodelno='"+modelNo+"' ");
		ResultSet rs = st.executeQuery();
		boolean rsHasData = rs.next();
		if (rsHasData) {
			String lastUpdate = rs.getString("fdate");
			lastUpdate = lastUpdate.substring(0,4)+"/"+lastUpdate.substring(4,6)+"/"+lastUpdate.substring(6,8);
			float totAmt = 0;
%>
	<tr bgcolor="#0072A8">
		<td><font color="#FFFF00" size="2" face="Arial">資料更新日期</font></td>
		<td colspan=3><font color="#FFFF00" size="2" face="Arial"><%=lastUpdate%></font></td>
	</tr>
	<tr>
		<td><font color="##000000" size="2" face="Arial">料號</font></td>
		<td align="right"><font color="##000000" size="2" face="Arial">標準成本</font></td>
		<td align="right"><font color="##000000" size="2" face="Arial">數量</font></td>
		<td align="right"><font color="##000000" size="2" face="Arial">金額</font></td>
	</tr>
<%
			while (rsHasData) {
%>
	</tr>
		<tr>
		<td><font color="##000000" size="2" face="Arial"><%=rs.getString("fitemno")%></font></td>
		<td align="right"><font color="##000000" size="2" face="Arial"><%=rs.getFloat("fcst")%></font></td>
		<td align="right"><font color="##000000" size="2" face="Arial"><%=rs.getString("fqty")%></font></td>
		<td align="right"><font color="##000000" size="2" face="Arial"><%=rs.getFloat("famt")%></font></td>
	</tr>

<%
				totAmt = totAmt + rs.getFloat("famt");
				rsHasData = rs.next();
			} // end while
%>
	<tr>
		<td colspan=3><font color="#000000" size="2" face="Arial">合計</font></td>
		<td align="right"><font color="#000000" size="2" face="Arial"><%=totAmt%></font></td>
	</tr>


<%


		} // end if rs
		rs.close();
		st.close();

	} // end if modelNo

} // end try
catch (Exception e) { out.println("Exception:"+e.getMessage());
}



%>
</table>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>

