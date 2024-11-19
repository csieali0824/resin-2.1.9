<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============Open Connectiong==========-->
<%@ include file="/jsp/include/ConnBPCS.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sample for Company Connect DB</title>
</head>

<body>
<font face="細明體" size="+2" color="#33CCFF"><strong>範列:如何動態連結BPCS資料庫</strong></font>
<br>
<font>公司代碼=<%=CompCode%></font>
<br>
<font>公司名稱=<%=CompName%></font>
<br>
<font>資料庫=<%=CompDbase%></font>
<br>
<font>Ledger=<%=CompLedger%></font>
<br>
<font>Book=<%=CompBook%></font>
<br>
<font>Base Currency=<%=CompCurr%></font>
<br>
<font>以下為table RCO 的資料</font>
<table border="1">
<tr><td>COMP</td><td>NAME</td></tr>
<%
try {
if (defcon!=null) {
	Statement st = defcon.createStatement();
	ResultSet rs = st.executeQuery("SELECT cmpny,cmpnam FROM rco");
	while (rs.next()) {
%>
<tr><td><%=rs.getString("cmpny")%></td><td><%=rs.getString("cmpnam")%></td></tr>
<%

	}
	rs.close();
	st.close();
} // end if
else { out.println("Connection Error");
}
} // end try
catch (Exception err) {out.println("Exception:"+err.getMessage());
%>
<%@ include file="/jsp/include/ReleaseConnBPCS.jsp"%>
<%
}

%>
</table>
</body>
</html>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnBPCS.jsp"%>
