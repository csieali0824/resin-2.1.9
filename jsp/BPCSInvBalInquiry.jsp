<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,ComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<script>
function submitCheck() {
	if (document.MYFORM.WAREHOUSE.value=="--" && document.MYFORM.PARTNUMBER.value=="") {
		alert ("料號或倉別請擇一輸入");
		return false;
	}
	document.MYFORM.action="BPCSInvBalInquiry.jsp?SEL=1";
	document.MYFORM.submit();

} // end function
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Inventory Inquiry</title>
</head>
<body>
<%
String sWarehouse=request.getParameter("WAREHOUSE"); //out.println(sWarehouse);
String sPartNumber=request.getParameter("PARTNUMBER"); //out.println(sPartNumber);
String sel=request.getParameter("SEL"); //out.println(sel);
if (sPartNumber==null || sPartNumber.equals("") ) {
  sPartNumber="";
}
int qty=0;  
String bgColor="#FFFFFF";

Statement st=bpcscon.createStatement();
ResultSet rs=null;
%>
<form ACTION="BPCSInvBalInquiry.jsp" METHOD="post" NAME="MYFORM">
<font color="#009999" face="Times New Roman" size="+3"><strong>大霸電子庫存餘額查詢</strong></font>
<font color="#000000" face="Times New Roman" size="+2"><strong>Inventory Inquiry</strong></font>
<br>
<A HREF="../WinsMainMenu.jsp">HOME</A>
<table width="500" border="1">
<tr>
<td><font face="Arial" color="#000000" size="+1"><strong>倉別:</strong></font><font face="Arial" color="#000000" size="+1"><strong>
<%
	try {		
		String sql = "SELECT lwhs,lwhs ||'--'|| ldesc AS ldesc FROM iwm"
		+" WHERE lid='WM' "
		+" AND ((lwhs>='00' AND lwhs<='02') OR (lwhs>='22' AND lwhs<='22') OR (lwhs>='31' AND lwhs<='33') "
		+"   OR (lwhs>='50' AND lwhs<='59') OR (lwhs>='70' AND lwhs<='87') "
		+"   OR (lwhs>='K1' AND lwhs<='K9') OR (lwhs>='T1' AND lwhs<='T9') OR lwhs='P1') "
		+"ORDER BY lwhs ";
		rs = st.executeQuery(sql);
		comboBoxBean.setRs(rs);   
		comboBoxBean.setSelection(sWarehouse);
	    comboBoxBean.setFieldName("WAREHOUSE");
	    out.println(comboBoxBean.getRsString());
	} //end try
	catch (Exception e){out.println("Exception:"+e.getMessage());	}
%>
	</strong></font></td>
<td bgcolor="#FFFFFF"><font face="Arial" color="#000000" size="+1"><strong>料號:</strong></font>
     <input type="TEXT" NAME='PARTNUMBER' SIZE=20 value='<%=sPartNumber%>'></td>
<td width="20%"><font face="Arial" color="#000000" size="+1"><strong>
	<input type="button" name="Query"  value="QUERY" onClick="return submitCheck()">
	</strong></font>
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
	<td align="right"><font face="Arial" color="#000000" size="1"><strong>庫存餘額</strong></font></td>
</tr>

<%
try {
	String sql="SELECT lwhs,lloc||'--'||wdesc AS lloc,lprod,idesc||idsce as desc,iums,lopb+lrct-lissu+ladju as inv "
	+" FROM ILI,IIM,ilm "
	+" WHERE lid='LI' and lprod=iprod and lwhs=wwhs and lloc=wloc and (lopb+lrct-lissu+ladju)!=0 "
	+" AND ((lwhs>='00' AND lwhs<='02') OR (lwhs>='22' AND lwhs<='22') OR (lwhs>='31' AND lwhs<='33') "
	+"   OR (lwhs>='50' AND lwhs<='59') OR (lwhs>='70' AND lwhs<='87') "
	+"   OR (lwhs>='K1' AND lwhs<='K9') OR (lwhs>='T1' AND lwhs<='T9') OR lwhs='P1') ";
	if (sPartNumber!=null && !sPartNumber.equals("") ) {
		sql= sql + " and lprod like '"+sPartNumber+"%' ";
	}
	if ( sWarehouse!=null && !sWarehouse.equals("--") ) {
		sql = sql + " and lwhs='"+sWarehouse+"'";
	} // end if
	sql = sql+" ORDER BY lwhs,lloc,lprod"; //out.println(sql);
	if (sel!=null) {
		rs = st.executeQuery(sql);
		boolean eof = !rs.next();
		if (eof) { out.println("<tr><td colspan='6'>Record(s) Not Found!</td></tr>");
		} else {
			while (!eof) {
				qty=rs.getInt("inv");  
				if (qty>0) {
					bgColor="#CCCCFF";
				} else {
					bgColor="#FFFFFF";
				}
%>
	<tr bgcolor="<%=bgColor%>">
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("lwhs")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("lloc")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("lprod")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("desc")%></strong></font></td>
	<td><font face="Arial" color="#000000" size="1"><strong><%=rs.getString("iums")%></strong></font></td>
	<td align="right"><font face="Arial" color="#000000" size="1"><strong><%=rs.getInt("inv")%></strong></font></td>
	</tr>
<%
				eof = !rs.next();
			} // end while
		} //end if eof
		rs.close();
	} // end if
} catch (Exception ec){
  out.println("Exception:"+ec.getMessage());	
  %>
  <%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
  <%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
  <%
}// end try-catch
st.close();
%>
</table>
</form>

</body>
</html>

<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>