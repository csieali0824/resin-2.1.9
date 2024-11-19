<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit1(URL)
{    
	if (document.SUBFORM.C_MONTH.value =="")
	{
		alert("Please enter a calculate month!");
		return false;
	}
	var rec_year = document.SUBFORM.C_MONTH.value.substr(0,4);
	var rec_month= document.SUBFORM.C_MONTH.value.substr(4,2);
	if (rec_month <1 || rec_month >12)
	{
		alert("Month error!!");
		document.SUBFORM.C_MONTH.focus();
		return false;			
	}	
	
	document.SUBFORM.action=URL+"&C_MONTH="+document.SUBFORM.C_MONTH.value;
 	document.SUBFORM.submit();
}
// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
	if((year%4==0&&year%100!=0)||(year%400==0)) 
	{ 
		return true; 
	}  
	return false; 
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
</STYLE>
<title>Calculate SG Safety Stock </title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String C_MONTH = request.getParameter("C_MONTH");
if (C_MONTH==null) C_MONTH="";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE="";
String sql = "";
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCSGItemSafetyStockJob.jsp" METHOD="post" NAME="SUBFORM">
<BR>
<table>
	<tr>
	  <td><p>
	      <input type="text" name="C_MONTH" value="<%=C_MONTH%>" style="font-family:Tahoma,Georgia;font-size:12px" size="15">
        <BR>
	    (YYYYMM)</td>
		<td><INPUT TYPE="button" align="middle"  value='Calculate' onClick='setSubmit1("../jsp/TSCSGItemSafetyStockJob.jsp?ACTIONCODE=SUBJOB")' style="font-family:Tahoma,Georgia" ></td>
	</tr>
</table>
<%
int job_cnt =0,job_id=2377;
if (ACTIONCODE.equals("SUBJOB"))
{
	try
	{	
		CallableStatement cs3 = con.prepareCall("{call TSSG_INV_PKG.SUBMIT_SAFETY_STOCK_JOB(?,?)}");
		cs3.setInt(1,job_id); 
		cs3.setString(2,C_MONTH); 
		cs3.execute();
		cs3.close();
		
		%>
		<script language="JavaScript" type="text/JavaScript">
			//window.opener.document.MYFORM.submit();
			window.close();	
		</script>
		<%
		
	}
	catch(Exception e)
	{
		out.println("<font color='red'>"+e.getMessage()+"</font>");
	}		
}

%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

