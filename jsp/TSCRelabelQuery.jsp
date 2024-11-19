<%@ page language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,java.lang.*,"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setUpload(URL)
{    
	subWin=window.open(URL,"subwin","width=840,height=550,scrollbars=yes,menubar=no");  
}
function setGetNo(URL)
{    
	subWin=window.open(URL,"subwin","width=30,height=50,scrollbars=yes,menubar=no");  
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 11px}
</STYLE>
<title>Relabel Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String CUSTOMERPO=request.getParameter("CUSTOMERPO");
if(CUSTOMERPO==null) CUSTOMERPO="";
String LOTNUMBER=request.getParameter("LOTNUMBER");
if(LOTNUMBER==null) LOTNUMBER="";
String REQUESTNO=request.getParameter("REQUESTNO");
if(REQUESTNO==null) REQUESTNO="";
String CUSTPARTNO =request.getParameter("CUSTPARTNO");
if(CUSTPARTNO==null) CUSTPARTNO="";
String TSCPARTNO=request.getParameter("TSCPARTNO");
if(TSCPARTNO==null) TSCPARTNO="";
String sql ="";
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCRelabelQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">Relabel Request/Query</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666;font-family: Tahoma,Georgia">Reuest No  :</td>   
		<td width="8%"><textarea cols="18" rows="4" name="REQUESTNO" class="style5"><%=REQUESTNO%></textarea></td> 
		<td width="7%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">TSC Part No:</td>   
		<td width="10%"><textarea cols="20" rows="4" name="TSCPARTNO" class="style5"><%=TSCPARTNO%></textarea></td>  
	    <td width="7%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Cust Part No:</td> 
		<td width="10%"><textarea cols="20" rows="4" name="CUSTPARTNO" class="style5"><%=CUSTPARTNO%></textarea></td>
	    <td width="7%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Customer PO:</td> 
		<td width="10%"><textarea cols="20" rows="4" name="CUSTOMERPO" class="style5"><%=CUSTOMERPO%></textarea></td>				
	    <td width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Lot Number :</td> 
		<td width="10%"><textarea cols="18" rows="4" name="LOTNUMBER" class="style5"><%=LOTNUMBER%></textarea></td>
    </tr>
</table>
<table border="0" width="100%">
	<tr>
	  <td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCRelabelQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='Request'  style="font-family:ARIAL" onClick='setUpload("../jsp/TSCRelabelRequest.jsp")' >
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT a.req_no"+
	      ",a.req_seq"+
		  ",a.shipping_marks"+
		  ",a.item_name"+
		  ",a.item_desc"+
		  ",a.cust_pn"+
		  ",a.cust_po"+
		  ",a.lot_number"+
		  ",a.date_code"+
		  ",a.quantity"+
		  ",a.carton_number"+
		  ",to_char(a.creation_date,'yyyymmdd') creation_date"+
		  ",a.created_by"+
		  ",a.printed_date"+
		  ",a.factory_code"+
		  ",a.sales_region"+
          " FROM oraddman.ts_relabel_request a"+
		  " where a.active_flag='A'";
	if (!CUSTOMERPO.equals(""))
	{
		String [] strCUSTOMERPO = CUSTOMERPO.split("\n");
		String CUSTOMERPOList = "";
		for (int x = 0 ; x < strCUSTOMERPO.length ; x++)
		{
			if (CUSTOMERPOList.length() >0) CUSTOMERPOList += ",";
			CUSTOMERPOList += "'"+strCUSTOMERPO[x].trim()+"'";
		}
		sql += " and a.CUST_PO in ("+CUSTOMERPOList+")";
	}
	if (!TSCPARTNO.equals(""))
	{
		String [] strTSCPARTNO = TSCPARTNO.split("\n");
		String TSCPARTNOList = "";
		for (int x = 0 ; x < strTSCPARTNO.length ; x++)
		{
			if (TSCPARTNOList.length() >0) TSCPARTNOList += ",";
			TSCPARTNOList += "'"+strTSCPARTNO[x].trim()+"'";
		}
		sql += " and a.ITEM_DESC in ("+TSCPARTNOList+")";
	}	
	if (!CUSTPARTNO.equals(""))
	{
		String [] strCUSTPARTNO = CUSTPARTNO.split("\n");
		String CUSTPARTNOList = "";
		for (int x = 0 ; x < strCUSTPARTNO.length ; x++)
		{
			if (CUSTPARTNOList.length() >0) CUSTPARTNOList += ",";
			CUSTPARTNOList += "'"+strCUSTPARTNO[x].trim()+"'";
		}
		sql += " and a.CUST_PN in ("+CUSTPARTNOList+")";
	}
	if (!LOTNUMBER.equals(""))
	{
		String [] strLOTNUMBER = LOTNUMBER.split("\n");
		String LOTNUMBERList = "";
		for (int x = 0 ; x < strLOTNUMBER.length ; x++)
		{
			if (LOTNUMBERList.length() >0) LOTNUMBERList += ",";
			LOTNUMBERList += "'"+strLOTNUMBER[x].trim()+"'";
		}
		sql += " and a.lot_number in ("+LOTNUMBERList+")";
	}		
	sql += " order by a.creation_date desc";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
			<tr bgcolor="#C9E2D0"> 
				<td width="7%" style="color:#006666" align="center">Sales Region</td>
				<td width="7%" style="color:#006666" align="center">Request No</td>
				<td width="12%" style="color:#006666" align="center">Shipping Marks</td>
				<td width="10%" style="color:#006666" align="center">Item Name</td>
				<td width="10%" style="color:#006666" align="center">Item Desc</td>
				<td width="8%" style="color:#006666" align="center">Customer PO</td>
				<td width="8%" style="color:#006666" align="center">Cust Part No</td>
				<td width="8%" style="color:#006666" align="center">Lot Number</td>
				<td width="7%" style="color:#006666" align="center">Date Code</td>
				<td width="5%" style="color:#006666" align="center">Qty</td>
				<td width="3%" style="color:#006666" align="center">Carton#</td>
				<td width="5%" style="color:#006666" align="center">Created By</td>				
				<td width="5%" style="color:#006666" align="center">Creation Date</td>
				
			</tr>
		<% 
		}
    	%>
		<tr  id="tr_<%=iCnt%>" bgcolor="#E7F1EB" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#E7F1EB';style.color='#000000';this.style.fontWeight='normal'">
			<td><%=rs.getString("SALES_REGION")%></td>
			<td><%=rs.getString("REQ_NO")%></td>
			<td><%=rs.getString("SHIPPING_MARKS")%></td>
			<td><%=rs.getString("ITEM_NAME")%></td>
			<td><%=rs.getString("ITEM_DESC")%></td>
			<td><%=rs.getString("CUST_PO")%></td>
			<td><%=rs.getString("CUST_PN")%></td>
			<td><%=rs.getString("LOT_NUMBER")%></td>
			<td><%=rs.getString("DATE_CODE")%></td>
			<td align="right"><%=rs.getString("QUANTITY")%></td>
			<td align="center"><%=rs.getString("CARTON_NUMBER")%></td>
			<td align="center"><%=rs.getString("CREATED_BY")%></td>
			<td align="center"><%=rs.getString("CREATION_DATE")%></td>
		</tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='·s²Ó©úÅé'><strong>No Data Found!</strong></font></div>");
	}
	else
	{
%>
	</table>
<%
	}
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
</FORM>
<BR>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

