<!-- 20151022 by Peggy,add date column,EFFECTIVE_DATE,LAST_ORDER_DATE,LAST_DELIVERY_DATE,INTENDED_START_OF_DELIVERY-->
<%@ page contentType="text/html; charset=utf-8" import="java.sql.*,jxl.*,java.util.*"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function setModify(URL)
{
	if (document.SITEFORM.SDATE.value==null || document.SITEFORM.SDATE.value=="")
	{
		alert("請輸入日期");
		document.SITEFORM.SDATE.focus();
		return false;
	}
	if (document.SITEFORM.EDATE.value==null || document.SITEFORM.EDATE.value=="")
	{
		alert("請輸入日期");
		document.SITEFORM.EDATE.focus();
		return false;
	}
	if (document.SITEFORM.EFFECTIVE_DATE.value==null || document.SITEFORM.EFFECTIVE_DATE.value=="")
	{
		alert("請輸入日期");
		document.SITEFORM.EFFECTIVE_DATE.focus();
		return false;
	}
	if (document.SITEFORM.LAST_ORDER_DATE.value==null || document.SITEFORM.LAST_ORDER_DATE.value=="")
	{
		alert("請輸入日期");
		document.SITEFORM.LAST_ORDER_DATE.focus();
		return false;
	}
	if (document.SITEFORM.LAST_DELIVERY_DATE.value==null || document.SITEFORM.LAST_DELIVERY_DATE.value=="")
	{
		alert("請輸入日期");
		document.SITEFORM.LAST_DELIVERY_DATE.focus();
		return false;
	}
	if (document.SITEFORM.INTENDED_DATE.value==null || document.SITEFORM.INTENDED_DATE.value=="")
	{
		alert("請輸入日期");
		document.SITEFORM.INTENDED_DATE.focus();
		return false;
	}
	document.SITEFORM.SAVE.disabled=true;	
	document.SITEFORM.action=URL+"&SDATE="+document.SITEFORM.SDATE.value+"&EDATE="+document.SITEFORM.EDATE.value+"&EFFECTIVE_DATE="+document.SITEFORM.EFFECTIVE_DATE.value+"&LAST_ORDER_DATE="+document.SITEFORM.LAST_ORDER_DATE.value+"&LAST_DELIVERY_DATE="+document.SITEFORM.LAST_DELIVERY_DATE.value+"&INTENDED_DATE="+document.SITEFORM.INTENDED_DATE.value;
	document.SITEFORM.submit();	
}
</script>
<title>PCN Issue Date Maintain</title>
</head>
<%
String PCN = request.getParameter("PCN");
if (PCN ==null) PCN="";
String SEQ = request.getParameter("SEQ");
if (SEQ ==null) SEQ="";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE ==null) ACTIONCODE="";	
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String EFFECTIVE_DATE = request.getParameter("EFFECTIVE_DATE");
if (EFFECTIVE_DATE ==null) EFFECTIVE_DATE ="";
String LAST_ORDER_DATE = request.getParameter("LAST_ORDER_DATE");
if (LAST_ORDER_DATE==null) LAST_ORDER_DATE="";
String LAST_DELIVERY_DATE = request.getParameter("LAST_DELIVERY_DATE");
if (LAST_DELIVERY_DATE==null) LAST_DELIVERY_DATE="";
String INTENDED_DATE = request.getParameter("INTENDED_DATE");
if (INTENDED_DATE==null) INTENDED_DATE="";
String sql="";
if (!ACTIONCODE.equals("SAVE"))
{
	 sql = "select a.PCN_CREATION_DATE,a.PCN_END_DATE,EFFECTIVE_DATE,LAST_ORDER_DATE,LAST_DELIVERY_DATE,INTENDED_START_OF_DELIVERY from oraddman.tsqra_pcn_item_header a where a.PCN_NUMBER=?";
	PreparedStatement statement1 = con.prepareStatement(sql);
	statement1.setString(1,PCN);
	ResultSet rs1=statement1.executeQuery();
	while (rs1.next())
	{
		SDATE = rs1.getString("PCN_CREATION_DATE");
		EDATE = rs1.getString("PCN_END_DATE");
		EFFECTIVE_DATE=rs1.getString("EFFECTIVE_DATE");
		LAST_ORDER_DATE=rs1.getString("LAST_ORDER_DATE");
		LAST_DELIVERY_DATE=rs1.getString("LAST_DELIVERY_DATE");
		INTENDED_DATE=rs1.getString("INTENDED_START_OF_DELIVERY");
	}
	rs1.close();
	statement1.close();	
}
%>
<body >  
<FORM METHOD="post" NAME="SITEFORM"  ENCTYPE="multipart/form-data">
<DIV><font style="font-family:arial;font-size:12px">PCN/PDN/IN Number:</font><font style="font-family:arial;font-size:12px">&nbsp;<%=PCN%><input type="hidden" NAME="PCN" value="<%=PCN%>"><input type="hidden" NAME="SEQ" value="<%=SEQ%>"></font></DIV>
<HR>
<p>
<table width="100%">
	<tr>
		<td width="30%"><font style="color:#006666;font-family:arial;font-size:12px">Issue Date:</font></td>
		<td><input type="text" name="SDATE" style="font-family:arial" value="<%=(SDATE==null?"":SDATE)%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.SITEFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
					~<input type="text" name="EDATE" style="font-family:arial" value="<%=(EDATE==null?"":EDATE)%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.SITEFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
	</tr>
	<tr>
		<td><font style="color:#006666;font-family:arial;font-size:12px">Effective Date:</font></td>
		<td><input type="text" name="EFFECTIVE_DATE" style="font-family:arial" value="<%=(EFFECTIVE_DATE==null?"":EFFECTIVE_DATE)%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.SITEFORM.EFFECTIVE_DATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
	</tr>
	<tr>
		<td><font style="color:#006666;font-family:arial;font-size:12px">Last Order Date:</font></td>
		<td><input type="text" name="LAST_ORDER_DATE" style="font-family:arial" value="<%=(LAST_ORDER_DATE==null?"":LAST_ORDER_DATE)%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.SITEFORM.LAST_ORDER_DATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
	</tr>
	<tr>
		<td><font style="color:#006666;font-family:arial;font-size:12px">Last Delivery Date:</font></td>
		<td><input type="text" name="LAST_DELIVERY_DATE" style="font-family:arial" value="<%=(LAST_DELIVERY_DATE==null?"":LAST_DELIVERY_DATE)%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.SITEFORM.LAST_DELIVERY_DATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
	</tr>
	<tr>
		<td><font style="color:#006666;font-family:arial;font-size:12px">Intended Start Of Delivery:</font></td>
		<td><input type="text" name="INTENDED_DATE" style="font-family:arial" value="<%=(INTENDED_DATE==null?"":INTENDED_DATE)%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.SITEFORM.INTENDED_DATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
	</tr>
