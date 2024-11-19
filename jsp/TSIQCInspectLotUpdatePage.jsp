<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,DateBean"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html> 
<head>
<title></title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Verdana; color: #000000; font-size: 12px }
  P         { font-family: Verdana; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Verdana; font-size: 12px }
  TD        { font-family: Verdana; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
</STYLE>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		window.opener.document.getElementById("alpha").style.width="0px";
		window.opener.document.getElementById("alpha").style.height="0px";
		this.window.close();				
    }  
}  
function setClose()
{
	window.opener.document.getElementById("alpha").style.width="0px";
	window.opener.document.getElementById("alpha").style.height="0px";
	this.window.close();				
}
function setsubmit(URL)
{
	document.SUBFORM.action=URL;
 	document.SUBFORM.submit();
}

</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<%
String NO = request.getParameter("NO");
if (NO==null) NO="";
String LINE = request.getParameter("LINE");
if (LINE==null) LINE="";
String CLN = request.getParameter("CLN");
if (CLN==null) CLN="";
String SUPPLIER_LOT_NO = request.getParameter("SUPPLIER_LOT_NO");
if (SUPPLIER_LOT_NO ==null) SUPPLIER_LOT_NO="";
String INV_ITEM_DESC = request.getParameter("INV_ITEM_DESC");
if (INV_ITEM_DESC == null) INV_ITEM_DESC="";
String REMARK = request.getParameter("REMARK");
if (REMARK==null) REMARK="";
String ACTION_TYPE = request.getParameter("ACTION_TYPE");
if (ACTION_TYPE==null) ACTION_TYPE="";
String sql ="",DateNoFound="N";

try
{
	if (ACTION_TYPE.equals(""))
	{
		sql = " select INV_ITEM_DESC,SUPPLIER_LOT_NO,INSPECT_REMARK from oraddman.tsciqc_lotinspect_detail WHERE INSPLOT_NO=? and LINE_NO=?";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,NO);
		statement.setString(2,LINE);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			INV_ITEM_DESC = rs.getString("INV_ITEM_DESC");
			if (INV_ITEM_DESC==null) INV_ITEM_DESC="";
			SUPPLIER_LOT_NO = rs.getString("SUPPLIER_LOT_NO");
			if (SUPPLIER_LOT_NO==null) SUPPLIER_LOT_NO="";
			REMARK = rs.getString("INSPECT_REMARK");
			if (REMARK==null) REMARK="";
			DateNoFound="Y";
		}
		rs.close();
		statement.close();	
		
		if (!DateNoFound.equals("Y"))
		{
		%>
			<script language="javascript">
			alert("No Data Found!!");
			setClose();
			</script>
		<%
		}
	}
}
catch(Exception e)
{
	out.println(e.getMessage());
}

%>
<body bgcolor="#EFF4DD">
<form name="SUBFORM"  METHOD="post" ACTION="TSCEDIOrderDetailNotice.jsp">
	<table align="center" width="60%" border="1" bordercolorlight="#E3E3E3" bordercolordark="#E4E4E4" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="1"n bgcolor="#FFFFFF">
					<tr>
						<td width="100%">檢驗批單號:<%=NO%>
						<input type="hidden" name="NO" value="<%=NO%>">
						<input type="hidden" name="LINE" value="<%=LINE%>">
						<input type="hidden" name="CLN" value="<%=CLN%>">
						</td>
					</tr>
					<tr>
						<td width="100%">供應商進料批號:<%=SUPPLIER_LOT_NO%>
						<input type="hidden" name="SUPPLIER_LOT_NO" value="<%=SUPPLIER_LOT_NO%>">
						</td>
					</tr>					
					<tr>
						<td width="100%">台半料號:<%=INV_ITEM_DESC%>
						<input type="hidden" name="INV_ITEM_DESC" value="<%=INV_ITEM_DESC%>">
						</td>
					</tr>					

					<tr>
						<td>Remarks:<br>
						<textarea cols="70" rows="5" name="REMARK" class="style2"><%=REMARK%></textarea>
						</td>
					</tr>
					<tr>
						<td><br><br><input type="button" name="save" style="font-family: Verdana" value="Submit" onClick="setsubmit('../jsp/TSIQCInspectLotUpdatePage.jsp?ACTION_TYPE=SAVE');"></td>
					</tr>
				</table>
			</td>
		</tr>	
	</table>
<%
if (ACTION_TYPE.equals("SAVE"))
{
	try
	{
		sql =  " insert into oraddman.tsciqc_lotinspect_log"+
		       " select INSPLOT_NO,LINE_NO,?,INSPECT_REMARK,?,SYSDATE,?"+
			   " from oraddman.tsciqc_lotinspect_detail "+
			   " WHERE INSPLOT_NO=? "+
			   " and LINE_NO=?"+
 		       " and nvl(INSPECT_REMARK,' ') <> nvl(?,' ')";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,CLN);
		pstmtDt.setString(2,REMARK);
		pstmtDt.setString(3,UserName);
		pstmtDt.setString(4,NO);
		pstmtDt.setString(5,LINE);
		pstmtDt.setString(6,REMARK);
		pstmtDt.executeQuery();
		pstmtDt.close();
		
		//out.println("REMARK="+REMARK);
		//out.println("NO="+NO);
		//out.println("LINE="+LINE);
		sql = " update oraddman.tsciqc_lotinspect_detail "+
			  " set INSPECT_REMARK =?"+
			  " WHERE INSPLOT_NO=? "+
			  " and LINE_NO=?"+
		      " and nvl(INSPECT_REMARK,' ') <> nvl(?,' ')";
		//out.println(sql);
		pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,REMARK);
		pstmtDt.setString(2,NO);
		pstmtDt.setString(3,LINE);
		pstmtDt.setString(4,REMARK);
		pstmtDt.executeQuery();
		pstmtDt.close();
		
		con.commit();
		
	%>
	<script language="javascript">
		if (document.SUBFORM.REMARK.value==null || document.SUBFORM.REMARK.value=="")
		{
			window.opener.document.getElementById("rmk"+document.SUBFORM.LINE.value).innerHTML  = "&nbsp;";
		}
		else
		{
			window.opener.document.getElementById("rmk"+document.SUBFORM.LINE.value).innerHTML  = document.SUBFORM.REMARK.value;
		}
		setClose();
	</script>		
	<%
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("<div style='color:#ff0000'>交易失敗!請洽系統管理人員,謝謝!("+e.getMessage()+")</div>");
	}	
}
%>
</form>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>