<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Authentication==========-->
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Labor Rate and Overhead Rate Revise Upload</title>
</head>

<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" ACTION="../jsp/TSCMfgSubelementRateReviseInsert.jsp?PTYPE=1" METHOD="post" ENCTYPE="multipart/form-data">
<BR><HR>
  <strong><font color="#004080" size="4" face="Arial">Labor Rate and Overhead Rate Revise Upload</font></strong> 

<%   
	// 20121224 Marvie Add : TSC and YEW use
	String errorFlag = "N";
	String sLegalEntityID = "";
	if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("TSC_COST")>=0) {
		sLegalEntityID = "41";
	} else if (UserRoles.indexOf("YEW_COST")>=0) {
		sLegalEntityID = "325";
	} else {
		out.println("Exception get sLegalEntityID: setup error");
		errorFlag = "Y";
	}

    if (errorFlag=="N" || errorFlag.equals("N")) {
%>

  <table width="80%" border="1">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080" face="Arial"><strong><font color="#004080">File </font>    </strong></font></div></td>
      <td width="74%"><font size="2">
        <INPUT TYPE="FILE"NAME="UPLOADFILE" size="50">
        <INPUT name="submit" TYPE="submit" value="UPLOAD" >
      </font></td>
    </tr>
  </table> 
<p><font color="#000099">1.上傳的Excel檔案, 請勿開啟。<br>
   2.上傳EXCEL檔案請依以下格式, 第一列為標題列, 實際資料由第二列填起。<br>
   3.欄位依序排列好位置要正確, 否則會抓錯資料。<br>
   4.請確認Subelement及Name是正確的, 此為比對依據。<br>
   5.Description, Hour 參考用, 不比對資料是否一致, 不修改資料。<br>
   6.Amount, Rate 不得為空白或文字。<br>
   7.Rate, 與原資料(Resource Rate 或 Overhead Rate)不同, 即可進行修改資料。<br>
   8.Amount, 資料保留給成本計算時, 合計數字不同時進行差異調整。<br>
   9.範例格式如下所示:</font><br>
   <br>
  <img src="images/subelementraterevise_<%=sLegalEntityID%>.jpg" ></p>

<%
	}
%>

<p>&nbsp;</p>
</FORM>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
