<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="BpcsBomBean" %>
<jsp:useBean id="bpcsBomBean" scope="page" class="BpcsBomBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%> <!-- WINS -->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%> <!-- 大霸電子 -->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%> <!-- 大霸控股 -->
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%> <!-- 迪比特 -->
<%@ include file="/jsp/include/ConnBPCSTmpBOMPoolPage.jsp"%> <!-- BOM Center -->
<%
	String sComp = request.getParameter("COMP"); //公司別
	String sProd = request.getParameter("PROD"); //料號
	String sFac = request.getParameter("FAC"); //廠別
	String sMethod = request.getParameter("MET"); //制程
	String sType = request.getParameter("TYP"); //0=single-level,1=multi-level,其他=最上階
	Connection conn = con;
%>
<!-- 判斷公司別, 取得connection, 將其他release -->
<%
///*
	if (sProd==null || sComp==null) {
	} else if (sComp.equals("01")) { //連到大霸
		conn = bpcscon;
		%><%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSTmpBOMPage.jsp"%><!-- BOM Center --><%
	} else if (sComp.equals("02") || sComp.equals("2")) {//連到控股
		conn = ifxdbexpcon;
		%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSTmpBOMPage.jsp"%><!-- BOM Center --><%
	} else if (sComp.equals("45")) {//連到迪比特
		conn = ifxshoescon;
		%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSTmpBOMPage.jsp"%><!-- BOM Center --><%
	} else if (sComp.equals("999")) {//連到BOM Center
		conn = ifxTmpBOMcon;
		%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 --><%
	} else { //連到大霸
		conn = bpcscon;
		%><%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSTmpBOMPage.jsp"%><!-- BOM Center --><%
	} // end if-else
//*/
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>BOM Test</title>
</head>

<body>
<A HREF="../WinsMainMenu.jsp">HOME</A>
<A HREF="./BPCSBomWhereUseSel.jsp">Where Use Inquiry</A>
<%
try {
	String type = "";
	String name ="";
	String sql = "SELECT mcdesc FROM wsmulti_comp WHERE trim(mccomp)='"+sComp.trim()+"'"; //out.println("<br>"+sql);
	PreparedStatement ps = con.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	if (rs.next()) { name = rs.getString("mcdesc").trim(); }
	rs.close();
	ps.close();
	if (sType.equals("S")) { type="Single-Level"; } else if (sType.equals("M")) { type="Multi-Level"; } else { type="最上階"; }
	//out.println("<br>"+" Company="+name+" Fac="+sFac+" Item="+sProd+" Method="+sMethod+" 顯示資料="+type);
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><!-- WINS --><%

	if (sProd==null || sComp==null) {
	} else {
		bpcsBomBean.setConnection(conn);
		int r = bpcsBomBean.getWhereUse(sProd,sFac,sMethod,sType);
		//out.println("<br>"+"Total Record(s)="+r);
%>
<table border="1">
<tr><td>Company</td><td colspan="5"><%=name%></td></tr>
<tr>
	<td>Fac</td><td><%if (sFac==null || sFac.equals("")) {out.println("&nbsp;&nbsp;");} else {out.println(sFac);}%></td>
	<td>Item</td><td><%=sProd%></td>
	<td>Method</td><td><%if (sMethod==null || sMethod.equals("")) {out.println("&nbsp;&nbsp;");} else {out.println(sMethod);}%></td>
</tr>
<tr><td>顯示資料</td><td colspan="5"><%=type%></td></tr>
<tr><td >Total Record(s)</td><td colspan="5"><%=r%></td></tr>
</table>
<table border="1">
<tr>
	<td>Level</td>
	<td>Item</td>
	<td>Desc</td>
</tr>

<%
		int n = 0;
		bpcsBomBean.setNext(n);
		for (int j=0;j<r;j++) {
			%><tr><%
			%><td><%
			//out.println("["+n+"]");
			out.println(bpcsBomBean.getLevelString());
			%></td><td><%
			out.println(" "+bpcsBomBean.getParent());
			%></td><td><%
			out.println(" "+bpcsBomBean.getDesc());
			%></td><%
			%></tr><%
			n = bpcsBomBean.getNext();
		} // end for
	} // end if

} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><!-- WINS --><%
	%><%//@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
//*
	if (sProd==null || sComp==null) {
	} else if (sComp.equals("01")) { //連到大霸電子
		%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
	} else if (sComp.equals("02") || sComp.equals("2")) {//連到控股
		%><%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 --><%
	} else if (sComp.equals("45")) {//連到迪比特
		%><%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 --><%
	} else if (sComp.equals("999")) {//連到BOM Center
		%><%@ include file="/jsp/include/ReleaseConnBPCSTmpBOMPage.jsp"%><!-- BOM Center --><%
	} else {
		%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
	} // end if-else
//*/
}
%>
</table>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%><!-- WINS -->
<%//@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 -->
<%//@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 -->
<%//@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 -->
<%
///*
	if (sProd==null || sComp==null) {
	} else if (sComp.equals("01")) { //連到大霸電子
		%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
	} else if (sComp.equals("02") || sComp.equals("2")) {//連到控股
		%><%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 --><%
	} else if (sComp.equals("45")) {//連到迪比特
		%><%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 --><%
	} else if (sComp.equals("999")) {//連到BOM Center
		%><%@ include file="/jsp/include/ReleaseConnBPCSTmpBOMPage.jsp"%><!-- BOM Center --><%
	} else {
		%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
	} // end if-else
//*/
%>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
