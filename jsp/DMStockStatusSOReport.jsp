<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Stock Status - Open Shop Order</title>
</head>

<body>
<%
try {

	//取得傳入參數
	String sProdNo=request.getParameter("PRODNO");

%>
<font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Times New Roman"><strong><%=sProdNo%> Stock Status - Open Shop Order</strong></font>


<table border="1">
<tr>
	<td><font color="#000000" size="2" face="Arial">料號</font></td>
	<td><font color="#000000" size="2" face="Arial">工單號</font></td>
	<td><font color="#000000" size="2" face="Arial">發工量</font></td>
	<td><font color="#000000" size="2" face="Arial">完工量</font></td>
	<td><font color="#000000" size="2" face="Arial">發工量-完工量</font></td>
</tr>

<%
	
	int nQReq = 0;
	int nQFin = 0;
	int nQWIP = 0;
	int nSumQReq = 0;
	int nSumQFin = 0;
	int nSumQWIP = 0;
	
	if (sProdNo!=null && !sProdNo.equals("")) {
		Statement state=bpcscon.createStatement();
		ResultSet rs=state.executeQuery("SELECT SPROD,SORD,SQREQ,SQFIN FROM FSO WHERE SID='SO' AND SPROD='"+sProdNo+"'");
		
		while (rs.next()) {
		
%>
<tr>
	<td><font color="#000000" size="2" face="Arial"><%=rs.getString("SPROD")%></font></td>
	<td><font color="#000000" size="2" face="Arial"><%=rs.getString("SORD")%></font></td>
	<td align="right"><font color="#000000" size="2" face="Arial"><%=rs.getInt("SQREQ")%></font></td>
	<td align="right"><font color="#000000" size="2" face="Arial"><%=rs.getInt("SQFIN")%></font></td>
	<td align="right"><font color="#000000" size="2" face="Arial"><%=rs.getInt("SQREQ")-rs.getInt("SQFIN")%></font></td>
</tr>
<%		
		nSumQReq = nSumQReq + rs.getInt("SQREQ");
		nSumQFin = nSumQFin + rs.getInt("SQFIN");
		nSumQWIP = nSumQWIP + ( rs.getInt("SQREQ") - rs.getInt("SQFIN") );
		} // end if
		rs.close();
		state.close();
	} // end if
	
%>
<tr>
	<td colspan=2>合計</td>
	<td align="right"><font color="#000000" size="2" face="Arial"><%=nSumQReq%></font></td>
	<td align="right"><font color="#000000" size="2" face="Arial"><%=nSumQFin%></font></td>
	<td align="right"><font color="#000000" size="2" face="Arial"><%=nSumQWIP%></font></td>
</tr>

</table>

<%
}// end try
catch (Exception e) { out.println("Exception:"+e.getMessage()); }

%>
</body>
</html>

<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>