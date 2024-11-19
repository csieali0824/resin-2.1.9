<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.sql.*,DominoPoolBean,lotus.domino.*,RsCountBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Login</title>
</head>
<script language="javascript">
function YEWURL() 
{
   location.href = "http://yewintra.ts.com.tw:8080/oradds/jsp/";
}
</script>
<body>
<jsp:useBean id="dominoPool" scope="session" class="DominoPoolBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<%  
String langCh=request.getParameter("LANGCH");
//session.setAttribute("LANGCH",langCh);
String UserName=request.getParameter("UserName");
String Password=request.getParameter("Password"); 
String sql = "";
String USERROLES="",GROUPNAME="",WEBID="";
String UserActCenterNo="";//銷售業務地區別中心
String UserSalesResID="";//Oracle系統業務員ID
String UserSalesGroupID="";//業務員歸屬地區群組組合ID
String UserPlanCenterNo="";//企劃生管中心
String UserProdCenterNo="";//生產製造中心
String UserCustGroupID=""; // 業務員隸屬客戶群組ID
String UserOrgID="";// 登入業務員隸屬Organization ID
String UserParOrgID="";// 登入業務員隸屬ParentOrgID
String userCompCodeArray[][]=null;//使用者之隸屬的公司別代碼
String UserQCInspectDeptID = ""; // 品管部門檢驗單位ID
String UserQCInspectDeptName = ""; // 品管部門檢驗單位名稱
String UserQCInspectID=""; // 品管檢驗單位使用者ID
String UserQCInspectName=""; // 品管檢驗單位使用者姓名
String UserQCOrgID=""; // 品管檢驗單位使用者歸屬ORG_ID
String UserQCEmpID=""; // 品管檢驗員之EMPLOYEE ID

String userMfgDeptArray[][]=null;//使用者之隸屬的製造部門代碼
String userMfgDeptNo = ""; // 製造部門單位代號
String userMfgDeptName = ""; // 製造部門單位名稱
String userMfgUserID = ""; // 製造部門使用者fnd_user user_id
String userMfgUserName = ""; // 製造部門使用者名稱
String userMfgDemLoc = "";  // 製造部內銷Location ID
String userMfgExpLoc = "";  // 製造部外銷Location ID

String UserMCDeptID="",UserMCOrgID=""; // 物管單位使用者歸屬ORG_ID
String UserWSDeptID="",UserWSOrgID=""; // 倉管單位使用者歸屬ORG_ID
String UserMCEmpID="",UserWSEmpID="";  // 物管倉管使用者EMployee ID

String UserISRDeptID = "";  // 資訊服務需求單取使用者部門別ID
String UserISREmolyID = ""; // 資訊服務需求單取使用者EmployeeID
String UserISRMISID =""; // 資訊服務需求單 資訊部負責人ID


String OIaddress= (String)session.getAttribute("address");
String QueryString= (String)session.getAttribute("QueryString");
String token=null;
String checkToken=null;
Cookie[] cookies = null;  
String flag=""; // 判斷是否由Notes登入
//
String UserRegionDesc = null;
String UserRegionSet = "";
   int UserRegionSetLength = 0; 
//
String UserGroupDesc = null;
String UserGroupSet = "";
   int UserGroupSetLength = 0;    
//
String UserMfgDeptDesc = null;
String UserMfgDeptSet = "";
   int UserMfgDeptSetLength = 0;    


