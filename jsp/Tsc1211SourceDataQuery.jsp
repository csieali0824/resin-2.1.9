<!-- 20150129 by Peggy,新增P/L list報表下載功能-->
<!-- 20160805 by Peggy,add customer query condition-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
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
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>New BufferNet原始資料查詢</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeane" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript">
function setsubmit(URL)
{  
	if ((document.form1.packingnumber.value == null || document.form1.packingnumber.value =="") && 
	     (document.form1.sdate.value == null || document.form1.sdate.value =="") && 
	     (document.form1.edate.value == null || document.form1.edate.value =="") && 
		  (document.form1.cust.value == null || document.form1.cust.value ==""))
	{
		alert("請輸入查詢條件!!");
		return false;
	}
	var sdate = document.form1.sdate.value;
	var edate = document.form1.edate.value;
	if (sdate.length >0 && sdate.length <8)
	{
		alert("日期格式錯誤,請重新輸入!!");
		document.form1.sdate.focus;
		return false;
	}
	if (edate.length >0 && edate.length <8)
	{
		alert("日期格式錯誤,請重新輸入!!");
		document.form1.edate.focus;
		return false;
	}
	if ((document.form1.cust.value == null || document.form1.cust.value =="") && sdate.length >0 && edate.length >0 )
	{
		sdate = sdate.substr(0,4) +"/"+sdate.substr(4,2) +"/"+ sdate.substr(6,2);
		edate = edate.substr(0,4) +"/"+edate.substr(4,2) +"/"+ edate.substr(6,2);
		var days = parseInt(((new Date(edate)).getTime()-(new Date(sdate)).getTime()) / (1000 * 60 * 60 * 24));
		if (days > 60)
		{
			alert("查詢天數範圍最多60天,請縮小日期範圍後再查詢,謝謝!");
			return false;
		}
	}
	document.form1.action=URL;
	document.form1.submit(); 
}
function setExportXLS(URL)
{    
	if (document.form1.sdate.value =="")
	{
		alert("Please enter a start date!");
		document.form1.sdate.focus(); 
		return false;
	}
	else if (document.form1.edate.value =="")
	{
		alert("Please enter a end date!");
		document.form1.edate.focus(); 
		return false;
	}
	document.form1.action=URL;
 	document.form1.submit();
}
</script>
<%
String packingnumber = request.getParameter("packingnumber");
if (packingnumber == null) packingnumber = "";
String sdate = request.getParameter("sdate");
String edate = request.getParameter("edate");
if (sdate == null)
{
	dateBeans.setAdjDate(-15);
	sdate = dateBeans.getYearMonthDay();
}
if (edate == null)	edate  = dateBeane.getYearMonthDay();
String cust=request.getParameter("cust");  //add by Peggy 20160805
if (cust==null) cust="";
%>
</head>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<body>
<form name="form1" method="post" action="Tsc1211SourceDataQuery.jsp">
 <iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
	<tr><td><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">New BufferNet </font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> Source Data Query </strong></font></p><td></tr>
	<tr><td> <%@ include file="Tsc1211head.jsp"%></td></tr>
 	<tr>
		<td>
			<table cellSpacing="0" borderColorDark="#aaaaaa"  cellPadding="0" width="100%" align="left" borderColorLight="#ffffff" border="1">
  				<tr >
    				<td colspan="8" bgcolor="#CCCC99" class="tableTitle" ><span class="style1"><font face='Arial'  size="2">查詢條件:</font></span></td>
    			</tr>
  				<tr>
					<td width="15%" bgcolor="#CCCC99" class="tableTitle">PackingNumber(or Customer PO)</td>
					<td width="10%"><input type="text" name="packingnumber" size="20" value="<%=packingnumber%>" style="font-family: Tahoma,Georgia;"></td>
					<td width="10%" bgcolor="#CCCC99" class="tableTitle">資料匯入開始日期</td>
					<td width="8%"><input name="sdate" type="text" id="sdate" size="8" value="<%=sdate%>" style="font-family: Tahoma,Georgia;"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.sdate);return false;'><IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></td>
					<td width="10%" bgcolor="#CCCC99" class="tableTitle">資料匯入結束日期</td>
					<td width="8%"><input name="edate" type="text" id="edate" size="8" value="<%=edate%>" style="font-family: Tahoma,Georgia;"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.edate);return false;'><IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></td>
					<td width="8%" bgcolor="#CCCC99" class="tableTitle">Customer Number/Name</td>
					<td width="8%"><input name="cust" type="text" id="cust" size="8" value="<%=cust%>" style="font-family: Tahoma,Georgia;"></td>
				</tr>
				<tr>
					<td width="20%" align="center" colspan="8"><input name="search" type="button" id="search" value="Search" style="font-family:arial" onClick="setsubmit('Tsc1211SourceDataQuery.jsp')">					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;							
				  <input name="excel" type="button" id="excel" value="Export To Excel" style="font-family:arial" onClick='setExportXLS("../jsp/Tsc1211EmailNotice.jsp?RTYPE=SOURCE")'>				  </td></tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
