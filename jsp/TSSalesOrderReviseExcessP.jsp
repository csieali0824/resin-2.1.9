<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<title>Excess Status Process</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.PMDFORM.action=URL;
	document.PMDFORM.submit();
}
</script>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSSalesOrderReviseExcessP.jsp" METHOD="post" NAME="ExcessFORM">
<%
try
{
	String LINENUM = request.getParameter("LINENUM");
	//if (LINENUM ==null) LINENUM="10";
	out.println("<div style='font-family:Tahoma,Georgia;font-size:12px'>LINENUM="+LINENUM+"</div>");
	
	// 為存入日期格式為US考量,將語系先設為美國
	String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	pstmtNLS.executeUpdate(); 
	pstmtNLS.close();

}
catch(Exception e)
{
	con.rollback();
	out.println("<font color='red'>交易失敗,請速洽系統工程師,謝謝!!<br>"+e.getMessage()+"</font>");
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

