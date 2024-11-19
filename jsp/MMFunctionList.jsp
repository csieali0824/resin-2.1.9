<%@ page contentType="text/html" language="java" %>
<%@ page import="java.sql.*,DateBean" %>
<%@ page import="QryAllChkBoxEditBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
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
<script>
var checkflag = "false";
function check(field,ms1,ms2) {
	if (checkflag == "false") {
		for (i = 0; i < field.length; i++) {
			field[i].checked = true;
		}
		checkflag = "true";
		return ms1; 
	} else {
		for (i = 0; i < field.length; i++) {
			field[i].checked = false; 
		}
		checkflag = "false";
		return ms2; 
	} // end if-else
}// end function

function NeedConfirm(ms1) { 
	flag=confirm(ms1); 
	return flag;
}// end function

function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

</script>
<html>
<head>
<title><jsp:getProperty name="rPH" property="pgFunction"/><jsp:getProperty name="rPH" property="pgList"/></title>
</head>

<body>
<%
try {
	String searchString=request.getParameter("SEARCHSTRING");
%>


<form name="MYFORM" action="MMFunctionDel.jsp" method="post"  onSubmit='return NeedConfirm("<jsp:getProperty name='rPH' property='pgDelete'/>")'>
<strong><font color="#0080C0" size="5"><jsp:getProperty name="rPH" property="pgFunction"/><jsp:getProperty name="rPH" property="pgList"/></font></strong>
<br><br>
<A HREF="/oradds/OraddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMFunctionNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgFunction"/></a>
<br><br>
<input name="button" type=button onClick='this.value=check(this.form.CH,"<jsp:getProperty name='rPH' property='pgCancelSelect'/>","<jsp:getProperty name='rPH' property='pgSelectAll'/>")' value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
<input type="submit" value='<jsp:getProperty name="rPH" property="pgDelete"/>'>
<font face="Arial" size="3"><jsp:getProperty name="rPH" property="pgFunction"/></font><input name="SEARCHSTRING" type="text" value="<%if (searchString!=null) out.println(searchString);%>">
<input name="search" type=button onClick='setSubmit("MMFunctionList.jsp")' value='<jsp:getProperty name="rPH" property="pgSearch"/>'>
<%
	
	String sSql = "SELECT FFUNCTION,FDESC,FMODULE,FSEQ,FADDRESS,FSHOW FROM ORADDMAN.MENUFUNCTION WHERE FFUNCTION IS NOT NULL and substr(FADDRESS,1,5) != '/wins'  ";
	if (searchString!=null) sSql = sSql + " AND ( UPPER(FFUNCTION) LIKE UPPER('%"+searchString+"%') OR UPPER(FDESC) LIKE UPPER('%"+searchString+"%') )";
	sSql = sSql + " ORDER BY FMODULE,FSEQ,FFUNCTION";
	//out.println(sSql);

	Statement st=con.createStatement(); 
	ResultSet rs=st.executeQuery(sSql);
	String a[] = {"FFUNCTION","FDESC","FMODULE","FSEQ","FADDRESS","FSHOW"};
	qryAllChkBoxEditBean.setPageURL("../jsp/MMFunctionEdit.jsp");
	qryAllChkBoxEditBean.setSearchKeyArray(a);
	qryAllChkBoxEditBean.setFieldName("CH");
	qryAllChkBoxEditBean.setRowColor1("B0E0E6");
	qryAllChkBoxEditBean.setRowColor2("ADD8E6");
	qryAllChkBoxEditBean.setRs(rs);   
	out.println(qryAllChkBoxEditBean.getRsString());
	rs.close();
	st.close();


%>
</form>
<%
} // end try

catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
}//end try-catch

%>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
