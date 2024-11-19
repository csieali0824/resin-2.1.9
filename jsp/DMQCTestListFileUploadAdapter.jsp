<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="DateBean" %>

<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>upload file - Daily Product Schedule</title>
</head>

<body>
<%   
  	  //取得傳入參數
      String sModelNo = request.getParameter("MODELNO");
	  if (sModelNo ==null) {sModelNo ="" ;out.println("未傳入MODELNO");}
%>

<FORM NAME="MYFORM" ACTION="../jsp/DMQCTestListFileUploadInsert.jsp?MODELNO=<%=sModelNo%>" METHOD="post" ENCTYPE="multipart/form-data">
  <A HREF='../WinsMainMenu.jsp'>HOME</A> <strong><font color="#004080" size="4"> 
    品質驗證進度 File Upload</font></strong> </p>
  <table width="64%" border="1">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080"><strong>Upload 
          FILE</strong></font></div></td>
      <td width="74%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="UPLOADFILE">
        </font></td>
  </table>
  <p> 
    <INPUT name="submit" TYPE="submit" value="UPLOAD">
  </p>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
