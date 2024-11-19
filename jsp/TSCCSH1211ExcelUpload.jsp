<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">

function setSubmit(URL)
{    
	document.getElementById("alpha").style.width=document.body.scrollWidth+"px";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit2(URL)
{
	if (document.MYFORM.CUSTOMER.value == null || document.MYFORM.CUSTOMER.value == "" || document.MYFORM.CUSTOMER.value=="--")
	{
		alert("請先選擇客戶!");
		return false;
	}
	document.getElementById("alpha").style.width=document.body.scrollWidth+"px";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open(URL+"?ID="+document.MYFORM.CUSTOMER.value,"subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px}
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px} 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px}
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline}
  A:visited { color: #990066; text-decoration: underline}
  A:active  { color: #FF0000; text-decoration: underline}
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px}
</STYLE>
<title>TSCC-SH 1211 EXL訂單轉入</title>
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
<jsp:useBean id="TSCCSHBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="UPDRESBean" scope="session" class="Array2DimensionInputBean"/>
<%
String sql = "";
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER==null || CUSTOMER.equals("--")) CUSTOMER="";
String SHIPTO = request.getParameter("SHIPTO");
if (SHIPTO==null) SHIPTO="";
String SHIPADDRESS = request.getParameter("SHIPADDRESS");
if (SHIPADDRESS==null) SHIPADDRESS="";
String SHIPCOUNTRY = request.getParameter("SHIPCOUNTRY");
if (SHIPCOUNTRY==null) SHIPCOUNTRY="";
String BILLTO = request.getParameter("BILLTO");
if (BILLTO==null) BILLTO="";
String BILLADDRESS = request.getParameter("BILLADDRESS");
if (BILLADDRESS==null) BILLADDRESS="";
String BILLCOUNTRY = request.getParameter("BILLCOUNTRY");
if (BILLCOUNTRY==null) BILLCOUNTRY="";
String CURRENCY = request.getParameter("CURRENCY");
if (CURRENCY==null) CURRENCY="";
String PRICELISTID = request.getParameter("PRICELISTID");
if (PRICELISTID==null) PRICELISTID="";
String PRICELIST = request.getParameter("PRICELIST");
if (PRICELIST==null) PRICELIST="";
String FOBPOINT = request.getParameter("FOBPOINT");
if (FOBPOINT==null) FOBPOINT="";
String PAYMENTTERMID = request.getParameter("PAYMENTTERMID");
if (PAYMENTTERMID==null) PAYMENTTERMID="";
String PAYMENTTERM = request.getParameter("PAYMENTTERM");
if (PAYMENTTERM==null) PAYMENTTERM="";
String TAXCODE = request.getParameter("TAXCODE");
if (TAXCODE==null) TAXCODE="";
String SHIPTOCONTACTID = request.getParameter("SHIPTOCONTACTID");
if (SHIPTOCONTACTID==null) SHIPTOCONTACTID="";
String SHIPTOCONTACT = request.getParameter("SHIPTOCONTACT");
if (SHIPTOCONTACT==null) SHIPTOCONTACT=""; 
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE ==null) ACTIONCODE="";
if (!ACTIONCODE.equals("UPLOAD"))
{
	TSCCSHBean.setArray2DString(null); 
	UPDRESBean.setArray2DString(null); 
}
int ErrCnt=0;

CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
cs1.execute();
cs1.close();

