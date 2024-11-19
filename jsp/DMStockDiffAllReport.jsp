<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="RsCountBean" %>
<jsp:useBean id="rsCountBean" scope="page" class="RsCountBean"/>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>差異料表</title>
</head>

<body>
<font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Times New Roman"><strong> 差異料表</strong></font>
<%
try {

	String a[][] = new String [][];
	PreparedStatement st = dmcon.prepareStatement("SELECT fmodelno,fitemno,fdate,fcst,famt,fqty FROM matestockdif ORDER BY fmodelno ");
	ResultSet rs = st.executeQuery();
	rsCountBean.setRs(rs);
	int i = rsCountBean.getRsCount();
	a[][] = new String[i][5];
	boolean rsHasData = rs.next();		
	if (rsHasData) {
		String lastUpdate = rs.getString("fdate");
		lastUpdate = lastUpdate.substring(0,4)+"/"+lastUpdate.substring(4,6)+"/"+lastUpdate.substring(6,8);
		float totAmt = 0;
		i = 0;
		while (rsHasData) {
			a[i][0]=rs.getString("fmodelno");
			a[i][1]=rs.getString("fitemno");
			a[i][2]=rs.getString("fcst");
			a[i][3]=rs.getString("famt");
			a[i][4]=rs.getString("fqty");
			i++;
			rsHasData = rs.next();
		} // end while
		rs.close();
		st.close();
%>
<table border="1">
	<tr bgcolor="#0072A8">
		<td><font color="#FFFF00" size="2" face="Arial">資料更新日期</font></td>
		<td colspan=3><font color="#FFFF00" size="2" face="Arial"><%=lastUpdate%></font></td>
	</tr>
	<tr>
		<td><font color="##000000" size="2" face="Arial">機種</font></td>
		<td><font color="##000000" size="2" face="Arial">料號</font></td>
		<td align="right"><font color="##000000" size="2" face="Arial">標準成本</font></td>
		<td align="right"><font color="##000000" size="2" face="Arial">數量</font></td>
		<td align="right"><font color="##000000" size="2" face="Arial">金額</font></td>
	</tr>
<%
		for (int j=0;j<i;j++) {
%>
	<tr>
		<td><%=a[j][0]%></td>
		
<%
			for (int k=0;k<5;k++) {
%>
		<td colspan="4">
			<table>
				<tr>
					<td><font color="##000000" size="2" face="Arial"><%=rs.getString("fitemno")%></font></td>
					<td align="right"><font color="##000000" size="2" face="Arial"><%=rs.getFloat("fcst")%></font></td>
					<td align="right"><font color="##000000" size="2" face="Arial"><%=rs.getString("fqty")%></font></td>
					<td align="right"><font color="##000000" size="2" face="Arial"><%=rs.getFloat("famt")%></font></td>
				</tr>
			</table>
		</td>
	</tr>
<%
				totAmt = totAmt + rs.getFloat("famt");
				rsHasData = rs.next();
			} // end for k
		} // end for j
%>

	<tr>
		<td colspan=3><font color="#000000" size="2" face="Arial">合計</font></td>
		<td align="right"><font color="#000000" size="2" face="Arial"><%=totAmt%></font></td>
	</tr>
</table>

<%


	} // end if rs



} // end try
catch (Exception e) { out.println("Exception:"+e.getMessage());
}



%>

</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>

