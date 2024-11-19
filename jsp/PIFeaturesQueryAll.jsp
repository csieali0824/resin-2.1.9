<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QueryAllCheckBoxBean" %>

<html>
<head>
<title>Query All Features Data</title>
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
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
}
function NeedConfirm()
{ 
 flag=confirm("是否確定刪除?"); 
 return flag;
}
</script>

<body><FORM ACTION="../jsp/PIFeaturesDel.jsp" METHOD="POST" onSubmit="return NeedConfirm()"> 
<input name="button" type=button onClick="this.value=check(this.form.CH)" value="全部選取">
<INPUT TYPE="submit" value="Delete">&nbsp;&nbsp;<A HREF="PIFeaturesInput.jsp">New Features</A>&nbsp;&nbsp;<A HREF="/wins/WinsMainMenu.jsp">Home</A> 
<jsp:useBean id="queryAllCheckBoxBean" scope="page" class="QueryAllCheckBoxBean"/>
<% 
 try
 {  
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select * from PIFEATURES ORDER BY FEATURECODE");
   queryAllCheckBoxBean.setRs(rs);
   queryAllCheckBoxBean.setFieldName("CH");
   queryAllCheckBoxBean.setRowColor1("B0E0E6");
   queryAllCheckBoxBean.setRowColor2("ADD8E6");
   out.println(queryAllCheckBoxBean.getRsString());
   
   statement.close();
   rs.close();   
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