<table width="1500"   bordercolordark="#CCCC99" border="1" cellpadding="0" cellspacing="1" class="innTable" bordercolorlight="#ffffff"  background="#334455">
	<tr bgcolor="#CCCC99" >
		<td width="8%">Customer Name</td>
		<td width="12%">ERP Customer Name</td>
		<td width="6%">PackingListNumber</td>
		<td width="6%">CustomerPO</td>
		<td width="6%">P/L Date</td>
		<td width="3%">Ship to ID</td>
		<td width="10%">Ship to</td>
		<td width="3%">Bill to ID</td>
		<td width="10%">Bill to</td>
		<td width="5%">Carton NO</td>
		<td width="7%">Awb</td>
		<td width="7%">Invoice</td>
		<td width="7%">Customer P/N</td>
		<td width="7%">TSC P/N</td>
		<td width="7%">Shipment Term</td>
		<td width="5%">Quantity</td>
		<td width="5%">Price</td>
		<td width="5%">Currency</td>
	</tr>
<%
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
	cs1.execute();
	cs1.close();	

	try
	{
		//String sql = " SELECT a.packinglistnumber, to_char(a.packinglistdate,'yyyy-mm-dd') packinglistdate,  a.cartonnumber, a.awb, a.invoicenumber, a.customerpo, a.customerproductnumber,"+
		//			 " a.quantity, a.price, a.customer_name, a.tsc_prod_description, a.shipmentterm,'('||a.BILLTOADDRESSID||')' || REPLACE(b.CUSTOMER_NAME,'\''',' ') erp_customer "+
		//			 " FROM tsc_packinglist_data a ,APPS.AR_CUSTOMERS  b where a.BILLTOADDRESSID=b.CUSTOMER_NUMBER(+) ";
		//shiptoaddressid改存ship_site_use_id,billtoaddressid改存bill_site_use_id,modify by Peggy 20130530
		String sql = " SELECT a.packinglistnumber, to_char(a.packinglistdate,'yyyy-mm-dd') packinglistdate,  a.cartonnumber, a.awb, a.invoicenumber, a.customerpo, a.customerproductnumber,"+
					 " a.quantity, a.price, a.customer_name, a.tsc_prod_description, a.shipmentterm,a.erp_customer "+
					 " ,a.SHIPTOADDRESSID,a.BILLTOADDRESSID"+//add by Peggy 20131118
					 ", a.shipto ,a.billto"+              //add by Peggy 20140115
					 ",a.CURRENCY"+    //add by Peggy 20140225
					 " from (SELECT a.packinglistnumber, a.packinglistdate,  a.cartonnumber, a.awb, a.invoicenumber, a.customerpo, a.customerproductnumber,"+
					 " a.quantity, a.price, a.customer_name, a.tsc_prod_description, a.shipmentterm,'('||a.BILLTOADDRESSID||')' || REPLACE(b.CUSTOMER_NAME,'\''',' ') erp_customer "+
					 ",a.SHIPTOADDRESSID,a.BILLTOADDRESSID"+ //add by Peggy 20131118
					 ",'' shipto ,'' billto"+                //add by Peggy 20140115
					 ",a.CURRENCY"+ //add by Peggy 20140225
					 ",a.CREATION_DATE"+  //add by Pegy 20150129					 
					 " FROM tsc_packinglist_data a ,APPS.AR_CUSTOMERS  b "+
					 " where a.BILLTOADDRESSID=b.CUSTOMER_NUMBER(+) "+
					 " and trunc(a.CREATION_DATE) < to_date('2013-06-04','yyyy-mm-dd')"+
					 " union all"+
					 " SELECT a.packinglistnumber, a.packinglistdate,  a.cartonnumber, a.awb, a.invoicenumber, a.customerpo, a.customerproductnumber,"+
					 " a.quantity, a.price, a.customer_name, a.tsc_prod_description, a.shipmentterm,"+
					 " '('||d.customer_number||')' || REPLACE(d.CUSTOMER_NAME,''\'',' ') erp_customer "+
					 ",a.SHIPTOADDRESSID,a.BILLTOADDRESSID"+ //add by Peggy 20131118
					 ",(select loc.ADDRESS1 from AR_SITE_USES_V asuv,HZ_CUST_ACCT_SITES hcas, hz_party_sites party_site, hz_locations loc"+
					 " where  asuv.ADDRESS_ID = hcas.cust_acct_site_id"+
                     " AND hcas.party_site_id = party_site.party_site_id"+
                     " AND loc.location_id = party_site.location_id "+
					 " and asuv.STATUS='A' "+
				 	 " and asuv.SITE_USE_ID = a.SHIPTOADDRESSID ) shipto"+   //add by Peggy 20140115
					 ",(select loc.ADDRESS1 from AR_SITE_USES_V asuv,HZ_CUST_ACCT_SITES hcas, hz_party_sites party_site, hz_locations loc"+
					 " where  asuv.ADDRESS_ID = hcas.cust_acct_site_id"+
                     " AND hcas.party_site_id = party_site.party_site_id"+
                     " AND loc.location_id = party_site.location_id "+
					 " and asuv.STATUS='A' "+
				 	 " and asuv.SITE_USE_ID = a.BILLTOADDRESSID ) billto"+	  //add by Peggy 20140115				 
					 ",a.CURRENCY"+   //add by Peggy 20140225
					 ",a.CREATION_DATE"+  //add by Pegy 20150129
					 " FROM tsc_packinglist_data a ,hz_cust_site_uses_all b,HZ_CUST_ACCT_SITES_all c,APPS.AR_CUSTOMERS d"+
					 " where a.BILLTOADDRESSID=b.site_use_id(+)"+
					 " and b.cust_acct_site_id=c.cust_acct_site_id(+)"+
					 " and c.cust_account_id=d.CUSTOMER_ID(+)"+
					 " and trunc(a.CREATION_DATE) >= to_date('2013-06-04','yyyy-mm-dd')"+
					 ") a where 1=1 ";
		//if (!sdate.equals("")) sql += " and a.packinglistdate >= to_date('"+sdate+"','yyyy-mm-dd')";
		//if (!edate.equals("")) sql += " and a.packinglistdate <= to_date('"+edate+"','yyyy-mm-dd')";
		if (!sdate.equals("")) sql += " and a.CREATION_DATE >= to_date('"+sdate+"','yyyy-mm-dd')";
		if (!edate.equals("")) sql += " and a.CREATION_DATE <= to_date('"+edate+"','yyyy-mm-dd')+0.99999";
		if (!packingnumber.equals("")) sql += " and packinglistnumber ='" + packingnumber+"'";
		if (!cust.equals("")) sql += " and erp_customer like '%"+cust+"%'"; //add by Peggy 20160805
		sql += " order by a.packinglistdate,customer_name,packinglistnumber,customerpo";
		//out.println(sql);
		Statement st=con.createStatement();
		ResultSet rs=st.executeQuery(sql);
		while(rs.next())
		{
			out.println("<tr>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("customer_name")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("erp_customer")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("packinglistnumber")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("customerpo")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial' align='center'>"+rs.getString("packinglistdate")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("SHIPTOADDRESSID")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("SHIPTO")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("BILLTOADDRESSID")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("BILLTO")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("cartonnumber")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("awb")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial' align='center'>"+rs.getString("invoicenumber")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("customerproductnumber")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("tsc_prod_description")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial'>"+rs.getString("shipmentterm")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial' align='right'>"+rs.getString("quantity")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial' align='right'>"+rs.getFloat("price")+"</td>");
			out.println("<td style='font-size:11px;font-family:arial' align='center'>"+(rs.getString("currency")==null?"&nbsp;":rs.getString("currency"))+"</td>"); //add by Peggy 20140225
			out.println("</tr>");
		}
		rs.close();
		st.close();
	}
	catch(Exception e)
	{
		out.println(e.getMessage());
	}
%>
</table>
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
