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
<title>轉倉及料號移轉申請審核</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	document.MYFORM.btnSubmit.disabled=true;
	document.MYFORM.btnReject.disabled=true;
	document.MYFORM.btnExit.disabled=true;

	document.MYFORM.action=URL+"&HID="+document.MYFORM.HID.value;
	document.MYFORM.submit();
}
function setSubmit1(URL)
{   
	document.MYFORM.btnSubmit.disabled=true;
	document.MYFORM.btnReject.disabled=true;
	document.MYFORM.btnExit.disabled=true;
	
	if (document.MYFORM.REMARKS.value =="")
	{
		document.MYFORM.btnSubmit.disabled=false;
		document.MYFORM.btnReject.disabled=false;
		document.MYFORM.btnExit.disabled=false;
		alert("備註欄位請填入Reject原因!");
		document.MYFORM.REMARKS.focus();
		return false;
	}
	document.MYFORM.action=URL+"&HID="+document.MYFORM.HID.value;
	document.MYFORM.submit();
}
function setSubmit2(URL)
{   
	document.MYFORM.btnSubmit.disabled=true;
	document.MYFORM.btnReject.disabled=true;
	document.MYFORM.btnExit.disabled=true;
	if (confirm("您確定要離開回到首頁嗎?")==true) 
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	else
	{
		document.MYFORM.btnSubmit.disabled=false;
		document.MYFORM.btnReject.disabled=false;
		document.MYFORM.btnExit.disabled=false;
	}
}
function chgFrame(url,hid)
{
	var o=document.getElementById("iframe");
	o.src=url;
}
</script>
</head>
<body>
<%
int iseq=0,icnt=0;
String HID=request.getParameter("HID");
if (HID==null) HID="";
String WKCODE=request.getParameter("WKCODE");
if (WKCODE==null) WKCODE="";
if (UserRoles.indexOf("admin")>=0) WKCODE="M";
String strWorkflowCode="",opt_type="";
String sql="",straddr="";


/*sql = " select distinct a.wkflow_level "+
      " from oraddman.tsc_stock_trans_wkflow a"+
	  " ,oraddman.tsc_stock_trans_member b"+
      " where a.wkflow_level_rank not in (?,?)"+
      " and a.wkflow_level=b.wkflow_level"+
      " and nvl(a.active_flag,'N')=?"+
      " and nvl(b.active_flag,'N')=?"+
      " and substr(b.WKFLOW_LEVEL,1,length(?))=?"+
      " and b.user_name=?";
PreparedStatement statement = con.prepareStatement(sql);
statement.setString(1,"0");
statement.setString(2,"99");
statement.setString(3,"A");
statement.setString(4,"A");
statement.setString(5,WKCODE);
statement.setString(6,WKCODE);
statement.setString(7,UserName);
ResultSet rs=statement.executeQuery();	
if (!rs.next())
{
	rs.close();
	statement.close();
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("您尚未設定主管審核權限,請向資訊單位提出申請後再作業,謝謝!");
		location.href="/oradds/ORADDSMainMenu.jsp";
	</script>
<%	
}
rs.close();
statement.close();*/

%>
<form name="MYFORM"  METHOD="post" ACTION="TSCStockTransConfirm.jsp">
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td width="9%"  bgcolor="#E9E8E7">&nbsp;</td>
		<td align="right" bgcolor="#E9E8E7"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
	<tr style="background-color:#EBEFF3">
		<td  rowspan="2" valign="top" style="text-align:center">

				
