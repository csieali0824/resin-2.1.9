<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns="http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv="Content-Language" content="zh-tw">
<meta name="GENERATOR" content="Microsoft FrontPage 6.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=big5">

<title>TAIWAN SEMICONDUCTOR CO</title>
</head>

<%
Set Ora_conn=Server.CreateObject("ADODB.Connection") 'oracle connection 
     Ora_conn.open "file name=" & server.mappath("oracle.UDL") 
dat="DD-MON-YYYY"
lang="US"
no="N"
invoice_no=request("invoice_no")
sql="select to_char(dpt.initial_pickup_date,'" & dat & "') initial_pickup_date1,to_char(dpt.REQUEST_DATE,'" & dat & "') REQUEST_DATE1,to_char(dpt.DELIVERY_DATE,'" & dat & "') DELIVERY_DATE1,dpt.* from daphne_pi_temp_bak dpt where CUST_PO_NUMBER='" & invoice_no & "' ORDER BY ITEM_DESCRIPTION,REQUEST_DATE"
Datacount = 0
sql2="select count(*) count from daphne_pi_temp_bak where CUST_PO_NUMBER='" & invoice_no & "'"
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

terms=rs("terms")
FOB_POINT_CODE=rs("FOB_POINT_CODE")
SHIPPING_METHOD_CODE=rs("SHIPPING_METHOD_CODE")

CURRENCY_CODE=rs("CURRENCY_CODE")
last_name=rs("last_name")
first_name=rs("first_name")

if trim(rs("first_name")) = "Other" then
   ship_to_customer=rs("last_name")
else if trim(rs("CUSTOMER_NAME")) = "TAIWAN SEMICONDUCTOR EUROPE GMBH"  then
            ship_to_customer="TSCE C/O ALPHA TRANS GMBH & CO., KG"
     else   
            ship_to_customer=rs("CUSTOMER_NAME")
     end if 
end if

PI_SEQNO=rs("PI_SEQNO")
tax_reference=rs("tax_reference")
vat=0
net_invoice_value=formatnumber(rs("net_invoice_value"),2,-1,-1,-1)
total_amount=formatnumber(rs("total_amount"),2,-1,-1,-1)
CUSTOMER_NAME=rs("CUSTOMER_NAME")
city=rs("BILLTO_CITY")

country1=ucase(rs("DELIVERTO_COUNTRY"))
country=ucase(rs("BILLTO_COUNTRY"))
DELIVERTO_COUNTRY=ucase(rs("DELIVERTO_COUNTRY"))
currency_code=rs("currency_code")
INITIAL_PICKUP_DATE=cstr(rs("INITIAL_PICKUP_DATE1"))
address=rs("BILLTO_ADDRESSEE")
postal_code=rs("BILLTO_POSTALCODE")
DELIVERTO_ADDRESSEE=rs("DELIVERTO_ADDRESSEE")
DELIVERTO_CITY=rs("DELIVERTO_CITY")
DELIVERTO_POSTAL_CODE=rs("DELIVERTO_POSTAL_CODE")
DELIVERTO_COUNTRY=rs("DELIVERTO_COUNTRY")

if rs("DELIVERY_TO_ADDRESS") <> "" then
   DELIVER_TO_ADDRESS1 = rs("DELIVERY_TO_ADDRESS")
else
   DELIVER_TO_ADDRESS1 = rs("DELIVERTO_ADDRESSEE")
   DELIVER_TO_ADDRESS1 = DELIVER_TO_ADDRESS1 & "<br>" & rs("DELIVERTO_POSTAL_CODE") & "&nbsp;&nbsp;" & rs("DELIVERTO_CITY")
   DELIVER_TO_ADDRESS1 = DELIVER_TO_ADDRESS1 & "<br>" & country1
end if

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

CUST_PO_NUMBER=rs("CUST_PO_NUMBER")
VERSION_NUMBER=rs("VERSION_NUMBER")
'ship_to_customer="TAIWAN SEMICONDUCTOR EUROPE GMBH<BR> C/O ALPHA TRANS HAMBURG"
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
    <td width="48%" align="left" valign="top" height="46">
