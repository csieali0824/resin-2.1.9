<%
'if session("login")="" or session("password")="" or ( session("org") <> "TSCE" and  session("org") <> "TSCAER" and  session("org") <> "ALL")   then
 '  resTscnse.redirect "http://intranet.ts.com.tw/"
'end if
%>
<html>
<!-- #include file="head.asp" -->
<!-- #include file="public/public.asp" -->
<!-- #include file="public/default_value.asp" -->

<%
'!LS?A!!OiAU?Aai!LI-E?¢FFX ""
	q_pi_seqno	= 	Request.Form("q_pi_seqno")
	q_begin_date	=	Request.Form("q_begin_date")
	q_end_date		=	Request.Form("q_end_date")
	q_status		=	Request.Form("q_status")
	q_cust_name		=	Request.Form("q_cust_name")

	if q_pi_seqno <> "" then
		str_q_pi_seqno  = " and a.cust_Tsc_num  = '"& q_pi_seqno  &"'  "			
		else
			
			str_q_pi_seqno  = ""
			'resTscnse.Write(str_q_pi_seqno)
			'resTscnse.End()
	end if

	if q_status = "" then
		str_q_status = ""
			else if q_satus = "0"  then
				str_q_status = " "
					else if q_status = "1" then
						str_q_status =" and b.status = 'N' "
							else if q_status="2" then
								str_q_status = " and b.status = 'Y' "
							end if
					end if
			end if 
	end if
	
	if q_begin_date <> ""  and q_end_date <> ""  then
			str_q_begin_date = " and b.updated_time between  '"& q_begin_date &"' and '"& q_end_date &"'  "
		else
			str_q_begin_date = ""
	end if


	if q_cust_name = "" then
		str_q_cust_name = ""
	else
		str_q_cust_name = " and a.cust_no = '"& q_cust_name &"'"
	end if



  '" and b.status= '" q_status "' "  &_
		'  " and b.update_time between '"& q_begin_date &"' and '"& q_end_date &"' "
	


%>
<body>

<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="iTscpeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; Tscsition:absolute; top:0px;"></iframe>
<table width="770" align="center">
	<tr align="center" >
	  <td><font face="Arial" size="+2"> Query Invoice Interface</font></td>
	</tr>
</table>

<form name="form1" method="Tscst" action="Tsc_all_query.asp">

<!-- #include file="link.asp" -->
<br>
<br>
  <table width="770"  border="1" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td bgcolor="#99CCFF" class="tableTitle" ><font face="Arial" size="2">Tsc_Number</font></td>
      <td><font face="Arial" size="2"><input name="q_pi_seqno" type="text" id="q_pi_seqno" size="15" value="<%=q_pi_seqno%>"></font></td>
      <td bgcolor="#99CCFF" class="tableTitle" ><font face="Arial" size="2">Customer name</font></td>
      <td colspan="4"><select name="q_cust_name" id="q_cust_name"  >
	  <option value=""></option>
	  <%	
	Set conn = Server.CreateObject("ADODB.Connection")
	conn.open db_connection_str
	sql_cust = " select * from tsc_cust_data order by customer_name asc "
	Set rs = conn.execute(sql_cust)
	while not rs.eof 
	customer_id = rs("customer_id")
	customer_name = rs("customer_name")
	resTscnse.Write  " <option value="& customer_id &" >"& customer_name&" </option>"
	rs.movenext
	wend

