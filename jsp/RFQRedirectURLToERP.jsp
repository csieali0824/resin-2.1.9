<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
</head>
<body>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">
<%
String langCh=request.getParameter("LANGCH");
String userId = ""; 
String encryptPassword = ""; 
String decryptPassword = ""; 
String userName = ""; 
String sqlSSO = ""; 
if (langCh==null) langCh = "zh-tw";
//由Oracle ERP 中的 fnd_user 取得該使用者加密後的密碼
Statement stmtSSO=con.createStatement(); 
sqlSSO ="select * from fnd_user where ( user_name = '%"+UserName+"%' or lower(user_name)='"+UserName+"' or upper(user_name)='"+UserName+"') "; 
ResultSet rsSSO = stmtSSO.executeQuery(sqlSSO);   
while (rsSSO.next()) 
{ 
	userId = rsSSO.getString("USER_NAME"); 
    encryptPassword = rsSSO.getString("ENCRYPTED_USER_PASSWORD"); 
} 
rsSSO.close();
stmtSSO.close();

//透過Oracle ERP 的API 將加密後的密碼轉成未加密的密碼 
oracle.apps.fnd.security.AolSecurity aolsec=new oracle.apps.fnd.security.AolSecurity(); 
decryptPassword = aolsec.decrypt("TSCAPPS12",encryptPassword); 
String erpURL = "";
try 
{
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
} 
catch (Exception ee) 
{ 
	out.println("Exception:"+ee.getMessage());  
}
response.sendRedirect(erpURL);
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>
