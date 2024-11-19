<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,CodeUtil" %>
<html>
<head>
<title>LCorderUpdate.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
</head>

<body>
<%
String LCNO=request.getParameter("LCNO");
String LCAMT=request.getParameter("LCAMT");
String LCCUR=request.getParameter("LCCUR");
String LCUSAGE=request.getParameter("LCUSAGE");
String LCEFF=request.getParameter("LCEFF");
String LCDIS=request.getParameter("LCDIS");

String LCUPDT=request.getParameter("LCUPDT");
String LCUPTM=request.getParameter("LCUPTM");

try
{ 
 
	Statement statement=ifxshoescon.createStatement();  
	String sql_update="UPDATE HLCM SET LCAMT='"+LCAMT+"',LCCUR='"+LCCUR+"',LCEFF='"+LCEFF+"',LCDIS='"+LCDIS+"' ,LCUPDT='"+LCUPDT+"' ,LCUPTM='"+LCUPTM+"' WHERE LCNO='"+LCNO+"'";
	statement.executeUpdate(sql_update);
	statement.close();


  
  	out.println("Update: "+LCNO+"L/C OK!<BR>");
  out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");

} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>
