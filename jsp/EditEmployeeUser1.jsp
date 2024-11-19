<!--20140924 by Peggy,密碼長度放大至30-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EditEmployeeUser1.jsp</title>
</head>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<body background="../image/b01.jpg">

<%
 String PASSWORD="";


try
   {
    	Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery("select * from ORADDMAN.WSUser WHERE USERNAME='"+UserName+"'");
       
   
          if(rs.next())
          {
           PASSWORD=rs.getString("PASSWORD");   
   
          } 
	 
	 
   }
   catch (Exception e)
   {
     out.println("Exception:"+e.getMessage());
   }

%>

 <form action="../jsp/UpdateEditEmployeeUser.jsp" method="post" name="signform" onSubmit="return check();">
<b>修改密碼</b><br>
人員名稱:<%= UserName %><br>
修改密碼：<input type="password" value="<%= PASSWORD %>" size="15" name="PASSWORD" maxlength="30">
<br>
<input type="submit" name="submit1" value="確定">
<input type="reset" name="reset" value="清除"><br>
<a href="/ORADDS/ORADDSMainMenu.jsp">回首頁</a><br>
</form>


</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
<script language="JavaScript"> 
function check() {
      if (document.signform.USERID.value == "" ) {
           alert("請輸入員工工號!");
		   return false;
      }
	  else if (document.signform.PASSWORD.value == "" ) {
           alert("請輸入員工密碼!");
		   return false;
      }
	  else{
		  
		   return true;
	  }
}
</script>