<font face="Arial">
<!--<span style='mso-ignore:vglayout;position:absolute;z-index:0;left:10px;top:15px;width:241px;height:53px'> -->
<img width=241 height=53 src="index1.files/image002.jpg" v:shapes="_x0000_s1025" loop="0" start="mouseover"><!--</span>--></font></td>
    <td><p align="left"><b><font face="Arial" size="4">TAIWAN SEMICONDUCTOR CO.,LTD.<u> </u></font>
    <font face="Arial"><u><font size="6"> <br>
</font></u></font></b><font face="Arial" size="2">&nbsp;11FL.,No.205,Sec.3,Beishin 
    Rd., Shindian City <br>
&nbsp;TAIPEI  . TAIWAN R.O.C. </font><font face="Arial"><br>&nbsp;<font size="2">T</font>el: 
    <font size="2">+886-2-89131588</font><br><font size="2">&nbsp;F</font>ax:<font size="2">+886-2-89131788&nbsp;</font></font></p></td>
  </tr>
</table>
　<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="98%" id="AutoNumber1" height="41">
  <tr>
    <td width="44%" height="20"></td>
    <td width="4%" height="20"></td>
    <td width="52%" height="20"><font face="Arial"><u>Ship&nbsp; to:</u></font></td>
  </tr>
  <tr>
    <td width="44%" height="21"><font size=2 face="Arial"><%="<br>" & CUSTOMER_NAME & "<br>" & "" & address & "<br>" & "" & postal_code & " " & "" & city & "<br>" & "" & country & ""  %></font></td>
    <td width="4%" height="21"></td>
    <td width="52%" height="21"><font size=2 face="Arial"><%="" & ship_to_customer & "<br>" & "" & DELIVER_TO_ADDRESS1 & ""%></font></td>
  </tr>
</table>
<font face="Arial">
<font size="2">VAT Reg.No.: <%=rs("tax_reference")%></font>
</font>
<p><font face="Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;</font><u><b><font face="Arial" size="5">Order Confirmation/Proforma Invoice</font></b></u></p>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="984" id="AutoNumber2">
  <tr>
    <td width="124"></td>
    <td width="314"></td>
    <td width="27"></td>
    <td width="519"><font face="Arial">&nbsp; Page:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=p%>&nbsp;&nbsp;&nbsp; 
    of&nbsp;&nbsp; <%=sum%></font></td>
  </tr>
</table>
　<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
  <tr>
    <td width="18%"><font face="Arial">OC/PI #:</font></td>
    <td width="55%"><b><font face="Arial"><%=PI_SEQNO%></font></b></td>
    <td width="10%"><font face="Arial">Date:</font></td>
    <td width="17%"><font face="Arial"><%=INITIAL_PICKUP_DATE%></font></td>
  </tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
  <tr>
    <td width="18%"><font face="Arial">Customer P/O:</font></td>
    <td width="55%"><font face="Arial" size="3"><%=rs("CUST_PO_NUMBER")%></font></td>
    <td width="10%"><font face="Arial">Revision:</font></td>
    <td width="17%"><font face="Arial"><%=rs("VERSION_NUMBER")%></font></td>
  </tr>
</table>
　<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3">
  <tr>
    <td width="20%"><font face="Arial">Payment Term:</font></td>
    <td width="17%"><font face="Arial"><%=rs("terms")%></font></td>
    <td width="20%"><font face="Arial">Shipment Term:</font></td>
    <td width="20%"><font face="Arial"><%=rs("FOB_POINT_CODE")%></font></td>
    <td width="14%"><font face="Arial">Currency:</font></td>
    <td width="9%"><font face="Arial"><%=rs("CURRENCY_CODE")%></font></td>
  </tr>
   </table>