try
{
	SHIPTO="";SHIPADDRESS="";SHIPCOUNTRY="";BILLTO="";BILLADDRESS="";BILLCOUNTRY="";CURRENCY="";PRICELISTID="";PRICELIST="";FOBPOINT="";PAYMENTTERMID="";PAYMENTTERM="";TAXCODE="";SHIPTOCONTACTID="";SHIPTOCONTACT="";
	Statement statementa=con.createStatement();
	sql = " select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno,"+
    	  " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,a.tax_code,"+       
 		  " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME  PAYMENT_TERM_NAME,"+
		  " a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,d.name,d.CURRENCY_CODE,"+ 
		  " con.LAST_NAME || DECODE(con.FIRST_NAME, NULL,NULL, ', '||con.FIRST_NAME)|| DECODE(con.TITLE,NULL, NULL, ' '||con.TITLE) contact_name,con.contact_id"+
	  	  " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c,SO_PRICE_LISTS d,(select * from ar_contacts_v where status='A') con"+
	  	  " where  a.ADDRESS_ID = b.cust_acct_site_id"+
	  	  " AND b.party_site_id = party_site.party_site_id"+
	      " AND loc.location_id = party_site.location_id "+
	      " and a.STATUS='A' "+
	      " and a.PRIMARY_FLAG='Y'"+
	      " and b.CUST_ACCOUNT_ID ='"+CUSTOMER+"'"+
	      " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
	      " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)"+
          " and a.address_id=con.address_id(+)"+
          " order by case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end"; 
	//out.println(sql); 
	ResultSet rs=statementa.executeQuery(sql);
	while (rs.next())
	{
		if (rs.getString("SITE_USE_CODE").equals("SHIP_TO"))
		{
			SHIPTO =rs.getString("SITE_USE_ID");
			SHIPADDRESS = rs.getString("ADDRESS1");
			SHIPCOUNTRY = rs.getString("COUNTRY");
			if (FOBPOINT== null || FOBPOINT.equals(""))	FOBPOINT = rs.getString("FOB_POINT");
			if (CURRENCY ==null || CURRENCY.equals(""))	CURRENCY = rs.getString("CURRENCY_CODE");
			if (TAXCODE == null || TAXCODE.equals("")) TAXCODE = rs.getString("TAX_CODE");
			if (PAYMENTTERMID == null || PAYMENTTERMID.equals(""))
			{
				PAYMENTTERMID = rs.getString("PAYMENT_TERM_ID");
				PAYMENTTERM = rs.getString("PAYMENT_TERM_NAME");
			}
			if (PRICELISTID == null || PRICELISTID.equals(""))
			{
				PRICELISTID = rs.getString("PRICE_LIST_ID");
				PRICELIST = "("+rs.getString("PRICE_LIST_ID")+") "+rs.getString("NAME");
			}
			SHIPTOCONTACT= rs.getString("contact_name");
			SHIPTOCONTACTID = rs.getString("contact_id");
			if (SHIPTOCONTACTID==null) 
			{
				SHIPTOCONTACTID="";SHIPTOCONTACT="";
			}
		}
		else if (rs.getString("SITE_USE_CODE").equals("BILL_TO"))
		{
			BILLTO = rs.getString("SITE_USE_ID");
			BILLADDRESS = rs.getString("ADDRESS1");
			BILLCOUNTRY = rs.getString("COUNTRY");
			if (FOBPOINT == null || FOBPOINT.equals("")) FOBPOINT = rs.getString("FOB_POINT");
			if (CURRENCY == null || CURRENCY.equals("")) CURRENCY = rs.getString("CURRENCY_CODE");
			if (TAXCODE == null || TAXCODE.equals("")) TAXCODE = rs.getString("TAX_CODE");
			if (PAYMENTTERMID == null || PAYMENTTERMID.equals(""))
			{
				PAYMENTTERMID = rs.getString("PAYMENT_TERM_ID");
				PAYMENTTERM = rs.getString("PAYMENT_TERM_NAME");
			}						
			if (PRICELISTID == null || PRICELISTID.equals(""))
			{
				PRICELISTID = rs.getString("PRICE_LIST_ID");
				PRICELIST = "("+rs.getString("PRICE_LIST_ID")+") "+rs.getString("NAME");
			}	
		}
	}
}
catch(Exception e)
{
	out.println("Exception1"+e.getMessage());
}

