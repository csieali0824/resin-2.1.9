<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="DateBean" %>

<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>upload file - Material Status</title>
</head>

<body>
<FORM NAME="MYFORM" ACTION="../jsp/DMMaterialStatusUpdateFileUploadInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">

  <strong><font color="#004080" size="4">Material Status  
  File Upload</font></strong> 
  <table width="64%" border="1">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080"><strong>Upload FILE</strong></font></div></td>
      <td width="74%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="UPLOADFILE">
        </font></td>
    </tr>
  </table>  
  <p> 
    <INPUT TYPE="submit" value="UPLOAD">
  </p>
  <P>轉入EXCEL檔案請依以下格式</P>
  <P>1.該work sheet名稱請用YYYYMMDD表示, 例如 : 20041101</P>
  <P>2.1~4列為標題</P>
  <P>3.C8開始為機種代碼</P>
  <P>4.當A行中出現&quot;TOTAL&quot; 即結束</P>
	
  <table width="100%" border="1">
    <tr> 
      <td width="8">&nbsp;</td>
      <td><div align="center">A</div></td>
      <td><div align="center">B</div></td>
      <td><div align="center">C</div></td>
      <td><div align="center">D</div></td>
      <td><div align="center">E</div></td>
      <td><div align="center">F</div></td>
      <td><div align="center">G</div></td>
      <td><div align="center">H</div></td>
      <td><div align="center">I</div></td>
      <td><div align="center">J</div></td>
      <td><div align="center">K</div></td>
      <td><div align="center">L</div></td>
      <td><div align="center">M</div></td>
      <td><div align="center">N</div></td>
    </tr>
    <tr> 
      <td>1</td>
      <td colspan="14">&nbsp;</td>
    </tr>
    <tr> 
      <td>2</td>
      <td colspan="14"><div align="center">DBTEL Incorporated</div></td>
    </tr>
    <tr> 
      <td>3</td>
      <td colspan="14"><div align="center">MATERIALS STATUS</div></td>
    </tr>
    <tr> 
      <td>4</td>
      <td colspan="14">&nbsp;</td>
    </tr>
    <tr> 
      <td>5</td>
      <td colspan="3" bgcolor="#FFFFFF">&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>6</td>
      <td width="47" rowspan="2"><div align="center"><font size="2" face="標楷體">IC類別</font></div></td>
      <td width="39" rowspan="2"><div align="center"><font size="2" face="標楷體">Model</font></div></td>
      <td width="56" rowspan="2"><div align="center"><font size="2" face="標楷體">Model</font></div></td>
      <td width="42" rowspan="2"> <p align="center"><font size="2" face="標楷體">Total</font><font size="2" face="標楷體"> 
          購料數</font></p></td>
      <td width="42" rowspan="2"><div align="center"><font size="2" face="標楷體">未含本月累計出貨數</font></div></td>
      <td width="17" rowspan="2"><div align="center"><font size="2" face="標楷體">樣品需求</font></div></td>
      <td width="29" rowspan="2"><div align="center"><font size="2" face="標楷體">本月 
          出貨數</font></div></td>
      <td width="63" rowspan="2"><div align="center"><font size="2" face="標楷體">成品 
          Inventory</font></div></td>
      <td width="48" rowspan="2" bgcolor="#FFFF66"><div align="center"><font size="2" face="標楷體">剩餘 
          材料數</font></div></td>
      <td width="33" rowspan="2" bgcolor="#66FFFF"><div align="center"><font size="2" face="標楷體">WIP</font></div></td>
      <td width="44" rowspan="2"><div align="center"><font size="2" face="標楷體">成套 
          材料數</font></div></td>
      <td width="44" rowspan="2"><div align="center"><font size="2" face="標楷體">成套 
          材料數 (80%)</font></div></td>
      <td width="90" rowspan="2"><div align="center"><font size="2" face="標楷體">不成套材料數</font></div></td>
      <td width="57" rowspan="2"><div align="center"><font size="2" face="標楷體">Remark</font></div></td>
    </tr>
    <tr> 
      <td>7</td>
    </tr>
    <tr> 
      <td>8</td>
      <td><div align="right"><font color="#000000"><font size="2"><font face="Arial, Helvetica, sans-serif"></font></font></font></div></td>
      <td><div align="right"><font color="#000000"><font size="2"><font face="Arial, Helvetica, sans-serif"></font></font></font></div></td>
      <td><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">2052C</font></div></td>
      <td><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">186,000</font></div></td>
      <td><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">167,255</font></div></td>
      <td><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">96</font></div></td>
      <td><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">2,000</font></div></td>
      <td><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">3,472</font></div></td>
      <td bgcolor="#FFFF66"><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">13,177</font></div></td>
      <td bgcolor="#66FFFF"><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">3,35</font></div></td>
      <td><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">2,842</font></div></td>
      <td><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">0</font></div></td>
      <td><div align="right"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif">10,000</font></div></td>
      <td><div align="right"><font color="#000000"><font size="2"><font face="Arial, Helvetica, sans-serif"></font></font></font></div></td>
    </tr>
  </table>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
