<%@ page language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,DateBean"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
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
  .style1   {font-weight:bold;color:#000000;font-size:18px;font-family:Verdana;}
  .style2   {font-family:Verdana;font-size:12px;}
  .style3   {font-family:Verdana;font-weight:bold;font-size:14px;color:#000000;}
  .style4   {color:#999999;font-family:Verdana;font-size:11px;}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setsubmit(URL)
{
	if (document.SUBFORM.REPLIER.value==null || document.SUBFORM.REPLIER.value=="")
	{
		document.SUBFORM.REPLIER.style.borderColor="#FF6600";
		document.SUBFORM.REPLIER.style.borderStyle="solid";
		document.SUBFORM.REPLIER.style.borderWidth="thin";
		return false;
	}
	if (document.SUBFORM.REPLIYDATE.value==null || document.SUBFORM.REPLIYDATE.value=="")
	{
		document.SUBFORM.REPLIYDATE.style.borderColor="#FF6600";
		document.SUBFORM.REPLIYDATE.style.borderStyle="solid";
		document.SUBFORM.REPLIYDATE.style.borderWidth="thin";
		return false;
	}
	document.SUBFORM.action=URL;
 	document.SUBFORM.submit();
}
</script>
</head>
<%
String ITEMLIST="",DateNoFound="",sql="";
String formkey = request.getParameter("formkey");
//out.println(formkey);
String action = request.getParameter("action");
String numid="3285017";
if (action==null) action="";
String KEYID = formkey.substring(0,formkey.indexOf("#"));
String CUSTSTR = formkey.substring(formkey.lastIndexOf("+")+1,formkey.lastIndexOf("/"));
String SEQNO = "PCN"+(formkey.substring(formkey.indexOf("#")+1,formkey.lastIndexOf("+"))).replace("sid","");
String QNO="";
String CUSTNO="";
String [] CUSTLIST = CUSTSTR.split("%");
for (int i =0 ; i < CUSTLIST.length ; i++)
{
	CUSTNO += ""+ (Integer.parseInt(CUSTLIST[i]) / (10 * (i+1)));
}
//out.println(CUSTNO);
if (CUSTNO==null || !CUSTNO.equals(numid)) DateNoFound="Y";
//out.println(CUSTNO);
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
//out.println(CUST);
String REPLIER = request.getParameter("REPLIER");
if (REPLIER==null) REPLIER="";
String REPLIYDATE = request.getParameter("REPLIYDATE");
if (REPLIYDATE==null) REPLIYDATE=dateBean.getYearMonthDay();
String iNo = request.getParameter("NO");
if (iNo==null) iNo="";

try
{
	if (action.equals("s"))
	{
		sql = " update  oraddman.tsqra_pcn_item_detail a"+
			  " set SALES_ISSUE_DATE=?"+
			  ",SALES=?"+
			  " WHERE PCN_NUMBER=?"+
			  " AND EXISTS (SELECT 1 FROM oraddman.tsqra_pcn_item_detail x where rowid=? AND x.territory=a.territory and x.CUST_SHORT_NAME=a.CUST_SHORT_NAME)";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,REPLIYDATE);
		pstmtDt.setString(2,REPLIER);
		pstmtDt.setString(3,SEQNO);
		pstmtDt.setString(4,CUST);
		pstmtDt.executeUpdate();
		pstmtDt.close();
	}
	else
	{

		sql = " SELECT distinct a.pcn_number,b.cust_short_name customer_name from oraddman.tsqra_pcn_item_header a,oraddman.tsqra_pcn_item_detail b"+
			  " where a.rowid=? and a.pcn_number=? and b.rowid =? "+
			  " and a.pcn_number= b.pcn_number ";
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,KEYID);
		statement.setString(2,SEQNO);
		statement.setString(3,CUST);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			QNO = rs.getString("pcn_number");
			//CUST = rs.getString("customer_name");
		}
		rs.close();
		statement.close();	
	}
}
catch(Exception e)
{
	DateNoFound = "Y";	
	out.println(e.getMessage());
}

if (DateNoFound.equals("Y"))
{
%>
	<Script language="JavaScript">
		alert("PCN number value is invalid!!");
		location.replace("http://www.taiwansemi.com/"); 
	</Script>
<%
}
%>
<body bgcolor="#DCF1E0">
<form name="SUBFORM"  METHOD="post" ACTION="TSCQRAProductNoticeSalesDate.jsp">
	<table align="center" width="70%" border="1" bordercolorlight="#E3E3E3" bordercolordark="#E4E4E4" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="1"n bgcolor="#FFFFFF">
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td width="30%"><font color="#FF6600"> *</font><font class="style3">Sales Name:</font></td>
						<td>
						<input type="text" name="REPLIER" class="style2" value="<%=REPLIER%>" size="30">
						<input type="hidden" name="CUST" value="<%=CUST%>">
						<input type="hidden" name="NO" VALUE="<%=iNo%>">
						</td>
					</tr>
					<tr>
						<td><font color="#FF6600"> *</font><font class="style3">Issue Date:</font></td>
						<td><input type="text" name="REPLIYDATE" class="style2" VALUE="<%=REPLIYDATE%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.SUBFORM.REPLIYDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" align="center"><input type="button" name="save" class="style2" value="Submit" onClick="setsubmit('../jsp/TSCQRAProductNoticeSalesDate.jsp?formkey=<%=java.net.URLEncoder.encode(formkey)%>&action=s');"></td>
					</tr>
				</table>
			</td>
		</tr>	
	</table>		
</form>
<%
if (action.equals("s"))
{
%>
	<Script language="JavaScript">
		var SALES_ISSUE_NOTICE = "";
		if (document.SUBFORM.REPLIYDATE.value.length>0) SALES_ISSUE_NOTICE += document.SUBFORM.REPLIYDATE.value;
		SALES_ISSUE_NOTICE += ("<br>"+document.SUBFORM.REPLIER.value);
		window.opener.document.getElementById("DIV_SALES_ISSUE_"+document.SUBFORM.NO.value).innerHTML = SALES_ISSUE_NOTICE;
		this.window.close(); 
	</Script>
<%
}
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>