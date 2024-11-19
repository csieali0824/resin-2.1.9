<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>SelectEmployee.jsp</title>
</head>

<body> 

<%
  
  try
    {
	Statement statement=con.createStatement();
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>
<table width="82%" height="25" border="0" cellpadding="0" cellspacing="8">
  <font color="#e8eef7"></font> 
</table>
<table width="322" height="148" align=center cellpadding=5 cellspacing=1 bgcolor=#708090>
  <tr vAlign="top" align="middle"><H4>查詢個人記錄</H4>
          
    <td width="340" height="144" bgcolor=#CCFFFF> <div align="left"> 
      <form action="SelectEmployeeDb.jsp" method="post" name="signform" onsubmit="return validate()">
 
人名:<input type="text" name="USERNAME" size="12" maxlength="20"><br><p>
     <input type="submit" name="submit1" value="查詢">
     <input name="reset" type="reset" value="清除"><br>
	 <a href="/wins/WinsMainMenu.jsp">回上一頁</a></form>
     </p></table>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->

</body>
</html>


  <script language="JavaScript"> 

   function validate(){
     if (document.signform.USERNAME.value == "") {
	      alert("請輸入人名!");
		  return (false);
	 }else if(document.signform.USERID.value == ""){
	      alert("請輸入工號!");
			return (false);
	  }else {
	      document.signform.submit();
	  }
   }
  </script> 