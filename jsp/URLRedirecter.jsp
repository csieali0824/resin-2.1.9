<%@ page contentType="text/html; charset=utf-8" language="java" import="lotus.domino.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>To redirect URL</title>
</head>
<body>
<% 
String userName=request.getParameter("USERNAME");
String chkUserName="";
if (userName!=null)  chkUserName=userName.replace(' ','|'); //因為cookie存的名字不能有空白,故轉換之
String webApp=request.getParameter("WEBAPP");
String userToken=null; //做為儲存個人token之cookie
String tokenValue=null,SSOToken=null;
Cookie[] cookies = null;

try 
{    
   cookies = request.getCookies();
   //先檢查是否已有LtpaToken SSO存在,若有則直接轉至讓應用系統===================
      if (cookies != null)
      {
        for (int iCookieCounter = 0; iCookieCounter < cookies.length;iCookieCounter++) 
        {                                      	
            if (cookies[iCookieCounter].getName().equals("LtpaToken") && !cookies[iCookieCounter].getValue().equals("") && cookies[iCookieCounter].getValue()!=null) 
            {            	
               	SSOToken=cookies[iCookieCounter].getValue();							
				break;                             
            }
        }
      } //enf of cookies if
    //======================================        
   
   if (SSOToken==null) //若不存在SSO Token之cookie,則再檢查是否有個人的COOKIE
   {  	   
	   //檢查是否存在暨有之個人的COOKIE===================
	   if (cookies != null)
	   {
		  for (int iCookieCounter = 0; iCookieCounter < cookies.length;iCookieCounter++) 
		  {                                      	
			  if (cookies[iCookieCounter].getName().equals(chkUserName) && !cookies[iCookieCounter].getValue().equals("") && cookies[iCookieCounter].getValue()!=null) 
			  {            	
				userToken=cookies[iCookieCounter].getValue();							
				break;                             
			  }
		  }
		} //enf of cookies if
		//======================================     
	   
	   if (userToken!=null) //若存在個人token之cookie則將之寫入SSO token cookie中,若否則不做任何動作
	   {  		 
		  Cookie loginCookie=new Cookie("LtpaToken",userToken);
		  loginCookie.setDomain(".dbtel.com.tw");         
		  loginCookie.setMaxAge(-86400); 
		  loginCookie.setPath("/"); 
		  response.addCookie(loginCookie);				 
	   } //end of if -> userToken
   } //end of if ->SSOToken==null	   
   
   //以下為判斷何WEB應用系統而做轉址的動作
   if (webApp.equals("PIS"))
   {
     response.sendRedirect("http://speed.dbtel.com.tw/jetspeed");	  
   }	 
   if (webApp.equals("REPAIR"))
   {
     response.sendRedirect("http://repairapp.dbtel.com.tw/repair");	  
   }
   if (webApp.equals("WINS"))
   {
     response.sendRedirect("http://wins.dbtel.com.tw/wins");	  
   }   
   if (webApp.equals("PORTAL"))
   {
     response.sendRedirect("http://my.dbtel.com.tw");	  
   } 
} catch (Exception e) {
    out.println(e.toString());
}
%>
</body>
</html>
