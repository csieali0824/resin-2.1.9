<!-- modify by Peggy 20150305,增加年度條件及是否清除該年度所有DC資料-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Authentication==========-->
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Date Code Uploading Center</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{ 
	var DEL_FLAG="N";
	if (document.MYFORM.DC_YEAR.value =="")
	{
		alert("請輸入年度");
		document.MYFORM.DC_YEAR.focus();
		return false;
	}
	else if (eval(document.MYFORM.DC_YEAR.value) <=2011 || eval(document.MYFORM.DC_YEAR.value)>2099)
	{
		alert("年度格式或值錯誤!");
		document.MYFORM.DC_YEAR.focus();
		return false;	
	}
	if (document.MYFORM.UPLOADFILE.value ==null || document.MYFORM.UPLOADFILE.value=="")
	{
		alert("請先按瀏覽鍵選擇上傳的檔案!");
		return false;
	}
	else
	{
		var filename = document.MYFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('上傳檔案必須為office 2003 excel檔!');
			document.MYFORM.UPLOADFILE.focus();
			return false;	
		}
	}
	if (document.MYFORM.chk.checked)
	{
		DEL_FLAG="Y";
	}
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.action=URL+"?DC_YEAR="+document.MYFORM.DC_YEAR.value+"&DEL_FLAG="+DEL_FLAG;
 	document.MYFORM.submit();
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" ACTION="../jsp/TSCMfgDateCodeInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">
<BR><HR>
<strong><font color="#004080" size="4">Date Code 檔案上傳</font></strong> 
<table width="70%" border="1">
	<tr> 
    	<td width="20%" align="right"><font color="#004080"><strong>Date Code年度</strong></font></td>
      	<td width="80%"><INPUT TYPE="TEXT" NAME="DC_YEAR" size="7" style="font-family:Tahoma,Georgia;font-size: 12px">(西元年:YYYY)&nbsp;&nbsp;&nbsp;<input type="checkbox" name="chk" value="Y">上傳前刪除該年度所有Date Code資料</td>
    </tr>
	<tr> 
    	<td width="20%" align="right"><font color="#004080"><strong>Upload File</strong></font></td>
      	<td width="80%"><INPUT TYPE="FILE" NAME="UPLOADFILE" size="80" style="font-family:Tahoma,Georgia;font-size: 12px"></td>
    </tr>
	<tr>
    	<td width="20%" align="right"><font color="#004080"><strong>Download Sample File</strong></font></td>
      	<td width="80%"><a title="按下此連結，下載excel上傳範本" href='..//jsp/samplefiles/D7-001_DCUPLOAD_Samplefile.xls'><font style="font-size:14px;font-family:arial">Download Sample File</font></a></td>
	</tr>
	<tr>
		<td colspan="2" align="center"><INPUT TYPE="button"  name="submit1" value="UPLOAD" style="font-family:Tahoma,Georgia;font-size: 12px" onClick='setSubmit("../jsp/TSCMfgDateCodeInsert.jsp")'></td>
	</tr>
</table> 
<p>1.上傳檔案請依以下格式,第一列為標題列,實際資料由第二列填起。<br>
   2.TSC_PACKAGE欄位,若無特例型號填列"YEW",餘填列實際Package。<br>
   3.TSC_MAKEBUY欄位,外購代填列"PUR",自製型號填列"TSC"。<br>
   4.PERIOD欄位,格式為'YYYY/MM',例:2007/01。<br>
   5.WEEK欄位,格式為整數字,例:1,2,3...。<br>
   6.DATE_CODE欄位,填列該月份實際對應之DATE_CODE。<br>
   7.工作表名稱請命名為'Sheet1',並置於最左邊第一個sheet。
<br><br>
<img src="images/yew_dc.png" width="450" height="220"></p>
<!--
<table border="1">
	<tr bgcolor="#BBBBBB">
		<td>&nbsp;</td><td>A</td> <td>B</td> <td>C</td> <td>D</td><td> E </td> 
	</tr>
	<tr >
		<td bgcolor="#BBBBBB">1</td> <td>TSC_PACKAGE</td><td>TSC_MAKEBUY</td> <td>PERIOD</td> <td>DATE_CODE</td> <td>&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr >
		<td bgcolor="#BBBBBB">2</td> <td>TS-1</td><td>TSC</td><td>2007/01</td><td>C1</td><td>&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#BBBBBB">3</td> <td>TS-1</td><td>TSC</td><td>2007/02</td><td>C2</td><td>&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td bgcolor="#BBBBBB">4</td> <td>TS-1</td><td>PUR</td><td>2007/01</td><td>71</td><td>&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr><td colspan=12>以下類推....</td></tr>
</table> -->
</FORM>
</body>
</html>

