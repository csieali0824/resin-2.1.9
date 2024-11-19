<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<html>
<head>
<title>刪除成功</title>
</head>
<body>
<%
try {
	String [] ch = request.getParameterValues("CH"); //out.println(ch[0]);
	if (ch!=null) {
		String role = ""; 
		String comp = "";
		String sql = "";
		PreparedStatement ps = null;
		for (int i=0;i<ch.length;i++) {
			role = ch[i].substring(0,ch[i].indexOf("|")); //out.println(role);
			comp = ch[i].substring(ch[i].indexOf("|")+1,ch[i].length()); //out.println(comp);
			sql = "DELETE FROM ORADDMAN.wsrole_comp WHERE rolename='"+role+"' AND comp='"+comp+"'";
			//out.println(sql);
			ps = con.prepareStatement(sql);
			ps.executeUpdate();
		} // end for
		ps.close();
	} // end if

} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
} // end try-catch

%>
<A HREF="/oradds/ORADDSMainMenu.jsp">回首頁</A>
&nbsp;&nbsp;
<a href="MMCompList.jsp">公司授權清單</a>
<br><br>
<font>刪除成功</font>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
