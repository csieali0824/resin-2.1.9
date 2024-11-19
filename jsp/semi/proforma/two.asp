<%
response.write("<html>")
	q_1			= 	UCASE(Request.Form("1"))
	q_2=	Request.Form("2")
	q_3=	Request.Form("3")
	
	q_4 = date
	
	response.write("<td>"&q_1&"</td><br>")
	response.write("<td>"&q_2&"</td><br>")
	response.write("<td>"&q_3&"</td><br>")
	response.write("<td>"&q_4&"</td><br>")
	response.end

%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>無標題文件</title>
</head>

<body>

</body>
</html>
