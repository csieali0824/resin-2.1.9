<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="ComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<script language="JavaScript">
function submitCheck() {
	if (document.MYFORM.ROLE.value == "--") {
		alert("請輸入角色");
		return (false);
	}
	if (document.MYFORM.COMP.value == "--") {
		alert("請輸入公司");
		return (false);
	}
	document.MYFORM.submit();
} //end function
</script>

<html>
<head>
<title>新增公司授權</title>

</head>
<body>
<FORM ACTION="./MMCompIns.jsp" METHOD="post" NAME="MYFORM" >
<strong><font color="#0080C0" size="5">新增公司授權</font></strong>
<br><br>
<A HREF="/oradds/ORADDSMainMenu.jsp">回首頁</A>
&nbsp;&nbsp;
<a href="MMCompList.jsp">公司授權清單</a>
<br><br>
<table border="1">
<tr><td>
角色</td><td>
<%
try {
	Statement st=con.createStatement(); 
	ResultSet rs=st.executeQuery("SELECT ROLENAME,ROLENAME||'--'||ROLEDESC FROM ORADDMAN.WSROLE ORDER BY ROLENAME");
	comboBoxBean.setRs(rs);
	comboBoxBean.setFieldName("ROLE");
	out.println(comboBoxBean.getRsString());
	rs.close();
	st.close();
} // end try

catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
}
%>
</td></tr>
<tr><td>公司</td><td>
<%
try {
	Statement st=con.createStatement(); 
	ResultSet rs=st.executeQuery("SELECT trim(mccomp),trim(mccomp)||'--'||trim(mcDESC) FROM ORADDMAN.wsmulti_comp WHERE mccomp is not null ORDER BY mccomp ");
	comboBoxBean.setRs(rs);
	comboBoxBean.setFieldName("COMP");
	out.println(comboBoxBean.getRsString());
	rs.close();
	st.close();

} // end try

catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
}

%>
</td></tr>

<tr><td colspan="2" align="center"><input type="submit" value='存檔'
 onClick='return submitCheck("請輸入角色"
  ,"請輸入公司")'>
</td></tr>
</table>
</FORM>

</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
