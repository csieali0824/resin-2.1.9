<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,ComboBoxBean,ArrayComboBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDbglobalPoolPage.jsp/"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Parts Inquiry</title>
</head>

<body>
<%
String sModelNo=request.getParameter("MODELNO");
String sFlag=request.getParameter("FLAG");
%>
<form ACTION="WSProductPartsInquiry.jsp?FLAG=1" METHOD="post" NAME="MYFORM">
<font color="#009999" face="Times New Roman" size="+3"><strong>DBTEL</strong></font>
<font color="#000000" face="Times New Roman" size="+2"><strong>Parts Inquiry</strong></font>
<br><A HREF="../WinsMainMenu.jsp">HOME</A>
<table border="1">
<tr>
<td><font face="Arial" color="#000000" size="+1"><strong>MODEL</strong></font></td>
<td><font face="Arial" color="#000000" size="+1"><strong>
	<%
	try {
		Statement st=ifxdbglobalcon.createStatement();
		ResultSet rs = st.executeQuery("SELECT UNIQUE MODELNO,MODELNO FROM REPAIRBOM");
		comboBoxBean.setRs(rs);		  
		comboBoxBean.setFieldName("MODELNO");	   
		comboBoxBean.setSelection(sModelNo);
		out.println(comboBoxBean.getRsString());		
		rs.close();
		st.close();
	} //end try
	catch (Exception e){out.println("Exception:"+e.getMessage());	}
	%>
	</strong></font>
</td>
<td><font face="Arial" color="#000000" size="+1"><strong>
	<input type="submit" name="Query"  value="QUERY">
	</strong></font>
</td>
</tr>
</table>

<table border="1">
<tr>
	<td><font face="Arial" color="#000000" size="1"><strong>MODEL</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>PRODUCT</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>PRODUCT DESC.</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>PARTS</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>PARTS DESC.</strong></font></td>
</tr>

<%
try {
	if (sFlag!=null && sFlag.equals("1")) {
		//out.println(sFlag);
		Statement st=ifxdbglobalcon.createStatement();
		String sql = "SELECT MODELNO,GOODS,ITEMNO,AA.IDESC||AA.IDSCE AS GDESC, BB.IDESC||BB.IDSCE AS IDESC"+
		" FROM REPAIRBOM,IIM AA,IIM BB "+
		" WHERE GOODS=AA.IPROD AND ITEMNO=BB.IPROD AND SUBSTR(ITEMNO,1,3) IN ('3EP','7DP','7DT')";
		//out.println(sql);
		if (sModelNo!=null && !sModelNo.equals("--")) { sql = sql + " AND MODELNO='"+sModelNo+"'";}
		sql = sql + " ORDER BY MODELNO, GOODS,ITEMNO";
		ResultSet rs = st.executeQuery(sql);
		while (rs.next()) {
%>
	<tr>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("MODELNO")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("GOODS")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("GDESC")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("ITEMNO")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("IDESC")%></strong></font></td>
	</tr>
<%
		} // end while
		rs.close();
		st.close();
	
	} // end if
	
} // end try
catch (Exception e){out.println("Exception:"+e.getMessage());	}

%>
</table>
</form>

</body>
</html>

<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDbglobalPage.jsp"%>