<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean" %>

<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>WSShipping.jsp</title>
</head>
  <jsp:useBean id="rsBean" scope="application" class="RsBean"/>

<body topmargin="0">
  <%
  String USERROLES=(String)session.getAttribute("USERROLES");  
  String UserName=(String)session.getAttribute("USERNAME"); 
  %>


<table width="77%" height="30" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td width="25%" align="left" bgcolor="#4646FF"><font color="#FFFFFF">&nbsp;</font></td>
    <td width="25%" align="left" bgcolor="#4646FF"><div align="center"><font color="#FFFFFF"><strong>LC</strong></font></div></td>
    <td width="25%" align="left" bgcolor="#4646FF"><font color="#FFFFFF">&nbsp;</font></td>
	<td width="2%" align="right" nowrap bgcolor="#4646FF"><font color="#00FF00"><strong><a href="/wins/jsp/Logout.jsp"></a></strong></font></td>
  </tr>
</table>
<table width="77%" height="209" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="31%" height="16" valign="top" bgcolor="#FFFFFF">&nbsp; </td>
    <td width="30%" valign="top" bgcolor="#FFFFFF">
      <%
    String MODEL_F1 = "F1";
	Statement statement=con.createStatement();
    ResultSet rs_F1=statement.executeQuery("select ADDRESS,PROGRAMMERNAME from WsProgrammer WHERE ROLENAME IN (select ROLENAME from WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') AND  MODEL='"+MODEL_F1+"' order by Lineno");
    rsBean.setRs(rs_F1);
    while(rs_F1.next())
    {
      	String ADDRESS_F1 = rs_F1.getString("ADDRESS");
		String PROGRAMMERNAME_F1 = rs_F1.getString("PROGRAMMERNAME");
		out.println("<font size=-1><a href="+ ADDRESS_F1 +">"+PROGRAMMERNAME_F1+"</a><br>");
	}
      rs_F1.close();  
	  statement.close();
   %>
    </td>
    <td width="39%" valign="top" bgcolor="#FFFFFF">&nbsp; </td>
  </tr>
</table>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>