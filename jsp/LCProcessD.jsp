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
<title>MRQProcess.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
</head>

<body>
<%
String [] choice=request.getParameterValues("CH");
String choiceString=null;
String formID=request.getParameter("FORMID");
//String svrTypeNo=request.getParameter("SVRTYPENO");
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionIDD=request.getParameter("ACTIONIDD");
//String repPersonID=request.getParameter("REPPERSONID");
//String remark=request.getParameter("REMARK");
String repNo="";
//String oriIMEI=request.getParameter("IMEI");
String oriStatus=null;
String actionName=null;
String LCSTAT=request.getParameter("LCSTAT");
String EDITION=request.getParameter("EDITION");
String LCRCTM=request.getParameter("LCRCTM");
String TIME=request.getParameter("TIME");
String searchString=request.getParameter("SEARCHSTRING");
//String changeRepCenterNo=request.getParameter("CHANGEREPCENTERNO");
//String changeRepPersonID=request.getParameter("CHANGEREPPERSONID");
/*out.print("LCSTAT:"+LCSTAT+"<br>");
out.print("EDITION:"+EDITION+"<br>");
out.print("TIME:"+TIME+"<br>");
out.print("SEARCHSTRING:"+searchString+"<br>");
out.print("userID:"+userID+"<br>");*/
out.print("actionIDD:"+actionIDD+"<br>");



//String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL

try
{ 
    if(actionIDD.equals("D")){
	Statement statement=ifxshoescon.createStatement();  
	String sql_update="UPDATE HLCM SET LCSTAT='"+actionIDD+"',LCRDTE='"+EDITION+"',LCRCTM='"+TIME+"',LCCFM='"+userID+"',LCID='HZ' WHERE LCNO='"+searchString+"'";
	statement.executeUpdate(sql_update);
	statement.close();
	
	} 
  
  out.println("DELETE: "+searchString+"L/C OK!<BR>");
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
