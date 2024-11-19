<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean" %>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<title>Query All Product Factory Person</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>

<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function NeedConfirm()
{ 
 flag=confirm("Do You really want delete all?"); 
 return flag;
}
</script>

<body><FORM ACTION="../jsp/TSSDRQProdPersonDel.jsp" METHOD="POST" onSubmit="return NeedConfirm()"> 
<input name="button" type=button onClick="this.value=check(this.form.CH)" value="<jsp:getProperty name="rPH" property="pgSelectAll"/>">
<INPUT TYPE="submit" value="<jsp:getProperty name="rPH" property="pgDelete"/>">
&nbsp;&nbsp;<A HREF="../jsp/TSSDRQProdPersonInput.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgProdPC"/></A>&nbsp;&nbsp;<A HREF="/Oradds/OraddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A> 

<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
<%  
  try
  {
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select USERID,PROD_FACNO||MANUFACTORY_NAME as FACTORY_NAME,PROD_PERSONNO,USERNAME from ORADDMAN.TSPROD_PERSON a, ORADDMAN.TSPROD_MANUFACTORY b where a.PROD_FACNO =b.MANUFACTORY_NO order by PROD_FACNO,PROD_PERSONNO");
   qryAllChkBoxEditBean.setPageURL("../jsp/TSSDRQProdPersonEditPage.jsp");
   qryAllChkBoxEditBean.setSearchKey("USERID");
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   qryAllChkBoxEditBean.setRowColor2("ADD8E6");
   qryAllChkBoxEditBean.setRs(rs);   
   out.println(qryAllChkBoxEditBean.getRsString());
   
   statement.close();
   rs.close();   
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</FORM>
</body>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
