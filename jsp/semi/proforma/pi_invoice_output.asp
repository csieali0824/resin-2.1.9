<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns="http://www.w3.org/TR/REC-html40">

<head>
<meta name="GENERATOR" content="Microsoft FrontPage 6.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=big5">

<title>TAIWAN SEMICONDUCTOR CO</title>
</head>
<!-- #include file="public/public.asp" -->
<%
 lang="US"
 no="N"
 'invoice_no1=request("invoice_no")
 invoice_no=session("invoice_no")

 
  	sql="select * from tsc_invoice_headers a ,  tsc_invoice_lines  b where  a.invoice_no = b.invoice_no and a.invoice_no ='" & invoice_no & "'"
  	set pppppp=Ora_conn.execute(sql)
	Datacount = 0
	sql2="select count(*) count from  tsc_invoice_headers a ,  tsc_invoice_lines  b  where  a.invoice_no = b.invoice_no and a.invoice_no ='" & invoice_no & "'"
	set rs=Ora_conn.execute(sql)

	set rs2=Ora_conn.execute(sql2)
	Datacount = cint(rs2("count"))
	a = Datacount /16
	b = Datacount mod 16
	sum = Datacount \16
	if b > 10 then
   		sum=sum+2
	else 
   		sum=sum+1
	end if 

'new  rs
tsh_invoice_no=rs("invoice_no")
tsh_pickup_date=rs("pickup_date")
tsh_delivery_date=rs("delivery_date")
tsh_customer_name=rs("customer_name")
tsh_fob_point_code=rs("fob_point_code")
tsh_shipping_method_code=rs("shipping_method_code")
tsh_customer_partno=rs("customer_partno")
tsh_deliverto_addressee=rs("deliverto_addressee")
tsh_deliverto_city=rs("deliverto_city")
tsh_deliverto_postal_code=rs("deliverto_postal_code")
tsh_deliverto_country=rs("deliverto_country")

tsh_billto_addressee=rs("billto_addressee")
tsh_billto_city=rs("billto_city")
tsh_billto_postal_code=rs("billto_postal_code")
tsh_billto_country=rs("billto_country")

tsh_tax_reference=rs("tax_reference")
tsh_tax_code=rs("tax_code")
'tsh_region1=rs("region1")
'tsh_status=rs("terms")
tsh_vat=rs("vat")
'tsh_net_invoice_value=rs("net_invoice_value")
tsh_total_amount=rs("total_amount")
tsh_ship_from=rs("ship_from")
tsh_docu=rs("docu")
tsh_net_invoice_value=formatnumber(rs("net_invoice_value"),2,-1,-1,-1)
tsh_total_amount =formatnumber(rs("total_amount"),2,-1,-1,-1)


tsh_shipto_customer_name=rs("shipto_customer_name")
tsh_shipto_reference=rs("shipto_reference")
tsh_shipto_mark=rs("shipto_mark")
'end new rs

'end new rs line







'response.write "" & a & ""
'terms=rs("terms")
'invoice_to_address2=replace(rs("invoice_to_address1")," ","<br>")
'FOB_POINT_CODE=rs("FOB_POINT_CODE")
'SHIPPING_METHOD_CODE=RS("SHIPPING_METHOD_CODE")
'CURRENCY_CODE=rs("CURRENCY_CODE")
'last_name=rs("last_name")
'first_name=rs("first_name")

'if trim(rs("first_name")) = "Other" then
'   ship_to_customer=rs("last_name")
'else 
'   ship_to_customer=rs("CUSTOMER_NAME")
'end if


'tax_reference=rs("tax_reference")
'vat=0

CUSTOMER_NAME=rs("CUSTOMER_NAME")

city=rs("BILLTO_CITY")
country=ucase(rs("BILLTO_COUNTRY"))

currency_code=rs("currency_code")
INITIAL_PICKUP_DATE=formatdatetime(rs("INITIAL_PICKUP_DATE"),2)
DELIVERY_DATE=formatdatetime(rs("DELIVERY_DATE"),2)


'name=rs("name")
'address=rs("BILLTO_ADDRESSEE")
'postal_code=rs("BILLTO_POSTALCODE")

