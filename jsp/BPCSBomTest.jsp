<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="BpcsBomBean" %>
<jsp:useBean id="bpcsBomBean" scope="session" class="BpcsBomBean"/>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
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
	if (sType.equals("0")) { type="是"; } else { type="否"; }
	//out.println("<br>"+" Company="+name+" Fac="+sFac+" Item="+sProd+" Method="+sMethod+" 採購件下階展開="+type);
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><!-- WINS --><%

	if (sProd==null || sProd.equals("") || sComp==null || sComp.equals("")) {
	} else {
		sql = "CREATE TEMP TABLE tmpbom010(bprod char(15) not null,level1 int  not null,levelseq1  int  not null"
		+",level2 int not null,levelseq2 int not null,level3 int not null,levelseq3 int not null,level4 int not null"
		+",levelseq4  int  not null,level5  int  not null,levelseq5  int  not null,level6  int  not null,levelseq6  int  not null,"+
		"level7  int  not null,levelseq7  int  not null,level8  int  not null,levelseq8  int  not null,level9  int  not null,"+
		"levelseq9  int  not null,level10 int  not null,levelseq10 int  not null,bmwhs  char(2) not null,bmbomm  char(2) not null,"+
		"bseq int,bchld  char(15) not null,itype  char(1),itype1 char(1),itype2  char(1),loc char(50),idesc char(60),"+
		"bqreq  decimal(15,6),qty  decimal(15,6),iums  char(2),ecn  char(10),apr1 char(30),apr2 char(30),apr3 char(30),"+
		"apr4  char(30),apr5  char(30),apr6 char(30),ven1 char(10),ven2  char(10),ven3  char(10),ven4  char(10),ven5  char(10),ven6  char(10),new char(3),serialcolumn serial not null)";
		ps = conn.prepareStatement(sql);
		ps.executeUpdate();
		ps.close();
		
		sql = "INSERT INTO tmpbom010 (bprod,level1, levelseq1, level2, levelseq2,level3, levelseq3, level4, levelseq4,"+
		"level5, levelseq5, level6, levelseq6,level7, levelseq7, level8, levelseq8,level9, levelseq9, level10, levelseq10,"+
		"bmwhs, bmbomm, bseq, bchld,bqreq, qty, serialcolumn) "+
		"VALUES (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','',0,'"+sProd+"',1,1,0)";
		ps = conn.prepareStatement(sql);
		ps.executeUpdate();
		ps.close();
		
		CallableStatement cs = conn.prepareCall("{call pbom010}");
		boolean b = cs.execute();
		cs.close();

%>
<form name="MYFORM">
<table border="1">
<tr><td>Company</td><td colspan="5"><%=name%></td></tr>
<tr>
	<td>Fac</td><td><%if (sFac==null || sFac.equals("")) {out.println("&nbsp;");} else {out.println(sFac);}%></td>
	<td>Item</td><td><%=sProd%></td>
	<td>Method</td><td><%if (sMethod==null || sMethod.equals("")) {out.println("&nbsp;");} else {out.println(sMethod);}%></td>
</tr>
<tr><td>採購件下階展開</td><td colspan="5"><%=type%></td></tr>
<tr><td >Total Record(s)</td><td colspan="5"><%//=r%></td></tr>
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
		sql = "SELECT level1,levelseq1,level2,levelseq2,level3,levelseq3,"
   		+" level4,levelseq4,level5,levelseq5,level6,levelseq6,level7,levelseq7,"
   		+" level8,levelseq8,level9,levelseq9,level10,levelseq10,"
   		+" itype,itype1,bChld,bseq,idesc,bqreq,qty,iums,"
   		+" ecn,loc,apr1,apr2,apr3,apr4,apr5,apr6,"
   		+" ven1,ven2,ven3,ven4,ven5,ven6,new"
   		+" FROM tmpbom010"
		+" ORDER BY level1,levelseq1,level2,levelseq2,level3,levelseq3,level4,levelseq4,"
    	+" level5,levelseq5,level6,levelseq6,level7,levelseq7,level8,levelseq8,"
    	+" level9,levelseq9,level10,levelseq10";
		ps = conn.prepareStatement(sql);
		rs = ps.executeQuery();
		while (rs.next()) {
%>
<tr>
	<td nowrap><font face="sans-serif" size="-1"><% if (rs.getString("bChld")=="") {out.println("&nbsp;");} else {out.println(rs.getString("bChld"));}%></font></td>
</tr>

<%
		} // end for
		rs.close();
		ps.close();
		sql = "DROP TABLE tmpbom010 ";
		ps = conn.prepareStatement(sql);
		ps.executeUpdate();
		ps.close();

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
