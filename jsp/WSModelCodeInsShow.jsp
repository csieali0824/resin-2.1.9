<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title></title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayCheckBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<p><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong> 產品編碼系統-</strong></font></p>
<p><font color="#000000" size="+2" face="Times New Roman"></font> 
  <%  
out.println("<font color='#990000' face='Arial'>"+session.getAttribute("DISPLAY")+"</font>");
out.println("<font color='#FF0000' face='Arial Black'>"+session.getAttribute("MODELNO")+"</font>");
if (session.getAttribute("DISPLAYAPPNO")!=null)
{
  out.println("<font color='#990000' face='Arial'>"+session.getAttribute("DISPLAYAPPNO")+"</font>");
  out.println("<font color='#000099' face='Arial Black'>"+session.getAttribute("APPNO")+"</font>");
}
%>
  <br>
</p>
<table width="591" border="1">
  <tr> 
    <td> <A HREF="WSModelEncodeApp.jsp">回產品編碼新增</A> </td>
    <td> <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> </td>
    <td> <A HREF="WSMRModelEncodeHistory.jsp">編碼資料明細及歷程查詢</A> </td>
    <td> <A HREF="WSMRModelEncodingInquiry.jsp">產品編碼查詢</A> </td>    
  </tr>
</table>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
