<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{ 
	try
	{	
		if (eval(document.MYFORMD.PO_PRICE.value)<=0)
		{
			alert("Please input the price value!");
			return false;
		}
	}
	catch(e)
	{
		//alert(e.message); 
		alert("The price is not number format!");
		document.MYFORMD.PO_PRICE.focus();
		return false;
	}
	document.MYFORMD.btnSubmit.disabled =true;
	document.MYFORMD.btnCancel.disabled =true;
	document.MYFORMD.action=URL;
 	document.MYFORMD.submit();
}
function setCancel()
{
	window.close();
}
</script>
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
</STYLE>
<title>SG Advise Customer Part NO Revise</title>
</head>
<body>
<FORM NAME="MYFORMD" ACTION="../jsp/TSCSGShippingAdviseRevise.jsp" METHOD="POST"> 
<%
String AID = request.getParameter("AID");
if (AID==null) AID="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String CUST_PARTNO = request.getParameter("CUST_PARTNO");
if (CUST_PARTNO==null) CUST_PARTNO="";
String PO_PRICE = request.getParameter("PO_PRICE");
if (PO_PRICE==null) PO_PRICE="";

String sql ="",strmsg="";
try
{
	if (ACODE.equals("SAVE"))
	{
		sql = " update tsc.tsc_shipping_po_price_sg "+
			  " set old_cust_partno=cust_partno"+
              ",old_po_unit_price=po_unit_price"+
              ",cust_partno=?"+
			  ",po_unit_price=?"+
			  ",last_updated_by=?"+
			  ",last_update_date=sysdate"+
			  " where pc_advise_price_id=?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,(CUST_PARTNO.equals("")?"N/A":CUST_PARTNO)); 
		pstmtDt.setString(2,PO_PRICE);
		pstmtDt.setString(3,UserName); 
		pstmtDt.setString(4,AID);
		pstmtDt.executeQuery();
		pstmtDt.close();
		con.commit();
		%>
		<script language="JavaScript" type="text/JavaScript">
			window.opener.document.MYFORM.submit();	
		  	this.window.close();
		</script>					
		<%
	}
	sql = " select cust_partno,po_unit_price from tsc.tsc_shipping_po_price_sg "+
	      " where pc_advise_price_id='"+AID+"'";
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	if (rs.next()) 
	{ 
		CUST_PARTNO = rs.getString("cust_partno");
		PO_PRICE = rs.getString("po_unit_price");
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	con.rollback();
	strmsg="<font color='red'>Fail!!cause:"+e.getMessage()+"</font>";
}
%>
<table align="center" width="60%">
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="30%" height="25" bgcolor="#C9E2D0" nowrap>Cust Part No：</td>
					<td nowrap><input type="TEXT" name="CUST_PARTNO" value="<%=CUST_PARTNO%>" style="font-family: Tahoma,Georgia;font-size:12px"><input type="hidden" name="AID" value="<%=AID%>"></td>
				</tr>
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>PO Price：</td>
					<td nowrap><input type="TEXT" name="PO_PRICE" value="<%=PO_PRICE%>" style="background-color:#F0F0F0;font-family: Tahoma,Georgia;font-size:12px"></td>
				</tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
  				<tr align=center>
    				<td width="16%"> <input name="btnSubmit" type="button" onClick='setSubmit("../jsp/TSCSGShippingAdviseRevise.jsp?ACODE=SAVE")' value="Submit" style="font-family:Tahoma,Georgia;font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input name="btnCancel" type="button" onClick="setCancel()" value="Exit" style="font-family:Tahoma,Georgia;font-size:12px">
					</td>    
  				</tr>
				<tr><td><div align="center"><%=strmsg%></div></td></tr>
			</table>
		</td>
	</tr>
</table>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
