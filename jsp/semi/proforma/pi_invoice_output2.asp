<%
'if session("login")= "" or session("password")= "" or session("org") <> "ALL" then
'   response.redirect "http://intranet.ts.com.tw/"
'end if

'response.write("qq")
'response.end
%>
<html>
<head>
<meta http-equiv="Content-Language" content="zh-tw">
<meta http-equiv="Content-Type" content="text/html; charset=big5">

<!-- #include file="number.asp" -->
<title>ts_invoice_output</title>
</head>
<!-- #include file="public/public.asp" -->
<!-- #include file="public/default_value.asp" -->
<%
	 pih_pi_seqno = request("pi_seqno")
	 'ts_invoice_date =  Request.QueryString("q_begin_date") 
 	 'Set Ora_conn=Server.CreateObject("ADODB.Connection") 'oracle connection 
     '	Ora_conn.open "file name=" & server.mappath("Oracle.UDL") 
	 sql = "select * from tsc_proforma_invoice_headers  where pi_seqno = '"&pih_pi_seqno&"' "
	 set rs=Ora_conn.execute(sql)
	 
	 Datacount = 0
	 sql_data="select count(*) count from tsc_proforma_invoice_lines where pi_seqno='" & pih_pi_seqno & "'"
	  
	  
	  
	 set rs_data = Ora_conn.execute(sql_data)
	 Datacount = cint(rs_data("count"))
	 Datacount2 = cint(rs_data("count"))
	 if Datacount > 16 then
		 total_page =  (Datacount \ 16) +1
		 Data_line = 1
	 else
		 total_page = 1
	 end if
	 set rs_data = nothing
	 

	'new  rs
	pih_pi_seqno=rs("pi_seqno")
	pih_pickup_date=rs("pickup_date")
	pih_customer_name=rs("customer_name")
	pih_fob_point_code=rs("fob_point_code")
	
	
	pih_deliverto_addressee=rs("deliverto_addressee")
	pih_deliverto_city=rs("deliverto_city")
	pih_deliverto_postal_code=rs("deliverto_postal_code")
	pih_deliverto_country=rs("deliverto_country")
	
	pih_billto_addressee=rs("billto_addressee")
	pih_billto_city=rs("billto_city")
	pih_billto_postal_code=rs("billto_postalcode")
	pih_billto_country=rs("billto_country")
	
	pih_tax_reference=rs("tax_reference")
	pih_terms=rs("terms")
	pih_tax_code=rs("tax_code")
	'pih_region1=rs("region1")
	'pih_status=rs("terms")
	pih_vat=rs("vat")
	'pih_net_invoice_value=rs("net_invoice_value")
	pih_total_amount=rs("total_amount")
	pih_ship_from=rs("ship_from")
	pih_docu=rs("docu")
	pih_net_invoice_value=formatnumber(rs("net_invoice_value"),2,-1,-1,-1)
	pih_total_amount =formatnumber(rs("total_amount"),2,-1,-1,-1)
	
	
	'pih_shipto_customer_name=rs("shipto_customer_name")
	'pih_shipto_reference=rs("shipto_reference")
	'pih_shipto_mark=rs("shipto_mark")
		 
	 'ts_invoice_name = rs("ts_invoice_name")
	 'pih_invoice_date = rs("INVOICE_DATE")
	 'pih_customer = rs("CUSTOMER") 
	 'pih_bill_to_location = rs("BILL_TO_LOCATION") 
	 'pih_shipped_method = rs("SHIPPED_METHOD") 
	 'ts_ship_to = rs("SHIP_TO")
	 'ts_currency = rs("CURRENCY")
	 'ts_ship_from = rs("SHIP_FROM")
	 'ts_sailing_date = rs("SAILING_DATE")
	 'ts_comments =Replace(rs.Fields.Item("COMMENTS").Value,vbCrLF,"<br>")
	 
	  
	 
	 'ts_uom = rs("UOM")
	 set rs=nothing
	 'Ora_conn.close
	 'set  Ora_conn = nothing 
%>
<body>
<!-- #include file="pi_header.asp" -->
 