'DELIVERTO_ADDRESSEE=rs("DELIVERTO_ADDRESSEE")
'DELIVERTO_CITY=rs("DELIVERTO_CITY")
'DELIVERTO_POSTAL_CODE=rs("DELIVERTO_POSTAL_CODE")
'DELIVERTO_COUNTRY=ucase(rs("DELIVERTO_COUNTRY"))


'   DELIVER_TO_ADDRESS1 = rs("DELIVERTO_ADDRESSEE")
'   DELIVER_TO_ADDRESS1 = DELIVER_TO_ADDRESS1 & "<br>" & rs("DELIVERTO_POSTAL_CODE") & "&nbsp;&nbsp;" & rs("DELIVERTO_CITY")
'   DELIVER_TO_ADDRESS1 = DELIVER_TO_ADDRESS1 & "<br>" & ucase(rs("DELIVERTO_COUNTRY"))




if rs("CURRENCY_CODE")="USD" then
   Bank="Hypovereinsbank, Vaterstetten<br>"
   Bank=Bank & "Account Nr. : 888636510<br>"
   Bank=Bank & "Bank Code : 700 202 70<br>"
   Bank=Bank & "IBAN : DE61 7002 0270 0888 6365 10<br>"
   Bank=Bank & "SWIFT (BIC) : HYVEDEMM"
else 
   Bank="Hypovereinsbank, Vaterstetten<br>"
   Bank=Bank & "Account Nr. : 656958430<br>" 
   Bank=Bank & "Bank Code : 700 202 70<br>" 
   Bank=Bank & "IBAN : DE60 7002 0270 0656 9584 30<br>" 
   Bank=Bank & "SWIFT (BIC) : HYVEDEMM"
end if


%> 
<body>


<font face="Arial">

<%'---------------表頭--------------------------------------------------------------------------%>

<%
  i=1
  p=1
  on error resume next
  rs.movefirst
  do while not  rs.eof 
%>
<% 
trailer= i mod 16
if (i mod 16 = 1 )   then  
if i <> 1 then
              response.write "<p style='page-break-after:always'></p>"
              else
              end if
%>

</font>

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="98%" id="AutoNumber7" height="46">
  <tr>
    <td width="53%" align="left" valign="top" height="46">
<font face="Arial">
<!--<span style='mso-ignore:vglayout;position:absolute;z-index:0;left:10px;top:15px;width:241px;height:53px'> -->
<img width=241 height=53 src="images/image002.jpg" v:shapes="_x0000_s1025" loop="0" start="mouseover"><!--</span>--></font></td>
    <td  width="47%" ><p align="left"><b><font face="Arial" size="3">TAIWAN SEMICONDUCTOR CO.,LTD.<u> </u></font>
    <font face="Arial"><u><font size="6"> <br>
</font></u></font></b><font face="Arial" size="2">&nbsp;11FL.,No.205,Sec.3,Beishin 
    Rd., Shindian City <br>
&nbsp;TAIPEI  . TAIWAN R.O.C. </font><font face="Arial"><br>&nbsp;<font size="2">T</font>el: 
    <font size="2">+886-2-89131588</font><br><font size="2">&nbsp;F</font>ax:<font size="2">+886-2-89131788&nbsp;</font></font></p></td>
  </tr>
</table>
<br>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="98%" id="AutoNumber1" height="41">
  <tr>
    <td width="49%" height="20"></td>
    <td width="4%" height="20"></td>
    <td width="47%" height="20"><font face="Arial"><u>Ship&nbsp; to:</u></font></td>
  </tr>
  <tr>
    <td width="49%" height="21"><font size=2 face="Arial"><%="<br>" & CUSTOMER_NAME & "<br>" & "" & address & "<br>" & "" & postal_code & " " & "" & city & "<br>" & "" & country & ""  %></font></td>
    <td width="4%" height="21"></td>
    <td width="47%" height="21"><font size=2 face="Arial"><%="" & ship_to_customer & "<br>" & "" & DELIVER_TO_ADDRESS1 & ""%></font></td>
  </tr>
