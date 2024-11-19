<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.sql.*"  %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Single sign-On Test</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
</head>
<%
String userName=request.getParameter("USERNAME");
String userId = ""; 
String encryptPassword = ""; 
String decryptPassword = ""; 
String sql = ""; 
  
if (userName == null || userName.equals("")) userName = UserName;
//由Oracle ERP 中的 fnd_user 取得該使用者加密後的密碼
Statement stmt=con.createStatement(); 
sql ="select * from fnd_user where ( user_name = '%"+userName+"%' or lower(user_name)='"+userName+"' or upper(user_name)='"+userName+"') "; 
//sql ="select * from dba_users where ( username = 'APPS' or lower(username)='apps') "; 
out.println("sql="+sql);
ResultSet rs = stmt.executeQuery(sql);   
while (rs.next()) 
{ 
	userId = rs.getString("USER_NAME"); 
    encryptPassword = rs.getString("ENCRYPTED_USER_PASSWORD"); 
} 
rs.close();
stmt.close();

//透過Oracle ERP 的API 將加密後的密碼轉成未加密的密碼 
oracle.apps.fnd.security.AolSecurity aolsec=new oracle.apps.fnd.security.AolSecurity(); 
decryptPassword = aolsec.decrypt("TSCAPPS12",encryptPassword); 
out.println("userId="+userId);
out.println("decryptPassword="+decryptPassword);
  
  
String erpURL = "";  
try 
{
	//String sSqlERP = "select PROFILE_OPTION_VALUE from APPLSYS.FND_PROFILE_OPTION_VALUES where PROFILE_OPTION_VALUE like 'http:%/dev60cgi/f60cgi' ";
	// 以下改抓Single Sign-On 的SQL取Profile option value的網址
	//String sSqlERP = "select PROFILE_OPTION_VALUE from APPLSYS.FND_PROFILE_OPTION_VALUES where PROFILE_OPTION_VALUE like 'http:%/pls/%' and APPLICATION_ID = 0 ";
	String sSqlERP = "select PROFILE_OPTION_VALUE from APPLSYS.FND_PROFILE_OPTION_VALUES where PROFILE_OPTION_VALUE like 'http:%OA_HTML/' and rownum=1";
	Statement stERP=con.createStatement();
	ResultSet rsERP=stERP.executeQuery(sSqlERP);
	if (rsERP.next())
	{
		erpURL = rsERP.getString("PROFILE_OPTION_VALUE");		  
	} 
	rsERP.close();
	stERP.close();
	erpURL+="fndvald.jsp?password="+java.net.URLEncoder.encode(decryptPassword)+"&username="+java.net.URLEncoder.encode(userId);
	//out.println("erpURL="+erpURL);
} 
catch (Exception ee) 
{ 
	out.println("Exception:"+ee.getMessage()); 
}

%>
<body>
<Form name="MYFORM" action=<%=erpURL%> method="post" target="_blank">
  <INPUT TYPE="hidden" NAME="i_1" VALUE="<%=userId%>"> 
  <INPUT TYPE="hidden" NAME="i_2" VALUE="<%=decryptPassword%>"> 
  <INPUT TYPE="hidden" NAME="rmode" VALUE="2"> 
  <INPUT TYPE="hidden" NAME="home_url" VALUE=""> 
</Form>
 <SCRIPT LANGUAGE="javascript"> 
    document.MYFORM.submit(); 
 </SCRIPT> 
<!--=============以下區段為釋放連結池==========--> 
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
