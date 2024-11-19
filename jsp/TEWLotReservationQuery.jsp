<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setSubmit1(URL)
{
	if (confirm("您確定要刪除預約批號分配資料嗎?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
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
<title>TEW Reservation Query</title>
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
String MONO = request.getParameter("MONO");
if (MONO==null) MONO="";
String LOT = request.getParameter("LOT");
if (LOT==null) LOT="";
String ITEM=request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String ADVISENO1 = request.getParameter("ADVISENO1");
if (ADVISENO1==null) ADVISENO1="";
String DATECODE = request.getParameter("DATECODE");
if (DATECODE==null) DATECODE="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String sql ="",stock_color="",swhere="";
int exist_cnt=0,iCnt = 0;

if (TRANSTYPE.equals("CANCEL") && !ID.equals(""))
{
	try
	{
		sql = " select count(1) from oraddman.tew_lot_allot_detail x "+
		      " where exists (select 1 from oraddman.tew_lot_reservation_detail a where  x.advise_line_id=a.advise_line_id and x.carton_num=a.carton_num and x.SEQ_ID=a.SEQ_ID"+
		      " and a.RESERVATION_ID="+ID+")";
		//out.println(sql);
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(sql);
		if (rs1.next())
		{
			exist_cnt=rs1.getInt(1);
		}
		rs1.close();
		statement1.close();			  
		
		if (exist_cnt ==0)
		{	  
			sql = " delete oraddman.tew_lot_reservation_detail a"+
				  " where RESERVATION_ID=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,ID);
			pstmtDt.executeUpdate();
			pstmtDt.close();
			
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("資料刪除成功!");
			</script>	
	<%	
		}
		else
		{
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("資料刪除失敗!預約資料已完成批號分配,不允許刪除!");
			</script>	
	<%			
		}
	}
	catch(Exception e)
	{
%>
		<script language="JavaScript" type="text/JavaScript">
			alert("資料刪除失敗,請洽系統管理人員!");
		</script>
<%
	}
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWLotReservationQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TEW 預約批號分配</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
	    <td width="7%" bgcolor="#669966" style="font-weight:bold;color:#ffffff">Advise No:</td> 
		<td width="9%"><input type="text" name="ADVISENO1" value="<%=ADVISENO1%>" style="font-family: Tahoma,Georgia;font-size:12px" size="13" onChange="chgObj(this.form.ADVISENO1.value);"></td>
		<td width="7%" bgcolor="#669966"  style="font-weight:bold;color:#ffffff">台半型號:</td>   
		<td width="10%"><input type="text" name="ITEM" value="<%=ITEM%>" style="font-family: Tahoma,Georgia; font-size: 12px " size="15" onChange="chgObj(this.form.ITEM.value);"></td>
		<td width="6%" bgcolor="#669966"  style="font-weight:bold;color:#ffffff">LOT:</td>   
		<td width="7%"><input type="text" name="LOT" value="<%=LOT%>" style="font-family: Tahoma,Georgia; font-size:12px" size="12" onChange="chgObj(this.form.LOT.value);"></td>  		
		<td width="6%" bgcolor="#669966"  style="font-weight:bold;color:#ffffff">Date Code:</td>   
		<td width="7%"><input type="text" name="DATECODE" value="<%=DATECODE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="10" onChange="chgObj(this.form.DATECODE.value);"></td>  		
	    <td width="7%" bgcolor="#669966" style="font-weight:bold;color:#ffffff">訂單號碼:</td> 
		<td width="9%"><input type="text" name="MONO" value="<%=MONO%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="chgObj(this.form.MONO.value);"></td>
	    <td width="7%" bgcolor="#669966" style="font-weight:bold;color:#ffffff">異動日:</td> 
		<td width="18%">
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			&nbsp;~&nbsp;
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td> 
	</tr>
</table>
<BR>
<div align="center"><INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TEWLotReservationQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='預約批號分配'  style="font-family:ARIAL" onClick='setSubmit("../jsp/TEWLotReservation.jsp")' > 
</div>
<hr>
<%
try
{       
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();
	
	sql = " select a.reservation_id"+
	      ",b.tew_advise_no"+
	      ",nvl(g.customer_name_phonetic,g.customer_name) customer_name"+
		  ",b.advise_header_id"+
		  ",a.advise_line_id"+
		  ",b.item_desc"+
		  ",DECODE (h.item_identifier_type,'CUST', h.ordered_item,'') cust_partno"+
		  ",b.po_no"+
		  ",b.so_no"+
		  ",a.carton_num"+
		  ",a.lot_number"+
		  ",c.date_code"+
		  ",sum(decode(a.RESERVATION_UOM,'KPC',a.RESERVATION_QTY*1,a.RESERVATION_QTY/1000)) RESERVATION_QTY"+
		  ",'KPC' AS RESERVATION_UOM"+
		  ",a.PO_NO PO"+
		  ",e.vendor_site_code"+
		  ",a.LAST_UPDATED_BY"+
		  ",to_char(MAX(a.LAST_UPDATE_DATE),'yyyy/mm/dd hh24:mi') LAST_UPDATE_DATE"+
		  ",A.STATUS"+
          ",(select count(1) from oraddman.tew_lot_allot_detail x where x.advise_line_id=a.advise_line_id and x.carton_num=a.carton_num and x.SEQ_ID=a.SEQ_ID) allot_count"+
          " from oraddman.tew_lot_reservation_detail a"+
          " ,tsc.tsc_shipping_advise_lines b"+ 
          " ,oraddman.tewpo_receive_detail c"+
          " ,oraddman.tewpo_receive_header d"+
          " ,ap_supplier_sites_all e"+
          " ,ont.oe_order_headers_all f"+
          " ,ar_customers g"+
          " ,ont.oe_order_lines_all h"+
          " where a.advise_line_id=b.advise_line_id "+
          " and a.seq_id=c.seq_id "+
          " and c.po_line_location_id=d.po_line_location_id"+
          " and d.vendor_site_id=e.vendor_site_id "+
          " and a.so_header_id=f.header_id"+
          " and f.sold_to_org_id=g.customer_id"+
          " and b.so_line_id=h.line_id"+
          " and a.CREATION_DATE >= to_date('20150701','yyyymmdd')"; //此功能7/1上線,先前交易都是人工寫入故不顯示
	if (!ADVISENO1.equals(""))
	{
		swhere += " AND b.tew_advise_no like '"+ ADVISENO1+"%'";
	}
	if (!MONO.equals(""))
	{
		swhere += " AND b.so_no = '"+ MONO+"'";
	}	
	if (!LOT.equals(""))
	{
		swhere += " AND a.lot_number ='" + LOT+"'";
	}
	if (!ITEM.equals(""))
	{
		swhere += " AND UPPER(b.item_desc) LIKE '"+ITEM.toUpperCase()+"%'";
	}
	if (!DATECODE.equals(""))  
	{
		swhere += " AND c.date_code LIKE '"+ DATECODE +"%'";
	}
	if (!SDATE.equals(""))
	{
		swhere += " and a.LAST_UPDATE_DATE >= TO_DATE('"+SDATE+"','yyyymmdd')";
	}
	if (!EDATE.equals(""))
	{
		swhere += " and a.LAST_UPDATE_DATE <= TO_DATE('"+EDATE+"','yyyymmdd')";
	}	
	if (swhere.equals(""))
	{
		dateBean.setAdjDate(-14);
		swhere += " and a.LAST_UPDATE_DATE >= TO_DATE('"+dateBean.getYearMonthDay()+"','yyyymmdd')";
		out.println("<script language='javascript'>");
		out.println("document.MYFORM.SDATE.value ="+dateBean.getYearMonthDay()+";");
		out.println("</script>");			
		dateBean.setAdjDate(14);
	}
	sql += swhere+ " group by a.reservation_id,b.tew_advise_no,g.customer_name_phonetic,g.customer_name,b.advise_header_id,a.advise_line_id,b.item_desc,b.po_no,b.so_no,a.carton_num,a.lot_number,a.PO_NO,a.LAST_UPDATED_BY,A.STATUS,c.date_code,e.vendor_site_code,h.item_identifier_type,h.ordered_item,a.seq_id"+
           " order by b.tew_advise_no,a.carton_num,a.lot_number";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	String destination="";
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
			<tr bgcolor="#86A68B" style="color:#FFFFFF"> 
				<td width="2%" align="center">&nbsp;</td>
				<td width="6%" align="center">Advise No</td>
				<td width="12%" align="center">客戶</td>
				<td width="7%" align="center">MO單號</td>
				<td width="10%" align="center">型號</td>            
				<td width="10%" align="center">客戶品號</td>            
				<td width="9%" align="center">客戶PO</td>            
				<td width="3%" align="center">箱號</td>            
				<td width="6%" align="center">LOT</td>            
				<td width="4%" align="center">D/C</td>
				<td width="4%" align="center">數量(K)</td>            
				<td width="6%" align="center">採購單號</td>            
				<td width="7%" align="center">供應商</td>
				<td width="8%" align="center">異動日</td>
				<td width="6%" align="center">異動人員</td>
			</tr>
		<% 
		}
		%>
		<tr  id="tr_<%=iCnt%>" bgcolor="#EEFCFF" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#EEFCFF';style.color='#000000';this.style.fontWeight='normal'">
			<td><%=(rs.getInt("allot_count")>0?"&nbsp;":"<input type='button' name='del"+rs.getString("RESERVATION_ID")+"' value='刪除' style='font-family: Tahoma,Georgia; font-size: 11px' onClick='setSubmit1("+'"'+"../jsp/TEWLotReservationQuery.jsp?TRANSTYPE=CANCEL&ID="+rs.getString("RESERVATION_ID")+'"'+")'>")%></td>
			<td align="center"><%=rs.getString("tew_advise_no")%></td>
			<td align="left"><%=rs.getString("CUSTOMER_NAME")%></td>
			<td align="center"><%=rs.getString("so_no")%></td>
			<td><%=rs.getString("ITEM_DESC")%></td>
			<td><%=(rs.getString("CUST_PARTNO")==null?"&nbsp;":rs.getString("CUST_PARTNO"))%></td>
			<td><%=(rs.getString("PO_NO")==null?"&nbsp;":rs.getString("PO_NO"))%></td>
			<td align="center"><%=rs.getString("CARTON_NUM")%></td>
			<td><%=rs.getString("LOT_NUMBER")%></td>
			<td><%=rs.getString("DATE_CODE")%></td>
			<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("RESERVATION_QTY")))%></td>
			<td align="center"><%=(rs.getString("PO")==null?"&nbsp;":rs.getString("PO"))%></td>
			<td align="center"><%=(rs.getString("VENDOR_SITE_CODE")==null?"&nbsp;":rs.getString("VENDOR_SITE_CODE"))%></td>
			<td align="center"><%=rs.getString("LAST_UPDATE_DATE")%></td>
			<td><%=rs.getString("LAST_UPDATED_BY")%></td>
		</tr>
<%
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
	
	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();		
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

