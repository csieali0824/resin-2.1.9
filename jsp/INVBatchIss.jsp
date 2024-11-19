<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,java.lang.Math.*,java.io.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Authentication==========-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>

<title>Batch Iss Uploading Center</title>
<script language="JavaScript" type="text/JavaScript">
function submitCheck1(URL)
{ 

  if (document.MYFORM.QUANTITY.value=="" || document.MYFORM.QUANTITY.value==null)
  { 
   alert("請先輸入套數後再上傳!!");   
   return(false);
  } 

  if (document.MYFORM.UPLOADFILE.value=="" || document.MYFORM.UPLOADFILE.value==null)
  { 
   alert("請先選擇Uplead File後再上傳!!");   
   return(false);
  } 

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<%@ page import="java.io.*,com.jspsmart.upload.*,CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<body>
<FORM NAME="MYFORM" ACTION="../jsp/INVBatchIssCheck.jsp" METHOD="post" ENCTYPE="multipart/form-data" >
<A HREF="/wins/WinsMainMenu.jsp">HOME</A><BR>  
<strong><font color="#0080FF" size="5">批次領料單新增</font></strong>
<table width="96%" border="1">
  <tr>
    <td colspan="1">填表人: <%=userID+"("+UserName+")"%> <br>
    </td>
    <td colspan="1"> 異動類型:I-領料</td>
    <td colspan="1"> 事由:
        <input type="TEXT" name="REMARK" size=30 maxlength="30"></td>	
  </tr>
  <tr>
    <td colspan="1"> 專案代碼:
        <input type="TEXT" name="PROJECT" size=15 maxlength="15"></td>			
    <td colspan="1"> 套數:
        <input type="TEXT" name="QUANTITY" size=10 maxlength="10"></td>
    <td colspan="1"> Upload FILE:
      <input type="FILE" name="UPLOADFILE">
      <INPUT name="button" TYPE="button" onClick='submitCheck1("../jsp/INVBatchIssCheck.jsp")' value='上傳'></td>
  </tr>	
</table>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
