<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>無標題文件</title>
<SCRIPT Language = javascript>
function datacheck(){
   if(kelly.q_1.value == ""){
      window.alert("It is empty of Po_number field!!");
      //
      document.kelly.q_1.focus();
      //
      return;
   }

   
	kelly.submit();
}
</script>

</head>
<!-- #include file="public/default_value.asp" -->
<%
 	created_by 	= 	"kelly"
	p_name ="lin"
	p_birth ="20060616"
	p_num =5
	p_1 =200
	
	string1=p_num * p_1
	response.write(string1)
	
	cust_po_num	=	1
	
	 
	
	'response.end
	
	
	Set conn = Server.CreateObject("ADODB.Connection")
	conn.open db_connection_str
	sql_cust = "SELECT * FROM tsc_cust_po_header "
	Set rs = conn.execute(sql_cust)
	while not rs.eof 
		'customer_id = rs("doc_id")
		'customer_name = rs("cust_po_num")
		'response.Write  " <td>"& customer_id&" </td><br>"
		'response.Write  " <td>"& customer_name&" </td><br>"
	rs.movenext
	wend
	
	

 
 

%>

<body>
<form name="kelly" method="post" action="two.asp">
  <p>
    <input type="text" name="q_1">
  </p>
  <p>&nbsp;</p>
  <p>
    <input type="text" name="2">
</p>
  <p>
    <input type="hidden" name="3" value="tsc">
  </p>
  <p>
    <input type="button" name="Submit" value="按鈕" onClick="datacheck()">
</p>
</form>
</body>
</html>
