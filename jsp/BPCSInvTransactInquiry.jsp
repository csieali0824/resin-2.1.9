<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,ComboBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<script>
function submitCheck() {
	if (document.MYFORM.PARTNUMBER.value=="" || document.MYFORM.TDATEFR.value=="" || document.MYFORM.TDATETO.value=="") {
		alert ("請輸入料號及日期");
		return false;
	}
	document.MYFORM.action="BPCSInvTransactInquiry.jsp?SEL=1";
	document.MYFORM.submit();

} // end function
</script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Inventory Transaction Inquiry</title>
</head>
<body>
<%
String sWarehouse=request.getParameter("WAREHOUSE"); //out.println(sWarehouse);
String sLoc=request.getParameter("LOC"); //out.println(sLoc);
if (sLoc==null) { sLoc=""; }
String sPartNumber=request.getParameter("PARTNUMBER"); //out.println(sPartNumber);
if (sPartNumber==null) { sPartNumber=""; }
String sType=request.getParameter("TTYPE"); //out.println(sType);
if (sType==null) { sType=""; }
String sDateFr=request.getParameter("TDATEFR"); //out.println(sDateFr);
if (sDateFr==null) { sDateFr=dateBean.getYearString()+dateBean.getMonthString()+"01"; }
String sDateTo=request.getParameter("TDATETO"); //out.println(sDateTo);
if (sDateTo==null) { sDateTo=dateBean.getYearMonthDay(); }
String sel=request.getParameter("SEL"); //out.println(sel);

%>
<form name="MYFORM" action="" method="post">
<font color="#009999" face="Times New Roman" size="+3"><strong>大霸電子庫存異動查詢</strong></font>
<font color="#000000" face="Times New Roman" size="+2"><strong>Inventory Transaction Inquiry</strong></font>
<br><A HREF="../WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="./BPCSInvBalInquiry.jsp">大霸電子庫存餘額查詢</A>
<table border="1">
<tr>
	<td>
	<font face="Arial" color="#000000" size="+1"><strong>倉別:</strong></font>
	<font face="Arial" color="#000000" size="+1">
	<%
	try {		
		String sql = "SELECT lwhs,lwhs ||'--'|| ldesc AS ldesc FROM iwm"
		+" WHERE lid='WM' "
		+" AND ((lwhs>='00' AND lwhs<='02') OR (lwhs>='22' AND lwhs<='22') OR (lwhs>='31' AND lwhs<='33') "
		+"   OR (lwhs>='50' AND lwhs<='59') OR (lwhs>='70' AND lwhs<='87') "
		+"   OR (lwhs>='K1' AND lwhs<='K9') OR (lwhs>='T1' AND lwhs<='T9') OR lwhs='P1') "
		+"ORDER BY lwhs ";
		Statement st=bpcscon.createStatement();
		ResultSet rs = st.executeQuery(sql);
		comboBoxBean.setRs(rs);   
		comboBoxBean.setSelection(sWarehouse);
	    comboBoxBean.setFieldName("WAREHOUSE");
	    out.println(comboBoxBean.getRsString());
	} catch (Exception e){out.println("Exception:"+e.getMessage());	
	}//end try
	%>
	</font>
	</td>
	<td>
	<font face="Arial" color="#000000" size="+1"><strong>儲位:</strong></font>
	<input type="TEXT" NAME='LOC' SIZE=20 value='<%=sLoc%>'>
	</td>
	<td colspan="2">
	<font face="Arial" color="#000000" size="+1"><strong>料號:</strong></font>
	<input type="TEXT" NAME='PARTNUMBER' SIZE=20 value='<%=sPartNumber%>'>
	</td>
	</tr>
	<tr>
	<td>
	<font face="Arial" color="#000000" size="+1"><strong>異動類型:</strong></font>
	<input type="TEXT" NAME='TTYPE' SIZE=20 value='<%=sType%>'>
	</td>
	<td>
	<font face="Arial" color="#000000" size="+1"><strong>異動日期起:</strong></font>
	<input type="TEXT" NAME='TDATEFR' SIZE=20 value='<%=sDateFr%>'>
	</td>
	<td>
	<font face="Arial" color="#000000" size="+1"><strong>異動日期迄:</strong></font>
	<input type="TEXT" NAME='TDATETO' SIZE=20 value='<%=sDateTo%>'>
	</td>
	<td>
	<input type="button" name="Query"  value="QUERY" onClick="return submitCheck()">
	</td>
</tr>
</table>
<table border="1">
<tr>
	<td><font face="Arial" color="#000000" size="1"><strong>倉別</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>儲位</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>料號</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>料號說明</strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong>單位</strong></font></td>
	<td align="right"><font face="Arial" color="#000000" size="1"><strong>異動類型</strong></font></td>
	<td align="right"><font face="Arial" color="#000000" size="1"><strong>異動數量</strong></font></td>
	<td align="right"><font face="Arial" color="#000000" size="1"><strong>異動日期</strong></font></td>
	<td align="right"><font face="Arial" color="#000000" size="1"><strong>異動單號</strong></font></td>
	<td align="right"><font face="Arial" color="#000000" size="1"><strong>單號(CO/PO/SO)</strong></font></td>
	<td align="right"><font face="Arial" color="#000000" size="1"><strong>備註</strong></font></td>
	<td align="right"><font face="Arial" color="#000000" size="1"><strong>帳號</strong></font></td>
</tr>
<%
try {
	String sql="SELECT twhs,tloct,tprod,idesc||idsce AS desc,iums,ttype,tqty,ttdte,tcom,tref,thadvn,thuser"
	+" FROM ith,iim "
	+" WHERE tprod=iprod AND tid='TH' ";
	if (sPartNumber!=null && !sPartNumber.equals("") ) {
		sql= sql + " and tprod='"+sPartNumber+"' ";
	}
	if ( sWarehouse!=null && !sWarehouse.equals("--") ) {
		sql = sql + " and twhs='"+sWarehouse+"'";
	} // end if
	if ( sLoc!=null && !sLoc.equals("") ) {
		sql = sql + " and tloct='"+sLoc+"'";
	} // end if
	if ( sType!=null && !sType.equals("") ) {
		sql = sql + " and ttype='"+sType+"'";
	} // end if
	if ( sDateFr!=null && !sDateFr.equals("") ) {
		sql = sql + " and ttdte>="+sDateFr;
	} // end if
	if ( sDateTo!=null && !sDateTo.equals("") ) {
		sql = sql + " and ttdte<="+sDateTo;
	} // end if
	sql = sql+" ORDER BY tprod,twhs,tloct"; //out.println(sql);
	if (sel!=null) {
		Statement st=bpcscon.createStatement();
		ResultSet rs = st.executeQuery(sql);
		boolean eof = !rs.next();
		if (eof) { out.println("<tr><td colspan='7'>Record(s) Not Found!</td></tr>");
		} else {
			while (!eof) {
%>
	<tr>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("twhs")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%if(rs.getString("tloct").trim()=="") {out.println("&nbsp;");} else {out.println(rs.getString("tloct"));}%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("tprod")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("desc")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("iums")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("ttype")%></strong></font></td>
	<td align="right"><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("tqty")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("ttdte")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("tcom")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("tref")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("thadvn")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("thuser")%></strong></font></td>
	</tr>
<%
				eof = !rs.next();
			} // end while
		} // end if
		rs.close();
		st.close();
	} // end if
} catch (Exception ec){
	out.println("Exception:"+ec.getMessage());	
	%>
	<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
	<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
	<%
}// end try-catch
%>
</table>
</form>
</body>
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
