<%@ page contentType="text/html" language="java" %>
<%@ page import="java.sql.*,ComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============for multi-language==========-->
<%@ include file="./include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>

<title><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgFunction"/></title>
</head>

<body>
<%
try {
	String sFunction = request.getParameter("FFUNCTION");
	String sModule = request.getParameter("FMODULE");
	String sDesc = request.getParameter("FDESC");
	String sAddr = request.getParameter("FADDRESS");
	String sShow = request.getParameter("FSHOW");
	String sSeq = request.getParameter("FSEQ");

%>
<form name="MYFORM" method="post" action="MMFunctionUpdate.jsp">
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgRevise"/><jsp:getProperty name="rPH" property="pgFunction"/></font></strong>
<br><br>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMFunctionList.jsp"><jsp:getProperty name="rPH" property="pgFunction"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<table border="1">
<tr>
<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgFunction"/></font></td>
<td><input name="FUNCTION" type="hidden" value="<%=sFunction%>"><%=sFunction%></td>
</tr>
<tr>
<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgDesc"/></font></td>
<td><input name="DESC" type="text" value="<%=sDesc%>"></td>
</tr>
<tr>
<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgModule"/></font></td>
<td><%
	Statement st=con.createStatement(); 
	ResultSet rs=st.executeQuery("SELECT MMODULE,MMODULE||'--'||MDESC AS MDESC FROM ORADDMAN.MENUMODULE ORDER BY MMODULE");
	comboBoxBean.setRs(rs);
	comboBoxBean.setSelection(sModule);
	comboBoxBean.setFieldName("MODULE");
	out.println(comboBoxBean.getRsString());
	rs.close();
	st.close();
%></td>
</tr>
<tr>
<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgHref"/></font></td>
<td><input name="ADDR" type="text" value="<%=sAddr%>" ></td>
</tr>
<tr>
<td><font face="Arial" size="3">SHOW</font></td>
<td><input name="SHOW" type="text" value="<%=sShow%>" ></td>
</tr>
<tr>
<td><font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgSeq"/></font></td>
<td><input name="SEQ" type="text" value="<%=sSeq%>" align="right"></td>
</tr>
<tr>
<td colspan="2" align="center"><input type="submit" value='<jsp:getProperty name="rPH" property="pgSave"/>'
 onClick='return submitCheck("<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgFunction'/>"
 ,"<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgDesc'/>"
 ,"<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgModule'/>"
  ,"<jsp:getProperty name='rPH' property='pgPlsEnter'/><jsp:getProperty name='rPH' property='pgHref'/>")'>
</td>
</tr>
<tr>
</table>
</form>
<%
} // end try

catch (Exception e) { out.println("Exception:"+e.getMessage()); }
%>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<script>
function submitCheck(ms1,ms2,ms3,ms4) {
	if (document.MYFORM.FUNCTION.value == "") {
		alert(ms1);
		return (false);
	}
	if (document.MYFORM.DESC.value == "") {
		alert(ms2);
		return (false);
	}
	if (document.MYFORM.MODULE.value == "--") {
		alert(ms3);
		return (false);
	}
	if (document.MYFORM.ADDR.value == "") {
		alert(ms4);
		return (false);
	}
	document.MYFORM.submit();
} //end function
</script>