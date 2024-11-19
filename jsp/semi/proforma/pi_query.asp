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
    'q_status ="0"
   	q_pi_seqno			= 	SqlStr(Request.Form("q_pi_seqno"))
	q_begin_date			=	SqlStr(Request.Form("q_begin_date"))
	q_end_date				=	SqlStr(Request.Form("q_end_date"))
	q_status				=	SqlStr(Request.Form("q_status"))
	q_cust_name				=	SqlStr(Request.Form("q_cust_name"))
	
	
		if q_pi_seqno <> "" then
			str_q_pi_seqno  = " and pih.pi_seqno  = '"&q_pi_seqno&"'  "			
		else
			
			str_q_pi_seqno  = ""
			'response.Write(str_q_num)
			'response.End()
		end if
		
		
		if q_status = "" then
			str_q_status = ""
				else if q_satus = "0"  then
					str_q_status = " "
						else if q_status = "1" then
							str_q_status =" and pih.status = '1' "
								else if q_status="2" then
									str_q_status = " and pih.status = '2' "
										else if q_status="3" then
											str_q_status = " and pih.status = '3' "
												else if q_status="4" then
													str_q_status = " and pih.status = '4' "
												end if
										end if
								end if
						end if
				end if 
		end if
	
		if q_begin_date <> ""  and q_end_date <> ""  then
				str_q_begin_date = " and pih.creation_date between  to_date('"&q_begin_date&"','yyyymmdd') and to_date('"&q_end_date&"','yyyymmdd')  "
			else
				str_q_begin_date = ""
		end if


		if q_cust_name = "" then
			str_q_cust_name = ""
		else
			str_q_cust_name = " and pih.customer_name like '%"& q_cust_name &"%'"
		end if

	
	
	

%>
<body>

<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<table width="770" align="center">
	<tr align="center" >
	  <td><font face="Arial" size="+2"> Query Invoice Interface</font></td>
	</tr>
</table>

<form name="form1" method="post" action="pi_query.asp">

<!-- #include file="link.asp" -->
<br>
<br>
  <table width="770"  border="1" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td bgcolor="#99CCFF" class="tableTitle" ><font face="Arial" size="2">pi_seqno</font></td>
      <td><font face="Arial" size="2"><input name="q_pi_seqno" type="text" id="q_pi_seqno" size="15" value="">
      </font></td>
      <td bgcolor="#99CCFF" class="tableTitle" ><font face="Arial" size="2">Customer name</font></td>
      <td colspan="4"><select name="q_cust_name" id="q_cust_name"  >
	  <option value="">All</option>
	  <%	
 
	sql_cust = " select distinct customer_name   from tsc_proforma_invoice_headers order by customer_name asc "
	Set rs = Ora_conn.execute(sql_cust)
	while not rs.eof 
	'customer_id = rs("customer_id")
	customer_name = SqlStr(rs("customer_name"))
	response.Write  " <option  value="&customer_name&">"&customer_name&"</option>"
	rs.movenext
	wend

%>
      </select></td>
    </tr>
    <tr>
      <td bgcolor="#99CCFF" class="tableTitle" width="77" >Status</td>
      <td width="115"><select name="q_status" id="q_status"   >
        <option value="0" >0.None</option>
        <option value="1">1.Shipping Conform</option>
        <option value="2">2.CN Confirm</option>
        <option value="3">3.Branch Confirm</option>
        <option value="4">4.Closed</option>
      </select></td>
      <td bgcolor="#99CCFF" class="tableTitle" width="99" ><font face="Arial" size="2">Begin time</font></td>
      <td width="159"><input name="q_begin_date" type="text" id="q_begin_date" size="15" readonly value= <% =q_begin_date %>  > <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.q_begin_date);return false;'><IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></td>
      <td bgcolor="#99CCFF" class="tableTitle" width="66" ><font face="Arial" size="2">End Time</font></td>
      <td width="176"><font face="Arial" size="2"><input name="q_end_date" type="text" id="q_end_date" size="15" readonly value= <% =q_end_date %> > <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.q_end_date);return false;'><IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></font></td>
    <td width="62"><font face="Arial" size="2"> <input name="search" type="submit" id="search" value="search"></font></td>
    </tr>
  </table>
  <p>&nbsp;</p>
  <table width="770" border="1" align="center" cellpadding="0" cellspacing="0">
	<tr bgcolor="#99CCFF" class="tableTitle"> 
	  <td width="2%">&nbsp;</td>
      <td width="10%"><font face="Arial" size="2">Invoice No </font></td>
      <td width="24%"><font size="2" face="Arial">Customer Name </font></td>
      <td width="20%"><font size="2" face="Arial">Date</font></td>
      <td width="9%"><font face="Arial" size="2">Status</font></td>
      <td width="10%"><font face="Arial" size="2">Vat</font></td>
	  <td width="7%"><font size="2" face="Arial">Net</font></td>
      <td width="7%"><font size="2" face="Arial">Total</font></td>
      <td width="4%"><font face="Arial" size="2">Open File</font></td>
	  <td width="6%"><font face="Arial" size="2">Maintain Option</font></td>
	</tr>
