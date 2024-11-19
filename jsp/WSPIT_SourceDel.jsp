<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<html>
<head>
<title>Delete the selected PIT source</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<%
String [] choice=request.getParameterValues("CH");
String choiceString=null;

try
{  
  for (int k=0;k<choice.length ;k++)
  {
   if (choiceString==null) 
   {
     choiceString="'"+choice[k]+"'";	 
   } else {	 
    choiceString=choiceString+",'"+choice[k]+"'";    
   }
  } //end of for
 
  String sql="delete from PIT_SOURCE where SOURCEID in ("+choiceString+")";   
  PreparedStatement pstmt=con.prepareStatement(sql);    
  
  pstmt.executeUpdate();           
  
  for (int k=0;k<choice.length ;k++)
  {
    out.println("來源:("+choice[k]+") 已刪除!<BR>");
  }	
  pstmt.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
<BR>
<a href="../WinsMainMenu.jsp">回首頁</a>&nbsp;  &nbsp;<A HREF="WSPIT_SourceQueryAll.jsp">測試來源 清單</A><br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
