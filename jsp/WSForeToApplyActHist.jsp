<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>The action History about Sales forecast</title>
</head>
<body>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A> 
<% 
  String docNo=request.getParameter("DOCNO");
  try
  {   
   Statement statement=con.createStatement();   
   ResultSet rs=statement.executeQuery("select USERNAME,ACTION,ACT_DATE||'-'||ACT_TIME,H_COMMENT from PSALES_FORE_APP_HIST,WSUSER where DOCNO='"+docNo+"' and WHO=WEBID order by ACT_DATE,ACT_TIME");
   ResultSetMetaData md=rs.getMetaData();
   int colCount=md.getColumnCount();  
   out.println("<TABLE>");
   out.println("<TR BGCOLOR=DARKCYAN><TH><FONT SIZE=2 COLOR=WHITE>WHO</TH><TH><FONT SIZE=2 COLOR=WHITE>ACTION</TH><TH><FONT SIZE=2 COLOR=WHITE>ACTION TIME</TH><TH><FONT SIZE=2 COLOR=WHITE>COMMENT</TH></TR>");
   while (rs.next())
   {
     out.println("<TR BGCOLOR=CYAN>");
      for (int i=1;i<=colCount;i++)
      {
        String s=(String)rs.getString(i);
        out.println("<TD><FONT SIZE=2>"+s+"</TD>");
       } //end of for
       out.println("</TR>");   
   }
   out.println("</TABLE>");
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
