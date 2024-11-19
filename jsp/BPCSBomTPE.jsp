<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="BpcsBomBean" %>
<jsp:useBean id="bpcsBomBean" scope="session" class="BpcsBomBean"/>
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
<script>
//不能使用mouse右鍵
/* 方法一
function click(e) {
	if (document.all) {
		if (event.button==1||event.button==2||event.button==3) {oncontextmenu='return false';}
	}
	if (document.layers) {
		if (e.which == 3) {oncontextmenu='return false';}
	}
} // end function
if (document.layers) {document.captureEvents(Event.MOUSEDOWN);}
document.onmousedown=click;
document.oncontextmenu = new Function("return false;")
*/
//方法二
function noSourceExplorer() {
	if (document.MYFORM.PRT.value=="0") {
		if (event.button==2 | event.button==3) {alert("此功能失效");}
	} // end if
} // end function
if (navigator.appName.indexOf("Internet Explorer")!=-1) document.onmousedown = noSourceExplorer;


//不能使用Ctrl鍵
var travel=true
var hotkey=17　 
function gogo(e) { 
	if (document.MYFORM.PRT.value=="0") {
		if (document.layers) {
	　　	if (e.which==hotkey&&travel){alert("此功能失效");} 
		} else if (document.all) {
		　　if (event.keyCode==hotkey&&travel){ alert("此功能失效"); }
		} // end if-else
	} // end if
} // end function
document.onkeydown=gogo ;

</script>

<%
	String sComp = request.getParameter("COMP"); //公司別
	String sProd = request.getParameter("PROD"); //料號
	String sFac = request.getParameter("FAC"); //廠別
	String sMethod = request.getParameter("MET"); //制程
	String sType = request.getParameter("TYP"); //1表示採購件下階不展開
	String prt = request.getParameter("PRT"); //控制是否能印表, 0=否,1=可
	Connection conn = null;

%>
<!-- 判斷公司別, 取得connection, 將其他release -->
<%
///*
	if (sProd==null || sProd.equals("") || sComp==null || sComp.equals("")) {
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
<title>BOM Show</title>
</head>
<body>
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
	//if (sType.equals("0")) { type="是"; } else { type="否"; }
	//out.println("<br>"+" Company="+name+" Fac="+sFac+" Item="+sProd+" Method="+sMethod+" 採購件下階展開="+type);
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><!-- WINS --><%

	if (sProd==null || sProd.equals("") || sComp==null || sComp.equals("")) {
	} else {
		bpcsBomBean.setConnection(conn);
		int r = bpcsBomBean.getStructure(sProd,sFac,sMethod,sType); 
		//out.println("<br>"+"Total Record(s)="+r);

%>
<form name="MYFORM">
<table border="1">
<tr><td>Company</td><td colspan="5"><%=name%></td></tr>
<tr>
	<td>Fac</td><td><%if (sFac==null || sFac.equals("")) {out.println("&nbsp;");} else {out.println(sFac);}%></td>
	<td>Item</td><td><%=sProd%></td>
	<td>Method</td><td><%if (sMethod==null || sMethod.equals("")) {out.println("&nbsp;");} else {out.println(sMethod);}%></td>
</tr>
<!--<tr><td>採購件下階展開</td><td colspan="5"><%//=type%></td></tr>-->
<tr><td >Total Record(s)</td><td colspan="5"><%=r%></td></tr>
</table>
<table border="1">
<input name="PRT" type="hidden" value="<%=prt%>">
<tr>
	<td>Level</td>
	<td>Type</td>
	<td>Item</td>
	<td>Desc</td>
	<td>Req</td>
	<td>Qty</td>
	<td>U/M</td>
	<td>Seq</td>
	<td>ECN#</td>
	<td>LOC#</td>
	<td>VEND1</td>
	<td>DWGID1</td>
	<td>VEND2</td>
	<td>DWGID2</td>
	<td>VEND3</td>
	<td>DWGID3</td>
	<td>VEND4</td>
	<td>DWGID4</td>
	<td>VEND5</td>
	<td>DWGID5</td>
	<td>VEND6</td>
	<td>DWGID6</td>
</tr>

<%
		int n = 0;
		bpcsBomBean.setNext(n);
		for (int j=0;j<r;j++) {
%>
<tr>
	<!--<td nowrap><font face="sans-serif" size="-1"><%//=n%></font></td>-->
	<!--<td nowrap><font face="sans-serif" size="-1"><%//if (bpcsBomBean.getLevelCode()==null) { out.println("&nbsp;");} else {out.println(bpcsBomBean.getLevelCode());}%></font></td>-->
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getLevelString()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getLevelString());}%></font></td>
	<!--<td><font face="sans-serif" size="-1"><%// if (bpcsBomBean.getOrder()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getOrder());}%></font></td>-->
	<!--<td><font face="sans-serif" size="-1"><%// if (bpcsBomBean.getPtype()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getPtype());}%></font></td>-->
	<!--<td><font face="sans-serif" size="-1"><%// if (bpcsBomBean.getParent()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getParent());}%></font></td>-->
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getCtype()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getCtype());}%></font></td>
	<td nowrap><font face="sans-serif" size="-1"><% if (bpcsBomBean.getChild()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getChild());}%></font></td>
	<td nowrap><font face="sans-serif" size="-1"><% if (bpcsBomBean.getDesc()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getDesc());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getReq()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getReq());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getQty()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getQty());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getUM()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getUM());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getSeq()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getSeq());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getECN()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getECN());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getLoc()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getLoc());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getVendApp1()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getVendApp1());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getApp1()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getApp1());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getVendApp2()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getVendApp2());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getApp2()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getApp2());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getVendApp3()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getVendApp3());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getApp3()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getApp3());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getVendApp4()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getVendApp4());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getApp4()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getApp4());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getVendApp5()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getVendApp5());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getApp5()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getApp5());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getVendApp6()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getVendApp6());}%></font></td>
	<td><font face="sans-serif" size="-1"><% if (bpcsBomBean.getApp6()=="") {out.println("&nbsp;");} else {out.println(bpcsBomBean.getApp6());}%></font></td>
</tr>

<%
			n = bpcsBomBean.getNext();
		} // end for
	} // end if-else

} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><!-- WINS --><%
	%><%//@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 --><%
//*
	if (sProd==null || sProd.equals("") || sComp==null || sComp.equals("")) {
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
</form>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%//@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><!-- 大霸電子 -->
<%//@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%><!-- 大霸控股 -->
<%//@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%><!-- 迪比特 -->
<%
///*
	if (sProd==null || sProd.equals("") || sComp==null || sComp.equals("")) {
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
