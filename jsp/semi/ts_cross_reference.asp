<html>
 
<%
	db_connection_str	=	"Driver={SQL Server};Database=website" &_
       	    	  	 		";server=localhost" &_
           		  	 		";UID=web" &_
               	  	  		";PWD=6227"


%>
<title>Create Invoice</title>
<head>
<script language = javascript>
function datacheck(){
   if(form1.ts_cross_ref.value.length < 3){
      window.alert("You must enter at least 3 characters!!");
      document.form1.ts_cross_ref.focus();
      return;
   }
	form1.submit();
}
</script>

</head>
<body>
 
<%
	ts_cross_ref = 	request.form("ts_cross_ref")
%>

<form action="ts_cross_reference.asp" method="post"  name="form1"  >
<td><font color="#990000" size="2">Cross Reference: aaa Total matches: 6</font></td><br>
<td><font color="#990000" size="2">New Competitor Cross Reference</font></td><br>

  <input type="text" name="ts_cross_ref" value=""> 
  <input type="button" name="Search" value="submit"  onClick="datacheck()">
  <%
  	if ts_cross_ref = "" then 
	else 
	response.write("<table width ='770'")
	response.write("<tr><td>industry no</td><td>compeiter</td><td>tsc no</td><td>status</td></tr>")

		Set conn = Server.CreateObject("ADODB.Connection")
		
		'response.write(conn)
		conn.open db_connection_str
		sql_ref = 	" select industry_no , company , tsc_pn , status from ts_cross_reference "&_
					" where industry_no like '%"&ts_cross_ref&"%' order by industry_no asc "
		 response.write(sql_ref)
		 response.end
		Set rs = conn.execute(sql_ref)
		while not rs.eof 
			ts_industry_no  = rs("ts_industry_no")
			ts_company  = rs("ts_company")
			ts_pn  = rs("tsc_pn")
			ts_status = rs("ts_status")
			response.write("<tr><td>"&ts_industry_no&"</td><td>"&ts_company&"</td><td>"&ts_pn&"</td><td>"&ts_status&"</td></tr>")
		rs.movenext
		wend
  	end if
	response.write("</table>")
  %>
</form>

</body>
</html>
