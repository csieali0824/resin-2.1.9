<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5" height="31">
  <tr>
    <td width="19%" height="15"><font face="Arial" size="2">VAT Reg.No.:</font></td>
    <td width="30%" height="15"><font face="Arial" size="2">DE813737662</font></td>
    <td width="22%" height="15"><font face="Arial">Net Invoice Value</font></td>
    <td width="9%" height="15"><font size=2 face="Arial">USD</font></td>
    <td width="20%" height="15" align="right"><font size=2 face="Arial"><%=pih_net_invoice_value%></font></td>
  </tr>
  <tr>
    <td width="19%" height="16"><font face="Arial" size="2">German Reg.No.:</font></td>
    <td width="30%" height="16"><font face="Arial" size="2">16/673/10388</font></td>
    <td width="22%" height="16"><font face="Arial">VAT 16%</font></td>
    <td width="9%" height="16"><font size=2 face="Arial">USD</font></td>
    <td width="20%" height="16" align="right"><font size=2 face="Arial"><%=pih_vat%></font></td>
  </tr>
</table>
<HR color="#000000" align="right" width="51%" size="1"  >
<HR color="#000000" align="right" width="51%" size="1" >
<table border="0" cellpadding="0" cellspacing="0"  bordercolor="#111111" width="100%" >
  <tr>
    <td width="48%"><font face="Arial" size="2">PLEASE INDICATE OC NO. ON PAYMENTS<BR>
  AGAINST PROFORMA INVOICE</font></td>
    <td width="23%"><font face="Arial">&nbsp;&nbsp; Total Amount </font></td>
    <td width="9%"><font face="Arial" size=2>USD</font></td>
    <td width="20%" align="right"><font face="Arial" size=2><%=pih_total_amount%></font></td>
  </tr>
</table>
<HR color="#000000" align="right" width="51%" size="1" noshade style="word-spacing: 1; margin-top: 1; margin-bottom: 1">
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber8" height="41">
  <tr>
    <td width="57%" height="41" align="left" valign="top"> <font size=2 face="Arial">
<%
if pil_currency_code="USD" then
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
response.write(Bank)
%>	
</font></td>
    <td width="43%" height="41"> <font face="Arial"> <img border="0" src="images/joetest.jpg" width="200" height="100"></font></td>
  </tr>
</table>