</table>
<br>
<!-- #include file="pi_paper_name2" -->
<br>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="778" id="AutoNumber2">
  <tr>
    <td width="124"><font face="Arial">VAT Reg.No.:</font></td>
    <td width="370"><font face="Arial"><%=rs("tax_reference")%></font></td>
    <td width="22"></td>
    <td width="262"><font face="Arial">&nbsp;Page:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=p%>&nbsp;&nbsp;&nbsp; 
    of&nbsp;&nbsp; <%=sum%></font></td>
  </tr>
</table>
　<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
  <tr>
    <td width="15%"><font face="Arial"><b>Invoice No.:</b></font></td>
    <td width="58%"><font face="Arial"><b><%=name%></b></font></td>
    <td width="17%"><font face="Arial">Invoice Date:</font></td>
    <td width="10%"><font face="Arial"><%=INITIAL_PICKUP_DATE%></font></td>
  </tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
  <tr>
    <td width="73%"><font size="1" face="Arial">(by payment , please always indicate Invoice No.)</font></td>
    <td width="17%"><font face="Arial">Delivery Date:</font></td>
    <td width="10%"><font face="Arial"><%=DELIVERY_DATE%></font></td>
  </tr>
</table>
<font size="1" face="Arial">Claims relating to this Invoice must be registered within 14 days from Invoice issue date,<br> 
The Invoice is payable net without deduction according to the agreed payment terms.</font>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3">
  <tr>
    <td width="20%"><font face="Arial" size="2">Payment Term:</font></td>
    <td width="17%"><font face="Arial" size="2"><%=rs("terms")%></font></td>
    <td width="20%"><font face="Arial" size="2">Shipment Term:</font></td>
    <td width="20%"><font face="Arial" size="2"><%=rs("FOB_POINT_CODE")%></font></td>
    <td width="14%"><font face="Arial" size="2">Currency:</font></td>
    <td width="9%"><font face="Arial" size="2"><%=rs("CURRENCY_CODE")%></font></td>
  </tr>
   <tr>
    <td width="20%"><font face="Arial" size="2">Country Of Origin:</font></td>
    <td width="17%"><font face="Arial" size="2"><%=PACKING_INSTRUCTIONS%></font></td>
    <td width="20%"></td>
    <td width="20%"></td>
    <td width="14%"></td>
    <td width="9%"></td>
  </tr>
</table>
<p style="margin-top: 0; margin-bottom: 0"></p>
<HR>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="96%" id="AutoNumber4">
  <tr>
    <td width="7%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>&nbsp; Item</b></font></td>                   
    <td width="22%">
    <font face="Arial" size="2">
    <b>Description</b></font></td>
    <td width="19%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>Customer 
    P/O#</b></font></td>
    <td width="19%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>Customer 
	P/N</b></font></td>
    <td width="11%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>Qty/pcs</b></font></td>
    <td width="14%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>Unit Price</b></font></td>
    <td width="7%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>Amount</b></font></td>
  </tr>
  <tr>
    <td width="7%">
    　</td> 
    <td width="22%">
    　</td>
    <td width="19%">
    <p style="margin-top: 0; margin-bottom: 0"></td>
    <td width="19%">
    <b><font size="2" face="Arial">Packing List No.</font></b></td>                  
    <td width="11%">
    　</td>
    <td width="14%">
    　</td>
    <td width="7%">
    　</td>
  </tr>
</table>
<HR>
<font face="Arial">
<%
p=p+1
end if
%>
<%'---------------表身--------------------------------------------------------------------------%>
</font>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber4" height="12">
 <%   
  SRC_REQUESTED_QUANTITY=formatnumber(rs("SRC_REQUESTED_QUANTITY"),0,-1,-1,-1)
  UNIT_SELLING_PRICE=formatnumber(rs("UNIT_SELLING_PRICE"),5,-1,-1,-1)
  amount=formatnumber(rs("amount"),2,-1,-1,-1)
  DELIVERY_TO_ADDRESS=rs("DELIVERY_TO_ADDRESS")
