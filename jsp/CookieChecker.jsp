<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Cookie Checker</title>
</head>

<body>
<%
 Cookie[] cookies = null;
 try 
 {   
     cookies = request.getCookies();
     if (cookies != null) 
	 {
          for (int iCookieCounter = 0; iCookieCounter < cookies.length;iCookieCounter++) 
   		  {
           	out.println("Name:"+cookies[iCookieCounter].getName()); //add by Roger20040902
           	out.println(cookies[iCookieCounter].getValue());
			out.println("<br>Is Secured?:"+cookies[iCookieCounter].getSecure());
			out.println("&nbsp;&nbsp;Time to expiry:"+cookies[iCookieCounter].getMaxAge());
			out.println("&nbsp;&nbsp;Version:"+cookies[iCookieCounter].getVersion());
			out.println("<br>Domain:"+cookies[iCookieCounter].getDomain());
			out.println("<br>Comment:"+cookies[iCookieCounter].getComment());
			out.println("<br>Path:"+cookies[iCookieCounter].getPath());
			out.println("<BR>");                    
          }                
      } 
	  out.println("SESSION ID IS "+session.getId().toUpperCase());  
 } catch (Exception e) {
          out.println(e.toString());
 }
%>
</body>
</html>
