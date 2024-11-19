<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>WSForecastMenu.jsp</title>
<style type="text/css">
<!--
.style1 {color: #FFFFFF}
.style2 {
	color: #000099;
	font-weight: bold;
	font-family: "標楷體";
}
-->
</style>

<STYLE type=text/css>
A:link {
	TEXT-DECORATION: none;
	color: #1878C2;
}
A:active {
	TEXT-DECORATION: none
}
A:visited {
	TEXT-DECORATION: none;
	color: #1878C2;
}
A:hover {
	COLOR: #3333FF; TEXT-DECORATION: none
}
td {
	font-size: 12px;
}
.tab {
	background-image:  url(../image/bd.jpg);
	background-repeat: no-repeat;
}
</STYLE>

</head>  

<body topmargin="0" class="tab">
  <%
  String USERROLES=(String)session.getAttribute("USERROLES");   
  %>
<BR>
<table width="77%" height="52" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="34" align="left" bgcolor="#E4F1FA"><font color="#3366FF"><strong>BUSINESS
    OPERATION </strong></font></td>
    <td align="left" bgcolor="#E4F1FA">&nbsp;</td>
    <td align="left" bgcolor="#E4F1FA"><A href="/wins/WinsMainMenu.jsp">HOME</td>
  </tr>
  <tr>
    <td width="55%" align="left"><div align="left"><font color="#3366FF"></font><font color="#FFFFFF">
        <%    
	String sSql="";
	Statement statement=con.createStatement();  
	sSql = "SELECT DISTINCT MMODULE,MDESC,MSEQ,FADDRESS,FDESC,FFUNCTION FROM MENUMODULE,MENUFUNCTION,WSPROGRAMMER "+
		" WHERE MMODULE=FMODULE AND FSHOW=1 AND FFUNCTION=ADDRESSDESC"+" AND ROLENAME IN ("+roles+")"+
		" AND MROOT='D' AND MMODULE='D1'"+
		" ORDER BY FFUNCTION ";
	ResultSet rs_D1=statement.executeQuery(sSql);
    while(rs_D1.next())
    {
      	String ADDRESS_D1 = rs_D1.getString("FADDRESS");
		String PROGRAMMERNAME_D1 = rs_D1.getString("FFUNCTION")+"--"+rs_D1.getString("FDESC");
		out.println("<font size=-1><a href="+ ADDRESS_D1 +">"+PROGRAMMERNAME_D1+"</a><br>");
	}
      rs_D1.close();  
	  statement.close();
   %>
    </font></div></td>
    <td width="17%" align="left"><font color="#3366FF"><div align="center"></div>
    </font></td>
    <td width="28%" align="left"><font color="#FFFFFF">&nbsp;</font></td>
  </tr>
</table>
 
<div align="center"></div>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>