<p style="margin-top: 0; margin-bottom: 0"></p>
<HR>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber4">
  <tr>
    <td width="8%"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2">&nbsp; Item</font></b></td>
    <td width="22%"><b><font face="Arial" size="2">Description&nbsp; /</font></b></td>
    <td width="16%"><p style="margin-top: 0; margin-bottom: 0"><b>
	<span lang="EN-US" style="font-size: 10.0pt; font-family: Arial">CRD&nbsp; /</span></b></td>
    <td width="17%"><b><font face="Arial" size="2">MO No.&nbsp; 	/ </font></b></td>
    <td width="12%"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2">
	Country </font></b></td>
    <td width="15%"><p style="margin-top: 0; margin-bottom: 0"><b>
	<span lang="EN-US" style="font-size: 10.0pt; font-family: Arial">Qty(pcs)&nbsp; /</span></b></td>
    <td width="11%"><b>
	<font face="Arial" size="2">Amount </font></b></td>
  </tr>
  <tr>
    <td width="8%" height="17"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2">&nbsp; </font></b></td>
    <td width="22%" height="17"><font face="Arial" size="2">Customer PN</font></td>
    <td width="16%" height="17"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2">Delivery Date</font></td>
    <td width="17%" height="17"><font size="2" face="Arial">Ship Method</font></td>
    <td width="12%" height="17"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2">
	Of Origin</font></td>
    <td width="15%" height="17"><p style="margin-top: 0; margin-bottom: 0">
	<span lang="EN-US" style="font-size: 10.0pt; font-family: Arial">Unit Price</span></td>
    <td width="11%" height="17"></td>
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
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber4" height="25">
<%   
  SRC_REQUESTED_QUANTITY=formatnumber(rs("SRC_REQUESTED_QUANTITY"),0,-1,-1,-1)
  UNIT_SELLING_PRICE=formatnumber(rs("UNIT_SELLING_PRICE"),4,-1,-1,-1)
  amount=formatnumber(rs("amount"),2,-1,-1,-1)
  REQUEST_DATE=rs("REQUEST_DATE1")
 
  if rs("PACKING_INSTRUCTIONS") = "Y" or rs("PACKING_INSTRUCTIONS") = "T" Then
         PACKING_INSTRUCTIONS = "CN(720)"
  else if rs("PACKING_INSTRUCTIONS") = "I" Then
         PACKING_INSTRUCTIONS = "TW(736)"
       end if
  end if
  
  if (trim(rs("ITEM_IDENTIFIER_TYPE")) = "Customer") or (trim(rs("ITEM_IDENTIFIER_TYPE")) = "CUST") then
     BILLTO_POSTALCODE=rs("CUSTOMER_JOB")
  else     
     BILLTO_POSTALCODE=""
  end if
  
  DELIVERY_DATE=rs("DELIVERY_DATE1")

FOB_POINT_CODE=rs("FOB_POINT_CODE")
SHIPPING_METHOD_CODE=rs("SHIPPING_METHOD_CODE")
if (trim(SHIPPING_METHOD_CODE)="AIR(C)" AND  trim(FOB_POINT_CODE)="FCA MUNICH") or (trim(SHIPPING_METHOD_CODE)="AIR" AND  trim(FOB_POINT_CODE)="FCA MUNICH") then
   DELIVERY_DATE1 = dateadd("d",8,DELIVERY_DATE)
