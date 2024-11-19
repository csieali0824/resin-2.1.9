<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Authentication==========-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Data Model Upload - PIS Check List File Uploading Center</title>
</head>

<body>
<FORM NAME="MYFORM" ACTION="../jsp/PISCheckListFileUploadInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">

  <strong><font color="#004080" size="4">PIS Check List File Uploading Center</font></strong> 
  <table width="64%" border="1">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080"><strong>      Upload FILE</strong></font></div></td>
      <td width="74%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="UPLOADFILE">
        </font></td>
    </tr>
  </table>  
  <p> 
    <INPUT TYPE="submit" value="UPLOAD">
  </p>
</FORM>
</body>
</html>