<table border="0" cellpadding="0" cellspacing="0"  bordercolor="111111" width="100%"  height="12">
 <%   
	
	sql_lines = " select item_description,cust_po_no,order_number,"&_
				" TO_CHAR(TO_DATE(delivery_date,'yyyy/mm/dd'),'DD-MON-YYYY') delivery_date,"&_
				" TO_CHAR(TO_DATE(request_date,'yyyy/mm/dd'),'DD-MON-YYYY') request_date ,"&_
				" shipping_method_code,customer_partno,quantity,unit_selling_price,"&_
				" currency_code,line_amount,cccode, packing_instructions "&_
				" from tsc_proforma_invoice_lines "&_
	  			" where pi_seqno ='"& pih_pi_seqno &"'"
					 'response.write(sql_lines)
	 'response.end
				
				
	set rs=Ora_conn.execute(sql_lines)

	If not rs.eof Then
		i=1 
		while not rs.eof 
			'new  rs line
			'pil_i=i
			pil_item_description=rs("item_description")
			pil_cust_po_no=rs("cust_po_no")
			pil_order_number=rs("order_number")
			pil_delivery_date=rs("delivery_date")
			pil_request_date=rs("request_date")
			pil_shipping_method_code=rs("shipping_method_code")
			pil_customer_partno=rs("customer_partno")
			pil_quantity=formatnumber(rs("quantity"),3,-1,-1,-1)
			pil_unit_selling_price= formatnumber(rs("unit_selling_price"),2,-1,-1,-1)
			pil_currency_code=rs("currency_code")
			pil_line_amount=  formatnumber(rs("line_amount"),3,-1,-1,-1)
			pil_cccode=rs("cccode")
			pil_packing_instruction=rs("packing_instructions")
			'pil_line_amount=rs("terms")
			if pil_packing_instruction = "Y" or pil_packing_instruction = "T" Then
				pil_packing_instruction = "CN(720)"
			else   pil_packing_instruction = "I"  
				pil_packing_instruction = "TW(736)"
			end if
				
			if trim(pil_cccode) <> empty then
				pil_cccode=rs("CCCODE")
			else   
				pil_cccode="Diodes - 8541100000"
			end if
  %>
  <tr>
    <td width="8%" height="11"><b><font size="2" face="Arial"><%=i%></font></td>
    <td width="22%" height="11"><b><font size="2" face="Arial"><%=pil_item_description%></font></b></td>
    <td width="16%" height="11"><b><font size="2" face="Arial"><%=pil_request_date%></font></b></td>
    <td width="17%" height="11" ><b><font size="2" face="Arial"><%=pil_order_number%></font></b></td>
    <td width="12%" height="11" align="left"><b><font size="2" face="Arial"><%=pil_packing_instruction%></font></b></td>
    <td width="14%" height="11" align="left"><b><font size="2" face="Arial"><%=pil_quantity%></font></b></td>
    <td width="11%" height="11" align="right"><b><font size="2" face="Arial"><%=pil_line_amount%></font></b></td>
  </tr>
  <tr>
    <td width="8%" height="13"></td>
    <td width="22%" height="13" ><font size="2" face="Arial"><%=pil_customer_partno%></font></td>
    <td width="16%" height="12" ><font size="2" face="Arial"><%=pil_delivery_date%></font></td>
    <td width="17%" height="12" ><font size="2" face="Arial"><%=pil_shipping_method_code%></font></td>
    <td width="12%" height="13" ><font size="2" face="Arial">&nbsp;</font></td>
	<td width="14%" height="13" align="left"><font size="2" face="Arial"><%=pil_unit_selling_price%></font></td>
	<td width="11%" height="15" ><font size="2" face="Arial">&nbsp;</font></td>
  </tr>


<%
	Data_line = Data_line +1
	Datacount = Datacount -1
	if total_page <> 1 and Data_line = 16 then
	response.write "</table>"
		response.write "<table  style='page-break-after:always'></p>"
%>
	<!-- #include file="pi_header.asp" -->
<%
	Data_line = 1
	total_page = total_page -1
		else  if total_page = 1 and Datacount = 0  then
			if Data_line < 16 then
			'total_page =  (Datacount \ 16) +1
			add_line = Datacount2 mod 16
			add =(16-add_line)
			for i=0 to add  
			 	response.write("<tr></tr>")
				'response.write("<br>")
			Next  
			
		    else
			end if
		
		
		response.write "</table>"
		
%>
	<!-- #include file="footer.asp" -->
<%	
		
			else
		end if
	end if
	i=i+1
 	rs.movenext
	wend

%>
<% else %>
	  <tr>
		<td colspan="6"  align="center"><font size="2" face="Arial">NO DATA!</font></td>
	  </tr>
<% 

end if 
	Set rs = nothing
	'rs.close
	Set Ora_conn = nothing
	'Ora_conn.close

%>
</table>
</body>
</html>

	