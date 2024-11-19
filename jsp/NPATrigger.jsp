<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnPDMPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>NPA Trigger</title>
</head>
<%
	Statement statement=con.createStatement();
	Statement pdmstatement=pdmcon.createStatement();
	ResultSet pdmrs=pdmstatement.executeQuery("select  * from npa_detail where rownum<100 ");  
	while(pdmrs.next())		 
	{			    
		out.println(pdmrs.getString("mrid")+"<br>");
	}//end of while
	rs.close();	 

	ResultSet rs=statement.executeQuery("select  * from npa_detail where STATUS='00'");  
	while(rs.next())		 
	{			    
		out.println(rs.getString("mrid")+"<br>");
	}//end of while
	rs.close();	 

%>
<body>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPDMPage.jsp"%>
