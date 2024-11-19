<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Authentication==========-->
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>SAFTY STOCK Uploading Center</title>
</head>

<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" ACTION="../jsp/TSCMfgSaftyStockInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">
<BR><HR>
  <strong><font color="#004080" size="4" face="Arial">Safty Stock 檔案上傳</font></strong> 
  <table width="64%" border="1">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080" face="Arial"><strong>    Upload FILE</strong></font></div></td>
      <td width="74%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="UPLOADFILE">
        </font></td>
    </tr>
  </table> 
<p>1.上傳檔案請依以下格式,第一列為標題列,實際資料由第二列填起。<br>
   2.ORG ID欄位,內銷請填326,外銷請填327。<br>
   3.ITEM NO欄位,填列欲增加安全庫存的料號。<br>
   4.ITEM DESC欄位,填列品名,非必填欄位,轉入時系統以料號抓取系統所載品名。<br>
   5.UOM欄位,填列計量單位,非必填欄位,轉入時系統以料號抓取系統所載計量單位。<br>
   6.SAFTY_STOCK欄位,填列安全庫存數量。<br>
   7.工作表名稱請訂為'Sheet1'。
</p>
<table border="1">
	<tr bgcolor="#BBBBBB">
		<td>&nbsp;</td><td>A</td> <td>B</td> <td>C</td> <td>D</td><td>E</td> 
	</tr>
	<tr >
		<td bgcolor="#BBBBBB">1</td> <td>ORG ID</td><td>ITEM NO</td> <td>ITEM DESC</td> <td>UOM</td> <td>SAFTY STOCK</td>
	</tr>
	<tr >
		<td bgcolor="#BBBBBB">2</td> <td>326</td><td>09-0505010</td><td>裸銅粒 3.96x0.75</td><td>KPC</td><td>200</td>
	</tr>
	<tr>
		<td bgcolor="#BBBBBB">3</td> <td>327</td><td>10-EN9N00DG0</td><td>4"SF(30-45) 晶片</td><td>PCE</td><td>50</td>
	</tr>
	<tr>
		<td bgcolor="#BBBBBB">4</td> <td>327</td><td>11-KNSH70800</td><td>HERGPP70MIL 800V 晶粒</td><td>KPC</td><td>50</td>
	</tr>
	<tr><td colspan=12>以下類推....</td></tr>
</table> 
  <p> <INPUT TYPE="submit" value="UPLOAD" > </p>
</FORM>
</body>
</html>

