<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%
//找是否有特定cookie,若有則清除之以使該cookei徹底失效 
Cookie logoutCookie=new Cookie("LtpaToken", ""); 
 try{
        logoutCookie.setDomain(".ts.com.tw");                                                                    
        logoutCookie.setMaxAge(-1);
		logoutCookie.setPath("/");        
		response.addCookie(logoutCookie);        
    }//end of try
 catch (Exception e)
    {
        out.println("Exception:"+e.getMessage());
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Login Fail</title>

</head>

<body topmargin="0"> 
<FORM name="MYFORM" action="../ORAddsMainMenu.jsp" method="post">
<%
String authSource=request.getParameter("AUTHSOURCE");

%>
<table width="704" border="0" align="center" cellspacing="0">
  <tr>
    <td width="80%" height="54" bgcolor="#FFFFFF"><div align="center"><img src="../image/logo.jpg" width="420" height="54"></div></td>
  </tr>
</table>

<table width="704" border="0" align="center" cellspacing="0">
  <tr>
    <td height="90" bgcolor="#FFFFFF">&nbsp; </td>
  </tr>
</table>

<table width="704" border="0" align="center" cellspacing="0">
	<tr><td width="30"></td></tr>
	<tr><td align="center"><font size="+2"><a href="">
	<%   //登入失敗, 重新登入
	   if (authSource==null || authSource.equals(""))
	   {  
	     out.println("<A HREF='/oradds/jsp/index.jsp'>登入失敗, 請重新登入</A>");
	   }
	   else if (authSource.equals("NoJSPAuth"))
	   { 
	     out.println("無Java Server Page 系統使用權限, 請先申請使用帳號");
	   } else if (authSource.equals("ErrorJSPPassword"))
	           {  
			      out.println("<A HREF='/oradds/jsp/index.jsp'>錯誤的Java Server Page 使用者密碼, 請重新輸入</A>");
			   }
	%></a></font></td></tr>
</table>
</FORM>
</body>
</html>

