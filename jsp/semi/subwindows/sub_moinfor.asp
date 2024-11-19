<%
 	order_no = request("order_number")

%>
<html>
<head>
<title> </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<!-- #include file="../public/default_value.asp" -->

</head>

<body >  
<%
	sql1="DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')"
	set rs1=Ora_conn.execute(sql1) 

	sql = " select * from tsc_invoice_lines where order_number = '"&order_no&"'"
	

 Set rs_sql = Ora_conn.execute(sql)
%>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> Ship Order Information (<%=order_no%>):</strong></font></TD>
<br>
<br>
<table width="600" border="1"  bordercolor="#0066FF"    align="center" cellpadding="0" cellspacing="0" bordercolorlight='#999999'>
<tr BGCOLOR='0066FF'>
	<td><font face="Arial" size="2" color="#FFFFFF">Invoice no</font></td>
	<td><font face="Arial" size="2" color="#FFFFFF">Item_Description</font></td>
	<td><font face="Arial" size="2" color="#FFFFFF">Cust_PO</font></td>
	<td><font face="Arial" size="2" color="#FFFFFF">Quantity</font></td>
	<td><font face="Arial" size="2" color="#FFFFFF">Price</font></td>
	<td><font face="Arial" size="2" color="#FFFFFF">Creation_Date</font></td>
</tr>


<%
If  rs_sql.eof=false Then 
		while not rs_sql.eof 
			response.write("<tr>")
			response.write("<td><font face='Arial' size='2'>"&rs_sql("INVOICE_NO")&"</font></td><td><font face='Arial' size='2'>"&rs_sql("ITEM_DESCRIPTION")&"</font></td>")
			response.write("<td><font face='Arial' size='2'>"&rs_sql("CUST_PO_NO")&"</font></td><td><font face='Arial' size='2'>"&rs_sql("QUANTITY")&"</font></td>")
			response.write("<td><font face='Arial' size='2'>"&rs_sql("UNIT_SELLING_PRICE")&"</font></td><td><font face='Arial' size='2'>"&rs_sql("CREATION_DATE")&"</font></td>")
			response.write("</tr>")
		rs_sql.movenext
		wend
else
 			response.write("<tr><td colspan='6' align='center'><font face='Arial' size='2'>No Shipping Goods Before</font></td></tr>")
end if



	rs_sql.close						
	Set rs_sql = nothing
	'Ora_conn.close
	Set Ora_conn = nothing

%>
<tr>
		<td colspan='6' align="right"> 
			<input type="button" value="Close Window" onclick="window.close()">
		</td>
	</tr>
</table>

</body>
</html>