if (trim(rs("ITEM_IDENTIFIER_TYPE")) = "Customer") or (trim(rs("ITEM_IDENTIFIER_TYPE")) = "CUST") then
   CUSTOMER_JOB=rs("CUSTOMER_JOB")
else
   CUSTOMER_JOB=""
end if
if trim(rs("CCCODE")) <> empty then
   CCCODE=rs("CCCODE")
else   
   CCCODE="Diodes - 8541100000"
end if
  %>
  <tr>
    <td width="5%" height="11"><font size="2" face="Arial"><%=i%></font></td>
    <td width="23%" height="11"><font size="2" face="Arial"><%=rs("item_description")%></font></td>
    <td width="16%" height="11"><font size="2" face="Arial"><%=rs("CUST_PO_NUMBER")%></font></td>
    <td width="17%" height="11" align="right"><font size="2" face="Arial"><%=CUSTOMER_JOB%></font></td>
    <td width="11%" height="11" align="right"><font size="2" face="Arial"><%=SRC_REQUESTED_QUANTITY%></font></td>
    <td width="13%" height="11" align="right"><font size="2" face="Arial"><%=UNIT_SELLING_PRICE%></font></td>
    <td width="15%" height="11" align="right"><font size="2" face="Arial"><%=amount%></font></td>
  </tr>
  <tr>
    <td width="5%" height="13"></td>
    <td width="39%" height="13" colspan="2"><font size="2" face="Arial"><%=CCCODE%></font></td>
    <td width="14%" height="12" align="right"><font size="2" face="Arial"><%=DELIVERY_TO_ADDRESS%></font></td>
    <td width="24%" height="12" colspan="2"></td>
    <td width="15%" height="13" align="right"></td>
  </tr>
</table>
  <font face="Arial">
  <%
  rs.movenext   
  i=i+1
  loop
  %>
  <%    if trailer = 0 then
        else         
             for Datacount=trailer*2 to 15
             response.write "<br>"  
             next     
        end if
  %>
<% if  trailer <> 0 and trailer < 11  then%>  
</font>  
<HR color="#000000" align="right" width="51%" size="1" style="word-spacing: 0; margin-top: 0; margin-bottom: 0">

<font face="Arial">

<%'---------------表尾--------------------------------------------------------------------------%>
</font>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5" height="31">
  <tr>
    <td width="19%" height="15"><font face="Arial" size="2">VAT Reg.No.:</font></td>
    <td width="30%" height="15"><font face="Arial" size="2">DE813737662</font></td>
    <td width="22%" height="15"><font face="Arial">Net Invoice Value</font></td>
    <td width="9%" height="15"><font size=2 face="Arial"><%=currency_code%></font></td>
    <td width="20%" height="15" align="right"><font size=2 face="Arial"><%=net_invoice_value%></font></td>
  </tr>
  <tr>
    <td width="19%" height="16"><font face="Arial" size="2">German Reg.No.:</font></td>
    <td width="30%" height="16"><font face="Arial" size="2">16/673/10388</font></td>
    <td width="22%" height="16"><font face="Arial">VAT 16%</font></td>
    <td width="9%" height="16"><font size=2 face="Arial"><%=currency_code%></font></td>
    <td width="20%" height="16" align="right"><font size=2 face="Arial"><%=vat%></font></td>
  </tr>
</table>
<HR color="#000000" align="right" width="51%" size="1" noshade style="word-spacing: 1; margin-top: 1; margin-bottom: 1">
<HR color="#000000" align="right" width="51%" size="1" noshade style="word-spacing: 1; margin-top: 1; margin-bottom: 1">
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
  <tr>
    <td width="48%"></td>
    <td width="23%"><font face="Arial">&nbsp;&nbsp; Total Amount </font></td>
    <td width="9%"><font face="Arial" size=2><%=currency_code%></font></td>
    <td width="20%" align="right"><font face="Arial" size=2><%=total_amount%></font></td>
  </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber8" height="41">
  <tr>
    <td width="57%" height="41" align="left" valign="top">
	<font size=2 face="Arial"><%=Bank%></font></td>
    <td width="43%" height="41">
	<font face="Arial">
	<img border="0" src="images/joetest.jpg" width="200" height="100"></font></td>
  </tr>
