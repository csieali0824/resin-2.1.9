<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Authentication==========-->
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>PO Receipt Upload</title>
</head>

<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" ACTION="../jsp/TSCPoReceiptInsert.jsp?PTYPE=1" METHOD="post" ENCTYPE="multipart/form-data">
<BR><HR>
  <strong><font color="#004080" size="4" face="Arial">整批接收 檔案上傳</font></strong> 
  <table width="80%" border="1">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080" face="Arial"><strong><font color="#004080">上傳檔案位置 </font>    </strong></font></div></td>
      <td width="74%"><font size="2">
        <INPUT TYPE="FILE"NAME="UPLOADFILE" size="50">
        <INPUT name="submit" TYPE="submit" value="UPLOAD" >
      </font></td>
    </tr>
  </table> 
<p><font color="#000099">1.上傳的Excel檔案,請勿開啟。<br>
   2.同批上傳的資料,會產生同一個驗收單號。<br>
   3.上傳EXCEL檔案請依以下格式,第一列為標題列,實際資料由第二列填起。<br>
   4.欄位依序排列好位置要正確,否則會抓錯資料。<br>
   5.請確認PO單號及料號是正確的,此為比對依據。<br>
   6.A01廠區請加填"有效期"欄位,其餘各廠不需要。<br>
   7.項次欄位請勿重覆。<br>
   8.範例格式如下所示:</font><br>
   <br>
  <img src="images/rcv.jpg" ></p>
<p>&nbsp;</p>
</FORM>
</body>
</html>

