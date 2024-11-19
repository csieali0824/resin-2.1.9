<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>UnShippingUpdate.jsp</title>
</head>

<body> 
<%
  String IMEI=request.getParameter("IMEI");
  int aLength = 0;
  
  //out.println("<b>修改"+IMEI+":</b><br>");
try
    {
	 aLength = IMEI.length();
	 if (aLength==15)
	 {
	  Statement statement=con.createStatement();
	  //String sql="DELETE FROM WSSHIP_IMEI_T WHERE IMEI='"+IMEI+"'";
      String sql="UPDATE WSSHIP_IMEI_T SET SHP_NOTES='C' WHERE IMEI='"+IMEI+"'";
	  statement.executeUpdate(sql);
	  statement.close();
	 }
	 else if (aLength==21)
	 {
	  Statement statement=con.createStatement();
	  //String sql="DELETE FROM WSSHIP_IMEI_T WHERE MES_CARTON_NO='"+IMEI+"'";
      String sql="UPDATE WSSHIP_IMEI_T SET SHP_NOTES='C' WHERE MES_CARTON_NO='"+IMEI+"'";
	  statement.executeUpdate(sql);
	  statement.close();	
	 }//end of else
   }//try of end
   catch (Exception e)
   {
    out.println("Exception:"+e.getMessage());
   }
%>
<%= IMEI %> 修改完成!<br><br>
<a href="/wins/jsp/UnShippingInput.jsp">回修改頁</a><br><br>
<a href="/wins/WinsMainMenu.jsp">HOME</a>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