</table>
<font face="Arial">
<%  else if trailer = 0 then
              'response.write "<hr>"
              response.write "<p style='page-break-after:always'></p>"
         else
              response.write "<hr>"
              response.write "<p style='page-break-after:always'></p>"
              'for f=trailer*2 to 30
              'response.write "<br>"  
              'next 
         end if
%>
</font>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="94%" id="AutoNumber7" height="46">
  <tr>
    <td width="46%" align="left" valign="top" height="46">
<font face="Arial">
<!--<span style='mso-ignore:vglayout;position:absolute;z-index:0;left:10px;top:15px;width:241px;height:53px'> -->
<img width=241 height=53 src="images/image002.jpg" v:shapes="_x0000_s1025" loop="0" start="mouseover"><!--</span>--></font></td>
    <td width="54%" height="46"><p align="left"><b><font face="Arial" size="3">TAIWAN SEMICONDUCTOR CO.,LTD.<u> </u></font>
    <font face="Arial"><u><font size="6"> <br>
</font></u></font></b><font face="Arial" size="2">&nbsp;11FL.,No.205,Sec.3,Beishin 
    Rd., Shindian City <br>
&nbsp;TAIPEI  . TAIWAN R.O.C. </font><font face="Arial"><br>&nbsp;<font size="2">T</font>el: 
    <font size="2">+886-2-89131588</font><br><font size="2">&nbsp; F</font>ax:<font size="2">+886-2-89131788&nbsp;</font></font></p></td>
  </tr>
</table>
<br>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="95%" id="AutoNumber1" height="41">
  <tr>
    <td width="37%" height="20"></td>
    <td width="14%" height="20"></td>
    <td width="49%" height="20"><font face="Arial"><u>Ship&nbsp; to:</u></font></td>
  </tr>
  <tr>
    <td width="46%" height="21"><font size=2 face="Arial"><%="<br>" & CUSTOMER_NAME & "<br>" &  "" & address & "<br>" & "" & postal_code & " " & "" & city & "<br>" & "" & country & ""  %></font></td>
    <td width="14%" height="21"></td>
    <td width="40%" height="21"><font size=2 face="Arial"><%="" & ship_to_customer & "<br>" & "" & DELIVER_TO_ADDRESS1 & ""%></font></td>
  </tr>
</table>
　<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="778" id="AutoNumber2">
  <tr>
    <td width="124"><font face="Arial">VAT Reg.No.:</font></td>
    <td width="370"><font face="Arial"><%=tax_reference%></font></td>
    <td width="22"></td>
    <td width="262"><font face="Arial">&nbsp;Page:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=p%>&nbsp;&nbsp;&nbsp; 
    of&nbsp;&nbsp; <%=sum%></font></td>
  </tr>
</table>
　<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
  <tr>
    <td width="15%"><font face="Arial"><b>Invoice No.:</b></font></td>
    <td width="60%"><font face="Arial"><b><%=name%></b></font></td>
    <td width="15%"><font face="Arial">Invoice Date:</font></td>
    <td width="10%"><font face="Arial"><%=INITIAL_PICKUP_DATE%></font></td>
  </tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
  <tr>
    <td width="74%"><font size="1" face="Arial">(by payment , please always indicate Invoice No.)</font></td>
    <td width="17%"><font face="Arial">Delivery Date:</font></td>
    <td width="9%"><font face="Arial"><%=DELIVERY_DATE%></font></td>
  </tr>
</table>
<font size="1" face="Arial">Claims relating to this Invoice must be registered within 14 days from Invoice issue date,<br> 
The Invoice is payable net without deduction according to the agreed payment terms.</font>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3">
  <tr>
    <td width="20%"><font face="Arial" size="2">Payment Term:</font></td>
    <td width="17%"><font size="2" face="Arial"><%=terms%></font></td>
    <td width="20%"><font face="Arial" size="2">Shipment Term:</font></td>
    <td width="20%"><font size="2" face="Arial"><%=FOB_POINT_CODE%></font></td>
    <td width="14%"><font face="Arial" size="2">Currency:</font></td>
    <td width="9%"><font size="2" face="Arial"><%=CURRENCY_CODE%></font></td>
  </tr>
   <tr>
    <td width="20%"><font face="Arial" size="2">Country Of Origin:</font></td>
    <td width="17%"><font size="2" face="Arial"><%=PACKING_INSTRUCTIONS%></font></td>
    <td width="20%"></td>
    <td width="20%"></td>
    <td width="14%"></td>
    <td width="9%"></td>
  </tr>
