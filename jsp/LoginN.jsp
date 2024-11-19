<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,DominoPoolBean,lotus.domino.*,RsCountBean"%>
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
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<%  
String UserName=request.getParameter("UserName");
String Password=request.getParameter("Password"); 
String userCompCodeArray[][]=null;//使用者之隸屬的公司別代碼
String USERROLES="",GROUPNAME="",WEBID="";  
//String LOCALE=""; 
String UserActCenterNo="";//取得使用者是否為維修人員,若是則取得其維修點編號 
String OIaddress= (String)session.getAttribute("address");
String QueryString= (String)session.getAttribute("QueryString");
String sql = "";
String token=null;
String checkToken=null;
Cookie[] cookies = null;  
String flag=""; // 判斷是否由Notes登入
try {   
	//檢查是否存在NOTES之SSO===================
	cookies = request.getCookies();
	if (cookies != null) {
		for (int iCookieCounter = 0; iCookieCounter < cookies.length;iCookieCounter++)  {                                      	
			if (cookies[iCookieCounter].getName().equals("LtpaToken") && !cookies[iCookieCounter].getValue().equals("") && cookies[iCookieCounter].getValue()!=null) {            	
				checkToken=cookies[iCookieCounter].getValue();							
				break;                             
            } // end if
        } // end for
      } //enf of cookies if
	//======================================     
  
	dominoPool.setUserName(UserName);
	dominoPool.setPassword(Password);
	dominoPool.setServerName(application.getInitParameter("DominoDIIOPConnection"));
	dominoPool.setSecondaryServerName(application.getInitParameter("DominoSecondaryDIIOPConnection")); 
	if (checkToken!=null)  {    
		dominoPool.connectDominoByToken(checkToken);	
		UserName=dominoPool.getCommonUserName();		
	} else {
		dominoPool.connectDomino();
		token=dominoPool.getToken();
	}  // end if
	dominoPool.setDisconnect();
  
	if(dominoPool.getCommonUserName()!=null)  { // 使用NOTES認証       
		UserName=dominoPool.getCommonUserName(); 
		session.setAttribute("flag","OK"); // 
        if (token!=null) { //若與notes有線且取得其SSO token
			Cookie loginCookie=new Cookie("LtpaToken", token);
			loginCookie.setDomain(".dbtel.com.tw");                                                                    
			loginCookie.setMaxAge(-86400); //86400代表一天的秒數
			loginCookie.setPath("/");
			response.addCookie(loginCookie);
		  
			//oooooooooo這個cookie是用來該Notes Client user可以直接登錄的檢查用cookie oooooooooooooooo
			Cookie userCookie=new Cookie(UserName.replace(' ','|'), token);
			userCookie.setDomain(".dbtel.com.tw");                                                                    
			userCookie.setMaxAge(86400); //86400代表一天的秒數
			userCookie.setPath("/");
			response.addCookie(userCookie);
			//ooooooooooooooooooooooooooooooooooooooooooooo
		}  // end if

		out.println("看該人員是否在WINS中有帳號");
		Statement statementR=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		sql = "select * from WSUSER WHERE (WEBID='"+UserName+"' or USERNAME= '"+UserName+"') and LOCKFLAG!='Y'";		 
		ResultSet rsR=statementR.executeQuery(sql);
		if(rsR.next()) { //看該人員是否在WINS中有帳號
			session.setAttribute("Login","ok");
			session.setAttribute("USERNAME",dominoPool.getCommonUserName());
			UserName=dominoPool.getCommonUserName();		
			WEBID = rsR.getString("WEBID");
			session.setAttribute("WEBID",WEBID);	
			session.setAttribute("USERMAIL",rsR.getString("USERMAIL"));		 
			//session.setMaxInactiveInterval(60*60); 
			//session.setAttribute("LOCALE",rsR.getString("LOCALE")); 		
			//LOCALE= rsR.getString("LOCALE");        		 		 
			 
			//取得該員之role
			out.println("取得該員之role");
			Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			ResultSet rs=statement.executeQuery("select ROLENAME from wsGroupUserRole WHERE trim(GROUPUSERNAME)='"+UserName+"'");  
			String rolenameString = "";
			String roleList = "";
			while(rs.next()) {
				if (rolenameString=="") {
					rolenameString=rs.getString("ROLENAME");
					roleList="'"+rs.getString("ROLENAME")+"'";
				} else {		     
					rolenameString = rolenameString +","+ rs.getString("ROLENAME") ;		
					roleList=roleList+",'"+rs.getString("ROLENAME")+"'";
				}
				session.setAttribute("USERROLES",rolenameString);				
				session.setAttribute("ROLES",roleList);

			} //end of while 
			rs.close();	 			 
			 
			out.println("取得該員之Group");
			rs=statement.executeQuery("select GROUPNAME from WsUserGroup WHERE USERNAME='"+UserName+"'");
			if(rs.next()) {
				GROUPNAME = rs.getString("GROUPNAME");
				session.setAttribute("GROUPNAME",GROUPNAME);
			}  		 
			rs.close();
			 
			out.println("取得該員出貨中心");
			sql = "select ACTCENTERNO,ACTUSERID from WSSHIPPER where (ACTUSERID='"+UserName+"' or USERNAME='"+UserName+"') and ACTIVE = 'Y' ";
			rs=statement.executeQuery(sql);
			if(rs.next()) {
				UserActCenterNo= rs.getString("ACTCENTERNO");
				session.setAttribute("USERACTCENTERNO",UserActCenterNo);			
			} 		
			rs.close();
			 
			//取得該員隸屬之COMPANY CODE			 
			out.println("取得該員隸屬之COMPANY CODE");
			rs=statement.executeQuery("select * from WSROLE_COMP WHERE trim(ROLENAME) in (select trim(ROLENAME) from WSGROUPUSERROLE where GROUPUSERNAME='"+UserName+"') and COMP='*'");	
			if (rs.next()) { //先看是否其COMP為*,此代表為admin具有所有權限
				rs=statement.executeQuery("select unique trim(MCCOMP) as COMP,trim(MCDESC) as MCDESC from WSMULTI_COMP order by MCDESC");		 		
			} else {
				rs=statement.executeQuery("select trim(COMP) as COMP,trim(MCDESC) as MCDESC from WSROLE_COMP,WSMULTI_COMP WHERE trim(COMP)=trim(MCCOMP) and trim(ROLENAME) in (select trim(ROLENAME) from WSGROUPUSERROLE where GROUPUSERNAME='"+UserName+"')");
			} 
			rsCountBean.setRs(rs); //取得其總筆數
			userCompCodeArray=new String[2][rsCountBean.getRsCount()];			 
			int ic=0;
			while(rs.next()) {			  
				userCompCodeArray[0][ic]=rs.getString("MCDESC");	
				userCompCodeArray[1][ic]=rs.getString("COMP");			  		   
				ic++;
			} //end of while 
			session.setAttribute("USERCOMPCODEARRAY",userCompCodeArray);	
			rs.close();	
			statement.close();
			rsR.close();
			statementR.close();
		} else {
			rsR.close();
			statementR.close();
			%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%		  
			response.sendRedirect("/wins/jsp/NoAuthority.jsp");
			return;
		}  //end of rsR if 該員是否有WINS帳號   
			//response.sendRedirect("/wins/WinsMainMenu.jsp");

	} else { //使用本系統認証
		session.setAttribute("flag",""); //使用本系統認証 
		Statement statement1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		sql = "select * from WSUSER WHERE (WEBID='"+UserName+"' or USERNAME='"+UserName+"') and PASSWORD='"+Password+"' and LOCKFLAG!='Y'";
		ResultSet rs1=statement1.executeQuery(sql);
		if(rs1.next()) {
			String USERNAME2 = rs1.getString("USERNAME");			 
			session.setAttribute("Login","ok");
			session.setAttribute("USERNAME",USERNAME2);			 
			WEBID = rs1.getString("WEBID");
			session.setAttribute("WEBID",WEBID);
			session.setAttribute("USERMAIL",rs1.getString("USERMAIL"));								 			 
			rs1.close();
			statement1.close();
			
			Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			ResultSet rs=statement.executeQuery("select ROLENAME from wsGroupUserRole WHERE trim(GROUPUSERNAME)='"+USERNAME2+"'");  
			String rolenameString = "";			
			while(rs.next()) {
				if (rolenameString=="")  {
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
				 
			rs=statement.executeQuery("select GROUPNAME from WsUserGroup WHERE USERNAME='"+USERNAME2+"'");
			if(rs.next()){
				GROUPNAME = rs.getString("GROUPNAME");
				out.print("GROUPNAME2:"+GROUPNAME+"<br>");
				session.setAttribute("GROUPNAME",GROUPNAME);
			 }  		 
			 rs.close();	
			 
			 sql = "select ACTCENTERNO,ACTUSERID from WSSHIPPER where (ACTUSERID='"+USERNAME2+"' or USERNAME='"+USERNAME2+"') and ACTIVE = 'Y' ";
			 rs=statement.executeQuery(sql);
			 if(rs.next()) {
				UserActCenterNo= rs.getString("ACTCENTERNO");
				session.setAttribute("USERACTCENTERNO",UserActCenterNo);			
			 } 		
			 rs.close();	
			  
			 //取得該員隸屬之COMPANY CODE
			 rs=statement.executeQuery("select * from WSROLE_COMP WHERE trim(ROLENAME) in (select trim(ROLENAME) from WSGROUPUSERROLE where GROUPUSERNAME='"+USERNAME2+"') and COMP='*'");	
			 if (rs.next()) { //先看是否其COMP為*,此代表為admin具有所有權限
				rs.close();
				rs=statement.executeQuery("select unique trim(COMP) as COMP,trim(MCDESC) as MCDESC from WSROLE_COMP,WSMULTI_COMP WHERE trim(COMP)=trim(MCCOMP)");		 		
			 } else {
				rs.close();
				rs=statement.executeQuery("select trim(COMP) as COMP,trim(MCDESC) as MCDESC from WSROLE_COMP,WSMULTI_COMP WHERE trim(COMP)=trim(MCCOMP) and trim(ROLENAME) in (select trim(ROLENAME) from WSGROUPUSERROLE where GROUPUSERNAME='"+USERNAME2+"')");
			 } 			  					 		
			 rsCountBean.setRs(rs); //取得其總筆數
             userCompCodeArray=new String[2][rsCountBean.getRsCount()];			 
			 int ic=0;
			 while(rs.next()) {			  
				userCompCodeArray[0][ic]=rs.getString("MCDESC");	
				userCompCodeArray[1][ic]=rs.getString("COMP");			  		   
				ic++;
			 } //end of while 
			session.setAttribute("USERCOMPCODEARRAY",userCompCodeArray);	
			rs.close();
			statement.close();
			 
		} else { // 沒有此帳號
			rs1.close();
			statement1.close();
			%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
			response.sendRedirect("/wins/jsp/index2.jsp");
			return;
		}		
			  
	}//end of dominoPool.getCommonUserName() if  	  	  	  
	  
	if(OIaddress!=null){		   
		session.setMaxInactiveInterval(60*60*3);		   
		session.setAttribute("address",null); //轉址前先將前內容清除以免陷入無窮迴圈
		session.setAttribute("QueryString",null);//轉址前先將前內容清除以免陷入無窮迴圈
		%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
		response.sendRedirect(OIaddress + '?' + QueryString);   
	} else {
		session.setMaxInactiveInterval(60*60*3);
		%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
		response.sendRedirect("/wins/WinsMainMenu.jsp");
	} 		  
} //end of try   
catch (Exception e) {
   e.printStackTrace();
   out.println("Exception:"+e.getMessage());
}
 %>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>