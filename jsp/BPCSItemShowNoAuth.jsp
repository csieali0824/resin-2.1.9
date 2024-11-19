<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得授權==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%> <!-- WINS -->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%> <!-- 大霸電子 -->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%> <!-- 大霸控股 -->
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%> <!-- 迪比特 -->
<%@ include file="/jsp/include/ConnBPCSTmpBOMPoolPage.jsp"%> <!-- BOM Center -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Item Show</title>
</head>

<body>
<A HREF="../WinsMainMenu.jsp">HOME</A>
<A HREF="./BPCSItemSelNoAuth.jsp">Item Inquiry</A>
<%
	String sComp = request.getParameter("COMP"); //公司別
	String sProd = request.getParameter("PROD"); //料號
	String sDesc = request.getParameter("DESC"); //規格
	Connection conn = null;
%>
<!-- 判斷公司別, 取得connection, 將其他release -->
<%
///*
	if (sComp==null || sComp.equals("")) {
	} else if (sComp.equals("01")) { //連到大霸
		conn = bpcscon; //out.println("連到大霸");
		%><%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSTmpBOMPage.jsp"%><!-- BOM Center --><%
	} else if (sComp.equals("02") || sComp.equals("2")) {//連到控股
		conn = ifxdbexpcon; //out.println("連到控股");
		%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSTmpBOMPage.jsp"%><!-- BOM Center --><%
	} else if (sComp.equals("45")) {//連到迪比特
		conn = ifxshoescon; //out.println("連到迪比特");
		%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSTmpBOMPage.jsp"%><!-- BOM Center --><%
	} else if (sComp.equals("999")) {//連到BOM Center
		conn = ifxTmpBOMcon; //out.println("連到BOM Center");
		%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 --><%
	} else { //連到大霸
		conn = bpcscon; //out.println("連到大霸");
		%><%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 --><%
		%><%@ include file="/jsp/include/ReleaseConnBPCSTmpBOMPage.jsp"%><!-- BOM Center --><%
	} // end if-else
//*/
%>
<%
try {
	String name ="";
	String sql = "SELECT mcdesc FROM wsmulti_comp WHERE trim(mccomp)='"+sComp.trim()+"'"; //out.println("<br>"+sql);
	PreparedStatement ps = con.prepareStatement(sql);
	ResultSet rs = ps.executeQuery();
	if (rs.next()) { name = rs.getString("mcdesc").trim(); }
	rs.close();
	ps.close();
	//out.println("<br>"+" Company="+name+" Fac="+sFac+" Item="+sProd+" Method="+sMethod+" 採購件下階展開="+type);
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><!-- WINS --><%
%>
<table border="1">
<tr><td colspan="2"><%=name%></td></tr>
<tr><td>Item</td><td>Description</td></tr>
<%
	if (((sProd==null || sProd.equals("")) && (sDesc==null || sDesc.equals(""))) || (sComp==null || sComp.equals(""))) {
	} else {
		sql = "SELECT iprod,idesc||idsce AS desc FROM iim WHERE iid='IM' ";
		if (sProd!=null && !sProd.equals("")) {sql = sql+" AND iprod like '%"+sProd+"%'"; }
		if (sDesc!=null && !sDesc.equals("")) {sql = sql+" AND idesc||idsce like '%"+sDesc+"%'"; }
		sql = sql +" ORDER BY iprod";
		//out.println("<br>"+sql);
		ps = conn.prepareStatement(sql);
		rs = ps.executeQuery();
		boolean eof = !rs.next();
		if (eof) {
%>
<tr>
	<td colspan="2"><font color="#FF0000"><%out.println("Record(s) Not Found!");%></font></td>
</tr>
<%
		}
		while (!eof) {
%>
<tr>
	<td><%=rs.getString("iprod").trim()%></td>
	<td><%=rs.getString("desc").trim()%></td>
</tr>
<%
			eof = !rs.next();
		} // end while
		rs.close();
		ps.close();
	} // end if-else
} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><!-- WINS --><%
	%><%//@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
//*
	if (sComp==null || sComp.equals("")) {
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
} // end try-catch

%>
</table>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%//@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 -->
<%//@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 -->
<%//@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 -->
<%
///*
	if (sComp==null || sComp.equals("")) {
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