</table>
<p style="margin-top: 0; margin-bottom: 0"></p>
<HR>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="96%" id="AutoNumber4">
  <tr>
    <td width="7%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>&nbsp; Item</b></font></td>                   
    <td width="22%">
    <font face="Arial" size="2">
    <b>Description</b></font></td>
    <td width="19%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>Customer 
    P/O#</b></font></td>
    <td width="19%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>Customer 
	P/N</b></font></td>
    <td width="11%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>Qty/pcs</b></font></td>
    <td width="14%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>Unit Price</b></font></td>
    <td width="7%">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>Amount</b></font></td>
  </tr>
  <tr>
    <td width="7%">
    　</td> 
    <td width="22%">
    　</td>
    <td width="19%">
    <p style="margin-top: 0; margin-bottom: 0"></td>
    <td width="19%">
    <b><font size="2" face="Arial">Packing List No.</font></b></td>                  
    <td width="11%">
    　</td>
    <td width="14%">
    　</td>
    <td width="7%">
    　</td>
  </tr>
</table>
<HR>
<font face="Arial">
<%
 for Datacount1=1 to 17
        response.write "<br>"  
        next  
%>
</font>
<HR color="#000000" align="right" width="51%" size="1" style="word-spacing: 0; margin-top: 0; margin-bottom: 0">

<font face="Arial">

<%'---------------表尾--------------------------------------------------------------------------%>
</font>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5" height="31">
  <tr>
    <td width="19%" height="15"><font face="Arial" size="2">VAT Reg.No.:</font></td>
    <td width="30%" height="15"><font face="Arial" size="2">DE813737662</font></td>
    <td width="22%" height="15"><font face="Arial">Net Invoice Value</font></td>
    <td width="9%" height="15"><font size=2 face="Arial"><%=currency_code%></font></td>
    <td width="20%" height="15" align="right"><font size=2 face="Arial"><%=net_invoice_value%></font></td>
  </tr>
  <tr>
    <td width="19%" height="16"><font face="Arial" size="2">German Reg.No.:</font></td>
    <td width="30%" height="16"><font face="Arial" size="2">16/673/10388</font></td>
    <td width="22%" height="16"><font face="Arial">VAT 16%</font></td>
    <td width="9%" height="16"><font size=2 face="Arial"><%=currency_code%></font></td>
    <td width="20%" height="16" align="right"><font size=2 face="Arial"><%=vat%></font></td>
  </tr>
</table>
<HR color="#000000" align="right" width="51%" size="1" style="word-spacing: 1; margin-top: 1; margin-bottom: 1">
<HR color="#000000" align="right" width="51%" size="1" style="word-spacing: 1; margin-top: 1; margin-bottom: 1">

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
  <tr>
    <td width="48%"></td>
    <td width="23%"><font face="Arial">&nbsp;&nbsp; Total Amount </font></td>
    <td width="9%"><font face="Arial" size=2><%=currency_code%></font></td>
    <td width="20%" align="right"><font face="Arial" size=2><%=total_amount%></font></td>
  </tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber8" height="41">
  <tr>
    <td width="57%" height="41" align="left" valign="top">
	<font size=2 face="Arial"><%=Bank%></font></td>
    <td width="43%" height="41"><p></p>
        <p></p>
        <p style="margin-top: 0; margin-bottom: 0">
	<font face="Arial">
	<img border="0" src="images/joetest.jpg" width="200" height="100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		</font> 
	</td>
  </tr>
</table>

<font face="Arial">

<%
end if

%>
<!--<% response.write "" & trailer & "" %> -->
</font>
</body>

</html>