<%
	sql = " select a.req_header_id"+
		  " ,a.req_no"+
		  " ,a.trans_type"+
		  " ,a.wkflow_level"+
		  " ,b.trans_name"+
		  " ,b.trans_desc"+
		  " ,c.wkflow_next_level"+
		  " from oraddman.tsc_stock_trans_headers a"+
		  " ,oraddman.tsc_stock_trans_type b"+
		  " ,oraddman.tsc_stock_trans_wkflow c"+
		  " ,oraddman.tsc_stock_trans_member d"+
		  " where a.trans_type=b.trans_type"+
		  " and a.status_code in (?,?)"+
		  " and a.trans_type=c.trans_type"+
		  " and a.wkflow_level=c.wkflow_level"+
		  " and a.trans_type=d.trans_type"+
		  " and c.wkflow_next_level=d.wkflow_level"+
		  " and nvl(b.active_flag,'N')=?"+
		  " and nvl(c.active_flag,'N')=?"+
		  " and nvl(d.active_flag,'N')=?"+
		  " and substr(d.WKFLOW_LEVEL,1,length(?))=?"+
		  //" and a.req_header_id=?"+
		  " and d.user_name=?";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"AWAITING_APPROVE");
	statement.setString(2,"CONFIRMED");
	statement.setString(3,"A");
	statement.setString(4,"A");
	statement.setString(5,"A");
	statement.setString(6,WKCODE);
	statement.setString(7,WKCODE);
	statement.setString(8,UserName);
	icnt=0;
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{
		
		strWorkflowCode = rs.getString("wkflow_next_level");
		opt_type = rs.getString("trans_name");
		icnt++;
		if (icnt==1)
		{
		%>
			<div id="id_<%=icnt%>" style="text-decoration:underline;font-weight:bold;font-size:16px;font-family:'細明體'">待審核申請單</div>
		<%
			straddr= "../jsp/TSCStockTransConfirmDetail.jsp?HID="+rs.getString("REQ_HEADER_ID")+"&WKCODE="+WKCODE;
			HID=rs.getString("req_header_id");
		}
		%>
		
			<div id="div<%=icnt%>" style="font-size:14px" onMouseOver="this.style.color='#ffffff';this.style.backgroundColor='#D5ECB0';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#EBEFF3',style.color='#000000';this.style.fontWeight='normal'"><img src="images/aw_blue.gif"><a href='javascript:chgFrame("../jsp/TSCStockTransConfirmDetail.jsp?HID=<%=rs.getString("REQ_HEADER_ID")%>&WKCODE=<%=WKCODE%>",<%=rs.getString("REQ_HEADER_ID")%>)'><%=rs.getString("req_no")%></a></div>
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
		//out.println("<font style='font-weight:bold;font-size:16px;font-family:細明體'>無待審核資料</font>");
	}
	%>
		</td>
		<td>
			<!--<iframe src="<%=straddr%>" id="iframe" width="100%" height="100%"></iframe>-->
			<iframe src="<%=straddr%>" id="iframe" style="width:1100px;height:440px;margin:5px;display:block"></iframe>
			
		</td>
	</tr>
	<%
	if (icnt>0)
	{
	%>
	<tr  style="background-color:#EBEFF3">
		<td align="center">
			<table>
				<tr>
					<td align="center">備註</td>
					<td><textarea cols="180" rows="4" name="REMARKS" style="font-size:11px;font-family:Tahoma,Georgia"></textarea></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td align="center" colspan="2"><input type="button" name="btnSubmit" value="Submit" style="font-family:Tahoma,Georgia" onClick="setSubmit('../jsp/TSCStockTransProcess.jsp?STATUS_CODE=CONFIRMED')">
		&nbsp;&nbsp;
		<input type="button" name="btnReject" value="Reject" style="font-family:Tahoma,Georgia" onClick="setSubmit1('../jsp/TSCStockTransProcess.jsp?STATUS_CODE=REJECTED')">
		&nbsp;&nbsp;		
		<input type="button" name="btnExit" value="Exit" style="font-family:Tahoma,Georgia"  onClick="setSubmit2('../ORADDSMainMenu.jsp')">
		</td>
	</tr>
	<%
	}
	%>
</table>
<input type="hidden" name="WORKFLOWCODE" value="<%=strWorkflowCode%>">
<input type="hidden" name="HID" value="<%=HID%>">
<input type="hidden" name="WKCODE" value="<%=WKCODE%>">
</form>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>
