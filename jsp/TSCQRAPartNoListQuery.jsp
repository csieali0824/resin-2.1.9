<!--20171116 Peggy,show "Recommended Replacement TSC P/N" column when query type=TSC P/N list-->
<%@ page contentType="text/html;charset=utf-8"  language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,DateBean,CodeUtil"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<jsp:useBean id="codeUtil" scope="page" class="CodeUtil"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html> 
<head>
<title></title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; font-size: 11px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   {background-color:#E1CDC8;font-size:11px;}
  .style2   {font-family:Tahoma,Georgia;border:none;font-size:11px;}
  .style3   {font-family:Tahoma,Georgia;color:#000000;font-size:11px;border:none;font-weight:bold}
  .style4   {font-family:Tahoma,Georgia;font-size:11px;border-left:none;border-right:none;border-top:none;color:#000000;border-color:#CCCCCC}
  .style5   {font-family:Tahoma,Georgia;font-size:11px;}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	if (document.MYFORM.QNO.value == null || document.MYFORM.QNO.value=="")
	{
		alert("please input the PCN/PDN/IN number!!");
		document.MYFORM.QNO.focus();
		return false;
	}
	if (document.MYFORM.QUERYTYPE.value == null || document.MYFORM.QUERYTYPE.value =="")
	{
		alert("please choose the query type!!");
		document.MYFORM.QUERYTYPE.focus();
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function toUpper(objname)
{
	if (event.keyCode!=8 && event.keyCode!=46)
	{
		document.MYFORM.elements[objname].value = document.MYFORM.elements[objname].value.toUpperCase();
	}
}
function subWindowReply(URL,HEIGHTNUM)
{
	subWin=window.open(URL,"subwin","width=600,height="+HEIGHTNUM+",scrollbars=yes,menubar=no");
}
function setExportXLS(URL)
{    
	if (document.MYFORM.QNO.value == null || document.MYFORM.QNO.value=="")
	{
		alert("please input the PCN/PDN/IN number!!");
		document.MYFORM.QNO.focus();
		return false;
	}
	if (document.MYFORM.QUERYTYPE.value == null || document.MYFORM.QUERYTYPE.value =="")
	{
		alert("please choose the query type!!");
		document.MYFORM.QUERYTYPE.focus();
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setUploadXLS(URL)
{    
	if (document.MYFORM.QNO.value == null || document.MYFORM.QNO.value=="")
	{
		alert("please input the PCN/PDN/IN number!!");
		document.MYFORM.QNO.focus();
		return false;
	}
	//if (document.MYFORM.QUERYTYPE.value == null || document.MYFORM.QUERYTYPE.value =="")
	//{
	//	alert("please choose the query type!!");
	//	document.MYFORM.QUERYTYPE.focus();
	//	return false;
	//}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open(URL+"?QNO="+document.MYFORM.QNO.value,"subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
}
</script>
</head>
<%
String QNO = request.getParameter("QNO");
if (QNO==null) QNO="";
String QUERYTYPE = request.getParameter("QUERYTYPE");
if (QUERYTYPE==null) QUERYTYPE="1";
String screenWidth=request.getParameter("SWIDTH");
if (screenWidth==null) screenWidth="0";
String screenHeight=request.getParameter("SHEIGHT");
if (screenHeight==null) screenHeight="0";
String sql ="",where="";
%>
<body>
<form name="MYFORM"  METHOD="post" ACTION="TSCQRAPartNoListQuery.jsp">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:<%=screenWidth%>;height:<%=screenHeight%>;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<font size=4><strong>Cust P/N & TSC P/N List Query</strong></font>
<%
try
{
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	

}
catch(SQLException e)
{
	out.println(e.toString());
}
	
%>
<table width="100%">
<%
	if ((String)session.getAttribute("USERNAME")!=null)
	{
%>
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp">HOME</A>
		</td>
	</tr>
<%
	}
%>
	<tr>
		<td>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
				<tr>
					<td width="15%" style="background-color:#62B3A3"><font color="#ffffff">PCN/PDN/IN Number</font></td>
					<td width="20%'"><input type="text"  name="QNO" class="style5" onKeyUp="toUpper('QNO')" value="<%=QNO%>"></td>
					<td width="15%" style="background-color:#62B3A3"><font color="#ffffff">Query Type</font></td>
					<td width="20%'"><SELECT NAME="QUERYTYPE" class="style5">
						<option value="1" <% if (QUERYTYPE.equals("1")) out.println("selected");%>>CUST P/N List
					    <option value="2" <% if (QUERYTYPE.equals("2")) out.println("selected");%>>TSC P/N List
						</SELECT>	
					</td>
					<td width="30%" align="center">
					<input type="button" name="submit1" value="Query" style="font-family:arial" onClick="setSubmit('../jsp/TSCQRAPartNoListQuery.jsp')">&nbsp;&nbsp;
					<input type="button" name="excel" value="Excel" style="font-family:arial" onClick="setExportXLS('../jsp/TSCQRAPartNoListReport.jsp')">&nbsp;&nbsp;
					<%
					if (((String)session.getAttribute("USERROLES")).toLowerCase().indexOf("admin")>=0 || ((String)session.getAttribute("USERNAME")).toUpperCase().equals("SUNNIE") || ((String)session.getAttribute("USERNAME")).toUpperCase().equals("DELIA.CHANG"))
					{
					%>
					<input type="button" name="Upload" value="Upload" style="font-family:arial" onClick="setUploadXLS('../jsp/TSCQRAPartNoListUpload.jsp')">
					<%
					}
					%>
					</td>
				</tr>
			</table>
		</td>
	</tr>
<%
try
{
%>
	<tr>
		<td>
<%
	if (!QNO.equals(""))
	{		
	
		if (QUERYTYPE.equals("1"))
		{
			sql = " select distinct c.PCN_NUMBER,b.TSC_PART_NO \"TSC P/N\" "+
		          ",b.MARKET_GROUP"+
		          ",b.CUST_SHORT_NAME customer_name"+
		          ",b.TERRITORY"+
		          ",b.CUST_PART_NO \"CUST P/N\""+
		          " from oraddman.tsqra_pcn_item_detail b ,oraddman.tsqra_pcn_item_header c"+
		          " where b.PCN_NUMBER(+)=c.PCN_NUMBER"+
				  " and c.PCN_NUMBER='"+QNO+"'"+
				  " and b.SOURCE_TYPE='1'"+
				  " ORDER BY 1,5,4,2";
		}
		else if (QUERYTYPE.equals("2"))
		{
			sql = " select distinct c.PCN_NUMBER,b.TSC_PART_NO \"TSC P/N\" "+
				  ",b.TSC_PROD_GROUP PROD_GROUP"+
				  ",b.TSC_PACKAGE PACKAGE"+
				  ",b.TSC_FAMILY FAMILY"+
				  ",b.DATE_CODE"+
				  ",c.PCN_TYPE"+  //add by Peggy 20140331
				  ",b.REPLACE_PART_NO"+ //add by Peggy 20171116
		          " from oraddman.tsqra_pcn_item_detail b ,oraddman.tsqra_pcn_item_header c"+
		          " where b.PCN_NUMBER(+)=c.PCN_NUMBER"+
				  " and c.PCN_NUMBER='"+QNO+"'"+
				  " and b.SOURCE_TYPE='2'"+
				  " ORDER BY 1,5,4";
		}
		if (sql.length()>0)
		{
			//out.println(sql);
			int rec_cnt =0;
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			while (rs.next())
			{
				if (rec_cnt==0)
				{
%>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border='1'>
<%
					if (QUERYTYPE.equals("1")) //by CUST P/N
					{
%>
				<tr style="font-weight:bold;background-color:#009966;color:#FFFFFF;">
					<td width="20%"  class="style5" align="center">PCN/PDN/IN Number</td>
					<td width="20%"  class="style5" align="center">TSC P/N</td>
					<td width="10%" class="style5" align="center">Territory</td>
					<td width="20%"  class="style5" align="center">Customer P/N</td>
					<td width="20%"  class="style5" align="center">Customer Name</td>
					<td width="10%"  class="style5" align="center">Market Group</td>
				</tr>
<%
					}
					else if (QUERYTYPE.equals("2")) //by TSC P/N
					{
%>
				<tr style="font-weight:bold;background-color:#009966;color:#FFFFFF;">
					<td width="12%"  class="style5" align="center">PCN/PDN/IN Number</td>
					<td width="20%" class="style5" align="center">Family</td>
					<td width="20%"  class="style5" align="center">Package</td>
					<td width="15%"  class="style5" align="center">TSC P/N</td>
					<td width="15%"  class="style5" align="center"><%=(rs.getString("PCN_TYPE").equals("PDN")?"Recommended Replacement TSC P/N":"New TSC P/N")%></td>
						<% if (rs.getString("PCN_TYPE").equals("PCN"))
						{
						%>
						<td width="18%"  class="style5" align="center">Expected Date Code</td>
						<%
						}
						%>
				</tr>
<%
					}
				}
				
				if (QUERYTYPE.equals("1")) //by CUSTOMER
				{
					out.println("<tr>");
					out.println("<td class='style5'>"+rs.getString("PCN_NUMBER")+"</td>");
					out.println("<td class='style5'>"+rs.getString("TSC P/N")+"</td>");
					out.println("<td class='style5'>"+rs.getString("TERRITORY")+"</td>");
					out.println("<td class='style5'>"+(rs.getString("CUST P/N")==null?"N/A":rs.getString("CUST P/N"))+"</td>");
					out.println("<td class='style5'>"+rs.getString("customer_name")+"</td>");
					out.println("<td class='style5'>"+rs.getString("market_group")+"</td>");
					out.println("</tr>");
				}
				else if (QUERYTYPE.equals("2")) //by TSC P/N
				{
					out.println("<tr>");
					out.println("<td class='style5'>"+rs.getString("PCN_NUMBER")+"</td>");
					out.println("<td class='style5'>"+rs.getString("FAMILY")+"</td>");
					out.println("<td class='style5'>"+rs.getString("PACKAGE")+"</td>");
					out.println("<td class='style5'>"+rs.getString("TSC P/N")+"</td>");
					out.println("<td class='style5'>"+(rs.getString("REPLACE_PART_NO")==null?"&nbsp;":rs.getString("REPLACE_PART_NO"))+"</td>");
					if (rs.getString("PCN_TYPE").equals("PCN"))
					{
						out.println("<td class='style5'>"+(rs.getString("DATE_CODE")==null?"&nbsp;":rs.getString("DATE_CODE"))+"</td>");
					}
					out.println("</tr>");
				}
				rec_cnt ++;
			}
			rs.close();
			statement.close();
			if (rec_cnt >0)
			{
	%>
					</table>
	<%
			}
		}
	}
%>
		</td>
	</tr>
<%	
}
catch(Exception e)
{
	out.println("exception2:"+e.toString());
}
%>			
</table>
</form>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>