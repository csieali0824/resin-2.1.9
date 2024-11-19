<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Cookie Checker</title>
</head>

<body>
<% 
 try 
 { 
   //Cookie loginCookie=new Cookie("B01732","zLknRD1x4ixSBNtM7kQ3NiwrD/VwE+CH94TaSl/e7fihxCqofmGb8ae2YiFlH7dI3QFwDqV1S7jCVn6TKpDk12O6x5WLYY7KS0iEbgIKk43aOPMhVx0Ua74XX0II+J0RttGQ7Oa2RhQGWVTh7b1YFEwUchAVqEqE6+z09CV3MDMM3MfuaKK8fNLB1xlY4m1rcNBGYvGF97IDd8zTCP6ycc8HY2n208Lt2F8h8Vwh9FAIXZp+I5QiYY339K6leHAZFoz7tvvVx2WbPlBipsmIgWL9n8CBTLTj5PIy0jV3b+37pMP4AIKNbEVmx2VGGzEbVwO+krnN/IY="); //WEBSPHERE	  	  
   //Cookie loginCookie=new Cookie("LtpaToken","zLknRD1x4ixSBNtM7kQ3NiwrD/VwE+CH94TaSl/e7fihxCqofmGb8ae2YiFlH7dI3QFwDqV1S7jWz64nWwTg0N3cwMkHSw42S0iEbgIKk43aOPMhVx0Ua74XX0II+J0RttGQ7Oa2RhQGWVTh7b1YFEwUchAVqEqE6+z09CV3MDMM3MfuaKK8fNLB1xlY4m1rcNBGYvGF97IDd8zTCP6ycc8HY2n208Lt2F8h8Vwh9FAIXZp+I5QiYY339K6leHAZFoz7tvvVx2WbPlBipsmIgWL9n8CBTLTj5PIy0jV3b+37pMP4AIKNbEVmx2VGGzEbVwO+krnN/IY=");
   Cookie loginCookie=new Cookie("ROGER|CHANG",null);
   loginCookie.setDomain(".dbtel.com.tw");         
   loginCookie.setMaxAge(-1); 
   loginCookie.setPath("/"); 
   response.addCookie(loginCookie);
   response.sendRedirect("CookieChecker.jsp");
	  
 } catch (Exception e) {
          out.println(e.toString());
 }
%>
</body>
</html>
