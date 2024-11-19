<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,DominoPoolBean,lotus.domino.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Login.jsp</title>
</head>

<body>
<jsp:useBean id="dominoPool" scope="session" class="DominoPoolBean"/>
<%  
  String UserName=request.getParameter("UserName");
  String Password=request.getParameter("Password");
  String userCompCode="";
  String USERROLES="";
  String GROUPNAME="";
  String WEBID="";
  //String LOCALE="";
  //String RepCenterWHS="";
  //String RepCenterLOC="";
  String UserActCenterNo="";//取得使用者是否為維修人員,若是則取得其維修點編號 
  String OIaddress= (String)session.getAttribute("address");
  String QueryString= (String)session.getAttribute("QueryString");
  String sql = "";
  String token=null;
  String checkToken=null;
  Cookie[] cookies = null;  
  
  try
  {   
    //檢查是否存在NOTES之SSO===================
     cookies = request.getCookies();
     if (cookies != null)
     {
        for (int iCookieCounter = 0; iCookieCounter < cookies.length;iCookieCounter++) 
        {                                      	
            if (cookies[iCookieCounter].getName().equals("LtpaToken") && !cookies[iCookieCounter].getValue().equals("") && cookies[iCookieCounter].getValue()!=null) 
            {            	
               	checkToken=cookies[iCookieCounter].getValue();							
				break;                             
            }
        }
      } //enf of cookies if
      //======================================     
  
  Statement statement=con.createStatement();
   //ResultSet rs=statement.executeQuery("select * from RPUSER WHERE USERID='"+USERID+"'and PASSWORD='"+PASSWORD+"'");   
  dominoPool.setUserName(UserName);
  dominoPool.setPassword(Password);
  dominoPool.setServerName("tpefax.dbtel.com.tw");
  dominoPool.setSecondaryServerName("tptest1.dbtel.com.tw"); 
  if (checkToken!=null)
  {    
    dominoPool.connectDominoByToken(checkToken);	
	UserName=dominoPool.getCommonUserName();	
  } else {
    dominoPool.connectDomino();
    token=dominoPool.getToken();
  }  
  dominoPool.setDisconnect();
  
  if(dominoPool.getCommonUserName()!=null)
   {       
        if (token!=null) //若與notes有?線且取得其SSO token
		{
		  Cookie loginCookie=new Cookie("LtpaToken", token);
		  loginCookie.setDomain(".dbtel.com.tw");                                                                    
          loginCookie.setMaxAge(-86400); //86400代表一天的秒數
		  loginCookie.setPath("/");
          response.addCookie(loginCookie);
		} 
        Statement statementR=con.createStatement();
		sql = "select * from WSUSER WHERE (WEBID='"+UserName+"' or USERNAME= '"+UserName+"') ";		 
        ResultSet rsR=statementR.executeQuery(sql);
		if(rsR.next())  //看該人員是否在WINS中有帳號
		{   
			 session.setAttribute("Login","ok");
			 session.setAttribute("USERNAME",dominoPool.getCommonUserName());
			 UserName=dominoPool.getCommonUserName();
			 //session.setMaxInactiveInterval(60*60); 
			 //session.setAttribute("LOCALE",rsR.getString("LOCALE")); 		
			 //LOCALE= rsR.getString("LOCALE");        		 		 
			 
			 //取得該員之role
			 ResultSet rs=statement.executeQuery("select ROLENAME from wsGroupUserRole WHERE trim(GROUPUSERNAME)='"+UserName+"'");  
			 String rolenameString = "";
			 String role = "";
			 while(rs.next())		 
			 {
			   if (rolenameString=="")
			   {
				rolenameString=rs.getString("ROLENAME");
			   } else {		     
				 rolenameString = rolenameString +","+ rs.getString("ROLENAME") ;
			   }
			   session.setAttribute("USERROLES",rolenameString);	
			 } //end of while 
			 rs.close();
			 
			 rs=statement.executeQuery("select WEBID from WsUser WHERE USERNAME='"+UserName+"'");
			 if(rs.next()){
				WEBID = rs.getString("WEBID");
				session.setAttribute("WEBID",WEBID);
				out.print("WEBID:"+WEBID+"<br>");
			 }
			 rs.close();		 
			 
			 rs=statement.executeQuery("select GROUPNAME from WsUserGroup WHERE USERNAME='"+UserName+"'");
			 if(rs.next()){
				GROUPNAME = rs.getString("GROUPNAME");
				session.setAttribute("GROUPNAME",GROUPNAME);
			 }  		 
			 rs.close();
			 
			 sql = "select ACTCENTERNO,ACTUSERID from WSSHIPPER where (ACTUSERID='"+UserName+"' or USERNAME='"+UserName+"') and ACTIVE = 'Y' ";
			 rs=statement.executeQuery(sql);
			 if(rs.next())
			 {
				UserActCenterNo= rs.getString("ACTCENTERNO");
				session.setAttribute("USERACTCENTERNO",UserActCenterNo);			
			 } 		
			 rs.close();	  
	   }else{
	      %><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%		  
		  response.sendRedirect("/wins/jsp/NoAuthority.jsp");
		  return;
	   }  //end of rsR if 該員是否有WINS帳號   
			//response.sendRedirect("/wins/WinsMainMenu.jsp");
		  rsR.close();
		  statementR.close();
  } else {//if(dominoPool.getCommonUserName()!=null),如NOTES沒有,去另一個table查(WSUSER)
	     Statement statement1=con.createStatement();
		 sql = "select * from WSUSER WHERE WEBID='"+UserName+"'and PASSWORD='"+Password+"' ";
         ResultSet rs1=statement1.executeQuery(sql);
		 
		 if(rs1.next())
		 { 		 
			 String USERNAME2 = rs1.getString("USERNAME");
			 out.print("USERNAME2:"+USERNAME2+"<br>");
			 
			 session.setAttribute("Login","ok");
			 session.setAttribute("USERNAME",USERNAME2);
			 UserName=dominoPool.getCommonUserName();
			 
			 ResultSet rs=statement.executeQuery("select ROLENAME from wsGroupUserRole WHERE trim(GROUPUSERNAME)='"+USERNAME2+"'");  
			 String rolenameString = "";
			 String role = "";
			 while(rs.next())		 
			 {
			  if (rolenameString=="")
			  {
			   rolenameString=rs.getString("ROLENAME");
			   out.print("rolenameStringAA:"+rolenameString+"<br>");
			  } else {		     
				rolenameString = rolenameString +","+ rs.getString("ROLENAME") ;
				out.print("rolenameStringBB:"+rolenameString+"<br>");
			  }
			  out.print("rolenameStringCC:"+rolenameString+"<br>");	
			  session.setAttribute("USERROLES",rolenameString);
			 } //end of while 
			 rs.close();
			 
			 rs=statement.executeQuery("select WEBID from WsUser WHERE USERNAME='"+USERNAME2+"'");
			 if(rs.next())
			 {
				WEBID = rs.getString("WEBID");
				session.setAttribute("WEBID",WEBID);
				 out.print("WEBID2:"+WEBID+"<br>");
			 }
			 rs.close();
					 
			 rs=statement.executeQuery("select GROUPNAME from WsUserGroup WHERE USERNAME='"+USERNAME2+"'");
			 if(rs.next()){
				GROUPNAME = rs.getString("GROUPNAME");
				out.print("GROUPNAME2:"+GROUPNAME+"<br>");
				session.setAttribute("GROUPNAME",GROUPNAME);
			 }  		 
			 rs.close();	
			 
			 sql = "select ACTCENTERNO,ACTUSERID from WSSHIPPER where (ACTUSERID='"+USERNAME2+"' or USERNAME='"+USERNAME2+"') and ACTIVE = 'Y' ";
			 rs=statement.executeQuery(sql);
			 if(rs.next())
			 {
				UserActCenterNo= rs.getString("ACTCENTERNO");
				session.setAttribute("USERACTCENTERNO",UserActCenterNo);			
			 } 		
			  rs.close();			 
		 }else{
		   %><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
		   response.sendRedirect("/wins/jsp/index2.jsp");
		   return;
		 }		
	     rs1.close();
		 statement1.close();	  
   }//end of else	  	  	  	  
	  
    if(OIaddress!=null)
	{		   
	       session.setMaxInactiveInterval(60*60*3);
		   session.setAttribute("address","");
		   %><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
           response.sendRedirect(OIaddress + '?' + QueryString);   
	} else {
	      session.setMaxInactiveInterval(60*60*3);
		  %><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
	      response.sendRedirect("/wins/WinsMainMenu.jsp");
    } 		  
	statement.close();	          
} //end of try   
catch (Exception e)
{
   e.printStackTrace();
   out.println("Exception:"+e.getMessage());
}
 %>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>