try {   
  /*  修改 不由 Notes認證 2005/09/09

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
		out.println("<br>"+"使用NOTES認証成功");
		session.setAttribute("flag","ok"); // //使用NOTES認証
		UserName=dominoPool.getCommonUserName(); 
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

		
		Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		sql = "select * from ORADDMAN.WSUSER where (WEBID='"+UserName+"' or USERNAME= '"+UserName+"') and LOCKFLAG!='Y'";		 
		ResultSet rs=st.executeQuery(sql);
		if(rs.next()) { //看該人員是否在WINS中有帳號
			out.println("<br>"+"授權成功");			
			session.setAttribute("Login","ok");
			session.setAttribute("USERNAME",dominoPool.getCommonUserName());
			session.setAttribute("WEBID",rs.getString("WEBID"));	
			session.setAttribute("USERMAIL",rs.getString("USERMAIL"));		 
			UserName=dominoPool.getCommonUserName();
			rs.close();
			st.close();
			
		} else {
			out.println("<br>"+"授權失敗");
			rs.close();
			st.close();
			%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%		  
			response.sendRedirect("/oradds/jsp/LoginFail.jsp");
			return;
		}  //end if-else  

	} else { //使用本系統認証
		session.setAttribute("flag",""); //使用本系統認証 
		Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		sql = "select * from ORADDMAN.WSUSER WHERE (WEBID='"+UserName+"' or UPPER(USERNAME)='"+UserName.toUpperCase()+"') and LOCKFLAG!='Y'";
		ResultSet rs=st.executeQuery(sql);
		if(rs.next()) {
			if (rs.getString("password").equals(Password)) {
				out.println("<br>"+"使用本系統認証成功");
				out.println("<br>"+"授權成功");
				session.setAttribute("Login","ok");
				session.setAttribute("USERNAME",rs.getString("USERNAME"));
				session.setAttribute("WEBID",rs.getString("WEBID"));
				session.setAttribute("USERMAIL",rs.getString("USERMAIL"));			
				UserName = rs.getString("USERNAME");					 			 
				rs.close();
				st.close();
			} else {
				out.println("<br>"+"授權失敗");
				rs.close();
				st.close();
				%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
				response.sendRedirect("/oradds/jsp/LoginFail.jsp");
				return;
			} // end if-else

		} else {
			out.println("<br>"+"使用本系統認証失敗");
			rs.close();
			st.close();
			%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
			response.sendRedirect("/oradds/jsp/NoAuthority.jsp?UserName="+UserName);
			return;
		} // end if-else
			  
	}//end if-else
	
	修改 不由 Notes認證 2005/09/09 
 */   // 僅Copy //使用本系統認証 
 
  String siteLogin = "";  // 判定使用者由何網域登入決定其使用之Web AP Server 2007/08/29
  int remoteAddrLength = request.getRemoteAddr().length();
  boolean YEWUserFlag = false;  // 預設非陽信使用者
  
  
	
  String userId = ""; 
  String encryptPassword = ""; 
  String decryptPassword = ""; 
  //String userName = ""; 
  String sqlSSO = "";	
  
  Statement st= null;  // 初始值宣告
  ResultSet rs = null; // 初始值宣告
	
  //由Oracle ERP 中的 fnd_user 取得該使用者加密後的密碼
  Statement stmtSSO=con.createStatement(); 
  //sqlSSO ="select * from fnd_user where ( user_name = '%"+UserName+"%' or lower(user_name)='"+UserName+"' or upper(user_name)='"+UserName+"') "; 
  sqlSSO ="select * from fnd_user where lower(user_name)='"+UserName.toLowerCase()+"' "; //modify by Peggy 20200831
  //out.println("sqlSSO="+sqlSSO);
  ResultSet rsSSO = stmtSSO.executeQuery(sqlSSO);   
  while (rsSSO.next()) 
  { 
    userId = rsSSO.getString("USER_NAME"); 
    encryptPassword = rsSSO.getString("ENCRYPTED_USER_PASSWORD"); 
	//out.println("encryptPassword="+encryptPassword);
	//out.println("userId="+userId);
  } 
  rsSSO.close();
  stmtSSO.close();

  //透過Oracle ERP 的API 將加密後的密碼轉成未加密的密碼 
  oracle.apps.fnd.security.AolSecurity aolsec=new oracle.apps.fnd.security.AolSecurity(); 
  decryptPassword = aolsec.decrypt("TSCAPPS12",encryptPassword); 
  if (decryptPassword!=null)  //add by Peggy 20170314
  {
  	decryptPassword = decryptPassword.toUpperCase();
  }
  //out.println("userId="+userId);
  //out.println("decryptPassword="+decryptPassword);
  
  if (decryptPassword !=null && (decryptPassword.equals(Password.toUpperCase()) || decryptPassword.equals(Password.toLowerCase())))
  {	 //先以Oracle ERP帳號密碼作為認證基礎,否則再以Java 
  
        session.setAttribute("flag",""); //使用Oracle ERP 系統認証 
		st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		sql = "select * from ORADDMAN.WSUSER WHERE (WEBID='"+UserName+"' or UPPER(USERNAME)='"+UserName.toUpperCase()+"') and LOCKFLAG!='Y'";
		rs=st.executeQuery(sql);
		if(rs.next()) 
		{
		
		        //out.println("<br>"+"使用Oracle系統認証成功");
				//out.println("<br>"+"授權成功");
				session.setAttribute("Login","ok");
				session.setAttribute("USERNAME",rs.getString("USERNAME"));
				session.setAttribute("WEBID",rs.getString("WEBID"));
				session.setAttribute("USERMAIL",rs.getString("USERMAIL"));		
				session.setAttribute("LOCALE",rs.getString("USERPROFILE"));	
				UserName = rs.getString("USERNAME");	
				
				session.setAttribute("AUTHSOURCE","Oracle E-Business 11i");	

		} else {
				out.println("<br>"+"授權失敗");
				rs.close();
				st.close();
				session.setAttribute("AUTHSOURCE","NoJSPAuth");
				
				%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
				response.sendRedirect("/oradds/jsp/LoginFail.jsp?AUTHSOURCE=NoJSPAuth");
				return;
			   } // end if-else
		rs.close();
		st.close();			
		
	 	
	
  } else
      {	
	    session.setAttribute("flag",""); //使用本系統認証 
		st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
		sql = "select * from ORADDMAN.WSUSER WHERE (WEBID='"+UserName+"' or UPPER(USERNAME)='"+UserName.toUpperCase()+"') and LOCKFLAG!='Y'";
		rs=st.executeQuery(sql);
		if(rs.next()) 
		{
			 if (rs.getString("password").equals(Password))
			 {
				if (rs.getString("PASSWORD_UPDATE_DATE")==null)
				{
					session.setAttribute("UNME",UserName.toUpperCase());
					session.setAttribute("UPWD",Password);
					response.sendRedirect("/oradds/jsp/indexCHPW.jsp?LANGCH="+langCh);
				}
				else 
				{			 
					out.println("<br>"+"使用本系統認証成功");
					out.println("<br>"+"授權成功");
					session.setAttribute("Login","ok");
					session.setAttribute("USERNAME",rs.getString("USERNAME"));
					session.setAttribute("WEBID",rs.getString("WEBID"));
					session.setAttribute("USERMAIL",rs.getString("USERMAIL"));		
					session.setAttribute("LOCALE",rs.getString("USERPROFILE"));	
					UserName = rs.getString("USERNAME");					 			 
					rs.close();
					st.close();
					
					session.setAttribute("AUTHSOURCE","Java Server Page System");
				}
				
			} else {
				out.println("<br>"+"授權失敗");
				rs.close();
				st.close();
				session.setAttribute("AUTHSOURCE","ErrorJSPPassword");
				%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
				response.sendRedirect("/oradds/jsp/LoginFail.jsp?AUTHSOURCE=ErrorJSPPassword");
				return;
			} // end if-else

		} else {
			     out.println("<br>"+"使用本系統認証失敗");
			     rs.close();
			     st.close();
			     %><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	
			     response.sendRedirect("/oradds/jsp/NoAuthority.jsp?UserName="+UserName);
			     return;
		       } // end if-else
	  } // End of if 先以oracle 密碼認證
//
	//out.println("取得該員之role");
	String rolenameString = "";
	String roleList = "";
    st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	rs=st.executeQuery("select ROLENAME from ORADDMAN.wsGroupUserRole WHERE trim(GROUPUSERNAME)='"+UserName+"'");  
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
			 
	//out.println("取得該員之Group");
	rs=st.executeQuery("select GROUPNAME from ORADDMAN.WsUserGroup WHERE USERNAME='"+UserName+"'");
	if(rs.next()) {
		GROUPNAME = rs.getString("GROUPNAME");
		session.setAttribute("GROUPNAME",GROUPNAME);
	}  		 
	rs.close();
			 
	//out.println("取得該員業務中心及其Oracle系統業務員ID");
	sql = " select a.TSSALEAREANO,a.RECPERSONNO,a.SALESPERSONID, b.ALNAME from ORADDMAN.TSRECPERSON a, ORADDMAN.TSSALES_AREA b "+
	      " where a.TSSALEAREANO = b.SALES_AREA_NO "+
	      "   and (a.USERID='"+UserName+"' or a.USERNAME='"+UserName+"') and a.PRIMARY_REGION ='Y' ";
	//out.println("sql="+sql);
	rs=st.executeQuery(sql);
	if(rs.next()) 
	{
		UserActCenterNo= rs.getString("TSSALEAREANO");
		session.setAttribute("USERACTCENTERNO",UserActCenterNo);
		UserSalesResID= rs.getString("SALESPERSONID");	
		session.setAttribute("USERSALESRESID",UserSalesResID);
		// 若業務員ID不為空值,再取組合業務歸屬之群組ID
		String SGroupDesc = null;
        String SGroupCodeGet = "";
        int SGroupCodeGetLength = 0; 
		if (UserSalesResID!=null && !UserSalesResID.equals(""))
		{
		     Statement stateSGroupDesc=con.createStatement(); 
             ResultSet rsSGroupDesc=stateSGroupDesc.executeQuery("select DISTINCT a.GROUP_ID from TSC_OM_GROUP_SALESREP a, TSC_OM_GROUP b "+
			                                                     " where a.GROUP_ID = b.GROUP_ID and ( a.SALESREP_ID ='"+UserSalesResID+"' or b.GROUP_NAME = '"+rs.getString("ALNAME")+"' ) ");
             while (rsSGroupDesc.next()) 
             { 
              SGroupDesc = rsSGroupDesc.getString(1);
	          SGroupCodeGet = SGroupCodeGet + SGroupDesc+","; 
             }
             rsSGroupDesc.close();
             stateSGroupDesc.close(); 	
			 
			if (SGroupCodeGet.length()>0)
            {        
             SGroupCodeGetLength = SGroupCodeGet.length()-1;  // 把最後的','去掉          
             SGroupCodeGet = SGroupCodeGet.substring(0,SGroupCodeGetLength);
            } 
			
		} // End of if (UserSalesResID!=null && !UserSalesResID.equals(""))
		UserSalesGroupID=SGroupCodeGet; // 把組合的Sales Group ID給參數,決定業務(業助)能下那些區客戶RFQ
		session.setAttribute("USERSALESGROUPID",UserSalesGroupID);
		
	} 		
	rs.close();
	//out.println("Step3=");
	
	//out.println("取得該員企劃生管之代號");
	sql = "select TSPLANDPT_NO,PLANNER_PERSONNO from ORADDMAN.TSSPLANER_PERSON where (USERID='"+UserName+"' or USERNAME='"+UserName+"') ";
	rs=st.executeQuery(sql);
	if(rs.next()) {
		UserPlanCenterNo= rs.getString("TSPLANDPT_NO");
		session.setAttribute("USERPLANCENTERNO",UserPlanCenterNo);			
	} 		
	rs.close();
	
	//out.println("取得該員生產製造中心");
	sql = "select PROD_FACNO,PROD_PERSONNO from ORADDMAN.TSPROD_PERSON where (USERID='"+UserName+"' or USERNAME='"+UserName+"') ";
	rs=st.executeQuery(sql);
	if(rs.next()) {
		UserProdCenterNo= rs.getString("PROD_FACNO");
		session.setAttribute("USERPRODCENTERNO",UserProdCenterNo);			
	} 		
	rs.close();
	
	// 取登入業務員所屬業務地區歸屬的客戶群組ID
	//out.println("取得登入業務員所屬業務地區歸屬的客戶群組ID、ORGANIZATION_ID及PAR_ORG_ID");
 
    sql = "select GROUP_ID,ORGANIZATION_ID,PAR_ORG_ID from ORADDMAN.TSSALES_AREA where SALES_AREA_NO = '"+UserActCenterNo+"' ";				   
    rs=st.executeQuery(sql);
    if(rs.next()) {
		           UserCustGroupID = rs.getString("GROUP_ID");
		           session.setAttribute("USERCUSTGROUPID",UserCustGroupID);
				   UserOrgID = rs.getString("ORGANIZATION_ID");
		           session.setAttribute("USERORGID",UserOrgID);	
				   UserParOrgID = rs.getString("PAR_ORG_ID");
		           session.setAttribute("USERPARORGID",UserParOrgID);		
	 } 		
	 rs.close();
			 
	//取得該員隸屬之COMPANY CODE			 
	//out.println("取得該員隸屬之多重業務地區代號");
	//out.println("select a.TSSALEAREANO,a.RECPERSONNO,a.SALESPERSONID, b.GROUP_ID from ORADDMAN.TSRECPERSON a, ORADDMAN.TSSALES_AREA b where a.TSSALEAREANO = b.SALES_AREA_NO and (a.USERID='"+UserName+"' or a.USERNAME='"+UserName+"')  ");
	rs=st.executeQuery("select a.TSSALEAREANO, a.RECPERSONNO,a.SALESPERSONID, b.GROUP_ID from ORADDMAN.TSRECPERSON a, ORADDMAN.TSSALES_AREA b where a.TSSALEAREANO = b.SALES_AREA_NO and (a.USERID='"+UserName+"' or a.USERNAME='"+UserName+"') ");	
		
	rsCountBean.setRs(rs); //取得其總筆數
	
	//out.print(rsCountBean.getRsCount());
	
	userCompCodeArray=new String[3][rsCountBean.getRsCount()+1];			 
	int ic=0;
	while(rs.next()) {			  
		              userCompCodeArray[0][ic]=rs.getString("TSSALEAREANO");	
		              userCompCodeArray[1][ic]=rs.getString("SALESPERSONID");
					  userCompCodeArray[2][ic]=rs.getString("GROUP_ID");			  		   
		              ic++;
					  UserRegionDesc = rs.getString("TSSALEAREANO");
	                  UserRegionSet = UserRegionSet +"'"+ UserRegionDesc+"'"+","; 
					  //itemCodeGet = itemCodeGet+"'"+ItemDesc+"'"+","; 
					  UserGroupDesc = rs.getString("GROUP_ID");
					  UserGroupSet = UserGroupSet + UserGroupDesc+","; 	
					  //out.println(UserRegionSet+"<BR>");				  
	                 } //end of while 
	session.setAttribute("USERCOMPCODEARRAY",userCompCodeArray);	
	rs.close();	
	
	//int UserRegionSetLength = 0;
	// 若要把最後的 , 去掉 則將 0 --> 1 
	/*
	if (UserRegionSet.length()>0)
    {        
             UserRegionSetLength = UserRegionSet.length()-1;            
             UserRegionSet = UserRegionSet.substring(0,UserRegionSetLength);
    }
	*/
	
	// 取登入QC品檢員所屬檢驗單位及使用者ID及使用者姓名
	//out.println("QC品檢員所屬檢驗單位ID、檢驗單位名稱、檢驗使用者ID及檢驗使用者姓名、ORG_ID、員工ID");

    sql = "select b.QCDEPT_ID, b.QCDEPT_DESC, a.QCUSER_ID, a.QCUSER_NAME, a.ORG_ID, a.EMPLOYEE_ID "+
	      "from ORADDMAN.TSCIQC_INSPECT_USER a, ORADDMAN.TSCIQC_INSPECT_DEPT b "+
	      "where a.QCDEPT_ID = b.QCDEPT_ID and a.QCUSER_NAME = '"+UserName+"' ";				   
    rs=st.executeQuery(sql);
    if(rs.next()) {
		           UserQCInspectDeptID = rs.getString("QCDEPT_ID");
		           session.setAttribute("QCDEPT_ID",UserQCInspectDeptID);
				   UserQCInspectDeptName = rs.getString("QCDEPT_DESC");
		           session.setAttribute("QCDEPT_DESC",UserQCInspectDeptName);	
				   UserQCInspectID = rs.getString("QCUSER_ID");
		           session.setAttribute("QCUSER_ID",UserQCInspectID);	
				   UserQCInspectName = rs.getString("QCUSER_NAME");
		           session.setAttribute("QCUSER_NAME",UserQCInspectName);
				   UserQCOrgID = rs.getString("ORG_ID");
		           session.setAttribute("QCORG_ID",UserQCOrgID);
				   UserQCEmpID = rs.getString("EMPLOYEE_ID");
		           session.setAttribute("QCEMP_ID",UserQCEmpID);
	} 		
	rs.close();
	
	// 取登入MFG單位及使用者ID及使用者姓名,部門代碼,部門名稱(取預設值=Y)
	//out.println("取登入MFG單位及使用者ID及使用者姓名,部門代碼,部門名稱");
	//out.print("UserName"+UserName);
    sql = " select a.MFG_DEPT_NO, a.MFG_DEPT_NAME, a.USER_ID, a.USER_NAME, b.DEM_LOCATION_ID, b.EXP_LOCATION_ID "+
	      " from APPS.YEW_MFG_USER a, APPS.YEW_MFG_DEFDATA b "+
		  " where a.MFG_DEPT_NO = b.CODE and b.DEF_TYPE = 'MFG_DEPT_NO' "+
		  "   and upper(a.USER_NAME) = upper('"+UserName+"') and a.PRIMARY_FLAG = 'Y' ";	
	//out.print(sql);			   
    rs=st.executeQuery(sql);
    if(rs.next()) {
		           userMfgDeptNo = rs.getString("MFG_DEPT_NO");
		           session.setAttribute("MFG_DEPT_NO",userMfgDeptNo);
				   userMfgDeptName = rs.getString("MFG_DEPT_NAME");
		           session.setAttribute("MFG_DEPT_NAME",userMfgDeptName);	
				   userMfgUserID = rs.getString("USER_ID");
		           session.setAttribute("USER_ID",userMfgUserID);	
				   userMfgUserName = rs.getString("USER_NAME");
		           session.setAttribute("USER_NAME",userMfgUserName);
				   userMfgDemLoc = rs.getString("DEM_LOCATION_ID");
		           session.setAttribute("DEM_LOCATION_ID",userMfgDemLoc);
				   userMfgExpLoc = rs.getString("EXP_LOCATION_ID");
		           session.setAttribute("EXP_LOCATION_ID",userMfgExpLoc);
	} 		
	rs.close();	
	
	// 取登入人員同時多組MFG單位及使用者ID及使用者姓名,部門代碼,部門名稱
	//out.println("取登入人員同時多組MFG單位及使用者ID及使用者姓名,部門代碼,部門名稱");
	
	sql = " select a.MFG_DEPT_NO, a.MFG_DEPT_NAME, a.USER_ID, a.USER_NAME, b.DEM_LOCATION_ID, b.EXP_LOCATION_ID "+
	      " from APPS.YEW_MFG_USER a, APPS.YEW_MFG_DEFDATA b "+
		  " where a.MFG_DEPT_NO = b.CODE and b.DEF_TYPE = 'MFG_DEPT_NO' "+
		  "   and upper(a.USER_NAME) = upper('"+UserName+"') ";	
	//out.print(sql);		
	rs=st.executeQuery(sql);	   
	rsCountBean.setRs(rs); //取得其總筆數
	
	userMfgDeptArray=new String[4][rsCountBean.getRsCount()+1];			 
	int it=0;    
    while(rs.next()) {
	                   if (rs.getString("MFG_DEPT_NO")!=null)
					   {
		                userMfgDeptArray[0][it]=rs.getString("MFG_DEPT_NO");	
		                userMfgDeptArray[1][it]=rs.getString("MFG_DEPT_NAME");
						userMfgDeptArray[2][it]=rs.getString("USER_ID");	
		                userMfgDeptArray[3][it]=rs.getString("USER_NAME");	
					   }								  		   
		                it++;
					    UserMfgDeptDesc = rs.getString("MFG_DEPT_NO");
	                    UserMfgDeptSet = UserMfgDeptSet + UserMfgDeptDesc+","; 				   
	                 } 
	session.setAttribute("USERMFGDEPTARRAY",userMfgDeptArray);				 		
	rs.close();	
	
	// 取登入物管特採申請核可人員驗單位及使用者ID及使用者姓名
	//out.println("物管特採核定人員所屬部門代號及ORG_ID");
    sql = "select a.TSC_DEPT_ID, a.ORG_ID, a.MC_EMPID "+
	      "from ORADDMAN.TSC_MC_USER a "+
	      "where upper(a.MC_USERID) = upper('"+UserName+"') ";				   
    rs=st.executeQuery(sql);
    if(rs.next()) {
		           UserMCDeptID = rs.getString("TSC_DEPT_ID");
		           session.setAttribute("MCTSC_DEPT_ID",UserMCDeptID);
				   UserMCOrgID = rs.getString("ORG_ID");
		           session.setAttribute("MCORG_ID",UserMCOrgID);
				   UserMCEmpID = rs.getString("MC_EMPID");
		           session.setAttribute("MCEMP_ID",UserMCEmpID);					  	
	} 		
	rs.close();
	
	// 取登入物管特採申請核可人員驗單位及使用者ID及使用者姓名
	//out.println("倉庫(入庫,批退)人員所屬部門代號及ORG_ID");
    sql = "select a.TSC_DEPT_ID, a.ORG_ID, a.EMPLOYEE_ID "+
	      "from ORADDMAN.TSC_WAREHOUSE_USER a "+
	      "where upper(a.USER_NAME) = upper('"+UserName+"') ";				   
    rs=st.executeQuery(sql);
    if(rs.next()) {
		           UserWSDeptID = rs.getString("TSC_DEPT_ID");
		           session.setAttribute("WSTSC_DEPT_ID",UserWSDeptID);
				   UserWSOrgID = rs.getString("ORG_ID");
		           session.setAttribute("WSORG_ID",UserWSOrgID);
				   UserWSEmpID = rs.getString("EMPLOYEE_ID");
		           session.setAttribute("WSEMP_ID",UserWSEmpID);					  	
	} 		
	rs.close();
	
	// 業務員業務地區群組代號_
	if (UserRegionSet.length()>0)
    {        
             UserRegionSetLength = UserRegionSet.length()-1;  // 把最後的','去掉          
             UserRegionSet = UserRegionSet.substring(0,UserRegionSetLength);
    }  	
	//out.println("UserRegionSet="+UserRegionSet);
	session.setAttribute("USERREGIONSET",UserRegionSet);	
	
	// 業務員業務地區群組ID_
	if (UserGroupSet.length()>0)
    {        
             UserGroupSetLength = UserGroupSet.length()-1;  // 把最後的','去掉          
             UserGroupSet = UserGroupSet.substring(0,UserGroupSetLength);
    }  	
	//out.println("UserGroupSet="+UserGroupSet);
	session.setAttribute("USERGROUPSET",UserGroupSet);	
	
	
	// 製造部人員隸屬群組_起
	if (UserMfgDeptSet.length()>0)
    {        
             UserMfgDeptSetLength = UserMfgDeptSet.length()-1;  // 把最後的','去掉          
             UserMfgDeptSet = UserMfgDeptSet.substring(0,UserMfgDeptSetLength);
    }  	
	session.setAttribute("USERMFGDEPTSET",UserMfgDeptSet);
	
	// 資訊服務需求單_使用者登入部門別ID_起
	sql = "select DEPT_ID, EMPLOY_ID  "+
	      "from ORADDMAN.TSISRUSER_HIERARCHY a "+
	      "where upper(a.USER_NAME) = upper('"+UserName+"') ";				   
    rs=st.executeQuery(sql);
    if(rs.next()) {
	                UserISRDeptID = rs.getString("DEPT_ID");
					session.setAttribute("USERISRDEPTID",UserISRDeptID);
	                UserISREmolyID = rs.getString("EMPLOY_ID");					
	                session.setAttribute("USERISREMPLOYID",UserISREmolyID);
	}		
	rs.close();	
	
	// 資訊服務需求單_IT負責人ID_起
	sql = "select PROCESSOR_ID  "+
	      "from ORADDMAN.TSISRMIS_PROCESSER a "+
	      "where upper(a.STAFF_NAME) = upper('"+UserName+"') ";				   
    rs=st.executeQuery(sql);
    if(rs.next()) {
	                UserISRMISID = rs.getString("PROCESSOR_ID");
					session.setAttribute("USERISRMISID",UserISRMISID);
	                
	}		
	rs.close();	
	
	st.close();
	// 資訊服務需求單_使用者登入部門別ID_迄
	

%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%	

// 設定 JSP 登入 IDLE Time Out 的時間(秒*分*時)
	session.setMaxInactiveInterval(60*60*3);		   
	//out.println("<br>"+"address="+OIaddress+"QueryString="+QueryString);
	if(OIaddress!=null) 
	{		   
		session.setAttribute("address",null); //轉址前先將前內容清除以免陷入無窮迴圈
		session.setAttribute("QueryString",null);//轉址前先將前內容清除以免陷入無窮迴圈
		if (QueryString==null) {
			response.sendRedirect(OIaddress);
			return;
		} else {
			response.sendRedirect(OIaddress + '?' + QueryString);
			return;
		} // end if-else
	} 
	else 
	{
      	     // response.sendRedirect("../ORADDSMainMenu.jsp?LANGCH="+langCh); // 2007/08/29 針對YEW 切開Web 主機
		     // return;   // // 2007/08/29 針對YEW 切開Web 主機
			//out.println("remoteAddrLength="+remoteAddrLength+"<BR>");
			//out.println("siteLogin="+siteLogin+"<BR>");
			
			// 2007/09/17 另外判斷使用者是否為山東陽信_起
			 Statement stmtERP=con.createStatement(); 
			 String sqlERP = " select a.USER_NAME "+
	                      " from FND_USER a, ORADDMAN.WSUSER b "+
		                  " where upper(a.USER_NAME) = upper(b.USERNAME) "+
		                  "   and upper(a.USER_NAME) = upper('"+UserName+"') and a.DESCRIPTION like '%陽信%' ";	
	         //out.print(sql);		
	         ResultSet rsERP=stmtERP.executeQuery(sqlERP);	   
	         if (rsERP.next())
			 {
			   YEWUserFlag = true;
			 } else { YEWUserFlag = false; }
			 rsERP.close();
			 stmtERP.close();
			// 2007/09/17 另外判斷使用者是否為山東陽信_迄
			
			if (remoteAddrLength>9) // 
            {
              siteLogin = request.getRemoteAddr().substring(0,10); // 若為YEW, 則一律以特定  
			  String reqURL = request.getRequestURL().toString();
             
			  //加入192.168.6這個網段,add by Peggy 20130520
	          if ((siteLogin.indexOf("192.168.5.")>=0 && !siteLogin.equals("192.168.6.235")) || siteLogin.indexOf("192.168.6.")>=0)  //AMANDA除外,add by Peggy 20111227
	          {
			    if (reqURL.indexOf("http://tsrfq.ts.com.tw:8080/oradds")>=0 || reqURL.indexOf("http://210.80.75.209:8080/oradds/jsp")>=0 || reqURL.indexOf("http://tsrfq.ts.com.tw:8080/oradds/jsp")>=0)
				{
	              %>
	               <script language="javascript">
	                 alert("                 您屬於山東陽信使用者\n 點擊確定後系統會自動將您轉至專屬服務主機!!!");		  
		             setTimeout('YEWURL()',500);
		           </script>
	              <%
				} 
				else 
				{
				         // out.println(siteLogin+"<BR>");
						 // out.println(reqURL+"<BR>");
					if (UserName.toUpperCase().equals("CLAIRECHEN") || UserName.toUpperCase().equals("ARIEL"))
					{
						response.sendRedirect("../JSP/TSShippingInvoiceNumberQuery.jsp");
						return;					
					}
					else if (UserName.toUpperCase().equals("RIKA_LIN") || UserName.toUpperCase().equals("JOGINDER.SACHDEVA") || UserName.toUpperCase().equals("MARK.SHIN") || UserName.toUpperCase().equals("JODIE") || UserName.toUpperCase().equals("SEIRO") ||  UserName.toUpperCase().equals("DAVID.LATOURETTE") || UserName.toUpperCase().equals("AMY") || UserName.toUpperCase().equals("RALF_WELTER"))
					{
						response.sendRedirect("../JSP/TSSalesOrderReviseSalesApprove.jsp");
						return;						
					}          
					else
					{
						response.sendRedirect("../ORADDSMainMenu.jsp?LANGCH="+langCh);
						return;
					}
				}
	         //response.sendRedirect("http://intranet.ts.com.tw:8080/ORADDS/");
		     //return;
	          } 
			  else if (YEWUserFlag == true && !UserName.toUpperCase().equals("KELLER") && (reqURL.indexOf("http://tsrfq.ts.com.tw:8080/oradds")>=0 || reqURL.indexOf("http://210.80.75.209")>=0))
			  {
				   %>
	               <script language="javascript">
	                 alert("                 您屬於山東陽信使用者\n 點擊確定後系統會自動將您轉至專屬服務主機!!!");		  
		             setTimeout('YEWURL()',500);
		           </script>
	              <%
			  }			  
			  else 
			  { 
				if (UserName.toUpperCase().equals("CLAIRECHEN") || UserName.toUpperCase().equals("ARIEL"))
				{
					response.sendRedirect("../JSP/TSShippingInvoiceNumberQuery.jsp");
					return;					
				}
				else if (UserName.toUpperCase().equals("RIKA_LIN") || UserName.toUpperCase().equals("JOGINDER.SACHDEVA") || UserName.toUpperCase().equals("MARK.SHIN") || UserName.toUpperCase().equals("JODIE") || UserName.toUpperCase().equals("SEIRO") ||  UserName.toUpperCase().equals("DAVID.LATOURETTE") || UserName.toUpperCase().equals("AMY") || UserName.toUpperCase().equals("RALF_WELTER"))
				{
					response.sendRedirect("../JSP/TSSalesOrderReviseSalesApprove.jsp");
					return;						
				} 				
				else
				{				  
					// 若不是山東使用者且不是登入 Intranet 主機(表示使用測試區),則仍可使用 rfq
					response.sendRedirect("../ORADDSMainMenu.jsp?LANGCH="+langCh);
					return;
				}
			  }
			} 
			else 
			{
				if (UserName.toUpperCase().equals("CLAIRECHEN") || UserName.toUpperCase().equals("ARIEL"))
				{
					response.sendRedirect("../JSP/TSShippingInvoiceNumberQuery.jsp");
					return;					
				}
				else if (UserName.toUpperCase().equals("RIKA_LIN") || UserName.toUpperCase().equals("JOGINDER.SACHDEVA") || UserName.toUpperCase().equals("MARK.SHIN") || UserName.toUpperCase().equals("JODIE") || UserName.toUpperCase().equals("SEIRO") ||  UserName.toUpperCase().equals("DAVID.LATOURETTE") || UserName.toUpperCase().equals("AMY") || UserName.toUpperCase().equals("RALF_WELTER"))
				{
					response.sendRedirect("../JSP/TSSalesOrderReviseSalesApprove.jsp");
					return;						
				} 				
				else
				{			
	            	siteLogin = request.getRemoteAddr();
		            //out.println("siteLogin="+siteLogin);
					response.sendRedirect("../ORADDSMainMenu.jsp?LANGCH="+langCh);
		            return;
				}
            }
		} // end if-else
} catch (Exception ee) {
	ee.printStackTrace();
	out.println("Exception:"+ee.getMessage());
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
} // end try-catch
%>
</body>
</html>