</table>		
<div align="center"><input type='button' name="SAVE" value="Save" style="font-family:arial;font-size:12px" onClick="setModify('../jsp/TSCQRAPCNIssueDate.jsp?ACTIONCODE=SAVE&SEQ=<%=SEQ%>&PCN=<%=PCN%>')"></div>
<BR>
<%
	if (ACTIONCODE.equals("SAVE"))
	{
		try
		{
			sql = " update oraddman.tsqra_pcn_item_header set PCN_CREATION_DATE =?,PCN_END_DATE=? ,EFFECTIVE_DATE=?,LAST_ORDER_DATE=?,LAST_DELIVERY_DATE=?,INTENDED_START_OF_DELIVERY=? where PCN_NUMBER=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,SDATE); 
			pstmtDt.setString(2,EDATE); 
			pstmtDt.setString(3,EFFECTIVE_DATE); 
			pstmtDt.setString(4,LAST_ORDER_DATE); 
			pstmtDt.setString(5,LAST_DELIVERY_DATE); 
			pstmtDt.setString(6,INTENDED_DATE); 
			pstmtDt.setString(7,PCN); 
			pstmtDt.executeUpdate();
			pstmtDt.close();
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.document.getElementById("sd_"+document.SITEFORM.SEQ.value).innerHTML=document.SITEFORM.SDATE.value;
				window.opener.document.getElementById("ed_"+document.SITEFORM.SEQ.value).innerHTML=document.SITEFORM.EDATE.value;
				window.opener.document.getElementById("efd_"+document.SITEFORM.SEQ.value).innerHTML=document.SITEFORM.EFFECTIVE_DATE.value;
				window.opener.document.getElementById("lod_"+document.SITEFORM.SEQ.value).innerHTML=document.SITEFORM.LAST_ORDER_DATE.value;
				window.opener.document.getElementById("ldd_"+document.SITEFORM.SEQ.value).innerHTML=document.SITEFORM.LAST_DELIVERY_DATE.value;
				window.opener.document.getElementById("id_"+document.SITEFORM.SEQ.value).innerHTML=document.SITEFORM.INTENDED_DATE.value;
				window.close();				
			</script>
	<%	
		}			
		catch(Exception e)
		{
			out.println("<font color='red' size='+1'>Exception:"+e.getMessage()+"</font>");
		}
			
	}
%>
<!--%表單參數%-->
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