%>
      </select></td>
    </tr>
    <tr>
      <td bgcolor="#99CCFF" class="tableTitle" width="77" >Status</td>
      <td width="115"><select name="q_status" id="q_status"  >
        <option value="0">all</option>
        <option value="1">no read</option>
        <option value="2">read</option>
      </select></td>
      <td bgcolor="#99CCFF" class="tableTitle" width="99" ><font face="Arial" size="2">Begin time</font></td>
      <td width="159"><input name="q_begin_date" type="text" id="q_begin_date" size="15" readonly value= <% =q_begin_date %>  > <A href='javascript:void(0)' onclick='gfTscp.fTscpCalendar(document.form1.q_begin_date);return false;'><IMG name='Tscpcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></td>
      <td bgcolor="#99CCFF" class="tableTitle" width="66" ><font face="Arial" size="2">End Time</font></td>
      <td width="176"><font face="Arial" size="2"><input name="q_end_date" type="text" id="q_end_date" size="15" readonly value= <% =q_end_date %> > <A href='javascript:void(0)' onclick='gfTscp.fTscpCalendar(document.form1.q_end_date);return false;'><IMG name='Tscpcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></font></td>
    <td width="62"><font face="Arial" size="2"> <input name="search" type="submit" id="search" value="search"></font></td>
    </tr>
  </table>
  <p>&nbsp;</p>
  <table width="770" border="1" align="center" cellpadding="0" cellspacing="0">
	<tr bgcolor="#99CCFF" class="tableTitle"> 
	  <td width="2%">&nbsp;</td>
      <td width="12%"><font face="Arial" size="2">pi_seqno</font></td>
      <td width="16%"><font face="Arial" size="2">Customer_name</font></td>
      <td width="12%"><font face="Arial" size="2">Ship_method</font></td>
      <td width="10%"><font size="2" face="Arial">Payment</font></td>
      <td width="7%"><font face="Arial" size="2">Vat</font></td>
	  <td width="10%">&nbsp;</td>
      <td width="7%"><font size="2" face="Arial">Total_Amount</font></td>
      <td width="11%">&nbsp;</td>
	  <td width="12%"><font face="Arial" size="2">Maintain Option</font></td>
	</tr>
<%

if q_status = ""  then  

%>
	<tr>
		<td colspan="10" align="center">Not Data!!</td>
	</tr>

<%  
else 

	'sql = "select * from tsc_euro_co_header tech ,tsc_euro_co_upload tecu "&_
		'  "where tech.doc_id =  tecu.doc_id and tecu.is_newest = 'Y' and tech.confirm ='" & q_status & "'  " & co_number & " "&_
		 ' "and  " & q_date & "  between  '" & q_begin_date & "' and '" & q_end_date & "' "

	sql = 	"select * from tsc_proforma_invoice_headers a  "&_
		  	"where a.pi_seqno = '" & pi_seqno & "'" 
			" and b.is_newest='Y'" &_
			 str_q_pi_seqno &_
			 'str_q_pi_seqno &_
			 str_q_begin_date &_
			 str_q_status &_
			 " order by a.doc_id desc"
			 
			' resTscnse.Write("sql = " +sql)
			' resTscnse.End()
			 

	Set conn = Server.CreateObject("ADODB.Connection")
	Set rs = Server.CreateObject("ADODB.Recordset")
	conn.open db_connection_str
	rs.open sql,conn,3,3

	If not rs.eof Then 
		while not rs.eof 
			show_doc_id 		=	rs("doc_id")
			show_cust_name 		=	rs("cust_name")
			show_Tsc_number		=	rs("cust_Tsc_num")
			show_version		=	rs("version")
			show_updatedby		=	rs("updated_by")
			show_updatetime		=	rs("updated_time")
			show_remarks		=	rs("remarks")
			show_link			=	rs("file_link")
					
%>
	<tr>
		<td><div align="center"><img src="images/aw_blue.gif"></div></td>
		<td><font face="Arial" size="2"><%=show_cust_name %></font></td>
		<td><font face="Arial" size="2"><%=show_cust_name %></font></td>
		<td><font face="Arial" size="2"><%=show_cust_name %></font></td>
		<td><font face="Arial" size="2"><%=show_cust_name %></font></td>
		<td><font face="Arial" size="2"><%=show_cust_name %></font></td>
		<td><font face="Arial" size="2"><%=show_cust_name %></font></td>
		<td>&nbsp;</td>
		<td><font face="Arial" size="2"><a href="<% =show_link %>" target="_blank"><img src="images/attach.gif" border="0"></a></font></td>
		<% if  session("org")= "TSCE" or  session("org")="ALL" then%>
		<td><font face="Arial" size="2"><a href="Tsc_update.asp?doc_id=<%=show_doc_id %>" >Update</a></font></td>
		<% else %>
		<td width="1%">&nbsp;</td>
		<% end if%>
   	</tr>
<% 
	rs.movenext
	wend
%>



<% 
	rs.close						
	Set rs = nothing
	conn.close
	Set conn = nothing
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
