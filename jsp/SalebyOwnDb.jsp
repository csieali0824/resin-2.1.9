<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>SalebyOwnDb.jsp</title>
</head>

<body>
<%
  String WEBID=request.getParameter("WEBID");
  String SEARCHSTRING=request.getParameter("SEARCHSTRING");
try
  {
    String sql="insert into WSSALESSEARCH(WEBID,SEARCHSTRING) values(?,?)";
	PreparedStatement pstmt=con.prepareStatement(sql);
    pstmt.setString(1,WEBID);
	pstmt.setString(2,SEARCHSTRING);
    pstmt.executeUpdate(); 
	pstmt.close();
  
  
  
  
  
  }
    catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }

%>

 <br>WEBID:<%= WEBID %> 加入記錄完成!<br>
 <a href="../WinsMainMenu.jsp">回首頁</a>

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