%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TSCCSH1211ExcelUpload.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TSCC-SH 1211 EXL訂單轉入</font></strong>
<BR>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="8%"><jsp:getProperty name="rPH" property="pgCustomerName"/></td>   
		<td width="46%" style="background-color:#FFFFFF">
		<%
		try
		{
			sql = " SELECT c.customer_id,'('||c.customer_number||') '|| c.customer_name customer_name"+
                  " from  APPS.AR_CUSTOMERS c "+
                  " where c.STATUS='A'"+
                  " and c.customer_number in (4034,14312,8404)"+
                  " order by  '('||c.customer_number||')'||c.customer_name";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(CUSTOMER);
			comboBoxBean.setFieldName("CUSTOMER");	
			comboBoxBean.setFontName("Tahoma,Georgia");  
			comboBoxBean.setOnChangeJS("document.MYFORM.submit()"); 
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}						  
		%>
		</td>
		<td width="8%"><jsp:getProperty name="rPH" property="pgCurr"/></td>   
		<td width="10%" style="background-color:#FFFFFF">
			<INPUT TYPE="text" name ="CURRENCY" value="<%=CURRENCY%>" style="font-size:11px;font-family:Tahoma,Georgia" size="20" readonly>	
		</td>
		<td width="8%"><jsp:getProperty name="rPH" property="pgPriceList"/></td>   
		<td width="20%" style="background-color:#FFFFFF">
			<INPUT TYPE="hidden" name="PRICELISTID" value="<%=PRICELISTID%>">
			<INPUT TYPE="TEXT"   name="PRICELIST" value="<%=PRICELIST%>" style="font-size:11px;font-family:Tahoma,Georgia" size="45" readonly>
		</td>		
	</tr>
	<tr>  
		<td><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></td>   
		<td style="background-color:#FFFFFF">
			<INPUT TYPE="text" SIZE="5" NAME="SHIPTO" VALUE="<%=SHIPTO%>" STYLE="font-size:11px;font-family:Tahoma,Georgia">		
		   	<INPUT TYPE="button" VALUE=".."  onClick='subWindowShipToFind("BILL_TO",this.form.CUSTOMERID.value,this.form.BILLTO.value,this.form.SALESAREANO.value,this.form.BILLADDRESS.value)'>
   			<INPUT TYPE="text" NAME="SHIPADDRESS" SIZE=90 VALUE="<%=SHIPADDRESS%>" STYLE="font-size:11px;font-family:Tahoma,Georgia" readonly> 
   			<INPUT TYPE="text" NAME="SHIPCOUNTRY" SIZE=3 VALUE="<%=SHIPCOUNTRY%>" STYLE="font-size:11px;font-family:Tahoma,Georgia" readonly></td>
		<td><jsp:getProperty name="rPH" property="pgFOB"/></td>   
		<td style="background-color:#FFFFFF">
			<INPUT TYPE="TEXT" name="FOBPOINT" value="<%=FOBPOINT%>" STYLE="font-size:11px;font-family:Tahoma,Georgia" size="20" readonly>
		</td>		
		<td><jsp:getProperty name="rPH" property="pgPaymentTerm"/></td>   
		<td style="background-color:#FFFFFF">
			<INPUT TYPE="hidden" name="PAYMENTTERMID" value="<%=PAYMENTTERMID%>">
			<INPUT TYPE="TEXT" name="PAYMENTTERM" value="<%=PAYMENTTERM%>" STYLE="font-size:11px;font-family:Tahoma,Georgia" size="45" readonly>
		</td>		
	</tr>
	<tr>  
		<td><jsp:getProperty name="rPH" property="pgBillTo"/></td>   
		<td style="background-color:#FFFFFF">
    		<INPUT TYPE="text" SIZE="5" name="BILLTO" VALUE="<%=BILLTO%>" STYLE="font-size:11px;font-family:Tahoma,Georgia">		
		   	<INPUT TYPE="button" VALUE=".."  onClick='subWindowShipToFind("BILL_TO",this.form.CUSTOMERID.value,this.form.BILLTO.value,this.form.SALESAREANO.value,this.form.BILLADDRESS.value)'>
		   	<INPUT TYPE="text" NAME="BILLADDRESS" SIZE=90 VALUE="<%=BILLADDRESS%>" STYLE="font-size:11px;font-family:Tahoma,Georgia" readonly> 
		   	<INPUT TYPE="text" NAME="BILLCOUNTRY" SIZE=3 VALUE="<%=BILLCOUNTRY%>" STYLE="font-size:11px;font-family:Tahoma,Georgia" readonly>
		</td>
		<td>Tax Code</td>   
		<td style="background-color:#FFFFFF">
			<INPUT TYPE="TEXT" name="TAXCODE" value="<%=TAXCODE%>" STYLE="font-size:11px;font-family:Tahoma,Georgia" size="20" readonly>
		</td>		
		<td>Ship to Contact</td>   
		<td style="background-color:#FFFFFF">
			<INPUT TYPE="hidden" name="SHIPTOCONTACTID" value="<%=SHIPTOCONTACTID%>">
			<INPUT TYPE="TEXT" name="SHIPTOCONTACT" value="<%=SHIPTOCONTACT%>" STYLE="font-size:11px;font-family:Tahoma,Georgia" size="45" readonly>
		</td>		

	</tr>	
	<tr>  

	</tr>	
	<tr>
		<td colspan="6" align="center">
			<INPUT TYPE="button" align="middle"  value='上傳匯入' onClick='setSubmit2("../jsp/TSCCSH1211ExcelUploadImport.jsp")' > 
		</td>
	</tr>
