<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>RoleAdd1.jsp</title>
</head>

<body>
<form action="../jsp/RoleAdd.jsp" method="post" name="signform" onSubmit="return check();">
  <table  border="1" align="center" bordercolor="#6699CC" >
    <tr>
      <td width="634" height="73" background="../image/back5.gif"> 
        <p><a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp; <A HREF="../jsp/RoleShow.jsp">查詢所有角色</A><br>
        </p>
        <p><strong><font color="#FF0000">角色新增</font></strong></p></td>
    </tr>
    <tr>
      <td bgcolor="#DEF5FE">角色名稱: 
        <input type="text" name="ROLENAME" size="20" maxlength="20">
        <br>
        內容說明:
        <input type="text" name="ROLEDESC" size="30" maxlength="40">
      </td>
    </tr>
    <tr>
      <td><input type="submit" name="submit" value="新增"> <input type="reset" name="reset" value="清除"></td>
    </tr>
  </table>
  <br>
</form>

</body>
</html>

<script language="JavaScript">
function check() {
      if (document.signform.ROLENAME.value == "") {
           alert("請輸入角色名稱!");
		   return (false);
      }else if(document.signform.ROLEDESC.value == ""){
	        alert("請輸入內容!");
			return (false);
	  }else {
	      	        document.signform.submit();
	  }
}

</script>