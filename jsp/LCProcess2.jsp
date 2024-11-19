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
String actionID=request.getParameter("ACTIONID");
//String repPersonID=request.getParameter("REPPERSONID");
//String remark=request.getParameter("REMARK");
String repNo="";
//String oriIMEI=request.getParameter("IMEI");
String oriStatus=null;
String actionName=null;
String LCSTAT=request.getParameter("LCSTAT");
String LCRDTE=request.getParameter("LCRDTE");
String LCRCTM=request.getParameter("LCRCTM");
//String changeRepCenterNo=request.getParameter("CHANGEREPCENTERNO");
//String changeRepPersonID=request.getParameter("CHANGEREPPERSONID");
out.print("LCSTAT:"+LCSTAT+"<br>");
out.print("LCRDTE:"+LCRDTE+"<br>");
out.print("LCRCTM:"+LCRCTM+"<br>");
out.print("actionID:"+actionID+"<br>");
//out.print("repPersonID:"+repPersonID+"<br>");
//out.print("remark:"+remark+"<br>");



//String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL

try
{ 
  //Statement getStatusStat=ifxshoescon.createStatement();  
  //ResultSet getStatusRs=getStatusStat.executeQuery("select TOSTATUSID,STATUSNAME from RPWORKFLOW x1,RPWFSTATUS x2 WHERE FORMID='"+formID+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID");  
  //getStatusRs.next();  
   
  for (int k=0;k<choice.length ;k++)    
  {     
    String sql="update HLCM set LCSTAT=?,LCRDTE=?,LCRCTM=? where LCNO='"+choice[k]+"'";
    PreparedStatement pstmt=ifxshoescon.prepareStatement(sql);  
 
    pstmt.setString(1,LCSTAT); //寫入LCSTAT
    pstmt.setString(2,LCRDTE); //寫入LCRDTE
	pstmt.setString(3,LCRCTM);
  
    pstmt.executeUpdate();
    pstmt.close();   
	} 
   
  out.println("Processing RpMr OK!<BR>");
  out.println("<A HREF='/repair/RepairMainMenu.jsp'>回首頁</A>");
  out.println("<A HREF=../jsp/MRQAll.jsp>查詢所有領料案件</A> ");

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
