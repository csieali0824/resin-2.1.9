<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,ArrayListCheckBoxBean" %>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>樣品繳回完成</title>
</head>

<body>

<font color="#3366FF" size="+2" face="Arial"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Arial"><strong>樣品繳回完成</strong></font>
<br>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A> &nbsp
<A HREF="../jsp/WSShippingSampleEntry.jsp">樣品領用作業</A>&nbsp
<A HREF="../jsp/WSShippingSampleReturn.jsp">樣品繳回作業</A>&nbsp
<A HREF="../jsp/WSShippingSampleQuery.jsp">樣品領用查詢作業</A>
<br>

<%
	String a[][]=arrayListCheckBoxBean.getArray2DContent();


%>
<table border='1' bgcolor="#CCFFCC" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="#333399" font size="2" face="Arial Black">ITEM</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">IMEI</font></td>
		<td><font color="#333399" font size="2" face="Arial Black">CARTON</font></td>
	</tr>
<%
try
{
	if (a==null)
	{ out.println("<tr><td colspan='2'><font color='#333399' font size='2' face='Arial Black'>"+"INPUT DATA NOT FOUND"+"</font></td></tr>");
	}
	else
	{
		
		Statement statement=con.createStatement();
		
		for (int i=0;i<a.length;i++)
		{
			
			String sIMEI = a[i][0];
			String sCarton = a[i][2];
%>
	<tr>
		<td><font color="#333399" font size="2" face="Arial Black"><%=i+1%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=sIMEI%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=sCarton%></font></td>
	</tr>

<%
			String sql = "UPDATE WSSHIP_IMEI_T SET SHP_NOTES='SR01' WHERE IMEI='"+sIMEI+"'";
			statement.executeUpdate(sql);
			//out.println(sql);
		} // end for
		
		statement.close();
		
		// clear array bean data
		arrayListCheckBoxBean.setArray2DString(null);
		
	} // end if

} // end try
catch (Exception e) {out.println("Exception:"+e.getMessage());}




%>

</table>

</body>
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