else if (trim(SHIPPING_METHOD_CODE)="AIR(C)" AND  trim(FOB_POINT_CODE)="DDP") or (trim(SHIPPING_METHOD_CODE)="AIR" AND  trim(FOB_POINT_CODE)="DDP") or (trim(SHIPPING_METHOD_CODE)="AIR(C)" AND  trim(FOB_POINT_CODE)="DDU") or (trim(SHIPPING_METHOD_CODE)="AIR" AND  trim(FOB_POINT_CODE)="DDU") then
         DELIVERY_DATE1 = dateadd("d",13,DELIVERY_DATE) 
     else if (trim(SHIPPING_METHOD_CODE)="AIR(C)" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA" or trim(FOB_POINT_CODE)="FCA TAIWAN" or trim(FOB_POINT_CODE)="FOB TAIWAN")) or (trim(SHIPPING_METHOD_CODE)="AIR" AND (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA" or trim(FOB_POINT_CODE)="FCA TAIWAN" or trim(FOB_POINT_CODE)="FOB TAIWAN")) then
              DELIVERY_DATE1 = dateadd("d",0,DELIVERY_DATE) 
          else if (trim(SHIPPING_METHOD_CODE)="SEA(C)" AND  trim(FOB_POINT_CODE)="FCA MUNICH") or (trim(SHIPPING_METHOD_CODE)="SEA" AND  trim(FOB_POINT_CODE)="FCA MUNICH") then
                    DELIVERY_DATE1 = dateadd("d",42,DELIVERY_DATE) 
               else if (trim(SHIPPING_METHOD_CODE)="SEA(C)" AND  trim(FOB_POINT_CODE)="DDP") or (trim(SHIPPING_METHOD_CODE)="SEA" AND  trim(FOB_POINT_CODE)="DDP") or (trim(SHIPPING_METHOD_CODE)="SEA(C)" AND  trim(FOB_POINT_CODE)="DDU") or (trim(SHIPPING_METHOD_CODE)="SEA" AND  trim(FOB_POINT_CODE)="DDU") then
                         DELIVERY_DATE1 = dateadd("d",49,DELIVERY_DATE) 
                    else if (trim(SHIPPING_METHOD_CODE)="SEA(C)" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA" or trim(FOB_POINT_CODE)="FCA TAIWAN" or trim(FOB_POINT_CODE)="FOB TAIWAN")) or (trim(SHIPPING_METHOD_CODE)="SEA" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA" or trim(FOB_POINT_CODE)="FCA TAIWAN" or trim(FOB_POINT_CODE)="FOB TAIWAN")) then
                              DELIVERY_DATE1 = dateadd("d",0,DELIVERY_DATE) 
                         else if (trim(SHIPPING_METHOD_CODE)="DHL" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA")) or (trim(SHIPPING_METHOD_CODE)="EMS" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA")) or (trim(SHIPPING_METHOD_CODE)="FEDEX ECONOMY" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA")) or (trim(SHIPPING_METHOD_CODE)="FEDEX FIRST" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA")) or (trim(SHIPPING_METHOD_CODE)="FEDEX PRIORITY" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA")) or (trim(SHIPPING_METHOD_CODE)="TNT ECONOMY EXPRESS" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA"))  or (trim(SHIPPING_METHOD_CODE)="TNT SPECIAL EXPRESS" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA"))   or (trim(SHIPPING_METHOD_CODE)="UPS EXPEDITED" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA")) or (trim(SHIPPING_METHOD_CODE)="UPS EXPRESS" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA")) or (trim(SHIPPING_METHOD_CODE)="UPS EXPRESS PLUS" AND  (trim(FOB_POINT_CODE)="FOB CHINA" or trim(FOB_POINT_CODE)="FCA CHINA")) then
                                  DELIVERY_DATE1 = dateadd("d",0,DELIVERY_DATE)
                              else 
                                  DELIVERY_DATE1 = dateadd("d",3,DELIVERY_DATE)
                              end if
                         end if 
                    end if 
               end if 
          end if 
    end if 
end if 

if CUSTOMER_NAME="TRIDONIC. ATCO CONTROLS PTY. LTD." then
   DELIVERY_DATE1 = dateadd("d",7,DELIVERY_DATE)
else 
end if 

sql9="SELECT TO_CHAR(TO_DATE('" & DELIVERY_DATE1 & "','yyyy/mm/dd'),'DD-MON-YYYY') DELIVERY_DATE3 FROM DUAL"
set pp9=Ora_conn.execute(sql9)
%>
  <tr>
    <td width="8%"><b><font size="2" face="Arial"><%=i%></font></b></td>
    <td width="22%"><b><font size="2" face="Arial"><%=rs("item_description")%></font></b></td>
    <td width="16%"><b><font size="2" face="Arial"><%=REQUEST_DATE%></font></b></td>
    <td width="17%"><b><font size="2" face="Arial"><%=rs("order_number")%></font></b></td>
    <td width="12%"><b><font size="2" face="Arial"><%=PACKING_INSTRUCTIONS%></font></b></td>
    <td width="14%"><b><font size="2" face="Arial"><%=SRC_REQUESTED_QUANTITY%></font></b></td>
    <td width="11%" align=right><b><font size="2" face="Arial"><%=amount%></font></b></td>
  </tr>
  <tr>
    <td width="8%"></td>
    <td width="22%"><font size="2" face="Arial"><%=BILLTO_POSTALCODE%></font></td>
    <td width="16%"><font size="2" face="Arial"><%=pp9("DELIVERY_DATE3")%></font></td>
    <td width="17%"><font size="2" face="Arial"><%=rs("SHIPPING_METHOD_CODE")%></font></td>
    <td width="12%">　</td>
    <td width="14%"><font size="2" face="Arial"><%=UNIT_SELLING_PRICE%></font></td>
    <td width="11%">　</td>
  </tr>
</table>
  <font face="Arial">
  <%
  'response.write "<br>"
  rs.movenext   
  i=i+1
  loop
  %>
  <%    
        if trailer = 0 then
        else         
             for Datacount=trailer*2 to 15
             response.write "<br>"  
             next     
        end if
  %>
<% if  trailer <> 0 and trailer < 11  then%>  

<%'---------------表尾--------------------------------------------------------------------------%>
</font>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5" height="31">
   <tr>
    <td width="19%" height="15"></td>
    <td width="30%" height="15"></td>
    <td width="22%" height="15"></td>
    <td width="9%" height="15"></td>
    <td width="20%" height="15" align="right"></td>
  </tr>
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
    <td width="22%" height="16"><font face="Arial">Vat 16 %</font></td>
    <td width="9%" height="16"><font size=2 face="Arial"><%=currency_code%></font></td>
    <td width="20%" height="16" align="right"><font size=2 face="Arial"><%=vat%></font></td>
  </tr>
</table>
<HR color="#000000" align="right" width="51%" size="1" noshade style="word-spacing: 1; margin-top: 1; margin-bottom: 1">
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
  <tr>
    <td width="48%"><font face="Arial" size="2">PLEASE INDICATE OC NO. ON PAYMENTS<BR> 
	AGAINST PROFORMA INVOICE</font></td>
    <td width="23%"><font face="Arial">&nbsp;&nbsp; Total Amount </font></td>
    <td width="9%"><font face="Arial" size=2><%=currency_code%></font></td>
    <td width="20%" align="right"><font face="Arial" size=2><%=net_invoice_value%></font></td>
  </tr>
</table>
<HR color="#000000" align="right" width="51%" size="1" noshade style="word-spacing: 1; margin-top: 1; margin-bottom: 1">
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber8" height="41">
  <tr>
    <td width="57%" height="41" align="left" valign="top">
	<font size=2 face="Arial"><%=Bank%></font></td>
    <td width="43%" height="41"></td>
  </tr>
</table>
<font face="Arial">
<% else if trailer = 0 then
              response.write "<hr>"
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
<img width=241 height=53 src="index1.files/image002.jpg" v:shapes="_x0000_s1025" loop="0" start="mouseover"><!--</span>--></font></td>
    <td width="54%" height="46"><p align="left"><b><font face="Arial" size="4">TAIWAN SEMICONDUCTOR CO.,LTD.<u> </u></font>
    <font face="Arial"><u><font size="6"> <br>
</font></u></font></b><font face="Arial" size="2">&nbsp;11FL.,No.205,Sec.3,Beishin 
    Rd., Shindian City <br>
&nbsp;TAIPEI  . TAIWAN R.O.C. </font><font face="Arial"><br>&nbsp;<font size="2">T</font>el: 
    <font size="2">+886-2-89131588</font><br><font size="2">&nbsp; F</font>ax:<font size="2">+886-2-89131788&nbsp;</font></font></p></td>
  </tr>
</table>
　<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="95%" id="AutoNumber1" height="41">
  <tr>
    <td width="44%" height="20"></td>
    <td width="1%" height="20"></td>
    <td width="55%" height="20"><font face="Arial"><u>Ship&nbsp; to:</u></font></td>
  </tr>
  <tr>
    <td width="44%" height="21"><font size=2 face="Arial"><%="<br>" & CUSTOMER_NAME & "<br>" &  "" & address & "<br>" & "" & postal_code & " " & "" & city & "<br>" & "" & country & ""  %></font></td>
    <td width="1%" height="21"></td>
    <td width="55%" height="21"><font size=2 face="Arial"><%="" & ship_to_customer & "<br>" & "" & DELIVER_TO_ADDRESS1 & ""%></font></td>
  </tr>
</table>
　<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="985" id="AutoNumber2">
  <tr>
    <td width="124"><font face="Arial">VAT Reg.No.:</font></td>
    <td width="370"><font face="Arial"><%=tax_reference%></font></td>
    <td width="22"></td>
    <td width="469"><font face="Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Page:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=p%>&nbsp;&nbsp;&nbsp; 
    of&nbsp;&nbsp; <%=sum%></font></td>
  </tr>
</table>
　<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
  <tr>
    <td width="20%"><font face="Arial">OC/PI #:</font></td>
    <td width="55%"><font face="Arial"><%=PI_SEQNO%></font></td>
    <td width="8%"><font face="Arial">Date:</font></td>
    <td width="17%"><font face="Arial"><%=INITIAL_PICKUP_DATE%></font></td>
  </tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber2">
  <tr>
    <td width="75%"><font face="Arial">Customer P/O:<b><%=CUST_PO_NUMBER%></b></font></td>
    <td width="16%"><font face="Arial">Revision:&nbsp; <%=VERSION_NUMBER%> </font>
</td>
    <td width="9%">　</td>
  </tr>
</table>
　<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3">
  <tr>
    <td width="20%"><font face="Arial" size="2">Payment Term:</font></td>
    <td width="17%"><font size="2" face="Arial"><%=terms%></font></td>
    <td width="20%"><font face="Arial" size="2">Shipment Term:</font></td>
    <td width="20%"><font size="2" face="Arial"><%=FOB_POINT_CODE%></font></td>
    <td width="14%"><font face="Arial" size="2">Currency:</font></td>
    <td width="9%"><font size="2" face="Arial"><%=CURRENCY_CODE%></font></td>
  </tr>
   </table>
<p style="margin-top: 0; margin-bottom: 0"></p>
<HR>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber4">
  <tr>
    <td width="8%"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2">&nbsp; Item</font></b></td>
    <td width="22%"><b><font face="Arial" size="2">Description&nbsp; /</font></b></td>
    <td width="15%"><p style="margin-top: 0; margin-bottom: 0"><b>
	<span lang="EN-US" style="font-size: 10.0pt; font-family: Arial">CRD&nbsp; /</span></b></td>
    <td width="17%"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2">MO No.&nbsp; 	/</font></b></td>
    <td width="13%"><b><font face="Arial" size="2">
	Country </font></b></td>
    <td width="14%"><p style="margin-top: 0; margin-bottom: 0"><b>
	<span lang="EN-US" style="font-size: 10.0pt; font-family: Arial">Qty(pcs)&nbsp; /</span></b></td>
    <td width="17%"><p style="margin-top: 0; margin-bottom: 0"><b>
	<font face="Arial" size="2">Amount</font></b></td>
  </tr>
  <tr>
    <td width="8%" height="17"><p style="margin-top: 0; margin-bottom: 0"><b><font face="Arial" size="2">&nbsp; </font></b></td>
    <td width="22%" height="17"><font face="Arial" size="2">Customer PN</font></td>
    <td width="15%" height="17"><p style="margin-top: 0; margin-bottom: 0"><font face="Arial" size="2">Delivery Date</font></td>
    <td width="17%" height="17"><p style="margin-top: 0; margin-bottom: 0"><font size="2" face="Arial">Ship Method</font></td>
    <td width="13%" height="17"><font face="Arial" size="2">
	Of Origin</font></td>
    <td width="14%" height="17"><p style="margin-top: 0; margin-bottom: 0">
	<span lang="EN-US" style="font-size: 10.0pt; font-family: Arial">Unit Price</span></td>
    <td width="17%" height="17"><p style="margin-top: 0; margin-bottom: 0"></td>
  </tr>
</table>
<HR>
<font face="Arial">
<%
 for Datacount1=1 to 17
        response.write "<br>"  
        next  
%>

<%'---------------表尾--------------------------------------------------------------------------%>
</font>
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5" height="31">
   <tr>
    <td width="19%" height="15"></td>
    <td width="30%" height="15"></td>
    <td width="22%" height="15"></td>
    <td width="9%" height="15"></td>
    <td width="20%" height="15" align="right"></td>
  </tr>
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

<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber5">
  <tr>
    <td width="48%"><font face="Arial" size="2">PLEASE INDICATE OC NO. ON PAYMENTS <BR>
	AGAINST PROFORMA INVOICE</font></td>
    <td width="23%"><font face="Arial">&nbsp;&nbsp; Total Amount </font></td>
    <td width="9%"><font face="Arial" size=2><%=currency_code%></font></td>
    <td width="20%" align="right"><font face="Arial" size=2><%=net_invoice_value%></font></td>
  </tr>
</table>
<HR color="#000000" align="right" width="51%" size="1" noshade style="word-spacing: 1; margin-top: 1; margin-bottom: 1">
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber8" height="41">
  <tr>
    <td width="57%" height="41" align="left" valign="top">
	<font size=2 face="Arial"><%=Bank%></font></td>
    <td width="43%" height="41"></td>
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