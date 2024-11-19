<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<title>Logout.jsp</title>
</head>

<body>
<% 
Cookie logoutCookie=new Cookie("LtpaToken", ""); 
 try{
        logoutCookie.setDomain(".dbtel.com.tw");                                                                    
        logoutCookie.setMaxAge(-1);
		logoutCookie.setPath("/");        
		response.addCookie(logoutCookie);
        session.invalidate();
        response.sendRedirect("/oradds/jsp/index.jsp?LOGINOUT=Y");
    }//end of try
 catch (Exception e)
    {
        out.println("Exception:"+e.getMessage());
    }
%>
</body>
</html>