</table> 
<HR>
<%
String ORDER[][]=TSCCSHBean.getArray2DContent();
if (ORDER!=null)
{
	String ORDERB[][]=UPDRESBean.getArray2DContent();
	if (Integer.parseInt(ORDERB[0][1])>0)
	{
%>
	<div style="color:#FF0000;font-family:Tahoma,Georgia">共上傳<%=ORDER.length%>筆資料，其中<%=ORDERB[0][1]%>筆資料異常，請確認資料正確性後，再重新上傳，謝謝!</div>
<%
	}
	else
	{
%>
	<div style="color:#0000FF;font-family:Tahoma,Georgia">共上傳<%=ORDER.length%>筆資料，資料檢查無誤，請按<jsp:getProperty name="rPH" property="pgSave"/>鍵產生1211訂單，謝謝!</div>
<%
	}
%>
	<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
		<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:11px" align="center">
			<td width="12%">發票號碼</td>
			<td width="6%">出貨日期</td>
			<td width="10%">客戶PO</td>
			<td width="10%">客戶品號</td>
			<td width="13%">台半品號</td>
			<td width="15%">台半料號</td>
			<td width="5%">數量(PCS)</td>
			<td width="5%">單價(USD)</td>
			<td width="6%">總價</td>
			<td width="18%">檢查結果</td>
		</tr>
<%
	ErrCnt =0;
	for (int k=0 ; k < ORDER.length ; k++)
	{
		out.println("<tr>");
		for (int m=0 ; m < ORDER[k].length; m++)
		{ 
			if (m >9) continue;
			if (m==1)
			{
				out.println("<td align='center'>"+(ORDER[k][m]==null ||ORDER[k][m].equals("")?"&nbsp;":ORDER[k][m])+"</td>");
			}
			else if (m==6 || m==7 || m==8)
			{
				out.println("<td align='right'>"+(ORDER[k][m]==null ||ORDER[k][m].equals("")?"&nbsp;":ORDER[k][m])+"</td>");
			}
			else
			{
				out.println("<td>"+(ORDER[k][m]==null ||ORDER[k][m].equals("")?"&nbsp;":ORDER[k][m]) +"</td>");
			}
			if (m==9 && ORDER[k][m].indexOf("OK")<0) ErrCnt++;
		} 
		out.println("</tr>");
	}
%>
	</table>
<%
	if (ErrCnt ==0)
	{
%>
	 <HR>
	 <table width="100%">
	 	<tr>
			<td align="center">
				<input type="button" name="Submit1" value='<jsp:getProperty name="rPH" property="pgSave"/>' onClick="setSubmit('../jsp/TSCCSH1211ExcelUploadProcess.jsp');">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" name="Cancel1" value='<jsp:getProperty name="rPH" property="pgRFQAborted"/>' onClick="document.MYFORM.submit();">
			</td>
		</td>
	 </table>
<%
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

