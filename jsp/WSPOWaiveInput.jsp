<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,ComboBoxBean,ArrayComboBoxBean,ArrayListCheckBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<!--=============To get the Authentication==========-->
<% // @ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>PO Waive核准單輸入</title>
</head>

<body>

<%
	String UserName = "楊沛嵐";
%>
<FORM ACTION="WSPOWaiveInput.jsp" METHOD="post" NAME="MYFORM">
<div align="center"><font color="#000000" size="+2" face="Arial"><strong>P/O Waive  申請核准單輸入</strong></font></div>
<font color="#000000" size="1" face="Arial">必備條件 : 請檢附該零件之技術圖面或規格書， 以利 P/O Waive 申請核准.</font>
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black">A)</font></td>
		<td><font color="#333399" font size="1" face="Arial Black">申請單位<input name="APPDEPT" type="text" value="採購" size="10"></font></td>
		<td><font color="#333399" font size="1" face="Arial Black">申請人<input name="APPNAME" type="text" value="<%=UserName%>" size="10"></font></td>
		<% String sTW_YYMMDD = dateBean.getYearMonthDay(); sTW_YYMMDD = sTW_YYMMDD.substring(0,4)+"."+sTW_YYMMDD.substring(4,6)+"."+sTW_YYMMDD.substring(6,8);%>
		<td><font color="#333399" font size="1" face="Arial Black">申請日期<input name="APPDATE" type="text" value="<%=sTW_YYMMDD%>"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td><font color="#333399" font size="1" face="Arial Black">1)DBTEL P/N ：<input name="ITEMNO" type="text"></font></td>
		<td colspan="2"><font color="#333399" font size="1" face="Arial Black">2)Model Name : <input name="MODELNO" type="text"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black">3) Part Description : <input name="ITEMDESC" type="text"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td><font color="#333399" font size="1" face="Arial Black">4) Part Spec : <input name="SPECOK" type="checkbox">有  <input name="SPECNG" type="checkbox">無</font></td>
		<td><font color="#333399" font size="1" face="Arial Black">, 原因<input name="SPECREASON" type="text" size="40"></font></td>
		<td><font color="#333399" font size="1" face="Arial Black">RD必需提出(強制性要求)</font></td>
	</tr>
	<tr>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td><font color="#333399" font size="1" face="Arial Black"><input name="EX" type="checkbox">電子件 : 規格書</font></td>
	</tr>
	<tr>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black"> </font></td>	
		<td><font color="#333399" font size="1" face="Arial Black"><input name="EL" type="checkbox">機電件 : 規格書</font></td>
	</tr>
	<tr>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black"> </font></td>	
		<td><font color="#333399" font size="1" face="Arial Black"><input name="MK" type="checkbox">機構件 : 圖面、尺寸</font></td>
	</tr>
	<tr>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black"> </font></td>	
		<td><font color="#333399" font size="1" face="Arial Black"><input name="PK" type="checkbox">包材類 : 圖面、尺寸</font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>	
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black">5)Part Version : <input name="VER" type="text"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>	
		<td><font color="#333399" font size="1" face="Arial Black">6)Supplier Name : <input name="VENDORNO" type="text"></font></td>
		<td><font color="#333399" font size="1" face="Arial Black"><input name="VENDORNAME" type="text"></font></td>
		<td><font color="#333399" font size="1" face="Arial Black">7)Supplier P/N : <input name="VENDORITEMNO" type="text"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>	
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black">8)Required Delivery Date : <input name="REQDATE" type="text"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>	
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black">9)Required Quantity : <input name="REQQTY" type="text"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>	
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black">10)Lead Time : <input name="LEADTIME" type="text"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td colspan="7"><font color="#333399" font size="1" face="Arial Black">11)Part to be used in (check one)</font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black"><input name="C1" type="checkbox">Capacity Reservation</font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td><font color="#333399" font size="1" face="Arial Black"><input name="C2" type="checkbox">Non-Qualified</font></td>
		<td colspan="2"><font color="#333399" font size="1" face="Arial Black">11-1)預計送樣(日期)<input name="SAMPLEDATE" type="text"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td><font color="#333399" font size="1" face="Arial Black"><input name="C3" type="checkbox">Prototype</font></td>
		<td colspan="2"><font color="#333399" font size="1" face="Arial Black">11-2)Proto-run<input name="PROTORUN" type="text"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black"><input name="C4" type="checkbox">Tooling</font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black"><input name="C5" type="checkbox">Others</font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td><font color="#333399" font size="1" face="Arial Black">12)RD測試結果 : <input name="R1" type="checkbox">Pass <input name="R2" type="checkbox">Fail (Test Report : </font></td>
		<td colspan="2"><font color="#333399" font size="1" face="Arial Black"><input name="T1" type="checkbox">有 <input name="T2" type="checkbox">無，原因<input name="RPTREASON" type="text">)</font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black">B)</font></td>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black">Quantity Granted  (RD填寫)</font></td>
	</tr>
	<tr>
		<td colspan="2"><font color="#333399" font size="1" face="Arial Black">1)</font></td>
		<td colspan="2"><font color="#333399" font size="1" face="Arial Black">2)風險評估</font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td><font color="#333399" font size="1" face="Arial Black"><input name="Q1" type="checkbox">1.規格已定，無品質問題者，Waive數量依採購需求</font></td>
		<td colspan="2"><font color="#333399" font size="1" face="Arial Black"> <input name="RHIG" type="checkbox"><input name="RMOD" type="checkbox"><input name="RLOW" type="checkbox"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td><font color="#333399" font size="1" face="Arial Black">(只能申請一次)</font></td>
		<td colspan="2"><font color="#333399" font size="1" face="Arial Black">3)If High</font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td><font color="#333399" font size="1" face="Arial Black"><input name="Q2" type="checkbox">2.有品質問題之零件，數量不得超出2K。</font></td>
		<td colspan="2"><font color="#333399" font size="1" face="Arial Black"><input name="HIGHREASON" type="text"></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black"><input name="Q3" type="checkbox">3.規格未確定者，數量不得超出1K。</font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="1" face="Arial Black"> </font></td>
		<td colspan="3"><font color="#333399" font size="1" face="Arial Black">有效日期 : <input name="VALIDDATE" type="text"></font></td>
	</tr>


</table>
</form>

</body>
</html>

<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
