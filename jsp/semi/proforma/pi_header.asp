<% 'if   UCase(LeftB(ts_customer , 8 )) = "EVER"  then %>
	<!-- #include file="pi_title.asp" -->
<%' else %>
	<!-- #include file="pi_address.asp" -->
<%' end if %>
<font face="Arial">
<font size="2">VAT Reg.No.: <%=pih_tax_reference%></font>
</font>
<br>
<!-- #include file="pi_paper_name2.asp" -->
<br>
<table border="0" cellpadding="0" cellspacing="0"  bordercolor="#111111" width="95%">
  <tr>
    <td width="124">&nbsp;</td>
    <td width="370">&nbsp;</td>
    <td width="22"></td>
    <td width="262"><font face="Arial" size="2">&nbsp;Page:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;&nbsp;&nbsp;of&nbsp;&nbsp;<%=total_page%></font></td>
  </tr>
</table>
 <br>
<TABLE  borderColor="#111111" cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD width="18%"><FONT face="Arial" size="2">OC/PI #:</FONT></TD>
    <TD width="55%"><B><FONT face="Arial" size="2"></FONT></B></TD>
    <TD width="10%"><FONT face="Arial" size="2">Date:</FONT></TD>
    <TD width="17%"><FONT face="Arial" size="2">23-MAY-2006</FONT></TD></TR></TBODY></TABLE>
<TABLE   borderColor="#111111" cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD width="18%"><FONT face="Arial" size="2">Customer P/O:</FONT></TD>
    <TD width="55%"><FONT face="Arial" size="2">3-040106-A</FONT></TD>
    <TD width="10%"><FONT face="Arial" size="2">Revision:</FONT></TD>
    <TD width="17%"><FONT face="Arial" size="2">0</FONT></TD></TR></TBODY></TABLE>
<TABLE id=AutoNumber3 style="BORDER-COLLAPSE: collapse" borderColor=#111111 
cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD width="20%"><FONT face="Arial" size="2">Payment Term:</FONT></TD>
    <TD width="17%"><FONT face="Arial" size="2">NET 60 Days</FONT></TD>
    <TD width="20%"><FONT face="Arial" size="2">Shipment Term:</FONT></TD>
    <TD width="20%"><FONT face="Arial" size="2"><%=pih_fob_point_code%></FONT></TD>
    <TD width="14%"><FONT face="Arial" size="2">Currency:</FONT></TD>
    <TD width="9%"><FONT face="Arial" size="2">EUR</FONT></TD></TR></TBODY></TABLE>

<HR>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber4">
  <tr>
    <td width="8%">
      <p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2"><b>&nbsp;Item</b></font></td>
    <td width="22%"> <font face="Arial" size="2"> <b>Description</b></font></td>
    <TD width="16%">
      <P style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px"><B><SPAN lang=EN-US 
      style="FONT-SIZE: 10pt; FONT-FAMILY: Arial">CRD&nbsp; /</SPAN></B></P></TD>
    <TD width="17%"><B><FONT face=Arial size=2>MO No.&nbsp; / </FONT></B></TD>
    <TD width="12%">
      <P style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px"><B><FONT face=Arial 
      size=2>Country </FONT></B></P></TD>
    <TD width="14%">
      <P style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px"><B><SPAN lang=EN-US 
      style="FONT-SIZE: 10pt; FONT-FAMILY: Arial">Qty(pcs)&nbsp; /</SPAN></B></P></TD>
    <TD width="11%"><B><FONT face=Arial size=2>Amount </FONT></B></TD>
  </tr>
  <tr>
    <td width="8%">  </td>
    <TD width="22%" height=17><FONT face=Arial size=2>Customer PN</FONT></TD>
    <TD width="16%">
      <P style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px"><FONT face=Arial 
      size=2>Delivery Date</FONT></P></TD>
    <TD width="17%"><FONT face=Arial size=2>Ship Method</FONT></TD>
    <TD width="12%">
      <P style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px"><FONT face=Arial size=2>Of Origin</FONT></P></TD>
    <TD width="14%">
      <P style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px"><SPAN lang=EN-US 
      style="FONT-SIZE: 10pt; FONT-FAMILY: Arial">Unit Price</SPAN></P></TD>
    <TD width="11%"></TD>
  </tr>
</table>
<table width="95%"  border="0" cellspacing="0" cellpadding="0">
 
<HR>
 