<%

if q_status <> "0"  then  

%>
	<tr>
		<td colspan="9" align="center">Not Data!!</td>
	</tr>

<%  
else 

	'sql = "select * from tsc_euro_co_header tech ,tsc_euro_co_upload tecu "&_
		'  "where tech.doc_id =  tecu.doc_id and tecu.is_newest = 'Y' and tech.confirm ='" & q_status & "'  " & co_number & " "&_
		 ' "and  " & q_date & "  between  '" & q_begin_date & "' and '" & q_end_date & "' "

	'sql = 	"select * from tsc_cust_po_header a,tsc_cust_po_upload b " &_
	
	sql  = " select * from tsc_proforma_invoice_headers pih "&_
			 "where pih.created_by is not null " &_
			 str_q_pi_seqno &_
			 str_q_begin_date &_
			 str_q_status &_
			 str_q_cust_name &_
			 " order by pih.pi_seqno desc"
			 
			 
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
			show_pi_seqno 		=	rs2("pi_seqno")
			show_cust_name 			=	rs2("customer_name")
			show_date    			=	rs2("pickup_date")
			show_status    			=	rs2("status")
			show_vat				=	rs2("vat")
			show_net_invoice_value	=	rs2("net_invoice_value")
			show_total_amount		=	rs2("total_amount")
			'show_remarks			=	rs("remarks")
			'show_link				=	rs("file_link")
					
%>
	<tr>
		<td><div align="center"><img src="images/aw_blue.gif"></div></td>
		<td><font face="Arial" size="2"><%=show_pi_seqno %></font></td>
		<td><font face="Arial" size="2"><%=show_cust_name %></font></td>
		<td><font face="Arial" size="2"><%=show_date %></font></td>
		<td><font face="Arial" size="2">
		<% 
			if show_status="1" then 
				response.write("1.Shipping Conform")
				else if  show_status="2" then
					response.write("2.CN Confirm")
					else if  show_status="3"  then
						response.write("3.Branch Confirm")
						else if  show_status="4"  then
							response.write("4.Closed")
						end if
					end if
				end if
			end if
 
		 %>		
		</font></td>
		<td align="right"><font face="Arial" size="2"><%=show_vat %></font></td>
		<td align="right"><font face="Arial" size="2"><%=show_net_invoice_value%></font></td>
		 
		<td align="right"><font face="Arial" size="2" ><%=show_total_amount %></font></td>
		<td><font face="Arial" size="2"><a href="pi_invoice_output2.asp?pi_seqno=<%=show_pi_seqno%>"  target="_blank"><img src="images/attach.gif" border="0"></a></font></td>
		<% 'if  session("org")= "TSCE" or  session("org")="ALL" then%>
		<td><font face="Arial" size="2"><a href="pi_invoice_output2.asp?pi_seqno=<%=show_pi_seqno%>" >Update</a></font></td>
		<%' else %>
		<td width="1%">&nbsp;</td>
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
		<td colspan="10" align="center"><font face="Arial" size="2">Not Data!!</font></td>
	</tr>
<% 	end if %>
<% 	end if %>

</table>
</form>
</table>
</body>
</html>
