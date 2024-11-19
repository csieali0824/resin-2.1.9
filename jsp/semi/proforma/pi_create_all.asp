<%
 ts_lan		= "US"
 ts_status	= "A"   '????
 ts_flag 	= ""    '????
 ts_deliver	= "DELIVER_TO"
 ts_bill	= "BILL_TO"
 ts_uom		=
 ts_invoice_no=ucase(trim(request("invoice_no")))
 ts_date=trim(request("date"))
 lang="US"
 stat="A"
 flag="Y"
 deliv="DELIVER_TO"
 billto="BILL_TO"
 kp="KPC"
 DDD="DD-Mon-RRRR"
  

 invoice_no1=left(trim(request("invoice_no")),8)
 session("invoice_no")=ucase(trim(request("invoice_no")))
 V_Shipto=trim(request("V_Shipto"))
  


%>