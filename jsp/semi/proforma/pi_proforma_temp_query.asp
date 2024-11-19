<%
'if session("login")="" or session("password")="" or ( session("org") <> "TSCE" and  session("org") <> "TSCAER" and  session("org") <> "ALL")   then
'   response.redirect "http://intranet.ts.com.tw/"
'end if
%>
<html>
<!-- #include file="head.asp" -->
<!-- #include file="public/public.asp" -->
<!-- #include file="public/default_value.asp" -->


<%
 

%>
<body>
 
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<table width="770" align="center">
	<tr align="center" >
	  <td><font face="Arial" size="+2"> Query Invoice Interface</font></td>
	</tr>
</table>

<form name="form1" method="post" action="pi_proforma_temp_query.asp">

<!-- #include file="link.asp" -->
<br>
<br>
  <table width="770"  border="1" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td bgcolor="#00CC00" class="tableTitle" ><font face="Arial" size="2">pi_seqno</font></td>
      <td><font face="Arial" size="2"><input name="q_pi_seqno" type="text" id="q_pi_seqno" size="15" value="">
      </font></td>
      <td bgcolor="#00CC00" class="tableTitle" ><font face="Arial" size="2">Customer name</font></td>
      <td colspan="4"><select name="q_cust_name" id="q_cust_name"  >
	  <option value="">All</option>
<%	
 
%>
      </select></td>
    </tr>
    <tr>
      <td bgcolor="#00CC00" class="tableTitle" width="77" >Status</td>
      <td width="115"><select name="q_status" id="q_status"   >
        <option value="0" >0.None</option>
        <option value="1">1.Shipping Conform</option>
        <option value="2">2.CN Confirm</option>
        <option value="3">3.Branch Confirm</option>
        <option value="4">4.Closed</option>
      </select></td>
      <td bgcolor="#00CC00" class="tableTitle" width="99" ><font face="Arial" size="2">Begin time</font></td>
      <td width="159"><input name="q_begin_date" type="text" id="q_begin_date" size="15" readonly value= <% =q_begin_date %>  > <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.q_begin_date);return false;'><IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></td>
      <td bgcolor="#00CC00" class="tableTitle" width="66" ><font face="Arial" size="2">End Time</font></td>
      <td width="176"><font face="Arial" size="2"><input name="q_end_date" type="text" id="q_end_date" size="15" readonly value= <% =q_end_date %> > <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.q_end_date);return false;'><IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></font></td>
    <td width="62"><font face="Arial" size="2"> <input name="search" type="submit" id="search" value="search"></font></td>
    </tr>
  </table>
  <p>&nbsp;</p>
  <table width="770" border="1" align="center" cellpadding="0" cellspacing="0">
	<tr bgcolor="#00CC00" class="tableTitle"> 
	  <td width="5%">&nbsp;</td>
      <td width="15%"><font face="Arial" size="2">Order Number </font></td>
      <td width="15%">Customer PO</td>
      <td width="30%"><font size="2" face="Arial">Customer Name </font></td>
      <td width="20%"><font face="Arial" size="2">Schedule Ship Date </font></td>
      <td width="15%"><font size="2" face="Arial">Shipping_Methed</font></td>

	</tr>
<%
q_status ="0"
if q_status <> "0"  then  

%>
	<tr>
		<td colspan="7" align="center">Not Data!!</td>
	</tr>

<%  
else 

	'sql = "select * from tsc_euro_co_header tech ,tsc_euro_co_upload tecu "&_
		'  "where tech.doc_id =  tecu.doc_id and tecu.is_newest = 'Y' and tech.confirm ='" & q_status & "'  " & co_number & " "&_
		 ' "and  " & q_date & "  between  '" & q_begin_date & "' and '" & q_end_date & "' "

	'sql = 	"select * from tsc_cust_po_header a,tsc_cust_po_upload b " &_
	
	sql  = " select * from tsc_proforma_invoice_temp pit "
			 '"where pit.order_number is not null " &_
			 ' str_q_pi_seqno &_
			' str_q_begin_date &_
			' str_q_status &_
			' str_q_cust_name &_
			' " order by 4,2,1 desc"
			 
			 
		  	'"where tih.invoice_no = "& customer_name & " &_
			'" and b.is_newest='Y'" &_
			' str_q_cust_no &_
			' str_q_num &_
			' str_q_begin_date &_
			' str_q_status &_
			' " order by a.doc_id desc"
			'order  by invoice_no asc "'
			 
			 'response.Write("sql = " +sql)
			 'response.End()
			 

	'Set conn = Server.CreateObject("ADODB.Connection")
	'Set rs = Server.CreateObject("ADODB.Recordset")
	'conn.open db_connection_str
	'rs.open sql,conn,3,3
	Set rs2 = Ora_conn.execute(sql)
 
	
	If not rs2.eof Then 
		while not rs2.eof 
			show_order_number 			=	rs2("order_number")
			show_cust_po_number 		=	rs2("cust_po_number")
			show_date    				=	rs2("schedule_ship_date")
			show_shipping_method_code	=	rs2("shipping_method_code")
			show_customer_name			=	rs2("customer_name")
 
			'show_remarks			=	rs("remarks")
			'show_link				=	rs("file_link")
					
%>
	<tr>
		<td><div align="center">
		  <input type="checkbox" name="checkbox" value="checkbox">
		</div></td>
		<td><font face="Arial" size="2"><%=show_order_number%></font></td>
		<td><font face="Arial" size="2"><%=show_cust_po_number%></font></td>
		<td><font face="Arial" size="2"><%=show_customer_name%></font></td>
		<td><font face="Arial" size="2"><%=show_date%></font></td>
		<td align="right"><font face="Arial" size="2"><%=show_shipping_method_code%></font></td>

		<% 'end if%>
   	</tr>
<% 
	rs2.movenext
	wend
%>



<% 
	rs2.close						
	Set rs2 = nothing
	Ora_conn.close
	Set Ora_conn = nothing
%>
<% else %>
	<tr>
		<td colspan="6" align="center"><font face="Arial" size="2">Not Data!!</font></td>
	</tr>
<% 	end if %>
<% 	end if %>

</table>
</form>
</table>
</body>
</html>
