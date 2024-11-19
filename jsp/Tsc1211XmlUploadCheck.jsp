<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*" %>
<jsp:useBean id="myUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<%
	String fileName = null;
	String errorMessage = null;
	myUpload.initialize(pageContext);
	myUpload.upload();
	
	if(myUpload.getFiles().getCount()>0){
		com.jspsmart.upload.File myFile = myUpload.getFiles().getFile(0);
		if (!myFile.isMissing()){
			fileName = myFile.getFileName();
			myFile.saveAs("/jsp/upload_xml/"+fileName);
			session.setAttribute("pic",fileName);
		}
	}
	response.sendRedirect("Tsc1211XmlUpload.jsp");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<%
	if(errorMessage == null){
%>
<script language="JavaScript" type="text/JavaScript">
<!--
window.close();
//-->
</script>
<%
	}
%>
<title>無標題文件</title>
</head>

<body>
<%=errorMessage%>

</body>
</html>
