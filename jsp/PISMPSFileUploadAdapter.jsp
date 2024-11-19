<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Authentication==========-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>PIS MPS File Uploading Center</title>
</head>

<body>
<FORM NAME="MYFORM" ACTION="../jsp/PISMPSFileUploadInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">
<A HREF='../WinsMainMenu.jsp'>HOME</A><BR>
  <strong><font color="#004080" size="4">PIS MPS  File Uploading Center</font></strong> 
  <table width="64%" border="1">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080"><strong>      Upload FILE</strong></font></div></td>
      <td width="74%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="UPLOADFILE">
        </font></td>
    </tr>
  </table> 
<p>1.上傳檔案請依以下格式, 最多只能處理10個機種 </p>
<P>2.自C3的位置開始是機種代碼</P>
<P>3.自A8的位置開始是DAY, 格式為SUN, MON, TUE, WED, THU, FRI, SAT</P>
<P>4.自B8的位置開始是DATE,格式請用YYYY/MM/DD</P>
<P>5.自C8到L8的位置往下是數量, 數量請勿使用非數字內容, 否則無法上傳</P>
<P>6.若有每週小計系統會自動略過</P>

<table border="1">
	<tr>
		<td>&nbsp;</td><td>A</td> <td>B</td> <td>C</td> <td>D</td> <td>E</td> <td>F</td> <td>G</td> <td>H</td> <td>I</td> <td>J</td> <td>K</td> <td>L</td>
	</tr>
	<tr>
		<td>3</td> <td>&nbsp;</td> <td>&nbsp;</td> <td>MODEL1</td> <td>MODEL2</td> <td>MODEL3</td> <td>MODEL4</td> <td>MODEL5</td> <td>MODEL6</td> <td>MODEL7</td> <td>MODEL8</td> <td>MODEL9</td> <td>MODEL10</td>
	</tr>
	<tr>
		<td>8</td> <td>SUN</td><td>2004/12/20</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td>
	</tr>
	<tr>
		<td>9</td> <td>MON</td><td>2004/12/21</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td><td>QTY</td>
	</tr>
	<tr><td colspan=12>以下類推</td></tr>
</table> 
  <p> 
    <INPUT TYPE="submit" value="UPLOAD">
  </p>
</FORM>
</body>
</html>
