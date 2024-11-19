<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function chgObj()
{
	document.MYFORM.SDATE.value = "";
	document.MYFORM.EDATE.value = "";
}
</script>
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
</STYLE>
<title>TEW 出貨編箱查詢</title>
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
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String MO = request.getParameter("MO");
if (MO==null) MO="";
String ADVISE_NO = request.getParameter("ADVISE_NO");
if (ADVISE_NO==null) ADVISE_NO="";
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String VENDOR = request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String ITEMNAME = request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String SHIPPING_METHOD = request.getParameter("SHIPPING_METHOD");
if (SHIPPING_METHOD==null) SHIPPING_METHOD="";
String VENDOR_INVOICE = request.getParameter("VENDOR_INVOICE");
if (VENDOR_INVOICE==null) VENDOR_INVOICE="";
String sql ="",stock_color="",swhere="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWShippingBoxHistoryQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TEW 出貨編箱查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
	<tr>
		<td width="10%" bgcolor="#D3E6F3"  style="color:#006666">出貨日:</td>   
		<td width="21%">
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			&nbsp;~&nbsp;
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>  
	    <td width="10%" bgcolor="#D3E6F3" style="font-family: Tahoma,Georgia;color:#006666">訂單號碼:</td> 
		<td width="13%"><input type="text" name="MO" value="<%=MO%>" style="font-family: Tahoma,Georgia;font-size: 12px" size="20" onKeyPress="chgObj();"></td>
	    <td width="10%" bgcolor="#D3E6F3" style="font-family: Tahoma,Georgia;color:#006666">出貨方式:</td> 
		<td width="13%"><input type="text" name="SHIPPING_METHOD" value="<%=SHIPPING_METHOD%>" style="font-family: Tahoma,Georgia;font-size: 12px" size="20" onKeyPress="chgObj();"></td>
		<td width="10%" bgcolor="#D3E6F3"  style="font-family: Tahoma,Georgia;color:#006666">Advise No:</td>   
		<td width="13%"><input type="text" name="ADVISE_NO" value="<%=ADVISE_NO%>" style="font-family:Tahoma,Georgia; font-size: 12px" size="20"   onKeyPress="chgObj();"></td>
	</tr>
	<tr>
	    <td bgcolor="#D3E6F3" style="font-family: Tahoma,Georgia;color:#006666">客戶號碼或名稱:</td> 
		<td><input type="text" name="CUSTOMER" value="<%=CUSTOMER%>" style="font-family: Tahoma,Georgia;font-size: 12px" size="30"></td>
	    <td bgcolor="#D3E6F3" style="font-family: Tahoma,Georgia;color:#006666">供應商:</td> 
		<td>
		<%
		try
		{
			sql = " select vendor_site_id,vendor_site_code from ap.ap_supplier_sites_all a where exists (select 1 from oraddman.tewpo_receive_header b where b.vendor_site_id=a.vendor_site_id) order by vendor_site_code";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(VENDOR);
			comboBoxBean.setFieldName("VENDOR");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
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
		<td bgcolor="#D3E6F3"  style="color:#006666">供應商發票號碼:</td>   
		<td><input type="text" name="VENDOR_INVOICE" value="<%=VENDOR_INVOICE%>" style="font-family: Tahoma,Georgia;font-size: 12px" size="20" onKeyPress="chgObj();"></td>
		<td bgcolor="#D3E6F3"  style="color:#006666">台半料號或型號:</td>   
		<td><input type="text" name="ITEMNAME" value="<%=ITEMNAME%>" style="font-family: Tahoma,Georgia;font-size: 12px" size="20" onKeyPress="chgObj();"></td>
	</tr>	
</table>
<table border="0" width="100%">
	<tr>
		<td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' style="font-family:Tahoma,Georgia;"  onClick='setSubmit("../jsp/TEWShippingBoxHistoryQuery.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select  b.tew_advise_no advise_no"+
          //",ra.customer_name customer"+
		  ",case when a.to_tw='Y' THEN 'TSCT' ELSE f.region_code END AS region_code "+
		  ",a.SHIPPING_METHOD"+
		  ",c.vendor_site_id"+
		  ",c.vendor_site_code,"+
          "a.to_tw,TO_CHAR(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') SSD,"+
		  "to_char(a.LAST_UPDATE_DATE,'yyyy-mm-dd') LAST_UPDATE_DATE,"+
		  "d.user_name,"+
		  "e.INVOICE_NO,"+
		  "count(1) rowcnt"+
		  " from tsc.tsc_shipping_advise_headers a"+
		  ",tsc.tsc_shipping_advise_lines b"+
		  ",ap.ap_supplier_sites_all c"+
		  ",fnd_user d"+
          ",ap.ap_supplier_sites_all ass"+
          ",AR_CUSTOMERS ra"+
		  ",apps.TSC_VENDOR_INVOICE_LINES e"+
		  ",(select tew_advise_no,region_code from  (select tew_advise_no,region_code,row_number() over (partition by  tew_advise_no order by region_code) row_cnt FROM tsc.tsc_shipping_advise_lines where tew_advise_no is not null) x where row_cnt=1) f"+
 		  " where a.advise_header_id = b.advise_header_id"+
		  " and b.vendor_site_id = c.vendor_site_id"+
		  " and a.LAST_UPDATED_BY= d.user_id(+)"+
		  " and b.vendor_site_id = ass.vendor_site_id"+
		  " and a.CUSTOMER_ID = ra.CUSTOMER_ID"+
		  " and b.tew_advise_no = e.tew_advise_no(+)"+
		  " and b.tew_advise_no = f.tew_advise_no(+)"+
		  " ?01"+
		  " and a.shipping_from =?"+ 
		  " group by  b.tew_advise_no,case when a.to_tw='Y' THEN 'TSCT' ELSE f.region_code END,a.SHIPPING_METHOD,c.vendor_site_id,c.vendor_site_code,a.to_tw,TO_CHAR(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd'),to_char(a.LAST_UPDATE_DATE,'yyyy-mm-dd') ,d.user_name,e.INVOICE_NO"+
		  " order by b.tew_advise_no";
	if (!SDATE.equals(""))
	{
		swhere += " and b.PC_SCHEDULE_SHIP_DATE >= TO_DATE('"+SDATE+"','yyyymmdd')";
	}
	if (!EDATE.equals(""))
	{
		swhere += " and b.PC_SCHEDULE_SHIP_DATE<= TO_DATE('"+EDATE+"','yyyymmdd')";
	}
	if (!MO.equals(""))
	{
		swhere += " and b.SO_NO like '"+MO+"%'";
	}
	if (!ADVISE_NO.equals(""))
	{
		swhere += " and b.tew_ADVISE_NO like '"+ADVISE_NO+"%'";
	}
	if (!ITEMNAME.equals(""))
	{
		swhere += " and (b.ITEM_NO like '"+ITEMNAME +"%' OR b.ITEM_DESC like '"+ ITEMNAME+"%')";
	}
	if (!CUSTOMER.equals(""))
	{
		swhere += " AND RA.CUSTOMER_NAME_PHONETIC like '"+CUSTOMER+"%' ";
	}
	if (!VENDOR.equals("") && !VENDOR.equals("--"))
	{
		swhere += " and ass.vendor_site_id = '"+VENDOR+"'";
	}
	if (!SHIPPING_METHOD.equals(""))
	{
		swhere += " and a.SHIPPING_METHOD='"+SHIPPING_METHOD+"'";
	}
	if (!VENDOR_INVOICE.equals(""))
	{
		swhere += " and e.INVOICE_NO ='" +VENDOR_INVOICE +"'";
	}
	if (swhere.equals(""))
	{
		/*
		String sql2 = " SELECT TO_CHAR(EDATE-5,'yyyymmdd') AS SDATE,to_char(EDATE,'yyyymmdd') EDATE"+
			  " FROM ( select case when to_char(max(tsa.PC_SCHEDULE_SHIP_DATE),'D')=6 THEN max(tsa.PC_SCHEDULE_SHIP_DATE) "+
			  " when to_char(max(tsa.PC_SCHEDULE_SHIP_DATE),'D')=7 THEN max(tsa.PC_SCHEDULE_SHIP_DATE)-1"+
			  " ELSE next_day(max(tsa.PC_SCHEDULE_SHIP_DATE),6) END AS EDATE"+
			  " FROM tsc.tsc_shipping_advise_lines tsa,tsc.tsc_shipping_advise_headers tsh"+
			  " where tsa.advise_header_id = tsh.advise_header_id and tsh.shipping_from ='TEW')";
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(sql2);
		if (rs1.next())
		{
			if (!rs1.getString(1).equals(""))
			{
				swhere += " and b.PC_SCHEDULE_SHIP_DATE >= TO_DATE('"+rs1.getString(1)+"','yyyymmdd')";
				out.println("<script language='javascript'>");
				out.println("document.MYFORM.SDATE.value ="+rs1.getString(1)+";");
				out.println("</script>");					
			}
			if (!rs1.getString(2).equals(""))
			{
				swhere += " and b.PC_SCHEDULE_SHIP_DATE <= TO_DATE('"+rs1.getString(2)+"','yyyymmdd')";
				out.println("<script language='javascript'>");
				out.println("document.MYFORM.EDATE.value ="+rs1.getString(2)+";");
				out.println("</script>");					
			}
		}
		rs1.close();
		statement1.close();
		*/
		dateBean.setAdjDate(-7);
		SDATE = dateBean.getYearMonthDay();
		dateBean.setAdjDate(7);
		swhere += " and b.PC_SCHEDULE_SHIP_DATE >= TO_DATE('"+SDATE+"','yyyymmdd')";
		out.println("<script language='javascript'>");
		out.println("document.MYFORM.SDATE.value ="+SDATE+";");
		out.println("</script>");					
	}
	sql = sql.replace("?01",swhere);
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"TEW");
	ResultSet rs=statement.executeQuery();
	while (rs.next())
	{
		if (iCnt ==0)
		{	
		%>
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#FFFFFF"  bordercolordark="#5C7671">
			<tr bgcolor="#C9E2D0"> 
				<td width="3%">項次</td>
				<td width="8%" align="center">Advise No</td>
				<!--<td width="17%" align="center">嘜頭</td>-->
				<td width="8%" align="center">供應商</td>
				<td width="7%" align="center">業務區</td>
				<td width="12%" align="center">出貨方式</td>
				<td width="8%" align="center">排定出貨日</td>
				<!--<td width="5%" align="center">幣別</td>-->
				<td width="5%" align="center">回T</td>
				<td width="8%" align="center">供應商發票號碼</td>
				<td width="5%" align="center">出貨筆數</td>
				<td width="10%" align="center">編箱人員</td>
				<td width="8%" align="center">編箱日期</td>
			</tr>
		<% 
		}
    	%>
		<tr  id="tr_<%=iCnt%>" bgcolor="#E4EDE2" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#E7F1EB';style.color='#000000';this.style.fontWeight='normal'" title="按下Advise No,可查看編箱明細資訊">
			<td align="left"><%=(iCnt+1)%></td>
			<td align="center"><a href="../jsp/TEWShippingBoxConfirm.jsp?ATYPE=Q&ADVISE_NO=<%=rs.getString("ADVISE_NO")%>"><%=rs.getString("ADVISE_NO")%></A></td>
			<td><%=rs.getString("VENDOR_SITE_CODE")%><input type="hidden" name="VENDOR_SITE_ID_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("vendor_site_id")%>"></td>
			<td><%=rs.getString("REGION_CODE")%><input type="hidden" name="REGION_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("REGION_CODE")%>"></td>
			<td align="center"><%=rs.getString("SHIPPING_METHOD")%><input type="hidden" name="SHIPPING_METHOD_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("SHIPPING_METHOD")%>"></td>
			<td align="center"><%=rs.getString("SSD")%><input type="hidden" name="SSD_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("SSD")%>"></td>
			<td align="center"><%=(rs.getString("TO_TW").equals("Y")?"是":"否")%><input type="hidden" name="TO_TW_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("TO_TW")%>"></td>
			<td align="center"><%=(rs.getString("INVOICE_NO")==null?"&nbsp;":rs.getString("INVOICE_NO"))%><input type="hidden" name="INVOICE_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("INVOICE_NO")%>"></td>
			<td align="right"><%=rs.getString("rowcnt")%></td>
			<td align="center"><%=rs.getString("user_name")%></td>
			<td align="center"><%=rs.getString("LAST_UPDATE_DATE")%></td>
		</tr>
<%
		iCnt++;
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
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
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

