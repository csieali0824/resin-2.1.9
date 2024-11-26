<%@ page contentType="text/html; charset=utf-8"  language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean,SalesDRQPageHeaderBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
 <!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
</STYLE>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<title>A01 OEM 審核</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	document.MYFORM1.btnSubmit.disabled=true;
	document.MYFORM1.btnReject.disabled=true;
	document.MYFORM1.btnExit.disabled=true;

	document.MYFORM1.action=URL+"&REQNO="+document.MYFORM1.REQNO.value;
	document.MYFORM1.submit();
}
function setSubmit1(URL)
{   
	document.MYFORM1.btnSubmit.disabled=true;
	document.MYFORM1.btnReject.disabled=true;
	document.MYFORM1.btnExit.disabled=true;
	
	if (document.MYFORM1.REMARKS.value =="")
	{
		document.MYFORM1.btnSubmit.disabled=false;
		document.MYFORM1.btnReject.disabled=false;
		document.MYFORM1.btnExit.disabled=false;
		alert("備註欄位請填入Reject原因!");
		document.MYFORM1.REMARKS.focus();
		return false;
	}
	document.MYFORM1.action=URL+"&REQNO="+document.MYFORM1.REQNO.value;
	document.MYFORM1.submit();
}
function setSubmit2(URL)
{   
	document.MYFORM1.btnSubmit.disabled=true;
	document.MYFORM1.btnReject.disabled=true;
	document.MYFORM1.btnExit.disabled=true;
	if (confirm("您確定要離開回到首頁嗎?")==true) 
	{
		document.MYFORM1.action=URL;
		document.MYFORM1.submit();
	}
	else
	{
		document.MYFORM1.btnSubmit.disabled=false;
		document.MYFORM1.btnReject.disabled=false;
		document.MYFORM1.btnExit.disabled=false;
	}
}
function chgFrame(url,hid)
{
	var o=document.getElementById("iframe1");
	document.MYFORM1.REQNO.value=hid;
	o.src=url;
}
</script>
</head>
<body>
<%
int iseq=0,icnt=0;
String REQNO=request.getParameter("REQNO");
if (REQNO==null) REQNO="";
String sql="",straddr="";
%>
<form name="MYFORM1"  METHOD="post" ACTION="TSA01OEMConfirm.jsp">
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td width="9%"  bgcolor="#E9E8E7">&nbsp;</td>
		<td align="right" bgcolor="#E9E8E7"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
	<tr style="background-color:#EBEFF3">
		<td rowspan="2" valign="top" style="text-align:center">

				
<%
	sql = " select a.request_no, a.version_id,a.request_no||'-'||a.version_id reqno"+
		  " from oraddman.tsa01_oem_headers_all a"+
		  " where a.status=? order by a.request_no";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"Submit");
	icnt=0;
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{
		icnt++;
		if (icnt==1)
		{
		%>
			<div id="id_<%=icnt%>" style="text-decoration:underline;font-weight:bold;font-size:16px;font-family:'細明體'">待審核申請單</div>
		<%
			straddr= "../jsp/TSA01OEMConfirmDetail.jsp?REQNO="+rs.getString("REQNO");
			REQNO=rs.getString("REQNO");
		}
		%>
		
			<div id="div<%=icnt%>" style="font-size:14px" onMouseOver="this.style.color='#ffffff';this.style.backgroundColor='#D5ECB0';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#EBEFF3',style.color='#000000';this.style.fontWeight='normal'"><img src="images/aw_blue.gif"><a href='javascript:chgFrame("../jsp/TSA01OEMConfirmDetail.jsp?REQNO=<%=rs.getString("REQNO")%>","<%=rs.getString("REQNO")%>")'><%=rs.getString("REQNO")%></a></div>
	<%
	}
	rs.close();
	statement.close();
	
	if (icnt==0)
	{
	%>
	<script language="JavaScript" type="text/JavaScript">
		alert("已無待審核資料,系統將轉回首頁!");
		location.href="/oradds/ORADDSMainMenu.jsp";
	</script>	
	<%
	}
	%>
		</td>
		<td>
			<iframe src="<%=straddr%>" id="iframe1" style="width:1100px;height:440px;margin:5px;display:block"></iframe>
		</td>
	</tr>
	<%
	if (icnt>0)
	{
	%>
	<tr style="background-color:#EBEFF3">
		<td align="center">
			<table width="100%">
				<tr>
					<td align="center">備註</td>
					<td><textarea cols="160" rows="4" name="REMARKS" style="font-size:11px;font-family:Tahoma,Georgia"></textarea></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr style="background-color:#EBEFF3">
		<td align="center" colspan="2"><input type="button" name="btnSubmit" value="Submit" style="font-family:Tahoma,Georgia" onClick="setSubmit('../jsp/TSA01OEMProcess.jsp?STATUS=Approved')">
		&nbsp;&nbsp;
		<input type="button" name="btnReject" value="Reject" style="font-family:Tahoma,Georgia" onClick="setSubmit1('../jsp/TSA01OEMProcess.jsp?STATUS=Reject')">
		&nbsp;&nbsp;		
		<input type="button" name="btnExit" value="Exit" style="font-family:Tahoma,Georgia"  onClick="setSubmit2('../ORADDSMainMenu.jsp')">
		</td>
	</tr>
	<%
	}
	%>
</table>
<input type="hidden" name="REQNO" value="<%=REQNO%>">	
<input type="hidden" name="TRANSCODE" value="Confirm">	
</form>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>
