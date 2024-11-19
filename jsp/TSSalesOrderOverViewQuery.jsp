<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setExportXLS(URL)
{  
	if (document.MYFORM.CUSTOMER_ID.value =="" || document.MYFORM.CUSTOMER_ID.value =="--")
	{
		alert("Please choose a customer!");
		document.MYFORM.CUSTOMER_ID.focus(); 
		return false;	
	}
	 
	if (document.MYFORM.SDATE.value =="")
	{
		alert("Please enter the start date!");
		document.MYFORM.SDATE.focus(); 
		return false;
	}
	if (document.MYFORM.EDATE.value =="")
	{
		alert("Please enter the end date!");
		document.MYFORM.EDATE.focus(); 
		return false;
	}	
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
<title>TSSalesOrderOverView Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<%
String CUSTOMER_ID = request.getParameter("CUSTOMER_ID");
if (CUSTOMER_ID==null) CUSTOMER_ID="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="20150101";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE=dateBean.getYearMonthDay();
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWPurchasingDetailQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">Customer Logistic Performance Analysis</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
  	<tr>
		<td width="10%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">Customer Name:</td>   
		<td width="15%">
		<%
		try
        {   
			String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
			PreparedStatement pstmt=con.prepareStatement(sql1);
			pstmt.executeUpdate(); 
			pstmt.close();	
					
			String sql = " SELECT CUSTOMER_ID,CUST_SHORTNAME"+
						 " FROM TSC_EDI_CUSTOMER "+
						 " WHERE INACTIVE_DATE is null or INACTIVE_DATE >trunc(sysdate)"+
						 " order by CUST_SHORTNAME";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(CUSTOMER_ID);
			comboBoxBean.setFieldName("CUSTOMER_ID");	
			comboBoxBean.setFontName("Tahoma,Georgia");  
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();
		 } //end of try		 
		 catch (Exception e)
		 { 
			out.println("Exception:"+e.getMessage()); 
		 }
		%>
		</td>
		<td width="15%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">Customer Order Date:</td>   
		<td width="60%">
		<input type="TEXT" NAME="SDATE" value="<%=SDATE%>" style="font-size:12px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="EDATE" value="<%=EDATE%>" style="font-size:12px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
			&nbsp;&nbsp;
			&nbsp;&nbsp;
			&nbsp;&nbsp;
			&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='EXCEL'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSSalesOrderOverView.jsp")' > 
		</td>
	</tr>
</table>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

