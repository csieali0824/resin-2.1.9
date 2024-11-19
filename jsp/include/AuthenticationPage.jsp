<%@ page import="java.sql.*"%>
<%@ include file="/jsp/include/ConnForAuthPoolPage.jsp"%>
<!--=========================================================-->
<%  
   String authSource=(String)session.getAttribute("AUTHSOURCE");// 
   String Login = (String)session.getAttribute("Login");
   String userID=(String)session.getAttribute("WEBID");   
   String UserName=(String)session.getAttribute("USERNAME"); 
   String userActCenterNo=(String)session.getAttribute("USERACTCENTERNO");
   String userSalesResID=(String)session.getAttribute("USERSALESRESID");
   String userSalesGroupID=(String)session.getAttribute("USERSALESGROUPID");
   String userPlanCenterNo=(String)session.getAttribute("USERPLANCENTERNO");
   String userProdCenterNo=(String)session.getAttribute("USERPRODCENTERNO");  
   String userCustGroupID=(String)session.getAttribute("USERCUSTGROUPID");
   String userOrgID=(String)session.getAttribute("USERORGID");
   String userParOrgID=(String)session.getAttribute("USERPARORGID");  
   String UserRoles=(String)session.getAttribute("USERROLES"); 
   String userMail=(String)session.getAttribute("USERMAIL");
   String locale=(String)session.getAttribute("LOCALE");     
   String userCompCodeArray[][]=(String [][])session.getAttribute("USERCOMPCODEARRAY");    
   String UserRegionSet=(String)session.getAttribute("USERREGIONSET");
   String UserGroupSet=(String)session.getAttribute("USERGROUPSET"); // Sales multip Group ID 
   //  QCDEPT ID and DEPT NAME andINSPECTOR ID and INSPECTOR
   String userInspDeptID=(String)session.getAttribute("QCDEPT_ID");
   String userInspDeptName=(String)session.getAttribute("QCDEPT_DESC");
   String userInspectorID=(String)session.getAttribute("QCUSER_ID");
   String userInspectorName=(String)session.getAttribute("QCUSER_NAME");
   String userQCOrgID=(String)session.getAttribute("QCORG_ID");
   String userQCEmpID=(String)session.getAttribute("QCEMP_ID");
   
   // MFG USER(May a User can create multip-dept workorder
   String userMfgDeptArray[][]=(String [][])session.getAttribute("USERMFGDEPTARRAY");  
   String UserMfgDeptSet=(String)session.getAttribute("USERMFGDEPTSET");
   String userMfgDeptNo=(String)session.getAttribute("MFG_DEPT_NO");
   String userMfgDeptName=(String)session.getAttribute("MFG_DEPT_NAME");
   String userMfgUserID=(String)session.getAttribute("USER_ID");
   String userMfgUserName=(String)session.getAttribute("USER_NAME");
   String userMfgDemLoc=(String)session.getAttribute("DEM_LOCATION_ID");  // MFG Demositic Location ID
   String userMfgExpLoc=(String)session.getAttribute("EXP_LOCATION_ID");  // MFG Export Location ID
   
   
   //  Material Control DEPT ID and ORG ID
   String userMCDeptID=(String)session.getAttribute("MCTSC_DEPT_ID");
   String userMCOrgID=(String)session.getAttribute("MCORG_ID");
   String userMCEmpID=(String)session.getAttribute("MCEMP_ID");
   //  Warehouser DEPT ID and ORG ID
   String userWSDeptID=(String)session.getAttribute("WSTSC_DEPT_ID");
   String userWSOrgID=(String)session.getAttribute("WSORG_ID");
   String userWSEmpID=(String)session.getAttribute("WSEMP_ID");
   
   String OIaddress=request.getRequestURL().toString();   
   String QueryString=request.getQueryString();
   String authURL=request.getContextPath().toString()+request.getServletPath().toString();
   if (QueryString!=null && !QueryString.equals("null"))
   {  
     authURL=authURL+"?"+QueryString;
   }     
   session.setAttribute("address",OIaddress);
   session.setAttribute("QueryString",QueryString);	
   String flag=(String)session.getAttribute("flag");// Judge form Notes Login
   String roles=(String)session.getAttribute("ROLES");
   //==========wheather following Segment to check the page with special Author===================
   Statement authStat=authcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);   
   ResultSet authRs=null;
   try
   { //  **** if always cann't author, Then transfer to NoAuth Page,and,that is ConnForAuthPoolPage.jsp 's problems ***** //
     String authentication="YES";  	
	 String sqlAuth ="select ROLENAME from ORADDMAN.WSPROGRAMMER,ORADDMAN.menufunction "+
	                  "where addressdesc=ffunction AND trim(FADDRESS)='"+authURL+"' ";    
					  //out.println(" sqlAuth="+ sqlAuth+"<BR>");
     authRs=authStat.executeQuery(sqlAuth);
	 while (authRs.next())
	 { //out.println(UserRoles.indexOf(authRs.getString("ROLENAME")));
	   //out.println("<BR>");
	   //out.println(authRs.getString("ROLENAME"));
	   authentication="NO"; 
	   if (UserRoles.indexOf(authRs.getString("ROLENAME"))>=0) //judge if it was page author ROLE,then passed
	   { //out.println("UserRoles="+UserRoles);
	     authentication="YES";
		 break;
	   }
	 } //end of authRs while
	 
	 if (!authentication.equals("YES"))
	 {
	   authRs.close();
	   authStat.close();
	   %>
	   <%@ include file="/jsp/include/ReleaseConnForAuthPage.jsp"%>
	   <%
	     response.sendRedirect("/oradds/jsp/NoAuthority.jsp");
	   
	   //out.println("select ROLENAME from ORADDMAN.WSPROGRAMMER,ORADDMAN.menufunction "
	              // +" where addressdesc=ffunction AND trim(FADDRESS)='"+authURL+"'");
	   return;
	 }
   } //end of try   
   catch (Exception e)
   {
     e.printStackTrace();
     out.println("Exception:"+e.getMessage());
   }
   if (authRs!=null) authRs.close();
   authStat.close();
   //====================================================================
  		 
   if ( Login == null || !Login.equals("ok"))
   {
    %>
	<%@ include file="/jsp/include/ReleaseConnForAuthPage.jsp"%>
	<%
	 response.sendRedirect("/oradds/jsp/index.jsp");
	 return;
   }
%>
<!--=============To release Connection==========-->
<%@ include file="/jsp/include/ReleaseConnForAuthPage.jsp"%>